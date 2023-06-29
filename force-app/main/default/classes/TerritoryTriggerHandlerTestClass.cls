/*
     Class Name : TerritoryTriggerHandlerTestClass
     Description : Test Class to cover the coverage Territory trigger handler class for territory assignment
     Author : Abhineet Kumar
     Date : 20/09/2022
 */
@isTest
public class TerritoryTriggerHandlerTestClass {
    @TestSetup
    public static void testSetupData(){
        //AF Sales Org
        Sales_Org__c sorgAF = new Sales_Org__c();
        sorgAF = LiquidationTestDataFactory.createSalesOrg('India', '1000');

        //AF Sales Org
        Sales_Org__c sorgSWAL = new Sales_Org__c();
        sorgSWAL = LiquidationTestDataFactory.createSalesOrg('SWAL', '1210');

        //Profile queries
        String tmAFProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id;
        String zmmProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers'].Id;
        String sbuProfileId = [SELECT Id FROM Profile WHERE Name = 'SBU Profile'].Id;
        String tmSWALProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager SWAL'].Id;
        String rmProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Manager SWAL'].Id;

        //AF Territory
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
        
        //SBU creation
        SBU__c sbuObj = LiquidationTestDataFactory.createSBU(sbuhUsr.Id, sbumUsr.Id, sorgAF.Id);      
        //AF Zone Creation
        Zone__c zoneAFObj = LiquidationTestDataFactory.createZone('Test AF Zone', sorgAF.Id, 'AFZONE1', sbuObj.Id, zmUsr.Id, zmmUsr.Id);       
        //Territory Creation
        Territory_Distributor__c territoryAF = LiquidationTestDataFactory.createTerritory('Test AF Territory', 'AF001', sorgAF.Id, zoneAFObj.Id, '', sbuObj.Id, '');   
        
        //SWAL Territory
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

        //Zone Creation
        Zone__c zoneSWALObj = LiquidationTestDataFactory.createZone('Test SWAL Zone', sorgSWAL.Id, 'SWALZONE1', '', zmSWALUsr.Id, zmlUsr.Id);
        //Region creation
        Region__c regionObj = LiquidationTestDataFactory.createRegion('Test SWAL Region', 'SWREG01', sorgSWAL.Id, rmUsr.Id, fmmUsr.Id, zoneSWALObj.Id);     
        //Territory Creation
        Territory_Distributor__c territory = LiquidationTestDataFactory.createTerritory('Test SWAL Territory', 'SW001', sorgSWAL.Id, zoneSWALObj.Id, regionObj.Id, '', '');
    }

    //TM assignment trigger
    @isTest
    public static void testTMAssignmentMailAF(){
        User tmusr = [SELECT Id FROM User Where Email = 'tmAFTestUser@test.com' LIMIT 1];
        List<Territory_Distributor__c> terrList = new List<Territory_Distributor__c>();
        for(Territory_Distributor__c terr : [SELECT Id, TerritoryManager__c FROM Territory_Distributor__c WHERE Name = 'Test AF Territory']){
            terr.TerritoryManager__c = tmusr.Id;
            terrList.add(terr);
        }
        UPDATE terrList;

        Territory_Distributor__c terrObj = [SELECT Id, TerritoryManager__c FROM Territory_Distributor__c WHERE Name = 'Test AF Territory'];

        System.assertEquals(tmusr.Id,terrObj.TerritoryManager__c);
    }

    @isTest
    public static void testTMAssignmentMailSWAL(){
        User tmusr = [SELECT Id FROM User Where Email = 'tmSWALTestUser@test.com' LIMIT 1];
        List<Territory_Distributor__c> terrList = new List<Territory_Distributor__c>();
        for(Territory_Distributor__c terr : [SELECT Id, TerritoryManager__c FROM Territory_Distributor__c WHERE Name = 'Test SWAL Territory']){
            terr.TerritoryManager__c = tmusr.Id;
            terrList.add(terr);
        }
        UPDATE terrList;

        Territory_Distributor__c terrObj = [SELECT Id, TerritoryManager__c FROM Territory_Distributor__c WHERE Name = 'Test SWAL Territory'];

        System.assertEquals(tmusr.Id,terrObj.TerritoryManager__c);
    }
}