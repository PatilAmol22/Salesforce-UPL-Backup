@isTest
public class KYCInformation_Test{
    @isTest
    public static void testKycInfo(){
        //Cover If...
        Id AccDistributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account acc = new Account();
        acc.name= 'Test Account For code coverage';
        acc.Mobile__c = '9530790243';
        acc.recordtypeId= AccDistributorRecordTypeId ;
        insert acc;
        
        Id surveykycRecordTypeId = Schema.SObjectType.Axedasurvey__c.getRecordTypeInfosByName().get('Channel Partner KYC').getRecordTypeId();
        Axedasurvey__c s = new Axedasurvey__c();
        s.Account__c = acc.Id;
        s.Customer_Fisrt_Name__c = 'Test first name';
        s.Customer_e_mail_Address__c ='test@gmail.com';
        s.Customer_Last_Name__c = 'Test Last Name';
        s.recordtypeId= surveykycRecordTypeId ;
        Insert s;
        KYCInformation.getKYCList(acc.Id ,s.Id);
        
        //cover else..
        Axedasurvey__c ss = new Axedasurvey__c();
        ss.Account__c = acc.Id;
        ss.Customer_Fisrt_Name__c = 'Test first name1';
        ss.Customer_e_mail_Address__c ='tesst@gmail.com';
        ss.Customer_Last_Name__c = 'Test Last Names';
        ss.recordtypeId= surveykycRecordTypeId ;
        ss.Mention_Firm_PAN_no__c = 'ABCDE1234F';
        ss.If_yes_mention_GST_no__c = '29ABCDE1234F2Z5';
        ss.Firm_operating_bank_acc_IFSC_code__c = 'HDFC0000037';
        ss.Passport_number_of_Owner_proprietor__c = '1234567890';
        ss.Firms_operating_Bank_acc_no__c = '098765432121';
        Insert ss;
        
        KYC__c kyc = new KYC__c();
        kyc.Name = 'PAN Card';
        kyc.Account__c = acc.Id;
        kyc.recordtypeId = Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('PAN Card').getRecordTypeId();
        INSERT kyc;
        KYC__c kyc1 = new KYC__c();
        kyc1.Name = 'PAN Card';
        kyc1.Account__c = acc.Id;
        kyc1.recordtypeId = Schema.SObjectType.KYC__c.getRecordTypeInfosByName().get('Passport').getRecordTypeId();
        INSERT kyc1;
        //Cover Distributor document part...
        Attachment att = new Attachment();
        att.Name = 'Test Attachment';
        att.body = blob.valueOf('test');
        att.parentId = acc.Id;
        INSERT att;
        
        DistributorDocument__c dd = new DistributorDocument__c();
        dd.Documents_Type__c = 'Pan Card';
        dd.AttachmentId__c = att.Id;
        dd.Survey__c = ss.Id;
        INSERT dd;
        
        DistributorDocument__c dd1 = new DistributorDocument__c();
        dd1.Documents_Type__c = 'GST Certification';
        dd1.AttachmentId__c = att.Id;
        dd1.Survey__c = ss.Id;
        INSERT dd1;
        
        DistributorDocument__c dd2 = new DistributorDocument__c();
        dd2.Documents_Type__c = 'Bank statement last 6M';
        dd2.AttachmentId__c = att.Id;
        dd2.Survey__c = ss.Id;
        INSERT dd2;
        
        DistributorDocument__c dd3 = new DistributorDocument__c();
        dd3.Documents_Type__c = 'Passport';
        dd3.AttachmentId__c = att.Id;
        dd3.Survey__c = ss.Id;
        INSERT dd3;
        
        DistributorDocument__c dd4 = new DistributorDocument__c();
        dd4.Documents_Type__c = 'Distributor Agreement Dealership Firm';
        dd4.AttachmentId__c = att.Id;
        dd4.Survey__c = ss.Id;
        INSERT dd4;
        KYCInformation.getKYCList(acc.Id ,ss.Id);
    }
}