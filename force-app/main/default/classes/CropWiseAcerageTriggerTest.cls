@isTest
public class CropWiseAcerageTriggerTest {
    @isTest
    public static void testmethod1(){
        Account a = TestDataFactory.CreateAccount('1234');
        Crop_Wise_Acerage__c CWA = new Crop_Wise_Acerage__c();
        CWA.Farmer__c = a.id;
        CWA.Crop_Potential_Type__c = 'TS';
        CWA.Crop_Category_1__c = 'Grandes cultures';
        CWA.Crop_category_2__c = 'Betteraves';
        CWA.Acerage_new__c = 1;
        insert CWA;
        
    }

}