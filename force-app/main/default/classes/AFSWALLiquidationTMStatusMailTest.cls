/*
     Class Name : AFSWALLiquidationTMStatusMailTest
     Description : Test Class for AFLiquidationTMStatusMailBatch Class
     Author : Abhineet Kumar
     Date : 01/10/2022
 */
@isTest
public class AFSWALLiquidationTMStatusMailTest {
	@TestSetup
    public static void testSetupData(){
        Integer curMonth = Date.Today().Month();
        
        //Custom Setting record
        MultiCountry_Liquidation__c multiCountCS = new MultiCountry_Liquidation__c();
        multiCountCS.Active__c = true;
        multiCountCS.Liquidation_Start_Day__c = System.today().day();
        multiCountCS.Month__c = String.valueOf(curMonth);
        multiCountCS.Active_Month__c = true;
        multiCountCS.Name = 'AF';
        INSERT multiCountCS;
        
        
        //AF Sales Org
        Sales_Org__c sorg = new Sales_Org__c();
        sorg = LiquidationTestDataFactory.createSalesOrg('India', '1000');
        
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
        sbuObj.SBUCode__c = '901';
        update sbuObj;
        
        //Zone Creation
        Zone__c zoneObj = LiquidationTestDataFactory.createZone('Test Zone', sorg.Id, 'ZONE1', sbuObj.Id, zmUsr.Id, zmmUsr.Id);
        
        //Territory Creation
        Territory_Distributor__c territoryaf1 = LiquidationTestDataFactory.createTerritory('Test Territoryaf1', '001', sorg.Id, zoneObj.Id, '', sbuObj.Id, tmUsr.Id);
   		
        Territory_Distributor__c territoryaf2 = LiquidationTestDataFactory.createTerritory('Test Territoryaf2', '004', sorg.Id, zoneObj.Id, '', sbuObj.Id, tmUsr.Id);
   
       
    	 //Custom Setting record
        MultiCountry_Liquidation__c multiCountCS1 = new MultiCountry_Liquidation__c();
        multiCountCS1.Active__c = true;
        multiCountCS1.Month__c = String.valueOf(curMonth);
        multiCountCS1.Name = 'SWAL';
        multiCountCS1.Active_Month__c = true;
        multiCountCS1.Liquidation_Start_Day__c = System.today().day();
        INSERT multiCountCS1;
        
        //AF Sales Org
        Sales_Org__c sorg1 = new Sales_Org__c();
        sorg1 = LiquidationTestDataFactory.createSalesOrg('SWAL', '1210');
        
        //Profile queries
        String tmProfileId1 = [SELECT Id FROM Profile WHERE Name = 'Territory Manager SWAL'].Id;
        String rmProfileId1 = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Manager SWAL'].Id;
        //String sbuProfileId = [SELECT Id FROM Profile WHERE Name = 'SBU Profile'].Id;
        
        //user Creation
        //TM User
        User tmUsr1 = LiquidationTestDataFactory.createUser(tmProfileId1, 'tmTestUser1', 'SWAL');
        //RM User
        User rmUsr1 = LiquidationTestDataFactory.createUser(rmProfileId1, 'rmTestUser1', 'SWAL');
        //FMM User
        User fmmUsr1 = LiquidationTestDataFactory.createUser(rmProfileId1, 'fmmTestUser1', 'SWAL');
        //zm User
        User zmUsr1 = LiquidationTestDataFactory.createUser(rmProfileId1, 'zmTestUser1', 'SWAL');
        //zmm User
        User zmmUsr1 = LiquidationTestDataFactory.createUser(rmProfileId1, 'zmmTestUser1', 'SWAL');
        
        //Zone Creation
        Zone__c zoneObj1 = LiquidationTestDataFactory.createZone('Test Zone1', sorg1.Id, 'ZONE2', '', zmUsr1.Id, zmmUsr1.Id);

        //Region creation
        Region__c regionObj1 = LiquidationTestDataFactory.createRegion('Test Region', 'REG01', sorg1.Id, rmUsr1.Id, fmmUsr1.Id, zoneObj1.Id);
        
        //Territory Creation
        Territory_Distributor__c territory1 = LiquidationTestDataFactory.createTerritory('Test Territory1', '002', sorg1.Id, zoneObj1.Id, regionObj1.Id, '', tmUsr1.Id);
        territory1.Zone__c =zoneObj1.Id;
        update territory1;
        
        Territory_Distributor__c territory2 = LiquidationTestDataFactory.createTerritory('Test Territory2', '003', sorg1.Id, zoneObj1.Id, regionObj1.Id, '', tmUsr1.Id);
        territory2.Zone__c =zoneObj1.Id;
        update territory2;
    }
    
    @isTest
    public static void AFLiquidationStatusSBUMail(){
        Test.startTest();
        AFLiquidationTMStatusMailBatch afLiqTM = new AFLiquidationTMStatusMailBatch();
        String sch = '0 0 1 * * ?';
        System.schedule('Send SBU Mail', sch, afLiqTM);
        Test.stopTest();
    }
}