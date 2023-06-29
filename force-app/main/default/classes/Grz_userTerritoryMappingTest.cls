@isTest
public class Grz_userTerritoryMappingTest
{
    public static testmethod void testTerritoryMap()
    {
        Sales_Org__c Sc = Grz_TestDataFactory.createSalesOrg(true,'india','1000');
        Territory_Distributor__c trt = Grz_TestDataFactory.createTeritory(false);
        trt.SalesOrg__c = Sc.id;
        insert trt;
        list<profile> pF = [select id from profile where name = 'India Partner Community Distributor Profile'];
        list<profile> pF1 = [select id from profile where name = 'System Administrator'];
        user u = Grz_TestDataFactory.createInternalUser(true,pF1[0].Id);
        
        Id accRecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'india', '1000');
        Account acc = Grz_TestDataFactory.createUserAccount(true,'Test Account',accRecordTypeId,sorg.Id);
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        
        Test.startTest();
        trt.TerritoryManager__c = u.id;
        update trt;
        User usr=new User();
        System.runAs(u){
            Group gg=Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(false,pF[0].Id,con.Id);
            usr.territory__c=trt.name;
            insert usr;
            GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
            trt.TerritoryManager__c = usr.id;
            update trt;
        }
        Test.stopTest();
    }
}