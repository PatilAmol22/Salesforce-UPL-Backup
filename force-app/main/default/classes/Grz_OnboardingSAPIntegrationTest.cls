/**************************************************************************************************
* Name             : Grz_OnboardingSAPIntegrationTest                                                     
* Description      : To cover the Apex class Grz_OnboardingSAPIntegration					 
* Created Date     : 26-01-2023                                                                       
* Project/JIRA     : UPL                                                                 
* Created By       : Rahul Mehta  (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 01-02-2023                                                                     
**************************************************************************************************/
@isTest
public class Grz_OnboardingSAPIntegrationTest {
    @isTest static void testcustomerCreation1(){
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        List<Grz_Customer360IntegrationMappings__mdt> c=[Select Company_Code__c,Sales_Org_Code__c,EndPointURL__c,Country__c,Customer_Creation_API_URL__c,Customer_Extension_API_URL__c,Customer_Modification_API_URL__c,Ship_to_API_URL__c,id from Grz_Customer360IntegrationMappings__mdt limit 1];
         test.startTest();
        String urlConc='Customer_Onboarding_Ship_To_Party_IND';
        string body='{"AcctAssignmentGroup":"04","Authorization":"DT05","City":"Nabha","CompanyCode":"1000","CorporateGroup":"1000","Country":"IN","DistributionChannel":"20","Distributor":"0001001255","Distributor_Name":"M/S.JANARDAN PARUI - AMTALA","Division":"10","EInvoicecategory":"2","Email":"dsds@fdf.fdf","GSTNumber":"21343124","Mobile":"323232332","PANNumber":"21343124","Pincode":"147201","SalesOrg":"1000","State":"19","Street1":"Ajit Nagar","Street2":"Street number 2","Street3":"24 PARAGANAS ( SOUTH )","Street4":"67867","TransportaionZone":"IN"}';
        Grz_OnboardingSAPIntegration.customerCreation(body,c[0]);
        Grz_OnboardingSAPIntegration.DistributorModification(body,c[0]);
        Grz_OnboardingSAPIntegration.salesAreaExtention(body,c[0]);
        
        Grz_OnboardingSAPIntegration.syncMethod(body, c[0]);
        test.stopTest();
}
        @isTest static void testcustomerCreation2(){
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(false));
            List<Grz_Customer360IntegrationMappings__mdt> c=[Select Company_Code__c,Sales_Org_Code__c,EndPointURL__c,Country__c,Customer_Creation_API_URL__c,Customer_Extension_API_URL__c,Customer_Modification_API_URL__c,Ship_to_API_URL__c,id from Grz_Customer360IntegrationMappings__mdt limit 1];
         test.startTest();
        String urlConc='Customer_Onboarding_Ship_To_Party_IND';
        string body='{"AcctAssignmentGroup":"04","Authorization":"DT05","City":"Nabha","CompanyCode":"1000","CorporateGroup":"1000","Country":"IN","DistributionChannel":"20","Distributor":"0001001255","Distributor_Name":"M/S.JANARDAN PARUI - AMTALA","Division":"10","EInvoicecategory":"2","Email":"dsds@fdf.fdf","GSTNumber":"21343124","Mobile":"323232332","PANNumber":"21343124","Pincode":"147201","SalesOrg":"1000","State":"19","Street1":"Ajit Nagar","Street2":"Street number 2","Street3":"24 PARAGANAS ( SOUTH )","Street4":"67867","TransportaionZone":"IN"}';
        Grz_OnboardingSAPIntegration.customerCreation(body,c[0]);
        Grz_OnboardingSAPIntegration.DistributorModification(body,c[0]);
        Grz_OnboardingSAPIntegration.salesAreaExtention(body,c[0]);
        
        Grz_OnboardingSAPIntegration.syncMethod(body,c[0]);
        test.stopTest();
}
    @isTest static void testcatchExceptions(){
        Test.setMock(HttpCalloutMock.class, new Grz_PANGSTValidationCallout(false));
        List<Grz_Customer360IntegrationMappings__mdt> c=[Select Company_Code__c,Sales_Org_Code__c,EndPointURL__c,Country__c,Customer_Creation_API_URL__c,Customer_Extension_API_URL__c,Customer_Modification_API_URL__c,Ship_to_API_URL__c,id from Grz_Customer360IntegrationMappings__mdt limit 1];
         test.startTest();
        String urlConc='Customer_Onboarding_Ship_To_Party_IND';
        string body='{"AcctAssignmentGroup":04,"Authorization":"DT05","City":"Nabha","CompanyCode":"1000","CorporateGroup":"abcd","Country":"IN","DistributionChannel":"20","Distributor":"0001001255","Distributor_Name":"M/S.JANARDAN PARUI - AMTALA","Division":"10","EInvoicecategory":"2","Email":"dsds@fdf.fdf","GSTNumber":"21343124","Mobile":"323232332","PANNumber":"21343124","Pincode":"147201","SalesOrg":"","State":"19","Street1":"Ajit Nagar","Street2":"Street number 2","Street3":"24 PARAGANAS ( SOUTH )","Street4":"67867","TransportaionZone":"IN"}';
       // String sub = 'abcde'.substring(2);
       // Assert.areEqual('{"AcctAssignmentGroup":04,"Authorization":"DT05"}', body, 'check ');
        Grz_OnboardingSAPIntegration.customerCreation(body,c[0]);
        
        Grz_OnboardingSAPIntegration.syncMethod(body,c[0]);
        
        try{
            integer i=null;
            integer q=3*i;
        }
        catch(exception e){
            Grz_OnboardingSAPIntegration.errorHandler(e);
        }
        test.stopTest();
    }
}