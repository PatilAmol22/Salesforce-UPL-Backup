/* Developer Name : Ketan Khatri
Purpose: To test the Brazil Case Trigger
*/
@isTest(Seealldata=false)
public class Grazitti_IndiaCaseModuleControllerTest {
    
    Public  static testmethod void testEscalationSchedular2(){ 

        Grz_TestDataFactory.createTemplate(true,'Community_Case_Escalation', 'Case');
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        List<Partner_Portal_Configuration__c> ppcList = new List<Partner_Portal_Configuration__c>();
        Id recordTypeconfigId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseConfiguration').RecordTypeId;         
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'SWAL', '1000');  // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
        
        Partner_Portal_Configuration__c partnerObj1 = Grz_TestDataFactory.createSummaryTabs(false, 'HO Mktng team', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj1.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj1);
        Partner_Portal_Configuration__c partnerObj2 = Grz_TestDataFactory.createSummaryTabs(false, 'Parveen Chambial', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj2.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj2);
        Partner_Portal_Configuration__c partnerObj3 = Grz_TestDataFactory.createSummaryTabs(false, 'HO Mktng team', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj3.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj3);
        Partner_Portal_Configuration__c partnerObj4 = Grz_TestDataFactory.createSummaryTabs(false, 'Purviish Shah', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj4.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj4);
        Partner_Portal_Configuration__c partnerObj5 = Grz_TestDataFactory.createSummaryTabs(false, 'Nikhil Sharma', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj5.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj5);
        Partner_Portal_Configuration__c partnerObj6 = Grz_TestDataFactory.createSummaryTabs(false, 'Ganesh Suvarna', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj6.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj6);
        Partner_Portal_Configuration__c partnerObj7 = Grz_TestDataFactory.createSummaryTabs(false, 'RCMs', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj7.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj7);
        Partner_Portal_Configuration__c partnerObj8 = Grz_TestDataFactory.createSummaryTabs(false, 'ZSM or ZSM', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj8.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj8);
        Partner_Portal_Configuration__c partnerObj9 = Grz_TestDataFactory.createSummaryTabs(false, 'Sales Excellences', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj9.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj9);
        //Partner_Portal_Configuration__c partnerObj10 = Grz_TestDataFactory.createSummaryTabs(false, 'TM', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        //partnerObj10.Description__c = 'Test@gmail.com';
        //ppcList.add(partnerObj10);
        Partner_Portal_Configuration__c partnerObj11 = Grz_TestDataFactory.createSummaryTabs(false, 'GBS Pune', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj11.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj11);
        //Code added for fixing test coverage issue  Mohit Garg(GRZ) (Date - 18-11-2022)
        Depot__c depo = Grz_TestDataFactory.createDepot(true,'Test',sorg.Id);
        TM_Depot_Mapping__c tmMap = Grz_TestDataFactory.createTMDepot(true,depo.Id);
        //Test.startTest();        
        insert ppcList;
        Account acc = Grz_TestDataFactory.createAccount(false, 'Test Account',accRecordTypeId); 
        acc.sales_org__c=sorg.id;
        insert acc;
        List<Case> casetoInsert  = new List<Case>();
        Case caserec1 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec1.Type = 'Invoice';
        caserec1.recordtypeId  = recordTypeShowId;
        caserec1.salesorg__C = sorg.Id;
        caserec1.escalation_level__c  = 'Escalated L2'; 
        caserec1.Is_Auto_Escalated__c = true;
        caserec1.Count_Open_Values__c = 2;
        caserec1.CategoryForSubcategory__c = '';
        caserec1.Sub_Category__c = '';
        caserec1.Description='Test Case';
        casetoInsert.add(caserec1);  
        Case caserec2 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec2.Type = 'Other';
        caserec2.recordtypeId  = recordTypeShowId;
        caserec2.salesorg__C = sorg.Id;
        caserec2.escalation_level__c  = 'Escalated L2'; 
        caserec2.Is_Auto_Escalated__c = true;
        caserec2.Count_Open_Values__c = 1;
        caserec2.CategoryForSubcategory__c = '';
        caserec2.Sub_Category__c = '';
        caserec2.Description='Test Case';
        casetoInsert.add(caserec2);
        Case caserec3 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec3.Type = 'Scheme';
        caserec3.recordtypeId  = recordTypeShowId;
        caserec3.salesorg__C = sorg.Id;
        caserec3.Count_Open_Values__c = 1;
        caserec3.level2__c = '';
        caserec3.CategoryForSubcategory__c = '';
        caserec3.Sub_Category__c = '';
        caserec3.Description='Test Case';
        casetoInsert.add(caserec3);  
        
        Case caserec4 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec4.recordtypeId  = recordTypeShowId;
        caserec4.salesorg__C = sorg.Id;
        caserec4.Type = 'Invoicess';
        caserec4.Count_Open_Values__c = 1;
        caserec4.CategoryForSubcategory__c = 'Complaint';
        caserec4.Sub_Category__c = 'Invoice, Schemes & Discount related';
        caserec4.Description='Test Case';
        caserec4.Count_Open_Values__c = 1;
        caserec4.level2__c = '';
        casetoInsert.add(caserec4); 
        
        Case caserec5 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec5.Type = 'Productss';
        caserec5.recordtypeId  = recordTypeShowId;
        caserec5.Count_Open_Values__c = 0;
        caserec5.salesorg__C = sorg.Id;
        caserec5.CategoryForSubcategory__c = 'Complaint';
        caserec5.Sub_Category__c = 'Product Availability';
        caserec5.Description='Test Case';
        caserec5.level2__c = '';
        casetoInsert.add(caserec5); 
        
        Case caserec6 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec6.Type = 'Paymentss';
        caserec6.recordtypeId  = recordTypeShowId;
        caserec6.salesorg__C = sorg.Id;
        caserec6.CategoryForSubcategory__c = 'Complaint';
        caserec6.Sub_Category__c = 'Payments & Receipts';
        caserec6.Count_Open_Values__c = 1;
        caserec6.level2__c = '';
        caserec6.Description='Test Case';
        casetoInsert.add(caserec6);
        
        Case caserec7 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec7.Type = 'Schemess';
        caserec7.recordtypeId  = recordTypeShowId;
        caserec7.salesorg__C = sorg.Id;
        caserec7.CategoryForSubcategory__c = 'Request';
        caserec7.Sub_Category__c = 'Schemes & Price Communication from HO';
        caserec7.Description='Test Case';
        caserec7.Count_Open_Values__c = 1;
        caserec7.level2__c = '';
        casetoInsert.add(caserec7); 
        
        Case caserec9 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec9.Type = 'Schemess';
        caserec9.recordtypeId  = recordTypeShowId;
        caserec9.salesorg__C = sorg.Id;
        caserec9.CategoryForSubcategory__c = 'Complaint';
        caserec9.Sub_Category__c = 'Product Availability';
        caserec9.Description='Test Case';
        casetoInsert.add(caserec9); 
        
        insert casetoInsert; 
        
                 List<Id> caseIds=new List<Id>();
         for(Case c:casetoInsert){
             caseIds.add(c.Id);
         }
         system.debug('caseIds==>'+caseIds);
         List<Case> updateCase=new List<Case>();
        for(Case c : [Select id,status from case where id IN :caseIds]){
            system.debug('status==>'+c.status);
            c.status = 'Reopen';
            updateCase.add(c);
        }
        Test.startTest();  // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
         system.debug('updateCase==>before update==>'+updateCase);
        update updateCase;
        system.debug('updateCase==>after update==>'+updateCase);

        
        //Grz_CaseDetailClass.escalatePortalCase(caseIdList,'TestEscalation'); 
        //Grazitti_IndiaCaseModuleController.escalatePortalCase(caseIdList,'TestEscalation');  //  Grz_CaseDetailClass.escalatePortalCase(caseIdList,'TestEscalation'); 
        Test.stopTest();
    }   
     Public  static testmethod void testEscalationSchedular1(){ 
        
        Grz_TestDataFactory.createTemplate(true,'Community_Case_Escalation', 'Case');
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        List<Partner_Portal_Configuration__c> ppcList = new List<Partner_Portal_Configuration__c>();
        Id recordTypeconfigId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('CaseConfiguration').RecordTypeId;         
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'SWAL', '1000');    // Change by Sumit(Grazitti) for APPS-4676 01-02-2023
        
        Partner_Portal_Configuration__c partnerObj1 = Grz_TestDataFactory.createSummaryTabs(false, 'GBS Pune', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj1.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj1);
        Partner_Portal_Configuration__c partnerObj2 = Grz_TestDataFactory.createSummaryTabs(false, 'Depot', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj2.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj2);
        Partner_Portal_Configuration__c partnerObj3 = Grz_TestDataFactory.createSummaryTabs(false, 'HO Mktng team', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj3.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj3);
        Partner_Portal_Configuration__c partnerObj4 = Grz_TestDataFactory.createSummaryTabs(false, 'Purviish Shah', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj4.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj4);
        Partner_Portal_Configuration__c partnerObj5 = Grz_TestDataFactory.createSummaryTabs(false, 'Sales Excellences', 'CaseTypePicklist', 1, 'TestTab1Url', 'en-US', recordTypeconfigId);
        partnerObj5.Description__c = 'Test@gmail.com';
        ppcList.add(partnerObj5);
        Test.startTest();        
        insert ppcList;
         
        //Code added for fixing test coverage issue  Mohit Garg(GRZ) (Date - 18-11-2022)
        Depot__c depo = Grz_TestDataFactory.createDepot(true,'Test',sorg.Id);
        TM_Depot_Mapping__c tmMap = Grz_TestDataFactory.createTMDepot(true,depo.Id);
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId); 
         
        List<Case> casetoInsert  = new List<Case>();
               
        Case caserec4 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec4.recordtypeId  = recordTypeShowId;
        caserec4.salesorg__C = sorg.Id;
        caserec4.Type = 'Invoicess';
        caserec4.Count_Open_Values__c = 1;
        caserec4.CategoryForSubcategory__c = 'Complaint';
        caserec4.Sub_Category__c = 'Invoice, Schemes & Discount related';
        caserec4.Description='Test Case';
        casetoInsert.add(caserec4); 
        
        Case caserec5 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec5.Type = 'Productss';
        caserec5.recordtypeId  = recordTypeShowId;
        caserec5.Count_Open_Values__c = 0;
        caserec5.salesorg__C = sorg.Id;
        caserec5.CategoryForSubcategory__c = 'Complaint';
        caserec5.Sub_Category__c = 'Product Availability';
        caserec5.Description='Test Case';
        casetoInsert.add(caserec5); 
        
        Case caserec6 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec6.Type = 'Paymentss';
        caserec6.recordtypeId  = recordTypeShowId;
        caserec6.Count_Open_Values__c = 2;
        caserec6.salesorg__C = sorg.Id;
        caserec6.CategoryForSubcategory__c = 'Request';
        caserec6.Sub_Category__c ='Credit Limit';
        caserec6.Description='Test Case';
        casetoInsert.add(caserec6);
        
        Case caserec7 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec7.Type = 'Schemess';
        caserec7.recordtypeId  = recordTypeShowId;
        caserec7.salesorg__C = sorg.Id;
        caserec7.CategoryForSubcategory__c = 'Request';
        caserec7.Sub_Category__c = 'Schemes & Price Communication from HO';
        caserec7.Description='Test Case';
        casetoInsert.add(caserec7); 
        
        Case caserec9 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec9.Type = 'Schemess';
        caserec9.recordtypeId  = recordTypeShowId;
        caserec9.salesorg__C = sorg.Id;
        caserec9.CategoryForSubcategory__c = 'Complaint';
        caserec9.Sub_Category__c = 'Dispatch related';
        caserec9.Description='Test Case';
        casetoInsert.add(caserec9); 
        
        insert casetoInsert; 
         List<Id> caseIds=new List<Id>();
         for(Case c:casetoInsert){
             caseIds.add(c.Id);
         }
         system.debug('caseIds==>'+caseIds);
         List<Case> updateCase=new List<Case>();
        for(Case c : [Select id,status,Count_Open_Values__c from case where id IN :caseIds]){
            system.debug('status==>'+c.status);
            c.status = 'Reopen';
            updateCase.add(c);
        }
         system.debug('updateCase==>before update==>'+updateCase);
        update updateCase;
        system.debug('updateCase==>after update==>'+updateCase);
        //Grz_CaseDetailClass.escalatePortalCase(caseIdList,'TestEscalation'); 
        //Grazitti_IndiaCaseModuleController.escalatePortalCase(caseIdList,'TestEscalation');  //  Grz_CaseDetailClass.escalatePortalCase(caseIdList,'TestEscalation'); 
        Test.stopTest();
    }   
    
    
}