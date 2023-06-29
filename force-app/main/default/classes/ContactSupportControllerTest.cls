@isTest
public class ContactSupportControllerTest {
    static testMethod void test(){
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
        User cu5 = new User(Alias = 'standt', Email='cu@gmail.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = prof2.Id, ContactId= c.Id, Country='Colombia',
        TimeZoneSidKey='America/Los_Angeles', UserName='cu2@gmail.com');
		insert cu5;
        
        ContentVersion cv=new Contentversion();
        cv.title='ABC';
        cv.PathOnClient ='test';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert cv;
        
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        Id docid=contentVersionSelect.ContentDocumentId;
        String subject='Test';
        String Description='Test';
        
        System.runAs(cu5){
            ContactSupportController.sendMail(docid, subject, description);
        }
    }
}