/**************************************************************************************************
* Name             : Grz_CaseCommentRCMControllerTest                                                     
* Description      : To cover the controller class Grz_CaseCommentRCMController , handledynamicRCMEmail
* Created Date     : 09-02-2023                                                                        
* Project/JIRA     : APPS-4742                                                                       
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Mohit Garg (Grazitti)  09-02-2023                                                                       
**************************************************************************************************/


@isTest
public class Grz_CaseCommentRCMControllerTest {
    
    @isTest static void testCaseCommentController(){
        
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
        c.RecordTypeId = recordTypeShowId;
        c.CategoryForSubcategory__c = 'Complaint';
        c.Sub_Category__c = 'Quality Complaint';
        c.Description='Test Case RCM';
        c.Subject = 'Testing RCM Case';
        c.Reopen_Status_Count__c = 1;
        insert c;   
        CaseComment cm = Grz_TestDataFactory.createCaseComment(true, c.Id, 'test comment');
    }
}