public with sharing class Grz_ActivityManagementRomaniaController {
	 public String ActivityTpOnUpdate { get; set; }
    public  List<Event> eventList{get;set;}
    private  List<Account> AccountList;//{get;set;}
    public List<List<Account>> nestedListAccount{get;set;}
    private Id LoginUserID;
    public Event eventToInsert{get;set;}
    /*Event Fileds*/
    public String salesRep{get;set;}
    public String Meeting_Purpose{get;set;}
    public String Competitor{get;set;}
    public String Activity_Type{get;set;}
    public String Product_Type{get;set;}
    public String Crop_List{get;set;}
    public String Start_Date{get;set;}
    public String Activity_Date{get;set;}
    public String Account_Type{get;set;}
    public String County{get;set;}
    public String OtherSuppliers{get;set;}
    public Decimal cpValue{get;set;}
     public Decimal arableLand{get;set;}
    //public String Total_Area{get;set;}
    
    
    
    public String Product_Id{get;set;}
    public String End_Date{get;set;}
    public String Account{get;set;}
    public String Location{get;set;}
    public String Meeting_Notes{get;set;}
    public String Negotiated_Agreement{get;set;}
    public String EventSubject{get;set;}
    public String StartDate{get;set;}
    public String StartTime{get;set;}
    public String EndDate{get;set;}
    public String EndTime{get;set;}
    public ID SelectedEventId{get;set;}
    public String status{get;set;}
    public list<cropParse> Crop_Listing{get;set;}
    public List<Attachment> AttachmentList{get;set;}
    public List<CE_Activity_Crop__c> ActivityCropList{get;set;}
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
    public list<RecordTypes> recordtypelist{get;set;}
    public list<Account> AccLookup{get;set;}
    public Map<String,String> productMap{get;set;} 
    public Map<String,String> DistributorsValue{get;set;} 
    public String Distributor_Value{get;set;} 
    public List<SKU__c >productList{get;set;}
    public List<Crop__c>cropList{get;set;}
    /*End of Event Fields*/ 
    
    /*Load initial data of event and account*/
    public Grz_ActivityManagementRomaniaController(){
        System.debug('Inside Constructor');
        try{
            parentStr ='';
            accountSearchKey='';
            
            string recType = '[{"name":"Europe_Farmer_Account","label":"Europe Farmer Account"},{"name":"Europe_Retailer_Account","label":"Europe Retailer Account"},{"name":"Distributor","label":"Distributor"}]';
            recordtypelist =(List<RecordTypes>) System.JSON.deserialize(recType, List<RecordTypes>.class);
            
            System.debug(DateTime.now().format('yyyy-MM-dd\'T\'hh:mm'));
            currentDateTimeStart  = DateTime.now().format('yyyy-MM-dd\'T\'hh:mm');
            System.debug('End time'+DateTime.now().addHours(1).format('yyyy-MM-dd\'T\'hh:mm'));
            status = 'Planned';
            inviteeTimeZone  = '';
            
            Account_Type='Europe_Farmer_Account';
            
            LoginUserID = UserInfo.getUserId();
            currentUser = [select id,Name, Country from user where id =: UserInfo.getUserId() ];
            salesRep = currentUser.Name;
            TimeZone tz = UserInfo.getTimeZone();
            System.debug('Display name: ' +tz.getDisplayName());
            System.debug('ID: ' + tz.getID());
            System.debug('currentUser : ' + currentUser);
            userTimeZone =tz.getID(); 
            
            attachmentToDelete = '';
            eventList = new List<Event>();
            AttachmentList = new List<Attachment>();  
            ActivityCropList = new List<CE_Activity_Crop__c>();  
            AccountList = new List<Account>();
            productMap=new Map<String,String>();
            DistributorsValue = getPicklistValues('Event', 'Romania_Distributors__c');            
            cropList = [SELECT Id, Name,Translated_Name__c FROM Crop__c where  Sales_Org_Code__c =: Label.Grz_RomaniaSalesOrgCode];
            
            productList = [SELECT Id,Product_Name__c,Product_Name__r.Product_code__c,SKU_Description__c, Product_Name__r.Name, Product_Name__r.Sales_Org_Code__c FROM SKU__c  WHERE Sales_Org_Code__c =:Label.Grz_RomaniaSalesOrgCode and SKU_Description__c != null and Active__c = TRUE];
            
            for(SKU__c prd:productlist)
            {
                prd.SKU_Description__c=prd.SKU_Description__c.replace(',',' ');
                productMap.put(prd.Id,prd.SKU_Description__c);
            }
            productMap.put('','--Selectați Produs--');
            eventList = [SELECT Id, Invitee_Timezone__c,Food__c,Night_Stay__c,trader_name__c,Romania_Distributors__c,trader_id__c,Total_area_ha__c,Recomended_UPL_Products__c,Other_Expenses__c,Activity_Date__c,Meeting_Purpose__c,Competitor__c,Location__c,Negotiated_Agreement__c,Meeting_Notes__c,No_of_KMs_Travelled__c,Account.name,Account.RecordType.developername,Subject,Activity_Status__c, AccountId, StartDateTime, EndDateTime,OwnerId,CreatedBy.Name,Owner.Name FROM Event where OwnerId=:LoginUserID AND StartDateTime!=null AND Account.Sales_Org_Code__c =: Label.Grz_RomaniaSalesOrgCode AND custom_activity__c =true];
            //distributor
            AccountList =[SELECT Id,Name,RecordType.Name,Phone FROM Account where  (RecordType.DeveloperName='Distributor' OR  RecordType.DeveloperName='Europe_Farmer_Account' OR RecordType.DeveloperName='Europe_Retailer_Account') AND sales_org_code__c=: Label.Grz_RomaniaSalesOrgCode AND IsPersonAccount=false AND (NOT Name LIKE '%DO NOT%')  order by Name limit 200];// Added DO NOT condition INC0418919 GRZ(Nikhil Verma) 06-12-2022
            AccLookup =[SELECT Id,Name,RecordType.Name,Phone FROM Account where RecordType.DeveloperName='Europe_Farmer_Account' AND sales_org_code__c=: Label.Grz_RomaniaSalesOrgCode AND IsPersonAccount=false AND (NOT Name LIKE '%DO NOT%') order by Name limit 1000];// Added DO NOT condition INC0418919 GRZ(Nikhil Verma) 06-12-2022
            System.debug('AccLookup==>'+ AccLookup.size());            
            //Farmer   
            //AccountList =[SELECT Id,Name, Customer_Type__c,RecordType.Name,Phone, ShippingCity FROM Account where  RecordType.Name='Farmer' AND IsPersonAccount=true];
            Set<String> eventIds = new Set<String>();
            System.debug('AccLookup117==>'+ eventList.size());
            for(Integer j=0;j<eventList.size();j++){
                eventIds.add(eventList[j].Id);
                System.debug('eventList[j].Account.name==>'+ eventList[j].Account.name);
                if(eventList[j].Account.name != null){
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
            ActivityCropList = [SELECT Id, Name, Crop_1__c,Crop_1__r.Name, Quantity_1__c, Crop_2__c,Crop_2__r.Name, Quantity_2__c, Crop_3__c,Crop_3__r.Name, Quantity_3__c, Crop_4__c, Crop_4__r.Name,Quantity_4__c, Crop_5__c,Crop_5__r.Name, Quantity_5__c, Crop_6__c,Crop_6__r.Name, Quantity_6__c, Crop_7__c,Crop_7__r.Name, Quantity_7__c, Crop_8__c,Crop_8__r.Name, Quantity_8__c, Crop_9__c,Crop_9__r.Name, Quantity_9__c FROM CE_Activity_Crop__c WHERE Name IN : eventIds];
            todaysEvent = [SELECT Id, Invitee_Timezone__c,Account.name,Subject,Activity_Status__c, AccountId, StartDateTime, EndDateTime,OwnerId,Negotiated_Agreement__c FROM Event where OwnerId=:LoginUserID AND StartDateTime >= TODAY AND StartDateTime!=null AND Account.Sales_Org_Code__c =: Label.Grz_RomaniaSalesOrgCode AND custom_activity__c =true limit 10];
            System.debug('todaysEvent===>'+todaysEvent);
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
            system.debug(e.getMessage());
        }   
    }
    /*Method for Creating event from Calander*/
    public void CreateEvents(){
        System.debug('Inside CreateEvents()');
        System.debug('Crop_List==>'+Crop_List);
        eventToInsert = new Event();
        ID eveID;
        if(!String.isBlank(SelectedEventId)){
            eveID=Id.valueOf(SelectedEventId); 
            eventToInsert.id=eveID ;
        }
        try{
            String distributorStr = Distributor_Value.replaceAll(',',';');
            eventToInsert.Subject = Activity_Type;
            eventToInsert.Romania_Distributors__c = distributorStr;
            eventToInsert.custom_activity__c = true;
            eventToInsert.WhatID= Account;
            if(!String.isEmpty(Product_Id)){
                eventToInsert.Recomended_UPL_Products__c = Product_Id;
            }else{
                eventToInsert.Recomended_UPL_Products__c = null;
            }
            system.debug('Start_Date'+Start_Date);
            system.debug('Activity_Date'+Activity_Date);
            // system.debug('Total_Area'+Total_Area);
             
            eventToInsert.Account__c=Account;//lookup
            eventToInsert.StartDateTime = Datetime.newInstance(integer.ValueOf(Start_Date.split('-')[0]),integer.ValueOf(Start_Date.split('-')[1]),integer.ValueOf(Start_Date.split('-')[2].split('T')[0]),integer.ValueOf(Start_Date.split('T')[1].split(':')[0]),integer.ValueOf(Start_Date.split('T')[1].split(':')[1]),0);
            eventToInsert.EndDateTime = Datetime.newInstance(integer.ValueOf(End_Date.split('-')[0]),integer.ValueOf(End_Date.split('-')[1]),integer.ValueOf(End_Date.split('-')[2].split('T')[0]),integer.ValueOf(End_Date.split('T')[1].split(':')[0]),integer.ValueOf(End_Date.split('T')[1].split(':')[1]),0);
            if(Activity_Date != '' && Activity_Date != null){
                eventToInsert.Activity_Date__c = Datetime.newInstance(integer.ValueOf(Activity_Date.split('-')[0]),integer.ValueOf(Activity_Date.split('-')[1]),integer.ValueOf(Activity_Date.split('-')[2].split('T')[0]),integer.ValueOf(Activity_Date.split('T')[1].split(':')[0]),integer.ValueOf(Activity_Date.split('T')[1].split(':')[1]),0);
            }    
            // if(Total_Area != null && Total_Area != ''){
           // eventToInsert.Total_area_ha__c =Decimal.valueOf(Total_Area) ;
           //  }else{
           //         eventToInsert.Total_area_ha__c =null;
           //  }
            
            eventToInsert.CurrencyIsoCode ='EUR';
            eventToInsert.OwnerId = LoginUserID ;
            eventToInsert.Competitor__c = Competitor;
            eventToInsert.Meeting_Purpose__c = Meeting_Purpose.replaceAll('/[^a-zA-Z0-9]/g', '');
            eventToInsert.Location__c =Location; 
            eventToInsert.Meeting_Notes__c = Meeting_Notes.replace('\n',', ');
            eventToInsert.Meeting_Notes__c = eventToInsert.Meeting_Notes__c.replaceAll('/[^a-zA-Z0-9]/g', '');
            eventToInsert.Negotiated_Agreement__c = Negotiated_Agreement.replace('\n',', ');
            eventToInsert.Negotiated_Agreement__c = eventToInsert.Negotiated_Agreement__c.replaceAll('/[^a-zA-Z0-9]/g', '');
            //eventToInsert.Meeting_Notes__c = eventToInsert.Meeting_Notes__c.replaceAll('\\W+','');
            eventToInsert.Activity_Status__c=status;
            
            eventToInsert.Invitee_Timezone__c = inviteeTimeZone;
            eventToInsert.Created_From__c = 'SFDC'; //CHGTASK0240834
            //system.debug('record id-->>'+);
            String recTypeId;
            if(Account_Type == 'Europe_Farmer_Account'){
                recTypeId = 'Europe_Farmer_Activity';
            }else if(Account_Type == 'Europe_Retailer_Account'){
                recTypeId = 'Europe_Retailer_Activity';
            }else if(Account_Type == 'Distributor'){
                recTypeId = 'Europe_Distributor_Activity';
            }
            eventToInsert.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get(recTypeId).getRecordTypeId();
            upsert eventToInsert;
            SelectedEventId =eventToInsert.id; 
            system.debug('SelectedEventId -- '+SelectedEventId);
            List<Event> newEventList = [SELECT Id,CreatedBy.Name, CreatedDate FROM Event WHERE Id =:SelectedEventId];
            Crop_Listing = (List<cropParse>) System.JSON.deserialize(Crop_List, List<cropParse>.class);
            system.debug('Crop_Listing -- '+Crop_Listing);
            List<CE_Activity_Crop__c> cropDataDelete = [SELECT Id FROM CE_Activity_Crop__c WHERE Name =: SelectedEventId LIMIT 1];
            if(!cropDataDelete.isEmpty()){
                try{
                    delete cropDataDelete;
                }catch(Exception ex){
                    system.debug('Exception===> '+ex.getMessage());
                }
            }
            CE_Activity_Crop__c ceCrop = new CE_Activity_Crop__c();
            ceCrop.Name = eventToInsert.id;
            ceCrop.Sales_Rep_Name__c = newEventList[0].CreatedById;
            ceCrop.Activity_Creation_Date__c = eventToInsert.StartDateTime;
            ceCrop.Full_Name__c = eventToInsert.Subject;
            ceCrop.Activity_Date__c = eventToInsert.Activity_Date__c;
            ceCrop.Purpose_of_Visit__c = eventToInsert.Meeting_Purpose__c;
            ceCrop.Account__c = eventToInsert.Account__c;
            ceCrop.Product__c = eventToInsert.Recomended_UPL_Products__c;

            if(Crop_Listing.size()>0){
                for(integer i = 0; i< Crop_Listing.size() ; i++){
                    if(i==0 && !String.isEmpty(Crop_Listing[i].Id)){
                        ceCrop.Crop_1__c = Crop_Listing[i].Id;
                        ceCrop.Quantity_1__c =  Integer.valueof(Crop_Listing[i].Quantity);
                    }
                    else if(i==1 && !String.isEmpty(Crop_Listing[i].Id)){
                        ceCrop.Crop_2__c = Crop_Listing[i].Id;
                        ceCrop.Quantity_2__c =  Integer.valueof(Crop_Listing[i].Quantity);
                    }
                    else if(i==2 && !String.isEmpty(Crop_Listing[i].Id)){
                        ceCrop.Crop_3__c = Crop_Listing[i].Id;
                        ceCrop.Quantity_3__c =  Integer.valueof(Crop_Listing[i].Quantity);
                    }
                    else if(i==3 && !String.isEmpty(Crop_Listing[i].Id)){
                        ceCrop.Crop_4__c = Crop_Listing[i].Id;
                        ceCrop.Quantity_4__c =  Integer.valueof(Crop_Listing[i].Quantity);
                    }
                    else if(i==4 && !String.isEmpty(Crop_Listing[i].Id)){
                        ceCrop.Crop_5__c = Crop_Listing[i].Id;
                        ceCrop.Quantity_5__c =  Integer.valueof(Crop_Listing[i].Quantity);
                    }
                    else if(i==5 && !String.isEmpty(Crop_Listing[i].Id)){
                        ceCrop.Crop_6__c = Crop_Listing[i].Id;
                        ceCrop.Quantity_6__c =  Integer.valueof(Crop_Listing[i].Quantity);
                    }
                    else if(i==6 && !String.isEmpty(Crop_Listing[i].Id)){
                        ceCrop.Crop_7__c = Crop_Listing[i].Id;
                        ceCrop.Quantity_7__c =  Integer.valueof(Crop_Listing[i].Quantity);
                    }
                    else if(i==7 && !String.isEmpty(Crop_Listing[i].Id)){
                        ceCrop.Crop_8__c = Crop_Listing[i].Id;
                        ceCrop.Quantity_8__c =  Integer.valueof(Crop_Listing[i].Quantity);
                    }
                    else if(i==8 && !String.isEmpty(Crop_Listing[i].Id)){
                        ceCrop.Crop_9__c = Crop_Listing[i].Id;
                        ceCrop.Quantity_9__c =  Integer.valueof(Crop_Listing[i].Quantity);
                    }
                }
            }
            Insert ceCrop;
            system.debug('CeCrop===> '+ ceCrop.Id);
        }catch(Exception e){
            System.debug('---'+e.getMessage());
        }  
    }
    public void deleteAttachment(){
        System.debug('Inside deleteAttachment()');
        Attachment atTodlete = new Attachment();
        atTodlete.id =  attachmentToDelete;
        try{
            delete atTodlete;
        }
        catch(Exception e){
            system.debug(e);
        }  
    }
    public void RectypeUpdate(){
        system.debug('Account_Type-->>'+Account_Type);
        //system.debug('Crop Listing-->>'+Crop_Listing);
        AccLookup =[SELECT Id,Name,RecordType.Name,Phone FROM Account where Sales_Org_Code__c =: Label.Grz_RomaniaSalesOrgCode and RecordType.DeveloperName=:Account_Type AND IsPersonAccount=false AND (NOT Name LIKE '%DO NOT%')  order by Name limit 1000]; // Added DO NOT condition INC0418919 GRZ(Nikhil Verma) 06-12-2022
    }
    public void getAccountCp(){
        system.debug('Account-->>'+Account);
        //system.debug('Crop Listing-->>'+Crop_Listing);
        Account a = new account();
        a.Crop_Protection_Purchase__c = 0;
        list<account> acc = [SELECT Id,Crop_Protection_Purchase__c,Arable_land_HA__c,romania_county__c,Other_suppliers__c,Name,Phone FROM Account where id =:Account limit 1];
        if(acc.size()>0){
            if(acc[0].Crop_Protection_Purchase__c != null){
        cpValue =acc[0].Crop_Protection_Purchase__c;
            }else{
                cpValue = null;
            }
              if(acc[0].romania_county__c != null){
        county =acc[0].romania_county__c;
              }
            else{
                county = '';
            }
             if(acc[0].Arable_land_HA__c != null){
        arableLand =acc[0].Arable_land_HA__c;
              }else{
                arableLand = null;
            }
            // if(acc[0].Other_suppliers__c != null){
      //  OtherSuppliers =acc[0].Other_suppliers__c;
        //     }
        }
        system.debug('cpValue-->>'+cpValue);
           system.debug('OtherSuppliers-->>'+OtherSuppliers);
    }
    public void searchAccount(){
        system.debug('accountSearchKey ---- '+accountSearchKey);
        String likeKey = accountSearchKey+'%';
        system.debug('Account_Type- '+Account_Type);
        AccountList =[SELECT Id,Name, Customer_Type__c,RecordType.Name,Phone, ShippingCity FROM Account where Sales_Org_Code__c =: Label.Grz_RomaniaSalesOrgCode  and  (RecordType.DeveloperName='Distributor' OR  RecordType.DeveloperName='Europe_Farmer_Account' OR RecordType.DeveloperName='Europe_Retailer_Account') AND IsPersonAccount=false AND (NOT Name LIKE '%DO NOT%') AND Name LIKE :likeKey]; // Added DO NOT condition INC0418919 GRZ(Nikhil Verma) 06-12-2022
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
    public class RecordTypes {
        public String name {get;set;}
        public String label {get;set;}
    }
    public class cropParse {
        public String Id {get;set;}
        public String Quantity {get;set;}
    } 

    public static Map<String, String> getPicklistValues(String obj, String fld){
        Map<String, String> options = new Map<String, String>();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(obj) ;
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        List<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry p: values) {
            options.put(p.getValue(), p.getLabel());
            system.debug(options);
        }
        return options;
    }
}