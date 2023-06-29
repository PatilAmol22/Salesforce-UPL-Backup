public class OfflineOrderHandler {
    
    //Insert Offline Orders to Sales Order on Before Insert
    public static void beforeInsert(List<Offline_Mobile_Order__c> offlineOrderList){
    
    system.debug('OfflineOrderHandler --->');
        
        // Create a savepoint before inserting Sales Order
    Savepoint sp = Database.setSavepoint();
        
        try{
            List<Offline_Mobile_Order__c > lstToupdate = new List<Offline_Mobile_Order__c >();
            Set<Id> accountIdSet = new Set<Id>();
            
            for(Offline_Mobile_Order__c ofmObj:offlineOrderList){
                if(ofmObj.Status__c == 'Completed'){        
                    accountIdSet.add(ofmObj.Account_txt__c);
                }
            }
            
            Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id, Name, BillingCity, BillingCountry, RegionalManager__c,
                                                               BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, Sales_Org__r.Name, 
                                                               OwnerId, SAP_Code__c, Sales_Org__c, Distribution_Channel__c, Division__c,
                                                               Order_Type__c, Order_Block__c,Sales_Org_Code__c, Status__c, Payment_Terms__c, PriceGroupCode__c
                                                               FROM Account 
                                                               WHERE Id IN:accountIdSet]);
            
            List<Sales_Order_Line_Item__c> salesOrderLineItemList = new List<Sales_Order_Line_Item__c>();
            
            for(Offline_Mobile_Order__c ofmObj:offlineOrderList){
                
                if(ofmObj.Status__c == 'Completed'){
                    
                    Sales_Order__c soObj = new Sales_Order__c();
                    soObj.Sold_to_Party__c = ofmObj.Account_txt__c;
                    soObj.Bill_To_Party__c = ofmObj.Account_txt__c;
                    soObj.Order_Date__c = System.today();
                    soObj.Order_Raise_By__c = 'Territory Manager';
                    soObj.Order_Status__c = 'Open';
                    soObj.CreatedFrom__c = 'SFDC';
                    soObj.OwnerId = accountMap.get(ofmObj.Account_txt__c).OwnerId; //distributorId;
                    soObj.Ship_To_Party__c = ofmObj.Shipping_Location_Id__c;
                    soObj.Sales_Org_lk__c = ofmObj.Sales_Org_txt__c;
                    soObj.Distribution_Channel_lk__c = ofmObj.Distribution_Channel_txt__c;
                    soObj.Division_lk__c = ofmObj.Division_txt__c;
                    soObj.CurrencyIsoCode = accountMap.get(ofmObj.Account_txt__c).CurrencyIsoCode;
                    
                    /*soObj.Credit_Term__c = distWrapObj.paymentTerms;
                    if(String.isNotBlank(PO)){
                    soObj.PONumber__c = PO;
                    }
                    if(soObj.Order_Raise_By__c == 'Distributor'){
                    soObj.Designated_Owner__c = territoryManagerId;
                    }
                    else{
                    soObj.Designated_Owner__c = distWrapObj.regionalManagerId;
                    }*/
                    
                    //soObj.Order_Type_lk__c = ofmObj.Order_Type__c;
                    
                    insert soObj;
                    
                    //Insert Line Items from JSON
                    List<OfflineLineItem> lineItemList = OfflineLineItem.parse(ofmObj.Offline_Mobile_LineItem__c);
                    Sales_Order_Line_Item__c sliObj;
                    
                    Integer itemNo = 0;
                    
                    for(OfflineLineItem lineItemObj : lineItemList){
                        
                        sliObj = new Sales_Order_Line_Item__c();
                        sliObj.SKU_Name__c = lineItemObj.sku_id;
                        itemNo = 10 + itemNo;
                        sliObj.Item_Number__c = itemNo;
                        sliObj.Item_Status__c = 'Active';
                        sliObj.No_of_Case__c = Decimal.valueOf(lineItemObj.no_case_size);
                        sliObj.DepotDepot__c = ofmObj.Depot_txt__c;
                        sliObj.Sale_Order__c = soObj.Id;
                        
                        //sliObj.UOM__c = lineItemObj.UOM;
                        sliObj.CurrencyIsoCode = accountMap.get(ofmObj.Account_txt__c).CurrencyIsoCode;
                        
                        /*
                        if(lineItemObj.qty > 0){                
                        sliObj.Quantity__c = lineItemObj.qty;
                        sliObj.Invoice_Discount__c = lineItemObj.invoiceDiscount * lineItemObj.qty;
                        sliObj.Special_Discount__c = lineItemObj.specialDiscount * lineItemObj.qty;
                        sliObj.Price__c = (lineItemObj.price*sliObj.Quantity__c) - sliObj.Invoice_Discount__c - sliObj.Special_Discount__c;
                        sliObj.Sale_Order__c = soObj.Id;
                        }*/
                        
                        //insert sliObj;
                        salesOrderLineItemList.add(sliObj);
                    }
                    
                    //Change status to Order placed after successful creation of Sales Order
                    ofmObj.Status__c = 'Order Placed';
                }
            }
            
            if(!salesOrderLineItemList.isEmpty()){
                insert salesOrderLineItemList;
                System.debug('Inserted succesfully--->');
            }
        }
        catch(Exception ex){
        
            System.debug('ex--->'+ex.getMessage());     
            System.debug('ex--->'+ex.getLineNumber());     
            // Rollback Sales Orders in Case of Errors
            Database.rollback(sp);
            
            //Log exceptions in Monitor Log
            ApexLog.exceptionHandler(ex, '', '');
        }
    }
}