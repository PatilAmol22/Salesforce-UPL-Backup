@isTest
public class TestClassForInvocableMethodOnIndiaSwal {
    @testSetup
    static void setup() {
        String ManagerID= [SELECT Name, ManagerID, Manager.Name FROM User WHERE ManagerID!=null limit 1 ].ManagerID;
        Event eventToInsert = new Event();
        eventToInsert.Subject = 'test record for test class';
        eventToInsert.Meeting_Notes__c =  'Test';
        eventToInsert.custom_activity__c = true;
        eventToInsert.Type='Meeting';
        
        eventToInsert.StartDateTime = System.today();
        eventToInsert.EndDateTime = System.today()+1;
        eventToInsert.CurrencyIsoCode ='INR';
        //eventToInsert.OwnerId=UserInfo.getUserId(); 
        insert eventToInsert; 
        Activity_Event__c ae=new Activity_Event__c();
       ae.Related_Event_Id__c=eventToInsert.id;
        ae.Event_Manger__c=ManagerID;
       insert ae;
    }
    @isTest
    static void testMethod1() {
        List<String> eventIDList=new List<String>();
        String EventId=[Select id from Event limit 1].id;
        eventIDList.add(EventId);
        System.debug('eventIDList'+eventIDList);
        Test.startTest();
        if(eventIDList!=null && eventIDList.size()>0 && !eventIDList.isEmpty()){
            UpdatingMeetingNotesIndiaSwal.submitForApproval(eventIDList);
        }
        Test.stopTest();
    }
    @isTest
    static void testMethod2() {
        List<String> activityEventList=new List<String>();
       
        
        
        
       
        Activity_Event__c activityEvent= [Select id,Meething_Notes__c,Related_Event_Id__c,Status__c from Activity_Event__c  limit 1];
        System.debug('activityEvent'+activityEvent);
        activityEvent.Status__c =  'Approved';
        update activityEvent;
        activityEventList.add(activityEvent.Id);
        
        Test.startTest();
        if(activityEventList!=null && activityEventList.size()>0 && !activityEventList.isEmpty()){
            try{
                ApprovalProcessManagementIndiaAndSwal.submitForApproval(activityEventList);
            }
            catch(Exception ex)
            {
                System.debug(ex.getMessage());
            }
        }
        Test.stopTest();
    }
    @isTest
    static void testMethod3() {
        List<String> activityEventList=new List<String>();
        
        Activity_Event__c activityEvent= [Select id,Related_Event_Id__c,Meething_Notes__c,Status__c from Activity_Event__c limit 1];
        activityEvent.Status__c = 'rejected';
        update activityEvent;
        activityEventList.add(activityEvent.Id);
        Test.startTest();
        if(activityEventList!=null && activityEventList.size()>0 && !activityEventList.isEmpty()){
            ActivityEventStatusFieldUpdateIndiaSwal.RecordToUpdate(activityEventList);
        }
        Test.stopTest();
    }
    
}