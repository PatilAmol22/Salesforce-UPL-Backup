@isTest
public class TargetPlanningFormController_Test {
    static testMethod void targetTest(){
        Test.startTest();
        Sales_Org__c sorg=TestDataFactory.CreateSalesOrgCode();
                     Sales_Org__c sorg1 = [Select id, name,Sales_Org_Code__c from Sales_Org__c where id =:sorg.Id limit 1];

        UPL_Settings__c monthSetting = UPL_Settings__c.getInstance();
        monthSetting.MKT_YR_USA__c=10;
        monthSetting.MKT_YR_CAN__c=30;
        monthSetting.MKT_YR_Visibility__c=30;
        monthSetting.Visibility_Date__c=30;
        monthSetting.Target_Plan_Visibility__c=5;
        monthSetting.Draft_Record_Per_Page__c=10;
		monthSetting.Division__c='None,None,10,60,75,76,77,78,79';        
        insert monthSetting;
        //Marketing_Year__c mkt= TestDataFactory.CreateMarkettingYear(sorg);
        CalculateMarkettingYearHelper.MarketingYearWrapper mkt = CalculateMarkettingYearHelper.calculateMarketingYear(sorg1.Sales_Org_Code__c);

        Account acc = TestDataFactory.CreateAccount('spCode');
        acc.Name='ABC';
        acc.Mobile__c='9090909090';
        acc.Email__c='abc@mail.com';
        acc.Sales_Org__c=sorg.Id;
        update acc;
        Draft_Plan_Header__c dh=TestDataFactory.CreatedfHeader(sorg,acc,mkt);
        dh.Status__c='Approved';
        update dh;
        SKU__c sku=TestDataFactory.CreateSKU('Test123',sorg,'comb' );
        sku.Product_Category__c='Herbicides';
        sku.Name='Test1';
        update sku;
        
        Draft_Plan__c df=TestDataFactory.CreatedfPlan(sorg,acc,dh,sku,'test123g');
        User u = TestDataFactory.CreateUser();
        u.Country = 'USA';
        update u;
        Division__C div=new division__c();
        div.name='75';
        div.division_code__c='75';
        insert div;
        User u1=new user(id=Userinfo.getUserId());
        u1.Country = 'USA';
        update u1;
        System.runAs(u1) {
            TargetPlanningFormController.getPageSize();
        TargetPlanningFormController.getMarketingYear();
        TargetPlanningFormController.getLastSavedData('first');
            TargetPlanningFormController.getDivisions();
        List<TargetPlanningFormController.SKUWrapper> skulist = TargetPlanningFormController.getSKUWrapper('first',div.Id);
        //skulist[0].targetTotal = 100;
        TargetPlanningFormController.saveTargetData(skulist,'first',div.Id);
        TargetPlanningFormController.getLastSavedData('Second');
        List<TargetPlanningFormController.SKUWrapper> skulist1 = TargetPlanningFormController.getSKUWrapper('Second',div.Id);
        //skulist1[0].targetTotal = 500;
        TargetPlanningFormController.saveTargetData(skulist1,'Second',div.Id);
        }
    }
    static testMethod void targetTestcad(){
        Test.startTest();
        Sales_Org__c sorg=TestDataFactory.CreateSalesOrgCodeCanada();
                     Sales_Org__c sorg1 = [Select id, name,Sales_Org_Code__c from Sales_Org__c where id =:sorg.Id limit 1];

        UPL_Settings__c monthSetting = UPL_Settings__c.getInstance();
        monthSetting.MKT_YR_USA__c=10;
        monthSetting.MKT_YR_CAN__c=30;
        monthSetting.MKT_YR_Visibility__c=30;
        monthSetting.Visibility_Date__c=30;
        monthSetting.Target_Plan_Visibility__c=5;
        monthSetting.Draft_Record_Per_Page__c=10;
        insert monthSetting;
        //Marketing_Year__c mkt= TestDataFactory.CreateMarkettingYear(sorg);
        CalculateMarkettingYearHelper.MarketingYearWrapper mkt = CalculateMarkettingYearHelper.calculateMarketingYear(sorg1.Sales_Org_Code__c);

        Account acc = TestDataFactory.CreateAccount('spCode');
        acc.Name='ABC';
        acc.Mobile__c='9090909090';
        acc.Email__c='abc@mail.com';
        acc.Sales_Org__c=sorg.Id;
        update acc;
        Division__C div=new division__c();
        div.name='75';
        div.division_code__c='75';
        insert div;
        Draft_Plan_Header__c dh=TestDataFactory.CreatedfHeader(sorg,acc,mkt);
        dh.Status__c='Approved';
        dh.Division__c=div.id;
        update dh;
        SKU__c sku=TestDataFactory.CreateSKU('Test123',sorg,'comb' );
        sku.Product_Category__c='Herbicides';
        sku.Name='Test1';
        update sku;
        
        Draft_Plan__c df=TestDataFactory.CreatedfPlan(sorg,acc,dh,sku,'test123g');
        
        User u = TestDataFactory.CreateUser();
        u.Country = 'Canada';
        update u;
        
        User u1=new user(id=Userinfo.getUserId());
        u1.Country = 'Canada';
        update u1;
        Target_Plan__c tp=new Target_Plan__c();
        tp.MKT_Year_Start_Date__c=mkt.firstMarketingYearStartDate;
        tp.MKT_Year_End_Date__c	=mkt.firstMarketingYearEndDate;
        tp.Sales_Org__c=sorg.id;
        insert tp;
        System.runAs(u1) {
            TargetPlanningFormController.getPageSize();
        TargetPlanningFormController.getMarketingYear();
        TargetPlanningFormController.getLastSavedData('first');
        List<TargetPlanningFormController.SKUWrapper> skulist = TargetPlanningFormController.getSKUWrapper('first',div.Id);
        //skulist[0].targetTotal = 100;
        TargetPlanningFormController.saveTargetData(skulist,'first',div.Id);
        TargetPlanningFormController.getLastSavedData('Second');
        List<TargetPlanningFormController.SKUWrapper> skulist1 = TargetPlanningFormController.getSKUWrapper('Second',div.Id);
        //skulist1[0].targetTotal = 500;
        TargetPlanningFormController.saveTargetData(skulist1,'Second',div.Id);
        }
    }
}