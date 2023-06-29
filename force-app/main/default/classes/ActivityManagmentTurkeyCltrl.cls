public with sharing class ActivityManagmentTurkeyCltrl{

    public  List<Event> eventList{get;set;}
 private  List<Account> AccountList;//{get;set;}
 public List<List<Account>> nestedListAccount{get;set;}
 private Id LoginUserID;
 public Event eventToInsert{get;set;}
 //Updated by Varun Shrivastava: SCTASK0362006 Start 6 April 2021
 //public FarmerActivity__c farmerAcc ;
 public List<FarmerActivity__c> farmerAcc ;
 //Updated by Varun Shrivastava: SCTASK0362006 End 6 April 2021
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
 public List<SKU__c >productList{get;set;}
 public List<FarmerActivity__c> FAList{get;set;}
  public List<List<Village__c>> nestedListVillage{get;set;}
  public RecordType rt{get;set;}
  
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
 ////Added by Varun Shrivastava : SCTASK0362006 End
   /*Load initial data of event and account*/
    public ActivityManagmentTurkeyCltrl(){
       try{
       rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Account' AND Name='PreRegistered Farmer' LIMIT 1];
       //Added by Varun shrivastava:SCTASK0362006 Start
       Turkey_Activity__c ta = Turkey_Activity__c.getValues('Current Time');
           if(ta != null)
           	isDSTEnabled = ta.Is_DST_Enabled__c; 
           else
            isDSTEnabled = false;   
       //Added by Varun Shrivastava:SCTASK0362006 End

       parentStr ='';
       accountSearchKey='';
       nestedListVillage = new  List<List<Village__c>>();
      farmerActivity = '';
      FAList = new List<FarmerActivity__c>();
           System.debug('Inside Constructor');
           
          villageList = new List<Village__c>();
          cropList = new List<Crop__c>();
          productList = [SELECT Id,Product_Name__c,Product_Name__r.Product_code__c,SKU_Description__c, Product_Name__r.Name, Product_Name__r.Sales_Org_Code__c FROM SKU__c  WHERE Sales_Org_Code__c = '7110' and SKU_Description__c != '' and Active__c = TRUE];
          
          productMap=new Map<String,String>();
          
          for(SKU__c prd:productlist)
            {
                if(prd.SKU_Description__c != ''){
                prd.SKU_Description__c=prd.SKU_Description__c.replace(',',' ');
                productMap.put(prd.Id,prd.SKU_Description__c);}
                
            }
            System.debug('Map Count---'+productMap.size());
                    
           cropList = [SELECT Id, Name,Translated_Name__c FROM Crop__c where  Sales_Org_Code__c ='7110'];
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
           System.debug('LoginUserID:---'+LoginUserID);
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
               eventList = [SELECT Id, Invitee_Timezone__c,Food__c,Night_Stay__c,Other_Expenses__c,Meeting_Purpose__c,Location__c,Meeting_Notes__c,No_of_KMs_Travelled__c,Account.name,Subject,Activity_Status__c, AccountId, StartDateTime, EndDateTime,OwnerId, No_of_Farmers__c, Expenses__c FROM Event where OwnerId=:LoginUserID AND SalesOrg__c ='Turkey' AND StartDateTime!=null];
               System.debug('Event List.. ' + eventList.size());
           
               for(Event env:eventList)
               {
                   if(String.isNotBlank(env.Meeting_Purpose__c)){
                       env.Meeting_Purpose__c=env.Meeting_Purpose__c.replaceAll('/[^a-zA-Z0-9]/g', '');
                   }
                   if(String.isNotBlank(env.Subject)){
                       env.Subject=env.Subject.replaceAll('/[^a-zA-Z0-9]/g', '');
                   }
               }
               
               //distributor
                //  AccountList =[SELECT Id,Name, Customer_Type__c,RecordType.Name,Phone, ShippingCity FROM Account where Account_Type__c='Sold To Party' AND RecordType.Name='Distributor' AND IsPersonAccount=false AND Sales_Org_Code__c='1000' limit 1000 ];//limit 999 (by saurabh AND Sales_Org_Code__c='1000' )
          //Farmer   
           //AccountList =[SELECT Id,Name, Customer_Type__c,RecordType.Name,Phone, ShippingCity FROM Account where  RecordType.Name='Farmer' AND IsPersonAccount=true];

        /*   nestedListAccount = new List<List<Account>>();
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
                 system.debug(parentStr.length()); */
              
               AttachmentList = [SELECT Id, Name, ParentId,ownerID FROM Attachment where ParentId IN : eventList];
               todaysEvent = [SELECT Id, Invitee_Timezone__c,Owner.name,Subject,Activity_Status__c, AccountId, StartDateTime, EndDateTime,OwnerId FROM Event where OwnerId=:LoginUserID AND SalesOrg__c ='Turkey' AND StartDateTime = TODAY AND StartDateTime!=null limit 100];
             system.debug('TODAY  -- - -- -'+system.now());
             system.debug('Attachment List-- - -- -'+AttachmentList.size());
             system.debug('Event List-- - -- -'+todaysEvent.size());
             
              /*contactList = [SELECT Id, FirstName,LastName,Title,AccountId, IsPersonAccount, Name, Phone, MobilePhone, Email, OwnerId FROM Contact where Account.ID IN:AccountList AND IsPersonAccount=false limit 0];
               vfEventRelList = [SELECT Id, Relation.name,eventID, Event.subject FROM EventRelation where eventID In :eventList AND IsInvitee =true];
           for(Integer i=0;i<contactList.size();i++){
            contactList[i].LastName=  contactList[i].LastName.replaceAll('"', '');// = contactList[i].FirstName.replaceAll('/[^a-zA-Z0-9]/g', '')+' '+contactList[i].LastName.replaceAll('/[^a-zA-Z0-9]/g', ''); 
           }
           
           for(Integer i=0;i<AccountList.size();i++){
               AccountList[i].Name = AccountList[i].Name.replaceAll('"', '');
           }
           jsonEventRelation =JSON.serialize(vfEventRelList); 
           
           jsonEventRelation= jsonEventRelation.replace('\\"', '');*/
           
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
          
           //SelectedEventId='';
          System.debug('Inside ActivityManagmentTurkeyCltrl() constructor');
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
       
        // eventToInsert.WhatID= Account;
       // eventToInsert.WhatID=LoginUserID;
       
       //  eventToInsert.Account__c=Account;//lookup
       
       //  eventToInsert.WhoID= UserInfo.getUserId();
         eventToInsert.StartDateTime = Datetime.newInstance(integer.ValueOf(Start_Date.split('-')[0]),integer.ValueOf(Start_Date.split('-')[1]),integer.ValueOf(Start_Date.split('-')[2].split('T')[0]),integer.ValueOf(Start_Date.split('T')[1].split(':')[0]),integer.ValueOf(Start_Date.split('T')[1].split(':')[1]),0);
         eventToInsert.EndDateTime = Datetime.newInstance(integer.ValueOf(End_Date.split('-')[0]),integer.ValueOf(End_Date.split('-')[1]),integer.ValueOf(End_Date.split('-')[2].split('T')[0]),integer.ValueOf(End_Date.split('T')[1].split(':')[0]),integer.ValueOf(End_Date.split('T')[1].split(':')[1]),0);
         eventToInsert.CurrencyIsoCode ='INR';
         eventToInsert.OwnerId = LoginUserID ;
         eventToInsert.No_of_KMs_Travelled__c = noOfKmTravel;//;
         eventToInsert.Food__c = food;//;
         eventToInsert.Night_Stay__c = nightStay;//;
         eventToInsert.Other_Expenses__c = otherExp;//;
         eventToInsert.Meeting_Purpose__c = Meeting_Purpose.replaceAll('/[^a-zA-Z0-9]/g', '');//;
         eventToInsert.Location__c =Location; 
         eventToInsert.Meeting_Notes__c = Meeting_Notes.replace('\n',', ');
        // eventToInsert.Meeting_Notes__c = eventToInsert.Meeting_Notes__c.replaceAll('\\W+','');
         eventToInsert.Activity_Status__c=status;
         eventToInsert.Invitee_Timezone__c = inviteeTimeZone;
         eventToInsert.No_of_Farmers__c=noOfFarmer;
         eventToInsert.Expenses__c=expenses;
         eventToInsert.Created_From__c = 'SFDC'; //CHGTASK0240834
         upsert eventToInsert;
         SelectedEventId =eventToInsert.id; 
         system.debug('SelectedEventId -- '+SelectedEventId);
         System.debug('contactIds -- '+contactIds);
         /*if(contactIds.length()>0){
             createEventRelation(SelectedEventId,contactIds);
           }
           if(Account_Type == 'Farmer'){
               CreateFarmerActivity(SelectedEventId);
           }*/                                                  /*comment by Nikhil..*/
           farmerAcc = new List<FarmerActivity__c>();
           farmerAcc = [Select Id from FarmerActivity__c where EventMaster__c =: SelectedEventId];
           
           //Updated  by Varun Shrivastava Start: SCTASK0362006 6 April 2021
           //if(farmerAcc.Id != '' && farmerAcc.Id != null){
           if(farmerAcc != null && farmerAcc.size() > 0){    
           //Updated  by Varun Shrivastava End: SCTASK0362006 6 April 2021
               delete_FarmerActivity(SelectedEventId);
               CreateFarmerActivity(SelectedEventId,Activity_Type);
           }
           else{
               CreateFarmerActivity(SelectedEventId,Activity_Type);
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
           System.debug( nestedListVillage.size());
          
             
         
          
          
      }
      
      public void CreateFarmerActivity(String EventId, String activity_type){
      system.debug('CreateFarmerActivity----CropList------'+inputCrops);
       system.debug('CreateFarmerActivity---Product-------'+inputProducts);
      system.debug('hidnFarmerActivity ---------- '+FarmerActivity);
      
          /*FarmerActivity = FarmerActivity.replace('[','').replace(']','');
          List<FarmerACtivityWrap> farmerWrap = new List<FarmerACtivityWrap>();
          for(String s : FarmerActivity.split('},')){
              
              system.debug(s);
              if(!s.contains('}')){
                  s = s+'}';
              }
            FarmerACtivityWrap faw =(FarmerACtivityWrap) JSON.deserialize(s,FarmerACtivityWrap.class); 
            farmerWrap.add(faw);   
          }*/
          
          inputCropList=new List<String>();
          for(String s : inputCrops.split(',')){
              
              system.debug(s);
            
            inputCropList.add(s);   
          }
           system.debug('Input Crop List:----'+ inputCropList);
          inputProductList=new List<String>();
          for(String st : inputProducts.split(',')){
              
              system.debug(st);
            
            inputProductList.add(st);   
          }
          system.debug('Input Crop List:----'+ inputProductList);
          //system.debug(farmerWrap);
          EventMaster__c EM = new EventMaster__c();
          EM.Name = EventId;
          insert EM;
          //system.debug(farmerActivity);
          eventToInsert = new Event();
          eventToInsert.id =EventId; 
          eventToInsert.EventMaster__c =EM.id;
          update eventToInsert; 
          
          Integer count=0;
          Integer c_count=inputCropList.size();
          system.debug('Crop Count:----'+ c_count);
          Integer p_count=inputProductList.size();
          system.debug('Product Count:----'+ p_count);
          
          if(c_count>=p_count)
          {
              count=c_count;
          }
          else
          {
              count=p_count;
          }
          system.debug('Count:----'+ count);
           FAList = new List<FarmerActivity__c>();
           
          
          /*for(FarmerACtivityWrap fdt :  farmerWrap){
             FarmerActivity__c FA = new FarmerActivity__c();
              FA.EventMaster__c = EM.id;
              FA.Name = fdt.ActivityName;
              FA.Crop__c = fdt.CropName;
              FA.Product__c = fdt.ProductName;
              FA.Village__c = fdt.VillageName;
              FAList.add(FA); 
          }*/
          
          for(Integer i=0;i<count;i++)
          {
              FarmerActivity__c FA = new FarmerActivity__c();
              FA.EventMaster__c = EM.id;
              FA.Name = activity_type;
              
              if(i<c_count){
                  FA.Crop__c = inputCropList.get(i);
              }
              else{
                  FA.Crop__c = '';
              }
              
             if(i<p_count){
                  FA.Product__c = inputProductList.get(i);
              }
              else{
                  FA.Product__c = '';
              }
              
              FA.Village__c = '';
              system.debug('Farmer Activity:----'+ FA);
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
          //Added by Varun Shrivastava: SCTASK0362006
                   
             Event ev  = [SELECT Id,EventMaster__c,Expenses__c,StartDateTime,EndDateTime from Event where id= :SelectedEventId];
          
                   expenses = Integer.valueOf(ev.Expenses__c);
          			eventStartDateTime = ev.StartDateTime;
          			eventEndDateTime = ev.EndDateTime;
                   //Added by Varun Shrivastava: SCTASK0362006
             FAList = [select id,Name ,Crop__c,EventMaster__c,Product__c,Village__c from FarmerActivity__c where EventMaster__c=: ev.EventMaster__c];   
             system.debug(FAList);   
      }
    public void delete_FarmerActivity(String EventId){
      system.debug('Inside delete_FarmerActivity method...');
      List<FarmerActivity__c> faList2=new List<FarmerActivity__c>();
      faList2=[select id,Name ,Crop__c,EventMaster__c,Product__c,Village__c from FarmerActivity__c where EventMaster__c=: EventId];
      try{      
        delete faList2;
       }
       catch(Exception e){
       system.debug('Exception while deleting Farmer Activities.'+ e);
        }          
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
      
      public void remove_ListElement(){
      system.debug('Inside remove_ListElement method...');
      system.debug('Selected Farmer Activity Id:- '+faId);
      system.debug('Selected Type:- '+type);
      
      FarmerActivity__c fa = new FarmerActivity__c();
      
      fa.Id=faId;
      if(type=='Crop__c'){
          fa.Crop__c='';
      }
      else{
          fa.Product__c='';
      }
      try{
          update fa;
          loadFarmerActivity();
      }
      catch(Exception e){
      system.debug('Exception occure while updating FA:- '+e);
      }
      
      }
      
      
      
}