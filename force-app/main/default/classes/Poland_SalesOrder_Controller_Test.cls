@isTest
public class Poland_SalesOrder_Controller_Test {
    
    @testSetup
    static void allTheDataForThisTestClass() {
        Id devRecordTypeId = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Sales Order').getRecordTypeId();
        Id devRecordAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id devRecordDepot = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();    
        
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Poland',           // Sales Org Name
            Company_Code__c = '2941',      // Company Code
            Sales_Org_Code__c = '2941'   // Sales Org Code
            
        );
        insert salesOrgObj;
        //Added by nandhini
        Sales_Org__c salesOrgObjBrazil1 = new Sales_Org__c(
            Name = 'Brazil',           // Sales Org Name
            Company_Code__c = '5191',      // Company Code
            Sales_Org_Code__c = '5191'   // Sales Org Code
            
        );
        insert salesOrgObjBrazil1;
        Trigger_Settings__c newtri = new Trigger_Settings__c();
        newtri.Name = 'SOLICombKeyTrigger';
        newtri.isActive__c = true;
        insert newtri;
        
        Trigger_Settings__c newtri1 = new Trigger_Settings__c();
        newtri1.Name = 'salesOrderShareTriger';
        newtri1.isActive__c = true;
        insert newtri1;
        
        
        Division__c DivisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert DivisionObj;
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZIOR';              
        ordType.Order_Type_Code__c = 'ZIOR';
        ordType.SalesOrg__c = salesOrgObj.Id;
        insert ordType;
        Order_Type__c ordType1 =new Order_Type__c();
        ordType1.Name = 'ZZOD';              
        ordType1.Order_Type_Code__c = 'ZZOD';
        ordType1.SalesOrg__c = salesOrgObj.Id;
        insert ordType1;
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
        
        userrole  usrole = new userrole();
        usrole.Name ='Regional/Zonal Managers for Spain';
        //added by nandhini
        userrole  usrole2 = new userrole();
        usrole2.Name ='AGROPESTCustomerUser';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Poland(wholesale sales Manager)'];
        
        Account accObj1 = new Account(
            Name = 'SAR123',                                                            // Account Name
            //OwnerId = user.id,
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
            //PriceGroupCode__c =priceGroupMasterObj.Id,                            // Tax classification for customer
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c='',
            Distributor_Type_Poland__c ='Regular Customer'
        );
        insert accObj1;
        
        List<Account> acclistNew=new List<Account>();
        //for non regulqar customer by nandhini
        Account accObjNon = new Account(
            Name = 'SAR1234',                                                            // Account Name
            //OwnerId = user.id,
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'SAR1234',                                         // Last Name
            SAP_Code__c = '000102323456789',                                        // SAP Customer Code
            Mobile__c = '08765432193',                                          // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '86005897933',                                    // Tax Number 1
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
            //PriceGroupCode__c =priceGroupMasterObj.Id,                            // Tax classification for customer
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c='',
            Distributor_Type_Poland__c ='Non Regular Customer'
        );
        
        insert accObjNon;
        
        
        
        List<Credit_Info__c> crdList = new List<Credit_Info__c>();
        Credit_Info__c crdIf2 = new Credit_Info__c();
        crdIf2.Credit_Limit__c=1000;
        crdIf2.Percentage_Used__c=100.0;
        crdIf2.Allocated_Limit__c=0.0;
        crdIf2.Distributor__c=accObj1.Id;
        crdIf2.Distributor_Code__c='0001023234';
        crdIf2.Sales_Org__c=salesOrgObj.Id;
        crdList.add(crdIf2);
        
        OrderTemplate__c OrderTempObj = new OrderTemplate__c(
            Name = 'ULALA 30 GM',                          // Order Template Name
            DistributorCustomerCode__c = accObj1.Id  // Distributor Customer Code
        );
        insert OrderTempObj;
        
        Contact con = new Contact();
        con.AccountId=accObj1.Id;
        con.LastName=accObj1.Last_Name__c;
        con.Is_Community__c=true;
        con.MobilePhone ='9876543211';
        con.Phone = '5592619030';
        con.Is_Community__c = true;
        insert con;      
        //by nandhini
        
        //Profile p2 = [SELECT Id FROM Profile WHERE UserType = 'PowerPartner' limit 1];
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'skim@skinternational123.com';                             
        sobj1.ProfileId  = p.ID;
        //sobj1.ContactId=con.Id;
        sobj1.UserRoleId=usrole.id;
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
        insert sobj1;
        //Added by nandhini
        userrole  usrole21 = new userrole();
        usrole21.Name ='Technical Manager Poland';
        Profile p23 = [SELECT Id,name FROM Profile WHERE Name = 'Poland(Key Account Manager)']; 
        User sobj2 = new User();
        sobj2.Alias = 'zonaaera';                                                            
        sobj2.Email = 'skim@skinternational123asd.com';                             
        sobj2.ProfileId  = p23.ID;
        //sobj1.ContactId=con.Id;
        sobj2.UserRoleId=usrole21.id;
        sobj2.Username = 'zonal_aaexe1232@u345.com.devbox';                                    
        sobj2.IsActive = true;  
        sobj2.LastName='Terriotory Manager';
        sobj2.CommunityNickname = 'zonalExe1222 sdDi'; 
        sobj2.TimeZoneSidKey = 'Asia/Kolkata'; 
        sobj2.LocaleSidKey = 'en_IN';                                    
        sobj2.LanguageLocaleKey = 'en_US';                                             
        sobj2.ForecastEnabled = false;                                                     
        sobj2.EmailEncodingKey = 'ISO-8859-1';    
        sobj2.Show_Inventory__c = false;                                                     
        sobj2.Show_Credit_Limit__c = false;         
        insert sobj2;
        Account accObj = new Account(
            Name = 'SAR123',                              // Account Name
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'SAR123',                                         // Last Name
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
            //PriceGroupCode__c =priceGroupMasterObj.Id,                            // Tax classification for customer
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c=''
        );
        insert accObj;
        
        Contact con2 = new Contact();
        con2.AccountId=accObj.Id;
        con2.LastName=accObj.Last_Name__c;
        con2.Is_Community__c=true;
        con2.MobilePhone ='9876543212';
        con2.Phone = '5592619031';
        con2.Is_Community__c = true;
        insert con2;
        List<Outstanding_Ageing__c> oaList = new List<Outstanding_Ageing__c>();
        Outstanding_Ageing__c ostAg = new Outstanding_Ageing__c();
        //ostAg.OutstandingTotalGreaterthan90__c=0.0;
        ostAg.Net_Outstanding__c=100.0;
        ostAg.Customer_Code__c = accObj1.Id;
        ostAg.Sales_Org__c = salesOrgObj.id;
        oaList.add(ostAg);
        
        Outstanding_Ageing__c ostAg2 = new Outstanding_Ageing__c();
        //ostAg.OutstandingTotalGreaterthan90__c=0.0;
        ostAg2.Net_Outstanding__c=100.0;
        ostAg2.Customer_Code__c = accObj.Id;
        ostAg2.Sales_Org__c = salesOrgObj.id;
        oaList.add(ostAg2);
        insert oaList;
        
        List<Payments__c> payList = new List<Payments__c>();
        Payments__c payC = new Payments__c();
        payC.Net_Overdue__c=0.0;
        payC.Customer_Name__c = accObj1.id;
        payC.Company_Code__c = salesOrgObj.id;
        payList.add(payC);
        
        Payments__c payC1 = new Payments__c();
        payC1.Net_Overdue__c=0.0;
        payC1.Customer_Name__c = accObj.id;
        payC1.Company_Code__c = salesOrgObj.id;
        payList.add(payC1);
        
        insert payList;
        
        Credit_Info__c crdIf = new Credit_Info__c();
        crdIf.Credit_Limit__c=1000;
        crdIf.Percentage_Used__c=100.0;
        crdIf.Allocated_Limit__c=0.0;
        crdIf.Distributor__c=accObj.Id;
        crdIf.Distributor_Code__c='0001023194';
        crdIf.Sales_Org__c=salesOrgObj.Id;
        crdList.add(crdIf);
        insert crdList;
        
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
        
       //Added by Nandhini CR:APPS-2521
        SKU__c skuObj1 = new SKU__c(
            Name = 'Child SKu1',                         // SKU Name
            SKU_Code__c = '000000000006060697',                 // SKU Code
            Product_Name__c = productObj.Id,                // Product Nam
            SKU_Description__c = 'FURYY 40 EC X 250 cc1',        // SKU Description
            UOM__c = 'L',                                       // UOM
            Distribution_Channel__c = DistributionChannelObj.Id,        // Distribution Channel
            Pack_Size__c = 0.00,                              // Pack Size
            Division__c = divisionObj.Id,   
            Unit_Cost__c = 200,
            Area_Manager_MSP__c =150,
            Sales_Agent_MSP__c =500,
            Sales_Director_MSP__c =50,
            Sales_Org__c = salesOrgObj.Id,                   // Sales Org
            Combination_Key__c = '57106710000000000006060697',  // Combination Key
            Material_type__c = 'FERT',                          // Material type
            Active__c = true,                                   // Active
            Brand_Name__c = 'FURRY1',                          // Brand Name
            Inventory_Description_Italy__c='Stock available'
        );
        insert skuObj1;
        //Data for Depot  
        Depot__c depotObj = new Depot__c(
            Name = 'IT00',                             // Depot Name
            Location__c = 'PD01',                        // Location
            SalesOrg__c = salesOrgObj.Id,             // Sales Org
            Depot_Code__c = 'PD01',                      // Depot Code
            RecordTypeId = devRecordDepot                  // Record Type
            // Active
        );
        insert depotObj;
        
        Distributor_Depot_Mapping__c ddm = new Distributor_Depot_Mapping__c(
            Depot__c = depotObj.id,      // Depot
            Distributor__c = accObj.id  // Distributor
        );
        insert ddm;
        
        Distributor_Depot_Mapping__c ddm2 = new Distributor_Depot_Mapping__c(
            Depot__c = depotObj.id,      // Depot
            Distributor__c = accObj1.id  // Distributor
        );
        insert ddm2;
        
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
        //Added by Nandhini CR:APPS-2521
        PriceBookMaster__c priceBookMasterObjChild = new PriceBookMaster__c(
            //DistributorCustomerCode__c = accObj.Id,         // Distributor Customer Code
            SKUCode__c = skuObj1.Id,                           // SKU Code
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
            CompositeKey__c ='c123',
            PAK__c=true// Sales Org
        );
        insert priceBookMasterObjChild;
        
        
        DistributorSalesAreaMapping__c DistributorSalesAreaMappingObj = new DistributorSalesAreaMapping__c(
            AccountType__c = 'Sold To Party',          // Account Type
            Distributor__c = accObj.id,          // Distributor
            SalesOrg__c = salesOrgObj.id,             // Sales Org
            OrderBlock__c = false,                       // Order Block
            DistributionChannel__c = distributionChannelObj.id,  // Distribution Channel
            Division__c = divisionObj.id             // Division
            // Account Owner
            //PriceGroupMaster__c = priceGroupMasterObj.id     // Price Group Master
        );
        insert DistributorSalesAreaMappingobj;
        
        
        
        DistributorSalesAreaMapping__c DistributorSalesAreaMappingObj1 = new DistributorSalesAreaMapping__c(
            AccountType__c = 'Sold To Party',          // Account Type
            Distributor__c = accObj1.id,          // Distributor
            SalesOrg__c = salesOrgObj.id,             // Sales Org
            OrderBlock__c = false,                       // Order Block
            DistributionChannel__c = distributionChannelObj.id,  // Distribution Channel
            Division__c = divisionObj.id          // Division
            // Account Owner
            //PriceGroupMaster__c = priceGroupMasterObj.id     // Price Group Master
        );
        insert DistributorSalesAreaMappingobj1;
        
        
        PriceBookMaster__c priceBookMasterObj1 = new PriceBookMaster__c(
            DistributorCustomerCode__c =null,         // Distributor Customer Code
            SKUCode__c = skuObj.Id,    
            //PG_CODE__c =priceGroupMasterObj.Id,
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
        
        Stock_Requirement__c stockObj = new Stock_Requirement__c(
            SKU__c = skuObj.Id,                       // SKU
            Depot__c = DepotObj.Id,                       // Depot
            Unrestricted_Stock__c = 0.00,                     // Unrestricted Stock
            Sales_Order_Stock__c = 0.00,                      // Sales Order Stock
            Delivery_Stock__c = 0.00,                         // Delivery Stock
            Purchase_Order_Stock__c = 0.00,                   // Purchase Order Stock
            Stock_In_Transit__c = 0.00,                       // Stock In Transit
            UOM__c = 'L',                                       // UOM
            Combination_Key__c = '2941000000000005618004PD01',  // Combination Key
            Net_Stock_Italy__c = 0.00,                        // Net Stock Italy
            Outgoing_Reservations_Italy__c = 0.00            // Outgoing Reservations Italy
        );
        insert stockObj;
        
        
        
        Order__c ord = new Order__c();
        ord.Bill_To_Party__c = accObj.Id;        
        ord.Order_Date__c = system.today();  
        ord.Order_Status__c = 'Draft';                    
        ord.Sales_Org__c =salesOrgObj.Id;          
        insert ord;
       // string ordid =(String)ord.Id;
        OrderLineItem__c ordItem = new OrderLineItem__c();
        ordItem.SKU_Name__c = skuObj.Id; 
        ordItem.FinalPrice__c =12;
        ordItem.pallet_Size_Italy__c =100.00;
        // ordItem.Weight_Italy__c =20;
        ordItem.Transport_contribution__c =45.00;
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
        insert ordItem; 
        
        List<Id> orderItemListId=new List<Id>();
        orderItemListId.add(ordItem.Id);
        OrderTemplateItem__c orderTemplLineObj = new OrderTemplateItem__c(
            Name = 'a140k000003jcRH',                   // Order Template Item Name
            OrderTemplate__c = OrderTempObj.Id,         // Order Template
            SKU__c = skuObj.Id,                   // SKU
            multipleOf__c = 12,                         // multipleOf
            Manager_Price__c = 0.00,                    // Manager Price
            Pallet_Size__c = 10,                        // Pallet Size
            UOM__c = 'L',                                 // UOM
            Payment_Term__c = paymentTermObj.Id,          // Payment Term
            Logistic_Discount__c = 2.50,                  // Logistic Discount
            Base_Price__c = 100.00,                       // Base Price
            Division__c = DivisionObj.Id,              // Division
            Distribution_Channel__c = distributionChannelObj.Id  // Distribution Channel
        );
        insert orderTemplLineObj;
        
        
        //Added By nandhini
        Territory_Distributor__c TD=new Territory_Distributor__c();
        TD.Name='Test TD';
        TD.SalesOrg__c=salesOrgObjBrazil1.id;
        TD.TerritoryManager__c=userinfo.getUserId();
        TD.BarterManager__c=userinfo.getUserId();
        insert TD;
        
        system.debug('distributor infno' +TD);
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
            Bill_To_Party__c = accObj.Id,                // Bill To Party
            Depot_Code__c = 'IT00',                              // Depot Code
            Sold_to_Party__c = accObj.Id,                // Sold to Party
            Ship_To_Party__c = shippingLocationObj.Id,                // Ship To Party
            UGDN__c = '20011688'                            // UGDN
        );
        insert SalesOrderObj;
        
        
        
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
            Inventory_Description_Italy__c='Stock available'
        );
        insert saleOrderLineObj;
        
        
        Attachment attach = new Attachment(
            parentId = SalesOrderObj.id,
            Body = EncodingUtil.base64Decode('fdestdctyrgdybdrtnuftyuytmiynu'),
            Name = 'fileName',
            ContentType = '.pdf');
        insert attach;
        
        Inco_Term__c sobj = new Inco_Term__c(
            Name = 'UN',                             // Inco Term Name
            IncoTerm_Desc__c = 'Porte/frete a pagar',  // IncoTerm Desc
            IncoTerm_Code__c = 'UN',                   // IncoTerm Code
            Sales_Org__c = salesOrgObj.Id,          // Sales Org
            Active__c = false                         // Active
        );
        insert sobj;
        
        Early_Order_Discount__c eod = new Early_Order_Discount__c(
            Name = 'Early Order Discount',
            Discount__c = 2
        );
        insert eod;
        
        Big_Volume_Discount__c bod = new Big_Volume_Discount__c(
            Name = 'Early Order Discount',
            Discount_If_Qty_Eq_or_Gt_Pallet__c = 2,
            Discount_If_Qty_Eq_or_Gt_Truck__c=3
        );
        insert bod;
        
        ZSP1_Discount__c zspmObj = new ZSP1_Discount__c(
            Active__c = false,                                                   // Active
            CompositeKey__c = '10-10-2018SW010412102092000000000000252011',        // CompositeKey
            DepotCode__c = 'a0w0K000005B9Ds',                                      // Depot Code
            Price__c = 784.82,                                                     // Discount Price
            DistributionChannel__c = DistributionChannelObj.Id,                            // Distribution Channel
            Division__c = DivisionObj.Id,                                       // Division
            EndDate__c = System.today(),                                // End Date
            PerUnit__c = 1,                                                      // Per Unit
            // PG_Code__c = 'a1928000000tLKj',                                        // PG Code
            Sales_Org__c = salesOrgObj.Id,                                      // Sales Org
            SKUCode__c = skuObj.Id,                                        // SKU Code
            StartDate__c = System.today(),                             // Start Date
            UOM__c = 'TO'                                                         // UOM
        );
        insert zspmObj;
        SpecialInvoiceDiscount__c specialInvoObj = new SpecialInvoiceDiscount__c(
            Active__c = false,                                                  // Active
            DistributionChannel__c = DistributionChannelObj.Id,                           // Distribution Channel
            Price__c = 3.00,                                                      // Discount Price
            EndDate__c = System.today(),                               // End Date
            //MagicModificationDate__c = Datetime.valueOf('13-7-2021 8:41 am:00'),  // Magic Modification Date
            PerUnit__c = 9,                                                     // Per Unit
            // PG_Code__c = 'a1928000000tLKi',                                       // PG Code
            SKUCode__c = skuObj.Id,                                       // SKU Code
            StartDate__c = System.today(),                             // Start Date
            CompositeKey__c = '2021-05-12031000201000000000000630607941',         // CompositeKey
            Sales_Org__c = salesOrgObj.Id,                                     // Sales Org
            Division__c = DivisionObj.Id,                                      // Division
            BeforeSwalActivity__c = false,                                        // Before Swal Activity
            PrIce_List_Type__c = 'a3n0K000000TcZX'                               // PrIce List Type
        );
        insert specialInvoObj;
        
        PriceBook_Indonesia_Discount__c pbIObj = new PriceBook_Indonesia_Discount__c(
            Active__c = false,                                         // Active
            UOM__c = 'KG',                                               // UOM
            Division__c = DivisionObj.Id,                             // Division
            BeforeSwalActivity__c = false,                               // Before Swal Activity
            Price__c = 15000,                                            // Discount Price
            CompositeKey__c = 'ID0103641000000000000618017801-06-2019',  // CompositeKey
            StartDate__c = System.today(),                     // Start Date
            EndDate__c = System.today(),                      // End Date
            Sales_Org__c = salesOrgObj.Id,                            // Sales Org
            SKUCode__c = skuObj.Id, 
            DistributorCustomerCode__c=accObj.Id      // SKU Code
        );
        insert pbIObj;
        
        
        Login_Country__c logCountryObj = new Login_Country__c();
        logCountryObj.Name ='Poland'; 
        logCountryObj.For_Contry__c ='Poland';
        logCountryObj.Sales_Org_Code__c ='2941';
        logCountryObj.Show_Delivery_Date__c =true;
        logCountryObj.Show_PO_Date__c =true;
        logCountryObj.PO_Date__c =true;
        logCountryObj.Delivery_Date__c =true;
        
        insert logCountryObj;
        
        Account accObj11 = new Account();
        test.startTest();
        
        Poland_SalesOrder_Controller.getCartOrderItems(accObj.Id);
        Poland_SalesOrder_Controller.getSalesSTP(SalesOrderObj.Id);
        Poland_SalesOrder_Controller.getOrderFields(accObj.Id);
        Poland_SalesOrder_Controller.getSalesOrder(SalesOrderObj.Id);
        Poland_SalesOrder_Controller.getSalesOrderItems(SalesOrderObj.Id,'cloneOrder','');
        Poland_SalesOrder_Controller.getSkuData(accObj.Id,true);
        Poland_SalesOrder_Controller.getSkuData(accObj11.Id,false);
        //Poland_SalesOrder_Controller.deleteOItem(orderItemListId,ord.Id,'0');
       // Poland_SalesOrder_Controller.deleteOrderItems(ord.Id);
        //Poland_SalesOrder_Controller.deleteSalesOrderLineItem(saleOrderLineObj.Id);
        
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '2941'];
        Account acc2 = [SELECT id FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'SAR123' LIMIT 1]; 
        Depot__c dep = [SELECT Id, Location__c FROM Depot__c WHERE SalesOrg__c = :sorg.Id AND Location__c = 'PD01' LIMIT 1];
        SKU__c skurec = [SELECT Id, SKU_Description__c,Unit_Cost__c, SKU_Code__c FROM SKU__c where SKU_Description__c = 'FURYY 40 EC X 250 cc' LIMIT 1]; 
        Payment_Term__c paymentRec  = [SELECT Id, Payment_Term_Code__c FROM Payment_Term__c WHERE Sales_Org__c = :sorg.Id AND Payment_Term_Code__c = 'UK01' LIMIT 1]; 
        //Added by nandhini
        profile pDistributor=[select id from profile where name='Customer Community Plus User - Poland - 1'];
        List<user> userlistNew=new List<user>();
        user AccConUser=new user();
        AccConUser.Alias = 'zonaa1';                                                            
        AccConUser.Email = 'skim@skinternational1.com';                             
        AccConUser.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser.UserRoleId=usrole2.id;
        AccConUser.Username = 'zonal_aaexe1232@upl12.com.devbox';                                    
        AccConUser.IsActive = true;  
        AccConUser.LastName='Terriotory Manager';
        AccConUser.CommunityNickname = 'zonalExe12Di'; 
        AccConUser.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser.LocaleSidKey = 'en_IN';                                    
        AccConUser.LanguageLocaleKey = 'en_US';                                             
        AccConUser.ForecastEnabled = false;                                                     
        AccConUser.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser.Show_Inventory__c = false;                                                     
        AccConUser.Show_Credit_Limit__c = false; 
        AccConUser.ContactId=con.id; 
        userlistNew.add(AccConUser);
        
        
        insert userlistNew;
        
        system.runAs(sobj1){
            
             Poland_SalesOrder_Controller.CartWrapper cartWrap = new Poland_SalesOrder_Controller.CartWrapper();

            Poland_SalesOrder_Controller.SalesOrderItem OwrapObj = new Poland_SalesOrder_Controller.SalesOrderItem();
            List<Poland_SalesOrder_Controller.SalesOrderItem> OwrapObjlst = new List<Poland_SalesOrder_Controller.SalesOrderItem>(); 
            OwrapObj.productId = skurec.Id; 
            OwrapObj.palletSize =100.00;
            OwrapObj.skuId = skurec.id;
            OwrapObj.distributionChannelId = distributionChannelObj.Id;
            
            OwrapObj.qty = 14;          
            OwrapObj.typeOfPayment = paymentRec.Id;
            OwrapObjlst.add(OwrapObj);
            String serlizeStr1 = JSON.serialize(OwrapObj);  
            String serlizeStr2 = JSON.serialize(OwrapObjlst);
            
            Sales_Order__c so2 = new Sales_Order__c();
            so2.Payment_Term__c = paymentRec.Id;      
            so2.Ship_To_Party__c = shippingLocationObj.Id;
            so2.Sold_to_Party__c = acc2.Id;   
            so2.Order_Status__c ='Pending';
            so2.Sent_for_Manager_Approval_Mexico__c=true;
            //by nandhini
            Sales_Order__c so3Non = new Sales_Order__c();
            so3Non.Payment_Term__c = paymentRec.Id;      
            so3Non.Ship_To_Party__c = shippingLocationObj.Id;
            so3Non.Sold_to_Party__c = accObjNon.Id;   
            so3Non.Order_Status__c ='Pending';
            so3Non.Sent_for_Manager_Approval_Mexico__c=true;
            
            
            List<Poland_SalesOrder_Controller.SalesOrderItem> solst = new List<Poland_SalesOrder_Controller.SalesOrderItem>(); 
            Poland_SalesOrder_Controller.SalesOrderItem wrapObj = new Poland_SalesOrder_Controller.SalesOrderItem();
            
            wrapObj.productId = skurec.id;
            wrapObj.productName = skurec.SKU_Description__c;
            wrapObj.skuId = skurec.id;
            wrapObj.qty = 50;
            wrapObj.UOM ='L';
            System.debug('ordItem.Id i Test class '+ordItem.Id);
            System.debug('ord.Id in test class '+ord.Id);
            wrapObj.oliId = ordItem.Id;
            wrapObj.typeOfPayment = paymentRec.Id;
            wrapObj.distributionChannelId = distributionChannelObj.Id;
            wrapObj.divisionId = DivisionObj.Id;
            
            
            
            solst.add(wrapObj);
            
            String serlizeStr = JSON.serialize(wrapObj);  
            String serlizeStr3 = JSON.serialize(solst);  
            List<String> orderItemList=new List<String>();
            orderItemList.add(serlizeStr3);
            System.debug('serlizeStr in the test class  '+serlizeStr);
            System.debug('serlizeStr in the test class3  '+serlizeStr3);
            Poland_SalesOrder_Controller.saveOrder(acc2.Id,serlizeStr,null,paymentRec.Id,sobj.Id,orderItemList);
            Poland_SalesOrder_Controller.saveSalesOrder(so2,serlizeStr3,sobj.Id,'cloneOrder',System.today());
            
            Poland_SalesOrder_Controller.getincotermCode(sobj.Id);
            Poland_SalesOrder_Controller.getdiscount();
            Poland_SalesOrder_Controller.gettingSKUInventories(skurec.Id);
            Poland_SalesOrder_Controller.gettingPaymentMethodList();
            List<String> parentList = new List<String>();
            parentList.add(so2.id); 
            List<String> attachList = new List<String>();
            List<String> attachList2 = new List<String>();
            
            attachList.add(attach.Id);
            Poland_SalesOrder_Controller.saveChunk(JSON.serialize(parentList),'fileName','gdsytrsrthj','bdftytrdcu',JSON.serialize(attachList));
            Poland_SalesOrder_Controller.saveTheFile(acc2.Id, 'fileName', 'gdsytrsrthj', 'contentType'); 
            Poland_SalesOrder_Controller.clubbingSKUs(serlizeStr3);
            Poland_SalesOrder_Controller.getfileNames(SalesOrderObj.Id);
            Poland_SalesOrder_Controller.showOrderTemplates(acc2.Id);
            Poland_SalesOrder_Controller.saveTemplate(acc2.Id, serlizeStr3, 'templateName', sobj.Id);
            Poland_SalesOrder_Controller.getEntity(OrderTempObj.Id);
            Poland_SalesOrder_Controller.getEntityAll(OrderTempObj.Id);
            Poland_SalesOrder_Controller.deleteSaleOrderItems(SalesOrderObj.Id);
            Poland_SalesOrder_Controller.getDistributorTypePolands(acc2.Id);
            Poland_SalesOrder_Controller.getEntity1(OrderTempObj.Id);
            Poland_SalesOrder_Controller.getDetailsTemp(OrderTempObj.Id);
            Poland_SalesOrder_Controller.viewOrderSummary(SalesOrderObj.Id);
            Poland_SalesOrder_Controller.getOrderFields1(acc2.Id);
            Poland_SalesOrder_Controller.gettingPriceBookPrices('57106710000000000006180633',accObj.Id);
            Poland_SalesOrder_Controller.gettingBigVolDiscounts('57106710000000000006180633');
            Poland_SalesOrder_Controller.gettingEarlyOrderDiscounts('57106710000000000006180633');
            Poland_SalesOrder_Controller.gettingManualDisc('57106710000000000006180633', accObj.Id);
            Poland_SalesOrder_Controller.getUserInfo();
            //Added by Nandhini CR:APPS-2521
            Poland_SalesOrder_Controller.getDependentSKUData(acc2.Id,'000000000006061000',10,'Next50days');
            //Poland_SalesOrder_Controller.OrderItems(cartWrap,ord,OwrapObj,paymentRec.Id);
            
        }
        
        
        test.stopTest();         
    }
/*  
* Name: keyAccountMangerMethodRegulartype    
* return:void
* Description: SCTASK1010530-This method responsible to cover changes related to Poland(Key Account Manager)
               and distributor type as Regular
*/ 
    @isTest
    public static void keyAccountMangerMethodRegulartype()
    {
        Test.startTest();
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '2941'];
        Inco_Term__c IncoTermObj=[select id,name from Inco_Term__c limit 1];
        Account acc2 = [SELECT id FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'SAR123' LIMIT 1]; 
        user userObj=[select id,name,email,username from user where username='zonal_aaexe1232@u345.com.devbox'];
        SKU__c skurec = [SELECT Id, SKU_Description__c,Unit_Cost__c, SKU_Code__c FROM SKU__c where SKU_Description__c = 'FURYY 40 EC X 250 cc' LIMIT 1]; 
        Distribution_Channel__c distributionChannelObj=[select id,Name,Distribution_Channel_Code__c,Description__c from Distribution_Channel__c limit 1];
        Payment_Term__c paymentRec  = [SELECT Id, Payment_Term_Code__c FROM Payment_Term__c WHERE Sales_Org__c = :sorg.Id AND Payment_Term_Code__c = 'UK01' LIMIT 1];
        OrderLineItem__c ordItem=[select id,SKU_Name__c,FinalPrice__c,pallet_Size_Italy__c,Transport_contribution__c,Discount2__c,Average_Final_Price__c,Quantity__c,Special_Discount__c,Price__c,Shipping_Date__c,Net_Invoice_Price__c,Order__c,Net_Price__c from OrderLineItem__c limit 1 ];
        Division__c DivisionObj=[select id,Name,Division_Code__c from Division__c limit 1 ];
        Account accObjNon=[select id from Account where sap_Code__c='000102323456789' limit 1];
        Shipping_Location__c shippingLocationObj=[select id,Location_Name__c,SAP_Code__c,Distributor__c,City__c,Billing_Street_1__c,State__c,Country__c,Billing_Street_3__c,Pincode__c,Sold_To_Party_SAP_Code__c,Combination_Key__c,Country_Name__c,Sales_Org__c,Distribution_Channel__c,Division__c from Shipping_Location__c limit 1];
        Order__c orderid=[Select Id from Order__c limit 1];
        List<Id> itemListId=new List<Id>();
        itemListId.add(ordItem.Id);
        Sales_Order__c salesOrder=[Select Id from Sales_Order__c limit 1];
        system.runas(userObj)
        {
            Poland_SalesOrder_Controller.SalesOrderItem OwrapObj = new Poland_SalesOrder_Controller.SalesOrderItem();
            List<Poland_SalesOrder_Controller.SalesOrderItem> OwrapObjlst = new List<Poland_SalesOrder_Controller.SalesOrderItem>(); 
            OwrapObj.productId = skurec.Id; 
            OwrapObj.palletSize =100.00;
            OwrapObj.skuId = skurec.id;
            OwrapObj.distributionChannelId = distributionChannelObj.Id;
            
            OwrapObj.qty = 14;          
            OwrapObj.typeOfPayment = paymentRec.Id;
            OwrapObjlst.add(OwrapObj);
            String serlizeStr1 = JSON.serialize(OwrapObj);  
            String serlizeStr2 = JSON.serialize(OwrapObjlst);
            
            Sales_Order__c so2 = new Sales_Order__c();
            so2.Payment_Term__c = paymentRec.Id;      
            so2.Ship_To_Party__c = shippingLocationObj.Id;
            so2.Sold_to_Party__c = acc2.Id;   
            so2.Order_Status__c ='Pending';
            so2.Sent_for_Manager_Approval_Mexico__c=true;
            List<Poland_SalesOrder_Controller.SalesOrderItem> solst = new List<Poland_SalesOrder_Controller.SalesOrderItem>(); 
            Poland_SalesOrder_Controller.SalesOrderItem wrapObj = new Poland_SalesOrder_Controller.SalesOrderItem();
            
            wrapObj.productId = skurec.id;
            wrapObj.productName = skurec.SKU_Description__c;
            wrapObj.skuId = skurec.id;
            wrapObj.qty = 50;
            wrapObj.UOM ='L';
            wrapObj.oliId = ordItem.Id;
            wrapObj.typeOfPayment = paymentRec.Id;
            wrapObj.distributionChannelId = distributionChannelObj.Id;
            wrapObj.divisionId = DivisionObj.Id;
            solst.add(wrapObj);
            Poland_SalesOrder_Controller.SalesOrderItem wrapObj1 = new Poland_SalesOrder_Controller.SalesOrderItem();
            wrapObj1.productId = skurec.id;
            wrapObj1.productName = skurec.SKU_Description__c;
            wrapObj1.skuId = skurec.id;
            wrapObj1.qty = 50;
            wrapObj1.UOM ='L';
            wrapObj1.oliId = ordItem.Id;
            wrapObj1.typeOfPayment = paymentRec.Id;
            wrapObj1.distributionChannelId = distributionChannelObj.Id;
            wrapObj1.divisionId = DivisionObj.Id;
            solst.add(wrapObj1);
            String serlizeStr = JSON.serialize(wrapObj);  
            String serlizeStr3 = JSON.serialize(solst);  
            System.debug('serlizeStr in the test class  '+serlizeStr);
            System.debug('serlizeStr in the test class3  '+serlizeStr3);
            Poland_SalesOrder_Controller.saveSalesOrder(so2,serlizeStr3,IncoTermObj.Id,'cloneOrder',System.today());
            Poland_SalesOrder_Controller.deleteOItem(itemListId,orderid.Id,'0');
            Poland_SalesOrder_Controller.deleteSalesOrderLineItem(salesOrder.Id);
            Poland_SalesOrder_Controller.deleteOrderItems(orderid.Id); //Added by Nandhini CR:APPS-2521
           
            
        }
        Test.stopTest();
    }
    
/*  
* Name: KeyAccountManagerNonRegular    
* return:void 
* Description: SCTASK1010530-This method responsible to cover changes related to Poland(Key Account Manager)
               and distributor type as Non Regular
*/    
    @isTest
    public static void KeyAccountManagerNonRegular()
    {
        Test.startTest();
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '2941'];
        Inco_Term__c incotermObj=[select id,name from Inco_Term__c limit 1];
        Account acc2 = [SELECT id FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'SAR123' LIMIT 1]; 
        user userobj=[select id,name,email,username from user where username='zonal_aaexe1232@u345.com.devbox'];
        SKU__c skurec = [SELECT Id, SKU_Description__c,Unit_Cost__c, SKU_Code__c FROM SKU__c where SKU_Description__c = 'FURYY 40 EC X 250 cc' LIMIT 1]; 
        Distribution_Channel__c distributionChannelObj=[select id,Name,Distribution_Channel_Code__c,Description__c from Distribution_Channel__c limit 1];
        Payment_Term__c paymentRec  = [SELECT Id, Payment_Term_Code__c FROM Payment_Term__c WHERE Sales_Org__c = :sorg.Id AND Payment_Term_Code__c = 'UK01' LIMIT 1];
        OrderLineItem__c ordItem=[select id,SKU_Name__c,FinalPrice__c,pallet_Size_Italy__c,Transport_contribution__c,Discount2__c,Average_Final_Price__c,Quantity__c,Special_Discount__c,Price__c,Shipping_Date__c,Net_Invoice_Price__c,Order__c,Net_Price__c from OrderLineItem__c limit 1 ];
        Division__c DivisionObj=[select id,Name,Division_Code__c from Division__c limit 1 ];
        Account accObjNon=[select id from Account where sap_Code__c='000102323456789' limit 1];
        Shipping_Location__c shippingLocationObj=[select id,Location_Name__c,SAP_Code__c,Distributor__c,City__c,Billing_Street_1__c,State__c,Country__c,Billing_Street_3__c,Pincode__c,Sold_To_Party_SAP_Code__c,Combination_Key__c,Country_Name__c,Sales_Org__c,Distribution_Channel__c,Division__c from Shipping_Location__c limit 1];
        
        system.runas(userobj)
        {
            Poland_SalesOrder_Controller.SalesOrderItem OwrapObj = new Poland_SalesOrder_Controller.SalesOrderItem();
            List<Poland_SalesOrder_Controller.SalesOrderItem> OwrapObjlst = new List<Poland_SalesOrder_Controller.SalesOrderItem>(); 
            OwrapObj.productId = skurec.Id; 
            OwrapObj.palletSize =100.00;
            OwrapObj.skuId = skurec.id;
            OwrapObj.distributionChannelId = distributionChannelObj.Id;
            
            OwrapObj.qty = 14;          
            OwrapObj.typeOfPayment = paymentRec.Id;
            OwrapObjlst.add(OwrapObj);
            String serlizeStr1 = JSON.serialize(OwrapObj);  
            String serlizeStr2 = JSON.serialize(OwrapObjlst);
            
            Sales_Order__c so3Non = new Sales_Order__c();
            so3Non.Payment_Term__c = paymentRec.Id;      
            so3Non.Ship_To_Party__c = shippingLocationObj.Id;
            so3Non.Sold_to_Party__c = accObjNon.Id;   
            so3Non.Order_Status__c ='Pending';
            so3Non.Sent_for_Manager_Approval_Mexico__c=true;
            
            List<Poland_SalesOrder_Controller.SalesOrderItem> solst = new List<Poland_SalesOrder_Controller.SalesOrderItem>(); 
            Poland_SalesOrder_Controller.SalesOrderItem wrapObj = new Poland_SalesOrder_Controller.SalesOrderItem();
            wrapObj.productId = skurec.id;
            wrapObj.productName = skurec.SKU_Description__c;
            wrapObj.skuId = skurec.id;
            wrapObj.qty = 50;
            wrapObj.UOM ='L';
            wrapObj.oliId = ordItem.Id;
            wrapObj.typeOfPayment = paymentRec.Id;
            wrapObj.distributionChannelId = distributionChannelObj.Id;
            wrapObj.divisionId = DivisionObj.Id;
            
            solst.add(wrapObj);
            String serlizeStr = JSON.serialize(wrapObj);  
            String serlizeStr3 = JSON.serialize(solst);  
            System.debug('serlizeStr in the test class  '+serlizeStr);
            System.debug('serlizeStr in the test class3  '+serlizeStr3);
            
            Poland_SalesOrder_Controller.saveSalesOrder(so3Non,serlizeStr3,incotermObj.Id,'cloneOrder',System.today());
        }
        Test.stopTest();
    }    
    /*  
* Name: Poland_SalesOrder_Controller_Test    
* return:void  
* Description: SCTASK1010530-This method responsible to cover changes related to Poland(wholesale sales Manager) 
               and distributor type as Non Regular
*/ 
    @isTest
    public static void WholesaleSalesManagerNonRegularType()
    {
        Test.startTest();
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '2941'];
        Inco_Term__c incotermObj=[select id,name from Inco_Term__c limit 1];
        Account acc2 = [SELECT id FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'SAR123' LIMIT 1]; 
        user userObj=[select id,name,email,username from user where username='zonal_aaexe1232@upl122333.com.devbox'];
        SKU__c skurec = [SELECT Id, SKU_Description__c,Unit_Cost__c, SKU_Code__c FROM SKU__c where SKU_Description__c = 'FURYY 40 EC X 250 cc' LIMIT 1]; 
        Distribution_Channel__c distributionChannelObj=[select id,Name,Distribution_Channel_Code__c,Description__c from Distribution_Channel__c limit 1];
        Payment_Term__c paymentRec  = [SELECT Id, Payment_Term_Code__c FROM Payment_Term__c WHERE Sales_Org__c = :sorg.Id AND Payment_Term_Code__c = 'UK01' LIMIT 1];
        OrderLineItem__c ordItem=[select id,SKU_Name__c,FinalPrice__c,pallet_Size_Italy__c,Transport_contribution__c,Discount2__c,Average_Final_Price__c,Quantity__c,Special_Discount__c,Price__c,Shipping_Date__c,Net_Invoice_Price__c,Order__c,Net_Price__c from OrderLineItem__c limit 1 ];
        Division__c DivisionObj=[select id,Name,Division_Code__c from Division__c limit 1 ];
        Account accObjNon=[select id from Account where sap_Code__c='000102323456789' limit 1];
        Shipping_Location__c shippingLocationObj=[select id,Location_Name__c,SAP_Code__c,Distributor__c,City__c,Billing_Street_1__c,State__c,Country__c,Billing_Street_3__c,Pincode__c,Sold_To_Party_SAP_Code__c,Combination_Key__c,Country_Name__c,Sales_Org__c,Distribution_Channel__c,Division__c from Shipping_Location__c limit 1];
        
        system.runas(userObj)
        {
            Poland_SalesOrder_Controller.SalesOrderItem OwrapObj = new Poland_SalesOrder_Controller.SalesOrderItem();
            List<Poland_SalesOrder_Controller.SalesOrderItem> OwrapObjlst = new List<Poland_SalesOrder_Controller.SalesOrderItem>(); 
            OwrapObj.productId = skurec.Id; 
            OwrapObj.palletSize =100.00;
            OwrapObj.skuId = skurec.id;
            OwrapObj.distributionChannelId = distributionChannelObj.Id;
            
            OwrapObj.qty = 14;          
            OwrapObj.typeOfPayment = paymentRec.Id;
            OwrapObjlst.add(OwrapObj);
            String serlizeStr1 = JSON.serialize(OwrapObj);  
            String serlizeStr2 = JSON.serialize(OwrapObjlst);
            
            Sales_Order__c so3Non = new Sales_Order__c();
            so3Non.Payment_Term__c = paymentRec.Id;      
            so3Non.Ship_To_Party__c = shippingLocationObj.Id;
            so3Non.Sold_to_Party__c = accObjNon.Id;   
            so3Non.Order_Status__c ='Pending';
            so3Non.Sent_for_Manager_Approval_Mexico__c=true;
            
            List<Poland_SalesOrder_Controller.SalesOrderItem> solst = new List<Poland_SalesOrder_Controller.SalesOrderItem>(); 
            Poland_SalesOrder_Controller.SalesOrderItem wrapObj = new Poland_SalesOrder_Controller.SalesOrderItem();
            
            wrapObj.productId = skurec.id;
            wrapObj.productName = skurec.SKU_Description__c;
            wrapObj.skuId = skurec.id;
            wrapObj.qty = 50;
            wrapObj.UOM ='L';
            wrapObj.oliId = ordItem.Id;
            wrapObj.typeOfPayment = paymentRec.Id;
            wrapObj.distributionChannelId = distributionChannelObj.Id;
            wrapObj.divisionId = DivisionObj.Id;
            
            solst.add(wrapObj);
            String serlizeStr = JSON.serialize(wrapObj);  
            String serlizeStr3 = JSON.serialize(solst);  
            System.debug('serlizeStr in the test class  '+serlizeStr);
            System.debug('serlizeStr in the test class3  '+serlizeStr3);
            
            Poland_SalesOrder_Controller.saveSalesOrder(so3Non,serlizeStr3,incotermObj.Id,'cloneOrder',System.today());
        }
        Test.stopTest();
    }  
/*  
* Name: Poland_SalesOrder_Controller_Test    
* return:void  
* Description: SCTASK1010530-This method responsible to cover changes related to Customer Community Plus User - Poland- 1
*/   
    
    @isTest
    public static void CustomerCommunityPlusUser()
    {
        Test.startTest();
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '2941'];
        Inco_Term__c IncoTermObj=[select id,name from Inco_Term__c limit 1];
        Account acc2 = [SELECT id FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'SAR123' LIMIT 1]; 
        user userObj=[select id,name,email,username from user where username='zonal_aaexe1232@upl12.com.devbox'];
        SKU__c skurec = [SELECT Id, SKU_Description__c,Unit_Cost__c, SKU_Code__c FROM SKU__c where SKU_Description__c = 'FURYY 40 EC X 250 cc' LIMIT 1]; 
        Distribution_Channel__c distributionChannelObj=[select id,Name,Distribution_Channel_Code__c,Description__c from Distribution_Channel__c limit 1];
        Payment_Term__c paymentRec  = [SELECT Id, Payment_Term_Code__c FROM Payment_Term__c WHERE Sales_Org__c = :sorg.Id AND Payment_Term_Code__c = 'UK01' LIMIT 1];
        OrderLineItem__c ordItem=[select id,SKU_Name__c,FinalPrice__c,pallet_Size_Italy__c,Transport_contribution__c,Discount2__c,Average_Final_Price__c,Quantity__c,Special_Discount__c,Price__c,Shipping_Date__c,Net_Invoice_Price__c,Order__c,Net_Price__c from OrderLineItem__c limit 1 ];
        Division__c DivisionObj=[select id,Name,Division_Code__c from Division__c limit 1 ];
        Account accObjNon=[select id from Account where sap_Code__c='000102323456789' limit 1];
        Shipping_Location__c shippingLocationObj=[select id,Location_Name__c,SAP_Code__c,Distributor__c,City__c,Billing_Street_1__c,State__c,Country__c,Billing_Street_3__c,Pincode__c,Sold_To_Party_SAP_Code__c,Combination_Key__c,Country_Name__c,Sales_Org__c,Distribution_Channel__c,Division__c from Shipping_Location__c limit 1];
        
        system.runas(userObj)
        {
            Poland_SalesOrder_Controller.SalesOrderItem OwrapObj = new Poland_SalesOrder_Controller.SalesOrderItem();
            List<Poland_SalesOrder_Controller.SalesOrderItem> OwrapObjlst = new List<Poland_SalesOrder_Controller.SalesOrderItem>(); 
            OwrapObj.productId = skurec.Id; 
            OwrapObj.palletSize =100.00;
            OwrapObj.skuId = skurec.id;
            OwrapObj.distributionChannelId = distributionChannelObj.Id;
            
            OwrapObj.qty = 14;          
            OwrapObj.typeOfPayment = paymentRec.Id;
            OwrapObjlst.add(OwrapObj);
            String serlizeStr1 = JSON.serialize(OwrapObj);  
            String serlizeStr2 = JSON.serialize(OwrapObjlst);
            Sales_Order__c so3Non = new Sales_Order__c();
            so3Non.Payment_Term__c = paymentRec.Id;      
            so3Non.Ship_To_Party__c = shippingLocationObj.Id;
            so3Non.Sold_to_Party__c = accObjNon.Id;   
            so3Non.Order_Status__c ='Pending';
            so3Non.Sent_for_Manager_Approval_Mexico__c=true;
            
            List<Poland_SalesOrder_Controller.SalesOrderItem> solst = new List<Poland_SalesOrder_Controller.SalesOrderItem>(); 
            Poland_SalesOrder_Controller.SalesOrderItem wrapObj = new Poland_SalesOrder_Controller.SalesOrderItem();
            
            wrapObj.productId = skurec.id;
            wrapObj.productName = skurec.SKU_Description__c;
            wrapObj.skuId = skurec.id;
            wrapObj.qty = 50;
            wrapObj.UOM ='L';
            wrapObj.oliId = ordItem.Id;
            wrapObj.typeOfPayment = paymentRec.Id;
            wrapObj.distributionChannelId = distributionChannelObj.Id;
            wrapObj.divisionId = DivisionObj.Id;
            
            solst.add(wrapObj);
            String serlizeStr = JSON.serialize(wrapObj);  
            String serlizeStr3 = JSON.serialize(solst);  
            System.debug('serlizeStr in the test class  '+serlizeStr);
            System.debug('serlizeStr in the test class3  '+serlizeStr3);
            Poland_SalesOrder_Controller.saveSalesOrder(so3Non,serlizeStr3,IncoTermObj.Id,'',System.today());
            
        }
        Test.stopTest();
    } 
    
    /*  
* Name: Poland_SalesOrder_Controller_Test    
* return:void   
* Description: SCTASK1010530-This method responsible to cover changes related to Poland(Key Account Manager)
               with 2 And 3 Distibutors
*/ 
    @isTest
    public static void KeyAccountManagerWith2And3Users()
    {
        Test.startTest();
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '2941'];
        Inco_Term__c IncoTermObj=[select id,name from Inco_Term__c limit 1];
        Account acc2 = [SELECT id FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'SAR123' LIMIT 1]; 
        user UserObj=[select id,name,email,username from user where username='zonal_aaexe1232@u345.com.devbox'];
        SKU__c skurec = [SELECT Id, SKU_Description__c,Unit_Cost__c, SKU_Code__c FROM SKU__c where SKU_Description__c = 'FURYY 40 EC X 250 cc' LIMIT 1]; 
        Distribution_Channel__c distributionChannelObj=[select id,Name,Distribution_Channel_Code__c,Description__c from Distribution_Channel__c limit 1];
        Payment_Term__c paymentRec  = [SELECT Id, Payment_Term_Code__c FROM Payment_Term__c WHERE Sales_Org__c = :sorg.Id AND Payment_Term_Code__c = 'UK01' LIMIT 1];
        OrderLineItem__c ordItem=[select id,SKU_Name__c,FinalPrice__c,pallet_Size_Italy__c,Transport_contribution__c,Discount2__c,Average_Final_Price__c,Quantity__c,Special_Discount__c,Price__c,Shipping_Date__c,Net_Invoice_Price__c,Order__c,Net_Price__c from OrderLineItem__c limit 1 ];
        Division__c DivisionObj=[select id,Name,Division_Code__c from Division__c limit 1 ];
        Account accObjNon=[select id from Account where sap_Code__c='000102323456789' limit 1];
        Shipping_Location__c shippingLocationObj=[select id,Location_Name__c,SAP_Code__c,Distributor__c,City__c,Billing_Street_1__c,State__c,Country__c,Billing_Street_3__c,Pincode__c,Sold_To_Party_SAP_Code__c,Combination_Key__c,Country_Name__c,Sales_Org__c,Distribution_Channel__c,Division__c from Shipping_Location__c limit 1];
        Id devRecordAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        List<Account> acclistNew=new List<Account>();
        Account accObjNon1 = new Account(
            Name = 'SAR223434',                                                            // Account Name
            //OwnerId = user.id,
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'SAR223434',                                         // Last Name
            SAP_Code__c = '00010232534',                                        // SAP Customer Code
            Mobile__c = '087654321334',                                          // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '86005897945',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentRec.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07',                                         // Payment Terms
            //PriceGroupCode__c =priceGroupMasterObj.Id,                            // Tax classification for customer
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c='',
            Distributor_Type_Poland__c ='Regular Customer'
        );
        acclistNew.add(accObjNon1);
        Account accObjNon2 = new Account(
            Name = 'SAR223456',                                                            // Account Name
            //OwnerId = user.id,
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'SAR223456',                                         // Last Name
            SAP_Code__c = '00014532534',                                        // SAP Customer Code
            Mobile__c = '087654356334',                                          // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '86005897215',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentRec.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07',                                         // Payment Terms
            //PriceGroupCode__c =priceGroupMasterObj.Id,                            // Tax classification for customer
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c='',
            Distributor_Type_Poland__c ='Regular Customer'
        );
        acclistNew.add(accObjNon2);
        insert acclistNew;
        List<contact> conlist=new List<contact>();
        Contact con11 = new Contact();
        con11.AccountId=acclistNew[0].Id;
        con11.LastName=acclistNew[0].Last_Name__c;
        con11.Is_Community__c=true;
        con11.MobilePhone ='9876543211';
        con11.Phone = '5592619030';
        con11.Is_Community__c = true;
        conlist.add(con11);
        
        Contact con12 = new Contact();
        con12.AccountId=acclistNew[0].Id;
        con12.LastName=acclistNew[0].Last_Name__c;
        con12.Is_Community__c=true;
        con12.MobilePhone ='9876543211';
        con12.Phone = '5592619030';
        con12.Is_Community__c = true;
        conlist.add(con12);
        
        
        Contact con13 = new Contact();
        con13.AccountId=acclistNew[1].Id;
        con13.LastName=acclistNew[1].Last_Name__c;
        con13.Is_Community__c=true;
        con13.MobilePhone ='9876543211';
        con13.Phone = '5592619030';
        con13.Is_Community__c = true;
        conlist.add(con13);
        
        Contact con14 = new Contact();
        con14.AccountId=acclistNew[1].Id;
        con14.LastName=acclistNew[1].Last_Name__c;
        con14.Is_Community__c=true;
        con14.MobilePhone ='9876543211';
        con14.Phone = '5592619030';
        con14.Is_Community__c = true;
        conlist.add(con14);
        
        Contact con15 = new Contact();
        con15.AccountId=acclistNew[1].Id;
        con15.LastName=acclistNew[1].Last_Name__c;
        con15.Is_Community__c=true;
        con15.MobilePhone ='9876543211';
        con15.Phone = '5592619030';
        con15.Is_Community__c = true;
        conlist.add(con15);
        
        insert conlist;
        profile pDistributor=[select id from profile where name='Customer Community Plus User - Poland - 1'];
        userrole  usrole2 = new userrole();
        usrole2.Name ='AGROPESTCustomerUser';
        List<user> userlistNew=new list<user>();
        user AccConUser1=new user();
        AccConUser1.Alias = 'zonaa11';                                                            
        AccConUser1.Email = 'ski8m@skinternational1.com';                             
        AccConUser1.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser1.UserRoleId=usrole2.id;
        AccConUser1.Username = 'zo8nal_aaexe1232@upl12.com.devbox';                                    
        AccConUser1.IsActive = true;  
        AccConUser1.LastName='Terriotory Manager';
        AccConUser1.CommunityNickname = 'zon8alExe12Di'; 
        AccConUser1.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser1.LocaleSidKey = 'en_IN';                                    
        AccConUser1.LanguageLocaleKey = 'en_US';                                             
        AccConUser1.ForecastEnabled = false;                                                     
        AccConUser1.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser1.Show_Inventory__c = false;                                                     
        AccConUser1.Show_Credit_Limit__c = false; 
        AccConUser1.ContactId=con11.id; 
        userlistNew.add(AccConUser1);
        
        user AccConUser2=new user();
        AccConUser2.Alias = 'zonaa12';                                                            
        AccConUser2.Email = 'sk7im@skinternational1.com';                             
        AccConUser2.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser2.UserRoleId=usrole2.id;
        AccConUser2.Username = 'zonal_aaexe71232@upl12.com.devbox';                                    
        AccConUser2.IsActive = true;  
        AccConUser2.LastName='Terriotory Manager';
        AccConUser2.CommunityNickname = 'zona7lExe12Di'; 
        AccConUser2.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser2.LocaleSidKey = 'en_IN';                                    
        AccConUser2.LanguageLocaleKey = 'en_US';                                             
        AccConUser2.ForecastEnabled = false;                                                     
        AccConUser2.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser2.Show_Inventory__c = false;                                                     
        AccConUser2.Show_Credit_Limit__c = false; 
        AccConUser2.ContactId=con12.id; 
        userlistNew.add(AccConUser2);
        
        
        user AccConUser3=new user();
        AccConUser3.Alias = 'zonaa13';                                                            
        AccConUser3.Email = 'skim1@skinternational1.com';                             
        AccConUser3.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser3.UserRoleId=usrole2.id;
        AccConUser3.Username = 'zona1l_aaexe1232@upl12.com.devbox';                                    
        AccConUser3.IsActive = true;  
        AccConUser3.LastName='Terriotory Manager';
        AccConUser3.CommunityNickname = 'zona1lExe12Di'; 
        AccConUser3.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser3.LocaleSidKey = 'en_IN';                                    
        AccConUser3.LanguageLocaleKey = 'en_US';                                             
        AccConUser3.ForecastEnabled = false;                                                     
        AccConUser3.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser3.Show_Inventory__c = false;                                                     
        AccConUser3.Show_Credit_Limit__c = false; 
        AccConUser3.ContactId=con13.id; 
        userlistNew.add(AccConUser3);
        
        user AccConUser4=new user();
        AccConUser4.Alias = 'zonaa14';                                                            
        AccConUser4.Email = 'ski2m@skinternational1.com';                             
        AccConUser4.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser4.UserRoleId=usrole2.id;
        AccConUser4.Username = 'zonal_a2aexe1232@upl12.com.devbox';                                    
        AccConUser4.IsActive = true;  
        AccConUser4.LastName='Terriotory Manager';
        AccConUser4.CommunityNickname = 'zon2alExe12Di'; 
        AccConUser4.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser4.LocaleSidKey = 'en_IN';                                    
        AccConUser4.LanguageLocaleKey = 'en_US';                                             
        AccConUser4.ForecastEnabled = false;                                                     
        AccConUser4.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser4.Show_Inventory__c = false;                                                     
        AccConUser4.Show_Credit_Limit__c = false; 
        AccConUser4.ContactId=con14.id; 
        userlistNew.add(AccConUser4);
        
        user AccConUser5=new user();
        AccConUser5.Alias = 'zonaa15';                                                            
        AccConUser5.Email = 'skim3@skinternational1.com';                             
        AccConUser5.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser5.UserRoleId=usrole2.id;
        AccConUser5.Username = 'zonal_aaexe31232@upl12.com.devbox';                                    
        AccConUser5.IsActive = true;  
        AccConUser5.LastName='Terriotory Manager';
        AccConUser5.CommunityNickname = 'z3onalExe12Di'; 
        AccConUser5.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser5.LocaleSidKey = 'en_IN';                                    
        AccConUser5.LanguageLocaleKey = 'en_US';                                             
        AccConUser5.ForecastEnabled = false;                                                     
        AccConUser5.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser5.Show_Inventory__c = false;                                                     
        AccConUser5.Show_Credit_Limit__c = false; 
        AccConUser5.ContactId=con15.id; 
        userlistNew.add(AccConUser5);
        
        insert userlistNew;
        
        system.runas(UserObj)
        {
            Poland_SalesOrder_Controller.SalesOrderItem OwrapObj = new Poland_SalesOrder_Controller.SalesOrderItem();
            List<Poland_SalesOrder_Controller.SalesOrderItem> OwrapObjlst = new List<Poland_SalesOrder_Controller.SalesOrderItem>(); 
            OwrapObj.productId = skurec.Id; 
            OwrapObj.palletSize =100.00;
            OwrapObj.skuId = skurec.id;
            OwrapObj.distributionChannelId = distributionChannelObj.Id;
            
            OwrapObj.qty = 14;          
            OwrapObj.typeOfPayment = paymentRec.Id;
            OwrapObjlst.add(OwrapObj);
            String serlizeStr1 = JSON.serialize(OwrapObj);  
            String serlizeStr2 = JSON.serialize(OwrapObjlst);
            
            Sales_Order__c so2 = new Sales_Order__c();
            so2.Payment_Term__c = paymentRec.Id;      
            so2.Ship_To_Party__c = shippingLocationObj.Id;
            so2.Sold_to_Party__c = acclistNew[0].Id;   
            so2.Order_Status__c ='Pending';
            so2.Sent_for_Manager_Approval_Mexico__c=true;
            Sales_Order__c so3Non = new Sales_Order__c();
            so3Non.Payment_Term__c = paymentRec.Id;      
            so3Non.Ship_To_Party__c = shippingLocationObj.Id;
            so3Non.Sold_to_Party__c = acclistNew[1].Id;   
            so3Non.Order_Status__c ='Pending';
            so3Non.Sent_for_Manager_Approval_Mexico__c=true;
            
            List<Poland_SalesOrder_Controller.SalesOrderItem> solst = new List<Poland_SalesOrder_Controller.SalesOrderItem>(); 
            Poland_SalesOrder_Controller.SalesOrderItem wrapObj = new Poland_SalesOrder_Controller.SalesOrderItem();
            
            wrapObj.productId = skurec.id;
            wrapObj.productName = skurec.SKU_Description__c;
            wrapObj.skuId = skurec.id;
            wrapObj.qty = 50;
            wrapObj.UOM ='L';
            wrapObj.oliId = ordItem.Id;
            wrapObj.typeOfPayment = paymentRec.Id;
            wrapObj.distributionChannelId = distributionChannelObj.Id;
            wrapObj.divisionId = DivisionObj.Id;
            
            solst.add(wrapObj);
            String serlizeStr = JSON.serialize(wrapObj);  
            String serlizeStr3 = JSON.serialize(solst);  
            System.debug('serlizeStr in the test class  '+serlizeStr);
            System.debug('serlizeStr in the test class3  '+serlizeStr3);
            Poland_SalesOrder_Controller.saveSalesOrder(so3Non,serlizeStr3,IncoTermObj.Id,'cloneOrder',System.today());
            
            Poland_SalesOrder_Controller.saveSalesOrder(so2,serlizeStr3,IncoTermObj.Id,'cloneOrder',System.today());
        }
        Test.stopTest();
    }
    
    /*  
* Name: Poland_SalesOrder_Controller_Test    
* return:void   
* Description: SCTASK1010530-This method responsible to cover changes related to Poland(wholeSale Sales Manager) 
               with 2 and 3 Distibutors
*/   
    @isTest
    public static void wholeSaleSalesMangerWith2And3Users()
    {
        Test.startTest();
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '2941'];
        Inco_Term__c IncoTermObj=[select id,name from Inco_Term__c limit 1];
        Account acc2 = [SELECT id FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'SAR123' LIMIT 1]; 
        user UserObj=[select id,name,email,username from user where username='zonal_aaexe1232@upl122333.com.devbox'];
        SKU__c skurec = [SELECT Id, SKU_Description__c,Unit_Cost__c, SKU_Code__c FROM SKU__c where SKU_Description__c = 'FURYY 40 EC X 250 cc' LIMIT 1]; 
        Distribution_Channel__c distributionChannelObj=[select id,Name,Distribution_Channel_Code__c,Description__c from Distribution_Channel__c limit 1];
        Payment_Term__c paymentRec  = [SELECT Id, Payment_Term_Code__c FROM Payment_Term__c WHERE Sales_Org__c = :sorg.Id AND Payment_Term_Code__c = 'UK01' LIMIT 1];
        OrderLineItem__c ordItem=[select id,SKU_Name__c,FinalPrice__c,pallet_Size_Italy__c,Transport_contribution__c,Discount2__c,Average_Final_Price__c,Quantity__c,Special_Discount__c,Price__c,Shipping_Date__c,Net_Invoice_Price__c,Order__c,Net_Price__c from OrderLineItem__c limit 1 ];
        Division__c DivisionObj=[select id,Name,Division_Code__c from Division__c limit 1 ];
        Account accObjNon=[select id from Account where sap_Code__c='000102323456789' limit 1];
        Shipping_Location__c shippingLocationObj=[select id,Location_Name__c,SAP_Code__c,Distributor__c,City__c,Billing_Street_1__c,State__c,Country__c,Billing_Street_3__c,Pincode__c,Sold_To_Party_SAP_Code__c,Combination_Key__c,Country_Name__c,Sales_Org__c,Distribution_Channel__c,Division__c from Shipping_Location__c limit 1];
        Id devRecordAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        List<Account> acclistNew=new List<Account>();
        Account accObjNon1 = new Account(
            Name = 'SAR223434',                                                            // Account Name
            //OwnerId = user.id,
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'SAR223434',                                         // Last Name
            SAP_Code__c = '00010232534',                                        // SAP Customer Code
            Mobile__c = '087654321334',                                          // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '86005897945',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentRec.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07',                                         // Payment Terms
            //PriceGroupCode__c =priceGroupMasterObj.Id,                            // Tax classification for customer
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c='',
            Distributor_Type_Poland__c ='Regular Customer'
        );
        acclistNew.add(accObjNon1);
        Account accObjNon2 = new Account(
            Name = 'SAR223456',                                                            // Account Name
            //OwnerId = user.id,
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'SAR223456',                                         // Last Name
            SAP_Code__c = '00014532534',                                        // SAP Customer Code
            Mobile__c = '087654356334',                                          // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '86005897215',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentRec.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07',                                         // Payment Terms
            //PriceGroupCode__c =priceGroupMasterObj.Id,                            // Tax classification for customer
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c='',
            Distributor_Type_Poland__c ='Regular Customer'
        );
        acclistNew.add(accObjNon2);
        insert acclistNew;
        List<contact> conlist=new List<contact>();
        Contact con11 = new Contact();
        con11.AccountId=acclistNew[0].Id;
        con11.LastName=acclistNew[0].Last_Name__c;
        con11.Is_Community__c=true;
        con11.MobilePhone ='9876543211';
        con11.Phone = '5592619030';
        con11.Is_Community__c = true;
        conlist.add(con11);
        
        Contact con12 = new Contact();
        con12.AccountId=acclistNew[0].Id;
        con12.LastName=acclistNew[0].Last_Name__c;
        con12.Is_Community__c=true;
        con12.MobilePhone ='9876543211';
        con12.Phone = '5592619030';
        con12.Is_Community__c = true;
        conlist.add(con12);
        
        
        Contact con13 = new Contact();
        con13.AccountId=acclistNew[1].Id;
        con13.LastName=acclistNew[1].Last_Name__c;
        con13.Is_Community__c=true;
        con13.MobilePhone ='9876543211';
        con13.Phone = '5592619030';
        con13.Is_Community__c = true;
        conlist.add(con13);
        
        Contact con14 = new Contact();
        con14.AccountId=acclistNew[1].Id;
        con14.LastName=acclistNew[1].Last_Name__c;
        con14.Is_Community__c=true;
        con14.MobilePhone ='9876543211';
        con14.Phone = '5592619030';
        con14.Is_Community__c = true;
        conlist.add(con14);
        
        Contact con15 = new Contact();
        con15.AccountId=acclistNew[1].Id;
        con15.LastName=acclistNew[1].Last_Name__c;
        con15.Is_Community__c=true;
        con15.MobilePhone ='9876543211';
        con15.Phone = '5592619030';
        con15.Is_Community__c = true;
        conlist.add(con15);
        
        insert conlist;
        profile pDistributor=[select id from profile where name='Customer Community Plus User - Poland - 1'];
        userrole  usrole2 = new userrole();
        usrole2.Name ='AGROPESTCustomerUser';
        List<user> userlistNew=new list<user>();
        user AccConUser1=new user();
        AccConUser1.Alias = 'zonaa11';                                                            
        AccConUser1.Email = 'ski8m@skinternational1.com';                             
        AccConUser1.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser1.UserRoleId=usrole2.id;
        AccConUser1.Username = 'zo8nal_aaexe1232@upl12.com.devbox';                                    
        AccConUser1.IsActive = true;  
        AccConUser1.LastName='Terriotory Manager';
        AccConUser1.CommunityNickname = 'zon8alExe12Di'; 
        AccConUser1.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser1.LocaleSidKey = 'en_IN';                                    
        AccConUser1.LanguageLocaleKey = 'en_US';                                             
        AccConUser1.ForecastEnabled = false;                                                     
        AccConUser1.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser1.Show_Inventory__c = false;                                                     
        AccConUser1.Show_Credit_Limit__c = false; 
        AccConUser1.ContactId=con11.id; 
        userlistNew.add(AccConUser1);
        
        user AccConUser2=new user();
        AccConUser2.Alias = 'zonaa12';                                                            
        AccConUser2.Email = 'sk7im@skinternational1.com';                             
        AccConUser2.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser2.UserRoleId=usrole2.id;
        AccConUser2.Username = 'zonal_aaexe71232@upl12.com.devbox';                                    
        AccConUser2.IsActive = true;  
        AccConUser2.LastName='Terriotory Manager';
        AccConUser2.CommunityNickname = 'zona7lExe12Di'; 
        AccConUser2.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser2.LocaleSidKey = 'en_IN';                                    
        AccConUser2.LanguageLocaleKey = 'en_US';                                             
        AccConUser2.ForecastEnabled = false;                                                     
        AccConUser2.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser2.Show_Inventory__c = false;                                                     
        AccConUser2.Show_Credit_Limit__c = false; 
        AccConUser2.ContactId=con12.id; 
        userlistNew.add(AccConUser2);
        
        
        user AccConUser3=new user();
        AccConUser3.Alias = 'zonaa13';                                                            
        AccConUser3.Email = 'skim1@skinternational1.com';                             
        AccConUser3.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser3.UserRoleId=usrole2.id;
        AccConUser3.Username = 'zona1l_aaexe1232@upl12.com.devbox';                                    
        AccConUser3.IsActive = true;  
        AccConUser3.LastName='Terriotory Manager';
        AccConUser3.CommunityNickname = 'zona1lExe12Di'; 
        AccConUser3.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser3.LocaleSidKey = 'en_IN';                                    
        AccConUser3.LanguageLocaleKey = 'en_US';                                             
        AccConUser3.ForecastEnabled = false;                                                     
        AccConUser3.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser3.Show_Inventory__c = false;                                                     
        AccConUser3.Show_Credit_Limit__c = false; 
        AccConUser3.ContactId=con13.id; 
        userlistNew.add(AccConUser3);
        
        user AccConUser4=new user();
        AccConUser4.Alias = 'zonaa14';                                                            
        AccConUser4.Email = 'ski2m@skinternational1.com';                             
        AccConUser4.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser4.UserRoleId=usrole2.id;
        AccConUser4.Username = 'zonal_a2aexe1232@upl12.com.devbox';                                    
        AccConUser4.IsActive = true;  
        AccConUser4.LastName='Terriotory Manager';
        AccConUser4.CommunityNickname = 'zon2alExe12Di'; 
        AccConUser4.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser4.LocaleSidKey = 'en_IN';                                    
        AccConUser4.LanguageLocaleKey = 'en_US';                                             
        AccConUser4.ForecastEnabled = false;                                                     
        AccConUser4.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser4.Show_Inventory__c = false;                                                     
        AccConUser4.Show_Credit_Limit__c = false; 
        AccConUser4.ContactId=con14.id; 
        userlistNew.add(AccConUser4);
        
        user AccConUser5=new user();
        AccConUser5.Alias = 'zonaa15';                                                            
        AccConUser5.Email = 'skim3@skinternational1.com';                             
        AccConUser5.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser5.UserRoleId=usrole2.id;
        AccConUser5.Username = 'zonal_aaexe31232@upl12.com.devbox';                                    
        AccConUser5.IsActive = true;  
        AccConUser5.LastName='Terriotory Manager';
        AccConUser5.CommunityNickname = 'z3onalExe12Di'; 
        AccConUser5.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser5.LocaleSidKey = 'en_IN';                                    
        AccConUser5.LanguageLocaleKey = 'en_US';                                             
        AccConUser5.ForecastEnabled = false;                                                     
        AccConUser5.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser5.Show_Inventory__c = false;                                                     
        AccConUser5.Show_Credit_Limit__c = false; 
        AccConUser5.ContactId=con15.id; 
        userlistNew.add(AccConUser5);
        
        insert userlistNew;
        
        system.runas(UserObj)
        {
            Poland_SalesOrder_Controller.SalesOrderItem OwrapObj = new Poland_SalesOrder_Controller.SalesOrderItem();
            List<Poland_SalesOrder_Controller.SalesOrderItem> OwrapObjlst = new List<Poland_SalesOrder_Controller.SalesOrderItem>(); 
            OwrapObj.productId = skurec.Id; 
            OwrapObj.palletSize =100.00;
            OwrapObj.skuId = skurec.id;
            OwrapObj.distributionChannelId = distributionChannelObj.Id;
            
            OwrapObj.qty = 14;          
            OwrapObj.typeOfPayment = paymentRec.Id;
            OwrapObjlst.add(OwrapObj);
            String serlizeStr1 = JSON.serialize(OwrapObj);  
            String serlizeStr2 = JSON.serialize(OwrapObjlst);
            
            Sales_Order__c so2 = new Sales_Order__c();
            so2.Payment_Term__c = paymentRec.Id;      
            so2.Ship_To_Party__c = shippingLocationObj.Id;
            so2.Sold_to_Party__c = acclistNew[0].Id;   
            so2.Order_Status__c ='Pending';
            so2.Sent_for_Manager_Approval_Mexico__c=true;
            //by nandhini
            Sales_Order__c so3Non = new Sales_Order__c();
            so3Non.Payment_Term__c = paymentRec.Id;      
            so3Non.Ship_To_Party__c = shippingLocationObj.Id;
            so3Non.Sold_to_Party__c = acclistNew[1].Id;   
            so3Non.Order_Status__c ='Pending';
            so3Non.Sent_for_Manager_Approval_Mexico__c=true;
            
            List<Poland_SalesOrder_Controller.SalesOrderItem> solst = new List<Poland_SalesOrder_Controller.SalesOrderItem>(); 
            Poland_SalesOrder_Controller.SalesOrderItem wrapObj = new Poland_SalesOrder_Controller.SalesOrderItem();
            
            wrapObj.productId = skurec.id;
            wrapObj.productName = skurec.SKU_Description__c;
            wrapObj.skuId = skurec.id;
            wrapObj.qty = 50;
            wrapObj.UOM ='L';
            wrapObj.oliId = ordItem.Id;
            wrapObj.typeOfPayment = paymentRec.Id;
            wrapObj.distributionChannelId = distributionChannelObj.Id;
            wrapObj.divisionId = DivisionObj.Id;
            
            solst.add(wrapObj);
            String serlizeStr = JSON.serialize(wrapObj);  
            String serlizeStr3 = JSON.serialize(solst);  
            System.debug('serlizeStr in the test class  '+serlizeStr);
            System.debug('serlizeStr in the test class3  '+serlizeStr3);
            Poland_SalesOrder_Controller.saveSalesOrder(so3Non,serlizeStr3,IncoTermObj.Id,'cloneOrder',System.today());
            Poland_SalesOrder_Controller.saveSalesOrder(so2,serlizeStr3,IncoTermObj.Id,'cloneOrder',System.today());
        }
        Test.stopTest();
    }
    /*  
* Name: Poland_SalesOrder_Controller_Test    
* return:void   
* Description: SCTASK1010530-This method responsible to cover changes related to Poland(wholeSale Sales Manager) 
               with 4 and 5 Distibutors
*/    
    @isTest
    public static void wholeSaleSalesmanger4And5Distributors()
    {
        Test.startTest();
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '2941'];
        Inco_Term__c IncoTermObj=[select id,name from Inco_Term__c limit 1];
        Account acc2 = [SELECT id FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'SAR123' LIMIT 1]; 
        user UserObj=[select id,name,email,username from user where username='zonal_aaexe1232@upl122333.com.devbox'];
        SKU__c skurec = [SELECT Id, SKU_Description__c,Unit_Cost__c, SKU_Code__c FROM SKU__c where SKU_Description__c = 'FURYY 40 EC X 250 cc' LIMIT 1]; 
        Distribution_Channel__c distributionChannelObj=[select id,Name,Distribution_Channel_Code__c,Description__c from Distribution_Channel__c limit 1];
        Payment_Term__c paymentRec  = [SELECT Id, Payment_Term_Code__c FROM Payment_Term__c WHERE Sales_Org__c = :sorg.Id AND Payment_Term_Code__c = 'UK01' LIMIT 1];
        OrderLineItem__c ordItem=[select id,SKU_Name__c,FinalPrice__c,pallet_Size_Italy__c,Transport_contribution__c,Discount2__c,Average_Final_Price__c,Quantity__c,Special_Discount__c,Price__c,Shipping_Date__c,Net_Invoice_Price__c,Order__c,Net_Price__c from OrderLineItem__c limit 1 ];
        Division__c DivisionObj=[select id,Name,Division_Code__c from Division__c limit 1 ];
        Account accObjNon=[select id from Account where sap_Code__c='000102323456789' limit 1];
        Shipping_Location__c shippingLocationObj=[select id,Location_Name__c,SAP_Code__c,Distributor__c,City__c,Billing_Street_1__c,State__c,Country__c,Billing_Street_3__c,Pincode__c,Sold_To_Party_SAP_Code__c,Combination_Key__c,Country_Name__c,Sales_Org__c,Distribution_Channel__c,Division__c from Shipping_Location__c limit 1];
        Id devRecordAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        List<Account> acclistNew=new List<Account>();
        Account accObjNon1 = new Account(
            Name = 'SAR223434',                                                            // Account Name
            //OwnerId = user.id,
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'SAR223434',                                         // Last Name
            SAP_Code__c = '00010232534',                                        // SAP Customer Code
            Mobile__c = '087654321334',                                          // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '86005897945',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentRec.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07',                                         // Payment Terms
            //PriceGroupCode__c =priceGroupMasterObj.Id,                            // Tax classification for customer
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c='',
            Distributor_Type_Poland__c ='Regular Customer'
        );
        acclistNew.add(accObjNon1);
        Account accObjNon2 = new Account(
            Name = 'SAR223456',                                                            // Account Name
            //OwnerId = user.id,
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'SAR223456',                                         // Last Name
            SAP_Code__c = '00014532534',                                        // SAP Customer Code
            Mobile__c = '087654356334',                                          // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '86005897215',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentRec.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07',                                         // Payment Terms
            //PriceGroupCode__c =priceGroupMasterObj.Id,                            // Tax classification for customer
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c='',
            Distributor_Type_Poland__c ='Regular Customer'
        );
        acclistNew.add(accObjNon2);
        insert acclistNew;
        List<contact> conlist=new List<contact>();
        Contact con11 = new Contact();
        con11.AccountId=acclistNew[0].Id;
        con11.LastName=acclistNew[0].Last_Name__c;
        con11.Is_Community__c=true;
        con11.MobilePhone ='9876543211';
        con11.Phone = '5592619030';
        con11.Is_Community__c = true;
        conlist.add(con11);
        
        Contact con12 = new Contact();
        con12.AccountId=acclistNew[0].Id;
        con12.LastName=acclistNew[0].Last_Name__c;
        con12.Is_Community__c=true;
        con12.MobilePhone ='9876543211';
        con12.Phone = '5592619030';
        con12.Is_Community__c = true;
        conlist.add(con12);
        
        
        Contact con13 = new Contact();
        con13.AccountId=acclistNew[0].Id;
        con13.LastName=acclistNew[0].Last_Name__c;
        con13.Is_Community__c=true;
        con13.MobilePhone ='9876543211';
        con13.Phone = '5592619030';
        con13.Is_Community__c = true;
        conlist.add(con13);
        
        Contact con14 = new Contact();
        con14.AccountId=acclistNew[0].Id;
        con14.LastName=acclistNew[0].Last_Name__c;
        con14.Is_Community__c=true;
        con14.MobilePhone ='9876543211';
        con14.Phone = '5592619030';
        con14.Is_Community__c = true;
        conlist.add(con14);
        
        Contact con15 = new Contact();
        con15.AccountId=acclistNew[1].Id;
        con15.LastName=acclistNew[1].Last_Name__c;
        con15.Is_Community__c=true;
        con15.MobilePhone ='9876543211';
        con15.Phone = '5592619030';
        con15.Is_Community__c = true;
        conlist.add(con15);
        
        
        
        Contact con16 = new Contact();
        con16.AccountId=acclistNew[1].Id;
        con16.LastName=acclistNew[1].Last_Name__c;
        con16.Is_Community__c=true;
        con16.MobilePhone ='9876543211';
        con16.Phone = '5592619030';
        con16.Is_Community__c = true;
        conlist.add(con16);
        
        Contact con17 = new Contact();
        con17.AccountId=acclistNew[1].Id;
        con17.LastName=acclistNew[1].Last_Name__c;
        con17.Is_Community__c=true;
        con17.MobilePhone ='9876543211';
        con17.Phone = '5592619030';
        con17.Is_Community__c = true;
        conlist.add(con17);
        
        Contact con18 = new Contact();
        con18.AccountId=acclistNew[1].Id;
        con18.LastName=acclistNew[1].Last_Name__c;
        con18.Is_Community__c=true;
        con18.MobilePhone ='9876543211';
        con18.Phone = '5592619030';
        con18.Is_Community__c = true;
        conlist.add(con18);
        
        Contact con19 = new Contact();
        con19.AccountId=acclistNew[1].Id;
        con19.LastName=acclistNew[1].Last_Name__c;
        con19.Is_Community__c=true;
        con19.MobilePhone ='9876543211';
        con19.Phone = '5592619030';
        con19.Is_Community__c = true;
        conlist.add(con19);
        
        
        insert conlist;
        profile pDistributor=[select id from profile where name='Customer Community Plus User - Poland - 1'];
        userrole  usrole2 = new userrole();
        usrole2.Name ='AGROPESTCustomerUser';
        List<user> userlistNew=new list<user>();
        user AccConUser1=new user();
        AccConUser1.Alias = 'zon11';                                                            
        AccConUser1.Email = 'ski8ewdm@skinternational1.com';                             
        AccConUser1.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser1.UserRoleId=usrole2.id;
        AccConUser1.Username = 'zo8nal_aaewqdxe1232@upl12.com.devbox';                                    
        AccConUser1.IsActive = true;  
        AccConUser1.LastName='Terriotory Manager';
        AccConUser1.CommunityNickname = 'zon8alExe12Di'; 
        AccConUser1.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser1.LocaleSidKey = 'en_IN';                                    
        AccConUser1.LanguageLocaleKey = 'en_US';                                             
        AccConUser1.ForecastEnabled = false;                                                     
        AccConUser1.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser1.Show_Inventory__c = false;                                                     
        AccConUser1.Show_Credit_Limit__c = false; 
        AccConUser1.ContactId=con11.id; 
        userlistNew.add(AccConUser1);
        
        user AccConUser2=new user();
        AccConUser2.Alias = 'zo12';                                                            
        AccConUser2.Email = 'sk7wdim@skinternational1.com';                             
        AccConUser2.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser2.UserRoleId=usrole2.id;
        AccConUser2.Username = 'zonal_aaexwsde71232@upl12.com.devbox';                                    
        AccConUser2.IsActive = true;  
        AccConUser2.LastName='Terriotory Manager';
        AccConUser2.CommunityNickname = 'zona7lExe12Di'; 
        AccConUser2.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser2.LocaleSidKey = 'en_IN';                                    
        AccConUser2.LanguageLocaleKey = 'en_US';                                             
        AccConUser2.ForecastEnabled = false;                                                     
        AccConUser2.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser2.Show_Inventory__c = false;                                                     
        AccConUser2.Show_Credit_Limit__c = false; 
        AccConUser2.ContactId=con12.id; 
        userlistNew.add(AccConUser2);
        
        
        user AccConUser3=new user();
        AccConUser3.Alias = 'zeaa13';                                                            
        AccConUser3.Email = 'skiewdm1@skinternational1.com';                             
        AccConUser3.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser3.UserRoleId=usrole2.id;
        AccConUser3.Username = 'zona1l_aaexewe1232@upl12.com.devbox';                                    
        AccConUser3.IsActive = true;  
        AccConUser3.LastName='Terriotory Manager';
        AccConUser3.CommunityNickname = 'zona1lExe12Di'; 
        AccConUser3.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser3.LocaleSidKey = 'en_IN';                                    
        AccConUser3.LanguageLocaleKey = 'en_US';                                             
        AccConUser3.ForecastEnabled = false;                                                     
        AccConUser3.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser3.Show_Inventory__c = false;                                                     
        AccConUser3.Show_Credit_Limit__c = false; 
        AccConUser3.ContactId=con13.id; 
        userlistNew.add(AccConUser3);
        
        user AccConUser4=new user();
        AccConUser4.Alias = 'zow14';                                                            
        AccConUser4.Email = 'skewfi2m@skinternational1.com';                             
        AccConUser4.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser4.UserRoleId=usrole2.id;
        AccConUser4.Username = 'zonal_awqef2aexe1232@upl12.com.devbox';                                    
        AccConUser4.IsActive = true;  
        AccConUser4.LastName='Terriotory Manager';
        AccConUser4.CommunityNickname = 'zon2alExe12Di'; 
        AccConUser4.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser4.LocaleSidKey = 'en_IN';                                    
        AccConUser4.LanguageLocaleKey = 'en_US';                                             
        AccConUser4.ForecastEnabled = false;                                                     
        AccConUser4.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser4.Show_Inventory__c = false;                                                     
        AccConUser4.Show_Credit_Limit__c = false; 
        AccConUser4.ContactId=con14.id; 
        userlistNew.add(AccConUser4);
        
        user AccConUser5=new user();
        AccConUser5.Alias = 'znaa15';                                                            
        AccConUser5.Email = 'skefim3@skinternational1.com';                             
        AccConUser5.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser5.UserRoleId=usrole2.id;
        AccConUser5.Username = 'zonal_aaexwefe31232@upl12.com.devbox';                                    
        AccConUser5.IsActive = true;  
        AccConUser5.LastName='Terriotory Manager';
        AccConUser5.CommunityNickname = 'z3owefnalExe12Di'; 
        AccConUser5.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser5.LocaleSidKey = 'en_IN';                                    
        AccConUser5.LanguageLocaleKey = 'en_US';                                             
        AccConUser5.ForecastEnabled = false;                                                     
        AccConUser5.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser5.Show_Inventory__c = false;                                                     
        AccConUser5.Show_Credit_Limit__c = false; 
        AccConUser5.ContactId=con15.id; 
        userlistNew.add(AccConUser5);
        
        
        user AccConUser6=new user();
        AccConUser6.Alias = 'zoneaa15';                                                            
        AccConUser6.Email = 'wqe@skinternational1.com';                             
        AccConUser6.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser6.UserRoleId=usrole2.id;
        AccConUser6.Username = 'zonal_aaexefe31232@upl12.com.devbox';                                    
        AccConUser6.IsActive = true;  
        AccConUser6.LastName='Terriotory Manager';
        AccConUser6.CommunityNickname = 'we'; 
        AccConUser6.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser6.LocaleSidKey = 'en_IN';                                    
        AccConUser6.LanguageLocaleKey = 'en_US';                                             
        AccConUser6.ForecastEnabled = false;                                                     
        AccConUser6.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser6.Show_Inventory__c = false;                                                     
        AccConUser6.Show_Credit_Limit__c = false; 
        AccConUser6.ContactId=con16.id; 
        userlistNew.add(AccConUser6);
        
        user AccConUser7=new user();
        AccConUser7.Alias = 'zonwefa5';                                                            
        AccConUser7.Email = 'skiefm3@skinternational1.com';                             
        AccConUser7.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser7.UserRoleId=usrole2.id;
        AccConUser7.Username = 'zonal_aaexe31wdf232@upl12.com.devbox';                                    
        AccConUser7.IsActive = true;  
        AccConUser7.LastName='Terriotory Manager';
        AccConUser7.CommunityNickname = 'z3onawqelExe12Di'; 
        AccConUser7.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser7.LocaleSidKey = 'en_IN';                                    
        AccConUser7.LanguageLocaleKey = 'en_US';                                             
        AccConUser7.ForecastEnabled = false;                                                     
        AccConUser7.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser7.Show_Inventory__c = false;                                                     
        AccConUser7.Show_Credit_Limit__c = false; 
        AccConUser7.ContactId=con17.id; 
        userlistNew.add(AccConUser7);
        
        user AccConUser8=new user();
        AccConUser8.Alias = 'zonafa15';                                                            
        AccConUser8.Email = 'skiewfm3@skinternational1.com';                             
        AccConUser8.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser8.UserRoleId=usrole2.id;
        AccConUser8.Username = 'zonal_aafdfexe31232@upl12.com.devbox';                                    
        AccConUser8.IsActive = true;  
        AccConUser8.LastName='Terriotory Manager';
        AccConUser8.CommunityNickname = 'z3fonalExe12Di'; 
        AccConUser8.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser8.LocaleSidKey = 'en_IN';                                    
        AccConUser8.LanguageLocaleKey = 'en_US';                                             
        AccConUser8.ForecastEnabled = false;                                                     
        AccConUser8.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser8.Show_Inventory__c = false;                                                     
        AccConUser8.Show_Credit_Limit__c = false; 
        AccConUser8.ContactId=con18.id; 
        userlistNew.add(AccConUser8);
        
        
        user AccConUser9=new user();
        AccConUser9.Alias = 'zo4naa15';                                                            
        AccConUser9.Email = 'skim34@skinternational1.com';                             
        AccConUser9.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser9.UserRoleId=usrole2.id;
        AccConUser9.Username = 'zonal_aaexe3123452@upl12.com.devbox';                                    
        AccConUser9.IsActive = true;  
        AccConUser9.LastName='Terriotory Manager';
        AccConUser9.CommunityNickname = 'z34onalExe12Di'; 
        AccConUser9.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser9.LocaleSidKey = 'en_IN';                                    
        AccConUser9.LanguageLocaleKey = 'en_US';                                             
        AccConUser9.ForecastEnabled = false;                                                     
        AccConUser9.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser9.Show_Inventory__c = false;                                                     
        AccConUser9.Show_Credit_Limit__c = false; 
        AccConUser9.ContactId=con19.id; 
        userlistNew.add(AccConUser9);
        
        insert userlistNew;
        
        system.runas(UserObj)
        {
            Poland_SalesOrder_Controller.SalesOrderItem OwrapObj = new Poland_SalesOrder_Controller.SalesOrderItem();
            List<Poland_SalesOrder_Controller.SalesOrderItem> OwrapObjlst = new List<Poland_SalesOrder_Controller.SalesOrderItem>(); 
            OwrapObj.productId = skurec.Id; 
            OwrapObj.palletSize =100.00;
            OwrapObj.skuId = skurec.id;
            OwrapObj.distributionChannelId = distributionChannelObj.Id;
            
            OwrapObj.qty = 14;          
            OwrapObj.typeOfPayment = paymentRec.Id;
            OwrapObjlst.add(OwrapObj);
            String serlizeStr1 = JSON.serialize(OwrapObj);  
            String serlizeStr2 = JSON.serialize(OwrapObjlst);
            
            Sales_Order__c so2 = new Sales_Order__c();
            so2.Payment_Term__c = paymentRec.Id;      
            so2.Ship_To_Party__c = shippingLocationObj.Id;
            so2.Sold_to_Party__c = acclistNew[0].Id;   
            so2.Order_Status__c ='Pending';
            so2.Sent_for_Manager_Approval_Mexico__c=true;
            
            Sales_Order__c so3Non = new Sales_Order__c();
            so3Non.Payment_Term__c = paymentRec.Id;      
            so3Non.Ship_To_Party__c = shippingLocationObj.Id;
            so3Non.Sold_to_Party__c = acclistNew[1].Id;   
            so3Non.Order_Status__c ='Pending';
            so3Non.Sent_for_Manager_Approval_Mexico__c=true;
            
            List<Poland_SalesOrder_Controller.SalesOrderItem> solst = new List<Poland_SalesOrder_Controller.SalesOrderItem>(); 
            Poland_SalesOrder_Controller.SalesOrderItem wrapObj = new Poland_SalesOrder_Controller.SalesOrderItem();
            
            wrapObj.productId = skurec.id;
            wrapObj.productName = skurec.SKU_Description__c;
            wrapObj.skuId = skurec.id;
            wrapObj.qty = 50;
            wrapObj.UOM ='L';
            wrapObj.oliId = ordItem.Id;
            wrapObj.typeOfPayment = paymentRec.Id;
            wrapObj.distributionChannelId = distributionChannelObj.Id;
            wrapObj.divisionId = DivisionObj.Id;
            
            solst.add(wrapObj);
            String serlizeStr = JSON.serialize(wrapObj);  
            String serlizeStr3 = JSON.serialize(solst);  
            System.debug('serlizeStr in the test class  '+serlizeStr);
            System.debug('serlizeStr in the test class3  '+serlizeStr3);
            Poland_SalesOrder_Controller.saveSalesOrder(so3Non,serlizeStr3,IncoTermObj.Id,'cloneOrder',System.today());
            
            Poland_SalesOrder_Controller.saveSalesOrder(so2,serlizeStr3,IncoTermObj.Id,'cloneOrder',System.today());
        }
        Test.stopTest();
    }
/*  
* Name: Poland_SalesOrder_Controller_Test    
* return:void 
* Description: SCTASK1010530-This method responsible to cover changes related to Poland(Key Account Manager)
               with 4 and 5 Distibutors
*/   
    @isTest
    public static void KeyAccountManger4And5Users()
    {
        Test.startTest();
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '2941'];
        Inco_Term__c IncotermObj=[select id,name from Inco_Term__c limit 1];
        Account acc2 = [SELECT id FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'SAR123' LIMIT 1]; 
        user UserObj=[select id,name,email,username from user where username='zonal_aaexe1232@u345.com.devbox'];
        SKU__c skurec = [SELECT Id, SKU_Description__c,Unit_Cost__c, SKU_Code__c FROM SKU__c where SKU_Description__c = 'FURYY 40 EC X 250 cc' LIMIT 1]; 
        Distribution_Channel__c distributionChannelObj=[select id,Name,Distribution_Channel_Code__c,Description__c from Distribution_Channel__c limit 1];
        Payment_Term__c paymentRec  = [SELECT Id, Payment_Term_Code__c FROM Payment_Term__c WHERE Sales_Org__c = :sorg.Id AND Payment_Term_Code__c = 'UK01' LIMIT 1];
        OrderLineItem__c ordItem=[select id,SKU_Name__c,FinalPrice__c,pallet_Size_Italy__c,Transport_contribution__c,Discount2__c,Average_Final_Price__c,Quantity__c,Special_Discount__c,Price__c,Shipping_Date__c,Net_Invoice_Price__c,Order__c,Net_Price__c from OrderLineItem__c limit 1 ];
        Division__c DivisionObj=[select id,Name,Division_Code__c from Division__c limit 1 ];
        Account accObjNon=[select id from Account where sap_Code__c='000102323456789' limit 1];
        Shipping_Location__c shippingLocationObj=[select id,Location_Name__c,SAP_Code__c,Distributor__c,City__c,Billing_Street_1__c,State__c,Country__c,Billing_Street_3__c,Pincode__c,Sold_To_Party_SAP_Code__c,Combination_Key__c,Country_Name__c,Sales_Org__c,Distribution_Channel__c,Division__c from Shipping_Location__c limit 1];
        Id devRecordAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        List<Account> acclistNew=new List<Account>();
        Account accObjNon1 = new Account(
            Name = 'SAR223434',                                                            // Account Name
            //OwnerId = user.id,
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'SAR223434',                                         // Last Name
            SAP_Code__c = '00010232534',                                        // SAP Customer Code
            Mobile__c = '087654321334',                                          // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '86005897945',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentRec.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07',                                         // Payment Terms
            //PriceGroupCode__c =priceGroupMasterObj.Id,                            // Tax classification for customer
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c='',
            Distributor_Type_Poland__c ='Regular Customer'
        );
        acclistNew.add(accObjNon1);
        Account accObjNon2 = new Account(
            Name = 'SAR223456',                                                            // Account Name
            //OwnerId = user.id,
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'SAR223456',                                         // Last Name
            SAP_Code__c = '00014532534',                                        // SAP Customer Code
            Mobile__c = '087654356334',                                          // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '86005897215',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentRec.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07',                                         // Payment Terms
            //PriceGroupCode__c =priceGroupMasterObj.Id,                            // Tax classification for customer
            AuthorizationGroupSalesoffice__c='',
            Tax_classification_for_customer__c='',
            Distributor_Type_Poland__c ='Regular Customer'
        );
        acclistNew.add(accObjNon2);
        insert acclistNew;
        List<contact> conlist=new List<contact>();
        Contact con11 = new Contact();
        con11.AccountId=acclistNew[0].Id;
        con11.LastName=acclistNew[0].Last_Name__c;
        con11.Is_Community__c=true;
        con11.MobilePhone ='9876543211';
        con11.Phone = '5592619030';
        con11.Is_Community__c = true;
        conlist.add(con11);
        
        Contact con12 = new Contact();
        con12.AccountId=acclistNew[0].Id;
        con12.LastName=acclistNew[0].Last_Name__c;
        con12.Is_Community__c=true;
        con12.MobilePhone ='9876543211';
        con12.Phone = '5592619030';
        con12.Is_Community__c = true;
        conlist.add(con12);
        
        
        Contact con13 = new Contact();
        con13.AccountId=acclistNew[0].Id;
        con13.LastName=acclistNew[0].Last_Name__c;
        con13.Is_Community__c=true;
        con13.MobilePhone ='9876543211';
        con13.Phone = '5592619030';
        con13.Is_Community__c = true;
        conlist.add(con13);
        
        Contact con14 = new Contact();
        con14.AccountId=acclistNew[0].Id;
        con14.LastName=acclistNew[0].Last_Name__c;
        con14.Is_Community__c=true;
        con14.MobilePhone ='9876543211';
        con14.Phone = '5592619030';
        con14.Is_Community__c = true;
        conlist.add(con14);
        
        Contact con15 = new Contact();
        con15.AccountId=acclistNew[1].Id;
        con15.LastName=acclistNew[1].Last_Name__c;
        con15.Is_Community__c=true;
        con15.MobilePhone ='9876543211';
        con15.Phone = '5592619030';
        con15.Is_Community__c = true;
        conlist.add(con15);
        
        
        
        Contact con16 = new Contact();
        con16.AccountId=acclistNew[1].Id;
        con16.LastName=acclistNew[1].Last_Name__c;
        con16.Is_Community__c=true;
        con16.MobilePhone ='9876543211';
        con16.Phone = '5592619030';
        con16.Is_Community__c = true;
        conlist.add(con16);
        
        Contact con17 = new Contact();
        con17.AccountId=acclistNew[1].Id;
        con17.LastName=acclistNew[1].Last_Name__c;
        con17.Is_Community__c=true;
        con17.MobilePhone ='9876543211';
        con17.Phone = '5592619030';
        con17.Is_Community__c = true;
        conlist.add(con17);
        
        Contact con18 = new Contact();
        con18.AccountId=acclistNew[1].Id;
        con18.LastName=acclistNew[1].Last_Name__c;
        con18.Is_Community__c=true;
        con18.MobilePhone ='9876543211';
        con18.Phone = '5592619030';
        con18.Is_Community__c = true;
        conlist.add(con18);
        
        Contact con19 = new Contact();
        con19.AccountId=acclistNew[1].Id;
        con19.LastName=acclistNew[1].Last_Name__c;
        con19.Is_Community__c=true;
        con19.MobilePhone ='9876543211';
        con19.Phone = '5592619030';
        con19.Is_Community__c = true;
        conlist.add(con19);
        
        
        insert conlist;
        profile pDistributor=[select id from profile where name='Customer Community Plus User - Poland - 1'];
        userrole  usrole2 = new userrole();
        usrole2.Name ='AGROPESTCustomerUser';
        List<user> userlistNew=new list<user>();
        user AccConUser1=new user();
        AccConUser1.Alias = 'zon11';                                                            
        AccConUser1.Email = 'ski8ewdm@skinternational1.com';                             
        AccConUser1.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser1.UserRoleId=usrole2.id;
        AccConUser1.Username = 'zo8nal_aaewqdxe1232@upl12.com.devbox';                                    
        AccConUser1.IsActive = true;  
        AccConUser1.LastName='Terriotory Manager';
        AccConUser1.CommunityNickname = 'zon8alExe12Di'; 
        AccConUser1.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser1.LocaleSidKey = 'en_IN';                                    
        AccConUser1.LanguageLocaleKey = 'en_US';                                             
        AccConUser1.ForecastEnabled = false;                                                     
        AccConUser1.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser1.Show_Inventory__c = false;                                                     
        AccConUser1.Show_Credit_Limit__c = false; 
        AccConUser1.ContactId=con11.id; 
        userlistNew.add(AccConUser1);
        
        user AccConUser2=new user();
        AccConUser2.Alias = 'zo12';                                                            
        AccConUser2.Email = 'sk7wdim@skinternational1.com';                             
        AccConUser2.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser2.UserRoleId=usrole2.id;
        AccConUser2.Username = 'zonal_aaexwsde71232@upl12.com.devbox';                                    
        AccConUser2.IsActive = true;  
        AccConUser2.LastName='Terriotory Manager';
        AccConUser2.CommunityNickname = 'zona7lExe12Di'; 
        AccConUser2.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser2.LocaleSidKey = 'en_IN';                                    
        AccConUser2.LanguageLocaleKey = 'en_US';                                             
        AccConUser2.ForecastEnabled = false;                                                     
        AccConUser2.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser2.Show_Inventory__c = false;                                                     
        AccConUser2.Show_Credit_Limit__c = false; 
        AccConUser2.ContactId=con12.id; 
        userlistNew.add(AccConUser2);
        
        
        user AccConUser3=new user();
        AccConUser3.Alias = 'zeaa13';                                                            
        AccConUser3.Email = 'skiewdm1@skinternational1.com';                             
        AccConUser3.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser3.UserRoleId=usrole2.id;
        AccConUser3.Username = 'zona1l_aaexewe1232@upl12.com.devbox';                                    
        AccConUser3.IsActive = true;  
        AccConUser3.LastName='Terriotory Manager';
        AccConUser3.CommunityNickname = 'zona1lExe12Di'; 
        AccConUser3.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser3.LocaleSidKey = 'en_IN';                                    
        AccConUser3.LanguageLocaleKey = 'en_US';                                             
        AccConUser3.ForecastEnabled = false;                                                     
        AccConUser3.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser3.Show_Inventory__c = false;                                                     
        AccConUser3.Show_Credit_Limit__c = false; 
        AccConUser3.ContactId=con13.id; 
        userlistNew.add(AccConUser3);
        
        user AccConUser4=new user();
        AccConUser4.Alias = 'zow14';                                                            
        AccConUser4.Email = 'skewfi2m@skinternational1.com';                             
        AccConUser4.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser4.UserRoleId=usrole2.id;
        AccConUser4.Username = 'zonal_awqef2aexe1232@upl12.com.devbox';                                    
        AccConUser4.IsActive = true;  
        AccConUser4.LastName='Terriotory Manager';
        AccConUser4.CommunityNickname = 'zon2alExe12Di'; 
        AccConUser4.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser4.LocaleSidKey = 'en_IN';                                    
        AccConUser4.LanguageLocaleKey = 'en_US';                                             
        AccConUser4.ForecastEnabled = false;                                                     
        AccConUser4.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser4.Show_Inventory__c = false;                                                     
        AccConUser4.Show_Credit_Limit__c = false; 
        AccConUser4.ContactId=con14.id; 
        userlistNew.add(AccConUser4);
        
        user AccConUser5=new user();
        AccConUser5.Alias = 'znaa15';                                                            
        AccConUser5.Email = 'skefim3@skinternational1.com';                             
        AccConUser5.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser5.UserRoleId=usrole2.id;
        AccConUser5.Username = 'zonal_aaexwefe31232@upl12.com.devbox';                                    
        AccConUser5.IsActive = true;  
        AccConUser5.LastName='Terriotory Manager';
        AccConUser5.CommunityNickname = 'z3owefnalExe12Di'; 
        AccConUser5.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser5.LocaleSidKey = 'en_IN';                                    
        AccConUser5.LanguageLocaleKey = 'en_US';                                             
        AccConUser5.ForecastEnabled = false;                                                     
        AccConUser5.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser5.Show_Inventory__c = false;                                                     
        AccConUser5.Show_Credit_Limit__c = false; 
        AccConUser5.ContactId=con15.id; 
        userlistNew.add(AccConUser5);
        
        
        user AccConUser6=new user();
        AccConUser6.Alias = 'zoneaa15';                                                            
        AccConUser6.Email = 'wqe@skinternational1.com';                             
        AccConUser6.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser6.UserRoleId=usrole2.id;
        AccConUser6.Username = 'zonal_aaexefe31232@upl12.com.devbox';                                    
        AccConUser6.IsActive = true;  
        AccConUser6.LastName='Terriotory Manager';
        AccConUser6.CommunityNickname = 'we'; 
        AccConUser6.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser6.LocaleSidKey = 'en_IN';                                    
        AccConUser6.LanguageLocaleKey = 'en_US';                                             
        AccConUser6.ForecastEnabled = false;                                                     
        AccConUser6.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser6.Show_Inventory__c = false;                                                     
        AccConUser6.Show_Credit_Limit__c = false; 
        AccConUser6.ContactId=con16.id; 
        userlistNew.add(AccConUser6);
        
        user AccConUser7=new user();
        AccConUser7.Alias = 'zonwefa5';                                                            
        AccConUser7.Email = 'skiefm3@skinternational1.com';                             
        AccConUser7.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser7.UserRoleId=usrole2.id;
        AccConUser7.Username = 'zonal_aaexe31wdf232@upl12.com.devbox';                                    
        AccConUser7.IsActive = true;  
        AccConUser7.LastName='Terriotory Manager';
        AccConUser7.CommunityNickname = 'z3onawqelExe12Di'; 
        AccConUser7.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser7.LocaleSidKey = 'en_IN';                                    
        AccConUser7.LanguageLocaleKey = 'en_US';                                             
        AccConUser7.ForecastEnabled = false;                                                     
        AccConUser7.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser7.Show_Inventory__c = false;                                                     
        AccConUser7.Show_Credit_Limit__c = false; 
        AccConUser7.ContactId=con17.id; 
        userlistNew.add(AccConUser7);
        
        user AccConUser8=new user();
        AccConUser8.Alias = 'zonafa15';                                                            
        AccConUser8.Email = 'skiewfm3@skinternational1.com';                             
        AccConUser8.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser8.UserRoleId=usrole2.id;
        AccConUser8.Username = 'zonal_aafdfexe31232@upl12.com.devbox';                                    
        AccConUser8.IsActive = true;  
        AccConUser8.LastName='Terriotory Manager';
        AccConUser8.CommunityNickname = 'z3fonalExe12Di'; 
        AccConUser8.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser8.LocaleSidKey = 'en_IN';                                    
        AccConUser8.LanguageLocaleKey = 'en_US';                                             
        AccConUser8.ForecastEnabled = false;                                                     
        AccConUser8.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser8.Show_Inventory__c = false;                                                     
        AccConUser8.Show_Credit_Limit__c = false; 
        AccConUser8.ContactId=con18.id; 
        userlistNew.add(AccConUser8);
        
        
        user AccConUser9=new user();
        AccConUser9.Alias = 'zo4naa15';                                                            
        AccConUser9.Email = 'skim34@skinternational1.com';                             
        AccConUser9.ProfileId  = pDistributor.ID;
        //sobj1.ContactId=con.Id;
        AccConUser9.UserRoleId=usrole2.id;
        AccConUser9.Username = 'zonal_aaexe3123452@upl12.com.devbox';                                    
        AccConUser9.IsActive = true;  
        AccConUser9.LastName='Terriotory Manager';
        AccConUser9.CommunityNickname = 'z34onalExe12Di'; 
        AccConUser9.TimeZoneSidKey = 'Asia/Kolkata'; 
        AccConUser9.LocaleSidKey = 'en_IN';                                    
        AccConUser9.LanguageLocaleKey = 'en_US';                                             
        AccConUser9.ForecastEnabled = false;                                                     
        AccConUser9.EmailEncodingKey = 'ISO-8859-1';    
        AccConUser9.Show_Inventory__c = false;                                                     
        AccConUser9.Show_Credit_Limit__c = false; 
        AccConUser9.ContactId=con19.id; 
        userlistNew.add(AccConUser9);
        
        insert userlistNew;
        
        system.runas(UserObj)
        {
            Poland_SalesOrder_Controller.SalesOrderItem OwrapObj = new Poland_SalesOrder_Controller.SalesOrderItem();
            List<Poland_SalesOrder_Controller.SalesOrderItem> OwrapObjlst = new List<Poland_SalesOrder_Controller.SalesOrderItem>(); 
            OwrapObj.productId = skurec.Id; 
            OwrapObj.palletSize =100.00;
            OwrapObj.skuId = skurec.id;
            OwrapObj.distributionChannelId = distributionChannelObj.Id;
            
            OwrapObj.qty = 14;          
            OwrapObj.typeOfPayment = paymentRec.Id;
            OwrapObjlst.add(OwrapObj);
            String serlizeStr1 = JSON.serialize(OwrapObj);  
            String serlizeStr2 = JSON.serialize(OwrapObjlst);
            
            Sales_Order__c so2 = new Sales_Order__c();
            so2.Payment_Term__c = paymentRec.Id;      
            so2.Ship_To_Party__c = shippingLocationObj.Id;
            so2.Sold_to_Party__c = acclistNew[0].Id;   
            so2.Order_Status__c ='Pending';
            so2.Sent_for_Manager_Approval_Mexico__c=true;
            
            Sales_Order__c so3Non = new Sales_Order__c();
            so3Non.Payment_Term__c = paymentRec.Id;      
            so3Non.Ship_To_Party__c = shippingLocationObj.Id;
            so3Non.Sold_to_Party__c = acclistNew[1].Id;   
            so3Non.Order_Status__c ='Pending';
            so3Non.Sent_for_Manager_Approval_Mexico__c=true;
            
            List<Poland_SalesOrder_Controller.SalesOrderItem> solst = new List<Poland_SalesOrder_Controller.SalesOrderItem>(); 
            Poland_SalesOrder_Controller.SalesOrderItem wrapObj = new Poland_SalesOrder_Controller.SalesOrderItem();
            
            wrapObj.productId = skurec.id;
            wrapObj.productName = skurec.SKU_Description__c;
            wrapObj.skuId = skurec.id;
            wrapObj.qty = 50;
            wrapObj.UOM ='L';
            wrapObj.oliId = ordItem.Id;
            wrapObj.typeOfPayment = paymentRec.Id;
            wrapObj.distributionChannelId = distributionChannelObj.Id;
            wrapObj.divisionId = DivisionObj.Id;
            
            solst.add(wrapObj);
            String serlizeStr = JSON.serialize(wrapObj);  
            String serlizeStr3 = JSON.serialize(solst);  
            System.debug('serlizeStr in the test class  '+serlizeStr);
            System.debug('serlizeStr in the test class3  '+serlizeStr3);
            Poland_SalesOrder_Controller.saveSalesOrder(so3Non,serlizeStr3,IncotermObj.Id,'cloneOrder',System.today());
            Poland_SalesOrder_Controller.saveSalesOrder(so2,serlizeStr3,IncotermObj.Id,'cloneOrder',System.today());
        }
        Test.stopTest();
    }
    static testMethod void method2(){ 
        
        
        
        
    }
}