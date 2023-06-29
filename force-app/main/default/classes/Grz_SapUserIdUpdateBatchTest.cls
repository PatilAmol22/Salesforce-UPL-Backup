@isTest
public class Grz_SapUserIdUpdateBatchTest {
    public static testmethod void unitTest(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        List<String> dataList = System.Label.Grz_SapUserIdMapping.split(',');
        String salesorg = dataList[0].substringBefore('-').trim();
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org',salesorg);
        Account acc = new account();
        acc.name='test account';
        acc.RecordTypeId=recordTypeId;
        acc.SAP_Code__c='1224';
        acc.Sales_Org__c=sOrg.Id; 
        insert acc;
        Test.startTest();
        Grz_SapUserIdUpdateBatch obj = new Grz_SapUserIdUpdateBatch();
        DataBase.executeBatch(obj); 
        Grz_SapUserIdUpdateBatch testsche = new Grz_SapUserIdUpdateBatch();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
    }
    
}