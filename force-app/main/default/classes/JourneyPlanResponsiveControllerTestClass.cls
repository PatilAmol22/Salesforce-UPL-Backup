@isTest 
private class JourneyPlanResponsiveControllerTestClass {
    static testMethod void validateHelloWorld() {
       Event eventToInsert = new Event();
       
       
         Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='1000';
        sorg.Description__c='India';
        sorg.Sales_Org_Code__c='1000';
        insert sorg;
        
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Trigger_Settings__c tsObj = new Trigger_Settings__c();
        tsObj.Name = 'CaseTrigger';
        tsObj.isActive__c = True;
        insert tsObj;
        
        
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
        ordType.Description__c = 'India';    
        ordType.Order_Type_Code__c = 'ZORD';
        insert ordType;
        
        
        Account acc = new Account();
        acc.Name='Bhavik Devdhar';
        acc.Last_Name__c='Devdhar';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.Account_Type__c='Sold To Party';
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
       
       eventToInsert.Subject = 'test';
         eventToInsert.WhatID= acc.Id;
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
         JourneyPlanResponsive_Controller jpr = new JourneyPlanResponsive_Controller();
         jpr.accountSearchKey = 'Bhavik ';
         jpr.Account=acc.id;
         jpr.Meeting_Purpose = '';
         jpr.Start_Date= '2014-08-20T15:30';
         jpr.Account_Type= '';
         jpr.End_Date= '2014-08-20T15:30';
         jpr.Meeting_Notes= '';
         jpr.SelectedEventId= eventToInsert.Id;
         jpr.CreateEvents();
         jpr.searchAccount();
         jpr.getContact();
         //jpr.createEventRelation(eventToInsert.id,'');
         //jpr.deleteAttachment();
            jpr.deleteInvitee();
         jpr.getContact();
         
    }
}