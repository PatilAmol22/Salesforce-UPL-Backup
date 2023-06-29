@isTest
public class SoChileEditControllerTest { 
    
    @testSetup
    static void allTheDataForThisTestClass() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Chile';
        sorg.Description__c='Chile';
        sorg.Sales_Org_Code__c='5661';
        insert sorg;
        
        Sales_Org__c sorg1 =new Sales_Org__c();
        sorg1.Name='Chile Export';
        sorg1.Description__c='Chile Export';
        sorg1.Sales_Org_Code__c='5662';
        insert sorg1;

        
        RecordType Supplier_RecTypeId = [SELECT Id FROM RecordType WHERE name = 'Depot' and isActive = true LIMIT 1];
        Depot__c dp =new Depot__c ();
        dp.Name='Chile';
        dp.recordtypeId=Supplier_RecTypeId.id;
        dp.Country__c='Chile';
        dp.Location__c='';
        dp.Depot_Code__c='CL00';
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
        
        Distribution_Channel__c disbj1 = new Distribution_Channel__c();
        disbj1.Name = '40';                      
        disbj1.Distribution_Channel_Code__c = '40';  
        disbj1.Description__c='test';
        insert disbj1;
        
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
        
        sku.Combination_Key__c='Cooooooo000011111';
        insert sku;
        
        SKU__c sku1 = new SKU__c();
        sku1.Name='DOST';
        sku1.SKU_Code__c='704002';
        sku1.SKU_Pack__c=1.00;
        sku1.SKU_UOM__c='L';
        sku1.Multiple_Of__c=5;
        sku1.Group__c='DOST';
        sku1.Pack_Size__c=10.00;
        sku1.Product_Name__c=pro.Id;
        sku1.Sales_Org__c = sorg.Id;
        sku1.UOM__c='L';
        
        sku1.Active__c=True;
        
        sku1.Combination_Key__c='Cooooooo000022222';
        insert sku1;
        
        
        PriceBookMaster__c PbMaster = new PriceBookMaster__c();
        PbMaster.SKUCode__c = sku.id;           
        PbMaster.DepotCode__c =dp.id;         
        PbMaster.Price__c = 34500;                    
        PbMaster.UOM__c = 'L';                          
        PbMaster.StartDate__c = system.today();
        PbMaster.EndDate__c = system.today()+1;
        PbMaster.Active__c = true;                      
        PbMaster.PerUnit__c = 1;                       
        PbMaster.Batch__c ='test'; 
        PbMaster.CurrencyIsoCode='USD'; 
        PbMaster.Division__c= Divbj.ID;
        PbMaster.CompositeKey__c='c1';
        //  PbMaster.DistributorCustomerCode__c='';
        insert PbMaster; 
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZWOR';              
        ordType.Description__c = 'ZWOR';    
        ordType.Order_Type_Code__c = 'ZWOR';
        ordType.SalesOrg__c = sorg.Id;
        insert ordType;
        
         Order_Type__c ordType1 =new Order_Type__c();
        ordType1.Name = 'ZZOR';              
        ordType1.Description__c = 'ZZOR';    
        ordType1.Order_Type_Code__c = 'ZZOR';
        ordType1.SalesOrg__c = sorg1.Id;
        insert ordType1;
        
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
        
        userrole  usrole = new userrole();
        usrole.Name ='Chile Customer Service User';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Chile Customer Service'];
        
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
        insert sobj1;
                
        
        Account acc = new Account();
        acc.Name='Nikhil';
        acc.Last_Name__c='Dhoke';
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='8600000000';
        acc.Phone='020200000';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Mumbai';
        acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'CL00';
        acc.Payment_Term_Code__c=payment_term.id;
        
        acc.OwnerId=sobj1.Id;
        insert acc;
        
        PbMaster.DistributorCustomerCode__c=acc.id;
        update PbMaster; 
        
        contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName=acc.Last_Name__c;
        insert con;
        
        
        system.debug('Account ID = '+acc.Id);
        Shipping_Location__c shippLoc =new Shipping_Location__c();
        shippLoc.Location_Name__c ='Same as Billing Address'; 
        shippLoc.Region__c='S.No:46/1, A1 Building, First Floor, Office No.101 E-Space, Wadgoan Sheri,Nagar Rd, Aga Nagar,';
        shippLoc.Distributor__c=acc.Id;
        shippLoc.City__c='Pune';
        shipploc.Sales_Org__c =sorg.Id;
        shippLoc.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc.SAP_Code__c='SAP0001';
        shippLoc.State__c='13';
        insert shippLoc;
        
        Shipping_Location__c shippLoc2 =new Shipping_Location__c();
        shippLoc2.Location_Name__c ='Mumbai'; 
        shippLoc2.Region__c='S.No:46/1, A1 Building, First Floor, Office No.101 E-Space, Wadgoan Sheri,Nagar Rd, Aga Nagar,';
        shippLoc2.Distributor__c=acc.Id;
        shippLoc2.City__c='Pune';
        shippLoc2.Sales_org__c=sorg.Id;
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
        spelDis.SKUCode__c = sku.Id;                          
        spelDis.StartDate__c = system.today();                         
        spelDis.UOM__c = 'L';                                                   
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
        invObj.Depot__c=dp.id;          
        insert invObj;
        
        
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
        
                
        Order__c ord = new Order__c();
        ord.Shipping_Location__c = shippLoc.id;  
        ord.Bill_To_Party__c = acc.Id;        
        ord.Order_Date__c = system.today();  
        ord.Order_Raise_By__c = 'Distributor';            
        ord.Order_Status__c = 'Draft';                    
        ord.Sales_Org__c =sorg.Id;          
        ord.Distribution_Channel__c =disbj.Id; 
        ord.Division__c = Divbj.Id;
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
        
        Login_Country__c logCountryObj = new Login_Country__c();
        logCountryObj.Name ='Chile'; 
        logCountryObj.For_Contry__c ='Chile';
        logCountryObj.Sales_Org_Code__c ='5661';
        insert logCountryObj;
        
        //CR#169 - Margin Block Approval Process - Chile - kalpesh chande - 10/11/2022 - Start Here
        Admin_MPT_Colombia__c adminMPT = new Admin_MPT_Colombia__c();
        adminMPT.Active__c = true;
        adminMPT.Approval_Level__c = 'Level 2';
        adminMPT.Sales_Org__c = sorg.Id;
        adminMPT.Level_3_below__c = 15;
        adminMPT.Level_2_min__c = 15.01;    
        adminMPT.Level_2_max__c = 20.00;
        adminMPT.Level_1_min__c = 20.01;
        adminMPT.Level_1_max__c = 30.00;
        adminMPT.Level_2_Minimum_Discount_Percent__c=5.01;
        adminMPT.Level_2_Maximum_Discount_Percent__c=10.00;
        adminMPT.Level_2_Minimum_Gross_Margin_Percent__c=20.00;
        insert adminMPT;
        
        Blanket_SKU__c bSKU = new Blanket_SKU__c();
        bSKU.SKU__c= sku.id;
        bSKU.Sales_Org__c = sorg.Id;
        bSKU.Start_Date__c = System.today();   
        bSKU.End_Date__c = System.today();
        bSKU.Status__c = false;
        insert bSKU;  
        
        Profit_Center__c pc = new Profit_Center__c();
        pc.Sales_Org__c = sorg.Id;
        pc.Profit_Center__c = 'LA0009';
        pc.Sales_Value__c = 3;
        insert pc;
        
        
        Price_Block_Margin_Matrix__c e2eCost = new Price_Block_Margin_Matrix__c();
        e2eCost.E2E_Cost_USD__c = 2;
        e2eCost.Type__c = 'E2ECost';
        e2eCost.Profit_Center__c = pc.Id;
        e2eCost.UOM__c = 'L';
        e2eCost.Start_Date__c = System.today();
        e2eCost.End_Date__c = System.today().addDays(5);
        e2eCost.Depot_Code__c = dp.Id;
        e2eCost.Sales_Org__c = sorg.Id;
        e2eCost.SKU_Code__c = sku.id;
        e2eCost.CurrencyIsoCode = 'USD';
        insert e2eCost;
         Price_Block_Margin_Matrix__c e2eCost1 = new Price_Block_Margin_Matrix__c();
        e2eCost1.E2E_Cost_USD__c = 2;
        e2eCost1.Type__c = 'E2ECost';
        e2eCost1.Profit_Center__c = pc.Id;
        e2eCost1.UOM__c = 'KG';
        e2eCost1.Start_Date__c = System.today();
        e2eCost1.End_Date__c = System.today().addDays(5);
        e2eCost1.Depot_Code__c = dp.Id;
        e2eCost1.Sales_Org__c = sorg.Id;
        e2eCost1.SKU_Code__c = sku1.id;
        e2eCost1.CurrencyIsoCode = 'USD';
        insert e2eCost1;
        
        Price_Block_Margin_Matrix__c e2eUPC9 = new Price_Block_Margin_Matrix__c();
        e2eUPC9.E2E_Cost_UPC9_USD__c = 2;
        e2eUPC9.Type__c = 'E2ECostUPC9';
        e2eUPC9.Profit_Center__c = pc.Id;
        e2eUPC9.UOM__c = 'L';
        e2eUPC9.Start_Date__c = System.today();
        e2eUPC9.End_Date__c = System.today().addDays(5);
        e2eUPC9.Depot_Code__c = dp.Id;
        e2eUPC9.Sales_Org__c = sorg.Id;
        e2eUPC9.SKU_Code__c = sku.id;
        e2eUPC9.CurrencyIsoCode = 'USD';
        insert e2eUPC9;
                
        
        Price_Block_Margin_Matrix__c e2eUPC91 = new Price_Block_Margin_Matrix__c();
        e2eUPC91.E2E_Cost_UPC9_USD__c = 2;
        e2eUPC91.Type__c = 'E2ECostUPC9';
        e2eUPC91.Profit_Center__c = pc.Id;
        e2eUPC91.UOM__c = 'KG';
        e2eUPC91.Start_Date__c = System.today();
        e2eUPC91.End_Date__c = System.today().addDays(5);
        e2eUPC91.Depot_Code__c = dp.Id;
        e2eUPC91.Sales_Org__c = sorg.Id;
        e2eUPC91.SKU_Code__c = sku1.id;
        e2eUPC91.CurrencyIsoCode = 'USD';
        insert e2eUPC91;
        
        Price_Block_Margin_Matrix__c e2eMBEW = new Price_Block_Margin_Matrix__c();
        e2eMBEW.E2E_Cost_MBEW_USD__c = 2;
        e2eMBEW.Type__c = 'E2ECostMBEW';
        e2eMBEW.Profit_Center__c = pc.Id;
        e2eMBEW.UOM__c = 'L';
        e2eMBEW.Start_Date__c = System.today();
        e2eMBEW.End_Date__c = System.today().addDays(5);
        e2eMBEW.Depot_Code__c = dp.Id;
        e2eMBEW.Sales_Org__c = sorg.Id;
        e2eMBEW.SKU_Code__c = sku.id;
        e2eMBEW.CurrencyIsoCode = 'USD';
        insert e2eMBEW;
        
         Price_Block_Margin_Matrix__c e2eMBEW1 = new Price_Block_Margin_Matrix__c();
        e2eMBEW1.E2E_Cost_MBEW_USD__c = 2;
        e2eMBEW1.Type__c = 'E2ECostMBEW';
        e2eMBEW1.Profit_Center__c = pc.Id;
        e2eMBEW1.UOM__c = 'KG';
        e2eMBEW1.Start_Date__c = System.today();
        e2eMBEW1.End_Date__c = System.today().addDays(5);
        e2eMBEW1.Depot_Code__c = dp.Id;
        e2eMBEW1.Sales_Org__c = sorg.Id;
        e2eMBEW1.SKU_Code__c = sku1.id;
        e2eMBEW1.CurrencyIsoCode = 'USD';
        insert e2eMBEW1;
        
        UOM_Conversion__c uom = new UOM_Conversion__c();
        uom.Base_UOM__c = 'L';
        uom.Sales_UOM__c = 'KG';
        uom.Numerator__c = 1;
        uom.Denominator__c = 1;
        uom.Sales_Org__c = sorg.Id;
        uom.SKU__c = sku.id;
        insert uom;
         UOM_Conversion__c uom1 = new UOM_Conversion__c();
        uom1.Base_UOM__c = 'L';
        uom1.Sales_UOM__c = 'KG';
        uom1.Numerator__c = 1;
        uom1.Denominator__c = 1;
        uom1.Sales_Org__c = sorg.Id;
        uom1.SKU__c = sku1.id;
        insert uom1;
        
        Price_Block_Margin_Matrix__c rebate1 = new Price_Block_Margin_Matrix__c();
        rebate1.Rebate_USD__c = 2;
        rebate1.Type__c = 'Rebate';
        rebate1.Profit_Center__c = pc.Id;
        rebate1.UOM__c = 'L';
        rebate1.Start_Date__c = System.today();
        rebate1.End_Date__c = System.today().addDays(5);
        rebate1.Depot_Code__c = dp.Id;
        rebate1.Sales_Org__c = sorg.Id;
        rebate1.SKU_Code__c = sku.id;
        rebate1.CurrencyIsoCode = 'USD';
        rebate1.Distributor_Code__c = acc.Id;
        rebate1.Rebate_Code__c = '12345';
        insert rebate1;
         Price_Block_Margin_Matrix__c rebate11 = new Price_Block_Margin_Matrix__c();
        rebate11.Rebate_USD__c = 2;
        rebate11.Type__c = 'Rebate';
        rebate11.Profit_Center__c = pc.Id;
        rebate11.UOM__c = 'KG';
        rebate11.Start_Date__c = System.today();
        rebate11.End_Date__c = System.today().addDays(5);
        rebate11.Depot_Code__c = dp.Id;
        rebate11.Sales_Org__c = sorg.Id;
        rebate11.SKU_Code__c = sku1.id;
        rebate11.CurrencyIsoCode = 'USD';
        rebate11.Distributor_Code__c = acc.Id;
        rebate11.Rebate_Code__c = '12345';
        insert rebate11;
        
        Price_Block_Margin_Matrix__c rebate2 = new Price_Block_Margin_Matrix__c();
        rebate2.Rebate_USD__c = 2;
        rebate2.Type__c = 'Rebate';
        rebate2.Profit_Center__c = pc.Id;
        rebate2.UOM__c = 'L';
        rebate2.Start_Date__c = System.today();
        rebate2.End_Date__c = System.today().addDays(5);
        rebate2.Depot_Code__c = dp.Id;
        rebate2.Sales_Org__c = sorg.Id;
        rebate2.SKU_Code__c = sku.id;
        rebate2.CurrencyIsoCode = 'USD';
        rebate2.Distributor_Code__c = acc.Id;
        rebate2.Rebate_Code__c = '12346';
        insert rebate2;
        
         Price_Block_Margin_Matrix__c rebate22 = new Price_Block_Margin_Matrix__c();
        rebate22.Rebate_USD__c = 2;
        rebate22.Type__c = 'Rebate';
        rebate22.Profit_Center__c = pc.Id;
        rebate22.UOM__c = 'KG';
        rebate22.Start_Date__c = System.today();
        rebate22.End_Date__c = System.today().addDays(5);
        rebate22.Depot_Code__c = dp.Id;
        rebate22.Sales_Org__c = sorg.Id;
        rebate22.SKU_Code__c = sku1.id;
        rebate22.CurrencyIsoCode = 'USD';
        rebate22.Distributor_Code__c = acc.Id;
        rebate22.Rebate_Code__c = '12346';
        insert rebate22;
        
        Price_Block_Margin_Matrix__c discount = new Price_Block_Margin_Matrix__c();
        discount.Discount_USD__c = 2;
        discount.Type__c = 'Discount';
        discount.Profit_Center__c = pc.Id;
        discount.UOM__c = 'L';
        discount.Start_Date__c = System.today();
        discount.End_Date__c = System.today().addDays(5);
        discount.Depot_Code__c = dp.Id;
        discount.Sales_Org__c = sorg.Id;
        discount.SKU_Code__c = sku.id;
        discount.CurrencyIsoCode = 'USD';
        discount.Distributor_Code__c = acc.Id;
        insert discount;
        
                Price_Block_Margin_Matrix__c discount1 = new Price_Block_Margin_Matrix__c();
        discount1.Discount_USD__c = 2;
        discount1.Type__c = 'Discount';
        discount1.Profit_Center__c = pc.Id;
        discount1.UOM__c = 'KG';
        discount1.Start_Date__c = System.today();
        discount1.End_Date__c = System.today().addDays(5);
        discount1.Depot_Code__c = dp.Id;
        discount1.Sales_Org__c = sorg.Id;
        discount1.SKU_Code__c = sku1.id;
        discount1.CurrencyIsoCode = 'USD';
        discount1.Distributor_Code__c = acc.Id;
        insert discount1;
        
        Price_Block_Margin_Matrix__c addDiscount = new Price_Block_Margin_Matrix__c();
        addDiscount.Additional_Discount_USD__c = 2;
        addDiscount.Type__c = 'AdditionalDiscount';
        addDiscount.Profit_Center__c = pc.Id;
        addDiscount.UOM__c = 'L';
        addDiscount.Start_Date__c = System.today();
        addDiscount.End_Date__c = System.today().addDays(5);
        addDiscount.Depot_Code__c = dp.Id;
        addDiscount.Sales_Org__c = sorg.Id;
        addDiscount.SKU_Code__c = sku.id;
        addDiscount.CurrencyIsoCode = 'USD';
        addDiscount.Distributor_Code__c = acc.Id;
        insert addDiscount;
        
         Price_Block_Margin_Matrix__c addDiscount1 = new Price_Block_Margin_Matrix__c();
        addDiscount1.Additional_Discount_USD__c = 2;
        addDiscount1.Type__c = 'AdditionalDiscount';
        addDiscount1.Profit_Center__c = pc.Id;
        addDiscount1.UOM__c = 'KG';
        addDiscount1.Start_Date__c = System.today();
        addDiscount1.End_Date__c = System.today().addDays(5);
        addDiscount1.Depot_Code__c = dp.Id;
        addDiscount1.Sales_Org__c = sorg.Id;
        addDiscount1.SKU_Code__c = sku1.id;
        addDiscount1.CurrencyIsoCode = 'USD';
        addDiscount1.Distributor_Code__c = acc.Id;
        insert addDiscount1;
        
        Price_Block_Margin_Matrix__c salesDeduction = new Price_Block_Margin_Matrix__c();
        salesDeduction.Sales_Deduction_USD__c = 2;
        salesDeduction.Sales_Deduction_LC__c=2;
        salesDeduction.Type__c = 'SalesDeduction';
        salesDeduction.Profit_Center__c = pc.Id;
        salesDeduction.UOM__c = 'L';
        salesDeduction.Start_Date__c = System.today();
        salesDeduction.End_Date__c = System.today().addDays(5);
        salesDeduction.Depot_Code__c = dp.Id;
        salesDeduction.Sales_Org__c = sorg.Id;
        salesDeduction.SKU_Code__c = sku.id;
        salesDeduction.Distributor_Code__c = acc.Id;
        salesDeduction.CurrencyIsoCode = 'USD';
        insert salesDeduction;
        
          Price_Block_Margin_Matrix__c salesDeduction1 = new Price_Block_Margin_Matrix__c();
        salesDeduction1.Sales_Deduction_USD__c = 2;
        salesDeduction1.Sales_Deduction_LC__c=2;
        salesDeduction1.Type__c = 'SalesDeduction';
        salesDeduction1.Profit_Center__c = pc.Id;
        salesDeduction1.UOM__c = 'KG';
        salesDeduction1.Start_Date__c = System.today();
        salesDeduction1.End_Date__c = System.today().addDays(5);
        salesDeduction1.Depot_Code__c = dp.Id;
        salesDeduction1.Sales_Org__c = sorg.Id;
        salesDeduction1.SKU_Code__c = sku1.id;
        salesDeduction1.Distributor_Code__c = acc.Id;
        salesDeduction1.CurrencyIsoCode = 'USD';
        insert salesDeduction1;
        
        Price_Block_Margin_Matrix__c pln = new Price_Block_Margin_Matrix__c();
        pln.PLN_USD__c = 2;
        pln.Type__c = 'PLN';
        pln.Profit_Center__c = pc.Id;
        pln.UOM__c = 'L';
        pln.Start_Date__c = System.today();
        pln.End_Date__c = System.today().addDays(5);
        pln.Depot_Code__c = dp.Id;
        pln.Sales_Org__c = sorg.Id;
        pln.SKU_Code__c = sku.id;
        pln.CurrencyIsoCode = 'USD';
        insert pln;
        
          Price_Block_Margin_Matrix__c pln1 = new Price_Block_Margin_Matrix__c();
        pln1.PLN_USD__c = 2;
        pln1.Type__c = 'PLN';
        pln1.Profit_Center__c = pc.Id;
        pln1.UOM__c = 'KG';
        pln1.Start_Date__c = System.today();
        pln1.End_Date__c = System.today().addDays(5);
        pln1.Depot_Code__c = dp.Id;
        pln1.Sales_Org__c = sorg.Id;
        pln1.SKU_Code__c = sku.id;
        pln1.CurrencyIsoCode = 'USD';
        insert pln1;
        
         DistributorSalesAreaMapping__c dsam=new DistributorSalesAreaMapping__c();
        dsam.SalesOrg__c=sorg.Id;
        dsam.Distributor__c=acc.Id;
        dsam.DistributionChannel__c=disbj.Id;
        insert dsam;
        
       /* Attachment oAttachment = new Attachment();
        oAttachment.ParentId='a1E5D000001GjvGUAS';
        oAttachment.Body=EncodingUtil.base64Decode('abcd');
        oAttachment.Name='ChileFile';
		oAttachment.ContentType='UTF-8';       
        insert oAttachment;
        
        List<Id> attId=new List<Id>();
        attId.add(oAttachment.Id);*/
        //CR#169 - Margin Block Approval Process - Chile - kalpesh chande - 10/11/2022 - End Here
    }
    
    static testMethod void method() {
        User sobj1 = [select id from User where Alias = 'zonaa'];
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '5661'];
        Product2 p = [Select id from Product2];
        Account acc = [Select id From Account];
        Order__c ord = [Select id ,Bill_To_Party__c From Order__c];
       List<Sku__c> sku = [Select id,Product_Name__c From SKu__c];
            String skuid=sku[0].id;
        OrderTemplate__c ordTemp = [Select id From OrderTemplate__c];
        Payment_Method__c payment_method =[Select id From Payment_Method__c];
        Payment_Term__c payment_term =[Select id From Payment_Term__c ];
        Inco_Term__c Inco_terms=[Select id From Inco_Term__c];
        Order_Type__c ordType=[SELECT Id FROM Order_Type__c WHERE SalesOrg__r.Sales_Org_Code__c = '5661'];
        Order_Type__c ordType1=[SELECT Id FROM Order_Type__c WHERE SalesOrg__r.Sales_Org_Code__c = '5662'];
        //OrderChileController ordmanage = new OrderChileController();
        System.runAs(sobj1){
            
            
            
            
            

            List<id> soList=new List<id>();
            Sales_Order__c so = new Sales_Order__c();
            so.Sold_to_Party__c = acc.id;
            so.Payment_Term__c = payment_term.id;
            so.Purchase_Order_Date__c = System.today();
            so.CurrencyIsoCode = 'USD';
            so.Gross_Margin__c=10;
            so.Business_Discount__c=5;
            so.Order_Type_lk__c=ordType.Id;
          //  so.Order__c=ord.Id;
           
            so.Total_Amount__c=100;
            
            insert so;
            soList.add(so.id);
            Sales_Order_Line_Item__c soli=new Sales_Order_Line_Item__c();
            soli.Sale_Order__c=so.id;
            soli.Item_Number__c=10;
            soli.CurrencyIsoCode='USD';
            soli.Profit_colombia__c=50;
            soli.Unit_PriceBook_Discount__c=30;
            soli.Price__c=200;
            
            insert soli;
            System.debug('soliId---->'+soli.id);
            
            Sales_Order__c so1 = new Sales_Order__c();
            so1.Sold_to_Party__c = acc.id;
            so1.Payment_Term__c = payment_term.id;
            so1.Purchase_Order_Date__c = System.today();
            so1.CurrencyIsoCode = 'CLP';
            so1.Gross_Margin__c=10;
            so1.Business_Discount__c=5;
            so1.Total_Amount__c=100;
             so1.Order_Type_lk__c=ordType1.Id;
            insert so1;
            so1.CurrencyIsoCode='USD';
            soList.add(so1.id);
            Sales_Order_Line_Item__c soli1=new Sales_Order_Line_Item__c();
            soli1.Sale_Order__c=so1.id;
            soli1.Item_Number__c=10;
            soli1.CurrencyIsoCode='USD';
            soli1.MaxPrice__c=40;
            soli1.Quantity__c=5;
            soli1.Profit_colombia__c=50;
            soli1.Unit_PriceBook_Discount__c=30;
            soli1.Price__c=200;
            insert soli1;
            String SolinId=(String)soli.id;    
            
            Order__c ordNull = ord.clone(false,true,true,false);
            insert ordNull;
            //OrderChileController.ordObj = null;
            //SoChileEditController.deleteOrderItem(10,acc.id);
            //SoChileEditController.deleteSaleOrdeLineItem(SolinId,so1);
            SoChileEditController.createOrder(acc.id,so,sorg.Id);
            //SoChileEditController.deleteAllOrderItem(acc.id,so);
            SoChileEditController.ordObj = ord;
            SoChileEditController.findByName('SAP');
            SoChileEditController.fetchCustomer();
            String salesOrderItemString = '[{"cultureDesc":"","days":0,"deliveryAddress":"Pune - null","deliveryDate":"2021-01-22","discount":0,"discount_percent":0,"interestRate":0,"isMO":false,"itemNo":10,"margin":0,"maxPrice":5130,"moItemNo":0,"netMargin":0,"netPrice":0,"netSales":7,"oiCurrency":"USD","orderItemId":"'+ord.Id+'","priceBookDetailId":"","productCode":"","productId":"'+skuid+'","productName":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","profit":50000,"qty":10,"totalValue":0,"totalValueWithInterest":0,"unitCost":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"L","SOLIID":"'+soli.id+'"}]';
            String salesOrderItemString1 = '{"balanceQty":0,"deliveryAddress":"Pune - null","balanceQty2":0,"cultureDesc":"","days":0,"interestRate":0,"isMO":false,"isValid":false,"itemNo":10,"maxPrice":7.2,"monthlyInterestRate":0,"orderItemId":"","percUsed":100,"pricebookId":"a181m0000002j7xAAA","qty":10,"regState":"","skuCode":"000000000006685080","skuDescription":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","skuId":"'+skuid+'","totalValue":0,"totalValueWithInterest":0,"unitCost":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"L","SOLIID":"'+soli1.id+'"}';
            //String priceDetailString='[{"additionalDiscountPercent":0,"additionalDiscountUOM":"L","additionalDiscountUOMConver":0,"additionalDiscountUSD":0,"balanceQty":0,"balanceQty2":0,"baseUOM":"L","convertFinalPrice":0,"convertNetPrice":0,"convertQty":0,"cultureDesc":"","days":0,"discountPercent":0,"discountUOM":"L","discountUOMConver":0,"discountUSD":0,"e2EBaseUOM":"L","e2ECostMBEWUSD":0,"e2ECostUPC9USD":0,"e2ECostUSD":10,"e2ESalesUOM":"L","e2EUOM":"L","e2EUOMValueCon":0,"interestRate":0,"isMO":false,"isValid":false,"itemNo":0,"maxPrice":11,"minValue":7,"monthlyInterestRate":0,"orderItemId":"","percUsed":100,"plnUOM":"","plnUOMConver":0,"pLNUSD":0,"pricebookId":"","profitCenter":"","qty":0,"rebate1Percent":0,"rebate1UOM":"L","rebate1USD":0,"rebate2Percent":0,"rebate2UOM":"L","rebate2USD":0,"rebateCode1":"","rebateCode2":"","rebateUOMConver1":0,"rebateUOMConver2":0,"regState":"","salesDeductionDUOMValueCon":0,"salesDeductionInPercent":0,"salesDeductionUOM":"L","salesDeductionUSD":0,"skuCode":"000000000000933043","skuDescription":"DEVRINOL 4 X 5 LT (NUFARM) (CL)","skuId":"'+sku.id+'","totalValue":0,"totalValueWithInterest":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"L","uomAddDiscount":"L","uomDiscount":"","uome2eCost":"L","uomPLN":"L","uomRebate1":"L","uomRebate2":"L","uomSalesDeduction":"L"}]';   
             String salesOrderItemString2 = '[{"balanceQty":0,"deliveryAddress":"Pune - null","balanceQty2":0,"cultureDesc":"","days":0,"interestRate":0,"isMO":false,"isValid":false,"itemNo":0,"maxPrice":7.2,"monthlyInterestRate":0,"orderItemId":"","percUsed":100,"pricebookId":"a181m0000002j7xAAA","oiCurrency":"USD","qty":0,"regState":"","skuCode":"000000000006685080","skuDescription":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","skuId":"'+skuid+'","totalValue":0,"totalValueWithInterest":0,"unitCost":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"L","SOLIID":"'+soli.id+'"}]';
            String salesOrderItemString3 = '[{"cultureDesc":"","days":0,"deliveryAddress":"Pune - null","deliveryDate":"2021-01-22","discount":0,"discount_percent":0,"interestRate":0,"isMO":false,"itemNo":0,"margin":0,"maxPrice":5130,"moItemNo":0,"netMargin":0,"netPrice":0,"netSales":7,"oiCurrency":"USD","orderItemId":"","priceBookDetailId":"","productCode":"","productId":"'+skuid+'","productName":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","profit":50000,"qty":10,"totalValue":0,"totalValueWithInterest":0,"unitCost":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"L"}]';
            String salesOrderItem = '[{"cultureDesc":"","days":0,"deliveryAddress":"Pune - null","deliveryDate":"2021-01-22","discount":0,"discount_percent":0,"interestRate":0,"isMO":false,"itemNo":0,"margin":0,"maxPrice":5130,"moItemNo":0,"netMargin":0,"netPrice":0,"netSales":7,"oiCurrency":"USD","orderItemId":"","priceBookDetailId":"","productCode":"","productId":"'+skuid+'","productName":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","profit":50000,"qty":10,"totalValue":0,"totalValueWithInterest":0,"unitCost":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"KG"}]';
            String priceDetailString='[{"additionalDiscountPercent":0,"additionalDiscountUOM":"L","additionalDiscountUOMConver":0,"additionalDiscountUSD":0,"balanceQty":0,"balanceQty2":0,"baseUOM":"L","convertFinalPrice":0,"convertNetPrice":0,"convertQty":0,"cultureDesc":"","days":0,"discountPercent":0,"discountUOM":"L","discountUOMConver":0,"discountUSD":0,"e2EBaseUOM":"L","e2ECostMBEWUSD":0,"e2ECostUPC9USD":0,"e2ECostUSD":10,"e2ESalesUOM":"L","e2EUOM":"L","e2EUOMValueCon":0,"interestRate":0,"isMO":false,"isValid":false,"itemNo":0,"maxPrice":11,"minValue":7,"monthlyInterestRate":0,"orderItemId":"","percUsed":100,"plnUOM":"","plnUOMConver":0,"pLNUSD":0,"pricebookId":"","profitCenter":"","qty":0,"rebate1Percent":0,"rebate1UOM":"L","rebate1USD":0,"rebate2Percent":0,"rebate2UOM":"L","rebate2USD":0,"rebateCode1":"","rebateCode2":"","rebateUOMConver1":0,"rebateUOMConver2":0,"regState":"","salesDeductionDUOMValueCon":0,"salesDeductionInPercent":0,"salesDeductionUOM":"L","salesDeductionUSD":0,"skuCode":"000000000000933043","skuDescription":"DEVRINOL 4 X 5 LT (NUFARM) (CL)","skuId":"'+skuid+'","totalValue":0,"totalValueWithInterest":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"L","uomAddDiscount":"L","uomDiscount":"","uome2eCost":"L","uomPLN":"L","uomRebate1":"L","uomRebate2":"L","uomSalesDeduction":"L"}]';   
            String priceDetailString1='[{"additionalDiscountPercent":0,"additionalDiscountUOM":"L","additionalDiscountUOMConver":0,"additionalDiscountUSD":0,"balanceQty":0,"balanceQty2":0,"baseUOM":"L","convertFinalPrice":0,"convertNetPrice":0,"convertQty":0,"cultureDesc":"","days":0,"discountPercent":0,"discountUOM":"L","discountUOMConver":0,"discountUSD":0,"e2EBaseUOM":"L","e2ECostMBEWUSD":0,"e2ECostUPC9USD":0,"e2ECostUSD":10,"e2ESalesUOM":"L","e2EUOM":"LB","e2EUOMValueCon":0,"interestRate":0,"isMO":false,"isValid":false,"itemNo":0,"maxPrice":11,"minValue":7,"monthlyInterestRate":0,"orderItemId":"","percUsed":100,"plnUOM":"","plnUOMConver":0,"pLNUSD":null,"pricebookId":"","profitCenter":"","qty":0,"rebate1Percent":0,"rebate1UOM":"LB","rebate1USD":0,"rebate2Percent":0,"rebate2UOM":"LB","rebate2USD":0,"rebateCode1":"","rebateCode2":"","rebateUOMConver1":0,"rebateUOMConver2":0,"regState":"","salesDeductionDUOMValueCon":0,"salesDeductionInPercent":0,"salesDeductionUOM":"LB","salesDeductionUSD":0,"skuCode":"000000000000933043","skuDescription":"DEVRINOL 4 X 5 LT (NUFARM) (CL)","skuId":"'+skuid+'","totalValue":0,"totalValueWithInterest":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"LB","uomAddDiscount":"LB","uomDiscount":"","uome2eCost":"LB","uomPLN":"LB","uomRebate1":"L","uomRebate2":"LB","uomSalesDeduction":"LB"}]';   
            String salesOrderItemString6 = '[{"cultureDesc":"","days":0,"deliveryAddress":"Pune - null","deliveryDate":"2021-01-22","discount":0,"discount_percent":0,"interestRate":0,"isMO":false,"itemNo":0,"margin":0,"maxPrice":5130,"moItemNo":0,"netMargin":0,"netPrice":0,"netSales":7,"oiCurrency":"CLP","orderItemId":"","priceBookDetailId":"","productCode":"","productId":"'+skuid+'","productName":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","profit":50000,"qty":10,"totalValue":0,"totalValueWithInterest":0,"unitCost":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"L"}]';
            so.Order__c=ord.Id;
            so1.CurrencyIsoCode='CLP'; 
            SOChileEditController.updateSalesOrderLineItem(salesOrderItemString1,so,acc.id);//facing issue in callig
           // SoChileEditController.saveSalesOrderLineItem(so1,priceDetailString1,salesOrderItemString3,false,sorg.Id,true);
            so.CurrencyIsoCode='CLP'; 
           // SOChileEditController.updateSalesOrderLineItem(salesOrderItemString1,so,acc.id);//facing issue in callig
            SoChileEditController.deleteSavedAttach(soList);
 SoChileEditController.checkUom(skuId);
                          SoChileEditController.saveSalesOrderLineItem(so,priceDetailString1,salesOrderItemString3,false,sorg.Id,true);

                         // SoChileEditController.saveSalesOrderLineItem(so,priceDetailString,salesOrderItemString,false,sorg.Id,true);
                         // SoChileEditController.saveSalesOrderLineItem(so,priceDetailString,salesOrderItemString3,false,sorg.Id,true);
             Test.startTest();
              SoChileEditController.editOrder(so);
            SoChileEditController.getSkuData(acc.id,so1);
            //SoChileEditController.createSalesOrder(so,'Pune - null',ordType.Id,sorg.Id,false);
          //   SoChileEditController.saveSalesOrderLineItem(so,salesOrderItemString,false,sorg.Id,true);
           // so1.CurrencyIsoCode='CLP';
           // SoChileEditController.saveSalesOrderLineItem(so,priceDetailString,salesOrderItemString,false,sorg.Id,true);
            so.CurrencyIsoCode='USD';
           //  SoChileEditController.saveSalesOrderLineItem(so,priceDetailString,salesOrderItemString,false,sorg.Id,true);
            so.CurrencyIsoCode='USD';
           //  so1.CurrencyIsoCode='USD';
           //  SoChileEditController.saveSalesOrderLineItem(so,priceDetailString,salesOrderItemString3,false,sorg.Id,true);
                       SoChileEditController.checkSimulation(priceDetailString, so, salesOrderItemString3, false, sorg.Id, true, true);
            SoChileEditController.ordObj = ordNull;
                SoChileEditController.saveSalesOrderLineItem(so,priceDetailString,salesOrderItemString3,false,sorg.Id,true);
            SoChileEditController.getSkuData(acc.id,so);
            SOChileEditController.getShippingLoationsforSalesOrder(so1.id);

            SoChileEditController.fetchDistributorDetails(acc.id);
           SoChileEditController.getExchangeRate(System.today());
           SoChileEditController.fetchPaymentTermDetails();
           SoChileEditController.fetchincoTermDetails();
            SoChileEditController.getOrderFields(so.id);
            SoChileEditController.getSalesOrder(soList);
            SoChileEditController.updateAllOrderItems(salesOrderItemString3,acc.id,so,sorg.Id);
            SoChileEditController.deleteSaleOrdeLineItem(soli.id,so);
        
            List<id> soId = new List<id>();
            //SoChileEditController.saveChunk(soId,'fileName','gdsytrsrthj','bdftytrdcu',soId);
           // SoChileEditController.getSalesOrderItems(soList);
           // so1.CurrencyIsoCode='CLP';
               // SoChileEditController.saveSalesOrderLineItem(so,priceDetailString,salesOrderItemString,false,sorg.Id,true);

           
           //  SoChileEditController.saveSalesOrderLineItem(so,priceDetailString,salesOrderItemString2,false,sorg.Id,true);
         //   SoChileEditController.updateOrderItem(salesOrderItemString1, acc.id, so, sorg.id);
           // SoChileEditController.saveSalesOrder(priceDetailString,so,salesOrderItemString,false,sorg.Id,true,false);
            Test.stopTest();
          
           
        }
    }
   static testMethod void method1() {
        User sobj1 = [select id from User where Alias = 'zonaa'];
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '5661'];
        Product2 p = [Select id from Product2];
        Account acc = [Select id From Account];
        Order__c ord = [Select id ,Bill_To_Party__c From Order__c];
         List<Sku__c> sku = [Select id,Product_Name__c From SKu__c];
            String skuid=sku[0].id;
       OrderTemplate__c ordTemp = [Select id From OrderTemplate__c];
        Payment_Method__c payment_method =[Select id From Payment_Method__c];
        Payment_Term__c payment_term =[Select id From Payment_Term__c ];
        Inco_Term__c Inco_terms=[Select id From Inco_Term__c];
        Order_Type__c ordType=[SELECT Id FROM Order_Type__c WHERE SalesOrg__r.Sales_Org_Code__c = '5661'];
        //OrderChileController ordmanage = new OrderChileController();
        System.runAs(sobj1){
            
            
            
            
            

            List<id> soList=new List<id>();
            Sales_Order__c so = new Sales_Order__c();
            so.Sold_to_Party__c = acc.id;
            so.Payment_Term__c = payment_term.id;
            so.Purchase_Order_Date__c = System.today();
            so.CurrencyIsoCode = 'CLP';
            so.Gross_Margin__c=10;
            so.Business_Discount__c=5;
           
            so.Total_Amount__c=100;
             so.Order_Type_lk__c=ordType.Id;
            insert so;
            soList.add(so.id);
            Sales_Order_Line_Item__c soli=new Sales_Order_Line_Item__c();
            soli.Sale_Order__c=so.id;
            soli.Item_Number__c=30;
            soli.CurrencyIsoCode='USD';
            soli.Profit_colombia__c=50;
            soli.Unit_PriceBook_Discount__c=30;
            soli.Price__c=200;
            
            insert soli;
            System.debug('soliId---->'+soli.id);
            
            Sales_Order__c so1 = new Sales_Order__c();
            so1.Sold_to_Party__c = acc.id;
            so1.Payment_Term__c = payment_term.id;
            so1.Purchase_Order_Date__c = System.today();
            so1.CurrencyIsoCode = 'CLP';
            so1.Gross_Margin__c=10;
            so1.Business_Discount__c=5;
            so1.Total_Amount__c=100;
            insert so1;
            so1.CurrencyIsoCode='CLP';
            soList.add(so1.id);
            Sales_Order_Line_Item__c soli1=new Sales_Order_Line_Item__c();
            soli1.Sale_Order__c=so1.id;
            soli1.Item_Number__c=10;
            soli1.CurrencyIsoCode='CLP';
            soli1.MaxPrice__c=40;
            soli1.Quantity__c=5;
            soli1.Profit_colombia__c=50;
            soli1.Unit_PriceBook_Discount__c=30;
            soli1.Price__c=200;
            insert soli1;
            String SolinId=(String)soli.id;
            String accids=(String)acc.id;
            
             String SerilaizedString = JSON.serialize(soli);
            system.debug('SerilaizedString :'+SerilaizedString);
            Order__c ordNull = ord.clone(false,true,true,false);
            insert ordNull;
            //OrderChileController.ordObj = null;
            SoChileEditController.deleteOrderItem(10,acc.id);
            SoChileEditController.deleteSaleOrdeLineItem(SolinId,so1);
            SoChileEditController.createOrder(acc.id,so,sorg.Id);
            SoChileEditController.createOrder(acc.id,so1,sorg.Id);
            SoChileEditController.deleteAllOrderItem(acc.id,so);
            SoChileEditController.ordObj = ord;
            SoChileEditController.findByName('SAP');
            SoChileEditController.fetchCustomer();
            SoChileEditController.getShippingLoations(acc.id);
            String salesOrderItemString = '[{"cultureDesc":"","days":0,"deliveryAddress":"Pune - null","deliveryDate":"2021-01-22","discount":0,"discount_percent":0,"interestRate":0,"isMO":false,"itemNo":0,"margin":0,"maxPrice":5130,"moItemNo":0,"netMargin":0,"netPrice":0,"netSales":7,"oiCurrency":"CLP","orderItemId":"","priceBookDetailId":"","productCode":"","productId":"'+skuid+'","productName":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","profit":50000,"qty":10,"totalValue":0,"totalValueWithInterest":0,"unitValue":10,"unitCost":0,"unitValueWithInterest":0,"UOM":"L","SOLIID":"'+soli1.id+'"}]';
            String salesOrderItemString4 = '[{"cultureDesc":"","days":0,"deliveryAddress":"Pune - null","deliveryDate":"2021-01-22","discount":0,"discount_percent":0,"interestRate":0,"isMO":false,"itemNo":0,"margin":0,"maxPrice":5130,"moItemNo":0,"netMargin":0,"netPrice":0,"netSales":7,"oiCurrency":"USD","orderItemId":"","priceBookDetailId":"","productCode":"","productId":"'+skuid+'","productName":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","profit":50000,"qty":10,"totalValue":0,"totalValueWithInterest":0,"unitValue":10,"unitCost":0,"unitValueWithInterest":0,"UOM":"L","SOLIID":"'+soli1.id+'"}]';
            String salesOrderItemString1 = '{"balanceQty":0,"deliveryAddress":"Pune - null","balanceQty2":0,"cultureDesc":"","days":0,"interestRate":0,"isMO":false,"isValid":false,"itemNo":10,"maxPrice":7.2,"monthlyInterestRate":0,"orderItemId":"","percUsed":100,"pricebookId":"a181m0000002j7xAAA","qty":10,"regState":"","skuCode":"000000000006685080","skuDescription":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","skuId":"'+skuid+'","totalValue":0,"totalValueWithInterest":0,"unitCost":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"L","SOLIID":"'+soli1.id+'"}';
            //String priceDetailString='[{"additionalDiscountPercent":0,"additionalDiscountUOM":"L","additionalDiscountUOMConver":0,"additionalDiscountUSD":0,"balanceQty":0,"balanceQty2":0,"baseUOM":"L","convertFinalPrice":0,"convertNetPrice":0,"convertQty":0,"cultureDesc":"","days":0,"discountPercent":0,"discountUOM":"L","discountUOMConver":0,"discountUSD":0,"e2EBaseUOM":"L","e2ECostMBEWUSD":0,"e2ECostUPC9USD":0,"e2ECostUSD":10,"e2ESalesUOM":"L","e2EUOM":"L","e2EUOMValueCon":0,"interestRate":0,"isMO":false,"isValid":false,"itemNo":0,"maxPrice":11,"minValue":7,"monthlyInterestRate":0,"orderItemId":"","percUsed":100,"plnUOM":"","plnUOMConver":0,"pLNUSD":0,"pricebookId":"","profitCenter":"","qty":0,"rebate1Percent":0,"rebate1UOM":"L","rebate1USD":0,"rebate2Percent":0,"rebate2UOM":"L","rebate2USD":0,"rebateCode1":"","rebateCode2":"","rebateUOMConver1":0,"rebateUOMConver2":0,"regState":"","salesDeductionDUOMValueCon":0,"salesDeductionInPercent":0,"salesDeductionUOM":"L","salesDeductionUSD":0,"skuCode":"000000000000933043","skuDescription":"DEVRINOL 4 X 5 LT (NUFARM) (CL)","skuId":"'+sku.id+'","totalValue":0,"totalValueWithInterest":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"L","uomAddDiscount":"L","uomDiscount":"","uome2eCost":"L","uomPLN":"L","uomRebate1":"L","uomRebate2":"L","uomSalesDeduction":"L"}]';   
             String salesOrderItemString2 = '[{"balanceQty":0,"deliveryAddress":"Pune - null","balanceQty2":0,"cultureDesc":"","days":0,"interestRate":0,"isMO":false,"isValid":false,"itemNo":0,"maxPrice":7.2,"monthlyInterestRate":0,"orderItemId":"","percUsed":100,"pricebookId":"a181m0000002j7xAAA","oiCurrency":"CLP","qty":0,"regState":"","skuCode":"000000000006685080","skuDescription":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","skuId":"'+skuid+'","totalValue":0,"totalValueWithInterest":0,"unitCost":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"L","SOLIID":"'+soli.id+'"}]';
            String salesOrderItemString3 = '[{"cultureDesc":"","days":0,"deliveryAddress":"Pune - null","deliveryDate":"2021-01-22","discount":0,"discount_percent":0,"interestRate":0,"isMO":false,"itemNo":0,"margin":0,"maxPrice":5130,"moItemNo":0,"netMargin":0,"netPrice":0,"netSales":7,"oiCurrency":"USD","orderItemId":"","priceBookDetailId":"","productCode":"","productId":"'+skuid+'","productName":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","profit":50000,"qty":10,"totalValue":0,"totalValueWithInterest":0,"unitCost":0,"unitValueWithInterest":0,"UOM":"L"}]';
            String priceDetailString='[{"additionalDiscountPercent":0,"additionalDiscountUOM":"L","additionalDiscountUOMConver":0,"additionalDiscountUSD":0,"balanceQty":0,"balanceQty2":0,"baseUOM":"L","convertFinalPrice":0,"convertNetPrice":0,"convertQty":0,"cultureDesc":"","days":0,"discountPercent":0,"discountUOM":"L","discountUOMConver":0,"discountUSD":0,"e2EBaseUOM":"L","e2ECostMBEWUSD":0,"e2ECostUPC9USD":0,"e2ECostUSD":10,"e2ESalesUOM":"L","e2EUOM":"L","e2EUOMValueCon":0,"interestRate":0,"isMO":false,"isValid":false,"itemNo":0,"maxPrice":11,"minValue":7,"monthlyInterestRate":0,"orderItemId":"","percUsed":100,"plnUOM":"","plnUOMConver":0,"pLNUSD":0,"pricebookId":"","profitCenter":"","qty":0,"rebate1Percent":0,"rebate1UOM":"L","rebate1USD":0,"rebate2Percent":0,"rebate2UOM":"L","rebate2USD":0,"rebateCode1":"","rebateCode2":"","rebateUOMConver1":0,"rebateUOMConver2":0,"regState":"","salesDeductionDUOMValueCon":0,"salesDeductionInPercent":0,"salesDeductionUOM":"L","salesDeductionUSD":0,"skuCode":"000000000000933043","skuDescription":"DEVRINOL 4 X 5 LT (NUFARM) (CL)","skuId":"'+skuid+'","totalValue":0,"totalValueWithInterest":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"L","uomAddDiscount":"L","uomDiscount":"","uome2eCost":"L","uomPLN":"L","uomRebate1":"L","uomRebate2":"L","uomSalesDeduction":"L"}]';   
            String salesOrderItem = '[{"cultureDesc":"","days":0,"deliveryAddress":"Pune - null","deliveryDate":"2021-01-22","discount":0,"discount_percent":0,"interestRate":0,"isMO":false,"itemNo":0,"margin":0,"maxPrice":5130,"moItemNo":0,"netMargin":0,"netPrice":0,"netSales":7,"oiCurrency":"USD","orderItemId":"","priceBookDetailId":"","productCode":"","productId":"'+skuid+'","productName":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","profit":50000,"qty":10,"totalValue":0,"totalValueWithInterest":0,"unitCost":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"KG"}]';
            String priceDetailString1='[{"additionalDiscountPercent":0,"additionalDiscountUOM":"KG","additionalDiscountUOMConver":0,"additionalDiscountUSD":0,"balanceQty":0,"balanceQty2":0,"baseUOM":"KG","convertFinalPrice":0,"convertNetPrice":0,"convertQty":0,"cultureDesc":"","days":0,"discountPercent":0,"discountUOM":"KG","discountUOMConver":0,"discountUSD":0,"e2EBaseUOM":"KG","e2ECostMBEWUSD":0,"e2ECostUPC9USD":0,"e2ECostUSD":10,"e2ESalesUOM":"KG","e2EUOM":"KG","e2EUOMValueCon":0,"interestRate":0,"isMO":false,"isValid":false,"itemNo":0,"maxPrice":11,"minValue":7,"monthlyInterestRate":0,"orderItemId":"","percUsed":100,"plnUOM":"","plnUOMConver":0,"pLNUSD":0,"pricebookId":"","profitCenter":"","qty":0,"rebate1Percent":0,"rebate1UOM":"KG","rebate1USD":0,"rebate2Percent":0,"rebate2UOM":"KG","rebate2USD":0,"rebateCode1":"","rebateCode2":"","rebateUOMConver1":0,"rebateUOMConver2":0,"regState":"","salesDeductionDUOMValueCon":0,"salesDeductionInPercent":0,"salesDeductionUOM":KG","salesDeductionUSD":0,"skuCode":"000000000000933043","skuDescription":"DEVRINOL 4 X 5 LT (NUFARM) (CL)","skuId":"'+skuid+'","totalValue":0,"totalValueWithInterest":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"KG","uomAddDiscount":"KG","uomDiscount":"","uome2eCost":"KG","uomPLN":"KG","uomRebate1":"L","uomRebate2":"KG","uomSalesDeduction":"KG"}]';   
            String priceDetailString2='[{"additionalDiscountPercent":0,"additionalDiscountUOM":"KG","additionalDiscountUOMConver":0,"additionalDiscountUSD":0,"balanceQty":0,"balanceQty2":0,"baseUOM":"KG","convertFinalPrice":0,"convertNetPrice":0,"convertQty":0,"cultureDesc":"","days":0,"discountPercent":0,"discountUOM":"KG","discountUOMConver":0,"discountUSD":0,"e2EBaseUOM":"KG","e2ECostMBEWUSD":0,"e2ECostUPC9USD":0,"e2ECostUSD":0,"e2ESalesUOM":"KG","e2EUOM":"KG","e2EUOMValueCon":0,"interestRate":0,"isMO":false,"isValid":false,"itemNo":0,"maxPrice":11,"minValue":7,"monthlyInterestRate":0,"orderItemId":"","percUsed":100,"plnUOM":"","plnUOMConver":0,"pLNUSD":0,"pricebookId":"","profitCenter":"","qty":0,"rebate1Percent":0,"rebate1UOM":"KG","rebate1USD":0,"rebate2Percent":0,"rebate2UOM":"KG","rebate2USD":0,"rebateCode1":"","rebateCode2":"","rebateUOMConver1":0,"rebateUOMConver2":0,"regState":"","salesDeductionDUOMValueCon":0,"salesDeductionInPercent":0,"salesDeductionUOM":"KG","salesDeductionUSD":0,"skuCode":"000000000000933043","skuDescription":"DEVRINOL 4 X 5 LT (NUFARM) (CL)","skuId":"'+skuid+'","totalValue":0,"totalValueWithInterest":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"KG","uomAddDiscount":"KG","uomDiscount":"","uome2eCost":"KG","uomPLN":"LB","uomRebate1":"KG","uomRebate2":"KG","uomSalesDeduction":"KG"}]';   
           // SoChileEditController.updateAllOrderItems(salesOrderItemString,acc.id,so,sorg.Id);
           //  SoChileEditController.saveSalesOrderLineItem(so,priceDetailString,salesOrderItem,false,sorg.Id,true);
            // SoChileEditController.saveSalesOrderLineItem(so,priceDetailString,salesOrderItemString3,false,sorg.Id,true);
            Test.startTest();
            so1.CurrencyIsoCode='CLP'; 
            SoChileEditController.saveSalesOrderLineItem(so1,priceDetailString2,salesOrderItemString,false,sorg.Id,true);
		    SoChileEditController.getSalesOrderItems(soList);
            SoChileEditController.getExchangeRate(System.today());
            SoChileEditController.getOrderFields(so1.id);
            SoChileEditController.getSalesOrder(soList);
            SoChileEditController.checkSimulation(priceDetailString, so, salesOrderItemString, false, sorg.Id, true, true);
              SoChileEditController.editOrder(so);
                SoChileEditController.saveSalesOrderLineItem(so,priceDetailString,salesOrderItemString,false,sorg.Id,true);
               so1.CurrencyIsoCode='USD';   
            SoChileEditController.saveSalesOrderLineItem(so,priceDetailString1,salesOrderItem,false,sorg.Id,true);
          //  SoChileEditController.createSalesOrder(so,'Pune - null',ordType.Id,sorg.Id,false);
          //   SoChileEditController.saveSalesOrderLineItem(so,salesOrderItemString,false,sorg.Id,true);
           // so1.CurrencyIsoCode='CLP';
           // SoChileEditController.saveSalesOrderLineItem(so,priceDetailString,salesOrderItemString,false,sorg.Id,true);
            so.CurrencyIsoCode='CLP';
           //  SoChileEditController.saveSalesOrderLineItem(so,priceDetailString,salesOrderItemString,false,sorg.Id,true);
            so.CurrencyIsoCode='CLP';
           //  so1.CurrencyIsoCode='USD';
           //  SoChileEditController.saveSalesOrderLineItem(so,priceDetailString,salesOrderItemString3,false,sorg.Id,true);
          //  SOChileEditController.updateSalesOrderLineItem(salesOrderItemString1,so,acc.id);//facing issue in callig
            SoChileEditController.ordObj = ordNull;
         
            //SoChileEditController.getSkuData(acc.id,so1);
          //  SOChileEditController.getShippingLoationsforSalesOrder(acc.id);

          // SoChileEditController.fetchDistributorDetails(acc.id);
          
           // SoChileEditController.fetchPaymentTermDetails();
           // SoChileEditController.fetchincoTermDetails();
           
          //  SoChileEditController.deleteSaleOrdeLineItem(soli.id,so);
            List<id> soId = new List<id>();
            SoChileEditController.saveChunk(soId,'fileName','gdsytrsrthj','bdftytrdcu',soId);
          
            so.CurrencyIsoCode='CLP';
 		//	SoChileEditController.checkUom(sku.Id);
              //  SoChileEditController.saveSalesOrderLineItem(so,priceDetailString,salesOrderItemString,false,sorg.Id,true);
            
           
           //  SoChileEditController.saveSalesOrderLineItem(so,priceDetailString,salesOrderItemString2,false,sorg.Id,true);
           // SoChileEditController.deleteSavedAttach(soList);
         //   SoChileEditController.updateOrderItem(salesOrderItemString1, acc.id, so, sorg.id);
           // SoChileEditController.saveSalesOrder(priceDetailString,so,salesOrderItemString,false,sorg.Id,true,false);
            Test.stopTest();
            
        }
           
        }
        static testMethod void method2() {
        User sobj1 = [select id from User where Alias = 'zonaa'];
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '5661'];
        Product2 p = [Select id from Product2];
        Account acc = [Select id From Account];
        Order__c ord = [Select id ,Bill_To_Party__c From Order__c];
        List<Sku__c> sku = [Select id,Product_Name__c From SKu__c];
            String skuid=sku[0].id;
            String skuid2=sku[1].id;
      //  Sku__c sku1 = [Select id,Product_Name__c From SKu__c];
        OrderTemplate__c ordTemp = [Select id From OrderTemplate__c];
        Payment_Method__c payment_method =[Select id From Payment_Method__c];
        Payment_Term__c payment_term =[Select id From Payment_Term__c ];
        Inco_Term__c Inco_terms=[Select id From Inco_Term__c];
        Order_Type__c ordType=[SELECT Id FROM Order_Type__c WHERE SalesOrg__r.Sales_Org_Code__c = '5661'];
        //OrderChileController ordmanage = new OrderChileController();
        System.runAs(sobj1){
            
            
            
            
            

            List<id> soList=new List<id>();
            Sales_Order__c so = new Sales_Order__c();
            so.Sold_to_Party__c = acc.id;
            so.Payment_Term__c = payment_term.id;
            so.Purchase_Order_Date__c = System.today();
            so.CurrencyIsoCode = 'USD';
            so.Gross_Margin__c=10;
            so.Business_Discount__c=5;
           
            so.Total_Amount__c=100;
            so.Order_Type_lk__c=ordType.Id;
            insert so;
            soList.add(so.id);
            Sales_Order_Line_Item__c soli=new Sales_Order_Line_Item__c();
            soli.Sale_Order__c=so.id;
            soli.Item_Number__c=10;
            soli.CurrencyIsoCode='USD';
            soli.Profit_colombia__c=50;
            soli.Unit_PriceBook_Discount__c=30;
            soli.Price__c=200;
            soli.MaxPrice__c=40;
             soli.MinPrice__c=10;
            insert soli;
            System.debug('soliId---->'+soli.id);
            
            Sales_Order__c so1 = new Sales_Order__c();
            so1.Sold_to_Party__c = acc.id;
            so1.Payment_Term__c = payment_term.id;
            so1.Purchase_Order_Date__c = System.today();
            so1.CurrencyIsoCode = 'CLP';
            so1.Gross_Margin__c=10;
            so1.Business_Discount__c=5;
            so1.Total_Amount__c=100;
            insert so1;
            so1.CurrencyIsoCode='CLP';
            soList.add(so1.id);
            Sales_Order_Line_Item__c soli1=new Sales_Order_Line_Item__c();
            soli1.Sale_Order__c=so1.id;
            soli1.Item_Number__c=10;
            soli1.CurrencyIsoCode='USD';
            soli1.MaxPrice__c=40;
            soli1.MinPrice__c=10;
            soli1.Quantity__c=5;
            soli1.Profit_colombia__c=50;
            soli1.Unit_PriceBook_Discount__c=30;
            soli1.Price__c=200;
            insert soli1;
            String SolinId=(String)soli.id;
            String accids=(String)acc.id;
            
             String SerilaizedString = JSON.serialize(soli);
            system.debug('SerilaizedString :'+SerilaizedString);
            Order__c ordNull = ord.clone(false,true,true,false);
            insert ordNull;
            //OrderChileController.ordObj = null;
            SoChileEditController.deleteOrderItem(10,acc.id);
            SoChileEditController.deleteSaleOrdeLineItem(SolinId,so1);
            SoChileEditController.createOrder(acc.id,so,sorg.Id);
            SoChileEditController.createOrder(acc.id,so1,sorg.Id);
            SoChileEditController.deleteAllOrderItem(acc.id,so);
            SoChileEditController.ordObj = ord;
            SoChileEditController.findByName('SAP');
            SoChileEditController.fetchCustomer();
            String salesOrderItemString = '[{"cultureDesc":"","days":0,"deliveryAddress":"Pune - null","deliveryDate":"2021-01-22","discount":0,"discount_percent":0,"interestRate":0,"isMO":false,"itemNo":0,"margin":0,"maxPrice":5130,"moItemNo":0,"netMargin":0,"netPrice":0,"netSales":7,"oiCurrency":"CLP","orderItemId":"","priceBookDetailId":"","productCode":"","productId":"'+skuid2+'","productName":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","profit":50000,"qty":10,"totalValue":0,"totalValueWithInterest":0,"unitValue":10,"unitCost":0,"unitValueWithInterest":0,"UOM":"L"}]';
            String salesOrderItemString5 = '[{"cultureDesc":"","days":0,"deliveryAddress":"Pune - null","deliveryDate":"2021-01-22","discount":0,"discount_percent":0,"interestRate":0,"isMO":false,"itemNo":0,"margin":0,"maxPrice":5130,"moItemNo":0,"netMargin":0,"netPrice":0,"netSales":7,"oiCurrency":"USD","orderItemId":"","priceBookDetailId":"","productCode":"","productId":"'+skuid2+'","productName":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","profit":50000,"qty":10,"totalValue":0,"totalValueWithInterest":0,"unitValue":10,"unitCost":0,"unitValueWithInterest":0,"UOM":"L","SOLIID":"'+soli1.id+'"}]';
            String salesOrderItemString4 = '[{"cultureDesc":"","days":0,"deliveryAddress":"Pune - null","deliveryDate":"2021-01-22","discount":0,"discount_percent":0,"interestRate":0,"isMO":false,"itemNo":0,"margin":0,"maxPrice":5130,"moItemNo":0,"netMargin":0,"netPrice":0,"netSales":7,"oiCurrency":"CLP","orderItemId":"","priceBookDetailId":"","productCode":"","productId":"'+skuid+'","productName":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","profit":50000,"qty":10,"totalValue":0,"totalValueWithInterest":0,"unitValue":10,"unitCost":0,"unitValueWithInterest":0,"UOM":"L"}]';
            String salesOrderItemString1 = '{"balanceQty":0,"deliveryAddress":"Pune - null","balanceQty2":0,"cultureDesc":"","days":0,"interestRate":0,"isMO":false,"isValid":false,"itemNo":10,"maxPrice":7.2,"monthlyInterestRate":0,"orderItemId":"","percUsed":100,"pricebookId":"a181m0000002j7xAAA","qty":10,"regState":"","skuCode":"000000000006685080","skuDescription":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","skuId":"'+skuid+'","totalValue":0,"totalValueWithInterest":0,"unitCost":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"L"}';
            //String priceDetailString='[{"additionalDiscountPercent":0,"additionalDiscountUOM":"L","additionalDiscountUOMConver":0,"additionalDiscountUSD":0,"balanceQty":0,"balanceQty2":0,"baseUOM":"L","convertFinalPrice":0,"convertNetPrice":0,"convertQty":0,"cultureDesc":"","days":0,"discountPercent":0,"discountUOM":"L","discountUOMConver":0,"discountUSD":0,"e2EBaseUOM":"L","e2ECostMBEWUSD":0,"e2ECostUPC9USD":0,"e2ECostUSD":10,"e2ESalesUOM":"L","e2EUOM":"L","e2EUOMValueCon":0,"interestRate":0,"isMO":false,"isValid":false,"itemNo":0,"maxPrice":11,"minValue":7,"monthlyInterestRate":0,"orderItemId":"","percUsed":100,"plnUOM":"","plnUOMConver":0,"pLNUSD":null,"pricebookId":"","profitCenter":"","qty":0,"rebate1Percent":0,"rebate1UOM":"L","rebate1USD":0,"rebate2Percent":0,"rebate2UOM":"L","rebate2USD":0,"rebateCode1":"","rebateCode2":"","rebateUOMConver1":0,"rebateUOMConver2":0,"regState":"","salesDeductionDUOMValueCon":0,"salesDeductionInPercent":0,"salesDeductionUOM":"L","salesDeductionUSD":0,"skuCode":"000000000000933043","skuDescription":"DEVRINOL 4 X 5 LT (NUFARM) (CL)","skuId":"'+sku.id+'","totalValue":0,"totalValueWithInterest":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"L","uomAddDiscount":"L","uomDiscount":"","uome2eCost":"L","uomPLN":"L","uomRebate1":"L","uomRebate2":"L","uomSalesDeduction":"L"}]';   
             String salesOrderItemString2 = '[{"balanceQty":0,"deliveryAddress":"Pune - null","balanceQty2":0,"cultureDesc":"","days":0,"interestRate":0,"isMO":false,"isValid":false,"itemNo":0,"maxPrice":7.2,"monthlyInterestRate":0,"orderItemId":"","percUsed":100,"pricebookId":"a181m0000002j7xAAA","oiCurrency":"CLP","qty":0,"regState":"","skuCode":"000000000006685080","skuDescription":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","skuId":"'+skuid+'","totalValue":0,"totalValueWithInterest":0,"unitCost":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"L"}]';
            String salesOrderItemString3 = '[{"cultureDesc":"","days":0,"deliveryAddress":"Pune - null","deliveryDate":"2021-01-22","discount":0,"discount_percent":0,"interestRate":0,"isMO":false,"itemNo":0,"margin":0,"maxPrice":5130,"moItemNo":0,"netMargin":0,"netPrice":0,"netSales":7,"oiCurrency":"CLP","orderItemId":"","priceBookDetailId":"","productCode":"","productId":"'+skuid+'","productName":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","profit":50000,"qty":10,"totalValue":0,"totalValueWithInterest":0,"unitCost":0,"unitValueWithInterest":0,"UOM":"L"}]';
            String priceDetailString='[{"additionalDiscountPercent":0,"additionalDiscountUOM":"L","additionalDiscountUOMConver":0,"additionalDiscountUSD":0,"balanceQty":0,"balanceQty2":0,"baseUOM":"L","convertFinalPrice":0,"convertNetPrice":0,"convertQty":0,"cultureDesc":"","days":0,"discountPercent":0,"discountUOM":"L","discountUOMConver":0,"discountUSD":0,"e2EBaseUOM":"L","e2ECostMBEWUSD":0,"e2ECostUPC9USD":0,"e2ECostUSD":10,"e2ESalesUOM":"L","e2EUOM":"L","e2EUOMValueCon":0,"interestRate":0,"isMO":false,"isValid":false,"itemNo":0,"maxPrice":11,"minValue":7,"monthlyInterestRate":0,"orderItemId":"","percUsed":100,"plnUOM":"","plnUOMConver":0,"pLNUSD":null,"pricebookId":"","profitCenter":"","qty":0,"rebate1Percent":0,"rebate1UOM":"L","rebate1USD":0,"rebate2Percent":0,"rebate2UOM":"L","rebate2USD":0,"rebateCode1":"","rebateCode2":"","rebateUOMConver1":0,"rebateUOMConver2":0,"regState":"","salesDeductionDUOMValueCon":0,"salesDeductionInPercent":0,"salesDeductionUOM":"L","salesDeductionUSD":0,"skuCode":"000000000000933043","skuDescription":"DEVRINOL 4 X 5 LT (NUFARM) (CL)","skuId":"'+skuid2+'","totalValue":0,"totalValueWithInterest":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"L","uomAddDiscount":"L","uomDiscount":"","uome2eCost":"L","uomPLN":"L","uomRebate1":"L","uomRebate2":"L","uomSalesDeduction":"L"}]';   
            String salesOrderItem = '[{"cultureDesc":"","days":0,"deliveryAddress":"Pune - null","deliveryDate":"2021-01-22","discount":0,"discount_percent":0,"interestRate":0,"isMO":false,"itemNo":0,"margin":0,"maxPrice":5130,"moItemNo":0,"netMargin":0,"netPrice":0,"netSales":7,"oiCurrency":"CL","orderItemId":"","priceBookDetailId":"","productCode":"","productId":"'+skuid+'","productName":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","profit":50000,"qty":10,"totalValue":0,"totalValueWithInterest":0,"unitCost":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"KG"}]';
            String priceDetailString1='[{"additionalDiscountPercent":0,"additionalDiscountUOM":"KG","additionalDiscountUOMConver":0,"additionalDiscountUSD":0,"balanceQty":0,"balanceQty2":0,"baseUOM":"KG","convertFinalPrice":0,"convertNetPrice":0,"convertQty":0,"cultureDesc":"","days":0,"discountPercent":0,"discountUOM":"KG","discountUOMConver":0,"discountUSD":0,"e2EBaseUOM":"KG","e2ECostMBEWUSD":0,"e2ECostUPC9USD":0,"e2ECostUSD":10,"e2ESalesUOM":"KG","e2EUOM":"KG","e2EUOMValueCon":0,"interestRate":0,"isMO":false,"isValid":false,"itemNo":0,"maxPrice":11,"minValue":7,"monthlyInterestRate":0,"orderItemId":"","percUsed":100,"plnUOM":"","plnUOMConver":0,"pLNUSD":null,"pricebookId":"","profitCenter":"","qty":0,"rebate1Percent":0,"rebate1UOM":"KG","rebate1USD":0,"rebate2Percent":0,"rebate2UOM":"KG","rebate2USD":0,"rebateCode1":"","rebateCode2":"","rebateUOMConver1":0,"rebateUOMConver2":0,"regState":"","salesDeductionDUOMValueCon":0,"salesDeductionInPercent":0,"salesDeductionUOM":KG","salesDeductionUSD":0,"skuCode":"000000000000933043","skuDescription":"DEVRINOL 4 X 5 LT (NUFARM) (CL)","skuId":"'+skuid+'","totalValue":0,"totalValueWithInterest":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"KG","uomAddDiscount":"KG","uomDiscount":"","uome2eCost":"KG","uomPLN":"KG","uomRebate1":"L","uomRebate2":"KG","uomSalesDeduction":"KG"}]';   
            String priceDetailString2='[{"additionalDiscountPercent":0,"additionalDiscountUOM":"KG","additionalDiscountUOMConver":0,"additionalDiscountUSD":0,"balanceQty":0,"balanceQty2":0,"baseUOM":"KG","convertFinalPrice":0,"convertNetPrice":0,"convertQty":0,"cultureDesc":"","days":0,"discountPercent":0,"discountUOM":"KG","discountUOMConver":0,"discountUSD":0,"e2EBaseUOM":"KG","e2ECostMBEWUSD":0,"e2ECostUPC9USD":0,"e2ECostUSD":0,"e2ESalesUOM":"KG","e2EUOM":"KG","e2EUOMValueCon":0,"interestRate":0,"isMO":false,"isValid":false,"itemNo":0,"maxPrice":11,"minValue":7,"monthlyInterestRate":0,"orderItemId":"","percUsed":100,"plnUOM":"","plnUOMConver":0,"pLNUSD":null,"pricebookId":"","profitCenter":"","qty":0,"rebate1Percent":0,"rebate1UOM":"KG","rebate1USD":0,"rebate2Percent":0,"rebate2UOM":"KG","rebate2USD":0,"rebateCode1":"","rebateCode2":"","rebateUOMConver1":0,"rebateUOMConver2":0,"regState":"","salesDeductionDUOMValueCon":0,"salesDeductionInPercent":0,"salesDeductionUOM":"KG","salesDeductionUSD":0,"skuCode":"000000000000933043","skuDescription":"DEVRINOL 4 X 5 LT (NUFARM) (CL)","skuId":"'+skuid2+'","totalValue":0,"totalValueWithInterest":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"KG","uomAddDiscount":"KG","uomDiscount":"","uome2eCost":"KG","uomPLN":"KG","uomRebate1":"KG","uomRebate2":"KG","uomSalesDeduction":"KG"}]';   
           String priceDetailString5='[{"additionalDiscountPercent":0,"additionalDiscountUOM":"KG","additionalDiscountUOMConver":0,"additionalDiscountUSD":0,"balanceQty":0,"balanceQty2":0,"baseUOM":"KG","convertFinalPrice":0,"convertNetPrice":0,"convertQty":0,"cultureDesc":"","days":0,"discountPercent":0,"discountUOM":"KG","discountUOMConver":0,"discountUSD":0,"e2EBaseUOM":"KG","e2ECostMBEWUSD":0,"e2ECostUPC9USD":0,"e2ECostUSD":10,"e2ESalesUOM":"KG","e2EUOM":"KG","e2EUOMValueCon":0,"interestRate":0,"isMO":false,"isValid":false,"itemNo":0,"maxPrice":11,"minValue":7,"monthlyInterestRate":0,"orderItemId":"","percUsed":100,"plnUOM":"","plnUOMConver":0,"pLNUSD":null,"pricebookId":"","profitCenter":"","qty":0,"rebate1Percent":0,"rebate1UOM":"KG","rebate1USD":0,"rebate2Percent":0,"rebate2UOM":"KG","rebate2USD":0,"rebateCode1":"","rebateCode2":"","rebateUOMConver1":0,"rebateUOMConver2":0,"regState":"","salesDeductionDUOMValueCon":0,"salesDeductionInPercent":0,"salesDeductionUOM":"KG","salesDeductionUSD":0,"skuCode":"000000000000933043","skuDescription":"DEVRINOL 4 X 5 LT (NUFARM) (CL)","skuId":"'+skuid2+'","totalValue":0,"totalValueWithInterest":0,"unitValue":10,"unitValueWithInterest":0,"UOM":"KG","uomAddDiscount":"KG","uomDiscount":"KG","uome2eCost":"KG","uomPLN":"KG","uomRebate1":"KG","uomRebate2":"KG","uomSalesDeduction":"KG"}]';   
            String salesOrderItemString6 = '[{"cultureDesc":"","days":0,"deliveryAddress":"Pune - null","deliveryDate":"2021-01-22","discount":0,"discount_percent":0,"interestRate":0,"isMO":false,"itemNo":0,"margin":0,"maxPrice":5130,"moItemNo":0,"netMargin":0,"netPrice":0,"netSales":7,"oiCurrency":"USD","orderItemId":"","priceBookDetailId":"","productCode":"","productId":"'+skuid2+'","productName":"PYRIMETHANIL (PYRI 400 SC) 1x5LT_PE","profit":50000,"qty":10,"totalValue":0,"totalValueWithInterest":0,"unitValue":10,"unitCost":0,"unitValueWithInterest":0,"UOM":"L","SOLIID":"'+soli1.id+'"}]';
         //   SoChileEditController.updateAllOrderItems(salesOrderItemString,acc.id,so,sorg.Id);

            Test.startTest();
                SoChileEditController.saveSalesOrderLineItem(so,priceDetailString2,salesOrderItemString6,false,sorg.Id,true);
                    SoChileEditController.checkSimulation(priceDetailString5, so, salesOrderItemString, false, sorg.Id, true, true);
            so1.CurrencyIsoCode='CLP'; 
            SoChileEditController.saveSalesOrderLineItem(so1,priceDetailString2,salesOrderItemString,false,sorg.Id,true);
		    SoChileEditController.getSalesOrderItems(soList);
            SoChileEditController.getExchangeRate(System.today());
            SoChileEditController.getOrderFields(so1.id);
            SoChileEditController.getSalesOrder(soList);
            SoChileEditController.checkSimulation(priceDetailString5, so, salesOrderItemString5, false, sorg.Id, true, true);
             // SoChileEditController.editOrder(so);
               so1.CurrencyIsoCode='CLP';   
          //  SoChileEditController.saveSalesOrderLineItem(so,priceDetailString1,salesOrderItem,false,sorg.Id,true);
            so.CurrencyIsoCode='CLP';
            so.CurrencyIsoCode='CLP';
     
            SoChileEditController.ordObj = ordNull;
         
        
           
            List<id> soId = new List<id>();
          
            so.CurrencyIsoCode='CLP';
 		
            Test.stopTest();
            
          
           
        }
    } 
}