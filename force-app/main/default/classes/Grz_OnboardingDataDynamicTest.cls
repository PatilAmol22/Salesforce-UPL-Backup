/**************************************************************************************************
* Name               : Grz_OnboardingDataDynamicTest                                                      
* Description        : Used for Customer Onboarding                                                                
* Created By         : Sumit Kumar(Grazitti)   
* JIRA               : APPS-2662,APPS-2665
**************************************************************************************************/
@isTest
public class Grz_OnboardingDataDynamicTest {
	
    @isTest static void testGetTableData(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Customer On-Boarding').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'India','1000');
        Account acc = Grz_TestDataFactory.createUserAccount(false, 'Grazitti Test Account',recordTypeId,sOrg.Id);
        acc.Mobile__c = '9192929299';
        insert acc;
        Territory_Distributor__c terr = Grz_TestDataFactory.createTeritory(true);
        Grz_TestDataFactory.CreateSalesArea(true,acc,sOrg.Id,'');
        List<DistributorSalesAreaMapping__c> lstSalesArea = [Select id, Name From DistributorSalesAreaMapping__c Where Distributor__c = :acc.Id];
        
        String query = 'Select Name,Address__c,PAN__c,Adhaar__c,Relationship__c,Profit_Sharing_Ratio__c from On_Boarding_Partner__c';
        
        Grz_OnboardingDataDynamic.getTableData('On_Boarding_Partner__c', query,  lstSalesArea[0].Id);
        Grz_OnboardingDataDynamic.getPickList('On_Boarding_Partner__c', 'CurrencyIsoCode');
    }
}