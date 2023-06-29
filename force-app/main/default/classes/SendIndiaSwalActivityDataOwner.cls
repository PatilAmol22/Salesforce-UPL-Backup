/* Class Name:- SendIndiaSwalActivityDataOwner
* Description: This Class is used to show data in email table  .
* Created By: Shubham Bansal
* Created Date: 10 March 2023
* Created For India and Swal
*/

public class SendIndiaSwalActivityDataOwner {
    
     public Id UsermanagerId {get;set;}
    public  List<Event> getEventData()
    {
       
    Date selectedDate =  Date.today();
    Date firstDate = selectedDate.toStartOfMonth();
        List<Event> eventList = new  List<Event>();
           eventList = [SELECT Id,Meeting_Purpose__c,Activity_Type__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                         Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                        where ( OwnerId=:UsermanagerId) and SalesOrg__c IN('India','Swal')  AND StartDateTime!=null AND CreatedDate >=:firstDate AND CreatedDate <:system.today() AND  Others__c IN('Pending','Approved','Rejected') and Created_From__c='India Activity' order by createdby.name];
           System.debug('Event List.. ' + eventList);
        return eventList;
    }

}