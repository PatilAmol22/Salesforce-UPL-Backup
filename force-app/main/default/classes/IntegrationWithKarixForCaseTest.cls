@isTest
public class IntegrationWithKarixForCaseTest {
    static testMethod void testData(){
        Profile pr = new Profile(name = 'UPL Call Expert');
        Profile prof = [select id from profile where name='UPL Call Expert'];
        Test.startTest();
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
                Fo_Map__c = true);
            insert village;
            //-------------------------------------------------------
            /*UPL_Settings__c uplsetting = new UPL_Settings__c();
            uplsetting.Name = 'UPLSetting';
            uplsetting.India_SAS_Sales_Org__c = '1410';
            INSERT uplsetting;*/
            Sales_Org__c SO = new Sales_Org__c();
            so.name = 'TestFin';
            so.Sales_Org_Code__c = '1000';
            insert so;
            
            Product2 p = new product2();
            //P.RecordTypeId= '';
            p.name = 'testproduct';
            p.Sales_Org__c = so.Id;
            p.Combination_Key__c = '123';
            //p.Sales_Org_Code__c = 1000;
            insert p;
            
            Promotional_Product__c pp1 = new Promotional_Product__c();
            pp1.Name = 'Testabc1';
            pp1.Product_Name__c = p.id;
            pp1.Current_Month__c = TRUE;
            pp1.Month__c = 'Jan';
            pp1.Financial_Year__c = '2021';
            insert pp1;
            
            SMS_Template__c st = new SMS_Template__c(Name__c= 'Auto Product1 Recommendation',Text__c = 'testing.....',ObjectName__c = 'Case',Language__c='Tamil');
            insert st;
            
            //SMS_Template__c st2 = new SMS_Template__c(Name__c= 'Case Closure',Text__c = 'testing.....',ObjectName__c = 'Case', Language__c = 'Hindi');
            //insert st2;
            
            //SMS_Template__c st3 = new SMS_Template__c(Name__c= 'Case Closure',Text__c = 'testing.....',ObjectName__c = 'Case', Language__c = 'Tamil');
            //insert st3;
            
            String farmerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            Account acc = new Account( FirstName = 'test',LastName = 'test',PersonMobilePhone='9869457812',Village_Pin_Code_Manual__pc = '422009',RecordTypeId = farmerRecordTypeId,Decision_Maker__pc = 'Yes',Crops_Cultivated__pc = 'Fruits/Vegetables',PersonBirthdate = Date.newInstance(1990, 09, 11),Mobile__c = '9869457812',What_is_your_highest_education_attained__pc = 'Illiterate',Village__c = village.id,Using_Smart_Phone__c = 'No' ,
                                      Using_Watsapp__c='NO',Promotional_Product__c = pp1.id ,Village__pc =village.id, Preferred_Language__pc = 'Tamil');
            insert acc;
            
            //Account a = [select id from Account limit 1];
            contact con = new contact(LastName ='kenia',Village__c = village.id,Account = acc,SMS_Voice_Msg_Call_Consent__c = 'Yes');
        	insert con;
           Date dt = System.today() - 7;
            string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
            string caseNurtureType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('nurture.farm care').getRecordTypeId();

            List<Case> caseList=new List<Case>();
            Case casobj = new Case(
                AccountId  = acc.Id,
                RecordTypeId = caseRecordType,
                Contact = con,   // Contact Name
                Sent_to_ZM__c = false,                                                // Sent to ZM
                Status = 'New',                                                    // Status
                Type = 'Mandi price',                                                      // Type
                Crop_pick__c = 'Brinjal',                                              // Crop
                Sub_Query__c = 'Mandi price',                                              // Sub Query
                //DAS__c = '60',                                                        // DAS
                Origin = 'Call-Inbound',                                              // Case Origin
                Croplist_is_Already_Updated__c = true,                               // Croplist is Already Updated
                Override__c = false,                                                  // Override Season
                Subject = 'Brinjal - Insect - Insect',                                // Subject
                Description = 'Buldhana\tSales Officer (Sandeep Raut - 7720091449)',  // Description
                Issue_Enquiry__c = '\n',                                              // Issue Enquiry
                // ClosedDate = Datetime.valueOf('20-1-2016 3:05 PM:00'),                // Date/Time Closed
                Priority = 'Medium',                                                  // Priority
                PriorPromotion__c = true,
                Cross_selling_Opportunity__c = 'Opportunity Available',
                Call_Stage_at_which_the_call_closed__c = 'Product recommendation given',
                purcahsedtherecommendedprodouct__c = 'Yes',
                Rateyourexperienceonscaleof15__c = '3 - Neutral',
                Treatment__c = 'Cure',
                Insect_General_Case__c ='Aphids',
                Product_Recommended_1_gc__c = 'Amigo',
                Dose_1_gc__c ='150',
                Measure_1_gc__c = 'Ml Per Acre',
                Possible_date_of_application__c = dt
            );
            
            caseList.add(casobj);
            //insert casobj;
            
            Case casobj2 = new Case(
                AccountId  = acc.Id,
                RecordTypeId = caseNurtureType,
                Type = 'Nurture Farm App',
                Sub_Query__c = ' Disease',
                QRC__c = 'Query',
                Contact = con,   // Contact Name
                Origin = 'Whatsapp',
                Priority = 'Medium',
                Customer_Type__c = 'Farmer',
                Status = 'Closed',
                Description = 'Test',
                Crop_pick__c = 'Bitter Gourd'
            );
            caseList.add(casobj2);
            insert caseList;
            //insert casobj2;*/
            List<Task> taskList=new List<Task>();
            Task tas= new Task(Subject='Send feedback message on whatsapp',
                               whatId=caseList[0].Id);
            Task tas1= new Task(Subject='Send feedback message on whatsapp',
                               whatId=caseList[1].Id);
            taskList.add(tas);
            taskList.add(tas1);
                insert taskList;
            
            
            Test.stopTest();
            
        }
    }
     static testMethod void testData1(){
        Profile pr = new Profile(name = 'SWAL Call Expert');
        Profile prof = [select id from profile where name='SWAL Call Expert'];
        
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
                Fo_Map__c = true);
            insert village;
            //-------------------------------------------------------
            /*UPL_Settings__c uplsetting = new UPL_Settings__c();
            uplsetting.Name = 'UPLSetting';
            uplsetting.India_SAS_Sales_Org__c = '1410';
            INSERT uplsetting;*/
            Sales_Org__c SO = new Sales_Org__c();
            so.name = 'TestFin';
            so.Sales_Org_Code__c = '1000';
            insert so;
            
            Product2 p = new product2();
            //P.RecordTypeId= '';
            p.name = 'testproduct';
            p.Sales_Org__c = so.Id;
            p.Combination_Key__c = '123';
            // p.Sales_Org_Code__c = 1000;
            insert p;
            
            Promotional_Product__c pp1 = new Promotional_Product__c();
            pp1.Name = 'Testabc1';
            pp1.Product_Name__c = p.id;
            pp1.Current_Month__c = TRUE;
            pp1.Month__c = 'Jan';
            pp1.Financial_Year__c = '2021';
            insert pp1;
            
            SMS_Template__c st = new SMS_Template__c(Name__c= 'Auto Product1 Recommendation',Text__c = 'testing.....',ObjectName__c = 'SWAL_Case',Language__c='Tamil');
            insert st;
            
            //SMS_Template__c st2 = new SMS_Template__c(Name__c= 'Case Closure',Text__c = 'testing.....',ObjectName__c = 'SWAL_Case', Language__c = 'Hindi');
            //insert st2;
            
            //SMS_Template__c st3 = new SMS_Template__c(Name__c= 'Case Closure',Text__c = 'testing.....',ObjectName__c = 'SWAL_Case', Language__c = 'Tamil');
            //insert st3;
            
            String farmerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SWAL Farmer').getRecordTypeId();
            Account acc = new Account( FirstName = 'test',LastName = 'test',PersonMobilePhone='9869457812',Village_Pin_Code_Manual__pc = '422009',RecordTypeId = farmerRecordTypeId,Decision_Maker__pc = 'Yes',Crops_Cultivated__pc = 'Fruits/Vegetables',PersonBirthdate = Date.newInstance(1990, 09, 11),Mobile__c = '9869457812',What_is_your_highest_education_attained__pc = 'Illiterate',Village__c = village.id,Using_Smart_Phone__c = 'No' ,
                                      Promotional_Product__c = pp1.id ,Village__pc =village.id,Preferred_Language__pc = 'Tamil');
            insert acc;
            
            Account a = [select id from Account limit 1];
            contact con = new contact(LastName ='kenia',Village__c = village.id,Account = acc);
        	insert con;
            Date dt = System.today() - 5;
            string caseRecordType1  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('SWAL General Case').getRecordTypeId();
            
            Case casobj = new Case(
                AccountId  = a.Id,
                RecordTypeId = caseRecordType1,
                Contact = con,   // Contact Name
                Sent_to_ZM__c = false,                                                // Sent to ZM
                Status = 'New',                                                    // Status
                Type = 'Mandi price',                                                      // Type
                Crop_pick__c = 'Brinjal',                                              // Crop
                Sub_Query__c = 'Mandi price',                                              // Sub Query
                //DAS__c = '60',                                                        // DAS
                Origin = 'Call-Inbound',                                              // Case Origin
                Croplist_is_Already_Updated__c = true,                               // Croplist is Already Updated
                Override__c = false,                                                  // Override Season
                Subject = 'Brinjal - Insect - Insect',                                // Subject
                Description = 'Buldhana\tSales Officer (Sandeep Raut - 7720091449)',  // Description
                Issue_Enquiry__c = '\n',                                              // Issue Enquiry
                // ClosedDate = Datetime.valueOf('20-1-2016 3:05 PM:00'),                // Date/Time Closed
                Priority = 'Medium',                                                  // Priority
                PriorPromotion__c = true,
                Cross_selling_Opportunity__c = 'Opportunity Available',
                Call_Stage_at_which_the_call_closed__c = 'Product recommendation given',
                purcahsedtherecommendedprodouct__c = 'Yes',
                Rateyourexperienceonscaleof15__c = '3 - Neutral',
                Treatment__c = 'Preventive',
                Insect_General_Case__c ='Aphids',
                Product_Recommended_1_gc__c = 'Amigo',
                Dose_1_gc__c ='150',
                Measure_1_gc__c = 'Ml Per Acre',
                Possible_date_of_application__c = dt
            );
            insert casobj;
         
            Test.startTest();
            Case casobj2 = new Case(
                AccountId  = a.Id,
                RecordTypeId = caseRecordType1,
                Type = 'Nurture Farm App',
                Sub_Query__c = 'OTP not received',
                QRC__c = 'Complaint',
                Contact = con,   // Contact Name
                Origin = 'Whatsapp',
                Priority = 'Medium',
                Customer_Type__c = 'Farmer',
                Status = 'Closed',
                Description = 'Test',
                Crop_pick__c = 'Bitter Gourd'
            );
            insert casobj2;
              Task tas= new Task(Subject='Send feedback message on whatsapp',
                               whatId=casobj2.Id);
                insert tas;
             Map<String,String> fieldValueCaseMap = new Map<String,String>();
            fieldValueCaseMap.put('P1',casobj2.Crop_pick__c);
            IntegrationWithKarixForCase.parseTemplate(st.Text__c,fieldValueCaseMap);
            Test.stopTest();
            
        }
    }
}