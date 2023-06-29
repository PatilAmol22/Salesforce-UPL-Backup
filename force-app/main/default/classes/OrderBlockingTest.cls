/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Test Class for OrderBlocking
*
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Swapnil More   <swapnil.more@in.ibm.com>
* @modifiedBy     Swapnil More   <swapnil.more@in.ibm.com>
* @maintainedBy   Swapnil More   <swapnil.more@in.ibm.com>
* @version        1.0
* @created        2020-01-27
* @modified       2020-01-27
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes

* @author         Anjaneyulu  <aanjaney@in.ibm.com>
* @modifiedBy     Anjaneyulu   <aanjaney@in.ibm.com>
* @maintainedBy   Anjaneyulu   <aanjaney@in.ibm.com>
* @version        1.0
* @created        2020-03-6
* @modified       2020-03-6              
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/


@isTest
public class OrderBlockingTest {
    
    
    public class MockHttpOrderBlockingTest implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
             // Optionally, only send a mock response for a specific endpoint
            // and method.
            //insert new UPL_Settings__c(Sales_Order_Tracking_URL__c='http://example.com/example/test',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
         
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            List<SalesOrderTrackingSalesOrders> wrppList=new List<SalesOrderTrackingSalesOrders>();
            SalesOrderTrackingSalesOrders wrpp=new SalesOrderTrackingSalesOrders();
            wrpp.sapSalesOrderNumber='7676767676';
            //wrpp.creditStatus=sobj.Invoice_Status__c;
            wrppList.add(wrpp);
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('Message_Type','E');
            gen.writeObjectField('salesOrders',wrppList);
            gen.writeEndObject();
            res.setBody(gen.getAsString());
            res.setStatusCode(200);
            return res;
        }
    }
    
    public class MockHttpOrderBlockingTests implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
             // Optionally, only send a mock response for a specific endpoint
            // and method.
            //insert new UPL_Settings__c(Sales_Order_Tracking_URL__c='http://example.com/example/test',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
         
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            List<SalesOrderTrackingSalesOrders> wrppList=new List<SalesOrderTrackingSalesOrders>();
            SalesOrderTrackingSalesOrders wrpp=new SalesOrderTrackingSalesOrders();
            wrpp.sapSalesOrderNumber='7676767676';
            //wrpp.creditStatus=sobj.Invoice_Status__c;
            wrppList.add(wrpp);
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('Message_Type','S');
            gen.writeObjectField('salesOrders',wrppList);
            gen.writeEndObject();
            res.setBody(gen.getAsString());
            res.setStatusCode(200);
            return res;
        }
    }
    public class MockHttpOrderBlockingTests1 implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
             // Optionally, only send a mock response for a specific endpoint
            // and method.
            //insert new UPL_Settings__c(Sales_Order_Tracking_URL__c='http://example.com/example/test',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
         
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            List<SalesOrderTrackingSalesOrders> wrppList=new List<SalesOrderTrackingSalesOrders>();
            SalesOrderTrackingSalesOrders wrpp=new SalesOrderTrackingSalesOrders();
            wrpp.sapSalesOrderNumber='7676767676';
            //wrpp.creditStatus=sobj.Invoice_Status__c;
            wrppList.add(wrpp);
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('Message_Type','E');
            gen.writeObjectField('salesOrders',wrppList);
            gen.writeEndObject();
            res.setBody(gen.getAsString());
            res.setStatusCode(200);
            return res;
        }
    }
    @isTest static void testCalloutSuccess() {
        //Test.setMock(HttpCalloutMock.class, new MockClassForOrderBlockingSuccess());
        
        
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
            sorg=[SELECT Id,sales_org_code__c from sales_org__c];
            
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
                Sales_Org__c = sorg .Id,                                              // Sales Org
                //Division__c = divisionObj.Id,                                               // Division Name
                //Distribution_Channel__c = DistributionChannelObj.Id,                                   // Distribution Channel
                Depot_Code__c = 'BR00',                                                        // Depot Code
                Payment_Terms__c = 'UK10'                                                     // Payment Terms
                
            );
            insert accObj;   
            
              Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        pro.Brand_Name__c = 'SPERTO';
        Insert Pro;
        
        SKU__c sku2 = new SKU__c();
        sku2.Name='P2';
        sku2.SKU_Code__c='704001';
        sku2.SKU_Pack__c = 1.00;
        sku2.SKU_UOM__c='L';
        sku2.Multiple_Of__c=5;
        sku2.Group__c='P2';
        sku2.Pack_Size__c=10.00;
        sku2.Product_Name__c=pro.Id;
        sku2.Sales_Org__c = sorg.Id;
        sku2.UOM__c='L';
        sku2.Active__c=True;
        sku2.Brand_Name__c='SPERTO';
        sku2.Combination_Key__c='Cooooooo000012111';
        Insert sku2;
            // Create a fake response
            Sales_Order__c sobj = new Sales_Order__c(            
               
                SAP_Order_Number__c='7676767676',
                Last_Invoice_Updated__c=system.now(),
                SDM_Approval_On_Order_Cancellation__c=2,
                Last_Invoice_Update_Status__c='Success',
                Last_SuccessFull_Invoice_Update__c=system.now(),
                Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
                Bill_To_Party__c =accObj.Id,                  // Bill To Party
                Sold_to_Party__c = accObj.Id,                 // Sold to Party
                SalesOrg__c=sorg.Id,
                createdDate = System.today()
                
            );
            
            insert sobj;
        
          Sales_Order_Line_Item__c soLineItm = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj.Id,          // Sale Order
            SKU_Name__c = sku2.Id,            // SKU Name
            Item_Number__c = 10,                        // Item Number
            Item_Status__c = 'Not yet processed',       // Item Status
            Item_Cancel__c = false,                     // Item Cancel
            Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
            Sales_Org__c = sorg.Id,           // Sales Org
            //PriceBookDetail__c = PBdetails.Id,  // Price Book Detail
            Approval_Flag__c = 0,                       // Approval Flag
            //ExchangeRate__c = ExchngRte.id,        // Exchange Rate
            OrderQuantityEdited__c = false,             // Order Quantity Edited
            Time_in_months__c = 0,                      // Time in months
            Days__c = 0,                                // Days
            DateofFAT__c =  system.today()+1, 
            Quantity__c = 450.00,                       // Quantity
            UnitValue__c = 100.00,                      // Unit Value
            UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
            InterestRate__c = 0.00,                     // Interest Rate
            TotalTax__c = 0.00,                         // Total Tax
            TotalFreight__c = 0.00,                     // Total Freight
            TotalPunctuality__c = 0.00,                 // Total Punctuality
            TotalLedgerCost__c = 0.00,                  // Total Ledger Cost
            TotalReplacementCost__c = 0.00 ,
            Customer_Conversion_Factor__c = 1// Total Replacement Cost
        );
        insert soLineItm;
          
         Inventory_Control__c f2 = new Inventory_Control__c();
        f2.Quantity__c = 1000;
        f2.Fiscal_Year__c = '22/23';
        f2.Product_Name__c = pro.id;
        f2.BU__c = '5191';
        f2.Product__c = 'SPERTO';
        insert f2;
          
        insert new UPL_Settings__c(Order_Blocking_URL__c='http://example.com/example/test',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);

        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpOrderBlockingTest());
        List<string> ordl=new List<string>();
        ordl.add(sobj.SAP_Order_Number__c);
      	OrderBlocking.OrderBlockingMethod(sobj.SAP_Order_Number__c,'','20'); 
        OrderBlocking.OrderBlockingCancel(ordl);
        Test.setMock(HttpCalloutMock.class, new MockHttpOrderBlockingTests());
        //List<string> ordl=new List<string>();
        //ordl.add(sobj.SAP_Order_Number__c);
      	
        OrderBlocking.OrderBlockingCancel(ordl);
        
        test.stopTest();
    }
    
    @isTest static void testCalloutFailure() {
			Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
            sorg=[SELECT Id,sales_org_code__c from sales_org__c];
            
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
                Sales_Org__c = sorg .Id,                                              // Sales Org
                //Division__c = divisionObj.Id,                                               // Division Name
                //Distribution_Channel__c = DistributionChannelObj.Id,                                   // Distribution Channel
                Depot_Code__c = 'BR00',                                                        // Depot Code
                Payment_Terms__c = 'UK10'                                                     // Payment Terms
                
            );
            insert accObj;   
            
            
            // Create a fake response
            Sales_Order__c sobj = new Sales_Order__c(            
               
                SAP_Order_Number__c='7676767676',
                Last_Invoice_Updated__c=system.now(),
                SDM_Approval_On_Order_Cancellation__c=3,
                Last_Invoice_Update_Status__c='Success',
                Last_SuccessFull_Invoice_Update__c=system.now(),
                Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
                Bill_To_Party__c =accObj.Id,                  // Bill To Party
                Sold_to_Party__c = accObj.Id,                 // Sold to Party
                SalesOrg__c=sorg.Id,
                createdDate = System.today()
                
            );
            
            insert sobj;
        insert new UPL_Settings__c(Order_Blocking_URL__c='http://example.com/example/test',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);

        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpOrderBlockingTest());
        List<string> ordl=new List<string>();
        ordl.add(sobj.SAP_Order_Number__c);
      	OrderBlocking.OrderBlockingMethod(sobj.SAP_Order_Number__c,'','20'); 
        OrderBlocking.OrderBlockingCancel(ordl);
        Test.setMock(HttpCalloutMock.class, new MockHttpOrderBlockingTests());
       
        OrderBlocking.OrderBlockingCancel(ordl);
        
        test.stopTest();
}
    
     @isTest static void testCalloutFailure1() {
			Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
            sorg=[SELECT Id,sales_org_code__c from sales_org__c];
            
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
                Sales_Org__c = sorg .Id,                                              // Sales Org
                //Division__c = divisionObj.Id,                                               // Division Name
                //Distribution_Channel__c = DistributionChannelObj.Id,                                   // Distribution Channel
                Depot_Code__c = 'BR00',                                                        // Depot Code
                Payment_Terms__c = 'UK10'                                                     // Payment Terms
                
            );
            insert accObj;   
            
            
            // Create a fake response
            Sales_Order__c sobj = new Sales_Order__c(            
               
                SAP_Order_Number__c='7676767676',
                Last_Invoice_Updated__c=system.now(),
                SDM_Approval_On_Order_Cancellation__c=3,
                Last_Invoice_Update_Status__c='Success',
                Last_SuccessFull_Invoice_Update__c=system.now(),
                Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
                Bill_To_Party__c =accObj.Id,                  // Bill To Party
                Sold_to_Party__c = accObj.Id,                 // Sold to Party
                SalesOrg__c=sorg.Id,
                createdDate = System.today()
                
            );
            
            insert sobj;
        insert new UPL_Settings__c(Order_Blocking_URL__c='http://example.com/example/test',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);

        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpOrderBlockingTest());
        List<string> ordl=new List<string>();
        ordl.add(sobj.SAP_Order_Number__c);
      	OrderBlocking.OrderBlockingMethod(sobj.SAP_Order_Number__c,'','20'); 
        OrderBlocking.OrderBlockingCancel(ordl);
        Test.setMock(HttpCalloutMock.class, new MockHttpOrderBlockingTests1());
       
        OrderBlocking.OrderBlockingCancel(ordl);
        
        test.stopTest();
}
         @isTest static void testCalloutFailure11() {
			Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
            sorg=[SELECT Id,sales_org_code__c from sales_org__c];
            
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
                Sales_Org__c = sorg .Id,                                              // Sales Org
                //Division__c = divisionObj.Id,                                               // Division Name
                //Distribution_Channel__c = DistributionChannelObj.Id,                                   // Distribution Channel
                Depot_Code__c = 'BR00',                                                        // Depot Code
                Payment_Terms__c = 'UK10'                                                     // Payment Terms
                
            );
            insert accObj;   
            
            
            // Create a fake response
            Sales_Order__c sobj = new Sales_Order__c(            
               
                SAP_Order_Number__c='7676767676',
                Last_Invoice_Updated__c=system.now(),
                SDM_Approval_On_Order_Cancellation__c=3,
                Last_Invoice_Update_Status__c='Success',
                Last_SuccessFull_Invoice_Update__c=system.now(),
                Sent_for_Manager_Approval_Mexico__c = true,            // Sent for Manager Approval
                Bill_To_Party__c =accObj.Id,                  // Bill To Party
                Sold_to_Party__c = accObj.Id,                 // Sold to Party
                SalesOrg__c=sorg.Id,
                createdDate = System.today()
                
            );
            
            insert sobj;
        insert new UPL_Settings__c(Order_Blocking_URL__c='http://example.com/example/test',Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);

        test.startTest();
              Test.setMock(HttpCalloutMock.class, new MockHttpOrderBlockingTests());
      //  Test.setMock(HttpCalloutMock.class, new MockHttpOrderBlockingTest());
        List<string> ordl=new List<string>();
        ordl.add(sobj.SAP_Order_Number__c);
      	OrderBlocking.OrderBlockingMethod(sobj.SAP_Order_Number__c,'','58'); 
        //OrderBlocking.OrderBlockingCancel(ordl);
       
       OrderBlocking.cancelReason();
       // OrderBlocking.OrderBlockingCancel(ordl);
        
        test.stopTest();
}
    
}