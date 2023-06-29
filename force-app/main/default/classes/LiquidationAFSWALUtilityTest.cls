@isTest
public class LiquidationAFSWALUtilityTest {
	@TestSetup
    public static void createTestData(){
        Integer curMonth = Date.Today().Month();
        
        //Custom Setting record
        MultiCountry_Liquidation__c multiCountCS = new MultiCountry_Liquidation__c();
        multiCountCS.Active__c = true;
        multiCountCS.Month__c = String.valueOf(curMonth);
        multiCountCS.Name = 'SWAL';
        multiCountCS.Active_Month__c = true;
        multiCountCS.Liquidation_Start_Day__c = System.today().day();
        INSERT multiCountCS;
    }
    
     @isTest
    public static void testUtilityMethods(){
        Test.startTest();
        Boolean retData = LiquidationAFSWALUtility.LiquidationStatusMail('SWAL');
        System.assertEquals(true, retData);
        String fisYear = LiquidationAFSWALUtility.getFiscalYear();
        LiquidationAFSWALUtility.sendEmail('Test Territory', 'Test Territory');
        Test.stopTest();
    }
}