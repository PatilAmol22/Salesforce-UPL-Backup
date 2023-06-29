@isTest
public class CaseDistributorFeedbackTest{
    @isTest static void SendEmailTestMethod()
    {
        Trigger_Settings__c tsObj = new Trigger_Settings__c();
        tsObj.Name = 'CaseTrigger';
        tsObj.isActive__c = True;
        insert tsObj;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id caseRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account accObj=new Account();
        accObj.Name = 'test';
        accObj.Last_Name__c = 'test';
        accObj.RecordTypeId=devRecordTypeId;
        //accObj.Farmer_Code__pc = 'fm0'+String.valueOf(auto.Sequence__c);
        accObj.Mobile__c='9869457812';
        insert accObj;
        
        
        SiteURL__c  urlObj= new SiteURL__c();
        urlObj.Name='RedirectPage';
        urlObj.URL__c='test';
        insert urlObj;
        
        
        SiteURL__c  urlObj1= new SiteURL__c();
        urlObj1.Name='CaseSave';
        urlObj1.URL__c='test';
        insert urlObj1;
        
        
        
        Non_SFDC_User__c non =new Non_SFDC_User__c();
        non.Name='test';
        non.Email__c='test@gmail.com';
        non.Designation__c='test';
        non.User_Type__c='Regional Manager';
        
        insert non;
        
        Non_SFDC_User__c non1 =new Non_SFDC_User__c();
        non1.Name='test1';
        non1.Email__c='test1@gmail.com';
        non1.Designation__c='test1';
        non1.User_Type__c='Zonal Head';
        insert non1;
        
        Case caseObj = new Case();
        CaseObj.Status='New';
        CaseObj.AccountId=accObj.Id;
        CaseObj.RecordTypeId=caseRecordTypeId;
        CaseObj.SendEmailNonsfdcuser__c=false;
        caseObj.Non_SFDC_User__c=non.Id;
        caseObj.Zonal_Head__c=non1.Id;
        insert caseObj;
        
        System.currentPagereference().getParameters().put('id',caseObj.id);
        
        CaseDistributorFeedback  custObj= new CaseDistributorFeedback ();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        custObj.CheckLink();
        custObj.Save();
    }
}