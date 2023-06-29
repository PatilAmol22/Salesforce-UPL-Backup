/*
     Class Name : LiquidationSWALLiqTest
     Description : Test Class for LiquidationSWALController Class
     Author : Abhineet Kumar
     Date : 12/09/2022
 */
@isTest
public with sharing class LiquidationSWALLiqTest {
    static final String rtForAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
    static final String rtForOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
    static final String rtForLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
    static final String rtForCropLiquidation = Schema.SObjectType.Crop_Liquidation__c.getRecordTypeInfosByName().get('CropSwalTrade').getRecordTypeId();
    
    //Set up data
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
        record.IsActive__c	= true;
        insert record;
        
        Trigger_Settings__c record1 = new Trigger_Settings__c();
        record1.Name = 'LiquidationApprovalTrigger';
        record1.IsActive__c	= true;
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
        Territory_Distributor__c territory = LiquidationTestDataFactory.createTerritory('Test Territory', '001', sorg.Id, zoneObj.Id, regionObj.Id, '', tmUsr.Id);
        
        //Product Creation
        List<Product2> productList = LiquidationTestDataFactory.createProductList(5, sorg.Id,'1210');
        
        //Crop Creation
        List<Crop__c> cropList = LiquidationTestDataFactory.createCropList(5, sorg.Id,'1210');
    }
    
    @isTest
    public static void testFetchHeaderDetails(){
        User tmusr = [SELECT Id FROM User Where Email = 'tmTestUser@test.com' LIMIT 1];
        User rmusr = [SELECT Id FROM User Where Email = 'rmTestUser@test.com' LIMIT 1];
        User fmmmusr = [SELECT Id FROM User Where Email = 'fmmTestUser@test.com' LIMIT 1];
        User zmlusr = [SELECT Id FROM User Where Email = 'zmmTestUser@test.com' LIMIT 1];
        
        userrole usroleTM = new userrole(Name ='Territory Manager SWAL Test');
        INSERT usroleTM;
        
        userrole usroleZML = new userrole(Name ='ZMM SWAL Test');
        INSERT usroleZML;
        
        userrole usroleRM = new userrole(Name ='Regional Manager SWAL Test');
        INSERT usroleRM;
        
        userrole usroleFMM = new userrole(Name ='Field Marketing Manager');
        INSERT usroleFMM;
        
        Test.startTest();
        tmusr.UserRoleId = usroleTM.Id;
        UPDATE tmusr;
        LiquidationSWALController.LiquidationWrapper liqTestWrapForTM = new LiquidationSWALController.LiquidationWrapper();
        liqTestWrapForTM = LiquidationSWALController.fetchHeaderDetails(tmusr.Id);
        
        rmusr.UserRoleId = usroleRM.Id;
        UPDATE rmusr;
        LiquidationSWALController.LiquidationWrapper liqTestWrapForRM = new LiquidationSWALController.LiquidationWrapper();
        liqTestWrapForRM = LiquidationSWALController.fetchHeaderDetails(rmusr.Id);
        
        fmmmusr.UserRoleId = usroleFMM.Id;
        UPDATE fmmmusr;
        LiquidationSWALController.LiquidationWrapper liqTestWrapForFMM = new LiquidationSWALController.LiquidationWrapper();
        liqTestWrapForFMM = LiquidationSWALController.fetchHeaderDetails(fmmmusr.Id);
        
        zmlusr.UserRoleId = usroleZML.Id;
        UPDATE zmlusr;
        LiquidationSWALController.LiquidationWrapper liqTestWrapForZML = new LiquidationSWALController.LiquidationWrapper();
        liqTestWrapForZML = LiquidationSWALController.fetchHeaderDetails(zmlusr.Id);
        
        System.assertEquals('TM',liqTestWrapForTM.userRole);
        Test.stopTest();
    }
    /*
    @isTest
    public static void testGetProductLiqDataNoOpnInv(){
        Territory_Distributor__c terr = [SELECT Id, Name, SalesOrg__c,TerritoryCode__c FROM Territory_Distributor__c WHERE Name = 'Test Territory'];
        String retData1 = LiquidationSWALController.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Aug', 'TM', false);
        //Create Liquidation Annual Plan record
        Liquidation_Annual_Plan__c lap =  LiquidationTestDataFactory.createLAP(rtForAnnualPlan, terr.SalesOrg__c, terr.Id); 
        
        Test.startTest();
        String retData2 = LiquidationSWALController.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Aug', 'TM', false);
        String retData3 = LiquidationSWALController.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Aug', 'RM/ZM', false);
        String retData4 = LiquidationSWALController.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Aug', 'RM/ZM', true);
        System.assert(retData2 != null);
        Test.stopTest();
    }*/
    
    @isTest
    public static void testGetProductLiqDataWithOpnInv(){
        Territory_Distributor__c terr = [SELECT Id, Name, SalesOrg__c,TerritoryCode__c FROM Territory_Distributor__c WHERE Name = 'Test Territory'];
        //Create Liquidation Annual Plan record
        Liquidation_Annual_Plan__c lap =  LiquidationTestDataFactory.createLAP(rtForAnnualPlan, terr.SalesOrg__c, terr.Id);
        
        //Create Opening Inventory records
        List<Opening_Inventory2__c> opnInvList = new List<Opening_Inventory2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 LIMIT 5]){
            Opening_Inventory2__c opInv = new Opening_Inventory2__c();
            opInv.Liquidation_Annual_Plan__c = lap.Id;
            opInv.Product__c = prod.Id;
            opInv.Territory__c = terr.Id;
            opInv.Opening_Inventory__c = 1000.00;
            opInv.YTD_Sales_Aug__c = 2000.00;
            opInv.CurrencyIsoCode = 'INR';
            opInv.RecordTypeId = rtForOpeningInventory;
            opnInvList.add(opInv);
        }
        INSERT opnInvList;

        Map<String,Id> prodTOOpnInvIdMap = new Map<String,Id>();
        for(Opening_Inventory2__c opnInv : [SELECT Id,Product__c FROM Opening_Inventory2__c LIMIT 5]){
            prodTOOpnInvIdMap.put(opnInv.Product__c,opnInv.Id);
        }
        
        //Create Product Liquidation for Last Month - Jul
        List<Liquidation2__c> lastMonthLiqList = new List<Liquidation2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 LIMIT 5]){
            Liquidation2__c liq = new Liquidation2__c();
            liq.Liquidation_Annual_Plan__c = lap.Id;
            liq.Territory__c = terr.Id;
            liq.Product__c = prod.Id;
            liq.YTD_Sales__c = 2000.00;
            liq.Distributors_Inventory__c = 100.00;
            liq.Distributor_Inventory_Previous_Month__c = 100.00;
            liq.Retailers_Inventory__c = 0.00;
            liq.Retailer_Inventory_Previous_Month__c = 0.00;
            liq.Product_Budget__c = 0.00;
            liq.Type__c = 'Trade';
            liq.Month__c = 'Sept';
            liq.RecordTypeId = rtForLiquidation;
            liq.Opening_Inventory2__c = prodTOOpnInvIdMap.get(prod.Id);
            lastMonthLiqList.add(liq);
        }
        INSERT lastMonthLiqList;
        
        for(Liquidation2__c lp : [SELECT Liquidation_Annual_Plan__c,Financial_Year__c,Territory_Code__c, Month__c, RecordTypeId FROM Liquidation2__c]){
            System.debug('1 = '+lp.Liquidation_Annual_Plan__c);
            System.debug('2 = '+lp.Financial_Year__c);
            System.debug('3 = '+lp.Territory_Code__c);
            System.debug('4 = '+lp.Month__c);
            System.debug('5 = '+lp.RecordTypeId);
        }
        
        Test.startTest();
        String retData2 = LiquidationSWALController.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Oct', 'TM', false);
        String retData3 = LiquidationSWALController.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Oct', 'RM/ZM', false);
        String retData4 = LiquidationSWALController.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Oct', 'RM/ZM', true);
        System.assert(retData2 != null);
        Test.stopTest();

    }
    
    @isTest
    public static void testGetProductLiqDatacurrMonth(){
        Territory_Distributor__c terr = [SELECT Id, Name, SalesOrg__c,TerritoryCode__c FROM Territory_Distributor__c WHERE Name = 'Test Territory'];
        //Create Liquidation Annual Plan record
        Liquidation_Annual_Plan__c lap =  LiquidationTestDataFactory.createLAP(rtForAnnualPlan, terr.SalesOrg__c, terr.Id);
        
        //Create Opening Inventory records
        List<Opening_Inventory2__c> opnInvList = new List<Opening_Inventory2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 LIMIT 5]){
            Opening_Inventory2__c opInv = new Opening_Inventory2__c();
            opInv.Liquidation_Annual_Plan__c = lap.Id;
            opInv.Product__c = prod.Id;
            opInv.Territory__c = terr.Id;
            opInv.Opening_Inventory__c = 1000.00;
            opInv.YTD_Sales_Aug__c = 2000.00;
            opInv.CurrencyIsoCode = 'INR';
            opInv.RecordTypeId = rtForOpeningInventory;
            opnInvList.add(opInv);
        }
        INSERT opnInvList;
        Map<String,Id> prodTOOpnInvIdMap = new Map<String,Id>();
        for(Opening_Inventory2__c opnInv : [SELECT Id,Product__c FROM Opening_Inventory2__c LIMIT 5]){
            prodTOOpnInvIdMap.put(opnInv.Product__c,opnInv.Id);
        }
        //Create Product Liquidation for Last Month - Jul
        List<Liquidation2__c> currMonthLiqList = new List<Liquidation2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 LIMIT 5]){
            Liquidation2__c liq = new Liquidation2__c();
            liq.Liquidation_Annual_Plan__c = lap.Id;
            liq.Territory__c = terr.Id;
            liq.Product__c = prod.Id;
            liq.YTD_Sales__c = 2000.00;
            liq.Distributors_Inventory__c = 100.00;
            liq.Distributor_Inventory_Previous_Month__c = 100.00;
            liq.Retailers_Inventory__c = 0.00;
            liq.Retailer_Inventory_Previous_Month__c = 0.00;
            liq.Product_Budget__c = 0.00;
            liq.Type__c = 'Trade';
            liq.Month__c = 'Oct';
            liq.RecordTypeId = rtForLiquidation;
            liq.Opening_Inventory2__c = prodTOOpnInvIdMap.get(prod.Id);
            currMonthLiqList.add(liq);
        }
        INSERT currMonthLiqList;
        
        //Create Liquidation Approval History Record
        Liquidation_Approval_History__c liqAppHis = LiquidationTestDataFactory.createAppHistory('In Progress', lap.Id, terr.SalesOrg__c, terr.Id, true, false);
        Test.startTest();
        String retData2 = LiquidationSWALController.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Oct', 'TM', false);
        //String retData3 = LiquidationSWALController.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Oct', 'RM/ZM', false);
        //String retData4 = LiquidationSWALController.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Oct', 'RM/ZM', true);
        LiquidationSWALController.getProductLiqTableData(lap.Id, '2022-2023', '2021-2022', terr.TerritoryCode__c, 'Apr', 'Mar', 'Not Started', terr.Id, 'TM', true);
        LiquidationSWALController.getProductLiqTableData(lap.Id, '2022-2023', '', terr.TerritoryCode__c, 'Oct', '', 'In Progress', terr.Id, 'TM', true);
        System.assert(retData2 != null);
        Test.stopTest();
    }
    
    @isTest
    public static void testCreateProductLiquidationInPrg(){
        String prodLiqStringNoopnInv;
        String prodLiqStringWithOpnInv;
        String prodId;
        Territory_Distributor__c terr = [SELECT Id, Name, SalesOrg__c,TerritoryCode__c FROM Territory_Distributor__c WHERE Name = 'Test Territory'];
        //Create Liquidation Annual Plan record
        Liquidation_Annual_Plan__c lap =  LiquidationTestDataFactory.createLAP(rtForAnnualPlan, terr.SalesOrg__c, terr.Id);
        
        List<Opening_Inventory2__c> opnInvList = new List<Opening_Inventory2__c>();
        //Create ProdLiquidation String
        for(Product2 prod : [SELECT Id FROM Product2 LIMIT 1]){
            prodId = prod.Id;
            Opening_Inventory2__c opInv = new Opening_Inventory2__c();
            opInv.Liquidation_Annual_Plan__c = lap.Id;
            opInv.Product__c = prod.Id;
            opInv.Territory__c = terr.Id;
            opInv.Opening_Inventory__c = 1000.00;
            opInv.YTD_Sales_Aug__c = 2000.00;
            opInv.CurrencyIsoCode = 'INR';
            opInv.RecordTypeId = rtForOpeningInventory;
            opnInvList.add(opInv);
        }
        INSERT opnInvList;
        
        //prodLiqStringNoopnInv = '[{"ytdSale":0,"totMrkInv":150,"terId":"'+terr.Id+'","tAvbStck":1000,"retInv":"050","prodName":"Shagun","prodId":"'+prodId+'","prodCode":"","prodBud":0,"prevMntYtdSale":0,"prevMntRI":0,"prevMntliqYTD":0,"prevMntDI":0,"opnInvId":"","openInv":"1000","liqYTDPer":0.85,"liqYTD":850,"liqMonth":null,"liqId":null,"lannualpId":"'+lap.Id+'","isOpnInvEdit":true,"isDisableOI":false,"index":0,"distInv":"0100"}]';
       	prodLiqStringWithOpnInv = '[{"ytdSale":0,"totMrkInv":150,"terId":"'+terr.Id+'","tAvbStck":1000,"retInv":"050","prodName":"Shagun","prodId":"'+prodId+'","prodCode":"","prodBud":0,"prevMntYtdSale":0,"prevMntRI":0,"prevMntliqYTD":0,"prevMntDI":0,"opnInvId":"'+opnInvList[0].Id+'","openInv":"1000","liqYTDPer":0.85,"liqYTD":850,"liqMonth":null,"liqId":null,"lannualpId":"'+lap.Id+'","isOpnInvEdit":true,"isDisableOI":false,"index":0,"distInv":"0100"}]';
       
        
        Test.startTest();
        //String restData1 = LiquidationSWALController.createProductLiquidation(prodLiqStringNoopnInv, 'Aug', '2022-2023', terr.TerritoryCode__c, 'Not Started');
        String restData2 = LiquidationSWALController.createProductLiquidation(prodLiqStringWithOpnInv, 'Aug', '2022-2023', terr.TerritoryCode__c, 'Not Started');
        System.assertEquals('Success', restData2);
        Test.stopTest();
    }
    
    @isTest
    public static void testCreateProductLiqNotInPrg(){
        //String prodLiqStringNoopnInv;
        String prodLiqStringWithOpnInv;
        String prodId;
        Territory_Distributor__c terr = [SELECT Id, Name, SalesOrg__c,TerritoryCode__c FROM Territory_Distributor__c WHERE Name = 'Test Territory'];
        //Create Liquidation Annual Plan record
        Liquidation_Annual_Plan__c lap =  LiquidationTestDataFactory.createLAP(rtForAnnualPlan, terr.SalesOrg__c, terr.Id);
        
        List<Opening_Inventory2__c> opnInvList = new List<Opening_Inventory2__c>();
        //Create ProdLiquidation String
        for(Product2 prod : [SELECT Id FROM Product2 LIMIT 1]){
            prodId = prod.Id;
            Opening_Inventory2__c opInv = new Opening_Inventory2__c();
            opInv.Liquidation_Annual_Plan__c = lap.Id;
            opInv.Product__c = prod.Id;
            opInv.Territory__c = terr.Id;
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
            liq.Territory__c = terr.Id;
            liq.Product__c = prod.Id;
            liq.YTD_Sales__c = 2000.00;
            liq.Distributors_Inventory__c = 100.00;
            liq.Distributor_Inventory_Previous_Month__c = 100.00;
            liq.Retailers_Inventory__c = 0.00;
            liq.Retailer_Inventory_Previous_Month__c = 0.00;
            liq.Product_Budget__c = 0.00;
            liq.Type__c = 'Trade';
            liq.Month__c = 'Aug';
            liq.RecordTypeId = rtForLiquidation;
            currMonthLiqList.add(liq);
        }
        INSERT currMonthLiqList;
        
        //Create Liquidation Approval History Record
        Liquidation_Approval_History__c liqAppHis = LiquidationTestDataFactory.createAppHistory('In Progress', lap.Id, terr.SalesOrg__c, terr.Id, true, false);
        
        
        //prodLiqStringNoopnInv = '[{"ytdSale":0,"totMrkInv":150,"terId":"'+terr.Id+'","tAvbStck":1000,"retInv":"050","prodName":"Shagun","prodId":"'+prodId+'","prodCode":"","prodBud":0,"prevMntYtdSale":0,"prevMntRI":0,"prevMntliqYTD":0,"prevMntDI":0,"opnInvId":"","openInv":"1000","liqYTDPer":0.85,"liqYTD":850,"liqMonth":null,"liqId":null,"lannualpId":"'+lap.Id+'","isOpnInvEdit":true,"isDisableOI":false,"index":0,"distInv":"0100"}]';
       	prodLiqStringWithOpnInv = '[{"ytdSale":0,"totMrkInv":150,"terId":"'+terr.Id+'","tAvbStck":1000,"retInv":"050","prodName":"Shagun","prodId":"'+prodId+'","prodCode":"","prodBud":0,"prevMntYtdSale":0,"prevMntRI":0,"prevMntliqYTD":0,"prevMntDI":0,"opnInvId":"'+opnInvList[0].Id+'","openInv":"1000","liqYTDPer":0.85,"liqYTD":850,"liqMonth":null,"liqId":null,"lannualpId":"'+lap.Id+'","isOpnInvEdit":false,"isDisableOI":true,"index":0,"distInv":"0100"}]';
       
        
        Test.startTest();
        String restData1 = LiquidationSWALController.createProductLiquidation(prodLiqStringWithOpnInv, 'Aug', '2022-2023', terr.TerritoryCode__c, 'Rejected');
        String restData2 = LiquidationSWALController.createProductLiquidation(prodLiqStringWithOpnInv, 'Aug', '2022-2023', terr.TerritoryCode__c, 'Pending for Approval');
        System.assertEquals('Success', restData1);
        Test.stopTest();
    }
    
    @isTest
    public static void testGetCropBreakupData(){
        Territory_Distributor__c terr = [SELECT Id, Name, SalesOrg__c,TerritoryCode__c FROM Territory_Distributor__c WHERE Name = 'Test Territory'];
        //Create Liquidation Annual Plan record
        Liquidation_Annual_Plan__c lap =  LiquidationTestDataFactory.createLAP(rtForAnnualPlan, terr.SalesOrg__c, terr.Id);
        
        //Create Opening Inventory records
        List<Opening_Inventory2__c> opnInvList = new List<Opening_Inventory2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 LIMIT 5]){
            Opening_Inventory2__c opInv = new Opening_Inventory2__c();
            opInv.Liquidation_Annual_Plan__c = lap.Id;
            opInv.Product__c = prod.Id;
            opInv.Territory__c = terr.Id;
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
            liq.Territory__c = terr.Id;
            liq.Product__c = prod.Id;
            liq.YTD_Sales__c = 2000.00;
            liq.Distributors_Inventory__c = 100.00;
            liq.Distributor_Inventory_Previous_Month__c = 100.00;
            liq.Retailers_Inventory__c = 0.00;
            liq.Retailer_Inventory_Previous_Month__c = 0.00;
            liq.Product_Budget__c = 0.00;
            liq.Type__c = 'Trade';
            liq.Month__c = 'Aug';
            liq.RecordTypeId = rtForLiquidation;
            currMonthLiqList.add(liq);
        }
        INSERT currMonthLiqList;
        
        //Create Liquidation Approval History Record
        Liquidation_Approval_History__c liqAppHis = LiquidationTestDataFactory.createAppHistory('In Progress', lap.Id, terr.SalesOrg__c, terr.Id, true, false);
        
        Test.startTest();
        String retData = LiquidationSWALController.getCropBreakupData(terr.TerritoryCode__c, '2022-2023', 'Aug');
        System.assert(retData != null);
        Test.stopTest();
    }
    
    @isTest
    public static void testCreateCropLiquidation(){
        String cropLiqData;
        Territory_Distributor__c terr = [SELECT Id, Name, SalesOrg__c,TerritoryCode__c FROM Territory_Distributor__c WHERE Name = 'Test Territory'];
        //Create Liquidation Annual Plan record
        Liquidation_Annual_Plan__c lap =  LiquidationTestDataFactory.createLAP(rtForAnnualPlan, terr.SalesOrg__c, terr.Id);
        
        //Create Opening Inventory records
        List<Opening_Inventory2__c> opnInvList = new List<Opening_Inventory2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 LIMIT 1]){
            Opening_Inventory2__c opInv = new Opening_Inventory2__c();
            opInv.Liquidation_Annual_Plan__c = lap.Id;
            opInv.Product__c = prod.Id;
            opInv.Territory__c = terr.Id;
            opInv.Opening_Inventory__c = 1000.00;
            opInv.YTD_Sales_Aug__c = 2000.00;
            opInv.CurrencyIsoCode = 'INR';
            opInv.RecordTypeId = rtForOpeningInventory;
            opnInvList.add(opInv);
        }
        INSERT opnInvList;
        
        //Create Product Liquidation for Last Month - Jul
        List<Liquidation2__c> currMonthLiqList = new List<Liquidation2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 LIMIT 1]){
            Liquidation2__c liq = new Liquidation2__c();
            liq.Liquidation_Annual_Plan__c = lap.Id;
            liq.Territory__c = terr.Id;
            liq.Product__c = prod.Id;
            liq.YTD_Sales__c = 2000.00;
            liq.Distributors_Inventory__c = 100.00;
            liq.Distributor_Inventory_Previous_Month__c = 100.00;
            liq.Retailers_Inventory__c = 0.00;
            liq.Retailer_Inventory_Previous_Month__c = 0.00;
            liq.Product_Budget__c = 0.00;
            liq.Type__c = 'Trade';
            liq.Month__c = 'Aug';
            liq.RecordTypeId = rtForLiquidation;
            currMonthLiqList.add(liq);
        }
        INSERT currMonthLiqList;
        
        //Create Liquidation Approval History Record
        Liquidation_Approval_History__c liqAppHis = LiquidationTestDataFactory.createAppHistory('In Progress', lap.Id, terr.SalesOrg__c, terr.Id, true, false);
        
        Crop__c crp = [SELECT Id, Name FROM Crop__c LIMIT 1];

        cropLiqData = '[{"crpLiqId":"","liqId":"'+currMonthLiqList[0].Id+'","crpName":"'+crp.Name+'","crpId":"'+crp.Id+'","prdCode":"","curLiqValue":100,"prevLiqValue":100,"prodYTD":2877,"prevMonthLiqYTD":2877,"sortOrder":1,"crpIndex":0}]';
        
        Test.startTest();
        String retData1 = LiquidationSWALController.createCropLiquidation(cropLiqData, terr.TerritoryCode__c, '2022-2023', 'Aug', 'In Progress', 'TM', 'Test');
        String retData2 = LiquidationSWALController.createCropLiquidation(cropLiqData, terr.TerritoryCode__c, '2022-2023', 'Aug', 'In Progress', 'RM/ZM', 'Test');
        String retData3 = LiquidationSWALController.createCropLiquidation(cropLiqData, terr.TerritoryCode__c, '2022-2023', 'Aug', 'Pending for Approval', 'RM/ZM', 'Test');
        System.assertEquals('Success', retData1);
        Test.stopTest();
    }
}