@isTest
public class MandiControllerTest {
    private static testMethod void unit1(){
        Id AccRecordId = Schema.SObjectType.account.getRecordTypeInfosByDeveloperName().get('Hannaford_Farm').getRecordTypeId();
        Account acc = new Account(Name = 'Test', Email__c = 'kuhinoor.barbhuiya@ibm.com',
                                  LegacyId__c='112233', Mobile__c='1234567890',recordTypeId = AccRecordId);
        // insert acc;
        MandiController.getAccountDetails(acc.Id);

        Test.setMock(HttpCalloutMock.class, new MandiHttpCalloutMock()); 
        MandiController.fetchMandiPrice(); 
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        MandiController md = new MandiController(sc);
        md.getMandiPriceData();
        md.beginning();
        md.end();
        md.getnxt();
        md.getprev();
        md.next();
        md.previous();
        md.searchStr='test';
        md.search();
        
    }
}