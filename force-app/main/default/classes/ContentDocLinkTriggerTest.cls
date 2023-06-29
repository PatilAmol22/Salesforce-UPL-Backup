@isTest
public class ContentDocLinkTriggerTest {
    Public  static testmethod void testContentDocLink(){
        ContentDocument condoc = Grz_TestDataFactory.createContentDocument(true);
        contentDocumentLink condocLink = new ContentDocumentLink();
        
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;    
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId); 
        
        
       //Change by Aashima(Grazitti) for APPS-4027 28Dec22
        Sales_Org__c salorg = new Sales_Org__c();
        salorg.name = 'UPL SAS';
        salorg.Sales_Org_Code__c = '1410';
        insert salorg;
            
         List<Case> casetoInsert  = new List<Case>();
        Case caserec1 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec1.Type = 'Invoice';
       // caserec1.CategoryForSubcategory__c = 'Request';
       // caserec1.Sub_Category__c = 'Credit Limit';
        caserec1.Description='Test Case';
        caserec1.SalesOrg__c = salorg.Id;
        
        insert caserec1;
        caserec1 = [Select Id, casenumber, subject, Type, status,  Description From Case where Id =: caserec1.Id];
        
        System.debug('caserec1 ' + caserec1);
        
        condocLink.ContentDocumentId  = condoc.Id;
        condocLink.LinkedEntityId = caserec1.id;
         insert condoclink;
        
    }  
    
    
    
    
/*    Public static testmethod  void createContentDocument1(){  // Boolean doInsert
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        ContentVersion cv = new ContentVersion();
        cv.Title = '#001-343434343';
        cv.PathOnClient = 'testDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        //if (doInsert) {
            Insert cv;
            List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
            List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            //return cdList[0];
            List<Case> casList = new List<Case>(); 
                
         Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',accRecordTypeId); 
        List<Case> casetoInsert  = new List<Case>();
        Case caserec1 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec1.Type = 'Invoice';
        caserec1.CategoryForSubcategory__c = 'Request';
        caserec1.Sub_Category__c = 'Credit Limit';
        caserec1.Description='Test Case';
        casList.add(caserec1);
        Case caserec2 = Grz_TestDataFactory.createCaseRecord(false, 'Test Case', 'New', acc.Id, recordTypeShowId);
        caserec2.Type = 'Invoice';
        caserec2.CategoryForSubcategory__c = '';
        caserec2.Sub_Category__c = '';
        caserec2.Description='Test Case';
        casList.add(caserec2);
        
        insert casList;
        
            List<ContentDocumentLink> cdLis1 = [Select LinkedEntityId from ContentDocumentLink where LinkedEntityId IN : casList.id];
            
            List<ContentVersion> cvList2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
            List<ContentDocument> cdList2 = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        insert cvList2;
        insert cdList2;
        //}        
        //else{
            //return null;
        //}
    } */
}