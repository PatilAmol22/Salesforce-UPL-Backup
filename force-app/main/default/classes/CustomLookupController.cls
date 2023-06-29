public with sharing class CustomLookupController {
    @AuraEnabled
    public static List<SObject> findRecords(String searchKey, String objectName, String searchField){
        String key = '%' + searchKey + '%';
        String QUERY = 'select Id, ' + searchField + ' From ' + objectName + ' Where ' + searchField + ' LIKE : key limit 5';
        List<SObject> sObjectList = Database.query(QUERY);
        return sObjectList;
     }
}