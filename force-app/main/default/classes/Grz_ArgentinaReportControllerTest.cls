/**************************************************************************************************
* Name             : Grz_ArgentinaReportControllerTest                                                     
* Description      : To cover the controller class Grz_ArgentinaReportController
* Created Date     : 23-08-2022                                                                        
* Project/JIRA     : APPS-1757                                                                        
* Created By       : Mohit Garg (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 10-10-2022                                                                        
**************************************************************************************************/

@isTest
public class Grz_ArgentinaReportControllerTest {
    public static testmethod void testOfArgentinaReport(){
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(false, 'Argentina','5631');
        sOrg.Company_Code__c = '5630';
        insert sOrg;
        Sales_District__c salesObj = new Sales_District__c();
        salesObj.Name = 'test';
        salesObj.Sales_District_Code__c = '5631';
        insert salesObj;
        Account acc = Grz_TestDataFactory.createUserAccount(false, 'Test Account',recordTypeId,sOrg.Id);
        acc.SAP_Code__c = '0001013516';
        acc.sap_UserId__c = 'UPLINTCRM';
        acc.BillingCity = 'CARLOS CASARES';
        acc.Sales_District__c = salesObj.Id;
        insert acc;
        Contact con = Grz_TestDataFactory.createContact(true, 'Test Contact',acc.Id);
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'Argentina Partner Community Distributor Profile'];
        Profile pro1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr1 = Grz_TestDataFactory.createInternalUser(true,pro1.Id);
           
         
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        User usr=new User();
        System.runAs(usr1){
            Group gg = Grz_TestDataFactory.creategroup(true);
            usr = Grz_TestDataFactory.createExternalUser(true,pro.Id,con.Id);
        }     
        
        Test.startTest();
        Grz_ArgentinaReportController.getReportData('Customer', '2021', '8', '8');
        Grz_ArgentinaReportController.getReportData('', '2021', '8', '8');
        Grz_ArgentinaReportController.loggedUserData();
        Test.stopTest(); 
    }
}