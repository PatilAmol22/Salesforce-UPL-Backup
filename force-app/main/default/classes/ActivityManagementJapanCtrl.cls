public with sharing class ActivityManagementJapanCtrl {
   
    public String ActivityTpOnUpdate { get; set; }
    public  List<Event> eventList{get;set;}
   @testVisible private  List<Account> AccountList;//{get;set;}
    public List<List<Account>> nestedListAccount{get;set;}
    private Id LoginUserID;
    public Event eventToInsert{get;set;}
    /*Event Fileds*/
    //public String Meeting_Purpose{get;set;}
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
    public String status{get;set;}
    public List <Attachment> AttachmentList{get;set;}
    public List <event> todaysEvent{get;set;}
    public String attachmentToDelete{get;set;}
    public String userTimeZone{get;set;}
    public String inviteeTimeZone{get;set;}
    public User currentUser{get;set;}
    public string accountSearchKey{get;set;}
    public String currentDateTimeStart {get;set;}
    public String currentDateTimeEnd {get;set;}
    public String parentStr {get;set;}
    public String ActivityCurrency {get;set;}  
    public String Partner_Name {get;set;}
    
   
    /* New Fields for japan */
    public List<String> Sales_Org_Code {get;set;}
    public List<String> Sales_Org_Id {get;set;}
    public List<Region__c> areaList{get;set;}
    /* public Map<String,String> materialList{get;set;} */
    public String Reported_Applied {get;set;}
    public String Sales_Office {get;set;}
    public String Reported_By {get;set;}
    public String Area {get;set;}
    public String Time_Repeated {get;set;}
    public String Customer_Office {get;set;}
    public String JA_Area {get;set;}
    public String Interviewee {get;set;}
    public String Material_Targeted {get;set;}
    public String Crop_Targeted {get;set;}
    public String Activity_Details {get;set;}
    public String Material_Categorie {get;set;}
    public String Next_Action {get;set;}
    public String Issues_Wishes {get;set;}
    public String Wishes_Delivered {get;set;}
    public String Others {get;set;}
    public Decimal Attendee {get;set;}
    public Decimal Duration {get;set;}
    //public Map<String,String> cropList {get;set;}
   // public String Visit_Purpose {get;set;}
    public String Sales_Office_Name {get;set;}
    //public Map<String,String> visitPurposeList {get;set;}
    public Map<String,String> activityDetailsList {get;set;}
    
    /* End */
   
    public String account_Id {get;set;}              /* ---------- for Redirect -----------*/
    public Account accountObj {get;set;}          /* ---------- for Redirect -----------*/
   
     /*End of Event Fields*/ 
      
      /*Load initial data of event and account*/
       public ActivityManagementJapanCtrl(){
        System.debug('Inside Constructor');
          try{
          
              parentStr ='';
              accountSearchKey='';
                         
              System.debug(DateTime.now().format('yyyy-MM-dd\'T\'hh:mm'));
              currentDateTimeStart  = DateTime.now().format('yyyy-MM-dd\'T\'hh:mm');
              System.debug('End time'+DateTime.now().addHours(1).format('yyyy-MM-dd\'T\'hh:mm'));
              status = 'Planned';
              inviteeTimeZone  = '';
              
              //Account_Type='Distributor';
              
              LoginUserID = UserInfo.getUserId();
              currentUser = [select id, Name, Country from user where id =: UserInfo.getUserId() ];
              Sales_Org_Code = new List<String>();
              Sales_Org_Code.add('6731');
              //Sales_Org_Code.add('6781');
   
              List<Sales_Org__c> salesOrg = [SELECT Id, Name, Sales_Org_Code__c FROM Sales_Org__c 
                                            where Sales_Org_Code__c IN : Sales_Org_Code];
   
               /* List<Sales_Org__c> salesOrg = [SELECT Id, Name, Sales_Org_Code__c FROM Sales_Org__c 
               where Sales_Org_Code__c IN : Sales_Org_Code AND 
               Name =:currentUser.Country ];  */ 
               Sales_Org_Id = new List<String>();
               if(salesOrg.size()>0){
                   for(Sales_Org__c so : salesOrg){
                       Sales_Org_Id.add(so.Id);
                   }
               }
   
               if(Sales_Org_Id.size()>0){
   
                   areaList = new List<Region__c>();
                   areaList = [SELECT Id, Name, Zone__c, SalesOrg__c, Sequence__c  FROM Region__c
                               Where  SalesOrg__c IN: Sales_Org_Id order by Sequence__c limit 999];                   
   
                  /*  materialList = new List<SKU__c>();   
                   materialList = [SELECT Id, Name, SKU_Description__c, Sales_Org_Code__c, Sales_Org__c, Active__c, 
                                   For_Japan_Activity__c FROM SKU__c 
                                   WHERE Sales_Org__c IN: Sales_Org_Id AND For_Japan_Activity__c = true];    */            
               }
   
               /* Schema.DescribeFieldResult fieldResult = Event.Crop_Targeted__c.getDescribe();
               List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
       
               cropList = new Map<String,String>();
               for(Schema.PicklistEntry f : ple){
                   cropList.put(f.getLabel(),f.getValue());
               }  */
   
               /* Schema.DescribeFieldResult fieldResult2 = Event.Visit_Purpose__c.getDescribe();
               List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
   
               visitPurposeList = new Map<String,String>();
               for(Schema.PicklistEntry f2 : ple2){
                   visitPurposeList.put(f2.getLabel(),f2.getValue());
               }  */
               /* Schema.DescribeFieldResult fieldResult4 = Event.Material_Targeted__c.getDescribe();
               List<Schema.PicklistEntry> ple4 = fieldResult4.getPicklistValues();
   
               materialList = new Map<String,String>();
               for(Schema.PicklistEntry f4 : ple4){
                   materialList.put(f4.getLabel(),f4.getValue());
               } */
   
               Schema.DescribeFieldResult fieldResult3 = Event.Activity_Details__c.getDescribe();
               List<Schema.PicklistEntry> ple3 = fieldResult3.getPicklistValues();
   
               activityDetailsList = new Map<String,String>();
               for(Schema.PicklistEntry f3 : ple3){
                   activityDetailsList.put(f3.getLabel(),f3.getValue());
               }    
   
              TimeZone tz = UserInfo.getTimeZone();
              System.debug('Display name: ' +tz.getDisplayName());
              System.debug('ID: ' + tz.getID());
              System.debug('currentUser : ' + currentUser);
              userTimeZone =tz.getID(); 
              
              attachmentToDelete = '';
              eventList = new List<Event>();
              AttachmentList = new List<Attachment>();  
              AccountList = new List<Account>();
              //Added by Varun Shrivastava : ID Filter: SCTASK0456157 Added this Month filter
              List<Event> alist=new List<Event>();
             
              alist = [SELECT Id, Invitee_Timezone__c,Food__c,Night_Stay__c,Other_Expenses__c,
                               Meeting_Purpose__c,Location__c,Meeting_Notes__c,Account__c,Partner_Name__c, 
                               No_of_KMs_Travelled__c,Account.name,Subject,Activity_Status__c, AccountId, 
                               StartDateTime, EndDateTime,OwnerId, Reported_Applied__c, Sales_Office__c,Sales_Office__r.Name, 
                               Area__c, Time_If_Repeated__c, Customers_Office__c, Account_Type__c, WhatId,
                               JA_Area__c, Interviewee__c, Material_Targeted__c,  Duration__c, Crop_Targeted__c,
                               Activity_Details__c, Material_Categories__c, Next_Action__c, Issues_wishes__c,
                               Wishes_Delivered__c, Others__c, Number_of_Attendee__c, custom_activity__c FROM Event 
                               where OwnerId=:LoginUserID AND StartDateTime!=null order by ActivityDate desc LIMIT 49999];//RITM0228438: Added 'This Year' filter to resolve Collection Size limit 1000 error
                               //AND CreatedDate = THIS_YEAR , Removed from SOQL added limit of 50000 RITM0318044,Vivek
             
              system.debug('**Eventlist size - ' +alist.size());
              //for(integer i=0;i<=999;i++)
              for(integer i=0;i<alist.size();i++)
              {
                  if(i<999) {
                  eventlist.add(alist[i]);
                  }
              }
                  //distributor  Visit_Purpose__c,
                  /* AccountList =[SELECT Id,Name,Location_Name__c 
                               FROM Shipping_Location__c where  Sales_Org_Code__c = '6100'  
                               order by Name limit 200]; */
              // Below commented by Vivek for AccountList Ticket #SCTASK0605025 ,18-NOV-21
                //   AccountList =[SELECT Id,Name,RecordType.Name,Phone FROM Account LIMIT 100];// where  
                
              AccountList =[SELECT Id,Name,RecordType.Name,Phone FROM Account   where  RecordType.Name = 'Distributor' AND
                                 IsPersonAccount=false  AND Sales_Org_Code__c IN:Sales_Org_Code AND (NOT Name LIKE '%DO NOT USE%')
                                 order by Name LIMIT 100];// Added DO NOT USE condition INC0418919 GRZ(Nikhil Verma) 06-12-2022            
             //Farmer   
              //AccountList =[SELECT Id,Name, Customer_Type__c,RecordType.Name,Phone, ShippingCity FROM Account where  RecordType.Name='Farmer' AND IsPersonAccount=true];
             for(Integer j=0;j<eventList.size();j++){
                 if(String.isNotBlank(eventList[j].AccountId)){
                 eventList[j].Account.name =eventList[j].Account.name.replace('\'', '');
                 eventList[j].Account.name =eventList[j].Account.name.replace('"', '');
                 }
                 
             }
             
             for(Integer i=0;i<AccountList.size();i++){
                  AccountList[i].Name = AccountList[i].Name.replace('"', '');
              }
   
             nestedListAccount = new List<List<Account>>();
             Integer count = 0,index=0;
             System.debug('nestedListAccount');
             List<Account>asts = new List<Account>();
             if(AccountList.size()<999){
                 nestedListAccount.add(AccountList);
             }
             for(Account acc : AccountList){
                 count++;
               
                 if(count>=999){
                        System.debug('count - '+count);
                      nestedListAccount.add(asts);  
                      asts= new List<Account>();
                      index++;
                     count=0; 
                 }
                asts.add(acc);
                              
             }
              System.debug('nestedListAccount');
             
                 System.debug(nestedListAccount.size());
                
            parentStr = JSON.serialize(AccountList); 
                    system.debug(AccountList.size());
                    system.debug(parentStr.length());
                 
                  AttachmentList = [SELECT Id, Name, ParentId,ownerID FROM Attachment where ParentId IN : eventList];
                  todaysEvent = [SELECT Id, Invitee_Timezone__c,Account__c,Account.name,Subject, Duration__c,
                                Activity_Status__c, Partner_Name__c, AccountId, StartDateTime, EndDateTime, Sales_Office__r.Name,
                                OwnerId, Reported_Applied__c, Sales_Office__c, Area__c,Account_Type__c, WhatId,
                                Time_If_Repeated__c, Customers_Office__c, JA_Area__c, Interviewee__c, Material_Targeted__c,
                                Crop_Targeted__c, Activity_Details__c, Material_Categories__c, Next_Action__c, 
                                Issues_wishes__c, Wishes_Delivered__c, Others__c, Number_of_Attendee__c, custom_activity__c 
                                FROM Event where OwnerId=:LoginUserID AND StartDateTime = TODAY AND 
                                StartDateTime!=null limit 100];  //Visit_Purpose__c,
                  
                  for(Integer k=0;k<todaysEvent.size();k++){
                      if(String.isNotBlank(todaysEvent[k].AccountId)){
                          todaysEvent[k].Account.name =todaysEvent[k].Account.name.replace('\'', '');
                          todaysEvent[k].Account.name =todaysEvent[k].Account.name.replace('"', '');
                      }
                   }     
                        
              eventToInsert = new Event();
              EventSubject='Nikhil';
              StartDate='01/10/2018';
              StartTime='1:00 PM';
              EndDate='01/10/2018';
              EndTime='2:00 PM';
              ActivityCurrency='EUR';
              Activity_Type='';
              Location='';
              Account='';
              Partner_Name='';
              //SelectedEventId='';
   
               Reported_Applied = '';
               Sales_Office = '';
               Sales_Office_Name = '';
               Reported_By = currentUser.Name;
               Area = '';
               Time_Repeated = '';
               Customer_Office = '';
               JA_Area = '';
               Interviewee = '';
               Material_Targeted = '';
               Crop_Targeted = '';
               Activity_Details = '';
               Material_Categorie = '';
               Next_Action = '';
               Issues_Wishes = '';
               Wishes_Delivered = '';
               Others = '';
               Attendee = 0.0;
               Duration = 0.0;
             
            }catch(Exception ex){
                //system.debug(e+''+e.getLineNumber());
                system.debug('**ex No - '+ex.getLineNumber()+'  **ex Msg - '+ex.getMessage()); 
            }   
       }
   
       /* ---------- for Redirect -----------*/
       public void getAccountDetails(){   
           System.debug('Inside getAccountDetails');
           System.debug('account_Id ..--- '+ account_Id);              
           if(!String.isBlank(account_Id)){
             accountObj = new Account();
             accountObj = [Select Id, Name from Account where Id = :account_Id];
             account_Id = '';
           }
          // System.debug('Inside getAccountDetails');
          // System.debug('account_Id ..--- '+ account_Id);
         }
   
       public void getAreaFromSO(){
          if(Area != '' || Area != null){
           List<Region__c> reg = new List<Region__c>();
           reg = [SELECT Id, Name, Zone__c, Zone__r.Name,  SalesOrg__c FROM Region__c
                       Where id =: Area AND SalesOrg__c IN: Sales_Org_Id LIMIT 1];
           if(reg.size()>0){
               Sales_Office = reg[0].Zone__c;
               Sales_Office_Name = reg[0].Zone__r.Name;
           }            
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
             system.debug('Activity_Type- '+Activity_Type);
            eventToInsert.Subject = Activity_Type;
            eventToInsert.custom_activity__c = true;
            if(Account=='' || Account==null)
            {
            system.debug('Inside if- ');
              eventToInsert.Partner_Name__c= Partner_Name.replaceAll('/[^a-zA-Z0-9]/g', '');
              eventToInsert.WhatID = null;
            }
            else{
            system.debug('Inside else..- ');
                eventToInsert.WhatID = Account;
                eventToInsert.Partner_Name__c = '';
                //eventToInsert.Account__c=Account;//lookup
               // eventToInsert.Spain_Portugal_Campaign__c='';//lookup
            }
            
            eventToInsert.StartDateTime = Datetime.newInstance(integer.ValueOf(Start_Date.split('-')[0]),integer.ValueOf(Start_Date.split('-')[1]),integer.ValueOf(Start_Date.split('-')[2].split('T')[0]),integer.ValueOf(Start_Date.split('T')[1].split(':')[0]),integer.ValueOf(Start_Date.split('T')[1].split(':')[1]),0);
            eventToInsert.EndDateTime = Datetime.newInstance(integer.ValueOf(End_Date.split('-')[0]),integer.ValueOf(End_Date.split('-')[1]),integer.ValueOf(End_Date.split('-')[2].split('T')[0]),integer.ValueOf(End_Date.split('T')[1].split(':')[0]),integer.ValueOf(End_Date.split('T')[1].split(':')[1]),0);
            eventToInsert.CurrencyIsoCode ='EUR';
            eventToInsert.OwnerId = LoginUserID ;
           // eventToInsert.Meeting_Purpose__c = Meeting_Purpose.replaceAll('/[^a-zA-Z0-9]/g', '').replace('\'', '');
          //  eventToInsert.Visit_Purpose__c = Visit_Purpose;
            eventToInsert.Location__c =Location; 
            eventToInsert.Meeting_Notes__c = Meeting_Notes.replace('\n',', ');
            eventToInsert.Meeting_Notes__c = eventToInsert.Meeting_Notes__c.replaceAll('/[^a-zA-Z0-9]/g', '').replace('\'', '');
            //eventToInsert.Meeting_Notes__c = eventToInsert.Meeting_Notes__c.replaceAll('\\W+','');
            eventToInsert.Activity_Status__c=status;
            eventToInsert.Invitee_Timezone__c = inviteeTimeZone;
            eventToInsert.Created_From__c = 'SFDC';
   
            system.debug('Reported_Applied -- '+ Reported_Applied);
            system.debug('Sales_Office -- '+ Sales_Office);
            system.debug('Area -- '+ Area);
            system.debug('Time_Repeated -- '+ Time_Repeated);
            system.debug('Customer_Office -- '+ Customer_Office);
            system.debug('Material_Targeted_UJJWAL -- '+ Material_Targeted);
            system.debug('Crop_Targeted -- '+ Crop_Targeted);
            system.debug('Wishes_Delivered -- '+ Wishes_Delivered);
            system.debug('Material_Categorie -- '+ Material_Categorie);
   
               eventToInsert.Account_Type__c = Account_Type;
               eventToInsert.Reported_Applied__c = Reported_Applied;
               //eventToInsert.Sales_Office__c = Sales_Office;
               eventToInsert.Area__c = Area;
               //eventToInsert.Time_If_Repeated__c = Time_Repeated.replaceAll('/[^a-zA-Z0-9]/g', '').replace('\'', '');
               eventToInsert.Customers_Office__c = Customer_Office;
               if(JA_Area == null){
                   eventToInsert.JA_Area__c = '';
               }
               else{
                   eventToInsert.JA_Area__c = JA_Area.replaceAll('/[^a-zA-Z0-9]/g', '').replace('\'', '');
               }
               
               eventToInsert.Interviewee__c = Interviewee.replaceAll('/[^a-zA-Z0-9]/g', '').replace('\'', '');
               eventToInsert.Material_Targeted__c = Material_Targeted;
               if(Crop_Targeted == null){
                   eventToInsert.Crop_Targeted__c = '';
               }
               else{
                   eventToInsert.Crop_Targeted__c = Crop_Targeted.replaceAll('/[^a-zA-Z0-9]/g', '').replace('\'', '');
               }
               
               eventToInsert.Activity_Details__c = Activity_Details;
              // eventToInsert.Material_Categories__c = Material_Categorie;
               eventToInsert.Next_Action__c = Next_Action.replaceAll('/[^a-zA-Z0-9]/g', '').replace('\'', '');
               eventToInsert.Issues_wishes__c = Issues_Wishes.replaceAll('/[^a-zA-Z0-9]/g', '').replace('\'', ''); 
               eventToInsert.Wishes_Delivered__c = Wishes_Delivered;
               eventToInsert.Others__c = Others.replaceAll('/[^a-zA-Z0-9]/g', '').replace('\'', '');
              // eventToInsert.Number_of_Attendee__c = Attendee;
               eventToInsert.Duration__c = Duration;
   
            upsert eventToInsert;
            SelectedEventId =eventToInsert.id; 
            system.debug('SelectedEventId -- '+SelectedEventId);
            
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
         
         public void searchAccount(){
              system.debug('accountSearchKey ---- '+accountSearchKey);
              String likeKey = accountSearchKey+'%';
            system.debug('Account_Type- '+Account_Type);
             
               /* AccountList =[SELECT Id,Name, Location_Name__c FROM Shipping_Location__c where 
                               Sales_Org_Code__c = '6100' AND Location_Name__c LIKE :likeKey]; */
               AccountList =[SELECT Id,Name, Customer_Type__c,RecordType.Name,Phone, ShippingCity FROM Account 
                             where  RecordType.Name='Distributor' AND Sales_Org_Code__c IN:Sales_Org_Code
                             AND IsPersonAccount=false AND (NOT Name LIKE '%DO NOT USE%') AND Name LIKE :likeKey]; // Added DO NOT USE condition INC0418919 GRZ(Nikhil Verma) 06-12-2022  
                
          
             for(Integer i=0;i<AccountList.size();i++){
                  AccountList[i].Name = AccountList[i].Name.replace('"', '');
              }
             
             system.debug(AccountList);
              nestedListAccount = new List<List<Account>>();
             Integer count = 0,index=0;
             System.debug('nestedListAccount');
             List<Account>asts = new List<Account>();
             if(AccountList.size()<999){
                 nestedListAccount.add(AccountList);
             }
             for(Account acc : AccountList){
                 count++;
               
                 if(count>=999){
                        System.debug('count - '+count);
                      nestedListAccount.add(asts);  
                      asts= new List<Account>();
                      index++;
                     count=0; 
                 }
                asts.add(acc);
                
                 
             }
              System.debug('nestedListAccount');
             
                 System.debug(nestedListAccount.size());
         }
   }