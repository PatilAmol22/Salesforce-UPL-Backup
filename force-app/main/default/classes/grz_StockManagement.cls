/**************************************************************************************************
* Name               : grz_StockManagement                                                      
* Description        : Controller class for grz_LiquidityAndStockManagement LWC Component
* Test Class         : grz_StockManagementTest
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
public with sharing class grz_StockManagement{
    public List<ResultWrapper> items{ get; set; }

/**************************************************************************************************
* Name               : getStockData                                                      
* Description        : Method will return Inventory data for Distributor
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
    @AuraEnabled(cacheable = true)
    public static stockManagementWrapper getStockData(Decimal pageNumber, Decimal pageSize, String product, String lote, String dueDate, String endDate, String type, String distributor, string clientCityAndName, String subGroupId){
        Integer pSize;
        DateTime todaysDate = System.today();
        Date myDate = todaysDate.dateGMT();
        //String todaysDateStr = todaysDate.format('yyyy-MM-dd');
        String todaysDateStr = String.valueOf(myDate);
        if (pageSize != null && pageSize != 0.0){
            pSize = (Integer) pageSize;
        } else{
            pSize = 10;
        }
        Integer pNumber = (Integer) pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        stockManagementWrapper objDT = new stockManagementWrapper();
        Id id;
        if (Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'Brazil Partner Community Distributor Profile'];
            List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId = :pro[0].Id AND lastname = 'Testing' and Email = 'test@grazitti.com' LIMIT 1];
            id = user[0].Id;
        } else{
            id = UserInfo.getUserId();
        }
        List<User> user = [SELECT Id, Username,Inventory_Expiry_Notification__c, AccountId, ContactId, profile.name, Account.Tax_Number_Br_Portal_Filter__c, Account.Customer_Group__c, Account.SAP_Customer_Code__c, Account.Name, Account.BillingCity
                           FROM User
                           where Id = :id];
        String accountId = user[0].AccountId;
        // Added for email notification functionality GRZ(Nikhil Verma) : APPS-1394
        if(accountId != null && accountId != ''){
            objDT.isExternalUser = true;
        }
        objDT.inventryNotification = user[0].Inventory_Expiry_Notification__c;
        
        String groupCstr = user[0].Account.Customer_Group__c;
        //Added below two lines for Main Parent filter. GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
        Boolean isMainParent = false;
        Set<String> subGroupData = new Set<String>();
        List<String> taxMap = new List<String>();
        List<String> taxNumber = new List<String>();
        Set<String> nameAndCity = new Set<String>();
        if (!user.isEmpty()){
            taxNumber.add(user[0].Account.Tax_Number_Br_Portal_Filter__c);
            taxMap.add(user[0].Account.Tax_Number_Br_Portal_Filter__c + ' - ' + user[0].Account.SAP_Customer_Code__c + ' - ' + user[0].Account.Name + ' - ' + user[0].Account.BillingCity);
        }
        if (!String.isEmpty(groupCstr)){
            for (Account ac : [SELECT Id, Name, BillingCity, SAP_Customer_Code__c, Tax_Number_Br_Portal_Filter__c
                               FROM Account where Customer_Group__c = :groupCstr AND (ParentId = :accountId OR Sub_Parent_Account__c = :accountId) ORDER BY Name, BillingCity ASC]){// Added Order by in Query, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
                taxNumber.add(ac.Tax_Number_Br_Portal_Filter__c);
                taxMap.add(ac.Tax_Number_Br_Portal_Filter__c + ' - ' + ac.SAP_Customer_Code__c + ' - ' + ac.Name + ' - ' + ac.BillingCity);
            }
            //Query added to get Sub Group distributor data, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
            for(Account ac : [SELECT Id,Sub_Parent_Account__c,Sub_Parent_Account__r.Tax_Number_Br_Portal_Filter__c,Sub_Parent_Account__r.Name,Sub_Parent_Account__r.BillingCity,Sub_Parent_Account__r.SAP_Customer_Code__c FROM Account WHERE Customer_Group__c =:groupCstr AND ParentId =:accountId AND Sub_Parent_Account__c != null ORDER BY Sub_Parent_Account__r.Name ASC]){
                isMainParent = true;  
                subGroupData.add(ac.Sub_Parent_Account__r.Tax_Number_Br_Portal_Filter__c + ' - ' + ac.Sub_Parent_Account__r.SAP_Customer_Code__c + ' - ' + ac.Sub_Parent_Account__r.Name + ' - ' + ac.Sub_Parent_Account__r.BillingCity);
            }
        }
        String countQuery = 'Select Count() from Stock_Management__c';
        string query = 'SELECT Id,Report_Date__c,Storage__c,UPL_Sale_Note__c,Name_And_City__c, CNPJ_Client__c,Product_Name__c,Batch__c,Batch_Expiry_Date__c,Current_Balance_Qty__c,Current_Balance_Value__c,AG_Remaining_Days__c  FROM Stock_Management__c';
        String filter = '';
        String clientNameQuery;
        if (!string.IsBlank(product)){
            filter += filter.contains('where') ? ' and' : ' where';
            filter += ' Product_Name__c like \'%' + product + '%\'';
        }
        if (!String.isEmpty(distributor)){
            if (distributor != 'All'){
                filter += filter.contains('where') ? ' and' : ' where';
                filter += ' CNPJ_Client__c =: distributor ';
            } else{
                if(subGroupId != null && subGroupId != ''){
                    Set<String> subGroupSapId = new Set<String>();
                    for(Account acc : [SELECT Tax_Number_Br_Portal_Filter__c FROM Account WHERE Sub_Parent_Account__r.Tax_Number_Br_Portal_Filter__c =:subGroupId AND RecordType.developerName = 'Distributor' AND Sales_Org_Code__c = '5191']){
                        subGroupSapId.add(acc.Tax_Number_Br_Portal_Filter__c);
                    }
                    subGroupSapId.add(subGroupId);
                    filter += filter.contains('where') ? ' and' : ' where';
                    filter += ' CNPJ_Client__c IN :subGroupSapId ';
                }else{
                    if (!taxNumber.isEmpty()){
                        filter += filter.contains('where') ? ' and' : ' where';
                        filter += ' CNPJ_Client__c IN :taxNumber ';
                    }
                }
            }
        }
        if (!string.IsBlank(lote)){
            filter += filter.contains('where') ? ' and' : ' where';
            filter += ' Batch__c like \'%' + lote + '%\'';
        }
        if (!filter.contains('where')){
            filter += ' where Batch_Expiry_Date__c >=' + dueDate + ' and Batch_Expiry_Date__c<=' + endDate;
        } else{
            filter += ' and Batch_Expiry_Date__c >=' + dueDate + ' and Batch_Expiry_Date__c<=' + endDate;
        }
        if (!string.IsBlank(type) ){
            if (type != 'All'){
                if (type == 'Yes'){
                    filter += filter.contains('where') ? ' and' : ' where';
                    filter += ' Batch_Expiry_Date__c <' + todaysDateStr;
                } else if (type == 'No'){
                    filter += filter.contains('where') ? ' and' : ' where';
                    filter += ' Batch_Expiry_Date__c >=' + todaysDateStr;
                }
            }
        }
        // Added filter condition for ClientNameandCity, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
        clientNameQuery = query + filter + ' ORDER BY Name_And_City__c ASC';
        if (!String.isEmpty(clientCityAndName)){
            if (clientCityAndName != 'All'){
                filter += filter.contains('where') ? ' and' : ' where';
                filter += ' Name_And_City__c =: clientCityAndName ';
            }
        }
        query += filter;
        countQuery += filter;
        if (offset > 2000){
            offset = 2000;
        }
        query += ' LIMIT :pSize OFFSET :offset';
        List<Stock_Management__c> stockList = Database.query(query);
        List<Stock_Management__c> clientNameData = Database.query(clientNameQuery);
        Integer totalRecords = Database.countQuery(countQuery);
        Integer recordEnd = pSize * pNumber;
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.totalRecords = totalRecords;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        if (taxNumber.size() > 1){
            objDT.isParentBr = true;
            objDT.taxMap = taxMap;
        } else{
            objDT.isParentBr = false;
        }
        // Below if to pass sub group data to LWC, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
        if(isMainParent){
            objDT.subGroupData = subGroupData;
            objDT.isMainParent = true;
          }
        List<ResultWrapper> stockwrap = new List<ResultWrapper>();
        //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
        for (Stock_Management__c sm : clientNameData){
            if (sm.Name_And_City__c != null){
                nameAndCity.add(sm.Name_And_City__c);
            }
        }
        //Changes Field mapping, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
        for (Stock_Management__c sm : stockList){
            ResultWrapper st = new ResultWrapper();
            st.Id = sm.Id;
            if (sm.Report_Date__c != null){
                st.reportDate = grz_SapIntegration.FormattedDateBrazil(sm.Report_Date__c);
            }
            st.storage = sm.Storage__c;
            st.uplSaleNote = sm.UPL_Sale_Note__c;
            st.CNPJ_Client = sm.CNPJ_Client__c;
            st.productName = sm.Product_Name__c;
            st.batch = sm.Batch__c;
            if (sm.Batch_Expiry_Date__c != null){
                st.batchExpiryDate = grz_SapIntegration.FormattedDateBrazil(sm.Batch_Expiry_Date__c);
                if (sm.Batch_Expiry_Date__c < todaysDate){
                    st.overDue = 'Sim';
                    st.expire = true;
                } else{
                    st.overDue = 'Não';
                    st.expire = false;
                }
            }
            st.NameAndCity = sm.Name_And_City__c;
            st.currentBalanceQty = sm.Current_Balance_Qty__c;
            st.currentBalanceValue = sm.Current_Balance_Value__c;
            st.agRemainingDays = sm.AG_Remaining_Days__c;
            stockwrap.add(st);
        }
        objDT.stockWrapList = stockwrap;
        objDT.clientNameAndCity = nameAndCity;//GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
        return objDT;
    }

/**************************************************************************************************
* Name               : getDataForVF                                                      
* Description        : Method will set inventorty data in global variable for VF page to download as XLS Format
* Created By         : GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022                                                                       
**************************************************************************************************/
    public void getDataForVF(){
        String product = ApexPages.currentPage().getParameters().get('product');
        String batch = ApexPages.currentPage().getParameters().get('batch');
        String dueDate = ApexPages.currentPage().getParameters().get('dueDate');
        String endDate = ApexPages.currentPage().getParameters().get('endDate');
        String type = ApexPages.currentPage().getParameters().get('type');
        string nameAndCity = ApexPages.currentPage().getParameters().get('nameAndCity');
        String distributor = ApexPages.currentPage().getParameters().get('distributor');
        String subGroupId = ApexPages.currentPage().getParameters().get('subGroupId');
        stockManagementWrapper wrapData = getStockData(1, 2000, product, batch, dueDate, endDate, type, distributor, nameAndCity, subGroupId);
        items = wrapData.stockWrapList;
    }

    // method added to update checkbox on user GRZ(Nikhil Verma) : APPS-1394
    @AuraEnabled  
    public static void updateCheckbox(Boolean val){
        User userData = new User();
        userData.Id = UserInfo.getUserId();
        userData.Inventory_Expiry_Notification__c = val;
        update userData;
    }

    public class stockManagementWrapper{
        @AuraEnabled public Integer pageSize{ get; set; }
        @AuraEnabled public Integer pageNumber{ get; set; }
        @AuraEnabled public Integer totalRecords{ get; set; }
        @AuraEnabled public Integer recordStart{ get; set; }
        @AuraEnabled public Integer recordEnd{ get; set; }
        @AuraEnabled public Boolean brazilFlag{ get; set; }
        @AuraEnabled public Boolean isParentBr{ get; set; }
        @AuraEnabled public Boolean isExternalUser{ get; set; }
        @AuraEnabled public Boolean inventryNotification{ get; set; }
        @AuraEnabled public Set<String> clientNameAndCity{ get; set; }
        @AuraEnabled public List<String> taxMap{ get; set; }
        @AuraEnabled public Boolean isMainParent{get;set;} 
        @AuraEnabled public Set<String> subGroupData{get;set;}
        @AuraEnabled public List<ResultWrapper> stockWrapList{ get; set; }

    }

    public class ResultWrapper{
        @AuraEnabled public String Id{ get; set; }
        @AuraEnabled public String storage{ get; set; }
        @AuraEnabled public String uplSaleNote{ get; set; }
        @AuraEnabled public String reportDate{ get; set; }
        @AuraEnabled public String IE_doResponsVel{ get; set; }
        @AuraEnabled public String agRemainingDays{ get; set; }
        @AuraEnabled public String currentBalanceQty{ get; set; }
        @AuraEnabled public String currentBalanceValue{ get; set; }
        @AuraEnabled public String overDue{ get; set; }
        @AuraEnabled public String rowClr{ get; set; }
        @AuraEnabled public Boolean expire{ get; set; }
        @AuraEnabled public String productName{ get; set; }
        @AuraEnabled public String CNPJ_Client{ get; set; }
        @AuraEnabled public String batch{ get; set; }
        @AuraEnabled public String batchExpiryDate{ get; set; }
        @AuraEnabled public String NameAndCity{ get; set; }
    }

}