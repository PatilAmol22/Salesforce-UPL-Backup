/*
* 	Test Class Name - LastLoginUsersReportBatchTest
*   Author : EY (Harshaprasad Srustu)
*   Batch Class - LastLoginUsersReportBatch
*   CreatedDate: 30-11-2022
*   Description - Fetch Reports for Country specific - This test class is purely runs on Reports.ReportMetadata using standard
				  Reports.ReportMetadata that runs Asynchronously. There is limitation in salesforce we cannot create
				 test data for standardreport we have to go with SeeAllDataTrue Async. 
	Note: Donot delete the reports under folder named Users not logged in for less than 7 days
**/
@isTest
public class LastLoginUsersReportBatchTest {
    
    static final Id systemAdministratorProfileId = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'].Id;

    // Test method for running report.
    @isTest(SeeAllData = 'true')
    public static void testBatchLogic(){ 
        Test.startTest();            

        LastLoginUsersReportBatch lastLoginUserBatch = new LastLoginUsersReportBatch();
        Id batchID = Database.executeBatch(lastLoginUserBatch);
        
        Test.stopTest();
    }
    
    
}