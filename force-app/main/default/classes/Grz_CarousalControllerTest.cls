@isTest(SeeAllData=false)
public class Grz_CarousalControllerTest {
	
    Public  static testmethod void testCarouselData(){		
        Id recordTypeShowId = Schema.SObjectType.Partner_Portal_Configuration__c.RecordTypeInfosByName.get('Carousel Image').RecordTypeId;     	
        Partner_Portal_Configuration__c partnerObj = Grz_TestDataFactory.createSummaryTabs(false, 'Test Tab1', 'TestTab1', 1, 'TestTab1Url','en-US', recordTypeShowId);         
        partnerObj.Background_Image__c = '<p><img alt="Group 1970.png" src="https://upl--dev6--c.documentforce.com/servlet/rtaImage?eid=a7g6D0000004TtH&amp;feoid=00N6D000008p5mo&amp;refid=0EM6D0000001bkC"></img></p>';
        insert partnerObj;
         Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','5190');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        Contact con = Grz_TestDataFactory.createContact(false, 'Test Contact',acc.Id);
        con.Terms_Accepted__c = true;
        insert con;
       
        System.assert(partnerObj.id != null, 'Fail to create Partner Portal Configuration Record!');
        Grz_CarousalController.getCarouselData(partnerObj.Language__c);  
         Grz_CarousalController.updateTerms(con.Id);
    }
    
}