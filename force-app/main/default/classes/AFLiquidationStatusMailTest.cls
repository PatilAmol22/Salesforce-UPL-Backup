/*
     Class Name : AFLiquidationStatusMailTest
     Description : Test Class for AFLiquidationStatusMailSchedule Class
     Author : Abhineet Kumar
     Date : 01/10/2022
 */
@isTest
public class AFLiquidationStatusMailTest {
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
        Territory_Distributor__c territory = LiquidationTestDataFactory.createTerritory('Test Territory', '001', sorg.Id, zoneObj.Id, '', sbuObj.Id, tmUsr.Id);
    }
    
    @isTest
    public static void AFLiquidationStatusSBUMail(){
        Test.startTest();
        AFLiquidationStatusMailSchedule afLiq = new AFLiquidationStatusMailSchedule();
        String sch = '0 0 1 * * ?';
        System.schedule('Send SBU Mail', sch, afLiq);
        Test.stopTest();
    }
}