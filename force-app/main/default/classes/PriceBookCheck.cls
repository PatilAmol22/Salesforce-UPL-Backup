Public Class PriceBookCheck{

    public Account acc {get;set;}
    public Boolean isPricebookApplied {get; set;}

    public PriceBookCheck(ApexPages.StandardController controller) {
        acc  = (Account)controller.getRecord();
        
        List<PriceBookMaster__c> listPricebook = [SELECT id, StartDate__c, EndDate__c,Sales_Org_Code__c, DistributorCustomerCode__c FROM PriceBookMaster__c WHERE DistributorCustomerCode__c =: acc.Id AND StartDate__c <= Today AND EndDate__c >= Today];
             
        if(listPriceBook.size() > 0){
            isPricebookApplied = true;
        }else{
            isPricebookApplied = false;
        }
    }
}