public class UpdateUSDRateOnPBBatchClass implements Database.batchable<sObject>{ 

    public Database.QueryLocator start(Database.BatchableContext BC){
        String Query='select Id,USD_Rate__c from Price_Book__c where USD_Rate__c = null';
       return Database.getQueryLocator(query);
    }     
    public void execute(Database.BatchableContext info, List<Price_Book__c> scope){
       List<Price_Book__c> lstPBNew = [select Id,USD_Rate__c,(Select Id,CreatedDate,Unit_Price_R__c,Unit_Price_U__c from Price_Book_Details__r where Unit_Price_R__c != 0 AND Unit_Price_U__c != 0 Order by CreatedDate DESC limit 1) from Price_Book__c where Id IN: scope];
       if(lstPBNew.size() > 0)
       {
           for(Price_Book__c obPB : lstPBNew)
           {
               if(obPB.Price_Book_Details__r.size() > 0)
               {
                   for(Price_Book_Details__c obM : obPB.Price_Book_Details__r)
                   {
                       if(obM.Unit_Price_R__c != null && obM.Unit_Price_U__c != null)
                       {
                           obPB.USD_Rate__c = (obM.Unit_Price_R__c/obM.Unit_Price_U__c).setScale(2);
                       }
                   }
               }
           }
           update lstPBNew;
       }
   }     
    public void finish(Database.BatchableContext info){     
    } 
 }