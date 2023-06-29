@isTest
public class GRZ_Vietnam_Indo_Turkey_ControllerTest {
    
    @TestSetup
    static void makeData(){
        
         Liquidation_Batch_Filters__c lbf2 = new Liquidation_Batch_Filters__c();
        lbf2.Name = 'Indonesia';
        lbf2.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'6451\'';
        lbf2.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
        lbf2.Active__c = true;
        lbf2.Distributor_Filter__c='Test';
        lbf2.Sales_District_Filter__c='Test';
        insert lbf2;
        
        Trigger_Settings__c settingsTest = new Trigger_Settings__c();
        settingsTest.Name = 'LiquidationTrigger';
        settingsTest.IsActive__c = false;
        insert settingsTest;
        
        Sales_Org__c so_indo1 = new Sales_Org__c();
        so_indo1.Name='UPL-Indonesia';
        so_indo1.Sales_Org_Code__c='6451';
        insert so_indo1;
        
        
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
        
        User usr_nsm = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'National sales Manager indonesia'].Id,
            LastName = 'NSM',
            Email = 'test@test.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert usr_nsm;
                
        SKU__c sku1 = new SKU__c();
        sku1.Name = '6 LTR';
        sku1.SKU_Code__c = '000000000005160032';
        sku1.Brand_Name__c = 'ABACO';
        sku1.SKU_Description__c = 'SCANNER (PARAQUAT DICHLOR 276SL) 5LT....';
        sku1.Active_for_Liquidation__c = true;
        sku1.Sales_Org__c = so_indo1.Id;
        insert sku1;
        
        Sales_District__c sales_dis = new Sales_District__c();
        sales_dis.Name = 'sale_dist';
        sales_dis.User__c = usr_regional_manager.Id;
        sales_dis.Sales_District_Code__c = 'ID0004';
        insert sales_dis;
        
        Id rec_type_acc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account acc1 = new Account();
        acc1.Name = 'acc1';
        acc1.Sales_District__c = sales_dis.Id;
        acc1.Account_Type__c = 'Sold To Party';
        acc1.RecordTypeId=rec_type_acc;
        acc1.Sales_Org__c = so_indo1.Id;
        acc1.Is_Community_Active__c = true;
        insert acc1;
                
        Contact c = new Contact();
        c.AccountId = acc1.ID;
        c.FirstName = 'testContact';
        c.LastName = 'test';
        c.email = 'test@test.com';
        insert c;
        
        User usr_turkey = new User(
            
            //ProfileId = [SELECT Id FROM Profile WHERE Name = 'Partner Community User-Turkey'].Id,
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            
            LastName = 'Turkey',
            Email = 'test@test.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            //ContactId =c.Id,
            Country = 'Turkey',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert usr_turkey;
        
        
        Id rec_type_LAP = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Liquidation_Annual_Plan__c lap = new Liquidation_Annual_Plan__c();
        lap.FIscal_Year__c = '2020-2021';
        lap.Fiscal_Start_Date__c =  Date.newInstance(Integer.valueOf(System.Today().year()), 4, 1);
        //lap.Fiscal_End_Date__c =  Date.newInstance(Integer.valueOf('2021'), 3, 31); 
        lap.Distributor__c = acc1.Id;
        lap.Sales_Org__c = so_indo1.Id;
        lap.recordTypeId = rec_type_LAP;
        insert lap;
        
        Id rec_type_OI = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Opening_Inventory2__c oi = new Opening_Inventory2__c();
        oi.SKU__c = sku1.Id;
        oi.Sales_District__c = sales_dis.Id;
        oi.Distributor__c = acc1.Id;
        oi.Opening_Inventory__c = 3360;
        oi.Liquidation_Annual_Plan__c = lap.Id;
        oi.recordTypeId = rec_type_OI;
        insert oi;
        
        Id rec_type_liquidation = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Liquidation2__c liquidation = new Liquidation2__c();
        liquidation.Month__c = 'Oct';
        liquidation.Distributor__c = acc1.Id;
        liquidation.Liquidation_Annual_Plan__c = lap.Id;
        liquidation.SKU__c = sku1.Id;
        liquidation.SKU_Code__c = sku1.SKU_Code__c;
        liquidation.Brand_Name__c = sku1.Brand_Name__c;
        liquidation.SKU_Description__c = sku1.SKU_Description__c;
        liquidation.Sales_District__c = sales_dis.Id;
        liquidation.RecordTypeId = rec_type_liquidation;
        liquidation.Opening_Inventory2__c = oi.Id;
        insert liquidation;
        
        Liquidation2__c liquidation1 = new Liquidation2__c();
        liquidation1.Month__c = 'Sept';
        liquidation1.Distributor__c = acc1.Id;
        liquidation1.Liquidation_Annual_Plan__c = lap.Id;
        liquidation1.SKU__c = sku1.Id;
        liquidation1.SKU_Code__c = sku1.SKU_Code__c;
        liquidation1.Brand_Name__c = sku1.Brand_Name__c;
        liquidation1.SKU_Description__c = sku1.SKU_Description__c;
        liquidation1.Sales_District__c = sales_dis.Id;
        liquidation1.RecordTypeId = rec_type_liquidation;
        liquidation1.Opening_Inventory2__c = oi.Id;
        
        liquidation1.YTD_Sales_Wrap__c = 20.22;
        liquidation1.Liquidation_YTD_Wrap__c = 30.22;
        liquidation1.Total_Available_Stock_Wrap__c = 54.11;
        liquidation1.Distributors_Inventory__c = 11.2;
        liquidation1.Retailers_Inventory__c = 54.3;
        liquidation1.Total_Market_Inventory_Wrap__c = 76.1;
        liquidation1.Plan_for_the_month__c = 12;
        liquidation1.Plan_for_the_next_month__c = 12;
        liquidation1.Opening_Inventory_Wrap__c = 100;
        liquidation1.UOM_Wrap__c = '44';
        liquidation1.Liquidation_YTD_Percent_Wrap__c = 44;
        insert liquidation1;
    }
    
    
    @IsTest
    static void testLiquidationPDF(){
        User usr_rm = [select id,Name from User where LastName='RM' limit 1];
        User usr_turkey = [select id,Name from User where LastName='Turkey' limit 1];
        User usr_nsm = [select id,Name from User where LastName='NSM' limit 1];
        
        Sales_Org__c sOrg =[select id,Sales_Org_Code__c from Sales_Org__c where name='UPL-Indonesia' limit 1];
        Sales_District__c sale_dist = [select id,Name from Sales_District__c where Name='sale_dist' limit 1];
        Account acc = [select id,Name from Account where Name='acc1' limit 1];
        
        Test.startTest();            
        ApexPages.currentPage().getParameters().put('Sales_Org',String.valueOf(sOrg.Sales_Org_Code__c));
        ApexPages.currentPage().getParameters().put('sales_district',  String.valueOf(sale_dist.Id));
        ApexPages.currentPage().getParameters().put('distributor', String.valueOf(acc.Id));
        ApexPages.currentPage().getParameters().put('year', String.valueOf(System.Today().year()));
        ApexPages.currentPage().getParameters().put('month', 'Sept');
        ApexPages.currentPage().getParameters().put('searchValue', 'ABACO');               
        GRZ_Vietnam_Indo_Turkey_Controller.getPOGLiquidationData();
        Test.stopTest();
    }
    
    @IsTest
    static void testLiquidationPDF1(){
        
        User usr_rm = [select id,Name from User where LastName='RM' limit 1]; 
        User usr_turkey = [select id,Name from User where LastName='Turkey' limit 1];
        Sales_Org__c sOrg =[select id,Sales_Org_Code__c from Sales_Org__c where name='UPL-Indonesia' limit 1];
        Sales_District__c sale_dist = [select id,Name from Sales_District__c where Name='sale_dist' limit 1];
        Account acc = [select id,Name from Account where Name='acc1' limit 1];
        SKU__c sku1 = [select id,Name,SKU_Code__c,SKU_Description__c,Brand_Name__c from SKU__c limit 1];
        Liquidation_Annual_Plan__c lap = [select id,Name from Liquidation_Annual_Plan__c limit 1];
        Opening_Inventory2__c opi = [select id,Name from Opening_Inventory2__c where Distributor__c=:acc.Id limit 1];
        
        Test.startTest(); 
        System.runAs(usr_turkey){

            ApexPages.currentPage().getParameters().put('salesOrgCode',String.valueOf(sOrg.Sales_Org_Code__c));
            ApexPages.currentPage().getParameters().put('sales_district',  String.valueOf(''));
            ApexPages.currentPage().getParameters().put('distributor', String.valueOf(''));
            ApexPages.currentPage().getParameters().put('year', String.valueOf(System.Today().year()));
            ApexPages.currentPage().getParameters().put('month', 'Sept');
            ApexPages.currentPage().getParameters().put('searchValue', 'ABACO');               
            GRZ_Vietnam_Indo_Turkey_Controller.getPOGLiquidationData();
        }
        Test.stopTest();
    }
    
        @IsTest
    static void testLiquidationPDF2(){
        
        User usr_rm = [select id,Name from User where LastName='RM' limit 1]; 
        User usr_turkey = [select id,Name from User where LastName='Turkey' limit 1];
        Sales_Org__c sOrg =[select id,Sales_Org_Code__c from Sales_Org__c where name='UPL-Indonesia' limit 1];
        Sales_District__c sale_dist = [select id,Name from Sales_District__c where Name='sale_dist' limit 1];
        Account acc = [select id,Name from Account where Name='acc1' limit 1];
        SKU__c sku1 = [select id,Name,SKU_Code__c,SKU_Description__c,Brand_Name__c from SKU__c limit 1];
        Liquidation_Annual_Plan__c lap = [select id,Name from Liquidation_Annual_Plan__c limit 1];
        Opening_Inventory2__c opi = [select id,Name from Opening_Inventory2__c where Distributor__c=:acc.Id limit 1];
        List<Liquidation2__c> lstliq = [select id,Month__c,SKU__r.Active_for_Liquidation__c,SKU__r.SKU_Code__c,Distributor__c,Liquidation_Annual_Plan__r.Fiscal_Start_Date__c,Sales_District__c,Ship_To_Party__c,Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c,RecordTypeId from Liquidation2__c];
        System.debug('lstliq : '+lstliq);
        
        Test.startTest(); 
        System.runAs(usr_turkey){

            ApexPages.currentPage().getParameters().put('salesOrgCode',String.valueOf(sOrg.Sales_Org_Code__c));
            ApexPages.currentPage().getParameters().put('sales_district',  String.valueOf(''));
            ApexPages.currentPage().getParameters().put('distributor', String.valueOf(''));
            ApexPages.currentPage().getParameters().put('year', String.valueOf(System.Today().year()));
            ApexPages.currentPage().getParameters().put('month', 'Sept');
            ApexPages.currentPage().getParameters().put('searchValue', '');               
            GRZ_Vietnam_Indo_Turkey_Controller.getPOGLiquidationData();
        }
        Test.stopTest();
    }
}