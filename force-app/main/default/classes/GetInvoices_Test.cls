/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Test class for getInvoicesapex class
*
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Manisha Yadav   <myadava1@in.ibm.com>
* @modifiedBy     Manisha Yadav   <myadava1@in.ibm.com>
* @maintainedBy   Manisha Yadav   <myadava1@in.ibm.com>
* @version        1.0 
* @created        2020-03-04
* @modified       2020-03-04 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
*                 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/@isTest
public class GetInvoices_Test {
    
    
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
            // Optionally, only send a mock response for a specific endpoint
            // and method.
            System.assertEquals('http://example.com/example/test', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            List<SalesOrderTrackingSalesOrders> wrppList=new List<SalesOrderTrackingSalesOrders>();
            SalesOrderTrackingSalesOrders wrpp=new SalesOrderTrackingSalesOrders();
            wrpp.sapSalesOrderNumber='7676767676';
            wrppList.add(wrpp);
            // Create a fake response
            HttpResponse res = new HttpResponse();
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('status','E'); 
            gen.writeObjectField('salesOrders',wrppList);          
            gen.writeEndObject();
            res.setBody(gen.getAsString());
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            
            return res;
        }
    }
    
    
    public class MockHttpResponseGeneratorSuccMaterial implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
            // Optionally, only send a mock response for a specific endpoint
            // and method.
            //System.assertEquals('http://example.com/example/test', req.getEndpoint());
            //System.assertEquals('POST', req.getMethod());
            List<SalesOrderTrackingInvoices > wrppList=new List<SalesOrderTrackingInvoices >();
            SalesOrderTrackingInvoices wrpp=new SalesOrderTrackingInvoices();
            wrpp.generalStatusOfTheInvoice='test';
            wrpp.invoiceDate=String.valueOf(system.now());
            wrpp.cancellationDate=String.valueOf(system.now());
            wrpp.invoiceTotalValue=String.valueOf(1.2);
            wrpp.invoiceIdNumber='2110787983';
            wrppList.add(wrpp);
            List<SalesOrderTrackingMaterial> wrapMat = new List<SalesOrderTrackingMaterial>();
            SalesOrderTrackingMaterial mat = new SalesOrderTrackingMaterial();
            mat.invoiceNumber ='testId';
            mat.volume = string.valueOf(5);
            mat.value = string.valueOf(100);
            mat.productCode ='3213456796854';
            mat.UnitPrice='123';
            mat.ManufacturingDate='2023-07-1';
            mat.deliveryDate='2023-07-1';
            mat.estimatedDeliveryDate='2023-07-1';
            wrapMat.add(mat);
            // Create a fake response
            HttpResponse res = new HttpResponse();
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('status','S');
            gen.writeObjectField('invoices',wrppList);
            gen.writeObjectField('materials',wrapMat);
            gen.writeEndObject();            
            res.setBody(gen.getAsString());
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            
            return res;
        }
    }
    
    
    
    public class MockHttpResponseGeneratorSucc implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
            // Optionally, only send a mock response for a specific endpoint
            // and method.
            System.assertEquals('http://example.com/example/test', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            List<SalesOrderTrackingInvoices > wrppList=new List<SalesOrderTrackingInvoices >();
            SalesOrderTrackingInvoices wrpp=new SalesOrderTrackingInvoices();
            wrpp.generalStatusOfTheInvoice='test';
            wrpp.invoiceDate=String.valueOf(system.now());
            wrpp.cancellationDate=String.valueOf(system.now());
            wrpp.invoiceTotalValue=String.valueOf(1.2);
            wrpp.invoiceIdNumber='testId';
            wrppList.add(wrpp);
            // Create a fake response
            HttpResponse res = new HttpResponse();
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('status','S');
            gen.writeObjectField('invoices',wrppList);           
            gen.writeEndObject();            
            res.setBody(gen.getAsString());
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            
            return res;
        }
    }
    
    public class MockHttpResponseGeneratorSucc1 implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
            // Optionally, only send a mock response for a specific endpoint
            // and method.
            System.assertEquals('http://example.com/example/test', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
            List<SalesOrderTrackingInvoices > wrppList=new List<SalesOrderTrackingInvoices >();
            SalesOrderTrackingInvoices wrpp=new SalesOrderTrackingInvoices();
            wrpp.generalStatusOfTheInvoice='test';
            wrpp.invoiceDate=String.valueOf(system.now());
            wrpp.cancellationDate=String.valueOf(system.now());
            wrpp.invoiceTotalValue=String.valueOf(1.2);
            wrpp.invoiceIdNumber='testId';
            wrppList.add(wrpp);
            // Create a fake response
            HttpResponse res = new HttpResponse();
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('status','S');
            gen.writeObjectField('invoices',wrppList);           
            gen.writeEndObject();            
            res.setBody(gen.getAsString());
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            
            return res;
        }
    }
    
    public class MockHttpResponseGeneratorFail1 implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
            // Optionally, only send a mock response for a specific endpoint
            // and method.
            System.assertEquals('http://example.com/example/test', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
            List<SalesOrderTrackingInvoices > wrppList=new List<SalesOrderTrackingInvoices >();
            SalesOrderTrackingInvoices wrpp=new SalesOrderTrackingInvoices();
            wrpp.generalStatusOfTheInvoice='test';
            wrpp.invoiceDate=String.valueOf(system.now());
            wrpp.cancellationDate=String.valueOf(system.now());
            wrpp.invoiceTotalValue=String.valueOf(1.2);
            wrpp.invoiceIdNumber='testId';
            wrppList.add(wrpp);
            // Create a fake response
            HttpResponse res = new HttpResponse();
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('status','E');
            gen.writeObjectField('invoices',wrppList);           
            gen.writeEndObject();            
            res.setBody('fail');
            res.setStatusCode(201);
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(201);
            
            return res;
        }
    }
    
    
    
    
    static testMethod void Call_fetchSalesOrderStatus_fail(){
        insert new UPL_Settings__c(Sales_Order_Tracking_URL__c='http://example.com/example/test',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        sorg=[SELECT Id,sales_org_code__c from sales_org__c];
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account accObj = new Account(
            Name = 'Test',                                                // Account Name
            Last_Name__c = 'Test Last',                                                 // Last Name
            SAP_Code__c = '0001052626',                                                    // SAP Customer Code
            Mobile__c = '000000000000',                                                    // Mobile
            Email__c = 'test@test.com',                                       // Email
            Order_Block__c = false,                                                        // Order Block
            TaxNumber2__c = '8300950488',                                                  // Tax Number 2
            Tax_Number_1__c = '830092048',                                                 // Tax Number 1
            Account_Type__c = 'Sold To Party',                                             // Account Type
            Billing_Street_1__c = 'KM 2 5 AUT A MEDELLIN PAR IND. PORTOS SABANA 80 BG95',  // Billing Street 1
            Sales_Org__c = sorg .Id,
            recordTypeId = RecordTypeId,
            //Division__c = divisionObj.Id,                                               // Division Name
            //Distribution_Channel__c = DistributionChannelObj.Id,                                   // Distribution Channel
            Depot_Code__c = 'BR00',                                                        // Depot Code
            Payment_Terms__c = 'UK10'                                                     // Payment Terms
            
        );
        insert accObj;   
        
        
        
        Sales_Order__c sobj = new Sales_Order__c(            
            SAP_Order_Number__c='7676767676',
            Last_Invoice_Updated__c=system.now(),
            Last_Invoice_Update_Status__c='Success',
            Last_SuccessFull_Invoice_Update__c=system.now(),
            Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
            Bill_To_Party__c =accObj.Id,                  // Bill To Party
            Sold_to_Party__c = accObj.Id,                 // Sold to Party
            SalesOrg__c=sorg.Id            
        );
        insert sobj;
        SalesOrderTrackingRequestWrapper req = new SalesOrderTrackingRequestWrapper();
        req.dateFrom = '';
        req.dateTo = '';
        req.invoiceId = '';
        req.sapOrderNumber ='7676767676';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());  
        getinvoices.fetchSalesOrderStatus();
        Test.stopTest(); 
    } 
    
    static testMethod void Call_GetInvoice_Succ(){
        insert new UPL_Settings__c(Sales_Order_Tracking_URL__c='http://example.com/example/test',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        sorg=[SELECT Id,sales_org_code__c from sales_org__c];
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account accObj = new Account(
            Name = 'Test',                                                // Account Name
            Last_Name__c = 'Test Last',                                                 // Last Name
            SAP_Code__c = '0001052626',                                                    // SAP Customer Code
            Mobile__c = '000000000000',                                                    // Mobile
            Email__c = 'test@test.com',                                       // Email
            Order_Block__c = false,                                                        // Order Block
            TaxNumber2__c = '8300950488',                                                  // Tax Number 2
            Tax_Number_1__c = '830092048',                                                 // Tax Number 1
            Account_Type__c = 'Sold To Party',                                             // Account Type
            Billing_Street_1__c = 'KM 2 5 AUT A MEDELLIN PAR IND. PORTOS SABANA 80 BG95',  // Billing Street 1
            Sales_Org__c = sorg .Id, 
            recordTypeId = RecordTypeId,
            Depot_Code__c = 'BR00',                                                        // Depot Code
            Payment_Terms__c = 'UK10'                                                     // Payment Terms
            
        );
        insert accObj;   
        
        
        Sales_Order__c sobj = new Sales_Order__c(            
            SAP_Order_Number__c='7676767676',
            Last_Invoice_Updated__c=system.now(),
            Last_Invoice_Update_Status__c='Success',
            Last_SuccessFull_Invoice_Update__c=system.now(),
            Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
            Bill_To_Party__c =accObj.Id,                  // Bill To Party
            Sold_to_Party__c = accObj.Id,                 // Sold to Party
            SalesOrg__c=sorg.Id         
            
        );
        insert sobj;
        SalesOrderTrackingRequestWrapper req = new SalesOrderTrackingRequestWrapper();
        req.dateFrom = '';
        req.dateTo = '';
        req.invoiceId = '';
        req.sapOrderNumber ='7676767676';
        
        Test.startTest();          
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorSucc()); 
        getinvoices.GetInvoicesAPICall('7676767676');
        Test.stopTest(); 
    }  
    static testMethod void Call_GetProductsMaterials_Succ(){
        insert new UPL_Settings__c(Sales_Order_Tracking_URL__c='http://example.com/example/test',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        sorg=[SELECT Id,sales_org_code__c from sales_org__c];
        SKU__c skuo = TestDataFactory.CreateSKU('3213456796854',sorg,'32134567968545191'); 
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account accObj = new Account(
            Name = 'Test',                                                // Account Name
            Last_Name__c = 'Test Last',                                                 // Last Name
            SAP_Code__c = '0001052626',                                                    // SAP Customer Code
            Mobile__c = '000000000000',                                                    // Mobile
            Email__c = 'test@test.com',                                       // Email
            Order_Block__c = false,                                                        // Order Block
            TaxNumber2__c = '8300950488',                                                  // Tax Number 2
            Tax_Number_1__c = '830092048',                                                 // Tax Number 1
            Account_Type__c = 'Sold To Party',                                             // Account Type
            Billing_Street_1__c = 'KM 2 5 AUT A MEDELLIN PAR IND. PORTOS SABANA 80 BG95',  // Billing Street 1
            Sales_Org__c = sorg .Id,
            recordTypeId = RecordTypeId,// sales org Id
            Depot_Code__c = 'BR00',                                                        // Depot Code
            Payment_Terms__c = 'UK10'                                                     // Payment Terms
            
        );
        insert accObj;   
        
        
        Sales_Order__c sobj = new Sales_Order__c(            
            SAP_Order_Number__c='7676767676',
            Last_Invoice_Updated__c=system.now(),
            Last_Invoice_Update_Status__c='Success',
            Last_SuccessFull_Invoice_Update__c=system.now(),
            Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
            Bill_To_Party__c =accObj.Id,                  // Bill To Party
            Sold_to_Party__c = accObj.Id,                 // Sold to Party
            SalesOrg__c=sorg.Id
            
        );
        insert sobj;
        
        
        Invoice__c InvoiceObj = new Invoice__c(
            Billing_Doc_Number__c = '2110787983',       // Billing Doc Number
            Billing_Date__c = System.today(),  // Billing Date
            PO_Number__c = '2438',                        // PO Number
            Sold_To_Party__c = accObj.Id,         // Sold To Party
            Sales_Org__c = sorg.Id ,          // Sales Org
            Sales_Order__c=sobj.Id             // Division
        );
        insert InvoiceObj;
        
        
        
        
        SalesOrderTrackingRequestWrapper req = new SalesOrderTrackingRequestWrapper();
        req.dateFrom = '';
        req.dateTo = '';
        req.invoiceId = InvoiceObj.id;
        req.sapOrderNumber ='7676767676';
        
        Test.startTest();          
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorSuccMaterial()); 
        getinvoices.GetProductsMaterialsAPICall('2110787983');          
        
        Test.stopTest(); 
    }
    static testMethod void Call_GetDoc_Succ(){
        insert new UPL_Settings__c(Sales_Order_Tracking_URL__c='http://example.com/example/test',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        sorg=[SELECT Id,sales_org_code__c from sales_org__c];
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account accObj = new Account(
            Name = 'Test',                                                // Account Name
            Last_Name__c = 'Test Last',                                                 // Last Name
            SAP_Code__c = '0001052626',                                                    // SAP Customer Code
            Mobile__c = '000000000000',                                                    // Mobile
            Email__c = 'test@test.com',                                       // Email
            Order_Block__c = false,                                                        // Order Block
            TaxNumber2__c = '8300950488',                                                  // Tax Number 2
            Tax_Number_1__c = '830092048',                                                 // Tax Number 1
            Account_Type__c = 'Sold To Party',                                             // Account Type
            Billing_Street_1__c = 'KM 2 5 AUT A MEDELLIN PAR IND. PORTOS SABANA 80 BG95',  // Billing Street 1
            Sales_Org__c = sorg .Id,
            recordTypeId = RecordTypeId,
            Depot_Code__c = 'BR00',                                                        // Depot Code
            Payment_Terms__c = 'UK10'                                                     // Payment Terms
            
        );
        insert accObj;   
        
        
        Sales_Order__c sobj = new Sales_Order__c(            
            SAP_Order_Number__c='7676767676',
            Last_Invoice_Updated__c=system.now(),
            Last_Invoice_Update_Status__c='Success',
            Last_SuccessFull_Invoice_Update__c=system.now(),
            Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
            Bill_To_Party__c =accObj.Id,                  // Bill To Party
            Sold_to_Party__c = accObj.Id,                 // Sold to Party
            SalesOrg__c=sorg.Id
            
        );
        insert sobj;
        
        
        Invoice__c InvoiceObj = new Invoice__c(
            Billing_Doc_Number__c = '2110787983',       // Billing Doc Number
            Billing_Date__c = System.today(),  // Billing Date
            PO_Number__c = '2438',                        // PO Number
            Sold_To_Party__c = accObj.Id,         // Sold To Party
            Sales_Org__c = sorg.Id ,          // Sales Org
            Sales_Order__c=sobj.id 
        );
        insert InvoiceObj;
        
        ContentVersion cv = new ContentVersion(Title='einstein_platform', PathOnClient='/Test.pdf', VersionData=Blob.valueof('some key'));
        insert cv;
        
        SalesOrderTrackingRequestWrapper req = new SalesOrderTrackingRequestWrapper();
        req.dateFrom = '';
        req.dateTo = '';
        req.invoiceId = InvoiceObj.id;
        req.sapOrderNumber ='7676767676';
        
        Test.startTest();          
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorSucc1()); 
        getinvoices.getDoc('123','2110787983','2110787983', InvoiceObj.id,'username','password','http://example.com/example/test','.pdf');          
        getinvoices.getDoc('123','2110787983','2110787983', InvoiceObj.id,'username','password','http://example.com/example/test','.xml');          
        
        Test.stopTest(); 
    } 
    static testMethod void Call_GetDoc_Fail(){
        insert new UPL_Settings__c(Sales_Order_Tracking_URL__c='http://example.com/example/test',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        sorg=[SELECT Id,sales_org_code__c from sales_org__c];
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account accObj = new Account(
            Name = 'Test',                                                // Account Name
            Last_Name__c = 'Test Last',                                                 // Last Name
            SAP_Code__c = '0001052626',                                                    // SAP Customer Code
            Mobile__c = '000000000000',                                                    // Mobile
            Email__c = 'test@test.com',                                       // Email
            Order_Block__c = false,                                                        // Order Block
            TaxNumber2__c = '8300950488',                                                  // Tax Number 2
            Tax_Number_1__c = '830092048',                                                 // Tax Number 1
            Account_Type__c = 'Sold To Party',                                             // Account Type
            Billing_Street_1__c = 'KM 2 5 AUT A MEDELLIN PAR IND. PORTOS SABANA 80 BG95',  // Billing Street 1
            Sales_Org__c = sorg .Id, 
            recordTypeId = RecordTypeId,// Sales Org
            Depot_Code__c = 'BR00',                                                        // Depot Code
            Payment_Terms__c = 'UK10'                                                     // Payment Terms
            
        );
        insert accObj;   
        
        
        Sales_Order__c sobj = new Sales_Order__c(            
            SAP_Order_Number__c='7676767676',
            Last_Invoice_Updated__c=system.now(),
            Last_Invoice_Update_Status__c='Success',
            Last_SuccessFull_Invoice_Update__c=system.now(),
            Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
            Bill_To_Party__c =accObj.Id,                  // Bill To Party
            Sold_to_Party__c = accObj.Id,                 // Sold to Party
            SalesOrg__c=sorg.Id
            
        );
        insert sobj;
        
        
        Invoice__c InvoiceObj = new Invoice__c(
            Billing_Doc_Number__c = '2110787983',       // Billing Doc Number
            Billing_Date__c = System.today(),  // Billing Date
            PO_Number__c = '2438',                        // PO Number
            Sold_To_Party__c = accObj.Id,         // Sold To Party
            Sales_Org__c = sorg.Id ,          // Sales Org
            Sales_Order__c=sobj.id 
        );
        insert InvoiceObj;
        
        ContentVersion cv = new ContentVersion(Title='einstein_platform', PathOnClient='/Test.pdf', VersionData=Blob.valueof('some key'));
        insert cv;
        
        SalesOrderTrackingRequestWrapper req = new SalesOrderTrackingRequestWrapper();
        req.dateFrom = '';
        req.dateTo = '';
        req.invoiceId = InvoiceObj.id;
        req.sapOrderNumber ='7676767676';
        
        Test.startTest();          
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorFail1()); 
        getinvoices.getDoc('123','2110787983','2110787983', InvoiceObj.id,'username','password','http://example.com/example/test','.pdf');          
        getinvoices.getDoc('123','2110787983','2110787983', InvoiceObj.id,'username','password','http://example.com/example/test','.xml');          
        
        Test.stopTest(); 
    } 
    
    
}