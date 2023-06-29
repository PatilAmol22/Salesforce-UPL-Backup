/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Test Class for ScheduleFetchSalesOrderStatus
*
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Anjaneyulu  <aanjaney@in.ibm.com>
* @modifiedBy     Anjaneyulu   <aanjaney@in.ibm.com>
* @maintainedBy   Anjaneyulu   <aanjaney@in.ibm.com>
* @version        1.0
* @created        2020-03-4
* @modified       2020-03-4
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
*                 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/



@isTest
public class ScheduleFetchSalesOrderStatusTest {
    
   public class MockHttpScheduleFetchSalesOrderStatusTest implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
            // Optionally, only send a mock response for a specific endpoint
            // and method.
            //insert new UPL_Settings__c(Sales_Order_Tracking_URL__c='http://example.com/example/test',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
            Sales_Org__c sorg =new Sales_Org__c();
            sorg.Name='Brazil';
            sorg.Description__c='Brazil';
            sorg.Sales_Org_Code__c='5191';
            insert sorg;
            Account accObj = new Account(
                Name = 'Test',                                                // Account Name
                Last_Name__c = 'Test Last',                                                 // Last Name
                SAP_Code__c = '0001052628',                                                    // SAP Customer Code
                Mobile__c = '000000000000',                                                    // Mobile
                Email__c = 'test@test.com',                                       // Email
                Order_Block__c = false,                                                        // Order Block
                TaxNumber2__c = '8300950488',                                                  // Tax Number 2
                Tax_Number_1__c = '830092048',                                                 // Tax Number 1
                Account_Type__c = 'Sold To Party',                                             // Account Type
                Billing_Street_1__c = 'KM 2 5 AUT A MEDELLIN PAR IND. PORTOS SABANA 80 BG95',  // Billing Street 1
                Sales_Org__c = sorg .Id,                                              // Sales Org
                //Division__c = divisionObj.Id,                                               // Division Name
                //Distribution_Channel__c = DistributionChannelObj.Id,                                   // Distribution Channel
                Depot_Code__c = 'BR00',                                                        // Depot Code
                Payment_Terms__c = 'UK10'                                                     // Payment Terms
                
            );
            //insert accObj;   
            System.assertEquals('http://example.com/example/test', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            
            // Create a fake response
            Sales_Order__c sobj = new Sales_Order__c(            
               
                SAP_Order_Number__c='7676767678',
                Last_Invoice_Updated__c=system.now(),
                Last_Invoice_Update_Status__c='Success',
                Last_SuccessFull_Invoice_Update__c=system.now(),
                Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
                //Bill_To_Party__c =accObj.Id,                  // Bill To Party
                //Sold_to_Party__c = accObj.Id,                 // Sold to Party
                SalesOrg__c=sorg.Id,
                createdDate = System.today()
                
            );
            
            //insert sobj;
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            List<SalesOrderTrackingSalesOrders> wrppList=new List<SalesOrderTrackingSalesOrders>();
            SalesOrderTrackingSalesOrders wrpp=new SalesOrderTrackingSalesOrders();
            wrpp.sapSalesOrderNumber='7676767678';
            wrpp.creditStatus='test';
            wrppList.add(wrpp);
            List<SalesOrderTrackingInvoices> wrppListInv=new List<SalesOrderTrackingInvoices>();
            SalesOrderTrackingInvoices wrppInv=new SalesOrderTrackingInvoices();
            wrppInv.carrierName = 'test';
            wrppInv.deliveryDate = '2020-02-02';
            wrppInv.destinationDocument = '312312';
            wrppInv.estimatedDeliveryDate = '2020-01-01';
            wrppInv.generalStatusOfTheInvoice = 'test';
            wrppInv.invoiceDate = '2021-01-01';
            wrppInv.cancellationDate = '2021-01-01';
            wrppInv.invoiceIdNumber = '123456';
            wrppInv.invoicekey = '2141241241';
            wrppInv.invoiceNumber = '24124';
            wrppInv.invoiceSeries = '2';
            wrppInv.invoiceTotalValue = '23';
            wrppInv.sapOrderNumber = '7676767678';
            wrppInv.senderDocument = '21412';
            wrppListInv.add(wrppInv);
            List<SalesOrderTrackingMaterial> wrppListMaterial=new List<SalesOrderTrackingMaterial>();
            SalesOrderTrackingMaterial material=new SalesOrderTrackingMaterial();
            material.invoiceDate = '2022-01-09';
            material.invoiceNumber = '214124';
            material.invoiceSeries = '2';
            material.itemNumber = '412412';
            material.notUsed = '2141241';
            material.productCode = '124124';
            material.productCode = '24124';
            material.productName = 'test';
            material.value = '343';
            material.volume = '3542';
            wrppListMaterial.add(material);
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('status','S');
            gen.writeObjectField('salesOrders',wrppList);
            gen.writeObjectField('invoices',wrppListInv);
            gen.writeObjectField('materials',wrppListMaterial);
            gen.writeEndObject();
            res.setBody(gen.getAsString());
            res.setStatusCode(200);
            return res;
        }
    }
    
    
    testmethod static void executeTest(){
        List<WrapperDate> wrapperr=new List<WrapperDate>();
        WrapperDate wrap=new WrapperDate();
        wrap.startDate = Date.newInstance(2020, 3, 9);
        wrap.endDate = Date.newInstance(2020, 3, 30);
        wrapperr.add(wrap);
        
        
        
        	UPL_Settings__c cussetting=new UPL_Settings__c();
           	cussetting.Sales_Order_Tracking_URL__c='http://example.com/example/test';
           	cussetting.Visibility_Date__c = 10;
            cussetting.SalesOrg__c='5191';
            cussetting.PaddingSAPCode__c=10;
            cussetting.PaddingSKU__c=18;
            cussetting.BatchDateRange__c=10;
            cussetting.BatchSize__c=20;
            cussetting.OrderBatchDateRange__c=20;
            cussetting.OrderBatchSize__c=20;
            insert cussetting;
        
        
        
        Test.startTest();
     	Test.setMock(HttpCalloutMock.class, new MockHttpScheduleFetchSalesOrderStatusTest());
        SchedulableContext sch=null;
        ScheduleFetchSalesOrderStatus scheduleTest=new ScheduleFetchSalesOrderStatus();
        scheduleTest.execute(sch);
        
        Test.stopTest();
    }
}