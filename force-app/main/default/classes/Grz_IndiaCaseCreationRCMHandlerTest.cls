/**************************************************************************************************
* Name             : Grz_IndiaCaseCreationRCMHandlerTest                                                     
* Description      : To cover the controller class Grz_IndiaCaseCreationRCMHandler
* Created Date     : 13-02-2023                                                                        
* Project/JIRA     : APPS-4742                                                                    
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti)  14-02-2023                                                                       
**************************************************************************************************/

@isTest
public class Grz_IndiaCaseCreationRCMHandlerTest {
    
     @testSetup static void setup() {
        List<Partner_Portal_Configuration__c> ppcList = new List<Partner_Portal_Configuration__c>(); 
        Id recordTypeconfigId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseConfiguration').RecordTypeId;   
        Partner_Portal_Configuration__c objPPC = Grz_TestDataFactory.createSummaryTabs(false, 'RCM Emails', 'CaseConfigRCM', 1, 'Url', 'en-US', recordTypeconfigId);
        objPPC.Description__c = 'Test@gmail.com';
        ppcList.add(objPPC);
        
        Partner_Portal_Configuration__c objPPC1 = Grz_TestDataFactory.createSummaryTabs(false, 'RCM CC Email', 'CaseConfigRCM', 2, 'Url', 'en-US', recordTypeconfigId);
        objPPC1.Description__c = 'Test@gmail.com';
        ppcList.add(objPPC1);
         
        
        Partner_Portal_Configuration__c objPPC2 = Grz_TestDataFactory.createSummaryTabs(false, 'RCMApprovalMail', 'CaseConfigApprovalRCM', 1, 'Url', 'en-US', recordTypeconfigId);
        objPPC2.Description__c = 'Test@gmail.com';
        ppcList.add(objPPC2);
         
        Partner_Portal_Configuration__c objPPC3 = Grz_TestDataFactory.createSummaryTabs(false, 'RCMApprovalCCEmail', 'CaseConfigApprovalRCM', 1, 'Url', 'en-US', recordTypeconfigId);
        objPPC3.Description__c = 'Test@gmail.com';
        ppcList.add(objPPC3);
         
         
        Insert ppcList;
         
        
         
        // Create Case
        List<case> caselist = new  List<case>();
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('RCMCase').RecordTypeId;
        Case c = new Case();
        c.RecordTypeId = recordTypeShowId;
        c.CategoryForSubcategory__c = 'Complaint';
        c.Sub_Category__c = 'Quality Complaint';
        c.Description='Test Case RCM';
        c.Subject = 'Testing RCM Case';
        c.Reopen_Status_Count__c = 1;
        caselist.add(c);
        
        Case c1 = new Case();
        c1.RecordTypeId = recordTypeShowId;
        c1.Status = 'Closed';
        c1.CategoryForSubcategory__c = 'Complaint';
        c1.Sub_Category__c = 'Quality Complaint';
        c1.Description='Test Case RCM Reopen';
        c1.Subject = 'Testing RCM Reopen';
        c1.Reopen_Status_Count__c = 1;
        caselist.add(c1);
        insert caselist;        
    }
    
    @isTest static void testCaseClose1(){       
		List<Case> caseList = [Select Id,subject,status from case where subject = 'Testing RCM Case' limit 1];         
        Test.startTest();
        caseList[0].status = 'Closed';
        update caseList;
        Test.stopTest();
        
    }
    @isTest static void testCaseReopen(){       
		List<Case> caseList = [Select Id,subject,status from case where subject = 'Testing RCM Reopen' limit 1];         
        Test.startTest();
        caseList[0].status = 'Reopen';
        update caseList;
        Test.stopTest();
    }
}