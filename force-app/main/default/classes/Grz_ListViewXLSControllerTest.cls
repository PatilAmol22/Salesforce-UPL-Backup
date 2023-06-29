@isTest
public class Grz_ListViewXLSControllerTest {
    public static testmethod void unitTest(){
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'Brazil', '5191');
        Customer_Conversion_factor__c ccf= new Customer_Conversion_factor__c();
        ccf.Customer_Group__c='tt';
        ccf.Brand_Name__C='testbrand';
        ccf.Combination_Key__c='tt5191testbrand';
        ccf.Conversion_Factor__c=10;
        ccf.Sales_Org__c=sorg.Id;
        insert ccf;
        
        Market_Variation__c mv= new Market_Variation__c();
        mv.Market_Variation__c=1;
        mv.SKU_Brand__c='test';
        mv.Region_Code__c='abcd';
        mv.Combination_Key__c='bbabcdtest5191';
        mv.Sales_Org__c=sorg.Id;
        insert mv;
        
        Sales_District_Cost__c sdc= new Sales_District_Cost__c();
        sdc.Sales_District_Cost__c=2;
        sdc.Region_Code__c='abcd';
        sdc.Sales_Org__c=sorg.Id;
        sdc.Combination_Key__c='BRabcd5191';
        insert sdc;
        
        Discount_Matrix__c dm= new Discount_Matrix__c();
        dm.Brand_Name__c='abcd';
        dm.BU_Manager__c=1;
        dm.Sales_District_Manager__c=1;
        dm.Sales_Director__c=1;
        dm.Sales_Person__c=1;
        dm.Combination_key__c='abcd5191';
        dm.Sales_Org__c=sorg.Id;
        insert dm;

        test.startTest();
        Grz_ListViewXLSController obj= new Grz_ListViewXLSController();
        obj.Grz_getCCF();
        obj.Grz_getMV();
        obj.Grz_getSdc();
        obj.Grz_getDM();
        test.stopTest();
    }
}