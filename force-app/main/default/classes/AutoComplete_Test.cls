@isTest
public class AutoComplete_Test {
    static testMethod void testMethod1(){
        Autocomplete_Controller.getStateData();
        Autocomplete_Controller.getSuggestions('Depot__c', 'Depot_Code__c', '(Depot__r.Country__c = \'Europe\' AND RecordType.Name=\'Storage Location\')');
    }

}