@isTest(SeeAllData=false)
public class Grz_StockReportTest {
    Public  static testmethod void teststockManagement(){
        Test.startTest();   
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','5191');
        Account acc = Grz_TestDataFactory.createUserAccount(false, 'Test Account',recordTypeId,sOrg.Id);
        acc.Tax_Number_1__c = '1234';
        acc.Customer_Group__c = '97';
        insert acc;
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'Brazil Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr=new User();
        System.runAs(usr1){
            Group gg=Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
            GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
        Stock_Management__c st = new Stock_Management__c();
        st.C_d_prod_ind_stria__c = 'test';
        st.Batch_Expiry_Date__c = Date.valueOf('2021-05-05');
        st.Descri_o_produto__c = 'test';
        st.Lote__c = 'test';
        st.CNPJ_Client__c = '1234';
        insert st;
        Test.stopTest();
        Grz_StockReport.getStockData('All',''); 
        Grz_StockReport.getStockData('88680095000182','');
        Grz_StockReport.getStockData('All','1243');
      
    }
}