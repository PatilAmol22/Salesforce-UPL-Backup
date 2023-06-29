/*
* Ticket : RITM0238894 
* Name: AKCExporterTest
* Created By :- Sayan Majumder (crmconsultant3@upl-ltd.com)
* Last Modified Date:- 12.08.2021
* Subjected Class: AKCExporter (Class)
*/


@isTest
public class AKCExporterTest {
    
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
        re.Type__c = 'AKC';
        insert re;
        
        
		Test.startTest();
		AKCExporter sch2 = new AKCExporter();
		String sch = '0 0 9,16 * * ?';
		system.schedule('AKCExporter', sch, sch2); 
        Test.stopTest();
    }
}