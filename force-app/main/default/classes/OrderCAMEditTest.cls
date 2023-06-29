@isTest
public without sharing class OrderCAMEditTest {
    static final Id Supplier_RecTypeId = [SELECT Id FROM RecordType WHERE name = 'Storage Location' and isActive = true LIMIT 1].Id;
    static final Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
   //testing data setup for all methods in this class
    @testSetup
    static void allTheDataForThisTestClass() {
	   Test.startTest();     
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Costa Rica';
        sorg.Description__c='Costa Rica';
        sorg.Sales_Org_Code__c='5711';
        insert sorg;
        
        Sales_Org__c sorg1 =new Sales_Org__c();
        sorg1.Name='Multi Country Costa Rica';
        sorg1.Description__c='Multi Country Costa Rica';
        sorg1.Sales_Org_Code__c='5712';
        insert sorg1;
        
        
        Depot__c dp =new Depot__c ();
        dp.Name='CR10';
        dp.recordtypeId=Supplier_RecTypeId;
        dp.Country__c='Costa Rica';
        dp.Location__c='NORTE';
        dp.Depot_Code__c='CR10';
        dp.SalesOrg__c = sorg.ID;
        insert dp;
        
        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        insert Pro;
        
        Distribution_Channel__c disbj = new Distribution_Channel__c();
        disbj.Name = '20';                      
        disbj.Distribution_Channel_Code__c = '20';  
        disbj.Description__c='test';
        insert disbj;
        
        Division__c Divbj2 = new Division__c();
        Divbj2.Name = '11';         
        Divbj2.Description__c = null;    
        Divbj2.Division_Code__c = '11'; 
        insert Divbj2;
        
        Division__c Divbj = new Division__c();
        Divbj.Name = '10';         
        Divbj.Description__c = null;    
        Divbj.Division_Code__c = '10'; 
        insert Divbj;
        
        
        SKU__c sku = new SKU__c();
        sku.Name='DOST';
        sku.SKU_Code__c='704002';
        sku.SKU_Pack__c=1.00;
        sku.SKU_UOM__c='KG';
        sku.Multiple_Of__c=5;
        sku.Group__c='DOST';
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='KG';
        sku.CurrencyIsoCode = 'USD';
        sku.Special_SKU__c = true;
        sku.Active__c=True;
        
        sku.Combination_Key__c='Cooooooo000011111';
        insert sku;

        
        Customer_Group__c Customer_GroupObj = new Customer_Group__c(
            Name = 'Farmer',                  // Customer Group Name
            Customer_Group_Code__c = 'ZF',      // Customer Group Code
            Customer_Group_Desc__c = 'Farmer'  // Customer Group Desc.
        );
        insert Customer_GroupObj;
        
        
        PriceBookMaster__c PbMaster = new PriceBookMaster__c();
        PbMaster.SKUCode__c = sku.id;           
        PbMaster.DepotCode__c =dp.id;         
        PbMaster.Price__c = 34500;
        PbMaster.MinPrice__c =1234;
        PbMaster.PG_CODE__c =Pg.Id;  
        PbMaster.UOM__c = 'KG';                          
        PbMaster.StartDate__c = system.today();
        PbMaster.EndDate__c = system.today()+1;
        PbMaster.Active__c = true;                      
        PbMaster.PerUnit__c = 1;                       
        PbMaster.Batch__c ='test';
        PbMaster.Price_Classification__c ='Big';
        PbMaster.CurrencyIsoCode='CLP'; 
        PbMaster.Division__c= Divbj.ID;
        PbMaster.CompositeKey__c='c1';
        PbMaster.Price_List_CAM__c='Melon';
        PbMaster.Customer_Group__c =Customer_GroupObj.Id;
        PbMaster.Country__c =sorg.ID;
        PbMaster.DistributionChannel__c = disbj.Id;
        
        
        insert PbMaster; 
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZZOR';              
        ordType.Description__c = 'Costa Rica';    
        ordType.Order_Type_Code__c = 'ZORD';
        insert ordType;
        
        Payment_Method__c payment_method = new Payment_Method__c(
            Name = 'CHEQUE NOMINATIVO',      // Payment Method Name
            Sales_Org__c = sorg.ID,  // Sales Org
            Payment_Method_Code__c = 'B',      // Payment Method Code
            Active__c = true,                  // Active
            Combination_Key__c = '5100B'      // Combination Key
        );
        insert payment_method;
        
        Payment_Term__c payment_term = new Payment_Term__c(
            Payment_Term_Code__c = '0004',    // Payment Term Code
            Payment_Term__c = 'Contado',        // Payment Term
            Payterms_Desc__c = 'Contado',       // Payterms Desc
            Days_to_calc_interest__c = 0,     // Days (to calc interest)
            Sales_Org__c = sorg.ID,   // Sales Org
            CombinationKey__c = '51000004',     // CombinationKey
            Active__c = true                   // Active
        );
        insert payment_term;
        
        Inco_Term__c Inco_terms = new Inco_Term__c(
            Name = 'CFR',                                      // Inco Term Name
            IncoTerm_Code__c = 'CFR',                            // IncoTerm Code
            IncoTerm_Desc__c = 'NOSOTROS ENVIAMOS EL PRODUCTO',  // IncoTerm Desc
            Active__c = true,                                    // Active
            Sales_Org__c = sorg.ID                    // Sales Org
        );
        insert Inco_terms; 
        
      
        Stock_Requirement__c Stock_RequirementObj = new Stock_Requirement__c(
            SKU__c = sku.Id,                       // SKU
            Depot__c = dp.id,                       // Depot
            Unrestricted_Stock__c = 1000.00,                 // Unrestricted Stock
            Sales_Order_Stock__c = 48.00,                     // Sales Order Stock
            Delivery_Stock__c = 0.00,                         // Delivery Stock
            Purchase_Order_Stock__c = 0.00,                   // Purchase Order Stock
            Stock_In_Transit__c = 0.00,                       // Stock In Transit
            UOM__c = 'KG',                                     // UOM
            Combination_Key__c = '6731000000000005291289JP01',  // Combination Key
            Net_Stock_Italy__c = 0.00                       // Net Stock Italy
            
        );
        insert Stock_RequirementObj;
        
        Account acc = new Account();
        acc.Name='Nikhil';
        acc.Last_Name__c='Dhoke';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='8600000000';
        acc.Phone='020200000';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Mumbai';
        acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        acc.Price_Classification__c ='Big';
        acc.Price_List_CAM__c='Melon';
        acc.Customer_Grp__c=Customer_GroupObj.Id;
        //  acc.OwnerId=sobj.Id;
        insert acc;
        
        PbMaster.DistributorCustomerCode__c=acc.id;
        update PbMaster; 
        
        Price_Group_Master__c priceGroup = new Price_Group_Master__c(
            PG_Code__c = '01'// PG Code
        );
        insert priceGroup;
        
        DistributorSalesAreaMapping__c sobj = new DistributorSalesAreaMapping__c(
            AccountType__c = 'Sold To Party',          // Account Type
            Distributor__c = acc.id,          // Distributor
            SalesOrg__c = sorg.id,             // Sales Org
            OrderBlock__c = false,                       // Order Block
            DistributionChannel__c = disbj.id,  // Distribution Channel
            Division__c = Divbj.id,             // Division
            Inco_Term__c = Inco_terms.Id,
            Payment_Term__c = payment_term.Id,
            PriceGroupMaster__c = priceGroup.id     // Price Group Master
        );
        insert sobj;
        
        DistributorSalesAreaMapping__c sobj2 = new DistributorSalesAreaMapping__c(
            AccountType__c = 'Sold To Party',          // Account Type
            Distributor__c = acc.id,          // Distributor
            SalesOrg__c = sorg.id,             // Sales Org
            OrderBlock__c = false,                       // Order Block
            DistributionChannel__c = disbj.id,  // Distribution Channel
            Division__c = Divbj2.id,             // Division
            Inco_Term__c = Inco_terms.Id,
            Payment_Term__c = payment_term.Id,
            PriceGroupMaster__c = priceGroup.id     // Price Group Master
        );
        insert sobj2;
        
        contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName=acc.Last_Name__c;
        insert con;
        
        userrole  usrole = new userrole();
        usrole.Name ='Regional Manager (New CAM)';
        //insert usrole;
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'PartnerCommunity Distributor Profile'];
        
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
        sobj1.ContactId=con.Id;
        sobj1.ManagerId = userInfo.getUserId();
        insert sobj1;
        
        TM_Depot_Mapping__c TMDepoMap = new TM_Depot_Mapping__c();
        TMDepoMap.Depot__c = dp.Id;        // Depot
        TMDepoMap.Territory_Manager__c = sobj1.id;  // Territory Manager
        insert TMDepoMap;
        
        system.debug('Account ID = '+acc.Id);
        Shipping_Location__c shippLoc =new Shipping_Location__c();
        shippLoc.Location_Name__c ='Same as Billing Address'; 
        shippLoc.Region__c='S.No:46/1, A1 Building, First Floor, Office No.101 E-Space, Wadgoan Sheri,Nagar Rd, Aga Nagar,';
        shippLoc.Distributor__c=acc.Id;
        shippLoc.City__c='Pune';
        shippLoc.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc.SAP_Code__c='SAP0001';
        shippLoc.State__c='13';
        insert shippLoc;
        
        Shipping_Location__c shippLoc2 =new Shipping_Location__c();
        shippLoc2.Location_Name__c ='Mumbai'; 
        shippLoc2.Region__c='S.No:46/1, A1 Building, First Floor, Office No.101 E-Space, Wadgoan Sheri,Nagar Rd, Aga Nagar,';
        shippLoc2.Distributor__c=acc.Id;
        shippLoc2.City__c='Pune';
        shippLoc2.Sales_Org__c=sorg.Id;
        //Sales_Org__c	
        
        //shippLoc2.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc2.SAP_Code__c = acc.SAP_Code__c;
        shippLoc2.State__c='13';
        insert shippLoc2;
        
        SpecialInvoiceDiscount__c spelDis = new SpecialInvoiceDiscount__c();
        spelDis.Active__c = false;                                             
        spelDis.Batch__c = 'test';                                                 
        spelDis.DepotCode__c =dp.Id;                                             
        spelDis.Price__c = 191;                                                
        spelDis.DistributorCustomerCode__c = acc.Id;                   
        spelDis.EndDate__c =System.today()+1;                          
        spelDis.PerUnit__c = 1.0;                                                   
        spelDis.PG_Code__c =Pg.Id;                                             
        spelDis.SKUCode__c = sku.Id;                          
        spelDis.StartDate__c = system.today();                         
        spelDis.UOM__c = 'KG';                                                   
        spelDis.CompositeKey__c = '000100122814-06-2016000000000000710002';         
        insert spelDis;
        
        Inventory__c invObj = new Inventory__c( );
        invObj.Stock_Quantity__c = 10;   
        invObj.Batch_Number__c = 'CMUMTX2506'; 
        invObj.Depot__c = dp.Id;    
        invObj.UOM__c = 'KG';                    
        invObj.Storage_Location__c = 'MAIN';  
        invObj.SKU__c = sku.Id;  
        invObj.SKU_Depot__c ='sd1';           
        insert invObj;
        
        PricebookDiscount__c PbDis = new PricebookDiscount__c();
        PbDis.Batch__c = 'test';                                               
        PbDis.DepotCode__c = dp.Id;                                  
        PbDis.DistributorCustomerCode__c = acc.Id;                              
        PbDis.EndDate__c = System.today()+1;                         
        PbDis.PerUnit__c = 1.00;                                                 
        PbDis.PG_Code__c = Pg.Id;                                   
        PbDis.SKUCode__c = sku.Id;                             
        PbDis.StartDate__c = system.today();                         
        PbDis.Active__c = false;                                               
        PbDis.Price__c = 200.00;                                                 
        PbDis.UOM__c = 'KG';                                                   
        PbDis.CompositeKey__c = '01-04-2016BHA103000000000000692001';           
        insert PbDis;
        
        Distributor_Depot_Mapping__c dsMap =new Distributor_Depot_Mapping__c();
        dsMap.Distributor__c = acc.id;
        dsMap.Depot__c=dp.Id;
        insert dsMap;
        
        SKU_Pack_Size__c spObj = new SKU_Pack_Size__c();
        spObj.Depot__c = dp.Id;
        spObj.UOM__c = 'KG';
        spObj.SKU__c = sku.Id;
        spObj.Pack_Size__c = '5';
        insert spObj;
        
        Credit_Info__c crdIf = new Credit_Info__c();
        crdIf.Credit_Limit__c=1000;
        crdIf.Percentage_Used__c=100.0;
        crdIf.Allocated_Limit__c=0.0;
        crdIf.Distributor__c=acc.Id;
        crdIf.Distributor_Code__c='0001001225';
        crdIf.Sales_Org__c=sorg.Id;
        insert crdIf;
        
        OrderTemplate__c ordTemp =new OrderTemplate__c();
        ordTemp.DistributorCustomerCode__c=acc.Id;
        ordTemp.Name='DOST 500.00 ML';
        insert ordTemp;
        
        OrderTemplateItem__c ordTempItem = new OrderTemplateItem__c();
        ordTempItem.Name = 'DOST';
        ordTempItem.OrderTemplate__c=ordTemp.Id;
        ordTempItem.SKU__c = sku.Id;
        insert ordTempItem;
        
        State_Tax_Structure__c statetax = new State_Tax_Structure__c();
        statetax.State_Name__c = 'Maharashtra';
        statetax.Country__c = 'Indonesia';          
        statetax.Tax__c = 10;           
        statetax.State_Code__c = '13';
        statetax.AdditionalTax__c = 30;
        statetax.SalesOrg__c = sorg.Id;
        insert statetax;
        
        Order__c ord = new Order__c();
        ord.Shipping_Location__c = shippLoc.id;  
        ord.Bill_To_Party__c = acc.Id;        
        ord.Order_Date__c = system.today();  
        ord.Order_Raise_By__c = 'Distributor';            
        ord.VAT__c = statetax.Tax__c;                            
        ord.Order_Status__c = 'Pending';                    
        ord.Additional_Tax__c =statetax.AdditionalTax__c;                        
        ord.Sales_Org__c =sorg.Id;          
        ord.Distribution_Channel__c =disbj.Id; 
        ord.Division__c = Divbj.Id;
        ord.Remarks__c  ='Remarks Enter';
        ord.CurrencyIsoCode = 'CLP';
        insert ord;
        
        OrderLineItem__c ordItem = new OrderLineItem__c();
        ordItem.Item_Status__c = 'test';          
        ordItem.SKU_Name__c = sku.Id; 
        ordItem.Item_Number__c = '10';          
        ordItem.UOM__c = 'KG';                   
        ordItem.No_of_Case__c = 1;            
        ordItem.Invoice_Discount__c = 0.00;     
        ordItem.Quantity__c = 100;          
        ordItem.Special_Discount__c = 0.00;     
        ordItem.Price__c = 23000;            
        ordItem.Order__c = ord.Id;    
        ordItem.Stock_Available__c = false;  
        ordItem.CurrencyIsoCode = 'CLP';
        insert ordItem; 
        
        PriceBookMaster__c pbmaster1 = new PriceBookMaster__c(
            
            DistributorCustomerCode__c = acc.Id,
            SKUCode__c = sku.Id,
            DepotCode__c = dp.Id,
            PG_CODE__c = pg.Id,
            UOM__c = 'KG',
            StartDate__c = System.today(),
            EndDate__c = System.today() + 365,
            Active__c = true,
            Sales_Org__c = sorg.Id,
            Division__c  = Divbj.id,
            DistributionChannel__c = disbj.id,
            Price__c = 100,
            MinPrice__c = 100,
            CurrencyIsoCode = 'CLP',
            Final_Price__c = 10,
            CompositeKey__c = '000100122814-07-2016000000000000710002'
        );
        insert pbmaster1;
        
        Profit_Center__c pc = new Profit_Center__c(
        	Sales_Value__c = 3.000,
            Sales_Org__c = sorg.Id,
            Profit_Center__c = 'LA00015'
        );
        insert pc;
        
        Price_Block_Margin_Matrix__c e2ecost = new Price_Block_Margin_Matrix__c(
        	SKU_Code__c = sku.Id,
            UOM__c = 'KG',
            Depot_Code__c = dp.Id,
            Profit_Center__c = pc.Id,
            Type__c = 'E2Ecost',
            Sales_Org__c = sorg.Id,
            Distributor_Code__c = acc.Id,
            Start_Date__c = System.today(),
            End_Date__c = System.today() + 365,
            E2E_Cost_LC__c = 50,
            E2E_Cost_USD__c = 50,
            CurrencyIsoCode = 'USD'
        );
        insert e2ecost;
        
        Price_Block_Margin_Matrix__c e2ecostmbew = new Price_Block_Margin_Matrix__c(
        	SKU_Code__c = sku.Id,
            UOM__c = 'KG',
            Depot_Code__c = dp.Id,
            Profit_Center__c = pc.Id,
            Type__c = 'E2EcostMBEW',
            Sales_Org__c = sorg.Id,
            Start_Date__c = System.today(),
            End_Date__c = System.today() + 365,
            E2E_Cost_MBEW_LC__c = 50,
            E2E_Cost_MBEW_USD__c = 50,
            CurrencyIsoCode = 'USD'
        );
        insert e2ecostmbew;
        
        Price_Block_Margin_Matrix__c e2ecostupc9 = new Price_Block_Margin_Matrix__c(
        	SKU_Code__c = sku.Id,
            UOM__c = 'KG',
            Depot_Code__c = dp.Id,
            Profit_Center__c = pc.Id,
            Type__c = 'E2ECostUPC9',
            Sales_Org__c = sorg.Id,
            Start_Date__c = System.today(),
            End_Date__c = System.today() + 365,
            E2E_Cost_UPC9_LC__c = 50,
            E2E_Cost_UPC9_USD__c = 50,
            CurrencyIsoCode = 'USD'
        );
        insert e2ecostupc9;
        
        Price_Block_Margin_Matrix__c SalesDeduction = new Price_Block_Margin_Matrix__c(
        	SKU_Code__c = sku.Id,
            UOM__c = 'KG',
            Depot_Code__c = dp.Id,
            Profit_Center__c = pc.Id,
            Type__c = 'SalesDeduction',
            Sales_Org__c = sorg.Id,
            Start_Date__c = System.today(),
            End_Date__c = System.today() + 365,
            Sales_Deduction_LC__c = 50,
            CurrencyIsoCode = 'USD'
        );
        insert SalesDeduction;
        
        Price_Block_Margin_Matrix__c Rebate = new Price_Block_Margin_Matrix__c(
        	SKU_Code__c = sku.Id,
            UOM__c = 'KG',
            Depot_Code__c = dp.Id,
            Profit_Center__c = pc.Id,
            Type__c = 'Rebate',
            Sales_Org__c = sorg.Id,
            Distributor_Code__c = acc.Id,
            Start_Date__c = System.today(),
            End_Date__c = System.today() + 365,
            Rebate_LC__c = 50,
            Rebate_USD__c = 50,
            Rebate_Code__c = '123',
            CurrencyIsoCode = 'USD'
        );
        insert Rebate;
        
        Price_Block_Margin_Matrix__c Rebate1 = new Price_Block_Margin_Matrix__c(
        	SKU_Code__c = sku.Id,
            UOM__c = 'KG',
            Depot_Code__c = dp.Id,
            Profit_Center__c = pc.Id,
            Type__c = 'Rebate',
            Sales_Org__c = sorg.Id,
            Distributor_Code__c = acc.Id,
            Start_Date__c = System.today(),
            End_Date__c = System.today() + 365,
            Rebate_LC__c = 50,
            Rebate_USD__c = 50,
            Rebate_Code__c = '1234',
            CurrencyIsoCode = 'USD'
            
        );
        insert Rebate1;
        
         Price_Block_Margin_Matrix__c additionalDiscount = new Price_Block_Margin_Matrix__c(
        	SKU_Code__c = sku.Id,
            UOM__c = 'KG',
            Depot_Code__c = dp.Id,
            Profit_Center__c = pc.Id,
            Type__c = 'AdditionalDiscount',
            Sales_Org__c = sorg.Id,
            Distributor_Code__c = acc.Id,
            Start_Date__c = System.today(),
            End_Date__c = System.today() + 365,
            Additional_Discount_LC__c = 50,
            Additional_Discount_USD__c = 50,
             Additional_Discount__c = 50,
             CurrencyIsoCode = 'USD'
            
        );
        insert additionalDiscount;
        
        Price_Block_Margin_Matrix__c Discount = new Price_Block_Margin_Matrix__c(
        	SKU_Code__c = sku.Id,
            UOM__c = 'KG',
            Depot_Code__c = dp.Id,
            Profit_Center__c = pc.Id,
            Type__c = 'Discount',
            Sales_Org__c = sorg.Id,
            Distributor_Code__c = acc.Id,
            Start_Date__c = System.today(),
            End_Date__c = System.today() + 365,
            Discount_LC__c = 50,
            Discount_USD__c = 50,
             Discount__c = 50,
            CurrencyIsoCode = 'USD'
            
        );
        insert Discount;
        
        Price_Block_Margin_Matrix__c SalesDeduction1 = new Price_Block_Margin_Matrix__c(
        	SKU_Code__c = sku.Id,
            UOM__c = 'KG',
            Depot_Code__c = dp.Id,
            Profit_Center__c = pc.Id,
            Type__c = 'SalesDeduction',
            Sales_Org__c = sorg.Id,
            Start_Date__c = System.today(),
            End_Date__c = System.today() + 365,
            Sales_Deduction_LC__c = 50,
            CurrencyIsoCode = 'USD'
        );
        insert SalesDeduction1;
        
        Price_Block_Margin_Matrix__c Rebate2 = new Price_Block_Margin_Matrix__c(
        	SKU_Code__c = sku.Id,
            UOM__c = 'KG',
            Depot_Code__c = dp.Id,
            Profit_Center__c = pc.Id,
            Type__c = 'Rebate',
            Sales_Org__c = sorg.Id,
            Distributor_Code__c = acc.Id,
            Start_Date__c = System.today(),
            End_Date__c = System.today() + 365,
            Rebate_LC__c = 50,
            Rebate_USD__c = 50,
            Rebate_Code__c = '123',
            CurrencyIsoCode = 'USD'
        );
        insert Rebate2;
        
        Price_Block_Margin_Matrix__c Rebate3 = new Price_Block_Margin_Matrix__c(
        	SKU_Code__c = sku.Id,
            UOM__c = 'KG',
            Depot_Code__c = dp.Id,
            Profit_Center__c = pc.Id,
            Type__c = 'Rebate',
            Sales_Org__c = sorg.Id,
            Distributor_Code__c = acc.Id,
            Start_Date__c = System.today(),
            End_Date__c = System.today() + 365,
            Rebate_LC__c = 50,
            Rebate_USD__c = 50,
            Rebate_Code__c = '1234',
            CurrencyIsoCode = 'USD'
            
        );
        insert Rebate3;
        
         Price_Block_Margin_Matrix__c additionalDiscount1 = new Price_Block_Margin_Matrix__c(
        	SKU_Code__c = sku.Id,
            UOM__c = 'KG',
            Depot_Code__c = dp.Id,
            Profit_Center__c = pc.Id,
            Type__c = 'AdditionalDiscount',
            Sales_Org__c = sorg.Id,
            Distributor_Code__c = acc.Id,
            Start_Date__c = System.today(),
            End_Date__c = System.today() + 365,
            Additional_Discount_LC__c = 50,
            Additional_Discount_USD__c = 50,
             Additional_Discount__c = 50,
             CurrencyIsoCode = 'USD'
            
        );
        insert additionalDiscount1;
        
        Price_Block_Margin_Matrix__c Discount1 = new Price_Block_Margin_Matrix__c(
        	SKU_Code__c = sku.Id,
            UOM__c = 'KG',
            Depot_Code__c = dp.Id,
            Profit_Center__c = pc.Id,
            Type__c = 'Discount',
            Sales_Org__c = sorg.Id,
            Distributor_Code__c = acc.Id,
            Start_Date__c = System.today(),
            End_Date__c = System.today() + 365,
            Discount_LC__c = 50,
            Discount_USD__c = 50,
             Discount__c = 50,
            CurrencyIsoCode = 'USD'
            
        );
        insert Discount1;
        
         Price_Block_Margin_Matrix__c pln = new Price_Block_Margin_Matrix__c(
        	SKU_Code__c = sku.Id,
            UOM__c = 'KG',
            Depot_Code__c = dp.Id,
            Profit_Center__c = pc.Id,
            Type__c = 'PLN',
            Sales_Org__c = sorg.Id,
            Start_Date__c = System.today(),
            End_Date__c = System.today() + 365,
             CurrencyIsoCode = 'USD'
        );
        insert pln;
        
        UOM_Conversion__c uomconversion = new UOM_Conversion__c(
        SKU__c = sku.Id,
            Base_UOM__c = 'L',
            Numerator__c = 1.00,
            Denominator__c = 200.00,
            Sales_Org__c = sorg.Id,
            Sales_UOM__c = 'KG',
            Division__c = Divbj.Id
        );
		insert  uomconversion;
        
        Login_Country__c logCoOj  = new Login_Country__c(
        	Name = 'COSTA RICA',
            For_Contry__c = 'COSTA RICA',
            Sales_Org_Code__c = '5711',
            Delivery_Date__c = true,
            PO_Date__c = true,
            Show_Delivery_Date__c = false,
            Show_PO_Date__c = true
        );
        insert logCoOj;
        Login_Country__c logCoOj1  = new Login_Country__c(
        	Name = 'Multi Country COSTA RICA',
            For_Contry__c = 'Multi Country COSTA RICA',
            Sales_Org_Code__c = '5712',
            Delivery_Date__c = true,
            PO_Date__c = true,
            Show_Delivery_Date__c = false,
            Show_PO_Date__c = true
        );
        insert logCoOj1;
        
        USD_Exchange_Rate__c usdexchnageRate = new USD_Exchange_Rate__c(
            FROM_Currency__c='CLP',
            TO_Currency__c = 'USD',
            Exchange_Rate__c = 800.97,
            Ratio_from__c =1.000,
            Ration_To__c =1.000,
            Valid_From__c = System.today() - 1,
            Combination_Key__c = 'USDExchange001'
        );
        insert usdexchnageRate;
        
        Admin_MPT_Colombia__c adminMPT = new Admin_MPT_Colombia__c(
            Approval_Level__c = 'Level 2',
            Active__c = true,
            Level_1_min__c = 20.01,
            Level_1_max__c = 20.02,
            Level_2_min__c = 15.01,
            Level_2_max__c = 20.00,
            Level_3_below__c = 15.00,
            Sales_Org__c = sorg.Id
        );
        insert adminMPT;
        
        //Data for Sales Order
        Sales_Order__c salesOrderObj = new Sales_Order__c(
            SFDC_Order_Number__c = '208014',                   // SFDC Order Number
            Order_Date__c = System.today(),           // Order Date
            SAP_Order_Number__c = '7066848131',                  // SAP Order Number
            Order_Status__c = 'Completely processed',            // Order Status
           // Order_Type_Colombia__c = 'ZZOR',                     // Order Type
            UGDN__c = '20006305',                                // UGDN
            Division_lk__c = Divbj.Id,                  // Division
            Distribution_Channel_lk__c = disbj.Id,      // Distribution Channel
            CreatedFrom__c = 'SAP',                              // Created From
            Sales_Org_lk__c = sorg.Id,                 // Sales Org
            Total_Amount__c = 1000.00,                           // Total Amount
            Is_Order_FCA_Italy__c = false,                       // Is Order FCA
            Order_FCA_Italy__c = false,                          // Order FCA
            Customer_Approval__c = false,                        // Customer Approval
            IsCustomerPortal__c = false,                         // IsCustomerPortal
            SAP_Password__c = 'init123',                         // SAP Password
            Sold_to_Party__c = acc.Id ,                // Sold to Party
            Depot_Code__c = 'CR10',                              // Depot Code
            Ship_To_Party__c = shippLoc.Id,                // Ship To Party
            Sent_for_Manager_Approval_Mexico__c = false,         // Sent for Manager Approval
            DirectApproved__c = false,                           // Direct Approved
            Sent_for_Director_Approval_Mexico__c = false,        // Sent for Director Approval
            Sent_for_Latam_Director_Approval__c = false,         // Sent for Latam Director Approval
            //TerritoryManager__c = '0050k0000036Um5',             // Territory Manager
            Check_Transport_contribution__c = false,             // Check Transport contribution
            Is_Payment_Term_Discount_Approval_Italy__c = false,  // Is Payment Term Discount Approval
            is_Different_Free_Product__c = false,                // is Different Free Product
            Is_Express_Delivery_Italy__c = false,                // Is Express Delivery
            Colombia_Order_Submitted_for_Approval__c = false,
            Price_Entry__c='Pre-uploaded',
            Remarks__c ='Remarks Test ',
            CurrencyIsoCode = 'CLP'
            // Colombia Order Submitted for Approval
           
        );
        insert salesOrderObj;
        
        //Data for Sales Order Line Item
        Sales_Order_Line_Item__c salesOrdeLineItemObj = new Sales_Order_Line_Item__c(
            Order_Item_Key__c = '1308202020801410',              // OrderNumber_Item_Key
            Item_Number__c = 10,                                 // Item Number
            SAP_Order_Number_Item_Number_Key__c = '706684813110',  // SAP Order Number Item Number Key
            UOM__c = 'KG',                                         // UOM
            DepotDepot__c = dp.Id,                     // Depot
            Sale_Order__c = salesOrderObj.Id,                     // Sales Order
            SKU_Name__c = sku.Id,                       // SKU Name
            Item_Status__c = 'Not yet processed',                  // Item Status
            Division__c = Divbj.Id,
            MinPrice__c =30,
            FinalPrice__c =23,							// Division
            Distribution_Channel__c = disbj.Id,           // Distribution Channel
            Price__c = 1000.00,                                    // Value
            Stock_Available__c = false,                            // Stock Available
            is_Approval_Required__c = false,                       // is Approval Required
            is_Different_Free_Product__c = false,                  // is Different Free Product
            Apply_Campaign_Discount__c = false,                    // Apply Campaign Discount
            Quantity__c = 1.00,                                  // Quantity
            Check_Transport_contribution__c = false,               // Check Transport contribution
            Sales_Org__c = sorg.Id,
            CurrencyIsoCode = 'CLP'
        );
        insert salesOrdeLineItemObj;
        
        Attachment attach=new Attachment();   	
    	attach.Name='Unit Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=salesOrderObj.id;
        attach.IsPrivate = false;
        attach.ContentType = 'image/jpeg';
        insert attach;
        
       Test.stopTest(); 
    }
    
    static testMethod void method() {
       
        Account acc = [Select id From Account LIMIT 1];
        Order__c ord = [Select id From Order__c LIMIT 1];
        Sku__c sku = [Select id From Sku__c LIMIT 1];
        Order_Type__c ordType =[select id,Name from Order_Type__c LIMIT 1];
        Shipping_Location__c shippLoc =[Select id from Shipping_Location__c LIMIT 1];
        System.debug('orderType test class '+ordType);
        Inco_Term__c incoTermObj =[select Id,Name,IncoTerm_Code__c,IncoTerm_Desc__c from Inco_Term__c LIMIT 1];
        Payment_Method__c paymentMethodObj=[select Id from Payment_Method__c LIMIT 1];
        Payment_Term__c paymentTermObj =[select Id,SalesOrgCode__c,Payment_Term__c from Payment_Term__c LIMIT 1];
        OrderTemplate__c ordTemp = [Select id From OrderTemplate__c LIMIT 1];
        Depot__c depot=[Select Id, Name from Depot__c]; 
        Sales_Order__c salesOrderObj =[Select id From Sales_Order__c LIMIT 1];
        
        //Sales_Order__c sObj= new Sales_Order__c();
        PageReference pageRef = Page.OrderCam_edit;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('soid',salesOrderObj.id); 
        pageRef.getParameters().put('acid',acc.id); 
        ApexPages.StandardController sc = new ApexPages.StandardController(ord);
        OrderCam_EditController ordmanage = new OrderCam_EditController(sc);
        ordmanage.country = '5711';
        
        ordmanage.PO = '23423';
        System.debug('depot.Id in test class '+depot.Id);
        ordmanage.storageIdChosen = depot.Id;
       	ordmanage.skuIdChosen = sku.Id;
        ordmanage.Payment_Terms = paymentTermObj.Id;
        ordmanage.tempIdChosen = ordTemp.Id;
        ordmanage.poDate = System.today();
        
        OrderCam_EditController.DistributorWrapper distributorWrapperObj = new OrderCam_EditController.DistributorWrapper();
        distributorWrapperObj.country = 'Costa Rica';
         ordmanage.orderId = ord.Id;
        ordmanage.fetchDistributorDetails();
        //ordmanage.fetchSKUData();
        ordmanage.populateShippingAddress();
        ordmanage.searchProduct(); 
        
        //ordmanage.editOrder();  editSalesOrder
        //ordmanage.skuIdChosen = sku.Id;
        ordmanage.addSKU(); 
        ordmanage.updateSKU();
        ordmanage.Payment_Terms = paymentTermObj.Id;
        ordmanage.selectedShipping =shippLoc.Id;
        ordmanage.saveOrder();
        
        ordmanage.confirmOrder();
        
        Test.startTest();
        ordmanage.getTemplateName();
        ordmanage.Payment_Methods = paymentMethodObj.Id;
        ordmanage.saveTemplate();
        ordmanage.showOrderHistory();
        
        ordmanage.showOrderTemplates();
        ordmanage.tempIdChosen=ordTemp.Id;
        ordmanage.loadTemplate();
        ordmanage.skuDetailsMap = new Map<Id,OrderCam_EditController.SKUDetails>();
        OrderCam_EditController.SKUDetails details = new OrderCam_EditController.SKUDetails();
        details.netRateEntered = 0;
        ordmanage.skuDetailsMap.put(sku.Id,details);
        ordmanage.addSOItem();
        
        details.netRateEntered = 10;
        ordmanage.skuDetailsMap.put(sku.Id,details);
        ordmanage.addSOItem();
        
        
        
        ordmanage.addSOLineItem();
        ordmanage.redirectFunction();
        
        ordmanage.deleteSKU();
        ordmanage.deleteAllSKU();
        
        details.deliveryDate = System.today();
        details.e2EUOM = 'KG';
        details.e2EUOMValueCon = 40;
        details.e2EBaseUOM = 'KG';
        details.e2ESalesUOM = 'KG';
        details.e2ECostLC = 40;
        details.e2ECostUSD = 40;
        details.e2ECostUPC9LC = 40;
        details.e2ECostUPC9USD = 40;
        details.e2ECostMBEWLC = 40;
        details.e2ECostMBEWUSD = 40;
        details.salesDeductionUOM = 'KG';
        details.salesDeductionLC = 40;
        details.salesDeductionUSD = 40;
        details.salesDeductionDUOMValueCon = 40;
        details.salesDeductionInPercent = 40;
        details.rebate1UOM = 'KG';
        details.rebate1LC = 40;
        details.rebate1USD = 40;
        details.rebateUOMConver1 = 40;
        details.rebateUOMConver2 = 40;
        details.rebate1Percent = 40;
        details.rebateCode1 = '401';
        details.rebate2UOM = 'KG';
        details.rebate2LC = 40;
        details.rebate2USD = 40;
        details.rebate2Percent = 40;
        details.rebateCode2 = '140';
        details.discountUOM = 'KG';
        details.discountLC = 40;
        details.discountUSD = 40;
        details.discountPercent = 40;
        details.discountUOMConver = 40;
        details.additionalDiscountUOM = 'KG';
        details.additionalDiscountLC = 40;
        details.additionalDiscountUSD = 40;
        details.additionalDiscountPercent = 40;
        details.additionalDiscountUOMConver = 40;
        details.plnUOM = 'KG';
        details.pLNLC = 40;
        details.pLNUSD = 40;
        details.profitCenter = 'PC-40';
        details.specialSKU = true;
        details.uomRebate1 = 'KG';
        details.uomRebate2 = 'KG';
        details.uomAddDiscount = 'KG';
        details.uomDiscount = 'KG';
        details.uomSalesDeduction = 'KG';
        details.uome2eCost = 'KG';
        details.uomPLN = 'KG';
        details.baseUOM = 'KG';
        details.convertQty = 40;
        details.convertNetPrice = 40;
        details.convertFinalPrice = 40;
        
        ordmanage.deleteSOItem();
        ordmanage.deleteSOItem1();
        
        Test.stopTest();
        
    }
    
   
     static testMethod void method2() {
         User u = [select Id,Name,ManagerId from User limit 1];
         Depot__c depot=[Select Id, Name from Depot__c]; 
         Sku__c sku = [Select id From Sku__c LIMIT 1];
         Payment_Term__c paymentTermObj =[select Id,SalesOrgCode__c,Payment_Term__c from Payment_Term__c LIMIT 1];
        OrderTemplate__c ordTemp = [Select id From OrderTemplate__c LIMIT 1];
         Shipping_Location__c shippLoc =[Select id from Shipping_Location__c LIMIT 1];
         Sales_Order__c salesOrderObj =[Select id From Sales_Order__c LIMIT 1];
         userrole  usrole = new userrole();
        usrole.Name ='Regional Manager (New CAM)';
         insert usrole;
         Profile p = [SELECT Id,name FROM Profile WHERE Name = 'CAM(Regional Manager)'];
         User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'himanshua.mehta1@skinternational.com';                             
        sobj1.ProfileId  = p.ID;                                                     
        sobj1.Username = 'zonal_aaexe12321@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='Terriotory Manager';
        sobj1.CommunityNickname = 'zonalExe1222ppDi'; 
        sobj1.TimeZoneSidKey = 'Asia/Kolkata'; 
        // sobj1.Contact.AccountID = acc.id;// Time Zone
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId=usrole.id;
        sobj1.ManagerId = userInfo.getUserId();
        insert sobj1;
         Order__c ord = [Select id From Order__c LIMIT 1];
         System.runAs(u){
             
             ApexPages.StandardController sc = new ApexPages.StandardController(ord);
             OrderCam_EditController ordmanage = new OrderCam_EditController(sc);
             PageReference pageRef = Page.OrderCam_edit;
        	 Test.setCurrentPage(pageRef);
             pageRef.getParameters().put('soid',salesOrderObj.id); 
             ordmanage.country = '5711';
             ordmanage.storageIdChosen = depot.Id;
             ordmanage.salesOrderId = salesOrderObj.Id;
             ordmanage.skuIdChosen = sku.Id;
             ordmanage.Payment_Terms = paymentTermObj.Id;
             ordmanage.tempIdChosen = ordTemp.Id;
             ordmanage.poDate = System.today();
             ordmanage.orderId = ord.Id;
             ordmanage.fetchDistributorDetails();
             ordmanage.populateShippingAddress();
        	 ordmanage.searchProduct(); 
        	 ordmanage.confirmOrder();
             ordmanage.addSOItem();
             ordmanage.deleteSOItem();
             ordmanage.deleteSOItem1();
         }
        // Test.stopTest();
     }
    
    static testMethod void method3() {
        Order__c ord = [Select id From Order__c LIMIT 1];
        Sales_Order__c salesOrderObj =[Select id From Sales_Order__c LIMIT 1];
    	ApexPages.StandardController sc = new ApexPages.StandardController(ord);
     	OrderCam_EditController ordmanage = new OrderCam_EditController(sc);
        PageReference pageRef = Page.OrderCam_edit;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('soid',salesOrderObj.id);
        ordmanage.addSKU();
        //ordmanage.createSalesOrder2(salesOrderObj.id);
    }
    
}