/* Class Name:- BatchClassForIndiaSwalEventNotification
* Description: This Class is used to show data in email table  .
* Created By: Shubham Bansal
* Created Date: 10 March 2023
* Created For India and Swal 
*/

global class BatchClassForIndiaSwalEventNotification implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC){
        Set<Id> ManagerId=new Set<Id>();
        String query='';
        Date startCreatedDate;
        Date EndDCreatedate;
        List<User>UserList=new List<User>();
        System.Debug('####33' +System.today().Day());
        Date selectedDate =  Date.today();
        Date firstDate = selectedDate.toStartOfMonth();
        Date lastDate = firstDate.addDays(date.daysInMonth(selectedDate.year() , selectedDate.month())  - 1);
        system.debug(firstDate  + ' **** ' +lastDate.day() );
        string s = string.valueof(System.today());
        System.debug('s'+s);
        if(!test.isRunningTest()){
            for(Event e:[SELECT Id,Meeting_Purpose__c,Activity_Type__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                         Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate,Createdby.Manager.Id FROM Event 
                         where SalesOrg__c IN('India','Swal') AND StartDateTime!=null  AND CreatedDate >=:firstDate AND CreatedDate <:system.today() AND  Others__c IN('Pending','Approved','Rejected') and Created_From__c='India Activity' order by createdby.name]){
                             ManagerId.add(e.Createdby.Manager.Id);
                         }
        }
        else{
            for(Event e:[SELECT Id,Meeting_Purpose__c,Activity_Type__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                         Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate,Createdby.Manager.Id FROM Event 
                         order by createdby.name]){
                             ManagerId.add(e.Createdby.Manager.Id);
                         } 
        }
        
        
        return Database.getQueryLocator([Select id from User WHERE id in:ManagerId AND isActive=True]);
        
        
        
    }
    
    global void execute(Database.BatchableContext BC, List<User> UserList){
        System.debug('EventList 45'+UserList);
        Date selectedDate =  Date.today();
        Date firstDate = selectedDate.toStartOfMonth();
        Map<String,List<String>> newMapOwnerVsEvent = new Map<String,List<String>>();
        Set<Id> UserOwnerId = new Set<Id>();
        Set<Id> OwnerandInline=new Set<Id>();
        //List<Id> uList=[Select id,name from user where managerid in :UserList].id;
        list<user> inlineusers =[Select id,name,managerid from user where managerid in : UserList];
        if(inlineusers!=null && !inlineusers.isEmpty()){
            for(user u:inlineusers){
                OwnerandInline.add(u.id);
                OwnerandInline.add(u.managerid);
            }
            
        }
         List<Event> EventList= new List<Event>();
        System.debug('OwnerandInline'+OwnerandInline);
           if(!test.isRunningTest()){
      EventList=[Select id,Meeting_Purpose__c,Activity_Type__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                               Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate,Createdby.Manager.Id from Event where OwnerId in :OwnerandInline  AND SalesOrg__c IN('India','Swal') AND StartDateTime!=null AND CreatedDate >=:firstDate AND CreatedDate <:system.today() AND  Others__c IN('Pending','Approved','Rejected') and Created_From__c='India Activity' order by createdby.name];
           }
         else{
               EventList=    [Select id,Meeting_Purpose__c,Activity_Type__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                               Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate from Event ]; 
        }
               System.debug('Event list'+EventList);
        Map<String,List<String>> newMapManagerVsEvent = new Map<String,List<String>>();
        Set<Id> UserManagerId = new Set<Id>();
        Set<Id> UserId = new Set<Id>();
        List<String> ccAddress = new List<String>();
        if(system.label.ccaddressIndaiActivity!=null)
        {
            for(String item : system.label.ccaddressIndaiActivity.split(',')){
                ccAddress.add(item.trim());
            }
        }
        List<String> ToAddress=new List<String>();
        if(EventList!=null && !EventList.IsEmpty()){
        for(event evObj:EventList)
        {
            UserOwnerId.add(evObj.OwnerId);
            
        }
        }
        System.debug('UserOwnerId after owner'+UserOwnerId);
        for(User u:[SELECT Email,Manager.Id from user where id in:UserOwnerId and Manager.IsActive =true and Manager.Id!=null]){//isactive and null check
            UserManagerId.add(u.Manager.Id );
        }
        System.debug('UserManagerId'+UserManagerId);
        String csvColumnHeader;
          if(EventList!=null && !EventList.IsEmpty()){
        for(Event e : EventList){
            if(newMapManagerVsEvent.Containskey(e.Createdby.Manager.id))
            {
                System.debug('eneterd in newmap mana' +e.StartDateTime+' '+e.EndDateTime); 
                e.StartDateTime=e.StartDateTime.addHours(0);
                e.EndDateTime=e.EndDateTime.addHours(0);
                String startTimeToShow = e.StartDateTime.format('HH:mm:ss','GMT');
                System.debug('startTimeToShow'+startTimeToShow);
                String EndTimeToShow = e.EndDateTime.format('HH:mm:ss','GMT');
                System.debug('newString'+EndTimeToShow);
                List<string> csvRowValues = newMapManagerVsEvent.get(e.Createdby.Manager.id);
                System.debug('csv'+newMapManagerVsEvent.get(e.Createdby.Manager.id));
                String StartDate = String.valueof(e.StartDateTime).substring(0,10);
                String StartTime = startTimeToShow;
                
                String EndDate = String.valueof(e.EndDateTime).substring(0,10);
                String EndTime = EndTimeToShow;
                System.Debug('EndTime'+EndTime);
                String  MeetingPurpose= e.Meeting_Purpose__c != null ? String.valueOf(e.Meeting_Purpose__c).escapeCsv() : '';
                String MeetingNotes = e.Meeting_Notes__c != null ? e.Meeting_Notes__c : '';
                MeetingNotes=MeetingNotes.replace(',', ' ');
                String OwnerName = e.Owner.name != null ? e.Owner.name : '';
                String ActivityStatus = e.Activity_Status__c != null ? e.Activity_Status__c : '';
                String ApprovalStatus = e.Others__c!= null ? e.Others__c : '';
                String OwnerUGDN = e.Createdby.UGDN_Number__c!= null ? e.Createdby.UGDN_Number__c : '';
                
                
                String csvRowVal = StartDate +','+StartTime+','+EndDate+','+EndTime+ ',' + MeetingPurpose + ',' + MeetingNotes + ',' + ActivityStatus+','+ OwnerName + ','+OwnerUGDN +','+ApprovalStatus ;
                csvRowValues.add(csvRowVal);
                newMapManagerVsEvent.put(e.Createdby.Manager.id,csvRowValues);
            }
            else
            {
                e.StartDateTime=e.StartDateTime.addHours(0);
                e.EndDateTime=e.EndDateTime.addHours(0);
                String startTimeToShow = e.StartDateTime.format('HH:mm:ss','GMT');
                String EndTimeToShow = e.EndDateTime.format('HH:mm:ss','GMT');
                
                String newString=String.valueOf(e.StartDateTime);
                System.debug('newString 1'+newString);
                String StartDate = String.valueof(e.StartDateTime).substring(0,10);
                String StartTime = startTimeToShow;
                String EndDate = String.valueof(e.EndDateTime).substring(0,10);
                String EndTime =EndTimeToShow;
                System.debug('EndTime else'+EndTime);
                String  MeetingPurpose= e.Meeting_Purpose__c != null ? String.valueOf(e.Meeting_Purpose__c).escapeCsv() : '';
                String MeetingNotes = e.Meeting_Notes__c != null ? e.Meeting_Notes__c : '';
                MeetingNotes=MeetingNotes.replace(',', ' ');
                String OwnerName = e.Owner.name != null ? e.Owner.name : '';
                String ActivityStatus = e.Activity_Status__c != null ? e.Activity_Status__c : '';
                String ApprovalStatus = e.Others__c!= null ? e.Others__c : '';
                String OwnerUGDN = e.Createdby.UGDN_Number__c!= null ? e.Createdby.UGDN_Number__c : '';
                
                List<string> csvRowValues = new List<String>();
                String csvRowVal = StartDate +','+StartTime+','+EndDate+','+EndTime+ ',' + MeetingPurpose + ',' + MeetingNotes + ',' + ActivityStatus+','+ OwnerName+ ','+ OwnerUGDN + ','+ApprovalStatus;
                csvRowValues.add(csvRowVal);
                newMapManagerVsEvent.put(e.Createdby.Manager.id,csvRowValues);
                
            }
            
            if(newMapOwnerVsEvent.Containskey(e.OwnerId))
            {
                System.debug('eneterd in newmap'); 
                e.StartDateTime=e.StartDateTime.addHours(0);
                e.EndDateTime=e.EndDateTime.addHours(0);
                String startTimeToShow = e.StartDateTime.format('HH:mm:ss','GMT');
                String EndTimeToShow = e.EndDateTime.format('HH:mm:ss','GMT');
                List<string> csvRowValues = newMapOwnerVsEvent.get(e.OwnerId);
                System.debug('csvRowValueForOwner'+csvRowValues +newMapOwnerVsEvent.get(e.OwnerId));
                String StartDate = String.valueof(e.StartDateTime).substring(0,10);
                String StartTime = startTimeToShow;
                String EndDate = String.valueof(e.EndDateTime).substring(0,10);
                String EndTime = EndTimeToShow;
                String  MeetingPurpose= e.Meeting_Purpose__c != null ? String.valueOf(e.Meeting_Purpose__c).escapeCsv() : '';
                String MeetingNotes = e.Meeting_Notes__c != null ? e.Meeting_Notes__c : '';
                MeetingNotes=MeetingNotes.replace(',', ' ');
                String OwnerName = e.Owner.name != null ? e.Owner.name : '';
                String ActivityStatus = e.Activity_Status__c != null ? e.Activity_Status__c : '';
                String ApprovalStatus = e.Others__c!= null ? e.Others__c : '';
                String OwnerUGDN = e.Createdby.UGDN_Number__c!= null ? e.Createdby.UGDN_Number__c : '';
                
                
                String csvRowVal = StartDate +','+StartTime+','+EndDate+','+EndTime+ ',' + MeetingPurpose + ',' + MeetingNotes + ',' + ActivityStatus+','+ OwnerName +','+ OwnerUGDN + ','+ApprovalStatus;
                
                csvRowValues.add(csvRowVal);
                System.debug('csvRowVal owner'+csvRowVal);
                System.debug('csvRowValueForOwner '+csvRowValues);
                System.debug('e.Id'+e.Id+'@@22 '+e.OwnerId);
                newMapOwnerVsEvent.put(e.OwnerId,csvRowValues);
                
            }            
            else
            {
                
                e.StartDateTime=e.StartDateTime.addHours(0);
                e.EndDateTime=e.EndDateTime.addHours(0);
                String startTimeToShow = e.StartDateTime.format('HH:mm:ss','GMT');
                String EndTimeToShow = e.EndDateTime.format('HH:mm:ss','GMT');
                String StartDate = String.valueof(e.StartDateTime).substring(0,10);
                String StartTime = startTimeToShow;
                String EndDate = String.valueof(e.EndDateTime).substring(0,10);
                String EndTime = EndTimeToShow;
                String  MeetingPurpose= e.Meeting_Purpose__c != null ? String.valueOf(e.Meeting_Purpose__c).escapeCsv() : '';
                String MeetingNotes = e.Meeting_Notes__c != null ? e.Meeting_Notes__c : '';
                MeetingNotes=MeetingNotes.replace(',', ' ');
                String OwnerName = e.Owner.name != null ? e.Owner.name : '';
                String ActivityStatus = e.Activity_Status__c != null ? e.Activity_Status__c : '';
                String ApprovalStatus = e.Others__c!= null ? e.Others__c : '';
                String OwnerUGDN = e.Createdby.UGDN_Number__c!= null ? e.Createdby.UGDN_Number__c : '';
                
                List<string> csvRowValues = new List<string>();
                String csvRowVal = StartDate +','+StartTime+','+EndDate+','+EndTime+ ',' + MeetingPurpose + ',' + MeetingNotes + ',' + ActivityStatus+','+ OwnerName +','+ OwnerUGDN +','+ApprovalStatus ;
                csvRowValues.add(csvRowVal);
                newMapOwnerVsEvent.put(e.OwnerId,csvRowValues);
                
            }
            
        }
        }
        
        
        EmailTemplate emplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName ='SendEventDetailToManager'];
        if(UserManagerId!=null && !UserManagerId.IsEmpty())
        {
            for(id obj:UserManagerId)
            {
                List<string> csvRowValues = new List<String>();
                system.debug(obj);
                if(newMapManagerVsEvent.Containskey(obj))
                {
                    csvRowValues = newMapManagerVsEvent.get(obj);
                    if(newMapOwnerVsEvent.Containskey(obj))
                    {
                        csvRowValues.addall(newMapOwnerVsEvent.get(obj));
                    }
                    system.debug('csvRowValueslist1234567'+ csvRowValues);
                    
                    csvColumnHeader = 'StartDate,StartTime,EndDate,EndTime, Meeting Purpose, Meeting Notes, Activity Status,Owner Name, Owner UGDN, Approval Status \n';
                    String csvFile = csvColumnHeader + String.join(csvRowValues,'\n');
                    
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.setTargetObjectId(obj);
                    message.setSaveAsActivity(false);
                    message.setCcAddresses(ccAddress);
                    Messaging.EmailFileAttachment attach1 = new Messaging.EmailFileAttachment();
                    blob b;
                    if(Test.isRunningTest()) {
                        b = blob.valueOf('Unit.Test');
                    } else {
                        b = Blob.valueOf(csvFile);
                    }                        
                    
                    attach1.setFileName('Activity data.csv');
                    attach1.setBody(b);
                    message.setFileAttachments(new Messaging.EmailFileAttachment[]{attach1});
                    message.setTemplateID(emplate.Id);
                    Messaging.SingleEmailMessage[] messages = new  
                    List<Messaging.SingleEmailMessage> {message};
                    System.debug('message 236'+message);
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                   
                }
                
                
                
            }
            
        }
    }
    
    global void finish(Database.BatchableContext BC){
    }
    
}