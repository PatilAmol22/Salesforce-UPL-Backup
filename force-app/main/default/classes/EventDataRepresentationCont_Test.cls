/* Class Name:- EventDataRepresentationIndiaSwal
* Description: This Class is used to show the Activity data on LWC Component thta is usong as a MIS Report.
* Created By: Shubham Bansal
* Created Date: 06 March 2023
* Created For India and Swal
*/

@isTest
public class EventDataRepresentationCont_Test {
    static testMethod void validateTestdata() {
        
        Test.startTest();
        //List<User> uObj = [SELECT ID FROM USER WHERE PROFILE.ID = '00e0K000001lCgH' LIMIT 1];
   


User u = new User(
     ProfileId =System.Label.NonAdminProfileId,
     LastName = 'last',
     Email = 'puser000@amamama.com',
     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US',
    Country  ='India',
    ManagerId = userinfo.getUserId()
    
     
    );
        insert u;
        
        
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
        insert eventToInsert;
        Event eventTo = new Event();
        
        eventTo.Subject = 'test';
        eventTo.StartDateTime = system.TODAY();  //datetime.newInstance(2017, 9, 15, 12, 30, 0);
        eventTo.EndDateTime = system.TODAY()+1;  //datetime.newInstance(2017, 9, 15, 12, 40, 0);
        eventTo.CurrencyIsoCode ='INR';
        eventTo.OwnerId = UserInfo.getUserId() ;
        eventTo.Meeting_Purpose__c ='test purpose' ;//;
        eventTo.Location__c ='Indore'; 
        eventTo.Meeting_Notes__c = 'testNotes';
        eventTo.Activity_Status__c='Planned';
        eventTo.custom_activity__c=true;
        eventTo.Others__c='Pending';
        eventTo.Created_From__c='India Activity';
        eventTo.OWNERID = u.ID;
        insert eventTo;
        
        
        String startDateTimeValue ='2023-02-23T07:30:00.000+0000';
        String enddataTimevalue ='2023-03-23T07:30:00.000+0000';
        String ApprovalStatusvalue = 'Pending';
        String Createddatevalue ='2023-02-23T07:30:00.000+0000';
        System.runAs(u) {
             EventDataRepresentationIndiaSwal.GetEventData();
        EventDataRepresentationIndiaSwal.GetFilterData(startDateTimeValue,enddataTimevalue,ApprovalStatusvalue,Createddatevalue);
        
        }
        EventDataRepresentationIndiaSwal.GetEventData();
        EventDataRepresentationIndiaSwal.GetFilterData(startDateTimeValue,enddataTimevalue,ApprovalStatusvalue,Createddatevalue);
        
        Test.stopTest();
        
    } 
    
}