@isTest
public class Grz_CaseDetailClassTest {
    
    Public  static testmethod void testCaseRecord(){
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;  
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        Case c = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        c.CategoryForSubcategory__c = '';
        c.Sub_Category__c = '';
        c.Description='Test Case';
        insert c;
        ContentDocument cd = Grz_TestDataFactory.createContentDocument(true);  
        Test.startTest();
        List<Id> cvIdList = Grz_TestDataFactory.mapAttachmentToCase(true,cd.Id,c.Id);  
        CaseComment cm = Grz_TestDataFactory.createCaseComment(true,c.Id,'Test Case Feed Item');       
        String urlapex = c.Id;
        
        Grz_CaseDetailClass.getCaseDetailList(urlapex);
        Grz_CaseDetailClass.saveCaseComment(c.Id, 'Test Case Comment','escalation');
     
        Test.stopTest();
    }
    
    Public  static testmethod void testCaseRecord1(){
    Grz_TestDataFactory.createTemplate(true,'Community_Case_Escalation', 'Case');
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        List<Partner_Portal_Configuration__c> ppcList = new List<Partner_Portal_Configuration__c>();
        Id recordTypeconfigId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseConfiguration').RecordTypeId;         
        Partner_Portal_Configuration__c partnerObj1 = Grz_TestDataFactory.createSummaryTabs(false, 'HO Finance', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj1.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj1);
        Partner_Portal_Configuration__c partnerObj2 = Grz_TestDataFactory.createSummaryTabs(false, 'LOGISTICS HO', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj2.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj2);
        Partner_Portal_Configuration__c partnerObj3 = Grz_TestDataFactory.createSummaryTabs(false, 'Sales excellence', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj3.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj3);
       
        Test.startTest();        
        insert ppcList;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId); 
        List<Case> casetoInsert  = new List<Case>();
        Case caserec1 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec1.Type = 'Invoice';
        caserec1.CategoryForSubcategory__c = '';
        caserec1.Sub_Category__c = '';
        caserec1.Description='Test Case';
        casetoInsert.add(caserec1);  
        Case caserec2 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec2.Type = 'Other';
        caserec2.CategoryForSubcategory__c = '';
        caserec2.Sub_Category__c = '';
        caserec2.Description='Test Case';
        casetoInsert.add(caserec2);
        Case caserec3 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec3.Type = 'Scheme';
        caserec3.CategoryForSubcategory__c = '';
        caserec3.Sub_Category__c = '';
        caserec3.Description='Test Case';
        casetoInsert.add(caserec3);        
        insert casetoInsert;        
        List<Id> caseIdList = new List<Id>();
        for(Case c : casetoInsert){
            caseIdList.add(c.Id);
        }        
        Grz_CaseDetailClass.escalatePortalCase(caseIdList,'TestEscalation');  
        Test.stopTest();
    }
    Public  static testmethod void testCaseRecord3(){
    Grz_TestDataFactory.createTemplate(true,'Community_Case_Closure', 'Case');
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;  
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        Case c = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        c.Description='Test Case';
        c.CategoryForSubcategory__c = '';
        c.Sub_Category__c = '';
        insert c;
        ContentDocument cd = Grz_TestDataFactory.createContentDocument(true);  
        Test.startTest();
        List<Id> cvIdList = Grz_TestDataFactory.mapAttachmentToCase(true,cd.Id,c.Id);  
        CaseComment cm = Grz_TestDataFactory.createCaseComment(true,c.Id,'Test Case Feed Item');       
        String urlapex = c.Id;
        
        
        Grz_CaseDetailClass.saveCaseComment(null, null,'comment');
        Grz_CaseDetailClass.getContentDistribution(null);
        Grz_CaseDetailClass.contentSizePublic(cd.Id,c.Id);
        c.Reason_for_Closure__c ='Test Reason';
        c.Reason='Unknown';
        update c;
        Grz_CaseDetailClass.CloseCase(c.Id, 'Test Reason');
        Grz_CaseDetailClass.CloseCase(null, null);
        Test.stopTest();
    }
    
    @isTest
    static void testReopenPortalCase(){
     Grz_TestDataFactory.createTemplate(true,'Community_Case_ReOpen', 'Case');
     Grz_TestDataFactory.createTemplate(true,'Community_Case_Closure', 'Case');
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Colombia Case').RecordTypeId;  
        List<Partner_Portal_Configuration__c> ppcList = new List<Partner_Portal_Configuration__c>();
        Id recordTypeconfigId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseConfiguration').RecordTypeId;         
        Partner_Portal_Configuration__c partnerObj1 = Grz_TestDataFactory.createSummaryTabs(false, 'HO Finance', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj1.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj1);
        Partner_Portal_Configuration__c partnerObj2 = Grz_TestDataFactory.createSummaryTabs(false, 'LOGISTICS HO', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj2.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj2);
        Partner_Portal_Configuration__c partnerObj3 = Grz_TestDataFactory.createSummaryTabs(false, 'Sales excellence', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj3.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj3);
        Partner_Portal_Configuration__c partnerObj4 = Grz_TestDataFactory.createSummaryTabs(false, 'FCE', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj4.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj4); 
        Partner_Portal_Configuration__c partnerObj5 = Grz_TestDataFactory.createSummaryTabs(false, 'CROP MANAGER', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj5.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj5); 
        Partner_Portal_Configuration__c partnerObj6 = Grz_TestDataFactory.createSummaryTabs(false, 'Business ID', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj6.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj6); 
        //Change by Aashima(Grazitti) for APPS-4027 28Dec22
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'UPL SAS', '1410');
        Zone__c zone = Grz_TestDataFactory.createZone(true,'Test Zone',userinfo.getUserId(),sorg.Id);
        Territory_Distributor__c trt = Grz_TestDataFactory.createTeritory(false);
        trt.Zone__c = zone.Id;
        insert trt;
        Account acc = Grz_TestDataFactory.createUserAccount(false,'Test Account',accRecordTypeId,sorg.Id);
        acc.Territory_Distributor__c = trt.Id;
        acc.OwnerId = userinfo.getUserId();
        insert acc;
        DistributorSalesAreaMapping__c sa = Grz_TestDataFactory.CreateSalesArea(true,acc,sorg.Id,trt.Id);
        List<Case> casetoInsert  = new List<Case>();
        Case caserec1 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec1.Type = 'Invoice';
        caserec1.Description='Test Case';
        caserec1.Escalation_Level__c = 'Escalated L1';
        caserec1.CategoryForSubcategory__c = '';
        caserec1.Sub_Category__c = '';
        caserec1.CaseOwner__c = 'C & F;RCM;LOGISTICS HO;HO Finance;FCE;ZSM;CROP MANAGER';
        caserec1.Reopen_Status_Count__c = 1;
        caserec1.SalesOrg__c = sorg.Id;
        caserec1.Status = 'Closed';
            caserec1.CategoryForSubcategory__c = '';
            caserec1.Sub_Category__c = '';
            caserec1.Reason = 'Issue resolved';
            caserec1.Reason_for_Closure__c ='Test Reason';
        casetoInsert.add(caserec1);  
        Case caserec2 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec2.Type = 'Other';
        caserec2.Description='Test Case';
        caserec2.CategoryForSubcategory__c = '';
        caserec2.Sub_Category__c = '';
        caserec2.Escalation_Level__c = 'Escalated L2';
        caserec2.Reopen_Status_Count__c = 1;
        caserec2.CaseOwner__c = 'FCE';
        caserec2.SalesOrg__c = sorg.Id;
        caserec2.Status = 'Closed';
            caserec2.CategoryForSubcategory__c = '';
            caserec2.Sub_Category__c = '';
            caserec2.Reason = 'Issue resolved';
            caserec2.Reason_for_Closure__c ='Test Reason';
        casetoInsert.add(caserec2);
        Case caserec3 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec3.Type = 'Scheme';
        caserec3.Description='Test Case';  
        caserec3.CategoryForSubcategory__c = '';
        caserec3.Sub_Category__c = '';
        caserec3.Escalation_Level__c = 'Escalated L2';
        caserec3.Is_Auto_Escalated__c = true;
        caserec3.Reopen_Status_Count__c = 1;
        caserec3.CaseOwner__c = 'Sales excellence';
        caserec3.SalesOrg__c = sorg.Id;
        caserec3.Status = 'Closed';
            caserec3.CategoryForSubcategory__c = '';
            caserec3.Sub_Category__c = '';
            caserec3.Reason = 'Issue resolved';
            caserec3.Reason_for_Closure__c ='Test Reason';
        casetoInsert.add(caserec3);    
        Case caserec4 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec4.Type = 'Invoice';
        caserec4.Description='Test Case';  
        caserec4.CategoryForSubcategory__c = '';
        caserec4.Sub_Category__c = '';
        caserec4.Escalation_Level__c = 'Escalated L2';
        caserec4.Reopen_Status_Count__c = 1;
        caserec4.CaseOwner__c = 'C & F;RCM';
        caserec4.SalesOrg__c = sorg.Id;
        caserec4.Status = 'Closed';
            caserec4.CategoryForSubcategory__c = '';
            caserec4.Sub_Category__c = '';
            caserec4.Reason = 'Issue resolved';
            caserec4.Reason_for_Closure__c ='Test Reason';
        casetoInsert.add(caserec4);
        Case caserec5 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec5.Type = 'Scheme';
        caserec5.Description='Test Case';
        caserec5.Escalation_Level__c = 'Escalated L2';
        caserec5.CategoryForSubcategory__c = '';
        caserec5.Sub_Category__c = '';
        caserec5.Reopen_Status_Count__c = 1;
        caserec5.CaseOwner__c = 'Sales excellence';
        caserec5.SalesOrg__c = sorg.Id;
        caserec5.Status = 'Closed';
            caserec5.CategoryForSubcategory__c = '';
            caserec5.Sub_Category__c = '';
            caserec5.Reason = 'Issue resolved';
            caserec5.Reason_for_Closure__c ='Test Reason';
        casetoInsert.add(caserec5);
        insert casetoInsert;        
        List<Id> caseIdList = new List<Id>();
        List<Case> casestoUpdate = new  List<Case>();
        for(Case c : casetoInsert){
            caseIdList.add(c.Id);
            /*c.Status = 'Closed';
            c.CategoryForSubcategory__c = '';
            c.Sub_Category__c = '';
            c.Reason = 'Issue resolved';
            c.Reason_for_Closure__c ='Test Reason';
            casestoUpdate.add(c);*/
        }
        insert ppcList;
        Depot__c depo = Grz_TestDataFactory.createDepot(true,'Test',sorg.Id);
        TM_Depot_Mapping__c tmMap = Grz_TestDataFactory.createTMDepot(true,depo.Id);
        Test.startTest(); 
        //update casestoUpdate;
        
        Grz_CaseDetailClass.reopenPortalCase(caseIdList);       
        Test.stopTest();
    }
    
}