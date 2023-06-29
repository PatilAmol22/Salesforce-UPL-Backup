@isTest
private class spainSOExporter_Test {
@isTest    
static void spainExporterCheck(){
	
        string spainType= system.label.Spain_Approved_SO;
        Report_Exporter__c re = new Report_Exporter__c();
        re.Attachment_Name__c = 'SalesOrder.csv';
        re.Email_Content__c = 'Details';
        re.Email_Recipients__c = 'test@test.com';
        re.Email_Subject__c = 'Spain Report';
        re.Name = 'New Report';
        re.Frequency__c = 'Daily';
        re.Report_Id__c = '656rytytryt';
        re.Type__c = spainType;
        insert re;
        
        
		Test.startTest();
		spainSOExporter  sch2 = new spainSOExporter();
		String sch = '0 05 14 * * ?';
		system.schedule('One Time Pro', sch, sch2); 
        Test.stopTest();
    }
}