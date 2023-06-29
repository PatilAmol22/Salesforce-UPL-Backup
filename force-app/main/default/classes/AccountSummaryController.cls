public class AccountSummaryController{
public List<CustomerTransaction__c> customerTransList{get;set;}
public String AccId {get;set;}
public Decimal TotalCr{get;set;}
public Decimal TotalDr{get;set;}
public String CustName{get;set;}
public String CustSAPcode{get;set;}
 public AccountSummaryController(ApexPages.StandardController stdController){
     
     try{
     TotalCr =0;
     TotalDr =0;
     CustName ='';CustSAPcode='';
     system.debug('AccId-->'+ApexPages.currentPage().getParameters().get('AccId') );
    // String s = ApexPages.currentPage().getParameters().get('AccId');
   //  AccId = [SELECT Id,Account__c from Account_Statement__c where id=:s][0].Account__c;
    AccId = ApexPages.currentPage().getParameters().get('AccId');
     customerTransList = new List<CustomerTransaction__c>();
     customerTransList = [SELECT Id,DocType__c,Customer__r.name,Customer__r.SAP_Code__c,PostingDate__c,DocNumber__c, Customer__c, Amount__c, Status__c, CreatedDate FROM CustomerTransaction__c where Customer__c=:AccId];
     if(customerTransList.size()>0){
         CustName = customerTransList[0].Customer__r.name; 
         CustSAPcode =customerTransList[0].Customer__r.SAP_Code__c; 
     }
     }catch(Exception e){
         System.debug('Error : '+e);
     }
 }

}