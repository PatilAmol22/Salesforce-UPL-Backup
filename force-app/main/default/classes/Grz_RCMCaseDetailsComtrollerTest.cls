/**************************************************************************************************
* Name             : Grz_RCMCaseDetailsComtrollerTest                                                     
* Description      : To cover the controller class Grz_RCMCaseDetailsComtroller
* Created Date     : 09-02-2023                                                                        
* Project/JIRA     : APPS-4742                                                                       
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti)  09-02-2023                                                                       
**************************************************************************************************/

@isTest
public class Grz_RCMCaseDetailsComtrollerTest {
    @isTest static void testRCMCaseDetailsComtroller(){
        
        
         Id recordTypeconfigId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseConfiguration').RecordTypeId;   
        Partner_Portal_Configuration__c objPPC = new Partner_Portal_Configuration__c();
        objPPC.Name = 'RCM Emails';
        objPPC.Description__c = 'Test@gmail.com';
        objPPC.Label__c = 'CaseConfigRCM';
        objPPC.RecordTypeId = recordTypeconfigId;
        insert objPPC;
        
        
        Partner_Portal_Configuration__c objPPC1 = new Partner_Portal_Configuration__c();
        objPPC1.Name = 'RCM CC Email';
        objPPC1.Description__c = 'Test@gmail.com';
        objPPC1.Label__c = 'CaseConfigRCM';
        objPPC1.RecordTypeId = recordTypeconfigId;
        insert objPPC1;
        
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('RCMCase').RecordTypeId;
        
        Case c = new Case();
        c.Status = 'New';
        c.RecordTypeId = recordTypeShowId;
        c.CategoryForSubcategory__c = '';
        c.Sub_Category__c = '';
        c.Description='Test Case';
        c.Subject = 'Testing';
        c.Type = 'Credit Limit';
        c.CaseOwnerName__c = '';
        insert c;
        
        ContentDocument cd = Grz_TestDataFactory.createContentDocument(true);
        
        List<Id> cvIdList = Grz_TestDataFactory.mapAttachmentToCase(true,cd.Id,c.Id);
        
        
        Test.startTest();
        
        CaseComment cm = Grz_TestDataFactory.createCaseComment(true,c.Id,'Test Case Feed Item');       
        String urlapex = c.Id;
        
        Grz_RCMCaseDetailsComtroller.contentSizePublic(cd.Id,c.Id);
        Grz_RCMCaseDetailsComtroller.getCaseDetailList(urlapex);
        Grz_RCMCaseDetailsComtroller.getContentDistribution(null);
        Grz_CaseDetailClass.saveCaseComment(c.Id, 'Test Case Comment','escalation');
        
        Test.stopTest();
    }
    
    
    @isTest static void testRCMCaseDetailsComtroller1(){
        Grz_TestDataFactory.createTemplate(true,'Community_Case_Closure', 'Case'); 
        
         Id recordTypeconfigId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseConfiguration').RecordTypeId;   
        Partner_Portal_Configuration__c objPPC = new Partner_Portal_Configuration__c();
        objPPC.Name = 'RCM Emails';
        objPPC.Description__c = 'Test@gmail.com';
        objPPC.Label__c = 'CaseConfigRCM';
        objPPC.RecordTypeId = recordTypeconfigId;
        insert objPPC;
        
        
        Partner_Portal_Configuration__c objPPC1 = new Partner_Portal_Configuration__c();
        objPPC1.Name = 'RCM CC Email';
        objPPC1.Description__c = 'Test@gmail.com';
        objPPC1.Label__c = 'CaseConfigRCM';
        objPPC1.RecordTypeId = recordTypeconfigId;
        insert objPPC1;
        
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('RCMCase').RecordTypeId;
        List<Case> lstNewCase = new List<Case>();
        
        Case c = new Case();
        c.Status = 'New';
        c.RecordTypeId = recordTypeShowId;
        c.CategoryForSubcategory__c = '';
        c.Sub_Category__c = '';
        c.Description='Test Case';
        c.Subject = 'Testing';
        c.CaseOwnerName__c = '';
        lstNewCase.add(c);
        
        
        Case c1 = new Case();
        c1.Status = 'Reopen';
        c1.RecordTypeId = recordTypeShowId;
        c1.CategoryForSubcategory__c = '';
        c1.Sub_Category__c = '';
        c1.Description='Test Case';
        c1.Subject = 'Testing';
        c1.CaseOwnerName__c = '';
        lstNewCase.add(c1);
        
        if(!lstNewCase.isEmpty()){
            insert lstNewCase;
        }
        
        
        
        Test.startTest();
        Grz_CaseDetailClass.saveCaseComment(c1.Id, 'Test','comment');
        Grz_RCMCaseDetailsComtroller.CloseCase(c.Id, 'Test Reason');
        Grz_RCMCaseDetailsComtroller.CloseCase(null, null);
        Test.stopTest();   
    }
    
    @isTest static void testRCMCaseDetailsComtroller2(){
        Grz_TestDataFactory.createTemplate(true,'Community_Case_Closure', 'Case'); 
        
         Id recordTypeconfigId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseConfiguration').RecordTypeId;   
        Partner_Portal_Configuration__c objPPC = new Partner_Portal_Configuration__c();
        objPPC.Name = 'RCM Emails';
        objPPC.Description__c = 'Test@gmail.com';
        objPPC.Label__c = 'CaseConfigRCM';
        objPPC.RecordTypeId = recordTypeconfigId;
        insert objPPC;
        
        
        Partner_Portal_Configuration__c objPPC1 = new Partner_Portal_Configuration__c();
        objPPC1.Name = 'RCM CC Email';
        objPPC1.Description__c = 'Test@gmail.com';
        objPPC1.Label__c = 'CaseConfigRCM';
        objPPC1.RecordTypeId = recordTypeconfigId;
        insert objPPC1;
        
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('RCMCase').RecordTypeId;
        Case c = new Case();
        c.Status = 'Closed';
        c.RecordTypeId = recordTypeShowId;
        c.CategoryForSubcategory__c = '';
        c.Sub_Category__c = '';
        c.Description='Test Case';
        c.Subject = 'Testing';
        c.CaseOwnerName__c = '';
        insert c;
        
        Test.startTest();
        Grz_CaseDetailClass.saveCaseComment(c.Id, 'Test','comment');
        Grz_RCMCaseDetailsComtroller.CloseCase(c.Id, 'Test Reason');
        Grz_RCMCaseDetailsComtroller.CloseCase(null, null);
        Test.stopTest();   
    }
    
}