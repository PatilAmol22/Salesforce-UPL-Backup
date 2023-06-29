@isTest
public class SalesAreaTriggerTest {
     static testmethod void method1(){
   User u2 = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
         );  
         insert u2;
          Account accObj = new account();
        accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        accObj.Mobile__c ='9967341750';
        accObj.Email__c = 'bhavik@gmail.com';
      
        accObj.Depot_Code__c = 'PUN';
        accObj.Name = 'Bhavik';
        insert accObj;
        
          User u3 = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
         LastName = 'last3',
         Email = 'puser000@amamama123.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST1',
         Title = 'title1',
         Alias = 'alias1',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
         );  
         insert u3;
         
           User u4 = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
         LastName = 'last3',
         Email = 'puser000@amamama1234.com',
         Username = 'puser000@ama2mama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST2',
         Title = 'title2',
         Alias = 'alias1',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
         );  
         insert u4;
         system.runAs(u2){
             
DistributorSalesAreaMapping__c SalesArea=new DistributorSalesAreaMapping__c();
         SalesArea.Distributor__c=accObj.id;
             SalesArea.AccountOwner__c=u3.id;
             insert SalesArea;
              SalesArea.AccountOwner__c=u4.id;
             update SalesArea;
         }
     }
}