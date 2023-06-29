/*
Class Name : CropLiquidationBatchTest
Description : Test Class For TestCropLiquidationBatch
Author : Bonny Mathews
Date : 05/08/2022
*/
@IsTest
public class CropLiquidationBatchTest {
	static final String rtForAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
    static final String rtForOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
    static final String rtForLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
    static final String rtForCropLiquidation = Schema.SObjectType.Crop_Liquidation__c.getRecordTypeInfosByName().get('CropSwalTrade').getRecordTypeId();
	@TestSetup
    public static void testSetupData(){
    	Integer curMonth = Date.Today().Month();
        
        //Custom Setting record
        MultiCountry_Liquidation__c multiCountCS = new MultiCountry_Liquidation__c();
        multiCountCS.Active__c = true;
        multiCountCS.Month__c = String.valueOf(curMonth);
        multiCountCS.Name = 'SWAL';
        INSERT multiCountCS;
        
        Trigger_Settings__c record = new Trigger_Settings__c();
        record.Name = 'LiquidationTrigger';
        record.IsActive__c	= false;
        insert record;
        
        Trigger_Settings__c record1 = new Trigger_Settings__c();
        record1.Name = 'LiquidationApprovalTrigger';
        record1.IsActive__c	= false;
        insert record1;
        
        //AF Sales Org
        Sales_Org__c sorg = new Sales_Org__c();
        sorg = LiquidationTestDataFactory.createSalesOrg('SWAL', '1210');
        
        //Profile queries
        String tmProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager SWAL'].Id;
        String rmProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Manager SWAL'].Id;
        //String sbuProfileId = [SELECT Id FROM Profile WHERE Name = 'SBU Profile'].Id;
        
        //user Creation
        //TM User
        User tmUsr = LiquidationTestDataFactory.createUser(tmProfileId, 'tmTestUser', 'SWAL');
        //RM User
        User rmUsr = LiquidationTestDataFactory.createUser(rmProfileId, 'rmTestUser', 'SWAL');
        //FMM User
        User fmmUsr = LiquidationTestDataFactory.createUser(rmProfileId, 'fmmTestUser', 'SWAL');
        //zm User
        User zmUsr = LiquidationTestDataFactory.createUser(rmProfileId, 'zmTestUser', 'SWAL');
        //zmm User
        User zmmUsr = LiquidationTestDataFactory.createUser(rmProfileId, 'zmmTestUser', 'SWAL');
        
        //Zone Creation
        Zone__c zoneObj = LiquidationTestDataFactory.createZone('Test Zone', sorg.Id, 'ZONE1', '', zmUsr.Id, zmmUsr.Id);

        //Region creation
        Region__c regionObj = LiquidationTestDataFactory.createRegion('Test Region', 'REG01', sorg.Id, rmUsr.Id, fmmUsr.Id, zoneObj.Id);
        
        //Territory Creation
        Territory_Distributor__c territory = LiquidationTestDataFactory.createTerritory('Test Territory', '001', sorg.Id, '', regionObj.Id, '', tmUsr.Id);
        
        //Product Creation
        List<Product2> productList = LiquidationTestDataFactory.createProductList(5, sorg.Id,'1210');
        
        //Crop Creation
        List<Crop__c> cropList = LiquidationTestDataFactory.createCropList(5, sorg.Id,'1210');
        
        Liquidation_Annual_Plan__c lap =  LiquidationTestDataFactory.createLAP(rtForAnnualPlan, territory.SalesOrg__c, territory.Id);
        
        //Create Opening Inventory records
        List<Opening_Inventory2__c> opnInvList = new List<Opening_Inventory2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 LIMIT 5]){
            Opening_Inventory2__c opInv = new Opening_Inventory2__c();
            opInv.Liquidation_Annual_Plan__c = lap.Id;
            opInv.Product__c = prod.Id;
            opInv.Territory__c = territory.Id;
            opInv.Opening_Inventory__c = 1000.00;
            opInv.YTD_Sales_Aug__c = 2000.00;
            opInv.CurrencyIsoCode = 'INR';
            opInv.RecordTypeId = rtForOpeningInventory;
            opnInvList.add(opInv);
        }
        INSERT opnInvList;
        
        //Create Product Liquidation for Last Month - Jul
        List<Liquidation2__c> currMonthLiqList = new List<Liquidation2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 LIMIT 5]){
            Liquidation2__c liq = new Liquidation2__c();
            liq.Liquidation_Annual_Plan__c = lap.Id;
            liq.Territory__c = territory.Id;
            liq.Product__c = prod.Id;
            liq.YTD_Sales__c = 2000.00;
            liq.Distributors_Inventory__c = 100.00;
            liq.Distributor_Inventory_Previous_Month__c = 100.00;
            liq.Retailers_Inventory__c = 0.00;
            liq.Retailer_Inventory_Previous_Month__c = 0.00;
            liq.Product_Budget__c = 0.00;
            liq.Type__c = 'Trade';
            liq.Month__c = 'Apr';
            liq.RecordTypeId = rtForLiquidation;
            currMonthLiqList.add(liq);
        }
        INSERT currMonthLiqList;
        
        List<Crop_Liquidation__c> cropLiqList = new List<Crop_Liquidation__c>();
        for(Crop__c crop : [SELECT Id FROM Crop__c LIMIT 5]){
            Crop_Liquidation__c cropLiq = new Crop_Liquidation__c();
            cropLiq.RecordTypeId = rtForCropLiquidation;
            cropLiq.Liquidation__c = currMonthLiqList[0].Id;
            cropLiq.is_Crop_Liquidation_Submitted__c = true;
            cropLiq.Crop__c = crop.Id;
            cropLiq.Sales_Org__c = sorg.Id;
            cropLiq.Liquidation_Value__c = 5000;
            cropLiq.Liquidation_YTD_Trade__c = 100;
            cropLiqList.add(cropLiq);
        }
        INSERT cropLiqList;
    }
    
    @IsTest
    public static void SWALCropLiqInsert(){
        
        Test.startTest();
        Database.executeBatch(new TestCropLiquidationBatch(),1);
        Test.stopTest();
    }
}