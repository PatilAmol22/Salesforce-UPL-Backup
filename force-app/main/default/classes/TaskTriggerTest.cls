@isTest
public class TaskTriggerTest {
    static testMethod void test1(){
        Id RecordTypeId = [SELECT Id, DeveloperName, SobjectType FROM RecordType where SobjectType = 'Task' AND DeveloperName = 'Alerts'].Id;
        Task taskObj = new Task();
        taskObj.RecordTypeId = RecordTypeId;
        taskObj.Status = 'In Progress';
        insert taskObj;
    }
    static testMethod void test2(){
        Id distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        
        insert auto;
        
        
        Account accObj = new Account();
        accObj.Name = 'Test';
        accObj.First_Name__c = 'Test';
        accObj.Last_Name__c = 'Test';
        accObj.RecordTypeId = distributorRecordTypeId;
        accObj.Mobile__c = '9967341750';
        accObj.Email__c = 'test@test.com';
        insert accObj;
        Id RecordTypeId = [SELECT Id, DeveloperName, SobjectType FROM RecordType where SobjectType = 'Task' AND DeveloperName = 'Alerts'].Id;
        
        Task taskObj = new Task();
        taskObj.Status = 'In Progress';
        taskObj.RecordTypeId = RecordTypeId;
        taskObj.SAP_Mobile__c = '9967341750';
        insert taskObj;
    }
    static testMethod void test3(){
        Id distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        
        insert auto;
        
        
        Account accObj = new Account();
        accObj.Name = 'Test';
        accObj.First_Name__c = 'Test';
        accObj.Last_Name__c = 'Test';
        accObj.RecordTypeId = distributorRecordTypeId;
        accObj.Mobile__c = '9967341750';
        accObj.Email__c = 'test@test.com';
        insert accObj;
        
        Id RecordTypeId = [SELECT Id, DeveloperName, SobjectType FROM RecordType where SobjectType = 'Task' AND DeveloperName = 'Alerts'].Id;
        Task taskObj = new Task();
        taskObj.Status = 'In Progress';
        taskObj.RecordTypeId = RecordTypeId;
        taskObj.SAP_Email__c = 'test@test.com';
        insert taskObj;
    }
    
    static testMethod void test4(){
        Id distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Account accObj = new Account();
        accObj.Name = 'Test';
        accObj.First_Name__c = 'Test';
        accObj.Last_Name__c = 'Test';
        accObj.RecordTypeId = distributorRecordTypeId;
        accObj.Mobile__c = '9920772228';
        //accObj.PersonEmail = 'test@test.com';
        insert accObj;
        
        Id RecordTypeId = [SELECT Id, DeveloperName, SobjectType FROM RecordType where SobjectType = 'Task' AND DeveloperName = 'Alerts'].Id;
        Task taskObj = new Task();
        taskObj.Status = 'In Progress';
        taskObj.RecordTypeId = RecordTypeId;
        taskObj.SAP_Mobile__c = '9967341750';
        taskObj.SAP_Email__c = 'test@test.com';
        insert taskObj;
    }
    static testMethod void test5(){
        
        Id RecordTypeId = [SELECT Id, DeveloperName, SobjectType FROM RecordType where SobjectType = 'Task' AND DeveloperName = 'Alerts'].Id;
        Task taskObj = new Task();
        taskObj.Status = 'In Progress';
        taskObj.RecordTypeId = RecordTypeId;
        taskObj.SAP_Mobile__c = '9967341750';
        //taskObj.SAP_Email__c = 'test@test.com';
        insert taskObj;
    }
    static testMethod void test6(){
        
        Id RecordTypeId = [SELECT Id, DeveloperName, SobjectType FROM RecordType where SobjectType = 'Task' AND DeveloperName = 'Alerts'].Id;
        Task taskObj = new Task();
        taskObj.Status = 'In Progress';
        taskObj.RecordTypeId = RecordTypeId;
        //taskObj.SAP_Mobile__c = '9967341750';
        taskObj.SAP_Email__c = 'test@test.com';
        insert taskObj;
    }
    static testMethod void test7(){
        Engagely_Settings__c eng = new Engagely_Settings__c();
        eng.Feedback_URL__c = '@@';
        eng.Password__c = '@@';
        eng.Name = 'engagely';
        eng.Product_URL__c = '@@';
        eng.User_Name__c = '@@';
        eng.wrmsURL__c = '@@';
        insert eng;
        Case c;
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
            State__c s=new State__c(Name='UP');
            insert s;
            District__c d=new District__c(Name='Bareilly',State__c=s.Id);
            insert d;
            Tehsil__c t=new Tehsil__c(Name='abc',District__c=d.Id, Tehsil_Code__c='123456');
            insert t;
            Village__c v=new Village__c(Name='Atak Pardi',Tehsil__c=t.Id,Territory__c='Pune');
            insert v;
            string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
            String farmerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            Account acc = new Account( FirstName = 'test',LastName = 'test',Village__pc=v.id,PersonMobilePhone='9869457812',Using_Watsapp__c='Yes',Preferred_Language__pc='Others',Village_Pin_Code_Manual__pc = '422009',Promotional_Product__c = pp1.id,RecordTypeId = farmerRecordTypeId,SMS_Voice_Msg_Call_Consent__pc = 'Yes',Decision_Maker__pc = 'Yes',Crops_Cultivated__pc = 'Fruits/Vegetables',PersonBirthdate = Date.newInstance(1990, 09, 11),Mobile__c = '9869457812',What_is_your_highest_education_attained__pc = 'Illiterate',Using_Smart_Phone__c = 'No');
            insert acc;
            c = new Case(
                AccountId  = acc.Id,
                RecordTypeId = caseRecordType,
                //Contact = con,   // Contact Name
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
                CaseOwner__c='RCM'
            );
            insert c;
            Test.startTest();
            Task taskObj = new Task();
            taskObj.Status = 'Open';
            //taskObj.RecordTypeId = RecordTypeId;
            taskObj.Subject = 'Auto Product2 Recommendation';
            taskObj.WhatId = c.id;
            //taskObj.SAP_Email__c = 'test@test.com';
            insert taskObj;
            Test.stopTest();
        }
    }
    static testMethod void test8(){
        Engagely_Settings__c eng = new Engagely_Settings__c();
        eng.Feedback_URL__c = '@@';
        eng.Password__c = '@@';
        eng.Name = 'engagely';
        eng.Product_URL__c = '@@';
        eng.User_Name__c = '@@';
        eng.wrmsURL__c = '@@';
        insert eng;
        Case c;
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
            State__c s=new State__c(Name='UP');
            insert s;
            District__c d=new District__c(Name='Bareilly',State__c=s.Id);
            insert d;
            Tehsil__c t=new Tehsil__c(Name='abc',District__c=d.Id, Tehsil_Code__c='123456');
            insert t;
            Village__c v=new Village__c(Name='Atak Pardi',Tehsil__c=t.Id,Territory__c='Pune');
            insert v;
            string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
            String farmerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            Account acc = new Account( FirstName = 'test',LastName = 'test',PersonMobilePhone='9869457812',Village__pc=v.id,Using_Watsapp__c='Yes',Preferred_Language__pc='Others',Village_Pin_Code_Manual__pc = '422009',Promotional_Product__c = pp1.id,RecordTypeId = farmerRecordTypeId,SMS_Voice_Msg_Call_Consent__pc = 'Yes',Decision_Maker__pc = 'Yes',Crops_Cultivated__pc = 'Fruits/Vegetables',PersonBirthdate = Date.newInstance(1990, 09, 11),Mobile__c = '9869457812',What_is_your_highest_education_attained__pc = 'Illiterate',Using_Smart_Phone__c = 'No');
            insert acc;
            c = new Case(
                AccountId  = acc.Id,
                RecordTypeId = caseRecordType,
                //Contact = con,   // Contact Name
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
                CaseOwner__c='RCM'
            );
            insert c;
            Test.startTest();
            Task taskObj = new Task();
            taskObj.Status = 'Open';
            //taskObj.RecordTypeId = RecordTypeId;
            taskObj.Subject = 'Cross Selling Whatsapp Preventive';
            taskObj.WhatId = c.id;
            //taskObj.SAP_Email__c = 'test@test.com';
            insert taskObj;
            Test.stopTest();
        }
    }
    static testMethod void test9(){
        Engagely_Settings__c eng = new Engagely_Settings__c();
        eng.Feedback_URL__c = '@@';
        eng.Password__c = '@@';
        eng.Name = 'engagely';
        eng.Product_URL__c = '@@';
        eng.User_Name__c = '@@';
        eng.wrmsURL__c = '@@';
        insert eng;
        Case c;
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
            State__c s=new State__c(Name='UP');
            insert s;
            District__c d=new District__c(Name='Bareilly',State__c=s.Id);
            insert d;
            Tehsil__c t=new Tehsil__c(Name='abc',District__c=d.Id, Tehsil_Code__c='123456');
            insert t;
            Village__c v=new Village__c(Name='Atak Pardi',Tehsil__c=t.Id,Territory__c='Pune');
            insert v;
            string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
            String farmerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            Account acc = new Account( FirstName = 'test',LastName = 'test',PersonMobilePhone='9869457812',Village__pc=v.id,Using_Watsapp__c='Yes',Preferred_Language__pc='Others',Village_Pin_Code_Manual__pc = '422009',Promotional_Product__c = pp1.id,RecordTypeId = farmerRecordTypeId,SMS_Voice_Msg_Call_Consent__pc = 'Yes',Decision_Maker__pc = 'Yes',Crops_Cultivated__pc = 'Fruits/Vegetables',PersonBirthdate = Date.newInstance(1990, 09, 11),Mobile__c = '9869457812',What_is_your_highest_education_attained__pc = 'Illiterate',Using_Smart_Phone__c = 'No');
            insert acc;
            c = new Case(
                AccountId  = acc.Id,
                RecordTypeId = caseRecordType,
                //Contact = con,   // Contact Name
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
                CaseOwner__c='RCM'
            );
            insert c;
            Test.startTest();
            Task taskObj = new Task();
            taskObj.Status = 'Open';
            //taskObj.RecordTypeId = RecordTypeId;
            taskObj.Subject = 'Cross Selling whatsapp Cure';
            taskObj.WhatId = c.id;
            //taskObj.SAP_Email__c = 'test@test.com';
            insert taskObj;
            Test.stopTest();
        }
    }
    static testMethod void test10(){
        Engagely_Settings__c eng = new Engagely_Settings__c();
        eng.Feedback_URL__c = '@@';
        eng.Password__c = '@@';
        eng.Name = 'engagely';
        eng.Product_URL__c = '@@';
        eng.User_Name__c = '@@';
        eng.wrmsURL__c = '@@';
        insert eng;
        Case c;
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
            State__c s=new State__c(Name='UP');
            insert s;
            District__c d=new District__c(Name='Bareilly',State__c=s.Id);
            insert d;
            Tehsil__c t=new Tehsil__c(Name='abc',District__c=d.Id, Tehsil_Code__c='123456');
            insert t;
            Village__c v=new Village__c(Name='Atak Pardi',Tehsil__c=t.Id,Territory__c='Pune');
            insert v;
            string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
            String farmerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            Account acc = new Account( FirstName = 'test',LastName = 'test',PersonMobilePhone='9869457812',Village__pc=v.id,Using_Watsapp__c='Yes',Preferred_Language__pc='Others',Village_Pin_Code_Manual__pc = '422009',Promotional_Product__c = pp1.id,RecordTypeId = farmerRecordTypeId,SMS_Voice_Msg_Call_Consent__pc = 'Yes',Decision_Maker__pc = 'Yes',Crops_Cultivated__pc = 'Fruits/Vegetables',PersonBirthdate = Date.newInstance(1990, 09, 11),Mobile__c = '9869457812',What_is_your_highest_education_attained__pc = 'Illiterate',Using_Smart_Phone__c = 'No');
            insert acc;
            c = new Case(
                AccountId  = acc.Id,
                RecordTypeId = caseRecordType,
                //Contact = con,   // Contact Name
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
                CaseOwner__c='RCM'
            );
            insert c;
            Test.startTest();
            Task taskObj = new Task();
            taskObj.Status = 'Open';
            //taskObj.RecordTypeId = RecordTypeId;
            taskObj.Subject = 'Send feedback message on whatsapp';
            taskObj.WhatId = c.id;
            //taskObj.SAP_Email__c = 'test@test.com';
            insert taskObj;
            Test.stopTest();
        }
    }
    static testMethod void test11(){
        Engagely_Settings__c eng = new Engagely_Settings__c();
        eng.Feedback_URL__c = '@@';
        eng.Password__c = '@@';
        eng.Name = 'engagely';
        eng.Product_URL__c = '@@';
        eng.User_Name__c = '@@';
        eng.wrmsURL__c = '@@';
        insert eng;
        Case c;
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
            State__c s=new State__c(Name='UP');
            insert s;
            District__c d=new District__c(Name='Bareilly',State__c=s.Id);
            insert d;
            Tehsil__c t=new Tehsil__c(Name='abc',District__c=d.Id, Tehsil_Code__c='123456');
            insert t;
            Village__c v=new Village__c(Name='Atak Pardi',Tehsil__c=t.Id,Territory__c='Pune');
            insert v;
            string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('SWAL General Case').getRecordTypeId();
            String farmerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            Account acc = new Account( FirstName = 'test',LastName = 'test',PersonMobilePhone='9869457812',Village__pc=v.id,Using_Watsapp__c='Yes',Preferred_Language__pc='Others',Village_Pin_Code_Manual__pc = '422009',Promotional_Product__c = pp1.id,RecordTypeId = farmerRecordTypeId,SMS_Voice_Msg_Call_Consent__pc = 'Yes',Decision_Maker__pc = 'Yes',Crops_Cultivated__pc = 'Fruits/Vegetables',PersonBirthdate = Date.newInstance(1990, 09, 11),Mobile__c = '9869457812',What_is_your_highest_education_attained__pc = 'Illiterate',Using_Smart_Phone__c = 'No');
            insert acc;
            SMS_Template__c st = new SMS_Template__c(Name__c= 'Auto Product1 Recommendation',Text__c = 'testing.....',ObjectName__c = 'SWAL_Case');
            insert st;
            SMS_Template__c st1 = new SMS_Template__c(Name__c= 'Auto Product1 Recommendation',Text__c = 'testing.....',ObjectName__c = 'Case');
            insert st1;
            c = new Case(
                AccountId  = acc.Id,
                RecordTypeId = caseRecordType,
                //Contact = con,   // Contact Name
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
                CaseOwner__c='RCM'
            );
            insert c;
            Test.startTest();
            Task taskObj = new Task();
            taskObj.Status = 'Open';
            //taskObj.RecordTypeId = RecordTypeId;
            taskObj.Subject = 'Send feedback message on whatsapp';
            taskObj.WhatId = c.id;
            //taskObj.SAP_Email__c = 'test@test.com';
            insert taskObj;
            Test.stopTest();
        }
    }
    
}