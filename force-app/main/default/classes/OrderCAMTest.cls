@isTest
public class OrderCAMTest {
    //testing data setup for all methods in this class
    @testSetup
    static void allTheDataForThisTestClass() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
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
        sorg.company_code__c='5710';
        insert sorg;
        
        Sales_Org__c sorg1 =new Sales_Org__c();
        sorg1.Name='Multi Country Costa Rica';
        sorg1.Description__c='Multi Country Costa Rica';
        sorg1.Sales_Org_Code__c='5712';
        insert sorg1;
        RecordType depot_RecTypeId = [SELECT Id FROM RecordType WHERE Name = 'Depot' and isActive = TRUE LIMIT 1];
        Depot__c dp_M = new Depot__c ();
        dp_M.Name = 'CR10';
        dp_M.recordtypeId = depot_RecTypeId.id;
        dp_M.Country__c = 'CAM';
        dp_M.Location__c = 'NORTE';
        dp_M.Depot_Code__c = 'CR10';
        dp_M.Active__c = true;
        dp_M.SalesOrg__c = sorg.ID;
        Insert dp_M;
        
        RecordType Supplier_RecTypeId = [SELECT Id FROM RecordType WHERE name = 'Storage Location' and isActive = true LIMIT 1];
        Depot__c dp =new Depot__c ();
        dp.Name='CR11';
        dp.recordtypeId=Supplier_RecTypeId.id;
        dp.Country__c='Costa Rica';
        dp.Location__c='NORTE';
        dp.Depot_Code__c='CR11';
        dp.SalesOrg__c = sorg.ID;
        dp.Depot__C=dp_M.Id;
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
        sku.SKU_UOM__c='L';
        sku.Multiple_Of__c=5;
        sku.Group__c='DOST';
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='L';
        sku.Active__c=True;
        sku.Brand_Name__c='sku';
        
        sku.Combination_Key__c='Cooooooo000011111';
        insert sku;
        
        List<Blanket_SKU__c> blanketSku=new List<Blanket_SKU__c>();
        Blanket_SKU__c bSKU = new Blanket_SKU__c();
        bSKU.SKU__c= sku.id;
        bSKU.Sales_Org__c = sorg.Id;
        bSKU.Start_Date__c = System.today();   
        bSKU.End_Date__c = System.today();
        bSKU.Status__c = true;
        blanketSku.add(bSKU);
        
        Blanket_SKU__c bSKU1 = new Blanket_SKU__c();
        bSKU1.SKU__c= sku.id;
        bSKU1.Sales_Org__c = sorg.Id;
        bSKU1.Start_Date__c = System.today();   
        bSKU1.End_Date__c = System.today();
        bSKU1.Status__c = true;
        blanketSku.add(bSKU1);
        insert blanketSku;
        
        List<UOM_Conversion__c> uomList=new List<UOM_Conversion__c>();
        
        UOM_Conversion__c uomConObj = new UOM_Conversion__c(
            Sales_Org__c = sorg.Id,         
            Base_UOM__c = 'L',            
            SKU__c = sku.Id,                
            Sales_UOM__c = 'kg',                 
            Distribution_Channel__c = disbj.id, 
            Numerator__c = 1.00,                 
            Division__c = Divbj.ID,             
            Denominator__c = 1.00,                  
            Combination_Key__c = 'Test1'            
        );
        uomList.add(uomConObj);
        insert uomList;
        
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
        PbMaster.UOM__c = 'NOS';                          
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
        ordType.Name = 'ZZEX'; // ZZOR            
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
            Payterms_Desc__c = 'Contado1',       // Payterms Desc
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
            UOM__c = 'BAG',                                     // UOM
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
        acc.Storage_Location_code__c='CR10';
        acc.Sales_Org__c = sorg.Id;
       // Company_Code__c
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
        usrole.Name ='Regional/Zonal Managers for Mexico';
        
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
        //sobj1.Contact.AccountID = acc.id;// Time Zone
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId=usrole.id;
        sobj1.ContactId=con.Id;
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
        shippLoc.Sales_Org__c=sorg.Id;
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
        invObj.UOM__c = 'L';                    
        invObj.Storage_Location__c = 'MAIN';  
        invObj.SKU__c = sku.Id;  
        invObj.SKU_Depot__c ='sd1';           
        insert invObj;
        
       /* PricebookDiscount__c PbDis = new PricebookDiscount__c();
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
        PbDis.Sales_Org__c=sorg.Id;
        PbDis.CompositeKey__c = '01-04-2016BHA103000000000000692001';           
        insert PbDis;*/
        
        Distributor_Depot_Mapping__c dsMap =new Distributor_Depot_Mapping__c();
        dsMap.Distributor__c = acc.id;
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
        ord.CurrencyIsoCode='CLP';
        ord.Remarks__c='test';
        insert ord;
        
        OrderLineItem__c ordItem = new OrderLineItem__c();
        ordItem.Item_Status__c = 'test';          
        ordItem.SKU_Name__c = sku.Id; 
        ordItem.Item_Number__c = '10';          
        ordItem.UOM__c = 'L';                   
        ordItem.No_of_Case__c = 1;            
        ordItem.Invoice_Discount__c = 0.00;     
        ordItem.Quantity__c = 100;          
        ordItem.Special_Discount__c = 0.00;     
        ordItem.Price__c = 23000;            
        ordItem.Order__c = ord.Id;    
        ordItem.Stock_Available__c = false;  
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
        List<Price_Block_Margin_Matrix__c> pbMatrixList=new List<Price_Block_Margin_Matrix__c>();
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
            E2E_Cost_USD__c = 50
        );
        pbMatrixList.add(e2ecost);
        
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
            E2E_Cost_MBEW_USD__c = 50
        );
        pbMatrixList.add(e2ecostmbew);
        
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
            E2E_Cost_UPC9_USD__c = 50
        );
        pbMatrixList.add(e2ecostupc9);
        
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
            Sales_Deduction_USD__c =30
        );
        
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
           Sales_Deduction_USD__c =30
        );
        pbMatrixList.add(SalesDeduction);
        pbMatrixList.add(SalesDeduction1);
        
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
            Rebate_Code__c = '123'
            
        );
        pbMatrixList.add(Rebate);
        
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
            Rebate_Code__c = '1234'
            
        );
        pbMatrixList.add(Rebate1);
        
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
             Additional_Discount__c = 50
            
        );
        pbMatrixList.add(additionalDiscount);
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
             Additional_Discount__c = 50
            
        );
        pbMatrixList.add(additionalDiscount1);
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
             Discount__c = 50
            
        );
        pbMatrixList.add(Discount);
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
             Discount__c = 50
            
        );
        pbMatrixList.add(Discount1);
         Price_Block_Margin_Matrix__c pln = new Price_Block_Margin_Matrix__c(
        	SKU_Code__c = sku.Id,
            UOM__c = 'KG',
            Depot_Code__c = dp.Id,
            Profit_Center__c = pc.Id,
            Type__c = 'PLN',
            Sales_Org__c = sorg.Id,
            Start_Date__c = System.today(),
            End_Date__c = System.today() + 365,
            PLN_LC__c=20,
            PLN_USD__c=20 
        );
        pbMatrixList.add(pln);
        
        Price_Block_Margin_Matrix__c pln1 = new Price_Block_Margin_Matrix__c(
        	SKU_Code__c = sku.Id,
            UOM__c = 'KG',
            Depot_Code__c = dp.Id,
            Profit_Center__c = pc.Id,
            Type__c = 'PLN',
            Sales_Org__c = sorg.Id,
            Start_Date__c = System.today(),
            End_Date__c = System.today() + 365,
            PLN_LC__c=20,
            PLN_USD__c=20
        );
        pbMatrixList.add(pln1);
        Insert pbMatrixList;
        
        UOM_Conversion__c uomconversion = new UOM_Conversion__c(
        SKU__c = sku.Id,
            Base_UOM__c = 'KG',
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
        Test.stopTest();
    }
    
    static testMethod void method() {
        Account acc = [Select id From Account LIMIT 1];
        Order__c ord = [Select id From Order__c LIMIT 1];
        Sku__c sku = [Select id From Sku__c LIMIT 1];
        Order_Type__c ordType =[select id,Name from Order_Type__c LIMIT 1];
        Sales_Org__c sorgRec=[Select Id from Sales_Org__c where Sales_Org_Code__c='5712' Limit 1];
        System.debug('orderType test class '+ordType);
        Payment_Method__c paymentMethodObj=[select Id from Payment_Method__c LIMIT 1];
        Payment_Term__c paymentTermObj =[select Id,SalesOrgCode__c,Payment_Term__c from Payment_Term__c LIMIT 1];
        Inco_Term__c incoTermObj =[select Id,Name,IncoTerm_Code__c,IncoTerm_Desc__c from Inco_Term__c LIMIT 1];
        OrderTemplate__c ordTemp = [Select id From OrderTemplate__c LIMIT 1];
        Depot__c depot=[Select Id, Name from Depot__c Limit 1]; 
        
        Sales_Order__c sObj= new Sales_Order__c();
        PageReference pageRef = Page.OrderCAM;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('acid',acc.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(ord);
        OrderCAMController ordmanage = new OrderCAMController(sc);
        ordmanage.PO = '23423';
        System.debug('depot.Id in test class '+depot.Id);
        ordmanage.storageIdChosen = depot.Id;
        ordmanage.skuIdChosen = sku.Id;
        ordmanage.Payment_Terms = paymentTermObj.Id;
        ordmanage.tempIdChosen = ordTemp.Id;
        ordmanage.poDate = System.today();
        ordmanage.orderType = 'ZZEX';
        //ordmanage.DeliveryDate = System.today();//Delivery Date:RITM0094155, 3rd September 2020, Sayan (crmconsultant3@upl-ltd.com)
        OrderCAMController.DistributorWrapper distributorWrapperObj = new OrderCAMController.DistributorWrapper();
        //distributorWrapperObj.country = 'Costa Rica';
        //ordmanage.selectedOrderType = orderType.Id;
        ordmanage.fetchDistributorDetails();
        
        //ordmanage.fetchSKUData();
        //ordmanage.populatePaymentMethod();
        //ordmanage.populateOrderType();
        ordmanage.populateShippingAddress();
        //ordmanage.changePaymentMethod();
        //ordmanage.selectedPayment = paymentMethodObj.Id;
        //ordmanage.selectedPaymentId = paymentMethodObj.Id;  
        //ordmanage.changePaymentTerm();
        ordmanage.searchProduct(); 
        ordmanage.searchProdValue='sku';
        ordmanage.searchProduct();
        ordmanage.orderType = 'ZZEX';
        ordmanage.addSKU(); 
        ordmanage.editOrder();
        ordmanage.updateSKU();
        ordmanage.getTemplateName();
        ordmanage.saveOrder();
        Test.startTest();
        ordmanage.confirmOrder();
        ordmanage.loadTemplate();
        ordmanage.saveTemplate();
        ordmanage.Payment_Methods = paymentMethodObj.Id;
        ordmanage.Payment_Terms = paymentTermObj.Id;
        ordmanage.Inco_Terms = incoTermObj.Id;
        ordmanage.getTemplateName();
        ordmanage.showOrderHistory();
        ordmanage.showOrderTemplates();
        ordmanage.redirectFunction();
        
        ordmanage.deleteSKU();
        ordmanage.deleteAllSKU();
        
        /*ordmanage.skuIdChosen = sku.Id;
        
        ordmanage.Payment_Methods = paymentMethodObj.Id;
        
        ordmanage.tempIdChosen=ordTemp.Id;
        
        ordmanage.redirectFunction();
        ordmanage.deleteSKU();
        ordmanage.deleteAllSKU(); */
        Test.stopTest();
    } 
    
    static testMethod void method1() {
        Test.startTest();
        Order__c ord = [Select id From Order__c LIMIT 1];
         PageReference pageRef = Page.OrderCAM;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('acid',null);
        ApexPages.StandardController sc = new ApexPages.StandardController(ord);
        OrderCAMController ordmanage = new OrderCAMController(sc);
        ordmanage.setorderType('ZZEX');
        ordmanage.changeDepot();
        ordmanage.changePayment();
        ordmanage.picklist();
        ordmanage.getCountryOptions();
        Test.stopTest();
    } 
    
     /*  
* Name: createOrderMethod    
* return:void
* Description: RITM0497119-This method responsible to cover Sales Order Creation Method.
*/
    static testMethod void createOrderMethod() {
        
        Account acc = [Select id From Account LIMIT 1];
        Order__c ord = [Select id From Order__c LIMIT 1];
        Sku__c sku = [Select id From Sku__c LIMIT 1];
        Order_Type__c ordType =[select id,Name from Order_Type__c LIMIT 1];
        Sales_Org__c sorgRec=[Select Id from Sales_Org__c where Sales_Org_Code__c='5712' Limit 1];
        System.debug('orderType test class '+ordType);
        Payment_Method__c paymentMethodObj=[select Id from Payment_Method__c LIMIT 1];
        Payment_Term__c paymentTermObj =[select Id,SalesOrgCode__c,Payment_Term__c from Payment_Term__c LIMIT 1];
        Inco_Term__c incoTermObj =[select Id,Name,IncoTerm_Code__c,IncoTerm_Desc__c from Inco_Term__c LIMIT 1];
        OrderTemplate__c ordTemp = [Select id From OrderTemplate__c LIMIT 1];
        Depot__c depot=[Select Id, Name from Depot__c Limit 1]; 
        PriceBookMaster__c pBMaster=[Select Id ,Final_Price__c from PriceBookMaster__c Limit 1];
        List<Price_Block_Margin_Matrix__c> pbList=[Select Id from Price_Block_Margin_Matrix__c where type__c='rebate'];
        Price_Block_Margin_Matrix__c pbE2E=[Select Id from Price_Block_Margin_Matrix__c where type__c='E2Ecost' Limit 1];
        delete pbE2E;
        delete pbList[0];
        pBMaster.Final_Price__c=5000;
        Update pBMaster;
        Sales_Order__c sObj= new Sales_Order__c();
        PageReference pageRef = Page.OrderCAM;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('acid',acc.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(ord);
        OrderCAMController ordCAM = new OrderCAMController(sc);
        ordCAM.PO = '23423';
        System.debug('depot.Id in test class '+depot.Id);
        ordCAM.storageIdChosen = depot.Id;
        ordCAM.skuIdChosen = sku.Id;
        ordCAM.Payment_Terms = paymentTermObj.Id;
        ordCAM.tempIdChosen = ordTemp.Id;
        ordCAM.poDate = System.today();
        //ordmanage.DeliveryDate = System.today();//Delivery Date:RITM0094155, 3rd September 2020, Sayan (crmconsultant3@upl-ltd.com)
        OrderCAMController.DistributorWrapper distributorWrapperObj = new OrderCAMController.DistributorWrapper();
        
        ordCAM.fetchDistributorDetails();
        
        ordCAM.populateShippingAddress();
        
        ordCAM.addSKU(); 
        ordCAM.editOrder();
        ordCAM.updateSKU();
        ordCAM.getTemplateName();
        ordCAM.saveOrder();
        Test.startTest();
        ordCAM.confirmOrder();
        //Sales_Order__c newSo=[Select Id,depot__c from Sales_Order__c];
        //system.Assert(newSo.depot__c!=null);
        Price_Block_Margin_Matrix__c pbE2EUPC9=[Select Id from Price_Block_Margin_Matrix__c where type__c='E2ECostUPC9' Limit 1];
        delete pbE2EUPC9;
        UOM_Conversion__c uomList=[Select Id,Base_UOM__c,Sales_UOM__c from UOM_Conversion__c Limit 1];
        uomList.Base_UOM__c='kg';
        update uomList;
        ordCAM.confirmOrder();
        test.stopTest();
        
    }
    
}