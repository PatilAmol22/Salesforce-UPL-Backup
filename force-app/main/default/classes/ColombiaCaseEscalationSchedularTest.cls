/**
* Test Class Name: ColombiaCaseEscalationSchedularTest
* Author: EY
* CR: APPS-2074
* CreatedDate: 01-Nov-2022
* ModifiedDate: 27-Nov-2022
* Description: Test class for ColombiaCaseEscalationSchedular class
* */
@isTest
public class ColombiaCaseEscalationSchedularTest {
    testmethod static void testEscalationTSchedular(){
        Test.startTest();
        String cronExp = '0 30 17 ? * *';
        ColombiaCaseEscalationSchedular schedObj = new ColombiaCaseEscalationSchedular();
        system.schedule('Colombia Case Schedular Test',cronExp,schedObj);
        Test.stopTest();
    }
}