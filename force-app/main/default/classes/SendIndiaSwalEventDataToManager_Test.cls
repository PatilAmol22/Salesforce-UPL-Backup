/* Class Name:- SendIndiaSwalEventDataToManager_Test
* Description: This Class is used to create test   Activity data on.
* Created By: Shubham Bansal
* Created Date: 10 March 2023
* Created For India and Swal
*/

@isTest 

public class SendIndiaSwalEventDataToManager_Test {
    static testMethod void validateTestdata() {
        
      
        Event eventToInsert = new Event();
        
        eventToInsert.Subject = 'test';
        eventToInsert.StartDateTime = system.TODAY();  //datetime.newInstance(2017, 9, 15, 12, 30, 0);
        eventToInsert.EndDateTime = system.TODAY()+1;  //datetime.newInstance(2017, 9, 15, 12, 40, 0);
        eventToInsert.CurrencyIsoCode ='INR';
        eventToInsert.OwnerId = UserInfo.getUserId() ;
        eventToInsert.Meeting_Purpose__c ='test purpose' ;//;
        eventToInsert.Location__c ='Indore'; 
        eventToInsert.Meeting_Notes__c = 'testNotes';
        eventToInsert.Activity_Status__c='Planned';
        eventToInsert.custom_activity__c=true;
        eventToInsert.Others__c='Pending';
        eventToInsert.Created_From__c='India Activity';
        eventToInsert.CreatedDate=system.TODAY().addDays(-1);
        insert eventToInsert;
        Event eventToInsert1 = new Event();
        
        eventToInsert1.Subject = 'test';
        eventToInsert1.StartDateTime = system.TODAY().addDays(-4);  
        eventToInsert1.EndDateTime = system.TODAY()+1;  
        eventToInsert1.CurrencyIsoCode ='INR';
        eventToInsert1.OwnerId = UserInfo.getUserId() ;
        eventToInsert1.Meeting_Purpose__c ='test purpose' ;
        eventToInsert1.Location__c ='Indore'; 
        eventToInsert1.Meeting_Notes__c = 'testNotes';
              eventToInsert1.Activity_Status__c='Planned';
        eventToInsert1.custom_activity__c=true;
        eventToInsert1.Others__c='Pending';
        eventToInsert1.Created_From__c='India Activity';
        eventToInsert1.CreatedDate=system.TODAY().addDays(-1);
        insert eventToInsert1;
          Test.startTest();
        SendIndiaSwalEventDataToManagerContrll obj = new SendIndiaSwalEventDataToManagerContrll();
        SendIndiaSwalActivityDataOwner obj1 = new SendIndiaSwalActivityDataOwner();
        obj.getEventData();
        obj.UsermanagerId = userinfo.getUserId();
        obj1.UsermanagerId=userinfo.getUserId();
      
        String CRON_EXP = '0 6 * * * ?';
        String jobId = System.schedule('Activity Data Manager', CRON_EXP, new ActivityIndiaSwalScheulerForManager());
        String jobId2 = System.schedule('Activity Data Owner', CRON_EXP, new ActivityIndiaSwalScheulerForOwner());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
        
    } 
}