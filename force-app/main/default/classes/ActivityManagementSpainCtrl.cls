public without sharing class ActivityManagementSpainCtrl{ // changed class from with to without w.r.t CR-RITM0366573

    public  List<Event> eventList{get;set;}
    private  List<Account> AccountList;//{get;set;}
    public List<List<Account>> nestedListAccount{get;set;}
    public List<Spain_Portugal_Campaign__c> campgnList;
    public List<List<Spain_Portugal_Campaign__c>> nestedCampgnList{get;set;}
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
    public String Campaign{get;set;} 
    public String SelectedSKU {get;set;} //added w.r.t CR-RITM0366573
    public String SKU {get;set;} //added w.r.t CR-RITM0366573
    public String Sales_Org_Code_For_Spain; 
    public String visit_reponse{get;set;}
    public List<Contact> ContactList;//{get;set;}
    public List<List<Contact>> nestedListContact{get;set;}
    public String Contact{get;set;}
   
    public String account_Id {get;set;}              /* ---------- for Redirect -----------*/
    public Account accountObj {get;set;}          /* ---------- for Redirect -----------*/
    
    //below added by Vaishnavi w.r.t CR-RITM0366573
    public List<PriceBookMaster__c> skuList {get;set;}


     /*End of Event Fields*/ 
      
      /*Load initial data of event and account*/
       public ActivityManagementSpainCtrl(){
        System.debug('Inside Constructor');
          try{
          
              parentStr ='';
              accountSearchKey='';
              visit_reponse = '';           
              System.debug(DateTime.now().format('yyyy-MM-dd\'T\'hh:mm'));
              currentDateTimeStart  = DateTime.now().format('yyyy-MM-dd\'T\'hh:mm');
              System.debug('End time'+DateTime.now().addHours(1).format('yyyy-MM-dd\'T\'hh:mm'));
              status = 'Planned';
              inviteeTimeZone  = '';
              
              Account_Type='';
                 
              LoginUserID = UserInfo.getUserId();
              currentUser = [select id, Country from user where id =: UserInfo.getUserId() ];
              
              if(currentUser.Country.equalsignorecase('Spain')){
                  Sales_Org_Code_For_Spain='2510';
              }
              else{
              // changes made by vishal UPL-CR131  changes from 2520 to 2481
                  Sales_Org_Code_For_Spain='2481';
              }
              getSkuDetails(); //added w.r.t CR-RITM0366573
              System.debug('Country name: ' +currentUser.Country);
              System.debug('Sales_Org_Code_For_Spain: ' +Sales_Org_Code_For_Spain);
              
              TimeZone tz = UserInfo.getTimeZone();
              System.debug('Display name: ' +tz.getDisplayName());
              System.debug('ID: ' + tz.getID());
              System.debug('currentUser : ' + currentUser);
              userTimeZone =tz.getID(); 
              
              attachmentToDelete = '';
              eventList = new List<Event>();
              AttachmentList = new List<Attachment>();  
              AccountList = new List<Account>();
              //below query updated w.r.t CR-RITM0366573
                  eventList = [SELECT Id, Invitee_Timezone__c,Meeting_Purpose__c,Location__c,Meeting_Notes__c,Account__c,
                               Account.name,Subject,Activity_Status__c,AccountId, StartDateTime, EndDateTime,OwnerId, WhatId,Price_Book_Master__c,Price_Book_Master__r.SKUCode__r.SKU_Description__c, 
                               Spain_Portugal_Campaign__c,Spain_Portugal_Campaign__r.Name,Account.RecordType.Name, Account_Type__c,
                               Visit_Response__c, WhoId, Who.Name FROM Event where OwnerId=:LoginUserID AND StartDateTime!=null AND 
                               (Sales_Org_Code_For_Spain__c=:Sales_Org_Code_For_Spain OR Sales_Org_Code_For_Spain__c='')];
                System.debug('Event List: ' +eventList.size());  
                
                for(Integer j=0;j<eventList.size();j++){
                
                 if(String.isNotBlank(eventList[j].AccountId)){
                  
                     eventList[j].Account.name =eventList[j].Account.name.replace('\'', '');
                     eventList[j].Account.name =eventList[j].Account.name.replace('"', '');
                 }
                
                 if(String.isNotBlank(eventList[j].Spain_Portugal_Campaign__c)){
                 
                     eventList[j].Spain_Portugal_Campaign__r.Name =eventList[j].Spain_Portugal_Campaign__r.Name.replace('\'', '');
                     eventList[j].Spain_Portugal_Campaign__r.Name =eventList[j].Spain_Portugal_Campaign__r.Name.replace('"', '');
                 }
                 
                 
                }
                Integer count = 0,index=0;
                  //distributor
                  AccountList =[SELECT Id,Name,RecordType.Name,Phone FROM Account where  
                               RecordType.Name = 'Distributor' AND 
                               IsPersonAccount=false  AND Sales_Org_Code__c=:Sales_Org_Code_For_Spain AND (NOT Name LIKE '%NO USAR%') 
                               ORDER BY Name ];// Added NO USAR condition INC0418903 GRZ(Nikhil Verma) 30-11-2022
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
              
              count=0; index=0;
              campgnList = new List<Spain_Portugal_Campaign__c>();
              campgnList =[SELECT Id, Name, Status__c FROM Spain_Portugal_Campaign__c WHERE 
                           Start_Date__c <= TODAY AND End_Date__c >= TODAY ORDER BY Name];
   
              if(campgnList.size() > 0){
                   for(Integer j=0;j<campgnList.size();j++){
                       campgnList[j].Name = campgnList[j].Name.replaceAll('"', '');
                   }
       
                   nestedCampgnList= new List<List<Spain_Portugal_Campaign__c>>();
                   
                   System.debug('nestedCampgnList');
                   List<Spain_Portugal_Campaign__c> cmpgn = new List<Spain_Portugal_Campaign__c>();
                   if(campgnList.size()<999){
                       nestedCampgnList.add(campgnList);
                   }
                   for(Spain_Portugal_Campaign__c cmp : campgnList){
                       count++;
                       
                       if(count>=999){
                               System.debug('count - '+count);
                               nestedCampgnList.add(cmpgn);  
                               cmpgn= new List<Spain_Portugal_Campaign__c>();
                               index++;
                           count=0; 
                       }
                       cmpgn.add(cmp);
                                       
                   }
                   System.debug('nestedCampgnList');
                   System.debug(nestedCampgnList.size());
              }
              
   
              count=0; index=0;
              ContactList = new List<Contact>();
              // changed below clause w.r.t CR-RITM0366573.
              //ContactList = [SELECT Id, Name, AccountId FROM Contact WHERE RecordType.Name = 'Farmer' ORDER BY Name];
              ContactList = [SELECT Id, Name,Account.Sales_Org_Country__c, AccountId FROM Contact WHERE RecordType.Name = 'Farmer' AND Account.Sales_Org_Country__c = 'Spain' ORDER BY Name];

              if(ContactList.size() > 0){
                   
                   nestedListContact = new List<List<Contact>>();
                   
                   System.debug('nestedListContact');
                   List<Contact> contct = new List<Contact>();
                   if(ContactList.size()<999){
                       nestedListContact.add(ContactList);
                   }
                   for(Contact cmp : ContactList){
                       count++;
                       
                       if(count>=999){
                               System.debug('count - '+count);
                               nestedListContact.add(contct);  
                               contct= new List<Contact>();
                               index++;
                           count=0; 
                       }
                       contct.add(cmp);
                                       
                   }
                   System.debug('nestedListContact');
                   System.debug(nestedListContact.size());
              }
              
             
                  AttachmentList = [SELECT Id, Name, ParentId,ownerID FROM Attachment where ParentId IN : eventList];
                  system.debug('AttachmentList---> '+AttachmentList.size());
              system.debug('LoginUserID---- ' + LoginUserID);
              system.debug('Sales_Org_Code_For_Spain---- ' + Sales_Org_Code_For_Spain);
                  todaysEvent = [SELECT Id, Invitee_Timezone__c,Account__c,Account.name,Subject,Activity_Status__c, WhatId,
                                AccountId, StartDateTime, EndDateTime, OwnerId,Spain_Portugal_Campaign__c, Account_Type__c,
                                Spain_Portugal_Campaign__r.Name,Account.RecordType.Name, Visit_Response__c, WhoId, Who.Name
                                FROM Event where OwnerId=:LoginUserID AND StartDateTime = TODAY AND StartDateTime!=null
                                AND (Sales_Org_Code_For_Spain__c=:Sales_Org_Code_For_Spain OR Sales_Org_Code_For_Spain__c='')
                                limit 100];
                                
              for(Integer k=0;k<todaysEvent.size();k++){
              
                if(String.isNotBlank(todaysEvent[k].AccountId)){
                     todaysEvent[k].Account.name =todaysEvent[k].Account.name.replace('\'', '');
                     todaysEvent[k].Account.name =todaysEvent[k].Account.name.replace('"', '');
                  }
                  else
                  {
                     todaysEvent[k].Spain_Portugal_Campaign__r.Name =todaysEvent[k].Spain_Portugal_Campaign__r.Name.replace('\'', '');
                     todaysEvent[k].Spain_Portugal_Campaign__r.Name =todaysEvent[k].Spain_Portugal_Campaign__r.Name.replace('"', ''); 
                  }   
                }          
                        system.debug('todaysEvent---- ' + todaysEvent);
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
              Campaign='';
              Contact ='';
              SKU=''; //added w.r.t CR-RITM0366573
              //Sales_Org_Code_For_Spain='2000';
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
   
            if(Activity_Type == null){
               
            }
            else{
               eventToInsert.Subject = Activity_Type;
            }
            
            eventToInsert.custom_activity__c = true;
            if(Account=='' || Account==null)
            {
               eventToInsert.WhoId = Contact;
               eventToInsert.WhatID= null;
               eventToInsert.Account__c= null;//lookup
            }
            else{
               eventToInsert.WhatID=Account;
               eventToInsert.Account__c=Account;//lookup
               //eventToInsert.WhoId = null; commented by Vaishnavi 
               eventToInsert.WhoId = Contact; // added w.r.t CR-RITM0366573

            }
            system.debug('Campaign - '+Campaign);
            system.debug('Campaign length- '+Campaign.length());
            if(Campaign.length()>0){
               eventToInsert.Spain_Portugal_Campaign__c = Campaign;
            }
            else{
               eventToInsert.Spain_Portugal_Campaign__c =null;
            }
            
            
               // eventToInsert.Spain_Portugal_Campaign__c='';//lookup
                     
            eventToInsert.StartDateTime = Datetime.newInstance(integer.ValueOf(Start_Date.split('-')[0]),integer.ValueOf(Start_Date.split('-')[1]),integer.ValueOf(Start_Date.split('-')[2].split('T')[0]),integer.ValueOf(Start_Date.split('T')[1].split(':')[0]),integer.ValueOf(Start_Date.split('T')[1].split(':')[1]),0);
            eventToInsert.EndDateTime = Datetime.newInstance(integer.ValueOf(End_Date.split('-')[0]),integer.ValueOf(End_Date.split('-')[1]),integer.ValueOf(End_Date.split('-')[2].split('T')[0]),integer.ValueOf(End_Date.split('T')[1].split(':')[0]),integer.ValueOf(End_Date.split('T')[1].split(':')[1]),0);
            eventToInsert.CurrencyIsoCode ='EUR';
            eventToInsert.OwnerId = LoginUserID ;
            eventToInsert.Meeting_Purpose__c = Meeting_Purpose.replaceAll('/[^a-zA-Z0-9]/g', '').replace('\'', '');//
            eventToInsert.Location__c =Location; 
            eventToInsert.Meeting_Notes__c = Meeting_Notes.replace('\n',', ');
            eventToInsert.Meeting_Notes__c = eventToInsert.Meeting_Notes__c.replaceAll('/[^a-zA-Z0-9]/g', '').replace('\'', '');
   
            //eventToInsert.Meeting_Notes__c = eventToInsert.Meeting_Notes__c.replaceAll('\\W+','');
            eventToInsert.Activity_Status__c=status;
            eventToInsert.Invitee_Timezone__c = inviteeTimeZone;
            eventToInsert.Sales_Org_Code_For_Spain__c=Sales_Org_Code_For_Spain;
            eventToInsert.Visit_Response__c = visit_reponse; // new..
            eventToInsert.Account_Type__c = Account_Type;
            eventToInsert.Created_From__c = 'SFDC'; //Added for SCTASK0415469  
            eventToInsert.Price_Book_Master__c = SelectedSKU; // added w.r.t CR-RITM0366573
            eventToInsert.Others__c = SKU; // added w.r.t CR-RITM0366573
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
                System.debug('Exception '+ e);
                System.debug('Exception Line - '+ e.getLineNumber());
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
                  AccountList =[SELECT Id,Name,RecordType.Name,Phone FROM Account where  
                               RecordType.Name=:Account_Type AND IsPersonAccount=false  AND 
                               Sales_Org_Code__c=:Sales_Org_Code_For_Spain AND (NOT Name LIKE '%NO USAR%') ORDER BY Name ]; // Added NO USAR condition INC0418903 GRZ(Nikhil Verma) 30-11-2022
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
                     AccountList =[SELECT Id,Name, Customer_Type__c,RecordType.Name,Phone, ShippingCity FROM Account where  RecordType.Name=:Account_Type AND IsPersonAccount=false AND (NOT Name LIKE '%NO USAR%') AND Name LIKE :likeKey]; // Added NO USAR condition INC0418903 GRZ(Nikhil Verma) 30-11-2022
              
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
         
         
         // below method added w.r.t CR-RITM0366573
         public void getSkuDetails(){
            skuList = new List < PriceBookMaster__c > ();
            String ObjectName = 'PriceBookMaster__c';
            String salesOrgCode ='';
            // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 
            
            String sQuery = 'select id, Name,Sales_Org_Code__c, SKUCode__c, SKUCode__r.Name, SKUCode__r.SKU_Description__c, SKUCode__r.SKU_Code__c, SKUCode__r.Mininum_Quantity__c, UOM__c, SKUCode__r.Multiple_of__c, Price__c, DepotCode__c, DistributionChannel__c, Division__c, Sales_Org__c,Country_Tax__c  from PriceBookMaster__c where Sales_Org_Code__c =\''+Sales_Org_Code_For_Spain+'\''+' AND Price__c != null AND StartDate__c <= TODAY AND EndDate__c >= TODAY  ';
           
            List < PriceBookMaster__c > lstOfRecords = Database.query(sQuery);
            
            
            
            for (PriceBookMaster__c obj: lstOfRecords) {
                if(ObjectName == 'PriceBookMaster__c'){
                    PriceBookMaster__c objNm = (PriceBookMaster__c) obj;
                    
                    // changes made by vishal UPL-CR131  changes from 2520 to 2481
                    if(objNm.Sales_Org_Code__c == '2510' || objNm.Sales_Org_Code__c == '2481' || objNm.Sales_Org_Code__c == '2541'){
                        objNm.SKUCode__r.SKU_Description__c = objNm.SKUCode__r.SKU_Description__c;
                    }else{
                        
                        //objNm.SKUCode__r.SKU_Description__c = objNm.SKUCode__r.SKU_Code__c +'-'+objNm.SKUCode__r.SKU_Description__c;
                        objNm.SKUCode__r.SKU_Description__c = objNm.SKUCode__r.SKU_Description__c +'-'+objNm.SKUCode__r.SKU_Code__c;
                    }
                    obj = objNm;
                    
                }
               
                
               
                    skuList.add(obj); 
                
                
            }
         }
   }