@isTest 
public class LiquidationUploadControllerTest {
    static testMethod void validateHelloWorld() {

        Sales_Org__c so_indo1 = new Sales_Org__c();
        so_indo1.Name='UPL-Indonesia';
        so_indo1.Sales_Org_Code__c='6451';
        insert so_indo1;

        SKU__c sku = new SKU__c();
        sku.Name='DOST';
        sku.SKU_Code__c='704002';
        sku.SKU_Pack__c=1.00;
        sku.SKU_UOM__c='L';
        sku.Multiple_Of__c=5;
        sku.Group__c='DOST';
        sku.Pack_Size__c=10.00;
        sku.Sales_Org__c = so_indo1.Id;
        sku.UOM__c='L';
        sku.Brand_Name__c = 'ABACO';
        sku.SKU_Description__c = 'SCANNER (PARAQUAT DICHLOR 276SL) 5LT....';
        sku.Active__c=True;
        sku.Combination_Key__c='Cooooooo000011111';
        insert sku;

        User usr_regional_manager = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Indonesia'].Id,
        LastName = 'RM',
        Email = 'test@test.com',
        Username = 'test@test.com' + System.currentTimeMillis(),
        CompanyName = 'TEST',
        Country = 'Indonesia',
        Title = 'title',
        Alias = 'alias',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US'
        );
        insert usr_regional_manager;
        
        Sales_District__c sales_dis = new Sales_District__c();
        sales_dis.Name = 'sale_dist';
        sales_dis.User__c = usr_regional_manager.Id;
        sales_dis.Sales_District_Code__c = 'ID0004';
        insert sales_dis;

        Sales_District__c sales_dis1 = new Sales_District__c();
        sales_dis1.Name = 'poland';
        sales_dis1.User__c = usr_regional_manager.Id;
        sales_dis1.Sales_District_Code__c = 'ID0005';
        insert sales_dis1;

        
        Id rec_type_acc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account acc1 = new Account();
        acc1.Name = 'acc1';
        acc1.Sales_District__c = sales_dis.Id;
        acc1.Account_Type__c = 'Sold To Party';
        acc1.RecordTypeId=rec_type_acc;
        acc1.Sales_Org__c = so_indo1.Id;
        acc1.SAP_Code__c = '0001173742';
        insert acc1;

        Id rec_type_LAP = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        
        Liquidation_Annual_Plan__c lap = new Liquidation_Annual_Plan__c();
        lap.FIscal_Year__c = '2020-2021';
        lap.Fiscal_Start_Date__c = Date.newInstance(Integer.valueOf('2020'), 4, 1); 
        lap.Fiscal_End_Date__c =  Date.newInstance(Integer.valueOf('2021'), 3, 31); 
        lap.Distributor__c = acc1.Id;
        lap.Sales_Org__c = so_indo1.Id;
        lap.recordTypeId = rec_type_LAP;
        insert lap;

        Id rec_type_OI = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        
        Opening_Inventory2__c oi = new Opening_Inventory2__c();
        oi.SKU__c = sku.Id;
        oi.Sales_District__c = sales_dis.Id;
        oi.Distributor__c = acc1.Id;
        oi.Opening_Inventory__c = 3360;
        oi.Liquidation_Annual_Plan__c = lap.Id;
        oi.recordTypeId = rec_type_OI;
        insert oi;

        Id rec_type_liquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        
        Liquidation2__c liquidation = new Liquidation2__c();
        liquidation.Month__c = 'Sept';
        liquidation.Distributor__c = acc1.Id;
        liquidation.Liquidation_Annual_Plan__c = lap.Id;
        liquidation.SKU__c = sku.Id;
        liquidation.SKU_Code__c = sku.SKU_Code__c;
        liquidation.Brand_Name__c = sku.Brand_Name__c;
        liquidation.SKU_Description__c = sku.SKU_Description__c;
        liquidation.Sales_District__c = sales_dis.Id;
        liquidation.RecordTypeId = rec_type_liquidation;
        liquidation.Opening_Inventory2__c = oi.Id;
        insert liquidation;
        
        Document document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'csv';
        document.DeveloperName = 'Liquidation_Upload_Template1';
        document.IsPublic = true;
        document.Name = 'Liquidation Upload Template1';
        document.FolderId = [select id from folder where name = 'Shared Documents'].id;
        insert document;

        
        List<LiquidationUploadController.LiquidationWrapper> liqWrapList = new List<LiquidationUploadController.LiquidationWrapper>();
        LiquidationUploadController.LiquidationWrapper liqWrap = new LiquidationUploadController.LiquidationWrapper();
        liqWrap.id= liquidation.id;
        liqWrap.distInv = 10;
        liqWrap.retailInv = 10;
        liqWrap.planNxtMnth = 10;
        liqWrapList.add(liqWrap);
        List<String> combkey = new List<String>();
        List<String> test1 = new List<String>();
        combkey.add(sku.SKU_Code__c+acc1.SAP_Code__c+'2020-2021'+'Sept');
        LiquidationUploadController.getLiquidationRecords(sales_dis.Id,JSON.serialize(combkey),'Sept','2020-2021','');
        LiquidationUploadController.updateLiquidation(JSON.serialize(liqWrapList),false,JSON.serialize(liqWrapList),test1,test1);
        LiquidationUploadController.getTemplateToDownload('Liquidation_Upload_Template1');
        LiquidationUploadController.getSalesDistrictName(sales_dis.Id);
        LiquidationUploadController.getLiquidationDetails(sales_dis.Id);
        LiquidationUploadController.getLiquidationDetails(sales_dis1.Name);
        LiquidationUploadController.getLiquidationRecords(sales_dis1.Name,JSON.serialize(combkey),'','2020-2021','Quarter 3');
        LiquidationUploadController.updateLiquidation(JSON.serialize(liqWrapList),true,JSON.serialize(liqWrapList),test1,test1);
        
        List<OpeningInventoryUploadController.OpeningInvWrapper> oiWrapList = new List<OpeningInventoryUploadController.OpeningInvWrapper>();
        OpeningInventoryUploadController.OpeningInvWrapper oiWrap = new OpeningInventoryUploadController.OpeningInvWrapper();
        oiWrap.id= oi.id;
        oiWrap.openInv = 10;
        oiWrapList.add(oiWrap);
        List<String> combkeyoi = new List<String>();
        combkeyoi.add(sku.SKU_Code__c+acc1.SAP_Code__c+'2020-2021'+'Sept'+'2941');
        
        
        OpeningInventoryUploadController.getOIDetails();
        OpeningInventoryUploadController.getOpeningInvRecords(JSON.serialize(combkeyoi), '2020-2021');
        OpeningInventoryUploadController.updateOpeningInv(JSON.serialize(oiWrapList),JSON.serialize(oiWrapList),test1,test1);
    }
}