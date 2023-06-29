@isTest
public class Grz_InventoryExpiryNotificationTest {
    @isTest
    public static void unitTest1(){
        Test.startTest();   
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','5191');
        Account acc = Grz_TestDataFactory.createUserAccount(false, 'Test Account',recordTypeId,sOrg.Id);
        acc.Tax_Number_1__c = '1234';
        insert acc;
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Contact con1 = Grz_TestDataFactory.createContact(true, 'Test Contact1',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'Brazil Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr = new User();
        System.runAs(usr1){
            Group gg = Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(false,pro.Id,con.Id);
            usr.Inventory_Expiry_Notification__c = true;
            insert usr;
            usr1 = Grz_TestDataFactory.createExternalUser(false,pro.Id,con1.Id);
            usr1.Inventory_Expiry_Notification__c = true;
            insert usr1;
            GroupMember gm = Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
        Decimal days = Brazil_Portal_Configuration__c.getOrgDefaults().Inventory_Expiration_Days__c;
        Integer expiryDays = days != null ? Integer.valueOf(days) : 0;
        Date todayDate = System.today();
        Date expiryDate = todayDate.addDays(expiryDays);
        Stock_Management__c st = new Stock_Management__c();
        st.Name_And_City__c = 'test';
        st.Batch_Expiry_Date__c = expiryDate;
        st.Product_Name__c = 'test';
        st.Batch__c = 'test';
        st.CNPJ_Client__c = '1234';
        insert st;
        Stock_Management__c st1 = new Stock_Management__c();
        st1.Name_And_City__c = 'test1';
        st1.Batch_Expiry_Date__c = expiryDate;
        st1.Product_Name__c = 'test1';
        st1.Batch__c = 'test1';
        st1.CNPJ_Client__c = '1234';
        insert st1;
        Test.stopTest();
        Grz_InventoryExpiryNotificationBRBatch b = new Grz_InventoryExpiryNotificationBRBatch(); 
        database.executebatch(b);
    }
}