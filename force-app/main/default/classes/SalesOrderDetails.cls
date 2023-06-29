/*  
  * Name: SalesOrderDetails    
  * Created On: 03rd Dec 2022
  * Author: Satish Tiware
  * Description: View Sales Order & SOLI Details on Approval Page Layout through custom hyperlink 'View Order'.
  */

public with sharing class SalesOrderDetails {
  /*
  * @Description  Fetching Sales order Details using respective Sales Order Id.
  * @Param        recordId 
  * @return       returns Sales Order Record Details
  */   
    @AuraEnabled(cacheable = true)
    public static Sales_Order__c getSalesOrderDetails(String recordId) {
        
        Sales_Order__c solist = [Select Id, Name, Sold_to_Party__r.Name, Total_Amount__c, Order_Status__c,
                                 Payment_Term__r.Payment_Term__c, OrderTypeCode__c, Remarks_Long__c,Ship_To_Party__r.Location_Name__c,
                                 PaymentMethod__r.Description__c,Inco_Term_Mexico__c,Discount_Percentage__c,Is_payment_Term_Changed__c,
                                 Gross_Margin_Percent__c,Sent_for_Latam_Director__c,Sent_for_CCO__c,CurrencyIsoCode
                                 From Sales_Order__C Where Id =: recordId LIMIT 1
                                ];
                                
        System.debug('List Of SO'+solist);
        System.debug('Loc Name'+solist.Ship_To_Party__r.Location_Name__c);
        return solist;
    }
    
    
  /*
  * @Description  Fetching Sales order Line Item Details using respective Sales Order Id.
  * @Param        recordId 
  * @return       returns Sales Order Line Item Details
  */
    @AuraEnabled(cacheable = true)
    public static wrapTotal getSOLIDetails(String recordId) {
        wrapTotal wrapTotoalObj = new wrapTotal();
        user userObj = [Select Id,Name from User 
                       where Id =:userinfo.getUserId() LIMIT 1];
        if(userObj.Name =='Farokh N. Hilloo'){
            wrapTotoalObj.isCOO = true;
        }else{
            wrapTotoalObj.isCOO = false;
        }
        
        
        List < Sales_Order_Line_Item__c > soliList = [Select Id, Net_Price__c,Sale_Order__c, Product__c, SKU_Name__r.SKU_Description__c,
                                                      MinPrice__c, MaxPrice__c, Quantity__c,
                                                      Contribution_Margin__c, Margin_Block_Level_1__c, Margin_Block_Level_2__c, 
                                                      Margin_Block_Level_3__c,Blanket_SKU_End_Date__c, Blanket_SKU_Start_Date__c, 
                                                      Blanket_SKU_Status__c, Contribution__c,
                                                      SKU_Net_Price__c, Sales_Deduction_Cal__c, E2E_Cost_Cal__c,
                                                      SKU_Name__r.Product_Name__r.MG_Desc__c,SKU_Name__r.SKU_Code__c,Base_UOM__c,Converted_Qty__c,
                                                      CurrencyIsoCode,Converted_Net_Price_USD__c,PLN_Value_USD__c,Type_of_Sale__c
                                                      From Sales_Order_Line_Item__c where Sale_Order__c =: recordId
                                                     ];
        List<wrapSalesOrderLine> wrpaList = new List<wrapSalesOrderLine>();
        if(soliList.size()>0){
            Decimal overContribution = 0;
            Decimal overSkuNetPrice = 0;
            Boolean marginBlockLevels=false;
            Boolean PromoGoods=false;
            for(Sales_Order_Line_Item__c tmpObj:soliList){
                wrapSalesOrderLine obj = new wrapSalesOrderLine();
                

                if(tmpObj.Type_of_Sale__c=='Promotion'){
                    PromoGoods=true;
                }else{
                    PromoGoods=false;
                }
                
                if(tmpObj.Margin_Block_Level_1__c || tmpObj.Margin_Block_Level_2__c || tmpObj.Margin_Block_Level_3__c){
                    obj.level = true;
                    marginBlockLevels = true;
                }else{
                    obj.level = false;
                }
                if(tmpObj.Blanket_SKU_Status__c && System.today()>=tmpObj.Blanket_SKU_Start_Date__c && System.today()<=tmpObj.Blanket_SKU_End_Date__c){
                    obj.skuExpriry=true;
                }else{
                    obj.skuExpriry=false;
                } 
                obj.skuName = tmpObj.SKU_Name__r.SKU_Description__c;               
                obj.netPrices = tmpObj.Converted_Net_Price_USD__c!=null?tmpObj.Converted_Net_Price_USD__c.setScale(2):null;
                obj.productName = tmpObj.Product__c;
                obj.minPrice =tmpObj.MinPrice__c!=null?tmpObj.MinPrice__c.setScale(2):null;
                obj.listPrice = tmpObj.MaxPrice__c!=null?tmpObj.MaxPrice__c.setScale(2):null;
                obj.Quantity = tmpObj.Quantity__c;
                obj.maxPrice = tmpObj.MaxPrice__c!=null?tmpObj.MaxPrice__c.setScale(2):null; 
                Obj.MGDesc = tmpObj.SKU_Name__r.Product_Name__r.MG_Desc__c;
                obj.SkuCode = tmpObj.SKU_Name__r.SKU_Code__c;
                obj.BaseUOM = tmpObj.Base_UOM__c;
                obj.BaseUOMQty = tmpObj.Converted_Qty__c;
                obj.Curr = tmpObj.CurrencyIsoCode;
                obj.NetPrice = tmpObj.Converted_Net_Price_USD__c;
                obj.PLNPrice = tmpObj.PLN_Value_USD__c;
                overContribution = overContribution + tmpObj.Contribution__c; 
                overSkuNetPrice = overSkuNetPrice + tmpObj.SKU_Net_Price__c; 
                obj.contributionMargin = tmpObj.Contribution_Margin__c;
                
                wrpaList.add(obj);	
            }
            
            
            Decimal overAllMargin = ((overContribution /overSkuNetPrice)*100).setScale(2);
            wrapTotoalObj.wrpaSaleOrder = wrpaList;
            wrapTotoalObj.overAllMargin = overAllMargin;
            wrapTotoalObj.marginBlockLevel = marginBlockLevels;
            wrapTotoalObj.PromoGood = PromoGoods;
            
        }
        
        
        return wrapTotoalObj;
    }
    
  /*
  * @Description  Fetching Last Approver Comment using respective Sales Order Id.
  * @Param        recordId 
  * @return       returns Last Approver Comment From ProcessInstanceStep Obj.
  */
    @AuraEnabled(cacheable = true)
    public static List < ProcessInstanceStep > getLastApproverComment(String recordId) {
        
        List < ProcessInstanceStep > commentList = new List < ProcessInstanceStep > ([SELECT Comments FROM ProcessInstanceStep
                                                                                      WHERE ProcessInstance.TargetObjectId =: recordId
                                                                                      ORDER BY SystemModStamp DESC LIMIT 1
                                                                                     ]);
        
        return commentList;
        
    }
    
    public class wrapTotal{
        @auraEnabled
        public List<wrapSalesOrderLine> wrpaSaleOrder{get;set;}
        @auraEnabled
        public decimal overAllMargin {get;set;}
        @auraEnabled
        public Boolean marginBlockLevel {get;set;}
        @auraEnabled
        public Boolean isCOO {get;set;}
        @auraEnabled
        public Boolean PromoGood {get;set;}
        
        public wrapTotal(){
            marginBlockLevel=false;
            PromoGood=false;
            //isCOO = false;
        }
        
        
    }
    
    
    public class wrapSalesOrderLine{	  
        
        @auraEnabled
        public String productName {get;set;}
        
        @auraEnabled
        public String skuName {get;set;}
        
        
        @auraEnabled
        public Decimal minPrice {get;set;}
        
        @auraEnabled
        public Decimal listPrice {get;set;}  
        
        
        @auraEnabled
        public Decimal Quantity {get;set;}
        
        @auraEnabled
        public Decimal maxPrice {get;set;}
        
        @auraEnabled
        public Decimal netPrices {get;set;}  
        
        
        @auraEnabled
        public Decimal contributionMargin {get;set;}
        
        @auraEnabled
        public Boolean skuExpriry {get;set;}
        
        @auraEnabled
        public Boolean level {get;set;}
  

        @auraEnabled
        public String MGDesc {get;set;}

        @auraEnabled
        public String SkuCode {get;set;}

        @auraEnabled
        public String BaseUOM {get;set;}

        @auraEnabled
        public Decimal BaseUOMQty {get;set;}

        @auraEnabled
        public String Curr {get;set;}

        @auraEnabled
        public Decimal NetPrice {get;set;}

        @auraEnabled
        public Decimal PLNPrice {get;set;}


        
        
        public wrapSalesOrderLine(){
            
        }
        
    }
    
}