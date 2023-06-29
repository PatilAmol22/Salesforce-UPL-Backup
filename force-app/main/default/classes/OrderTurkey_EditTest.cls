@isTest
public class OrderTurkey_EditTest {

  //testing data setup for all methods in this class
    @testSetup
    static void allTheDataForThisTestClass() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id SOrecordTypeId = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Sales Order').getRecordTypeId(); 
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Turkey';
        sorg.Description__c='Turkey';
        sorg.Sales_Org_Code__c='7110';
        insert sorg;
        
        
        
        Order_Type__c  orderTypeObj = new Order_Type__c(
            Name = 'ZTO0',                  // Order Type Name
            Description__c = 'Free Samples',     // Description
            Order_Type_Code__c = 'ZTO0',      // Order Type Code
            SalesOrg__c = sorg.Id  // Sales Org
        );
        insert orderTypeObj;
        
        Order_Type__c  SampleorderType = new Order_Type__c(
            Name = 'ZTF0',                  // Order Type Name  
            Description__c = 'Free Samples',     // Description
            Order_Type_Code__c = 'ZTF0',      // Order Type Code
            SalesOrg__c = sorg.Id  // Sales Org
        );
        insert SampleorderType;
        
        
        Depot__c dp =new Depot__c ();
        dp.Name='Turkey';
        dp.Country__c='Turkey';
        dp.Location__c='Turkey';
        dp.Depot_Code__c='TR00';
        insert dp;

        
        Distribution_Channel__c disbj = new Distribution_Channel__c();
        disbj.Name = 'Depot';                      
        disbj.Distribution_Channel_Code__c = '20';  
        disbj.Description__c='test';
        insert disbj;
        
        Division__c Divbj = new Division__c();
        Divbj.Name = 'Agro Formulation';         
        Divbj.Description__c = null;    
        Divbj.Division_Code__c = '10'; 
        insert Divbj;
        

        
        SKU__c sku = new SKU__c();
        sku.Name= '300 ML';
        sku.SKU_Code__c='000000000005300189';
        sku.SKU_Pack__c= 0.00;
        sku.SKU_UOM__c='L';
        sku.Distribution_Channel__c = disbj.Id;
        sku.Division__c = Divbj.Id;
        sku.Pack_Size__c=0.00;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='L';
        sku.Material_type__c = 'HAWA';
        sku.Brand_Name__c = 'ADITYA'; 
        sku.Active__c=True;
        sku.Combination_Key__c='7110201000000000005300189';
        sku.Multiple_of__c = 5.00;
        insert sku;
        
        SKU__c sku1 = new SKU__c();
        sku.Name= '500 ML';
        sku1.SKU_Code__c='000000000004300189';
        sku1.SKU_Pack__c= 0.00;
        sku1.SKU_UOM__c='L';
        sku1.Distribution_Channel__c = disbj.Id;
        sku1.Division__c = Divbj.Id;
        sku1.Pack_Size__c=0.00;
        sku1.Sales_Org__c = sorg.Id;
        sku1.UOM__c='L';
        sku1.Material_type__c = 'HAWA';
        sku1.Brand_Name__c = 'BLUE'; 
        sku1.Active__c=True;
        sku1.Combination_Key__c='7110201000000000005300000';
        insert sku1;
        

        
        PriceBookMaster__c PbMaster = new PriceBookMaster__c(
            SKUCode__c = sku.id,                               // SKU Code
            MinPrice__c = 5.20,                                           // Min Price
            DepotCode__c = dp.id,                             // Depot Code
            Price__c = 7.00,
            PG_CODE__c =Pg.Id, 													// Price
            UOM__c = 'L',                                                // UOM
            StartDate__c = system.today(),                      // Start Date
            Division__c = Divbj.Id,
            EndDate__c = system.today()+1,                       // End Date
            DistributionChannel__c = disbj.Id,                   // Distribution Channel
            Active__c = true,                                            // Active
            PerUnit__c = 1, 
            Batch__c ='1010',
            CompositeKey__c = 'TR00037120000000000000368001',  // CompositeKey
            Sales_Org__c = sorg.id,                             // Sales Org
            Price_Book_Change__c = false                                 // Price_Book_Change
        );
        insert PbMaster; 
 
        Account acc = new Account();
        acc.Name='Ganesh Chaurasia';
        acc.Last_Name__c='Chaurasia';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP000004';
        acc.Order_Block__c = false;  
        acc.Account_Type__c = 'Sold To Party';
        acc.RecordTypeId=devRecordTypeId;
       // acc.CustomerAccountGroup__c = 'Z031';
      //  acc.LanguageKey__c = 'EN';
        acc.Mobile__c='9867213275';
        acc.Phone='98745632';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity= '35210 Alsancak / IZMIR';
        acc.Order_Type__c=orderTypeObj.Id;
      //  acc.Tax_classification_for_customer__c = '1';
        insert acc;
        
        
        userrole  usrole = new userrole();
        usrole.Name ='Ganesh chaurasia Customer User';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'District Manager for Turkey'];
        
        User sobj1 = new User();
        sobj1.Alias = 'Emrah';                                                            
        sobj1.Email = 'ganesh.chaurasia@skinternational.com';                             
        sobj1.ProfileId  = p.ID;                                                     
        sobj1.Username = '200030100@uniphos.com.upltest';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='District Manager';
        sobj1.CommunityNickname = 'Emrah123Ucar'; 
        sobj1.Title = 'District Managers (RM)';
        sobj1.TimeZoneSidKey = 'Europe/Istanbul'; 
        // sobj1.Contact.AccountID = acc.id;// Time Zone
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;   
        sobj1.TM_Code__c = '123654741';
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId=usrole.id;
        insert sobj1;
        

        
        TM_Depot_Mapping__c TMDepoMap = new TM_Depot_Mapping__c();
        TMDepoMap.Depot__c = dp.Id;        // Depot
        TMDepoMap.Territory_Manager__c = sobj1.id;  // Territory Manager
        insert TMDepoMap;
        
        Shipping_Location__c shippLoc =new Shipping_Location__c();
        shippLoc.Location_Name__c ='IZMIR GÜMRÜK MÜDÜRLÜGÜ'; 
        shippLoc.Region__c='S.No:46/1, A1 Building, First Floor, Office No.101 E-Space, Wadgoan Sheri,Nagar Rd, Aga Nagar,';
        shippLoc.Distributor__c=acc.Id;
        shippLoc.City__c='IZMIR, TURKEY';
        shippLoc.Sales_Org__c=sorg.Id;
        shippLoc.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc.SAP_Code__c='SAP0dd001';
        shippLoc.State__c='turkey';
        insert shippLoc;
        
        
        Inventory__c invObj = new Inventory__c( );
        invObj.Stock_Quantity__c = 10;   
        invObj.Batch_Number__c = 'CMUMTX2506'; 
        invObj.Depot__c = dp.Id;    
        invObj.UOM__c = 'L';                    
        invObj.Storage_Location__c = 'MAIN';  
        invObj.SKU__c = sku.Id;  
        invObj.SKU_Depot__c ='sd1';           
        insert invObj;
        
        Distributor_Depot_Mapping__c dsMap =new Distributor_Depot_Mapping__c();
        dsMap.Distributor__c = acc.id;
        dsMap.Depot__c=dp.Id;
        insert dsMap;
        
        DistributorSalesAreaMapping__c dsmObj = new DistributorSalesAreaMapping__c();
        dsmObj.Distributor__c = acc.Id;
        dsmObj.SalesOrg__c = sorg.Id;
        dsmObj.DistributionChannel__c = disbj.Id; 
        dsmObj.Division__c = Divbj.Id;
        dsmObj.AccountOwner__c = UserInfo.getUserId();
        insert dsmObj;
        
        PricebookDiscount__c sobj = new PricebookDiscount__c(
            Division__c = Divbj.Id,                       // Division
            DepotCode__c = dp.Id,                      // Depot Code
            DistributionChannel__c = disbj.Id,            // Distribution Channel
            DistributorCustomerCode__c = acc.Id,        // Distributor Customer Code
            Distributor_Discount__c = 10.00,                       // Distributor Discount
            EndDate__c = system.today()+50,                 // End Date
            PG_Code__c = pg.Id,                        // PG Code
            SKUCode__c =sku.Id,                        // SKU Code
            StartDate__c = system.today(),               // Start Date
            Active__c = true,                                      // Active
            CompositeKey__c = 'TR000311020100000000368001',  // CompositeKey
            Sales_Org__c = sorg.Id                     // Sales Org
        );
        insert sobj;

        Credit_Info__c crdIf = new Credit_Info__c();
        crdIf.Credit_Limit__c=1000;
        crdIf.Percentage_Used__c=100.0;
        crdIf.Allocated_Limit__c=0.0;
        crdIf.Sales_Org__c=sorg.Id;        
        crdIf.Distributor__c=acc.Id;
        crdIf.Distributor_Code__c='00010001225';
        insert crdIf;
    
    
    
        Sales_Order__c soObj = new Sales_Order__c(
            //   RecordType = '0120k0000000ZbF',                // Record Type
            SFDC_Order_Number__c = '01000',                  // SFDC Order Number
            Order_Raise_By__c = 'District Manager',          // Order Raised By
            Order_Status__c = 'Rejected',  
            Remarks__c = 'DomesticSalesSK',// Order Status
            Order_Date__c = system.today(),
            Division_lk__c = Divbj.Id,             			 // Division
            Distribution_Channel_lk__c = disbj.Id, 			 // Distribution Channel
            Order_Type_lk__c = orderTypeObj.Id,         	  // Order Type
            Sold_to_Party__c = acc.Id,           			 // Sold to Party
            Bill_To_Party__c = acc.Id,          			  // Bill To Party
            Ship_To_Party__c = shippLoc.Id ,     		      // Ship To Party
            CreatedFrom__c = 'SFDC', 
            Sales_Org_lk__c = sorg.Id // Created From
        );
        insert soObj;
        
        Sales_Order_Line_Item__c soLineItem = new Sales_Order_Line_Item__c(
            Sale_Order__c = soObj.Id,     // Sale Order
            SKU_Name__c = sku.Id,       // SKU Name
            Item_Status__c = 'Active',             // Item Status
            Item_Number__c = 10,                   // Item Number
            DepotDepot__c =  dp.Id,      // Depot
            Campaign_Discount__c = 2.00,           // Campaign Discount
            UOM__c = 'L',                         // UOM
            Net_Price__c = 47040.00,               // Net Price
            MinPrice__c = 295.00,                  // Min Price
            Quantity__c = 1.00,                    // Quantity
            Material_Discount__c = 4.00,           // Material Discount
            FinalPrice__c = 50000.00,              // FinalPrice
            Distributor_Discount__c = 0.00,        // Distributor Discount
            Comment__c = 'test01',                   // Comment
            Price__c = 47040.00                   // Value
        );
        insert soLineItem;
        
        Sales_Order__c soObj1 = new Sales_Order__c(
            //   RecordType = '0120k0000000ZbF',                // Record Type
            SFDC_Order_Number__c = '01800',                  // SFDC Order Number
            Order_Raise_By__c = 'District Manager',          // Order Raised By
            Order_Status__c = 'Rejected',  
            Remarks__c = 'SampleSalesSK',// Order Status
            Order_Date__c = system.today(),
            Division_lk__c = Divbj.Id,             			 // Division
            Distribution_Channel_lk__c = disbj.Id, 			 // Distribution Channel
            Order_Type_lk__c = SampleorderType.Id,         	  // Order Type
            Sold_to_Party__c = acc.Id,           			 // Sold to Party
            Bill_To_Party__c = acc.Id,          			  // Bill To Party
            Ship_To_Party__c = shippLoc.Id ,     		      // Ship To Party
            CreatedFrom__c = 'SFDC',
            Sales_Org_lk__c = sorg.Id// Created From
        );
        insert soObj1;
        
        Sales_Order_Line_Item__c soLineItem1 = new Sales_Order_Line_Item__c(
            Sale_Order__c = soObj1.Id,     // Sale Order
            SKU_Name__c = sku.Id,       // SKU Name
            Item_Status__c = 'Active',             // Item Status
            Item_Number__c = 10,                   // Item Number
            DepotDepot__c =  dp.Id,      // Depot
            Campaign_Discount__c = 0.00,           // Campaign Discount
            UOM__c = 'L',                         // UOM
            Net_Price__c = 0.00,               // Net Price
            MinPrice__c = 0.00,                  // Min Price
            Quantity__c = 10.00,                    // Quantity
            Material_Discount__c = 0.00,           // Material Discount
            FinalPrice__c = 0.00,              // FinalPrice
            Distributor_Discount__c = 0.00,        // Distributor Discount
            Comment__c = 'test02',                   // Comment
            Price__c = 0.00                   // Value
        );
        insert soLineItem1;
        
        Login_Country__c logCountryObj = new Login_Country__c();
        logCountryObj.Name ='Turkey'; 
        logCountryObj.For_Contry__c ='Turkey';
        logCountryObj.Sales_Org_Code__c ='7110';        
        logCountryObj.Show_Delivery_Date__c =true;
        logCountryObj.Show_PO_Date__c =true;
        logCountryObj.PO_Date__c =true;
        logCountryObj.Delivery_Date__c =true;
        insert logCountryObj;
        

    
}
    
    
    static testMethod void method() {
        Account accObj = [Select id From Account LIMIT 1];
        Sales_Order__c soObj =[select id,Remarks__c from Sales_Order__c where Remarks__c = 'DomesticSalesSK' LIMIT 1];
        Sku__c sku = [Select id From Sku__c LIMIT 1 ];
        Sales_Order_Line_Item__c soli= [select id from Sales_Order_Line_Item__c where Sale_Order__c =:soObj.Id  LIMIT 1] ;
        
        PageReference pageRef = Page.OrderTurkey_Edit;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('acid',accObj.id);
        pageRef.getParameters().put('soid',soObj.id);
        
 		ApexPages.StandardController sc = new ApexPages.StandardController(soObj);
        OrderTurkey_EditController ordmanage = new OrderTurkey_EditController(sc);
        ordmanage.skuIdChosen = sku.Id; 
      
        ordmanage.fetchDistributorDetails();
        ordmanage.changePayment();
        ordmanage.searchProdValue='ADITYA';
        ordmanage.searchProduct();
        
        OrderTurkey_EditController.SKUDetails wrapObj = new OrderTurkey_EditController.SKUDetails();
        wrapObj.skuId=sku.Id;
        wrapObj.qty = 300;
        wrapObj.finalPrice = '45000';
        wrapObj.soliId=soli.id;
        wrapObj.netRateEntered = 1236547;
        wrapObj.comment='testSK--Domestic';
        ordmanage.skuDetailsMap.put(wrapObj.skuId,wrapObj);
        ordmanage.skuSaleOrderMap.put(wrapObj.skuId,wrapObj);
        
        ordmanage.skuIdChosen = sku.Id;
        ordmanage.addSOItem();
        ordmanage.sampleDisable=true;
        ordmanage.confirmOrder();
        ordmanage.showOrderHistory();
        ordmanage.deleteSOItem();
        ordmanage.deleteAllSKU();
        ordmanage.redirectFunction();
    }
    //.Brand_Name__c = 'BLUE'
    static testMethod void method2() {
        Account accObj = [Select id From Account LIMIT 1];
        Sales_Order__c soObj =[select id from Sales_Order__c where Remarks__c = 'SampleSalesSK' LIMIT 1];
        Sku__c sku1 = [Select id,Brand_Name__c From Sku__c where Brand_Name__c = 'BLUE' LIMIT 1 ];
        Sales_Order_Line_Item__c soli= [select id from Sales_Order_Line_Item__c where Sale_Order__c =:soObj.Id  LIMIT 1] ;
        
        PageReference pageRef = Page.OrderTurkey_Edit;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('acid',accObj.id);
        pageRef.getParameters().put('soid',soObj.id);
        
 		ApexPages.StandardController sc = new ApexPages.StandardController(soObj);
        OrderTurkey_EditController ordmanage = new OrderTurkey_EditController(sc);
      
        OrderTurkey_EditController.SKUDetails wrapObj2 = new OrderTurkey_EditController.SKUDetails();
        wrapObj2.finalPrice = '0';
        wrapObj2.netRateEntered = 0;
        wrapObj2.qty = 40;
        wrapObj2.comment='testSKsam';
        ordmanage.skuDetailsMap.put(wrapObj2.skuId,wrapObj2);
    
        ordmanage.skuIdChosen = null;
        ordmanage.addSOItem();
        
    }
    
    static testMethod void method3() {
        Account accObj = [Select id From Account LIMIT 1];
        Sales_Order__c soObj =[select id from Sales_Order__c where Remarks__c = 'SampleSalesSK' LIMIT 1];
        Sku__c sku = [Select id,Brand_Name__c From Sku__c where Brand_Name__c = 'ADITYA' LIMIT 1 ];
        Sku__c sku1 = [Select id,Brand_Name__c From Sku__c where Brand_Name__c = 'BLUE' LIMIT 1 ];
        Sales_Order_Line_Item__c soli= [select id from Sales_Order_Line_Item__c where Sale_Order__c =:soObj.Id  LIMIT 1] ;
        
        PageReference pageRef = Page.OrderTurkey_Edit;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('acid',accObj.id);
        pageRef.getParameters().put('soid',soObj.id);
        
 		ApexPages.StandardController sc = new ApexPages.StandardController(soObj);
        OrderTurkey_EditController ordmanage = new OrderTurkey_EditController(sc);
        ordmanage.fetchDistributorDetails();
        ordmanage.changePayment();
        ordmanage.searchProdValue='ADITYA';
        ordmanage.searchProduct();
        //updating existing
        OrderTurkey_EditController.SKUDetails wrapObj = new OrderTurkey_EditController.SKUDetails();
        wrapObj.skuId=sku.Id;
        wrapObj.finalPrice = '0';
        wrapObj.netRateEntered = 0;
        wrapObj.qty = 10;
        wrapObj.soliId=soli.id;
        wrapObj.comment='testSKsample';
        ordmanage.skuDetailsMap.put(wrapObj.skuId,wrapObj);
        ordmanage.skuSaleOrderMap.put(wrapObj.skuId,wrapObj);
        ordmanage.skuIdChosen = sku.Id;
        ordmanage.addSOItem();
        
       //insert new soli 
        OrderTurkey_EditController.SKUDetails wrapObj2 = new OrderTurkey_EditController.SKUDetails();
        wrapObj2.skuId=null;
        wrapObj2.finalPrice = '0';
        wrapObj2.netRateEntered = 0;
        wrapObj2.qty = 10;
        wrapObj2.soliId=null;
        wrapObj2.comment='testSKsample12';
        ordmanage.skuDetailsMap.put(wrapObj2.skuId,wrapObj2);
        ordmanage.skuSaleOrderMap.put(wrapObj2.skuId,wrapObj2);
        ordmanage.skuIdChosen = null;
        ordmanage.addSOItem();
        
        ordmanage.sampleDisable=true;
        ordmanage.confirmOrder();
        ordmanage.showOrderHistory();
        ordmanage.deleteSOItem();
        ordmanage.deleteAllSKU();
        ordmanage.redirectFunction();
 }
    static testMethod void method4() {
        Account accObj = [Select id From Account LIMIT 1];
        Sales_Order__c soObj =[select id from Sales_Order__c where Remarks__c = 'DomesticSalesSK' LIMIT 1];
        Sku__c sku1 = [Select id,Brand_Name__c From Sku__c where Brand_Name__c = 'BLUE' LIMIT 1 ];
        Sales_Order_Line_Item__c soli= [select id from Sales_Order_Line_Item__c where Sale_Order__c =:soObj.Id  LIMIT 1] ;
        
        PageReference pageRef = Page.OrderTurkey_Edit;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('acid',accObj.id);
        pageRef.getParameters().put('soid',soObj.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(soObj);
        OrderTurkey_EditController ordmanage = new OrderTurkey_EditController(sc);
        OrderTurkey_EditController.SKUDetails wrapObj2 = new OrderTurkey_EditController.SKUDetails();
        wrapObj2.finalPrice = '123';
        wrapObj2.netRateEntered = 125463;
        wrapObj2.qty = 40;
        wrapObj2.comment='testSKDOM';
        ordmanage.skuDetailsMap.put(wrapObj2.skuId,wrapObj2);
        ordmanage.skuIdChosen = null;
        ordmanage.addSOItem();
        
    }
    
    
}