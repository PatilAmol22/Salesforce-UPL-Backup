public class ActivityManagmentHOCtrl{
    
     public  List<Event> eventList{get;set;}
 private  List<Territory_Distributor__c> AccountList;//{get;set;}
 public List<List<Territory_Distributor__c>> nestedListAccount{get;set;}
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
 public String contactIds{get;set;}
 public String status{get;set;}
 public String farmerActivity{get;set;}
 public Integer noOfKmTravel;//{get;set;}
 public Integer food;//{get;set;}
 public Integer nightStay;//{get;set;}
 public Integer otherExp;//{get;set;}
 public List<Attachment>AttachmentList{get;set;}
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
 public List<Product2>productList{get;set;}
 public List<FarmerActivity__c> FAList{get;set;}
  public List<List<Village__c>> nestedListVillage{get;set;}
  public RecordType rt{get;set;}
 /*End of Event Fields*/  
 public String ActivityCurrency{get;set;}    
   /*Load initial data of event and account*/
    public ActivityManagmentHOCtrl(){
    
       try{
       rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Account' AND Name='PreRegistered Farmer' LIMIT 1];

       parentStr ='';
       accountSearchKey='';
       nestedListVillage = new  List<List<Village__c>>();
      farmerActivity = '';
      FAList = new List<FarmerActivity__c>();
           System.debug('Inside Constructor');
           villageList = new List<Village__c>();
          // cropList = new List<Crop__c>();
          productList = [SELECT Id, Name,  Sales_Org_Code__c FROM Product2 where  Sales_Org_Code__c ='1000'];
           cropList = [SELECT Id, Name FROM Crop__c];
            loadVillage();
           
           System.debug(DateTime.now().format('yyyy-MM-dd\'T\'hh:mm'));
           currentDateTimeStart  = DateTime.now().format('yyyy-MM-dd\'T\'hh:mm');
            System.debug('End time'+DateTime.now().addHours(1).format('yyyy-MM-dd\'T\'hh:mm'));
           status = 'Planned';
           contactIds='';
           inviteeToDelete = '';
           inviteeTimeZone  = '';
           Account_Type='';
           LoginUserID = UserInfo.getUserId();
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
           AccountList = new List<Territory_Distributor__c>();
               eventList = [SELECT Id,Territory_Name__r.name,Territory_Name__c, Invitee_Timezone__c,Food__c,Night_Stay__c,Other_Expenses__c,Meeting_Purpose__c,Location__c,Meeting_Notes__c,No_of_KMs_Travelled__c,Account.name,Subject,Activity_Status__c, AccountId, StartDateTime, EndDateTime,OwnerId FROM Event where OwnerId=:LoginUserID AND StartDateTime!=null AND custom_activity__c =true];
               //distributor
                  AccountList =[SELECT Id, Name, TerritoryCode__c,  Sales_Org_Code__c FROM Territory_Distributor__c where Sales_Org_Code__c='1000' AND Present_in_KEDE__c = true AND Neglected__c = false];//limit 999 (by saurabh AND Sales_Org_Code__c='1000' )
          //Farmer   
           //AccountList =[SELECT Id,Name, Customer_Type__c,RecordType.Name,Phone, ShippingCity FROM Account where  RecordType.Name='Farmer' AND IsPersonAccount=true];

           nestedListAccount = new List<List<Territory_Distributor__c>>();
          Integer count = 0,index=0;
          System.debug('nestedListAccount'+AccountList );
          List<Territory_Distributor__c>asts = new List<Territory_Distributor__c>();
          if(AccountList.size()<999){
              nestedListAccount.add(AccountList);
          }
          for(Territory_Distributor__c acc : AccountList){
              count++;
            
              if(count>=999){
                     System.debug('count - '+count);
                   nestedListAccount.add(asts);  
                   asts= new List<Territory_Distributor__c>();
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
               todaysEvent = [SELECT Id, Territory_Name__r.name,Invitee_Timezone__c,Account.name,Subject,Activity_Status__c, AccountId, StartDateTime, EndDateTime,OwnerId FROM Event where OwnerId=:LoginUserID AND StartDateTime = TODAY AND StartDateTime!=null AND custom_activity__c =true limit 100];
              // contactList = [SELECT Id, FirstName,LastName,Title,AccountId, IsPersonAccount, Name, Phone, MobilePhone, Email, OwnerId FROM Contact where Account.ID IN:AccountList AND IsPersonAccount=false limit 0];
            //   vfEventRelList = [SELECT Id, Relation.name,eventID, Event.subject FROM EventRelation where eventID In :eventList AND IsInvitee =true];
         
          // jsonEventRelation =JSON.serialize(vfEventRelList); 
           
          // jsonEventRelation= jsonEventRelation.replace('\\"', '');
           
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
           SelectedEventId='';
          
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
         eventToInsert.Subject = Activity_Type;
         eventToInsert.custom_activity__c = true;
         eventToInsert.Territory_Name__c=Account;
         eventToInsert.StartDateTime = Datetime.newInstance(integer.ValueOf(Start_Date.split('-')[0]),integer.ValueOf(Start_Date.split('-')[1]),integer.ValueOf(Start_Date.split('-')[2].split('T')[0]),integer.ValueOf(Start_Date.split('T')[1].split(':')[0]),integer.ValueOf(Start_Date.split('T')[1].split(':')[1]),0);
         eventToInsert.EndDateTime = Datetime.newInstance(integer.ValueOf(End_Date.split('-')[0]),integer.ValueOf(End_Date.split('-')[1]),integer.ValueOf(End_Date.split('-')[2].split('T')[0]),integer.ValueOf(End_Date.split('T')[1].split(':')[0]),integer.ValueOf(End_Date.split('T')[1].split(':')[1]),0);
         eventToInsert.CurrencyIsoCode ='INR';
         eventToInsert.OwnerId = LoginUserID ;
         eventToInsert.No_of_KMs_Travelled__c = noOfKmTravel;//;
         eventToInsert.Food__c = food;//;
         eventToInsert.Night_Stay__c = nightStay;//;
         eventToInsert.Other_Expenses__c = otherExp;//;
         eventToInsert.Meeting_Purpose__c = Meeting_Purpose;//;
         eventToInsert.Location__c =Location; 
         eventToInsert.Meeting_Notes__c = Meeting_Notes.replace('\n',', ');
         eventToInsert.Meeting_Notes__c = eventToInsert.Meeting_Notes__c.replaceAll('\\W+','');
         eventToInsert.Activity_Status__c=status;
         eventToInsert.Invitee_Timezone__c = inviteeTimeZone;
         eventToInsert.Created_From__c = 'SFDC'; //CHGTASK0240834
         upsert eventToInsert;
         SelectedEventId =eventToInsert.id; 
         system.debug('SelectedEventId -- '+SelectedEventId);
         System.debug('contactIds -- '+contactIds);
         if(contactIds.length()>0){
             //createEventRelation(SelectedEventId,contactIds);
           }
           if(Account_Type == 'Farmer'){
               CreateFarmerActivity(SelectedEventId);
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
     
      public void searchAccount(){
           system.debug('accountSearchKey ---- '+accountSearchKey);
           String likeKey = accountSearchKey+'%';
         system.debug('Account_Type- '+Account_Type);
          if(Account_Type == 'Distributor'){
                  AccountList =[SELECT Id, Name, TerritoryCode__c,  Sales_Org_Code__c FROM Territory_Distributor__c where Sales_Org_Code__c='1000'];
       
          }
          if(Account_Type == 'Farmer'){
                  AccountList =[SELECT Id, Name, TerritoryCode__c,  Sales_Org_Code__c FROM Territory_Distributor__c where Sales_Org_Code__c='1000'];
       
          }
          system.debug(AccountList);
           nestedListAccount = new List<List<Territory_Distributor__c>>();
          Integer count = 0,index=0;
          System.debug('nestedListAccount');
          List<Territory_Distributor__c>asts = new List<Territory_Distributor__c>();
          if(AccountList.size()<999){
              nestedListAccount.add(AccountList);
          }
          for(Territory_Distributor__c acc : AccountList){
              count++;
            
              if(count>=999){
                     System.debug('count - '+count);
                   nestedListAccount.add(asts);  
                   asts= new List<Territory_Distributor__c>();
                   index++;
                  count=0; 
              }
             asts.add(acc);
             
              
          }
           System.debug('nestedListAccount');
          
              System.debug(nestedListAccount.size());
      }
      public void loadVillage(){
          //vilage SOQL
          system.debug('Calling');
          List<TM_District_Tehsil_Mapping__c > TMDTM = [SELECT Id, Territory__c ,Tehsil__r.name ,TM_User__c, Territory__r.name FROM TM_District_Tehsil_Mapping__c where TM_User__c =: UserInfo.getUserId()];
          system.debug('user ID - '+UserInfo.getUserId());
          system.debug('TMDTM ');
          system.debug(TMDTM);
          set<ID> TerritoryList = new set<ID>();
         for(TM_District_Tehsil_Mapping__c  trhg : TMDTM){
             TerritoryList.add(trhg.Territory__c);
         }
          villageList = new List<Village__c>();
          system.debug('TerritoryList');
          system.debug(TerritoryList);
           villageList  = [SELECT Name, Id ,Tehsil__r.Territory__c FROM Village__c  where Tehsil__r.Territory__c!='' AND Tehsil__r.Territory__c IN :TerritoryList];
       //  Village__c  vilg = new Village__c();
        // vilg.Name = 'Abhish';
        // villageList.add(vilg);  
          nestedListVillage = new List<List<Village__c>>();
          Integer count = 0,index=0;
          System.debug('nestedListAccount');
          List<Village__c>asts = new List<Village__c>();
        
          for(Village__c acc : villageList){
              count++;
            System.debug(acc.Name);
              if(count>=999){
                     System.debug('count - '+count);
                   nestedListVillage.add(asts);  
                   asts= new List<Village__c>();
                   index++;
                  count=0; 
              }
              
             asts.add(acc);
             
              
          }
          if(asts.size()>0){
               nestedListVillage.add(asts);  
              }
           System.debug('nestedListVillage');
           System.debug( nestedListVillage);
          
             
         
          
          
      }
      public void CreateFarmerActivity(String EventId){
      system.debug('hidnFarmerActivity ---------- '+FarmerActivity);
          FarmerActivity = FarmerActivity.replace('[','').replace(']','');
          List<FarmerACtivityWrap> farmerWrap = new List<FarmerACtivityWrap>();
          for(String s : FarmerActivity.split('},')){
              
              system.debug(s);
              if(!s.contains('}')){
                  s = s+'}';
              }
            FarmerACtivityWrap faw =(FarmerACtivityWrap) JSON.deserialize(s,FarmerACtivityWrap.class); 
            farmerWrap.add(faw);   
          }
          
          system.debug(farmerWrap);
          EventMaster__c EM = new EventMaster__c();
          EM.Name = EventId;
          insert EM;
          //system.debug(farmerActivity);
          eventToInsert = new Event();
          eventToInsert.id =EventId; 
          eventToInsert.EventMaster__c =EM.id;
          update eventToInsert; 
           FAList = new List<FarmerActivity__c>();
          
          for(FarmerACtivityWrap fdt :  farmerWrap){
             FarmerActivity__c FA = new FarmerActivity__c();
              FA.EventMaster__c = EM.id;
              FA.Name = fdt.ActivityName;
              FA.Crop__c = fdt.CropName;
              FA.Product__c = fdt.ProductName;
              FA.Village__c = fdt.VillageName;
              FAList.add(FA); 
          }
          if(FAList.size()>0){
              insert FAList;
          }
           
      }
      public void loadFarmerActivity(){
          //SelectedEventId
          system.debug('SelectedEventId -- '+SelectedEventId);
           FAList = new List<FarmerActivity__c>();
             Event ev  = [SELECT Id,EventMaster__c from Event where id= :SelectedEventId];
             FAList = [select id,Name ,Crop__c,EventMaster__c,Product__c,Village__c from FarmerActivity__c where EventMaster__c=: ev.EventMaster__c];       
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