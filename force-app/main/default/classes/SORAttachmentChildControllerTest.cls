@isTest
public class SORAttachmentChildControllerTest {
    @TestSetup
    public static void testData(){
        
        Return_Sales_Order__c sor=new Return_Sales_Order__c();
        sor.SFDC_Order_Number__c='RSO-2701202300000001';
        insert sor;
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = sor.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl; 
    }
     @istest
    public static void searchTest(){
        Return_Sales_Order__c sorId=[select id,SFDC_Order_Number__c from Return_Sales_Order__c];
        ContentVersion conDocId = [SELECT Id, ContentDocumentId FROM ContentVersion];
        
        Test.startTest();
        SORAttachmentChildController.getSORAttachments(sorId.Id);
        SORAttachmentChildController.deleteContentDocument(conDocId.ContentDocumentId);
        SORAttachmentChildController.getSORAttachments(null);
        SORAttachmentChildController.deleteContentDocument(conDocId.Id);
        Test.stopTest();
    }
}