/*
@Author: Shubham Bansal(GRZ) For ActivityManagement India Swal
@Class_Description : Controller to call from vf page to create event from calendar and show data saved on calendar.
*/ 
public with sharing class ActivityManagementIndiaSwalController{
    
    public  List<Event> eventList{get;set;}
    private  List<Account> AccountList;//{get;set;}
    public List<List<Account>> nestedListAccount{get;set;}
    public  List<Event> monthlyeventList{get;set;}
    public List<Event> inlineUserEventList{get;set;}
    private Id LoginUserID;
    public Event eventToInsert{get;set;}
    public List<FarmerActivity__c> farmerAcc ;
    public String Meeting_Purpose{get;set;}
    public String Activity_Type{get;set;}
    public String Start_Date{get;set;}
    public String Account_Type{get;set;}
    public String End_Date{get;set;}
    public String Account{get;set;}
    public String Location{get;set;}
    public String Meeting_Notes{get;set;}
    public String EventSubject{get;set;}
    public String StartDate{get;set;}
    public String StartTime{get;set;}
    public String EndDate{get;set;}
    public String EndTime{get;set;}
    public ID SelectedEventId{get;set;}
    public String contactIds{get;set;}
    public String status{get;set;}
    public String farmerActivity{get;set;}
    public Integer noOfKmTravel;//{get;set;}
    public Integer food;//{get;set;}
    public Integer nightStay;//{get;set;}
    public Integer otherExp;//{get;set;}
    public List<Attachment>AttachmentList{get;set;}
    public List<Event> EventListOnDoubleTap{get;set;}
    public String CurrentDateActivity{get;set;}
        public Integer MonthNumber{get;set;}
    public List<event>todaysEvent{get;set;}
    public List<contact>contactList{get;set;}
    public String groupedResultsString{get;set;}
    List<EventRelation>vfEventRelList{get;set;}
    public string jsonEventRelation{get;set;}
    public string inviteeToDelete{get;set;}
    public String attachmentToDelete{get;set;}
    public String userTimeZone{get;set;}
    public String inviteeTimeZone;
    public User currentUser{get;set;}
    public string accountSearchKey{get;set;}
    public String currentDateTimeStart {get;set;}
    public String currentDateTimeEnd {get;set;}
    public String parentStr {get;set;}
    public List<Village__c>villageList;
    public List<Crop__c>cropList{get;set;}
    public List<SKU__c >productList{get;set;}
    public List<FarmerActivity__c> FAList{get;set;}
    public List<List<Village__c>> nestedListVillage{get;set;}
    public RecordType rt{get;set;}
    public datetime cdate{get;set;}
    public String evid{get;set;}
    public Integer noOfFarmer{get;set;}              /*Created by Nikhil*/
    public Integer expenses{get;set;}                /*Created by Nikhil*/
    public String inputCrops{get;set;}               /*Created by Nikhil*/
    public String inputProducts{get;set;}            /*Created by Nikhil*/
    public List<String>inputCropList{get;set;}       /*Created by Nikhil*/
    public List<String>inputProductList{get;set;}    /*Created by Nikhil*/
    public ID faId{get;set;}                         /*Created by Nikhil*/
    public String type{get;set;}                     /*Created by Nikhil*/
    public Map<String,String> productMap{get;set;}                /*Created by Nikhil*/
    /*End of Event Fields*/  
    public String ActivityCurrency{get;set;}    
    //Added by Varun Shrivastava : SCTASK0362006 Start
    public DateTime eventStartDateTime{get;set;}
    public DateTime eventEndDateTime{get;set;}
    public ID eventFetchID{get;set;}
    public Boolean isDSTEnabled{get;set;}
    public ActivityManagementIndiaSwalController(){
        try{
            cdate = DateTime.now();
            rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Account' AND Name='PreRegistered Farmer' LIMIT 1];
                isDSTEnabled = false;        
            System.debug(DateTime.now().format('yyyy-MM-dd\'T\'hh:mm'));
            currentDateTimeStart  = DateTime.now().format('yyyy-MM-dd\'T\'hh:mm');
            System.debug('End time'+DateTime.now().addHours(1).format('yyyy-MM-dd\'T\'hh:mm'));
            status = 'Planned';
            contactIds='';
            inviteeToDelete = '';
            inviteeTimeZone  = '';
            Account_Type='';
            list<id> inlineuserid= new   list<id>();
              list<id> OwnerandInline= new   list<id>();
            LoginUserID = UserInfo.getUserId();
            System.debug('LoginUserID:---'+LoginUserID);
            list<user> inlineusers =[Select id,name from user where managerid=:LoginUserID];
            if(inlineusers!=null && !inlineusers.isEmpty()){
                for(user u:inlineusers){
                    inlineuserid.add(u.id);
                    OwnerandInline.add(u.id);
                }
                
            }
            OwnerandInline.add(LoginUserID);
            currentUser = [select id, Country from user where id =: UserInfo.getUserId() ];
            TimeZone tz = UserInfo.getTimeZone();
            System.debug('Display name: ' +tz.getDisplayName());
            System.debug('ID: ' + tz.getID());
            System.debug('currentUser : ' + currentUser);
            userTimeZone =tz.getID(); 
            noOfKmTravel = 0;food=0;nightStay=0;otherExp=0;
            AggregateResult[] groupedResults = [SELECT sum(Night_Stay__c)nightstay,sum(Other_Expenses__c)otherexp,sum(Food__c)foodexp, sum(No_of_KMs_Travelled__c)noofkm,calendar_month(StartDateTime)month  from event where OwnerId=:LoginUserID  GROUP BY calendar_month(StartDateTime)];
            groupedResultsString = JSON.serialize(groupedResults);
            attachmentToDelete = '';
            eventList = new List<Event>();
            AttachmentList = new List<Attachment>();  
            AccountList = new List<Account>();
            eventList = [SELECT Id, Invitee_Timezone__c,Food__c,Night_Stay__c,Other_Expenses__c,Meeting_Purpose__c,Location__c,Meeting_Notes__c,
                         No_of_KMs_Travelled__c,Account.name,Subject,Activity_Status__c, AccountId, StartDateTime,
                         EndDateTime,OwnerId, No_of_Farmers__c, Expenses__c,others__c,Next_Action__c FROM Event
                         where OwnerId IN:OwnerandInline and SalesOrg__c IN('India','Swal')
                         AND StartDateTime!=null and Others__c IN('Pending','Approved','Rejected') and Created_From__c='India Activity'];
           // System.debug('Event List.. ' + eventList.size());
            Date firstDayOfMonth = System.today().toStartOfMonth();
            Date t1 = date.newinstance(firstDayOfMonth.year(), firstDayOfMonth.month(), firstDayOfMonth.day());
            Date lastDayOfMonth = firstDayOfMonth.addDays(Date.daysInMonth(firstDayOfMonth.year(), firstDayOfMonth.month()));
            Date t2 = date.newinstance(lastDayOfMonth.year(), lastDayOfMonth.month(), lastDayOfMonth.day());
            system.debug('dt2'+t1+'32234234'+t2);
            
            monthlyeventList=[SELECT Id,Meeting_Notes__c, Others__c,Invitee_Timezone__c,Owner.name,Subject,Activity_Status__c, AccountId, StartDateTime, EndDateTime,OwnerId FROM Event where OwnerId=:LoginUserID AND SalesOrg__c IN ('India','Swal') and Created_From__c='India Activity' AND  Others__c IN('Pending','Approved','Rejected') And ((StartDateTime>=:t1 and StartDateTime<:t2) Or (EndDateTime>=:t1 and EndDateTime<:t2))  limit 100];
            if(inlineuserid!=null && !inlineuserid.isEmpty()){
                
                inlineUserEventList=[SELECT Id,Meeting_Notes__c, Others__c,Invitee_Timezone__c,Owner.name,Subject,Activity_Status__c, AccountId, StartDateTime, EndDateTime,OwnerId FROM Event where OwnerId in:inlineuserid AND SalesOrg__c IN ('India','Swal') and Created_From__c='India Activity' AND Others__c IN('Pending','Approved','Rejected') And ((StartDateTime>=:t1 and StartDateTime<:t2) Or (EndDateTime>=:t1 and EndDateTime<:t2))  limit 100];
                
            }
            system.debug('@@@@@monthlyeventList@@@@'+monthlyeventList);
            system.debug('@@@@@inlineUserEventList@@@@'+inlineuserid+'$$$$$$$$$$$$$$$$$$$$$'+inlineUserEventList);
            for(Event env:eventList)
            {
                //env.StartDateTime=env.StartDateTime.adddays(-1);//
                //env.EndDateTime=env.EndDateTime.adddays(-1);
                if(String.isNotBlank(env.Meeting_Purpose__c)){
                    env.Meeting_Purpose__c=env.Meeting_Purpose__c.replaceAll('/[^a-zA-Z0-9]/g', '');
                }
                if(String.isNotBlank(env.Subject)){
                    env.Subject=env.Subject.replaceAll('/[^a-zA-Z0-9]/g', '');
                }
                env.Subject = String.escapeSingleQuotes(env.Subject);
                  system.debug('env.Subject@@@@@@@@@@163'+env.Subject);
                  if(env.Subject.contains('\'')){
                      system.debug('env.Subject@@@@@@@@@@'+env.Subject);
                    env.Subject=env.Subject.replaceAll('\'', '&#39');
                }
            }
            
            
            AttachmentList = [SELECT Id, Name, ParentId,ownerID FROM Attachment where ParentId IN : eventList];
            todaysEvent = [SELECT Id, Invitee_Timezone__c,Owner.name,Subject,Activity_Status__c, AccountId, StartDateTime, EndDateTime,OwnerId FROM Event where OwnerId=:LoginUserID AND Others__c IN('Pending','Approved','Rejected') And SalesOrg__c IN ('India','Swal') AND StartDateTime = TODAY AND StartDateTime!=null  limit 100];
            system.debug('TODAY  -- - -- -'+system.now());
         //   system.debug('Attachment List-- - -- -'+AttachmentList.size());
         //   system.debug('Event List-- - -- -'+todaysEvent.size());
         //   system.debug('MonthEvent List-- - -- -'+monthlyeventList.size());
            
            eventToInsert = new Event();
            EventSubject='abhi';
            StartDate='19/5/2017';
            StartTime='1:00 PM';
            EndDate='19/5/2017';
            EndTime='2:00 PM';
            ActivityCurrency='INR';
            Activity_Type='';
            Location='';
            Account='';
            noOfFarmer=0;
            expenses=0;
            //faId='';
            type='';
        }catch(Exception e){
            System.debug('Inside Exception call..........');
            system.debug(e.getLineNumber());
            System.debug('Exception e '+e.getLineNumber());
        }   
    }
    /*Method for Creating event from Calander*/
    public void CreateEvents(){
     
        System.debug('Inside CreateEvents()');
        eventToInsert = new Event();
        ID eveID;
        if(!String.isBlank(SelectedEventId)){
            eveID=Id.valueOf(SelectedEventId); 
            eventToInsert.id=eveID ;
            
        }
        
        try{
            system.debug('Account - '+Account);
            eventToInsert.Subject = Activity_Type;
            eventToInsert.custom_activity__c = true;
            eventToInsert.StartDateTime = Datetime.newInstance(integer.ValueOf(Start_Date.split('-')[0]),integer.ValueOf(Start_Date.split('-')[1]),integer.ValueOf(Start_Date.split('-')[2].split('T')[0]),integer.ValueOf(Start_Date.split('T')[1].split(':')[0]),integer.ValueOf(Start_Date.split('T')[1].split(':')[1]),0);
            eventToInsert.EndDateTime = Datetime.newInstance(integer.ValueOf(End_Date.split('-')[0]),integer.ValueOf(End_Date.split('-')[1]),integer.ValueOf(End_Date.split('-')[2].split('T')[0]),integer.ValueOf(End_Date.split('T')[1].split(':')[0]),integer.ValueOf(End_Date.split('T')[1].split(':')[1]),0);
            system.debug('---StartDateTime'+eventToInsert.StartDateTime);
            system.debug('---EndDateTime'+eventToInsert.EndDateTime);
            eventToInsert.CurrencyIsoCode ='INR';
            eventToInsert.OwnerId = LoginUserID ;
            eventToInsert.Activity_Type__c=Activity_Type;
            eventToInsert.Expenses__c=expenses;
            eventToInsert.Meeting_Purpose__c = Meeting_Purpose.replaceAll('/[^a-zA-Z0-9]/g', '');//;
            eventToInsert.Location__c =Location; 
            eventToInsert.Meeting_Notes__c = Meeting_Notes.replace('\n',', ');
           // eventToInsert.Meeting_Notes__c = eventToInsert.Meeting_Notes__c.replaceAll('\\W+','');
            eventToInsert.Activity_Status__c=status;
            eventToInsert.Invitee_Timezone__c = inviteeTimeZone;  
            eventToInsert.Created_From__c = 'India Activity'; //CHGTASK0240834  
            upsert eventToInsert;
            SelectedEventId =eventToInsert.id; 
           
        }catch(Exception e){
            System.debug('---'+e);
        } 
    }
    public void deleteAttachment(){
        System.debug('Inside deleteAttachment()');
        Attachment atTodlete = new Attachment();
        atTodlete.id =  attachmentToDelete;
        try{
            delete atTodlete;
        }catch(Exception e){
            system.debug(e);
        }  
        
    }
    public  void setEventid(){  
        
        String data=apexPages.currentPage().getParameters().get('evid');
        System.debug('setEventid@@@@'+data);
        evid=data;
        System.debug('setEventid@@@@'+evid);
    }
    public  void ActivityOnDoubleTap(){
       
        String datevar=apexPages.currentPage().getParameters().get('CurrentDateActivity');
        System.debug('datevar'+datevar);
         IF(Test.isRunningTest())
         {
            datevar = String.valueof(System.today()); 
         }
        datevar=datevar.remove('"');
        Date sampleDate = Date.valueOf(datevar);
        Date t1 = date.newinstance(sampleDate.year(), sampleDate.month(), sampleDate.day());
        System.debug('dssdsds'+t1);
        date t2=t1.addDays(1);
         list<id> inlineuserid= new   list<id>();
              list<id> OwnerandInline= new   list<id>();
            LoginUserID = UserInfo.getUserId();
            System.debug('LoginUserID:---'+LoginUserID);
            list<user> inlineusers =[Select id,name from user where managerid=:LoginUserID];
            if(inlineusers!=null && !inlineusers.isEmpty()){
                for(user u:inlineusers){
                    inlineuserid.add(u.id);
                    OwnerandInline.add(u.id);
                }
                
            }
            OwnerandInline.add(LoginUserID);

        EventListOnDoubleTap= [SELECT Id,IsAllDayEvent,Owner.name,  Invitee_Timezone__c,Food__c,Night_Stay__c,Other_Expenses__c,Meeting_Purpose__c
                               ,Location__c,Meeting_Notes__c,No_of_KMs_Travelled__c,Account.name,Subject,Activity_Status__c, AccountId, StartDateTime, 
                               EndDateTime,OwnerId FROM Event where SalesOrg__c IN ('India','Swal') and Others__c IN('Pending','Approved','Rejected') and Created_From__c='India Activity' and  OwnerId IN:OwnerandInline  AND  StartDateTime <:t2 and EndDateTime>=:t1 ];
        
        System.debug('list after double'+EventListOnDoubleTap);
        
    }
    public void RefreshMonthdata(){
          String dateva =apexPages.currentPage().getParameters().get('MonthNumber');
         String yrvalue =apexPages.currentPage().getParameters().get('yearValue');
          IF(Test.isRunningTest())
         {
            yrvalue = '55'; 
         }
        String completeyr = '20'+yrvalue;
        Integer YearinInt = Integer.valueOf(completeyr);
        system.debug('@@@@@yrvalue+'+yrvalue+'@@@@@@@@@completeyr'+completeyr);
         IF(Test.isRunningTest())
         {
            dateva = '55'; 
         }
        Integer mNumber = Integer.valueOf(dateva);
     //   System.debug('datevar@@@@@@@271@@@@@'+dateva+'@@@@mNumber'+mNumber);
          list<id> inlineuserid= new   list<id>();
            LoginUserID = UserInfo.getUserId();
            System.debug('LoginUserID:---'+LoginUserID);
            list<user> inlineusers =[Select id,name from user where managerid=:LoginUserID];
            if(inlineusers!=null && !inlineusers.isEmpty()){
                for(user u:inlineusers){
                    inlineuserid.add(u.id);
                }
                
            }
Date todaysdate = Date.today();

Date t1 = Date.newInstance(YearinInt, mNumber, 1);
integer noOfDays = Date.daysInMonth(YearinInt, mNumber);

Date t2 = Date.newInstance( YearinInt, mNumber, noOfDays);
system.debug('@@@@@'+t1+'&&&&&'+t2);
         monthlyeventList=[SELECT Id, Others__c,Meeting_Notes__c,Invitee_Timezone__c,Owner.name,Subject,Activity_Status__c, AccountId, StartDateTime, EndDateTime,OwnerId FROM Event where OwnerId=:LoginUserID and Created_From__c='India Activity' AND Others__c IN('Pending','Approved','Rejected') And SalesOrg__c IN ('India','Swal')  AND ((StartDateTime>=:t1 and StartDateTime<:t2) Or (EndDateTime>=:t1 and EndDateTime<:t2))  limit 100];
            if(inlineuserid!=null && !inlineuserid.isEmpty()){
                
                inlineUserEventList=[SELECT Id, Others__c,Meeting_Notes__c,Invitee_Timezone__c,Owner.name,Subject,Activity_Status__c, AccountId, StartDateTime, EndDateTime,OwnerId FROM Event where OwnerId in:inlineuserid and Created_From__c='India Activity' AND Others__c IN('Pending','Approved','Rejected') And SalesOrg__c IN ('India','Swal')  AND ((StartDateTime>=:t1 and StartDateTime<:t2) Or (EndDateTime>=:t1 and EndDateTime<:t2))  limit 100];
                
            }
            system.debug('@@@@@monthlyeventList290@@@@'+monthlyeventList);
            system.debug('@@@@@inlineUserEventList291@@@@'+inlineuserid+'$$$$$$$$$$$$$$$$$$$$$'+inlineUserEventList);

        
    }
    
    public class FarmerACtivityWrap{
        public String ActivityName;
        public String CropName;
        public String ProductName;
        public String VillageName;
        public FarmerACtivityWrap(){
            ActivityName = '';
            CropName= '';
            ProductName= '';
            VillageName= '';
        }
    }
    
}