@isTest
private class Lookup_Test {
    public static TestMethod void LookupTest(){
        Monitor_Log__c monObj = new Monitor_Log__c(
            Name = 'Test'
        );
        insert monObj;
        
        String name = [Select Name From Monitor_Log__c].Name;
        
        Lookup.searchDB('Monitor_Log__c', 'Id', 'Name', 5, 'Name', name,' AND Name != \'6451\'');
    }
}