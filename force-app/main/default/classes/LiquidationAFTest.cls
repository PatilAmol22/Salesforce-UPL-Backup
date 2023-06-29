/*
     Class Name : LiquidationAFTest
     Description : Test Class for LiquidationAF Class
     Author : Abhineet Kumar
     Date : 10/09/2022
 */
@isTest
public class LiquidationAFTest {
    static final String rtForAnnualPlan = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
    static final String rtForOpeningInventory = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
    static final String rtForLiquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
    static final String rtForCropLiquidation = Schema.SObjectType.Crop_Liquidation__c.getRecordTypeInfosByName().get('CropTrade').getRecordTypeId();
    
    //Create setup data
	@TestSetup
    public static void testSetupData(){
        Integer curMonth = Date.Today().Month();
        
        //Custom Setting record
        MultiCountry_Liquidation__c multiCountCS = new MultiCountry_Liquidation__c();
        multiCountCS.Active__c = true;
        multiCountCS.Month__c = String.valueOf(curMonth);
        multiCountCS.Name = 'AF';
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
        sorg = LiquidationTestDataFactory.createSalesOrg('India', '1410');
        
        //Profile queries
        String tmProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id;
        String zmmProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers'].Id;
        String sbuProfileId = [SELECT Id FROM Profile WHERE Name = 'SBU Profile'].Id;
        
        //user Creation
        //TM User
        User tmUsr = LiquidationTestDataFactory.createUser(tmProfileId, 'tmTestUser', 'India');

        //ZM User
         User zmUsr = LiquidationTestDataFactory.createUser(zmmProfileId, 'zmTestUser', 'India');

        //ZMM User
        User zmmUsr = LiquidationTestDataFactory.createUser(zmmProfileId, 'zmmTestUser', 'India');

        //SBUH User
        User sbuhUsr = LiquidationTestDataFactory.createUser(sbuProfileId, 'sbuhTestUser', 'India');

        //SBUM User
        User sbumUsr = LiquidationTestDataFactory.createUser(sbuProfileId, 'sbumTestUser', 'India');
        
        //SBU creation
        SBU__c sbuObj = LiquidationTestDataFactory.createSBU(sbuhUsr.Id, sbumUsr.Id, sorg.Id);
        
        //Zone Creation
        Zone__c zoneObj = LiquidationTestDataFactory.createZone('Test Zone', sorg.Id, 'ZONE1', sbuObj.Id, zmUsr.Id, zmmUsr.Id);
        
        //Territory Creation
        Territory_Distributor__c territory = LiquidationTestDataFactory.createTerritory('Test Territory', '001', sorg.Id, zoneObj.Id, '', sbuObj.Id, tmUsr.Id);
        
        //Product Creation
        List<Product2> productList = LiquidationTestDataFactory.createProductList(5, sorg.Id, '1410');
        
        //Crop Creation
        List<Crop__c> cropList = LiquidationTestDataFactory.createCropList(5, sorg.Id, '1410');
    }
    
    @isTest
    public static void testFetchHeaderDetails(){
        User tmusr = [SELECT Id FROM User Where Email = 'tmTestUser@test.com' LIMIT 1];
        User zmmusr = [SELECT Id FROM User Where Email = 'zmmTestUser@test.com' LIMIT 1];
        User zmusr = [SELECT Id FROM User Where Email = 'zmTestUser@test.com' LIMIT 1];
        
        userrole usroleTM = new userrole(Name ='Territory Manager Test');
        INSERT usroleTM;
        
        userrole usroleZMM = new userrole(Name ='Zonal Marketing Manager Test');
        INSERT usroleZMM;
        
        userrole usroleZM = new userrole(Name ='Zonal Business Head Test');
        INSERT usroleZM;
        
        Test.startTest();
        tmusr.UserRoleId = usroleTM.Id;
        UPDATE tmusr;
        LiquidationAF.LiquidationWrapper liqTestWrapForTM = new LiquidationAF.LiquidationWrapper();
        liqTestWrapForTM = LiquidationAF.fetchHeaderDetails(tmusr.Id);
        
        zmmusr.UserRoleId = usroleZMM.Id;
        UPDATE zmmusr;
        LiquidationAF.LiquidationWrapper liqTestWrapForZMM = new LiquidationAF.LiquidationWrapper();
        liqTestWrapForZMM = LiquidationAF.fetchHeaderDetails(zmmusr.Id);
        
        zmusr.UserRoleId = usroleZM.Id;
        UPDATE zmusr;
        LiquidationAF.LiquidationWrapper liqTestWrapForZM = new LiquidationAF.LiquidationWrapper();
        liqTestWrapForZM = LiquidationAF.fetchHeaderDetails(zmusr.Id);
        System.assertEquals('TM',liqTestWrapForTM.userRole);
        Test.stopTest();
    }
    
    @isTest
    public static void testGetProductLiqDataNoOpnInv(){
        Territory_Distributor__c terr = [SELECT Id, Name, SalesOrg__c,TerritoryCode__c FROM Territory_Distributor__c WHERE Name = 'Test Territory'];
        String retData1 = LiquidationAF.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Aug', 'TM', false);
        //Create Liquidation Annual Plan record
        Liquidation_Annual_Plan__c lap =  LiquidationTestDataFactory.createLAP(rtForAnnualPlan, terr.SalesOrg__c, terr.Id); 
        
        Test.startTest();
        String retData2 = LiquidationAF.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Aug', 'TM', false);
        String retData3 = LiquidationAF.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Aug', 'ZMM', false);
        String retData4 = LiquidationAF.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Aug', 'ZMM', true);
        System.assert(retData2 != null);
        Test.stopTest();
    }
    
    @isTest
    public static void testGetProductLiqDataWithOpnInv(){
        Territory_Distributor__c terr = [SELECT Id, Name, SalesOrg__c,TerritoryCode__c FROM Territory_Distributor__c WHERE Name = 'Test Territory'];
        //Create Liquidation Annual Plan record
        Liquidation_Annual_Plan__c lap =  LiquidationTestDataFactory.createLAP(rtForAnnualPlan, terr.SalesOrg__c, terr.Id);
        
        //Create Opening Inventory records
        List<Opening_Inventory2__c> opnInvList = new List<Opening_Inventory2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 LIMIT 4]){
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
        List<Liquidation2__c> lastMonthLiqList = new List<Liquidation2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 LIMIT 4]){
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
            liq.Month__c = 'Jul';
            liq.RecordTypeId = rtForLiquidation;
            lastMonthLiqList.add(liq);
        }
        INSERT lastMonthLiqList;
        
        Test.startTest();
        String retData2 = LiquidationAF.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Aug', 'TM', false);
        String retData3 = LiquidationAF.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Aug', 'ZMM', false);
        String retData4 = LiquidationAF.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Aug', 'ZMM', true);
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
            liq.Month__c = 'Sept';
            liq.RecordTypeId = rtForLiquidation;
            currMonthLiqList.add(liq);
        }
        INSERT currMonthLiqList;
        
        //Create Liquidation Approval History Record
        Liquidation_Approval_History__c liqAppHis = LiquidationTestDataFactory.createAppHistory('In Progress', lap.Id, terr.SalesOrg__c, terr.Id, true, false);
        LiquidationAF.LiquidationAFProductTableWrapper afProductTableWrapper = new LiquidationAF.LiquidationAFProductTableWrapper();
        afProductTableWrapper.liqAfProductList = new List<LiquidationAF.LiquidationAFProductWrapper>();
        Test.startTest();
        String retData2 = LiquidationAF.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Oct', 'TM', false);
        String retData3 = LiquidationAF.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Oct', 'ZMM', false);
        String retData4 = LiquidationAF.getProductLiquidationData(terr.TerritoryCode__c, '2022-2023', 'Oct', 'ZMM', true);
        System.assert(retData2 != null);
        //afProductTableWrapper.liqAfProductList = LiquidationAF.getProductLiqTableData(lap.Id,'2022-2023','2021-2022',terr.TerritoryCode__c,'Apr','Mar','Not Started',terr.Id,'TM',true);
        Test.stopTest();
    }
    
    @isTest
    public static void testGetProductLiqDataPreviousYear(){
        Territory_Distributor__c terr = [SELECT Id, Name, SalesOrg__c,TerritoryCode__c FROM Territory_Distributor__c WHERE Name = 'Test Territory'];
        //Create Liquidation Annual Plan record
        Liquidation_Annual_Plan__c lap =  LiquidationTestDataFactory.createLAP(rtForAnnualPlan, terr.SalesOrg__c, terr.Id);
        Liquidation_Annual_Plan__c lap1 =  LiquidationTestDataFactory.createLAP(rtForAnnualPlan, terr.SalesOrg__c, terr.Id);
        lap1.Fiscal_Start_Date__c = Date.newInstance(2021, 04, 01);
        lap1.Fiscal_End_Date__c = Date.newInstance(2022,03, 31);
        lap1.FIscal_Year__c = '2021-2022';
        update lap1;
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
            liq.Liquidation_Annual_Plan__c = lap1.Id;
            liq.Territory__c = terr.Id;
            liq.Product__c = prod.Id;
            liq.YTD_Sales__c = 2000.00;
            liq.Distributors_Inventory__c = 100.00;
            liq.Distributor_Inventory_Previous_Month__c = 100.00;
            liq.Retailers_Inventory__c = 0.00;
            liq.Retailer_Inventory_Previous_Month__c = 0.00;
            liq.Product_Budget__c = 0.00;
            liq.Type__c = 'Trade';
            liq.Month__c = 'Mar';
            liq.RecordTypeId = rtForLiquidation;
            currMonthLiqList.add(liq);
        }
        INSERT currMonthLiqList;
        
        //Create Liquidation Approval History Record
        Liquidation_Approval_History__c liqAppHis = LiquidationTestDataFactory.createAppHistory('In Progress', lap.Id, terr.SalesOrg__c, terr.Id, true, false);
        LiquidationAF.LiquidationAFProductTableWrapper afProductTableWrapper = new LiquidationAF.LiquidationAFProductTableWrapper();
        afProductTableWrapper.liqAfProductList = new List<LiquidationAF.LiquidationAFProductWrapper>();
        Test.startTest();
        afProductTableWrapper.liqAfProductList = LiquidationAF.getProductLiqTableData(lap.Id,'2022-2023','2021-2022',terr.TerritoryCode__c,'Apr','Mar','Not Started',terr.Id,'TM',true);
        afProductTableWrapper.liqAfProductList = LiquidationAF.getProductLiqTableData(lap.Id,'2022-2023','2021-2022',terr.TerritoryCode__c,'Apr','Mar','In Progress',terr.Id,'TM',true);
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
        //String restData1 = LiquidationAF.createProductLiquidation(prodLiqStringNoopnInv, 'Aug', '2022-2023', terr.TerritoryCode__c, 'Not Started');
        String restData2 = LiquidationAF.createProductLiquidation(prodLiqStringWithOpnInv, 'Aug', '2022-2023', terr.TerritoryCode__c, 'Not Started');
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
        String restData1 = LiquidationAF.createProductLiquidation(prodLiqStringWithOpnInv, 'Aug', '2022-2023', terr.TerritoryCode__c, 'Rejected');
        String restData2 = LiquidationAF.createProductLiquidation(prodLiqStringWithOpnInv, 'Aug', '2022-2023', terr.TerritoryCode__c, 'Pending for Approval');
        System.assertEquals('Success', restData1);
        Test.stopTest();
    }
    
    @isTest
    public static void testUpdateLiquidationApproval(){
        Territory_Distributor__c terr = [SELECT Id, Name, SalesOrg__c,TerritoryCode__c,Sales_Org_Code__c FROM Territory_Distributor__c WHERE Name = 'Test Territory'];
        //Create Liquidation Annual Plan record
        Liquidation_Annual_Plan__c lap =  LiquidationTestDataFactory.createLAP(rtForAnnualPlan, terr.SalesOrg__c, terr.Id);
        
        //Create Liquidation Approval History Record
        Liquidation_Approval_History__c liqAppHis = LiquidationTestDataFactory.createAppHistory('Pending for Approval', lap.Id, terr.SalesOrg__c, terr.Id, true, true);
        
        Test.startTest();
        LiquidationAF.updateLiquidationApproval('Approved', terr.TerritoryCode__c, '2022-2023', 'Aug', 'Test');
        LiquidationAF.updateLiquidationApproval('Rejected', terr.TerritoryCode__c, '2022-2023', 'Aug', 'Test');
        Liquidation_Approval_History__c liqAppHisUpdated = [SELECT Approval_Status__c FROM Liquidation_Approval_History__c WHERE LAP__c = :lap.Id AND SalesOrg__r.Sales_Org_Code__c = :terr.Sales_Org_Code__c AND Territory__r.TerritoryCode__c = :terr.TerritoryCode__c LIMIT 1];
        System.assertEquals('Pending for Approval', liqAppHisUpdated.Approval_Status__c);
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
        String retData = LiquidationAF.getCropBreakupData(terr.TerritoryCode__c, '2022-2023', 'Aug');
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
        String retData1 = LiquidationAF.createCropLiquidation(cropLiqData, terr.TerritoryCode__c, '2022-2023', 'Aug', 'In Progress', 'TM', 'Test');
        String retData2 = LiquidationAF.createCropLiquidation(cropLiqData, terr.TerritoryCode__c, '2022-2023', 'Aug', 'In Progress', 'ZMM', 'Test');
        String retData3 = LiquidationAF.createCropLiquidation(cropLiqData, terr.TerritoryCode__c, '2022-2023', 'Aug', 'Pending for Approval', 'ZMM', 'Test');
        System.assertEquals('Success', retData1);
        Test.stopTest();
    }
}