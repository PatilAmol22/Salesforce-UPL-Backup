@isTest
public class BoliviaParaguaySOControllerTest {
    static testMethod void validateHelloWorld() {

        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='5361';
        sorg.Description__c='Bolivia';
        sorg.Sales_Org_Code__c='5361';
        insert sorg;

        Distribution_Channel__c disbj = new Distribution_Channel__c();
        disbj.Name = '20';                      
        disbj.Distribution_Channel_Code__c = '20';  
        disbj.Description__c='20';
        disbj.Sales_Org__c = sorg.id;
        insert disbj;
        
        Division__c divsn = new Division__c();
        divsn.Name = '10';         
        divsn.Description__c = '10';    
        divsn.Division_Code__c = '10'; 
        insert divsn;

        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZZOR';              
        ordType.Description__c = 'ZZOR';    
        ordType.Order_Type_Code__c = 'ZZOR';
        ordType.Combination_Key__c = 'ZZOR5361';
        insert ordType;

        Inco_Term__c incoTerm = new Inco_Term__c(
          Name = 'CIF',                    // Inco Term Name
          IncoTerm_Desc__c = 'CIF',          // IncoTerm Desc
          IncoTerm_Code__c = 'CIF',          // IncoTerm Code
          Sales_Org__c = sorg.id,  // Sales Org
          Active__c = true,                  // Active
          Combination_Key__c = '5361CIF'    // Combination Key
        );
        insert incoTerm;

      Payment_Term__c payTerm = new Payment_Term__c(
        Payment_Term__c = 'LIB1',// Payment Term
        Payment_Term_Code__c = 'LIB1',                             // Payment Term Code
        Payterms_Desc__c = 'LIB1',      // Payterms Desc
        Sales_Org__c = sorg.id,                          // Sales Org
        Active__c = true,                                         // Active
        CombinationKey__c = '5361LIB1'                            // CombinationKey
      );
      insert payTerm;

        Account acc = new Account();
        acc.Name='Nikhil';
        acc.Last_Name__c='Dhoke';
        //acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='8600000000';
        acc.Phone='020200000';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=divsn.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Mumbai';
        acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'BO01';
        //acc.Customer_Grp__c = cg.id;
        //  acc.OwnerId=sobj.Id;
        insert acc;
         
        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName=acc.Last_Name__c;
        con.MobilePhone ='9876543210';
        con.Phone = '5592619031';
        insert con;

        Contact con2 = new Contact();
        con2.AccountId=acc.Id;
        con2.LastName=acc.Last_Name__c;
        con2.MobilePhone ='9876543210';
        con2.Phone = '5592619031';
        insert con2;
        
        userrole  usrole = new userrole();
        usrole.Name ='Regional/Zonal Managers for Spain';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'PartnerCommunity Distributor Profile'];

        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'skim@skinternational123.com';                             
        sobj1.ProfileId  = p.ID;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='Terriotory Manager';
        sobj1.CommunityNickname = 'zonalExe1222 Di'; 
        sobj1.TimeZoneSidKey = 'Asia/Kolkata'; 
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId=usrole.id;
        sobj1.ContactId=con.Id;
        sobj1.Country = 'Bolivia';
        insert sobj1;
        
        User spainUser = new User();
        spainUser.Alias = 'zonaa2';                                                            
        spainUser.Email = 'sk@skinternational.com';                             
        spainUser.ProfileId  = p.ID;                                                     
        spainUser.Username = 'zonal7_aaexe1232@upl122333.com.devbox1';                                    
        spainUser.IsActive = true;  
        spainUser.LastName='TM';
        spainUser.CommunityNickname = 'zonal7Exe1222 Di'; 
        spainUser.TimeZoneSidKey = 'Asia/Kolkata'; 
        spainUser.LocaleSidKey = 'en_IN';                                    
        spainUser.LanguageLocaleKey = 'en_US';                                             
        spainUser.ForecastEnabled = false;                                                     
        spainUser.EmailEncodingKey = 'ISO-8859-1';    
        spainUser.Show_Inventory__c = false;                                                     
        spainUser.Show_Credit_Limit__c = false; 
        spainUser.UserRoleId=usrole.id;
        spainUser.ContactId=con2.Id;
        spainUser.Country = 'Bolivia';
        spainUser.ManagerId = sobj1.Id;
        spainUser.Country_Head__c = sobj1.Id;
        
        insert spainUser;       

        RecordType shipLocRcdTp = [SELECT Id FROM RecordType WHERE name = 'Storage Location' and isActive = true LIMIT 1];
        RecordType depoRcdTp = [SELECT Id FROM RecordType WHERE name = 'Depot' and isActive = true LIMIT 1];
        

        Depot__c storageLoc =new Depot__c ();
        storageLoc.Name='MAIN';
        storageLoc.recordtypeId=shipLocRcdTp.id;
        storageLoc.Country__c='Bolivia';
        storageLoc.Location__c='Bolivia';
        storageLoc.Depot_Code__c='MAIN';
        storageLoc.SalesOrg__c = sorg.ID;
        storageLoc.Plant_Desc__c= '';
        storageLoc.Active__c = true;
        insert storageLoc;

        Depot__c depo =new Depot__c ();
        depo.Name='BO01';
        depo.recordtypeId=depoRcdTp.id;
        depo.Country__c='Bolivia';
        depo.Location__c='BO01';
        depo.Depot_Code__c='BO01';
        depo.SalesOrg__c = sorg.ID;
        depo.Plant_Desc__c= 'BO01';
        depo.Active__c = true;
        insert depo;
        
        Shipping_Location__c shippLoc =new Shipping_Location__c();
        shippLoc.Location_Name__c ='Same as Billing Address'; 
        shippLoc.Region__c='Wadgoan Sheri,Nagar Rd, Aga Nagar,';
        shippLoc.Distributor__c=acc.Id;
        shippLoc.City__c='Pune';
        shippLoc.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc.SAP_Code__c='SAP996734';
        shippLoc.State__c='13';
        shippLoc.Country_Name__c = '';
        shippLoc.Country__c = 'Vietnam';
        shippLoc.Pincode__c = '041523';
        shippLoc.Sales_Org__c = sorg.id;
        shippLoc.Billing_Street_1__c = '';
        shippLoc.Billing_Street_2__c = '';
        shippLoc.Billing_Street_3__c = '';
        shippLoc.Billing_Street_4__c = '';
        shippLoc.Billing_Street_5__c = '';
        shippLoc.Billing_Street_6__c = '';
        insert shippLoc;

        Credit_Info__c crdIf = new Credit_Info__c();
        crdIf.Credit_Limit__c=1000;
        crdIf.Percentage_Used__c=100.0;
        crdIf.Allocated_Limit__c=0.0;
        crdIf.Distributor__c=acc.Id;
        crdIf.Distributor_Code__c='0001001225';
        crdIf.Sales_Org__c=sorg.Id;
        crdIf.Internal_Limit__c=0.0;
        crdIf.Used_Limit__c=0.0;
        crdIf.Balance_Limit__c=0.0;
        insert crdIf;

        Outstanding_Ageing__c ostAg = new Outstanding_Ageing__c();
        //ostAg.OutstandingTotalGreaterthan90__c=0.0;
        ostAg.Net_Outstanding__c=0.0;
        ostAg.Customer_Code__c = acc.Id;
        ostAg.Sales_Org__c = sorg.id;
        insert ostAg;

        Payments__c payC = new Payments__c();
        payC.Net_Overdue__c=0.0;
        payC.Customer_Name__c = acc.id;
        payC.Company_Code__c = sorg.id;
        insert payC;

        DistributorSalesAreaMapping__c DSAM = new DistributorSalesAreaMapping__c(
              AccountType__c = 'Sold To Party',          // Account Type
              Distributor__c = acc.id,          // Distributor
              SalesOrg__c = sorg.id,             // Sales Org
              OrderBlock__c = false,                       // Order Block
              //DistributionChannel__c = disbj.id,  // Distribution Channel
              //Division__c = Divbj2.id,             // Division
              AccountOwner__c = spainUser.Id
              //PriceGroupMaster__c = priceGroup.id     // Price Group Master
            );
            insert DSAM;

        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        insert pro;
        
        SKU__c sku = new SKU__c();
        sku.Name='DOST';
        sku.SKU_Code__c='704002';
        sku.SKU_Pack__c=1.00;
        sku.SKU_UOM__c='L';
        sku.Multiple_Of__c=5;
        sku.Group__c='DOST';
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='L';
        sku.Division__c = divsn.id;
        sku.Distribution_Channel__c = disbj.id;
        sku.Active__c=True;
        sku.Combination_Key__c='Cooooooo000011111';
        insert sku;

        SKU__c sku2 = new SKU__c();
        sku2.Name='DOST2';
        sku2.SKU_Code__c='704003';
        sku2.SKU_Pack__c=1.00;
        sku2.SKU_UOM__c='KG';
        sku2.Multiple_Of__c=5;
        sku2.Group__c='DOST2';
        sku2.Pack_Size__c=10.00;
        sku2.Product_Name__c=pro.Id;
        sku2.Sales_Org__c = sorg.Id;
        sku2.UOM__c='KG';
        sku2.Division__c = divsn.id;
        sku2.Distribution_Channel__c = disbj.id;
        sku2.Active__c=True;
        sku2.Combination_Key__c='Cooooooo000011112';
        insert sku2;     

        Stock_Requirement__c stockReq = new Stock_Requirement__c(
            SKU__c = sku.id,             // SKU
            Depot__c = depo.id
        );
        insert stockReq;
        

        PriceBookMaster__c pbMaster = new PriceBookMaster__c(
          SKUCode__c = sku.id,                      // SKU Code
          Price__c = 45.00,                                    // Price / Max Price
          MinPrice__c = 10,
          DepotCode__c = depo.id,                    // Depot Code
          Final_Price__c = 0.00,                               // Final Price
          StartDate__c = system.today(),             // Start Date
          EndDate__c = system.today() + 1,              // End Date
          UOM__c = 'L',                                        // UOM
          Division__c = divsn.id,                     // Division
          DistributionChannel__c = disbj.id,          // Distribution Channel
          Active__c = true,                                    // Active
          PerUnit__c = 1,                                    // Per Unit
          CompositeKey__c = 'SW0625207010000000000006001071',  // CompositeKey
          Sales_Org__c = sorg.id,                    // Sales Org
          Price_Book_Change__c = false                        // Price_Book_Change
         // Customized_Product__c = false                       // Customized Product
        );
        insert pbMaster;

        PriceBookMaster__c pbMaster2 = new PriceBookMaster__c(
          SKUCode__c = sku2.id,                      // SKU Code
          Price__c = 45.00,                                    // Price / Max Price
          MinPrice__c = 10,
          DepotCode__c = depo.id,                    // Depot Code
          Final_Price__c = 0.00,                               // Final Price
          StartDate__c = system.today(),             // Start Date
          EndDate__c = system.today() + 1,              // End Date
          UOM__c = 'L',                                        // UOM
          Division__c = divsn.id,                     // Division
          DistributionChannel__c = disbj.id,          // Distribution Channel
          Active__c = true,                                    // Active
          PerUnit__c = 1,                                    // Per Unit
          CompositeKey__c = 'SW0625207010000000000006001072',  // CompositeKey
          Sales_Org__c = sorg.id,                    // Sales Org
          Price_Book_Change__c = false                        // Price_Book_Change
          //Customized_Product__c = false                       // Customized Product
        );
        insert pbMaster2;       

        Order__c order = new Order__c(
          Order_Date__c = system.today(),      // Order Date
          Order_Type__c = ordType.Id,              // Order Type
          Order_Status__c = 'Draft',                   // Order Status
          Remarks__c = 'Test',                            // Remarks
          Price_Entry__c = 'Pre-uploaded',                // Price Entry
          Depot__c = depo.ID,                   // Depot
          Is_Express_Delivery_Italy__c = false,           // Is Express Delivery
          //Early_Order_Discount__c = 2.00,                 // Early Order Discount
          //Net_Amount__c = 1767.92,  // Gross Amount With Early Discount
          Sales_Org__c = sorg.id,               // Sales Org
          Bill_To_Party__c = acc.id,           // Bill To Party
          Shipping_Location__c = shippLoc.id,       // Shipping Location
          Date_of_Payment__c = system.today(),
          Type_of_Order__c = 'Regular'
        );
        insert order;

        OrderLineItem__c orderLineItem1 = new OrderLineItem__c(
          SKU_Name__c = sku.id,              // SKU Name
          Item_Number__c = '10',                        // Item Number
          UOM__c = 'L',                                 // UOM
          Quantity__c = 205.00,                       // Quantity
          Price__c = 10.00,                             // Price
          Order__c = order.id,                 // Order
          Net_Price__c = 1804.00,                       // Net Price
          Stock_Available__c = false,                   // Stock Available
          Distributor_Discount__c = 0,                  // Distributor Discount
          Material_Discount__c = 0,                     // Material Discount
          Campaign_Discount__c = 5,                     // Campaign Discount
          FinalPrice__c = 8.80,                         // FinalPrice
          Shipping_Date__c = system.today(),  // Shipping Date
          Apply_Rebate__c = false,                      // Apply Rebate
          multipleOf__c = 1,                          // multipleOf
         // Customized_Product__c = false,                // Customized Product
          Price_Book_Master__c = pbMaster.id,     // Price Book Master
          Apply_Campaign_Discount__c = true,            // Apply Campaign Discount
          Division__c = divsn.id,              // Division
          Distribution_Channel__c = disbj.id,  // Distribution Channel
          Actual_Discount__c = 1.20,                    // Actual Discount
          Edited_Discount__c = 1.20,                    // Edited Discount
          Line_Discount__c = 2.00,                      // Line Discount
          Volume_Discount__c = 5.00,                    // Volume Discount
          Actual_Campaign_Discount__c = 5.00,           // Actual Campaign Discount
          Actual_Line_Discount__c = 2.00,               // Actual Line Discount
          Actual_Volume_Discount__c = 5.00,          // Actual Volume Discount
          MaxPrice__c = 10,
          MinPrice__c = 05,
          Date_of_Payment__c = system.today()
        );
        insert orderLineItem1;

        OrderLineItem__c orderLineItem2 = new OrderLineItem__c(
          SKU_Name__c = sku2.id,              // SKU Name
          Item_Number__c = '10',                        // Item Number
          UOM__c = 'KG',                                 // UOM
          Quantity__c = 205.00,                       // Quantity
          Price__c = 10.00,                             // Price
          Order__c = order.id,                 // Order
          Net_Price__c = 1804.00,                       // Net Price
          Stock_Available__c = false,                   // Stock Available
          Distributor_Discount__c = 0,                  // Distributor Discount
          Material_Discount__c = 0,                     // Material Discount
          Campaign_Discount__c = 5,                     // Campaign Discount
          FinalPrice__c = 8.80,                         // FinalPrice
          Shipping_Date__c = system.today(),  // Shipping Date
          Apply_Rebate__c = false,                      // Apply Rebate
          multipleOf__c = 1,                          // multipleOf
          //Customized_Product__c = false,                // Customized Product
          Price_Book_Master__c = pbMaster2.id,     // Price Book Master
          Apply_Campaign_Discount__c = true,            // Apply Campaign Discount
          Division__c = divsn.id,              // Division
          Distribution_Channel__c = disbj.id,  // Distribution Channel
          Actual_Discount__c = 1.20,                    // Actual Discount
          Edited_Discount__c = 1.20,                    // Edited Discount
          Line_Discount__c = 2.00,                      // Line Discount
          Volume_Discount__c = 5.00,                    // Volume Discount
          Actual_Campaign_Discount__c = 5.00,           // Actual Campaign Discount
          Actual_Line_Discount__c = 2.00,               // Actual Line Discount
          Actual_Volume_Discount__c = 5.00,             // Actual Volume Discount
          MaxPrice__c = 10,
          MinPrice__c = 05,
          Date_of_Payment__c = system.today()
        );
        insert orderLineItem2;

        Sales_Order__c salesOrder = new Sales_Order__c(
          //SFDC_Order_Number__c = '212964',                   // SFDC Order Number
          Order_Date__c = system.today(),            // Order Date
          Order__c = order.id,                        // Order
          SAP_Order_Number__c = '5010220050',                  // SAP Order Number
          Order_Status__c = 'Draft',               // Order Status
          UGDN__c = '20003863',                                // UGDN
          Division_lk__c = divsn.id,                  // Division
          Distribution_Channel_lk__c = disbj.id,      // Distribution Channel
          CreatedFrom__c = 'SFDC',                             // Created From
          Sales_Org_lk__c = sorg.id,                 // Sales Org
          Total_Amount__c = 1804.00,                           // Total Amount
          Is_Order_FCA_Italy__c = false,                       // Is Order FCA
          Remarks__c = 'Test 3',                               // Remarks
          Order_FCA_Italy__c = false,                          // Order FCA
          PONumber__c = '65',                                  // PO Number
          Customer_Approval__c = false,                        // Customer Approval
          Early_Order_Discount__c = 2.00,                      // Early Order Discount
          is_Different_Free_Product__c = false,                // is Different Free Product
          Sold_to_Party__c = acc.id,                // Sold to Party
          Depot_Code__c = depo.id,                              // Depot Code
          Bill_To_Party__c = acc.id,                // Bill To Party
          Ship_To_Party__c = shippLoc.id,                // Ship To Party
          Sent_for_Manager_Approval_Mexico__c = false,         // Sent for Manager Approval
          DirectApproved__c = false,                           // Direct Approved
          Sent_for_Director_Approval_Mexico__c = false,        // Sent for Director Approval
          Sent_for_Latam_Director_Approval__c = false,         // Sent for Latam Director Approval
          Check_Transport_contribution__c = false,             // Check Transport contribution
          Is_Payment_Term_Discount_Approval_Italy__c = false,  // Is Payment Term Discount Approval
          Is_Express_Delivery_Italy__c = false,                // Is Express Delivery
          Gross_Amount_With_Early_Discount__c = 0,
          Date_of_Payment__c = system.today(),
          Order_Type__c = 'Regular'
        );
        insert salesOrder;

      Sales_Order_Line_Item__c soLineItem1 = new Sales_Order_Line_Item__c(
        Order_Item_Key__c = '0109202021296410',     // OrderNumber_Item_Key
        Item_Number__c = 10,                        // Item Number
        UOM__c = 'L',                                 // UOM
        DepotDepot__c = depo.id,            // Depot
        Sale_Order__c = salesOrder.id,            // Sales Order
        SKU_Name__c = sku.id,              // SKU Name
        Item_Status__c = 'Active',                    // Item Status
        Division__c = divsn.id,              // Division
        Distribution_Channel__c = disbj.id,  // Distribution Channel
        Price__c = 10.00,                             // Value
        Storage_Location__c = storageLoc.id,      // Storage Location
        Stock_Available__c = false,                   // Stock Available
        is_Approval_Required__c = false,              // is Approval Required
        is_Different_Free_Product__c = false,         // is Different Free Product
        Apply_Campaign_Discount__c = true,            // Apply Campaign Discount
        Actual_Discount__c = 1.20,                    // Actual Discount
        Edited_Discount__c = 1.20,                    // Edited Discount
        Line_Discount__c = 2.00,                      // Line Discount
        Volume_Discount__c = 5.00,                    // Volume Discount
        Actual_Line_Discount__c = 2.00,               // Actual Line Discount
        Actual_Volume_Discount__c = 5.00,             // Actual Volume Discount
        Actual_Campaign_Discount__c = 5.00,           // Actual Campaign Discount
        Net_Price__c = 1804.00,                       // Net Price
        FinalPrice__c = 8.80,                         // Edited Estimated Final Price
        Quantity__c = 205.00,                       // Quantity
        Shipping_Date__c = system.today(),  // Shipping Date
        Check_Transport_contribution__c = false,      // Check Transport contribution
        Campaign_Discount__c = 5,                     // Campaign Discount (%)
        MaxPrice__c = 10,
        MinPrice__c = 05,
        Date_of_Payment__c = system.today()
      );
      insert soLineItem1;

      Sales_Order_Line_Item__c soLineItem2 = new Sales_Order_Line_Item__c(
        Order_Item_Key__c = '0109202021296420',     // OrderNumber_Item_Key
        Item_Number__c = 20,                        // Item Number
        UOM__c = 'KG',                                 // UOM
        DepotDepot__c = depo.id,            // Depot
        Sale_Order__c = salesOrder.id,            // Sales Order
        SKU_Name__c = sku2.id,              // SKU Name
        Item_Status__c = 'Active',                    // Item Status
        Division__c = divsn.id,              // Division
        Distribution_Channel__c = disbj.id,  // Distribution Channel
        Price__c = 10.00,                             // Value
        Storage_Location__c = storageLoc.id,      // Storage Location
        Stock_Available__c = false,                   // Stock Available
        is_Approval_Required__c = false,              // is Approval Required
        is_Different_Free_Product__c = false,         // is Different Free Product
        Apply_Campaign_Discount__c = true,            // Apply Campaign Discount
        Actual_Discount__c = 1.20,                    // Actual Discount
        Edited_Discount__c = 1.20,                    // Edited Discount
        Line_Discount__c = 2.00,                      // Line Discount
        Volume_Discount__c = 5.00,                    // Volume Discount
        Actual_Line_Discount__c = 2.00,               // Actual Line Discount
        Actual_Volume_Discount__c = 5.00,             // Actual Volume Discount
        Actual_Campaign_Discount__c = 5.00,           // Actual Campaign Discount
        Net_Price__c = 1804.00,                       // Net Price
        FinalPrice__c = 8.80,                         // Edited Estimated Final Price
        Quantity__c = 205.00,                       // Quantity
        Shipping_Date__c = system.today(),  // Shipping Date
        Check_Transport_contribution__c = false,      // Check Transport contribution
        Campaign_Discount__c = 5,                     // Campaign Discount (%)
        MaxPrice__c = 10,
        MinPrice__c = 05,
        Date_of_Payment__c = system.today()
      );
      insert soLineItem2;

      Attachment attach = new Attachment(
      parentId = salesOrder.id,
      Body = EncodingUtil.base64Decode('fdestdctyrgdybdrtnuftyuytmiynu'),
      Name = 'fileName',
      ContentType = '.pdf');
      insert attach;

      Test.startTest();
      BoliviaParaguaySOController.OrderWrapper ordWrapper = new BoliviaParaguaySOController.OrderWrapper();
      List<BoliviaParaguaySOController.OrderItemWrapper> ordItemWrapperList = new List<BoliviaParaguaySOController.OrderItemWrapper>();
      BoliviaParaguaySOController.OrderItemWrapper ordItemWrapper = new BoliviaParaguaySOController.OrderItemWrapper();
      ordItemWrapper.orderItem_id = orderLineItem1.id;
      ordItemWrapper.order_id = order.id;
      ordItemWrapper.pb_id = pbMaster.id;
      ordItemWrapper.sku_name = sku.Name;
      ordItemWrapper.sku_id = sku.id;
      ordItemWrapper.uom = sku.UOM__c;
      ordItemWrapper.quantity = 0.0;
      ordItemWrapper.max_price = 0.0;
      ordItemWrapper.min_price = 0.0;
      ordItemWrapper.payment_date = String.valueOf(System.today());
      ordItemWrapper.inventory = 0.0;
      ordItemWrapper.net_price = 0.0;
      ordItemWrapper.final_price = 0.0;
      ordItemWrapper.multiple_of = 0.0;
      ordItemWrapper.distributionChanlIds = disbj.id;
      ordItemWrapper.divisionIds = divsn.id;
      ordItemWrapper.itemNumber = 10;
     
      ordItemWrapperList.add(ordItemWrapper);

      ordItemWrapper = new BoliviaParaguaySOController.OrderItemWrapper();
      ordItemWrapper.orderItem_id = orderLineItem2.id;
      ordItemWrapper.order_id = order.id;
      ordItemWrapper.pb_id = pbMaster2.id;
      ordItemWrapper.sku_name = sku2.Name;
      ordItemWrapper.sku_id = sku2.id;
      ordItemWrapper.uom = sku2.UOM__c;
      ordItemWrapper.max_price = 0.0;
      ordItemWrapper.min_price = 0.0;
      ordItemWrapper.payment_date = String.valueOf(System.today());
      ordItemWrapper.inventory = 0.0;
      ordItemWrapper.net_price = 0.0;
      ordItemWrapper.final_price = 0.0;
      ordItemWrapper.multiple_of = 0.0;
      ordItemWrapper.distributionChanlIds = disbj.id;
      ordItemWrapper.divisionIds = divsn.id;
      ordItemWrapper.quantity = 0.0;
      ordItemWrapper.itemNumber = 20;
     // ordItemWrapper.min_quantity = 0;
     // ordItemWrapper.campaign_code = '';

      ordItemWrapperList.add(ordItemWrapper);

      ordWrapper.orderItemList = ordItemWrapperList;
      ordWrapper.orderFor = '5361';
      ordWrapper.account_Id = acc.id;
      ordWrapper.ordr_id = order.id;
      ordWrapper.so_id = '';
      ordWrapper.isSalesOrder = true;
     // ordWrapper.early_ordr_discount = 0;
      ordWrapper.total_amount = 0.0;
     // ordWrapper.gross_amount = 0.0;
      ordWrapper.uom_kg = '';
      ordWrapper.uom_each = '';
      ordWrapper.uom_litre = '';
      ordWrapper.net_price_kg = 0.0;
      ordWrapper.net_price_each = 0.0;
      ordWrapper.net_price_litre = 0.0;
      ordWrapper.quantity_kg = 0.0;
      ordWrapper.quantity_each = 0.0;
      ordWrapper.quantity_litre = 0.0;
      ordWrapper.inco_term = incoTerm.Name;
      ordWrapper.inco_term_id = incoTerm.id;
      //ordWrapper.payment_method = payMethod.Name;
      //ordWrapper.payment_method_id = payMethod.id;
      ordWrapper.payment_term = payTerm.Name;
      ordWrapper.payment_term_id = payTerm.id;
      ordWrapper.shipping_loc = shippLoc.id;
      ordWrapper.shipping_loc_details = 'Test';
      ordWrapper.po_no = 'tet';
      ordWrapper.remark = 'test';
      ordWrapper.status = 'Draft';
      ordWrapper.salesOrgObj = sorg.id;
      ordWrapper.Order_Type = ordType.id;
      ordWrapper.Depo_Obj = depo.id;
     // ordWrapper.Shipping_Point = shippingPoint.id;
      ordWrapper.Storage_Location = storageLoc.id;
      ordWrapper.CurrencyCode = 'USD';
      ordWrapper.ownerId = spainUser.id;
     
      List<String> distIds = new List<String>();
      distIds.add(disbj.id);
      List<String> divIds = new List<String>();
      divIds.add(divsn.id);

      ordWrapper.distributionChanlIds = distIds;
      ordWrapper.divisionIds = divIds;
      ordWrapper.lastItemNumber = 20;
     // ordWrapper.countryWise_EOD = new List<Decimal>();
     // ordWrapper.disable_EOD = false;
      ordWrapper.orderRaisedBy = '';
      ordWrapper.managerId = sobj1.id;
      ordWrapper.countryHead = sobj1.id;

      //BoliviaParaguaySOController.getOrderDetails(acc.id);
      System.runAs(spainUser){
            BoliviaParaguaySOController.getOrderDetails(salesOrder.id);
      }
      BoliviaParaguaySOController.getOrderDetails(salesOrder.id);
      //BoliviaParaguaySOController.getOrderForList('2510',acc.id);
      BoliviaParaguaySOController.getSKUInventory(sku.id,'5361',depo.id);
      //BoliviaParaguaySOController.getCampaignAndDiscount(sku2.id,sorg.id,depo.id,disbj.id,divsn2.id,depo.Name+''+storageLoc.Name);
      BoliviaParaguaySOController.createDraftOrder(JSON.serialize(ordWrapper));

      ordWrapper = new BoliviaParaguaySOController.OrderWrapper();
      ordItemWrapperList = new List<BoliviaParaguaySOController.OrderItemWrapper>();
      ordItemWrapper = new BoliviaParaguaySOController.OrderItemWrapper();

      ordItemWrapper.orderItem_id = soLineItem1.id;
      ordItemWrapper.order_id = order.id;
      ordItemWrapper.pb_id = pbMaster.id;
      ordItemWrapper.sku_name = sku.Name;
      ordItemWrapper.sku_id = sku.id;
      ordItemWrapper.uom = sku.UOM__c;
      ordItemWrapper.max_price = 0.0;
      ordItemWrapper.min_price = 0.0;
      ordItemWrapper.payment_date = String.valueOf(System.today());
      ordItemWrapper.inventory = 0.0;
      ordItemWrapper.net_price = 0.0;
      ordItemWrapper.final_price = 0.0;
      ordItemWrapper.multiple_of = 0.0;
      ordItemWrapper.distributionChanlIds = disbj.id;
      ordItemWrapper.divisionIds = divsn.id;
      ordItemWrapper.quantity = 100.0;
      ordItemWrapper.itemNumber = 10;
     
      ordItemWrapperList.add(ordItemWrapper);

      ordItemWrapper = new BoliviaParaguaySOController.OrderItemWrapper();
      ordItemWrapper.orderItem_id = soLineItem2.id;
      ordItemWrapper.order_id = order.id;
      ordItemWrapper.pb_id = pbMaster2.id;
      ordItemWrapper.sku_name = sku2.Name;
      ordItemWrapper.sku_id = sku2.id;
      ordItemWrapper.uom = sku2.UOM__c;
      ordItemWrapper.max_price = 0.0;
      ordItemWrapper.min_price = 0.0;
      ordItemWrapper.payment_date = String.valueOf(System.today());
      ordItemWrapper.inventory = 0.0;
      ordItemWrapper.net_price = 0.0;
      ordItemWrapper.final_price = 0.0;
      ordItemWrapper.multiple_of = 0.0;
      ordItemWrapper.distributionChanlIds = disbj.id;
      ordItemWrapper.divisionIds = divsn.id;
      ordItemWrapper.quantity = 100.0;
      ordItemWrapper.itemNumber = 20;

      ordItemWrapperList.add(ordItemWrapper);

      ordWrapper.orderItemList = ordItemWrapperList;
      ordWrapper.orderFor = '5361';
      ordWrapper.account_Id = acc.id;
      ordWrapper.ordr_id = order.id;
      ordWrapper.so_id = salesOrder.id;
      ordWrapper.isSalesOrder = true;
     // ordWrapper.early_ordr_discount = 2;
      ordWrapper.total_amount = 1000.0;
    //  ordWrapper.gross_amount = 1000.0;
      ordWrapper.uom_kg = '';
      ordWrapper.uom_each = '';
      ordWrapper.uom_litre = '';
      ordWrapper.net_price_kg = 0.0;
      ordWrapper.net_price_each = 0.0;
      ordWrapper.net_price_litre = 0.0;
      ordWrapper.quantity_kg = 0.0;
      ordWrapper.quantity_each = 0.0;
      ordWrapper.quantity_litre = 0.0;
      ordWrapper.inco_term = incoTerm.Name;
      ordWrapper.inco_term_id = incoTerm.id;
      //ordWrapper.payment_method = payMethod.Name;
      //ordWrapper.payment_method_id = payMethod.id;
      ordWrapper.payment_term = payTerm.Name;
      ordWrapper.payment_term_id = payTerm.id;
      ordWrapper.shipping_loc = shippLoc.id;
      ordWrapper.shipping_loc_details = 'Test';
      ordWrapper.po_no = 'tet';
      ordWrapper.remark = 'test';
      ordWrapper.status = 'Draft';
      ordWrapper.salesOrgObj = sorg.id;
      ordWrapper.Order_Type = ordType.id;
      ordWrapper.Depo_Obj = depo.id;
    //  ordWrapper.Shipping_Point = shippingPoint.id;
      ordWrapper.Storage_Location = storageLoc.id;
      ordWrapper.CurrencyCode = 'EUR';
      ordWrapper.ownerId = spainUser.id;

      List<String> distIds2 = new List<String>();
      distIds2.add(disbj.id);
      List<String> divIds2 = new List<String>();
      divIds2.add(divsn.id);

      ordWrapper.distributionChanlIds = distIds2;
      ordWrapper.divisionIds = divIds2;
      ordWrapper.lastItemNumber = 20;
    //  ordWrapper.countryWise_EOD = new List<Decimal>();
    //  ordWrapper.disable_EOD = false;
      ordWrapper.orderRaisedBy = 'Regional Manager';
      ordWrapper.managerId = sobj1.id;
      ordWrapper.countryHead = sobj1.id;
      

      BoliviaParaguaySOController.createNewSO(JSON.serialize(ordWrapper));
      BoliviaParaguaySOController.updateSalesOrder(JSON.serialize(ordWrapper));
      List<String> parentList = new List<String>();
      List<String> attachList = new List<String>();
      List<String> attachList2 = new List<String>();
      parentList.add(salesOrder.id);
      attachList.add(attach.Id);
      BoliviaParaguaySOController.saveChunk(JSON.serialize(parentList),'fileName','gdsytrsrthj','bdftytrdcu',JSON.serialize(attachList));
      BoliviaParaguaySOController.saveChunk(JSON.serialize(parentList),'fileName','gdsytrsrthj','bdftytrdcu',JSON.serialize(attachList2));
      BoliviaParaguaySOController.deleteLineItem(soLineItem1.id,'Sales Order', 0.0);
      BoliviaParaguaySOController.deleteLineItem(orderLineItem1.id,'Order', 0.0);
      BoliviaParaguaySOController.deleteAllLineItem(salesOrder.id, 'Sales Order');
      BoliviaParaguaySOController.deleteAllLineItem(order.id, 'Order');
      BoliviaParaguaySOController.getAccountDetails(acc.id);
      BoliviaParaguaySOController.setOrderFor('5361');
      Test.stopTest();
      
    }

    static testMethod void validateHelloWorld2() {

        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();

        Sales_Org__c sorg2 =new Sales_Org__c();
        sorg2.Name='5441';
        sorg2.Description__c='Paraguay';
        sorg2.Sales_Org_Code__c='5441';
        insert sorg2;

        Distribution_Channel__c disbj = new Distribution_Channel__c();
        disbj.Name = '20';                      
        disbj.Distribution_Channel_Code__c = '20';  
        disbj.Description__c='20';
        insert disbj;
        
        Division__c divsn = new Division__c();
        divsn.Name = '10';         
        divsn.Description__c = '10';    
        divsn.Division_Code__c = '10'; 
        insert divsn;        

        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZZOR';              
        ordType.Description__c = 'ZZOR';    
        ordType.Order_Type_Code__c = 'ZZOR';
        ordType.Combination_Key__c = 'ZZOR5441';
        insert ordType;

       
        Account acc = new Account();
        acc.Name='Nikhil';
        acc.Last_Name__c='Dhoke';
        //acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='8600000000';
        acc.Phone='020200000';
        acc.Sales_Org__c=sorg2.Id;
        acc.Division__c=divsn.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Mumbai';
        acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'ES51';
        //acc.Customer_Grp__c = cg.id;
        //  acc.OwnerId=sobj.Id;
        insert acc;

       Contact con = new Contact();
       con.AccountId=acc.Id;
       con.LastName=acc.Last_Name__c;
       con.MobilePhone ='9876543211';
       con.Phone = '5592619030';
       insert con;

       Contact con2 = new Contact();
       con2.AccountId=acc.Id;
       con2.LastName=acc.Last_Name__c;
        con2.MobilePhone ='9876543211';
       con2.Phone = '5592619030';
       insert con2;
       
       userrole  usrole = new userrole();
       usrole.Name ='Regional/Zonal Managers for Spain';
       
       Profile p = [SELECT Id,name FROM Profile WHERE Name = 'PartnerCommunity Distributor Profile'];

       User sobj1 = new User();
       sobj1.Alias = 'zonaa';                                                            
       sobj1.Email = 'ski4m@skinternational.com';                             
       sobj1.ProfileId  = p.ID;                                                     
       sobj1.Username = 'zonal2_aaexe1232@upl122333.com.devbox';                                    
       sobj1.IsActive = true;  
       sobj1.LastName='Terriotory Manager';
       sobj1.CommunityNickname = 'zonalExe1222 Di'; 
       sobj1.TimeZoneSidKey = 'Asia/Kolkata'; 
       sobj1.LocaleSidKey = 'en_IN';                                    
       sobj1.LanguageLocaleKey = 'en_US';                                             
       sobj1.ForecastEnabled = false;                                                     
       sobj1.EmailEncodingKey = 'ISO-8859-1';    
       sobj1.Show_Inventory__c = false;                                                     
       sobj1.Show_Credit_Limit__c = false; 
       sobj1.UserRoleId=usrole.id;
       sobj1.ContactId=con.Id;
       sobj1.Country = 'Vietnam';
       insert sobj1;
       
       User portUser = new User();
       portUser.Alias = 'zonaa01';                                                            
       portUser.Email = 'ski3@skinternational.com';                             
       portUser.ProfileId  = p.ID;                                                     
       portUser.Username = 'zonal03_aaexe1232@upl122333.com.devbox';                                    
       portUser.IsActive = true;  
       portUser.LastName='TM';
       portUser.CommunityNickname = 'zonal01Exe1222 Di'; 
       portUser.TimeZoneSidKey = 'Asia/Kolkata'; 
       // sobj1.Contact.AccountID = acc.id;// Time Zone
       portUser.LocaleSidKey = 'en_IN';                                    
       portUser.LanguageLocaleKey = 'en_US';                                             
       portUser.ForecastEnabled = false;                                                     
       portUser.EmailEncodingKey = 'ISO-8859-1';    
       portUser.Show_Inventory__c = false;                                                     
       portUser.Show_Credit_Limit__c = false; 
       portUser.UserRoleId=usrole.id;
       portUser.ContactId=con2.Id;
       portUser.Country = 'Vietnam';
       portUser.ManagerId = sobj1.Id;

       insert portUser;     

        RecordType shipLocRcdTp = [SELECT Id FROM RecordType WHERE name = 'Storage Location' and isActive = true LIMIT 1];
        RecordType depoRcdTp = [SELECT Id FROM RecordType WHERE name = 'Depot' and isActive = true LIMIT 1];      

        Depot__c storageLoc =new Depot__c ();
        storageLoc.Name='MAIN';
        storageLoc.recordtypeId=shipLocRcdTp.id;
        storageLoc.Country__c='Paraguay';
        storageLoc.Location__c='NORTE';
        storageLoc.Depot_Code__c='MAIN';
        storageLoc.SalesOrg__c = sorg2.ID;
        storageLoc.Plant_Desc__c= 'MAIN';
        storageLoc.Active__c = true;
        insert storageLoc;
        
        Depot__c depo =new Depot__c ();
        depo.Name='PY01';
        depo.recordtypeId=depoRcdTp.id;
        depo.Country__c='Paraguay';
        depo.Location__c='NORTE';
        depo.Depot_Code__c='PY01';
        depo.SalesOrg__c = sorg2.ID;
        depo.Plant_Desc__c= 'PY01';
        depo.Active__c = true;
        insert depo;      

        Shipping_Location__c shippLoc =new Shipping_Location__c();
        shippLoc.Location_Name__c ='Same as Billing Address'; 
        shippLoc.Region__c='Wadgoan Sheri,Nagar Rd, Aga Nagar,';
        shippLoc.Distributor__c=acc.Id;
        shippLoc.City__c='Pune';
        shippLoc.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc.SAP_Code__c='SAP996734';
        shippLoc.State__c='13';
        shippLoc.Country_Name__c = '';
        shippLoc.Country__c = 'Portugal';
        shippLoc.Pincode__c = '041523';
        shippLoc.Sales_Org__c = sorg2.id;
        shippLoc.Billing_Street_1__c = '';
        shippLoc.Billing_Street_2__c = '';
        shippLoc.Billing_Street_3__c = '';
        shippLoc.Billing_Street_4__c = '';
        shippLoc.Billing_Street_5__c = '';
        shippLoc.Billing_Street_6__c = '';
        insert shippLoc;

        Credit_Info__c crdIf = new Credit_Info__c();
        crdIf.Credit_Limit__c=1000;
        crdIf.Percentage_Used__c=100.0;
        crdIf.Allocated_Limit__c=0.0;
        crdIf.Distributor__c=acc.Id;
        crdIf.Distributor_Code__c='0001001225';
        crdIf.Sales_Org__c=sorg2.Id;
        crdIf.Internal_Limit__c=0.0;
        crdIf.Used_Limit__c=0.0;
        crdIf.Balance_Limit__c=0.0;
        insert crdIf;

        Outstanding_Ageing__c ostAg = new Outstanding_Ageing__c();
       // ostAg.OutstandingTotalGreaterthan90__c=0.0;
        ostAg.Net_Outstanding__c=0.0;
        ostAg.Customer_Code__c = acc.Id;
        ostAg.Sales_Org__c = sorg2.id;
        insert ostAg;

        Payments__c payC = new Payments__c();
        payC.Net_Overdue__c=0.0;
        payC.Customer_Name__c = acc.id;
        payC.Company_Code__c = sorg2.id;
        insert payC;

        DistributorSalesAreaMapping__c DSAM = new DistributorSalesAreaMapping__c(
            AccountType__c = 'Sold To Party',          // Account Type
            Distributor__c = acc.id,          // Distributor
            SalesOrg__c = sorg2.id,             // Sales Org
            OrderBlock__c = false,                       // Order Block
            //DistributionChannel__c = disbj.id,  // Distribution Channel
            //Division__c = Divbj2.id,             // Division
            AccountOwner__c = portUser.Id
            //PriceGroupMaster__c = priceGroup.id     // Price Group Master
          );
          insert DSAM;

        Product2 pro = new Product2();
        pro.ProductCode = '667000';
        pro.Product_Code__c='667000';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM00651000';
        insert pro;
        
        SKU__c sku = new SKU__c();
        sku.Name='DOST3';
        sku.SKU_Code__c='704003';
        sku.SKU_Pack__c=1.00;
        sku.SKU_UOM__c='L';
        sku.Multiple_Of__c=5;
        sku.Group__c='DOST3';
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = sorg2.Id;
        sku.UOM__c='L';
        sku.Division__c = divsn.id;
        sku.Distribution_Channel__c = disbj.id;
        sku.Active__c=True;
        sku.Combination_Key__c='Cooooooo000011113';
        insert sku;

        SKU__c sku2 = new SKU__c();
        sku2.Name='DOST4';
        sku2.SKU_Code__c='704004';
        sku2.SKU_Pack__c=1.00;
        sku2.SKU_UOM__c='KG';
        sku2.Multiple_Of__c=5;
        sku2.Group__c='DOST4';
        sku2.Pack_Size__c=10.00;
        sku2.Product_Name__c=pro.Id;
        sku2.Sales_Org__c = sorg2.Id;
        sku2.UOM__c='KG';
        sku2.Division__c = divsn.id;
        sku2.Distribution_Channel__c = disbj.id;
        sku2.Active__c=True;
        sku2.Combination_Key__c='Cooooooo000011114';
        insert sku2;

        Stock_Requirement__c stockReq = new Stock_Requirement__c(
            SKU__c = sku.id,             // SKU
            Depot__c = depo.id
        );
        insert stockReq;
        

        PriceBookMaster__c pbMaster = new PriceBookMaster__c(
          SKUCode__c = sku.id,                      // SKU Code
          Price__c = 45.00,                                    // Price / Max Price
          MinPrice__c = 10,
          DepotCode__c = depo.id,                    // Depot Code
          Final_Price__c = 0.00,                               // Final Price
          StartDate__c = system.today(),             // Start Date
          EndDate__c = system.today() + 1,              // End Date
          UOM__c = 'L',                                        // UOM
          Division__c = divsn.id,                     // Division
          DistributionChannel__c = disbj.id,          // Distribution Channel
          Active__c = true,                                    // Active
          PerUnit__c = 1,                                    // Per Unit
          CompositeKey__c = 'SW0625207010000000000006001071',  // CompositeKey
          Sales_Org__c = sorg2.id,                    // Sales Org
          Price_Book_Change__c = false                        // Price_Book_Change
         // Customized_Product__c = false                       // Customized Product
        );
        insert pbMaster;

        PriceBookMaster__c pbMaster2 = new PriceBookMaster__c(
          SKUCode__c = sku2.id,                      // SKU Code
          Price__c = 45.00,                                    // Price / Max Price
          MinPrice__c = 10,
          DepotCode__c = depo.id,                    // Depot Code
          Final_Price__c = 0.00,                               // Final Price
          StartDate__c = system.today(),             // Start Date
          EndDate__c = system.today() + 1,              // End Date
          UOM__c = 'L',                                        // UOM
          Division__c = divsn.id,                     // Division
          DistributionChannel__c = disbj.id,          // Distribution Channel
          Active__c = true,                                    // Active
          PerUnit__c = 1,                                    // Per Unit
          CompositeKey__c = 'SW0625207010000000000006001072',  // CompositeKey
          Sales_Org__c = sorg2.id,                    // Sales Org
          Price_Book_Change__c = false                        // Price_Book_Change
         // Customized_Product__c = false                       // Customized Product
        );
        insert pbMaster2;

        Order__c order = new Order__c(
          Order_Date__c = system.today(),      // Order Date
          Order_Type__c = ordType.Id,              // Order Type
          Order_Status__c = 'Draft',                   // Order Status
          Remarks__c = 'Test',                            // Remarks
          Price_Entry__c = 'Pre-uploaded',                // Price Entry
          Depot__c = depo.ID,                   // Depot
          Is_Express_Delivery_Italy__c = false,           // Is Express Delivery
          Date_of_Payment__c = system.today(),
          Type_of_Order__c = 'Regular',
          Sales_Org__c = sorg2.id,               // Sales Org
          Bill_To_Party__c = acc.id,           // Bill To Party
          Shipping_Location__c = shippLoc.id       // Shipping Location
        );
        insert order;

        OrderLineItem__c orderLineItem1 = new OrderLineItem__c(
          SKU_Name__c = sku.id,              // SKU Name
          Item_Number__c = '10',                        // Item Number
          UOM__c = 'L',                                 // UOM
          Quantity__c = 205.00,                       // Quantity
          Price__c = 10.00,                             // Price
          Order__c = order.id,                 // Order
          Net_Price__c = 1804.00,                       // Net Price
          Stock_Available__c = false,                   // Stock Available
          Distributor_Discount__c = 0,                  // Distributor Discount
          Material_Discount__c = 0,                     // Material Discount
          Campaign_Discount__c = 5,                     // Campaign Discount
          FinalPrice__c = 8.80,                         // FinalPrice
          Shipping_Date__c = system.today(),  // Shipping Date
          Apply_Rebate__c = false,                      // Apply Rebate
          multipleOf__c = 1,                          // multipleOf
          //Customized_Product__c = false,                // Customized Product
          Price_Book_Master__c = pbMaster.id,     // Price Book Master
          Apply_Campaign_Discount__c = true,            // Apply Campaign Discount
          Division__c = divsn.id,              // Division
          Distribution_Channel__c = disbj.id,  // Distribution Channel
          Actual_Discount__c = 1.20,                    // Actual Discount
          Edited_Discount__c = 1.20,                    // Edited Discount
          Line_Discount__c = 2.00,                      // Line Discount
          Volume_Discount__c = 5.00,                    // Volume Discount
          Actual_Campaign_Discount__c = 5.00,           // Actual Campaign Discount
          Actual_Line_Discount__c = 2.00,               // Actual Line Discount
          Actual_Volume_Discount__c = 5.00,             // Actual Volume Discount
          MaxPrice__c = 120,
          MinPrice__c = 10,
          Date_of_Payment__c = system.today()
        );
        insert orderLineItem1;

        OrderLineItem__c orderLineItem2 = new OrderLineItem__c(
          SKU_Name__c = sku2.id,              // SKU Name
          Item_Number__c = '10',                        // Item Number
          UOM__c = 'KG',                                 // UOM
          Quantity__c = 205.00,                       // Quantity
          Price__c = 10.00,                             // Price
          Order__c = order.id,                 // Order
          Net_Price__c = 1804.00,                       // Net Price
          Stock_Available__c = false,                   // Stock Available
          Distributor_Discount__c = 0,                  // Distributor Discount
          Material_Discount__c = 0,                     // Material Discount
          Campaign_Discount__c = 5,                     // Campaign Discount
          FinalPrice__c = 8.80,                         // FinalPrice
          Shipping_Date__c = system.today(),  // Shipping Date
          Apply_Rebate__c = false,                      // Apply Rebate
          multipleOf__c = 1,                          // multipleOf
          //Customized_Product__c = false,                // Customized Product
          Price_Book_Master__c = pbMaster2.id,     // Price Book Master
          Apply_Campaign_Discount__c = true,            // Apply Campaign Discount
          Division__c = divsn.id,              // Division
          Distribution_Channel__c = disbj.id,  // Distribution Channel
          Actual_Discount__c = 1.20,                    // Actual Discount
          Edited_Discount__c = 1.20,                    // Edited Discount
          Line_Discount__c = 2.00,                      // Line Discount
          Volume_Discount__c = 5.00,                    // Volume Discount
          Actual_Campaign_Discount__c = 5.00,           // Actual Campaign Discount
          Actual_Line_Discount__c = 2.00,               // Actual Line Discount
          Actual_Volume_Discount__c = 5.00,             // Actual Volume Discount
          MaxPrice__c = 120,
          MinPrice__c = 10,
          Date_of_Payment__c = system.today()
        );
        insert orderLineItem2;

        BoliviaParaguaySOController.setOrderFor('5441');
        BoliviaParaguaySOController.getOrderDetails(acc.id);
        //BoliviaParaguaySOController.getOrderForList('2520',acc.id);

   }
}