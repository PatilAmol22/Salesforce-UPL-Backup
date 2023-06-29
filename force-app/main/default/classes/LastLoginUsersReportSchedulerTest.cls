/**
* Test Class Name: LastLoginUsersReportSchedulerTest
* Author: EY (Harshaprasad Srustu)
* CR: 
* CreatedDate: 01-Nov-2022
* Description: Test class for LastLoginUsersReportSchedulerTest class
* */
@isTest
public class LastLoginUsersReportSchedulerTest {
    testmethod static void testEscalationTSchedular(){
        Test.startTest();
        String cronExp = '0 00 16 ? * *';
        LastLoginUsersReportScheduler schedObj = new LastLoginUsersReportScheduler();
        system.schedule('Last Login users Reports Schedular Test',cronExp,schedObj);
        Test.stopTest();
    }
}