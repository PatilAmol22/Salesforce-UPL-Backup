/*
* Ticket : INCTASK0074667 Liquidation Cumulative reports for AF and SWAL
* Name: ReportExporterTest
* Created By :- Sayan Majumder (crmconsultant3@upl-ltd.com)
* Last Modified Date:- 20.05.2020
* Supporting Class: ReportExporterTest (Test Class)
*/


@isTest
public class ReportExporterTest {
    @isTest()
    static void mainmethod(){
        //system.debug('User id in = mainmethod '+u3.Id);
        Sales_Org__c sOrg = new Sales_Org__c();
        sOrg.Name = 'India';
        sOrg.Sales_Org_Code__c = '1000';
        insert sOrg;
        
        SBU__c t = new SBU__c();
        t.SalesOrg__c = sOrg.Id;
        t.SBUUser__c = [ select Id from User where Id = :UserInfo.getUserId()].id;
        t.SBUCode__c = '0001';
        insert t;
        
        Report_Exporter__c resbu = new Report_Exporter__c();
        resbu.Name = 'ZMM2 Report for Testing';
        resbu.Attachment_Name__c = 'ZMM2 Report with Liquidations cumulative data';
        resbu.Email_Content__c = 'Hi,/r/n/r/nPlease find the attachment./r/n/r/nThanks & Regards/r/nSayan Majumder,';
        resbu.Email_Recipients__c = 'crmconsultant3@upl-ltd.com';
        resbu.Email_Subject__c = 'Mail regarding Liquidation Cumulative data';
        resbu.Report_Id__c = 'a6w6D0000004Gq4';
        resbu.Type__c = 'ZMM 2';
        resbu.ZMM2_SBU_or_Zone__c = 'SBU';
        resbu.SBU__c = t.Id;
        insert resbu;
        
        Zone__c t1 = new Zone__c();
        t1.SalesOrg__c = sOrg.Id;
        t1.ZMMUser__c = [ select Id from User where Id = :UserInfo.getUserId()].id;
        t1.ZoneCode__c = '0001';
        insert t1;
        
        Report_Exporter__c rezone = new Report_Exporter__c();
        rezone.Name = 'ZMM2 Report for Testing';
        rezone.Attachment_Name__c = 'ZMM2 Report with Liquidations cumulative data';
        rezone.Email_Content__c = 'Hi,/r/n/r/nPlease find the attachment./r/n/r/nThanks & Regards/r/nSayan Majumder,';
        rezone.Email_Recipients__c = 'crmconsultant3@upl-ltd.com';
        rezone.Email_Subject__c = 'Mail regarding Liquidation Cumulative data';
        rezone.Report_Id__c = 'a6w6D0000004Hq4';
        rezone.Type__c = 'ZMM 2';
        rezone.ZMM2_SBU_or_Zone__c = 'Zone';
        rezone.Zone__c = t1.id;
        insert rezone;
        
        Test.startTest();
        ReportExporter  sch2 = new ReportExporter();
        String sch = '0 0 12 19 5 ?';
        system.schedule('ZMM2 mails schedulers testing', sch, sch2); 
        Test.stopTest();
    }
}