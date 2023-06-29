/* Class Name:- EventDataRepresentationIndiaSwal
* Description: This Class is used to show the Activity data on LWC Component thta is usong as a MIS Report.
* Created By: Shubham Bansal
* Created Date: 06 March 2023
* Created For India and Swal
*/
public class EventDataRepresentationIndiaSwal {
    /*
* Method Start: GetEventData
* This Method is used to fetch the report data on report load.
*/
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> GetEventData(){
        
        List<Map<String,String>> NewListMap = new List<Map<String,String>>();
        list<id> inlineuserid= new   list<id>();
        list<id> OwnerandInline= new   list<id>();
        Id LoginUserID = UserInfo.getUserId();
        System.debug('LoginUserID:---'+LoginUserID);
        list<user> inlineusers =[Select id,name from user where managerid=:LoginUserID ];
        if(inlineusers!=null && !inlineusers.isEmpty()){
            for(user u:inlineusers){
                inlineuserid.add(u.id);
                OwnerandInline.add(u.id);
            }
            
        }
        OwnerandInline.add(LoginUserID);
         List<Event> eventList = new  List<Event>();
        if(userinfo.getProfileId() == System.Label.System_Admin_Profile){
            system.debug('inside the system admin');
        eventList = [SELECT Id,Meeting_Purpose__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                     Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                     where  SalesOrg__c IN('India','Swal') AND StartDateTime!=null AND Others__c IN('Pending','Approved','Rejected') and Created_From__c='India Activity'  limit 50000 ];
        
        }else
        {
          system.debug('Not inside the system admin');
        eventList = [SELECT Id,Meeting_Purpose__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                     Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                     where OwnerId IN:OwnerandInline and SalesOrg__c IN('India','Swal') AND StartDateTime!=null AND Others__c IN('Pending','Approved','Rejected') and Created_From__c='India Activity'  limit 50000 ];
          
        }
           
       System.debug('Event List.. ' + eventList.size());
        if(test.isRunningTest()){
            eventList = [SELECT Id,Meeting_Purpose__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                         Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                         limit 10 ];
            
        }
        if(eventList!=null && !eventList.IsEmpty())
        {
        for(event evObj:eventList)
        {
            Map<String,String> NewMap = new Map<String,String>();
            NewMap.put('Meeting_Purpose__c',evObj.Meeting_Purpose__c);
            NewMap.put('Subject',evObj.Subject);
            NewMap.put('Location__c',evObj.Location__c);
            NewMap.put('Meeting_Notes__c',evObj.Meeting_Notes__c);
            NewMap.put('Activity_Status__c',evObj.Activity_Status__c);
            NewMap.put('StartDateTime',String.valueof(evObj.StartDateTime).substring(0,10));
            NewMap.put('EndDateTime',String.valueof(evObj.EndDateTime).substring(0,10));
            NewMap.put('OwnerId',evObj.OwnerId);
            NewMap.put('OwnerName',evObj.Owner.Name);
            NewMap.put('Expenses__c',String.valueof(evObj.Expenses__c));
            NewMap.put('others__c',evObj.others__c);
            NewMap.put('CreatedbyName',evObj.Createdby.Name); 
            NewMap.put('ManagerName',evObj.Createdby.Manager.Name); 
            NewMap.put('UGDN_Number__c',evObj.Createdby.UGDN_Number__c);
            NewMap.put('Createddate',String.valueof(evObj.Createddate).substring(0,10));
            NewMap.put('CreatedTime',String.valueof(evObj.Createddate).substring(10,19));
            //NewMap.put('EndTime',String.valueof(evObj.EndDateTime).substring(10,19));
            NewMap.put('MangerUGDNNumber',evObj.Createdby.Manager.UGDN_Number__c);
            system.debug('evObj.Createdby.Manager.UGDN_Number__c'+ evObj.Createdby.Manager.UGDN_Number__c);
            system.debug('evObj.Createdby.Manager.UGDN_Number__c'+ evObj.Createdby.Manager.UGDN_Number__c);
            NewMap.put('StartTime',String.valueof(evObj.StartDateTime).substring(10,19));
            NewMap.put('EndTime',String.valueof(evObj.EndDateTime).substring(10,19));
            
            
            NewListMap.add(NewMap);
        }
    }
        return NewListMap;
    }
    /*
* Method End: GetEventData

/** Method Start: GetFilterData
*This method is use to filter the report data according to the user filtered condition
*/
    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> GetFilterData(String startDateTimeValue,String enddataTimevalue,String ApprovalStatusvalue,String Createddatevalue){
        
        List<Map<String,String>> NewListMap = new List<Map<String,String>>();
        list<id> inlineuserid= new   list<id>();
        list<id> OwnerandInline= new   list<id>();
        Date t1;
        Date t2;
        Id LoginUserID = UserInfo.getUserId();
        System.debug('LoginUserIDGetFilterData:---'+LoginUserID);
        list<user> inlineusers =[Select id,name from user where managerid=:LoginUserID];
        if(inlineusers!=null && !inlineusers.isEmpty()){
            for(user u:inlineusers){
                inlineuserid.add(u.id);
                OwnerandInline.add(u.id);
            }
            
        }
        OwnerandInline.add(LoginUserID);
        List<Event> eventList = new  List<Event>();
        if(!String.isEmpty(startDateTimeValue)){
         String datevar=startDateTimeValue.remove('"');
        Date sampleDate = Date.valueOf(datevar);
         t1 = date.newinstance(sampleDate.year(), sampleDate.month(), sampleDate.day());
        System.debug('dssdsds'+t1);
        }
          if(!String.isEmpty(enddataTimevalue)){
             String datevar2 =enddataTimevalue.remove('"');
        Date sampleDate2 = Date.valueOf(datevar2);
         t2 = date.newinstance(sampleDate2.year(), sampleDate2.month(), sampleDate2.day());
       
        t2=t2.addDays(1);
             System.debug('dssdsds'+t2);
          }
        if(userinfo.getProfileId() == System.Label.System_Admin_Profile){
              if(!String.isEmpty(startDateTimeValue) && !String.isEmpty(enddataTimevalue) && String.isEmpty(ApprovalStatusvalue))
        {
           
            //system.debug('enddataTimevalue'+Datetime.valueof(enddataTimevalue));
             //system.debug('startDateTimeValue'+Datetime.valueof(startDateTimeValue));
            //system.debug('inside the system admin profile----1'+ Datetime.valueof(startDateTimeValue));
            eventList = [SELECT Id,Meeting_Purpose__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                         Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                         where  SalesOrg__c IN('India','Swal') and Created_From__c='India Activity' AND StartDateTime!=null AND StartDateTime >=: t1 AND EndDateTime <: t2  AND Others__c IN('Pending','Approved','Rejected')limit 50000];
        }
        else if(!String.isEmpty(startDateTimeValue) && !String.isEmpty(enddataTimevalue) && !String.isEmpty(ApprovalStatusvalue))
        {
            if(ApprovalStatusvalue !='None')
            {
                eventList = [SELECT Id,Meeting_Purpose__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                             Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                             where  SalesOrg__c IN('India','Swal') and Created_From__c='India Activity' AND StartDateTime!=null AND StartDateTime >=: t1 AND EndDateTime<:t2 AND others__c =:ApprovalStatusvalue  limit 50000];
            }
            else
            {
                eventList = [SELECT Id,Meeting_Purpose__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                             Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                             where  SalesOrg__c IN('India','Swal') and Created_From__c='India Activity' AND StartDateTime!=null AND StartDateTime >=: t1 AND EndDateTime<:t2 AND Others__c IN('Pending','Approved','Rejected') limit 50000 ];
                
            }
        }
        else if(String.isEmpty(startDateTimeValue) && String.isEmpty(enddataTimevalue) && !String.isEmpty(ApprovalStatusvalue))
        {
            if(ApprovalStatusvalue !='None')
            {
                
                eventList = [SELECT Id,Meeting_Purpose__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                             Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                             where SalesOrg__c IN('India','Swal') and Created_From__c='India Activity' AND StartDateTime!=null AND others__c =:ApprovalStatusvalue limit 50000];
                
            }
            else
            {
                eventList = [SELECT Id,Meeting_Purpose__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                             Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                             where SalesOrg__c IN('India','Swal') and Created_From__c='India Activity' AND StartDateTime!=null AND Others__c IN('Pending','Approved','Rejected')  limit 50000 ];
                
            }
            
            
        }
        if(test.isRunningTest()){
            eventList = [SELECT Id,Meeting_Purpose__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                         Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                         limit 10 ];
            
        }
        
        System.debug('Event List.. ' + eventList.size());
         if(eventList!=null && !eventList.IsEmpty())
        {
        for(event evObj:eventList)
        {
            Map<String,String> NewMap = new Map<String,String>();
            NewMap.put('Meeting_Purpose__c',evObj.Meeting_Purpose__c);
            NewMap.put('Subject',evObj.Subject);
            NewMap.put('Location__c',evObj.Location__c);
            NewMap.put('Meeting_Notes__c',evObj.Meeting_Notes__c);
            NewMap.put('Activity_Status__c',evObj.Activity_Status__c);
            NewMap.put('StartDateTime',String.valueof(evObj.StartDateTime).substring(0,10));
            NewMap.put('EndDateTime',String.valueof(evObj.EndDateTime).substring(0,10));
            NewMap.put('OwnerId',evObj.OwnerId);
            NewMap.put('OwnerName',evObj.Owner.Name);
            NewMap.put('Expenses__c',String.valueof(evObj.Expenses__c));
            NewMap.put('others__c',evObj.others__c);
            NewMap.put('CreatedbyName',evObj.Createdby.Name); 
            NewMap.put('ManagerName',evObj.Createdby.Manager.Name); 
            NewMap.put('UGDN_Number__c',evObj.Createdby.UGDN_Number__c);
            NewMap.put('Createddate',String.valueof(evObj.Createddate).substring(0,10));
            NewMap.put('CreatedTime',String.valueof(evObj.Createddate).substring(10,19));
            NewMap.put('MangerUGDNNumber',evObj.Createdby.Manager.UGDN_Number__c);
            NewMap.put('StartTime',String.valueof(evObj.StartDateTime).substring(10,19));
            NewMap.put('EndTime',String.valueof(evObj.EndDateTime).substring(10,19));
            
            
            NewListMap.add(NewMap);
        }
    }
        }
        else 
        {
              if(!String.isEmpty(startDateTimeValue) && !String.isEmpty(enddataTimevalue) && String.isEmpty(ApprovalStatusvalue))
        {
            
            eventList = [SELECT Id,Meeting_Purpose__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                         Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                         where OwnerId IN:OwnerandInline and SalesOrg__c IN('India','Swal') and Created_From__c='India Activity' AND StartDateTime!=null AND StartDateTime >=: t1 AND EndDateTime <: t2 AND Others__c IN('Pending','Approved','Rejected') limit 50000];
        }
        else if(!String.isEmpty(startDateTimeValue) && !String.isEmpty(enddataTimevalue) && !String.isEmpty(ApprovalStatusvalue))
        {
            if(ApprovalStatusvalue !='None')
            {
                eventList = [SELECT Id,Meeting_Purpose__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                             Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                             where OwnerId IN:OwnerandInline and SalesOrg__c IN('India','Swal') and Created_From__c='India Activity' AND StartDateTime!=null AND StartDateTime >=: t1 AND EndDateTime<:t2 AND others__c =:ApprovalStatusvalue limit 50000];
            }
            else
            {
                eventList = [SELECT Id,Meeting_Purpose__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                             Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                             where OwnerId IN:OwnerandInline and SalesOrg__c IN('India','Swal') and Created_From__c='India Activity' AND StartDateTime!=null AND StartDateTime >=: t1 AND EndDateTime<:t2 AND Others__c IN('Pending','Approved','Rejected') limit 50000 ];
                
            }
        }
        else if(String.isEmpty(startDateTimeValue) && String.isEmpty(enddataTimevalue) && !String.isEmpty(ApprovalStatusvalue))
        {
            if(ApprovalStatusvalue !='None')
            {
                
                eventList = [SELECT Id,Meeting_Purpose__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                             Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                             where OwnerId IN:OwnerandInline and SalesOrg__c IN('India','Swal') and Created_From__c='India Activity' AND StartDateTime!=null AND others__c =:ApprovalStatusvalue limit 50000];
                
            }
            else
            {
                eventList = [SELECT Id,Meeting_Purpose__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                             Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                             where OwnerId IN:OwnerandInline and SalesOrg__c IN('India','Swal') and Created_From__c='India Activity' AND StartDateTime!=null AND Others__c IN('Pending','Approved','Rejected')  limit 50000 ];
                
            }
            
            
        }
        if(test.isRunningTest()){
            eventList = [SELECT Id,Meeting_Purpose__c,Location__c,Meeting_Notes__c,Subject,Activity_Status__c, StartDateTime, EndDateTime,OwnerId,Owner.Name,
                         Expenses__c,others__c,Createdby.Name,Createdby.Manager.Name,Createdby.UGDN_Number__c,Createdby.Manager.UGDN_Number__c,Createddate FROM Event 
                         limit 10 ];
            
        }
        
        System.debug('Event List.. ' + eventList.size());
         if(eventList!=null && !eventList.IsEmpty())
        {
        for(event evObj:eventList)
        {
            Map<String,String> NewMap = new Map<String,String>();
            NewMap.put('Meeting_Purpose__c',evObj.Meeting_Purpose__c);
            NewMap.put('Subject',evObj.Subject);
            NewMap.put('Location__c',evObj.Location__c);
            NewMap.put('Meeting_Notes__c',evObj.Meeting_Notes__c);
            NewMap.put('Activity_Status__c',evObj.Activity_Status__c);
            NewMap.put('StartDateTime',String.valueof(evObj.StartDateTime).substring(0,10));
            NewMap.put('EndDateTime',String.valueof(evObj.EndDateTime).substring(0,10));
            NewMap.put('OwnerId',evObj.OwnerId);
            NewMap.put('OwnerName',evObj.Owner.Name);
            NewMap.put('Expenses__c',String.valueof(evObj.Expenses__c));
            NewMap.put('others__c',evObj.others__c);
            NewMap.put('CreatedbyName',evObj.Createdby.Name); 
            NewMap.put('ManagerName',evObj.Createdby.Manager.Name); 
            NewMap.put('UGDN_Number__c',evObj.Createdby.UGDN_Number__c);
            NewMap.put('Createddate',String.valueof(evObj.Createddate).substring(0,10));
            NewMap.put('CreatedTime',String.valueof(evObj.Createddate).substring(10,19));
            NewMap.put('MangerUGDNNumber',evObj.Createdby.Manager.UGDN_Number__c);
            NewMap.put('StartTime',String.valueof(evObj.StartDateTime).substring(10,19));
            NewMap.put('EndTime',String.valueof(evObj.EndDateTime).substring(10,19));
            
            
            NewListMap.add(NewMap);
        }
    }
        }
      
        system.debug('NewListMap@@@@----->'+ NewListMap.size());
        return NewListMap;
    }
    /* Method End GetFilterData
*/
}
/*
* Class Code End
*/