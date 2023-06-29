@isTest
public class MandiControllerNewTest {
    private static testMethod void unit1(){
        Id AccRecordId = Schema.SObjectType.account.getRecordTypeInfosByDeveloperName().get('Hannaford_Farm').getRecordTypeId();
        Account acc = new Account(Name = 'Test', Email__c = 'kuhinoor.barbhuiya@ibm.com',
                                  LegacyId__c='112233', Mobile__c='1234567890',recordTypeId = AccRecordId);
        // insert acc;
        MandiControllerNew.getAccountDetails(acc.Id);
        
        Test.setMock(HttpCalloutMock.class, new MandiHttpCalloutMockNew1()); 
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        MandiControllerNew md = new MandiControllerNew(sc);
        
        md.beginning();
        md.end();
        md.getnxt();
        md.getprev();
        md.next();
        md.previous();
        MandiControllerNew.getStates();
        MandiControllerNew.getDistricts('2473');
        MandiControllerNew.getCrops();
        Test.setMock(HttpCalloutMock.class, new MandiHttpCalloutMockNew2());
        
        List<MandiControllerNew.MandiWrapper> mandiValLst=new List<MandiControllerNew.MandiWrapper>();
        mandiValLst=MandiControllerNew.getMandiPriceDetails('2473');
        //RITM0465177-Added by Nandhini to increase the code coverage
        MandiControllerNew.MandiWrapper wrapperMandi=new MandiControllerNew.MandiWrapper();
        wrapperMandi.product='Beetroot';
        wrapperMandi.variety='Narma BT Cotton';
        wrapperMandi.market='Rajkot';
        wrapperMandi.district='Rajkot';
        wrapperMandi.state='Gujarat';
        wrapperMandi.modalPrice='8750';
        wrapperMandi.maxPrice='9000';
        wrapperMandi.minPrice='8500';
    }
}