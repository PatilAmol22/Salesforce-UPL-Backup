public with sharing class ActivityManagementPolandCtrl {
 
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
 public List<Attachment> AttachmentList{get;set;}
 public List<event> todaysEvent{get;set;}
 public String attachmentToDelete{get;set;}
 public String userTimeZone{get;set;}
 public String inviteeTimeZone{get;set;}
 public User currentUser{get;set;}
 public string accountSearchKey{get;set;}
 public String currentDateTimeStart {get;set;}
 public String currentDateTimeEnd {get;set;}
 public String parentStr {get;set;}
 public String ActivityCurrency{get;set;}
 public String Sales_Org_Code; 
 public String visit_reponse{get;set;}
 public String priority{get;set;}
 public String past7Days{get;set;}
 public String Partner_Name {get;set;}

 public String account_Id {get;set;}              /* ---------- for Redirect -----------*/
 public Account accountObj {get;set;}          /* ---------- for Redirect -----------*/
 
  /*End of Event Fields*/ 
   
   /*Load initial data of event and account*/
    public ActivityManagementPolandCtrl(){
     System.debug('Inside Constructor');
       try{
       
           parentStr ='';
           accountSearchKey='';
           visit_reponse = '';    
           priority = '';       
           
           currentDateTimeStart  = DateTime.now().format('yyyy-MM-dd\'T\'hh:mm');
          // System.debug('End time'+DateTime.now().addHours(1).format('yyyy-MM-dd\'T\'hh:mm'));
           status = 'Planned';
           inviteeTimeZone  = '';
           Date tday = (Date.today() - 7);
           //System.debug('past7Days :- ' + String.valueOf(tday)+'T00:00');
           past7Days = String.valueOf(tday)+'T00:00';
           Account_Type='';
           Partner_Name = '';
           LoginUserID = UserInfo.getUserId();
           currentUser = [select id, Country from user where id =: UserInfo.getUserId() ];
           Sales_Org_Code='2941';
           /* if(currentUser.Country.equalsignorecase('Spain')){
               Sales_Org_Code='2941';
           }
           else{
               Sales_Org_Code='2520';
           } */
           
           System.debug('Country name: ' +currentUser.Country);
           System.debug('Sales_Org_Code: ' +Sales_Org_Code);
           
           TimeZone tz = UserInfo.getTimeZone();
           System.debug('Display name: ' +tz.getDisplayName());
           System.debug('ID: ' + tz.getID());
           System.debug('currentUser : ' + currentUser);
           userTimeZone =tz.getID(); 
           
           attachmentToDelete = '';
           eventList = new List<Event>();
           AttachmentList = new List<Attachment>();  
           AccountList = new List<Account>();
               eventList = [SELECT Id, Invitee_Timezone__c,Meeting_Purpose__c,Location__c,Meeting_Notes__c,Account__c,
                            Account.name,Subject,Activity_Status__c,AccountId, StartDateTime, EndDateTime,OwnerId, WhatId,
                            Account.RecordType.Name, Priority__c, Visit_Response__c, Partner_Name__c, Account_Type__c, custom_activity__c 
                            FROM Event where OwnerId=:LoginUserID AND StartDateTime!=null AND 
                            custom_activity__c =true ];
             System.debug('Event List: ' +eventList.size());  
             
             for(Integer j=0;j<eventList.size();j++){
             
              if(String.isNotBlank(eventList[j].AccountId)){
                  eventList[j].Account.name =eventList[j].Account.name.replace('\'', '');
                  eventList[j].Account.name =eventList[j].Account.name.replace('"', '');
              }
                            
             }
             Integer count = 0,index=0;
               //distributor
               AccountList =[SELECT Id,Name,RecordType.Name,Phone FROM Account where  
                            RecordType.Name = 'Distributor' AND 
                            IsPersonAccount=false  AND Sales_Org_Code__c=:Sales_Org_Code 
                            order by Name ];
                System.debug('Account List: ' +AccountList.size());
           
            
          for(Integer i=0;i<AccountList.size();i++){
               AccountList[i].Name = AccountList[i].Name.replace('"', '');
           }
            
          nestedListAccount = new List<List<Account>>();
          
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
           system.debug(parentStr.length());                   
              
            AttachmentList = [SELECT Id, Name, ParentId,ownerID FROM Attachment where ParentId IN : eventList];
            system.debug('AttachmentList---> '+AttachmentList.size());
            todaysEvent = [SELECT Id, Invitee_Timezone__c,Meeting_Purpose__c,Location__c,Meeting_Notes__c,Account__c,
                            Account.name,Subject,Activity_Status__c,AccountId, StartDateTime, EndDateTime,OwnerId, WhatId,
                            Account.RecordType.Name, Priority__c, Visit_Response__c, Partner_Name__c, Account_Type__c, custom_activity__c
                            FROM Event where OwnerId=:LoginUserID AND StartDateTime = TODAY AND StartDateTime!=null
                            AND custom_activity__c =true limit 100];
                             
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
           //Sales_Org_Code='2000';
           //SelectedEventId='';
          
         }catch(Exception e){
             system.debug(e.getStackTraceString());
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
           eventToInsert.Partner_Name__c= Partner_Name.replaceAll('/[^a-zA-Z0-9]/g', '').replace('\'', '');
           eventToInsert.WhatID= null;
           eventToInsert.Account__c= null;
         }
         else{
             eventToInsert.WhatID = Account;
             eventToInsert.Account__c = Account;
             eventToInsert.Partner_Name__c = '';
         }
         eventToInsert.Priority__c = priority;       
         
         eventToInsert.StartDateTime = Datetime.newInstance(integer.ValueOf(Start_Date.split('-')[0]),integer.ValueOf(Start_Date.split('-')[1]),integer.ValueOf(Start_Date.split('-')[2].split('T')[0]),integer.ValueOf(Start_Date.split('T')[1].split(':')[0]),integer.ValueOf(Start_Date.split('T')[1].split(':')[1]),0);
         eventToInsert.EndDateTime = Datetime.newInstance(integer.ValueOf(End_Date.split('-')[0]),integer.ValueOf(End_Date.split('-')[1]),integer.ValueOf(End_Date.split('-')[2].split('T')[0]),integer.ValueOf(End_Date.split('T')[1].split(':')[0]),integer.ValueOf(End_Date.split('T')[1].split(':')[1]),0);
         eventToInsert.CurrencyIsoCode ='PLN';
         eventToInsert.OwnerId = LoginUserID ;
         eventToInsert.Meeting_Purpose__c = Meeting_Purpose.replaceAll('/[^a-zA-Z0-9]/g', '').replace('\'', '');//
         eventToInsert.Location__c =Location; 
         eventToInsert.Meeting_Notes__c = Meeting_Notes.replace('\n',', ');
         eventToInsert.Meeting_Notes__c = eventToInsert.Meeting_Notes__c.replaceAll('/[^a-zA-Z0-9]/g', '').replace('\'', '');

         //eventToInsert.Meeting_Notes__c = eventToInsert.Meeting_Notes__c.replaceAll('\\W+','');
         eventToInsert.Activity_Status__c=status;
         eventToInsert.Invitee_Timezone__c = inviteeTimeZone;
         //eventToInsert.Sales_Org_Code_For_Spain__c=Sales_Org_Code_For_Spain;
         eventToInsert.Visit_Response__c = visit_reponse; // new..
         eventToInsert.Account_Type__c = Account_Type;
         eventToInsert.Created_From__c = 'SFDC'; //SCTASK0415469
         upsert eventToInsert;
         SelectedEventId =eventToInsert.id; 
         system.debug('SelectedEventId -- '+SelectedEventId);

         if(Account.trim().length() > 0  && visit_reponse.trim().length() > 0 ){
            Account acc = new Account();
            acc.Id = Account;
            acc.Visit_Response__c = visit_reponse;
            update acc;
         }
         
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

      public void getAccountByRecordType(){
          if(Account_Type != '' || Account_Type != null){
            AccountList = new List<Account>();
            Integer count = 0,index=0;
               //distributor
               AccountList =[SELECT Id,Name,RecordType.Name,Phone FROM Account 
                            where RecordType.Name=:Account_Type AND IsPersonAccount=false  
                            AND Sales_Org_Code__c=:Sales_Org_Code order by Name ];
                System.debug('Account List: ' +AccountList.size());
           
            
          for(Integer i=0;i<AccountList.size();i++){
               AccountList[i].Name = AccountList[i].Name.replace('"', '');
           }
            
          nestedListAccount = new List<List<Account>>();
          
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
           system.debug(parentStr.length());
          }
      }

      /* public void setVisitResponse(){
          this.visit_reponse = visit_reponse;
      } */


      public void searchAccount(){
           system.debug('accountSearchKey ---- '+accountSearchKey);
           String likeKey = accountSearchKey+'%';
           system.debug('Account_Type- '+Account_Type);
          
           if(Account_Type != '' || Account_Type != null){
                  AccountList =[SELECT Id,Name, Customer_Type__c,RecordType.Name,Phone, ShippingCity 
                  FROM Account where  RecordType.Name=:Account_Type AND IsPersonAccount=false AND 
                  Sales_Org_Code__c=:Sales_Org_Code AND Name LIKE :likeKey];
           
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
        }
           System.debug('nestedListAccount');
          
              System.debug(nestedListAccount.size());
      }
           
      
}