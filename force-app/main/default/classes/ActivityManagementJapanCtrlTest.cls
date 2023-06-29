@isTest (seeAllData=false)
public class ActivityManagementJapanCtrlTest {
   
     static testMethod void validateHelloWorld() {
        Event eventToInsert = new Event();
        List<Event>    eventList=new List<Event>();  
          Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
         
         Sales_Org__c sorg =new Sales_Org__c();
         sorg.Name='6731';
         sorg.Description__c='Japan';
         sorg.Sales_Org_Code__c='6731';
         insert sorg;
         
         
         Price_Group_Master__c pg = new Price_Group_Master__c ();
         pg.PG_Code__c='03';
         insert Pg;
         
         Distribution_Channel__c disbj = new Distribution_Channel__c();
         disbj.Name = '20';                      
         disbj.Distribution_Channel_Code__c = '20';  
         disbj.Description__c='test';
         insert disbj;
         
         Division__c Divbj = new Division__c();
         Divbj.Name = '10';         
         Divbj.Description__c = null;    
         Divbj.Division_Code__c = '10'; 
         insert Divbj;
         
         Order_Type__c ordType =new Order_Type__c();
         ordType.Name = 'ZORD';              
         ordType.Description__c = 'Japan';    
         ordType.Order_Type_Code__c = 'ZORD';
         insert ordType;
         
         List<Account> accList =new List<Account>();

            Account acc = new Account();
         acc.Name='Nikhil';
         acc.Last_Name__c='Dhoke';
         acc.PriceGroupCode__c=pg.id;
         acc.SAP_Code__c='SAP996734';
         acc.RecordTypeId=devRecordTypeId;
         acc.Mobile__c='8600687971';
         acc.Phone='020266589';
         acc.Sales_Org__c=sorg.Id;
         acc.Division__c=Divbj.Id;
         acc.Distribution_Channel__c=disbj.Id;
         acc.BillingCity='Pune';
         acc.Order_Type__c=ordType.Id;
         acc.Depot_Code__c = 'PUN1';
         //  acc.OwnerId=sobj.Id;
        // insert acc;
         Account acc1 = new Account();
         acc1.Name='Nikhil';
         acc1.Last_Name__c='Dhoke';
         acc1.PriceGroupCode__c=pg.id;
         acc1.SAP_Code__c='SAP996734';
         acc1.RecordTypeId=devRecordTypeId;
         acc1.Mobile__c='8600687971';
         acc1.Phone='020266589';
         acc1.Sales_Org__c=sorg.Id;
         acc1.Division__c=Divbj.Id;
         acc1.Distribution_Channel__c=disbj.Id;
         acc1.BillingCity='Pune';
         acc1.Order_Type__c=ordType.Id;
         acc1.Depot_Code__c = 'PUN1';
        accList.add(acc1);


         
        insert accList;
         /*Spain_Portugal_Campaign__c sobj = new Spain_Portugal_Campaign__c(
           Name = 'Avancer Glow',                             // Campaign Name
           Status__c = 'Active',                                  // Status
           End_Date__c = system.today() + 1 , 
           Start_Date__c = system.today()
           
         );
         insert sobj;*/
                /*
        eventToInsert.Subject = 'test';
          eventToInsert.WhatID= accList[0].Id;
          //eventToInsert.Account__c= '';
          eventToInsert.StartDateTime =system.TODAY();  //datetime.newInstance(2018, 11, 15, 12, 30, 0);
          eventToInsert.EndDateTime =system.TODAY()+1; //datetime.newInstance(2017, 9, 15, 12, 40, 0);
          eventToInsert.CurrencyIsoCode ='INR';
          eventToInsert.OwnerId = UserInfo.getUserId() ;
         // eventToInsert.Visit_Purpose__c ='Spread' ;//;
          eventToInsert.Location__c ='Indore'; 
          eventToInsert.Meeting_Notes__c = 'testNotes';
          eventToInsert.Activity_Status__c='Planned';
          eventToInsert.Activity_Details__c = 'Trial';
          //eventToInsert.Spain_Portugal_Campaign__c=sobj.id;
          eventToInsert.custom_activity__c=true;
          eventToInsert.Sales_Org_Code_For_Spain__c=sorg.Sales_Org_Code__c;
         eventToInsert.Material_Targeted__c='test mate';
          insert eventToInsert; */
          
        Attachment attach=new Attachment();   	
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=accList[0].Id;
        insert attach;
         
         Event someEvent = new Event(Subject = 'Test', 
                                     ActivityDate = date.today(), 
                                     StartDateTime = System.Now(),
                                     EndDateTime = System.Now() + 5,
                                     whatId = accList[0].Id);
       eventToInsert.Subject = 'test';
         eventToInsert.WhatID= accList[0].Id;
         eventToInsert.StartDateTime =datetime.newInstance(2017, 9, 15, 12, 30, 0);
         eventToInsert.EndDateTime = datetime.newInstance(2017, 9, 15, 12, 40, 0);
         eventToInsert.CurrencyIsoCode ='INR';
         eventToInsert.OwnerId = UserInfo.getUserId() ;
         eventToInsert.No_of_KMs_Travelled__c = 0;//;
         eventToInsert.Food__c = 0;//;
         eventToInsert.Night_Stay__c = 0;//;
         eventToInsert.Other_Expenses__c = 0;//;
         eventToInsert.Meeting_Purpose__c ='test purpose' ;//;
         eventToInsert.Location__c ='Indore'; 
         eventToInsert.Meeting_Notes__c = 'testNotes';
         eventToInsert.Activity_Status__c='Planned';
         insert eventToInsert; 
         eventList.add(eventToInsert);
          ActivityManagementJapanCtrl jpr = new ActivityManagementJapanCtrl();
          jpr.Account=accList[0].Id;
          //jpr.Visit_Purpose = '';
          jpr.Start_Date= '2021-08-20T15:30';
          jpr.Account_Type= 'Phone';
          jpr.End_Date= '2021-11-20T15:30';
          jpr.Meeting_Notes= '';
          jpr.EventSubject='';
          jpr.SelectedEventId= eventToInsert.Id;
          jpr.CreateEvents();
          jpr.getAreaFromSO();
          jpr.searchAccount();
         jpr.attachmentToDelete=attach.id;
         jpr.eventList=eventList;
         jpr.todaysEvent=eventList;
        jpr.currentDateTimeEnd=String.valueOf(system.now());
        jpr.getAccountDetails();
        jpr.accountObj=accList[0];
        jpr.account_Id=accList[0].Id;
        jpr.ActivityTpOnUpdate='Test Update';
        jpr.StartDate=String.valueOf(system.today());
        jpr.StartTime=String.valueOf(system.now());
        jpr.EndDate=String.valueOf(system.today()+1);
        jpr.EndTime=String.valueOf(system.now());
        jpr.Reported_By='Test user';
        jpr.Activity_Details='test';
        jpr.Next_Action='Action test';
        jpr.Attendee=3;
        jpr.Duration=30;
         jpr.Area='Area test';
         jpr.Issues_Wishes='test issues';
         jpr.Others='others test';
        jpr.Sales_Office_Name='Test ofc';
         jpr.ActivityCurrency='Japanese yen';
         jpr.Partner_Name='ching chang';
         jpr.AccountList=accList;

                            
     }
}