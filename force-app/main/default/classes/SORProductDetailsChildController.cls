/*******************************************************************************************
* @Name         Sales Order Return 
* @Author       Nikhil Dhoke (SKI)
* @Date         03/03/2023
* @Group        SKI
* @Description  This class is used for Sales Order Return Module (Brazil Only).
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer         	   Date(MM/DD/YYYY)      Description
*-------------------------------------------------------------------------------------------   
*  1.0             Nikhil Dhoke            03/04/2023            Initial Creation                                        
*******************************************************************************************/
public without sharing class SORProductDetailsChildController {

    public static List<String> invItemIdList = new List<String>();

    /*
    * @Description - This method will return List of SOR items based on SOR id.
    * @Param String - SOR id.
    * @return  - List of Wrapper object.
    */
    @AuraEnabled(cacheable=true)
    public static List<ProductDetailsWrapper> getSORItemList(String sorId) {
        List<ProductDetailsWrapper> pdWrapList = new List<ProductDetailsWrapper>();
        Set<String> idSet = new Set<String>();
        try{
            List<Return_Sales_Order_Line_Item__c> sorItemList = [SELECT Id, Name, Return_Sales_Order__c, 
                                                                Invoice_Line_Item__c, Net_Amount__c, Item_Number__c, 
                                                                RSOLI_Combination_Key__c, Batch__c, SKU_Code__c, 
                                                                SKU_Description__c, SKU_Name__c, UOM__c, Invoice__c, 
                                                                Invoice__r.SAP_Billing_DOC__c, Invoice__r.Billing_Date__c, 
                                                                Invoice__r.Sales_Order__r.Inco_Term_Code__c, Invoice__r.Nota_Fiscal__c, 
                                                                AT_AG__c, Product_Damaged__c, Packing_Condition__c, 
                                                                Product_Condition__c, Comments__c, Slow_Moving__c, 
                                                                Product_Contention__c, Product_can_be_reworked__c, 
                                                                Rework_Cost__c, Write_Off__c, Currency__c, Volumn_KG_LT__c, 
                                                                Unit_Value__c, Total_Value__c, Expire_Date__c, Invoice__r.Name  
                                                                FROM Return_Sales_Order_Line_Item__c WHERE Return_Sales_Order__c =: sorId];
            if(sorItemList.size()>0){
                Integer counter = 10;
                Integer count = 0;
                for(Return_Sales_Order_Line_Item__c rsI : sorItemList){
                    if(rsI.Item_Number__c != null){
                        if(count < integer.valueof(rsI.Item_Number__c)){
                            count = integer.valueof(rsI.Item_Number__c);
                        }
                    }
                }
                for(Return_Sales_Order_Line_Item__c rsoItem : sorItemList){
                    ProductDetailsWrapper pdWrap = new ProductDetailsWrapper();
                    if(rsoItem.Item_Number__c != null){
                        pdWrap.srNo = integer.valueof(rsoItem.Item_Number__c);//count;
                    }
                    else{
                        pdWrap.srNo = count;
                        count += counter;
                    }
                                        
                    pdWrap.recId = rsoItem.Id;
                    pdWrap.sorId = rsoItem.Return_Sales_Order__c;
                    pdWrap.invoiceItemId = rsoItem.Invoice_Line_Item__c;
                    pdWrap.invoiceId = rsoItem.Invoice__c;
                    pdWrap.batch = rsoItem.Batch__c;
                    pdWrap.currencyCode = rsoItem.Currency__c;
                    pdWrap.volume = rsoItem.Volumn_KG_LT__c;
                    pdWrap.unitValue = rsoItem.Unit_Value__c;
                    pdWrap.totalValue = rsoItem.Total_Value__c;
                    pdWrap.invoiceName = rsoItem.Invoice__r.Nota_Fiscal__c;
                    pdWrap.productName = rsoItem.SKU_Name__c;
                    Integer intgr = integer.valueOf(rsoItem.SKU_Code__c);
                    pdWrap.productCode = string.valueOf(intgr);//rsoItem.SKU_Code__c;
                    pdWrap.productDescription = string.valueOf(intgr)+'-'+rsoItem.SKU_Description__c;

                    if(rsoItem.Expire_Date__c != null){
                        pdWrap.expireDate = string.valueof(rsoItem.Expire_Date__c);
                    }
                    
                    pdWrap.atAG = rsoItem.AT_AG__c;
                    pdWrap.productDamage = rsoItem.Product_Damaged__c;
                    pdWrap.packagingCondition = rsoItem.Packing_Condition__c;
                    pdWrap.productCondition = rsoItem.Product_Condition__c;
                    pdWrap.comments = rsoItem.Comments__c;
                    pdWrap.slowMoving = rsoItem.Slow_Moving__c;
                    pdWrap.productContention = rsoItem.Product_Contention__c;
                    pdWrap.productRework = rsoItem.Product_can_be_reworked__c;
                    pdWrap.reworkCost = rsoItem.Rework_Cost__c;
                    pdWrap.writeOff = rsoItem.Write_Off__c;

                    pdWrap.billingDoc = rsoItem.Invoice__r.SAP_Billing_DOC__c;

                    if(rsoItem.Invoice__r.Billing_Date__c != null){
                        pdWrap.invoiceDate = string.valueOf(rsoItem.Invoice__r.Billing_Date__c);
                    }
                    pdWrap.incoTerm = 'FOB';//rsoItem.Invoice__r.Sales_Order__r.Inco_Term_Code__c; // hardcoded as per client request...

                    pdWrapList.add(pdWrap);

                    if(!idSet.contains(rsoItem.Invoice_Line_Item__c)){
                        idSet.add(rsoItem.Invoice_Line_Item__c);
                    }
                }
            }                                                    

        } catch(Exception e){
            System.debug('getSORItemList Exception is - '+ e.getMessage());
            System.debug('getSORItemList Exception at - '+ e.getLineNumber());
        }
        invItemIdList.addAll(idSet);
        return pdWrapList;
    }

    /*
    * @Description - This method will return invoice and product details from Invoice line item object.
    * @Param String - record id.
    * @return  - Wrapper object.
    */
    @AuraEnabled(cacheable=true)
    public static ProductDetailsWrapper getInvoiceProductDetails(String recId){
        ProductDetailsWrapper prodDetailsWrap = new ProductDetailsWrapper();
        try{
            if(recId != '' || recId != null){
                List<Invoice_Line_Item__c> invcItemList = [SELECT Id, Name, Invoice__c, Batch__c, Net_Value__c, 
                                                            Quantity__c, SKU__c, SKU_Code__c, SKU__r.Name, Status__c, 
                                                            Tax_Value__c, UOM__c, Sales_Order__c, Product_Name__c, 
                                                            Sales_Order_Line_Item__c, Invoice__r.Sales_Org__c, SKU__r.UOM__c,  
                                                            Invoice__r.Sold_To_Party__c, Invoice__r.CurrencyIsoCode, 
                                                            Invoice__r.Name, SKU__r.SKU_Description__c, Unit_Price__c, Expire_Date__c, 
                                                            Invoice__r.Nota_Fiscal__c    
                                                            FROM Invoice_Line_Item__c WHERE Id =: recId LIMIT 1];
                if(invcItemList.size()>0){
                    
                    //prodDetailsWrap.srNo = invcItemList[0].;
                    //prodDetailsWrap.recId = invcItemList[0].;
                    //prodDetailsWrap.sorId = invcItemList[0].;
                    prodDetailsWrap.accountId = invcItemList[0].Invoice__r.Sold_To_Party__c;
                    prodDetailsWrap.invoiceId = invcItemList[0].Invoice__c;
                    prodDetailsWrap.invoiceItemId = invcItemList[0].Id;
                    prodDetailsWrap.invoiceName = invcItemList[0].Invoice__r.Nota_Fiscal__c;
                    Integer intgr = integer.valueOf(invcItemList[0].SKU_Code__c);
                    prodDetailsWrap.productCode = string.valueOf(intgr);//invcItemList[0].SKU_Code__c;
                    prodDetailsWrap.productName = invcItemList[0].SKU__r.Name;
                    prodDetailsWrap.productDescription = string.valueOf(intgr) +'-'+ invcItemList[0].SKU__r.SKU_Description__c;
                    prodDetailsWrap.batch = invcItemList[0].Batch__c;
                    prodDetailsWrap.currencyCode = invcItemList[0].Invoice__r.CurrencyIsoCode;
                    prodDetailsWrap.uom = invcItemList[0].SKU__r.UOM__c;
                    //prodDetailsWrap.maxVolume = invcItemList[0].Quantity__c;
                    prodDetailsWrap.unitValue = invcItemList[0].Unit_Price__c;  

                    if(invcItemList[0].Expire_Date__c != null){
                        prodDetailsWrap.expireDate = string.valueof(invcItemList[0].Expire_Date__c);
                    }
                      
                    prodDetailsWrap.productRework = 'NA';
                    /* prodDetailsWrap.atAG = invcItemList[0].;
                    prodDetailsWrap.productDamage = invcItemList[0].;
                    prodDetailsWrap.packagingCondition = invcItemList[0].;
                    prodDetailsWrap.productCondition = invcItemList[0].;
                    prodDetailsWrap.comments = invcItemList[0].;
                    prodDetailsWrap.slowMoving = invcItemList[0].;
                    prodDetailsWrap.productContention = invcItemList[0].;
                    //prodDetailsWrap.productRework = invcItemList[0].;
                    prodDetailsWrap.reworkCost = invcItemList[0].;
                    prodDetailsWrap.writeOff = invcItemList[0].; */

                    /* List<AggregateResult> dec = [SELECT SUM(Volumn_KG_LT__c)aver FROM Return_Sales_Order_Line_Item__c 
                                                WHERE Invoice_Line_Item__c =: recId AND Return_Sales_Order__r.Order_Status__c NOT IN ('Rejected','Return Order Cancelled','Cancelled','Completely Rejected')];
                                                
                    Object sumAmount = dec[0].get('aver');
                    
                    if(sumAmount!=null){
                        prodDetailsWrap.maxVolume = integer.valueof(invcItemList[0].Quantity__c) - integer.valueof(sumAmount);
                    }
                    else{
                        prodDetailsWrap.maxVolume = invcItemList[0].Quantity__c;
                    } */
                    Map<String,Decimal> agrMap = SORProductDetailsChildController.getInvoiceItemAggregate(new List<String>{recId});
                    System.debug('agrMap is - '+ agrMap);
                    if(agrMap.size()>0){
                        prodDetailsWrap.maxVolume = agrMap.get(recId);//integer.valueof(invcItemList[0].Quantity__c) - integer.valueof(agrMap.get(recId));
                    }
                    else{
                        prodDetailsWrap.maxVolume = invcItemList[0].Quantity__c;
                    }
                    System.debug('prodDetailsWrap.maxVolume is - '+ prodDetailsWrap.maxVolume);
                }                
            }
        }
        catch(Exception e){
            System.debug('getInvoiceProductDetails Exception is - '+ e.getMessage());
            System.debug('getInvoiceProductDetails Exception at - '+ e.getLineNumber());
        }
        return prodDetailsWrap;
    }

    /*
    * @Description - This method will delete SOR item.
    * @Param String - record id.
    * @return  - String value.
    */
    @AuraEnabled
    public static string deleteRSOItem(String recId){
        String result = '';
        try{
            if(recId != '' || recId != null){
                DELETE [SELECT Id, Name FROM Return_Sales_Order_Line_Item__c WHERE Id=: recId];
                result = 'success';
            }
        }
        catch(Exception e){
            result = 'fail';
            System.debug('Exception is - '+ e.getMessage());
            System.debug('Exception at - '+ e.getLineNumber());
        }
        return result;
    }

    /*
    * @Description - This method will return map of aggregated value and invoice.
    * @Param List - invoice line item ids.
    * @return  - Map.
    */
    @AuraEnabled
    public static Map<String,Decimal> getInvoiceItemAggregate(List<String> invItemIds){
        Map<String,Decimal> aggregateMap = new Map<String,Decimal>();
        try{
            List<Invoice_Line_Item__c> itemList = [SELECT Id, Name, Quantity__c FROM Invoice_Line_Item__c WHERE ID IN: invItemIds];
            if(itemList.size()>0){
                for(Invoice_Line_Item__c invI : itemList){
                    if(!aggregateMap.containsKey(invI.Id)){
                        aggregateMap.put(invI.Id,invI.Quantity__c);
                    }
                }
            }

            List<AggregateResult> aggList = [SELECT SUM(Volumn_KG_LT__c)aver, Invoice_Line_Item__c FROM 
                                        Return_Sales_Order_Line_Item__c WHERE Invoice_Line_Item__c IN: invItemIds 
                                        AND Return_Sales_Order__r.Order_Status__c NOT IN ('Rejected','Return Order Cancelled','Cancelled','Completely Rejected','Draft') //Grazitti(Butesh Singla)- RITM0578826-28 june 2023
                                        GROUP BY Invoice_Line_Item__c ];

            if(aggList.size()>0){
                for(AggregateResult ar : aggList){
                    if(aggregateMap.containsKey((String)ar.get('Invoice_Line_Item__c'))){
                        Decimal intgr = (Decimal)ar.get('aver');
                        intgr = aggregateMap.get((String)ar.get('Invoice_Line_Item__c')) - intgr;
                        aggregateMap.put((String)ar.get('Invoice_Line_Item__c'),intgr);
                    }
                }
            }                            
        }
        catch(Exception e){
            System.debug('getInvoiceItemAggregate Exception is - '+ e.getMessage());
            System.debug('getInvoiceItemAggregate Exception at - '+ e.getLineNumber());
        }
        return aggregateMap;
    }

    /*
    * @Description - This method will return List of invoices which are marked as full return.
    * @Param String - Account id.
    * @return  - List of invoice id's.
    */
    @AuraEnabled
    public static List<String> getFullReturnInvoices(String accId){
        List<String> invoiceList = new List<String>();
        Set<String> csSet = new Set<String>();
        try{
            List<RSO_with_Customer_Service__c> csList = [SELECT Id, Name, Invoice__c, Invoice__r.Sold_To_Party__c, 
                                                        Full_Return__c FROM RSO_with_Customer_Service__c WHERE 
                                                        Full_Return__c = true AND Invoice__r.Sold_To_Party__c =: accId];
            if(csList.size()>0){
                for(RSO_with_Customer_Service__c cs : csList){
                    if(!csSet.contains(cs.Invoice__c)){
                        csSet.add(cs.Invoice__c);
                    }
                }
            }                                            
        }
        catch(Exception e){
            System.debug('getFullReturnInvoices Exception is - '+ e.getMessage());
            System.debug('getFullReturnInvoices Exception at - '+ e.getLineNumber());
        }
        invoiceList.addAll(csSet);
        return invoiceList;
    }

    public class ProductDetailsWrapper{
        @AuraEnabled public Integer srNo;
        @AuraEnabled public String recId;
        @AuraEnabled public String sorId;
        @AuraEnabled public String accountId;
        @AuraEnabled public String invoiceId;
        @AuraEnabled public String invoiceItemId;
        @AuraEnabled public String invoiceName;
        @AuraEnabled public String productCode;
        @AuraEnabled public String productName;
        @AuraEnabled public String productDescription;
        @AuraEnabled public String batch;
        @AuraEnabled public String currencyCode;
        @AuraEnabled public Decimal volume;
        @AuraEnabled public Decimal unitValue;
        @AuraEnabled public Decimal totalValue;
        @AuraEnabled public String expireDate;
        @AuraEnabled public String atAG;
        @AuraEnabled public String productDamage;
        @AuraEnabled public String packagingCondition;
        @AuraEnabled public String productCondition;
        @AuraEnabled public String comments;
        @AuraEnabled public String slowMoving;
        @AuraEnabled public String productContention;
        @AuraEnabled public String productRework;
        @AuraEnabled public Decimal reworkCost;
        @AuraEnabled public String writeOff;
        @AuraEnabled public String uom;
        @AuraEnabled public Decimal maxVolume;
        @AuraEnabled public Boolean isEdit;
        @AuraEnabled public String billingDoc;
        @AuraEnabled public String invoiceDate;
        @AuraEnabled public String incoTerm;
        
        public ProductDetailsWrapper(){
            srNo = 0;
            recId = '';
            sorId = '';
            accountId = '';
            invoiceId = '';
            invoiceItemId = '';
            invoiceName = '';
            productCode = '';
            productName = '';
            productDescription = '';
            batch = '';
            currencyCode = '';
            volume = 0;
            unitValue = 0;
            totalValue = 0;
            expireDate = string.valueof(System.today());
            atAG = '';
            productDamage = '';
            packagingCondition = '';
            productCondition = '';
            comments = '';
            slowMoving = '';
            productContention = '';
            productRework = '';
            reworkCost = 0;
            writeOff = '';
            uom = '';
            maxVolume = 0;
            isEdit = false;
            billingDoc = '';
            invoiceDate = '';
            incoTerm = '';
        }
        
    }
}