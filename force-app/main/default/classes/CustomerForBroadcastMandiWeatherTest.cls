@isTest
public class CustomerForBroadcastMandiWeatherTest {
    
    static testMethod void testData(){
        Profile pr = new Profile(name = 'UPL Call Expert');
        Profile prof = [select id from profile where name='UPL Call Expert'];
        
        Engagely_Settings__c eng = new Engagely_Settings__c();
        eng.Feedback_URL__c = 'https://botbuilder.engagely.ai/upl/notification/feedbackmessage';
        eng.Password__c = 'USGUf3CF';
        eng.Product_URL__c = 'https://botbuilder.engagely.ai/upl/notification/productreview';
        eng.Name = 'Engagely Credentials';
        eng.wrmsURL__c = 'https://botbuilder.engagely.ai/upl/notification/wrmsreport/userlist';
        eng.User_Name__c = 'upl-ltd';
        insert eng;
        
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
            State__c state = new State__c(Name = 'Maharashtra',Language__c = 'Marathi');
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
            
            String farmerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SWAL Farmer').getRecordTypeId();
            Account acc = new Account( FirstName = 'test',LastName = 'test',PersonMobilePhone='9869457812',SMS_Voice_Msg_Call_Consent__pc = 'Yes', Village_Pin_Code_Manual__pc = '422009',RecordTypeId = farmerRecordTypeId,Decision_Maker__pc = 'Yes',Crops_Cultivated__pc = 'Fruits/Vegetables',PersonBirthdate = Date.newInstance(1990, 09, 11),Mobile__c = '9869457812',What_is_your_highest_education_attained__pc = 'Illiterate',Village__c = village.id,Using_Smart_Phone__c = 'No' ,
                                      Promotional_Product__c = pp1.id ,Village__pc =village.id);
            insert acc;
            Test.startTest();
            List<Account> a = [select UniquePhone__c, isPersonAccount,PersonContactId ,RecordTypeId, State_Language__pc from Account where id =:acc.id];
            Database.executeBatch(new CustomerForBroadcastMandiWeather(), 200);
            system.debug('@'+a);
            Test.stopTest();
        }
    }
    
}