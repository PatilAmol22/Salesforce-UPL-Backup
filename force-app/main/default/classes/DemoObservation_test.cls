@isTest
public class DemoObservation_test{
         static string retURL;
         static testmethod void method1(){
         
         User u2 = new User(
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
         insert u2;
         
                  
         Sales_Org__c salorg = new Sales_Org__c();
         salorg.name = 'India';
         salorg.Sales_Org_Code__c = '1000';
         salorg.Continent__c = 'Europe';
         insert salorg; 
        
         Territory_Distributor__c territory = new Territory_Distributor__c();
         territory.Name = 'Narayangaon';
         territory.TerritoryManager__c = u2.id;
         territory.TerritoryCode__c = '397';
         insert territory;
         
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
          Sales_Org__c = salorg.id,      // Sales Org
          Combination_Key__c = '2520112102092'  // Combination Key
          );
        insert prodct;
        
         Campaign_Day__c campdayrec1 = new Campaign_Day__c();
         campdayrec1.name = '7';
         campdayrec1.Day__c = 7;
         insert campdayrec1;
     
         Campaign_Day__c campdayrec2 = new Campaign_Day__c();
          campdayrec2.name = '15';
         campdayrec2.Day__c = 15;
         insert campdayrec2;
        
         Campaign_Day__c campdayrec3 = new Campaign_Day__c();
          campdayrec3.name = '21';
         campdayrec3.Day__c = 21;
         insert campdayrec3;
         
          Campaign_Day__c campdayrec4 = new Campaign_Day__c();
          campdayrec4.name = '25';
         campdayrec4.Day__c = 25;
         insert campdayrec4;
         
          Campaign_Day__c campdayrec5 = new Campaign_Day__c();
          campdayrec5.name = '26';
         campdayrec5.Day__c = 26;
         insert campdayrec5;
         
         Target_Weed__c targWd1 = new Target_Weed__c();
         targWd1.Category__c = 'Biologicals and Nutrition,Insecticides,ST';  // Category
         targWd1.Crop__c = 'Apple';    
         targWd1.name = 'Termite';
         insert targWd1;
        
         Target_Weed__c targWd2 = new Target_Weed__c();
         targWd2.Category__c = 'Biologicals and Nutrition';  // Category
         targWd2.Crop__c = 'Banana';
         targWd2.name = 'Mites';
         insert targWd2;
        
         Target_Weed__c targWd3 = new Target_Weed__c();
         targWd3.Category__c = 'Insecticides,ST';  // Category
         targWd3.Crop__c = 'potato';
         targWd3.name = 'Nematodes';
         insert targWd3; 
         
          Target_Weed__c targWd4 = new Target_Weed__c();
         targWd4.Category__c = 'Biologicals and Nutrition,ST';  // Category
         targWd4.Crop__c = 'pineapple';
         targWd4.name = 'Grey mildew';
         insert targWd4; 
         
         Target_Weed__c targWd5 = new Target_Weed__c();
         targWd5.Category__c = 'Biologicals and Nutrition,Insecticides,ST';  // Category
         targWd5.Crop__c = 'Mango';
         targWd5.name = 'Aphids';
         insert targWd5; 
         
         Treatment__c treatmnt1 = new Treatment__c();
         treatmnt1.name = 'Untreated Control';
         insert treatmnt1 ;
        
         Treatment__c treatmnt2 = new Treatment__c();
         treatmnt2.name = 'Farmers Practice';
         insert treatmnt2 ;
        
         Treatment__c treatmnt3 = new Treatment__c();
         treatmnt3.name = 'UPL Product';
         insert treatmnt3 ;
         
         Treatment__c treatmnt4 = new Treatment__c();
         treatmnt4.name = 'UPL Product1';
         insert treatmnt4 ;
         
         Treatment__c treatmnt5 = new Treatment__c();
         treatmnt5.name = 'UPL Product2';
         insert treatmnt5;
         
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
           Campaign_Crop_Mapping__c camCrpMap = new Campaign_Crop_Mapping__c(
              Campaign__c = camobj.id,      // Campaign
              Crop__c = 'Apple',                     // Crop
              Category__c = 'Insecticides',           // Category
              Campaign_Day_1__c = campdayrec1.id,
              Campaign_Day_2__c = campdayrec2.id, 
              Campaign_Day_3__c = campdayrec3.id, 
              Campaign_Day_4__c = campdayrec4.id, 
              Campaign_Day_5__c = campdayrec5.id,  // Days after application(DAA) 1
              Target_Weed_1__c = targWd1.id, 
              Target_Weed_2__c = targWd2.id,
              Target_Weed_3__c = targWd3.id, 
              Target_Weed_4__c = targWd4.id,      // Target Pest 1
              Target_Weed_5__c = targWd5.id,  
              Treatment_1__c = treatmnt1.id,     // Treatment 1
              Treatment_1_Dose_ml_acre__c = 200,      // Treatment 1 (Dose: ml/acre)
              Treatment_2__c = treatmnt2.id,     // Treatment 2
              Treatment_2_Dose_ml_acre__c = 3000,     // Treatment 2 (Dose: ml/acre)
              Treatment_3__c = treatmnt3.id,     // Treatment 3
              Treatment_3_Dose_ml_acre__c = 400,      // Treatment 3 (Dose: ml/acre)
               Treatment_4__c = treatmnt4.id,     // Treatment 3
              Treatment_4_Dose_ml_acre__c = 400,
               Treatment_5__c = treatmnt5.id,     // Treatment 3
              Treatment_5_Dose_ml_acre__c = 400
              );
                insert camCrpMap;
           Demo_Observations__c demoObservObj = new Demo_Observations__c(Farmer_Name__c='ketan',Contact_Number__c = '1010120225',Campaign_Name__c=camobj.id ,Crop__c =crp.id, Address__c = teh.id);
           insert demoObservObj;
           ApexPages.StandardController sc = new ApexPages.StandardController(demoObservObj);
           DemoObservation demoObserobj  = new DemoObservation(sc);
           demoObserobj.productOrCrop = prodct.Name;
           demoObserobj.lstofCrops.add(camCrpMap); 
            demoObserobj.cropfilterObservation();
           demoObserobj.lstoftehsil.add(teh);
           demoObserobj.saveobs();
           demoObserobj.cancelDemoObser();
           
           }
           
           
         
    }
        static TestMethod void method2(){
         
          User u2 = new User(
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
         insert u2;
         
                  
         Sales_Org__c salorg = new Sales_Org__c();
         salorg.name = 'India';
         salorg.Sales_Org_Code__c = '1000';
         salorg.Continent__c = 'Europe';
         insert salorg; 
        
         Territory_Distributor__c territory = new Territory_Distributor__c();
         territory.Name = 'Narayangaon';
         territory.TerritoryManager__c = u2.id;
         territory.TerritoryCode__c = '397';
         insert territory;
         
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
          Sales_Org__c = salorg.id,      // Sales Org
          Combination_Key__c = '2520112102092'  // Combination Key
          );
        insert prodct;
        
        Campaign_Day__c campdayrec1 = new Campaign_Day__c();
         campdayrec1.name = '7';
         campdayrec1.Day__c = 7;
         insert campdayrec1;
     
         Campaign_Day__c campdayrec2 = new Campaign_Day__c();
          campdayrec2.name = '15';
         campdayrec2.Day__c = 15;
         insert campdayrec2;
        
         Campaign_Day__c campdayrec3 = new Campaign_Day__c();
          campdayrec3.name = '21';
         campdayrec3.Day__c = 21;
         insert campdayrec3;
         
         
         Target_Weed__c targWd1 = new Target_Weed__c();
         targWd1.Category__c = 'Biologicals and Nutrition,Insecticides,ST';  // Category
         targWd1.Crop__c = 'Apple';    
         targWd1.name = 'Termite';
         insert targWd1;
        
         Target_Weed__c targWd2 = new Target_Weed__c();
         targWd2.Category__c = 'Biologicals and Nutrition,Insecticides,ST';  // Category
         targWd2.Crop__c = 'Apple';
         targWd2.name = 'Mites';
         insert targWd2;
        
         Target_Weed__c targWd3 = new Target_Weed__c();
         targWd3.Category__c = 'Biologicals and Nutrition,Insecticides,ST';  // Category
         targWd3.Crop__c = 'Apple';
         targWd3.name = 'Nematodes';
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
           
           Campaign_Crop_Mapping__c camCrpMap = new Campaign_Crop_Mapping__c(
              Campaign__c = camobj.id,      // Campaign
              Crop__c = 'Apple',                     // Crop
              Category__c = 'Insecticides',           // Category
              Campaign_Day_1__c = campdayrec1.id,  // Days after application(DAA) 1
              Target_Weed_1__c = targWd1.id,   // Target Pest 1
              Campaign_Day_2__c = campdayrec2.id,  // Days after application(DAA) 2
              Target_Weed_2__c = targWd2.id,   // Target Pest 2
              Treatment_1__c = treatmnt1.id,     // Treatment 1
              Treatment_1_Dose_ml_acre__c = 200,      // Treatment 1 (Dose: ml/acre)
              Treatment_2__c = treatmnt2.id,     // Treatment 2
              Treatment_2_Dose_ml_acre__c = 3000,     // Treatment 2 (Dose: ml/acre)
              Treatment_3__c = treatmnt3.id,     // Treatment 3
              Treatment_3_Dose_ml_acre__c = 400      // Treatment 3 (Dose: ml/acre)
              );
                insert camCrpMap;
           Test.setCurrentPageReference(new PageReference('Page.myPage'));
           System.currentPageReference().getParameters().put(camobj.id,retURL);
           Demo_Observations__c demoObservObj = new Demo_Observations__c(Campaign_Name__c=camobj.id);
           //demoObservObj.Campaign_Name__c = camobj.id;
           insert demoObservObj;
           ApexPages.StandardController sc = new ApexPages.StandardController(demoObservObj);
           DemoObservation demoObserobj  = new DemoObservation(sc);
           demoObserobj.productOrCrop = prodct.Name;
           demoObserobj.lstofCrops.add(camCrpMap); 
           demoObserobj.lstoftehsil.add(teh);
           //demoObserobj.cropfilterObservation();
           demoObserobj.saveobs();
           demoObserobj.cancelDemoObser();
           
       
        }
        }
 }