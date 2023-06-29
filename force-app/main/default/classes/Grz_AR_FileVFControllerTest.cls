@isTest(SeeAllData=false)
public class Grz_AR_FileVFControllerTest {
    Public  static testmethod void testAccReceivablesTest(){
        
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','5190');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
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
        Test.startTest();   
        PageReference pageRef = Page.Grz_ARxlsDownload; // Add your VF page Name here
        pageRef.setRedirect(true);
        pageRef.getParameters().put('distributorValue','All');
        pageRef.getParameters().put('refSearch','000028');
        pageRef.getParameters().put('dueDate','2021-05-20');
        Test.setCurrentPage(pageRef);
        Grz_AR_FileVFController abc = new Grz_AR_FileVFController();
        abc.Grz_ARactionVF();
        Test.stopTest(); 
        PageReference pageRef1 = Page.Grz_ARxlsDownload; // Add your VF page Name here
        pageRef1.setRedirect(true);
        pageRef1.getParameters().put('distributorValue','All');
        pageRef1.getParameters().put('refSearch','000028');
        Test.setCurrentPage(pageRef1);
        Grz_AR_FileVFController abc1 = new Grz_AR_FileVFController();
        abc1.Grz_ARactionVF();
        Grz_AR_FileVFController.ARWrapper ar = new  Grz_AR_FileVFController.ARWrapper();
        Grz_AR_FileVFController.Br_Account_receivable arl = new Grz_AR_FileVFController.Br_Account_receivable();
        List<Grz_AR_FileVFController.ARWrapper> arlis = new List<Grz_AR_FileVFController.ARWrapper>();
        arl.Account_Receivables = arlis;
        ar.account_in_local_currency = 'test';
        ar.accounting_document_number = 'test';
        ar.amount_in_document_currency_PRTVLR = 'test';
        ar.amount_in_document_currency_WRBTR = 'test';
        ar.Assignment_Number_for_Special_GL_Accounts = 'test';
        ar.baseline_date_for_due_date_calculation = 'test';
        ar.Cash_Discount_Percentage_1 = 'test';
        ar.CSname = 'test';
        ar.currency_key_WAERS = 'test';
        ar.customer_number = 'test';
        ar.Customers_account_number_with_credit_limit_reference = 'test';
        ar.document_date_in_document = 'test';
        ar.document_type = 'test';
        ar.Payment_Method_ZLSCH = 'test';
        ar.Reference_Document_Number = 'test';
        ar.Short_Key_for_a_House_Bank = 'test';
    }
    Public  static testmethod void testAccReceivablesTest1(){
        
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','5190');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
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
        Test.startTest();   
        PageReference pageRef = Page.Grz_ARxlsDownload; // Add your VF page Name here
        pageRef.getParameters().put('distributorValue','0001033252');
        Test.setCurrentPage(pageRef);
        Grz_AR_FileVFController abc = new Grz_AR_FileVFController();
        abc.Grz_ARactionVF();
        Test.stopTest(); 
        PageReference pageRef1 = Page.Grz_ARxlsDownload; // Add your VF page Name here
        pageRef1.setRedirect(true);
        pageRef1.getParameters().put('distributorValue','0001033252');
        pageRef1.getParameters().put('refSearch','000028');
        Test.setCurrentPage(pageRef1);
        Grz_AR_FileVFController abc1 = new Grz_AR_FileVFController();
        abc1.Grz_ARactionVF();
    }
}