@isTest
public class RetailerWiseBusinessControllerTest {
    @isTest
    static void testController(){
        id userId =UserInfo.getUserId();
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Company_Code__c = '1000',    // Company Code
            Sales_Org_Code__c = '1000'  // Sales Org Code
        );
        insert salesOrgObj;
        SBU__c SBUObj = new SBU__c(
            SBUUser__c = userId, // SBU User
            SBUCode__c = 'SBU2',              // SBU Code
            SalesOrg__c = salesOrgObj.id  // Sales Org
        );
        insert SBUObj;
        
        Zone__c zoneObj = new Zone__c(
            Name = 'Indore',                 // Zone Name
            SalesOrg__c = salesOrgObj.Id,   // Sales Org
            ZoneCode__c = 'Z16',               // Zone Code
            ZonalHead__c = userId,  // Zonal Head
            ZMMUser__c = userId,
            SBUCode__c = SBUObj.id// SBU Code
        );
        insert zoneObj;
        Territory_Distributor__c territoryObj = new Territory_Distributor__c();
        territoryObj.Name = 'Narayangaon';
        territoryObj.TerritoryCode__c = '398';
        territoryObj.SalesOrg__c = salesOrgObj.id;
        territoryObj.TerritoryManager__c = userId;
        territoryObj.Zone__c = zoneObj.id;
        territoryObj.SBU__c = SBUObj.Id;
        territoryObj.SalesOrg__c = salesOrgObj.id;
        territoryObj.Present_in_KEDE__c = true ;
        territoryObj.Neglected__c = false;
        insert territoryObj;
        RetailerWiseBusinessController retailerWiseBusinessController = new RetailerWiseBusinessController();
        retailerWiseBusinessController.getOID();
    }
    
    @isTest
    static void testController2(){
        id userId =UserInfo.getUserId();
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Company_Code__c = '1000',    // Company Code
            Sales_Org_Code__c = '1000'  // Sales Org Code
        );
        insert salesOrgObj;
        
        SBU__c SBUObj1 = new SBU__c(
            SBUUser__c = userId, // SBU User
            SBUCode__c = 'SBU2',              // SBU Code
            SalesOrg__c = salesOrgObj.id  // Sales Org
        );
        insert SBUObj1;
        
        Zone__c zoneObj1 = new Zone__c(
            Name = 'Indore',                 // Zone Name
            SalesOrg__c = salesOrgObj.Id,   // Sales Org
            ZoneCode__c = 'Z16',               // Zone Code
            ZonalHead__c = userId,  // Zonal Head
            ZMMUser__c = userId,
            SBUCode__c = SBUObj1.id// SBU Code
        );
        insert zoneObj1;
        RetailerWiseBusinessController retailerWiseBusinessController = new RetailerWiseBusinessController();
        retailerWiseBusinessController.getOID();
    }
     @isTest
    static void testController3(){
        id userId =UserInfo.getUserId();
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Company_Code__c = '1000',    // Company Code
            Sales_Org_Code__c = '1000'  // Sales Org Code
        );
        insert salesOrgObj;
        
        SBU__c SBUObj1 = new SBU__c(
            SBUUser__c = userId, // SBU User
            SBUCode__c = 'SBU2',              // SBU Code
            SalesOrg__c = salesOrgObj.id  // Sales Org
        );
        insert SBUObj1;
        RetailerWiseBusinessController retailerWiseBusinessController = new RetailerWiseBusinessController();
        retailerWiseBusinessController.getOID();
    }
    
}