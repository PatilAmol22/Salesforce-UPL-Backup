/*
* Ticket : INCTASK0075617 ZMM point 4 reports scheduling
* Name: Exporter
* Created By :- Sayan Majumder (crmconsultant3@upl-ltd.com)
* Last Modified Date:- 20.05.2020
* Supporting Class: ExporterTest (Class)
*/


@isTest
public class ExporterTest {
    
    static testMethod void ExporterCheck(){
        
        Report_Exporter__c re = new Report_Exporter__c();
        re.Attachment_Name__c = 'New Report for ZMM Point 4';
        re.Email_Content__c = 'Details';
        re.Email_Recipients__c = 'sayan88126791@gmail.com';
        re.Email_Subject__c = 'Reports for ZMM Point 4';
        re.Name = 'New Report';
        re.Frequency__c = 'Daily';
        re.Report_Id__c = '656rytytryt';
        re.Type__c = 'ZMM 4';
        insert re;
        
        
		Test.startTest();
		Exporter  sch2 = new Exporter();
		String sch = '0 05 14 * * ?';
		system.schedule('One Time Pro', sch, sch2); 
        Test.stopTest();
    }
}