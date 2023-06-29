@isTest
public class LiquidationLookupControllerPolandTest {
	
    Public  static testmethod void testSearchedListPoland(){
        
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Poland','2941');
        Account acc = Grz_TestDataFactory.createUserAccount(false, 'Test Account',recordTypeId,sOrg.Id);
        acc.Active_For_Liquidation__c = true;
        insert acc;    
        Territory_Distributor__c tr = Grz_TestDataFactory.createTeritory(true);
        DistributorSalesAreaMapping__c dsa = Grz_TestDataFactory.CreateSalesArea(false,acc,sOrg.Id,tr.Id);
        dsa.AccountType__c = 'Sold To Party';
        insert dsa;
        Test.startTest();
        LiquidationLookupControllerPoland.searchedListPoland('DistributorSalesAreaMapping__c','count( Id), Distributor__c,Distributor__r.Name,Distributor__r.SAP_code__c','',
                                                            'AccountType__c=\'Sold To Party\' and Distributor__r.Active_for_Liquidation__c=true and Distributor__r.RecordType.Name=\'Distributor\' group by Distributor__c ,Distributor__r.Name, Distributor__r.SAP_code__c HAVING count(ID) >=1','distributor');
        Test.stopTest();
    } 
}