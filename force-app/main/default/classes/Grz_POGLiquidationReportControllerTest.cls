@isTest
public class Grz_POGLiquidationReportControllerTest {
    
    @TestSetup
    static void makeData(){
        
        Liquidation_Batch_Filters__c lbf2 = new Liquidation_Batch_Filters__c();
        lbf2.Name = 'Poland';
        lbf2.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'2941\'';
        lbf2.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
        lbf2.Distributor_Filter__c = 'test';
        lbf2.Active__c = true;
        
        insert lbf2;
        
        
        Sales_Org__c so_indo1 = new Sales_Org__c();
        so_indo1.Name='Poland';
        so_indo1.Sales_Org_Code__c='2941';
        insert so_indo1;
        
        
        
        
        
        List<SKU__c> skuList = new List<SKU__c>();
        SKU__c sku12 = new SKU__c();
        sku12.Name = '6 LTR11';
        sku12.SKU_Code__c = '0000000000051600321';
        sku12.Brand_Name__c = 'ABACO1';
        sku12.IsParent__c = true;
        sku12.SKU_Description__c = 'SCANNER (PARAQUAT DICHLOR 276SL) 5L1T....';
        sku12.Active_for_Liquidation__c =true;
        sku12.Sales_Org__c = so_indo1.Id;
        skuList.add(sku12);
        
        SKU__c sku1 = new SKU__c();
        sku1.Name = '6 LTR';
        sku1.SKU_Code__c = '000000000005160032';
        sku1.Parent_SKU__c = sku12.id;
        sku1.Brand_Name__c = 'ABACO';
        sku1.IsParent__c = true;
        sku1.SKU_Description__c = 'SCANNER (PARAQUAT DICHLOR 276SL) 5LT....';
        sku1.Active_for_Liquidation__c =true;
        sku1.Sales_Org__c = so_indo1.Id;
        skuList.add(sku1);
        insert skuList;
        
        
        Id rec_type_acc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account acc1 = new Account();
        acc1.Name = 'acc1';
        acc1.Account_Type__c = 'Sold To Party';
        acc1.RecordTypeId=rec_type_acc;
        acc1.Sales_Org__c = so_indo1.Id;
        insert acc1;        
        
        Id rec_type_LAP = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Liquidation_Annual_Plan__c lap = new Liquidation_Annual_Plan__c();
        lap.FIscal_Year__c = '2020-2021';
        //lap.Fiscal_Start_Date__c = Date.newInstance(Integer.valueOf('2020'), 4, 1); 
        lap.Fiscal_Start_Date__c = Date.newInstance(Integer.valueOf(System.Today().year()), 4, 1);
        lap.Fiscal_End_Date__c =  Date.newInstance(Integer.valueOf(System.Today().year()+1), 3, 31); 
        lap.Distributor__c = acc1.Id;
        lap.Sales_Org__c = so_indo1.Id;
        lap.recordTypeId = rec_type_LAP;
        insert lap;
        
        Id rec_type_OI = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        List<Opening_Inventory2__c> oiList=new List<Opening_Inventory2__c>();
        Opening_Inventory2__c o1 = new Opening_Inventory2__c();
        o1.Liquidation_Annual_Plan__c = lap.Id;
        o1.Multi_Country_Key__c = '12345';
        o1.RecordTypeId = rec_type_OI;
        o1.Distributor__c = acc1.Id;
        o1.SKU__c = sku1.Id;
        o1.Sent_to_Batch__c = false;
        
        
        oiList.add(o1);
        Opening_Inventory2__c o11 = new Opening_Inventory2__c();
        o11.Liquidation_Annual_Plan__c = lap.Id;
        o11.Multi_Country_Key__c = '12345';
        o11.RecordTypeId = rec_type_OI;
        o11.Distributor__c = acc1.Id;
        o11.SKU__c = sku1.Id;
        o11.Sent_to_Batch__c = false;
        
        oiList.add(o11);
        insert oiList;
        system.debug(o1);
        
        
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        Id rec_type_liquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Liquidation2__c liquidation = new Liquidation2__c();
        liquidation.Quarter__c = 'Quarter 3';
        liquidation.Distributor__c = acc1.Id;
        liquidation.Liquidation_Annual_Plan__c = lap.Id;
        liquidation.Distributors_Inventory__c = 21;
        liquidation.SKU__c = sku1.Id;
        liquidation.SKU_Code__c = sku1.SKU_Code__c;
        liquidation.Brand_Name__c = sku1.Brand_Name__c;
        liquidation.SKU_Description__c = sku1.SKU_Description__c;
        liquidation.RecordTypeId = rec_type_liquidation;
        liquidation.Opening_Inventory2__c = o1.Id;
        liqList.add(liquidation);
        
        Liquidation2__c liquidation1 = new Liquidation2__c();
        liquidation1.Quarter__c = 'Quarter 3';
        liquidation1.Distributor__c = acc1.Id;
        liquidation1.Liquidation_Annual_Plan__c = lap.Id;
        liquidation1.SKU__c = sku1.Id;
        liquidation1.SKU_Code__c = sku1.SKU_Code__c;
        liquidation1.Brand_Name__c = sku1.Brand_Name__c;
        liquidation1.SKU_Description__c = sku1.SKU_Description__c;
        liquidation1.RecordTypeId = rec_type_liquidation;
        liquidation1.Opening_Inventory2__c = o1.Id;
        liqList.add(liquidation1);
        
        Liquidation2__c liquidation2 = new Liquidation2__c();
        liquidation2.Quarter__c = 'Quarter 3';
        liquidation2.Distributor__c = acc1.Id;
        liquidation2.Liquidation_Annual_Plan__c = lap.Id;
        liquidation2.SKU__c = sku1.Id;
        liquidation2.SKU_Code__c = sku1.SKU_Code__c;
        liquidation2.Brand_Name__c = sku1.Brand_Name__c;
        liquidation2.SKU_Description__c = sku1.SKU_Description__c;
        liquidation2.RecordTypeId = rec_type_liquidation;
        liquidation2.Opening_Inventory2__c = o1.Id;
        liqList.add(liquidation2); 
        
        insert liqList;
        
        MultiCountry_Liquidation__c montlyliq = new MultiCountry_Liquidation__c();
        montlyliq.Name = 'All Countries';
        montlyliq.Active_Month__c = true;
        montlyliq.Month__c = 'Apr';
        montlyliq.Previous_Month__c = 'Mar';
        insert montlyliq;
        
        list<string> test = new list<string>();
        list<string> test1 = new list<string>();
        list<string> test2 = new list<string>();
        test.add(acc1.id);
        test1.add(sku1.id);
        test2.add(sku1.Brand_Name__c);
        Grz_POGLiquidationReportController.getPOGLiquidationReportData(test,String.valueOf(System.Today().year()),'Quarter 3',test1,true);
        
        Grz_POGLiquidationReportController.getPOGLiquidationReportDataBrand(test,String.valueOf(System.Today().year()),'Quarter 3',test2,true);
        Grz_POGLiquidationReportController.getDependentSKUDec(test);
        Grz_POGLiquidationReportController.getPOGLiquidationReportDataCustomer(test,String.valueOf(System.Today().year()),'Quarter 3',test1,test2,true);
        Grz_POGLiquidationReportController.getPOGLiquidationReportDataBrandForVF(test,String.valueOf(System.Today().year()),'Quarter 3',test2,true,'');
        Grz_POGLiquidationReportController.getPOGLiquidationReportDataCustomerforVF(test,String.valueOf(System.Today().year()),'Quarter 3',test1,test2,true,'');
    }
    
    Public static testmethod void testPOGLiquidationReport(){
        
        Account acc1 = [select id,Name from Account where Name='acc1' limit 1];
        SKU__c sku1 = [select id,Name,SKU_Code__c,SKU_Description__c,Brand_Name__c from SKU__c where Brand_Name__c = 'ABACO' limit 1];        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('distributor', String.valueOf(acc1.Id));
        ApexPages.currentPage().getParameters().put('distributorName', String.valueOf(acc1.Name));
        ApexPages.currentPage().getParameters().put('year', String.valueOf(System.Today().year()));
        ApexPages.currentPage().getParameters().put('quarter', 'Quarter 3');
        ApexPages.currentPage().getParameters().put('skuList', String.valueOf(sku1.Id));
        ApexPages.currentPage().getParameters().put('search', 'ABACO');
        ApexPages.currentPage().getParameters().put('selectedColumn','-');
        Grz_LiquidationReportVFController.getPOGLiquidationReport();
        Grz_POGLiquidationReportController.getPOGBrandList();
        Grz_POGLiquidationReportController.getPOGSkusList('sku_code');
        
        Test.stopTest(); 
        
    }
    
    Public static testmethod void testPOGLiquidationReportBrand(){
        
        Account acc1 = [select id,Name from Account where Name='acc1' limit 1];
        SKU__c sku1 = [select id,Name,SKU_Code__c,SKU_Description__c,Brand_Name__c from SKU__c limit 1];        
        
        Test.startTest();      
        ApexPages.currentPage().getParameters().put('distributor', String.valueOf(acc1.Id));
        ApexPages.currentPage().getParameters().put('year', String.valueOf(System.Today().year()));
        ApexPages.currentPage().getParameters().put('quarter', 'Quarter 3');
        ApexPages.currentPage().getParameters().put('brandList', String.valueOf(sku1.Brand_Name__c));
        ApexPages.currentPage().getParameters().put('search', '');
        ApexPages.currentPage().getParameters().put('selectedColumn','-');
        
        Grz_LiquidationReportVFBrandController.getPOGLiquidationReport();
        Grz_POGLiquidationReportController.getPOGSkusList('SKU_Description');
        Test.stopTest(); 
        
    }
    
    Public static testmethod void testPOGLiquidationReportCustomer(){
        
        Account acc1 = [select id,Name from Account where Name='acc1' limit 1];
        SKU__c sku1 = [select id,Name,SKU_Code__c,SKU_Description__c,Brand_Name__c from SKU__c limit 1];        
        
        Test.startTest();      
        ApexPages.currentPage().getParameters().put('distributor', String.valueOf(acc1.Id));
        ApexPages.currentPage().getParameters().put('year', String.valueOf(System.Today().year()));
        ApexPages.currentPage().getParameters().put('quarter', 'Quarter 3');
        ApexPages.currentPage().getParameters().put('brandList', String.valueOf(sku1.Brand_Name__c));
        ApexPages.currentPage().getParameters().put('skuList', String.valueOf(sku1.Id));
        ApexPages.currentPage().getParameters().put('search', '');
        ApexPages.currentPage().getParameters().put('selectedColumn','-');
        Grz_LiquidationReportVFCustomer.getPOGLiquidationReport();
        
        Grz_POGLiquidationReportController.checkPriceloaded('2020');
        Test.stopTest(); 
        
    }
    
    
}