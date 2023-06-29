/*
     Class Name : SWALLiquidationStatusMailZMMTest
     Description : Test Class to cover the coverage for SWAL liquidation status mail for ZML
     Author : Abhineet Kumar
     Date : 20/09/2022
 */
@isTest
public class SWALLiquidationStatusMailZMMTest {
    @TestSetup
    public static void testSetupData(){
		Integer curMonth = Date.Today().Month();
        
        //Custom Setting record
        MultiCountry_Liquidation__c multiCountCS = new MultiCountry_Liquidation__c();
        multiCountCS.Active__c = true;
        multiCountCS.Month__c = String.valueOf(curMonth);
        multiCountCS.Name = 'SWAL';
        multiCountCS.Active_Month__c = true;
        multiCountCS.Liquidation_Start_Day__c = System.today().day();
        INSERT multiCountCS;
        
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
        territory.Zone__c =zoneObj.Id;
        update territory;
    }
    
    @isTest
    public static void SWALLiquidationStatusZMMMail(){
        Test.startTest();
        SWALLiquidationStatusMailZMMSchedule swalLiqSBU = new SWALLiquidationStatusMailZMMSchedule();
        String sch = '0 0 1 * * ?';
        System.schedule('Send SBU Mail', sch, swalLiqSBU);
        Test.stopTest();
    }
}