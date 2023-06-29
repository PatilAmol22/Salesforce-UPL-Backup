/*
     Class Name : LiquidationReportAFSWALControllerTest
     Description : Test Class for LiquidationReportAFSWALController Class
     Author : Abhineet Kumar
     Date : 20/09/2022
	 Modified By: Harshaprasad Srustu
	 Date: 10-Feb-2022
	 Reason: Updated the SalesOrg version from 1000 to 1410 as 1000 products are inactive.
 */
@isTest
public class LiquidationReportAFSWALControllerTest {
    static final String rtForAnnualPlanAF = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
    static final String rtForOpeningInventoryAF = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
    static final String rtForLiquidationAF = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
    static final String rtForCropLiquidationAF = Schema.SObjectType.Crop_Liquidation__c.getRecordTypeInfosByName().get('CropTrade').getRecordTypeId();
    static final String rtForAnnualPlanSWAL = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
    static final String rtForOpeningInventorySWAL = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
    static final String rtForLiquidationSWAL = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
    static final String rtForCropLiquidationSWAL = Schema.SObjectType.Crop_Liquidation__c.getRecordTypeInfosByName().get('CropSwalTrade').getRecordTypeId();
	static final String liquidationNotCompleted = System.Label.NoCompletedLiquidationData;
    
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
        Sales_Org__c sorgAF = new Sales_Org__c();
        sorgAF = LiquidationTestDataFactory.createSalesOrg('India', '1410');

        //AF Sales Org
        Sales_Org__c sorgSWAL = new Sales_Org__c();
        sorgSWAL = LiquidationTestDataFactory.createSalesOrg('SWAL', '1210');

        //Profile queries
        String tmAFProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id;
        String zmmProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers'].Id;
        String sbuProfileId = [SELECT Id FROM Profile WHERE Name = 'SBU Profile'].Id;
        String tmSWALProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager SWAL'].Id;
        String rmProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Manager SWAL'].Id;

        //user Creation
        //TM AF User
        User tmAFUsr = LiquidationTestDataFactory.createUser(tmAFProfileId, 'tmAFTestUser', 'India');
        //ZM User
         User zmUsr = LiquidationTestDataFactory.createUser(zmmProfileId, 'zmAFTestUser', 'India');
        //ZMM User
        User zmmUsr = LiquidationTestDataFactory.createUser(zmmProfileId, 'zmmAFTestUser', 'India');
        //SBUH User
        User sbuhUsr = LiquidationTestDataFactory.createUser(sbuProfileId, 'sbuhTestUser', 'India');
        //SBUM User
        User sbumUsr = LiquidationTestDataFactory.createUser(sbuProfileId, 'sbumTestUser', 'India');
        //TM User
        User tmSWALUsr = LiquidationTestDataFactory.createUser(tmSWALProfileId, 'tmSWALTestUser', 'SWAL');
        //RM User
        User rmUsr = LiquidationTestDataFactory.createUser(rmProfileId, 'rmTestUser', 'SWAL');
        //FMM User
        User fmmUsr = LiquidationTestDataFactory.createUser(rmProfileId, 'fmmTestUser', 'SWAL');
        //zm User
        User zmSWALUsr = LiquidationTestDataFactory.createUser(rmProfileId, 'zmSWALTestUser', 'SWAL');
        //zmm User
        User zmlUsr = LiquidationTestDataFactory.createUser(rmProfileId, 'zmlSWALTestUser', 'SWAL');
        
        //AF Data
        //SBU creation
        SBU__c sbuObj = LiquidationTestDataFactory.createSBU(sbuhUsr.Id, sbumUsr.Id, sorgAF.Id);      
        //AF Zone Creation
        Zone__c zoneAFObj = LiquidationTestDataFactory.createZone('Test AF Zone', sorgAF.Id, 'AFZONE1', sbuObj.Id, zmUsr.Id, zmmUsr.Id);       
        //Territory Creation
        Territory_Distributor__c territoryAF = LiquidationTestDataFactory.createTerritory('Test AF Territory', 'AF001', sorgAF.Id, zoneAFObj.Id, '', sbuObj.Id, tmAFUsr.Id);       
        //Product Creation
        List<Product2> productListAF = LiquidationTestDataFactory.createProductList(5, sorgAF.Id,'1410');        
        //Crop Creation
        List<Crop__c> cropListAF = LiquidationTestDataFactory.createCropList(5, sorgAF.Id,'1410');

        //SWAL Data
        //Zone Creation
        Zone__c zoneSWALObj = LiquidationTestDataFactory.createZone('Test SWAL Zone', sorgSWAL.Id, 'SWALZONE1', '', zmSWALUsr.Id, zmlUsr.Id);
        //Region creation
        Region__c regionObj = LiquidationTestDataFactory.createRegion('Test SWAL Region', 'SWREG01', sorgSWAL.Id, rmUsr.Id, fmmUsr.Id, zoneSWALObj.Id);     
        //Territory Creation
        Territory_Distributor__c territory = LiquidationTestDataFactory.createTerritory('Test SWAL Territory', 'SW001', sorgSWAL.Id, zoneSWALObj.Id, regionObj.Id, '', tmSWALUsr.Id);
        //Product Creation
        List<Product2> productList = LiquidationTestDataFactory.createProductList(5, sorgSWAL.Id,'1210');    
        //Crop Creation
        List<Crop__c> cropList = LiquidationTestDataFactory.createCropList(5, sorgSWAL.Id,'1210');
    }

    @isTest
    public static void testFetchHeaderDetailsAF(){
        User tmusr = [SELECT Id FROM User Where Email = 'tmAFTestUser@test.com' LIMIT 1];
        User zmmusr = [SELECT Id FROM User Where Email = 'zmmAFTestUser@test.com' LIMIT 1];
        User zmusr = [SELECT Id FROM User Where Email = 'zmAFTestUser@test.com' LIMIT 1];
        User sbhuhusr = [SELECT Id FROM User Where Email = 'sbuhTestUser@test.com' LIMIT 1];
        User sbhumusr = [SELECT Id FROM User Where Email = 'sbumTestUser@test.com' LIMIT 1];

        userrole usroleTM = new userrole(Name ='Territory Manager Test');
        INSERT usroleTM;
        
        userrole usroleZMM = new userrole(Name ='Zonal Marketing Manager Test');
        INSERT usroleZMM;
        
        userrole usroleZM = new userrole(Name ='Zonal Business Head Test');
        INSERT usroleZM;

        userrole usroleSBUH = new userrole(Name ='SBU Head India Test');
        INSERT usroleSBUH;
                
        userrole usroleSBUM = new userrole(Name ='SBU Marketing Head India Test');
        INSERT usroleSBUM;

        Test.startTest();
        //TM User
        tmusr.UserRoleId = usroleTM.Id;
        UPDATE tmusr;
        String tmRetData = LiquidationReportAFSWALController.fetchReportHeaderDetails(tmusr.Id);

        //ZMM User
        zmmusr.UserRoleId = usroleZMM.Id;
        UPDATE zmmusr;
        String zmmRetData = LiquidationReportAFSWALController.fetchReportHeaderDetails(zmmusr.Id);

        //ZM User
        zmusr.UserRoleId = usroleZM.Id;
        UPDATE zmusr;
        String zmRetData = LiquidationReportAFSWALController.fetchReportHeaderDetails(zmusr.Id);

        //SBUH User
        sbhuhusr.UserRoleId = usroleSBUH.Id;
        UPDATE sbhuhusr;
        String sbuhRetData = LiquidationReportAFSWALController.fetchReportHeaderDetails(sbhuhusr.Id);

        //SBUM User
        sbhumusr.UserRoleId = usroleSBUM.Id;
        UPDATE sbhumusr;
        String sbumRetData = LiquidationReportAFSWALController.fetchReportHeaderDetails(sbhumusr.Id);
        
        System.assert(sbumRetData != null);
        Test.stopTest();
    }

    @isTest
    public static void testFetchHeaderDetailsSWAL(){
        User tmusr = [SELECT Id FROM User Where Email = 'tmSWALTestUser@test.com' LIMIT 1];
        User rmusr = [SELECT Id FROM User Where Email = 'rmTestUser@test.com' LIMIT 1];
        User fmmmusr = [SELECT Id FROM User Where Email = 'fmmTestUser@test.com' LIMIT 1];
        User zmlusr = [SELECT Id FROM User Where Email = 'zmlSWALTestUser@test.com' LIMIT 1];
        
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
        String tmRetData = LiquidationReportAFSWALController.fetchReportHeaderDetails(tmusr.Id);
        
        rmusr.UserRoleId = usroleRM.Id;
        UPDATE rmusr;
        String rmRetData = LiquidationReportAFSWALController.fetchReportHeaderDetails(rmusr.Id);
        
        fmmmusr.UserRoleId = usroleFMM.Id;
        UPDATE fmmmusr;
        String fmmRetData = LiquidationReportAFSWALController.fetchReportHeaderDetails(fmmmusr.Id);
        
        zmlusr.UserRoleId = usroleZML.Id;
        UPDATE zmlusr;
        String zmlRetData = LiquidationReportAFSWALController.fetchReportHeaderDetails(zmlusr.Id);
        System.assert(tmRetData != null);
        Test.stopTest();
    }

    @isTest
    public static void testGetAFProdTableData(){
        Territory_Distributor__c terr = [SELECT Id, Name, SalesOrg__c,TerritoryCode__c FROM Territory_Distributor__c WHERE Name = 'Test AF Territory'];
        //Create Liquidation Annual Plan record
        Liquidation_Annual_Plan__c lap =  LiquidationTestDataFactory.createLAP(rtForAnnualPlanAF, terr.SalesOrg__c, terr.Id);
        
        //Create Opening Inventory records
        List<Opening_Inventory2__c> opnInvList = new List<Opening_Inventory2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 WHERE Sales_Org_Code__c = '1410' LIMIT 5]){
            Opening_Inventory2__c opInv = new Opening_Inventory2__c();
            opInv.Liquidation_Annual_Plan__c = lap.Id;
            opInv.Product__c = prod.Id;
            opInv.Territory__c = terr.Id;
            opInv.Opening_Inventory__c = 1000.00;
            opInv.YTD_Sales_Aug__c = 2000.00;
            opInv.CurrencyIsoCode = 'INR';
            opInv.RecordTypeId = rtForOpeningInventoryAF;
            opnInvList.add(opInv);
        }
        INSERT opnInvList;

        Map<Id,Id> prdToOpInvIdMap = new Map<Id,Id>();

        for(Opening_Inventory2__c opnInv : [SELECT Id,Product__c FROM Opening_Inventory2__c WHERE Liquidation_Annual_Plan__c = :lap.Id]){
            prdToOpInvIdMap.put(opnInv.Product__c, opnInv.Id);
        }

        //Create Product Liquidation 
        List<Liquidation2__c> currMonthLiqList = new List<Liquidation2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 WHERE Sales_Org_Code__c = '1410' LIMIT 5]){
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
            liq.RecordTypeId = rtForLiquidationAF;
            liq.Opening_Inventory2__c = prdToOpInvIdMap.get(prod.Id);
            currMonthLiqList.add(liq);
        }
        INSERT currMonthLiqList;

        //Create Liquidation Approval History Record
        Liquidation_Approval_History__c liqAppHis = LiquidationTestDataFactory.createAppHistory('In Progress', lap.Id, terr.SalesOrg__c, terr.Id, true, false);

        Test.startTest();
        User sbhuhusr = [SELECT Id FROM User Where Email = 'sbuhTestUser@test.com' LIMIT 1];
        //All Zone Error Message
        String allZoneErrorMsg = LiquidationReportAFSWALController.getTableData('All','All','2022-2023','Aug','India',sbhuhusr.Id,'Product');

        //Single Zone Error Message
        String singleZoneErrorMsg = LiquidationReportAFSWALController.getTableData('Test AF Zone','All','2022-2023','Aug','India',sbhuhusr.Id,'Product');

        //Single Territory Error Message
        String singleTerrErrorMsg = LiquidationReportAFSWALController.getTableData('Test AF Zone','AF001','2022-2023','Aug','India',sbhuhusr.Id,'Product');
        System.assertEquals(liquidationNotCompleted, singleTerrErrorMsg);
        
        liqAppHis.Approval_Status__c = 'Approved';
        UPDATE liqAppHis;

        //All Zone 
        String allZoneProdData = LiquidationReportAFSWALController.getTableData('All','All','2022-2023','Aug','India',sbhuhusr.Id,'Product');

        //Single Zone 
        String singleZoneProdData = LiquidationReportAFSWALController.getTableData('Test AF Zone','All','2022-2023','Aug','India',sbhuhusr.Id,'Product');

        //Single Territory 
        String singleTerrProdData = LiquidationReportAFSWALController.getTableData('Test AF Zone','AF001','2022-2023','Aug','India',sbhuhusr.Id,'Product');
        System.assert(singleTerrProdData != null);
        Test.stopTest();
    }

    @isTest
    public static void testGetSWALProdTableData(){
        Territory_Distributor__c terr = [SELECT Id, Name, SalesOrg__c,TerritoryCode__c FROM Territory_Distributor__c WHERE Name = 'Test SWAL Territory'];
        //Create Liquidation Annual Plan record
        Liquidation_Annual_Plan__c lap =  LiquidationTestDataFactory.createLAP(rtForAnnualPlanSWAL, terr.SalesOrg__c, terr.Id);
        
        //Create Opening Inventory records
        List<Opening_Inventory2__c> opnInvList = new List<Opening_Inventory2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 WHERE Sales_Org_Code__c = '1210' LIMIT 5]){
            Opening_Inventory2__c opInv = new Opening_Inventory2__c();
            opInv.Liquidation_Annual_Plan__c = lap.Id;
            opInv.Product__c = prod.Id;
            opInv.Territory__c = terr.Id;
            opInv.Opening_Inventory__c = 1000.00;
            opInv.YTD_Sales_Aug__c = 2000.00;
            opInv.CurrencyIsoCode = 'INR';
            opInv.RecordTypeId = rtForOpeningInventorySWAL;
            opnInvList.add(opInv);
        }
        INSERT opnInvList;

        Map<Id,Id> prdToOpInvIdMap = new Map<Id,Id>();

        for(Opening_Inventory2__c opnInv : [SELECT Id,Product__c FROM Opening_Inventory2__c WHERE Liquidation_Annual_Plan__c = :lap.Id]){
            prdToOpInvIdMap.put(opnInv.Product__c, opnInv.Id);
        }

        //Create Product Liquidation 
        List<Liquidation2__c> currMonthLiqList = new List<Liquidation2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 WHERE Sales_Org_Code__c = '11210' LIMIT 5]){
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
            liq.RecordTypeId = rtForLiquidationSWAL;
            liq.Opening_Inventory2__c = prdToOpInvIdMap.get(prod.Id);
            currMonthLiqList.add(liq);
        }
        INSERT currMonthLiqList;

        //Create Liquidation Approval History Record
        Liquidation_Approval_History__c liqAppHis = LiquidationTestDataFactory.createAppHistory('Approved', lap.Id, terr.SalesOrg__c, terr.Id, true, true);

        Test.startTest();
        User zmlusr = [SELECT Id FROM User Where Email = 'zmlSWALTestUser@test.com' LIMIT 1];
        
        //All Zone 
        String allZoneProdData = LiquidationReportAFSWALController.getTableData('All','All','2022-2023','Aug','SWAL',zmlusr.Id,'Product');

        //Single Zone 
        String singleZoneProdData = LiquidationReportAFSWALController.getTableData('Test SWAL Region','All','2022-2023','Aug','SWAL',zmlusr.Id,'Product');

        //Single Territory 
        String singleTerrProdData = LiquidationReportAFSWALController.getTableData('Test SWAL Region','SW001','2022-2023','Aug','SWAL',zmlusr.Id,'Product');
        System.assert(singleTerrProdData != null);
        Test.stopTest();
    }

    @isTest
    public static void testGetAFCropTableData(){
        Territory_Distributor__c terr = [SELECT Id, Name, SalesOrg__c,TerritoryCode__c FROM Territory_Distributor__c WHERE Name = 'Test AF Territory'];
        //Create Liquidation Annual Plan record
        Liquidation_Annual_Plan__c lap =  LiquidationTestDataFactory.createLAP(rtForAnnualPlanAF, terr.SalesOrg__c, terr.Id);
        
        //Create Opening Inventory records
        List<Opening_Inventory2__c> opnInvList = new List<Opening_Inventory2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 WHERE Sales_Org_Code__c = '1410' LIMIT 5]){
            Opening_Inventory2__c opInv = new Opening_Inventory2__c();
            opInv.Liquidation_Annual_Plan__c = lap.Id;
            opInv.Product__c = prod.Id;
            opInv.Territory__c = terr.Id;
            opInv.Opening_Inventory__c = 1000.00;
            opInv.YTD_Sales_Aug__c = 2000.00;
            opInv.CurrencyIsoCode = 'INR';
            opInv.RecordTypeId = rtForOpeningInventoryAF;
            opnInvList.add(opInv);
        }
        INSERT opnInvList;

        Map<Id,Id> prdToOpInvIdMap = new Map<Id,Id>();
        Map<Id,Liquidation2__c> prdToLiqMap = new Map<Id,Liquidation2__c>();
        for(Opening_Inventory2__c opnInv : [SELECT Id,Product__c FROM Opening_Inventory2__c WHERE Liquidation_Annual_Plan__c = :lap.Id]){
            prdToOpInvIdMap.put(opnInv.Product__c, opnInv.Id);
        }

        //Create Product Liquidation 
        List<Liquidation2__c> currMonthLiqList = new List<Liquidation2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 WHERE Sales_Org_Code__c = '1410' LIMIT 5]){
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
            liq.RecordTypeId = rtForLiquidationAF;
            liq.Opening_Inventory2__c = prdToOpInvIdMap.get(prod.Id);
            currMonthLiqList.add(liq);
        }
        INSERT currMonthLiqList;

        for(Liquidation2__c liq : [SELECT Id,Product__c,Liquidation_YTD_Trade__c FROM Liquidation2__c WHERE Month__c = 'Aug']){
            prdToLiqMap.put(liq.Product__c,liq);
        }

        //Create crop Liquidation
        List<Crop_Liquidation__c> crpLiqList = new List<Crop_Liquidation__c>();
        List<Crop__c> crpList = new List<Crop__c>();
        for(Crop__c crp : [SELECT Id, Name FROM Crop__c WHERE Sales_Org_Code__c = '1410' LIMIT 5]){
            crpList.add(crp);
        }
        for(Id prdId : prdToLiqMap.keySet()){
            for(Crop__c crp : crpList){
                Crop_Liquidation__c cropLiq = new Crop_Liquidation__c();
                cropLiq.RecordTypeId = rtForCropLiquidationAF;
                cropLiq.Liquidation__c = prdToLiqMap.get(prdId).Id;
                cropLiq.Sales_Org__c = terr.SalesOrg__c;
                cropLiq.Liquidation_YTD_Trade__c = prdToLiqMap.get(prdId).Liquidation_YTD_Trade__c;
                cropLiq.Liquidation_Value__c = 100.00;
                cropLiq.is_Crop_Liquidation_Submitted__c = true;
                cropLiq.Crop__c = crp.Id;
                crpLiqList.add(cropLiq);
            }
        }
        INSERT crpLiqList;

        //Create Liquidation Approval History Record
        Liquidation_Approval_History__c liqAppHis = LiquidationTestDataFactory.createAppHistory('Approved', lap.Id, terr.SalesOrg__c, terr.Id, true, true);

        Test.startTest();
        User sbhuhusr = [SELECT Id FROM User Where Email = 'sbuhTestUser@test.com' LIMIT 1];
        //All Zone 
        String allZoneCropData = LiquidationReportAFSWALController.getTableData('All','All','2022-2023','Aug','India',sbhuhusr.Id,'Crop');

        //Single Zone 
        String singleZoneCropData = LiquidationReportAFSWALController.getTableData('Test AF Zone','All','2022-2023','Aug','India',sbhuhusr.Id,'Crop');

        //Single Territory 
        String singleTerrCropData = LiquidationReportAFSWALController.getTableData('Test AF Zone','AF001','2022-2023','Aug','India',sbhuhusr.Id,'Crop');
        System.assert(singleTerrCropData != null);
        Test.stopTest();
    }

    @isTest
    public static void testGetSWALCropTableData(){
        Territory_Distributor__c terr = [SELECT Id, Name, SalesOrg__c,TerritoryCode__c FROM Territory_Distributor__c WHERE Name = 'Test SWAL Territory'];
        //Create Liquidation Annual Plan record
        Liquidation_Annual_Plan__c lap =  LiquidationTestDataFactory.createLAP(rtForAnnualPlanSWAL, terr.SalesOrg__c, terr.Id);
        
        //Create Opening Inventory records
        List<Opening_Inventory2__c> opnInvList = new List<Opening_Inventory2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 WHERE Sales_Org_Code__c = '1210' LIMIT 5]){
            Opening_Inventory2__c opInv = new Opening_Inventory2__c();
            opInv.Liquidation_Annual_Plan__c = lap.Id;
            opInv.Product__c = prod.Id;
            opInv.Territory__c = terr.Id;
            opInv.Opening_Inventory__c = 1000.00;
            opInv.YTD_Sales_Aug__c = 2000.00;
            opInv.CurrencyIsoCode = 'INR';
            opInv.RecordTypeId = rtForOpeningInventorySWAL;
            opnInvList.add(opInv);
        }
        INSERT opnInvList;

        Map<Id,Id> prdToOpInvIdMap = new Map<Id,Id>();
        Map<Id,Liquidation2__c> prdToLiqMap = new Map<Id,Liquidation2__c>();
        for(Opening_Inventory2__c opnInv : [SELECT Id,Product__c FROM Opening_Inventory2__c WHERE Liquidation_Annual_Plan__c = :lap.Id]){
            prdToOpInvIdMap.put(opnInv.Product__c, opnInv.Id);
        }

        //Create Product Liquidation 
        List<Liquidation2__c> currMonthLiqList = new List<Liquidation2__c>();
        for(Product2 prod : [SELECT Id FROM Product2 WHERE Sales_Org_Code__c = '1210' LIMIT 5]){
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
            liq.RecordTypeId = rtForLiquidationSWAL;
            liq.Opening_Inventory2__c = prdToOpInvIdMap.get(prod.Id);
            currMonthLiqList.add(liq);
        }
        INSERT currMonthLiqList;

        for(Liquidation2__c liq : [SELECT Id,Product__c,Liquidation_YTD_SWAL__c FROM Liquidation2__c WHERE Month__c = 'Aug']){
            prdToLiqMap.put(liq.Product__c,liq);
        }

        //Create crop Liquidation
        List<Crop_Liquidation__c> crpLiqList = new List<Crop_Liquidation__c>();
        List<Crop__c> crpList = new List<Crop__c>();
        for(Crop__c crp : [SELECT Id, Name FROM Crop__c WHERE Sales_Org_Code__c = '1210' LIMIT 5]){
            crpList.add(crp);
        }
        for(Id prdId : prdToLiqMap.keySet()){
            for(Crop__c crp : crpList){
                Crop_Liquidation__c cropLiq = new Crop_Liquidation__c();
                cropLiq.RecordTypeId = rtForCropLiquidationSWAL;
                cropLiq.Liquidation__c = prdToLiqMap.get(prdId).Id;
                cropLiq.Sales_Org__c = terr.SalesOrg__c;
                cropLiq.Liquidation_YTD_Trade__c = prdToLiqMap.get(prdId).Liquidation_YTD_SWAL__c;
                cropLiq.Liquidation_Value__c = 100.00;
                cropLiq.is_Crop_Liquidation_Submitted__c = true;
                cropLiq.Crop__c = crp.Id;
                crpLiqList.add(cropLiq);
            }
        }
        INSERT crpLiqList;

        //Create Liquidation Approval History Record
        Liquidation_Approval_History__c liqAppHis = LiquidationTestDataFactory.createAppHistory('Approved', lap.Id, terr.SalesOrg__c, terr.Id, true, true);

        Test.startTest();
        User zmlusr = [SELECT Id FROM User Where Email = 'zmlSWALTestUser@test.com' LIMIT 1];
        
        //All Zone 
        String allZoneCropData = LiquidationReportAFSWALController.getTableData('All','All','2022-2023','Aug','SWAL',zmlusr.Id,'Crop');

        //Single Zone 
        String singleZoneCropData = LiquidationReportAFSWALController.getTableData('Test SWAL Region','All','2022-2023','Aug','SWAL',zmlusr.Id,'Crop');

        //Single Territory 
        String singleTerrCropData = LiquidationReportAFSWALController.getTableData('Test SWAL Region','SW001','2022-2023','Aug','SWAL',zmlusr.Id,'Crop');
        System.assert(singleTerrCropData != null);
        
        //Updating Prod Liquidaton to zero for one product
        List<Liquidation2__c> liqToBeUpdatedList = new List<Liquidation2__c>();
        for(Liquidation2__c liq : [SELECT Id,Distributors_Inventory__c FROM Liquidation2__c WHERE Month__c = 'Aug' LIMIT 1 ]){
            liq.Distributors_Inventory__c = 3000.0;
            liqToBeUpdatedList.add(liq);
        }
        UPDATE liqToBeUpdatedList;
        
        Product2 prod = [SELECT Id,Name FROM Product2 WHERE Sales_Org_Code__c = '1410' LIMIT 1];
        prod.Name = 'TestProduct';
        prod.Active_For_Liquidation__c = false;
        UPDATE prod;
        
        Product2 prod1 = [SELECT Id,Name FROM Product2 WHERE Active_For_Liquidation__c = false AND Sales_Org_Code__c = '1410' LIMIT 1];
        prod1.Active_For_Liquidation__c = true;
        UPDATE prod1;
        Test.stopTest();
    }
}