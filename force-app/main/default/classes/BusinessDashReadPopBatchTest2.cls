@isTest
public class BusinessDashReadPopBatchTest2 {
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
        attachment2.Body = Blob.valueof('235,71450,	2018, 2, 488.00,KG\r\n');
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
        tdObj.TerritoryCode__c	='235';
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
        attachment2.Body = Blob.valueof('"235","71450",	"2018", "2", "488.00","KG"\r\n"235","71450",	"2018", "11", "488.00","KG"\r\n');
        insert attachment2;
        System.debug('attachment2 :----'+attachment2);
        
        Attachment attachment3 = new Attachment();
        attachment3.ParentId = bdObj2.Id;
        attachment3.Name = 'testSwal.csv';
        attachment3.Body = Blob.valueof('SW008","655200","2018","160","KG"\r\n"SW008","655200","2018","160","KG"\r\n');
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
        
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesorg.Name='India';
        salesorg.Description__c='India';
        salesorg.Sales_Org_Code__c='1000';
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
        tdObj.TerritoryCode__c	='235';
        insert tdObj;
        
        Territory_Distributor__c tdObj1= new Territory_Distributor__c();
        tdObj1.Name='Narayangaon';
        tdObj1.TerritoryCode__c	='SW008';
        insert tdObj1;
        
        Opening_Inventory2__c oiObj= new Opening_Inventory2__c();
        oiObj.YTD_Sales__c=20;
        oiObj.Product__c=pro.Id;
        oiObj.Liquidation_Annual_Plan__c=liqAPObj.Id;
        oiObj.Territory__c=tdObj.Id;
        oiObj.RecordTypeId=Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        insert oiObj;

        Opening_Inventory2__c oiObj1= new Opening_Inventory2__c();
        oiObj1.YTD_Sales__c=20;
        oiObj1.Product__c=pro1.Id;
        oiObj1.Liquidation_Annual_Plan__c=liqAPObj1.Id;
        oiObj1.Territory__c=tdObj.Id;
        oiObj1.RecordTypeId=Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Trade').getRecordTypeId();
        insert oiObj1;
        
        Opening_Inventory2__c oiObj2= new Opening_Inventory2__c();
        oiObj2.YTD_Sales__c=20;
        oiObj2.Product__c=pro1.Id;
        oiObj2.Liquidation_Annual_Plan__c=liqAPObj.Id;
        oiObj2.Territory__c=tdObj1.Id;
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
        
        /*SchedulerSettings__c ssObj= new SchedulerSettings__c();
		ssObj.Name ='DashboardDataDeletionBatch';
        ssObj.Enabled__c =true;
        ssObj.Batch_Size__c=2000;
        insert ssObj;*/
        
        SchedulerSettings__c ssObj1= new SchedulerSettings__c();
		ssObj1.Name ='BusinessDashboardReadAndPopulateBatch';
        ssObj1.Enabled__c =true;
        ssObj1.Batch_Size__c=2000;
        insert ssObj1;
    }
    
    
    /*static TestMethod void method(){
        
        List<SchedulerSettings__c> settingsList =[SELECT Name, Enabled__c, Batch_Size__c FROM SchedulerSettings__c WHERE Name LIKE 'DashboardDataDeletionBatch'];
        Test.startTest();
        BusinessDashboardReadAndPopulateBatch batchController = new BusinessDashboardReadAndPopulateBatch();
        Database.executeBatch(batchController);
        Test.stopTest();
        
    }*/
    static TestMethod void method2(){
        List<SchedulerSettings__c> settingsList =[SELECT Name, Enabled__c, Batch_Size__c FROM SchedulerSettings__c WHERE Name LIKE 'BusinessDashboardReadAndPopulateBatch'];
        Test.startTest();
        BusinessDashboardReadAndPopulateBatch batchController = new BusinessDashboardReadAndPopulateBatch();
        Database.executeBatch(batchController);
        Test.stopTest();
        
    }
}