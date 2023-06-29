@isTest
public class OrderTurkeyTest {
    
    //testing data setup for all methods in this class
    @testSetup
    static void allTheDataForThisTestClass() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
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
            Description__c = 'Domestic Sales',     // Description
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
        
         Payment_Term__c paymentTermObj = new Payment_Term__c(
            Payment_Term_Code__c = '0015',                     // Payment Term Code
            Payment_Term__c = 'Cash',                         // Payment Term
            Payterms_Desc__c = 'Pagamento estrito em 30 dias.',  // Payterms Desc
            Sales_Org__c = sorg.Id,                    // Sales Org
            Active__c = false                                   // Active
        );
        insert paymentTermObj;
        
        
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
      //  acc.CustomerAccountGroup__c = 'Z031';
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
        dsmObj.PriceGroupMaster__c = pg.id;
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
        crdIf.Distributor__c=acc.Id;
        crdIf.Sales_Org__c=sorg.Id;        
        crdIf.Distributor_Code__c='00010001225';
        insert crdIf;
        
        OrderTemplate__c ordTemp =new OrderTemplate__c();
        ordTemp.DistributorCustomerCode__c=acc.Id;
        ordTemp.Name='ADITYA 300.00 ML';
        insert ordTemp;
        
        OrderTemplateItem__c ordTempItem = new OrderTemplateItem__c();
        ordTempItem.Name = 'ADITYA';
        ordTempItem.OrderTemplate__c=ordTemp.Id;
        ordTempItem.SKU__c = sku.Id;
        insert ordTempItem;
        
        Order__c ord = new Order__c();
        ord.Shipping_Location__c = shippLoc.id;  
        ord.Bill_To_Party__c = acc.Id;        
        ord.Order_Date__c = system.today();  
        ord.Order_Type__c = orderTypeObj.Id;
        ord.Order_Raise_By__c = 'Distributor';                                     
        ord.Order_Status__c = 'Pending';                                        
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
        ordItem.comment__c='ui';
        ordItem.Quantity__c = 100;          
        ordItem.Special_Discount__c = 0.00;     
        ordItem.Price__c = 23000;            
        ordItem.Order__c = ord.Id;    
        ordItem.Stock_Available__c = false;  
        insert ordItem; 
        
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
        
        Account acc = [Select id From Account LIMIT 1];
        Order__c ord = [Select id From Order__c LIMIT 1];
        Sku__c sku = [Select id From Sku__c LIMIT 1];
        Order_Type__c orderType =[select id from Order_Type__c LIMIT 1];
        OrderTemplate__c ordTemp = [Select id From OrderTemplate__c LIMIT 1];
        Depot__c depot=[Select Id, Name from Depot__c]; 
        
        Sales_Order__c sObj= new Sales_Order__c();
        PageReference pageRef = Page.OrderTurkey;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('acid',acc.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(ord);
        OrderTurkeyController ordmanage = new OrderTurkeyController(sc);
        
        
        ordmanage.country = 'Turkey';
        OrderTurkeyController.DistributorWrapper distributorWrapperObj = new OrderTurkeyController.DistributorWrapper();
        distributorWrapperObj.country = 'Turkey';
        ordmanage.country = 'Turkey';
        ordmanage.selectedOrderType = orderType.Id;
        
        
        
        ordmanage.fetchDistributorDetails();
        ordmanage.fetchSKUData();
        ordmanage.accountId = acc.Id;
	    ordmanage.changeOrderType();
        ordmanage.selectedOrderType = orderType.id;
      
        ordmanage.searchProdValue = 'ADITYA';
        ordmanage.searchProduct();
        ordmanage.skuIdChosen = sku.Id;
        
        ordmanage.changeOrderType();
       // ordmanage.addSKU();
        //ordmanage.deleteSKU();
        ordmanage.searchProdValue = 'ADITYA';
        ordmanage.searchProduct();
        ordmanage.skuIdChosen = sku.Id;
       // ordmanage.addSKU();
       // ordmanage.deleteAllSKU();
        ordmanage.searchProdValue = 'ADITYA';
        ordmanage.searchProduct();
        ordmanage.skuIdChosen = sku.Id;
       // ordmanage.addSKU();
        ordmanage.changePayment();
         OrderTurkeyController.SKUDetails wrapObj1 = new OrderTurkeyController.SKUDetails();
        wrapObj1.qty=100;
      	wrapObj1.finalPrice='2000';
        wrapObj1.comment ='ydi';
        wrapObj1.customerDeliveryDate = System.today();
        
        ordmanage.addSKU();
        ordmanage.createOrder();
        ordmanage.updateSKU();
        ordmanage.refreshOrderValue();
        ordmanage.templateName = 'test';
        ordmanage.saveTemplate();
        ordmanage.tempIdChosen = ordTemp.Id;
        ordmanage.sampleDisable=true;
       
        OrderTurkeyController.SKUDetails wrapObj = new OrderTurkeyController.SKUDetails();
        wrapObj.qty=100;
      	wrapObj.finalPrice='2000,5';
        wrapObj.comment ='yi';
        wrapObj.customerDeliveryDate = System.today();
        
        ordmanage.addSOLineItem();
        ordmanage.confirmOrder();
       
        ordmanage.createSalesOrder();
        ordmanage.editOrder();
        ordmanage.showOrderTemplates();
        ordmanage.loadTemplate();
        ordmanage.getTemplateName();
        ordmanage.showOrderHistory();
        ordmanage.redirectFunction();
        
    }
    
    static testMethod void method2(){
        Account acc = [Select id From Account];
        Order__c ord = [Select id From Order__c limit 1];
        Sku__c sku = [Select id From SKu__c];
        OrderTemplate__c ordTemp = [Select id From OrderTemplate__c];
        
     
        PageReference pageRef2 = Page.OrderTurkey;
        Test.setCurrentPage(pageRef2);
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(ord);
        OrderTurkeyController ordmanage2 = new OrderTurkeyController(sc2);
        
        ordmanage2.fetchDistributorDetails();
        ordmanage2.fetchSKUData();
        ordmanage2.skuIdChosen = sku.Id;
       // ordmanage2.addSKU();
        ordmanage2.orderId= ord.id;//'12345678906';
      //  ordmanage2.DeleteOrderObj();
        ordmanage2.deleteSKU();
        ordmanage2.deleteAllSKU();
        
        ordmanage2.throwEx = true;
        ordmanage2.fetchDistributorDetails();
        
        ordmanage2.fetchSKUData();
        ordmanage2.fetchPopular();
        ordmanage2.searchProdValue = '';
        ordmanage2.searchProduct();
        
        ordmanage2.addSKU();
        
        ordmanage2.createOrder();
        
        ordmanage2.updateSKU();
        
        ordmanage2.deleteSKU();
        
        ordmanage2.refreshOrderValue();
        
        ordmanage2.templateName = 'test';
        
        ordmanage2.saveTemplate();
        ordmanage2.tempIdChosen = ordTemp.Id;
        
        ordmanage2.saveOrder();
        
        ordmanage2.confirmOrder();
        ordmanage2.createSalesOrder();
        
        ordmanage2.editOrder();
        
        ordmanage2.showOrderTemplates();
        
        ordmanage2.loadTemplate();
        
        ordmanage2.getTemplateName();
        
        ordmanage2.showOrderHistory();
        
       // ordmanage2.changeDepot();
        
        ordmanage2.deleteAllSKU();
        //End of Logic
    }
    static testMethod void method3(){
        
         Account acc = [Select id From Account];
        Order__c ord = [Select id From Order__c limit 1];
        Sku__c sku = [Select id From SKu__c];
        OrderTemplate__c ordTemp = [Select id From OrderTemplate__c];
        
     
        PageReference pageRef2 = Page.OrderTurkey;
        Test.setCurrentPage(pageRef2);
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(ord);
        OrderTurkeyController ordmanage3 = new OrderTurkeyController(sc2);
        ordmanage3.profilName='Regional tech & technical sales Turkey';
        
        ordmanage3.accountId = acc.Id;
        ordmanage3.fetchDistributorDetails();
        
        OrderTurkeyController.SKUDetails wrapOb = new OrderTurkeyController.SKUDetails();
        wrapOb.qty=200;
      	wrapOb.finalPrice='0';
        wrapOb.comment ='yi';
        ordmanage3.addSKU();
     
        
        
        
    }
    
    
}