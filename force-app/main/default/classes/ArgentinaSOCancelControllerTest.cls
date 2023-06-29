@isTest 
public Class ArgentinaSOCancelControllerTest{
    static testMethod void controllerMethodTest(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
     
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Depot__c dp =new Depot__c ();
        dp.Name='Charata';
        dp.Country__c='Argentina';
        dp.Location__c='Charata';
        dp.Depot_Code__c='PUN1';
        insert dp;
        
        //Data for Sales Org
         Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Argentina',        // Sales Org Name
            Sales_Org_Code__c = '5631'  // Sales Org Code
        );
        insert salesOrgObj;
        
       Order_Type__c  orderTypeObj = new Order_Type__c(
            Name = 'ZXKB',                  // Order Type Name
            Description__c = 'Consignatario',     // Description
            Order_Type_Code__c = 'ZXKB',      // Order Type Code
            SalesOrg__c = salesOrgObj.Id  // Sales Org
        );
        insert orderTypeObj;
        
        
        
         //Data for Distribution Channel 
        Distribution_Channel__c distributionChannelObj = new Distribution_Channel__c(
            Name = 'Direct',                    // Distribution Channel Name
            Distribution_Channel_Code__c = '10'  // Distribution Channel Code
        );
        insert distributionChannelObj;
         
        
         //Data for Division
        Division__c divisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert divisionObj;
        
         //Bill to party /sold to party is Account Object 
        Account accObj = new Account(
            Name='Bhavik Devdhar',
            SAP_Code__c = '0001013292', 
            PriceGroupCode__c=pg.id,
            RecordTypeId=devRecordTypeId,              // SAP Customer Code
            Last_Name__c = 'ADECO AGROPECUARIA S.A.',     // Last Name
            Order_Block__c = false,                       // Order Block
            Mobile__c = '9405883688',  
            Phone='020256589', // Mobile
            Email__c = 'marcelo.gorla@uniphos.com',       // Email
            Account_Type__c = 'Sold To Party',            // Account Type
            Raise_Order_Type__c = 'Factura',                 // Raise Order Type
            Billing_Street_2__c = 'CATAMARCA 3454',       // Billing Street 2
            Sales_Org__c = salesOrgObj.id,             // Sales Org
            Division__c = divisionObj.Id,              // Division Name
            Distribution_Channel__c = distributionChannelObj.Id,  // Distribution Channel
            Depot_Code__c = 'AR13'                       // Depot Code
        );
        insert accObj;
        
       
        
         Product2 productObj = new Product2(
            Name = 'BISECT',                     // Product Name
            ProductCode = '71501',                 // Product Code
            Product_Code__c = '71501',             // Product Code
            IsActive = false,                      // Active
            Active__c = false,                     // Active
            Sales_Org__c = salesOrgObj.id,      // Sales Org
            Combination_Key__c = '7150156311010',  // Combination Key
            Popular__c = false,                    // Popular
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = false     // Active For Liquidation
        );
        insert productObj;
        
         SKU__c sku = new SKU__c(
            Name = '6 LTS',                                   // SKU Name
            SKU_Code__c = '000000000006010097',                 // SKU Code
            Product_Name__c = productObj.id,                // Product Name
            UOM__c = 'L',                                       // UOM
            Distribution_Channel__c = distributionChannelObj.Id,        // Distribution Channel
            Pack_Size__c = 0.00,                                // Pack Size
            Division__c = divisionObj.Id,                    // Division
            Sales_Org__c = salesOrgObj.Id,                   // Sales Org
            Multiple_of__c = 20.00,                             // Multiple Of
            Combination_Key__c = '56311010000000000006010097',  // Combination Key
            Active__c = true,                                   // Active
            Brand_Name__c = 'BISECT 6LTS'                      // Brand Name
        );
        insert sku;
        
        
        
        
        
       
        
        PriceBookMaster__c PbMaster = new PriceBookMaster__c();
        PbMaster.SKUCode__c = sku.id;           
        PbMaster.DepotCode__c =dp.id;         
        PbMaster.Price__c = 34500;    
        PbMaster.MinPrice__c = 3000;
        PbMaster.PG_CODE__c =Pg.Id;  
        PbMaster.UOM__c = 'NOS';                          
        PbMaster.StartDate__c = system.today();
        PbMaster.EndDate__c = system.today()+1;
        PbMaster.Active__c = true;                      
        PbMaster.PerUnit__c = 1;                       
        PbMaster.Batch__c ='test'; 
        PbMaster.CompositeKey__c='c1';
        insert PbMaster; 
        
        
        
       
        
        contact con = new Contact();
        con.AccountId=accObj.Id;
        con.MobilePhone = '123456789';
        con.LastName=accObj.Last_Name__c;
        con.Phone = '123456789';
        insert con;
        
        userrole  usrole = new userrole();
        usrole.Name ='Bhavik Devdhar Customer User';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Sales Head Argentina'];
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'himanshua.mehta@skinternational.com';                             
        sobj1.ProfileId  = p.ID;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='Terriotory Manager';
        sobj1.CommunityNickname = 'zonalExe1222 Di'; 
        sobj1.TimeZoneSidKey = 'Asia/Kolkata'; 
        // sobj1.Contact.AccountID = acc.id;// Time Zone
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId=usrole.id;
        //sobj1.ContactId=con.Id;
        insert sobj1;
        
        TM_Depot_Mapping__c TMDepoMap = new TM_Depot_Mapping__c();
        TMDepoMap.Depot__c = dp.Id;        // Depot
        TMDepoMap.Territory_Manager__c = sobj1.id;  // Territory Manager
        insert TMDepoMap;
        
        Inventory__c invObj = new Inventory__c( );
        invObj.Stock_Quantity__c = 10;   
        invObj.Batch_Number__c = 'CMUMTX2506'; 
        invObj.Depot__c = dp.Id;    
        invObj.UOM__c = 'L';                    
        invObj.Storage_Location__c = 'MAIN';  
        invObj.SKU__c = sku.Id;  
        invObj.SKU_Depot__c ='sd1';           
        insert invObj;
        
        Distributor_Depot_Mapping__c dsMap =new Distributor_Depot_Mapping__c();
        dsMap.Distributor__c = accObj.id;
        dsMap.Depot__c=dp.Id;
        insert dsMap;
        
       
        
        SKU_Pack_Size__c spObj = new SKU_Pack_Size__c();
        spObj.Depot__c = dp.Id;
        spObj.UOM__c = 'L';
        spObj.SKU__c = sku.Id;
        spObj.Pack_Size__c = '5';
        insert spObj;
        
        Credit_Info__c crdIf = new Credit_Info__c();
        crdIf.Credit_Limit__c=1000;
        crdIf.Percentage_Used__c=100.0;
        crdIf.Allocated_Limit__c=0.0;
        crdIf.Distributor__c=accObj.Id;
        crdIf.Distributor_Code__c='0001001225';
        crdIf.Sales_Org__c = salesOrgObj.id;
        insert crdIf;
        
        //Data for Shipping Location
        Shipping_Location__c shippingLocationObj = new Shipping_Location__c(
            Location_Name__c = 'ADECO AGROPECUARIA S.A.',// Location Name
            Distributor__c = accObj.Id,            // Distributor
            SAP_Code__c = '00010132925631',                // SAP Code
            City__c = 'MARTINEZ -PCIA. BUENOS AI',         // City
            State__c = '01',                               // State
            Country__c = 'AR',                             // Country
            Pincode__c = '1640',                           // Pincode
            Sold_To_Party_SAP_Code__c = '0001013292',      // Sold To Party (SAP Code)
            Sales_Org__c = salesOrgObj.Id,              // Sales Org
            
            Distribution_Channel__c = distributionChannelObj.Id,   // Distribution Channel
            Division__c = divisionObj.id               // Division
        );
        insert shippingLocationObj;
        
       
        
        Order__c ord = new Order__c();
        ord.Shipping_Location__c = shippingLocationObj.id;  
        ord.Bill_To_Party__c = accObj.Id;        
        ord.Order_Date__c = system.today();  
        ord.Order_Raise_By__c = 'Distributor';                                     
        ord.Order_Status__c = 'Pending';                                        
        ord.Sales_Org__c =salesOrgObj.Id;          
        ord.Distribution_Channel__c =distributionChannelObj.Id; 
        ord.Division__c = divisionObj.Id;
        insert ord;
        
       
    
       
        
        //Data for Order Object 
        Order__c orderObj = new Order__c(
            Order_Date__c = system.today(),     // Order Date
            Order_Raise_By__c = 'Territory Manager',      // Order Raise By
            Order_Status__c = 'Approved',                 // Order Status
            Sales_Org__c = salesOrgObj.id,             // Sales Org
            Division__c = divisionObj.id,              // Division
            Distribution_Channel__c = distributionChannelObj.id,  // Distribution Channel
            Bill_To_Party__c = accObj.Id,         // Bill To Party
            Shipping_Location__c = shippingLocationObj.id     // Shipping Location
        );
        insert orderObj;
        
       
        
        
        
        //Data for Payment Method for Contado
        Payment_Method__c paymentMethodObj = new Payment_Method__c(
            Name = 'Contado',                   // Payment Method Name
            Sales_Org__c = salesOrgObj.Id,  // Sales Org
            Payment_Method_Code__c = 'C1',     // Payment Method Code
            Active__c = true                  // Active
        );
        insert paymentMethodObj;
        
        //for credit card
         Payment_Method__c paymentMethodCreditObj = new Payment_Method__c(
            Name = 'Credit Card',                   // Payment Method Name
            Sales_Org__c = salesOrgObj.Id,  // Sales Org
            Payment_Method_Code__c = 'CD1',     // Payment Method Code
            Active__c = true                  // Active
        );
        insert paymentMethodCreditObj;
        
        //for Long Barter
        
    Payment_Method__c paymentMethodLongBarterObj = new Payment_Method__c(
            Name = 'Long Barter',                   // Payment Method Name
            Sales_Org__c = salesOrgObj.Id,  // Sales Org
            Payment_Method_Code__c = 'LB1',     // Payment Method Code
            Active__c = true                  // Active
        );
        insert paymentMethodLongBarterObj;
        
        
        // for Available Barter
       Payment_Method__c paymentMethodAvailableBarterObj = new Payment_Method__c(
            Name = 'Available Barter',                   // Payment Method Name
            Sales_Org__c = salesOrgObj.Id,  // Sales Org
            Payment_Method_Code__c = 'AB1',     // Payment Method Code
            Active__c = true                  // Active
        );
        insert paymentMethodAvailableBarterObj;
        
        //for Wire transfer
        Payment_Method__c paymentMethodWireTransferObj = new Payment_Method__c(
            Name = 'Wire transfer',                   // Payment Method Name
            Sales_Org__c = salesOrgObj.Id,  // Sales Org
            Payment_Method_Code__c = 'WT1',     // Payment Method Code
            Active__c = true                  // Active
        );
        insert paymentMethodWireTransferObj;
        
        
        //for Check
         Payment_Method__c paymentMethodCheckObj = new Payment_Method__c(
            Name = 'Check',                   // Payment Method Name
            Sales_Org__c = salesOrgObj.Id,  // Sales Org
            Payment_Method_Code__c = 'CH1',     // Payment Method Code
            Active__c = true                  // Active
        );
        insert paymentMethodCheckObj;
        
        //data for Payment Term for 30 days
        Payment_Term__c paymentTermObj = new Payment_Term__c(
            Payment_Term_Code__c = '0015',                     // Payment Term Code
            Payment_Term__c = '30 dias',                         // Payment Term
            Payterms_Desc__c = 'Pagamento estrito em 30 dias.',  // Payterms Desc
            Maturity_Date_Mandatory__c = 'Yes',                  // Maturity Date Mandatory
            Sales_Org__c = salesOrgObj.Id,                    // Sales Org
            Active__c = false                                   // Active
        );
        insert paymentTermObj;
        
        //data for Payment Term for 120 days
        Payment_Term__c paymentTermFor120DaysObj = new Payment_Term__c(
            Payment_Term_Code__c = '0017',    // Payment Term Code
            Payment_Term__c = '120 dias',       // Payment Term
            Maturity_Date_Mandatory__c = 'No',  // Maturity Date Mandatory
            Days_to_calc_interest__c = 120,     // Days (to calc interest)
            Sales_Org__c = salesOrgObj.Id,    // Sales Org
            Active__c = false                  // Active
        );
        insert paymentTermFor120DaysObj;
        
        //data for payment term for 150 days
        Payment_Term__c paymentTerm150DayObj = new Payment_Term__c(
            Payment_Term_Code__c = '0018',    // Payment Term Code
            Payment_Term__c = '150 dias',       // Payment Term
            Maturity_Date_Mandatory__c = 'No',  // Maturity Date Mandatory
            Days_to_calc_interest__c = 150,     // Days (to calc interest)
            Sales_Org__c = salesOrgObj.Id,   // Sales Org
            Active__c = false                  // Active
        );
        insert paymentTerm150DayObj;
       
        //data for payment term for 60 days
        Payment_Term__c paymentTerm60DayObj = new Payment_Term__c(
            Payment_Term_Code__c = '0016',    // Payment Term Code
            Payment_Term__c = '60 dias',        // Payment Term
            Maturity_Date_Mandatory__c = 'No',  // Maturity Date Mandatory
            Days_to_calc_interest__c = 60,      // Days (to calc interest)
            Sales_Org__c =salesOrgObj.Id ,   // Sales Org
            Active__c = false                  // Active
        );
        insert paymentTerm60DayObj;
        
        
        //data for payment term for 90 days
        Payment_Term__c paymentTerm90DayObj = new Payment_Term__c(
            Payment_Term_Code__c = '0014',     // Payment Term Code
            Payment_Term__c = '90 dias',         // Payment Term
            Maturity_Date_Mandatory__c = 'Yes',  // Maturity Date Mandatory
            Days_to_calc_interest__c = 0,        // Days (to calc interest)
            Sales_Org__c =salesOrgObj.Id ,    // Sales Org
            Active__c = false                   // Active
        );
        insert paymentTerm90DayObj;
       
        
        
    //Data for Sales Order Object
        
        Sales_Order__c salesOrderobj = new Sales_Order__c(
            SFDC_Order_Number__c = '13875',               // SFDC Order Number
            Order_Raise_By__c = 'Territory Manager',        // Order Raised By
            Order_Status__c = 'Pending',                       // Order Status
            Order_Cancel__c = false,                        // Order Cancel
            Order_Date__c = system.today(),       // Order Date
            Order__c = orderObj.id,                   // Order
            ProcessBuilderFlag__c = false,                  // Process Builder Flag
            Manager__c = sobj1.id,                 // Manager
            PaymentMethod__c = paymentMethodObj.Id,           // Payment Method
            Payment_Term__c = paymentTermObj.id,            // Payment Term
            Customer_Approval__c = false,                   // Customer Approval
            Order_Type_lk__c = orderTypeObj.Id,           // Order Type
            Customer_Approval_Status__c = 'Approved',       // Customer Approval Status
            ArgentinaOrderSubmittedforApproval__c = false,  // Argentina Order Submitted for Approval
            InternalApprovalCheck__c = false,               // Internal Approval Check
            BudgetApprovalCheck__c = true,                  // Budget Approval Check
            Total_Amount__c = 2400.00,                      // Total Amount
            Sold_to_Party__c = accObj.Id,           // Sold to Party
            Bill_To_Party__c = accObj.Id,           // Bill To Party
            Ship_To_Party__c = shippingLocationObj.Id,           // Ship To Party
            CreatedFrom__c = 'SFDC',      
            Sales_Org_lk__c = salesOrgObj.Id     // Created From
        );
        insert salesOrderobj;
        
         Sales_Order_Line_Item__c salesOrderLineItemObj1 = new Sales_Order_Line_Item__c(
            UOM__c = 'L',                            // UOM
            Sale_Order__c = salesOrderobj.id,         // Sale Order
            SKU_Name__c = sku.Id,           // SKU Name
            DepotDepot__c = dp.Id,         // Depot
            Item_Number__c = 20,                       // Item Number
            Item_Status__c = 'Active',                 // Item Status
            Item_Cancel__c = false,                    // Item Cancel
            Order_Item_Key__c = '1389610',             // OrderNumber_Item_Key
            BudgetPrice__c = 5.70,                     // Budget Price
            MinPrice__c = 5.85,                        // Min Price
            MaxPrice__c = 7.20,                        // Max Price
            Net_Price__c = 5.60,                       // Net Price
            OrderQuantityEdited__c = false,            // Order Quantity Edited
            multipleOf__c = 20,                        // multipleOf
            Quantity__c = 200.00,                      // Quantity
            Price__c = 1120.00,                        // Value
            DistributorDiscountPercentage__c = 22.22  // Distributor Discount (%)
        );
        insert salesOrderLineItemObj1;
        
        //Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        //app.setObjectId(salesOrderobj.id);
        //Approval.ProcessResult result = Approval.process(app);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(salesOrderobj);
        ArgentinaSOCancelController argentinaSOCancelController =new ArgentinaSOCancelController (sc);
        argentinaSOCancelController.soId = salesOrderobj.id;
        argentinaSOCancelController.controllerMethod();
    }

}