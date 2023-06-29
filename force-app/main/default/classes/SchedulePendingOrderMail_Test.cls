@isTest(SeeAllData=true)
public class SchedulePendingOrderMail_Test {
    static testmethod void test(){
        
        EmailTemplate emailTemplate =[SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body 
                                      FROM EmailTemplate 
                                      WHERE Name ='Chile SO Approval request']; 
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
		User u = new User(Alias = 'standt', Email='kalpesh.chande@skinternational.com', 
            EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser786@testorg.com');
        insert u;
        List<Sales_Order__c> soList=[select id,SalesOrgCode__c,Order_Status__c from Sales_Order__c where Order_Status__c = 'Pending' AND SalesOrgCode__c='5661' limit 1];          
        Test.startTest();
                PendingOrderMailBatch scBatch=new PendingOrderMailBatch();
       // Database.executeBatch(scBatch, 10);
                 scBatch.start(null);
                 scBatch.execute(null,soList);
                 scBatch.finish(null);	        
            SchedulePendingOrderMail schorder = new SchedulePendingOrderMail(); 
            String sch ='0 10 * * * ?'; 
            System.schedule('Schedule to send mail', sch,schorder);
        
        Test.stopTest();
        
    }
	
}