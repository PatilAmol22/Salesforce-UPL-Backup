@isTest
public class ActivityManagmentNZCtrlTest {
static testMethod void validateHelloWorld() {
       Event eventToInsert = new Event();
    	Event eventToInsert1 = new Event();
              
         Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='New Zealand';
        sorg.Description__c='Australia';
        sorg.Sales_Org_Code__c='6061';
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
        ordType.Description__c = 'Europe';    
        ordType.Order_Type_Code__c = 'ZORD';
        insert ordType;
        
        
        Account acc = new Account();
        acc.Name='Bhavik Devdhar';
        acc.Last_Name__c='Devdhar';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='9967341759';
        acc.Phone='020256589';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Pune';
        acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        //  acc.OwnerId=sobj.Id;
        insert acc;
    
    Shipping_Location__c sl = new Shipping_Location__c();
    sl.SAP_Code__c = 'SAP996789';
    sl.Distributor__c = acc.id;
    insert sl;
       
       	eventToInsert.Subject = 'test';
         eventToInsert.WhatID= sl.Id;
         eventToInsert.StartDateTime =datetime.newInstance(2017, 9, 15, 12, 30, 0);
         eventToInsert.EndDateTime = datetime.newInstance(2017, 9, 15, 12, 40, 0);
         eventToInsert.CurrencyIsoCode ='INR';
         eventToInsert.OwnerId = UserInfo.getUserId() ;
         eventToInsert.Meeting_Purpose__c ='test purpose' ;
         eventToInsert.Location__c ='Indore'; 
         eventToInsert.Meeting_Notes__c = 'testNotes';
         eventToInsert.Activity_Status__c='Planned';
         insert eventToInsert; 
    
    	eventToInsert1.Subject = 'test1';
         eventToInsert1.WhatID= sl.Id;
         eventToInsert1.StartDateTime =System.now();
         eventToInsert1.EndDateTime = datetime.newInstance(2021, 6, 22, 12, 40, 0);
         eventToInsert1.CurrencyIsoCode ='INR';
         eventToInsert1.OwnerId = UserInfo.getUserId() ;
         eventToInsert1.Meeting_Purpose__c ='test purpose' ;//;
         eventToInsert1.Location__c ='Indore'; 
         eventToInsert1.Meeting_Notes__c = 'testNotes';
         eventToInsert1.Activity_Status__c='Planned';
         insert eventToInsert1; 
         
         ActivityManagmentNZCtrl jpr = new ActivityManagmentNZCtrl();
         jpr.Account=sl.id;
         jpr.Meeting_Purpose = '';
         jpr.Start_Date= '2014-08-20T15:30';
         jpr.Account_Type= '';
         jpr.End_Date= '2014-08-20T15:30';
         jpr.Meeting_Notes= '';
         jpr.SelectedEventId= eventToInsert.Id;
         jpr.CreateEvents();
        
         jpr.searchAccount();
    
    	ActivityManagmentNZCtrl jpr1 = new ActivityManagmentNZCtrl();
         jpr1.Account=sl.id;
         jpr1.Meeting_Purpose = '';
         jpr1.Start_Date= '2014-08-20T15:30';
         jpr1.Account_Type= '';
         jpr1.End_Date= '2014-08-20T15:30';
         jpr1.Meeting_Notes= '';
         jpr1.SelectedEventId= eventToInsert1.Id;
         jpr1.CreateEvents();
        
         jpr1.searchAccount();
        
                              
    }
}