@isTest
public  class CustomLookupControllerTest {
    @isTest
    public static void LookupControllerTest() {
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Account acc = Grz_TestDataFactory.createAccount(true, 'Test Account',recordTypeId);
        test.startTest();
        CustomLookupController.findRecords('Test','Account','Name');
        test.stopTest();
    }
}