@isTest
public class DraftPlanRegionEntryClass_Test {
    static testMethod void GenerateTest(){
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrgCode();
        UPL_Settings__c monthSetting = UPL_Settings__c.getInstance();
        monthSetting.MKT_YR_USA__c=10;
        monthSetting.MKT_YR_CAN__c=30;
        monthSetting.MKT_YR_Visibility__c=30;
        monthSetting.Visibility_Date__c=30;
        monthSetting.Division__c='None,None,10,60,75,76,77,78,79';
        insert monthSetting;
        Division__C div=new division__c();
        div.name='75';
        div.division_code__c='75';
        insert div;
        //Marketing_Year__c mkt= TestDataFactory.CreateMarkettingYear(sorg);
        Region__c reg=TestDataFactory.CreateRegion(sorg,'4100');
        SKU__c sku=TestDataFactory.CreateSKU('Test123',sorg,'comb' );
        sku.Product_Category__c='Herbicides';
        sku.Name='Test1';
        sku.division__c=div.id;
        sku.IsParent__c=true;
        
        update sku;
        Region__c reg1=TestDataFactory.CreateRegion(sorg,'4200');
        //reg1.division__c=div.id;
        update reg1;
     /*   SKU__c sku1=TestDataFactory.CreateSKU('Test456',sorg,'comb123' );
        sku1.Product_Category__c='Cereal Herbicides';
        sku1.Name='Test2';
        sku1.division__c=div.id;
        update sku1;*/
        Account acc = TestDataFactory.CreateAccount('spCode');
    acc.Name='ABC';
    acc.Mobile__c='9090909090';
    acc.Email__c='abc@mail.com';
    acc.Sales_Org__c=sorg.Id;
        acc.Division__c=div.Id;
    update acc;
        CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper = CalculateMarkettingYearHelper.calculateMarketingYear(sorg.Sales_Org_Code__c);
            Draft_Plan_Header__c dh=TestDataFactory.CreatedfHeader(sorg,acc,mktYearWrapper);
    Draft_Plan__c df=TestDataFactory.CreatedfPlan(sorg,acc,dh,sku,'test123g');

        Draft_Plan_Region__c dpr=TestDataFactory.CreatedfRegion(reg,sku,mktYearWrapper,div.id);
        DraftPlanRegionEntryClass.getDivsions();
        system.debug('mktYearWrapper'+mktYearWrapper);
        List<Draft_Plan_Region__c> dfrList=[select id,Combination_Key__c,Draft_Quantity__c,MKT_Year_End_Date__c,MKT_Year_Start_Date__c,MKT_Year_Name__c,
                                            Region__c,Region__r.name,Region__r.RegionCode__c,SKU__c,SKU__r.Name,SKU__r.SKU_Code__c,SKU__r.Product_Category__c,SKU__r.SKU_Description__c,sku__r.UOM__c,
                                            EDI_Quantity_LLY__c,EDI_Quantity_LY__c,Invoice_Quantity_LY__c,Division__c from Draft_Plan_Region__c];
            system.debug('inTest'+dfrList);
        DraftPlanRegionEntryClass.dfRegionWrapper dfReg= DraftPlanRegionEntryClass.generateWrapper('first',div.id);
        DraftPlanRegionEntryClass.dfRegionWrapper dfReg1= DraftPlanRegionEntryClass.generateWrapper('second',div.id);
        DraftPlanRegionEntryClass.getHiearchySettings();
        DraftPlanRegionEntryClass.getMarketingYear();
        List<DraftPlanRegionEntryClass.finalDraftRegWrapper> fin=dfReg.finalWrap;
        DraftPlanRegionEntryClass.createDraftPlanRegion(fin,'first',sorg.Sales_Org_Code__c,div.Id);
    }
    
}