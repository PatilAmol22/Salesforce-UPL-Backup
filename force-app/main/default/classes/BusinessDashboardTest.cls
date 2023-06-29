@isTest
public class BusinessDashboardTest {
    //testing data setup for all methods in this class
   @testSetup
    static void  allTheDataForThisTestClass() {
        BusinessDashboard__c bdObj = new BusinessDashboard__c();
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
        System.debug('smObj :----'+smObj);
        
        BusinessDashboard__c bdObj2 = new BusinessDashboard__c();
        bdObj2.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
        bdObj2.EmailSubject__c = 'test_liquidation3.txt';
        bdObj2.FromAddress__c = 'azhar.shaikh@skinternational.com' ;
        bdObj2.Status__c = 'Draft';
        bdObj2.As_of_now__c = System.now();
        bdObj2.Rows__c = 5;
        bdObj2.Header__c = 'Territory,Material Group - Key,Fiscal Year,YTD Qty ACT AUG 2018,Unit';
        insert bdObj2;
        System.debug('bdObj2 :----'+bdObj2); //Swal YTD Oct 2018 New.csv
        
        BusinessDashboard__c bdObj3 = new BusinessDashboard__c();
        bdObj3.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
        bdObj3.EmailSubject__c = 'Swal YTD Oct 2018 New.csv';
        bdObj3.FromAddress__c = 'azhar.shaikh@skinternational.com' ;
        bdObj3.Status__c = 'Draft';
        bdObj3.As_of_now__c = System.now();
        bdObj3.Rows__c = 4;
        bdObj3.Header__c = 'Territory,Material Group - Key,Fiscal Year,YTD Qty ACT AUG 2018';
        insert bdObj3;
        System.debug('bdObj3 :----'+bdObj3);
        
        Attachment attachment2 = new Attachment();
        attachment2.ParentId = bdObj2.Id;
        attachment2.Name = 'test';
        attachment2.Body = Blob.valueof('235,71450, 2018, 488.00,KG\r\n');
        insert attachment2;
        System.debug('attachment2 :----'+attachment2);
        
        Attachment attachment3 = new Attachment();
        attachment3.ParentId = bdObj3.Id;
        attachment3.Name = 'testSwal';
        attachment3.Body = Blob.valueof('SW008,655200, 2018, 160,KG\r\n');
        insert attachment3;
        System.debug('attachment3 :----'+attachment3);
        
        
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
        
        Product2 pro1 = new Product2();
        pro1.ProductCode = '655200';
        pro1.Product_Code__c='655200';
        pro1.Name='SAATHI';
        pro1.Sales_Org__c=salesOrg.Id;
        pro1.popular__c = true;
        pro1.Combination_Key__c='RM00655200';
        insert pro1;
        
        Liquidation_Annual_Plan__c liqAPObj= new Liquidation_Annual_Plan__c();
        liqAPObj.FIscal_Year__c='2018-2019';
        insert liqAPObj;
        
        Territory_Distributor__c tdObj= new Territory_Distributor__c();
        tdObj.Name='Narayangaon';
        tdObj.TerritoryCode__c  ='235';
        insert tdObj;
        
        Territory_Distributor__c tdObj1= new Territory_Distributor__c();
        tdObj1.Name='Pune';
        tdObj1.TerritoryCode__c  ='SW008';
        insert tdObj1;
        
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
        oiObj.Liquidation_Annual_Plan__c = liqAPObj.Id;
        oiObj.Territory__c = tdObj.Id;
        insert oiObj;
        
        
        Opening_Inventory2__c oiObj1= new Opening_Inventory2__c();
        oiObj1.YTD_Sales__c=20;
        oiObj1.YTD_Sales_Jan__c=20;
        oiObj1.YTD_Sales_Feb__c=20;
        oiObj1.YTD_Sales_Mar__c=20;
        oiObj1.YTD_Sales_Apr__c=20;
        oiObj1.YTD_Sales_Mar__c=20;
        oiObj1.YTD_Sales_Jun__c=20;
        oiObj1.YTD_Sales_Jul__c=20;
        oiObj1.YTD_Sales_Aug__c=20;
        oiObj1.YTD_Sales_Sept__c=20;
        oiObj1.YTD_Sales_Oct__c=20;
        oiObj1.YTD_Sales_Nov__c=20;
        oiObj1.YTD_Sales_Dec__c=20;
        oiObj1.Product__c=pro1.Id;
        oiObj1.Liquidation_Annual_Plan__c = liqAPObj.Id;
        oiObj1.Territory__c = tdObj1.Id;
        insert oiObj1;
        
        Liquidation2__c liqObj = new Liquidation2__c();
        liqObj.YTD_Sales__c=20;
        liqObj.Product__c=pro.Id;
        liqObj.Liquidation_Annual_Plan__c=liqAPObj.Id;
        liqObj.Territory__c=tdObj.Id;
        insert liqObj;
        
        
           
        
    }
    
    
    static testMethod void method() {
    //allTheDataForThisTestClass();
        Database.executeBatch(new BusinessDashboardReadAndPopulateBatch (),10);
    }
    
    static testMethod void method2() {
        //allTheDataForThisTestClass();
        BusinessDashboard__c bdObj  = [SELECT ID FROM BusinessDashboard__c Where EmailSubject__c = 'UPL_Business_Dashboard_2017-03-01-15-20-40_.txt'];
        Attachment attachment = [SELECT ID FROM Attachment WHERE ParentId =: bdObj.Id];
        attachment.Body = Blob.valueof('112,0001001299,error,error,,error,error,error,2\r\n');
        update attachment;
        Database.executeBatch(new BusinessDashboardReadAndPopulateBatch (),10);
    }
    
     /*static testMethod void method3(){
        System.debug('method 4 :----');
        BusinessDashboard__c oIObj  = [SELECT ID FROM BusinessDashboard__c Where EmailSubject__c = 'test_liquidation3.txt'];
        System.debug('oIObj.Id :----'+oIObj.Id);
        Attachment attachment = [SELECT ID FROM Attachment WHERE ParentId =: oIObj.Id];
        attachment.Body = Blob.valueof('235, 71450, 2018, 2, 488.00,KG\r\n');
        update attachment;
        System.debug('attachment :----'+attachment);
        Database.executeBatch(new BusinessDashboardReadAndPopulateBatch (),10);
    }*/
    static testMethod void method3() {
       // allTheDataForThisTestClass();
        delete[SELECT ID FROM BusinessDashboard__c];
        BusinessDashboard__c bdObj = new BusinessDashboard__c();
        bdObj.Status__c = 'Draft';
        insert bdObj;
        Database.executeBatch(new BusinessDashboardReadAndPopulateBatch (),10);
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
        bdObj.EmailSubject__c = 'Export Order';
        bdObj.FromAddress__c = 'prashant.chinchpure@skinternational.com' ;
        bdObj.Status__c = 'Draft';
        bdObj.As_of_now__c = System.now();
        bdObj.Rows__c = 5;
        bdObj.Header__c = 'Ship to Party,Ship to Party-Key,Ship-to Country,Ship-to Country-Key,Sold to party,Sold to party-Key,Plant,Sales Order No.,SO Date,Customer PO,Customer PO Date,Material Code,Material Description (Product/ Packing),Order Quantity,Schedule Line Date,Label Remark in SO,Label Confirmation Date,Credit Status,Req. Delivery date,Last Date of Shipment as per LC ,Commitment Date,Rev Commitment Date,Act Readiness Date,Fact. Stuffing Date ( PGI),Invoice Quantity,Pending Quantity,Tentative Sailing Date,Actual Sailing Date,Tentative Arrival Date,Vessel Name,Container No.,Logistics Feedback,Shipping Status,Document Currency,SO Net Price,SO Net Value,Invoice Net Value,SALES MONTH,Payment Terms - Medium Text,Commercial Invoice,Commercial Invoice Date,DHL No.,DHL Date,Copy Docs Date,DOCS. REMARK,Ldoc No,REGION,Overall Order Status,Excise invoice,Delivery Block,Reason for Rejection,Item,Schedule Line,Order Quantity Unit,Bill of lading Date,Material Group Code,Material Group Description,Distribution channel,Distribution channel-Key,Division,Division-Key,Sales Office,Sales Office - Key,Unconfirmed MAD,Status\r\n';
        insert bdObj;
        System.debug('bdObj :----'+bdObj);
        
        Attachment attachment = new Attachment();
        attachment.ParentId = bdObj.Id;
        attachment.Name = 'Export_Order__c.csv';
        attachment.Body = Blob.valueof('"UPL - Vietnam (Bonded Warehouse)","U5002026","Vietnam","IN","UPL - Vietnam (Bonded Warehouse)","U5002026","PL03","5005000722","29-MAR-18","PO181901","29-MAR-18","6300222","MANCOZEB 80 WP (BLUE) - 25 KG_VN","12,000","15-JUN-18"," STENCILING/STANDARD","","OK","03-MAY-18","","25-APR-18","05-MAY-18","02-MAY-18","01-MAY-18","12,000","0","08-MAY-18","08-MAY-18","08-MAY-18","ZIM LOS ANGELES V-057E","CAIU6073156","","DELIVERED","USD","2.5","30,000","30,000","MAY.18","CONSIGNMENT SALE EXPORT.","1400566954","01-MAY-18","8578442434","14-MAY-18","11-MAY-18"," ","1000028490","ASIA","Completed","1416546827","","","10","1","KG","08-MAY-18","55500","MANCOZEB 80% WP","Exports - Non Subs","40","Agro Formulation","10","UPL - HO","HOP1","13-MAY-18","ORDERS COMPLETED"\r\n');
        insert attachment;
        System.debug('attachmen :----'+attachment);
        
        Schema_Definition__c sdObj = new Schema_Definition__c();
        sdObj.Name = 'Export_Order__c';
        sdObj.Mapping_Definition__c = '[{"position": 0,"label": "Territory Code","fieldType": "STRING","column": "Territory\\t","api": "TerritoryCode__c"}, {"position": 2,"label": "PY Actual - MTD","fieldType": "DOUBLE","column": "\\tActual Sales FEB 2016\\t","api": "py_actual_mtd__c"}]';
        insert sdObj;
        System.debug('sdObj :----'+sdObj);
        
        SchemaObjectMapping__c smObj = new SchemaObjectMapping__c();
        smObj.Name = 'Export_Order__c';
        smObj.Object__c = 'Export_Order__c';
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
        
        
        BusinessDashboard__c bdObj1  = [SELECT ID FROM BusinessDashboard__c Where EmailSubject__c = 'Export Order'];
        Attachment attachment1 = [SELECT ID FROM Attachment WHERE ParentId =: bdObj1.Id];
        attachment1.Body = Blob.valueof('"UPL - Vietnam (Bonded Warehouse)","U5002026","Vietnam","IN","UPL - Vietnam (Bonded Warehouse)","U5002026","PL03","5005000722","29-MAR-18","PO181901","29-MAR-18","6300222","MANCOZEB 80 WP (BLUE) - 25 KG_VN","12,000","15-JUN-18"," STENCILING/STANDARD","","OK","03-MAY-18","","25-APR-18","05-MAY-18","02-MAY-18","01-MAY-18","12,000","0","08-MAY-18","08-MAY-18","08-MAY-18","ZIM LOS ANGELES V-057E","CAIU6073156","","DELIVERED","USD","2.5","30,000","30,000","MAY.18","CONSIGNMENT SALE EXPORT.","1400566954","01-MAY-18","8578442434","14-MAY-18","11-MAY-18"," ","1000028490","ASIA","Completed","1416546827","","","10","1","KG","08-MAY-18","55500","MANCOZEB 80% WP","Exports - Non Subs","40","Agro Formulation","10","UPL - HO","HOP1","13-MAY-18","ORDERS COMPLETED"\r\n');
        update attachment1;
        Database.executeBatch(new BusinessDashboardReadAndPopulateBatch (),10);
    
    
    }
    
    static testMethod void methodInvokeScheduler(){
        //allTheDataForThisTestClass();
        Test.StartTest();
        String cronStr = '0  00 1 3 * ?';
        System.schedule('Scheduler', cronStr, new BatchParsingScheduler());
        Test.stopTest();
    }

}