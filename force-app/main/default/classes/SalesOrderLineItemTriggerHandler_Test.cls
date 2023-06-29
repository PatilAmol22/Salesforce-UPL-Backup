@isTest
public class SalesOrderLineItemTriggerHandler_Test{
   
    @testSetup
    static void setupMethod(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        Insert Pg;
        
        Zone__c z1 = new Zone__c();
        z1.ZoneCode__c = 'BR15';
        insert z1;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        Insert auto;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Mexico';
        sorg.Description__c='Mexico';
        sorg.Sales_Org_Code__c='5100';
        Insert sorg;
        
        Sales_Org__c sorgBRL =new Sales_Org__c();
        sorgBRL.Name='Brazil';
        sorgBRL.Description__c='Brazil';
        sorgBRL.Sales_Org_Code__c='5191';
        Insert sorgBRL;
        
        Crop__c crops = new Crop__c();
        crops.active__c=true;
        crops.name = 'Apple';
        crops.SalesOrg__c = sorg.id;
        crops.CurrencyIsoCode='INR';
        Insert crops;
        
        Crop__c crops2 = new Crop__c();
        crops2.active__c=true;
        crops2.name = 'Lemon';
        crops2.SalesOrg__c = sorg.id;
        crops2.CurrencyIsoCode='INR';
        Insert crops2;
        
        Crop__c crops3 = new Crop__c();
        crops3.active__c=true;
        crops3.name = 'Tomato';
        crops3.SalesOrg__c = sorg.id;
        crops3.CurrencyIsoCode='INR';
        Insert crops3;
        
        Crop__c crops4 = new Crop__c();
        crops4.active__c=true;
        crops4.name = 'Orange';
        crops4.SalesOrg__c = sorg.id;
        crops4.CurrencyIsoCode='INR';
        Insert crops4;
        
        Crop__c crops5 = new Crop__c();
        crops5.active__c=true;
        crops5.name = 'Other';
        crops5.SalesOrg__c = sorg.id;
        crops5.CurrencyIsoCode='INR';
        Insert crops5;
        
        Crop__c crops6 = new Crop__c();
        crops6.active__c = true;
        crops6.name = 'Planta';
        crops6.SalesOrg__c = sorg.id;
        crops6.CurrencyIsoCode='INR';
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
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='L';
        sku.Active__c=True;
        sku.Brand_Name__c='SPERTO';
        sku.Combination_Key__c='Cooooooo000011111';
        Insert sku;
        
        SKU__c sku2 = new SKU__c();
        sku2.Name='P2';
        sku2.SKU_Code__c='704001';
        sku2.SKU_Pack__c = 1.00;
        sku2.SKU_UOM__c='L';
        sku2.Multiple_Of__c=5;
        sku2.Group__c='P2';
        sku2.Pack_Size__c=10.00;
        sku2.Product_Name__c=pro.Id;
        sku2.Sales_Org__c = sorg.Id;
        sku2.UOM__c='L';
        sku2.Active__c=True;
        sku2.Brand_Name__c='SPERTO';
        sku2.Combination_Key__c='Cooooooo000012111';
        Insert sku2;
        
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
            Payment_Term__c = 'Contado',  
            Payterms_Desc__c = 'Contado',
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
        
     /*   Profile p = [SELECT Id,name FROM Profile WHERE Name = 'PartnerCommunity Distributor Profile'];
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
        Insert sobj1;*/
        
        Sales_Org__c salesOrg  = new Sales_Org__c();
        salesOrg.Name = 'Mexico';
        salesOrg.Company_Code__c = '5000';
        salesOrg.Country_Code__c = 'MX';
        salesOrg.Sales_Org_Code__c = '5100';
        Insert salesOrg;
        
      /*  TM_Depot_Mapping__c TMDepoMap = new TM_Depot_Mapping__c();
        TMDepoMap.Depot__c = dp.Id;        // Depot
        TMDepoMap.Territory_Manager__c = sobj1.id;  // Territory Manager
        Insert TMDepoMap;*/
        
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
        ordTempItem.SKU__c = sku.Id;
        Insert ordTempItem;
        
        State_Tax_Structure__c statetax = new State_Tax_Structure__c();
        statetax.State_Name__c = 'Maharashtra';
        statetax.Country__c = 'Indonesia';          
        statetax.Tax__c = 10;           
        statetax.State_Code__c = '13';
        statetax.AdditionalTax__c = 30;
        statetax.SalesOrg__c = sorg.Id;
        Insert statetax;
        
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
        Insert ord;
        
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
        Insert ordItem; 
        
        OrderLineItem__c ordItem2 = new OrderLineItem__c();
        ordItem2.Item_Status__c = 'test';          
        ordItem2.SKU_Name__c = sku2.Id; 
        ordItem2.Item_Number__c = '20';          
        ordItem2.UOM__c = 'L';                   
        ordItem2.No_of_Case__c = 1;            
        ordItem2.Invoice_Discount__c = 0.00;     
        ordItem2.Quantity__c = 100;          
        ordItem2.Special_Discount__c = 0.00;     
        ordItem2.Price__c = 23900;            
        ordItem2.Order__c = ord.Id;    
        ordItem2.Stock_Available__c = false;
        Insert ordItem2; 
        
        
          Rejection_Status__c ob= new Rejection_Status__c();
        ob.Rejection_Description__c='12345';
        ob.Rejection_Code__c='12323';
        insert ob;
        
          

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
     
        so.GP_Lista__c=30000.000;
        Insert so;
        
        Sales_Order_Line_Item__c sliObj = new Sales_Order_Line_Item__c();
        sliObj.SKU_Name__c = sku.Id;
        sliObj.Item_Number__c = 10;
        sliObj.Rejection_Code__c=ob.id;
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
        sliObj.DateofFAT__c = date.today();
        sliObj.New_Date_of_FAT__c = date.today() + 1;
        sliObj.Date_Of_FAT_Changed__c = true;
        sliObj.New_Quantity__c=100;
        Insert sliObj;
        
        Sales_Order_Line_Item__c sliObj2 = new Sales_Order_Line_Item__c();
        sliObj2.SKU_Name__c = sku2.Id;
        sliObj2.Item_Number__c = 20;
         sliObj2.Rejection_Code__c=ob.id;
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
        sliObj2.Net_Price__c = 150;
        sliObj2.Price__c = 1500;
        sliObj2.Sale_Order__c = so.Id;
        sliObj2.New_Quantity__c = 100;
        Insert sliObj2;
        
        Pincode_Depot_Code_Mapping__c custSett = new Pincode_Depot_Code_Mapping__c();
        custSett.Name = 'C1';
        custSett.Pin_Code__c = '44900';
        custSett.Depot_Code__c = 'MW22';
        Insert custSett;
                 List<Inventory_Control__c> invlist = new List<Inventory_Control__c>();

         Inventory_Control__c f1 = new Inventory_Control__c();
        f1.BU__c = '5191';
        f1.Product__c='SPERTO';
        f1.Product_Name__c = Pro.id;
        f1.Quantity__c = 1000;
        f1.Fiscal_Year__c = '22/23';
        invlist.add(f1);
         Inventory_Control__c f2 = new Inventory_Control__c();
         f2.BU__c = '5191';
        f2.Product__c='SPERTO';
        f2.Product_Name__c = Pro.id;
        f2.Quantity__c = 1000;
        f2.Fiscal_Year__c = '23/24';
        invlist.add(f2);
         Inventory_Control__c f3 = new Inventory_Control__c();
         f3.BU__c = '5191';
        f3.Product__c='SPERTO';
        f3.Product_Name__c = Pro.id;
        f3.Quantity__c = 1000;
        f3.Fiscal_Year__c = '21/22';
        invlist.add(f3);
        insert invlist; 
        
      list<Sales_Order_Line_Item__c> lineItemList= new list<Sales_Order_Line_Item__c>();
        lineItemList.add(sliObj);
        
        map<id,Sales_Order_Line_Item__c> oldSalesMap= new map<id,Sales_Order_Line_Item__c>();
        oldSalesMap.put(sliObj2.Id,sliObj2);
        SalesOrderLineItemTriggerHandler.updateRejectionReason(lineItemList,null);
       

    }
    
    private static testMethod void testInitializeDetails_Acc(){
        test.startTest();
        Account acc = [SELECT Id FROM Account WHERE SAP_Code__c = 'SAP996734' LIMIT 1];
        Sales_Order__c so = [SELECT Id FROM Sales_Order__c LIMIT 1];
       
        test.stopTest();
    }
    
    private static testMethod void inventoryTest(){
        test.startTest();
        Account acc = [SELECT Id FROM Account WHERE SAP_Code__c = 'SAP996734' LIMIT 1];
        Sales_Order__c so = [SELECT Id FROM Sales_Order__c LIMIT 1];
        list<Sales_Order_Line_Item__c> lineItemList= new list<Sales_Order_Line_Item__c>();
        lineItemList =   [select id,Item_Status__c,Sale_Order__c,SKU_Name__c,SKU_Name__r.Brand_Name__c,Quantity__c,New_Quantity__c,Unbilled_Quatity__c,Sales_Org_Code__c from Sales_Order_Line_Item__c where Sale_Order__c=:so.id ];
        for(Sales_Order_Line_Item__c i : lineItemList){
        i.DateofFAT__c= Date.today();
        i.New_Date_of_FAT__c = Date.today()+1;
        }
        update lineItemList;
       SalesOrderLineItemTriggerHandler.changedateofFAT(lineItemList);
        SalesOrderLineItemTriggerHandler.CancelItemHandle(lineItemList);
          SalesOrderLineItemTriggerHandler.ProductCancellation(lineItemList);
           // SalesOrderLineItemTriggerHandler.changeDOFQTY(lineItemList);
           SalesOrderLineItemTriggerHandler.inventorycontrol(lineItemList);
            SalesOrderLineItemTriggerHandler.QuantityChangeHandle(lineItemList);
            SalesOrderLineItemTriggerHandler.onAfterInsert(lineItemList);
        test.stopTest();
    }
     private static testMethod void inventoryTest1(){
        test.startTest();
        
        Zone__c oZone = [select id from Zone__c limit 1];
        Sales_Org__c sorgBRL = [select id from Sales_Org__c where Sales_Org_Code__c = '5191' limit 1];
        Sales_Org__c sorg = [select id from Sales_Org__c where Sales_Org_Code__c = '5100' limit 1];
        
        Territory_Distributor__c ObjTD = new Territory_Distributor__c();
        ObjTD.Name = 'Test';
        ObjTD.Zone__c = oZone.Id;
        ObjTD.SalesOrg__c = sorgBRL.Id;
        ObjTD.TerritoryManager__c = UserInfo.getUserId();
        insert ObjTD;
        
       /* Inventory_Control__c ObjInv = new Inventory_Control__c();
        ObjInv.Quantity__c = 12345678;
        ObjInv.Product__c = 'SPERTO';
        ObjInv.Fiscal_Year__c = '22/23';
        ObjInv.BU__c = '5191';
        insert ObjInv;*/
        
        Account acc = [SELECT Id FROM Account WHERE SAP_Code__c = 'SAP996734' LIMIT 1];
        Sales_Order__c so = [SELECT Id FROM Sales_Order__c LIMIT 1];
        list<Sales_Order_Line_Item__c> lineItemList= new list<Sales_Order_Line_Item__c>();
        lineItemList =   [select id,Item_Status__c,Sale_Order__c,SKU_Name__c,SKU_Name__r.Brand_Name__c,Quantity__c,New_Quantity__c,Unbilled_Quatity__c,Sales_Org_Code__c from Sales_Order_Line_Item__c where Sale_Order__c=:so.id ];
        for(Sales_Order_Line_Item__c i : lineItemList){
        i.DateofFAT__c= Date.today();
        i.New_Date_of_FAT__c = Date.today()+1;
            i.Item_Status__c='Cancel';
        }
        update lineItemList;
      /// SalesOrderLineItemTriggerHandler.changedateofFAT(lineItemList);
      //  SalesOrderLineItemTriggerHandler.CancelItemHandle(lineItemList);
          SalesOrderLineItemTriggerHandler.ProductCancellation(lineItemList);
            SalesOrderLineItemTriggerHandler.changeDOFQTY(lineItemList);
          // SalesOrderLineItemTriggerHandler.inventorycontrol(lineItemList);
           // SalesOrderLineItemTriggerHandler.QuantityChangeHandle(lineItemList);
           // SalesOrderLineItemTriggerHandler.onAfterInsert(lineItemList);
        test.stopTest();
    }
    
    private static testMethod void inventoryTest2(){
        test.startTest();
        Account acc = [SELECT Id FROM Account WHERE SAP_Code__c = 'SAP996734' LIMIT 1];
        Sales_Order__c so = [SELECT Id FROM Sales_Order__c LIMIT 1];
        list<Sales_Order_Line_Item__c> lineItemList= new list<Sales_Order_Line_Item__c>();
        lineItemList =   [select id,Item_Status__c,Sale_Order__c,SKU_Name__c,SKU_Name__r.Brand_Name__c,Quantity__c,New_Quantity__c,Unbilled_Quatity__c,Sales_Org_Code__c from Sales_Order_Line_Item__c where Sale_Order__c=:so.id ];
        for(Sales_Order_Line_Item__c i : lineItemList){
        i.DateofFAT__c= Date.newInstance(2023, 01, 01);
        i.New_Date_of_FAT__c = Date.newInstance(2023, 01, 03);
        }
        update lineItemList;
       /* List<Inventory_Control__c> invlst = new List<Inventory_Control__c>();
          invlst = [select id,BU__c,Product__c,Quantity__c,Fiscal_Year__c from Inventory_Control__c where Product__c='SPERTO'];
        for(Inventory_Control__c inv : invlst){
        inv.BU__c= 'BR15';
        }
        update invlst;*/
       
        
       SalesOrderLineItemTriggerHandler.changedateofFAT(lineItemList);
        SalesOrderLineItemTriggerHandler.CancelItemHandle(lineItemList);
          SalesOrderLineItemTriggerHandler.ProductCancellation(lineItemList);
           // SalesOrderLineItemTriggerHandler.changeDOFQTY(lineItemList);
           SalesOrderLineItemTriggerHandler.inventorycontrol(lineItemList);
            SalesOrderLineItemTriggerHandler.QuantityChangeHandle(lineItemList);
            SalesOrderLineItemTriggerHandler.onAfterInsert(lineItemList);
        test.stopTest();
    }
  private static testMethod void inventoryTest3(){
        test.startTest();
        
        Account acc = [SELECT Id FROM Account WHERE SAP_Code__c = 'SAP996734' LIMIT 1];
        Sales_Order__c so = [SELECT Id FROM Sales_Order__c LIMIT 1];
        Sales_Org__c sorgBRL = [select id from Sales_Org__c where Sales_Org_Code__c = '5191' limit 1];

        list<Sales_Order_Line_Item__c> lineItemList= new list<Sales_Order_Line_Item__c>();
        lineItemList =   [select id,Item_Status__c,Sale_Order__c,SKU_Name__c,SKU_Name__r.Brand_Name__c,Quantity__c,New_Quantity__c,Quantity_Billed__c,Unbilled_Quatity__c,Sales_Org_Code__c from Sales_Order_Line_Item__c where Sale_Order__c=:so.id ];
        for(Sales_Order_Line_Item__c i : lineItemList){
            i.Quantity_Billed__c=123.00;
        i.DateofFAT__c= Date.newInstance(2022, 01, 01);
        i.New_Date_of_FAT__c = Date.newInstance(2023, 01, 03);
        }
        update lineItemList;
       /* List<Inventory_Control__c> invlst = new List<Inventory_Control__c>();
          invlst = [select id,BU__c,Product__c,Quantity__c,Fiscal_Year__c from Inventory_Control__c where Product__c='SPERTO'];
        for(Inventory_Control__c inv : invlst){
        inv.BU__c= 'BR15';
        }
        update invlst;*/
       
          SalesOrderLineItemTriggerHandler.changeDOFQTY(lineItemList);
       SalesOrderLineItemTriggerHandler.changedateofFAT(lineItemList);
        SalesOrderLineItemTriggerHandler.CancelItemHandle(lineItemList);
          SalesOrderLineItemTriggerHandler.ProductCancellation(lineItemList);
           // SalesOrderLineItemTriggerHandler.changeDOFQTY(lineItemList);
           SalesOrderLineItemTriggerHandler.inventorycontrol(lineItemList);
            SalesOrderLineItemTriggerHandler.QuantityChangeHandle(lineItemList);
            SalesOrderLineItemTriggerHandler.onAfterInsert(lineItemList);
           so.Sales_Org_lk__c = sorgBRL.id;
           update so;
           set<Id> setid = new set<Id>{so.Id};
            SalesOrderLineItemTriggerHandler.gpLista(setid);
                

      
        test.stopTest();
    }
}