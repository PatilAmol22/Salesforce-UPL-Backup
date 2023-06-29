/*
* Name: SOMBalanceController
* Created On: 29 December 2017
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Lightning Component Apex Controller used for SOM Balance (Brazil Order Module)
* Supporting Classes: Refer ApexLog Class for Exception Handling Method.
*/
public without sharing class SOMBalanceController {
    
    @AuraEnabled
    public static List<SOMBalance> getSOMBalance(String recordId){
        List<SOMBalance> balanceList = new List<SOMBalance>();
        try{
            System.debug('getSOMBalance recordId: '+recordId);
            //Get SOM Balance quantity of Line Items for the Mother Order
            List<Sales_Order_Line_Item__c> salesOrderItemList = [SELECT ID, SKU_Name__c, SKU_Name__r.SKU_Description__c, 
                                                                 Quantity__c
                                                                 FROM Sales_Order_Line_Item__c
                                                                 WHERE Sale_Order__c=:recordId];
            
            Map<Id,Sales_Order_Line_Item__c> soiMap = new Map<Id,Sales_Order_Line_Item__c>();
            Map<Id, SOMBalance> balanceMap = new Map<Id, SOMBalance>();
            for(Sales_Order_Line_Item__c soiObj:salesOrderItemList){
                SOMBalance balObj = new SOMBalance();
                balObj.productId = soiObj.SKU_Name__c;
                balObj.product = soiObj.SKU_Name__r.SKU_Description__c;
                balObj.quantity = soiObj.Quantity__c;
                balObj.balance = soiObj.Quantity__c;
                balObj.percent = ((balObj.balance / balObj.quantity) *100).setScale(2);
                balanceMap.put(soiObj.Id, balObj);
                soiMap.put(soiObj.Id, soiObj);
            }
            
            System.debug('recordId: '+recordId);
            
            AggregateResult[] groupedResults = [SELECT SKU_Name__c, SKU_Name__r.SKU_Description__c, 
                                                SUM(Quantity__c) used, Sales_Order_Line_Item__c
                                                FROM Sales_Order_Line_Item__c
                                                WHERE Sale_Order__r.Sales_Order__c=:recordId 
                                                AND Sale_Order__r.BrazilSalesOrderStatus__c!='Cancelled' 
                                                AND Sale_Order__r.BrazilSalesOrderStatus__c!='Cancelado'
                                                AND Sale_Order__r.BrazilSalesOrderStatus__c!='Draft'
                                                GROUP BY SKU_Name__c, SKU_Name__r.SKU_Description__c, Sales_Order_Line_Item__c];
            
            System.debug('groupedResults: '+groupedResults);
            
            for(AggregateResult ar : groupedResults){
                String skuName = String.valueOf(ar.get('Sales_Order_Line_Item__c'));
                if(soiMap.containsKey(skuName)){
                    SOMBalance balObj = new SOMBalance();
                    balObj.productId = String.valueOf(ar.get('SKU_Name__c'));
                    balObj.product = String.valueOf(ar.get('SKU_Description__c'));
                    balObj.quantity = soiMap.get(String.valueOf(ar.get('Sales_Order_Line_Item__c'))).Quantity__c;
                    balObj.used = Decimal.valueOf(String.valueOf(ar.get('used')));
                    balObj.balance = Math.abs(balObj.quantity - balObj.used);
                    balObj.percent = (Math.abs(balObj.balance / balObj.quantity) *100).setScale(2);
                    balanceMap.put(String.valueOf(ar.get('Sales_Order_Line_Item__c')), balObj);
                }
            }
            System.debug('balanceMap: '+balanceMap);
            
            if(!balanceMap.isEmpty()){
                
                List<Sales_Order_Line_Item__c> socItemList = [SELECT Id, Sale_Order__r.SalesOrderNumber_Brazil__c, SKU_Name__c, Sale_Order__c,
                                                              SKU_Name__r.SKU_Description__c, Quantity__c, Sales_Order_Line_Item__c
                                                              FROM Sales_Order_Line_Item__c
                                                              WHERE Sale_Order__r.Sales_Order__c=:recordId 
                                                              AND Sale_Order__r.BrazilSalesOrderStatus__c!='Cancelled' 
                                                              AND Sale_Order__r.BrazilSalesOrderStatus__c!='Cancelado'
                                                              AND Sale_Order__r.BrazilSalesOrderStatus__c!='Draft'];
                
                for(Sales_Order_Line_Item__c soiObj : socItemList){
                    if(balanceMap.containsKey(soiObj.Sales_Order_Line_Item__c)){
                        SOMBalance socObj = new SOMBalance();
                        socObj.productId = soiObj.Sale_Order__c;
                        socObj.product = 'SOC:'+soiObj.Sale_Order__r.SalesOrderNumber_Brazil__c;
                        socObj.balance = soiObj.Quantity__c;
                        
                        SOMBalance balObj = balanceMap.get(soiObj.Sales_Order_Line_Item__c);
                        balObj.socList.add(socObj);
                        System.debug('socObj: '+socObj);
                        balanceMap.put(soiObj.Sales_Order_Line_Item__c, balObj);
                    }
                }
                balanceList.addAll(balanceMap.values());
            }
        }
        catch(Exception ex){
            System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage());
            ApexLog.exceptionHandlerBrazil(ex, '', null, '');
        }
        return balanceList;
    }
    
    public class SOMBalance{
        @AuraEnabled public String productId;
        @AuraEnabled public String product;
        @AuraEnabled public Decimal quantity;
        @AuraEnabled public Decimal used;
        @AuraEnabled public Decimal balance;
        @AuraEnabled public Decimal percent;
        @AuraEnabled public List<SOMBalance> socList;
        
        public SOMBalance(){
            product = '';
            quantity = 0;
            balance = 0;
            percent = 0;
            used = 0;
            socList = new List<SOMBalance>();
        }
    }    
}