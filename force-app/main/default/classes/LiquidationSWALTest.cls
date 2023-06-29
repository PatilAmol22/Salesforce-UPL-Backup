/*
* Name: LiquidationSWALTest
* Created By :- Sayan Majumder (crmconsultant3@upl-ltd.com)
* Date:- 26.06.2020
* Description: This is a Test Class for LiquidationSWAL Scheduler class.
* Subjected Class: LiquidationSWAL (Class)
*/


@isTest
public class LiquidationSWALTest {
    
    static testMethod void LiquidationSWALCheck(){
        
        Report_Exporter__c re = new Report_Exporter__c();
        re.Attachment_Name__c = 'Liquidation SWAL Report';
        re.Email_Content__c = 'Details';
        re.Email_Recipients__c = 'crmconsultant3@upl-ltd.com';
        re.Email_Subject__c = 'Liquidation SWAL Report for Gaurav Singh swal';
        re.Name = 'New Report';
        re.Frequency__c = 'Daily';
        re.Type__c = 'Liquidation SWAL (INCTASK0214674)';
        re.Report_Id__c = '656rytytryt';
        insert re;
        
        
        Test.startTest();
        LiquidationSWAL  sch2 = new LiquidationSWAL();
        String sch = '0 0 8 1-8 * ?';
        system.schedule('SWAL Liquidation Report to Gaurav Singh swal', sch, sch2); 
        Test.stopTest();
    }
    
}