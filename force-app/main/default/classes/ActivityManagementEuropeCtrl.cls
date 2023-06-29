public with sharing class ActivityManagementEuropeCtrl{

    public String ActivityTpOnUpdate { get; set; }
    
    
    
 public  List<Event> eventList{get;set;}
 private  List<Account> AccountList;//{get;set;}
 public List<List<Account>> nestedListAccount{get;set;}
 private Id LoginUserID;
 public Event eventToInsert{get;set;}
 /*Event Fileds*/
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
 public String status{get;set;}
 public List<Attachment>AttachmentList{get;set;}
 public List<event>todaysEvent{get;set;}
 public String attachmentToDelete{get;set;}
 public String userTimeZone{get;set;}
 public String inviteeTimeZone{get;set;}
 public User currentUser{get;set;}
 public string accountSearchKey{get;set;}
 public String currentDateTimeStart {get;set;}
 public String currentDateTimeEnd {get;set;}
 public String parentStr {get;set;}
 public String ActivityCurrency{get;set;}   
  /*End of Event Fields*/ 
   
   /*Load initial data of event and account*/
    public ActivityManagementEuropeCtrl(){
     System.debug('Inside Constructor');
       try{
       
           parentStr ='';
           accountSearchKey='';
                      
           System.debug(DateTime.now().format('yyyy-MM-dd\'T\'hh:mm'));
           currentDateTimeStart  = DateTime.now().format('yyyy-MM-dd\'T\'hh:mm');
           System.debug('End time'+DateTime.now().addHours(1).format('yyyy-MM-dd\'T\'hh:mm'));
           status = 'Planned';
           inviteeTimeZone  = '';
           
           Account_Type='Distributor';
           
           LoginUserID = UserInfo.getUserId();
           currentUser = [select id, Country from user where id =: UserInfo.getUserId() ];
           TimeZone tz = UserInfo.getTimeZone();
           System.debug('Display name: ' +tz.getDisplayName());
           System.debug('ID: ' + tz.getID());
           System.debug('currentUser : ' + currentUser);
           userTimeZone =tz.getID(); 
           
           attachmentToDelete = '';
           eventList = new List<Event>();
           AttachmentList = new List<Attachment>();  
           AccountList = new List<Account>();
               eventList = [SELECT Id, Invitee_Timezone__c,Food__c,Night_Stay__c,Other_Expenses__c,Meeting_Purpose__c,Location__c,Meeting_Notes__c,No_of_KMs_Travelled__c,Account.name,Subject,Activity_Status__c, AccountId, StartDateTime, EndDateTime,OwnerId FROM Event where OwnerId=:LoginUserID AND StartDateTime!=null AND custom_activity__c =true];
               //distributor
               AccountList =[SELECT Id,Name,RecordType.Name,Phone FROM Account where  RecordType.Name='Distributor' AND IsPersonAccount=false  AND (NOT Name LIKE '%don\'t use%') order by Name limit 200]; // Added don't use condition INC0418919 GRZ(Nikhil Verma) 06-12-2022
          //Farmer   
           //AccountList =[SELECT Id,Name, Customer_Type__c,RecordType.Name,Phone, ShippingCity FROM Account where  RecordType.Name='Farmer' AND IsPersonAccount=true];
          for(Integer j=0;j<eventList.size();j++){
              eventList[j].Account.name =eventList[j].Account.name.replace('\'', '');
              eventList[j].Account.name =eventList[j].Account.name.replace('"', '');
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
               todaysEvent = [SELECT Id, Invitee_Timezone__c,Account.name,Subject,Activity_Status__c, AccountId, StartDateTime, EndDateTime,OwnerId FROM Event where OwnerId=:LoginUserID AND StartDateTime = TODAY AND StartDateTime!=null AND custom_activity__c =true limit 100];
               
               for(Integer k=0;k<todaysEvent.size();k++){
                  todaysEvent[k].Account.name =todaysEvent[k].Account.name.replace('\'', '');
                  todaysEvent[k].Account.name =todaysEvent[k].Account.name.replace('"', '');
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
           //SelectedEventId='';
          
         }catch(Exception e){
             system.debug(e);
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
         eventToInsert.WhatID= Account;
         eventToInsert.Account__c=Account;//lookup
         eventToInsert.StartDateTime = Datetime.newInstance(integer.ValueOf(Start_Date.split('-')[0]),integer.ValueOf(Start_Date.split('-')[1]),integer.ValueOf(Start_Date.split('-')[2].split('T')[0]),integer.ValueOf(Start_Date.split('T')[1].split(':')[0]),integer.ValueOf(Start_Date.split('T')[1].split(':')[1]),0);
         eventToInsert.EndDateTime = Datetime.newInstance(integer.ValueOf(End_Date.split('-')[0]),integer.ValueOf(End_Date.split('-')[1]),integer.ValueOf(End_Date.split('-')[2].split('T')[0]),integer.ValueOf(End_Date.split('T')[1].split(':')[0]),integer.ValueOf(End_Date.split('T')[1].split(':')[1]),0);
         eventToInsert.CurrencyIsoCode ='EUR';
         eventToInsert.OwnerId = LoginUserID ;
         eventToInsert.Meeting_Purpose__c = Meeting_Purpose.replaceAll('/[^a-zA-Z0-9]/g', '');
         eventToInsert.Location__c =Location; 
         eventToInsert.Meeting_Notes__c = Meeting_Notes.replace('\n',', ');
         eventToInsert.Meeting_Notes__c = eventToInsert.Meeting_Notes__c.replaceAll('/[^a-zA-Z0-9]/g', '');
         //eventToInsert.Meeting_Notes__c = eventToInsert.Meeting_Notes__c.replaceAll('\\W+','');
         eventToInsert.Activity_Status__c=status;
         eventToInsert.Invitee_Timezone__c = inviteeTimeZone;
         eventToInsert.Created_From__c = 'SFDC'; //CHGTASK0240834
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
          
                  AccountList =[SELECT Id,Name, Customer_Type__c,RecordType.Name,Phone, ShippingCity FROM Account where  RecordType.Name='Distributor' AND IsPersonAccount=false  AND (NOT Name LIKE '%don\'t use%') AND Name LIKE :likeKey];// Added don't use condition INC0418919 GRZ(Nikhil Verma) 06-12-2022
       
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