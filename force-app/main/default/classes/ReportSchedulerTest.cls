/*
* Name: ReportSchedulerTest
* Created By :- Varun Shrivastava 
* Last Modified Date:- 16.06.2020
* Supporting Class: ReportScheduler
*/


@isTest
public class ReportSchedulerTest {
    @isTest()
    static void mainmethod(){
        
        Report_Exporter__c resbu = new Report_Exporter__c();
        resbu.Name = 'Un Productive Call Reporter';
        resbu.Attachment_Name__c = 'Un Productive Call Report';
        resbu.Email_Content__c = 'Hi,/r/n/r/nPlease find the attachment./r/n/r/nThanks & Regards/r/n,';
        resbu.Email_Recipients__c = 'test@upl-ltd.com';
        resbu.Email_Subject__c = 'Unproductive Call Report';
        resbu.Report_Id__c = '00O1m000000LAuO';
        resbu.Type__c = 'Unproductive Call';
        insert resbu;
        
        
        
        Test.startTest();
        ReportScheduler  sch2 = new ReportScheduler();
        String cron = '0 0 12 19 5 ?';
        system.schedule('Un Producitve Call Testing', cron, sch2); 
        Test.stopTest();
    }
}