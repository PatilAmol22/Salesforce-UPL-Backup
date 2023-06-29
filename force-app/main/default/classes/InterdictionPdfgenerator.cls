/*
@Author: Pragati Sharma   For APPS-3648
@Class_Description : pdf controller for Interdiction Process record.
*/ 
public class InterdictionPdfgenerator {
    private final Interdiction_Process__c  ipc;
   
    public InterdictionPdfgenerator(ApexPages.StandardController stdController) {
        this.ipc = (Interdiction_Process__c )stdController.getRecord();
    }
      public  List<Interdiction_Product__c> getProduct() {
       
       List<Interdiction_Product__c >  prodList = [Select id,Name,Batch__c,Quantity__c,Expire_Date__c,Interdiction_Process__c from Interdiction_Product__c where Interdiction_Process__c=:ipc.Id ];
              
       
        return prodList;
       
    }
    
    

}