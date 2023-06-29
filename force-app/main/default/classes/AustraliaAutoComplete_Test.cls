@isTest
public class AustraliaAutoComplete_Test {
    static testMethod void testMethod1(){
        AustraliaAutocomplete_Controller.getStateData();
        AustraliaAutocomplete_Controller.getSuggestions('Depot__c', 'Depot_Code__c', '(Depot__r.Country__c = \'Australia\' AND RecordType.Name=\'Storage Location\')');
    }

}