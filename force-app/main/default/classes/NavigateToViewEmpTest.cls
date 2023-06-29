@isTest
public class NavigateToViewEmpTest {
    
    @isTest
    public static void getTasksTest(){
        
         Group g1 = new Group(Name='group name', type='Queue');
        insert g1;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'user000@amamama.com',
            Username = 'user000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');    
        
        System.runAs(u){
            QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Task');
            insert q1;
            
        }
        
        QueuesObject qq = [SELECT ID,QueueID FROM QueuesObject Limit 1];
        
        Profile pr = new Profile(name = 'UPL Call Expert');
        Profile prof = [select id from profile where name='UPL Call Expert'];
        
        User usr = new User(LastName = 'Krishnan',
                            FirstName='Sujin',
                            Alias = 'Sujin',
                            Email = 'abc@sfdc.com',
                            Username = 'sujinkrishnnan2908199311123@sfdc.com',
                            ProfileId = prof.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                           ); 
        
        system.runAs(usr){
            State__c state = new State__c(Name = 'Tamil Nadu',Language__c = 'Tamil');
            insert state;
            
            District__c dist = new District__c(
                Name = 'Krishnagiri',                   // District Name
                District_Code__c = '631',                 // District Code
                State__c = state.Id,             
                Active__c = true,                        // Active
                District_Name_Census__c = 'Krishnagiri',  // District Name Census
                District_Code_Census__c = '631');
            insert dist;
            
            Tehsil__c tehsil = new Tehsil__c(
                Name = '644000', 
                District__c = dist.Id,
                Tehsil_Code__c = '5890');
            insert tehsil;
            
            Village__c village = new Village__c(
                Name = 'Nimbhora  Bk.',                                                  
                Territory__c = 'Narayangaon', 
                Tehsil__c = tehsil.Id,
                Region__c = 'Aurangabad',                                                      
                Zone__c = 'Pune Zone',
                Fo_Map__c = true);
            insert village;
            
            Sales_Org__c SO = new Sales_Org__c();
            so.name = 'TestFin';
            so.Sales_Org_Code__c = '1000';
            insert so;
            
            Product2 p = new product2();
            //P.RecordTypeId= '';
            p.name = 'testproduct';
            p.Sales_Org__c = SO.ID;
            p.Combination_Key__c = '123';
            // p.Sales_Org_Code__c = 1000;
            insert p;
				
            /*
            Product2 p = new product2();
            string rid = [select id from RecordType where SobjectType='Product2'AND DeveloperName != 'US' limit 1].id;
            System.debug('rid ' + rid);
            p.RecordTypeId = rid;
            p.name = 'testproduct';
            p.Sales_Org__c = SO.ID;
            p.Combination_Key__c = '123';
            insert p;
            */
            
            Promotional_Product__c pp1 = new Promotional_Product__c();
            pp1.Name = 'Testabc1';
            pp1.Product_Name__c = p.id;
            pp1.Current_Month__c = TRUE;
            pp1.Month__c = 'Jan';
            pp1.Financial_Year__c = '2020';
            pp1.Crop__c = 'Cotton';
            insert pp1;
            
        

        String farmerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
        Account acc = new Account( FirstName = 'test',LastName = 'test',PersonMobilePhone='9869457812',
                                  RecordTypeId = farmerRecordTypeId,Decision_Maker__pc = 'Yes',
                                  Crops_Cultivated__pc = 'Fruits/Vegetables',PersonBirthdate = Date.newInstance(1990, 09, 11),
                                  Mobile__c = '9869457812',What_is_your_highest_education_attained__pc = 'Illiterate',
                                  Village__c = village.id,Using_Smart_Phone__c = 'No' ,
                                  Promotional_Product__c = pp1.id ,Village__pc =village.id);
        insert acc;
        
        Account actest = [Select Id, State__c, State__pc, Village__c,Name, Village__r.State__c FROM Account where id = :acc.id ];
        System.debug('AC-QUERY '+actest);
        
        
        Task t = new Task(
            WhatID = actest.id,
            Subject='Call To Farmer - For Follow Up',
            Status='New',
            Priority='Normal');
        
        insert t;  
        
        system.debug('qqqqqq '+qq.QueueId);    
        t.OwnerId = g1.Id;
        update t;
        
        
        Test.startTest();
        NavigateToViewEmp.getTasks(t.id);
        Test.stopTest();
        
        
        Task tt = [SELECT ID, recordTypeId, WhoId, WhatId, WhoCount, WhatCount, 
                   Subject, ActivityDate, Status, Priority, IsHighPriority, OwnerId,
                   Description, Type, AccountId, IsClosed, 
                   Empanelment__c FROM Task WHERE Id =: t.Id];
        System.assertEquals('Call To Farmer - For Follow Up', tt.Subject);
		
    	}

}
     @isTest
    public static void empanelValuesTest(){
        //
        Profile pr = new Profile(name = 'UPL Call Expert');
        Profile prof = [select id from profile where name='UPL Call Expert'];
        User u = new User(LastName = 'Krishna',
                            FirstName='Sujint',
                            Alias = 'Sujik',
                            Email = 'abc2@sfdc.com',
                            Username = 'sujinkrishnnan29081993111222@sfdc.com',
                            ProfileId = prof.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                           ); 
        
        system.runAs(u){
            State__c state = new State__c(Name = 'Tamil Nadu',Language__c = 'Tamil');
            insert state;
            
            District__c dist = new District__c(
                Name = 'Krishnagiri',                   // District Name
                District_Code__c = '631',                 // District Code
                State__c = state.Id,             
                Active__c = false,                        // Active
                District_Name_Census__c = 'Krishnagiri',  // District Name Census
                District_Code_Census__c = '631');
            insert dist;
            
            Tehsil__c tehsil = new Tehsil__c(
                Name = '644000', 
                District__c = dist.Id,
                Tehsil_Code__c = '5890');
            insert tehsil;
            
            Village__c village = new Village__c(
                Name = 'Nimbhora  Bk.',                                                  
                Territory__c = 'Narayangaon', 
                Tehsil__c = tehsil.Id,
                Region__c = 'Aurangabad',                                                      
                Zone__c = 'Pune Zone',
                Fo_Map__c = true);
            insert village;
            
            Sales_Org__c SO = new Sales_Org__c();
            so.name = 'TestFin';
            so.Sales_Org_Code__c = '1000';
            insert so;
            
            Product2 p = new product2();
            //P.RecordTypeId= '';
            p.name = 'testproduct';
            p.Sales_Org__c = SO.ID;
            p.Combination_Key__c = '123';
            // p.Sales_Org_Code__c = 1000;
            insert p;
            
            Promotional_Product__c pp1 = new Promotional_Product__c();
            pp1.Name = 'Testabc1';
            pp1.Product_Name__c = p.id;
            pp1.Current_Month__c = TRUE;
            pp1.Month__c = 'Jan';
            pp1.Financial_Year__c = '2020';
            insert pp1;
          
        String farmerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
        Account acc = new Account( FirstName = 'test',LastName = 'test',PersonMobilePhone='9869457812',
                                  RecordTypeId = farmerRecordTypeId,Decision_Maker__pc = 'Yes',
                                  Crops_Cultivated__pc = 'Fruits/Vegetables',PersonBirthdate = Date.newInstance(1990, 09, 11),
                                  Mobile__c = '9869457812',What_is_your_highest_education_attained__pc = 'Illiterate',
                                  Village__c = village.id,Using_Smart_Phone__c = 'No' ,
                                  Promotional_Product__c = pp1.id ,Village__pc =village.id);
        insert acc;
        
        Account actest = [Select Id, State__c, State__pc, Village__c,Name, Village__r.State__c FROM Account where id = :acc.id ];
        System.debug('AC-QUERY '+actest);
        //
        
        Empanelment__c emp = new Empanelment__c();
        emp.CultivatedCrop__c = 'Cotton';
        emp.SeedTreatmentProduct__c = 'Ulala';
        emp.CultivatedArea__c = 34;
        emp.WaterSource__c = 'Rainfed';
        //emp.SowingDate__c = Date.today();
          emp.SowingDate__c = date.valueOf('2020-02-10');
        emp.Farmer__c = acc.Id;
        insert emp;
        //Empanelment__c empid  = TestDataFactory.CreateEmpanelment();
        Call__c call = new Call__c();
        call.Empanelment__c = emp.Id;
        call.Insect__c = 'Aphid;BacterialBlight' ;
        insert call;
        
        Recommendations__c reco = new Recommendations__c();
        reco.Call__c = call.Id;
        reco.Product__c = 'Iris';
        reco.Dosage__c = '400';
        reco.DosageUnit__c = 'Ml Per Acre';
        insert reco;
        call.isRecommendation__c=true;
        update call;    
        
        Recommendations__c reco1 = new Recommendations__c();
        reco1.Call__c = call.Id;
        reco1.Product__c = 'Jhatka';
        reco1.Dosage__c = '160';
        reco1.DosageUnit__c = 'Gm Per Acre';
        insert reco1;
        
        Recommendations__c reco2 = new Recommendations__c();
        reco2.Call__c = call.Id;
        reco2.Product__c = 'Josh';
        reco2.Dosage__c = '10';
        reco2.DosageUnit__c = 'Ml Per Acre';
        insert reco2;
        
        List<Recommendations__c> listreco = new List<Recommendations__c>();
        listreco.add(reco);
        listreco.add(reco1);
        listreco.add(reco2);
        update listreco;
        //
		Empanelment__c empc = [SELECT ID FROM Empanelment__c LIMIT 1];
           
        Test.startTest();
        NavigateToViewEmp.empanelValues(empc.id);
        Test.stopTest();
		Empanelment__c em = [SELECT Id,Name,CultivatedArea__c, SowingDate__c, CultivatedCrop__c,
                               Farmer__r.Village__pr.State__c,Farmer__r.Id,
                               Farmer__r.Name  FROM Empanelment__c WHERE Id =: empc.Id ]; 
        System.assertEquals('Cotton', em.CultivatedCrop__c);
    	}
}
}