/*
* Ticket : SCTASK0229141 
* Name: RCMExporterTest
* Created By :- Sayan Majumder (crmconsultant3@upl-ltd.com)
* Last Modified Date:- 16.07.2020
* Subjected Class: RCMExporter (Class)
*/


@isTest
public class RCMExporterTest {
    
    static testMethod void RCMExporterCheck(){
        
        Report_Exporter__c re = new Report_Exporter__c();
        re.Attachment_Name__c = 'SAP Vs SFDC SO India - MTD.csv';
        re.Email_Content__c = ' Hi,Please find SAP vs SFDC sales orders Zone wise.Thanks & Regards';
        re.Email_Recipients__c = 'crmconsultant3@upl-ltd.com';
        re.CC_Recipients__c = 'sayan88126791@gmail.com,anusua88126791@gmail.com';
        re.Email_Subject__c = 'SAP vs SFDC Sales Orders Zone Wise Report';
        re.Name = 'RCM Exporter';
        re.Frequency__c = 'Daily';
        re.Report_Id__c = '01Z1m0000005onp';
        re.Type__c = 'RCM';
        insert re;
        
        
		Test.startTest();
		RCMExporter sch2 = new RCMExporter();
		String sch = '0 0 7 * * ?';
		system.schedule('RCMExporter', sch, sch2); 
        Test.stopTest();
    }
}