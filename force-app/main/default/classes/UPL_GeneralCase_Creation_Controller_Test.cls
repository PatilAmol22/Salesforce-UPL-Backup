/*
* Name : UPL_GeneralCase_Creation_Controller_Test
* Created on : 6th May 2020
* Developer : Varun Shrivastava                               
* Description : To provide Coverage to UPL_GeneralCase_Creation_Controller class 
* Last Stable Backup : 
*/
@isTest(seeAllData=false)
private class UPL_GeneralCase_Creation_Controller_Test {
   
    @testSetup
    static void testSetup(){
        
        Profile profile = [select id from profile where name ='UPL Call Expert'];
        
        
        Contact con = new Contact();
        con.FirstName = 'test';
        con.LastName = 'contact';
        con.Email = 'test@email.com';
        insert con;
        
        User testUser = new User();
        testUser.ProfileId = profile.Id;
        testUser.LastName = 'last';
        testUser.Email = 'puser000@amamama.com';
        testUser.Username = 'puser000@amamama.com' + System.currentTimeMillis();
        testUser.CompanyName = 'TEST';
        testUser.Title = 'title';
        testUser.Alias = 'alias';
        testUser.TimeZoneSidKey = 'GMT';
        testUser.EmailEncodingKey = 'UTF-8';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.LocaleSidKey = 'en_US';
        testUser.isActive = true;
        insert testUser;
        
        System.runAs(testUser){

            //-------------------------------------------------------
            /*UPL_Settings__c uplsetting = new UPL_Settings__c();
            uplsetting.Name = 'UPLSetting';
            uplsetting.India_SAS_Sales_Org__c = '1410';
            INSERT uplsetting;*/
            //-------------------------------------------------------
            Sales_Org__c salesOrg = new Sales_Org__c();
            salesOrg.Name = 'Test Org';
            salesOrg.Sales_Org_Code__c = '1000';
            //salesOrg.Sales_Org_Code__c = uplsetting.India_SAS_Sales_Org__c;
            insert salesOrg;
            
            Product2 testProduct = new Product2();
            testProduct.Name = 'Test Product';
            testProduct.Active__c = true;
            testProduct.Sales_Org__c = salesOrg.ID;
            testProduct.Product_Code__c = '12345';
            testProduct.Combination_Key__c = '123';
            insert testProduct;
            
            Promotional_Product__c  promotionalProduct = new Promotional_Product__c ();
            promotionalProduct.Name = 'Promotional Product';
            promotionalProduct.Product_Name__c = testProduct.ID;
            promotionalProduct.Current_Month__c = TRUE;
            promotionalProduct.Month__c = 'Jan';
            promotionalProduct.Financial_Year__c = '2020';
            insert promotionalProduct;
            
            Account acc= new Account();
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            acc.FirstName = 'test';
            acc.LastName = 'account';
            acc.Decision_Maker__pc = 'Yes';
            acc.Mobile__c = '9869457812';
            acc.PersonMobilePhone='9869457812';
            acc.Promotional_Product__c = promotionalProduct.ID;
            acc.What_is_your_highest_education_attained__pc = 'Illiterate';
            insert acc;
            
        }
        
        /*UPL_General_Case_Type__mdt customMdtRecord = new UPL_General_Case_Type__mdt();
        customMdtRecord.Name = 'Weed Availability';
        customMdtRecord.Type__c = 'Weed';
        customMdtRecord.Sub_Query__c = 'Availability';  
        customMdtRecord.Required_Fields__c = 'Other_Crop_Name__c;Theme_of_Month__c;Promotional_Product__c;Croplist_is_Already_Updated__c;Crop_Type__c;CropName__c;Sowing_Date__c;Season_Type__c;Override__c;Acreage__c;Type_of_farm__c';
        insert customMdtRecord;*/
    }
    
    static testMethod void constructorCoverage(){
        Test.startTest();
        Case caseRecord = new Case();
        Apexpages.StandardController sc = new Apexpages.StandardController(caseRecord);
        UPL_GeneralCase_Creation_Controller record =  new UPL_GeneralCase_Creation_Controller(sc);
        Test.stopTest();
    }
    
    static testMethod void renderSectionsCoverage(){
        Test.startTest();
        Case caseRecord = new Case();
        caseRecord.Type = 'Weed';
        caseRecord.Sub_Query__c = 'Availability';
        caseRecord.QRC__c = 'Query';
        caseRecord.Type = 'Product Recommendation';
        Apexpages.StandardController sc = new Apexpages.StandardController(caseRecord);
        UPL_GeneralCase_Creation_Controller record =  new UPL_GeneralCase_Creation_Controller(sc);
        record.renderSections();
        record.toggleCallerField();
        record.hideOtherFields();
        Test.stopTest();
    }
    
    static testMethod void initiateRedirectCoverage(){
        Test.startTest();
        Promotional_Product__c testPromotionalProduct = [Select Id from Promotional_Product__c limit 1];
        Date myDate = date.newInstance(2020,05,06);
        
        Account acc = [Select Id from Account where Name = 'test account' limit 1];
        Contact con = [Select ID from Contact where Email = 'test@email.com' limit 1];
        
        Case caseRecord = new Case();
        caseRecord.Type = 'Weed';
        caseRecord.AccountId = acc.Id;
        caseRecord.ContactId = con.Id;
        caseRecord.Sub_Query__c = 'Availability';
        caseRecord.QRC__c = 'Query';
        caseRecord.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
        caseRecord.Status = 'Closed';
        caseRecord.Other_Crop_Name__c='test';
        caseRecord.Theme_of_Month__c=false;
        caseRecord.Promotional_Product__c = testPromotionalProduct.Id;
        caseRecord.Croplist_is_Already_Updated__c=false;
        caseRecord.Crop_Type__c='Fruits';
        caseRecord.CropName__c='Kinnow (128)';
        caseRecord.Sowing_Date__c=myDate;
        caseRecord.Season_Type__c='Summer Season';
        caseRecord.Override__c=false;
        caseRecord.Acreage__c=12;
        caseRecord.Type_of_farm__c='Irrigated';
        caseRecord.Crop_pick__c = 'Amla';
        caseRecord.Caller_Type__c = 'Account Holder';
        insert caseRecord;
        Apexpages.StandardController sc = new Apexpages.StandardController(caseRecord);
        ApexPages.currentPage().getParameters().put('Mode','Edit');
        ApexPages.currentPage().getParameters().put('id',caseRecord.ID);
        UPL_GeneralCase_Creation_Controller record =  new UPL_GeneralCase_Creation_Controller(sc);
        record.initiateRedirect();
        record.toggleCallerField();
        record.hideOtherFields();
        Test.stopTest();
    }
    
    /*static testMethod void initiateRedirectOtherTypeCoverage(){
        Test.startTest();
        Promotional_Product__c testPromotionalProduct = [Select Id from Promotional_Product__c limit 1];
        Date myDate = date.newInstance(2020,05,06);
        
        Account acc = [Select Id from Account where Name = 'test account' limit 1];
        Contact con = [Select ID from Contact where Email = 'test@email.com' limit 1];
        
        Case caseRecord = new Case();
        caseRecord.Type = 'Weed';
        caseRecord.AccountId = acc.Id;
        caseRecord.ContactId = con.Id;
        caseRecord.Sub_Query__c = 'Availability';
        caseRecord.QRC__c = 'Query';
        caseRecord.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC Retailer').getRecordTypeId();
        caseRecord.Status = 'Closed';
        caseRecord.Other_Crop_Name__c='test';
        caseRecord.Theme_of_Month__c=false;
        caseRecord.Promotional_Product__c = testPromotionalProduct.Id;
        caseRecord.Croplist_is_Already_Updated__c=false;
        caseRecord.Crop_Type__c='Fruits';
        caseRecord.CropName__c='Apple (13)';
        caseRecord.Sowing_Date__c=myDate;
        caseRecord.Season_Type__c='Summer Season';
        caseRecord.Override__c=false;
        caseRecord.Acreage__c=12;
        caseRecord.Type_of_farm__c='Irrigated';
        insert caseRecord;
        Apexpages.StandardController sc = new Apexpages.StandardController(caseRecord);
        ApexPages.currentPage().getParameters().put('Mode','Edit');
        ApexPages.currentPage().getParameters().put('id',caseRecord.ID);
        UPL_GeneralCase_Creation_Controller record =  new UPL_GeneralCase_Creation_Controller(sc);
        record.initiateRedirect();
        
        Test.stopTest();
    }*/
    
    static testMethod void saveFunctionalityCoverage(){
        Test.startTest();
        
        Promotional_Product__c testPromotionalProduct = [Select Id from Promotional_Product__c limit 1];
        Date myDate = date.newInstance(2020,05,06);
        
        Account acc = [Select Id from Account where Name = 'test account' limit 1];
        Contact con = [Select ID from Contact where Email = 'test@email.com' limit 1];
        
        Case caseRecord = new Case();
        caseRecord.Type = 'Weed';
        caseRecord.AccountId = acc.Id;
        caseRecord.ContactId = con.Id;
        caseRecord.Sub_Query__c = 'Availability';
        caseRecord.QRC__c = 'Query';
        caseRecord.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
        caseRecord.Status = 'Closed';
        caseRecord.Other_Crop_Name__c='test';
        caseRecord.Theme_of_Month__c=false;
        caseRecord.Promotional_Product__c = testPromotionalProduct.Id;
        caseRecord.Croplist_is_Already_Updated__c=false;
        caseRecord.Crop_Type__c='Fruits';
        caseRecord.CropName__c='Kinnow (128)';
        caseRecord.Sowing_Date__c=myDate;
        caseRecord.Season_Type__c='Summer Season';
        caseRecord.Override__c=false;
        caseRecord.Origin__c = 'Phone';
        caseRecord.Customer_Type__c = 'Farmer';
        caseRecord.Acreage__c=12;
        caseRecord.Type_of_farm__c='Irrigated';
        Apexpages.StandardController sc = new Apexpages.StandardController(caseRecord);
        UPL_GeneralCase_Creation_Controller record =  new UPL_GeneralCase_Creation_Controller(sc);
        record.saveFunctionality();
        Test.stopTest();
    }
    
    static testMethod void saveProductRecommendationCoverage(){
        Test.startTest();
        
        Promotional_Product__c testPromotionalProduct = [Select Id from Promotional_Product__c limit 1];
        Date myDate = date.newInstance(2020,05,06);
        
        Account acc = [Select Id from Account where Name = 'test account' limit 1];
        Contact con = [Select ID from Contact where Email = 'test@email.com' limit 1];
        
        Case caseRecord = new Case();
        caseRecord.Type = 'Weed';
        caseRecord.AccountId = acc.Id;
        caseRecord.ContactId = con.Id;
        caseRecord.Sub_Query__c = 'Availability';
        caseRecord.QRC__c = 'Query';
        caseRecord.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
        caseRecord.Status = 'Closed';
        caseRecord.Other_Crop_Name__c='test';
        caseRecord.Theme_of_Month__c=false;
        caseRecord.Promotional_Product__c = testPromotionalProduct.Id;
        caseRecord.Croplist_is_Already_Updated__c=false;
        caseRecord.Crop_Type__c='Fruits';
        caseRecord.CropName__c='Kinnow (128)';
        caseRecord.Sowing_Date__c=myDate;
        caseRecord.Season_Type__c='Summer Season';
        caseRecord.Override__c=false;
        caseRecord.Origin__c = 'Phone';
        caseRecord.Customer_Type__c = 'Farmer';
        caseRecord.Acreage__c=12;
        caseRecord.Type_of_farm__c='Irrigated';
        Apexpages.StandardController sc = new Apexpages.StandardController(caseRecord);
        UPL_GeneralCase_Creation_Controller record =  new UPL_GeneralCase_Creation_Controller(sc);
        record.saveFunctionality();
        
        Case productRecommendationRecord = new Case();
        productRecommendationRecord.Type = 'Product Recommendation';
        productRecommendationRecord.AccountId = acc.Id;
        productRecommendationRecord.ContactId = con.Id;
        productRecommendationRecord.Product_Recommendation_Case__c = caseRecord.Id;
        productRecommendationRecord.Sub_Query__c = 'Weed';
        productRecommendationRecord.QRC__c = 'Query';
        productRecommendationRecord.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
        productRecommendationRecord.Status = 'Closed';
        productRecommendationRecord.Product_Recommended_1_gc__c = 'Avert';
        productRecommendationRecord.Dose_1_gc__c= '100';
        productRecommendationRecord.Measure_1_gc__c='Gm Per Acre';
        
        Apexpages.StandardController sc1 = new Apexpages.StandardController(productRecommendationRecord);
        UPL_GeneralCase_Creation_Controller record1 =  new UPL_GeneralCase_Creation_Controller(sc1);
        record1.saveFunctionality();
        
        Test.stopTest();
    }
    
    
    static testMethod void saveFunctionalityExceptionCoverage(){
        Test.startTest();
        Case caseRecord = new Case();
        caseRecord.Type = 'Weed';
        caseRecord.Sub_Query__c = 'Availability';
        caseRecord.QRC__c = 'Query';
        Apexpages.StandardController sc = new Apexpages.StandardController(caseRecord);
        UPL_GeneralCase_Creation_Controller record =  new UPL_GeneralCase_Creation_Controller(sc);
        record.saveFunctionality();
        Test.stopTest();
    }
    
    static testMethod void saveAndNewFunctionalityCoverage(){
        Test.startTest();
        
        Promotional_Product__c testPromotionalProduct = [Select Id from Promotional_Product__c limit 1];
        Date myDate = date.newInstance(2020,05,06);
        
        Account acc = [Select Id from Account where Name = 'test account' limit 1];
        Contact con = [Select ID from Contact where Email = 'test@email.com' limit 1];
        ApexPages.currentPage().getParameters().put('accountId', acc.Id);
        Case caseRecord = new Case();
        caseRecord.Type = 'Weed';
        caseRecord.AccountId = acc.Id;
        caseRecord.ContactId = con.Id;
        caseRecord.Sub_Query__c = 'Availability';
        caseRecord.QRC__c = 'Query';
        caseRecord.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
        caseRecord.Status = 'Closed';
        caseRecord.Other_Crop_Name__c='test';
        caseRecord.Theme_of_Month__c=false;
        caseRecord.Promotional_Product__c = testPromotionalProduct.Id;
        caseRecord.Croplist_is_Already_Updated__c=false;
        caseRecord.Crop_Type__c='Fruits';
        caseRecord.CropName__c='Kinnow (128)';
        caseRecord.Sowing_Date__c=myDate;
        caseRecord.Season_Type__c='Summer Season';
        caseRecord.Override__c=false;
        caseRecord.Acreage__c=12;
        caseRecord.Type_of_farm__c='Irrigated';
        Apexpages.StandardController sc = new Apexpages.StandardController(caseRecord);
        UPL_GeneralCase_Creation_Controller record =  new UPL_GeneralCase_Creation_Controller(sc);
        record.saveAndNewFunctionality();
        Test.stopTest();
    }
    
    
    static testMethod void saveAndNewFunctionalityExceptionCoverage(){
        Test.startTest();
        Case caseRecord = new Case();
        caseRecord.Type = 'Weed';
        caseRecord.Sub_Query__c = 'Availability';
        caseRecord.QRC__c = 'Query';
        Apexpages.StandardController sc = new Apexpages.StandardController(caseRecord);
        UPL_GeneralCase_Creation_Controller record =  new UPL_GeneralCase_Creation_Controller(sc);
        record.saveAndNewFunctionality();
        Test.stopTest();
    }
    
    static testMethod void cancelFunctionalityCoverage(){
        Test.startTest();
        Case caseRecord = new Case();
        caseRecord.Type = 'Weed';
        caseRecord.Sub_Query__c = 'Availability';
        caseRecord.QRC__c = 'Query';
        Apexpages.StandardController sc = new Apexpages.StandardController(caseRecord);
        UPL_GeneralCase_Creation_Controller record =  new UPL_GeneralCase_Creation_Controller(sc);
        record.cancelFunctionality();
        Test.stopTest();
    }
    
    static testMethod void escalationCoverage(){
        Test.startTest();
        Id UPLRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
        Case caseRecord = new Case();
        caseRecord.Type = 'Pricing';
        caseRecord.Sub_Query__c = 'Wrongly Charged';
        caseRecord.QRC__c = 'Complaint';
        caseRecord.Description = 'test';
        caseRecord.Status = 'Escalated-L1';
        caseRecord.Customer_Type__c = 'Farmer';
        caseRecord.Origin__c = 'Phone';
        caseRecord.RecordTypeId = UPLRecordTypeID;
        ApexPages.currentPage().getParameters().put('RecordTypeId',UPLRecordTypeID);
        Apexpages.StandardController sc = new Apexpages.StandardController(caseRecord);
        UPL_GeneralCase_Creation_Controller record =  new UPL_GeneralCase_Creation_Controller(sc);
        record.saveFunctionality();
        record.doNothing();
        Test.stopTest();
    }
    
    static testMethod void unit1(){
        Test.startTest();
        Id UPLRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC Retailer').getRecordTypeId();
        Case caseRecord = new Case();
        caseRecord.Type = 'Pricing';
        caseRecord.Sub_Query__c = 'Wrongly Charged';
        caseRecord.QRC__c = 'Complaint';
        caseRecord.Description = 'test';
        caseRecord.Status = 'Escalated-L1';
        caseRecord.Customer_Type__c = 'Farmer';
        caseRecord.Origin__c = 'Phone';
        caseRecord.RecordTypeId = UPLRecordTypeID;
        ApexPages.currentPage().getParameters().put('RecordTypeId',UPLRecordTypeID);
        Apexpages.StandardController sc = new Apexpages.StandardController(caseRecord);
        UPL_GeneralCase_Creation_Controller record =  new UPL_GeneralCase_Creation_Controller(sc);
        //record.saveFunctionality();
        //record.doNothing();
        //
        Id SWALRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SWAL General Case').getRecordTypeId();
        Case caseRecord2 = new Case();
        caseRecord2.RecordTypeId = UPLRecordTypeID;
        ApexPages.currentPage().getParameters().put('RecordTypeId',SWALRecordTypeID);
        Apexpages.StandardController sc2 = new Apexpages.StandardController(caseRecord2);
        UPL_GeneralCase_Creation_Controller record2 =  new UPL_GeneralCase_Creation_Controller(sc2);
        
        Test.stopTest();
    }
}