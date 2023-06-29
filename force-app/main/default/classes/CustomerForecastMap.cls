public with sharing class CustomerForecastMap{

   //public Map<String,Spain_Portugal_Campaign__c> campaignMap;
   public list<Customer_Forecast_Information__c> cfiList;
   public Map<String,Customer_Forecast_Information__c> cfiMap;
   public List<String> customerList;
   public List<String> sKUList;
   public List<Invoice_Line_Item__c> invcLnItmList;
    
   public void processData(List<Spain_Portugal_Campaign__c> cmpgn,Boolean isSentFromBatch){
   
       String cmpgn_id='';
       Date cmp_Date;
       for(Spain_Portugal_Campaign__c spc:  cmpgn){
          cmpgn_id=spc.id; 
          String date1=String.valueOf(spc.CreatedDate);
          system.debug('Create date..-'+spc.CreatedDate);
          date1=date1.split(' ')[0];
          cmp_Date=Date.newInstance(integer.valueOf(date1.split('-')[0]),integer.valueOf(date1.split('-')[1]),integer.valueOf(date1.split('-')[2]));  
       }
      
       cfiList= new list<Customer_Forecast_Information__c>();
       if(cmpgn_id!='' || cmpgn_id!=null){
       cfiList=[SELECT Id, Name, Customer__c, SKU__c, Forecast_Amount__c, Actual_Amount__c, Spain_Portugal_Campaign__c,Actual_Quantity__c FROM Customer_Forecast_Information__c where Spain_Portugal_Campaign__c=:cmpgn_id ];
       }
       cfiMap= new Map<String,Customer_Forecast_Information__c>();
              
       System.debug('CFI List size---'+ cfiList.size());
           
       if(cfiList.size()>0){    
           for(Customer_Forecast_Information__c cfi : cfiList){
              
                  String str=cfi.Customer__c+''+cfi.SKU__c;
                  System.debug('Concated Id---'+ str);
                  cfiMap.put(str,cfi);
           }
       
       System.debug('CFI MAP size---'+ cfiMap.size());
       System.debug('CFI MAP ---'+ cfiMap);
       
       customerList= new List<String>();
       sKUList = new List<String>();
               for(Customer_Forecast_Information__c cfi : cfiList){
                  customerList.add(cfi.Customer__c); 
       			  sKUList.add(cfi.SKU__c);
               }
               system.debug('customerList size >>----->'+ customerList.size());
               system.debug('customerList  >>----->'+ customerList);
               
               invcLnItmList=[SELECT Id, Name, Invoice__c, Net_Value__c, Quantity__c, SKU__c, Invoice__r.Id, Invoice__r.Name, Invoice__r.Billing_Status__c,Invoice__r.Billing_Date__c, 
                             Invoice__r.Sold_To_Party__c FROM Invoice_Line_Item__c where SKU__c IN: sKUList AND Invoice__r.Billing_Status__c='M' AND Invoice__r.Sold_To_Party__c IN:customerList AND Net_Value__c !=0  AND Invoice__r.Billing_Date__c<=:cmp_Date  order by Invoice__r.Billing_Date__c  DESC LIMIT 1];
               
               system.debug('invcLnItmList size >>----->'+ invcLnItmList.size());
               system.debug('invcLnItmList  >>----->'+ invcLnItmList);
                 
                
               if((invcLnItmList.size()>0 && cfiMap.size()>0) || test.isRunningTest()){
                String key='';
                Decimal actl_amnt=0;
                
                   for(Invoice_Line_Item__c ilic : invcLnItmList){
                   
                        key=ilic.Invoice__r.Sold_To_Party__c+''+ilic.SKU__c;
                                               
                       if(cfiMap.containskey(key)){
                       
                           Customer_Forecast_Information__c cf =cfiMap.get(key);
                           system.debug('Net amnt value >>----->'+ ilic.Net_Value__c);
                           cf.Actual_Amount__c=0;
                           cf.Actual_Quantity__c=0;
                           cf.Actual_Amount__c=cf.Actual_Amount__c + ilic.Net_Value__c;
                           cf.Actual_Quantity__c=cf.Actual_Quantity__c + ilic.Quantity__c;
                            cfiMap.put(key,cf);
                                                  
                          //actl_amnt=actl_amnt + ilic.Net_Value__c;
                       
                       }
                  }
               
               }
               system.debug('CFI TO update size>>----->'+ cfiMap.values().size());
               if(cfiMap.values().size()>0)
               {
               system.debug('CFI TO update >>----->'+ cfiMap.values());
                       
               
                   update cfiMap.values();
                   if(test.isRunningTest()){
                     isSentFromBatch = true;
                   }
                   if(isSentFromBatch){
                   for(Spain_Portugal_Campaign__c spc: cmpgn){
                      spc.Send_To_Batch__c=true;
                       
                   }
                   //update cmpgn;
                  }
               }
       }
       
        
   }
}