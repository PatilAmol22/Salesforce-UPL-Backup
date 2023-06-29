@isTest
public class NeoFogBuildingGoogleMapController_Test {

     Public  static testmethod void testOne(){
         
         Test.startTest();   
         
         Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'France Org', '2710');
         
            Sales_District__c sdObj = new   Sales_District__c();
            sdObj.Name = 'NeoFog';
            sdObj.Sales_District_Code__c = 'France0101';
            sdObj.SalesOrg__c = sOrg.Id;
            insert sdObj;
         
 //     Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Neo_Fog').RecordTypeId;
        Account acc = new Account();
 //      acc.RecordTypeId = recordTypeId;
         acc.Name = 'DELAITRE';
         acc.Sales_District__c = sdObj.Id;
        acc.SAP_Code__c = '1067145';
        insert acc;
         
      Neofog_Building__c NBObj = new Neofog_Building__c();
         NBObj.Name = 'Bât - SAINT REMY SOUS BROYES';
         NBObj.Account_Name__c = acc.Id;
         NBObj.GPS_Coordinates__Latitude__s = 48.702828;
         NBObj.GPS_Coordinates__Longitude__s = 3.775947;  
         NBObj.Structure_capacity__c = 12;
         insert NBObj;
         
         List<Neofog_Building__c> NBListObj = NeoFogBuildingGoogleMapController.getNeoFogBuilding(NBObj.Id);
        
        Test.stopTest(); 
        //new Grz_BrazilAccountStatement().Grz_AccountPDFControllerData();
        
         
         
  }
}