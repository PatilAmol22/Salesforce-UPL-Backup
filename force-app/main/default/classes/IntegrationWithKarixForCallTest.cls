@isTest
public class IntegrationWithKarixForCallTest {
    
    
    @isTest
    static void getCallContentTest(){
        Profile pr = new Profile(name = 'UPL Call Expert');
        Profile prof = [select id from profile where name='UPL Call Expert'];
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1()); 
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
                Postal_Code__c = '443402',
                Fo_Map__c = true);
            insert village;

            /*UPL_Settings__c uplsetting = new UPL_Settings__c();
            uplsetting.Name = 'UPLSetting';
            uplsetting.India_SAS_Sales_Org__c = '1410';
            INSERT uplsetting;*/
            //------------------------------------------

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
            
            SMS_Template__c st = new SMS_Template__c(Name__c= 'Tamil Product Recommendation',Text__c = 'testing.....',ObjectName__c = 'Call');
            insert st;
            /*
String farmerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
Account acc = new Account( FirstName = 'test',LastName = 'test',PersonMobilePhone='9869457812',RecordTypeId = farmerRecordTypeId,Decision_Maker__pc = 'Yes',Crops_Cultivated__pc = 'Fruits/Vegetables',PersonBirthdate = Date.newInstance(1990, 09, 11),Mobile__c = '9869457812',What_is_your_highest_education_attained__pc = 'Illiterate',Village__c = village.id,Using_Smart_Phone__c = 'No' ,
Promotional_Product__c = pp1.id ,Village__pc =village.id);
insert acc;
*/
            Account ac = new Account();
            ac.PersonMobilePhone = '9090909900';
            ac.FirstName = 'Vikas';
            ac.LastName = 'Gupta';
            ac.Promotional_Product__c = pp1.Id;
            //ac.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
            string strrecord = [select id from RecordType where SobjectType='Account' AND IsPersonType=True AND DeveloperName = 'PreRegistered_Farmer' limit 1].id;
            ac.RecordTypeId = strrecord;
            ac.Village__pc = village.Id;
            //ac.Village_Pin_Code_Manual__pc ='234567';
            //ac.State_Language__pc = 'Tamil';
            System.debug('ac.recordtypeid '+ ac.RecordTypeId);
            insert ac;
            
            
            
            
            Empanelment__c emp = new Empanelment__c();
            emp.CultivatedCrop__c = 'Cotton';
            emp.SeedTreatmentProduct__c = 'Ulala';
            emp.CultivatedArea__c = 34;
            emp.WaterSource__c = 'Rainfed';
            //emp.SowingDate__c = Date.today();
            emp.SowingDate__c = date.valueOf('2020-02-10');
            emp.Farmer__c = ac.Id;
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
            
            Call__c call1 = new Call__c();
            call1.Empanelment__c = emp.Id;
            call1.Insect__c = 'Aphid;BacterialBlight' ;
            insert call1;
            
            Recommendations__c reco11 = new Recommendations__c();
            reco11.Call__c = call1.Id;
            reco11.Product__c = 'Jhatka';
            reco11.Dosage__c = '160';
            reco11.DosageUnit__c = 'Gm Per Acre';
            insert reco11;
            
            
            
            
            Test.startTest();
            Account a = [select isPersonAccount,PersonContactId , State_Language__pc from Account where id =:ac.id];
            
            Call__c call2 = new Call__c();
            call2.Empanelment__c = emp.Id;
            call2.Insect__c = 'Aphid;BacterialBlight' ;
            insert call2;
            
            Recommendations__c reco12 = new Recommendations__c();
            reco12.Call__c = call2.Id;
            reco12.Product__c = 'Jhatka';
            reco12.Dosage__c = '160';
            reco12.DosageUnit__c = 'Gm Per Acre';
            insert reco12;
            
            call2.isRecommendation__c = true;
            update call2;
            
            List<Call__c> cal = [SELECT Id, Name FROM Call__c];
            List<id> liId = new List<id>();
            liId.add(call2.Id);
IntegrationWithKarixForCall.getCallContent(liId);
            
            Test.stopTest();
            
        }
       
    }  
    
    @isTest
        static void getCallContentTest1(){
            Profile pr = new Profile(name = 'UPL Call Expert');
        Profile prof = [select id from profile where name='UPL Call Expert'];
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1()); 
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
                Postal_Code__c = '443402',
                Fo_Map__c = true);
            insert village;

            /*UPL_Settings__c uplsetting = new UPL_Settings__c();
            uplsetting.Name = 'UPLSetting';
            uplsetting.India_SAS_Sales_Org__c = '1410';
            INSERT uplsetting;*/
            //------------------------------------------
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
             /*
            SMS_Template__c st = new SMS_Template__c(Name__c= 'Tamil Product Recommendation',Text__c = 'testing.....',ObjectName__c = 'Call');
            insert st;
           
String farmerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
Account acc = new Account( FirstName = 'test',LastName = 'test',PersonMobilePhone='9869457812',RecordTypeId = farmerRecordTypeId,Decision_Maker__pc = 'Yes',Crops_Cultivated__pc = 'Fruits/Vegetables',PersonBirthdate = Date.newInstance(1990, 09, 11),Mobile__c = '9869457812',What_is_your_highest_education_attained__pc = 'Illiterate',Village__c = village.id,Using_Smart_Phone__c = 'No' ,
Promotional_Product__c = pp1.id ,Village__pc =village.id);
insert acc;
*/
            Account ac = new Account();
            ac.PersonMobilePhone = '9090909900';
            ac.FirstName = 'Vikas';
            ac.LastName = 'Gupta';
            ac.Promotional_Product__c = pp1.Id;
            //ac.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PreRegistered Farmer').getRecordTypeId();
            string strrecord = [select id from RecordType where SobjectType='Account' AND IsPersonType=True AND DeveloperName = 'PreRegistered_Farmer' limit 1].id;
            ac.RecordTypeId = strrecord;
            ac.Village__pc = village.Id;
            //ac.Village_Pin_Code_Manual__pc ='234567';
            //ac.State_Language__pc = 'Tamil';
            System.debug('ac.recordtypeid '+ ac.RecordTypeId);
            insert ac;
            
            
            
            
            Empanelment__c emp = new Empanelment__c();
            emp.CultivatedCrop__c = 'Cotton';
            emp.SeedTreatmentProduct__c = 'Ulala';
            emp.CultivatedArea__c = 34;
            emp.WaterSource__c = 'Rainfed';
            //emp.SowingDate__c = Date.today();
            emp.SowingDate__c = date.valueOf('2020-02-10');
            emp.Farmer__c = ac.Id;
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
            
            Call__c call1 = new Call__c();
            call1.Empanelment__c = emp.Id;
            call1.Insect__c = 'Aphid;BacterialBlight' ;
            insert call1;
            
            Recommendations__c reco11 = new Recommendations__c();
            reco11.Call__c = call1.Id;
            reco11.Product__c = 'Jhatka';
            reco11.Dosage__c = '160';
            reco11.DosageUnit__c = 'Gm Per Acre';
            insert reco11;
            
            
            
            
            Test.startTest();
            Account a = [select isPersonAccount,PersonContactId , State_Language__pc from Account where id =:ac.id];
            
            Call__c call2 = new Call__c();
            call2.Empanelment__c = emp.Id;
            call2.Insect__c = 'Aphid;BacterialBlight' ;
            insert call2;
            
            Recommendations__c reco12 = new Recommendations__c();
            reco12.Call__c = call2.Id;
            reco12.Product__c = 'Jhatka';
            reco12.Dosage__c = '160';
            reco12.DosageUnit__c = 'Gm Per Acre';
            insert reco12;
            
            call2.isRecommendation__c = true;
            update call2;
            
               
List<Call__c> cal = [SELECT Id, Name FROM Call__c];
            List<id> liId = new List<id>();
            liId.add(call2.Id);
IntegrationWithKarixForCall.getCallContent(liId);
        
            Test.stopTest();
            
        }
}
}