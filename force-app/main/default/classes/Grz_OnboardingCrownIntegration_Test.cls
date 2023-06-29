@isTest
public class Grz_OnboardingCrownIntegration_Test {
    @testSetup static void setup() {
        
        Price_Group_Master__c pgObj = new Price_Group_Master__c ();
        pgObj.PG_Code__c='001';
        insert pgObj;
        
        
        Sales_Org__c sOrg = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Sales_Org_Code__c = '1410'//'1000' //uplsetting.India_SAS_Sales_Org__c  // Sales Org Code
        );
        insert sOrg;
        
        
        
        Depot__c dpObj = new Depot__c ();
        dpObj.Name = 'Pune';
        dpObj.Country__c = 'India';
        dpObj.Location__c='Pune';
        dpObj.Depot_Code__c = 'PUN';
        dpObj.RecordTypeId = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();
        insert dpObj;
        
        Division__c divObj = new Division__c();
        divObj.Name = 'Fertilizer Division';
        divObj.Division_Code__c = '10';
        insert divObj;
        
        Pin_Code__c pCode = new Pin_Code__c();
        pCode.Name = '400014';
        pCode.District__c = 'Mumbai';
        insert pCode;
        
        State_Tax_Structure__c sTax = new State_Tax_Structure__c();
        sTax.State_Name__c = 'Maharashtra';
        sTax.State_Code__c = '13';
        sTax.GST_State_Code__c = '27';
        sTax.SalesOrg__c = sOrg.Id;
        insert sTax;
        
        //-----
        Account accOb = new account();
        accOb.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        accOb.Name = 'Test Account';
        accOb.PriceGroupCode__c=PGObj.Id;
        accOb.Mobile__c='9967341759';
        accOb.Phone='0202356589';
        accOb.Sales_Org__c = sOrg.Id;
        accOb.Callout_Set__c = False;
        accOb.ApprovalStatus__c = 'Approved';
        
        accOb.Country__c='India';
        accOb.Division__c = divObj.Id;
        accOb.BillingCity = 'Mumbai';
        accOb.BillingCountry = 'India';
        accOb.BillingStreet = 'DSP';
        accOb.BillingState = 'MAHARASHTRA';
        accOb.BillingPostalCode= '400014';
        accOb.PAN_Number__c = 'DLEPK3323L';
        accOb.State_Tax_Structure__c = sTax.Id;
        accOb.Tax_Number_3__c = '27DLEPK3323LAAA';  
        
        insert accOb;   
        
        
        DistributorSalesAreaMapping__c DSA = new DistributorSalesAreaMapping__c();
        DSA.Distributor__c=accOb.Id;
        DSA.CurrencyIsoCode='INR';
        insert DSA;
        
        Crown_Document__c cd = new Crown_Document__c();
        cd.Sales_Area__c=DSA.Id;
        insert cd;
        
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=cd.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        PAN_GST_API_Creds__c pan1 = new PAN_GST_API_Creds__c();
        pan1.Name='Crown_API_Creds';
        pan1.Password__c='Admin';
        pan1.Username__c='CaseAdminuser@1234';
        
        insert pan1;
    }

    
    public static testmethod void Grz_Onbordingtestmethod(){
        System.debug('__Inside First Method__');
        
        Account acct = [SELECT Id FROM Account WHERE Name='Test Account' LIMIT 1];
        
        DistributorSalesAreaMapping__c DSA = [Select id from DistributorSalesAreaMapping__c where Distributor__c=: acct.id];
        
        Crown_Document__c cd = [Select id from Crown_Document__c where Sales_Area__c=: DSA.id];
        
        
        
        
        Test.startTest();
        String recordid = string.valueOf(DSA.Id);
        String cd_id = String.valueOf(cd.Id);
        
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        Grz_OnboardingCrownIntegration.getDocumentsFromCrown(recordid);
         
        Grz_OnboardingCrownIntegration.updateSAPNumber(recordid,'0001101413','Testcase');
        Grz_OnboardingCrownIntegration.generatePdf('Test',cd_id,'Header_Picture1');
        Grz_OnboardingCrownIntegration.deleteAllDocuments(recordid);
        Grz_OnboardingCrownIntegration.getDocumentByProspect('TestBody');
        Test.stopTest();
        
    }
    public static testmethod void Grz_Onbordingtestmethoderror(){
        System.debug('__Inside First Method__');
        
        Account acct = [SELECT Id FROM Account WHERE Name='Test Account' LIMIT 1];
        
        DistributorSalesAreaMapping__c DSA = [Select id from DistributorSalesAreaMapping__c where Distributor__c=: acct.id];
        
        Crown_Document__c cd = [Select id from Crown_Document__c where Sales_Area__c=: DSA.id];
        
        
        
        
        Test.startTest();
        String recordid = string.valueOf(DSA.Id);
        String cd_id = String.valueOf(cd.Id);
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        
        Grz_OnboardingCrownIntegration.getDocumentsFromCrown(recordid);
        Test.setMock(HttpCalloutMock.class, new GD_calloutMock1_Test());
 
        Test.stopTest();
        
    }
}