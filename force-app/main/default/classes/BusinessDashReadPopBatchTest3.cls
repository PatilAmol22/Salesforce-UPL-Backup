/*
 * 	 APPS-4655 - Conversion of YTD into MTD - Liquidation Module in SFDC
 *   Modified By: Harshaprasad Srustu
 *   LastmodifiedDate: 12-Feb-2023
 */ 
 
@isTest
public class BusinessDashReadPopBatchTest3 {
    @testSetup
    
    static void allTheDataForThisTestClass() {
        /*BusinessDashboard__c bdObj = new BusinessDashboard__c();
bdObj.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
bdObj.EmailSubject__c = 'UPL_Business_Dashboard_2017-03-01-15-20-40_.txt';
bdObj.FromAddress__c = 'bhavik.devdhar@skinternational.com' ;
bdObj.Status__c = 'Draft';
bdObj.As_of_now__c = System.now();
bdObj.Rows__c = 5;
bdObj.Header__c = 'Territory,Customer,ActualSalesFEB2016,ActualPYYTDFEB2016,ActualSalesFEB2017,ActualYTDFEB2017,%GrowthFEB2017,%GrowthYTDFEB2017,Row No';
insert bdObj;
System.debug('bdObj :----'+bdObj);

Attachment attachment = new Attachment();
attachment.ParentId = bdObj.Id;
attachment.Name = 'Business Dashboard Channel Partner_2017-03-06-16-12-22.csv';
attachment.Body = Blob.valueof('112,0001001299,,3283925.00,,3486344.00,0.00,6.16,2\r\n');
insert attachment;
System.debug('attachmen :----'+attachment);

Schema_Definition__c sdObj = new Schema_Definition__c();
sdObj.Name = 'BusinessDashboardData__c';
sdObj.Mapping_Definition__c = '[{"position": 0,"label": "Territory Code","fieldType": "STRING","column": "Territory\\t","api": "TerritoryCode__c"}, {"position": 2,"label": "PY Actual - MTD","fieldType": "DOUBLE","column": "\\tActual Sales FEB 2016\\t","api": "py_actual_mtd__c"}]';
insert sdObj;
System.debug('sdObj :----'+sdObj);

SchemaObjectMapping__c smObj = new SchemaObjectMapping__c();
smObj.Name = 'Business Dashboard Channel Partner';
smObj.Object__c = 'BusinessDashboardData__c';
insert smObj;
System.debug('smObj :----'+smObj);*/
        
        /*BusinessDashboard__c bdObj2 = new BusinessDashboard__c();
bdObj2.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
bdObj2.EmailSubject__c = 'test_liquidation3.txt';
bdObj2.FromAddress__c = 'azhar.shaikh@skinternational.com' ;
bdObj2.Status__c = 'Draft';
bdObj2.As_of_now__c = System.now();
bdObj2.Rows__c = 5;
bdObj2.Header__c = 'Territory,Material Group - Key,Fiscal Year,Posting Period,YTD Qty ACT AUG 2018,Unit';
insert bdObj2;
System.debug('bdObj2 :----'+bdObj2);

Attachment attachment2 = new Attachment();
attachment2.ParentId = bdObj2.Id;
attachment2.Name = 'test.csv';
attachment2.Body = Blob.valueof('235,71450,  2018, 2, 488.00,KG\r\n');
insert attachment2;
System.debug('attachment2 :----'+attachment2);

Schema_Definition__c sdObj3 = new Schema_Definition__c();
sdObj3.Name = 'Opening_Inventory2__c';
sdObj3.Mapping_Definition__c = '[{"position" : 0,"label" : "Territory","fieldType" : "REFERENCE","column" : "Territory - Key","api" : "territory__c"}, {"position" : 1,"label" : "Product","fieldType" : "REFERENCE","column" : "Material Group - Key","api" : "product__c"}, {"position" : 4,"label" : "YTD Sales","fieldType" : "DOUBLE","column" : "YTD Qty ACT AUG 2018","api" : "ytd_sales__c"}]';
insert sdObj3;
System.debug('sdObj3 :----'+sdObj3);

SchemaObjectMapping__c smObj2 = new SchemaObjectMapping__c();
smObj2.Name = 'test'; //'Open inventory';
smObj2.Filename__c='test';
smObj2.Object__c = 'Opening_Inventory2__c';
insert smObj2;

Sales_Org__c salesOrg= new Sales_Org__c();
salesorg.Name='India';
salesorg.Description__c='India';
salesorg.Sales_Org_Code__c='1000';
insert salesorg;

Product2 pro = new Product2();
pro.ProductCode = '71450';
pro.Product_Code__c='71450';
pro.Name='SAATHI';
pro.Sales_Org__c=salesOrg.Id;
pro.popular__c = true;
pro.Combination_Key__c='RM006510000';
insert pro;

Liquidation_Annual_Plan__c liqAPObj= new Liquidation_Annual_Plan__c();
liqAPObj.FIscal_Year__c='2018-2019';
insert liqAPObj;

Territory_Distributor__c tdObj= new Territory_Distributor__c();
tdObj.Name='Narayangaon';
tdObj.TerritoryCode__c  ='235';
insert tdObj;

Opening_Inventory2__c oiObj= new Opening_Inventory2__c();
oiObj.YTD_Sales__c=20;
oiObj.Product__c=pro.Id;
oiObj.Liquidation_Annual_Plan__c=liqAPObj.Id;
oiObj.Territory__c=tdObj.Id;
oiObj.RecordTypeId=Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
insert oiObj;

Liquidation2__c liqObj= new Liquidation2__c();
liqObj.YTD_Sales__c=20;
liqObj.Product__c=pro.Id;
liqObj.Liquidation_Annual_Plan__c=liqAPObj.Id;
liqObj.Territory__c=tdObj.Id;
insert liqObj;*/
    }
    
    static testMethod void method1(){
        
        BusinessDashboard__c bdObj2 = new BusinessDashboard__c();
        bdObj2.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
        bdObj2.EmailSubject__c = 'test_liquidation3.txt';
        bdObj2.FromAddress__c = 'azhar.shaikh@skinternational.com' ;
        bdObj2.Status__c = 'Draft';
        bdObj2.As_of_now__c = System.now();
        bdObj2.Rows__c = 5;
        bdObj2.Header__c = 'Territory,Material Group - Key,Fiscal Year,Posting Period,YTD Qty ACT AUG 2018,Unit';
        insert bdObj2;
        System.debug('bdObj2 :----'+bdObj2);
        
        Attachment attachment2 = new Attachment();
        attachment2.ParentId = bdObj2.Id;
        attachment2.Name = 'test.csv';
        attachment2.Body = Blob.valueof('"235","71450", "7.2018",  "488.00","KG"\r\n"235","71450",    "7.2018",  "488.00","KG"\r\n');
        insert attachment2;
        System.debug('attachment2 :----'+attachment2);
        
        Attachment attachment3 = new Attachment();
        attachment3.ParentId = bdObj2.Id;
        attachment3.Name = 'testSwal.csv';
        attachment3.Body = Blob.valueof('"SW235","71450", "9.2018", "488.00","KG"\r\n"SW235","71450",   "9.2018", "488.00","KG"\r\n');
        insert attachment3;
        System.debug('attachment3 :----'+attachment3);
        
        Schema_Definition__c sdObj3 = new Schema_Definition__c();
        sdObj3.Name = 'Opening_Inventory2__c';
        sdObj3.Mapping_Definition__c = '[{"position" : 0,"label" : "Territory","fieldType" : "REFERENCE","column" : "Territory - Key","api" : "territory__c"}, {"position" : 1,"label" : "Product","fieldType" : "REFERENCE","column" : "Material Group - Key","api" : "product__c"}, {"position" : 4,"label" : "YTD Sales","fieldType" : "DOUBLE","column" : "YTD Qty ACT AUG 2018","api" : "ytd_sales__c"}]';
        insert sdObj3;
        System.debug('sdObj3 :----'+sdObj3);
        
        SchemaObjectMapping__c smObj2 = new SchemaObjectMapping__c();
        smObj2.Name = 'Open inventory';
        smObj2.Filename__c='test';
        smObj2.Object__c = 'Opening_Inventory2__c';
        insert smObj2;
        //-------------------------------------------------------
        /*UPL_Settings__c uplsetting = new UPL_Settings__c();
        uplsetting.Name = 'UPLSetting';
        uplsetting.India_SAS_Sales_Org__c = '1410';
        INSERT uplsetting;*/
        
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesorg.Name='India';
        salesorg.Description__c='India';
        salesorg.Sales_Org_Code__c= '1410'; //'1000';
        insert salesorg;
        
        Product2 pro = new Product2();
        pro.ProductCode = '71450';
        pro.Product_Code__c='71450';
        pro.Name='SAATHI';
        pro.Sales_Org__c=salesOrg.Id;
        pro.popular__c = true;
        pro.Combination_Key__c='RM006510000';
        insert pro;
        
        Product2 pro1 = new Product2();
        pro1.ProductCode = '59002';
        pro1.Product_Code__c='59002';
        pro1.Name='test';
        pro1.Sales_Org__c=salesOrg.Id;
        pro1.popular__c = true;
        pro1.Combination_Key__c='RM006810000';
        insert pro1;
        
        Liquidation_Annual_Plan__c liqAPObj= new Liquidation_Annual_Plan__c();
        liqAPObj.FIscal_Year__c='2018-2019';
        insert liqAPObj;
        
        Liquidation_Annual_Plan__c liqAPObj1= new Liquidation_Annual_Plan__c();
        liqAPObj1.FIscal_Year__c='2017-2018';
        insert liqAPObj1;
        
        Territory_Distributor__c tdObj= new Territory_Distributor__c();
        tdObj.Name='Narayangaon';
        tdObj.TerritoryCode__c  ='235';
        insert tdObj;
        
        Territory_Distributor__c tdObj2= new Territory_Distributor__c();
        tdObj2.Name='Narayangaon';
        tdObj2.TerritoryCode__c  ='SW235';
        insert tdObj2;
        
        Opening_Inventory2__c oiObj= new Opening_Inventory2__c();
        oiObj.YTD_Sales__c=20;
        oiObj.MTD_Sales_Jan__c=20;
        oiObj.MTD_Sales_Feb__c=20;
        oiObj.MTD_Sales_Mar__c=20;
        oiObj.MTD_Sales_Apr__c=20;
        oiObj.MTD_Sales_Mar__c=20;
        oiObj.MTD_Sales_Jun__c=20;
        oiObj.MTD_Sales_Jul__c=20;
        oiObj.MTD_Sales_Aug__c=20;
        oiObj.MTD_Sales_Sept__c=20;
        oiObj.MTD_Sales_Oct__c=20;
        oiObj.MTD_Sales_Nov__c=20;
        oiObj.MTD_Sales_Dec__c=20;
        
        oiObj.Product__c=pro.Id;
        oiObj.Liquidation_Annual_Plan__c=liqAPObj.Id;
        oiObj.Territory__c=tdObj.Id;
        oiObj.RecordTypeId=Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        insert oiObj;
        
        Opening_Inventory2__c oiObj1= new Opening_Inventory2__c();
        oiObj1.YTD_Sales__c=20;
        oiObj1.MTD_Sales_Jan__c=20;
        oiObj1.MTD_Sales_Feb__c=20;
        oiObj1.MTD_Sales_Mar__c=20;
        oiObj1.MTD_Sales_Apr__c=20;
        oiObj1.MTD_Sales_Mar__c=20;
        oiObj1.MTD_Sales_Jun__c=20;
        oiObj1.MTD_Sales_Jul__c=20;
        oiObj1.MTD_Sales_Aug__c=20;
        oiObj1.MTD_Sales_Sept__c=20;
        oiObj1.MTD_Sales_Oct__c=20;
        oiObj1.MTD_Sales_Nov__c=20;
        oiObj1.MTD_Sales_Dec__c=20;
        oiObj1.Product__c=pro1.Id;
        oiObj1.Liquidation_Annual_Plan__c=liqAPObj1.Id;
        oiObj1.Territory__c=tdObj.Id;
        oiObj1.RecordTypeId=Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        insert oiObj1;
        
        Opening_Inventory2__c oiObj2= new Opening_Inventory2__c();
        oiObj2.YTD_Sales__c=20;
        oiObj2.YTD_Sales_Jan__c=20;
        oiObj2.YTD_Sales_Feb__c=20;
        oiObj2.YTD_Sales_Mar__c=20;
        oiObj2.YTD_Sales_Apr__c=20;
        oiObj2.YTD_Sales_Mar__c=20;
        oiObj2.YTD_Sales_Jun__c=20;
        oiObj2.YTD_Sales_Jul__c=20;
        oiObj2.YTD_Sales_Aug__c=20;
        oiObj2.YTD_Sales_Sept__c=20;
        oiObj2.YTD_Sales_Oct__c=20;
        oiObj2.YTD_Sales_Nov__c=20;
        oiObj2.YTD_Sales_Dec__c=20;
        oiObj2.Product__c=pro1.Id;
        oiObj2.Liquidation_Annual_Plan__c=liqAPObj1.Id;
        oiObj2.Territory__c=tdObj2.Id;
        oiObj2.RecordTypeId=Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        insert oiObj2;
        
        Liquidation2__c liqObj= new Liquidation2__c();
        liqObj.YTD_Sales__c=20;
        liqObj.Product__c=pro.Id;
        liqObj.Liquidation_Annual_Plan__c=liqAPObj.Id;
        liqObj.Territory__c=tdObj.Id;
        liqObj.RecordTypeId=Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
        liqObj.Month__c='Jul';
        insert liqObj;
        
        
        
        Liquidation2__c liqObj1= new Liquidation2__c();
        liqObj1.YTD_Sales__c=20;
        liqObj1.Product__c=pro1.Id;
        liqObj1.Liquidation_Annual_Plan__c=liqAPObj1.Id;
        liqObj1.Territory__c=tdObj.Id;
        liqObj1.RecordTypeId=Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
        liqObj1.Month__c='Jan';
        insert liqObj1;
        
        
        //7145010002018-2019235TRADEMay
        Liquidation2__c liqObj3= new Liquidation2__c();
        liqObj3.YTD_Sales__c=20;
        liqObj3.Product__c=pro.Id;
        liqObj3.Liquidation_Annual_Plan__c=liqAPObj.Id;
        liqObj3.Territory__c=tdObj.Id;
        liqObj3.RecordTypeId=Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
        liqObj3.Month__c='May';
        insert liqObj3;
        
        //7145010002018-2019235TRADEMay
        Liquidation2__c liqObj4= new Liquidation2__c();
        liqObj4.YTD_Sales__c=20;
        liqObj4.Product__c=pro.Id;
        liqObj4.Liquidation_Annual_Plan__c=liqAPObj.Id;
        liqObj4.Territory__c=tdObj.Id;
        liqObj4.RecordTypeId=Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('TRADE').getRecordTypeId();
        liqObj4.Month__c='May';
        insert liqObj4;
        
        SchedulerSettings__c ssObj1= new SchedulerSettings__c();
        ssObj1.Name ='BusinessDashboardReadAndPopulateBatch';
        ssObj1.Enabled__c =true;
        ssObj1.Batch_Size__c=2000;
        insert ssObj1;
        
        List<SchedulerSettings__c> settingsList =[SELECT Name, Enabled__c, Batch_Size__c FROM SchedulerSettings__c WHERE Name LIKE 'BusinessDashboardReadAndPopulateBatch'];
        BusinessDashboardReadAndPopulateBatch batchController = new BusinessDashboardReadAndPopulateBatch();
        Database.executeBatch(batchController);
        
        
    }
    static testMethod void method2(){
        
        BusinessDashboard__c bdObj2 = new BusinessDashboard__c();
        bdObj2.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
        bdObj2.EmailSubject__c = 'Swal YTD Oct 2018 New.csv';
        bdObj2.FromAddress__c = 'azhar.shaikh@skinternational.com' ;
        bdObj2.Status__c = 'Draft';
        bdObj2.As_of_now__c = System.now();
        bdObj2.Rows__c = 5;
        bdObj2.Header__c = 'Territory,Material Group - Key,Fiscal Year,YTD Qty ACT AUG 2018,Unit';
        insert bdObj2;
        System.debug('bdObj2 :----'+bdObj2);
        
        Attachment attachment2 = new Attachment();
        attachment2.ParentId = bdObj2.Id;
        attachment2.Name = 'test3.csv';
        attachment2.Body = Blob.valueof('"SW008","655200","9.2018","160","KG"\r\n"SW008","655200","9.2018","160","KG"\r\n');
        insert attachment2;
        System.debug('attachment2 :----'+attachment2);
        
        
        
        Schema_Definition__c sdObj3 = new Schema_Definition__c();
        sdObj3.Name = 'Opening_Inventory2__c';
        sdObj3.Mapping_Definition__c = '[{"position" : 0, "label" : "Territory", "fieldType" : "REFERENCE", "column" : "Territory - Key", "api" : "territory__c"}, {"position" : 1, "label" : "Product", "fieldType" : "REFERENCE", "column" : "Material Group - Key", "api" : "product__c"}, {"position" : 2,"label" : "", "fieldType" : "","column" : "Fiscal Year", "api" : ""}, {"position" : 3,"label" : "","fieldType" : "","column" : "Posting Period","api" : ""}, {"position" : 4,"label" : "YTD Sales","fieldType" : "DOUBLE", "column" : "YTD Qty ACT AUG 2018","api" : "ytd_sales__c"}, {"position" : 5,"label" : "","fieldType" : "","column" : "Unit","api" : ""} ]';
        insert sdObj3;
        System.debug('sdObj3 :----'+sdObj3);
        
        SchemaObjectMapping__c smObj2 = new SchemaObjectMapping__c();
        smObj2.Name = 'Open inventory';
        smObj2.Filename__c='test';
        smObj2.Object__c = 'Opening_Inventory2__c';
        insert smObj2;
        
        //-------------------------------------------------------
        /*UPL_Settings__c uplsetting = new UPL_Settings__c();
        uplsetting.Name = 'UPLSetting';
        uplsetting.India_SAS_Sales_Org__c = '1410';
        INSERT uplsetting;*/
        
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesorg.Name='India';
        salesorg.Description__c='India';
        salesorg.Sales_Org_Code__c= '1410';//'1000';
        insert salesorg;
        
        Sales_Org__c salesOrg2= new Sales_Org__c();
        salesOrg2.Name='SWAL';
        salesOrg2.Description__c='SWAL';
        salesOrg2.Sales_Org_Code__c='1210';
        insert salesOrg2;
        
        Product2 pro = new Product2();
        pro.ProductCode = '71450';
        pro.Product_Code__c='71450';
        pro.Name='SAATHI';
        pro.Sales_Org__c=salesOrg.Id;
        pro.popular__c = true;
        pro.Combination_Key__c='RM006510000';
        insert pro;
        
        Product2 pro1 = new Product2();
        pro1.ProductCode = '655200';
        pro1.Product_Code__c='655200';
        pro1.Name='test';
        pro1.Sales_Org__c=salesOrg2.Id;
        pro1.popular__c = true;
        pro1.Combination_Key__c='RM00655200';
        insert pro1;
        
        Liquidation_Annual_Plan__c liqAPObj= new Liquidation_Annual_Plan__c();
        liqAPObj.FIscal_Year__c='2018-2019';
        insert liqAPObj;
        
        Liquidation_Annual_Plan__c liqAPObj1= new Liquidation_Annual_Plan__c();
        liqAPObj1.FIscal_Year__c='2017-2018';
        insert liqAPObj1;
        
        Territory_Distributor__c tdObj= new Territory_Distributor__c();
        tdObj.Name='Narayangaon';
        tdObj.TerritoryCode__c  ='SW008';
        insert tdObj;
        
        
        Opening_Inventory2__c oiObj2= new Opening_Inventory2__c();
        oiObj2.YTD_Sales__c=20;
        oiObj2.YTD_Sales_Jan__c=20;
        oiObj2.YTD_Sales_Feb__c=20;
        oiObj2.YTD_Sales_Mar__c=20;
        oiObj2.YTD_Sales_Apr__c=20;
        oiObj2.YTD_Sales_Mar__c=20;
        oiObj2.YTD_Sales_Jun__c=20;
        oiObj2.YTD_Sales_Jul__c=20;
        oiObj2.YTD_Sales_Aug__c=20;
        oiObj2.YTD_Sales_Sept__c=20;
        oiObj2.YTD_Sales_Oct__c=20;
        oiObj2.YTD_Sales_Nov__c=20;
        oiObj2.YTD_Sales_Dec__c=20;
        oiObj2.Product__c=pro1.Id;
        oiObj2.Liquidation_Annual_Plan__c=liqAPObj.Id;
        oiObj2.Territory__c=tdObj.Id;
        oiObj2.RecordTypeId=Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('SWAL TRADE').getRecordTypeId();
        insert oiObj2;
        
        
        // Insert data for Liquidation     
        /*    
Liquidation2__c liqObj= new Liquidation2__c();
liqObj.YTD_Sales__c=20;
liqObj.Product__c=pro.Id;
liqObj.Liquidation_Annual_Plan__c=liqAPObj.Id;
liqObj.Territory__c=tdObj.Id;
liqObj.RecordTypeId=Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SAIB').getRecordTypeId();
liqObj.Month__c='Jul';
insert liqObj;


Liquidation2__c liqObj1= new Liquidation2__c();
liqObj1.YTD_Sales__c=20;
liqObj1.Product__c=pro1.Id;
liqObj1.Liquidation_Annual_Plan__c=liqAPObj1.Id;
liqObj1.Territory__c=tdObj.Id;
liqObj1.RecordTypeId=Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SAIB').getRecordTypeId();
liqObj1.Month__c='Jan';
insert liqObj1;


//7145010002018-2019235TRADEMay
Liquidation2__c liqObj3= new Liquidation2__c();
liqObj3.YTD_Sales__c=20;
liqObj3.Product__c=pro.Id;
liqObj3.Liquidation_Annual_Plan__c=liqAPObj.Id;
liqObj3.Territory__c=tdObj.Id;
liqObj3.RecordTypeId=Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SAIB').getRecordTypeId();
liqObj3.Month__c='May';
insert liqObj3;

//7145010002018-2019235TRADEMay
Liquidation2__c liqObj4= new Liquidation2__c();
liqObj4.YTD_Sales__c=20;
liqObj4.Product__c=pro.Id;
liqObj4.Liquidation_Annual_Plan__c=liqAPObj.Id;
liqObj4.Territory__c=tdObj.Id;
liqObj4.RecordTypeId=Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('SAIB').getRecordTypeId();
liqObj4.Month__c='May';
insert liqObj4;
*/
        SchedulerSettings__c ssObj1= new SchedulerSettings__c();
        ssObj1.Name ='BusinessDashboardReadAndPopulateBatch';
        ssObj1.Enabled__c =true;
        ssObj1.Batch_Size__c=2000;
        insert ssObj1;
        
        List<SchedulerSettings__c> settingsList =[SELECT Name, Enabled__c, Batch_Size__c FROM SchedulerSettings__c WHERE Name LIKE 'BusinessDashboardReadAndPopulateBatch'];
        BusinessDashboardReadAndPopulateBatch batchController = new BusinessDashboardReadAndPopulateBatch();
        Database.executeBatch(batchController);
        
        
    }
    
    static testMethod void method4(){
        
        BusinessDashboard__c bdObj2 = new BusinessDashboard__c();
        bdObj2.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
        bdObj2.EmailSubject__c = 'test_liquidation3.txt';
        bdObj2.FromAddress__c = 'azhar.shaikh@skinternational.com' ;
        bdObj2.Status__c = 'Draft';
        bdObj2.As_of_now__c = System.now();
        bdObj2.Rows__c = 5;
        bdObj2.Header__c = 'Sold-to ,Material,Fiscal Year,Period,YTD Qty ACT SEP 2020,Unit';
        insert bdObj2;
        System.debug('bdObj2 :----'+bdObj2);
        
        Attachment attachment4 = new Attachment();
        attachment4.ParentId = bdObj2.Id;
        attachment4.Name = 'test-6410.csv';
        attachment4.Body = Blob.valueof('1088807,6160011,2020,004,31250,KG\r\n');
        insert attachment4;
        System.debug('attachment4 :----'+attachment4);  
        
        Schema_Definition__c sdObj4 = new Schema_Definition__c();
        sdObj4.Name = 'Opening_Inventory2__c';
        sdObj4.Mapping_Definition__c = '[{"position" : 0,"label" : "Distributor","fieldType" : "REFERENCE","column" : "Sold-to ","api" : "distributor__c"},{"position" : 1,"label" : "SKU","fieldType" : "REFERENCE","column" : "Material","api" : "sku__c"},{"position" : 2,"label" : "","fieldType" : "","column" : "Fiscal Year","api" : ""},{"position" : 3,"label" : "Period","fieldType" : "DOUBLE","column" : "Period","api" : "period__c"},{"position" : 4,"label" : "YTD Sales","fieldType" : "DOUBLE","column" : "YTD Qty ACT SEP 2020","api" : "ytd_sales__c"},{"position" : 5,"label" : "","fieldType" : "","column" : "Unit","api" : ""}]';
        insert sdObj4;
        
        SchemaObjectMapping__c smObj2 = new SchemaObjectMapping__c();
        smObj2.Name = 'Open inventory';
        smObj2.Filename__c='Liquidation Report - 6410';
        smObj2.Object__c = 'Opening_Inventory2__c';
        insert smObj2;
        
        Sales_Org__c salesOrg3= new Sales_Org__c();
        salesOrg3.Name='Indonesia - Catur';
        salesOrg3.Description__c='Indonesia - Catur';
        salesOrg3.Sales_Org_Code__c='6410';
        insert salesOrg3;
        
        Account accObj1 = new Account(
            Name = 'BAM',                                         // Account Record Type
            Last_Name__c = 'SAR123',                                         // Last Name
            SAP_Code__c = '0001088807',                                        // SAP Customer Code
            Mobile__c = '0876543219',                                   // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589793',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = salesOrg3.Id, 
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c=''
        );
        insert accObj1;
        
        Product2 pro2 = new Product2();
        pro2.ProductCode = '6160011';
        pro2.Product_Code__c='6160011';
        pro2.Name='test';
        pro2.Sales_Org__c=salesOrg3.Id;
        pro2.popular__c = true;
        pro2.Combination_Key__c='RM006160011';
        insert pro2;
        
        Opening_Inventory2__c oiObj= new Opening_Inventory2__c();
        oiObj.YTD_Sales__c=31250;
        oiObj.Product__c=pro2.Id;
        oiObj.Distributor__c=accObj1.Id;
        oiObj.RecordTypeId=Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        oiObj.Multi_Country_Key__c='00000000000616001100010888072020-20216410';    
        insert oiObj;
        System.debug('oiObj :----'+oiObj);  
        
        
        SchedulerSettings__c ssObj1= new SchedulerSettings__c();
        ssObj1.Name ='BusinessDashboardReadAndPopulateBatch';
        ssObj1.Enabled__c =true;
        ssObj1.Batch_Size__c=2000;
        insert ssObj1;
        
        List<SchedulerSettings__c> settingsList =[SELECT Name, Enabled__c, Batch_Size__c FROM SchedulerSettings__c WHERE Name LIKE 'BusinessDashboardReadAndPopulateBatch'];
        BusinessDashboardReadAndPopulateBatch batchController = new BusinessDashboardReadAndPopulateBatch();
        Database.executeBatch(batchController);
        
    }
    static testMethod void method5(){
        
        BusinessDashboard__c bdObj2 = new BusinessDashboard__c();
        bdObj2.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
        bdObj2.EmailSubject__c = 'test_liquidation3.txt';
        bdObj2.FromAddress__c = 'azhar.shaikh@skinternational.com' ;
        bdObj2.Status__c = 'Draft';
        bdObj2.As_of_now__c = System.now();
        bdObj2.Rows__c = 5;
        bdObj2.Header__c = 'Sold-to ,Material,Fiscal Year,Period,YTD Qty ACT SEP 2020,Unit';
        insert bdObj2;
        System.debug('bdObj2 :----'+bdObj2);
        
        Attachment attachment4 = new Attachment();
        attachment4.ParentId = bdObj2.Id;
        attachment4.Name = 'test-6410.csv';
        attachment4.Body = Blob.valueof('108807,61600110,2020,005,31250,KG\r\n');
        insert attachment4;
        System.debug('attachment4 :----'+attachment4);  
        
        Schema_Definition__c sdObj4 = new Schema_Definition__c();
        sdObj4.Name = 'Opening_Inventory2__c';
        sdObj4.Mapping_Definition__c = '[{"position" : 0,"label" : "Distributor","fieldType" : "REFERENCE","column" : "Sold-to ","api" : "distributor__c"},{"position" : 1,"label" : "SKU","fieldType" : "REFERENCE","column" : "Material","api" : "sku__c"},{"position" : 2,"label" : "","fieldType" : "","column" : "Fiscal Year","api" : ""},{"position" : 3,"label" : "Period","fieldType" : "DOUBLE","column" : "Period","api" : "period__c"},{"position" : 4,"label" : "YTD Sales","fieldType" : "DOUBLE","column" : "YTD Qty ACT SEP 2020","api" : "ytd_sales__c"},{"position" : 5,"label" : "","fieldType" : "","column" : "Unit","api" : ""}]';
        insert sdObj4;
        
        SchemaObjectMapping__c smObj2 = new SchemaObjectMapping__c();
        smObj2.Name = 'Open inventory';
        smObj2.Filename__c='Liquidation Report - 6410';
        smObj2.Object__c = 'Opening_Inventory2__c';
        insert smObj2;
        
        Sales_Org__c salesOrg3= new Sales_Org__c();
        salesOrg3.Name='Indonesia - Catur';
        salesOrg3.Description__c='Indonesia - Catur';
        salesOrg3.Sales_Org_Code__c='6410';
        insert salesOrg3;
        
        Account accObj1 = new Account(
            Name = 'BAM',                                         // Account Record Type
            Last_Name__c = 'SAR123',                                         // Last Name
            SAP_Code__c = '0000108807',                                        // SAP Customer Code
            Mobile__c = '0876543219',                                   // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589793',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = salesOrg3.Id, 
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c=''
        );
        insert accObj1;
        
        Product2 pro2 = new Product2();
        pro2.ProductCode = '61600110';
        pro2.Product_Code__c='61600110';
        pro2.Name='test';
        pro2.Sales_Org__c=salesOrg3.Id;
        pro2.popular__c = true;
        pro2.Combination_Key__c='RM006160011';
        insert pro2;
        
        Opening_Inventory2__c oiObj= new Opening_Inventory2__c();
        oiObj.YTD_Sales__c=31250;
        oiObj.Product__c=pro2.Id;
        oiObj.Distributor__c=accObj1.Id;
        oiObj.RecordTypeId=Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        oiObj.Multi_Country_Key__c='00000000000616001100001088072020-20216410';    
        insert oiObj;
        System.debug('oiObj :----'+oiObj);  
        
        
        SchedulerSettings__c ssObj1= new SchedulerSettings__c();
        ssObj1.Name ='BusinessDashboardReadAndPopulateBatch';
        ssObj1.Enabled__c =true;
        ssObj1.Batch_Size__c=2000;
        insert ssObj1;
        
        List<SchedulerSettings__c> settingsList =[SELECT Name, Enabled__c, Batch_Size__c FROM SchedulerSettings__c WHERE Name LIKE 'BusinessDashboardReadAndPopulateBatch'];
        BusinessDashboardReadAndPopulateBatch batchController = new BusinessDashboardReadAndPopulateBatch();
        Database.executeBatch(batchController);
        
    }    
    static testMethod void method6(){
        
        BusinessDashboard__c bdObj2 = new BusinessDashboard__c();
        bdObj2.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
        bdObj2.EmailSubject__c = 'test_liquidation3.txt';
        bdObj2.FromAddress__c = 'azhar.shaikh@skinternational.com' ;
        bdObj2.Status__c = 'Draft';
        bdObj2.As_of_now__c = System.now();
        bdObj2.Rows__c = 5;
        bdObj2.Header__c = 'Sold-to ,Material,Fiscal Year,Period,YTD Qty ACT SEP 2020,Unit';
        insert bdObj2;
        System.debug('bdObj2 :----'+bdObj2);
        
        Attachment attachment4 = new Attachment();
        attachment4.ParentId = bdObj2.Id;
        attachment4.Name = 'test-6410.csv';
        attachment4.Body = Blob.valueof('"108807","61600110","2020","005","31250","KG"\r\n');
        insert attachment4;
        System.debug('attachment4 :----'+attachment4);  
        
        Schema_Definition__c sdObj4 = new Schema_Definition__c();
        sdObj4.Name = 'Opening_Inventory2__c';
        sdObj4.Mapping_Definition__c = '[{"position" : 0,"label" : "Distributor","fieldType" : "REFERENCE","column" : "Sold-to ","api" : "distributor__c"},{"position" : 1,"label" : "SKU","fieldType" : "REFERENCE","column" : "Material","api" : "sku__c"},{"position" : 2,"label" : "","fieldType" : "","column" : "Fiscal Year","api" : ""},{"position" : 3,"label" : "Period","fieldType" : "DOUBLE","column" : "Period","api" : "period__c"},{"position" : 4,"label" : "YTD Sales","fieldType" : "DOUBLE","column" : "YTD Qty ACT SEP 2020","api" : "ytd_sales__c"},{"position" : 5,"label" : "","fieldType" : "","column" : "Unit","api" : ""}]';
        insert sdObj4;
        
        SchemaObjectMapping__c smObj2 = new SchemaObjectMapping__c();
        smObj2.Name = 'Open inventory';
        smObj2.Filename__c='Liquidation Report - 6410';
        smObj2.Object__c = 'Opening_Inventory2__c';
        insert smObj2;
        
        Sales_Org__c salesOrg3= new Sales_Org__c();
        salesOrg3.Name='Indonesia - Catur';
        salesOrg3.Description__c='Indonesia - Catur';
        salesOrg3.Sales_Org_Code__c='6410';
        insert salesOrg3;
        
        Account accObj1 = new Account(
            Name = 'BAM',                                         // Account Record Type
            Last_Name__c = 'SAR123',                                         // Last Name
            SAP_Code__c = '0000108807',                                        // SAP Customer Code
            Mobile__c = '0876543219',                                   // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589793',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = salesOrg3.Id, 
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c=''
        );
        insert accObj1;
        
        Product2 pro2 = new Product2();
        pro2.ProductCode = '61600110';
        pro2.Product_Code__c='61600110';
        pro2.Name='test';
        pro2.Sales_Org__c=salesOrg3.Id;
        pro2.popular__c = true;
        pro2.Combination_Key__c='RM006160011';
        insert pro2;
        
        Opening_Inventory2__c oiObj= new Opening_Inventory2__c();
        oiObj.YTD_Sales__c=31250;
        oiObj.Product__c=pro2.Id;
        oiObj.Distributor__c=accObj1.Id;
        oiObj.RecordTypeId=Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        oiObj.Multi_Country_Key__c='00000000000616001100001088072020-20216410';    
        insert oiObj;
        System.debug('oiObj :----'+oiObj);  
        
        
        SchedulerSettings__c ssObj1= new SchedulerSettings__c();
        ssObj1.Name ='BusinessDashboardReadAndPopulateBatch';
        ssObj1.Enabled__c =true;
        ssObj1.Batch_Size__c=2000;
        insert ssObj1;
        
        List<SchedulerSettings__c> settingsList =[SELECT Name, Enabled__c, Batch_Size__c FROM SchedulerSettings__c WHERE Name LIKE 'BusinessDashboardReadAndPopulateBatch'];
        BusinessDashboardReadAndPopulateBatch batchController = new BusinessDashboardReadAndPopulateBatch();
        Database.executeBatch(batchController);
        
    }    
    static testMethod void method7(){
        
        BusinessDashboard__c bdObj2 = new BusinessDashboard__c();
        bdObj2.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
        bdObj2.EmailSubject__c = 'test_liquidation3.txt';
        bdObj2.FromAddress__c = 'azhar.shaikh@skinternational.com' ;
        bdObj2.Status__c = 'Draft';
        bdObj2.As_of_now__c = System.now();
        bdObj2.Rows__c = 5;
        bdObj2.Header__c = 'Customer,Ship-to Party,Material,Fiscal Year,Period,YTD Qty ACT JAN 2021,Unit';
        insert bdObj2;
        System.debug('bdObj2 :----'+bdObj2);
        
        Attachment attachment4 = new Attachment();
        attachment4.ParentId = bdObj2.Id;
        attachment4.Name = 'test-SHT 5100.csv';
        attachment4.Body = Blob.valueof('1049453,2032286,855092,2020,009,200000,KG\r\n');
        insert attachment4;
        System.debug('attachment4 :----'+attachment4);  
        
        Schema_Definition__c sdObj4 = new Schema_Definition__c();
        sdObj4.Name = 'Opening_Inventory2__c';
        sdObj4.Mapping_Definition__c = '[{"position" : 0,"label" : "Distributor","fieldType" : "REFERENCE","column" : "Sold-to ","api" : "distributor__c"},{"position" : 1,"label" : "SKU","fieldType" : "REFERENCE","column" : "Material","api" : "sku__c"},{"position" : 2,"label" : "","fieldType" : "","column" : "Fiscal Year","api" : ""},{"position" : 3,"label" : "Period","fieldType" : "DOUBLE","column" : "Period","api" : "period__c"},{"position" : 4,"label" : "YTD Sales","fieldType" : "DOUBLE","column" : "YTD Qty ACT SEP 2020","api" : "ytd_sales__c"},{"position" : 5,"label" : "","fieldType" : "","column" : "Unit","api" : ""}]';
        insert sdObj4;
        
        SchemaObjectMapping__c smObj2 = new SchemaObjectMapping__c();
        smObj2.Name = 'Open inventory';
        smObj2.Filename__c='Liquidation Report - SHT 5100';
        smObj2.Object__c = 'Opening_Inventory2__c';
        insert smObj2;
        
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesOrg.Name='Mexico';
        salesOrg.Description__c='Mexico';
        salesOrg.Sales_Org_Code__c='5100';
        insert salesOrg;
        
        Account accObj1 = new Account(
            Name = 'SAM',                                         // Account Record Type
            Last_Name__c = 'SAM123',                                         // Last Name
            SAP_Code__c = '0001049453',                                        // SAP Customer Code
            Mobile__c = '0876543219',                                   // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589793',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = salesOrg.Id, 
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c=''
        );
        insert accObj1;
        
        Product2 pro2 = new Product2();
        pro2.ProductCode = '855092';
        pro2.Product_Code__c='855092';
        pro2.Name='test';
        pro2.Sales_Org__c=salesOrg.Id;
        pro2.popular__c = true;
        pro2.Combination_Key__c='RM000855092';
        insert pro2;
        
        Opening_Inventory2__c oiObj= new Opening_Inventory2__c();
        oiObj.YTD_Sales__c=31250;
        oiObj.Product__c=pro2.Id;
        oiObj.Distributor__c=accObj1.Id;
        oiObj.RecordTypeId=Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        oiObj.Multi_Country_Key__c='000000000000855092000104945300020322862020-20215100';    
        insert oiObj;
        System.debug('oiObj :----'+oiObj);  
        
        
        SchedulerSettings__c ssObj1= new SchedulerSettings__c();
        ssObj1.Name ='BusinessDashboardReadAndPopulateBatch';
        ssObj1.Enabled__c =true;
        ssObj1.Batch_Size__c=2000;
        insert ssObj1;
        
        List<SchedulerSettings__c> settingsList =[SELECT Name, Enabled__c, Batch_Size__c FROM SchedulerSettings__c WHERE Name LIKE 'BusinessDashboardReadAndPopulateBatch'];
        BusinessDashboardReadAndPopulateBatch batchController = new BusinessDashboardReadAndPopulateBatch();
        Database.executeBatch(batchController);
        
    }  
    static testMethod void method8(){
        
        BusinessDashboard__c bdObj2 = new BusinessDashboard__c();
        bdObj2.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
        bdObj2.EmailSubject__c = 'test_liquidation3.txt';
        bdObj2.FromAddress__c = 'azhar.shaikh@skinternational.com' ;
        bdObj2.Status__c = 'Draft';
        bdObj2.As_of_now__c = System.now();
        bdObj2.Rows__c = 5;
        bdObj2.Header__c = 'Customer,Ship-to Party,Material,Fiscal Year,Period,YTD Qty ACT JAN 2021,Unit';
        insert bdObj2;
        System.debug('bdObj2 :----'+bdObj2);
        
        Attachment attachment4 = new Attachment();
        attachment4.ParentId = bdObj2.Id;
        attachment4.Name = 'test-SHT 5100.csv';
        attachment4.Body = Blob.valueof('1049453,2032286,855092,2020,009,"200000",KG\r\n');
        insert attachment4;
        System.debug('attachment4 :----'+attachment4);  
        
        Schema_Definition__c sdObj4 = new Schema_Definition__c();
        sdObj4.Name = 'Opening_Inventory2__c';
        sdObj4.Mapping_Definition__c = '[{"position" : 0,"label" : "Distributor","fieldType" : "REFERENCE","column" : "Sold-to ","api" : "distributor__c"},{"position" : 1,"label" : "SKU","fieldType" : "REFERENCE","column" : "Material","api" : "sku__c"},{"position" : 2,"label" : "","fieldType" : "","column" : "Fiscal Year","api" : ""},{"position" : 3,"label" : "Period","fieldType" : "DOUBLE","column" : "Period","api" : "period__c"},{"position" : 4,"label" : "YTD Sales","fieldType" : "DOUBLE","column" : "YTD Qty ACT SEP 2020","api" : "ytd_sales__c"},{"position" : 5,"label" : "","fieldType" : "","column" : "Unit","api" : ""}]';
        insert sdObj4;
        
        SchemaObjectMapping__c smObj2 = new SchemaObjectMapping__c();
        smObj2.Name = 'Open inventory';
        smObj2.Filename__c='Liquidation Report - SHT 5100';
        smObj2.Object__c = 'Opening_Inventory2__c';
        insert smObj2;
        
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesOrg.Name='Mexico';
        salesOrg.Description__c='Mexico';
        salesOrg.Sales_Org_Code__c='5100';
        insert salesOrg;
        
        Account accObj1 = new Account(
            Name = 'SAM',                                         // Account Record Type
            Last_Name__c = 'SAM123',                                         // Last Name
            SAP_Code__c = '0001049453',                                        // SAP Customer Code
            Mobile__c = '0876543219',                                   // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589793',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = salesOrg.Id, 
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c=''
        );
        insert accObj1;
        
        Product2 pro2 = new Product2();
        pro2.ProductCode = '855092';
        pro2.Product_Code__c='855092';
        pro2.Name='test';
        pro2.Sales_Org__c=salesOrg.Id;
        pro2.popular__c = true;
        pro2.Combination_Key__c='RM000855092';
        insert pro2;
        
        Opening_Inventory2__c oiObj= new Opening_Inventory2__c();
        oiObj.YTD_Sales__c=31250;
        oiObj.Product__c=pro2.Id;
        oiObj.Distributor__c=accObj1.Id;
        oiObj.RecordTypeId=Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        oiObj.Multi_Country_Key__c='000000000000855092000104945300020322862020-20215100';    
        insert oiObj;
        System.debug('oiObj :----'+oiObj);  
        
        
        SchedulerSettings__c ssObj1= new SchedulerSettings__c();
        ssObj1.Name ='BusinessDashboardReadAndPopulateBatch';
        ssObj1.Enabled__c =true;
        ssObj1.Batch_Size__c=2000;
        insert ssObj1;
        
        List<SchedulerSettings__c> settingsList =[SELECT Name, Enabled__c, Batch_Size__c FROM SchedulerSettings__c WHERE Name LIKE 'BusinessDashboardReadAndPopulateBatch'];
        BusinessDashboardReadAndPopulateBatch batchController = new BusinessDashboardReadAndPopulateBatch();
        Database.executeBatch(batchController);
        
    }  
    static testMethod void ExportOrderSchedular(){
        Sales_Org__c salesOrg = new Sales_Org__c();
        salesOrg.Name='India';
        salesOrg.Description__c ='India';
        salesOrg.Sales_Org_Code__c ='2000';
        salesOrg.Country_Code__c = 'IN';
        insert salesOrg;
        
        Id recordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account accObj = new Account(
            Name = 'AKASH KRUSHI KENDRA',
            Last_Name__c = 'AKASH KRUSHI KENDRA - MANDRUP',       // Last Name
            recordtypeid = recordTypeIdAccount,                // Mobile
            OwnersetbyProcess__c = true,                          // Owner set by Process
            Status__c = 'Active',                                 // Status
            Zone__c = 'Pune',   
            Sales_Org__c  =  salesOrg.id,                                 // Zone
            Cust_Group__c = '189',                                // Customer Group
            Territory_Code__c = '189',                            // Territory Code
            ApprovedbyRegionalManager__c = false,                 // Approved by Regional Manager
            ApprovedbyZonalHead__c = false,
            ApprovalStatus__c = 'Draft', 
            SAP_Code__c = '0005002026'
            
        );
        insert accObj;
        
        BusinessDashboard__c bdObj = new BusinessDashboard__c();
        bdObj.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
        bdObj.EmailSubject__c = 'test2';
        bdObj.FromAddress__c = 'prashant.chinchpure@skinternational.com' ;
        bdObj.Status__c = 'Draft';
        bdObj.As_of_now__c = System.now();
        bdObj.Rows__c = 5;
        bdObj.Header__c = 'Ship to Party,Ship to Party-Key,Ship-to Country,Ship-to Country-Key,Sold to party,Sold to party-Key,Plant,Sales Order No.,SO Date,Customer PO,Customer PO Date,Material Code,Material Description (Product/ Packing),Order Quantity,Schedule Line Date,Label Remark in SO,Label Confirmation Date,Credit Status,Req. Delivery date,Last Date of Shipment as per LC ,Commitment Date,Rev Commitment Date,Act Readiness Date,Fact. Stuffing Date ( PGI),Invoice Quantity,Pending Quantity,Tentative Sailing Date,Actual Sailing Date,Tentative Arrival Date,Vessel Name,Container No.,Logistics Feedback,Shipping Status,Document Currency,SO Net Price,SO Net Value,Invoice Net Value,SALES MONTH,Payment Terms - Medium Text,Commercial Invoice,Commercial Invoice Date,DHL No.,DHL Date,Copy Docs Date,DOCS. REMARK,Ldoc No,REGION,Overall Order Status,Excise invoice,Delivery Block,Reason for Rejection,Item,Schedule Line,Order Quantity Unit,Bill of lading Date,Material Group Code,Material Group Description,Distribution channel,Distribution channel-Key,Division,Division-Key,Sales Office,Sales Office - Key,Unconfirmed MAD,Status\r\n';
        insert bdObj;
        System.debug('bdObj :----'+bdObj);
        
        Attachment attachment = new Attachment();
        attachment.ParentId = bdObj.Id;
        attachment.Name = 'test2.csv';
        attachment.Body = Blob.valueof('"UPL AGRO SA DE CV","5002026","Mexico","MX","UPL CORPORATION LIMITED","5002026","PL00","5008034145","05-Jun-17","5770011756","28-Apr-17","6300222","CYPERMETHRIN TECH 40:60 92-94% 200KG_MX","16,000","30-Jul-17","LABEL AVAILABLE","05-May-17","OK","05-May-17","05-May-17","19-Jul-18","19-Jul-18","19-Jul-18","03-Aug-18","16,000","0","08-Aug-18","08-Aug-18","08-Aug-18","MSC PERLE V- IS831R","FBIU0166725","","BL RECEIVED","USD","8.3","1","32,800","1","32,800","###############################","08-Aug-18","1425945836","08-Aug-18","08-Aug-18","08-Aug-18","14-Aug-18","","1000030444","MEXICO","Being processed","1416525059","10","10","KG","555002","08-Aug-18","555002","CYPER TECH  Intergroup","40","Agro Technical","10","United Phos De Mx","S045","10-Jun-17","ORDERS COMPLETED"\r\n');
        insert attachment;
        System.debug('attachmen :----'+attachment);
        
        Schema_Definition__c sdObj = new Schema_Definition__c();
        sdObj.Name = 'Export_Order__c';
        sdObj.Mapping_Definition__c = '[{"position": 0,"label": "Territory Code","fieldType": "STRING","column": "Territory\\t","api": "TerritoryCode__c"}, {"position": 2,"label": "PY Actual - MTD","fieldType": "DOUBLE","column": "\\tActual Sales FEB 2016\\t","api": "py_actual_mtd__c"}]';
        sdObj.File_Name__c = 'test2';
        insert sdObj;
        System.debug('sdObj :----'+sdObj);
        
        SchemaObjectMapping__c smObj = new SchemaObjectMapping__c();
        smObj.Name = 'test';
        smObj.Object__c = 'Export_Order__c';
        smObj.Filename__c='test2';
        insert smObj;
        System.debug('smObj :----'+smObj);
        
        Division__c div = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert div;
        
        Distribution_Channel__c distChnnl = new Distribution_Channel__c(
            Name = 'Exports - Non Subs',        // Distribution Channel Name
            Distribution_Channel_Code__c = '40'  // Distribution Channel Code
        );
        insert distChnnl;
        
        SKU__c sku = new SKU__c(
            Name = '10 KG',                                                // SKU Name
            SKU_Code__c = '000000000006050191',                              // SKU Code
            // Product_Name__c = '01t0k000003ctce',                             // Product Name
            SKU_Description__c = 'BLUE BORDO DISPERSS 10 KG',                // SKU Description
            UOM__c = 'KG',                                                   // UOM
            Distribution_Channel__c = distChnnl.id,                     // Distribution Channel
            //Pack_Size__c = '0.00',                                           // Pack Size
            Division__c = div.id,                                 // Division
            // salesorgDistributionDivision__c = '71102010',                    // salesorg+Distribution+Division                                      // Sales Org Code
            Combination_Key__c = '20004010000000000006300222',               // Combination Key
            Material_type__c = 'FERT',                                       // Material type
            Active__c = true,                                              
            Brand_Name__c = 'BLUE'                                          // Brand Name
        );
        insert sku;
        
        
        Product2 prod = new Product2();
        prod.ProductCode = '55500';
        prod.Product_Code__c='55500';
        prod.Combination_Key__c = '5550020004010';
        prod.Name='SAATHI';
        prod.Sales_Org__c=salesOrg.Id;
        prod.popular__c = true;
        insert prod;
        
        Shipping_Location__c shipLoc = new Shipping_Location__c(
            Location_Name__c = 'AGRO ROCA SOCIEDAD ANONIMA',                 // Location Name
            Distributor__c = accObj.id,                                // Distributor
            SAP_Code__c = '00010133085631',                                    // SAP Code
            City__c = 'GENERAL ROCA',                                          // City
            State__c = '22',                                                   // State
            Country__c = 'AR',                                                 // Country
            Pincode__c = '8332',                                               // Pincode
            Sold_To_Party_SAP_Code__c = '0001013308',                          // Sold To Party (SAP Code)
            Combination_Key__c = '00050020260005002026',                   // Combination Key
            Sales_Org__c = salesorg.id,                                  // Sales Org
            Distribution_Channel__c = distChnnl.id,                       // Distribution Channel
            Division__c = div.id                                   // Division
        );
        insert shipLoc;
        
        
        BusinessDashboard__c bdObj1  = [SELECT ID FROM BusinessDashboard__c Where EmailSubject__c = 'test2'];
        Attachment attachment1 = [SELECT ID FROM Attachment WHERE ParentId =: bdObj1.Id];
        attachment1.Body = Blob.valueof('"UPL AGRO SA DE CV","5002026","Mexico","MX","UPL CORPORATION LIMITED","5002026","PL00","5008034145","05-Jun-17","5770011756","28-Apr-17","6300222","CYPERMETHRIN TECH 40:60 92-94% 200KG_MX","16,000","30-Jul-17","LABEL AVAILABLE","05-May-17","OK","05-May-17","05-May-17","19-Jul-18","19-Jul-18","19-Jul-18","03-Aug-18","16,000","0","08-Aug-18","08-Aug-18","08-Aug-18","MSC PERLE V- IS831R","FBIU0166725","","BL RECEIVED","USD","8.3","1","32,800","1","32,800","###############################","08-Aug-18","1425945836","08-Aug-18","08-Aug-18","08-Aug-18","14-Aug-18","","1000030444","MEXICO","Being processed","1416525059","10","10","KG","555002","08-Aug-18","555002","CYPER TECH  Intergroup","40","Agro Technical","10","United Phos De Mx","S045","10-Jun-17","ORDERS COMPLETED"\r\n');
        update attachment1;
        Database.executeBatch(new BusinessDashboardReadAndPopulateBatch (),10);
    }
    
     static testMethod void method9(){
        
        BusinessDashboard__c bdObj2 = new BusinessDashboard__c();
        bdObj2.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
        bdObj2.EmailSubject__c = 'Poland YTD upload';
        bdObj2.FromAddress__c = 'sumit.kumar@grazitti.com' ;
        bdObj2.Status__c = 'Draft';
        bdObj2.As_of_now__c = System.now();
        bdObj2.Rows__c = 5;
        bdObj2.Header__c = 'Customer,Material,Fiscal Year,Period,YTD Qty ACT SEP 2020,Unit';
        insert bdObj2;
        System.debug('bdObj2 :----'+bdObj2);
        
        Attachment attachment4 = new Attachment();
        attachment4.ParentId = bdObj2.Id;
        attachment4.Name = 'Liquidation Report - 2941.csv';
        attachment4.Body = Blob.valueof('"1088807","6160011","2020","4","31250","KG"\r\n');
        insert attachment4;
        System.debug('attachment4 :----'+attachment4);  
        
        Schema_Definition__c sdObj4 = new Schema_Definition__c();
        sdObj4.Name = 'Opening_Inventory2__c';
        sdObj4.Mapping_Definition__c = '[{"position" : 0,"label" : "Distributor","fieldType" : "REFERENCE","column" : "Sold-to ","api" : "distributor__c"},{"position" : 1,"label" : "SKU","fieldType" : "REFERENCE","column" : "Material","api" : "sku__c"},{"position" : 2,"label" : "","fieldType" : "","column" : "Fiscal Year","api" : ""},{"position" : 3,"label" : "Period","fieldType" : "DOUBLE","column" : "Period","api" : "period__c"},{"position" : 4,"label" : "YTD Sales","fieldType" : "DOUBLE","column" : "YTD Qty ACT SEP 2020","api" : "ytd_sales__c"},{"position" : 5,"label" : "","fieldType" : "","column" : "Unit","api" : ""}]';
        insert sdObj4;
        
        SchemaObjectMapping__c smObj2 = new SchemaObjectMapping__c();
        smObj2.Name = 'Open inventory';
        smObj2.Filename__c='Liquidation Report - 2941';
        smObj2.Object__c = 'Opening_Inventory2__c';
        insert smObj2;
        
        Sales_Org__c salesOrg3= new Sales_Org__c();
        salesOrg3.Name='Poland';
        salesOrg3.Description__c='Poland Sales Org';
        salesOrg3.Sales_Org_Code__c='2941';
        insert salesOrg3;
        
        Account accObj1 = new Account(
            Name = 'BAM',                                         // Account Record Type
            Last_Name__c = 'SAR123',                                         // Last Name
            SAP_Code__c = '0001088807',                                        // SAP Customer Code
            Mobile__c = '0876543219',                                   // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589793',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = salesOrg3.Id, 
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c=''
        );
        insert accObj1;
        
        Product2 pro2 = new Product2();
        pro2.ProductCode = '6160011';
        pro2.Product_Code__c='6160011';
        pro2.Name='test';
        pro2.Sales_Org__c=salesOrg3.Id;
        pro2.popular__c = true;
        pro2.Combination_Key__c='RM006160011';
        insert pro2;
        
        Opening_Inventory2__c oiObj= new Opening_Inventory2__c();
        oiObj.YTD_Sales__c=31250;
        oiObj.Product__c=pro2.Id;
        oiObj.Distributor__c=accObj1.Id;
        oiObj.RecordTypeId=Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        oiObj.Multi_Country_Key__c='00000000000616001100010888072020-20212941';    
        insert oiObj;
        System.debug('oiObj :----'+oiObj);  
        
        
        SchedulerSettings__c ssObj1= new SchedulerSettings__c();
        ssObj1.Name ='BusinessDashboardReadAndPopulateBatch';
        ssObj1.Enabled__c =true;
        ssObj1.Batch_Size__c=2000;
        insert ssObj1;
        
        List<SchedulerSettings__c> settingsList =[SELECT Name, Enabled__c, Batch_Size__c FROM SchedulerSettings__c WHERE Name LIKE 'BusinessDashboardReadAndPopulateBatch'];
        BusinessDashboardReadAndPopulateBatch batchController = new BusinessDashboardReadAndPopulateBatch();
        Database.executeBatch(batchController);
        
    }
    
    static testMethod void method10(){
        
        BusinessDashboard__c bdObj2 = new BusinessDashboard__c();
        bdObj2.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
        bdObj2.EmailSubject__c = 'Poland YTD upload';
        bdObj2.FromAddress__c = 'sumit.kumar@grazitti.com' ;
        bdObj2.Status__c = 'Draft';
        bdObj2.As_of_now__c = System.now();
        bdObj2.Rows__c = 5;
        bdObj2.Header__c = 'Customer,Material,Fiscal Year,Period,YTD Qty ACT SEP 2020,Unit';
        insert bdObj2;
        System.debug('bdObj2 :----'+bdObj2);
        
        Attachment attachment4 = new Attachment();
        attachment4.ParentId = bdObj2.Id;
        attachment4.Name = 'Liquidation Report - 2941.csv';
        attachment4.Body = Blob.valueof('1088807,6160011,2020,5,31250,KG\r\n1088807,6160011,2020,6,31250,KG\r\n1088807,6160011,2020,7,31250,KG\r\n1088807,6160011,2020,8,31250,KG\r\n1088807,6160011,2020,9,31250,KG\r\n1088807,6160011,2020,10,31250,KG\r\n1088807,6160011,2020,12,31250,KG\r\n1088807,6160011,2020,1,31250,KG\r\n1088807,6160011,2020,2,31250,KG\r\n1088807,6160011,2020,11,31250,KG\r\n1088807,6160011,2020,3,31250,KG\r\n1088807,6160011,2020,4,31250,KG\r\n');
        insert attachment4;
        System.debug('attachment4 :----'+attachment4);  
        
        Schema_Definition__c sdObj4 = new Schema_Definition__c();
        sdObj4.Name = 'Opening_Inventory2__c';
        sdObj4.Mapping_Definition__c = '[{"position" : 0,"label" : "Distributor","fieldType" : "REFERENCE","column" : "Sold-to ","api" : "distributor__c"},{"position" : 1,"label" : "SKU","fieldType" : "REFERENCE","column" : "Material","api" : "sku__c"},{"position" : 2,"label" : "","fieldType" : "","column" : "Fiscal Year","api" : ""},{"position" : 3,"label" : "Period","fieldType" : "DOUBLE","column" : "Period","api" : "period__c"},{"position" : 4,"label" : "YTD Sales","fieldType" : "DOUBLE","column" : "YTD Qty ACT SEP 2020","api" : "ytd_sales__c"},{"position" : 5,"label" : "","fieldType" : "","column" : "Unit","api" : ""}]';
        insert sdObj4;
        
        SchemaObjectMapping__c smObj2 = new SchemaObjectMapping__c();
        smObj2.Name = 'Open inventory';
        smObj2.Filename__c='Liquidation Report - 2941';
        smObj2.Object__c = 'Opening_Inventory2__c';
        insert smObj2;
        
        Sales_Org__c salesOrg3= new Sales_Org__c();
        salesOrg3.Name='Poland';
        salesOrg3.Description__c='Poland Sales Org';
        salesOrg3.Sales_Org_Code__c='2941';
        insert salesOrg3;
        
        Account accObj1 = new Account(
            Name = 'BAM',                                         // Account Record Type
            Last_Name__c = 'SAR123',                                         // Last Name
            SAP_Code__c = '0001088807',                                        // SAP Customer Code
            Mobile__c = '0876543219',                                   // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589793',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = salesOrg3.Id, 
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c=''
        );
        insert accObj1;
        
        Product2 pro2 = new Product2();
        pro2.ProductCode = '6160011';
        pro2.Product_Code__c='6160011';
        pro2.Name='test';
        pro2.Sales_Org__c=salesOrg3.Id;
        pro2.popular__c = true;
        pro2.Combination_Key__c='RM006160011';
        insert pro2;
        
        Opening_Inventory2__c oiObj= new Opening_Inventory2__c();
        oiObj.YTD_Sales__c=31250;
        oiObj.Product__c=pro2.Id;
        oiObj.Distributor__c=accObj1.Id;
        oiObj.RecordTypeId=Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        oiObj.Multi_Country_Key__c='00000000000616001100010888072020-20212941';    
        insert oiObj;
        System.debug('oiObj :----'+oiObj);  
        
        
        SchedulerSettings__c ssObj1= new SchedulerSettings__c();
        ssObj1.Name ='BusinessDashboardReadAndPopulateBatch';
        ssObj1.Enabled__c =true;
        ssObj1.Batch_Size__c=2000;
        insert ssObj1;
        
        List<SchedulerSettings__c> settingsList =[SELECT Name, Enabled__c, Batch_Size__c FROM SchedulerSettings__c WHERE Name LIKE 'BusinessDashboardReadAndPopulateBatch'];
        BusinessDashboardReadAndPopulateBatch batchController = new BusinessDashboardReadAndPopulateBatch();
        Database.executeBatch(batchController);
        
        BusinessDashboardBatch.saibWrapper sobj = new BusinessDashboardBatch.saibWrapper();
    }
    
}