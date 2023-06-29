@isTest
public class IntegrationWithEngagelyTest {
    static testMethod void testData(){
        
        Engagely_Settings__c eng = new Engagely_Settings__c();
        eng.Feedback_URL__c = '@@';
        eng.Password__c = '@@';
        eng.Name = 'engagely';
        eng.Product_URL__c = '@@';
        eng.User_Name__c = '@@';
        eng.wrmsURL__c = '@@';
        insert eng;
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
            
            string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('UPL General Case').getRecordTypeId();
            String farmerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            Account acc = new Account( FirstName = 'test',LastName = 'test',PersonMobilePhone='9869457812',Village_Pin_Code_Manual__pc = '422009',Promotional_Product__c = pp1.id,RecordTypeId = farmerRecordTypeId,SMS_Voice_Msg_Call_Consent__pc = 'Yes',Decision_Maker__pc = 'Yes',Crops_Cultivated__pc = 'Fruits/Vegetables',PersonBirthdate = Date.newInstance(1990, 09, 11),Mobile__c = '9869457812',What_is_your_highest_education_attained__pc = 'Illiterate',Using_Smart_Phone__c = 'No');
            insert acc;
            Case c = new Case(
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
                Measure_1_gc__c = 'Ml Per Acre'
            );
            insert c;
            
            IntegrationWithEngagely.sendWhatsapp(c.id,'tEST','tEST','3453','Marathi',c.Product_Recommended_1_gc__c,c.Product_Recommended_2_gc__c,c.Product_Recommended_3_gc__c,c.Product_Recommended_4__c,5);
            httpResponse response = new httpResponse();
            IntegrationWithEngagely.createSMSHistory(c.Id,'98765431121',response);
            Task taskObj = new Task();
            taskObj.Status = 'In Progress';
            //taskObj.RecordTypeId = RecordTypeId;
            //taskObj.SAP_Mobile__c = '9967341750';
            taskObj.WhatId = c.id;
            taskObj.SAP_Email__c = 'test@test.com';
            insert taskObj;
            List<task> taskList = new List<task>();
            taskList.add(taskObj);
            IntegrationWithEngagely.getCaseContentsForSMS(taskList);
            IntegrationWithEngagely.getRecommendedForwhatsapp(taskList,5);
        }
    }
    /*
static testMethod void testData1(){
Profile pr = new Profile(name = 'UPL Call Expert');
Profile prof = [select id from profile where name='UPL Call Expert'];

setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1()); 
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

SMS_Template__c st = new SMS_Template__c(Name__c= 'Auto Product1 Recommendation',Text__c = 'testing.....',ObjectName__c = 'Case');
insert st;

String farmerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
Account acc = new Account( FirstName = 'test',LastName = 'test',PersonMobilePhone='9869457812',Village_Pin_Code_Manual__pc = '422009',RecordTypeId = farmerRecordTypeId,SMS_Voice_Msg_Call_Consent__pc = 'Yes',Decision_Maker__pc = 'Yes',Crops_Cultivated__pc = 'Fruits/Vegetables',PersonBirthdate = Date.newInstance(1990, 09, 11),Mobile__c = '9869457812',What_is_your_highest_education_attained__pc = 'Illiterate',Village__c = village.id,Using_Smart_Phone__c = 'No' ,
Promotional_Product__c = pp1.id ,Village__pc =village.id);
insert acc;

Account a = [select id from Account limit 1];
contact con = new contact(LastName ='kenia',Village__c = village.id,Account = acc);
insert con;
Test.startTest();
system.debug('!!'+acc.Using_Smart_Phone__c);
string caseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('UPL General Case').getRecordTypeId();
Case casobj = new Case(
AccountId  = a.Id,
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
Measure_1_gc__c = 'Ml Per Acre'
);
insert casobj;
//getCaseContentsForSMS();

Test.stopTest();

}
}*/
}