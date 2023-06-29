@isTest
public class DistributorDocumentTest {
    public static TestMethod void testmethod1(){
        
        
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Price_Group_Master__c PGObj = new Price_Group_Master__c();
        PGObj.PG_Code__c ='PG001';
        insert PGObj;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        
        Account act = new Account();
        act.RecordTypeId = recordTypeId;
        //act.FirstName='TEst';
        act.First_Name__c='TEst';
        act.Name='TestAccount';
        //act.LastName='test';
        act.Last_Name__c='Test';
        act.PriceGroupCode__c=PGObj.Id;
        act.CurrencyIsoCode='INR';
        act.Mobile__c='9874584857';
        insert act;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(act);
        DistributorDocument disObj = new DistributorDocument(sc);
        
        DistributorDocument__c dcObj = new DistributorDocument__c();
        dcObj.Document_Name__c='Test';
        dcObj.Distributor__c=act.Id;
        dcObj.Description__c='test';
        //dcObj.Document_List__c='PAN Card copy';
        insert dcObj;
        
        disObj.docObj=dcObj;
        disObj.UploadFile();
    }
    public static TestMethod void testmethod2(){
        
        
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Price_Group_Master__c PGObj = new Price_Group_Master__c();
        PGObj.PG_Code__c ='PG001';
        insert PGObj;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        
        Account act = new Account();
        act.RecordTypeId = recordTypeId;
        //act.FirstName='TEst';
        act.First_Name__c='TEst';
        //act.LastName='test';
        act.Name='TestAccount';
        act.Last_Name__c='Test';
        act.PriceGroupCode__c=PGObj.Id;
        act.CurrencyIsoCode='INR';
        act.Mobile__c='9874584857';
        insert act;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(act);
        DistributorDocument disObj = new DistributorDocument(sc);
        
        DistributorDocument__c dcObj = new DistributorDocument__c();
        dcObj.Document_Name__c='Test';
        dcObj.Distributor__c=act.Id;
        dcObj.Description__c='test';
        dcObj.Document_List__c='PAN Card copy';
        insert dcObj;
        
        disObj.docObj=dcObj;
        disObj.UploadFile();
    }
    public static TestMethod void testmethod3(){
        
        
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Price_Group_Master__c PGObj = new Price_Group_Master__c();
        PGObj.PG_Code__c ='PG001';
        insert PGObj;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        
          Account act = new Account();
        act.RecordTypeId = recordTypeId;
        //act.FirstName='TEst';
        act.First_Name__c='TEst';
       // act.LastName='test';
        act.Name='TestAccount';
        act.Last_Name__c='Test';
        act.PriceGroupCode__c=PGObj.Id;
        act.CurrencyIsoCode='INR';
        act.Mobile__c='9874584857';
        insert act;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(act);
        DistributorDocument disObj = new DistributorDocument(sc);
        disObj.fname='Filename';
        DistributorDocument__c dcObj = new DistributorDocument__c();
        dcObj.Document_Name__c='Test';
        dcObj.Distributor__c=act.Id;
        dcObj.Description__c='test';
        dcObj.Document_List__c='PAN Card copy';
        insert dcObj;
        
        Attachment attach=new Attachment();     
        attach.Name= disObj.fname;
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=dcObj.id; 
        attach.Description = dcObj.Description__c;
        insert attach;
        
        disObj.BlobFileValue=attach.Body;
        disObj.fname=attach.name;
        disObj.AcntId=act.id;
        disObj.docObj.Document_List__c=dcObj.Document_List__c;
        disObj.docObj.Description__c=dcObj.Description__c;
        
        //disObj.docObj=dcObj;
        
        disObj.UploadFile();
    }
        public static TestMethod void testmethod4(){
        
        
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Price_Group_Master__c PGObj = new Price_Group_Master__c();
        PGObj.PG_Code__c ='PG001';
        insert PGObj;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Account act = new Account();
        act.RecordTypeId = recordTypeId;
        //act.FirstName='TEst';
        act.First_Name__c='TEst';
       // act.LastName='test';
        act.Name='TestAccount';
        act.Last_Name__c='Test';
        act.PriceGroupCode__c=PGObj.Id;
        act.CurrencyIsoCode='INR';
        act.Mobile__c='9874584857';
        insert act;
            
        ApexPages.StandardController sc = new ApexPages.StandardController(act);
        DistributorDocument disObj = new DistributorDocument(sc);
        disObj.fname='Filename';
        DistributorDocument__c dcObj = new DistributorDocument__c();
        dcObj.Document_Name__c='Test';
        dcObj.Distributor__c=act.Id;
        dcObj.Description__c='test';
        dcObj.Document_List__c='PAN Card copy';
        insert dcObj;
        
        Attachment attach=new Attachment();     
        attach.Name= disObj.fname;
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=dcObj.id; 
        attach.Description = dcObj.Description__c;
        insert attach;
        
        disObj.BlobFileValue=attach.Body;
        disObj.fname=attach.name;
        disObj.AcntId=act.id;
        disObj.docObj.Document_List__c=dcObj.Document_List__c;
        disObj.docObj.Description__c=dcObj.Description__c;
        
        disObj.docObj=dcObj;
        
        disObj.UploadFile();
    }
}