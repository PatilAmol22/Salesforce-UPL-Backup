@isTest
public class Casevalidation1_Test {
    
    Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
   public static testMethod void test2(){
      
       
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
        
        Sales_Org__c SO = new Sales_Org__c();
        so.name = 'TestFin';
        so.Sales_Org_Code__c = '1000';
        insert SO;
        
        Product2 p = new product2();
       //P.RecordTypeId= Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Non-US').getRecordTypeId();
        p.name = 'testproduct';
        P.Sales_Org__c = SO.ID;
        p.Combination_Key__c = '123';
       // p.Sales_Org_Code__c = 1000;
        insert p;
        
        Promotional_Product__c pp = new Promotional_Product__c();
        pp.Name = 'Testabc';
        pp.Product_Name__c = p.id;
        pp.Current_Month__c = TRUE;
        pp.Month__c = 'Jan';
        pp.Financial_Year__c = '2020';
        insert pp;
        
        Promotional_Product__c pp1 = new Promotional_Product__c();
        pp1.Name = 'Testabc1';
        pp1.Product_Name__c = p.id;
        pp1.Current_Month__c = TRUE;
        pp1.Month__c = 'Jan';
        pp1.Financial_Year__c = '2020';
        insert pp1;

      Account acc = new account();
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
        acc.FirstName='test';
        acc.LastName='Test';
        acc.Last_Name__c='test';
        acc.PersonMobilePhone='9869457812';
        //acc.Village__pc=villObj.Id;
       // acc.Farmer_Code__pc = 'fm0'+String.valueOf(auto.Sequence__c);
        acc.PersonEmail='test@gmail.com';
        acc.Phone='1010101004';
        acc.WRMS_Code__c='1223';
        acc.BillingStreet='test';
        acc.BillingCity='test';
        acc.BillingState='test';
        acc.BillingPostalCode='test';
        acc.BillingCountry='test';
        acc.Decision_Maker__pc = 'Yes';
        acc.Birthday_Specified__c = 'No';
        acc.Using_Smart_Phone__c = 'No';
        acc.Promotional_Product__c = pp.id;
        acc.Ask_specific_brands_buys_them_only__pc = '1-Strongly Disagree';
        acc.Relies_on_Retailers_Prod_Recommendation__pc = '1-Strongly Disagree';
        acc.New_Brands_Adoption__pc = '1. Buys newly launched pesticide/seed';
        acc.Influence_Fellow_Farmers_with_Crp_Advice__pc = '1-Strongly Disagree';
        acc.Crops_Cultivated__pc = 'Fruit/Vegetables';
        acc.SMS_Voice_Msg_Call_Consent__pc = 'Yes';
        acc.Fruit_Vegetable_Acerage__pc = '1 or Above';
        acc.Age__pc = 27;
        acc.Sales_Org__c = SO.Id;
        
        //acc.PriceGroupCode__c=Pg.Id;
        
        insert acc; 
        
         Account acc1 = new account();
        acc1.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
        acc1.FirstName='testabc';
        acc1.LastName='Testdef';
        acc1.Last_Name__c='testghi';
        acc1.PersonMobilePhone='8754253487';
        //acc.Village__pc=villObj.Id;
       // acc.Farmer_Code__pc = 'fm0'+String.valueOf(auto.Sequence__c);
        acc1.PersonEmail='test1@gmail.com';
        acc1.Phone='1010101005';
        acc1.WRMS_Code__c='1222';
        acc1.BillingStreet='test1';
        acc1.BillingCity='test1';
        acc1.BillingState='test1';
        acc1.BillingPostalCode='test1';
        acc1.BillingCountry='test1';
        acc1.Decision_Maker__pc = 'Yes';
        acc1.Birthday_Specified__c = 'YES';
        acc1.PersonBirthdate = Date.newInstance(1993, 08, 29);
        acc1.Using_Smart_Phone__c = 'No';
        acc1.Promotional_Product__c = pp1.id;
        acc1.Ask_specific_brands_buys_them_only__pc = '1-Strongly Disagree';
        acc1.Relies_on_Retailers_Prod_Recommendation__pc = '1-Strongly Disagree';
        acc1.New_Brands_Adoption__pc = '1. Buys newly launched pesticide/seed';
        acc1.Influence_Fellow_Farmers_with_Crp_Advice__pc = '1-Strongly Disagree';
        acc1.Crops_Cultivated__pc = 'Fruit/Vegetables';
        acc1.SMS_Voice_Msg_Call_Consent__pc = 'Yes';
        acc1.Fruit_Vegetable_Acerage__pc = '1 or Above';
        acc1.What_is_your_highest_education_attained__pc = 'Up to 4th std';
        acc1.Sales_Org__c = SO.Id;
        
        //acc.PriceGroupCode__c=Pg.Id;
        
        insert acc1; 
       
        Test.startTest();
            PageReference pageRef = Page.CaseValidation;
            Test.setCurrentPage(pageRef);
            
            pageRef.getParameters().put('id',acc.id);
           CaseValidation c = new CaseValidation();
           c.MyActionMethod();
           c.Sync();
           c.Sync1();
        c.cancel();
        Test.stopTest();
        
        }
    } 
}