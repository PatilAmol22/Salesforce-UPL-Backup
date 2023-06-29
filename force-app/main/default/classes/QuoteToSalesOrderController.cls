public without sharing class QuoteToSalesOrderController {
    /* public QuoteToSalesOrderController() {

} */
    public static Quote quote;
    public static List<QuoteLineItem> quoteLineItem;
    public static Map<String,Sales_Order__c> divisionViseOrderMap = new Map<String,Sales_Order__c>();
    public static Map<String,String> salesOrderMap = new Map<String,String>();
    
    @AuraEnabled
    public static String checkQuoteStatus(String quote_id){
        String result='';
        Quote quote = [SELECT Id, Name, AccountID,Sales_Order_created__c, Status from Quote where Id =:quote_id];
        
        if(quote.Sales_Order_created__c==true && quote.Status == 'Approved'){
            result = 'Sales Order already created';
        }else if(quote == null){
            result = 'Record Not Found';
        }else if(quote.Status == 'Approved' && quote.Sales_Order_created__c==false){
            result = 'Approved';
        }else{
            result = 'Not Approved';
        }
        return result;
    }
    
    @AuraEnabled
    public static List<Sales_Order__c> createSalesOrder(String quote_id){
        
        List<String> soIdList = new List<String>();
        List<Sales_Order__c> soList = new List<Sales_Order__c>();
        List<Sales_Order_Line_Item__c> soItemList = new List<Sales_Order_Line_Item__c>();
        Map<String,List<QuoteLineItem>> DivisionMap = new Map<String,List<QuoteLineItem>>();
        
        try {
            if(quote_id != '' || quote_id != null){
                quote = new Quote();
                quote = [SELECT Id, Name, Opportunity.Sales_Org_Code__c,  AccountID, Ship_to_Party__c, Distribution_Channel__c,Order_Type__c, Storage_Location__c,
                         Payment_Term__c, Inco_Term_Code__c, TM_Code__c, Quote_Raised_By__c from Quote where Id =:quote_id];
                
                quoteLineItem = new List<QuoteLineItem>();
                quoteLineItem = [SELECT Id, LineNumber, QuoteId, SKU__c, Item_Number__c,UnitPrice, Quantity, Depot__c, 
                                 Storage_Location__c, Max_Price__c, Min_Price__c, Division__c, Sales_Org__c, UOM__c 
                                 from QuoteLineItem where QuoteId =: quote_id];
                
                if(quoteLineItem.size()>0){
                    for(QuoteLineItem qlitm : quoteLineItem){
                        if(!DivisionMap.containsKey(qlitm.Division__c)) {
                            DivisionMap.put(qlitm.Division__c, new List<QuoteLineItem>{qlitm});
                        }
                        else{
                            DivisionMap.get(qlitm.Division__c).add(qlitm);
                        }
                    }
                    
                    for(String div : DivisionMap.keySet()){
                        
                        Integer itemNo = 0;
                        Sales_Order_Line_Item__c sliObj;
                        
                        for(QuoteLineItem qLineItm:DivisionMap.get(div)){
                            itemNo = itemNo + 10;
                            String soId = createSalesOrder2(qLineItm.Division__c,qLineItm.Sales_Org__c,quote);
                            system.debug('soId- - '+ soId);
                            if(!salesOrderMap.containsKey(soId)) {
                                salesOrderMap.put(soId, soId);
                            }
                            
                            sliObj = new Sales_Order_Line_Item__c();
                            sliObj.Sale_Order__c = soId;
                            sliObj.SKU_Name__c = qLineItm.SKU__c;
                            sliObj.Item_Number__c = itemNo;
                            sliObj.Quantity__c = qLineItm.Quantity;
                            sliObj.UOM__c = qLineItm.UOM__c;
                            sliObj.DepotDepot__c = qLineItm.Depot__c;
                            System.debug('@@@@ in line Item Storage_Location__c '+qLineItm.Storage_Location__c);
                            
                            sliObj.Storage_Location__c = qLineItm.Storage_Location__c;
                            sliObj.MaxPrice__c = qLineItm.Max_Price__c;
                            sliObj.MinPrice__c = qLineItm.Min_Price__c;
                            sliObj.FinalPrice__c = qLineItm.UnitPrice;
                            sliObj.Sales_Org__c = qLineItm.Sales_Org__c;
                            //sliObj.Item_Status__c = 'Active';
                            //sliObj.Order_Item_Key__c
                            //sliObj.SpotDiscountPercentage__c
                            //sliObj.Price__c
                            //sliObj.Net_Price__c
                            //sliObj.ITM_Number
                            //sliObj.COND_TYPE
                            //sliObj.Error_Message__c
                            //sliObj.Campaign_Discount__c
                            //sliObj.Material_Discount__c
                            //sliObj.FinalPrice__c
                            soItemList.add(sliObj);
                            
                        }
                    }
                    system.debug('soItemList- - '+ soItemList.size());
                    if(soItemList.size()>0){
                        insert soItemList;
                    }
                    system.debug('salesOrderMap- - '+ salesOrderMap);
                    soIdList = salesOrderMap.values();
                    system.debug('soIdList- - '+ soIdList);
                    if(soIdList.size()>0){
                        soList = [Select Id,Name,Net_Amount__c from Sales_Order__c where id IN:soIdList];
                       
                        for(Sales_Order__c so: soList){
                            so.Total_Amount__c = so.Net_Amount__c;
                        }
                        
                        if(soList.size()>0){
                            update soList;
                            System.debug('soObj: '+soList);
                        }
                    }
                }
                Quote qobj = new Quote();
                Quote qobj1 = new Quote();
                qobj = [Select Id, Sales_Order_created__c from Quote Where Id=:quote_id];
                
                qobj1.Sales_Order_created__c =true;
                qobj1.Id = qobj.Id;
                update qobj1;
                    
                
                
            }
        } 
        catch (Exception ex) {
            
        }
        //soIdList.add('a1E0k000001A6KtEAK');
        //soIdList.add('a1E0k000001A4dYEAS');
        return soList;
    }
    
    public static String createSalesOrder2(String div_Id, String sales_org, Quote quoteObj){
        
        system.debug('createSalesOrder2 Called....');
        system.debug('divisionId - createSalesOrder2'+div_Id);
        system.debug('quoteObj- - '+quoteObj);
        System.debug('Quote Sales Org is '+quoteObj.Opportunity.Sales_Org_Code__c);
        String orderType;
        
        if(quoteObj.Opportunity.Sales_Org_Code__c=='5711'){
            System.debug('Inside 5711');
            orderType ='ZZOR';
        }
        
        if(quoteObj.Opportunity.Sales_Org_Code__c=='5712'){
            System.debug('Inside 5712');
            orderType ='ZZEX';
        }
        System.debug('orderType before  '+orderType);
      String Order_Type_lk = [Select Id,SalesOrg__c,Order_Type_Code__c FROM Order_Type__c WHERE Order_Type_Code__c =:orderType limit 1].Id;    
System.debug('Order_Type_lk while testng '+Order_Type_lk);
        
        Sales_Order__c soObj;
        try {
            
            
            if(!divisionViseOrderMap.containskey(div_Id)){ 
                system.debug('Inside IF- - ');
                soObj = new Sales_Order__c();
                soObj.Sold_to_Party__c = quoteObj.AccountID;
                soObj.Ship_To_Party__c = quoteObj.Ship_to_Party__c;
                soObj.Sales_Org_lk__c = sales_org;
                soObj.Distribution_Channel_lk__c = quoteObj.Distribution_Channel__c;
                soObj.Division_lk__c = div_Id;
                soObj.Order_Date__c = System.today();
                
                
                System.debug('@@@ DistributionChannel '+quoteObj.Distribution_Channel__c);
                System.debug('@@@ Ship to Party '+quoteObj.Ship_to_Party__c);
                System.debug('@@@ PaymentTerm '+quoteObj.Payment_Term__c);
                
                soObj.Payment_Term__c = quoteObj.Payment_Term__c;
                soObj.Inco_Term__c = quoteObj.Inco_Term_Code__c;
                soObj.Order_Status__c = 'Open';
                soObj.TM_Code__c = quoteObj.TM_Code__c;
                soObj.Created_From_Quote__c = true;
                soObj.CreatedFrom__c =  'SFDC';
                soObj.Price_Entry__c =  'Manual';
                soObj.Bill_To_Party__c =  quoteObj.AccountID;
                soObj.Quote__c = quoteObj.Id;
                System.debug('Order_Type_lk before assigninig '+Order_Type_lk);
                    
                soObj.Order_Type_lk__c = Order_Type_lk;
                //soObj.Order_Type_lk__c = quoteObj.Order_Type__c;
               
                soObj.Order_Raise_By__c = quoteObj.Quote_Raised_By__c;
                //soObj.Bill_To_Party__c = accountId;
                //soObj.Order_Raise_By__c = orderRaisedBy;
                //soObj.Order_Type_lk__c
                //soObj.Inco_Term_1__c
                //soObj.Inco_Term_2__c
                //soObj.UGDN__c
                //soObj.Error_Message__c
                //soObj.PONumber__c
                //soObj.SAP_Password__c
                //soObj.partner_role
                //soObj.partner_number
                //soObj.Remarks__c & Remarks_Long__c
                //soObj.Distributor_Discount__c
                //soObj.Editable_Payment_Term_Discount__c
                //soObj.PaymentMethod__c
                //soObj.Shipping_condition__c
                
                insert soObj;
                system.debug('soObj- - '+soObj.id);
                divisionViseOrderMap.put(div_Id,soObj);
                
            }
            else{
                system.debug('Inside else- - ');
                soObj = divisionViseOrderMap.get(div_Id);
            }
            system.debug('soObj2- - '+soObj.ID);
        } 
        catch (Exception ex) {
            System.debug('Exception Occure... '+ ex);
        }
        return soObj.ID;
    }
    
}