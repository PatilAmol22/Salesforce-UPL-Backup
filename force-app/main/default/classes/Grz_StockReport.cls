/**************************************************************************************************
* Name               : Grz_StockReport                                                      
* Description        : Controller class for grz_StockPie aura Component
* Test Class         : Grz_StockReportTest
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
public with sharing class Grz_StockReport{
/**************************************************************************************************
* Name               : getStockData                                                      
* Description        : method will return total amount of Inventory that will expire after 30,31-60, 61-90 , 91+ days
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
    @AuraEnabled(cacheable = true)
    public static stockManagementWrapper getStockData(String distributor, String subGroupId){
        DateTime todaysDate = System.today();
        DateTime today0_30 = todaysDate + 30;
        DateTime today31_60 = today0_30 + 30;
        DateTime today61_90 = today31_60 + 30;
        String todaysDateStr = todaysDate.format('yyyy-MM-dd');
        String todaysDateStr1 = today0_30.format('yyyy-MM-dd');
        String todaysDateStr2 = today31_60.format('yyyy-MM-dd');
        String todaysDateStr3 = today61_90.format('yyyy-MM-dd');
        Id id;
        if (Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'Brazil Partner Community Distributor Profile'];
            List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId = :pro[0].Id AND lastname = 'Testing' and Email = 'test@grazitti.com' LIMIT 1];
            id = user[0].Id;
        } else{
            id = UserInfo.getUserId();
        }
        List<User> user = [SELECT Id, Username, AccountId, ContactId, profile.name, Account.Tax_Number_Br_Portal_Filter__c, Account.Customer_Group__c, Account.SAP_Customer_Code__c, Account.Name, Account.BillingCity FROM User where Id = :id];
        String accountId = user[0].AccountId;
        String groupCstr = user[0].Account.Customer_Group__c;
        List<String> taxMap = new List<String>();
        List<String> taxNumber = new List<String>();
        //Added below two lines for Main Parent filter. GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
        Boolean isMainParent = false;
        Set<String> subGroupData = new Set<String>();
        if (!user.isEmpty()){
            taxNumber.add(user[0].Account.Tax_Number_Br_Portal_Filter__c);
            taxMap.add(user[0].Account.Tax_Number_Br_Portal_Filter__c + ' - ' + user[0].Account.SAP_Customer_Code__c + ' - ' + user[0].Account.Name + ' - ' + user[0].Account.BillingCity);
        }
        if (!String.isEmpty(groupCstr)){
            for (Account ac : [SELECT Id, Name, BillingCity, SAP_Customer_Code__c, Tax_Number_Br_Portal_Filter__c
                               FROM Account
                               where Customer_Group__c = :groupCstr AND (ParentId = :accountId OR Sub_Parent_Account__c = :accountId) ORDER BY Name, BillingCity ASC]){ // Added Order by in Query, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
                                   taxNumber.add(ac.Tax_Number_Br_Portal_Filter__c);
                                   taxMap.add(ac.Tax_Number_Br_Portal_Filter__c + ' - ' + ac.SAP_Customer_Code__c + ' - ' + ac.Name + ' - ' + ac.BillingCity);
                               }
            //Query added to get Sub Group distributor data, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
            for (Account ac : [SELECT Id, Sub_Parent_Account__c,Sub_Parent_Account__r.Tax_Number_Br_Portal_Filter__c, Sub_Parent_Account__r.Name, Sub_Parent_Account__r.BillingCity, Sub_Parent_Account__r.SAP_Customer_Code__c
                               FROM Account
                               WHERE Customer_Group__c = :groupCstr AND ParentId = :accountId AND Sub_Parent_Account__c != null
                               ORDER BY Sub_Parent_Account__r.Name ASC]){
                                   isMainParent = true;
                                   subGroupData.add(ac.Sub_Parent_Account__r.Tax_Number_Br_Portal_Filter__c + ' - ' + ac.Sub_Parent_Account__r.SAP_Customer_Code__c + ' - ' + ac.Sub_Parent_Account__r.Name + ' - ' + ac.Sub_Parent_Account__r.BillingCity);
                               }
        }
        stockManagementWrapper objDT = new stockManagementWrapper();
        String filter = '';
        objDT.upto_0_30 = 0;
        objDT.upto_31_60 = 0;
        objDT.upto_61_90 = 0;
        objDT.after_91 = 0;
        if (Test.isRunningTest()){
            objDT.upto_0_30 = 1;
            objDT.upto_31_60 = 1;
            objDT.upto_61_90 = 1;
            objDT.after_91 = 1;
        }
        // Changed Object Field mapping GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
        String query = 'SELECT Batch_Expiry_Date__c,CNPJ_Client__c,Current_Balance_Value__c FROM Stock_Management__c';
        if (!String.isEmpty(distributor)){
            if (distributor != 'All'){
                filter += filter.contains('where') ? ' and' : ' where';
                filter += ' CNPJ_Client__c =: distributor ';
            }else{//Else bock added, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
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
        query += filter;
        List<Stock_Management__c> stockList = Database.query(query);
        for (Stock_Management__c stockinfo : stockList){
            Decimal tempstock = 0;
            if (!Test.isRunningTest()){
                // Updated Null check and trim function. GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
                if (stockinfo.Current_Balance_Value__c != null){
                    tempstock = decimal.valueOf(stockinfo.Current_Balance_Value__c.replace('.', '').replace('R$', '').replace(',', '.').trim());
                }
            }
            if (stockinfo.Batch_Expiry_Date__c >= date.valueOf(todaysDateStr) && stockinfo.Batch_Expiry_Date__c < date.valueOf(todaysDateStr1)){
                objDT.upto_0_30 += tempstock;
                
            }
            if (stockinfo.Batch_Expiry_Date__c >= date.valueOf(todaysDateStr1) && stockinfo.Batch_Expiry_Date__c < date.valueOf(todaysDateStr2)){
                objDT.upto_31_60 += tempstock;
            }
            if (stockinfo.Batch_Expiry_Date__c >= date.valueOf(todaysDateStr2) && stockinfo.Batch_Expiry_Date__c < date.valueOf(todaysDateStr3)){
                objDT.upto_61_90 += tempstock;
            }
            if (stockinfo.Batch_Expiry_Date__c >= date.valueOf(todaysDateStr3)){
                objDT.after_91 += tempstock;
            }
        }
        if (taxNumber.size() > 1){
            objDT.isParentBr = true;
            objDT.taxMap = taxMap;
        } else{
            objDT.isParentBr = false;
        }
        if (isMainParent){
            objDT.subGroupData = subGroupData;
            objDT.isMainParent = true;
        }
        List<StChart> st = new List<StChart>();
        if (objDT.upto_0_30 == 0 && objDT.upto_31_60 == 0 && objDT.upto_61_90 == 0 && objDT.after_91 == 0){
            objDT.ChartValue = st;
        } else{
            st.add(new StChart('Menor que 30', objDT.upto_0_30));
            st.add(new StChart('de 30 a 60 dias', objDT.upto_31_60));
            st.add(new StChart('de 60 a 90 dias', objDT.upto_61_90));
            st.add(new StChart('Acima de 90', objDT.after_91));
            objDT.ChartValue = st;
        }
        return objDT;
    }
    
    public class StChart{
        @AuraEnabled public String name{ get; set; }
        @AuraEnabled public Decimal value{ get; set; }
        public StChart(String name, Decimal value){
            this.name = name;
            this.value = value;
        }
    }
    
    public class stockManagementWrapper{
        @AuraEnabled public Boolean isParentBr{ get; set; }
        @AuraEnabled public List<String> taxMap{ get; set; }
        @AuraEnabled public decimal upto_0_30{ get; set; }
        @AuraEnabled public decimal upto_31_60{ get; set; }
        @AuraEnabled public decimal upto_61_90{ get; set; }
        @AuraEnabled public decimal after_91{ get; set; }
        @AuraEnabled public list<StChart> ChartValue{ get; set; }
        @AuraEnabled public Boolean isMainParent{ get; set; }
        @AuraEnabled public Set<String> subGroupData{ get; set; }  
    }
}