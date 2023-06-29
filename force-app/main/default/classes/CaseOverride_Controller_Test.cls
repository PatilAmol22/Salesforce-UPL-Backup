@istest public class CaseOverride_Controller_Test {
    
    static testMethod void CaseOverride_Controller(){
        string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();    
        string uplGeneralCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
        string Distributor = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
   
         User u2 = new User(
         ProfileId = [select id from profile where name ='Business Center Coordinator Colombia'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US',
         isActive = true
         );  
         insert u2;
        
        CaseOverride_Controller.getReordInformation('',caseRecordType,'');
        CaseOverride_Controller.getReordInformation('',uplGeneralCase,'');
            CaseOverride_Controller.getReordInformation('',Distributor,'');
        system.runAs(u2){
             CaseOverride_Controller.getReordInformation('',null,'');
        }
    }
}