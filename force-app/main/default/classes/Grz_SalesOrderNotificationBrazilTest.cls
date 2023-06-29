@isTest
public class Grz_SalesOrderNotificationBrazilTest {
    @isTest
    public static void unitTest1(){
        Test.startTest();   
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','1000');
        Sales_Org__c sOrg1 = Grz_TestDataFactory.createSalesOrg(true, 'Org','5191');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        Account acc1 = new Account();
        acc1.Name = 'AccountName';
        acc1.RecordTypeId = recordTypeId;
        acc1.SAP_Code__c = '234442';
        acc1.Sales_Org__c = sOrg.id;
        acc1.Sap_UserId__c = 'UPLINTCRM';
        acc1.Sub_Parent_Account__c=acc.id;
        insert acc1;
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'Brazil Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr = new User();
        System.runAs(usr1){
            Group gg = Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(false,pro.Id,con.Id);
            usr.Sales_Order_Notification__c = true;
            insert usr;
            GroupMember gm = Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '7062133268','Approved',Date.today(), acc1.Id);
        salesObj1.Sales_Org_lk__c = sorg.Id;
        salesObj1.Invoice_Status__c = 'test';
        salesObj1.Type_of_Order__c='VENDA NORMAL';
        insert salesObj1;
        Sales_Order_Line_Item__c lineItem = Grz_TestDataFactory.createsalesLineItemsRecord(true, salesObj1.Id, 23);
        Brazil_Portal_Configuration__c bp = new Brazil_Portal_Configuration__c();
        bp.Name = 'Configuration';
        bp.Portal_Sales_Order_Type__c = 'CONTRATO MÃE \n VENDA NORMAL';
        insert bp;
        Test.stopTest();

        List<String> soIds = new List<String>();
        soIds.add(salesObj1.Id);
        Grz_SalesOrderNotificationBrazil.getSalesOrder(soIds);
    }
}