@isTest(SeeAllData=false)
public class grz_StockManagementTest {
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
        st.Name_And_City__c = 'test';
        st.Batch_Expiry_Date__c = Date.valueOf('2021-05-05');
        st.Product_Name__c = 'test';
        st.Batch__c = 'test';
        st.CNPJ_Client__c = '1234';
        insert st;
        
        Test.stopTest(); 
        PageReference pageRef = Page.Grz_StockManagementXLSVF; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('product','product');
        pageRef.getParameters().put('batch','batch');
        pageRef.getParameters().put('dueDate',string.valueOf(system.today()));
        pageRef.getParameters().put('endDate',string.valueOf(system.today().addDays(2)));
        pageRef.getParameters().put('type','type');
        pageRef.getParameters().put('nameAndCity','nameAndCity');
        pageRef.getParameters().put('distributor','distributor');
        Test.setCurrentPage(pageRef);
        grz_StockManagement ob= new grz_StockManagement();
        ob.getDataForVF();
        grz_StockManagement.getStockData(1, 10, 'test', 'test', '2021-05-05','2021-05-05', 'Yes','All','test','');
        grz_StockManagement.updateCheckbox(true);
    }
}