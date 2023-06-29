@isTest
public class ContactDetailControllerTest {
    static testMethod void test(){
        /*
        Profile prof1 = [select id from profile where name = 'System Administrator'];
        User cu1 = new User(Alias = 'standt', Email='cu1@gmail.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = prof1.Id, Country='Colombia', MobilePhone='8899334455',
        TimeZoneSidKey='America/Los_Angeles', UserName='cu1@gmail.com');
		insert cu1;
		*/
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account a=new Account();
        a.RecordTypeId=recordTypeId;
        a.Name='test';
        a.CurrencyIsoCode='COP';
        a.Mobile__c='9898989898';
        //a.OwnerId=cu1.Id;
        insert a;
        
        Contact c=new Contact();
        c.FirstName='test';
        c.LastName='test';
		c.AccountId=a.Id;        
        insert c;
        
        Profile prof2 = [select id from profile where name = 'Customer Community Plus User - Colombia'];
        User cu = new User(Alias = 'standt', Email='cu@gmail.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = prof2.Id, ContactId= c.Id, Country='Poland',
        TimeZoneSidKey='America/Los_Angeles', UserName='cu3@gmail.com');
		insert cu;
        
        System.runAs(cu){
            ContactDetailController.getDetail();
        }
    }
}