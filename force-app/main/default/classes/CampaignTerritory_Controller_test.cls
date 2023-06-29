@isTest
public class CampaignTerritory_Controller_test{
   
    static testmethod void method1(){
                
        User u2 = new User(
         ProfileId = [select id from profile where name ='Regional Sales Manager'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US',
         isActive = true
         );  
         insert u2;
         
         User u = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Mangers'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US',
         isActive = true
         );  
         insert u;
         
          
         User u1 = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
         );  
         insert u1;
         
          User u3 = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
         );  
         insert u3;
         
         Sales_Org__c salorg = new Sales_Org__c();
         salorg.name = 'India';
         salorg.Sales_Org_Code__c = '1000';
         insert salorg; 
         
         Zone__c sobj2 = new Zone__c(
  Name = 'Pune',                  // Zone Name
  SalesOrg__c =salorg.id,  // Sales Org
  ZoneCode__c = 'SWZ08',
  ZMMUser__c= u2.id            // Zone Code
);
insert sobj2;
         
         Region__c sobj1 = new Region__c(
  Name = 'PUNE',                  // Region Name
  RegionCode__c = 'SW017',          // Region Code
  SalesOrg__c = salorg.id,
  RegionHead__c = u.id,
    // Sales Org
  Zone__c = sobj2.id      // Zone
);
insert sobj1;

         Territory_Distributor__c territory = new Territory_Distributor__c();
         territory.Name = 'Narayangaon';
         territory.TerritoryManager__c = u1.id;
         territory.TerritoryCode__c = '397';
         territory.Region__c = sobj1.id;
         territory.SalesOrg__c = salorg.id;
         territory.Zone__c = sobj2.id;
         territory.Present_in_KEDE__c = true;
         territory.Neglected__c = false;
         insert territory;
         
         Territory_Distributor__c territory1 = new Territory_Distributor__c();
         territory1.Name = 'Akola';
         territory1.TerritoryManager__c = u3.id;
         territory1.TerritoryCode__c = '39';
         territory1.Region__c = sobj1.id;
          territory1.SalesOrg__c = salorg.id;
          territory1.Zone__c = sobj2.id;
          territory1.Present_in_KEDE__c = true;
         territory1.Neglected__c = false;
         insert territory1;
         
         State__c state = new State__c(
          Name = 'Maharashtra',   // State Name
          State_Code__c = 'IN/13',  // State Code
          Country__c = 'India',     // Country
          Active__c = true);
          insert state;
         
         District__c sobj = new District__c(
              Name = 'Adilabad',           // District Name
              District_Code__c = '532',      // District Code
              State__c = state.id,  // State
              Active__c = true              // Active
              );
         insert sobj;
                  
         Tehsil__c teh = new Tehsil__c();
         teh.Name = 'Sangamner';
         teh.Territory__c = territory.id;
         teh.District__c = sobj.id;
         insert teh;
          
         Crop__c crp = new Crop__c();
         crp.name = 'Apple';
         crp.SalesOrg__c = salorg.id;
         insert crp; 
         
         Product2 prodct = new Product2(
          Name = 'MICRONUTRIENT',              // Product Name
          ProductCode = '25201',                 // Product Code
          Product_Code__c = '25201',             // Product Code
          Sales_Org__c = salorg.id,              // Sales Org
          Combination_Key__c = '2520112102092'  // Combination Key
                  );
        insert prodct; 
        
         Campaign_Day__c campdayrec1 = new Campaign_Day__c();
         campdayrec1.Name = '7';
         campdayrec1.Day__c = 7;
         insert campdayrec1;
     
         Campaign_Day__c campdayrec2 = new Campaign_Day__c();
         campdayrec2.Name = '15';
         campdayrec2.Day__c = 15;
         insert campdayrec2;
        
         Campaign_Day__c campdayrec3 = new Campaign_Day__c();
         campdayrec3.Name = '21';
         campdayrec3.Day__c = 21;
         insert campdayrec3;
         
         Target_Weed__c targWd1 = new Target_Weed__c();
         targWd1.name = 'BLWs';
         insert targWd1;
        
         Target_Weed__c targWd2 = new Target_Weed__c();
         targWd2.name = 'Grasses';
         insert targWd2;
        
         Target_Weed__c targWd3 = new Target_Weed__c();
         targWd3.name = 'Sedges';
         insert targWd3; 
         
         Treatment__c treatmnt1 = new Treatment__c();
         treatmnt1.name = 'Untreated Control';
         insert treatmnt1 ;
        
         Treatment__c treatmnt2 = new Treatment__c();
         treatmnt2.name = 'Farmers Practice';
         insert treatmnt2 ;
        
         Treatment__c treatmnt3 = new Treatment__c();
         treatmnt3.name = 'UPL Product';
         insert treatmnt3 ;
           system.runAs(u2){
              Campaign  camobj = new Campaign();     
              camobj.Name = 'Test campign';
              camobj.Product_Name__c = prodct.id;
              camobj.Target_Weed_1__c = targWd1.id;
              camobj.Target_Weed_2__c = targWd2.id;
              camobj.Target_Weed_3__c = targWd3.id;
              camobj.Treatment_1__c = treatmnt1.id;
              camobj.Treatment_2__c = treatmnt2.id;
              camobj.Treatment_3__c = treatmnt3.id;
              camobj.Treatment_1_Dose__c = 1000;
              camobj.Treatment_2_Dose_ml_acre__c = 800;  
              camobj.Treatment_3_Dose_ml_acre__c = 2000;
              camobj.Campaign_Day_1__c = campdayrec1.id;
              camobj.Campaign_Day_2__c = campdayrec2.id;
              camobj.Campaign_Day_3__c = campdayrec3.id;  
            
              insert camobj;
               
           Campaign_user_Mapping__c camUserMapobj = new Campaign_user_Mapping__c(
           User__c = u1.id,    // User
           Campaign__c = camobj.id,   // Campaign
           Checked_Zonal_User__c = false     // Checked Zonal User
            );
            insert camUserMapobj;
           
           system.debug('u2.id>>----->'+u2.id);
           system.debug('camobj.id>>------>'+camobj.id);
          
          
           ApexPages.StandardController sc = new ApexPages.StandardController(camobj);
           CampaignTerritory_Controller campTerrObj = new CampaignTerritory_Controller(sc);
           campTerrObj.save1();
           
         }
         
          system.runAs(u2){
              Campaign  camobj1 = new Campaign();     
              camobj1.Name = 'Test campign';
              camobj1.Product_Name__c = prodct.id;
              camobj1.Target_Weed_1__c = targWd1.id;
              camobj1.Target_Weed_2__c = targWd2.id;
              camobj1.Target_Weed_3__c = targWd3.id;
              camobj1.Treatment_1__c = treatmnt1.id;
              camobj1.Treatment_2__c = treatmnt2.id;
              camobj1.Treatment_3__c = treatmnt3.id;
              camobj1.Treatment_1_Dose__c = 1000;
              camobj1.Treatment_2_Dose_ml_acre__c = 800;  
              camobj1.Treatment_3_Dose_ml_acre__c = 2000;
              camobj1.Campaign_Day_1__c = campdayrec1.id;
              camobj1.Campaign_Day_2__c = campdayrec2.id;
              camobj1.Campaign_Day_3__c = campdayrec3.id;  
            
              insert camobj1;
               
           Campaign_user_Mapping__c camUserMapobj1 = new Campaign_user_Mapping__c(
           User__c = u1.id,    // User
           Campaign__c = camobj1.id,   // Campaign
           Checked_Zonal_User__c = false     // Checked Zonal User
            );
            insert camUserMapobj1;
           
           system.debug('u2.id>>----->'+u2.id);
           system.debug('camobj.id>>------>'+camobj1.id);
          
          
           ApexPages.StandardController sc1 = new ApexPages.StandardController(camobj1);
           CampaignTerritory_Controller campTerrObj1 = new CampaignTerritory_Controller(sc1);
           system.debug('territory>>----->'+territory);
           campTerrObj1.assignTerties.put(territory.id,territory);
           campTerrObj1.assignTerties.put(territory1.id,territory1);
           campTerrObj1.territories.add(territory1);
           campTerrObj1.selectedTerritories.add(new selectoption(territory.id,territory.Name));
           campTerrObj1.save1();
           
         }
         
          system.runAs(u){
              Campaign  camobj1 = new Campaign();     
              camobj1.Name = 'Test campign';
              camobj1.Product_Name__c = prodct.id;
              camobj1.Target_Weed_1__c = targWd1.id;
              camobj1.Target_Weed_2__c = targWd2.id;
              camobj1.Target_Weed_3__c = targWd3.id;
              camobj1.Treatment_1__c = treatmnt1.id;
              camobj1.Treatment_2__c = treatmnt2.id;
              camobj1.Treatment_3__c = treatmnt3.id;
              camobj1.Treatment_1_Dose__c = 1000;
              camobj1.Treatment_2_Dose_ml_acre__c = 800;  
              camobj1.Treatment_3_Dose_ml_acre__c = 2000;
              camobj1.Campaign_Day_1__c = campdayrec1.id;
              camobj1.Campaign_Day_2__c = campdayrec2.id;
              camobj1.Campaign_Day_3__c = campdayrec3.id;  
            
              insert camobj1;
               
           Campaign_user_Mapping__c camUserMapobj1 = new Campaign_user_Mapping__c(
           User__c = u1.id,    // User
           Campaign__c = camobj1.id,   // Campaign
           Checked_Zonal_User__c = false     // Checked Zonal User
            );
            insert camUserMapobj1;
           
           system.debug('u2.id>>----->'+u2.id);
           system.debug('camobj.id>>------>'+camobj1.id);
          
          
           ApexPages.StandardController sc1 = new ApexPages.StandardController(camobj1);
           CampaignTerritory_Controller campTerrObj1 = new CampaignTerritory_Controller(sc1);
           system.debug('territory>>----->'+territory);
           campTerrObj1.assignTerties.put(territory.id,territory);
           campTerrObj1.assignTerties.put(territory1.id,territory1);
           campTerrObj1.territories.add(territory1);
           campTerrObj1.selectedTerritories.add(new selectoption(territory.id,territory.Name));
           campTerrObj1.save1();
           
         }
    }
    
     static testmethod void method2(){
                
        User u2 = new User(
         ProfileId = [select id from profile where name ='Regional Sales Manager'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US',
         isActive = true
         );  
         insert u2;
         
         User u = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Mangers'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US',
         isActive = true
         );  
         insert u;
         
          
         User u1 = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
         );  
         insert u1;
         
          User u3 = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
         );  
         insert u3;
         
         Sales_Org__c salorg = new Sales_Org__c();
         salorg.name = 'India';
         salorg.Sales_Org_Code__c = '1000';
         insert salorg; 
        
         Zone__c sobj2 = new Zone__c(
  Name = 'Pune',                  // Zone Name
  SalesOrg__c =salorg.id,  // Sales Org
  ZoneCode__c = 'SWZ08',
  ZMMUser__c= u2.id            // Zone Code
);
insert sobj2;
         
         Region__c sobj1 = new Region__c(
  Name = 'PUNE',                  // Region Name
  RegionCode__c = 'SW017',          // Region Code
  SalesOrg__c = salorg.id,  // Sales Org
  Zone__c = sobj2.id      // Zone
);
insert sobj1;

         Territory_Distributor__c territory = new Territory_Distributor__c();
         territory.Name = 'Narayangaon';
         territory.TerritoryManager__c = u1.id;
         territory.TerritoryCode__c = '397';
         territory.Region__c = sobj1.id;
         territory.Zone__c = sobj2.id;
         territory.Present_in_KEDE__c = true;
         territory.Neglected__c = false;
         insert territory;
         
         Territory_Distributor__c territory1 = new Territory_Distributor__c();
         territory1.Name = 'Akola';
         territory1.TerritoryManager__c = u3.id;
         territory1.TerritoryCode__c = '39';
         territory1.Region__c = sobj1.id;
         territory1.Zone__c = sobj2.id;
         territory1.Present_in_KEDE__c = true;
         territory1.Neglected__c = false;
         insert territory1;
         

         Territory_Distributor__c territory2 = new Territory_Distributor__c();
         territory2.Name = 'Akola';
         territory2.TerritoryManager__c = u3.id;
         territory2.TerritoryCode__c = '394';
         insert territory2;
         
         State__c state = new State__c(
          Name = 'Maharashtra',   // State Name
          State_Code__c = 'IN/13',  // State Code
          Country__c = 'India',     // Country
          Active__c = true);
          insert state;
         
         District__c sobj = new District__c(
              Name = 'Adilabad',           // District Name
              District_Code__c = '532',      // District Code
              State__c = state.id,  // State
              Active__c = true              // Active
              );
         insert sobj;
                  
         Tehsil__c teh = new Tehsil__c();
         teh.Name = 'Sangamner';
         teh.Territory__c = territory.id;
         teh.District__c = sobj.id;
         insert teh;
          
         Crop__c crp = new Crop__c();
         crp.name = 'Apple';
         crp.SalesOrg__c = salorg.id;
         insert crp; 
         
         Product2 prodct = new Product2(
          Name = 'MICRONUTRIENT',              // Product Name
          ProductCode = '25201',                 // Product Code
          Product_Code__c = '25201',             // Product Code
          Sales_Org__c = salorg.id,              // Sales Org
          Combination_Key__c = '2520112102092'  // Combination Key
                  );
        insert prodct; 
        
         Campaign_Day__c campdayrec1 = new Campaign_Day__c();
         campdayrec1.Name = '7';
         campdayrec1.Day__c = 7;
         insert campdayrec1;
     
         Campaign_Day__c campdayrec2 = new Campaign_Day__c();
         campdayrec2.Name = '15';
         campdayrec2.Day__c = 15;
         insert campdayrec2;
        
         Campaign_Day__c campdayrec3 = new Campaign_Day__c();
         campdayrec3.Name = '21';
         campdayrec3.Day__c = 21;
         insert campdayrec3;
         
         Target_Weed__c targWd1 = new Target_Weed__c();
         targWd1.name = 'BLWs';
         insert targWd1;
        
         Target_Weed__c targWd2 = new Target_Weed__c();
         targWd2.name = 'Grasses';
         insert targWd2;
        
         Target_Weed__c targWd3 = new Target_Weed__c();
         targWd3.name = 'Sedges';
         insert targWd3; 
         
         Treatment__c treatmnt1 = new Treatment__c();
         treatmnt1.name = 'Untreated Control';
         insert treatmnt1 ;
        
         Treatment__c treatmnt2 = new Treatment__c();
         treatmnt2.name = 'Farmers Practice';
         insert treatmnt2 ;
        
         Treatment__c treatmnt3 = new Treatment__c();
         treatmnt3.name = 'UPL Product';
         insert treatmnt3 ;
           
                  
          system.runAs(u){
              Campaign  camobj1 = new Campaign();     
              camobj1.Name = 'Test campign';
              camobj1.Product_Name__c = prodct.id;
              camobj1.Target_Weed_1__c = targWd1.id;
              camobj1.Target_Weed_2__c = targWd2.id;
              camobj1.Target_Weed_3__c = targWd3.id;
              camobj1.Treatment_1__c = treatmnt1.id;
              camobj1.Treatment_2__c = treatmnt2.id;
              camobj1.Treatment_3__c = treatmnt3.id;
              camobj1.Treatment_1_Dose__c = 1000;
              camobj1.Treatment_2_Dose_ml_acre__c = 800;  
              camobj1.Treatment_3_Dose_ml_acre__c = 2000;
              camobj1.Campaign_Day_1__c = campdayrec1.id;
              camobj1.Campaign_Day_2__c = campdayrec2.id;
              camobj1.Campaign_Day_3__c = campdayrec3.id;  
            
              insert camobj1;
               
           Campaign_user_Mapping__c camUserMapobj1 = new Campaign_user_Mapping__c(
           User__c = u1.id,    // User
           Campaign__c = camobj1.id,   // Campaign
           Checked_Zonal_User__c = false     // Checked Zonal User
            );
            insert camUserMapobj1;
         
         Campaign_user_Mapping__c camUserMapobj2 = new Campaign_user_Mapping__c(
           User__c = u3.id,    // User
           Campaign__c = camobj1.id,   // Campaign
           Checked_Zonal_User__c = false     // Checked Zonal User
            );
            insert camUserMapobj2;
         
           
           system.debug('u2.id>>----->'+u2.id);
           system.debug('camobj.id>>------>'+camobj1.id);
          
          
           ApexPages.StandardController sc1 = new ApexPages.StandardController(camobj1);
           CampaignTerritory_Controller campTerrObj1 = new CampaignTerritory_Controller(sc1);
           system.debug('territory>>----->'+territory);
           campTerrObj1.assignTerties.put(territory.id,territory);
           campTerrObj1.assignTerties.put(territory1.id,territory1);
           //campTerrObj1.campaignId = camobj1.id;
           campTerrObj1.territories.add(territory2);
           campTerrObj1.selectedTerritories.add(new selectoption(territory.id,territory.Name));
           campTerrObj1.save1();
           
         }
    }
     static testmethod void method3(){
     
         User u2 = new User(
         ProfileId = [select id from profile where name ='Regional Sales Manager'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US',
         isActive = true
         );  
         insert u2;
         
         User u = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Mangers'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US',
         isActive = true
         );  
         insert u;
         
          
         User u1 = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
         );  
         insert u1;
         
          User u3 = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
         );  
         insert u3;
         
     
              Sales_Org__c salorg = new Sales_Org__c();
         salorg.name = 'India';
         salorg.Sales_Org_Code__c = '1000';
         insert salorg; 
         
         Zone__c sobj2 = new Zone__c(
  Name = 'Pune',                  // Zone Name
  SalesOrg__c =salorg.id,  // Sales Org
  ZoneCode__c = 'SWZ08',
  ZMMUser__c= u2.id            // Zone Code
);
insert sobj2;
         
         Region__c sobj1 = new Region__c(
  Name = 'PUNE',                  // Region Name
  RegionCode__c = 'SW017',          // Region Code
  SalesOrg__c = salorg.id,
  RegionHead__c = u.id,
    // Sales Org
  Zone__c = sobj2.id      // Zone
);
insert sobj1;

         Territory_Distributor__c territory = new Territory_Distributor__c();
         territory.Name = 'Narayangaon';
         territory.TerritoryManager__c = u1.id;
         territory.TerritoryCode__c = '397';
         territory.Region__c = sobj1.id;
         territory.SalesOrg__c = salorg.id;
         territory.Zone__c = sobj2.id;
         territory.Present_in_KEDE__c = true;
         territory.Neglected__c = false;
         insert territory;
         
         Territory_Distributor__c territory1 = new Territory_Distributor__c();
         territory1.Name = 'Akola';
         territory1.TerritoryManager__c = u3.id;
         territory1.TerritoryCode__c = '39';
         territory1.Region__c = sobj1.id;
          territory1.SalesOrg__c = salorg.id;
          territory1.Zone__c = sobj2.id;
          territory1.Present_in_KEDE__c = true;
         territory1.Neglected__c = false;
         insert territory1;
         
         State__c state = new State__c(
          Name = 'Maharashtra',   // State Name
          State_Code__c = 'IN/13',  // State Code
          Country__c = 'India',     // Country
          Active__c = true);
          insert state;
         
         District__c sobj = new District__c(
              Name = 'Adilabad',           // District Name
              District_Code__c = '532',      // District Code
              State__c = state.id,  // State
              Active__c = true              // Active
              );
         insert sobj;
                  
         Tehsil__c teh = new Tehsil__c();
         teh.Name = 'Sangamner';
         teh.Territory__c = territory.id;
         teh.District__c = sobj.id;
         insert teh;
          
         Crop__c crp = new Crop__c();
         crp.name = 'Apple';
         crp.SalesOrg__c = salorg.id;
         insert crp; 
         
         Product2 prodct = new Product2(
          Name = 'MICRONUTRIENT',              // Product Name
          ProductCode = '25201',                 // Product Code
          Product_Code__c = '25201',             // Product Code
          Sales_Org__c = salorg.id,              // Sales Org
          Combination_Key__c = '2520112102092'  // Combination Key
                  );
        insert prodct; 
        
         Campaign_Day__c campdayrec1 = new Campaign_Day__c();
         campdayrec1.Name = '7';
         campdayrec1.Day__c = 7;
         insert campdayrec1;
     
         Campaign_Day__c campdayrec2 = new Campaign_Day__c();
         campdayrec2.Name = '15';
         campdayrec2.Day__c = 15;
         insert campdayrec2;
        
         Campaign_Day__c campdayrec3 = new Campaign_Day__c();
         campdayrec3.Name = '21';
         campdayrec3.Day__c = 21;
         insert campdayrec3;
         
         Target_Weed__c targWd1 = new Target_Weed__c();
         targWd1.name = 'BLWs';
         insert targWd1;
        
         Target_Weed__c targWd2 = new Target_Weed__c();
         targWd2.name = 'Grasses';
         insert targWd2;
        
         Target_Weed__c targWd3 = new Target_Weed__c();
         targWd3.name = 'Sedges';
         insert targWd3; 
         
         Treatment__c treatmnt1 = new Treatment__c();
         treatmnt1.name = 'Untreated Control';
         insert treatmnt1 ;
        
         Treatment__c treatmnt2 = new Treatment__c();
         treatmnt2.name = 'Farmers Practice';
         insert treatmnt2 ;
        
         Treatment__c treatmnt3 = new Treatment__c();
         treatmnt3.name = 'UPL Product';
         insert treatmnt3 ;
         
         Campaign_Unit_Cost__c cucost = new Campaign_Unit_Cost__c();
         cucost.AudioVideoCDsPerUnitCost__c = 200;
         cucost.BannersPerUnitCost__c = 200;
         cucost.BrochuresPerUnitCost__c = 300;
         cucost.DanglersPerUnitCost__c = 100;
         cucost.DemosPerUnitCost__c = 400;
         cucost.JeepPerUnitCost__c = 500;
         cucost.Leaflets_Per_Unit_Cost__c = 600; 
         cucost.PostersPerUnitCost__c = 400;
          
         insert cucost;
  
              Campaign  camobj1 = new Campaign();     
              camobj1.Name = 'Test campign';
              camobj1.Product_Name__c = prodct.id;
              camobj1.Target_Weed_1__c = targWd1.id;
              camobj1.Target_Weed_2__c = targWd2.id;
              camobj1.Target_Weed_3__c = targWd3.id;
              camobj1.Treatment_1__c = treatmnt1.id;
              camobj1.Treatment_2__c = treatmnt2.id;
              camobj1.Treatment_3__c = treatmnt3.id;
              camobj1.Treatment_1_Dose__c = 1000;
              camobj1.Treatment_2_Dose_ml_acre__c = 800;  
              camobj1.Treatment_3_Dose_ml_acre__c = 2000;
              camobj1.Campaign_Day_1__c = campdayrec1.id;
              camobj1.Campaign_Day_2__c = campdayrec2.id;
              camobj1.Campaign_Day_3__c = campdayrec3.id; 
              camobj1.Leaflets_per_unit_cost__c = 120;
              camobj1.Jeep_per_unit_cost__c = 1500;
              camobj1.Demos_per_unit_cost__c = 300;
              camobj1.Banners_per_unit_cost__c = 900;
              camobj1.Danglers_per_unit_cost__c = 200;
              camobj1.Audio_Video_CD_s_per_unit_cost__c = 50;
              camobj1.Posters_per_unit_cost__c = 150;
              camobj1.Brochures_per_unit_cost__c = 100; 
            
              insert camobj1;
              
              
              
              Promotional_Input_Requirements__c pr = new Promotional_Input_Requirements__c(
  Campaign_Name__c =camobj1.id ,       // Campaign Name
  No_of_Villages__c = 100,                      // No. of Villages
  No_of_Demos_Per_Village__c = 3,               // No. of Demos Per Territory
  No_of_Jeep_Campaign_Per_Village__c = 10,      // No. of Jeep Campaign Days
  No_of_Farmer_Meetings_Per_Territory__c = 10,  // No. of Farmer Meetings Per Territory
  No_of_Dealer_Meetings_Per_Territory__c = 10,  // No. of Dealer Meetings Per Territory
  No_of_Leaflets_Per_Village__c = 10,           // No. of Leaflets Per Village
  No_of_Audio_Video_CD_s_per_Village__c = 10,   // No. of Audio/Video CD's Per Territory
  No_of_Posters_Per_Village__c = 20,            // No. of Posters Per Village
  No_of_Brochures_Per_Village__c = 10,          // No. of Brochures Per Village
  No_of_Danglers_Per_Village__c = 15,           // No. of Danglers Per Village
  No_of_Banners_per_Village__c = 10,            // No. of Banners Per Village
  No_of_Farmers_Per_Village__c = 10            // No. of Farmers Per Village
);
insert pr;
        List<Promotional_Input_Requirements__c> prObj =  new List<Promotional_Input_Requirements__c>();
         prObj = [SELECT Id, No_of_Banners_per_Village__c, No_of_Audio_Video_CD_s_per_Village__c, No_of_Brochures_Per_Village__c, No_of_Danglers_Per_Village__c, No_of_Dealer_Meetings_Per_Territory__c, No_of_Demos_Per_Village__c,
                          No_of_Farmer_Meetings_Per_Territory__c, No_of_Farmers_Per_Village__c, Campaign_Name__c, No_of_Leaflets_Per_Village__c, No_of_Jeep_Campaign_Per_Village__c, No_of_Posters_Per_Village__c, No_of_Video_CD_s_Per_Village__c,
                          No_of_Villages__c, Total_No_of_Audio_CD_s__c, Total_No_of_Banners__c, Total_No_of_Brochures__c, Total_No_of_Danglers__c, Total_No_of_Demos__c, Total_No_of_Farmers__c, Total_No_of_Jeep_Campaigns__c, Total_No_of_Leaflets__c, Total_No_of_Posters__c
                          FROM Promotional_Input_Requirements__c Where Id= :pr.Id ];
         system.debug('Promotional_Input_Requirements__c ===> '+prObj);
         system.debug('Promotional_Input_Requirements__c ===> '+pr);
              
           ApexPages.StandardController sc1 = new ApexPages.StandardController(camobj1);
           CampaignRollUp  campTerrObj1 = new CampaignRollUp(sc1);
     
     }
}