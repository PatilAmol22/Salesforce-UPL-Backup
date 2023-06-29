@isTest 
public class SpainPortugalSOControllerTest {
    static testMethod void validateHelloWorld() {

        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='2510';
        sorg.Description__c='Spain';
        sorg.Sales_Org_Code__c='2510';
        insert sorg;

        Distribution_Channel__c disbj = new Distribution_Channel__c();
        disbj.Name = '10';                      
        disbj.Distribution_Channel_Code__c = '10';  
        disbj.Description__c='10';
        disbj.Sales_Org__c = sorg.id;
        insert disbj;
        
        Division__c divsn = new Division__c();
        divsn.Name = '10';         
        divsn.Description__c = '10';    
        divsn.Division_Code__c = '10'; 
        insert divsn;

        Division__c divsn2 = new Division__c();
        divsn2.Name = '60';         
        divsn2.Description__c = '60';    
        divsn2.Division_Code__c = '60'; 
        insert divsn2;

        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZZOD';              
        ordType.Description__c = 'ZZOD';    
        ordType.Order_Type_Code__c = 'ZZOD';
        insert ordType;

        Inco_Term__c incoTerm = new Inco_Term__c(
          Name = 'CPT',                    // Inco Term Name
          IncoTerm_Desc__c = 'CPT',          // IncoTerm Desc
          IncoTerm_Code__c = 'CPT1',          // IncoTerm Code
          Sales_Org__c = sorg.id,  // Sales Org
          Active__c = true,                  // Active
          Combination_Key__c = '2510CPT1'    // Combination Key
        );
        insert incoTerm;

      Payment_Term__c payTerm = new Payment_Term__c(
        Payment_Term__c = 'Pagadero inmediatamente sin DPP Undo',// Payment Term
        Payment_Term_Code__c = '2020',                             // Payment Term Code
        Payterms_Desc__c = 'Pagadero inmediatamente sin DPP',      // Payterms Desc
        Sales_Org__c = sorg.id,                          // Sales Org
        Active__c = true,                                         // Active
        CombinationKey__c = '25102020'                            // CombinationKey
      );
      insert payTerm;

      Payment_Method__c payMethod = new Payment_Method__c(
        Name = 'CHEQUE',                 // Payment Method Name
        Sales_Org__c = sorg.id,  // Sales Org
        Payment_Method_Code__c = 'C1',      // Payment Method Code
        Active__c = true,                  // Active
        Combination_Key__c = '2010C1'      // Combination Key
      );
      insert payMethod;

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
        acc.Depot_Code__c = 'ES51';
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
        spainUser.Country = 'Spain';
        spainUser.ManagerId = sobj1.Id;
        spainUser.Country_Head__c = sobj1.Id;
        insert spainUser;       

        RecordType shipLocRcdTp = [SELECT Id FROM RecordType WHERE name = 'Storage Location' and isActive = true LIMIT 1];
        
        Depot__c shippingPoint =new Depot__c ();
        shippingPoint.Name='SW06';
        shippingPoint.recordtypeId=shipLocRcdTp.id;
        shippingPoint.Country__c='Spain';
        shippingPoint.Location__c='NORTE';
        shippingPoint.Depot_Code__c='SW06';
        shippingPoint.SalesOrg__c = sorg.ID;
        shippingPoint.Shipping_Point__c ='ES29';
        shippingPoint.Plant_Desc__c= '';
        shippingPoint.Active__c = true;
        insert shippingPoint;

        Depot__c storageLoc =new Depot__c ();
        storageLoc.Name='SW16';
        storageLoc.recordtypeId=shipLocRcdTp.id;
        storageLoc.Country__c='Spain';
        storageLoc.Location__c='NORTE';
        storageLoc.Depot_Code__c='CR00';
        storageLoc.SalesOrg__c = sorg.ID;
        storageLoc.Plant_Desc__c= '';
        storageLoc.Active__c = true;
        insert storageLoc;

        Depot__c depo =new Depot__c ();
        depo.Name='ES51';
        depo.recordtypeId=shipLocRcdTp.id;
        depo.Country__c='Spain';
        depo.Location__c='NORTE';
        depo.Depot_Code__c='ES51';
        depo.SalesOrg__c = sorg.ID;
        depo.Plant_Desc__c= 'ES51';
        depo.Active__c = true;
        depo.Combination_key_Storage_Location__c = 'SW16ES51';
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
        shippLoc.Country__c = 'Spain';
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
		
        Inventory__c inv1 = new Inventory__c();    
      	inv1.Stock_Quantity__c = 10;   
        inv1.Batch_Number__c = 'CMUMTX2503'; 
        inv1.Depot__c = depo.Id;    
        inv1.UOM__c = 'BT';   
        inv1.SKU__c = sku.Id;
        inv1.Storage_Location__c = 'MAIN';  
        inv1.SKU_Depot__c ='sd1'; 
        inv1.Storage_Location_Depot__c = depo.id;
        
        insert inv1;
        
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

        Spain_Portugal_Campaign__c campaign = new Spain_Portugal_Campaign__c(
        Name = 'Spain',                     // Spain Portugal Campaign Name
        Start_Date__c =system.today(),  // Start Date
        End_Date__c = system.today() +1,   // End Date
        CompositeKey__c = 'C0020',                 // CompositeKey
        Status__c = 'Active'                      // Status
        );
        insert campaign;

        PricebookDiscount__c pbDiscount = new PricebookDiscount__c(
        Division__c = divsn.id,                              // Division
        SKUCode__c = sku.id,                                 // SKU Code
        DistributionChannel__c = disbj.id,                     // Distribution Channel
        Active__c = true,                                               // Active
        Spain_Portugal_Campaign__c = campaign.id,                 // Spain Portugal Campaign
        Distributor_Discount__c = 5.00,                                 // Distributor Discount
        Sales_Org__c = sorg.Id,                               // Sales Org
        CompositeKey__c = '2020-09-03C002025207010000000000006001071',  // CompositeKey
        DepotCode__c = depo.id,                               // Depot Code
        StartDate__c = system.today(),                        // Start Date
        EndDate__c = system.today() +1                        // End Date
        );
        insert pbDiscount;

        PricebookDiscount__c pbDiscount2 = new PricebookDiscount__c(
        Division__c = divsn2.id,                              // Division
        SKUCode__c = sku2.id,                                 // SKU Code
        DistributionChannel__c = disbj.id,                     // Distribution Channel
        Active__c = true,                                               // Active
        Spain_Portugal_Campaign__c = campaign.id,                 // Spain Portugal Campaign
        Distributor_Discount__c = 5.00,                                 // Distributor Discount
        Sales_Org__c = sorg.Id,                               // Sales Org
        CompositeKey__c = '2020-09-03C002025207010000000000006001072',  // CompositeKey
        DepotCode__c = depo.id,                               // Depot Code
        StartDate__c = system.today(),                        // Start Date
        EndDate__c = system.today() +1                        // End Date
        );
        insert pbDiscount2;

        SpecialInvoiceDiscount__c splInvDis = new SpecialInvoiceDiscount__c(
        Active__c = true,                          // Active
        Division__c = divsn.id,             // Division
        Batch__c = 'Portugal 5',                     // Batch
        DistributionChannel__c = disbj.id,  // Distribution Channel
        DepotCode__c = depo.id,            // Depot Code
        Price__c = 500.00,                           // Discount Price
        EndDate__c = system.today()+1,      // End Date
        SKUCode__c = sku.id,              // SKU Code
        StartDate__c = system.today(),     // Start Date
        UOM__c = 'L',                                // UOM
        CompositeKey__c = '000000000006001080',      // CompositeKey
        Sales_Org__c = sorg.Id,            // Sales Org
        Discount__c = 5.00                          // Discount
        );
        insert splInvDis;

        SpecialInvoiceDiscount__c splInvDis2 = new SpecialInvoiceDiscount__c(
        Active__c = true,                          // Active
        Division__c = divsn2.id,             // Division
        Batch__c = 'Portugal 5',                     // Batch
        DistributionChannel__c = disbj.id,  // Distribution Channel
        DepotCode__c = depo.id,            // Depot Code
        Price__c = 500.00,                           // Discount Price
        EndDate__c = system.today() +1,      // End Date
        SKUCode__c = sku2.id,              // SKU Code
        StartDate__c = system.today(),     // Start Date
        UOM__c = 'KG',                                // UOM
        CompositeKey__c = '000000000006001081',      // CompositeKey
        Sales_Org__c = sorg.Id,            // Sales Org
        Discount__c = 5.00                          // Discount
        );
        insert splInvDis2;

        ZSP1_Discount__c zspDisc = new ZSP1_Discount__c(
        Active__c = true,                          // Active
        Batch__c = 'POrtugal 4',                     // Batch
        CompositeKey__c = '000000000006001145',      // CompositeKey
        DepotCode__c = depo.id,            // Depot Code
        Price__c = 200.00,                           // Discount Price
        DistributionChannel__c = disbj.id,  // Distribution Channel
        Division__c = divsn.id,             // Division
        EndDate__c = system.today()+1,      // End Date
        Sales_Org__c = sorg.Id,            // Sales Org
        SKUCode__c = sku.id,              // SKU Code
        StartDate__c = system.today(),     // Start Date
        UOM__c = 'L',                                // UOM
        Discount__c = 2.00                          // Discount
        );
        insert zspDisc;

        ZSP1_Discount__c zspDisc2 = new ZSP1_Discount__c(
        Active__c = true,                          // Active
        Batch__c = 'POrtugal 4',                     // Batch
        CompositeKey__c = '000000000006001146',      // CompositeKey
        DepotCode__c = depo.id,            // Depot Code
        Price__c = 200.00,                           // Discount Price
        DistributionChannel__c = disbj.id,  // Distribution Channel
        Division__c = divsn2.id,             // Division
        EndDate__c = system.today()+1,      // End Date
        Sales_Org__c = sorg.Id,            // Sales Org
        SKUCode__c = sku2.id,              // SKU Code
        StartDate__c = system.today(),     // Start Date
        UOM__c = 'KG',                                // UOM
        Discount__c = 2.00                          // Discount
        );
        insert zspDisc2;

        Stock_Requirement__c stockReq = new Stock_Requirement__c(
        SKU__c = sku.id,             // SKU
        Depot__c = depo.id,             // Depot
        Unrestricted_Stock__c = 0.00,           // Unrestricted Stock
        Sales_Order_Stock__c = 0.00,            // Sales Order Stock
        Delivery_Stock__c = 0.00,               // Delivery Stock
        Purchase_Order_Stock__c = 0.00,         // Purchase Order Stock
        Stock_In_Transit__c = 0.00,             // Stock In Transit
        UOM__c = 'L',                             // UOM
        Combination_Key__c = depo.Name+''+storageLoc.Name,          // Combination Key
        Net_Stock_Italy__c = 0.00,              // Net Stock Italy
        Outgoing_Reservations_Italy__c = 0.00  // Outgoing Reservations Italy
        );
        insert stockReq;

        Stock_Requirement__c stockReq2 = new Stock_Requirement__c(
        SKU__c = sku2.id,             // SKU
        Depot__c = depo.id,             // Depot
        Unrestricted_Stock__c = 0.00,           // Unrestricted Stock
        Sales_Order_Stock__c = 0.00,            // Sales Order Stock
        Delivery_Stock__c = 0.00,               // Delivery Stock
        Purchase_Order_Stock__c = 0.00,         // Purchase Order Stock
        Stock_In_Transit__c = 0.00,             // Stock In Transit
        UOM__c = 'KG',                             // UOM
       // Combination_Key__c = depo.Name+''+storageLoc.Name,          // Combination Key
        Net_Stock_Italy__c = 0.00,              // Net Stock Italy
        Outgoing_Reservations_Italy__c = 0.00  // Outgoing Reservations Italy
        );
        insert stockReq2;

        PriceBookMaster__c pbMaster = new PriceBookMaster__c(
          SKUCode__c = sku.id,                      // SKU Code
          Price__c = 45.00,                                    // Price / Max Price
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
          DepotCode__c = depo.id,                    // Depot Code
          Final_Price__c = 0.00,                               // Final Price
          StartDate__c = system.today(),             // Start Date
          EndDate__c = system.today() + 1,              // End Date
          UOM__c = 'L',                                        // UOM
          Division__c = divsn2.id,                     // Division
          DistributionChannel__c = disbj.id,          // Distribution Channel
          Active__c = true,                                    // Active
          PerUnit__c = 1,                                    // Per Unit
          CompositeKey__c = 'SW0625207010000000000006001072',  // CompositeKey
          Sales_Org__c = sorg.id,                    // Sales Org
          Price_Book_Change__c = false                        // Price_Book_Change
          //Customized_Product__c = false                       // Customized Product
        );
        insert pbMaster2;

        Early_Order_Discount__c eod = new Early_Order_Discount__c(
          Name = 'Spain',
          Discount__c = 2
        );
        insert eod;

        Early_Order_Discount__c eod2 = new Early_Order_Discount__c(
          Name = 'Portugal',
          Discount__c = 2
        );
        insert eod2;

       

        Order__c order = new Order__c(
          Order_Date__c = system.today(),      // Order Date
          Order_Type__c = ordType.Id,              // Order Type
          Order_Status__c = 'Draft',                   // Order Status
          Remarks__c = 'Test',                            // Remarks
          Price_Entry__c = 'Pre-uploaded',                // Price Entry
          Depot__c = depo.ID,                   // Depot
          Is_Express_Delivery_Italy__c = false,           // Is Express Delivery
          Early_Order_Discount__c = 2.00,                 // Early Order Discount
          Gross_Amount_With_Early_Discount__c = 1767.92,  // Gross Amount With Early Discount
          Sales_Org__c = sorg.id,               // Sales Org
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
          Actual_Volume_Discount__c = 5.00             // Actual Volume Discount
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
          Division__c = divsn2.id,              // Division
          Distribution_Channel__c = disbj.id,  // Distribution Channel
          Actual_Discount__c = 1.20,                    // Actual Discount
          Edited_Discount__c = 1.20,                    // Edited Discount
          Line_Discount__c = 2.00,                      // Line Discount
          Volume_Discount__c = 5.00,                    // Volume Discount
          Actual_Campaign_Discount__c = 5.00,           // Actual Campaign Discount
          Actual_Line_Discount__c = 2.00,               // Actual Line Discount
          Actual_Volume_Discount__c = 5.00             // Actual Volume Discount
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
          Gross_Amount_With_Early_Discount__c = 0
        );
        insert salesOrder;
        //List added by Aashima(Grazitti) for INC0416329 test class issue
      List<Sales_Order_Line_Item__c> soItemList=new List<Sales_Order_Line_Item__c>();
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
        Campaign__c = campaign.id,
        Pricebook_Discount_Id__c = pbDiscount.id
      );
      soItemList.add(soLineItem1);

      Sales_Order_Line_Item__c soLineItem2 = new Sales_Order_Line_Item__c(
        Order_Item_Key__c = '0109502021295420',     // OrderNumber_Item_Key
        Item_Number__c = 20,                        // Item Number
        UOM__c = 'KG',                                 // UOM
        DepotDepot__c = depo.id,            // Depot
        Sale_Order__c = salesOrder.id,            // Sales Order
        SKU_Name__c = sku2.id,              // SKU Name
        Item_Status__c = 'Active',                    // Item Status
        Division__c = divsn2.id,              // Division
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
        Campaign__c = campaign.id,
        Pricebook_Discount_Id__c = pbDiscount2.id
      );
      soItemList.add(soLineItem2);
     insert soItemList;
      Attachment attach = new Attachment(
      parentId = salesOrder.id,
      Body = EncodingUtil.base64Decode('fdestdctyrgdybdrtnuftyuytmiynu'),
      Name = 'fileName',
      ContentType = '.pdf');
      insert attach;

      SpainPortugalSOController.OrderWrapper ordWrapper = new SpainPortugalSOController.OrderWrapper();
      List<SpainPortugalSOController.OrderItemWrapper> ordItemWrapperList = new List<SpainPortugalSOController.OrderItemWrapper>();
      SpainPortugalSOController.OrderItemWrapper ordItemWrapper = new SpainPortugalSOController.OrderItemWrapper();
      ordItemWrapper.orderItem_id = orderLineItem1.id;
      ordItemWrapper.order_id = order.id;
      ordItemWrapper.pb_id = pbMaster.id;
      ordItemWrapper.sku_name = sku.Name;
      ordItemWrapper.sku_id = sku.id;
      ordItemWrapper.uom = sku.UOM__c;
      ordItemWrapper.campaign_nm = campaign.Name;
      ordItemWrapper.campaign_id = campaign.id;
      ordItemWrapper.base_price = 0.0;
      ordItemWrapper.apply_cmpgn_disc = false;
      ordItemWrapper.campaign_discount = 0.0;
      ordItemWrapper.line_discount = 0.0;
      ordItemWrapper.volume_discount = 0.0;
      ordItemWrapper.quantity = 0.0;
      ordItemWrapper.final_price = 0.0;
      ordItemWrapper.net_price = 0.0;
      ordItemWrapper.shipmnt_date = String.valueOf(System.today());
      ordItemWrapper.inventory = 0.0;
      ordItemWrapper.actual_discount = 0.0;
      ordItemWrapper.edited_discount = 0.0;
      ordItemWrapper.multiple_of = 0.0;
      ordItemWrapper.actual_campaign_discount = 0.0;
      ordItemWrapper.actual_line_discount = 0.0;
      ordItemWrapper.actual_volume_discount = 0.0;
      ordItemWrapper.pb_discount_id = pbDiscount.id;
      ordItemWrapper.distributionChanlIds = disbj.id;
      ordItemWrapper.divisionIds = divsn.id;
      ordItemWrapper.itemNumber = 10;
      ordItemWrapper.min_quantity = 0;
      ordItemWrapper.campaign_code = '';

      ordItemWrapperList.add(ordItemWrapper);

      ordItemWrapper = new SpainPortugalSOController.OrderItemWrapper();
      ordItemWrapper.orderItem_id = orderLineItem2.id;
      ordItemWrapper.order_id = order.id;
      ordItemWrapper.pb_id = pbMaster2.id;
      ordItemWrapper.sku_name = sku2.Name;
      ordItemWrapper.sku_id = sku2.id;
      ordItemWrapper.uom = sku2.UOM__c;
      ordItemWrapper.campaign_nm = campaign.Name;
      ordItemWrapper.campaign_id = campaign.id;
      ordItemWrapper.base_price = 0.0;
      ordItemWrapper.apply_cmpgn_disc = false;
      ordItemWrapper.campaign_discount = 0.0;
      ordItemWrapper.line_discount = 0.0;
      ordItemWrapper.volume_discount = 0.0;
      ordItemWrapper.quantity = 0.0;
      ordItemWrapper.final_price = 0.0;
      ordItemWrapper.net_price = 0.0;
      ordItemWrapper.shipmnt_date = String.valueOf(System.today());
      ordItemWrapper.inventory = 0.0;
      ordItemWrapper.actual_discount = 0.0;
      ordItemWrapper.edited_discount = 0.0;
      ordItemWrapper.multiple_of = 0.0;
      ordItemWrapper.actual_campaign_discount = 0.0;
      ordItemWrapper.actual_line_discount = 0.0;
      ordItemWrapper.actual_volume_discount = 0.0;
      ordItemWrapper.pb_discount_id = pbDiscount2.id;
      ordItemWrapper.distributionChanlIds = disbj.id;
      ordItemWrapper.divisionIds = divsn2.id;
      ordItemWrapper.itemNumber = 20;
      ordItemWrapper.min_quantity = 0;
      ordItemWrapper.campaign_code = '';

      ordItemWrapperList.add(ordItemWrapper);

      ordWrapper.orderItemList = ordItemWrapperList;
      ordWrapper.orderFor = '2510';
      ordWrapper.account_Id = acc.id;
      ordWrapper.ordr_id = order.id;
      ordWrapper.so_id = '';
      ordWrapper.isSalesOrder = true;
      ordWrapper.early_ordr_discount = 0;
      ordWrapper.total_amount = 0.0;
      ordWrapper.gross_amount = 0.0;
      ordWrapper.uom_kg = '';
      ordWrapper.uom_bottle = '';
      ordWrapper.uom_litre = '';
      ordWrapper.net_price_kg = 0.0;
      ordWrapper.net_price_bottle = 0.0;
      ordWrapper.net_price_litre = 0.0;
      ordWrapper.quantity_kg = 0.0;
      ordWrapper.quantity_bottle = 0.0;
      ordWrapper.quantity_litre = 0.0;
      ordWrapper.inco_term = incoTerm.Name;
      ordWrapper.inco_term_id = incoTerm.id;
      ordWrapper.payment_method = payMethod.Name;
      ordWrapper.payment_method_id = payMethod.id;
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
      ordWrapper.Shipping_Point = shippingPoint.id;
      ordWrapper.Storage_Location = storageLoc.id;
      ordWrapper.CurrencyCode = 'EUR';
      ordWrapper.ownerId = spainUser.id;

      List<String> distIds = new List<String>();
      distIds.add(disbj.id);
      List<String> divIds = new List<String>();
      divIds.add(divsn.id);

      ordWrapper.distributionChanlIds = distIds;
      ordWrapper.divisionIds = divIds;
      ordWrapper.lastItemNumber = 20;
      ordWrapper.countryWise_EOD = new List<Decimal>();
      ordWrapper.disable_EOD = false;
      ordWrapper.orderRaisedBy = '';
      ordWrapper.managerId = sobj1.id;
      ordWrapper.countryHead = sobj1.id;

      //SpainPortugalSOController.getOrderDetails(acc.id);
      SpainPortugalSOController.getOrderDetails(salesOrder.id);
      //SpainPortugalSOController.getOrderForList('2510',acc.id);
      SpainPortugalSOController.getCampaignAndDiscount(sku.id,sorg.id,depo.id,disbj.id,divsn.id,depo.Name+''+storageLoc.Name);
      SpainPortugalSOController.getCampaignAndDiscount(sku2.id,sorg.id,depo.id,disbj.id,divsn2.id,depo.Name+''+storageLoc.Name);
      SpainPortugalSOController.createDraftOrder(JSON.serialize(ordWrapper));

      ordWrapper = new SpainPortugalSOController.OrderWrapper();
      ordItemWrapperList = new List<SpainPortugalSOController.OrderItemWrapper>();
      ordItemWrapper = new SpainPortugalSOController.OrderItemWrapper();

      ordItemWrapper.orderItem_id = soLineItem1.id;
      ordItemWrapper.order_id = order.id;
      ordItemWrapper.pb_id = pbMaster.id;
      ordItemWrapper.sku_name = sku.Name;
      ordItemWrapper.sku_id = sku.id;
      ordItemWrapper.uom = sku.UOM__c;
      ordItemWrapper.campaign_nm = campaign.Name;
      ordItemWrapper.campaign_id = campaign.id;
      ordItemWrapper.base_price = 100.0;
      ordItemWrapper.apply_cmpgn_disc = false;
      ordItemWrapper.campaign_discount = 1.0;
      ordItemWrapper.line_discount = 2.0;
      ordItemWrapper.volume_discount = 1.0;
      ordItemWrapper.quantity = 100.0;
      ordItemWrapper.final_price = 100.0;
      ordItemWrapper.net_price = 100.0;
      ordItemWrapper.shipmnt_date = String.valueOf(System.today());
      ordItemWrapper.inventory = 0.0;
      ordItemWrapper.actual_discount = 3.0;
      ordItemWrapper.edited_discount = 4.0;
      ordItemWrapper.multiple_of = 5.0;
      ordItemWrapper.actual_campaign_discount = 1.0;
      ordItemWrapper.actual_line_discount = 1.0;
      ordItemWrapper.actual_volume_discount = 1.0;
      ordItemWrapper.pb_discount_id = pbDiscount.id;
      ordItemWrapper.distributionChanlIds = disbj.id;
      ordItemWrapper.divisionIds = divsn.id;
      ordItemWrapper.itemNumber = 10;
      ordItemWrapper.min_quantity = 10;
      ordItemWrapper.campaign_code = '';

      ordItemWrapperList.add(ordItemWrapper);

      ordItemWrapper = new SpainPortugalSOController.OrderItemWrapper();
      ordItemWrapper.orderItem_id = soLineItem2.id;
      ordItemWrapper.order_id = order.id;
      ordItemWrapper.pb_id = pbMaster2.id;
      ordItemWrapper.sku_name = sku2.Name;
      ordItemWrapper.sku_id = sku2.id;
      ordItemWrapper.uom = sku2.UOM__c;
      ordItemWrapper.campaign_nm = campaign.Name;
      ordItemWrapper.campaign_id = campaign.id;
      ordItemWrapper.base_price = 100.0;
      ordItemWrapper.apply_cmpgn_disc = false;
      ordItemWrapper.campaign_discount = 1.0;
      ordItemWrapper.line_discount = 2.0;
      ordItemWrapper.volume_discount = 1.0;
      ordItemWrapper.quantity = 100.0;
      ordItemWrapper.final_price = 100.0;
      ordItemWrapper.net_price = 100.0;
      ordItemWrapper.shipmnt_date = String.valueOf(System.today());
      ordItemWrapper.inventory = 0.0;
      ordItemWrapper.actual_discount = 3.0;
      ordItemWrapper.edited_discount = 4.0;
      ordItemWrapper.multiple_of = 2.0;
      ordItemWrapper.actual_campaign_discount = 1.0;
      ordItemWrapper.actual_line_discount = 1.0;
      ordItemWrapper.actual_volume_discount = 1.0;
      ordItemWrapper.pb_discount_id = pbDiscount2.id;
      ordItemWrapper.distributionChanlIds = disbj.id;
      ordItemWrapper.divisionIds = divsn2.id;
      ordItemWrapper.itemNumber = 20;
      ordItemWrapper.min_quantity = 10;
      ordItemWrapper.campaign_code = '';

      ordItemWrapperList.add(ordItemWrapper);

      ordWrapper.orderItemList = ordItemWrapperList;
      ordWrapper.orderFor = '2510';
      ordWrapper.account_Id = acc.id;
      ordWrapper.ordr_id = order.id;
      ordWrapper.so_id = salesOrder.id;
      ordWrapper.isSalesOrder = true;
      ordWrapper.early_ordr_discount = 2;
      ordWrapper.total_amount = 1000.0;
      ordWrapper.gross_amount = 1000.0;
      ordWrapper.uom_kg = '';
      ordWrapper.uom_bottle = '';
      ordWrapper.uom_litre = '';
      ordWrapper.net_price_kg = 0.0;
      ordWrapper.net_price_bottle = 0.0;
      ordWrapper.net_price_litre = 0.0;
      ordWrapper.quantity_kg = 0.0;
      ordWrapper.quantity_bottle = 0.0;
      ordWrapper.quantity_litre = 0.0;
      ordWrapper.inco_term = incoTerm.Name;
      ordWrapper.inco_term_id = incoTerm.id;
      ordWrapper.payment_method = payMethod.Name;
      ordWrapper.payment_method_id = payMethod.id;
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
      ordWrapper.Shipping_Point = shippingPoint.id;
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
      ordWrapper.countryWise_EOD = new List<Decimal>();
      ordWrapper.disable_EOD = false;
      ordWrapper.orderRaisedBy = 'Regional Manager';
      ordWrapper.managerId = sobj1.id;
      ordWrapper.countryHead = sobj1.id;
      string tempName = 'DOST';

      Test.startTest();
      SpainPortugalSOController.createNewSO(JSON.serialize(ordWrapper),tempName);
      SpainPortugalSOController.updateSalesOrder(JSON.serialize(ordWrapper));
      List<String> parentList = new List<String>();
      List<String> attachList = new List<String>();
      List<String> attachList2 = new List<String>();
      parentList.add(salesOrder.id);
      attachList.add(attach.Id);
      SpainPortugalSOController.saveChunk(JSON.serialize(parentList),'fileName','gdsytrsrthj','bdftytrdcu',JSON.serialize(attachList));
      SpainPortugalSOController.saveChunk(JSON.serialize(parentList),'fileName','gdsytrsrthj','bdftytrdcu',JSON.serialize(attachList2));
      //SpainPortugalSOController.deleteLineItem(soLineItem1.id,'Sales Order', 0.0);
      SpainPortugalSOController.deleteLineItem(orderLineItem1.id,'Order', 0.0);
      SpainPortugalSOController.deleteAllLineItem(salesOrder.id, 'Sales Order');
      //SpainPortugalSOController.showOrderTemplates('SAP996734');
      OrderTemplate__c ordList = [SELECT Id, Name, DistributorCustomerCode__c,DistributorCustomerCode__r.name,DistributorCustomerCode__r.SAP_Code__c FROM OrderTemplate__c
                WHERE DistributorCustomerCode__r.SAP_Code__c='SAP996734' limit 1];
      String tempId = ordList.id;
     
      SpainPortugalSOController.loadTemplate(JSON.serialize(ordWrapper),tempId);
      SpainPortugalSOController.showOrderTemplates(acc.SAP_Code__c);  
      Test.stopTest();     
     // SpainPortugalSOController.deleteAllLineItem(order.id, 'Order');
      //SpainPortugalSOController.getAccountDetails(acc.id);
      //SpainPortugalSOController.setOrderFor('2510');
      //SpainPortugalSOController.setOrderFor('2520');
     //SpainPortugalSOController.setOrderFor('2541');
      
    }

    static testMethod void validateHelloWorld2() {

        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();

        Sales_Org__c sorg2 =new Sales_Org__c();
        sorg2.Name='2520';
        sorg2.Description__c='Portugal';
        sorg2.Sales_Org_Code__c='2520';
        insert sorg2;

        Distribution_Channel__c disbj = new Distribution_Channel__c();
        disbj.Name = '70';                      
        disbj.Distribution_Channel_Code__c = '70';  
        disbj.Description__c='70';
        insert disbj;
        
        Division__c divsn = new Division__c();
        divsn.Name = '10';         
        divsn.Description__c = '10';    
        divsn.Division_Code__c = '10'; 
        insert divsn;

        Division__c divsn2 = new Division__c();
        divsn2.Name = '60';         
        divsn2.Description__c = '60';    
        divsn2.Division_Code__c = '60'; 
        insert divsn2;

        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZQEX';              
        ordType.Description__c = 'ZQEX';    
        ordType.Order_Type_Code__c = 'ZQEX';
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
       portUser.Country = 'Portugal';
       portUser.ManagerId = sobj1.Id;
       insert portUser;     

        RecordType shipLocRcdTp = [SELECT Id FROM RecordType WHERE name = 'Storage Location' and isActive = true LIMIT 1];
        
        Depot__c shippingPoint =new Depot__c ();
        shippingPoint.Name='SW06';
        shippingPoint.recordtypeId=shipLocRcdTp.id;
        shippingPoint.Country__c='Portugal';
        shippingPoint.Location__c='NORTE';
        shippingPoint.Depot_Code__c='SW06';
        shippingPoint.SalesOrg__c = sorg2.ID;
        shippingPoint.Shipping_Point__c ='ES50';
        shippingPoint.Plant_Desc__c= '';
        shippingPoint.Active__c = true;
        insert shippingPoint;

        Depot__c storageLoc =new Depot__c ();
        storageLoc.Name='SW06';
        storageLoc.recordtypeId=shipLocRcdTp.id;
        storageLoc.Country__c='Portugal';
        storageLoc.Location__c='NORTE';
        storageLoc.Depot_Code__c='CR00';
        storageLoc.SalesOrg__c = sorg2.ID;
        storageLoc.Plant_Desc__c= '';
        storageLoc.Active__c = true;
        insert storageLoc;
        
        Depot__c depo =new Depot__c ();
        depo.Name='ES51';
        depo.recordtypeId=shipLocRcdTp.id;
        depo.Country__c='Portugal';
        depo.Location__c='NORTE';
        depo.Depot_Code__c='ES51';
        depo.SalesOrg__c = sorg2.ID;
        depo.Plant_Desc__c= '';
        depo.Active__c = true;
        depo.Combination_key_Storage_Location__c = 'SW16ES51';
        insert depo;      
      
      

        Inventory__c inv = new Inventory__c();
       
      	inv.Stock_Quantity__c = 10;   
        inv.Batch_Number__c = 'CMUMTX2506'; 
        inv.Depot__c = depo.Id;    
        inv.UOM__c = 'BT';                    
        inv.Storage_Location__c = 'MAIN';  
        inv.SKU_Depot__c ='sd1'; 
        insert inv;

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
        sku2.Division__c = divsn2.id;
        sku2.Distribution_Channel__c = disbj.id;
        sku2.Active__c=True;
        sku2.Combination_Key__c='Cooooooo000011114';
        insert sku2;

        Spain_Portugal_Campaign__c campaign = new Spain_Portugal_Campaign__c(
        Name = 'Portugal',                     // Spain Portugal Campaign Name
        Start_Date__c = system.today(),  // Start Date
        End_Date__c = system.today() + 1,   // End Date
        CompositeKey__c = 'C0021',                 // CompositeKey
        Status__c = 'Active'                      // Status
        );
        insert campaign;  

        PricebookDiscount__c pbDiscount = new PricebookDiscount__c(
        Division__c = divsn.id,                              // Division
        SKUCode__c = sku.id,                                 // SKU Code
        DistributionChannel__c = disbj.id,                     // Distribution Channel
        Active__c = true,                                               // Active
        Spain_Portugal_Campaign__c = campaign.id,                 // Spain Portugal Campaign
        Distributor_Discount__c = 5.00,                                 // Distributor Discount
        Sales_Org__c = sorg2.Id,                               // Sales Org
        CompositeKey__c = '2020-09-03C002025207010000000000006001071',  // CompositeKey
        DepotCode__c = depo.id,                               // Depot Code
        StartDate__c = system.today(),                        // Start Date
        EndDate__c = system.today()                        // End Date
        );
        insert pbDiscount;

        PricebookDiscount__c pbDiscount2 = new PricebookDiscount__c(
        Division__c = divsn2.id,                              // Division
        SKUCode__c = sku2.id,                                 // SKU Code
        DistributionChannel__c = disbj.id,                     // Distribution Channel
        Active__c = true,                                               // Active
        Spain_Portugal_Campaign__c = campaign.id,                 // Spain Portugal Campaign
        Distributor_Discount__c = 5.00,                                 // Distributor Discount
        Sales_Org__c = sorg2.Id,                               // Sales Org
        CompositeKey__c = '2020-09-03C002025207010000000000006001072',  // CompositeKey
        DepotCode__c = depo.id,                               // Depot Code
        StartDate__c = system.today(),                        // Start Date
        EndDate__c = system.today()                         // End Date
        );
        insert pbDiscount2;

        SpecialInvoiceDiscount__c splInvDis = new SpecialInvoiceDiscount__c(
        Active__c = true,                          // Active
        Division__c = divsn.id,             // Division
        Batch__c = 'Portugal 5',                     // Batch
        DistributionChannel__c = disbj.id,  // Distribution Channel
        DepotCode__c = depo.id,            // Depot Code
        Price__c = 500.00,                           // Discount Price
        EndDate__c = system.today()+1,      // End Date
        SKUCode__c = sku.id,              // SKU Code
        StartDate__c = system.today(),     // Start Date
        UOM__c = 'L',                                // UOM
        CompositeKey__c = '000000000006001071',      // CompositeKey
        Sales_Org__c = sorg2.Id,            // Sales Org
        Discount__c = 5.00                          // Discount
        );
        insert splInvDis;

        SpecialInvoiceDiscount__c splInvDis2 = new SpecialInvoiceDiscount__c(
        Active__c = true,                          // Active
        Division__c = divsn2.id,             // Division
        Batch__c = 'Portugal 5',                     // Batch
        DistributionChannel__c = disbj.id,  // Distribution Channel
        DepotCode__c = depo.id,            // Depot Code
        Price__c = 500.00,                           // Discount Price
        EndDate__c = system.today()+1,      // End Date
        SKUCode__c = sku2.id,              // SKU Code
        StartDate__c = system.today(),     // Start Date
        UOM__c = 'KG',                                // UOM
        CompositeKey__c = '000000000006001072',      // CompositeKey
        Sales_Org__c = sorg2.Id,            // Sales Org
        Discount__c = 5.00                          // Discount
        );
        insert splInvDis2;

        ZSP1_Discount__c zspDisc = new ZSP1_Discount__c(
        Active__c = true,                          // Active
        Batch__c = 'POrtugal 4',                     // Batch
        CompositeKey__c = '000000000006001135',      // CompositeKey
        DepotCode__c = depo.id,            // Depot Code
        Price__c = 200.00,                           // Discount Price
        DistributionChannel__c = disbj.id,  // Distribution Channel
        Division__c = divsn.id,             // Division
        EndDate__c = system.today(),      // End Date
        Sales_Org__c = sorg2.Id,            // Sales Org
        SKUCode__c = sku.id,              // SKU Code
        StartDate__c = system.today(),     // Start Date
        UOM__c = 'L',                                // UOM
        Discount__c = 2.00                          // Discount
        );
        insert zspDisc;

        ZSP1_Discount__c zspDisc2 = new ZSP1_Discount__c(
        Active__c = true,                          // Active
        Batch__c = 'POrtugal 4',                     // Batch
        CompositeKey__c = '000000000006001136',      // CompositeKey
        DepotCode__c = depo.id,            // Depot Code
        Price__c = 200.00,                           // Discount Price
        DistributionChannel__c = disbj.id,  // Distribution Channel
        Division__c = divsn2.id,             // Division
        EndDate__c = system.today(),      // End Date
        Sales_Org__c = sorg2.Id,            // Sales Org
        SKUCode__c = sku2.id,              // SKU Code
        StartDate__c =system.today(),     // Start Date
        UOM__c = 'KG',                                // UOM
        Discount__c = 2.00                          // Discount
        );
        insert zspDisc2;

        Stock_Requirement__c stockReq = new Stock_Requirement__c(
        SKU__c = sku.id,             // SKU
        Depot__c = depo.id,             // Depot
        Unrestricted_Stock__c = 0.00,           // Unrestricted Stock
        Sales_Order_Stock__c = 0.00,            // Sales Order Stock
        Delivery_Stock__c = 0.00,               // Delivery Stock
        Purchase_Order_Stock__c = 0.00,         // Purchase Order Stock
        Stock_In_Transit__c = 0.00,             // Stock In Transit
        UOM__c = 'L',                             // UOM
        Combination_Key__c = depo.Name+''+storageLoc.Name,          // Combination Key
        Net_Stock_Italy__c = 0.00,              // Net Stock Italy
        Outgoing_Reservations_Italy__c = 0.00  // Outgoing Reservations Italy
        );
        insert stockReq;

        Stock_Requirement__c stockReq2 = new Stock_Requirement__c(
        SKU__c = sku2.id,             // SKU
        Depot__c = depo.id,             // Depot
        Unrestricted_Stock__c = 0.00,           // Unrestricted Stock
        Sales_Order_Stock__c = 0.00,            // Sales Order Stock
        Delivery_Stock__c = 0.00,               // Delivery Stock
        Purchase_Order_Stock__c = 0.00,         // Purchase Order Stock
        Stock_In_Transit__c = 0.00,             // Stock In Transit
        UOM__c = 'KG',                             // UOM
       // Combination_Key__c = depo.Name+''+storageLoc.Name,          // Combination Key
        Net_Stock_Italy__c = 0.00,              // Net Stock Italy
        Outgoing_Reservations_Italy__c = 0.00  // Outgoing Reservations Italy
        );
        insert stockReq2;

        PriceBookMaster__c pbMaster = new PriceBookMaster__c(
          SKUCode__c = sku.id,                      // SKU Code
          Price__c = 45.00,                                    // Price / Max Price
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
          DepotCode__c = depo.id,                    // Depot Code
          Final_Price__c = 0.00,                               // Final Price
          StartDate__c = system.today(),             // Start Date
          EndDate__c = system.today() + 1,              // End Date
          UOM__c = 'L',                                        // UOM
          Division__c = divsn2.id,                     // Division
          DistributionChannel__c = disbj.id,          // Distribution Channel
          Active__c = true,                                    // Active
          PerUnit__c = 1,                                    // Per Unit
          CompositeKey__c = 'SW0625207010000000000006001072',  // CompositeKey
          Sales_Org__c = sorg2.id,                    // Sales Org
          Price_Book_Change__c = false                        // Price_Book_Change
         // Customized_Product__c = false                       // Customized Product
        );
        insert pbMaster2;

        Early_Order_Discount__c eod = new Early_Order_Discount__c(
          Name = 'Spain',
          Discount__c = 2
        );
        insert eod;

        Early_Order_Discount__c eod2 = new Early_Order_Discount__c(
          Name = 'Portugal',
          Discount__c = 2
        );
        insert eod2;

        Order__c order = new Order__c(
          Order_Date__c = system.today(),      // Order Date
          Order_Type__c = ordType.Id,              // Order Type
          Order_Status__c = 'Draft',                   // Order Status
          Remarks__c = 'Test',                            // Remarks
          Price_Entry__c = 'Pre-uploaded',                // Price Entry
          Depot__c = depo.ID,                   // Depot
          Is_Express_Delivery_Italy__c = false,           // Is Express Delivery
          Early_Order_Discount__c = 2.00,                 // Early Order Discount
          Gross_Amount_With_Early_Discount__c = 1767.92,  // Gross Amount With Early Discount
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
          Actual_Volume_Discount__c = 5.00             // Actual Volume Discount
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
          Division__c = divsn2.id,              // Division
          Distribution_Channel__c = disbj.id,  // Distribution Channel
          Actual_Discount__c = 1.20,                    // Actual Discount
          Edited_Discount__c = 1.20,                    // Edited Discount
          Line_Discount__c = 2.00,                      // Line Discount
          Volume_Discount__c = 5.00,                    // Volume Discount
          Actual_Campaign_Discount__c = 5.00,           // Actual Campaign Discount
          Actual_Line_Discount__c = 2.00,               // Actual Line Discount
          Actual_Volume_Discount__c = 5.00             // Actual Volume Discount
        );
        insert orderLineItem2;
 
       
        
        SpainPortugalSOController.setOrderFor('2520');
        SpainPortugalSOController.setOrderFor('2541');
        SpainPortugalSOController.getOrderDetails(acc.id);
        SpainPortugalSOController.deleteAllLineItem(order.id, 'Order');
        
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
          Sales_Org_lk__c = sorg2.id,                 // Sales Org
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
          Gross_Amount_With_Early_Discount__c = 0
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
        Campaign__c = campaign.id,
        Pricebook_Discount_Id__c = pbDiscount.id
      );
     insert soLineItem1;
       
        SpainPortugalSOController.deleteLineItem(soLineItem1.id,'Sales Order', 0.0);

        //SpainPortugalSOController.getOrderForList('2520',acc.id);

   }
    
    static testMethod void validateTestCase3(){
           
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='2481';
        sorg.Description__c='Spain';
        sorg.Sales_Org_Code__c='2481';
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

        Division__c divsn2 = new Division__c();
        divsn2.Name = '60';         
        divsn2.Description__c = '60';    
        divsn2.Division_Code__c = '60'; 
        insert divsn2;

        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZZOD';              
        ordType.Description__c = 'ZZOD';    
        ordType.Order_Type_Code__c = 'ZZOD';
        insert ordType;

        Inco_Term__c incoTerm = new Inco_Term__c(
          Name = 'CPT',                    // Inco Term Name
          IncoTerm_Desc__c = 'CPT',          // IncoTerm Desc
          IncoTerm_Code__c = 'CPT1',          // IncoTerm Code
          Sales_Org__c = sorg.id,  // Sales Org
          Active__c = true,                  // Active
          Combination_Key__c = '2510CPT1'    // Combination Key
        );
        insert incoTerm;

      Payment_Term__c payTerm = new Payment_Term__c(
        Payment_Term__c = 'Pagadero inmediatamente sin DPP Undo',// Payment Term
        Payment_Term_Code__c = '2020',                             // Payment Term Code
        Payterms_Desc__c = 'Pagadero inmediatamente sin DPP',      // Payterms Desc
        Sales_Org__c = sorg.id,                          // Sales Org
        Active__c = true,                                         // Active
        CombinationKey__c = '25102020'                            // CombinationKey
      );
      insert payTerm;

      Payment_Method__c payMethod = new Payment_Method__c(
        Name = 'CHEQUE',                 // Payment Method Name
        Sales_Org__c = sorg.id,  // Sales Org
        Payment_Method_Code__c = 'C1',      // Payment Method Code
        Active__c = true,                  // Active
        Combination_Key__c = '2010C1'      // Combination Key
      );
      insert payMethod;

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
        acc.Depot_Code__c = 'ES51';
        acc.Inco_Term__c = incoTerm.Id;
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
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Regional Manager/Sales Reps Spain'];

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
       // sobj1.ContactId=con.Id;
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
        //spainUser.ContactId=con2.Id;
        spainUser.Country = 'Spain';
        spainUser.ManagerId = sobj1.Id;
        spainUser.Country_Head__c = sobj1.Id;
        insert spainUser;       

        RecordType shipLocRcdTp = [SELECT Id FROM RecordType WHERE name = 'Storage Location' and isActive = true LIMIT 1];
        
        Depot__c shippingPoint =new Depot__c ();
        shippingPoint.Name='SW06';
        shippingPoint.recordtypeId=shipLocRcdTp.id;
        shippingPoint.Country__c='Spain';
        shippingPoint.Location__c='NORTE';
        shippingPoint.Depot_Code__c='SW06';
        shippingPoint.SalesOrg__c = sorg.ID;
        shippingPoint.Shipping_Point__c ='PT00';
        shippingPoint.Plant_Desc__c= '';
        shippingPoint.Active__c = true;
        insert shippingPoint;

        Depot__c storageLoc =new Depot__c ();
        storageLoc.Name='SW06';
        storageLoc.recordtypeId=shipLocRcdTp.id;
        storageLoc.Country__c='Spain';
        storageLoc.Location__c='NORTE';
        storageLoc.Depot_Code__c='WL01';
        storageLoc.SalesOrg__c = sorg.ID;
        storageLoc.Plant_Desc__c= '';
        storageLoc.Active__c = true;
        insert storageLoc;

        Depot__c depo =new Depot__c ();
        depo.Name='ES51';
        depo.recordtypeId=shipLocRcdTp.id;
        depo.Country__c='Spain';
        depo.Location__c='NORTE';
        depo.Depot_Code__c='ES51';
        depo.SalesOrg__c = sorg.ID;
        depo.Plant_Desc__c= 'ES51';
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
        shippLoc.Country__c = 'Spain';
        shippLoc.Pincode__c = '041523';
        shippLoc.Sales_Org__c = sorg.id;
        shippLoc.Billing_Street_1__c = 'ABC';
        shippLoc.Billing_Street_2__c = '';
        shippLoc.Billing_Street_3__c = '';
        shippLoc.Billing_Street_4__c = '';
        shippLoc.Billing_Street_5__c = '';
        shippLoc.Billing_Street_6__c = '';
        insert shippLoc;

        Shipping_Location__c shippLoc1 =new Shipping_Location__c();
        shippLoc1.Location_Name__c ='Same as current Address'; 
        shippLoc1.Region__c='Wadgoan Sheri,Nagar Rd, Aga,';
        shippLoc1.Distributor__c=acc.Id;
        shippLoc1.City__c='Pune';
        shippLoc1.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc1.SAP_Code__c='SAP996724';
        shippLoc1.State__c='';
        shippLoc1.Country_Name__c = '';
        shippLoc1.Country__c = 'Spain';
        shippLoc1.Pincode__c = '041523';
        shippLoc1.Sales_Org__c = sorg.id;
        shippLoc1.Billing_Street_1__c = '';
        shippLoc1.Billing_Street_2__c = 'PQR';
        shippLoc1.Billing_Street_3__c = '';
        shippLoc1.Billing_Street_4__c = '';
        shippLoc1.Billing_Street_5__c = '';
        shippLoc1.Billing_Street_6__c = '';
        insert shippLoc1;

        Shipping_Location__c shippLoc2 =new Shipping_Location__c();
        shippLoc2.Location_Name__c ='Same as current Address'; 
        shippLoc2.Region__c='Wadgoan Sheri,Nagar Rd, Aga,';
        shippLoc2.Distributor__c=acc.Id;
        shippLoc2.City__c='Pune';
        shippLoc2.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc2.SAP_Code__c='SAP996724';
        shippLoc2.State__c='13';
        shippLoc2.Country_Name__c = '';
        shippLoc2.Country__c = '';
        shippLoc2.Pincode__c = '041523';
        shippLoc2.Sales_Org__c = sorg.id;
        shippLoc2.Billing_Street_1__c = 'ABC';
        shippLoc2.Billing_Street_2__c = 'PQR';
        shippLoc2.Billing_Street_3__c = '';
        shippLoc2.Billing_Street_4__c = '';
        shippLoc2.Billing_Street_5__c = '';
        shippLoc2.Billing_Street_6__c = '';
        insert shippLoc2;

        Shipping_Location__c shippLoc3 =new Shipping_Location__c();
        shippLoc3.Location_Name__c ='Same as current Address'; 
        shippLoc3.Region__c='Wadgoan Sheri,Nagar Rd, Aga,';
        shippLoc3.Distributor__c=acc.Id;
        shippLoc3.City__c='Pune';
        shippLoc3.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc3.SAP_Code__c='SAP996724';
        shippLoc3.State__c='13';
        shippLoc3.Country_Name__c = '';
        shippLoc3.Country__c = 'Spain';
        shippLoc3.Pincode__c = '';
        shippLoc3.Sales_Org__c = sorg.id;
        shippLoc3.Billing_Street_1__c = 'ABC';
        shippLoc3.Billing_Street_2__c = 'PQR';
        shippLoc3.Billing_Street_3__c = 'LMN';
        shippLoc3.Billing_Street_4__c = '';
        shippLoc3.Billing_Street_5__c = '';
        shippLoc3.Billing_Street_6__c = '';
        insert shippLoc3;

        Shipping_Location__c shippLoc4 =new Shipping_Location__c();
        shippLoc4.Location_Name__c ='Same as current Address'; 
        shippLoc4.Region__c='Wadgoan Sheri,Nagar Rd, Aga,';
        shippLoc4.Distributor__c=acc.Id;
        shippLoc4.City__c='';
        shippLoc4.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc4.SAP_Code__c='SAP996724';
        shippLoc4.State__c='13';
        shippLoc4.Country_Name__c = '';
        shippLoc4.Country__c = 'Spain';
        shippLoc4.Pincode__c = '041523';
        shippLoc4.Sales_Org__c = sorg.id;
        shippLoc4.Billing_Street_1__c = 'AXC';
        shippLoc4.Billing_Street_2__c = 'ABC';
        shippLoc4.Billing_Street_3__c = 'DFG';
        shippLoc4.Billing_Street_4__c = 'xyz';
        shippLoc4.Billing_Street_5__c = '';
        shippLoc4.Billing_Street_6__c = '';
        insert shippLoc4;

        Shipping_Location__c shippLoc5 =new Shipping_Location__c();
        shippLoc5.Location_Name__c ='Same as current Address'; 
        shippLoc5.Region__c='';
        shippLoc5.Distributor__c=acc.Id;
        shippLoc5.City__c='';
        shippLoc5.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc5.SAP_Code__c='SAP996724';
        shippLoc5.State__c='13';
        shippLoc5.Country_Name__c = '';
        shippLoc5.Country__c = 'Spain';
        shippLoc5.Pincode__c = '041523';
        shippLoc5.Sales_Org__c = sorg.id;
        shippLoc5.Billing_Street_1__c = 'AXC';
        shippLoc5.Billing_Street_2__c = 'ABC';
        shippLoc5.Billing_Street_3__c = 'DFG';
        shippLoc5.Billing_Street_4__c = 'xyz';
        shippLoc5.Billing_Street_5__c = 'dfd';
        shippLoc5.Billing_Street_6__c = '';
        insert shippLoc5;

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

        Spain_Portugal_Campaign__c campaign = new Spain_Portugal_Campaign__c(
        Name = 'Spain',                     // Spain Portugal Campaign Name
        Start_Date__c =system.today(),  // Start Date
        End_Date__c = system.today() +1,   // End Date
        CompositeKey__c = 'C0020',                 // CompositeKey
        Status__c = 'Active'                      // Status
        );
        insert campaign;

        PricebookDiscount__c pbDiscount = new PricebookDiscount__c(
        Division__c = divsn.id,                              // Division
        SKUCode__c = sku.id,                                 // SKU Code
        DistributionChannel__c = disbj.id,                     // Distribution Channel
        Active__c = true,                                               // Active
        Spain_Portugal_Campaign__c = campaign.id,                 // Spain Portugal Campaign
        Distributor_Discount__c = 5.00,                                 // Distributor Discount
        Sales_Org__c = sorg.Id,                               // Sales Org
        CompositeKey__c = '2020-09-03C002025207010000000000006001071',  // CompositeKey
        DepotCode__c = depo.id,                               // Depot Code
        StartDate__c = system.today(),                        // Start Date
        EndDate__c = system.today() +1                        // End Date
        );
        insert pbDiscount;

        PricebookDiscount__c pbDiscount2 = new PricebookDiscount__c(
        Division__c = divsn2.id,                              // Division
        SKUCode__c = sku2.id,                                 // SKU Code
        DistributionChannel__c = disbj.id,                     // Distribution Channel
        Active__c = true,                                               // Active
        Spain_Portugal_Campaign__c = campaign.id,                 // Spain Portugal Campaign
        Distributor_Discount__c = 5.00,                                 // Distributor Discount
        Sales_Org__c = sorg.Id,                               // Sales Org
        CompositeKey__c = '2020-09-03C002025207010000000000006001072',  // CompositeKey
        DepotCode__c = depo.id,                               // Depot Code
        StartDate__c = system.today(),                        // Start Date
        EndDate__c = system.today() +1                        // End Date
        );
        insert pbDiscount2;

        SpecialInvoiceDiscount__c splInvDis = new SpecialInvoiceDiscount__c(
        Active__c = true,                          // Active
        Division__c = divsn.id,             // Division
        Batch__c = 'Portugal 5',                     // Batch
        DistributionChannel__c = disbj.id,  // Distribution Channel
        DepotCode__c = depo.id,            // Depot Code
        Price__c = 500.00,                           // Discount Price
        EndDate__c = system.today()+1,      // End Date
        SKUCode__c = sku.id,              // SKU Code
        StartDate__c = system.today(),     // Start Date
        UOM__c = 'L',                                // UOM
        CompositeKey__c = '000000000006001080',      // CompositeKey
        Sales_Org__c = sorg.Id,            // Sales Org
        Discount__c = 5.00                          // Discount
        );
        insert splInvDis;

        SpecialInvoiceDiscount__c splInvDis2 = new SpecialInvoiceDiscount__c(
        Active__c = true,                          // Active
        Division__c = divsn2.id,             // Division
        Batch__c = 'Portugal 5',                     // Batch
        DistributionChannel__c = disbj.id,  // Distribution Channel
        DepotCode__c = depo.id,            // Depot Code
        Price__c = 500.00,                           // Discount Price
        EndDate__c = system.today() +1,      // End Date
        SKUCode__c = sku2.id,              // SKU Code
        StartDate__c = system.today(),     // Start Date
        UOM__c = 'KG',                                // UOM
        CompositeKey__c = '000000000006001081',      // CompositeKey
        Sales_Org__c = sorg.Id,            // Sales Org
        Discount__c = 5.00                          // Discount
        );
        insert splInvDis2;

        ZSP1_Discount__c zspDisc = new ZSP1_Discount__c(
        Active__c = true,                          // Active
        Batch__c = 'POrtugal 4',                     // Batch
        CompositeKey__c = '000000000006001145',      // CompositeKey
        DepotCode__c = depo.id,            // Depot Code
        Price__c = 200.00,                           // Discount Price
        DistributionChannel__c = disbj.id,  // Distribution Channel
        Division__c = divsn.id,             // Division
        EndDate__c = system.today()+1,      // End Date
        Sales_Org__c = sorg.Id,            // Sales Org
        SKUCode__c = sku.id,              // SKU Code
        StartDate__c = system.today(),     // Start Date
        UOM__c = 'L',                                // UOM
        Discount__c = 2.00                          // Discount
        );
        insert zspDisc;

        ZSP1_Discount__c zspDisc2 = new ZSP1_Discount__c(
        Active__c = true,                          // Active
        Batch__c = 'POrtugal 4',                     // Batch
        CompositeKey__c = '000000000006001146',      // CompositeKey
        DepotCode__c = depo.id,            // Depot Code
        Price__c = 200.00,                           // Discount Price
        DistributionChannel__c = disbj.id,  // Distribution Channel
        Division__c = divsn2.id,             // Division
        EndDate__c = system.today()+1,      // End Date
        Sales_Org__c = sorg.Id,            // Sales Org
        SKUCode__c = sku2.id,              // SKU Code
        StartDate__c = system.today(),     // Start Date
        UOM__c = 'KG',                                // UOM
        Discount__c = 2.00                          // Discount
        );
        insert zspDisc2;

        Stock_Requirement__c stockReq = new Stock_Requirement__c(
        SKU__c = sku.id,             // SKU
        Depot__c = depo.id,             // Depot
        Unrestricted_Stock__c = 0.00,           // Unrestricted Stock
        Sales_Order_Stock__c = 0.00,            // Sales Order Stock
        Delivery_Stock__c = 0.00,               // Delivery Stock
        Purchase_Order_Stock__c = 0.00,         // Purchase Order Stock
        Stock_In_Transit__c = 0.00,             // Stock In Transit
        UOM__c = 'L',                             // UOM
        Combination_Key__c = depo.Name+''+storageLoc.Name,          // Combination Key
        Net_Stock_Italy__c = 0.00,              // Net Stock Italy
        Outgoing_Reservations_Italy__c = 0.00  // Outgoing Reservations Italy
        );
        insert stockReq;

        Stock_Requirement__c stockReq2 = new Stock_Requirement__c(
        SKU__c = sku2.id,             // SKU
        Depot__c = depo.id,             // Depot
        Unrestricted_Stock__c = 0.00,           // Unrestricted Stock
        Sales_Order_Stock__c = 0.00,            // Sales Order Stock
        Delivery_Stock__c = 0.00,               // Delivery Stock
        Purchase_Order_Stock__c = 0.00,         // Purchase Order Stock
        Stock_In_Transit__c = 0.00,             // Stock In Transit
        UOM__c = 'KG',                             // UOM
       // Combination_Key__c = depo.Name+''+storageLoc.Name,          // Combination Key
        Net_Stock_Italy__c = 0.00,              // Net Stock Italy
        Outgoing_Reservations_Italy__c = 0.00  // Outgoing Reservations Italy
        );
        insert stockReq2;

        PriceBookMaster__c pbMaster = new PriceBookMaster__c(
          SKUCode__c = sku.id,                      // SKU Code
          Price__c = 45.00,                                    // Price / Max Price
          DepotCode__c = depo.id,                    // Depot Code
          Final_Price__c = 0.00,                               // Final Price
          StartDate__c = system.today(),             // Start Date
          EndDate__c = system.today() + 1,              // End Date
          UOM__c = 'BT',                                        // UOM
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
          DepotCode__c = depo.id,                    // Depot Code
          Final_Price__c = 0.00,                               // Final Price
          StartDate__c = system.today(),             // Start Date
          EndDate__c = system.today() + 1,              // End Date
          UOM__c = 'BT',                                        // UOM
          Division__c = divsn2.id,                     // Division
          DistributionChannel__c = disbj.id,          // Distribution Channel
          Active__c = true,                                    // Active
          PerUnit__c = 1,                                    // Per Unit
          CompositeKey__c = 'SW0625207010000000000006001072',  // CompositeKey
          Sales_Org__c = sorg.id,                    // Sales Org
          Price_Book_Change__c = false                        // Price_Book_Change
          //Customized_Product__c = false                       // Customized Product
        );
        insert pbMaster2;

        Early_Order_Discount__c eod = new Early_Order_Discount__c(
          Name = 'Spain',
          Discount__c = 2
        );
        insert eod;

        Early_Order_Discount__c eod2 = new Early_Order_Discount__c(
          Name = 'Portugal',
          Discount__c = 2
        );
        insert eod2;
        
        Inventory__c inv = new Inventory__c();
       
      	inv.Stock_Quantity__c = 10;   
        inv.Batch_Number__c = 'CMUMTX2506'; 
        inv.Depot__c = depo.Id;    
        inv.UOM__c = 'BT';                    
        inv.Storage_Location__c = 'MAIN';  
        inv.SKU__c = sku.Id;  
        inv.SKU_Depot__c ='sd1';           
        insert inv;
        SpainPortugalSOController.OrderWrapper ordWrapper = new SpainPortugalSOController.OrderWrapper();
        ordWrapper.inco_term = incoTerm.Name;
        ordWrapper.inco_term_id = incoTerm.id;
        ordWrapper.payment_method = payMethod.Name;
        ordWrapper.payment_method_id = payMethod.id;
        ordWrapper.payment_term = payTerm.Name;
        ordWrapper.payment_term_id = payTerm.id;
     
      system.runAs(spainUser){
          SpainPortugalSOController.getOrderDetails(acc.id);
      }
      //SpainPortugalSOController.getOrderForList('2510',acc.id);
      SpainPortugalSOController.getCampaignAndDiscount(sku.id,sorg.id,depo.id,disbj.id,divsn.id,depo.Name+''+storageLoc.Name);
      SpainPortugalSOController.getCampaignAndDiscount(sku2.id,sorg.id,depo.id,disbj.id,divsn2.id,depo.Name+''+storageLoc.Name);
      SpainPortugalSOController.createDraftOrder(JSON.serialize(ordWrapper));

    
      
    }
    static testMethod void validateTestCase4(){
           
      Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
      
      Sales_Org__c sorg =new Sales_Org__c();
      sorg.Name='2481';
      sorg.Description__c='Spain';
      sorg.Sales_Org_Code__c='2481';
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

      Division__c divsn2 = new Division__c();
      divsn2.Name = '60';         
      divsn2.Description__c = '60';    
      divsn2.Division_Code__c = '60'; 
      insert divsn2;

      Order_Type__c ordType =new Order_Type__c();
      ordType.Name = 'ZZOD';              
      ordType.Description__c = 'ZZOD';    
      ordType.Order_Type_Code__c = 'ZZOD';
      insert ordType;

      Inco_Term__c incoTerm = new Inco_Term__c(
        Name = 'CPT',                    // Inco Term Name
        IncoTerm_Desc__c = 'CPT',          // IncoTerm Desc
        IncoTerm_Code__c = 'CPT1',          // IncoTerm Code
        Sales_Org__c = sorg.id,  // Sales Org
        Active__c = true,                  // Active
        Combination_Key__c = '2510CPT1'    // Combination Key
      );
      insert incoTerm;

    Payment_Term__c payTerm = new Payment_Term__c(
      Payment_Term__c = 'Pagadero inmediatamente sin DPP Undo',// Payment Term
      Payment_Term_Code__c = '2020',                             // Payment Term Code
      Payterms_Desc__c = 'Pagadero inmediatamente sin DPP',      // Payterms Desc
      Sales_Org__c = sorg.id,                          // Sales Org
      Active__c = true,                                         // Active
      CombinationKey__c = '25102020'                            // CombinationKey
    );
    insert payTerm;

    Payment_Method__c payMethod = new Payment_Method__c(
      Name = 'CHEQUE',                 // Payment Method Name
      Sales_Org__c = sorg.id,  // Sales Org
      Payment_Method_Code__c = 'C1',      // Payment Method Code
      Active__c = true,                  // Active
      Combination_Key__c = '2010C1'      // Combination Key
    );
    insert payMethod;

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
      acc.Depot_Code__c = 'ES51';
      acc.Inco_Term__c = incoTerm.Id;
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
      spainUser.Country = 'Spain';
      spainUser.ManagerId = sobj1.Id;
      spainUser.Country_Head__c = sobj1.Id;
      insert spainUser;       

      RecordType shipLocRcdTp = [SELECT Id FROM RecordType WHERE name = 'Storage Location' and isActive = true LIMIT 1];
      
      Depot__c shippingPoint =new Depot__c ();
      shippingPoint.Name='SW06';
      shippingPoint.recordtypeId=shipLocRcdTp.id;
      shippingPoint.Country__c='Spain';
      shippingPoint.Location__c='NORTE';
      shippingPoint.Depot_Code__c='SW06';
      shippingPoint.SalesOrg__c = sorg.ID;
      shippingPoint.Shipping_Point__c ='PT00';
      shippingPoint.Plant_Desc__c= '';
      shippingPoint.Active__c = true;
      insert shippingPoint;

      Depot__c storageLoc =new Depot__c ();
      storageLoc.Name='WL01';
      storageLoc.recordtypeId=shipLocRcdTp.id;
      storageLoc.Country__c='Spain';
      storageLoc.Location__c='NORTE';
      storageLoc.Depot_Code__c='CR00';
      storageLoc.SalesOrg__c = sorg.ID;
      storageLoc.Plant_Desc__c= '';
      storageLoc.Active__c = true;
      insert storageLoc;

      Depot__c depo =new Depot__c ();
      depo.Name='ES51';
      depo.recordtypeId=shipLocRcdTp.id;
      depo.Country__c='Spain';
      depo.Location__c='NORTE';
      depo.Depot_Code__c='ES51';
      depo.SalesOrg__c = sorg.ID;
      depo.Plant_Desc__c= 'ES51';
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
      shippLoc.Country__c = 'Spain';
      shippLoc.Pincode__c = '041523';
      shippLoc.Sales_Org__c = sorg.id;
      shippLoc.Billing_Street_1__c = 'ABC';
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

      Spain_Portugal_Campaign__c campaign = new Spain_Portugal_Campaign__c(
      Name = 'Spain',                     // Spain Portugal Campaign Name
      Start_Date__c =system.today(),  // Start Date
      End_Date__c = system.today() +1,   // End Date
      CompositeKey__c = 'C0020',                 // CompositeKey
      Status__c = 'Active'                      // Status
      );
      insert campaign;

      PricebookDiscount__c pbDiscount = new PricebookDiscount__c(
      Division__c = divsn.id,                              // Division
      SKUCode__c = sku.id,                                 // SKU Code
      DistributionChannel__c = disbj.id,                     // Distribution Channel
      Active__c = true,                                               // Active
      Spain_Portugal_Campaign__c = campaign.id,                 // Spain Portugal Campaign
      Distributor_Discount__c = 5.00,                                 // Distributor Discount
      Sales_Org__c = sorg.Id,                               // Sales Org
      CompositeKey__c = '2020-09-03C002025207010000000000006001071',  // CompositeKey
      DepotCode__c = depo.id,                               // Depot Code
      StartDate__c = system.today(),                        // Start Date
      EndDate__c = system.today() +1                        // End Date
      );
      insert pbDiscount;

      PricebookDiscount__c pbDiscount2 = new PricebookDiscount__c(
      Division__c = divsn2.id,                              // Division
      SKUCode__c = sku2.id,                                 // SKU Code
      DistributionChannel__c = disbj.id,                     // Distribution Channel
      Active__c = true,                                               // Active
      Spain_Portugal_Campaign__c = campaign.id,                 // Spain Portugal Campaign
      Distributor_Discount__c = 5.00,                                 // Distributor Discount
      Sales_Org__c = sorg.Id,                               // Sales Org
      CompositeKey__c = '2020-09-03C002025207010000000000006001072',  // CompositeKey
      DepotCode__c = depo.id,                               // Depot Code
      StartDate__c = system.today(),                        // Start Date
      EndDate__c = system.today() +1                        // End Date
      );
      insert pbDiscount2;

      SpecialInvoiceDiscount__c splInvDis = new SpecialInvoiceDiscount__c(
      Active__c = true,                          // Active
      Division__c = divsn.id,             // Division
      Batch__c = 'Portugal 5',                     // Batch
      DistributionChannel__c = disbj.id,  // Distribution Channel
      DepotCode__c = depo.id,            // Depot Code
      Price__c = 500.00,                           // Discount Price
      EndDate__c = system.today()+1,      // End Date
      SKUCode__c = sku.id,              // SKU Code
      StartDate__c = system.today(),     // Start Date
      UOM__c = 'L',                                // UOM
      CompositeKey__c = '000000000006001080',      // CompositeKey
      Sales_Org__c = sorg.Id,            // Sales Org
      Discount__c = 5.00                          // Discount
      );
      insert splInvDis;

      SpecialInvoiceDiscount__c splInvDis2 = new SpecialInvoiceDiscount__c(
      Active__c = true,                          // Active
      Division__c = divsn2.id,             // Division
      Batch__c = 'Portugal 5',                     // Batch
      DistributionChannel__c = disbj.id,  // Distribution Channel
      DepotCode__c = depo.id,            // Depot Code
      Price__c = 500.00,                           // Discount Price
      EndDate__c = system.today() +1,      // End Date
      SKUCode__c = sku2.id,              // SKU Code
      StartDate__c = system.today(),     // Start Date
      UOM__c = 'KG',                                // UOM
      CompositeKey__c = '000000000006001081',      // CompositeKey
      Sales_Org__c = sorg.Id,            // Sales Org
      Discount__c = 5.00                          // Discount
      );
      insert splInvDis2;

      ZSP1_Discount__c zspDisc = new ZSP1_Discount__c(
      Active__c = true,                          // Active
      Batch__c = 'POrtugal 4',                     // Batch
      CompositeKey__c = '000000000006001145',      // CompositeKey
      DepotCode__c = depo.id,            // Depot Code
      Price__c = 200.00,                           // Discount Price
      DistributionChannel__c = disbj.id,  // Distribution Channel
      Division__c = divsn.id,             // Division
      EndDate__c = system.today()+1,      // End Date
      Sales_Org__c = sorg.Id,            // Sales Org
      SKUCode__c = sku.id,              // SKU Code
      StartDate__c = system.today(),     // Start Date
      UOM__c = 'L',                                // UOM
      Discount__c = 2.00                          // Discount
      );
      insert zspDisc;

      ZSP1_Discount__c zspDisc2 = new ZSP1_Discount__c(
      Active__c = true,                          // Active
      Batch__c = 'POrtugal 4',                     // Batch
      CompositeKey__c = '000000000006001146',      // CompositeKey
      DepotCode__c = depo.id,            // Depot Code
      Price__c = 200.00,                           // Discount Price
      DistributionChannel__c = disbj.id,  // Distribution Channel
      Division__c = divsn2.id,             // Division
      EndDate__c = system.today()+1,      // End Date
      Sales_Org__c = sorg.Id,            // Sales Org
      SKUCode__c = sku2.id,              // SKU Code
      StartDate__c = system.today(),     // Start Date
      UOM__c = 'KG',                                // UOM
      Discount__c = 2.00                          // Discount
      );
      insert zspDisc2;

      Stock_Requirement__c stockReq = new Stock_Requirement__c(
      SKU__c = sku.id,             // SKU
      Depot__c = depo.id,             // Depot
      Unrestricted_Stock__c = 0.00,           // Unrestricted Stock
      Sales_Order_Stock__c = 0.00,            // Sales Order Stock
      Delivery_Stock__c = 0.00,               // Delivery Stock
      Purchase_Order_Stock__c = 0.00,         // Purchase Order Stock
      Stock_In_Transit__c = 0.00,             // Stock In Transit
      UOM__c = 'L',                             // UOM
      Combination_Key__c = depo.Name+''+storageLoc.Name,          // Combination Key
      Net_Stock_Italy__c = 0.00,              // Net Stock Italy
      Outgoing_Reservations_Italy__c = 0.00  // Outgoing Reservations Italy
      );
      insert stockReq;

      Stock_Requirement__c stockReq2 = new Stock_Requirement__c(
      SKU__c = sku2.id,             // SKU
      Depot__c = depo.id,             // Depot
      Unrestricted_Stock__c = 0.00,           // Unrestricted Stock
      Sales_Order_Stock__c = 0.00,            // Sales Order Stock
      Delivery_Stock__c = 0.00,               // Delivery Stock
      Purchase_Order_Stock__c = 0.00,         // Purchase Order Stock
      Stock_In_Transit__c = 0.00,             // Stock In Transit
      UOM__c = 'KG',                             // UOM
     // Combination_Key__c = depo.Name+''+storageLoc.Name,          // Combination Key
      Net_Stock_Italy__c = 0.00,              // Net Stock Italy
      Outgoing_Reservations_Italy__c = 0.00  // Outgoing Reservations Italy
      );
      insert stockReq2;

      PriceBookMaster__c pbMaster = new PriceBookMaster__c(
        SKUCode__c = sku.id,                      // SKU Code
        Price__c = 45.00,                                    // Price / Max Price
        DepotCode__c = depo.id,                    // Depot Code
        Final_Price__c = 0.00,                               // Final Price
        StartDate__c = system.today(),             // Start Date
        EndDate__c = system.today() + 1,              // End Date
        UOM__c = 'BT',                                        // UOM
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
        DepotCode__c = depo.id,                    // Depot Code
        Final_Price__c = 0.00,                               // Final Price
        StartDate__c = system.today(),             // Start Date
        EndDate__c = system.today() + 1,              // End Date
        UOM__c = 'BT',                                        // UOM
        Division__c = divsn2.id,                     // Division
        DistributionChannel__c = disbj.id,          // Distribution Channel
        Active__c = true,                                    // Active
        PerUnit__c = 1,                                    // Per Unit
        CompositeKey__c = 'SW0625207010000000000006001072',  // CompositeKey
        Sales_Org__c = sorg.id,                    // Sales Org
        Price_Book_Change__c = false                        // Price_Book_Change
        //Customized_Product__c = false                       // Customized Product
      );
      insert pbMaster2;

      Early_Order_Discount__c eod = new Early_Order_Discount__c(
        Name = 'Spain',
        Discount__c = 2
      );
      insert eod;

      Early_Order_Discount__c eod2 = new Early_Order_Discount__c(
        Name = 'Portugal',
        Discount__c = 2
      );
      insert eod2;
      
      Inventory__c inv = new Inventory__c();
     
      inv.Stock_Quantity__c = 10;   
      inv.Batch_Number__c = 'CMUMTX2506'; 
      inv.Depot__c = depo.Id;    
      inv.UOM__c = 'BT';                    
      inv.Storage_Location__c = 'MAIN';  
      inv.SKU__c = sku.Id;  
      inv.SKU_Depot__c ='sd1';           
      insert inv;
      
     
        Order__c order = new Order__c(
        Order_Date__c = system.today(),      // Order Date
        Order_Type__c = ordType.Id,              // Order Type
        Order_Status__c = 'Draft',                   // Order Status
        Remarks__c = 'Test',                            // Remarks
        Price_Entry__c = 'Pre-uploaded',                // Price Entry
        Depot__c = depo.ID,                   // Depot
        Is_Express_Delivery_Italy__c = false,           // Is Express Delivery
        Early_Order_Discount__c = 2.00,                 // Early Order Discount
        Gross_Amount_With_Early_Discount__c = 1767.92,  // Gross Amount With Early Discount
        Sales_Org__c = sorg.id,               // Sales Org
        Bill_To_Party__c = acc.id,           // Bill To Party
        Shipping_Location__c = shippLoc.id       // Shipping Location
      );
      insert order;

      OrderLineItem__c orderLineItem1 = new OrderLineItem__c(
        SKU_Name__c = sku.id,              // SKU Name
        Item_Number__c = '20',                        // Item Number
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
        Actual_Volume_Discount__c = 5.00             // Actual Volume Discount
      );
      insert orderLineItem1;

    

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
        PaymentMethod__c =payMethod.id ,
          Payment_Term__c= payTerm.id,
          Inco_Term__c = incoTerm.id
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
      Campaign__c = campaign.id,
      Pricebook_Discount_Id__c = pbDiscount.id
    );
    insert soLineItem1;
        
	Payment_Method_Term__c pmTerm= new Payment_Method_Term__c();
    pmTerm.Name='test';
    pmTerm.Payment_Method_Spain__c='c1';
    pmTerm.Payment_Term_Spain__c = '2020';
    insert pmTerm;
        
    Payment_Method_Term__c pmTerm2= new Payment_Method_Term__c();
    pmTerm2.Name='test2';
    pmTerm2.Payment_Method_Spain__c='c1';
    pmTerm2.Payment_Term_Spain__c = '2020';
    insert pmTerm2;
        
    Attachment attach = new Attachment(
    parentId = salesOrder.id,
    Body = EncodingUtil.base64Decode('fdestdctyrgdybdrtnuftyuytmiynu'),
    Name = 'fileName',
    ContentType = '.pdf');
    insert attach;

    SpainPortugalSOController.OrderWrapper ordWrapper = new SpainPortugalSOController.OrderWrapper();
    List<SpainPortugalSOController.OrderItemWrapper> ordItemWrapperList = new List<SpainPortugalSOController.OrderItemWrapper>();
    SpainPortugalSOController.OrderItemWrapper ordItemWrapper = new SpainPortugalSOController.OrderItemWrapper();
    ordItemWrapper.orderItem_id = orderLineItem1.id;
    ordItemWrapper.order_id = order.id;
    ordItemWrapper.pb_id = pbMaster.id;
    ordItemWrapper.sku_name = sku.Name;
    ordItemWrapper.sku_id = sku.id;
    ordItemWrapper.uom = sku.UOM__c;
    ordItemWrapper.campaign_nm = campaign.Name;
    ordItemWrapper.campaign_id = campaign.id;
    ordItemWrapper.base_price = 0.0;
    ordItemWrapper.apply_cmpgn_disc = false;
    ordItemWrapper.campaign_discount = 0.0;
    ordItemWrapper.line_discount = 0.0;
    ordItemWrapper.volume_discount = 0.0;
    ordItemWrapper.quantity = 0.0;
    ordItemWrapper.final_price = 0.0;
    ordItemWrapper.net_price = 0.0;
    ordItemWrapper.shipmnt_date = String.valueOf(System.today());
    ordItemWrapper.inventory = 0.0;
    ordItemWrapper.actual_discount = 0.0;
    ordItemWrapper.edited_discount = 0.0;
    ordItemWrapper.multiple_of = 0.0;
    ordItemWrapper.actual_campaign_discount = 0.0;
    ordItemWrapper.actual_line_discount = 0.0;
    ordItemWrapper.actual_volume_discount = 0.0;
    ordItemWrapper.pb_discount_id = pbDiscount.id;
    ordItemWrapper.distributionChanlIds = disbj.id;
    ordItemWrapper.divisionIds = divsn.id;
    ordItemWrapper.itemNumber = 10;
    ordItemWrapper.min_quantity = 0;
    ordItemWrapper.campaign_code = '';

    ordItemWrapperList.add(ordItemWrapper);

    ordWrapper.orderItemList = ordItemWrapperList;
    ordWrapper.orderFor = '2510';
    ordWrapper.account_Id = acc.id;
    ordWrapper.ordr_id = order.id;
    ordWrapper.so_id = '';
    ordWrapper.isSalesOrder = true;
    ordWrapper.early_ordr_discount = 0;
    ordWrapper.total_amount = 0.0;
    ordWrapper.gross_amount = 0.0;
    ordWrapper.uom_kg = '';
    ordWrapper.uom_bottle = '';
    ordWrapper.uom_litre = '';
    ordWrapper.net_price_kg = 0.0;
    ordWrapper.net_price_bottle = 0.0;
    ordWrapper.net_price_litre = 0.0;
    ordWrapper.quantity_kg = 0.0;
    ordWrapper.quantity_bottle = 0.0;
    ordWrapper.quantity_litre = 0.0;
    ordWrapper.inco_term = incoTerm.Name;
    ordWrapper.inco_term_id = incoTerm.id;
    ordWrapper.payment_method = payMethod.Name;
    ordWrapper.payment_method_id = payMethod.id;
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
    ordWrapper.Shipping_Point = shippingPoint.id;
    ordWrapper.Storage_Location = storageLoc.id;
    ordWrapper.CurrencyCode = 'EUR';
    ordWrapper.ownerId = spainUser.id;

    List<String> distIds = new List<String>();
    distIds.add(disbj.id);
    List<String> divIds = new List<String>();
    divIds.add(divsn.id);

    ordWrapper.distributionChanlIds = distIds;
    ordWrapper.divisionIds = divIds;
    ordWrapper.lastItemNumber = 20;
    ordWrapper.countryWise_EOD = new List<Decimal>();
    ordWrapper.disable_EOD = false;
    ordWrapper.orderRaisedBy = '';
    ordWrapper.managerId = sobj1.id;
    ordWrapper.countryHead = sobj1.id;
                                      
    //SpainPortugalSOController.getOrderDetails(acc.id);
    SpainPortugalSOController.getOrderDetails(acc.id);
    //SpainPortugalSOController.getOrderForList('2510',acc.id);
    SpainPortugalSOController.getCampaignAndDiscount(sku.id,sorg.id,depo.id,disbj.id,divsn.id,depo.Name+''+storageLoc.Name);
    SpainPortugalSOController.getCampaignAndDiscount(sku2.id,sorg.id,depo.id,disbj.id,divsn2.id,depo.Name+''+storageLoc.Name);
    SpainPortugalSOController.createDraftOrder(JSON.serialize(ordWrapper));

    ordWrapper = new SpainPortugalSOController.OrderWrapper();
    ordItemWrapperList = new List<SpainPortugalSOController.OrderItemWrapper>();
    ordItemWrapper = new SpainPortugalSOController.OrderItemWrapper();

    ordItemWrapper.orderItem_id = soLineItem1.id;
    ordItemWrapper.order_id = order.id;
    ordItemWrapper.pb_id = pbMaster.id;
    ordItemWrapper.sku_name = sku.Name;
    ordItemWrapper.sku_id = sku.id;
    ordItemWrapper.uom = sku.UOM__c;
    ordItemWrapper.campaign_nm = campaign.Name;
    ordItemWrapper.campaign_id = campaign.id;
    ordItemWrapper.base_price = 100.0;
    ordItemWrapper.apply_cmpgn_disc = false;
    ordItemWrapper.campaign_discount = 1.0;
    ordItemWrapper.line_discount = 2.0;
    ordItemWrapper.volume_discount = 1.0;
    ordItemWrapper.quantity = 100.0;
    ordItemWrapper.final_price = 100.0;
    ordItemWrapper.net_price = 100.0;
    ordItemWrapper.shipmnt_date = String.valueOf(System.today());
    ordItemWrapper.inventory = 0.0;
    ordItemWrapper.actual_discount = 3.0;
    ordItemWrapper.edited_discount = 4.0;
    ordItemWrapper.multiple_of = 5.0;
    ordItemWrapper.actual_campaign_discount = 1.0;
    ordItemWrapper.actual_line_discount = 1.0;
    ordItemWrapper.actual_volume_discount = 1.0;
    ordItemWrapper.pb_discount_id = pbDiscount.id;
    ordItemWrapper.distributionChanlIds = disbj.id;
    ordItemWrapper.divisionIds = divsn.id;
    ordItemWrapper.itemNumber = 10;
    ordItemWrapper.min_quantity = 10;
    ordItemWrapper.campaign_code = '';

    ordItemWrapperList.add(ordItemWrapper);

    ordWrapper.orderItemList = ordItemWrapperList;
    ordWrapper.orderFor = '2510';
    ordWrapper.account_Id = acc.id;
    ordWrapper.ordr_id = order.id;
    ordWrapper.so_id = salesOrder.id;
    ordWrapper.isSalesOrder = true;
    ordWrapper.early_ordr_discount = 2;
    ordWrapper.total_amount = 1000.0;
    ordWrapper.gross_amount = 1000.0;
    ordWrapper.uom_kg = '';
    ordWrapper.uom_bottle = '';
    ordWrapper.uom_litre = '';
    ordWrapper.net_price_kg = 0.0;
    ordWrapper.net_price_bottle = 0.0;
    ordWrapper.net_price_litre = 0.0;
    ordWrapper.quantity_kg = 0.0;
    ordWrapper.quantity_bottle = 0.0;
    ordWrapper.quantity_litre = 0.0;
    ordWrapper.inco_term = incoTerm.Name;
    ordWrapper.inco_term_id = incoTerm.id;
    ordWrapper.payment_method = payMethod.Name;
    ordWrapper.payment_method_id = payMethod.id;
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
    ordWrapper.Shipping_Point = shippingPoint.id;
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
    ordWrapper.countryWise_EOD = new List<Decimal>();
    ordWrapper.disable_EOD = false;
    ordWrapper.orderRaisedBy = 'Regional Manager';
    ordWrapper.managerId = sobj1.id;
    ordWrapper.countryHead = sobj1.id;
    string tempName = 'DOST';

    SpainPortugalSOController.createNewSO(JSON.serialize(ordWrapper),tempName);
  
    
  }
}