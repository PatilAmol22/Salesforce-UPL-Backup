/* Class Name:- BatchCForIndiaSwalOwnerEventNotification
* Description: This Class is used to send Activity Data to owner.
* Created By: Shubham Bansal
* Created Date: 10 March 2023
* Created For India and Swal 
*/

global class BatchCForIndiaSwalOwnerEventNotification implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC){
        Set<Id> OwnerId=new Set<Id>();
        String query='';
        
        Date startCreatedDate;
        Date EndDCreatedate;
        System.Debug('####33' +System.today().Day());
        Date selectedDate =  Date.today();
        Date firstDate = selectedDate.toStartOfMonth();
        Date lastDate = firstDate.addDays(date.daysInMonth(selectedDate.year() , selectedDate.month())  - 1);
        system.debug(firstDate  + ' **** ' +lastDate.day() );
        string s = string.valueof(System.today());
        System.debug('s'+s); 
        
        if(!test.isRunningTest()){
            for(Event e:[SELECT Id,Meeting_Purpose__c,Activity_Type__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                         Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                         where SalesOrg__c IN('India','Swal') AND StartDateTime!=null AND CreatedDate >=:firstDate AND CreatedDate <:system.today() AND  Others__c IN('Pending','Approved','Rejected') and Created_From__c='India Activity' order by createdby.name]){
                             OwnerId.add(e.OwnerId);
                         }
        }
        else{
            for(Event e:[SELECT Id,Meeting_Purpose__c,Activity_Type__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                         Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                         order by createdby.name]){
                             OwnerId.add(e.OwnerId);
                         }   
        }
        return Database.getQueryLocator([Select id from User WHERE id in:OwnerId]);
    }
    
    global void execute(Database.BatchableContext BC, List<User> UserList){
        System.debug('userList 42 '+UserList);
        Date selectedDate =  Date.today();
        Date firstDate = selectedDate.toStartOfMonth();
        List<Event> EventList= new List<Event>();
        if(!test.isRunningTest()){
    EventList=    [Select id,Meeting_Purpose__c,Activity_Type__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                               Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate from Event where OwnerId in :UserList AND  SalesOrg__c IN('India','Swal')  AND StartDateTime!=null AND CreatedDate >=:firstDate AND CreatedDate <:system.today() AND  Others__c IN('Pending','Approved','Rejected') and Created_From__c='India Activity' order by createdby.name];
        }
        else{
               EventList=    [Select id,Meeting_Purpose__c,Activity_Type__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                               Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate from Event ]; 
        }
        Map<String,List<String>> newMapOwnerVsEvent = new Map<String,List<String>>();
        Set<Id> EventOwnerId = new Set<Id>();
        
        List<String> ccAddress = new List<String>();
        if(system.label.ccaddressIndaiActivity!=null)
        {
            for(String item : system.label.ccaddressIndaiActivity.split(',')){
                ccAddress.add(item.trim());
            }
        }
        if(EventList.size()>0 && !EventList.isEmpty()){
            for(event evObj:EventList)
            {
                EventOwnerId.add(evObj.OwnerId);
                
            }
        }
        
        String csvColumnHeader;
        if(EventList.size()>0 && !EventList.isEmpty()){
            for(Event e : EventList){
                
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
                    //List<Event> getNewList = newMap.get(evObj.Createdby.Manager.id)
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
        
        
        EmailTemplate Ownertemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName ='SendActivityDataToOwner'];
        
        for(id obj:EventOwnerId)
        {
            List<string> csvRowValues = new List<String>();
            system.debug(obj);
            
            if(newMapOwnerVsEvent.Containskey(obj))
            {
                csvRowValues = newMapOwnerVsEvent.get(obj);
                
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
                
                message.setTemplateID(Ownertemplate.Id);
                Messaging.SingleEmailMessage[] messages = new  
                    List<Messaging.SingleEmailMessage> {message};
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                system.debug(results);
            }      
            
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
    }
    
}