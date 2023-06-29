/*
* Name : UPL_GeneralCase_Edit_Controller_Test
* Created on : 26th May 2020
* Developer : Varun Shrivastava                               
* Description : To provide Coverage to UPL_GeneralCase_EditCreation_Controller class 
* Last Stable Backup : 
*/
@isTest(seeAllData=false)
private class UPL_GeneralCase_Edit_Controller_Test {
   
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

            /*UPL_Settings__c uplsetting = new UPL_Settings__c();
            uplsetting.Name = 'UPLSetting';
            uplsetting.India_SAS_Sales_Org__c = '1000';
            INSERT uplsetting;*/

            Sales_Org__c salesOrg = new Sales_Org__c();
            salesOrg.Name = 'Test Org';
            salesOrg.Sales_Org_Code__c = '1000';
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
            promotionalProduct.Financial_Year__c = '2021';
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
        UPL_GeneralCase_EditCreation_Controller record =  new UPL_GeneralCase_EditCreation_Controller();
        
        Test.stopTest();
    }
    
    static testMethod void renderSectionsCoverage(){
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
        ApexPages.currentPage().getParameters().put('id',caseRecord.ID);
        UPL_GeneralCase_EditCreation_Controller record =  new UPL_GeneralCase_EditCreation_Controller();
        record.renderSections();
        record.toggleCallerField();
        Test.stopTest();
    }
    
    
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
        caseRecord.Acreage__c=12;
        caseRecord.Type_of_farm__c='Irrigated';
        caseRecord.Crop_pick__c = 'Amla';
        caseRecord.Department__c='.Farm';
        caseRecord.QRC_Category__c = 'Agronomy';
        caseRecord.QRC_sub_category__c='Product';
        caseRecord.Reason_for_calling__c ='Product Complaint';
        caseRecord.Origin__c = 'Phone';
        caseRecord.Caller_Type__c = 'Account Holder	';
        caseRecord.QRC_type__c = 'Complaint';
        insert caseRecord;
        ApexPages.currentPage().getParameters().put('id',caseRecord.ID);
        UPL_GeneralCase_EditCreation_Controller record =  new UPL_GeneralCase_EditCreation_Controller();
        record.saveFunctionality();
        record.toggleCallerField();
        record.showRecomSec();
        record.doNothing();
        Test.stopTest();
    }
    
    static testMethod void saveProductRecommendationCoverage(){
        Test.startTest();
        
        Promotional_Product__c testPromotionalProduct = [Select Id from Promotional_Product__c limit 1];
        Date myDate = date.newInstance(2020,05,06);
        
        Account acc = [Select Id from Account where Name = 'test account' limit 1];
        Contact con = [Select ID from Contact where Email = 'test@email.com' limit 1];
        
        Case productRecommendationRecord = new Case();
        productRecommendationRecord.Type = 'Product Recommendation';
        productRecommendationRecord.AccountId = acc.Id;
        productRecommendationRecord.ContactId = con.Id;
        productRecommendationRecord.Product_Recommendation_Case__c = null;
        productRecommendationRecord.Sub_Query__c = 'Weed';
        productRecommendationRecord.QRC__c = 'Query';
        productRecommendationRecord.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
        productRecommendationRecord.Status = 'Closed';
        productRecommendationRecord.Product_Recommended_1_gc__c = 'Avert';
        productRecommendationRecord.Dose_1_gc__c= '100';
        productRecommendationRecord.Measure_1_gc__c='Gm Per Acre';
        insert productRecommendationRecord;
        ApexPages.currentPage().getParameters().put('id',productRecommendationRecord.ID);
        UPL_GeneralCase_EditCreation_Controller record1 =  new UPL_GeneralCase_EditCreation_Controller();
        record1.renderSections();
        
        
        
        Test.stopTest();
    }
    
   
    static testMethod void saveFunctionalityExceptionCoverage(){
        Test.startTest();
        Case caseRecord = new Case();
        caseRecord.Type = 'Weed';
        caseRecord.Sub_Query__c = 'Availability';
        caseRecord.QRC__c = 'Query';
        caseRecord.Status ='Closed';
        caseRecord.Crop_pick__c = 'Amla';
        insert caseRecord;
        ApexPages.currentPage().getParameters().put('id',caseRecord.ID);
        
        UPL_GeneralCase_EditCreation_Controller record =  new UPL_GeneralCase_EditCreation_Controller();
        record.saveFunctionality();
        Test.stopTest();
    }
    
    static testMethod void saveAndNewFunctionalityCoverage(){
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
        UPL_GeneralCase_EditCreation_Controller record =  new UPL_GeneralCase_EditCreation_Controller();
        record.saveAndNewFunctionality();
        Test.stopTest();
    }
    
    
    static testMethod void saveAndNewFunctionalityExceptionCoverage(){
        Test.startTest();
        Case caseRecord = new Case();
        caseRecord.Type = 'Weed';
        caseRecord.Sub_Query__c = 'Availability';
        caseRecord.QRC__c = 'Query';
        UPL_GeneralCase_EditCreation_Controller record =  new UPL_GeneralCase_EditCreation_Controller();
        record.saveAndNewFunctionality();
        Test.stopTest();
    }
    
    static testMethod void cancelFunctionalityCoverage(){
        Test.startTest();
        Case caseRecord = new Case();
        caseRecord.Type = 'Weed';
        caseRecord.Sub_Query__c = 'Availability';
        caseRecord.QRC__c = 'Query';
        UPL_GeneralCase_EditCreation_Controller record =  new UPL_GeneralCase_EditCreation_Controller();
        record.cancelFunctionality();
        Test.stopTest();
    }
}