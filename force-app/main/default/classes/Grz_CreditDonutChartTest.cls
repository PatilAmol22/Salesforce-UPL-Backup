@isTest(SeeAllData=false)
public class Grz_CreditDonutChartTest {
    /*Public  static testmethod void testCreditDonutChart(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','1000');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
        Group gg=Grz_TestDataFactory.creategroup(true);
        User usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
        GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        Test.stopTest(); 
        Grz_CreditDonutChart.getDonData();
        Grz_CreditDonutChart.getDonDataBrazil();
        Grz_CreditDonutChart.credit cfo =  new Grz_CreditDonutChart.credit();
        cfo.Salesorg = '1000';  
    }*/
    Public  static testmethod void testCreditDonutChart(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','1000');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'India Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        Territory_Distributor__c objTe = new Territory_Distributor__c();
        objTe.Name = 'test';
        objTe.TerritoryCode__c	= '1000';
        insert objTe;
        DistributorSalesAreaMapping__c objSalesArea = Grz_TestDataFactory.CreateSalesArea(true, acc, String.valueOf(sOrg.Id), objTe.Id);
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        User usr=new User();
        System.runAs(usr1){
            Group gg=Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
            GroupMember gm=Grz_TestDataFactory.createGM(true,gg.Id,usr.id);
        }
        System.runAs(usr){
        	Grz_CreditDonutChart.getSalesAreaOptions();
        }
        
        Test.stopTest();
        Grz_CreditDonutChart.getDonData(sOrg.Company_Code__c);
        Grz_CreditDonutChart.getDonDataBrazil();
        //Grz_CreditDonutChart.getDonDataMexico();
        Grz_CreditDonutChart.credit cfo =  new Grz_CreditDonutChart.credit();
        cfo.Salesorg = '1000'; 
        cfo.customer_number = 'test';
        cfo.name = 'test';
        cfo.Credit_exposure = 'test';
        Grz_CreditDonutChart.ParentResultWrapper pr =  new Grz_CreditDonutChart.ParentResultWrapper();
        pr.isSuccess = true;
        pr.Message = 'test';
        
    }
    
    Public  static testmethod void testDonut2(){
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Id recordTypeId1 = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrgChile = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','5660');
        Account accChile = Grz_TestDataFactory.createUserAccount(false, 'Test Account1',recordTypeId1,sOrgChile.Id);
        accChile.SAP_Code__c='0001085776';
        insert accChile;
        Contact conChile = Grz_TestDataFactory.createContact(true, 'Test Contact',accChile.Id);
        Profile proChile = [SELECT Id FROM Profile WHERE Name = 'Chile Partner Community Distributor Profile'];
        User usr=new User();
        usr = Grz_TestDataFactory.createExternalUser(true,proChile.Id,conChile.Id);
        Test.stopTest();
        Grz_CreditDonutChart.getDonDataChile(accChile.Id);
    }
    
    
    Public  static testmethod void testDonut3(){
        
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Profile proChile1 = [SELECT Id FROM Profile WHERE Name = 'Chile Read Only'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,proChile1.Id);
        Sales_Org__c sOrgChile = new Sales_Org__c();
        System.runAs(usr1){
            sOrgChile.name = 'Test Org';
            sOrgChile.Company_Code__c= '5661';
            sOrgChile.Sales_Org_Code__c= '5661';
            insert sOrgChile;
            Id recordTypeId1 = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
            Account a = new account();
            a.name = 'test';
            a.Sap_UserId__c = 'UPLINTCRM';
            a.SAP_Code__c  = '0001085776';
            a.Sales_Org__c = sOrgChile.id;
            a.RecordTypeId = recordTypeId1 ;
            insert a;
            Test.startTest();   
            Grz_CreditDonutChart.getDonDataChile(a.Id);
        }
        Test.stopTest();
    }
    
    Public  static testmethod void testCreditDonutChartMexico(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(false, 'Mexico','5100');
        sOrg.Company_Code__c = '5000';
        insert sOrg;
		Account acc = Grz_TestDataFactory.createUserAccount(false, 'Test Account',recordTypeId,sOrg.Id);
        acc.SAP_Code__c = '0001006761';
        acc.sap_UserId__c = 'UPLINTCRM';
        insert acc;
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'Mexico Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        User usr=new User();
        System.runAs(usr1){
            Group gg=Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
        } 
        Test.stopTest();
        Grz_CreditDonutChart.getDonDataMexico();

    }
/**************************************************************************************************
* @Description       : test method created for covering the method introduced to get Argentina chart data                                                      
* Date               : 11-08-2022
* Project/JIRA       : APPS-1757                                                                        
* Author             : Gurubaksh Grewal
* @Return            : Void
* Last Modified By 	 : Gurubaksh Grewal (Grazitti) 17-08-2022                                                                        
**************************************************************************************************/
    
    Public  static testmethod void testCreditDonutChartArgentina(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(false, 'Argentina','5100');
        sOrg.Company_Code__c = '5000';
        insert sOrg;
		Account acc = Grz_TestDataFactory.createUserAccount(false, 'Test Account',recordTypeId,sOrg.Id);
        acc.SAP_Code__c = '0001006761';
        acc.sap_UserId__c = 'UPLINTCRM';
        insert acc;
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
         List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'Argentina Partner Community Distributor Profile'];
        List<Profile> pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        if(!pro1.isEmpty()){
            User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1[0].Id);
            Test.startTest();   
            Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
            User usr=new User();
            System.runAs(usr1){
                Group gg=Grz_TestDataFactory.creategroup(true);
                if(!pro.isEmpty())
                usr = Grz_TestDataFactory.createExternalUser(true,pro[0].Id,con.Id);
            } 
            Test.stopTest();
        }
        Grz_CreditDonutChart.getDonDataArgentina();

    }
    
}