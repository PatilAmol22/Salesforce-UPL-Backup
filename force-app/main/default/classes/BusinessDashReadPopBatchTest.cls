@isTest
public class BusinessDashReadPopBatchTest {
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
        
        BusinessDashboard__c bdObj2 = new BusinessDashboard__c();
        bdObj2.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
       	bdObj2.EmailSubject__c = 'test_liquidation3.txt';
        bdObj2.FromAddress__c = 'azhar.shaikh@skinternational.com' ;
        bdObj2.Status__c = 'Draft';
        bdObj2.As_of_now__c = System.now();
        bdObj2.Rows__c = 5;
        bdObj2.Header__c = 'Territory,Material Group - Key,Fiscal Year,YTD Qty ACT AUG 2018,Unit';
        insert bdObj2;
        System.debug('bdObj2 :----'+bdObj2);
        
        Attachment attachment2 = new Attachment();
        attachment2.ParentId = bdObj2.Id;
        attachment2.Name = 'test.csv';
        attachment2.Body = Blob.valueof('"235","71450",	"2018", "488.00","KG"\r\n');
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
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
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
        oiObj.YTD_Sales_Jan__c=20;
            oiObj.YTD_Sales_Feb__c=20;
            oiObj.YTD_Sales_Mar__c=20;
            oiObj.YTD_Sales_Apr__c=20;
            oiObj.YTD_Sales_Mar__c=20;
            oiObj.YTD_Sales_Jun__c=20;
            oiObj.YTD_Sales_Jul__c=20;
            oiObj.YTD_Sales_Aug__c=20;
            oiObj.YTD_Sales_Sept__c=20;
            oiObj.YTD_Sales_Oct__c=20;
            oiObj.YTD_Sales_Nov__c=20;
            oiObj.YTD_Sales_Dec__c=20;
        oiObj.Product__c=pro.Id;
        oiObj.Liquidation_Annual_Plan__c=liqAPObj.Id;
        oiObj.Territory__c=tdObj.Id;
        insert oiObj;
        
        Liquidation2__c liqObj= new Liquidation2__c();
        liqObj.YTD_Sales__c=20;
        
        liqObj.Product__c=pro.Id;
        liqObj.Liquidation_Annual_Plan__c=liqAPObj.Id;
        liqObj.Territory__c=tdObj.Id;
        insert liqObj;
        
        SchedulerSettings__c ssObj= new SchedulerSettings__c();
		ssObj.Name ='batchTest';
        ssObj.Enabled__c =true;
        ssObj.Batch_Size__c=2000;
        insert ssObj;
    }
    
    
    static TestMethod void method(){
        
        List<SchedulerSettings__c> settingsList =[SELECT Name, Enabled__c, Batch_Size__c FROM SchedulerSettings__c WHERE Name LIKE 'BusinessDashboardReadAndPopulateBatch'];
        Test.startTest();
        BusinessDashboardReadAndPopulateBatch batchController = new BusinessDashboardReadAndPopulateBatch();
        Database.executeBatch(batchController);
        Test.stopTest();
        
    }
    static TestMethod void method2(){
        List<SchedulerSettings__c> settingsList =[SELECT Name, Enabled__c, Batch_Size__c FROM SchedulerSettings__c WHERE Name LIKE 'BusinessDashboardReadAndPopulateBatch'];
        Test.startTest();
        BusinessDashboardReadAndPopulateBatch batchController = new BusinessDashboardReadAndPopulateBatch();
        Database.executeBatch(batchController);
        Test.stopTest();
        
    }
}