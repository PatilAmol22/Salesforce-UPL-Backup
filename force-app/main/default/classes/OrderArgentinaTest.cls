@isTest
public class OrderArgentinaTest {

 static final Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
 static final Id dprecordId = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Storage Location').getRecordTypeId();
       
    
    //testing data setup for all methods in this class
    @testSetup
    static void allTheDataForThisTestClass() {
       Test.startTest();  //RITM0506556 - iminate or put on hold the last level of the margin block approval matrix.
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Argentina';
        sorg.Description__c='Argentina';
        sorg.Sales_Org_Code__c='5631';
        insert sorg;
        
        
        
        Order_Type__c  orderTypeObj = new Order_Type__c(
            Name = 'ZXOR',                  // Order Type Name
            Description__c = 'Factura',     // Description
            Order_Type_Code__c = 'ZXOR',      // Order Type Code
            SalesOrg__c = sorg.Id  // Sales Org
        );
        insert orderTypeObj;
        
         Order_Type__c  orderTypeObj1 = new Order_Type__c(
            Name = 'Consignatario',                  // Order Type Name
            Description__c = 'Consignatario',     // Description
            Order_Type_Code__c = 'Consignatario',      // Order Type Code
            SalesOrg__c = sorg.Id  // Sales Org
        );
        insert orderTypeObj1;
        
         Order_Type__c  orderTypeObj2 = new Order_Type__c(
            Name = 'Commission Sales',                  // Order Type Name
            Description__c = 'Commission Sales',     // Description
            Order_Type_Code__c = 'Commission Sales',      // Order Type Code
            SalesOrg__c = sorg.Id  // Sales Org
        );
        insert orderTypeObj2;
        
          Payment_Method__c paymentMethodObj = new Payment_Method__c(
            Name = 'Contado',                   // Payment Method Name
            Sales_Org__c = sorg.Id,      // Sales Org
            Payment_Method_Code__c = 'C1',     // Payment Method Code
            Active__c = true                  // Active
        );
        insert paymentMethodObj;
        
        
        Payment_Term__c paymentTermObj = new Payment_Term__c(
            Payment_Term_Code__c = '0015',                     // Payment Term Code
            Payment_Term__c = '30 dias',                         // Payment Term
            Payterms_Desc__c = 'Pagamento estrito em 30 dias.',  // Payterms Desc
            Maturity_Date_Mandatory__c = 'Yes',                  // Maturity Date Mandatory
            Sales_Org__c = sorg.Id,                    // Sales Org
            Active__c = false                                   // Active
        );
        insert paymentTermObj;
        
        Payment_Method_Payment_Term_Mapping__c pmpt = new Payment_Method_Payment_Term_Mapping__c();
        pmpt.Payment_Method__c = paymentMethodObj.Id;
        pmpt.Payment_Term__c = paymentTermObj.Id;
        pmpt.Discount__c = 5;
        insert pmpt;
        
        Depot__c dp =new Depot__c ();
        dp.Name='Argentina';
        dp.Country__c='Argentina';
        dp.Location__c='Charata';
        dp.SalesOrg__c=sorg.Id;
        dp.Depot_Code__c='PUN1';
        dp.Sequence_Number__c = 1;
        dp.RecordTypeId = dprecordId;
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
        
        SKU__c sku = new SKU__c();
        sku.Name='DOST';
        sku.SKU_Code__c='704002';
        sku.SKU_Pack__c=1.00;
        sku.SKU_UOM__c='L';
        sku.Group__c='DOST';
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='L';
        sku.Active__c=True;
        sku.Combination_Key__c='Cooooooo000011111';
        sku.Multiple_of__c = 5.00;
        sku.Brand_Name__c = 'DOST';
        sku.CurrencyIsoCode = 'USD';
        insert sku;
         //Added by Nandhini-APPS-5287
        SKU__c sku1 = new SKU__c();
        sku1.Name='DOST1';
        sku1.SKU_Code__c='704003';
        sku1.SKU_Pack__c=1.00;
        sku1.SKU_UOM__c='KG';
        sku1.Group__c='DOST1';
        sku1.Pack_Size__c=10.00;
        sku1.Product_Name__c=pro.Id;
        sku1.Sales_Org__c = sorg.Id;
        sku1.UOM__c='L';
        sku1.Active__c=True;
        sku1.Combination_Key__c='Cooooooo000011341';
        sku1.Multiple_of__c = 5.00;
        sku1.Brand_Name__c = 'DOST1';
        sku1.CurrencyIsoCode = 'USD';
        insert sku1;
        
        PriceBookMaster__c PbMaster = new PriceBookMaster__c(
            BudgetPrice__c = 5.00,                                        // Budget Price
            SKUCode__c = sku.id,                               // SKU Code
            MinPrice__c = 5.20,                                           // Min Price
            DepotCode__c = dp.id,                             // Depot Code
            Price__c = 7.00,
            PG_CODE__c =Pg.Id,                           // Price
            UOM__c = 'KG',                                                // UOM
            StartDate__c = system.today(),                      // Start Date            
            EndDate__c = system.today()+1,                       // End Date
           // DistributionChannel__c = 'a0x0k000000IQiV',                   // Distribution Channel
            Active__c = true,                                            // Active
            PerUnit__c = 1, 
            Batch__c ='test',
            CompositeKey__c = 'c1',  // CompositeKey
            Sales_Org__c = sorg.id,                             // Sales Org
            Price_Book_Change__c = false,			// Price_Book_Change
            CurrencyIsoCode = 'USD'
        );
        insert PbMaster; 
          //Added by Nandhini-APPS-5287
         PriceBookMaster__c PbMaster1 = new PriceBookMaster__c(
            BudgetPrice__c = 5.00,                                        // Budget Price
            SKUCode__c = sku1.id,                               // SKU Code
            MinPrice__c = 5.20,                                           // Min Price
            DepotCode__c = dp.id,                             // Depot Code
            Price__c = 7.00,
            PG_CODE__c =Pg.Id,                           // Price
            UOM__c = 'L',                                                // UOM
            StartDate__c = system.today(),                      // Start Date            
            EndDate__c = system.today()+1,                       // End Date
           // DistributionChannel__c = 'a0x0k000000IQiV',                   // Distribution Channel
            Active__c = true,                                            // Active
            PerUnit__c = 1, 
            Batch__c ='test',
            CompositeKey__c = 'c123',  // CompositeKey
            Sales_Org__c = sorg.id,                             // Sales Org
            Price_Book_Change__c = false,			// Price_Book_Change
            CurrencyIsoCode = 'USD'
        );
        insert PbMaster1;
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZXOR';              
        ordType.Description__c = 'Factura';    
        ordType.Order_Type_Code__c = 'ZXOR';
        insert ordType;
        
        Order_Type__c ordType1 =new Order_Type__c();
        ordType1.Name = 'Consignatario';              
        ordType1.Description__c = 'Consignatario';    
        ordType1.Order_Type_Code__c = 'Consignatario';
        insert ordType1;
        
        
        
        Account acc = new Account();
        acc.Name='Bhavik Devdhar';
        acc.Last_Name__c='Devdhar';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Raise_Order_Type__c = 'Factura';
        acc.Mobile__c='9967341759';
        acc.Phone='020256589';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Charata';
        acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        acc.CurrencyIsoCode = 'USD';
        //acc.OwnerId=sobj.Id;
        insert acc;
        
        Payments__c sobj = new Payments__c(
            Customer_Name__c = acc.Id,// Customer Name
            Bounce__c = 0.00,                      // Bounce
            X1_15__c = 0.00,                       // 1 - 15
            X16_30__c = 0.00,                      // 16-30
            X31_60__c = 0.00,                      // 31-60
            Forecasted_Collection__c = 0.00,       // Forecasted Collection
            X61_90__c = 0.00,                      // 61-90
            Net_Overdue__c = 37195.20,             // Net Overdue
            X91_120__c = 0.00,                     // 91-120
            Total_Collectibles__c = 37195.20,      // Total Collectibles
            Total_Collection__c = 0.00,            // Total Collection
            Non_Forecasted_Collection__c = 0.00   // Non-Forecasted Collection
            
        );
        insert sobj;
        
        contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName=acc.Last_Name__c;
        insert con;
        
        userrole  usrole = new userrole();
        usrole.Name ='Regional Manager';
        
        userrole  usrole1 = new userrole();
        usrole1.Name ='Territory Manager';
       
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Sales Head Argentina'];
        
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
        sobj1.CurrencyIsoCode='USD';
        //sobj1.ContactId=con.Id;
        insert sobj1;
        
        
        User sobj2 = new User();
        sobj2.Alias = 'zonaa';                                                            
        sobj2.Email = 'himanshqua.mehta@skinternational.com';                             
        sobj2.ProfileId  = p.ID;                                                     
        sobj2.Username = 'zonal1_aaexe1232@upl122333.com.devbox';                                    
        sobj2.IsActive = true;  
        sobj2.LastName='Regional Manager';
        sobj2.CommunityNickname = 'zonalExe1222 Dil'; 
        sobj2.TimeZoneSidKey = 'Asia/Kolkata'; 
        // sobj1.Contact.AccountID = acc.id;// Time Zone
        sobj2.LocaleSidKey = 'en_IN';                                    
        sobj2.LanguageLocaleKey = 'en_US';                                             
        sobj2.ForecastEnabled = false;                                                     
        sobj2.EmailEncodingKey = 'ISO-8859-1';    
        sobj2.Show_Inventory__c = false;                                                     
        sobj2.Show_Credit_Limit__c = false; 
        sobj2.UserRoleId=usrole1.id;
        sobj2.CurrencyIsoCode='USD';
        //sobj1.ContactId=con.Id;
        insert sobj2;
        
        TM_Depot_Mapping__c TMDepoMap = new TM_Depot_Mapping__c();
        TMDepoMap.Depot__c = dp.Id;        // Depot
        TMDepoMap.Territory_Manager__c = sobj1.id;  // Territory Manager
        insert TMDepoMap;
        
        Shipping_Location__c shippLoc =new Shipping_Location__c();
        shippLoc.Location_Name__c ='Same as Billing Address'; 
        shippLoc.Region__c='S.No:46/1, A1 Building, First Floor, Office No.101 E-Space, Wadgoan Sheri,Nagar Rd, Aga Nagar,';
        shippLoc.Distributor__c=acc.Id;
        shippLoc.City__c='Charata';
        shippLoc.Sales_Org__c=sorg.Id;
        shippLoc.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc.SAP_Code__c='SAP0001';
        shippLoc.State__c='01';
        insert shippLoc;
        
        Shipping_Location__c shippLoc2 =new Shipping_Location__c();
        shippLoc2.Location_Name__c ='Mumbai'; 
        shippLoc2.Region__c='S.No:46/1, A1 Building, First Floor, Office No.101 E-Space, Wadgoan Sheri,Nagar Rd, Aga Nagar,';
        shippLoc2.Distributor__c=acc.Id;
        shippLoc2.City__c='Charata';
        //shippLoc2.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc2.SAP_Code__c = acc.SAP_Code__c;
        shippLoc2.State__c='01';
        shippLoc2.Sales_Org__c=sorg.Id;
        insert shippLoc2;
        
        Inventory__c invObj = new Inventory__c( );
        invObj.Stock_Quantity__c = 10;   
        invObj.Batch_Number__c = 'CMUMTX2506'; 
        invObj.Depot__c = dp.Id;    
        invObj.UOM__c = 'L';                    
        invObj.Storage_Location__c = 'MAIN';    
        invObj.SKU__c = sku.Id;
        invObj.Storage_Location_Depot__c =dp.Id;
        invObj.SKU_Depot__c ='sd1';           
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
        crdIf.Sales_Org__c= sorg.Id;
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
        
        Order__c ord = new Order__c();
        ord.Shipping_Location__c = shippLoc.id;  
        ord.Bill_To_Party__c = acc.Id;        
        ord.Order_Date__c = system.today();  
        ord.Order_Raise_By__c = 'Distributor';                                     
        ord.Order_Status__c = 'Pending';                                        
        ord.Sales_Org__c =sorg.Id;          
        ord.Distribution_Channel__c =disbj.Id; 
        ord.Division__c = Divbj.Id;
        ord.Remarks__c ='test remark';
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
        ordItem.CurrencyIsoCode = 'USD';
       // ordItem.Shipping_Location__c=shippLoc.Id;
        insert ordItem; 
        
        
        OrderLineItem__c ordItem1 = new OrderLineItem__c();
        ordItem1.Item_Status__c = 'test';          
        ordItem1.SKU_Name__c = sku1.Id; 
        ordItem1.Item_Number__c = '10';          
        ordItem1.UOM__c = 'L';                   
        ordItem1.No_of_Case__c = 1;            
        ordItem1.Invoice_Discount__c = 0.00;     
        ordItem1.Quantity__c = 100;          
        ordItem1.Special_Discount__c = 0.00;     
        ordItem1.Price__c = 23000;            
        ordItem1.Order__c = ord.Id;    
        ordItem1.Stock_Available__c = false;
        ordItem1.CurrencyIsoCode = 'USD';
        insert ordItem1;
        
        Login_Country__c logCountryObj = new Login_Country__c();
        logCountryObj.Name ='Argentina'; 
        logCountryObj.For_Contry__c ='Argentina';
        logCountryObj.Sales_Org_Code__c ='5631';
        logCountryObj.Delivery_Date__c = false;
        insert logCountryObj;
        
        Admin_MPT_Colombia__c adminMPT = new Admin_MPT_Colombia__c();
        adminMPT.Active__c = true;
        adminMPT.Approval_Level__c = 'Level 2';
        adminMPT.Sales_Org__c = sorg.Id;
        adminMPT.Level_3_below__c = 15;
        adminMPT.Level_2_min__c = 15.01;    
        adminMPT.Level_2_max__c = 20.00;
        adminMPT.Level_1_min__c = 20.01;
        adminMPT.Level_1_max__c = 30.00;
        insert adminMPT;
        
        Blanket_SKU__c bSKU = new Blanket_SKU__c();
        bSKU.SKU__c= sku.id;
        bSKU.Sales_Org__c = sorg.Id;
        bSKU.Start_Date__c = System.today();   
        bSKU.End_Date__c = System.today();
        bSKU.Status__c = false;
        insert bSKU;
          //Added by Nandhini-APPS-5287
        Blanket_SKU__c bSKU1 = new Blanket_SKU__c();
        bSKU1.SKU__c= sku.id;
        bSKU1.Sales_Org__c = sorg.Id;
        bSKU1.Start_Date__c = System.today();   
        bSKU1.End_Date__c = System.today();
        bSKU1.Status__c = false;
        insert bSKU1; 
        
        Profit_Center__c pc = new Profit_Center__c();
        pc.Sales_Org__c = sorg.Id;
        pc.Profit_Center__c = 'P0000';
        pc.Sales_Value__c = 3;
        insert pc;
        
        
        Price_Block_Margin_Matrix__c e2eCost = new Price_Block_Margin_Matrix__c();
        e2eCost.E2E_Cost_USD__c = 2;
        e2eCost.Type__c = 'E2ECost';
        e2eCost.Profit_Center__c = pc.Id;
        e2eCost.UOM__c = 'KG';
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
        e2eCost1.SKU_Code__c = sku.id;
        e2eCost1.CurrencyIsoCode = 'USD';
        insert e2eCost1;
        
        Price_Block_Margin_Matrix__c e2eCost2 = new Price_Block_Margin_Matrix__c();
        e2eCost2.E2E_Cost_USD__c = 3;
        e2eCost2.Type__c = 'E2ECost';
        e2eCost2.Profit_Center__c = pc.Id;
        e2eCost2.UOM__c = 'L';
        e2eCost2.Start_Date__c = System.today();
        e2eCost2.End_Date__c = System.today().addDays(5);
        e2eCost2.Depot_Code__c = dp.Id;
        e2eCost2.Sales_Org__c = sorg.Id;
        e2eCost2.SKU_Code__c = sku1.id;
        e2eCost2.CurrencyIsoCode = 'USD';
        insert e2eCost2;
        
        Price_Block_Margin_Matrix__c e2eUPC9 = new Price_Block_Margin_Matrix__c();
        e2eUPC9.E2E_Cost_UPC9_USD__c = 2;
        e2eUPC9.Type__c = 'E2ECostUPC9';
        e2eUPC9.Profit_Center__c = pc.Id;
        e2eUPC9.UOM__c = 'KG';
        e2eUPC9.Start_Date__c = System.today();
        e2eUPC9.End_Date__c = System.today().addDays(5);
        e2eUPC9.Depot_Code__c = dp.Id;
        e2eUPC9.Sales_Org__c = sorg.Id;
        e2eUPC9.SKU_Code__c = sku.id;
        e2eUPC9.CurrencyIsoCode = 'USD';
        insert e2eUPC9;
        
        Price_Block_Margin_Matrix__c e2eMBEW = new Price_Block_Margin_Matrix__c();
        e2eMBEW.E2E_Cost_MBEW_USD__c = 2;
        e2eMBEW.Type__c = 'E2ECostMBEW';
        e2eMBEW.Profit_Center__c = pc.Id;
        e2eMBEW.UOM__c = 'KG';
        e2eMBEW.Start_Date__c = System.today();
        e2eMBEW.End_Date__c = System.today().addDays(5);
        e2eMBEW.Depot_Code__c = dp.Id;
        e2eMBEW.Sales_Org__c = sorg.Id;
        e2eMBEW.SKU_Code__c = sku.id;
        e2eMBEW.CurrencyIsoCode = 'USD';
        insert e2eMBEW;
        
        UOM_Conversion__c uom = new UOM_Conversion__c();
        uom.Base_UOM__c = 'KG';
        uom.Sales_UOM__c = 'KG';
        uom.Numerator__c = 1;
        uom.Denominator__c = 1;
        uom.Sales_Org__c = sorg.Id;
        uom.SKU__c = sku.id;
        insert uom;
         //Added by Nandhini-APPS-5287
        UOM_Conversion__c uom1 = new UOM_Conversion__c();
        uom1.Base_UOM__c = 'KG';
        uom1.Sales_UOM__c = 'KG';
        uom1.Numerator__c = 1;
        uom1.Denominator__c = 1;
        uom1.Sales_Org__c = sorg.Id;
        uom1.SKU__c = sku.id;
        insert uom1;
        UOM_Conversion__c uom2 = new UOM_Conversion__c();
        uom2.Base_UOM__c = 'KG';
        uom2.Sales_UOM__c = 'L';
        uom2.Numerator__c = 1;
        uom2.Denominator__c = 1;
        uom2.Sales_Org__c = sorg.Id;
        uom2.SKU__c = sku1.id;
        insert uom2;
        
        Price_Block_Margin_Matrix__c rebate1 = new Price_Block_Margin_Matrix__c();
        rebate1.Rebate_USD__c = 2;
        rebate1.Type__c = 'Rebate';
        rebate1.Profit_Center__c = pc.Id;
        rebate1.UOM__c = 'KG';
        rebate1.Start_Date__c = System.today();
        rebate1.End_Date__c = System.today().addDays(5);
        rebate1.Depot_Code__c = dp.Id;
        rebate1.Sales_Org__c = sorg.Id;
        rebate1.SKU_Code__c = sku.id;
        rebate1.CurrencyIsoCode = 'USD';
        rebate1.Distributor_Code__c = acc.Id;
        rebate1.Rebate_Code__c = '12345';
        insert rebate1;
        
        Price_Block_Margin_Matrix__c rebate2 = new Price_Block_Margin_Matrix__c();
        rebate2.Rebate_USD__c = 2;
        rebate2.Type__c = 'Rebate';
        rebate2.Profit_Center__c = pc.Id;
        rebate2.UOM__c = 'KG';
        rebate2.Start_Date__c = System.today();
        rebate2.End_Date__c = System.today().addDays(5);
        rebate2.Depot_Code__c = dp.Id;
        rebate2.Sales_Org__c = sorg.Id;
        rebate2.SKU_Code__c = sku.id;
        rebate2.CurrencyIsoCode = 'USD';
        rebate2.Distributor_Code__c = acc.Id;
        rebate2.Rebate_Code__c = '12346';
        insert rebate2;
        
          //Added by Nandhini-APPS-5287
        Price_Block_Margin_Matrix__c rebate3 = new Price_Block_Margin_Matrix__c();
        rebate3.Rebate_USD__c = 2;
        rebate3.Type__c = 'Rebate';
        rebate3.Profit_Center__c = pc.Id;
        rebate3.UOM__c = 'L';
        rebate3.Start_Date__c = System.today();
        rebate3.End_Date__c = System.today().addDays(5);
        rebate3.Depot_Code__c = dp.Id;
        rebate3.Sales_Org__c = sorg.Id;
        rebate3.SKU_Code__c = sku1.id;
        rebate3.CurrencyIsoCode = 'USD';
        rebate3.Distributor_Code__c = acc.Id;
        rebate3.Rebate_Code__c = '12346';
        insert rebate3;
        
        
        Price_Block_Margin_Matrix__c rebate4 = new Price_Block_Margin_Matrix__c();
        rebate4.Rebate_USD__c = 2;
        rebate4.Type__c = 'Rebate';
        rebate4.Profit_Center__c = pc.Id;
        rebate4.UOM__c = 'L';
        rebate4.Start_Date__c = System.today();
        rebate4.End_Date__c = System.today().addDays(5);
        rebate4.Depot_Code__c = dp.Id;
        rebate4.Sales_Org__c = sorg.Id;
        rebate4.SKU_Code__c = sku1.id;
        rebate4.CurrencyIsoCode = 'USD';
        rebate4.Distributor_Code__c = acc.Id;
        rebate4.Rebate_Code__c = '12347';
        insert rebate4;
        Price_Block_Margin_Matrix__c discount = new Price_Block_Margin_Matrix__c();
        discount.Discount_USD__c = 2;
        discount.Type__c = 'Discount';
        discount.Profit_Center__c = pc.Id;
        discount.UOM__c = 'KG';
        discount.Start_Date__c = System.today();
        discount.End_Date__c = System.today().addDays(5);
        discount.Depot_Code__c = dp.Id;
        discount.Sales_Org__c = sorg.Id;
        discount.SKU_Code__c = sku.id;
        discount.CurrencyIsoCode = 'USD';
        discount.Distributor_Code__c = acc.Id;
        insert discount;
        Price_Block_Margin_Matrix__c discount1 = new Price_Block_Margin_Matrix__c();
        discount1.Discount_USD__c = 3;
        discount1.Type__c = 'Discount';
        discount1.Profit_Center__c = pc.Id;
        discount1.UOM__c = 'KG';
        discount1.Start_Date__c = System.today();
        discount1.End_Date__c = System.today().addDays(5);
        discount1.Depot_Code__c = dp.Id;
        discount1.Sales_Org__c = sorg.Id;
        discount1.SKU_Code__c = sku.id;
        discount1.CurrencyIsoCode = 'USD';
        discount1.Distributor_Code__c = acc.Id;
        insert discount1;
        
        Price_Block_Margin_Matrix__c discount2 = new Price_Block_Margin_Matrix__c();
        discount2.Discount_USD__c = 3;
        discount2.Type__c = 'Discount';
        discount2.Profit_Center__c = pc.Id;
        discount2.UOM__c = 'L';
        discount2.Start_Date__c = System.today();
        discount2.End_Date__c = System.today().addDays(5);
        discount2.Depot_Code__c = dp.Id;
        discount2.Sales_Org__c = sorg.Id;
        discount2.SKU_Code__c = sku1.id;
        discount2.CurrencyIsoCode = 'USD';
        discount2.Distributor_Code__c = acc.Id;
        insert discount2;
        
        Price_Block_Margin_Matrix__c addDiscount = new Price_Block_Margin_Matrix__c();
        addDiscount.Additional_Discount_USD__c = 2;
        addDiscount.Type__c = 'AdditionalDiscount';
        addDiscount.Profit_Center__c = pc.Id;
        addDiscount.UOM__c = 'KG';
        addDiscount.Start_Date__c = System.today();
        addDiscount.End_Date__c = System.today().addDays(5);
        addDiscount.Depot_Code__c = dp.Id;
        addDiscount.Sales_Org__c = sorg.Id;
        addDiscount.SKU_Code__c = sku.id;
        addDiscount.CurrencyIsoCode = 'USD';
        addDiscount.Distributor_Code__c = acc.Id;
        insert addDiscount;
        Price_Block_Margin_Matrix__c addDiscount1 = new Price_Block_Margin_Matrix__c();
        addDiscount1.Additional_Discount_USD__c =3;
        addDiscount1.Type__c = 'AdditionalDiscount';
        addDiscount1.Profit_Center__c = pc.Id;
        addDiscount1.UOM__c = 'KG';
        addDiscount1.Start_Date__c = System.today();
        addDiscount1.End_Date__c = System.today().addDays(5);
        addDiscount1.Depot_Code__c = dp.Id;
        addDiscount1.Sales_Org__c = sorg.Id;
        addDiscount1.SKU_Code__c = sku.id;
        addDiscount1.CurrencyIsoCode = 'USD';
        addDiscount1.Distributor_Code__c = acc.Id;
        insert addDiscount1;
        
          //Added by Nandhini-APPS-5287
        Price_Block_Margin_Matrix__c addDiscount2 = new Price_Block_Margin_Matrix__c();
        addDiscount2.Additional_Discount_USD__c =3;
        addDiscount2.Type__c = 'AdditionalDiscount';
        addDiscount2.Profit_Center__c = pc.Id;
        addDiscount2.UOM__c = 'L';
        addDiscount2.Start_Date__c = System.today();
        addDiscount2.End_Date__c = System.today().addDays(5);
        addDiscount2.Depot_Code__c = dp.Id;
        addDiscount2.Sales_Org__c = sorg.Id;
        addDiscount2.SKU_Code__c = sku1.id;
        addDiscount2.CurrencyIsoCode = 'USD';
        addDiscount2.Distributor_Code__c = acc.Id;
        insert addDiscount2;
        
        Price_Block_Margin_Matrix__c salesDeduction = new Price_Block_Margin_Matrix__c();
        salesDeduction.Sales_Deduction_USD__c = 2;
        salesDeduction.Type__c = 'SalesDeduction';
        salesDeduction.Profit_Center__c = pc.Id;
        salesDeduction.UOM__c = 'KG';
        salesDeduction.Start_Date__c = System.today();
        salesDeduction.End_Date__c = System.today().addDays(5);
        salesDeduction.Depot_Code__c = dp.Id;
        salesDeduction.Sales_Org__c = sorg.Id;
        salesDeduction.SKU_Code__c = sku.id;
        salesDeduction.CurrencyIsoCode = 'USD';
        insert salesDeduction;
        Price_Block_Margin_Matrix__c salesDeduction1 = new Price_Block_Margin_Matrix__c();
        salesDeduction1.Sales_Deduction_USD__c = 3;
        salesDeduction1.Type__c = 'SalesDeduction';
        salesDeduction1.Profit_Center__c = pc.Id;
        salesDeduction1.UOM__c = 'KG';
        salesDeduction1.Start_Date__c = System.today();
        salesDeduction1.End_Date__c = System.today().addDays(5);
        salesDeduction1.Depot_Code__c = dp.Id;
        salesDeduction1.Sales_Org__c = sorg.Id;
        salesDeduction1.SKU_Code__c = sku.id;
        salesDeduction1.CurrencyIsoCode = 'USD';
        insert salesDeduction1;
        
         Price_Block_Margin_Matrix__c salesDeduction2 = new Price_Block_Margin_Matrix__c();
        salesDeduction2.Sales_Deduction_USD__c = 3;
        salesDeduction2.Type__c = 'SalesDeduction';
        salesDeduction2.Profit_Center__c = pc.Id;
        salesDeduction2.UOM__c = 'L';
        salesDeduction2.Start_Date__c = System.today();
        salesDeduction2.End_Date__c = System.today().addDays(5);
        salesDeduction2.Depot_Code__c = dp.Id;
        salesDeduction2.Sales_Org__c = sorg.Id;
        salesDeduction2.SKU_Code__c = sku1.id;
        salesDeduction2.CurrencyIsoCode = 'USD';
        insert salesDeduction2;
        
        Price_Block_Margin_Matrix__c pln = new Price_Block_Margin_Matrix__c();
        pln.PLN_USD__c = 2;
        pln.Type__c = 'PLN';
        pln.Profit_Center__c = pc.Id;
        pln.UOM__c = 'KG';
        pln.Start_Date__c = System.today();
        pln.End_Date__c = System.today().addDays(5);
        pln.Depot_Code__c = dp.Id;
        pln.Sales_Org__c = sorg.Id;
        pln.SKU_Code__c = sku.id;
        pln.CurrencyIsoCode = 'USD';
        insert pln;
        Price_Block_Margin_Matrix__c pln1 = new Price_Block_Margin_Matrix__c();
        pln1.PLN_USD__c = 3;
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
        
        Price_Block_Margin_Matrix__c pln2 = new Price_Block_Margin_Matrix__c();
        pln2.PLN_USD__c = 3;
        pln2.Type__c = 'PLN';
        pln2.Profit_Center__c = pc.Id;
        pln2.UOM__c = 'L';
        pln2.Start_Date__c = System.today();
        pln2.End_Date__c = System.today().addDays(5);
        pln2.Depot_Code__c = dp.Id;
        pln2.Sales_Org__c = sorg.Id;
        pln2.SKU_Code__c = sku1.id;
        pln2.CurrencyIsoCode = 'USD';
        insert pln2;

          //Added by Nandhini-APPS-5287
        Sales_Order__c so = new Sales_Order__c();
        so.Sold_to_Party__c = acc.Id;
        so.Bill_To_Party__c = acc.Id;
        so.Order_Date__c = system.today();
        so.CreatedFrom__c = 'SFDC';
        so.Depot__c = dp.Id;
        so.OwnerId = UserInfo.getUserId();
        so.Order__c = ord.Id;
        so.Sales_Org_lk__c = sorg.Id;
        so.Order_Status__c = 'Pending';
        so.Ship_To_Party__c = shippLoc.Id;
        so.MinimumPriceCheck__c =true;
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
        //sliObj.crop__c = crops.Id;
        //sliObj.Crop1_Percentage__c = 100;
        sliObj.Quantity__c = 10;
        sliObj.Net_Price__c = 150;
        sliObj.Price__c = 1500;
        sliObj.Sale_Order__c = so.Id;
        //sliObj.Contribution__c = 10;
        sliObj.SKU_Net_Price__c = 100;
        sliObj.Sales_Deduction_Cal__c = 20;
        sliObj.E2E_Cost_Cal__c = 40;
        Insert sliObj;
        
        Test.stopTest(); //RITM0506556 - iminate or put on hold the last level of the margin block approval matrix.
    }
    
    static testMethod void method() {
        
        Account acc = [Select id From Account LIMIT 1];
        Order__c ord = [Select id From Order__c LIMIT 1];
        Sku__c sku = [Select id From Sku__c where SKU_Code__c='704002' LIMIT 1];
        Sku__c sku1 = [Select id From Sku__c where SKU_Code__c='704003' LIMIT 1];
        Order_Type__c orderType =[select id from Order_Type__c LIMIT 1];
        Payment_Method__c paymentMethodObj=[select Id from Payment_Method__c LIMIT 1];
        Payment_Term__c paymentTermObj =[select Id,SalesOrgCode__c,Payment_Term__c from Payment_Term__c LIMIT 1];
        OrderTemplate__c ordTemp = [Select id From OrderTemplate__c LIMIT 1];
        Depot__c depot=[Select Id, Name from Depot__c]; 
        Sales_order__c salesOrder=[Select id from Sales_order__c limit 1 ];
        system.debug('created sales order :'+salesOrder);
        Sales_Order__c sObj= new Sales_Order__c();
        PageReference pageRef = Page.OrderArgentina;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('acid',acc.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(ord);
        OrderArgentinaController ordmanage = new OrderArgentinaController(sc);
        
        ordmanage.selectDeliveryModule='Deliver';
        ordmanage.country = 'Argentina';
        ordmanage.PO = '23423';
        ordmanage.DeliveryDate = System.today();//Delivery Date:RITM0094155, 3rd September 2020, Sayan (crmconsultant3@upl-ltd.com)
        OrderArgentinaController.DistributorWrapper distributorWrapperObj = new OrderArgentinaController.DistributorWrapper();
        distributorWrapperObj.country = 'Argentina';
        ordmanage.country = 'Argentina';
        ordmanage.selectedOrderType = orderType.Id;
        ordmanage.enteredFinalPrice=8;
        ordmanage.enteredqty=200;
        ordmanage.skuId=sku.Id;
//        Test.startTest(); //RITM0506556 - iminate or put on hold the last level of the margin block approval matrix.
        
        ordmanage.fetchDistributorDetails();
        ordmanage.fetchSKUData();
        ordmanage.populatePaymentMethod();
        ordmanage.populateOrderType();
        ordmanage.populateShippingAddress();
        ordmanage.accountId = acc.Id;
        ordmanage.populateOrderType(); 
        ordmanage.selectedPayment='None';//New
        ordmanage.changePaymentMethod();
        ordmanage.selectedPayment = paymentMethodObj.Id;
        ordmanage.selectedPaymentId = paymentMethodObj.Id;
        ordmanage.changePaymentTerm();
        ordmanage.paymentTermCode = paymentTermObj.Id;
        ordmanage.isCustomerAprrove = True;
        ordmanage.storageIdChosen = depot.Id;       
        
        ordmanage.changeOrderType();
        ordmanage.selectedOrderType = orderType.id;        
        ordmanage.populateShippingAddress();
        ordmanage.searchProdValue = 'DOST';
        ordmanage.searchProduct();
        ordmanage.skuIdChosen = sku.Id;    
        ordmanage.changeOrderType();
        Test.startTest(); //RITM0506556 - iminate or put on hold the last level of the margin block approval matrix.
        ordmanage.addSKU();
        ordmanage.deleteSKU();
        ordmanage.searchProdValue = 'DOST';
        ordmanage.searchProduct();
        
        
        ordmanage.skuIdChosen = sku.Id;
        ordmanage.addSKU();
        
        ordmanage.deleteAllSKU();
        
        ordmanage.searchProdValue = 'DOST';
        ordmanage.searchProduct();
        ordmanage.skuIdChosen = sku.Id;
        ordmanage.addSKU();
        ordmanage.changePayment();
        
        ordmanage.addSOLineItem();
        
        ordmanage.addSKU();
        ordmanage.createOrder();
        ordmanage.updateSKU();
       
        ordmanage.enteredFinalPrice=8;
        ordmanage.enteredqty=200;
        //ordmanage.skuId=sku1.Id;
        ordmanage.calculateFreezePeriod();
        ordmanage.updateDeliveryDate();
        //ordmanage.calculateTax();
        ordmanage.refreshOrderValue();
        ordmanage.templateName = 'test';
        ordmanage.saveTemplate();
        ordmanage.tempIdChosen = ordTemp.Id;
        ordmanage.confirmOrder();
        
        
        // Create an approval request for the account
       /* Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(salesOrder.Id);
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
        // Verify the result
        System.assert(result.isSuccess());
        
        System.assertEquals('Pending', result.getInstanceStatus(), 
            'Instance Status'+result.getInstanceStatus());
        
        // Approve the submitted request
        // First, get the ID of the newly created item
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        
        // Instantiate the new ProcessWorkitemRequest object and populate it
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments('Approving request.');
        req2.setAction('Approved');
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        
        // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(newWorkItemIds.get(0));*/
        
        // Submit the request for approval
        //Approval.ProcessResult result2 =  Approval.process(req2);
      
        // Verify the result
        //System.assert(result2.isSuccess());
        
        Test.stopTest();  
        
        ordmanage.changePaymentMethod();
        ordmanage.selectedPaymentId =paymentMethodObj.Id;
        ordmanage.changePaymentTerm();
        ordmanage.selectedPaymentTerm=paymentTermObj.Id;
        ordmanage.selectedPaymentId = paymentMethodObj.Id;
           
        ordmanage.createSalesOrder();
        ordmanage.editOrder();
        ordmanage.showOrderTemplates();
        ordmanage.loadTemplate();
        ordmanage.getTemplateName();
        ordmanage.showOrderHistory();
        //ordmanage.selectedPayment = null;
        //ordmanage.selectedPaymentTerm = null;
        ordmanage.changeDepot();
        ordmanage.redirectFunction();
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(salesOrder.Id);
        Approval.ProcessResult result1 = Approval.process(req1);
        ProcessInstanceWorkitem[] piWorkItems = [SELECT Id FROM ProcessInstanceWorkItem WHERE ProcessInstance.TargetObjectId = :salesOrder.Id
                                                 AND ProcessInstance.Status = 'Pending']; 
        if(piWorkItems.size() > 0){
            //Create Process Work Item Request
            Approval.ProcessWorkItemRequest pwiRequest = new Approval.ProcessWorkItemRequest();
            pwiRequest.setAction('Approve');
            pwiRequest.setWorkItemId(piWorkItems[0].Id);
            Approval.ProcessResult result = Approval.process(pwiRequest);
        }
         ProcessInstance pi= [Select id , Status, SubmittedBy.Name,ProcessDefinitionId,ProcessDefinition.Name,(Select id,StepStatus,Actor.Name,ProcessNode.Name from StepsAndWorkitems) from ProcessInstance where TARGETOBJECTID =:salesOrder.Id ORDER BY CreatedDate DESC];
         System.debug('pi inside testclass---->'+pi.StepsAndWorkitems.size());
        OrderArgentinaController.getApprovalHistory(salesOrder.Id);
	      
        
                
    }
    /*  
* Name: CaseNurture    
* return:void
* Description: APPS-5287-This method responsible to cover FreezePeriodLogic.
*/  
  
     static testMethod void FreezePeriodLogic() {
         Account acc = [Select id From Account LIMIT 1];
         Order__c ord = [Select id From Order__c LIMIT 1];
        Sku__c sku1 = [Select id From Sku__c where SKU_Code__c='704003' LIMIT 1];
         Order_Type__c orderType =[select id from Order_Type__c LIMIT 1];
         Payment_Method__c paymentMethodObj=[select Id from Payment_Method__c LIMIT 1];
         Payment_Term__c paymentTermObj =[select Id,SalesOrgCode__c,Payment_Term__c from Payment_Term__c LIMIT 1];
         OrderTemplate__c ordTemp = [Select id From OrderTemplate__c LIMIT 1];
         Depot__c depot=[Select Id, Name from Depot__c]; 
         
         Sales_Order__c sObj= new Sales_Order__c();
         PageReference pageRef = Page.OrderArgentina;
         Test.setCurrentPage(pageRef);
         
         pageRef.getParameters().put('acid',acc.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(ord);
         OrderArgentinaController ordmanage = new OrderArgentinaController(sc);
         
         ordmanage.selectDeliveryModule='Deliver';
         ordmanage.country = 'Argentina';
         ordmanage.PO = '23423';
         ordmanage.DeliveryDate = System.today();//Delivery Date:RITM0094155, 3rd September 2020, Sayan (crmconsultant3@upl-ltd.com)
         OrderArgentinaController.DistributorWrapper distributorWrapperObj = new OrderArgentinaController.DistributorWrapper();
         distributorWrapperObj.country = 'Argentina';
         ordmanage.country = 'Argentina';
         ordmanage.selectedOrderType = orderType.Id;
         ordmanage.enteredFinalPrice=8;
        ordmanage.enteredqty=200;
        ordmanage.skuId=sku1.Id;        
        ordmanage.commonPeriodMap='{"a1C28000002ceHzEAI":3}';
        ordmanage.salesApprovalPeriodMap='{"a1C28000002ceHzEAI":3}';
         Test.startTest();
         ordmanage.fetchDistributorDetails();
         ordmanage.fetchSKUData();
         ordmanage.populatePaymentMethod();
         ordmanage.populateOrderType();
         ordmanage.populateShippingAddress();
         ordmanage.accountId = acc.Id;
         ordmanage.populateOrderType();        
         ordmanage.changePaymentMethod();
         ordmanage.selectedPayment = paymentMethodObj.Id;
         ordmanage.selectedPaymentId = paymentMethodObj.Id;
         ordmanage.changePaymentTerm();
         ordmanage.paymentTermCode = paymentTermObj.Id;
         ordmanage.isCustomerAprrove = True;
         ordmanage.storageIdChosen = depot.Id;
         ordmanage.changeOrderType();
         ordmanage.selectedOrderType = orderType.id;        
         ordmanage.populateShippingAddress();
         ordmanage.searchProdValue = 'DOST';
         ordmanage.searchProduct();
         ordmanage.skuIdChosen = sku1.Id;    
         ordmanage.changeOrderType();
         ordmanage.addSKU();
         ordmanage.changePayment();
         ordmanage.addSOLineItem();
         ordmanage.calculateFreezePeriod();
         ordmanage.updateDeliveryDate();
        
         OrderArgentinaController.ApprovalHistory wrapInfo=new OrderArgentinaController.ApprovalHistory();
         wrapInfo.userName='User New 1';
         wrapInfo.status='Approved';
         wrapInfo.step='2';
        // ordmanage.calculateFreezePeriod(); 
         Test.stopTest();
     }
  
/*  
* Name: CaseNurture    
* return:void
* Description: APPS-5287-This method responsible to cover FreezePeriodLogic.
*/  
    static testMethod void FreezePeriodLogic1() {
         Account acc = [Select id From Account LIMIT 1];
         Order__c ord = [Select id From Order__c LIMIT 1];
        Sku__c sku1 = [Select id From Sku__c where SKU_Code__c='704003' LIMIT 1];
         Order_Type__c orderType =[select id from Order_Type__c LIMIT 1];
         Payment_Method__c paymentMethodObj=[select Id from Payment_Method__c LIMIT 1];
         Payment_Term__c paymentTermObj =[select Id,SalesOrgCode__c,Payment_Term__c from Payment_Term__c LIMIT 1];
         OrderTemplate__c ordTemp = [Select id From OrderTemplate__c LIMIT 1];
         Depot__c depot=[Select Id, Name from Depot__c]; 
         List<Price_Block_Margin_Matrix__c> pNMatrix=[Select Id,SKU_Code__c,type__c from Price_Block_Margin_Matrix__c where type__c='E2ECost' and SKU_Code__c =: sku1.id];
         delete pNMatrix;
         Sales_Order__c sObj= new Sales_Order__c();
         PageReference pageRef = Page.OrderArgentina;
         Test.setCurrentPage(pageRef);
         
         pageRef.getParameters().put('acid',acc.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(ord);
         OrderArgentinaController ordmanage = new OrderArgentinaController(sc);
         
         ordmanage.selectDeliveryModule='Deliver';
         ordmanage.country = 'Argentina';
         ordmanage.PO = '23423';
         ordmanage.DeliveryDate = System.today();//Delivery Date:RITM0094155, 3rd September 2020, Sayan (crmconsultant3@upl-ltd.com)
         OrderArgentinaController.DistributorWrapper distributorWrapperObj = new OrderArgentinaController.DistributorWrapper();
         distributorWrapperObj.country = 'Argentina';
         ordmanage.country = 'Argentina';
         ordmanage.selectedOrderType = orderType.Id;
         ordmanage.enteredFinalPrice=8;
        ordmanage.enteredqty=200;
        ordmanage.skuId=sku1.Id;        
        ordmanage.commonPeriodMap='{"a1C28000002ceHzEAI":3}';
        ordmanage.salesApprovalPeriodMap='{"a1C28000002ceHzEAI":3}';
         Test.startTest();
         ordmanage.fetchDistributorDetails();
         ordmanage.fetchSKUData();
         ordmanage.populatePaymentMethod();
         ordmanage.populateOrderType();
         ordmanage.populateShippingAddress();
         ordmanage.accountId = acc.Id;
         ordmanage.populateOrderType();        
         ordmanage.changePaymentMethod();
         ordmanage.selectedPayment = paymentMethodObj.Id;
         ordmanage.selectedPaymentId = paymentMethodObj.Id;
         ordmanage.changePaymentTerm();
         ordmanage.paymentTermCode = paymentTermObj.Id;
         ordmanage.isCustomerAprrove = True;
         ordmanage.storageIdChosen = depot.Id;
         ordmanage.changeOrderType();
         ordmanage.selectedOrderType = orderType.id;        
         ordmanage.populateShippingAddress();
         ordmanage.searchProdValue = 'DOST';
         ordmanage.searchProduct();
         ordmanage.skuIdChosen = sku1.Id;    
         ordmanage.changeOrderType();
         ordmanage.addSKU();
         ordmanage.changePayment();
         ordmanage.addSOLineItem();
         //ordmanage.calculateFreezePeriod();
         //ordmanage.updateDeliveryDate();
         
          
         OrderArgentinaController.ApprovalHistory wrapInfo=new OrderArgentinaController.ApprovalHistory();
         wrapInfo.userName='User New 1';
         wrapInfo.status='Approved';
         wrapInfo.step='2';
        // ordmanage.calculateFreezePeriod(); 
         Test.stopTest();
     }
    
    
}