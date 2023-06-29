/**************************************************************************************************
* Name               : Grz_SalesOrderListBrazil                                                      
* Description        : Controller class for Grz_SalesOrderListBrazil LWC Component
* Test Class         : Grz_SalesOrderListBrazilTest
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
public with sharing class Grz_SalesOrderListBrazil{
/**************************************************************************************************
* Name               : getSalesOrderRecordBrazil                                                      
* Description        : Method will return Sales Order of current logged in user on community
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
    @AuraEnabled(cacheable = true)
    public static FinamlSalesDataWrapper getSalesOrderRecordBrazil(String searchKey, String datefilter, String sortby, Decimal pageNumber, Decimal pageSize, String startDate, String endDate, String distributor, String invoicedata, String subGroupId, Boolean viewUndeliveredOrders){
        Integer pSize;
        if (pageSize != null && pageSize != 0.0){
            pSize = (Integer) pageSize;
        } else{
            pSize = 10;
        }
        Integer pNumber = (Integer) pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        // Added to get ordet type from Custom Setting GRZ(Nikhil Verma) : APPS-1394
        list<string> statusList= new list<string>();
        List<String> pickOptions = new List<String>();
        List<String> allStatus = Brazil_Portal_Configuration__c.getOrgDefaults().Portal_Sales_Order_Type__c.split('\n'); 
        for(String st : allStatus){
            statusList.add(st.trim());
            pickOptions.add(st.trim());
        }

        Id id = UserInfo.getUserId(); // getting current user info
        List<User> user = [SELECT Id,Sales_Order_Notification__c, Username, AccountId, ContactId, profile.name, Account.Customer_Group__c, Account.SAP_Customer_Code__c, Account.Name, Account.BillingCity FROM User where Id = :id];// Field added GRZ(Nikhil Verma) : APPS-1394
        String accountId = user[0].AccountId;
        String groupCstr = user[0].Account.Customer_Group__c;
        List<String> cstrCode = new List<String>();
        if (!user.isEmpty()){
            cstrCode.add(user[0].Account.SAP_Customer_Code__c + ' - ' + user[0].Account.Name + ' - ' + user[0].Account.BillingCity);
        }
        List<ResultWrapper> saleWrapperList = new List<ResultWrapper>();
        FinamlSalesDataWrapper objDT = new FinamlSalesDataWrapper();
        String countQuery = 'Select Count() from Sales_Order__c';
        List<String> salesorgcode = System.Label.Grz_BrazilSalesOrgCode.trim().Split(',');
        List<String> orderSt = System.Label.Approved.trim().Split(',');
        Set<Id> accId = new Set<Id>();
        //Added below two lines for Main Parent filter. GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
        Boolean isMainParent = false;
        Set<String> subGroupData = new Set<String>();
        if (!String.isEmpty(groupCstr)){
            for (Account ac : [SELECT Id, Name, BillingCity, SAP_Customer_Code__c
                               FROM Account
                               where Customer_Group__c = :groupCstr AND (ParentId = :accountId OR Sub_Parent_Account__c = :accountId)
                               ORDER BY Name, BillingCity ASC]){// Added Order by in Query, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
                accId.add(ac.Id);
                cstrCode.add(ac.SAP_Customer_Code__c + ' - ' + ac.Name + ' - ' + ac.BillingCity);
            }
            //Query added to get Sub Group distributor data, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022 
            for (Account ac : [SELECT Id, Sub_Parent_Account__c, Sub_Parent_Account__r.Name, Sub_Parent_Account__r.BillingCity, Sub_Parent_Account__r.SAP_Customer_Code__c
                               FROM Account
                               WHERE Customer_Group__c = :groupCstr AND ParentId = :accountId AND Sub_Parent_Account__c != null
                               ORDER BY Sub_Parent_Account__r.Name ASC]){
                isMainParent = true;
                subGroupData.add(ac.Sub_Parent_Account__r.SAP_Customer_Code__c + ' - ' + ac.Sub_Parent_Account__r.Name + ' - ' + ac.Sub_Parent_Account__r.BillingCity);
            }
        }
        accId.add(accountId);
        String query = 'Select Id,Name,SAP_Order_Number__c,SalesOrderNumber_Brazil__c, SFDC_Order_Number__c, Currency_Brazil__c,Invoice_Status__c,CreatedBy.Name, CreatedDate ,Total_Value_Brazil__c,BrazilSalesOrderStatus__c, LastModifiedDate, Type_of_Order__c, Brazil_City__c , Order_Type_lk__c, Order_Type_lk__r.Name, Order_Status__c,OrderQuantity__c,Total_Amount__c,Sold_to_Party__r.name,Sold_to_Party__c from Sales_Order__c';
        String filter = ' where SalesOrgCode__c in:salesorgcode and BrazilSalesOrderStatus__c In: orderSt and Type_of_Order__c	In:statusList'; // Order Type check added GRZ(Nikhil Verma) : APPS-1394
        if (!String.isEmpty(accountId)){
            objDT.isExternalUser = true;//GRZ(Nikhil Verma) : APPS-1394
            if (!filter.contains('where')){
                filter += ' where Sold_to_Party__c In: accId';
            } else{
                filter += ' and Sold_to_Party__c In: accId';
            }
        }
        if (!String.isEmpty(distributor)){
            if (distributor != 'All'){
                if (!filter.contains('where')){
                    filter += ' where Sold_to_Party__r.SAP_Code__c =: distributor';
                } else{
                    filter += ' and Sold_to_Party__r.SAP_Code__c =: distributor';
                }
            }else{//Else bock added, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                if (subGroupId != null && subGroupId != ''){
                    Set<String> subGroupSapId = new Set<String>();
                    for(Account acc : [SELECT SAP_Code__c FROM Account WHERE Sub_Parent_Account__r.SAP_Code__c = :subGroupId ]){
                        subGroupSapId.add(acc.SAP_Code__c);
                    }
                    subGroupSapId.add(subGroupId);
                    if (!filter.contains('where')){
                        filter += ' where Sold_to_Party__r.SAP_Code__c IN: subGroupSapId';
                    } else{
                        filter += ' and Sold_to_Party__r.SAP_Code__c IN: subGroupSapId';
                    }
                } 
            }
        }
        if (!string.IsBlank(invoicedata)){
            if (invoicedata != 'All'){
                filter += filter.contains('where') ? ' and' : ' where';
                if (invoicedata == 'A'){
                    filter += ' (Invoice_Status__c like \'%' + 'Faturado' + '%\' or Invoice_Status__c like \'%' + 'Faturado Parcial' + '%\')';
                } else if (invoicedata == 'B'){
                    filter += ' (Invoice_Status__c like \'%' + 'Pedido em Análise' + '%\' or Invoice_Status__c like \'%' + 'Crédito Bloqueado' + '%\' or Invoice_Status__c like \'%' + 'Crédito Liberado' + '%\' or Invoice_Status__c like \'%' + null + '%\')';
                } else if(invoicedata == 'Entregue em'){//Condition updated, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                    filter += ' (Invoice_Status__c like \'%' + invoicedata + '%\' OR Invoice_Status__c = \'Entregue\')';
                }else{
                    filter += ' (Invoice_Status__c like \'%' + invoicedata + '%\')';
                }
            }else{//Else bock added for new filter to show open orders, GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                if(viewUndeliveredOrders){
                    filter += filter.contains('where') ? ' and' : ' where';
                    filter += ' ( (NOT Invoice_Status__c like \'%Entregue em%\' ) AND Invoice_Status__c != \'Entregue\')';
                }
            }
        }

        if (!string.IsBlank(searchKey)){
            filter += filter.contains('where') ? ' and' : ' where';
            filter += ' (Name like \'%' + searchKey + '%\' or SAP_Order_Number__c like \'%' + searchKey + '%\' or SFDC_Order_Number__c  like \'%' + searchKey + '%\')';
        }
        if (!string.IsBlank(sortby)){
            if (sortby != 'All'){
                filter += filter.contains('where') ? ' and' : ' where';
                filter += ' Type_of_Order__c like \'%' + sortby + '%\'';
            }
        }
        if (!filter.contains('where')){
            filter += ' where DAY_ONLY(createddate) >=' + startDate + ' and DAY_ONLY(createddate)<=' + endDate;
        } else{
            filter += ' and DAY_ONLY(createddate) >=' + startDate + ' and DAY_ONLY(createddate)<=' + endDate;
        }
        query += filter;
        countQuery += filter;
        if (datefilter != NULL && datefilter != ''){
            query += ' order by ' + datefilter;
        } else{
            query += ' order by CreatedDate desc ';
        }
        if (offset > 2000){
            offset = 2000;
        }
        query += ' LIMIT :pSize OFFSET :offset';
        countQuery += ' LIMIT 2000';
        List<Sales_Order__c> salesOrderList = Database.query(query);
        Integer totalRecords = Database.countQuery(countQuery);
        Integer recordEnd = pSize * pNumber;
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.salesNotification = user[0].Sales_Order_Notification__c;//GRZ(Nikhil Verma) : APPS-1394

        if (accId.size() > 1){
            objDT.isParentBr = true;
            objDT.cstrCode = cstrCode;
        } else{
            objDT.isParentBr = false;
        }
        //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
        if (isMainParent){
            objDT.subGroupData = subGroupData;
            objDT.isMainParent = true;
        }

        objDT.recordStart = offset + 1;
        objDT.totalRecords = totalRecords;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        for (Sales_Order__c sOrder : salesOrderList){
            ResultWrapper orderResult = new ResultWrapper();
            orderResult.Id = sOrder.Id;
            orderResult.soUrl = '/uplpartnerportal/apex/Grz_SalesOrderPDF?Id=' + sOrder.Id; //GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
            orderResult.SAPOrderNumber = sOrder.SAP_Order_Number__c;
            orderResult.SFDCOrderNumber = sOrder.SalesOrderNumber_Brazil__c;
            /*Start--- Updated Logic conditions GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022*/
            if (sOrder.Invoice_Status__c == 'Pedido em Análise' || sOrder.Invoice_Status__c == 'Crédito Bloqueado' || sOrder.Invoice_Status__c == 'Crédito Liberado'){
                orderResult.InvoiceStatus = 'Pedido em Processamento';
            } else if (sOrder.Invoice_Status__c == 'Faturado' || sOrder.Invoice_Status__c == 'Faturado Parcial'){
                orderResult.InvoiceStatus = 'Pedido Faturado';
            } else if (sOrder.Invoice_Status__c == null){
                orderResult.InvoiceStatus = 'Pedido em Processamento';
            } else{
                orderResult.InvoiceStatus = sOrder.Invoice_Status__c;
            }
            /*-----------End--------------*/
            if (sOrder.CreatedDate != null){
                orderResult.CreatedDate = grz_SapIntegration.FormattedDateBrazil(sOrder.CreatedDate);
            }
            String name = sOrder.CreatedBy.Name.toLowerCase();
            String result = '';
            if (name != null && name != ''){
                for (String iter : name.split('[ ]+')){
                    if (iter != null && iter != ''){
                        if (iter.length() > 1){
                            result += iter.substring(0, 1).toUpperCase() + iter.substring(1, iter.length()) + ' ';
                        } else{
                            result += iter.substring(0, 1).toUpperCase() + ' ';
                        }
                    }
                }
                result = result.substring(0, result.length() - 1);
                orderResult.SalesRepName = result;
            }
            orderResult.SoldToPartyName = sOrder.Sold_To_Party__r.Name;
            orderResult.City = sOrder.Brazil_City__c;
            if (sOrder.Currency_Brazil__c != null){
                if (sOrder.Currency_Brazil__c == 'Billing BRL / Payment BRL'){
                    orderResult.CurrencyBrazil = 'Real – BRL';
                } else if (sOrder.Currency_Brazil__c == 'Billing USD / Payment BRL'){
                    orderResult.CurrencyBrazil = 'Dólar – USD';
                } else if (sOrder.Currency_Brazil__c == 'Billing USD / Payment USD'){
                    orderResult.CurrencyBrazil = 'Dólar – USD';
                }
            }
            if (sOrder.Total_Value_Brazil__c != null){
                if (sOrder.Type_of_Order__c == 'BONIFICAÇÃO' || sOrder.Type_of_Order__c == 'REMESSA PARA TESTE'){
                    orderResult.Amount = '-';
                } else{
                    orderResult.Amount = String.valueOf(sOrder.Total_Value_Brazil__c.setScale(0));
                }
            }
            orderResult.OrderType = sOrder.Type_of_Order__c;
            orderResult.OrderStatus = sOrder.BrazilSalesOrderStatus__c;
            saleWrapperList.add(orderResult);
        }
        objDT.salesWrapList = saleWrapperList;
        objDT.picklistValues = pickOptions;
        return objDT;
    }

    // New method added to update notification checkbox on user GRZ(Nikhil Verma) : APPS-1394
    @AuraEnabled  
    public static void updateCheckbox(Boolean val){
        User userData = new User();
        userData.Id = UserInfo.getUserId();
        userData.Sales_Order_Notification__c = val;
        update userData;
    }

    public class ResultWrapper{
        @AuraEnabled public String Id{ get; set; }
        @AuraEnabled public String SAPOrderNumber{ get; set; }
        @AuraEnabled public String soUrl{ get; set; }
        @AuraEnabled public String SFDCOrderNumber{ get; set; }
        @AuraEnabled public String InvoiceStatus{ get; set; }
        @AuraEnabled public String CreatedDate{ get; set; }
        @AuraEnabled public String SalesRepName{ get; set; }
        @AuraEnabled public String SoldToPartyName{ get; set; }
        @AuraEnabled public String City{ get; set; }
        @AuraEnabled public String Amount{ get; set; }
        @AuraEnabled public String OrderType{ get; set; }
        @AuraEnabled public String OrderStatus{ get; set; }
        @AuraEnabled public String CurrencyBrazil{ get; set; }
    }

    public class FinamlSalesDataWrapper{
        @AuraEnabled public Integer pageSize{ get; set; }
        @AuraEnabled public Integer pageNumber{ get; set; }
        @AuraEnabled public Integer totalRecords{ get; set; }
        @AuraEnabled public Integer recordStart{ get; set; }
        @AuraEnabled public Integer recordEnd{ get; set; }
        @AuraEnabled public Boolean brazilFlag{ get; set; }
        @AuraEnabled public Boolean isParentBr{ get; set; }
        @AuraEnabled public Boolean salesNotification{ get; set; }
        @AuraEnabled public Boolean isExternalUser{ get; set; }
        @AuraEnabled public List<String> cstrCode{ get; set; }
        @AuraEnabled public List<ResultWrapper> salesWrapList{ get; set; }
        @AuraEnabled public List<String> picklistValues{ get; set; }
        @AuraEnabled public Boolean isMainParent{ get; set; }
        @AuraEnabled public Set<String> subGroupData{ get; set; }
    }
}