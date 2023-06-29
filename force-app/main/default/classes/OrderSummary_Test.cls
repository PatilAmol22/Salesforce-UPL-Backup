@isTest
public class OrderSummary_Test {
    static testMethod void test(){
        
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Japan',           // Sales Org Name
            Company_Code__c = '6731',      // Company Code
            Sales_Org_Code__c = '6731'   // Sales Org Code
            
        );
        insert salesOrgObj;
        
        Division__c DivisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert DivisionObj;
        
        Distribution_Channel__c DistributionChannelObj = new Distribution_Channel__c(
            Name = '20',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '20',  // Distribution Channel Code
            Description__c='test'
        );
        insert DistributionChannelObj;
        
        Payment_Term__c paymentTermObj = new Payment_Term__c(
            Payment_Term__c = 'Net 7 days',   // Payment Term
            Payment_Term_Code__c = 'UK01',      // Payment Term Code
            Payterms_Desc__c = 'Net 7 days',    // Payterms Desc
            Sales_Org__c = salesOrgObj.Id,   // Sales Org
            Days_to_calc_interest__c = 0,     // Days (to calc interest)
            Active__c = true,                   // Active
            CombinationKey__c = '5710UK01'     // CombinationKey
        );
        insert paymentTermObj;
        
        Id recordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id devRecordAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account accObj1 = new Account(
            Name = 'SAR123',                                                            // Account Name
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'SAR123',                                         // Last Name
            SAP_Code__c = '0001023234',                                        // SAP Customer Code
            Mobile__c = '0876543219',                                          // Mobile           
            Account_Type__c = 'Sold To Party',                                 // Account Type                        
            Sales_Org__c = salesOrgObj.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentTermObj.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07'                                         // Payment Terms                    
        );
        insert accObj1;
        
        Account accObj2 = new Account(
            Name = 'SAR1234',                                                            // Account Name
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'SAR1234',                                         // Last Name
            SAP_Code__c = '0001023235',                                        // SAP Customer Code
            Mobile__c = '0876543267',                                          // Mobile           
            Account_Type__c = 'Sold To Party',                                 // Account Type                        
            Sales_Org__c = salesOrgObj.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentTermObj.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07'                                         // Payment Terms                    
        );
        insert accObj2;
        String SOLIquery='SELECT Id,SKU_Code__c,SKU_Description__c,UOM__c,Price__c,Quantity__c,CurrencyIsoCode,Net_Price__c,SKU_Name__r.Product_Name__r.Name,Sale_Order__r.Id,Sale_Order__r.Name,Sale_Order__r.SAP_Order_Number__c,Sale_Order__r.Order_Date__c,Sale_Order__r.PONumber__c,Sale_Order__r.CurrencyIsoCode,Sale_Order__r.Total_Amount__c,Sale_Order__r.Net_Amount__c,Sale_Order__r.Order_Status__c,Special_Discount__c,Invoice_Reflection_Code__c FROM Sales_Order_Line_Item__c ';
        String query='SELECT Id,SKU_Name__r.Product_Name__r.Name,SKU_Name__r.Product_Name__c,SKU_Name__r.SKU_Description__c FROM Sales_Order_Line_Item__c where Sale_Order__r.Sold_To_Party__c='+'\''+accObj1.Id+'\'';
        
        Id devRecordTypeId = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Sales Order').getRecordTypeId();
        
        
        Contact c=new Contact();
        c.FirstName='test';
        c.LastName='test';
        c.AccountId=accObj1.Id;        
        insert c;
        
        Contact c1=new Contact();
        c1.FirstName='test';
        c1.LastName='test';
        c1.AccountId=accObj1.Id;        
        insert c1;
         
        Profile prof = [select id from profile where name = 'Customer Community Plus User - Colombia'];    
        User u = new User(Alias = 'standt', Email='paresh@gmail.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = prof.Id, ContactId= c.Id, Country='Colombia',
        TimeZoneSidKey='America/Los_Angeles', UserName='paresh346@gmail.com');
        insert u;
        
        Profile prof1 = [select id from profile where name = 'Customer Community Plus User'];    
        User u1 = new User(Alias = 'standt1', Email='paresh123@gmail.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = prof1.Id, ContactId= c1.Id, Country='Japan',
        TimeZoneSidKey='America/Los_Angeles', UserName='paresh123@gmail.com');
        insert u1;
        
        Id recordTypeId2 = Schema.SObjectType.Community_Configuration__c.getRecordTypeInfosByName().get('Order Summary').getRecordTypeId(); 
        Community_Configuration__c config=new Community_Configuration__c();
        config.Sales_Org__c='5710';
        config.Sales_Order_Line_Item_SOQL__c='SELECT Id, Name, Sales_Order_Line_Item_SOQL__c, SO_Header_Column__c, SOLI_Column__c, Sales_Org__c FROM Community_Configuration__c';
        config.SO_Header_Column__c='sales order columns';
        config.SOLI_Column__c='sales order line item columns';
        config.RecordTypeId = recordTypeId2;
        config.Country__c='Colombia';
        insert config;
        
        Community_Configuration__c config1=new Community_Configuration__c();
        config1.Sales_Org__c='6731';
        config1.Sales_Order_Line_Item_SOQL__c='SELECT Id, Name, Sales_Order_Line_Item_SOQL__c, SO_Header_Column__c, SOLI_Column__c, Sales_Org__c FROM Community_Configuration__c';
        config1.SO_Header_Column__c='sales order columns';
        config1.SOLI_Column__c='sales order line item columns';
        config1.RecordTypeId = recordTypeId2;
        config1.Country__c='Japan';
        insert config1;
        
        
        Shipping_Location__c shippingLocationObj = new Shipping_Location__c(
            Location_Name__c = 'BAM S.A.',                           // Location Name
            SAP_Code__c = '0001023194',                                // SAP Code
            Distributor__c = accObj1.Id,                        // Distributor
            City__c = 'BOGOTA DC',                                     // City
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',  // Billing Street 1
            State__c = '11',                                           // State
            Country__c = 'CO',                                         // Country
            Billing_Street_3__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',  // Billing Street 3
            Pincode__c = '11001',                                      // Pincode
            Sold_To_Party_SAP_Code__c = '0001023194',                  // Sold To Party (SAP Code)
            Combination_Key__c = '00010231940001023194',               // Combination Key
            Country_Name__c = 'Italy',                   // Country Name
            Sales_Org__c = salesOrgObj.Id,                          // Sales Org
            Distribution_Channel__c = DistributionChannelObj.Id,               // Distribution Channel
            Division__c = divisionObj.Id                           // Division
            
        );
        
        //insert shippingLocationObj;
        //
        Order_Type__c type= new Order_Type__c();
        type.Combination_Key__c='1234567890';
        type.Name='ZJWH';
        type.Order_Type_Code__c='ZJWH';
        type.SalesOrg__c=salesOrgObj.Id;
        insert type;
        
        Sales_Order__c SalesOrderObj = new Sales_Order__c(
            RecordTypeId = devRecordTypeId,                        // Record Type
            SFDC_Order_Number__c = '87614',                      // SFDC Order Number
            // Order_Raise_By__c = 'Territory Manager',             // Order Raised By
            Desc_Punctuality__c = false,                         // Desc Punctuality
            Order_Date__c = System.today(),            // Order Date
            //OrderSubStatus__c = 'Draft',                         // Order Sub-Status
            Punctuality_Discount__c = 0.00,                      // Punctuality Discount
            Flag_Status__c = '\n',                               // Flag Status
            isOffline_Mobile_Order__c = false,                   // isOffline Mobile Order
            BrazilOrderSubmittedforApproval__c = false,
            Call_Process_Builder_Flow__c = false,                // Call Process Builder Flow
            ProcessBuilderFlag__c = false,                       // Process Builder Flag
            Customer_Approval__c = false,                        // Customer Approval
            Sales_Org_lk__c = salesOrgObj.Id,                 // Sales Org
            RequestforCancellationCheck__c = false,              // Request for Cancellation
            TM_Code__c = '00051120',                             // TM Code
            ApprovedBySDM__c = false,     
            Order_Status__c ='Pending',
            ApprovedBySOM__c = false,                            // Approved By SOM
            ApprovedByBM__c = false,                             // Approved By BM
            ApprovedBySOMifSDMisNull__c = false,                 // Approved By SOM if SDM is Null
            Approved_By_SD__c = false,                           // Approved By SD
            Division_lk__c = DivisionObj.Id,                  // Division
            Distribution_Channel_lk__c = DistributionChannelObj.Id,      // Distribution Channel
            Sent_for_Manager_Approval_Mexico__c = true,          // Sent for Manager Approval
            Sent_for_Director_Approval_Mexico__c = false,        // Sent for Director Approval
            Bill_To_Party__c = accObj1.Id,                // Bill To Party
            Depot_Code__c = 'IT00',                              // Depot Code
            Sold_to_Party__c = accObj1.Id,                // Sold to Party
            Total_Amount__c=12000,        
            UGDN__c = '20011688',
            Order_Type_lk__c=type.Id,
            SAP_Order_Number__c='788989'
        );
        insert SalesOrderObj;
        
        Id recordId = SalesOrderObj.Id;
        
        Product2 productObj = new Product2(
            Name = 'ALPHA CYPER 10% EC',         // Product Name
            Product_Code__c = '65100',             // Product Code
            Active__c = false,                     // Active
            Sales_Org__c = salesOrgObj.Id,      // Sales Org
            Combination_Key__c = '6510057106710',  // Combination Key
            Popular__c = false,                    // Popular
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = false,     // Active For Liquidation
            //  Multiple_Of__c = 0.0,                // Multiple Of
            Budget_NRV__c = 0.00                // Budget NRV
        );
        insert productObj;
        
        SKU__c skuObj = new SKU__c(
            Name = 'a1C0k000000NAz5',                         // SKU Name
            SKU_Code__c = '000000000006180633',                 // SKU Code
            Product_Name__c = productObj.Id,                // Product Nam
            SKU_Description__c = 'FURYY 40 EC X 250 cc',        // SKU Description
            UOM__c = 'L',                                       // UOM
            Distribution_Channel__c = DistributionChannelObj.Id,        // Distribution Channel
            Pack_Size__c = 0.00,                              // Pack Size
            Division__c = divisionObj.Id,   
            Unit_Cost__c = 200,
            Area_Manager_MSP__c =150,
            Sales_Agent_MSP__c =500,
            Sales_Director_MSP__c =50,
            Sales_Org__c = salesOrgObj.Id,                   // Sales Org
            Combination_Key__c = '57106710000000000006180633',  // Combination Key
            Material_type__c = 'FERT',                          // Material type
            Active__c = true,                                   // Active
            Brand_Name__c = 'FURRY1',                          // Brand Name
            Inventory_Description_Italy__c='Stock available'
        );
        insert skuObj;
        
        Sales_Order_Line_Item__c saleOrderLineObj = new Sales_Order_Line_Item__c(
            Sale_Order__c = SalesOrderObj.Id,      // Sales Order
            SKU_Name__c = skuObj.Id,                // SKU Name
            Item_Number__c = 10,                  // Item Number
            UOM__c = 'L',      
            Net_Price__c = 10.00,                   // Net Price
            MinPrice__c = 10.00,                    // Min Price
            MaxPrice__c = 15.00,                    // Max Price
            Quantity__c = 9.00,                   // Quantity
            FinalPrice__c = 10.00,                  // Final Price
            Price__c = 90.00,                       // Value
            Inventory_order_Flag_Color_Italy__c='',
            Inventory_Description_Italy__c='Stock available',
            Special_Discount__c=0
        );
        insert saleOrderLineObj;
                        
        Community_Url_Configuration__c url = new Community_Url_Configuration__c();
        url.Name='Distributors Community URL';
        url.URL__c='https://uat-upl.cs117.force.com/Distributor';
        insert url;
        
        Credit_Info__c cinfo = new Credit_Info__c();
        cinfo.Distributor__c=accObj1.Id;
        insert cinfo;
        
        Outstanding_Ageing__c out = new Outstanding_Ageing__c();
        out.Customer_Code__c=accObj1.Id;
        insert out;
                       
        
        System.runAs(u1){           
            PageReference pageRef2 = Page.OrderSummaryExcel;
            Test.setCurrentPage(pageRef2);
            pageRef2.getParameters().put('DateFrom', '2019-06-15');
            pageRef2.getParameters().put('DateTo', '2019-06-15');
            pageRef2.getParameters().put('AccId', accObj1.Id);
            pageRef2.getParameters().put('Status', 'Rejected');
            pageRef2.getParameters().put('Country', 'japan');
            OrderSummary o2 = new OrderSummary();
            OrderSummary.fetchUser();
            OrderSummary.getCommunityConfiguration();
            OrderSummary.fetchSalesOrder(SOLIquery, recordId);
            OrderSummary.fetchLineItem(SOLIquery, recordId);
            OrderSummary.searchOrder(SOLIquery);
            OrderSummary.searchProduct(recordId);
            OrderSummary.getCummunityURL();
            OrderSummary.fetchAccountSummary(recordId);            
            OrderSummary.WrapOS o3=new OrderSummary.WrapOS();
            OrderSummary.WrapAS o4=new OrderSummary.WrapAS();  
        } 
        
        System.runAs(u){
            
            PageReference pageRef2 = Page.OrderSummaryExcel;
            Test.setCurrentPage(pageRef2);
            pageRef2.getParameters().put('DateFrom', '2019-06-15');
            pageRef2.getParameters().put('DateTo', '2019-06-15');
            pageRef2.getParameters().put('AccId', accObj1.Id);
            pageRef2.getParameters().put('Status', 'Rejected');
            OrderSummary o2 = new OrderSummary();
            OrderSummary.fetchUser();
            OrderSummary.getCommunityConfiguration();
            OrderSummary.fetchSalesOrder(SOLIquery, recordId);
            OrderSummary.fetchLineItem(SOLIquery, recordId);
            OrderSummary.searchOrder(SOLIquery);
            OrderSummary.searchProduct(recordId);
            OrderSummary.getCummunityURL();
            OrderSummary.fetchAccountSummary(recordId);
            OrderSummary.WrapOS o3=new OrderSummary.WrapOS();
            OrderSummary.WrapAS o4=new OrderSummary.WrapAS();     
                          
        } 
        

    }
}