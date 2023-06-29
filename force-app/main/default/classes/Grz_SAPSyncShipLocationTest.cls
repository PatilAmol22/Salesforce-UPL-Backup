/**************************************************************************************************
* Name             : Grz_SAPSyncShipLocationTest                                                     
* Description      : To cover the Apex class Grz_SAPSyncShipLocation                     
* Created Date     : 25-01-2023                                                                       
* Project/JIRA     : UPL                                                                 
* Created By       : Ranjeet Sharma  (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 27-01-2023                                                                     
**************************************************************************************************/
@isTest
public class Grz_SAPSyncShipLocationTest {
    @testSetup static void setup() {     
        Sales_Org__c objSalesOrg = new Sales_Org__c();
        objSalesOrg.Name = 'test1';
        objSalesOrg.Sales_Org_Code__c = '3710';
        objSalesOrg.Company_Code__c='1200';
        
        insert objSalesOrg;
        
        
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account objAcc = new Account();
        objAcc.RecordTypeId = stExam;
        objAcc.Name = 'Test';
        objAcc.Sales_Org__c = objSalesOrg.Id;
        objAcc.sap_code__c = '13414';
        objAcc.Ship_To_Party_SAP_Code__c = '13414';

        objAcc.Email__c='taruni.uce@test.com';
        objAcc.GST_Validated__c=True;
        insert objAcc;
        
        
        Division__c objDiv = new Division__c();
        objDiv.Name = 'Testing';
        objDiv.Division_Code__c = '20';
        insert objDiv;
        
        Distribution_Channel__c objDivChannel = new Distribution_Channel__c();
        objDivChannel.Name = 'Testt';
        objDivChannel.Distribution_Channel_Code__c = '10';  
        insert objDivChannel;
        
        
        Shipping_Location__c ShippingLocData= Grz_TestDataFactory.CreateShippingLocation(True,objAcc.id,objDivChannel.id,objDiv.id,objSalesOrg.id);
        
        
    }
    /*@istest static void initiateSyncMethod1(){     
        list<Shipping_Location__c> ShippingLocData= [SELECT ID from Shipping_Location__c];
        
        Grz_SAPSyncShipLocation.initiateSync(ShippingLocData[0].id);    
        ShippingLocData[0].Country_Name__c='Nepal';
        update ShippingLocData;
        test.startTest();        
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(false));
        Grz_SAPSyncShipLocation.initiateSync(ShippingLocData[0].id);   
        test.stopTest();
    }
    */
    
    @istest static void initiateSyncMethod2(){     
        list<Shipping_Location__c> ShippingLocData= [SELECT ID from Shipping_Location__c];
        ShippingLocData[0].Billing_Street_1__c='Nepal';
        ShippingLocData[0].Billing_Street_2__c='Nepal';
        ShippingLocData[0].Billing_Street_3__c='Nepal';
        ShippingLocData[0].Billing_Street_4__c='Nepal';
        ShippingLocData[0].Location_Name__c='Nepal';
        ShippingLocData[0].Email_Id__c='Nepal@mt.everest';
        ShippingLocData[0].PAN_Number_Ship__c='1d13ed13';
        ShippingLocData[0].City__c='Nepal';
        ShippingLocData[0].state__c='Nepal';
        ShippingLocData[0].City__c='13411';
        ShippingLocData[0].Tax_Number_3__c='13d13';
        ShippingLocData[0].Depot_Code__c='13';
        ShippingLocData[0].Mobile_Number__c='8289717819386';
        ShippingLocData[0].Pincode__c='131331';
        ShippingLocData[0].Sold_To_Party_SAP_Code__c='123414';
        ShippingLocData[0].Country_Name__c='NP';
        update ShippingLocData;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));

        Grz_SAPSyncShipLocation.initiateSync(ShippingLocData[0].id);   
        test.stopTest();
    }
    @istest static void initiateSyncMethod3(){     
        list<Shipping_Location__c> ShippingLocData= [SELECT ID from Shipping_Location__c];
        ShippingLocData[0].Billing_Street_1__c='Nepal';
        ShippingLocData[0].Billing_Street_2__c='Nepal';
        ShippingLocData[0].Billing_Street_3__c='Nepal';
        ShippingLocData[0].Billing_Street_4__c='Nepal';
        ShippingLocData[0].Location_Name__c='Nepal';
        ShippingLocData[0].Email_Id__c='Nepal@mt.everest';
        ShippingLocData[0].PAN_Number_Ship__c='1d13ed13';
        ShippingLocData[0].City__c='Nepal';
        ShippingLocData[0].state__c='Nepal';
        ShippingLocData[0].City__c='13411';
        ShippingLocData[0].Tax_Number_3__c='13d13';
        ShippingLocData[0].Depot_Code__c='13';
        ShippingLocData[0].Mobile_Number__c='8289717819386';
        ShippingLocData[0].Pincode__c='131331';
        ShippingLocData[0].Sold_To_Party_SAP_Code__c='123414';
        update ShippingLocData;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));

        Grz_SAPSyncShipLocation.initiateSync(ShippingLocData[0].id);   
        test.stopTest();
    }
}