/*  
* Name: OrderMexicoCmpControllerTest     
* Created On: 17th Jan 2021
* Author: Vivek Shrivastava
* Description: Test Class for OrderMexicoCmpController
*/ 

@isTest
public class OrderMexicoCmpControllerTest{
    
    @testSetup
    static void setupMethod(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        Insert Pg;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        Insert auto;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Mexico';
        sorg.Description__c='Mexico';
        sorg.Sales_Org_Code__c='5100';
        Insert sorg;
        
        Crop__c crops = new Crop__c();
        crops.active__c=true;
        crops.name = 'Apple';
        crops.SalesOrg__c = sorg.id;
        crops.CurrencyIsoCode='MXN';
        Insert crops;
        
        Crop__c crops2 = new Crop__c();
        crops2.active__c=true;
        crops2.name = 'Lemon';
        crops2.SalesOrg__c = sorg.id;
        crops2.CurrencyIsoCode='MXN';
        Insert crops2;
        
        Crop__c crops3 = new Crop__c();
        crops3.active__c=true;
        crops3.name = 'Tomato';
        crops3.SalesOrg__c = sorg.id;
        crops3.CurrencyIsoCode='MXN';
        Insert crops3;
        
        Crop__c crops4 = new Crop__c();
        crops4.active__c=true;
        crops4.name = 'Orange';
        crops4.SalesOrg__c = sorg.id;
        crops4.CurrencyIsoCode='MXN';
        Insert crops4;
        
        Crop__c crops5 = new Crop__c();
        crops5.active__c=true;
        crops5.name = 'Other';
        crops5.SalesOrg__c = sorg.id;
        crops5.CurrencyIsoCode='MXN';
        Insert crops5;
        
        Crop__c crops6 = new Crop__c();
        crops6.active__c = true;
        crops6.name = 'Planta';
        crops6.SalesOrg__c = sorg.id;
        crops6.CurrencyIsoCode='MXN';
        Insert crops6;
        
        RecordType depot_RecTypeId = [SELECT Id FROM RecordType WHERE Name = 'Depot' and isActive = TRUE LIMIT 1];
        Depot__c dp_M = new Depot__c ();
        dp_M.Name = 'UPL Mexico';
        dp_M.recordtypeId = depot_RecTypeId.id;
        dp_M.Country__c = 'Mexico';
        dp_M.Location__c = 'NORTE';
        dp_M.Depot_Code__c = 'MX00';
        dp_M.Active__c = true;
        dp_M.SalesOrg__c = sorg.ID;
        Insert dp_M;
        
        RecordType supplier_RecTypeId = [SELECT Id FROM RecordType WHERE Name = 'Storage Location' and isActive = TRUE LIMIT 1];
        Depot__c dp = new Depot__c ();
        dp.Name = 'NORTE';
        dp.recordtypeId = supplier_RecTypeId.id;
        dp.Country__c = 'Mexico';
        dp.Location__c = 'NORTEE';
        dp.Depot_Code__c = 'MW22';
        dp.Active__c = true;
        dp.Depot__c = dp_M.Id;
        dp.SalesOrg__c = sorg.ID;
        dp.Segment_Name__c = 'Sales Team';
        Insert dp;
        
        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        Insert Pro;
        
        Distribution_Channel__c disbj = new Distribution_Channel__c();
        disbj.Name = '20';                      
        disbj.Distribution_Channel_Code__c = '20';  
        disbj.Description__c='test';
        Insert disbj;
        
        Distribution_Channel__c disbj2 = new Distribution_Channel__c();
        disbj2.Name = '67';                      
        disbj2.Distribution_Channel_Code__c = '67';  
        disbj2.Description__c='test';
        Insert disbj2;
        
        Division__c Divbj2 = new Division__c();
        Divbj2.Name = '20';         
        Divbj2.Description__c = null;    
        Divbj2.Division_Code__c = '20'; 
        Insert Divbj2;
        
        Division__c Divbj = new Division__c();
        Divbj.Name = '10';         
        Divbj.Description__c = null;    
        Divbj.Division_Code__c = '10'; 
        Insert Divbj;
        
        SKU__c sku = new SKU__c();
        sku.Name='P1';
        sku.SKU_Code__c='704002';
        sku.SKU_Pack__c=1.00;
        sku.SKU_UOM__c='L';
        sku.Multiple_Of__c=5;
        sku.Group__c='DOST';
        sku.Special_SKU__c = true;
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='L';
        sku.Brand_Name__c='My brand Name';
        sku.Active__c=True;
        sku.Combination_Key__c='Cooooooo000011111';
        Insert sku;
        
        SKU__c sku2 = new SKU__c();
        sku2.Name='P2';
        sku2.SKU_Code__c='704001';
        sku2.SKU_Pack__c = 1.00;
        sku2.SKU_UOM__c='L';
        sku2.Multiple_Of__c=5;
        sku2.Special_SKU__c = true;
        sku2.Group__c='P2';
        sku2.Pack_Size__c=10.00;
        sku2.Product_Name__c=pro.Id;
        sku2.Sales_Org__c = sorg.Id;
        sku2.UOM__c='L';
        sku2.Active__c=True;
        sku2.Combination_Key__c='Cooooooo000012111';
        Insert sku2;
        
        SKU__c sku3 = new SKU__c();
        sku3.Name='P2';
        sku3.SKU_Code__c='704001';
        sku3.SKU_Pack__c = 1.00;
        sku3.SKU_UOM__c='L';
        sku3.Multiple_Of__c=5;
        sku3.Special_SKU__c = true;
        sku3.Group__c='P2';
        sku3.Pack_Size__c=10.00;
        sku3.Product_Name__c=pro.Id;
        sku3.Sales_Org__c = sorg.Id;
        sku3.UOM__c='L';
        sku3.Active__c=True;
        sku3.Combination_Key__c='Cooossoooo000012111';
        Insert sku3;
        
        PriceBookMaster__c PbMaster = new PriceBookMaster__c();
        PbMaster.SKUCode__c = sku.id;           
        PbMaster.DepotCode__c =dp_M.id;         
        PbMaster.Price__c = 34500;                    
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
        Insert PbMaster; 
        
        PriceBookMaster__c PbMaster2 = new PriceBookMaster__c();
        PbMaster2.SKUCode__c = sku2.id;           
        PbMaster2.DepotCode__c =dp_M.id;         
        PbMaster2.Price__c = 3400;                    
        PbMaster2.PG_CODE__c =Pg.Id;  
        PbMaster2.UOM__c = 'NOS';                          
        PbMaster2.StartDate__c = system.today();
        PbMaster2.EndDate__c = system.today()+1;
        PbMaster2.Active__c = true;                      
        PbMaster2.PerUnit__c = 1;                       
        PbMaster2.Batch__c ='test'; 
        PbMaster2.CurrencyIsoCode='MXN'; 
        PbMaster2.Division__c= Divbj.ID;
        PbMaster2.CompositeKey__c='c2';
        Insert PbMaster2; 
        
        
        PriceBookMaster__c PbMaster3 = new PriceBookMaster__c();
        PbMaster3.SKUCode__c = sku3.id;           
        PbMaster3.DepotCode__c =dp_M.id;         
        PbMaster3.Price__c = 3400;                    
        PbMaster3.PG_CODE__c =Pg.Id;  
        PbMaster3.UOM__c = 'KG';                          
        PbMaster3.StartDate__c = system.today();
        PbMaster3.EndDate__c = system.today()+1;
        PbMaster3.Active__c = true;                      
        PbMaster3.PerUnit__c = 1;                       
        PbMaster3.Batch__c ='test'; 
        PbMaster3.CurrencyIsoCode='MXN'; 
        PbMaster3.Division__c= Divbj.ID;
        PbMaster3.CompositeKey__c='sc2';
        Insert PbMaster3; 
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZORD';              
        ordType.Description__c = 'Indonesia';    
        ordType.Order_Type_Code__c = 'ZORD';
        Insert ordType;
        
        Payment_Method__c payment_method = new Payment_Method__c(
            Name = 'CHEQUE NOMINATIVO',
            Sales_Org__c = sorg.ID,
            Payment_Method_Code__c = 'B',
            Active__c = true, 
            Combination_Key__c = '5100B' 
        );
        Insert payment_method;
        
        Payment_Term__c payment_term = new Payment_Term__c(
            Payment_Term_Code__c = '0004',   
            Payment_Term__c = 'Net 190 days',  
            Payterms_Desc__c = 'Net 190 days',
            Days_to_calc_interest__c = 0, 
            Sales_Org__c = sorg.ID, 
            CombinationKey__c = '51000004', 
            Active__c = true
        );
        Insert payment_term;
        
        Inco_Term__c Inco_terms = new Inco_Term__c(
            Name = 'CFR',                                     
            IncoTerm_Code__c = 'CFR',                          
            IncoTerm_Desc__c = 'NOSOTROS ENVIAMOS EL PRODUCTO', 
            Active__c = true,                              
            Sales_Org__c = sorg.ID               
        );
        Insert Inco_terms; 
        test.startTest();
        Account acc = new Account();
        acc.Name = 'Test Account Distributer';
        acc.Last_Name__c = 'Distributer';
        acc.PriceGroupCode__c = pg.id;
        acc.SAP_Code__c = 'SAP996734';
        acc.RecordTypeId = devRecordTypeId;
        acc.Mobile__c = '9967341759';
        acc.Phone = '020256589';
        acc.Sales_Org__c = sorg.Id;
        acc.Division__c = Divbj.Id;
        acc.Distribution_Channel__c = disbj.Id;
        acc.BillingCity = 'Pune';
        acc.Order_Type__c = ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        Insert acc;
        
        PbMaster.DistributorCustomerCode__c = acc.Id;
        Update PbMaster; 
        
        Price_Group_Master__c priceGroup = new Price_Group_Master__c(
            PG_Code__c = '01'
        );
        Insert priceGroup;
        
        DistributorSalesAreaMapping__c sobj = new DistributorSalesAreaMapping__c(
            AccountType__c = 'Sold To Party',          
            Distributor__c = acc.id,       
            SalesOrg__c = sorg.id,         
            OrderBlock__c = false,                   
            DistributionChannel__c = disbj.id, 
            Division__c = Divbj.id,   
            PriceGroupMaster__c = priceGroup.id   
        );
        Insert sobj;
        
        DistributorSalesAreaMapping__c sobj2 = new DistributorSalesAreaMapping__c(
            AccountType__c = 'Sold To Party',      
            Distributor__c = acc.id,         
            SalesOrg__c = sorg.id,         
            OrderBlock__c = false,                    
            DistributionChannel__c = disbj.id,  
            Division__c = Divbj2.id,             
            PriceGroupMaster__c = priceGroup.id  
        );
        Insert sobj2;
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = acc.Last_Name__c;
        Insert con;
        
        userrole  usrole = new userrole();
        usrole.Name = 'Regional/Zonal Managers for Mexico';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'PartnerCommunity Distributor Profile'];
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';    
        sobj1.Crop_Selection__c=true;                                                        
        sobj1.Email = 'himanshua.mehta@skinternational.com';                             
        sobj1.ProfileId  = p.Id;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = True;  
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
        sobj1.ContactID=con.Id;
        Insert sobj1;
        
        Sales_Org__c salesOrg  = new Sales_Org__c();
        salesOrg.Name = 'Mexico';
        salesOrg.Company_Code__c = '5000';
        salesOrg.Country_Code__c = 'MX';
        salesOrg.Sales_Org_Code__c = '5100';
        Insert salesOrg;
        
        TM_Depot_Mapping__c TMDepoMap = new TM_Depot_Mapping__c();
        TMDepoMap.Depot__c = dp.Id;        // Depot
        TMDepoMap.Territory_Manager__c = sobj1.id;  // Territory Manager
        Insert TMDepoMap;
        
        Shipping_Location__c shippLoc =new Shipping_Location__c();
        shippLoc.Location_Name__c ='Same as Billing Address'; 
        shippLoc.Region__c='Pune';
        shippLoc.Distributor__c=acc.Id;
        shippLoc.City__c='Pune';
        shippLoc.Sold_To_Party_SAP_Code__c = acc.SAP_Code__c;
        shippLoc.SAP_Code__c='SAP0001';
        shippLoc.State__c='13';
        shippLoc.Sales_Org__c = salesOrg.id;
        Insert shippLoc;
        
        Shipping_Location__c shippLoc2 =new Shipping_Location__c();
        shippLoc2.Location_Name__c ='Mumbai'; 
        shippLoc2.Region__c='Mumbai';
        shippLoc2.Distributor__c=acc.Id;
        shippLoc2.City__c='Mumbai';
        shippLoc2.SAP_Code__c = acc.SAP_Code__c;
        shippLoc2.Sold_To_Party_SAP_Code__c = acc.SAP_Code__c;
        shippLoc2.State__c='14';
        shippLoc2.Sales_Org__c = salesOrg.id;
        Insert shippLoc2;
        
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
        Insert spelDis;
        
        Inventory__c invObj = new Inventory__c( );
        invObj.Stock_Quantity__c = 0;
        invObj.In_transit_stock_quantity__c = 100;
        invObj.Batch_Number__c = 'CMUMTX2506'; 
        invObj.Depot__c = dp_M.Id;    
        invObj.UOM__c = 'L';                    
        invObj.Storage_Location__c = 'L1P';  
        invObj.SKU__c = sku.Id;  
        invObj.SKU_Depot__c ='sd1';           
        Insert invObj;
        
        Inventory__c invObj4 = new Inventory__c( );
        invObj4.Stock_Quantity__c = 0;
        invObj4.In_transit_stock_quantity__c = 100;
        invObj4.Batch_Number__c = 'CMUMTX2506'; 
        invObj4.Depot__c = dp_M.Id;    
        invObj4.UOM__c = 'L';                    
        invObj4.Storage_Location__c = 'L4P';  
        invObj4.SKU__c = sku2.Id;  
        invObj4.SKU_Depot__c ='sd4';           
        Insert invObj4;
        
        Inventory__c invObj2 = new Inventory__c( );
        invObj2.Stock_Quantity__c = 0;
        invObj2.In_transit_stock_quantity__c = 100;
        invObj2.Batch_Number__c = 'CMUMTX2506'; 
        invObj2.Storage_Location_Depot__c = dp.Id;    
        invObj2.UOM__c = 'L';                    
        invObj2.Storage_Location__c = 'L1C';  
        invObj2.SKU__c = sku.Id;  
        invObj2.SKU_Depot__c ='sd2';           
        Insert invObj2;
        
        Inventory__c invObj3 = new Inventory__c( );
        invObj3.Stock_Quantity__c = 0;
        invObj3.In_transit_stock_quantity__c = 100;
        invObj3.Batch_Number__c = 'CMUMTX2506'; 
        invObj3.Storage_Location_Depot__c = dp.Id;    
        invObj3.UOM__c = 'L';                    
        invObj3.Storage_Location__c = 'L2C';  
        invObj3.SKU__c = sku2.Id;  
        invObj3.SKU_Depot__c ='sd3';           
        Insert invObj3;
        
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
        PbDis.Sales_Org__c = salesOrg.Id;
        Insert PbDis;
        
        Distributor_Depot_Mapping__c dsMap =new Distributor_Depot_Mapping__c();
        dsMap.Distributor__c = acc.id;
        dsMap.Depot__c = dp_M.Id;
        Insert dsMap;
        
        SKU_Pack_Size__c spObj = new SKU_Pack_Size__c();
        spObj.Depot__c = dp.Id;
        spObj.UOM__c = 'L';
        spObj.SKU__c = sku.Id;
        spObj.Pack_Size__c = '5';
        Insert spObj;
        
        Credit_Info__c crdIf = new Credit_Info__c();
        crdIf.Credit_Limit__c=1000;
        crdIf.Percentage_Used__c=100.0;
        crdIf.Allocated_Limit__c=0.0;
        crdIf.Distributor__c=acc.Id;
        crdIf.Distributor_Code__c='0001001225';
        crdIf.Sales_Org__c = salesOrg.id;
        Insert crdIf;
        
        OrderTemplate__c ordTemp =new OrderTemplate__c();
        ordTemp.DistributorCustomerCode__c=acc.Id;
        ordTemp.Name='DOST 500.00 ML';
        Insert ordTemp;
        
        OrderTemplateItem__c ordTempItem = new OrderTemplateItem__c();
        ordTempItem.Name = 'DOST';
        ordTempItem.OrderTemplate__c=ordTemp.Id;
        ordTempItem.SKU__c = sku2.Id;
        Insert ordTempItem;
        
        State_Tax_Structure__c statetax = new State_Tax_Structure__c();
        statetax.State_Name__c = 'Maharashtra';
        statetax.Country__c = 'Indonesia';          
        statetax.Tax__c = 10;           
        statetax.State_Code__c = '13';
        statetax.AdditionalTax__c = 30;
        statetax.SalesOrg__c = sorg.Id;
        Insert statetax;
        
        Payment_Term__c paymenTermObj = new Payment_Term__c(
            Payment_Term__c = 'NET 75 Days',  // Payment Term
            Payment_Term_Code__c = 'UK38',      // Payment Term Code
            Maturity_Date_Mandatory__c = 'No',  // Maturity Date Mandatory
            Sales_Org__c = sorg.Id,   // Sales Org
            Payterms_Desc__c = 'NET 75 Days',   // Payterms Desc
            Active__c = true,                   // Active
            CombinationKey__c = '5100UK38'     // CombinationKey
        );
        insert paymenTermObj;
        
        Order__c ord = new Order__c();
        ord.Shipping_Location__c = shippLoc.id;  
        ord.Bill_To_Party__c = acc.Id;        
        ord.Order_Date__c = system.today();  
        ord.Order_Raise_By__c = 'Distributor';            
        ord.VAT__c = statetax.Tax__c;                            
        ord.Order_Status__c = 'Draft';                    
        ord.Additional_Tax__c =statetax.AdditionalTax__c;                        
        ord.Sales_Org__c =sorg.Id;          
        ord.Distribution_Channel__c =disbj.Id; 
        ord.Division__c = Divbj.Id;
        ord.Remarks_Long__c='test';
        //ord.Paymemt_Term__c = paymenTermObj.Id; 
        Insert ord;
        
        OrderLineItem__c ordItem = new OrderLineItem__c();
        ordItem.Item_Status__c = 'test';          
        ordItem.SKU_Name__c = sku.Id;
        ordItem.CurrencyIsoCode = 'MXN';
        
        ordItem.Item_Number__c = '10';          
        ordItem.UOM__c = 'L';                   
        ordItem.No_of_Case__c = 1;            
        ordItem.Invoice_Discount__c = 0.00;     
        ordItem.Quantity__c = 100;
        ordItem.Net_Price__c= 10;
        ordItem.Special_Discount__c = 0.00;     
        ordItem.Price__c = 23000;            
        ordItem.Order__c = ord.Id;    
        ordItem.Stock_Available__c = false;
        Insert ordItem; 
        
        OrderLineItem__c ordItem2 = new OrderLineItem__c();
        ordItem2.Item_Status__c = 'test';          
        ordItem2.SKU_Name__c = sku2.Id;
        ordItem2.CurrencyIsoCode = 'MXN';
        ordItem2.Item_Number__c = '20';          
        ordItem2.UOM__c = 'L'; 
        ordItem2.Net_Price__c= 10;
        ordItem2.No_of_Case__c = 1;            
        ordItem2.Invoice_Discount__c = 0.00;     
        ordItem2.Quantity__c = 100;          
        ordItem2.Special_Discount__c = 0.00;     
        ordItem2.Price__c = 23900;            
        ordItem2.Order__c = ord.Id;    
        ordItem2.Stock_Available__c = false;
        Insert ordItem2; 
        
        OrderLineItem__c ordItem3 = new OrderLineItem__c();
        ordItem3.Item_Status__c = 'test';          
        ordItem3.SKU_Name__c = sku3.Id;
        ordItem3.CurrencyIsoCode = 'MXN';
        ordItem3.Item_Number__c = '30';          
        ordItem3.UOM__c = 'L'; 
        ordItem3.Net_Price__c= 10;
        ordItem3.No_of_Case__c = 1;            
        ordItem3.Invoice_Discount__c = 0.00;     
        ordItem3.Quantity__c = 100;          
        ordItem3.Special_Discount__c = 0.00;     
        ordItem3.Price__c = 23900;            
        ordItem3.Order__c = ord.Id;    
        ordItem3.Stock_Available__c = false;
        Insert ordItem3; 
        
        
        
        Sales_Order__c so = new Sales_Order__c();
        so.Sold_to_Party__c = acc.Id;
        so.Bill_To_Party__c = acc.Id;
        so.Order_Date__c = system.today();
        so.CreatedFrom__c = 'SFDC';
        so.Depot__c = dp.Id;
        so.OwnerId = UserInfo.getUserId();
        so.Order__c = ord.Id;
        so.Sales_Org_lk__c = sorg.Id;
        so.Order_Status__c = 'Draft';
        so.Ship_To_Party__c = shippLoc.Id;
        so.Payment_Term__c =paymenTermObj.Id;
        so.Sent_for_Latam_Director__c = true;
        Insert so;
        
        Sales_Order_Line_Item__c sliObj = new Sales_Order_Line_Item__c();
        sliObj.SKU_Name__c = sku.Id;
        sliObj.Item_Number__c = 10;
        sliObj.Type_of_Sale__c = 'Real Sale';
        sliObj.Item_Status__c = 'Active';
        sliObj.UOM__c = 'L';
        sliObj.CurrencyIsoCode = 'MXN';
        sliObj.multipleOf__c = 10;
        sliObj.MaxPrice__c = 200;
        sliObj.MinPrice__c = 50;
        sliobj.Shipping_Date__c = System.today().addDays(3);
        sliObj.Finalprice__c = 150;
        sliObj.crop__c = crops.Id;
        sliObj.Crop1_Percentage__c = 100;
        sliObj.Quantity__c = 10;
        sliObj.Net_Price__c = 150;
        sliObj.Price__c = 1500;
        sliObj.Sale_Order__c = so.Id;
        Insert sliObj;
        
        Sales_Order_Line_Item__c sliObj2 = new Sales_Order_Line_Item__c();
        sliObj2.SKU_Name__c = sku2.Id;
        sliObj2.Item_Number__c = 20;
        sliObj2.Type_of_Sale__c = 'Real Sale';
        sliObj2.Item_Status__c = 'Active';
        sliObj2.UOM__c = 'L';
        sliObj2.CurrencyIsoCode = 'MXN';
        sliObj2.multipleOf__c = 10;
        sliObj2.MaxPrice__c = 200;
        sliObj2.MinPrice__c = 50;
        sliobj2.Shipping_Date__c = System.today().addDays(3);
        sliObj2.Finalprice__c = 150;
        sliObj2.crop__c = crops.Id;
        sliObj2.Crop1_Percentage__c = 100;
        sliObj2.Quantity__c = 10;
        sliObj2.Net_Price__c = 10;
        sliObj2.Price__c = 1500;
        sliObj2.Sale_Order__c = so.Id;
        Insert sliObj2;
        
        Sales_Order_Line_Item__c sliObj3 = new Sales_Order_Line_Item__c();
        sliObj3.SKU_Name__c = sku3.Id;
        sliObj3.Item_Number__c = 30;
        sliObj3.Type_of_Sale__c = 'Real Sale';
        sliObj3.Item_Status__c = 'Active';
        sliObj3.UOM__c = 'L';
        sliObj3.CurrencyIsoCode = 'MXN';
        sliObj3.multipleOf__c = 10;
        sliObj3.MaxPrice__c = 200;
        sliObj3.MinPrice__c = 50;
        sliObj3.Shipping_Date__c = System.today().addDays(3);
        sliObj3.Finalprice__c = 150;
        sliObj3.crop__c = crops.Id;
        sliObj3.Crop1_Percentage__c = 100;
        sliObj3.Quantity__c = 10;
        sliObj3.Net_Price__c = 150;
        sliObj3.Price__c = 1500;
        sliObj3.Sale_Order__c = so.Id;
        Insert sliObj3;
        
        Pincode_Depot_Code_Mapping__c custSett = new Pincode_Depot_Code_Mapping__c();
        custSett.Name = 'C1';
        custSett.Pin_Code__c = '44900';
        custSett.Depot_Code__c = 'MW22';
        Insert custSett;
        
        Profit_Center__c profitObj = new Profit_Center__c(
            Depot__c = dp_M.Id,    // Depot
            Combination_Key__c = 'ADMX01',     // Combination Key
            Sales_Value__c = 3.00,             // Sales Value
            Sales_Org__c = sorg.Id,
            Profit_Center__c = 'ADMX01'       // Profit Center
        );
        insert profitObj;
        
        //vishal
        
        Price_Block_Margin_Matrix__c pbmmObj = new Price_Block_Margin_Matrix__c(
            Combination_Key__c = 'Test1',                 // Combination Key
            Depot_Code__c = dp_M.Id,            // Depot Code
            Distribution_Channel__c = disbj.id,  // Distribution Channel
            Division__c = Divbj.ID,              // Division
            E2E_Cost_LC__c = 10.00,                       // E2E Cost (LC)
            End_Date__c = System.today()+3,     // End Date
            Start_Date__c = System.today(),     // Start Date
            Sales_Org__c = sorg.Id,             // Sales Org
            SKU_Active__c = false,                        // SKU Active
            SKU_Code__c = sku2.Id,              // SKU Code
            UOM__c = 'L',     // UOM
            Type__c = 'E2ECost',     // UOM
            Profit_Center__c = profitObj.Id,
            Distributor_Code__c=acc.Id,
            E2E_Cost_USD__c =87
        );
        insert pbmmObj;
        
        Price_Block_Margin_Matrix__c pbmmObj1 = new Price_Block_Margin_Matrix__c(
            Combination_Key__c = 'Test21',                 // Combination Key
            Depot_Code__c = dp_M.Id,            // Depot Code
            Distribution_Channel__c = disbj.id,  // Distribution Channel
            Division__c = Divbj.ID,              // Division
            E2E_Cost_LC__c = 10.00,
            E2E_Cost_UPC9_LC__c =34.00,// E2E Cost (LC)
            End_Date__c = System.today()+3,     // End Date
            Start_Date__c = System.today(),     // Start Date
            Sales_Org__c = sorg.Id,             // Sales Org
            SKU_Active__c = false,                        // SKU Active
            SKU_Code__c = sku2.Id,              // SKU Code
            UOM__c = 'L',     // UOM
            Type__c = 'E2ECostUPC9',     // UOM
            Profit_Center__c = profitObj.Id,
            Distributor_Code__c=acc.Id,
            E2E_Cost_USD__c =87
        );
        insert pbmmObj1;
        
        Price_Block_Margin_Matrix__c pbmmObj2 = new Price_Block_Margin_Matrix__c(
            Combination_Key__c = 'Tessst21',                 // Combination Key
            Depot_Code__c = dp_M.Id,
            Distributor_Code__c=acc.Id,            // Depot Code
            Distribution_Channel__c = disbj.id,  // Distribution Channel
            Division__c = Divbj.ID,              // Division
            E2E_Cost_LC__c = 10.00,
            E2E_Cost_UPC9_LC__c =34.00,// E2E Cost (LC)
            End_Date__c = System.today()+3,     // End Date
            Start_Date__c = System.today(),     // Start Date
            Sales_Org__c = sorg.Id,             // Sales Org
            SKU_Active__c = false,                        // SKU Active
            SKU_Code__c = sku2.Id,              // SKU Code
            UOM__c = 'L',     // UOM
            Type__c = 'Rebate',     // UOM
            Rebate_LC__c = 43.00,
            Rebate_Code__c ='654654',
            Profit_Center__c = profitObj.Id ,
            Rebate_USD__c =78
        );
        insert pbmmObj2;
        
        Price_Block_Margin_Matrix__c pbmmObj3 = new Price_Block_Margin_Matrix__c(
            Combination_Key__c = 'Tessstcc21',                 // Combination Key
            Depot_Code__c = dp_M.Id,
            Distributor_Code__c=acc.Id,            // Depot Code
            Distribution_Channel__c = disbj.id,  // Distribution Channel
            Division__c = Divbj.ID,              // Division
            E2E_Cost_LC__c = 10.00,
            E2E_Cost_UPC9_LC__c =34.00,// E2E Cost (LC)
            End_Date__c = System.today()+3,     // End Date
            Start_Date__c = System.today(),     // Start Date
            Sales_Org__c = sorg.Id,             // Sales Org
            SKU_Active__c = false,                        // SKU Active
            SKU_Code__c = sku2.Id,              // SKU Code
            UOM__c = 'L',     // UOM
            Type__c = 'Rebate',     // UOM
            Rebate_LC__c = 43.00,
            Rebate_Code__c ='65434654',
            Profit_Center__c = profitObj.Id, 
            Rebate_USD__c = 43
        );
        insert pbmmObj3;
        
        Price_Block_Margin_Matrix__c pbmmObj4 = new Price_Block_Margin_Matrix__c(
            Combination_Key__c = 'Tessstsscc21',                 // Combination Key
            Depot_Code__c = dp_M.Id,
            Distributor_Code__c=acc.Id,            // Depot Code
            Distribution_Channel__c = disbj.id,  // Distribution Channel
            Division__c = Divbj.ID,              // Division
            E2E_Cost_LC__c = 10.00,
            E2E_Cost_UPC9_LC__c =34.00,// E2E Cost (LC)
            End_Date__c = System.today()+3,     // End Date
            Start_Date__c = System.today(),     // Start Date
            Sales_Org__c = sorg.Id,             // Sales Org
            SKU_Active__c = false,                        // SKU Active
            SKU_Code__c = sku2.Id,              // SKU Code
            UOM__c = 'L',     // UOM
            Type__c = 'Discount',     // UOM
            Rebate_LC__c = 43.00,
            Rebate_Code__c ='654654',
            Profit_Center__c = profitObj.Id,
            Discount_LC__c = 23.90,
            Discount_USD__c =65.9,
            Discount__c = 76.00
        );
        insert pbmmObj4;
        
        Price_Block_Margin_Matrix__c pbmmObj5 = new Price_Block_Margin_Matrix__c(
            Combination_Key__c = 'Tessstsssscc21',                 // Combination Key
            Depot_Code__c = dp_M.Id,
            Distributor_Code__c=acc.Id,            // Depot Code
            Distribution_Channel__c = disbj.id,  // Distribution Channel
            Division__c = Divbj.ID,              // Division
            E2E_Cost_LC__c = 10.00,
            E2E_Cost_UPC9_LC__c =34.00,// E2E Cost (LC)
            End_Date__c = System.today()+3,     // End Date
            Start_Date__c = System.today(),     // Start Date
            Sales_Org__c = sorg.Id,             // Sales Org
            SKU_Active__c = false,                        // SKU Active
            SKU_Code__c = sku2.Id,              // SKU Code
            UOM__c = 'L',     // UOM
            Type__c = 'AdditionalDiscount',     // UOM
            Rebate_LC__c = 43.00,
            Rebate_Code__c ='654654',
            Profit_Center__c = profitObj.Id,
            Discount_LC__c = 23.90,
            Discount_USD__c =65.9,
            Discount__c = 76.00,
            Additional_Discount_LC__c= 78.99,
            Additional_Discount_USD__c= 78.99,
            Additional_Discount__c= 78.99
        );
        insert pbmmObj5;
        
        
        Price_Block_Margin_Matrix__c pbmmObj6 = new Price_Block_Margin_Matrix__c(
            Combination_Key__c = 'Tessstsssscchg21',                 // Combination Key
            Depot_Code__c = dp_M.Id,
            Distributor_Code__c=acc.Id,            // Depot Code
            Distribution_Channel__c = disbj.id,  // Distribution Channel
            Division__c = Divbj.ID,              // Division
            E2E_Cost_LC__c = 10.00,
            E2E_Cost_UPC9_LC__c =34.00,// E2E Cost (LC)
            End_Date__c = System.today()+3,     // End Date
            Start_Date__c = System.today(),     // Start Date
            Sales_Org__c = sorg.Id,             // Sales Org
            SKU_Active__c = false,                        // SKU Active
            SKU_Code__c = sku2.Id,              // SKU Code
            UOM__c = 'L',     // UOM
            Type__c = 'SalesDeduction',     // UOM
            Rebate_LC__c = 43.00,
            Rebate_Code__c ='654654',
            Sales_Deduction_LC__c =87.00,
            Profit_Center__c = profitObj.Id,
            Discount_LC__c = 23.90,
            Discount_USD__c =65.9,
            Discount__c = 76.00,
            Additional_Discount_LC__c= 78.99,
            Additional_Discount_USD__c= 78.99,
            Additional_Discount__c= 78.99,
            Sales_Deduction_USD__c =87
        );
        insert pbmmObj6;
        
        
        Price_Block_Margin_Matrix__c pbmmObj7 = new Price_Block_Margin_Matrix__c(
            Combination_Key__c = 'Tessstsssssscchg21',                 // Combination Key
            Depot_Code__c = dp_M.Id,
            Distributor_Code__c=acc.Id,            // Depot Code
            Distribution_Channel__c = disbj.id,  // Distribution Channel
            Division__c = Divbj.ID,              // Division
            E2E_Cost_LC__c = 10.00,
            E2E_Cost_UPC9_LC__c =34.00,// E2E Cost (LC)
            End_Date__c = System.today()+3,     // End Date
            Start_Date__c = System.today(),     // Start Date
            Sales_Org__c = sorg.Id,             // Sales Org
            SKU_Active__c = false,                        // SKU Active
            SKU_Code__c = sku2.Id,              // SKU Code
            UOM__c = 'L',     // UOM
            Type__c = 'PLN',     // UOM
            Rebate_LC__c = 43.00,
            Rebate_Code__c ='654654',
            Sales_Deduction_LC__c =87.00,
            Profit_Center__c = profitObj.Id,
            Discount_LC__c = 23.90,
            Discount_USD__c =65.9,
            Discount__c = 76.00,
            Additional_Discount_LC__c= 78.99,
            Additional_Discount_USD__c= 78.99,
            Additional_Discount__c= 78.99,
            PLN_LC__c = 12,
            PLN_USD__c =65
        );
        insert pbmmObj7;
        
        
        
        
        
        UOM_Conversion__c uomConObj = new UOM_Conversion__c(
            Sales_Org__c = sorg.Id,           // Sales Org
            Base_UOM__c = 'L',                            // Base UOM
            SKU__c = sku2.Id,                   // SKU
            Sales_UOM__c = 'L',                           // Sales UOM
            Distribution_Channel__c = disbj.id,  // Distribution Channel
            Numerator__c = 1.00,                        // Numerator
            Division__c = Divbj.ID,              // Division
            Denominator__c = 1.00,                      // Denominator
            Combination_Key__c = 'Test1'                 // Combination Key
        );
        insert uomConObj;
        
        UOM_Conversion__c uomConObj1 = new UOM_Conversion__c(
            Sales_Org__c = sorg.Id,           // Sales Org
            Base_UOM__c = 'L',                            // Base UOM
            SKU__c = sku3.Id,                   // SKU
            Sales_UOM__c = 'L',                           // Sales UOM
            Distribution_Channel__c = disbj.id,  // Distribution Channel
            Numerator__c = 1.00,                        // Numerator
            Division__c = Divbj.ID,              // Division
            Denominator__c = 1.00,                      // Denominator
            Combination_Key__c = 'Tessst1'                 // Combination Key
        );
        insert uomConObj1;
        
        
        Admin_MPT_Colombia__c adminMPTObj = new Admin_MPT_Colombia__c(
            USD_Conversion_Rate__c = 1.000,                 // USD Conversion Rate 1$=
            of_adjustment_to_display_vendor_utility__c = 1.00,  // Percentage Of Adjustment
            Min_for_Profitable_in_result_by_margin__c = 1.00,   // Minimum Percentage For Profitable
            Level_1_max__c = 25.00,                             // Level 1 Maximum Percentage
            Level_1_min__c = 15.10,                             // Level 1 Minimum Percentage
            Level_2_max__c = 15.00,                             // Level 2 Maximum Percentage
            Level_2_min__c = 10.10,                             // Level 2 Minimum Percentage
            Level_3_below__c = 10.00,                           // Level 3 Below Percentage
            Sales_Org__c = sorg.Id,                   // Sales Org
            Max_no_of_prod_asso_with_initial_product__c = 1,  // Maximum Number Of Product
            Active__c = true                                   // Active
        );
        insert adminMPTObj;
        
        USD_Exchange_Rate__c usdExchange = new USD_Exchange_Rate__c(
            FROM_Currency__c = 'MXN',                // FROM Currency
            TO_Currency__c = 'USD',                    // TO Currency
            Exchange_Rate__c = 0.04906,              // Exchange Rate
            Ratio_from__c = 1.000,                   // Ratio from
            Ration_To__c = 1.000,                    // Ration To
            Valid_From__c = System.today(),  // Valid From
            Combination_Key__c = 'MXNUSD05042022'     // Combination Key
        );
        insert usdExchange;
        Login_Country__c logCountryObj = new Login_Country__c();
        logCountryObj.Name ='Mexico'; 
        logCountryObj.For_Contry__c ='Mexico';
        logCountryObj.Sales_Org_Code__c ='5100';
        logCountryObj.Show_Delivery_Date__c = true;
        logCountryObj.Show_PO_Date__c = true;
        logCountryObj.Delivery_Date__c = true;
        logCountryObj.PO_Date__c = true;
        insert logCountryObj;
        
        
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=ord.id;
        insert attach;
test.stopTest();
        
        
        
        
    }
    
    private static testMethod void testInitializeDetails_Acc(){
        test.startTest();
        Account acc = [SELECT Id FROM Account WHERE SAP_Code__c = 'SAP996734' LIMIT 1];
        Sales_Order__c so = [SELECT Id FROM Sales_Order__c LIMIT 1];
        OrderMexicoCmpController.WrapperData obj = new OrderMexicoCmpController.WrapperData();
        obj = OrderMexicoCmpController.initializeDetails(String.valueOf(acc.Id));
        obj = OrderMexicoCmpController.initializeDetails(String.valueOf(so.Id));
        
        System.assert(obj.skuOrderList != null);
        OrderMexicoCmpController.getInventoryDetails(JSON.serialize(obj.initDetailsWrap), JSON.serialize(obj.skuOrderList), 
                                                     JSON.serialize(obj.skuObjList), JSON.serialize(obj.skuObjList[0]),
                                                     obj.initDetailsWrap.storageIdChosen);
        OrderMexicoCmpController.getSalesOrderHistory(JSON.serialize(obj.initDetailsWrap), obj.skuObjList[0].skuId);
        OrderMexicoCmpController.addCharIntoRemark('Test Remark');
        test.stopTest();
    }
    
    private static testMethod void testAddSKU(){
        test.startTest();
        Account acc = [SELECT Id FROM Account WHERE SAP_Code__c = 'SAP996734' LIMIT 1];
        OrderMexicoCmpController.WrapperData obj = new OrderMexicoCmpController.WrapperData();
        obj = OrderMexicoCmpController.initializeDetails(String.valueOf(acc.Id));
        Crop__c crop1 = [SELECT Id FROM Crop__c WHERE Name = 'Apple' LIMIT 1];
        
        System.assert(obj.skuOrderList != null);
        
        obj.skuObjList[0].crop1 = crop1.Id;
        obj.skuObjList[0].crop1_Percentage = 100;
        obj.skuObjList[0].qty = 50;
        obj.skuObjList[0].finalPrice = 1;
        obj.skuObjList[0].typeOfSale = 'Real Sale';
        System.debug('sadsadd 1  '+JSON.serialize(obj.skuObjList[0]));
        System.debug('sadsadd 2 '+JSON.serialize(null));
        System.debug('sadsadd 3 '+JSON.serialize(obj.distributerWrapObj));
        System.debug('sadsadd 4 '+obj.initDetailsWrap.orderRaisedBy);
        System.debug('sadsadd 5 '+obj.orderObj);
        
       /* OrderMexicoCmpController.addSKU(JSON.serialize(obj.skuObjList[0]), JSON.serialize(null),
                                        JSON.serialize(obj.distributerWrapObj), obj.initDetailsWrap.orderRaisedBy,
                                        obj.orderObj, false, null);*/
        
        obj.skuObjList[0].crop1 = crop1.Id;
        obj.skuObjList[0].crop1_Percentage = 100;
        obj.skuObjList[0].qty = 50;
        obj.skuObjList[0].finalPrice = 2;
        obj.skuObjList[0].typeOfSale = 'Real Sale';
        for(Integer i = 0; i< obj.skuOrderList.size(); i++){
            if(obj.skuOrderList[i].skuId == obj.skuObjList[0].skuId){
                obj.skuOrderList[i].typeOfSale = 'Real Sale';
                break;
            }
        }
        OrderMexicoCmpController.addSKU(JSON.serialize(obj.skuObjList[0]), JSON.serialize(obj.skuOrderList),
                                        JSON.serialize(obj.distributerWrapObj), obj.initDetailsWrap.orderRaisedBy,
                                        obj.orderObj, false, null);
        
        obj.skuObjList[0].crop1 = crop1.Id;
        obj.skuObjList[0].crop1_Percentage = 100;
        obj.skuObjList[0].qty = 50;
        obj.skuObjList[0].finalPrice = 3;
        obj.skuObjList[0].typeOfSale = 'Promotion';
        /*
        OrderMexicoCmpController.addSKU(JSON.serialize(obj.skuObjList[0]), JSON.serialize(obj.skuOrderList),
                                        JSON.serialize(obj.distributerWrapObj), obj.initDetailsWrap.orderRaisedBy,
                                        obj.orderObj, false, null);*/
        test.stopTest();
    }
    
    private static testMethod void testUpdateSKU(){
        test.startTest();
        Account acc = [SELECT Id FROM Account WHERE SAP_Code__c = 'SAP996734' LIMIT 1];
        OrderMexicoCmpController.WrapperData obj = new OrderMexicoCmpController.WrapperData();
        obj = OrderMexicoCmpController.initializeDetails(String.valueOf(acc.Id));
        Crop__c crop1 = [SELECT Id FROM Crop__c WHERE Name = 'Apple' LIMIT 1];
        
        System.assert(obj.skuOrderList != null);
        
        obj.skuObjList[0].crop1 = crop1.Id;
        obj.skuObjList[0].crop1_Percentage = 100;
        obj.skuObjList[0].qty = 50;
        obj.skuObjList[0].finalPrice = 4;
        obj.skuObjList[0].typeOfSale = 'Real Sale';
        
        OrderMexicoCmpController.addSKU(JSON.serialize(obj.skuObjList[0]), JSON.serialize(obj.skuOrderList),
                                        JSON.serialize(obj.distributerWrapObj), obj.initDetailsWrap.orderRaisedBy,
                                        obj.orderObj, false, null);
        obj.skuOrderList[0].finalPrice =5;
        OrderMexicoCmpController.updateSKU(JSON.serialize(obj.skuOrderList), 0, false);
        OrderMexicoCmpController.deleteSKU(JSON.serialize(obj.skuOrderList), 0, false);
        test.stopTest();
    }
    
    private static testMethod void testDeleteSKU(){
        test.startTest();
        Account acc = [SELECT Id FROM Account WHERE SAP_Code__c = 'SAP996734' LIMIT 1];
        OrderMexicoCmpController.WrapperData obj = new OrderMexicoCmpController.WrapperData();
        obj = OrderMexicoCmpController.initializeDetails(String.valueOf(acc.Id));
        Crop__c crop1 = [SELECT Id FROM Crop__c WHERE Name = 'Apple' LIMIT 1];
        
        System.assert(obj.skuOrderList != null);
        
        obj.skuObjList[0].crop1 = crop1.Id;
        obj.skuObjList[0].crop1_Percentage = 100;
        obj.skuObjList[0].qty = 50;
        obj.skuObjList[0].finalPrice = 6;
        obj.skuObjList[0].typeOfSale = 'Real Sale';
        
        OrderMexicoCmpController.addSKU(JSON.serialize(obj.skuObjList[0]), JSON.serialize(obj.skuOrderList),
                                        JSON.serialize(obj.distributerWrapObj), obj.initDetailsWrap.orderRaisedBy,
                                        obj.orderObj, false, null);
        obj.skuOrderList[0].finalPrice = 7;
        OrderMexicoCmpController.updateSKU(JSON.serialize(obj.skuOrderList), 0, false);
        OrderMexicoCmpController.deleteAllSKU(JSON.serialize(obj.skuOrderList), false);
        test.stopTest();
    }
    
    private static testMethod void testAddSKU_SO(){
        test.startTest();
        Sales_Order__c so = [SELECT Id,Payment_Term__c FROM Sales_Order__c LIMIT 1];
        OrderMexicoCmpController.WrapperData obj = new OrderMexicoCmpController.WrapperData();
        obj = OrderMexicoCmpController.initializeDetails(String.valueOf(so.Id));
        Crop__c crop1 = [SELECT Id FROM Crop__c WHERE Name = 'Apple' LIMIT 1];
        
        System.assert(obj.skuOrderList != null);
        
        obj.skuObjList[0].crop1 = crop1.Id;
        obj.skuObjList[0].crop1_Percentage = 100;
        obj.skuObjList[0].qty = 50;
        obj.skuObjList[0].finalPrice = 8;
        obj.skuObjList[0].typeOfSale = 'Real Sale';
        /*OrderMexicoCmpController.addSKU(JSON.serialize(obj.skuObjList[0]), JSON.serialize(null),
                                        JSON.serialize(obj.distributerWrapObj), obj.initDetailsWrap.orderRaisedBy,
                                        obj.orderObj, true, so);*/
        
        obj.skuObjList[0].crop1 = crop1.Id;
        obj.skuObjList[0].crop1_Percentage = 100;
        obj.skuObjList[0].qty = 50;
        obj.skuObjList[0].finalPrice = 9;
        obj.skuObjList[0].typeOfSale = 'Real Sale';
        for(Integer i = 0; i< obj.skuOrderList.size(); i++){
            if(obj.skuOrderList[i].skuId == obj.skuObjList[0].skuId){
                obj.skuOrderList[i].typeOfSale = 'Real Sale';
                break;
            }
        }
        OrderMexicoCmpController.addSKU(JSON.serialize(obj.skuObjList[0]), JSON.serialize(obj.skuOrderList),
                                        JSON.serialize(obj.distributerWrapObj), obj.initDetailsWrap.orderRaisedBy,
                                        obj.orderObj, true, so);
        
        obj.skuObjList[0].crop1 = crop1.Id;
        obj.skuObjList[0].crop1_Percentage = 100;
        obj.skuObjList[0].qty = 50;
        obj.skuObjList[0].finalPrice = 10;
        obj.skuObjList[0].typeOfSale = 'Promotion';
        OrderMexicoCmpController.addSKU(JSON.serialize(obj.skuObjList[0]), JSON.serialize(obj.skuOrderList),
                                        JSON.serialize(obj.distributerWrapObj), obj.initDetailsWrap.orderRaisedBy,
                                        obj.orderObj, true, so);
        test.stopTest();
    }
    
    private static testMethod void testUpdateSKU_SO(){
        test.startTest();
        Sales_Order__c so = [SELECT Id,Payment_Term__c FROM Sales_Order__c LIMIT 1];
        OrderMexicoCmpController.WrapperData obj = new OrderMexicoCmpController.WrapperData();
        obj = OrderMexicoCmpController.initializeDetails(String.valueOf(so.Id));
        Crop__c crop1 = [SELECT Id FROM Crop__c WHERE Name = 'Apple' LIMIT 1];
        
        System.assert(obj.skuOrderList != null);
        
        obj.skuObjList[0].crop1 = crop1.Id;
        obj.skuObjList[0].crop1_Percentage = 100;
        obj.skuObjList[0].qty = 50;
        obj.skuObjList[0].finalPrice = 11;
        obj.skuObjList[0].typeOfSale = 'Real Sale';
        
        OrderMexicoCmpController.addSKU(JSON.serialize(obj.skuObjList[0]), JSON.serialize(obj.skuOrderList),
                                        JSON.serialize(obj.distributerWrapObj), obj.initDetailsWrap.orderRaisedBy,
                                        obj.orderObj, true, so);
        obj.skuOrderList[0].finalPrice = 12;
        OrderMexicoCmpController.updateSKU(JSON.serialize(obj.skuOrderList), 0, true);
        OrderMexicoCmpController.deleteSKU(JSON.serialize(obj.skuOrderList), 0, true);
        test.stopTest();
    }
    
    private static testMethod void testDeleteSKU_SO(){
        test.startTest();
        Sales_Order__c so = [SELECT Id,Payment_Term__c FROM Sales_Order__c LIMIT 1];
        OrderMexicoCmpController.WrapperData obj = new OrderMexicoCmpController.WrapperData();
        obj = OrderMexicoCmpController.initializeDetails(String.valueOf(so.Id));
        Crop__c crop1 = [SELECT Id FROM Crop__c WHERE Name = 'Apple' LIMIT 1];
        
        obj.skuObjList[0].crop1 = crop1.Id;
        obj.skuObjList[0].crop1_Percentage = 100;
        obj.skuObjList[0].qty = 50;
        obj.skuObjList[0].finalPrice = 13;
        obj.skuObjList[0].typeOfSale = 'Real Sale';
        
        OrderMexicoCmpController.addSKU(JSON.serialize(obj.skuObjList[0]), JSON.serialize(obj.skuOrderList),
                                        JSON.serialize(obj.distributerWrapObj), obj.initDetailsWrap.orderRaisedBy,
                                        obj.orderObj, true, so);
        obj.skuOrderList[0].finalPrice = 14;
        OrderMexicoCmpController.updateSKU(JSON.serialize(obj.skuOrderList), 0, true);
        List<OrderMexicoCmpController.SKUDetails> skuList = OrderMexicoCmpController.deleteAllSKU(JSON.serialize(obj.skuOrderList), true);
        System.assert(skuList.isEmpty());
        test.stopTest();
    }
    
    private static testMethod void testConfirmOrder(){
       
        Account acc = [SELECT Id FROM Account WHERE SAP_Code__c = 'SAP996734' LIMIT 1];
        OrderMexicoCmpController.WrapperData obj = new OrderMexicoCmpController.WrapperData();
        obj = OrderMexicoCmpController.initializeDetails(String.valueOf(acc.Id));
        Crop__c crop1 = [SELECT Id FROM Crop__c WHERE Name = 'Apple' LIMIT 1];
        
        
        obj.skuObjList[0].crop1 = crop1.Id;
        obj.skuObjList[0].crop1_Percentage = 100;
        obj.skuObjList[0].qty = 50;
        obj.skuObjList[0].finalPrice = 15;
        obj.skuObjList[0].typeOfSale = 'Real Sale';
        System.debug('in test class obj.skuObjList pack Name  '+obj.skuObjList[0].skuPackName);
        System.debug('in test class obj.skuObjList currency '+obj.skuObjList[0].currencyIso);
        
        
        OrderMexicoCmpController.addSKU(JSON.serialize(obj.skuObjList[0]), JSON.serialize(obj.skuOrderList),
                                        JSON.serialize(obj.distributerWrapObj), obj.initDetailsWrap.orderRaisedBy,
                                        obj.orderObj, false, null);
        Payment_Method__c payMethod = [SELECT Id FROM Payment_Method__c LIMIT 1];
        Payment_Term__c payTerm = [SELECT Id FROM Payment_Term__c LIMIT 1];
        Inco_Term__c incoTerm = [SELECT Id FROM Inco_Term__c LIMIT 1];
        Depot__c depo = [SELECT Id FROM Depot__c WHERE RecordType.Name = 'Storage Location' LIMIT 1];
        Shipping_Location__c ship = [SELECT Id FROM Shipping_Location__c WHERE Region__c = 'Pune' LIMIT 1];
        OrderMexicoCmpController.ShippingLocationWrapper shipWrap = new OrderMexicoCmpController.ShippingLocationWrapper();
        shipWrap.locationId = ship.Id;
        Date poDate=System.today()+1;
        test.startTest();
        List<Sales_Order__c> soList = OrderMexicoCmpController.confirmOrder(JSON.serialize(obj.skuOrderList), obj.orderObj, 'Test Template', 
                                                                            3000, payMethod.Id, payTerm.Id,
                                                                            incoTerm.Id, JSON.serialize(obj.initDetailsWrap), depo.Id,
                                                                            '12345', JSON.serialize(obj.distributerWrapObj),
                                                                            JSON.serialize(shipWrap),
                                                                            false, null, 'Test Remark', 'Sales Team',poDate);
        System.assert(soList.size() > 0);
        
        OrderTemplate__c temp = [SELECT Id, Name FROM OrderTemplate__c LIMIT 1];
        
        OrderMexicoCmpController.showOrderTemplates(JSON.serialize(obj.initDetailsWrap));
        OrderMexicoCmpController.loadTemplate(obj.orderObj, temp.Id, JSON.serialize(obj.initDetailsWrap), JSON.serialize(obj.distributerWrapObj));
        OrderMexicoCmpController.fetchProfitCenter();
         test.stopTest();
        Sales_Order__c so = [SELECT Id,Sent_for_Latam_Director_Approval__c FROM Sales_Order__c LIMIT 1];
        Date poDate1 = System.today()+2;
        
        List<Sales_Order__c> soList2 = OrderMexicoCmpController.confirmOrder(JSON.serialize(obj.skuOrderList), obj.orderObj, 'Test Template', 
                                                                             3000, payMethod.Id, payTerm.Id,
                                                                             incoTerm.Id, JSON.serialize(obj.initDetailsWrap), depo.Id,
                                                                             '12345', JSON.serialize(obj.distributerWrapObj),
                                                                             JSON.serialize(shipWrap),
                                                                             true, so, 'Test Remark', 'Sales Team',poDate1);
        
       
    }
    
    
    
}