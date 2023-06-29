public class CasePDFController {

   
    public String selectedIDs{get;set;}
    public Case cPDF{get;set;}
    //public String punctuality{get;set;}
    //public List<Sales_Order_Line_Item__c> solPDF{get;set;}
    Public datetime now {get;set;}
    public String dateStr {get;set;}
    //Public String CNPG_CPF {get;set;}
    
        public CasePDFController(ApexPages.StandardController stdController){
        
        now = system.today();
        dateStr =now.format();
        
        //getting recordId from component
        selectedIDs=ApexPages.CurrentPage().getParameters().get('id');
        system.debug('Selected Record ID '+selectedIDs);
        
        
        system.debug('userinfo'+userinfo.getLocale()+'language'+userinfo.getLanguage());
        //retrieving value from case 
        /*cPDF = [SELECT id,AccountId,CaseNumber,Comments,Record_type__c FROM Case WHERE Record_Type__c = 'Mexico Distributor' and
                 Id =: selectedIDs];*/
        
        cPDF = [SELECT id,Priority,CaseNumber, Record_Type__c,Account.Name, SAP_Code__c,OpenNewEscalationDateTime__c,Approval_Submitted_Date__c,
        Segmentation__c,Origin__c,Type,Status, Subject,Source.Name,Origin, EmailForCaseCreate__c,SuppliedEmail, Description,
        Contact.Name,CreatedBy.Name,Reason_for_Closure__c, LastModifiedBy.Name,Owner.Name FROM Case WHERE Record_Type__c = 'Mexico Distributor' and
                 Id =: selectedIDs]; 
                 
                  
 
    }
    
  /*  public PageReference generatePDF(){
         PageReference reference = new PageReference('/apex/caseDownloadPDF?from='+selectedIDs); 
         reference.setRedirect(true);
         return(reference);
    }*/
    
    
    
    
}