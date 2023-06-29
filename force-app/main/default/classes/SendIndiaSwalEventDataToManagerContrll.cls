/* Class Name:- SendIndiaSwalEventDataToManagerContrll
* Description: This Class is used to show the Activity data on Email that we are send it to manager.
* Created By: Shubham Bansal
* Created Date: 10 March 2023
* Created For India and Swal
*/
public class SendIndiaSwalEventDataToManagerContrll {
  
    public Id UsermanagerId {get;set;}
    public  List<Event> getEventData()
    {
        list<id> inlineuserid= new   list<id>();
              list<id> OwnerandInline= new   list<id>();
           Id LoginUserID = UserInfo.getUserId();
            System.debug('LoginUserID:---'+LoginUserID);
            list<user> inlineusers =[Select id,name from user where managerid =: UsermanagerId];
            if(inlineusers!=null && !inlineusers.isEmpty()){
                for(user u:inlineusers){
                    inlineuserid.add(u.id);
                    OwnerandInline.add(u.id);
                }
                
            }
            OwnerandInline.add(UsermanagerId);
            Date selectedDate =  Date.today();
    Date firstDate = selectedDate.toStartOfMonth();
        List<Event> eventList = new  List<Event>();
           eventList = [SELECT Id,Meeting_Purpose__c,Activity_Type__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                         Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                        where (OwnerId=: OwnerandInline) and SalesOrg__c IN('India','Swal')  AND StartDateTime!=null AND CreatedDate >=:firstDate AND CreatedDate <:system.today() AND  Others__c IN('Pending','Approved','Rejected') and Created_From__c='India Activity' order by createdby.name];
           System.debug('Event List.. ' + eventList);
        return eventList;
    }

}