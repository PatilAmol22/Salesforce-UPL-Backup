@isTest
public class CasePDFController_Test {
    
    
   Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
   public static testMethod void test2(){
      
       
       Profile pr = new Profile(name = 'Admin/KeyUser Mexico');
        Profile prof = [select id from profile where name='Admin/KeyUser Mexico'];
       
        
       User usr = new User(LastName = 'Kr',
                           FirstName='Su',
                           Alias = 'Sujin',
                           Email = 'abc@sfdc.com',
                           Username = 'sujinkrishnnan2908199311123@sfdc.com',
                           ProfileId = prof.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           ); 
       
       system.runAs(usr){
  
      Account acc = new account();
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        acc.Name='test';
       // acc.LastName='Test';
        //acc.Last_Name__c='test';
        
        //acc.PersonEmail='test@gmail.com';
        acc.Phone='1010101004';
        acc.WRMS_Code__c='1223';
        acc.BillingStreet='test';
        acc.BillingCity='test';
        acc.BillingState='test';
        acc.BillingPostalCode='test';
        acc.BillingCountry='test';
       // acc.Decision_Maker__pc = 'Yes';
        acc.Birthday_Specified__c = 'No';
        acc.Using_Smart_Phone__c = 'No';

        insert acc; 
 
        Case caseObj = new Case();
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Mexico Distributor').getRecordTypeId();
        caseObj.Status = 'New';
        caseObj.AccountId = acc.Id;
        caseObj.Type = 'Account Ledger';
        caseObj.Subject = 'test';
        caseObj.Description = 'test';
        insert caseObj;
           
        //for case PDF Test Coverage
        ApexPages.CurrentPage().getParameters().put('id',caseObj.Id);
        ApexPages.StandardController sc = new ApexPages.standardController(caseObj);
        CasePDFController cPDF = new CasePDFController(sc);
 
        }
    } 
}