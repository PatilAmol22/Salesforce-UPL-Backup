public class BrazilSalesOrderTaxAndFreightUpdate {
     public  static void BeforeUpdateMyMethod(List<Sales_Order__c> newSalesOrderList){
            
         
         List<String> cRNames = new List<String>();
         Set<Id> setIds=new Set<Id>();
         Map<Id, Sales_Order__c> salesOrderNewMap = new Map<Id, Sales_Order__c>();
        
        for(Sales_Order__c c : newSalesOrderList){
            
             if((c.Customer_Region_SoldToParty__c != null && c.SalesOrgCode__c=='5191'))  
                {
                    cRNames.add(c.Customer_Region_SoldToParty__c);
                }
        }
            Map<String, Business_Rule__c> entries = new Map<String, Business_Rule__c>();  
             if(cRNames.size()>0 && !cRNames.isEmpty() && cRNames != null){
              for(Business_Rule__c c : [SELECT Id,Name,Freight__c,Taxes__c FROM Business_Rule__c WHERE Name IN :cRNames]){
                  entries.put(c.Name, c);
             }  
                 }
        
        System.debug('@@@@@'+entries);
        if(entries != null && entries.size() > 0 && !entries.isEmpty())
        {
            for(Sales_Order__c c : newSalesOrderList){   
                 if(c.Customer_Region_SoldToParty__c != null){
                           c.Tax__c = entries.get(c.Customer_Region_SoldToParty__c).Taxes__c; 
                           c.Freight__c = entries.get(c.Customer_Region_SoldToParty__c).Freight__c;
                           c.Tax_BrazilSalesOrder__c = entries.get(c.Customer_Region_SoldToParty__c).Taxes__c; 
                           c.Freight_BrazilSalesOrder__c = entries.get(c.Customer_Region_SoldToParty__c).Freight__c;
                           
              }
            }
        }
                    

           
    }  
      
}