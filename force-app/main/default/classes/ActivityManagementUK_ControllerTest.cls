@isTest 
public class ActivityManagementUK_ControllerTest {
     static testMethod void validateHelloWorld() {
       Event eventToInsert = new Event();
              
         Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='2410';
        sorg.Description__c='Italy-Domestic';
        sorg.Sales_Org_Code__c='2410';
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
        ordType.Description__c = 'Italy-Domestic';    
        ordType.Order_Type_Code__c = 'ZORD';
        insert ordType;
        
        
        
        Account acc = new Account();
        acc.Name='Nikhil';
        acc.Last_Name__c='Dhoke';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='860687971';
        acc.Phone='020255589';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Pune';
        acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        //  acc.OwnerId=sobj.Id;
        insert acc;
       
       eventToInsert.Subject = 'test';
         eventToInsert.WhatID= acc.Id;
         eventToInsert.Account__c= acc.Id;
         eventToInsert.StartDateTime = system.TODAY();  //datetime.newInstance(2017, 9, 15, 12, 30, 0);
         eventToInsert.EndDateTime = system.TODAY()+1;  //datetime.newInstance(2017, 9, 15, 12, 40, 0);
         eventToInsert.CurrencyIsoCode ='INR';
         eventToInsert.OwnerId = UserInfo.getUserId() ;
         eventToInsert.Meeting_Purpose__c ='test purpose' ;//;
         eventToInsert.Location__c ='Indore'; 
         eventToInsert.Meeting_Notes__c = 'testNotes';
         eventToInsert.Activity_Status__c='Planned';
         eventToInsert.custom_activity__c=true;
         insert eventToInsert; 
         
        
         
         ActivityManagementUK_Controller jpr = new ActivityManagementUK_Controller();
         jpr.Account=acc.id;
         jpr.Meeting_Purpose = '';
         jpr.Start_Date= '2014-08-20T15:30';
         jpr.Account_Type= '';
         jpr.End_Date= '2014-08-20T15:30';
         jpr.Meeting_Notes= '';
         jpr.SelectedEventId= eventToInsert.Id;
         jpr.currentDateTimeEnd = date.today() +'00:00:00';
         jpr.ActivityTpOnUpdate  = '';
         jpr.CreateEvents();
         jpr.searchAccount();
          
         
        
       
      
        
                              
    }

}