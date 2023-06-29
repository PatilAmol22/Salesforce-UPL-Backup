@isTest
public class OrderItalyController_Test {
    @testSetup
    static void allTheDataForThisTestClass() {
        
        Id devRecordTypeId = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Sales Order').getRecordTypeId();
        Id devRecordAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id devRecordDepot = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();
       
        userrole  usrole = new userrole();
        usrole.Name ='Sales Agent Italy New';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Sales Agents Italy'];

        User usr = new User();
        usr.Alias = 'zonaa';                                                            
        usr.Email = 'skim@skinternational123.com';                             
        usr.ProfileId  = p.ID;                                                     
        usr.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        usr.IsActive = true;  
        usr.LastName='Terriotory Manager';
        usr.CommunityNickname = 'zonalExe1222 Di'; 
        usr.TimeZoneSidKey = 'Asia/Kolkata'; 
        usr.LocaleSidKey = 'en_IN';                                    
        usr.LanguageLocaleKey = 'en_US';                                             
        usr.ForecastEnabled = false;                                                     
        usr.EmailEncodingKey = 'ISO-8859-1';    
        usr.Show_Inventory__c = false;                                                     
        usr.Show_Credit_Limit__c = false; 
        usr.UserRoleId=usrole.id;
        usr.Marketing_Manager__c=UserInfo.getUserId();
       // usr.ContactId=con.Id;
        insert usr; 
        
        //Data for Sales Org
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Italy',           // Sales Org Name
            Company_Code__c = '2400',      // Company Code
            Sales_Org_Code__c = '2410',    // Sales Org Code
            Country_Code__c = 'IT'        // Country Codes
        );
        insert salesOrgObj;
        
        //Data for Division
        Division__c DivisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert DivisionObj;
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZZCQ';              
        ordType.Order_Type_Code__c = 'ZZCQ';
        ordType.SalesOrg__c = salesOrgObj.Id;
        insert ordType;
        
        //Data for Distribution Channel
        Distribution_Channel__c DistributionChannelObj = new Distribution_Channel__c(
            Name = '20',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '20',  // Distribution Channel Code
            Description__c='test'
        );
        insert DistributionChannelObj;
        
       
        
        //Data for Payment Term
        
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
        
        //Data for Price Group
        Price_Group_Master__c priceGroupMasterObj = new Price_Group_Master__c(
            PG_Code__c = '95',                // PG Code
            Description_Colombia__c = 'Casagro'  // Description
        );
        insert priceGroupMasterObj;
        
        Payment_Term_PG_Group_Mapping__c paymentPgMapObj = new Payment_Term_PG_Group_Mapping__c(
            Name = '0001',   // Payment Term
            Payment_Term_Italy__c = paymentTermObj.Id,      // Payment Term Code
            Price_Group_Master_Italy__c =priceGroupMasterObj.Id    // Payterms Desc
        );
        insert paymentPgMapObj;
        
        
        //Data for account 1
        Account accObj1 = new Account(
            Name = 'BAM',                                                           // Account Name
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'SAR123',                                         // Last Name
            SAP_Code__c = '0001023234',                                        // SAP Customer Code
            Mobile__c = '0876543219',                                          // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589793',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = salesOrgObj.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentTermObj.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07',                                         // Payment Terms
            PriceGroupCode__c =priceGroupMasterObj.Id,                          // Tax classification for customer
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c=''
        );
        insert accObj1;
        
        
        //Data for Account 2
        Account accObj = new Account(
            Name = 'BAM S.A.',                              // Account Name
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'BAM S.A.',                                         // Last Name
            SAP_Code__c = '0001023194',                                        // SAP Customer Code
            Mobile__c = '1234567980',                                          // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589795',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = salesOrgObj.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentTermObj.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07',                                         // Payment Terms
            PriceGroupCode__c =priceGroupMasterObj.Id,                          // Tax classification for customer
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c=''
        );
        insert accObj;
        
          Credit_Info__c crdIf = new Credit_Info__c();
        crdIf.Credit_Limit__c=1000;
        crdIf.Percentage_Used__c=100.0;
        crdIf.Allocated_Limit__c=0.0;
        crdIf.Distributor__c=accObj.Id;
        crdIf.Distributor_Code__c='0001001225';
        crdIf.Sales_Org__c=salesOrgObj.Id;
        insert crdIf;
        
        Shipping_Location__c shippingLocationObj = new Shipping_Location__c(
            Location_Name__c = 'BAM S.A.',                           // Location Name
            SAP_Code__c = '0001023194',                                // SAP Code
            Distributor__c = accObj.Id,                        // Distributor
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
        insert shippingLocationObj;
        
      
        
        //Data For Product
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
        
        
        
        
        //Data for SKU
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
        
        //Data for Depot  
        Depot__c depotObj = new Depot__c(
            Name = 'IT00',                             // Depot Name
            Location__c = 'IT00',                        // Location
            SalesOrg__c = salesOrgObj.Id,             // Sales Org
            Depot_Code__c = 'IT00',                      // Depot Code
            RecordTypeId = devRecordDepot,                  // Record Type
            Active__c = false                           // Active
        );
        insert depotObj;
        
         PricebookDiscount__c PbDis = new PricebookDiscount__c();
        PbDis.Batch__c = 'test';                                               
        PbDis.DepotCode__c = depotObj.Id;                                  
        PbDis.EndDate__c = System.today()+1;                         
        PbDis.PerUnit__c = 1.00;                                                 
        PbDis.PG_Code__c =null;// priceGroupMasterObj.Id;                                   
        PbDis.SKUCode__c = skuObj.Id;                             
        PbDis.StartDate__c = system.today();                         
        PbDis.Active__c = false;
        PbDis.DistributorCustomerCode__c = accObj.Id;
        PbDis.Price__c = 200.00;                                                 
        PbDis.UOM__c = 'KG';
        PbDis.Sales_Org__c = salesOrgObj.Id;
        PbDis.CompositeKey__c = '01-04-2016BHA103000000000000692001';           
        insert PbDis;
        
        Trans_Contribution__c tcData = new Trans_Contribution__c();
        tcData.name ='default value';
        tcData.LessThanPallet__c =0.20;
        tcData.MoreThanPallet__c = 0.10;
        insert tcData;
        
        //Data for PRice Book Master       
        PriceBookMaster__c priceBookMasterObj = new PriceBookMaster__c(
            DistributorCustomerCode__c = accObj.Id,         // Distributor Customer Code
            SKUCode__c = skuObj.Id,                           // SKU Code
            Price__c = 61000.00,                                      // Price / Max Price
            DepotCode__c = DepotObj.Id,                         // Depot Code
            MinPrice__c = 41000.00,                                   // Min Price
            Final_Price__c = 0.00,                                    // Final Price
            StartDate__c = System.today(),                // Start Date
            EndDate__c = System.today()+10,                    // End Date
            UOM__c = 'L',                                             // UOM
            Division__c = divisionObj.Id,                          // Division
            DistributionChannel__c = distributionChannelObj.Id,               // Distribution Channel
            Sales_Org__c = salesOrgObj.Id,
            CompositeKey__c ='c1'// Sales Org
        );
        insert priceBookMasterObj;
        
        
        DistributorSalesAreaMapping__c DistributorSalesAreaMappingObj = new DistributorSalesAreaMapping__c(
              AccountType__c = 'Sold To Party',          // Account Type
              Distributor__c = accObj.id,          // Distributor
              SalesOrg__c = salesOrgObj.id,             // Sales Org
              OrderBlock__c = false,                       // Order Block
              DistributionChannel__c = distributionChannelObj.id,  // Distribution Channel
              Division__c = divisionObj.id,             // Division
                    // Account Owner
              PriceGroupMaster__c = priceGroupMasterObj.id     // Price Group Master
            );
            insert DistributorSalesAreaMappingobj;
        
        
        
         DistributorSalesAreaMapping__c DistributorSalesAreaMappingObj1 = new DistributorSalesAreaMapping__c(
              AccountType__c = 'Sold To Party',          // Account Type
              Distributor__c = accObj1.id,          // Distributor
              SalesOrg__c = salesOrgObj.id,             // Sales Org
              OrderBlock__c = false,                       // Order Block
              DistributionChannel__c = distributionChannelObj.id,  // Distribution Channel
              Division__c = divisionObj.id,             // Division
                    // Account Owner
              PriceGroupMaster__c = priceGroupMasterObj.id     // Price Group Master
            );
            insert DistributorSalesAreaMappingobj1;
        
        
        
        //Data for PRice Book Master       
        PriceBookMaster__c priceBookMasterObj1 = new PriceBookMaster__c(
            DistributorCustomerCode__c =null,         // Distributor Customer Code
            SKUCode__c = skuObj.Id,    
            PG_CODE__c =priceGroupMasterObj.Id,
            Price__c = 60000.00,                                      // Price / Max Price
            DepotCode__c = DepotObj.Id,                         // Depot Code
            MinPrice__c = 41000.00,                                   // Min Price
            Final_Price__c = 0.00,                                    // Final Price
            StartDate__c = System.today(),                // Start Date
            EndDate__c = System.today()+10,                    // End Date
            UOM__c = 'L',                                             // UOM
            Division__c = divisionObj.Id,                          // Division
            DistributionChannel__c = distributionChannelObj.Id,               // Distribution Channel
            Sales_Org__c = salesOrgObj.Id,
            CompositeKey__c ='c12'// Sales Org
        );
        insert priceBookMasterObj1;
        
        Order__c ord = new Order__c();
        ord.Bill_To_Party__c = accObj.Id;        
        ord.Order_Date__c = system.today();  
        ord.Order_Status__c = 'Draft';                    
        ord.Sales_Org__c =salesOrgObj.Id;          
        insert ord;
        
        OrderLineItem__c ordItem = new OrderLineItem__c();
        ordItem.SKU_Name__c = skuObj.Id; 
        ordItem.FinalPrice__c =12;
        ordItem.pallet_Size_Italy__c =100.00;
       // ordItem.Weight_Italy__c =20;
        ordItem.Transport_contribution__c =45.00;
        ordItem.Transport_contribution2__c =45.00;
        
        ordItem.Discount2__c =490.00;
        ordItem.Average_Final_Price__c =4000.00;
      //  ordItem.Ordered_weight__c =280.00;
        ordItem.Quantity__c = 14;          
        ordItem.Special_Discount__c = 0.00;     
        ordItem.Price__c = 4500.00; 
        ordItem.Shipping_Date__c = System.today(); 
        ordItem.Net_Invoice_Price__c = 4500.00; 
        ordItem.Order__c = ord.Id;    
        ordItem.Net_Price__c = 63000.00;  
        ordItem.Product_Type_Italy__c = 'Vendita';
        ordItem.Inventory_order_Flag_Color_Italy__c='';
        ordItem.Inventory_Description_Italy__c='Stock available';
        insert ordItem; 
    
        
          //Data for Sales Orders
        Sales_Order__c SalesOrderObj = new Sales_Order__c(
            RecordTypeId = devRecordTypeId,                        // Record Type
            SFDC_Order_Number__c = '87614',                      // SFDC Order Number
         // Order_Raise_By__c = 'Territory Manager',             // Order Raised By
            Desc_Punctuality__c = false,                         // Desc Punctuality
            Order_Date__c = System.today(),            // Order Date
            OrderSubStatus__c = 'Draft',                         // Order Sub-Status
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
            Bill_To_Party__c = accObj.Id,                // Bill To Party
            Depot_Code__c = 'IT00',                              // Depot Code
            Sold_to_Party__c = accObj.Id,                // Sold to Party
            Ship_To_Party__c = shippingLocationObj.Id,                // Ship To Party
            UGDN__c = '20011688'                            // UGDN
        );
        insert SalesOrderObj;
        
        String orderId =[select Id,Order__c from OrderLineItem__c where Id =:ordItem.Id Limit 1].Order__c; 
        Order__c ord2=new Order__c();
        ord2.id=orderId;
        ord2.Order_Status__c='Approved';
        
            
        //Data for Sales Order Line Item
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
            Product_Type_Italy__c ='Vendita',
            Inventory_order_Flag_Color_Italy__c='',
            Inventory_Description_Italy__c='Stock available',
          Transport_contribution__c =45.00,
        Transport_contribution2__c =45.00
        );
        insert saleOrderLineObj;
        
      /*  Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(saleOrderLineObj.id);
        Approval.ProcessResult result = Approval.process(app);*/
        
        
        OrderItalyController.getCartOrderItems(accObj.Id);
        OrderItalyController.getSalesSTP(SalesOrderObj.Id);
        OrderItalyController.getOrderFields(accObj.Id);
        OrderItalyController.getSalesOrder(SalesOrderObj.Id);
        OrderItalyController.getSalesOrderFromParent(SalesOrderObj.Id);
        OrderItalyController.getSalesOrderItems(SalesOrderObj.Id);
        OrderItalyController.getSalesOrderItemsOnChildOrder(SalesOrderObj.Id);
        OrderItalyController.getSalesOrderItemsOnEditChildOrder(SalesOrderObj.Id,'1235') ;
        OrderItalyController.getSkuData(accObj.Id,accObj.PriceGroupCode__c);
        OrderItalyController.deleteOItem(ordItem.Id,ord.Id,'0');
        OrderItalyController.deleteOrderItems(ord.Id);
       // OrderItalyController.getPbDiscount1();
        OrderItalyController.processApproval(true,SalesOrderObj.Id,'approved');
        //ProcessApprovelRequest1.submitForApproval(SalesOrderObj);   
       // OrderItalyController.submitForApproval(SalesOrderObj);
    }
    
    static testMethod void method2(){
        user usr1 = [select id,name from user limit 1];
        system.debug('**User - ' +usr1);
        System.runAs(usr1) {
             Test.startTest();
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '2410'];
        Account acc2 = [SELECT id FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'SAR123' LIMIT 1]; 
        Price_Group_Master__c pgRec = [SELECT id,PG_Code__c FROM Price_Group_Master__c where PG_Code__c = '95' limit 1];
        Depot__c dep = [SELECT Id, Location__c FROM Depot__c WHERE SalesOrg__c = :sorg.Id AND Location__c = 'IT00' LIMIT 1]; 
        SKU__c skurec = [SELECT Id, SKU_Description__c,Unit_Cost__c, SKU_Code__c FROM SKU__c where SKU_Description__c = 'FURYY 40 EC X 250 cc' LIMIT 1]; 
        Payment_Term__c paymentRec  = [SELECT Id, Payment_Term_Code__c FROM Payment_Term__c WHERE Sales_Org__c = :sorg.Id AND Payment_Term_Code__c = 'UK01' LIMIT 1]; 
        Shipping_Location__c shipLoc = [SELECT Id, Pincode__c,City__c,Sales_Org__c FROM Shipping_Location__c WHERE Sales_Org__c =: sorg.Id AND Pincode__c = '11001'  LIMIT 1]; 
        PriceBookMaster__c pbmObj = [SELECT id,PG_Code__c,MinPrice__c,Price__c FROM PriceBookMaster__c where SKUCode__c =: skurec.Id limit 1];
        
        Order__c ord = new Order__c();
        ord.Bill_To_Party__c = acc2.Id;        
        ord.Order_Date__c = system.today();  
        ord.Order_Status__c = 'Draft';                    
        ord.Sales_Org__c =sorg.Id;  
        insert  ord; 
        
        Date todaySDate=Date.today();
        Date todaySAdditonalDate=todaySDate.addDays(15);
        
        OrderItalyController.SalesOrderItem OwrapObj = new OrderItalyController.SalesOrderItem();
        List<OrderItalyController.SalesOrderItem> OwrapObjlst = new List<OrderItalyController.SalesOrderItem>(); 
        OwrapObj.productId = skurec.Id; 
        OwrapObj.unitValue =12;
        OwrapObj.palletSize =100.00;
      //  OwrapObj.Weight =20;
        OwrapObj.TransContribution =45.00;
        OwrapObj.standardRebate2 =490.00;
        OwrapObj.averageFinalP =4000.00;
      //  OwrapObj.orderedWeight =280.00;
        OwrapObj.qty = 14;          
        OwrapObj.materialPrice = 4500.00; 
        OwrapObj.shipDate = String.valueOf(System.today()); 
        OwrapObj.netInvoicePrice = 4500.00; 
        OwrapObj.netPrice = 63000.00;  
        OwrapObj.typeOfProduct = 'Vendita';
        OwrapObjlst.add(OwrapObj);
        String serlizeStr1 = JSON.serialize(OwrapObj);  
        String serlizeStr2 = JSON.serialize(OwrapObjlst);  
       
        Sales_Order__c so2 = new Sales_Order__c();
        so2.Payment_Term__c = paymentRec.Id;      
        so2.Ship_To_Party__c = shipLoc.Id;       
        so2.Sold_to_Party__c = acc2.Id;   
        so2.Order_Status__c ='Submitted';
        so2.Sent_for_Manager_Approval_Mexico__c=true;
        so2.Order_Type_Italy__c='Parent Order';
           
           
            
        List<OrderItalyController.SalesOrderItem> solst = new List<OrderItalyController.SalesOrderItem>(); 
        OrderItalyController.SalesOrderItem wrapObj = new OrderItalyController.SalesOrderItem();
        wrapObj.productId = skurec.id;
        wrapObj.productName = skurec.SKU_Description__c;
        wrapObj.qty = 50;
        wrapObj.UOM ='L';
        wrapObj.oliId = ord.Id;
        wrapObj.shipDate = String.valueOf(System.today()); 
        wrapObj.maxPrice = pbmObj.Price__c;
        wrapObj.typeOfProduct = 'Vendita';
        wrapObj.unitValue = 0.00;
        wrapObj.unitValue2 = 2500.00;
        wrapObj.unitCost =skurec.Unit_Cost__c;
        wrapObj.minValue =pbmObj.MinPrice__c;
        wrapObj.unitValue = 3200;
        wrapObj.productCode =  skurec.SKU_Code__c;
        solst.add(wrapObj);
        String serlizeStr = JSON.serialize(solst);  
         
         OrderItalyController.saveOrder(null, '' ,null,false,'Normal Order');
           
        
         OrderItalyController.saveSalesOrder(so2,  serlizeStr,'');
            Test.stopTest();
         }
        //
       // OrderItalyController.deleteOrderItems('');
        
        
    }
    
    static testMethod void method3(){
         
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '2410'];
        Account acc2 = [SELECT id FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'SAR123' LIMIT 1]; 
        Price_Group_Master__c pgRec = [SELECT id,PG_Code__c FROM Price_Group_Master__c where PG_Code__c = '95' limit 1];
        Depot__c dep = [SELECT Id, Location__c FROM Depot__c WHERE SalesOrg__c = :sorg.Id AND Location__c = 'IT00' LIMIT 1]; 
        SKU__c skurec = [SELECT Id, SKU_Description__c,Unit_Cost__c,Sales_Agent_MSP__c,Area_Manager_MSP__c, SKU_Code__c FROM SKU__c where SKU_Description__c = 'FURYY 40 EC X 250 cc' LIMIT 1]; 
        Payment_Term__c paymentRec  = [SELECT Id, Payment_Term_Code__c FROM Payment_Term__c WHERE Sales_Org__c = :sorg.Id AND Payment_Term_Code__c = 'UK01' LIMIT 1]; 
        Shipping_Location__c shipLoc = [SELECT Id, Pincode__c,City__c,Sales_Org__c FROM Shipping_Location__c WHERE Sales_Org__c =: sorg.Id AND Pincode__c = '11001'  LIMIT 1]; 
        PriceBookMaster__c pbmObj = [SELECT id,PG_Code__c,MinPrice__c,Price__c FROM PriceBookMaster__c where SKUCode__c =: skurec.Id limit 1];
        //OrderLineItem__c oliOb=[Select id, Order__c from OrderLineItem__c where SKU_Name__c =: skurec.Id limit 1];    
        List<Sales_Org__c> salesOrgList = [Select ID FROM Sales_Org__c   
                                                   WHERE Sales_Org_Code__c = '2410'  
                                                   AND Country_Code__c = 'IT' LIMIT 1]; 
        
        Order__c ord = new Order__c();
        ord.Bill_To_Party__c = acc2.Id;        
        ord.Order_Date__c = system.today();  
        ord.Order_Status__c = 'Draft';                    
        ord.Sales_Org__c =sorg.Id;  
        insert  ord;     
       
        OrderItalyController.SalesOrderItem OwrapObj = new OrderItalyController.SalesOrderItem();
        List<OrderItalyController.SalesOrderItem> OwrapObjlst = new List<OrderItalyController.SalesOrderItem>(); 
        OwrapObj.productId = skurec.Id; 
        OwrapObj.unitValue =12;
        OwrapObj.palletSize =100.00;
        OwrapObj.TransContribution =45.00;
        OwrapObj.standardRebate2 =490.00;
        OwrapObj.averageFinalP =400.00;
        OwrapObj.qty = 14;          
        OwrapObj.materialPrice = 4500.00; 
        OwrapObj.shipDate = String.valueOf(System.today()); 
        OwrapObj.netInvoicePrice = 4500.00; 
        OwrapObj.netPrice = 63000.00;  
        OwrapObj.typeOfProduct = 'Vendita';
        OwrapObj.pricebookId=null;
        OwrapObjlst.add(OwrapObj);
        String serlizeStr1 = JSON.serialize(OwrapObj);  
        String serlizeStr2 = JSON.serialize(OwrapObjlst);  

        Sales_Order__c so2 = new Sales_Order__c();
        so2.Payment_Term__c = paymentRec.Id;      
        so2.Ship_To_Party__c = shipLoc.Id;       
        so2.Sold_to_Party__c = acc2.Id;   
        so2.Order_Status__c ='Submitted';
        so2.Is_Payment_Term_Discount_Approval_Italy__c =true;
        so2.PONumber__c='12355';

        
        List<OrderItalyController.SalesOrderItem> solst = new List<OrderItalyController.SalesOrderItem>(); 
        OrderItalyController.SalesOrderItem wrapObj = new OrderItalyController.SalesOrderItem();
        wrapObj.productId = skurec.id;
        wrapObj.productName = skurec.SKU_Description__c;
        wrapObj.qty = 50;
        wrapObj.UOM ='L';
        wrapObj.averageFinalP =400;
        wrapObj.shipDate = String.valueOf(System.today()); 
        wrapObj.maxPrice = pbmObj.Price__c;
        wrapObj.typeOfProduct = 'Vendita';
        wrapObj.unitValue2 = 400.00;
        wrapObj.unitCost =skurec.Unit_Cost__c;
        wrapObj.minValue =pbmObj.MinPrice__c;
        wrapObj.unitValue = 400;
        wrapObj.productCode =  skurec.SKU_Code__c;
        solst.add(wrapObj);
        String serlizeStr = JSON.serialize(solst);  
        //List<SalesOrderItem> salesOrderItemList = (List<SalesOrderItem>)JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class);
       // String pricegroupCode =salesOrderItemList[0].pgCode;
       // String customerWiseCode =salesOrderItemList[0].customerCode;
        
        //OrderItalyController.getPaymentTermCustomerMap(acc2.Id);
        OrderItalyController.getSkuData(acc2.Id,pgRec.Id);
        Test.startTest();
        OrderItalyController.getBlankOrderItemList();
        OrderItalyController.getOrderFields(acc2.Id);
        OrderItalyController.saveOrder(acc2.Id, serlizeStr1 ,ord.Id,false,'Normal Order');
        OrderItalyController.saveOrder(acc2.Id, serlizeStr1 ,null,false,'Normal Order');
        OrderItalyController.updateOrderLineItems(serlizeStr2);
        OrderItalyController.getCartOrderItems(acc2.Id);
        OrderItalyController.getSalesOrderItems(so2.Id);
        try{
        OrderItalyController.saveOrderItems(so2,solst,salesOrgList,null,null,'');
        }Catch(Exception e){
            system.debug('ERROR::'+e.getMessage());
        }
        Test.stopTest();
        //OrderItalyController.getSalesOrderItemsOnChildOrder(so2.Id);
        //OrderItalyController.saveSalesOrder(so2,  serlizeStr);
        
       // OrderItalyController.getSalesOrder(so2.Id);
        
    }
    static testMethod void method4(){
        user usr1 = [select id,name from user limit 1];
        system.debug('**User - ' +usr1);
        System.runAs(usr1) {
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '2410'];
        Account acc2 = [SELECT id FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'SAR123' LIMIT 1]; 
        Price_Group_Master__c pgRec = [SELECT id,PG_Code__c FROM Price_Group_Master__c where PG_Code__c = '95' limit 1];
        Depot__c dep = [SELECT Id, Location__c FROM Depot__c WHERE SalesOrg__c = :sorg.Id AND Location__c = 'IT00' LIMIT 1]; 
        SKU__c skurec = [SELECT Id, SKU_Description__c,Unit_Cost__c, SKU_Code__c FROM SKU__c where SKU_Description__c = 'FURYY 40 EC X 250 cc' LIMIT 1]; 
        Payment_Term__c paymentRec  = [SELECT Id, Payment_Term_Code__c FROM Payment_Term__c WHERE Sales_Org__c = :sorg.Id AND Payment_Term_Code__c = 'UK01' LIMIT 1]; 
        Shipping_Location__c shipLoc = [SELECT Id, Pincode__c,City__c,Sales_Org__c FROM Shipping_Location__c WHERE Sales_Org__c =: sorg.Id AND Pincode__c = '11001'  LIMIT 1]; 
        PriceBookMaster__c pbmObj = [SELECT id,PG_Code__c,MinPrice__c,Price__c FROM PriceBookMaster__c where SKUCode__c =: skurec.Id limit 1];
        
        Order__c ord = new Order__c();
        ord.Bill_To_Party__c = acc2.Id;        
        ord.Order_Date__c = system.today();  
        ord.Order_Status__c = 'Draft';                    
        ord.Sales_Org__c =sorg.Id;  
        insert  ord; 
        
        Date todaySDate=Date.today();
        Date todaySAdditonalDate=todaySDate.addDays(15);
        
        OrderItalyController.SalesOrderItem OwrapObj = new OrderItalyController.SalesOrderItem();
        List<OrderItalyController.SalesOrderItem> OwrapObjlst = new List<OrderItalyController.SalesOrderItem>(); 
        OwrapObj.productId = skurec.Id; 
        OwrapObj.unitValue =12;
        OwrapObj.palletSize =100.00;
      //  OwrapObj.Weight =20;
        OwrapObj.TransContribution =45.00;
        OwrapObj.standardRebate2 =490.00;
        OwrapObj.averageFinalP =4000.00;
      //  OwrapObj.orderedWeight =280.00;
        OwrapObj.qty = 14;          
        OwrapObj.materialPrice = 4500.00; 
        OwrapObj.shipDate = String.valueOf(System.today()); 
        OwrapObj.netInvoicePrice = 4500.00; 
        OwrapObj.netPrice = 63000.00;  
        OwrapObj.typeOfProduct = 'Vendita';
        OwrapObjlst.add(OwrapObj);
        String serlizeStr1 = JSON.serialize(OwrapObj);  
        String serlizeStr2 = JSON.serialize(OwrapObjlst);  
       
        Sales_Order__c so2 = new Sales_Order__c();
        so2.Payment_Term__c = paymentRec.Id;      
        so2.Ship_To_Party__c = shipLoc.Id;       
        so2.Sold_to_Party__c = acc2.Id;   
        so2.Order_Status__c ='Submitted';
        so2.Sent_for_Manager_Approval_Mexico__c=true;
        so2.Order_Type_Italy__c='Child Order';
           
            Test.startTest();
        List<OrderItalyController.SalesOrderItem> solst = new List<OrderItalyController.SalesOrderItem>(); 
        OrderItalyController.SalesOrderItem wrapObj = new OrderItalyController.SalesOrderItem();
        wrapObj.productId = skurec.id;
        wrapObj.productName = skurec.SKU_Description__c;
        wrapObj.qty = 50;
        wrapObj.UOM ='L';
        wrapObj.oliId = ord.Id;
        wrapObj.shipDate = String.valueOf(System.today()); 
        wrapObj.maxPrice = pbmObj.Price__c;
        wrapObj.typeOfProduct = 'Vendita';
        wrapObj.unitValue = 0.00;
        wrapObj.unitValue2 = 2500.00;
        wrapObj.unitCost =skurec.Unit_Cost__c;
        wrapObj.minValue =pbmObj.MinPrice__c;
        wrapObj.unitValue = 3200;
        wrapObj.productCode =  skurec.SKU_Code__c;
        solst.add(wrapObj);
        String serlizeStr = JSON.serialize(solst);  
         
         OrderItalyController.saveOrder(null, '' ,null,false,'Normal Order');
           
        
         OrderItalyController.saveSalesOrder(so2,  serlizeStr,'');
            Test.stopTest();
         }
        //
       // OrderItalyController.deleteOrderItems('');
        
        
    }
        
    }