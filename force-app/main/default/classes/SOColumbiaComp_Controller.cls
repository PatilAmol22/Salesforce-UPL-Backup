public class SOColumbiaComp_Controller {
    
    public String selectedId {get;set;}
    public String salesOrgCode {get;set;}
    public Boolean EnableNewPage {get;set;}//RITM0196538: Added by Sayan for the new Italy Page
    
    public SOColumbiaComp_Controller(Apexpages.Standardsetcontroller cont){
        System.debug('SalesOrgCode');
        String recordId = ApexPages.currentpage().getparameters().get('recordId');    
        if( String.isNotBlank(recordId)){
            selectedId = recordId;
            Account Acc = [Select Id, Sales_Org_Code__c From Account Where Id =: selectedId];
            
            salesOrgCode = Acc.Sales_Org_Code__c;
            System.debug('SalesOrgCode: '+SalesOrgCode);
            
        }
        else{
            salesOrgCode='0000';
            System.debug('SalesOrgCode'+SalesOrgCode);
        }
    }
    //Modified by Deeksha : For full screen
    @AuraEnabled
    public static DistributorWrapper getAccountData(String recordId){
        Account Acc = [Select Id, Sales_Org_Code__c, Price_Group_Code__c From Account Where Id =: recordId];
        DistributorWrapper distributor = new DistributorWrapper();
        distributor.soCode = Acc.Sales_Org_Code__c;
        distributor.pgCode = Acc.Price_Group_Code__c;//Sayan
        return distributor;
    }
    
    public class DistributorWrapper{ 
        @AuraEnabled   public String soCode;
        @AuraEnabled   public Boolean enabledNewPage;
        @AuraEnabled   public String pgCode;//Sayan
    }
    //END :Modified by Deeksha : For full screen
}