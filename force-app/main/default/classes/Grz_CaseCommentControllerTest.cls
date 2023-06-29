@isTest(SeeAllData=false)
public class Grz_CaseCommentControllerTest {
    
    Public  static testmethod void testCaseComment1(){
        Grz_TestDataFactory.createTemplate(true,'Community_Case_Closure', 'Case');
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
        //Change by Aashima(Grazitti) for APPS-4027 28Dec22
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'UPL SAS', '1410');
        Zone__c zone = Grz_TestDataFactory.createZone(true,'Test Zone',userinfo.getUserId(),sorg.Id);
        Territory_Distributor__c trt = Grz_TestDataFactory.createTeritory(false);
        trt.Zone__c = zone.Id;
        insert trt;
        Account acc = Grz_TestDataFactory.createUserAccount(false,'Test Account',accRecordTypeId,sorg.Id);
        acc.Territory_Distributor__c = trt.Id;
        insert acc;
        //Account acc = Grz_TestDataFactory.createAccount(false, 'Test Account',accRecordTypeId); 
        //acc.Sales_Org__c = sorg.Id;
        //insert acc;
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr=new User();
        System.runAs(usr1){
        Group gg=Grz_TestDataFactory.creategroup(true);
        usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
        GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
             
        insert ppcList;
        Depot__c depo = Grz_TestDataFactory.createDepot(true,'Test',sorg.Id);
        TM_Depot_Mapping__c tmMap = Grz_TestDataFactory.createTMDepot(true,depo.Id);
        Case caseObj = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caseObj.Type = 'Invoice'; 
        caseObj.CaseOwner__c = 'C & F;RCM;Sales excellence';
        insert caseObj;
        Test.startTest(); 
        System.runAs(usr){
               CaseComment cm = Grz_TestDataFactory.createCaseComment(true, caseObj.Id, 'test comment');
        }
        Test.stopTest();
    }
    
    Public  static testmethod void testCaseComment2(){
        Grz_TestDataFactory.createTemplate(true,'Community_Case_Closure', 'Case');
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;
         Id recordTypeconfigId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseConfiguration').RecordTypeId;
        List<Partner_Portal_Configuration__c> ppcList = new List<Partner_Portal_Configuration__c>();
        Partner_Portal_Configuration__c partnerObj1 = Grz_TestDataFactory.createSummaryTabs(false, 'HO Finance', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj1.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj1);
        Partner_Portal_Configuration__c partnerObj2 = Grz_TestDataFactory.createSummaryTabs(false, 'LOGISTICS HO', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj2.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj2);
        Partner_Portal_Configuration__c partnerObj3 = Grz_TestDataFactory.createSummaryTabs(false, 'CROP MANAGER', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj3.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj3); 
        //Change by Aashima(Grazitti) for APPS-4027 28Dec22
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'UPL SAS', '1410');
        Zone__c zone = Grz_TestDataFactory.createZone(true,'Test Zone',userinfo.getUserId(),sorg.Id);
        Territory_Distributor__c trt = Grz_TestDataFactory.createTeritory(false);
        trt.Zone__c = zone.Id;
        insert trt;
        Account acc = Grz_TestDataFactory.createUserAccount(false,'Test Account',accRecordTypeId,sorg.Id);
        acc.Territory_Distributor__c = trt.Id;
        insert acc;
        system.debug('Test User Account : '+acc);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr=new User();
        System.runAs(usr1){
        Group gg=Grz_TestDataFactory.creategroup(true);
        usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
        GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
          
        insert ppcList;
        Depot__c depo = Grz_TestDataFactory.createDepot(true,'Test',sorg.Id);
        TM_Depot_Mapping__c tmMap = Grz_TestDataFactory.createTMDepot(true,depo.Id);
        Case caseObj = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caseObj.Type = 'Product Related';  
        caseObj.CaseOwner__c = 'ZSM;CROP MANAGER';
        insert caseObj;
        system.debug('caseObj : '+caseObj);
        Test.startTest();
        System.runAs(usr){
               CaseComment cm = Grz_TestDataFactory.createCaseComment(true, caseObj.Id, 'test comment');
        }
        Test.stopTest();
    }
    
    Public  static testmethod void testCaseComment3(){
        Grz_TestDataFactory.createTemplate(true,'Community_Case_Closure', 'Case');
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeconfigId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseConfiguration').RecordTypeId;         
        List<Partner_Portal_Configuration__c> ppcList = new List<Partner_Portal_Configuration__c>();
        Partner_Portal_Configuration__c partnerObj1 = Grz_TestDataFactory.createSummaryTabs(false, 'HO Finance', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj1.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj1);
        Partner_Portal_Configuration__c partnerObj2 = Grz_TestDataFactory.createSummaryTabs(false, 'LOGISTICS HO', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj2.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj2);
        Partner_Portal_Configuration__c partnerObj3 = Grz_TestDataFactory.createSummaryTabs(false, 'FCE', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj3.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj3);   
         //Change by Aashima(Grazitti) for APPS-4027 28Dec22
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'UPL SAS', '1410');
        Zone__c zone = Grz_TestDataFactory.createZone(true,'Test Zone',userinfo.getUserId(),sorg.Id);
        Territory_Distributor__c trt = Grz_TestDataFactory.createTeritory(false);
        trt.Zone__c = zone.Id;
        insert trt;
        Account acc = Grz_TestDataFactory.createUserAccount(false,'Test Account',accRecordTypeId,sorg.Id);
        acc.Territory_Distributor__c = trt.Id;
        insert acc;
        system.debug('Test User Account : '+acc);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr=new User();
        System.runAs(usr1){
            Group gg=Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
            GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
           
        insert ppcList;
        Depot__c depo = Grz_TestDataFactory.createDepot(true,'Test',sorg.Id);
        TM_Depot_Mapping__c tmMap = Grz_TestDataFactory.createTMDepot(true,depo.Id);
        Case caseObj = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caseObj.Type = 'Customer Master Updation';  
        caseObj.CaseOwner__c = 'RCM;FCE';
        
        insert caseObj;
         Test.startTest();
        system.debug('caseObj : '+caseObj);
        System.runAs(usr){
               CaseComment cm = Grz_TestDataFactory.createCaseComment(true, caseObj.Id, 'test comment');
        }
        Test.stopTest();
    }
    
    Public  static testmethod void testCaseComment4(){
        Grz_TestDataFactory.createTemplate(true,'Community_Case_Closure', 'Case');
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeconfigId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseConfiguration').RecordTypeId;         
        List<Partner_Portal_Configuration__c> ppcList = new List<Partner_Portal_Configuration__c>();
        Partner_Portal_Configuration__c partnerObj1 = Grz_TestDataFactory.createSummaryTabs(false, 'HO Finance', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj1.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj1);
        Partner_Portal_Configuration__c partnerObj2 = Grz_TestDataFactory.createSummaryTabs(false, 'LOGISTICS HO', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj2.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj2);
           //Change by Aashima(Grazitti) for APPS-4027 28Dec22
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'UPL SAS', '1410');
        Zone__c zone = Grz_TestDataFactory.createZone(true,'Test Zone',userinfo.getUserId(),sorg.Id);
        Territory_Distributor__c trt = Grz_TestDataFactory.createTeritory(false);
        trt.Zone__c = zone.Id;
        insert trt;
        Account acc = Grz_TestDataFactory.createUserAccount(false,'Test Account',accRecordTypeId,sorg.Id);
        acc.Territory_Distributor__c = trt.Id;
        insert acc;
        system.debug('Test User Account : '+acc);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr=new User();
        System.runAs(usr1){
            Group gg=Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
            GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
            
        insert ppcList;
        Depot__c depo = Grz_TestDataFactory.createDepot(true,'Test',sorg.Id);
        TM_Depot_Mapping__c tmMap = Grz_TestDataFactory.createTMDepot(true,depo.Id);
        Case caseObj = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caseObj.Type = 'Order Update';  
        caseObj.CaseOwner__c = 'HO Finance;LOGISTICS HO';
        
        insert caseObj;
        system.debug('caseObj : '+caseObj);
        Test.startTest();
        System.runAs(usr){
               CaseComment cm = Grz_TestDataFactory.createCaseComment(true, caseObj.Id, 'test comment');
        }
        Test.stopTest();
    }
    
    
    Public  static testmethod void testCaseCmnt1(){
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;  
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr=new User();
        System.runAs(usr1){
            Group gg=Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
            GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
        Test.startTest();
        Grz_CaseCommentControllerTest.myFutureMethod(usr.Id, acc.Id , recordTypeShowId);
        Test.stopTest();
    }
    
    public static void myFutureMethod(Id usrId, Id accId ,Id recordTypeShowId)
    {   
        Case caseObj = Grz_TestDataFactory.createCaseRecord(true, 'Test Case', 'Invoice', accId, recordTypeShowId);
        caseObj = [select Id,Subject,CaseNumber,Type,Description,CreatedDate,ClosedDate,Status from case where id = : caseObj.id];
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = Grz_TestDataFactory.createInternalUser(true,pro.Id);
        EmailTemplate et=new EmailTemplate();
        System.runAs(usr){
            et.Name = 'Test Template';            
            et.Body = 'Test Email Body';
            et.TemplateType = 'custom';
            et.FolderId = UserInfo.getUserId();
            et.Subject = '[CaseNumber] test';
            et.HtmlValue = '[OwnerEmail] test [CaseDetailPageLink]';
            et.DeveloperName = 'CaseCommentEmailTemplate';
            insert et;
        }
        List<EmailTemplate> emailtempList = new List<EmailTemplate>();
        emailtempList.add(et);
        //Grz_CaseCommentController.handledynamicEmail(emailtempList,usrId,caseObj,'t1@gmail.com','test',usrId); 
    }

}