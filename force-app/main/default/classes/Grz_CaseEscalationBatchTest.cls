@isTest(SeeAllData=false)
public class Grz_CaseEscalationBatchTest {
    Public  static testmethod void testEscalationSchedular(){
    Grz_TestDataFactory.createTemplate(true,'Community_Case_Escalation', 'Case');
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;  
        test.startTest();
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        Case caseObj = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'Invoice', acc.Id, recordTypeShowId);
        caseObj.Escalation_Level__c = 'Escalated L1';
        caseObj.CaseOwner__c = 'C & F;RCM';
        caseObj.CategoryForSubcategory__c = '';  //  Additional Line 
        caseObj.Sub_Category__c = '';  //  Additional Line         
        insert caseObj;         
        test.stopTest();
        Datetime createDate = Date.today();
        System.debug('createDate : '+createDate.addDays(-3));
        Test.setCreatedDate(caseObj.Id, createDate.addDays(-3));
        Database.executeBatch(new Grz_CaseEscalationBatch(),100);
   }  
   
    Public  static testmethod void testEscalationSchedular1(){ 
        /* Additional Line For Escalation2 Batch Class and Reopen1TimeHO Batch Class  */  
        
        List<Case> casList = new List<Case>();
        List<Id> caseIds = new List<Id>();
        Grz_TestDataFactory.createTemplate(true,'Community_Case_Closure', 'Case');
        Grz_TestDataFactory.createTemplate(true,'Community_Case_Escalation', 'Case');
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;  
        test.startTest();
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId);  
        Case caseObj = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'Invoice', acc.Id, recordTypeShowId);
        caseObj.Escalation_Level__c = '';  //  
        caseObj.CaseOwner__c = 'Depot';  // 
        caseObj.CategoryForSubcategory__c = 'Complaint';  //  Additional Line 
        caseObj.caseCommentDate__c = system.now().addDays(-2);
        caseObj.Sub_Category__c = 'Invoice, Schemes & Discount related';  //  Additional Line    
        caseObj.Is_Auto_Escalated__c = false;  //  Additional Line  
        caseObj.Status = 'NEW';  //  Additional Line  
        caseObj.Count_Open_Values__c = 0;  //  Additional Line
        casList.add(caseObj);
        caseIds.add(caseobj.Id);
        //insert caseObj; 
        Case caseObj1 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'Invoice', acc.Id, recordTypeShowId);  
        caseObj1.Escalation_Level__c = '';  //  
        caseObj1.CaseOwner__c = 'GBS Pune';  // 
        caseObj1.CategoryForSubcategory__c = 'Request';  //  Additional Line 
        caseObj1.Sub_Category__c = 'Credit Limit';  //  Additional Line    
        caseObj1.Is_Auto_Escalated__c = false;  //  Additional Line  
        caseObj1.Status = 'NEW';  //  Additional Line
        caseObj1.caseCommentDate__c = system.now().addDays(-4);
        caseObj1.Count_Open_Values__c = 0;  //  Additional Line
        casList.add(caseObj1);
        caseIds.add(caseobj1.Id);
        
        Case caseObj2 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'Invoice', acc.Id, recordTypeShowId);  
        caseObj2.Escalation_Level__c = 'Escalated L2';  //  
        caseObj2.CaseOwner__c = 'Harbind Chauhan';  // 
        caseObj2.CategoryForSubcategory__c = 'Request';  //  Additional Line 
        caseObj2.Sub_Category__c = 'Credit Limit';  //  Additional Line    
        caseObj2.Is_Auto_Escalated__c = true;  //  Additional Line  
        caseObj2.Status = 'NEW';  //  Additional Line
        caseObj2.caseCommentDate__c = system.now().addDays(-4);
        caseObj2.Count_Open_Values__c = 0;  //  Additional Line
        casList.add(caseObj2);
        caseIds.add(caseobj2.Id);
        
        Case caseObj3 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'Invoice', acc.Id, recordTypeShowId);  
        caseObj3.Escalation_Level__c = 'Escalated L2';  //  
        caseObj3.CaseOwner__c = 'RCMs';  // 
        caseObj3.CategoryForSubcategory__c = 'Complaint';  //  Additional Line 
        caseObj3.Sub_Category__c = 'Invoice, Schemes & Discount related';  //  Additional Line    
        caseObj3.Is_Auto_Escalated__c = true;  //  Additional Line  
        caseObj3.Status = 'NEW';  //  Additional Line
        caseObj3.caseCommentDate__c = system.now().addDays(-2);
        caseObj3.Count_Open_Values__c = 0;  //  Additional Line
        casList.add(caseObj3);
        caseIds.add(caseobj3.Id); 
        
        insert casList;
        test.stopTest();
        Datetime createDate = Date.today();
        System.debug('createDate : '+createDate.addDays(-3));
        Test.setCreatedDate(caseObj.Id, createDate.addDays(-3));
        Database.executeBatch(new Grz_IndiaCaseModuleEscalate2Batch(),100);
        Database.executeBatch(new Grz_IndiaCaseMOduleHOBatch(),100);
        
          //Grz_CaseDetailClass.reopenPortalCase(caseIds);    
        
   }
       
}