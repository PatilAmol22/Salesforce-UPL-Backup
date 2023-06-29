@isTest
public class SecondarySalesDataTriggerHandlerTest {
	@isTest
    public static void test1(){
        test.startTest();
        Sales_org__c so = new Sales_org__c();
        so.Name = 'USA';
        so.Sales_Org_Code__c = '3100';
        insert so;
        
        SKU__c sku = new SKU__c();
        sku.Name = 'USA SKU';
        sku.SKU_Code__c = '000000000000012345';
        sku.sales_org__c = so.Id;
        insert sku;
        
        Account acc = new Account();
        acc.Name = 'Nam Test';
        acc.EBID__c = '12345';
        acc.Sales_org__c = so.Id;
        insert acc;
        
        Secondary_Sales_Data__c ssd = new Secondary_Sales_Data__c();
        ssd.EBID__c = '12345';
        ssd.Sales_Org__c = so.Id;
        ssd.Customer_Product_Code__c = '12345';
        insert ssd;
        test.stopTest();
    }
}