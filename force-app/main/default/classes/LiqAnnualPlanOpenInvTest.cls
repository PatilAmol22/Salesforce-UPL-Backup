/*
     Class Name : LiqAnnualPlanOpenInvTest
     Description : Test Class For LiqAnnualPlanOpenInvScheduler class
     Author : Bonny Mathews
     Date : 21/11/2022
 */
@isTest
public class LiqAnnualPlanOpenInvTest {
	@TestSetup
    public static void LiquidationProductTerritory(){
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
        
        //Zone Creation
        Zone__c zoneObj = LiquidationTestDataFactory.createZone('Test Zone', sorg.Id, 'ZONE1', sbuObj.Id, zmUsr.Id, zmmUsr.Id);
        
        //Territory Creation
        Territory_Distributor__c territory1 = LiquidationTestDataFactory.createTerritory('Test Territory1', '001', sorg.Id, zoneObj.Id, '', sbuObj.Id, tmUsr.Id);
        Territory_Distributor__c territory2 = LiquidationTestDataFactory.createTerritory('Test Territory2', '002', sorg.Id, zoneObj.Id, '', sbuObj.Id, tmUsr.Id);
        
        //Product Creation
        List<Product2> productList = LiquidationTestDataFactory.createProductList(5, sorg.Id, '1000');
        
        
        //SWAL
        Sales_Org__c sorg1 = new Sales_Org__c();
        sorg1 = LiquidationTestDataFactory.createSalesOrg('SWAL', '1210');
        
        //Profile queries
        String tmProfileId1 = [SELECT Id FROM Profile WHERE Name = 'Territory Manager SWAL'].Id;
        String rmProfileId1 = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Manager SWAL'].Id;
        
        //user Creation
        //TM User
        User tmUsr1 = LiquidationTestDataFactory.createUser(tmProfileId1, 'tmTestUser', 'SWAL');
        //RM User
        User rmUsr1 = LiquidationTestDataFactory.createUser(rmProfileId1, 'rmTestUser', 'SWAL');
        //FMM User
        User fmmUsr1 = LiquidationTestDataFactory.createUser(rmProfileId1, 'fmmTestUser', 'SWAL');
        //zm User
        User zmUsr1 = LiquidationTestDataFactory.createUser(rmProfileId1, 'zmTestUser', 'SWAL');
        //zmm User
        User zmmUsr1 = LiquidationTestDataFactory.createUser(rmProfileId1, 'zmmTestUser', 'SWAL');
        
        //Zone Creation
        Zone__c zoneObj1 = LiquidationTestDataFactory.createZone('Test Zone1', sorg1.Id, 'ZONE12', '', zmUsr1.Id, zmmUsr1.Id);

        //Region creation
        Region__c regionObj1 = LiquidationTestDataFactory.createRegion('Test Region1', 'REG01', sorg1.Id, rmUsr1.Id, fmmUsr1.Id, zoneObj1.Id);
        
        //Territory Creation
        Territory_Distributor__c territory3 = LiquidationTestDataFactory.createTerritory('Test Territory3', '003', sorg1.Id, zoneObj1.Id, regionObj1.Id, '', tmUsr1.Id);
        
        //Product Creation
        List<Product2> productList1 = LiquidationTestDataFactory.createProductList(5, sorg1.Id,'1210');

    }
    
    @isTest
    public static void testLiqAnnualPlanOpeningInventory(){
        Test.startTest();
        LiqAnnualPlanOpenInvScheduler liqLapOi = new LiqAnnualPlanOpenInvScheduler();
        String sch = '0 0 1 * * ?';
        System.schedule('Create LAP and OI', sch, liqLapOi);
        Test.stopTest();
    }
}