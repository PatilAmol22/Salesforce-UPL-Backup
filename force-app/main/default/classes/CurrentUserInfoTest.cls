@isTest
public class CurrentUserInfoTest {
    
    static testmethod void test(){
                
        //User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account a=new Account();
        a.RecordTypeId=recordTypeId;
        a.Name='test';
        a.CurrencyIsoCode='COP';
        a.Mobile__c='9898989898';
        insert a;
        
        Contact c=new Contact();
        c.FirstName='test';
        c.LastName='test';
		c.AccountId=a.Id;        
        insert c;
         
        Profile prof = [select id from profile where name = 'Customer Community Plus User - Colombia'];    
        User u = new User(Alias = 'standt', Email='paresh@gmail.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = prof.Id, ContactId= c.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='paresh@gmail.com');
		insert u;
        
        System.runAs(u){
      	 	Test.startTest();
       		CurrentUserInfo.getUserInfo();
        	Test.stopTest();                   
        }                        
    } 
}