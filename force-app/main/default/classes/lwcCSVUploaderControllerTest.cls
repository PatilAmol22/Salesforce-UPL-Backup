@isTest
public class lwcCSVUploaderControllerTest {
    static testMethod void validateTestdata() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Test.startTest();
        User u = new User(
            ProfileId = System.Label.NonAdminProfileId,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Country  ='India',
            ManagerId = userinfo.getUserId()
            
            
        );
        insert u;
        
        Sales_Org__c salesOrgObj = new Sales_Org__c();
        salesOrgObj.Name='Colombia';
        salesOrgObj.Sales_Org_Code__c = '5710';
        insert salesOrgObj;
        
        Depot__c dp =new Depot__c ();
        dp.Name='CO51';
        
        dp.Country__c='Colombia';
        dp.Location__c='CO51';
        dp.Depot_Code__c='CO51';
        dp.SalesOrg__c = salesOrgObj.ID;
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
        
        
        Division__c Divbj = new Division__c();
        Divbj.Name = '10';         
        Divbj.Description__c = null;    
        Divbj.Division_Code__c = '10'; 
        insert Divbj;
        
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg; 
        Product2 productObj = new Product2(
            Name = 'ALPHA CYPER 10% EC',         // Product Name
            Product_Code__c = '65100',             // Product Code
            Active__c = false,                     // Active
            Sales_Org__c = salesOrgObj.Id,      // Sales Org
            Combination_Key__c = '6510057106710',  // Combination Key
            Popular__c = false,                    // Popular
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = false,     // Active For Liquidation
            
            Budget_NRV__c = 0.00                // Budget NRV
        );
        insert productObj;
        SKU__c skuObj = new SKU__c(
            Name = 'test sku',                         // SKU Name
            SKU_Code__c = '000000000006180633',                 // SKU Code
            Product_Name__c = productObj.Id,                // Product Nam
            SKU_Description__c = 'Test sku description',        // SKU Description
            UOM__c = 'L',                                       // UOM
            Distribution_Channel__c = disbj.Id,        // Distribution Channel
            Pack_Size__c = 0.00,                              // Pack Size
            Division__c = Divbj.Id,   
            Unit_Cost__c = 200,
            Sales_Org__c = salesOrgObj.Id,                   // Sales Org
            Combination_Key__c = '57106710000000000006180633',  // Combination Key
            Material_type__c = 'FERT',                          // Material type
            Active__c = true,                                   // Active
            Brand_Name__c = 'FURRY1'                          // Brand Name
        );
        insert skuObj;
                Product2 productObj1 = new Product2(
            Name = 'ALPHA CYPER 10% EC TEST',         // Product Name
            Product_Code__c = '61806',             // Product Code
            Active__c = true,                     // Active
            Sales_Org__c = salesOrgObj.Id,      // Sales Org
            Combination_Key__c = '6510057106111',  // Combination Key
            Popular__c = false,                    // Popular
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = false,     // Active For Liquidation
            
            Budget_NRV__c = 0.00                // Budget NRV
        );
        insert productObj1;
         SKU__c skuObj1 = new SKU__c(
            Name = 'test sku1',                         // SKU Name
            SKU_Code__c = '000000000006180632',                 // SKU Code
            Product_Name__c = productObj1.Id,                // Product Nam
            SKU_Description__c = 'Test sku description',        // SKU Description
            UOM__c = 'L',                                       // UOM
            Distribution_Channel__c = disbj.Id,        // Distribution Channel
            Pack_Size__c = 0.00,                              // Pack Size
            Division__c = Divbj.Id,   
            Unit_Cost__c = 200,
            Sales_Org__c = salesOrgObj.Id,                   // Sales Org
            Combination_Key__c = '57106710000000000006180632',  // Combination Key
            Material_type__c = 'FERT',                          // Material type
            Active__c = true,                                   // Active
            Brand_Name__c = 'FURRY1'                          // Brand Name
        );
        insert skuObj1;
        
        
        PriceBookMaster__c PbMaster = new PriceBookMaster__c();
        PbMaster.SKUCode__c = skuObj.id;           
        PbMaster.DepotCode__c =dp.id;         
        PbMaster.Price__c = 30; 
        PbMaster.MaxPrice__c=50;
        PbMaster.PG_CODE__c =Pg.Id;  
        PbMaster.UOM__c = 'NOS';                          
        PbMaster.StartDate__c = system.today();
        PbMaster.EndDate__c = system.today()+1;
        PbMaster.Active__c = true;                      
        PbMaster.PerUnit__c = 1;                       
        PbMaster.Batch__c ='test'; 
        PbMaster.CurrencyIsoCode='MXN'; 
        PbMaster.Division__c= Divbj.ID;
        PbMaster.CompositeKey__c='c1';
        //  PbMaster.DistributorCustomerCode__c='';
        insert PbMaster; 
          PriceBookMaster__c PbMaster1 = new PriceBookMaster__c();
        PbMaster1.SKUCode__c = skuObj1.id;           
        PbMaster1.DepotCode__c =dp.id;         
        PbMaster1.Price__c = 70; 
        PbMaster1.MaxPrice__c=50;
        PbMaster1.PG_CODE__c =Pg.Id;  
        PbMaster1.UOM__c = 'NOS';                          
        PbMaster1.StartDate__c = system.today();
        PbMaster1.EndDate__c = system.today()+1;
        PbMaster1.Active__c = true;                      
        PbMaster1.PerUnit__c = 1;                       
        PbMaster1.Batch__c ='test'; 
        PbMaster1.CurrencyIsoCode='MXN'; 
        PbMaster1.Division__c= Divbj.ID;
        PbMaster1.CompositeKey__c='c11';
        //  PbMaster.DistributorCustomerCode__c='';
        insert PbMaster1;
        Payment_Method__c payment_method = new Payment_Method__c(
            Name = 'CHEQUE NOMINATIVO',      // Payment Method Name
            Sales_Org__c = salesOrgObj.ID,  // Sales Org
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
            Sales_Org__c = salesOrgObj.ID,   // Sales Org
            CombinationKey__c = '51000004',     // CombinationKey
            Active__c = true                   // Active
        );
        insert payment_term;
        
        Inco_Term__c Inco_terms = new Inco_Term__c(
            Name = 'CFR',                                      // Inco Term Name
            IncoTerm_Code__c = 'CFR',                            // IncoTerm Code
            IncoTerm_Desc__c = 'NOSOTROS ENVIAMOS EL PRODUCTO',  // IncoTerm Desc
            Active__c = true,                                    // Active
            Sales_Org__c = salesOrgObj.ID                    // Sales Org
        );
        insert Inco_terms; 
        
        Order_Type__c salesorgOrderType = new Order_Type__c();
        salesorgOrderType.SalesOrg__c = salesOrgObj.Id;
        salesorgOrderType.Order_Type_Code__c ='ZZOR';
        insert salesorgOrderType;
        Account acc = new Account();
        acc.Name='Test Account';
        acc.Last_Name__c='Test';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='8600000000';
        acc.Phone='020200000';
        acc.Sales_Org__c=salesOrgObj.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Mumbai';
        acc.Order_Type__c=salesorgOrderType.Id;
        acc.Depot_Code__c = dp.Id;
        acc.Payment_Term_Code__c=payment_term.id;
        
        //  acc.OwnerId=sobj.Id;
        insert acc;
        
        PbMaster.DistributorCustomerCode__c=acc.id;
        update PbMaster; 
          PbMaster1.DistributorCustomerCode__c=acc.id;
        
        System.debug('PbMaster'+PbMaster);
        System.debug('query for pbb'+[SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                                      SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c,
                                      DepotCode__c, DepotCode__r.Location__c,SKUCode__r.UOM__c,
                                      Price__c, PG_CODE__c, PG_CODE__r.Name,
                                      UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Unit_Cost__c,
                                      SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,
                                      SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c
                                      FROM PriceBookMaster__c
                                      WHERE (DistributorCustomerCode__c =:acc.Id AND DepotCode__r.Location__c ='CO51')
                                      AND SKUCode__r.Sales_Org__r.sales_org_code__c ='5710' 
                                      AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True ]);
        Shipping_Location__c shippingLocationObj = new Shipping_Location__c(
            Location_Name__c = 'BAM S.A.',                           // Location Name
            SAP_Code__c = '0001023194',                                // SAP Code
            Distributor__c = acc.Id,                        // Distributor
            City__c = 'TESTCITY',                                     // City
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',  // Billing Street 1
            State__c = '11',                                           // State
            Country__c = 'CO',                                         // Country
            Billing_Street_3__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',  // Billing Street 3
            Pincode__c = '11001',                                      // Pincode
            Sold_To_Party_SAP_Code__c = '0001023194',                  // Sold To Party (SAP Code)
            Combination_Key__c = '00010231940001023194',               // Combination Key
            Country_Name__c = 'Colombia',                              // Country Name
            Sales_Org__c = salesOrgObj.Id,                          // Sales Org
            Distribution_Channel__c = disbj.Id,               // Distribution Channel
            Division__c = Divbj.Id                           // Division
            
        );
        insert shippingLocationObj;
        Admin_MPT_Colombia__c AdminMPTColombiaObj = new Admin_MPT_Colombia__c(
            of_adjustment_to_display_vendor_utility__c = 5.12,// Percentage Of Adjustment
            Min_for_Profitable_in_result_by_margin__c = 45.00,   // Minimum Percentage For Profitable
            Level_1_max__c = 30.00,                              // Level 1 Maximum Percentage
            Level_1_min__c = 20.01,                              // Level 1 Minimum Percentage
            Level_2_max__c = 20.00,                              // Level 2 Maximum Percentage
            Level_2_min__c = 15.01,                              // Level 2 Minimum Percentage
            Level_3_below__c =15,                            // Level 3 Below Percentage
            Max_no_of_prod_asso_with_initial_product__c = 25,   // Maximum Number Of Product
            Sales_Org__c =salesOrgObj.Id,
            Active__c = true,
            USD_Conversion_Rate__c = 3800                                  // Active
        );
        insert AdminMPTColombiaObj;
        
        String base64Data = JSON.serialize('\r\nTest Account,MPT Order,2023-04-16,TESTCITY\r\n\r\nTest Account,6180633,L,9,300,Producto Inicial \r\n\Test Account,6180633,L,9,300,Impacto Producto');
        
        String base64Data1 = JSON.serialize('\r\nTest Account,Normal Order,2023-04-16,TESTCITY\r\n\r\nTest Account,6180633,L,9,300');
          String base64Data2 = JSON.serialize('\r\nTest Account,MPT Order,2023-04-16,TESTCITY\r\n\r\nTest Account,6180633,L,9,300,Producto Inicial \r\n\Test Account,6180633,L,9,300,Impacto Negocio');
        lwcCSVUploaderColombiaController.saveFile(base64Data);
        lwcCSVUploaderColombiaController.saveFile(base64Data1);
         lwcCSVUploaderColombiaController.saveFile(base64Data2);
        
        
        Test.stopTest();
        
    } 
    
}