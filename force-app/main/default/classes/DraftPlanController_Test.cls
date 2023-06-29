@isTest
public class DraftPlanController_Test {
static testMethod void CallDraftPlan()
{
    Test.startTest();
    Sales_Org__c sorg=TestDataFactory.CreateSalesOrgCode();
    Sales_Org__c sorg1= TestDataFactory.CreateSalesOrgCodeCanada();
    UPL_Settings__c monthSetting = UPL_Settings__c.getInstance();
        monthSetting.MKT_YR_USA__c=10;
        monthSetting.MKT_YR_CAN__c=30;
        monthSetting.MKT_YR_Visibility__c=30;
        monthSetting.Visibility_Date__c=30;
        insert monthSetting;
    Account acc = TestDataFactory.CreateAccount('spCode');
    acc.Name='ABC';
    acc.Mobile__c='9090909090';
    acc.Email__c='abc@mail.com';
    acc.Sales_Org__c=sorg.Id;
    update acc;
            CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper = CalculateMarkettingYearHelper.calculateMarketingYear(sorg.Sales_Org_Code__c);
            CalculateMarkettingYearHelper.MarketingYearWrapper mktYearWrapper1 = CalculateMarkettingYearHelper.calculateMarketingYear(sorg1.Sales_Org_Code__c);

        Draft_Plan_Header__c dh=TestDataFactory.CreatedfHeader(sorg,acc,mktYearWrapper);
	SKU__c sku=TestDataFactory.CreateSKU('Test123',sorg,'comb' );
    	sku.Product_Category__c='Herbicides';
    	sku.Name='Test1';
    	update sku;
    SKU__c sku1=TestDataFactory.CreateSKU('Test125',sorg,'comb1' );
    	//sku.Product_Category__c='CereHerbicides';
    	sku1.Name='Test2';
    	update sku;
    CalculateMarkettingYearHelper.calculateYearWithoutVisibility('3100');
    Draft_Plan__c df=TestDataFactory.CreatedfPlan(sorg,acc,dh,sku,'test567g');
        Draft_Plan__c df1=TestDataFactory.CreatedfPlan(sorg,acc,dh,sku1,'test567g1');

    	Draft_Plan_Payout__c dpp = TestDataFactory.CreatedfPay(df);
    ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        DraftPlanController acc1 = new DraftPlanController(sc);
        
        PageReference pageRef = Page.DraftPlanPDF;
        pageRef.getParameters().put('id', acc.id);
        Test.setCurrentPage(pageRef);
    DraftPlanDivision dp=new DraftPlanDivision(sc);
    dp.createPDF();
    dp.getdivisionWrapper();
    PageReference pageRef1 = Page.DraftPlanDivision;
        pageRef1.getParameters().put('id', acc.id);
        Test.setCurrentPage(pageRef1);
    
    Test.stopTest();

}
}