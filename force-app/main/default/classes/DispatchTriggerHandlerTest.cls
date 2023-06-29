@isTest
public class DispatchTriggerHandlerTest {
    @isTest
    public static void TestDispatch() {
        Test.startTest();  
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Chile','5661');
        Account acc = Grz_TestDataFactory.createUserAccount(true, 'Test Account',recordTypeId,sOrg.Id);
        Sales_Order__c salesObj = Grz_TestDataFactory.createSalesOrderRecord(true, '7062140268','Approved',Date.today(), acc.Id);
        Sales_Order_Line_Item__c lineItem = Grz_TestDataFactory.createsalesLineItemsRecord(true, salesObj.Id, 23);
        
        String myJSON = '{"resource":"dispatch_guide","event":"create","account_name":"Arysta","dispatch_guide":'+
        '{"guide":"107948","beecode":"149142c46e7ccfb8171dea10","identifier":"107948","account_id":2588,"promised_date":null,"contact_name"'+
        ':"ARYSTA LIFESCIENCE CHILE SA","contact_phone":null,"contact_identifier"'+
        ':null,"contact_email":null,"contact_address":"REQUINOA"},'+
        '"tags":[{"name":"Chofer","value":"RAFAEL SANTELICES"},{"name":"Patente","value":"PRCY-18"}],'+
        '"items":[{"id":534658622,"name":"AZOTE","description":"AZOTE","quantity":20,"original_quantity"'+
        ':20,"delivered_quantity":0,"code":null,"extras":[]}],"groups":[]}';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/upsertaccount';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(myJSON);
        RestContext.request = request;
        grz_BeeTrackIntegrationChile.HandleResponse();
        Test.stopTest();
        Dispatch__c dis = new Dispatch__c();
        dis.Sales_Order__c = salesObj.Id;
        dis.SKUDescription__c = 'AZOTE';
        dis.Quantity__c = 20;
        dis.SalesOrg__c = sOrg.Id;
        dis.SalesOrderLineItem__c = lineItem.Id;
        dis.Reference_Number__c = 'GD107948';
        insert dis;
        Dispatch__c disUp = new Dispatch__c();
        disUp.Id = dis.Id; 
        disUp.Reference_Number__c = 'GD0107948';
        update disUp;
    }
}