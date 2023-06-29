/*
* Name: AKCReportExporterTest
* Created By :- Ankita Saxena (crmconsultant5@upl-ltd.com)
* Date:- 07.05.2020
* Description: schedule reports on daily basis and sent as an attachment
* Subjected Class: AKCReportExporter (Class)
*/


@isTest
public class AKCReportExporterTest {
    
    static testMethod void AKCReportExporterCheck(){
        
        Report_Exporter__c re = new Report_Exporter__c();
        re.Attachment_Name__c = 'Inbound Call Type Report';
        re.Email_Content__c = 'Details';
        re.Email_Recipients__c = 'crmconsultant5@upl-ltd.com';
        re.Email_Subject__c = 'Reports for Inbound Call Type';
        re.Name = 'New Report';
        re.Frequency__c = 'Daily';
        re.Type__c = 'AKC Exporter';
        re.Report_Id__c = '656rytytryt';
        insert re;
        
        
		Test.startTest();
		AKCReportExporter  sch2 = new AKCReportExporter();
		String sch = '0 05 14 * * ?';
		system.schedule('AKC Report Exporter', sch, sch2); 
        Test.stopTest();
    }

}