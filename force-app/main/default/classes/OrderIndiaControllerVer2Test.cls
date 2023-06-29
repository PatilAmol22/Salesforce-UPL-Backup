@isTest
public class OrderIndiaControllerVer2Test {

    @testSetup
    static void allDataForThisClass(){
        Profile p = [SELECT Id FROM Profile WHERE Name  = 'PartnerCommunity Distributor Profile' LIMIT 1];   
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        System.debug('devRecordTypeId :- '+devRecordTypeId);
        Price_Group_Master__c pgcode=new Price_Group_Master__c();
        pgcode.PG_Code__c='04';
        insert pgcode;
        
        PrIce_List_Type_Master__c pltmaster= new PrIce_List_Type_Master__c();
        pltmaster.Price_List_Type__c='03';
        insert pltmaster;
            
        Distribution_Channel__c discObj=new Distribution_Channel__c();
        discObj.Name='10';
        discObj.Description__c='xyz';
        discObj.Distribution_Channel_Code__c='2012';
        insert discObj;
        
        Division__c divObj= new Division__c();
        divObj.Name='Abc';
        divObj.Description__c = 'xyz';
        divObj.Division_Code__c= '10';
        insert divObj;
        
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesorg.Name='India';
        salesorg.Description__c='India';
        salesorg.Sales_Org_Code__c='1000';
        insert salesorg;
        
        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='SAATHI';
        pro.Sales_Org__c=salesOrg.Id;
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        insert pro;
        
        Region__c regObj= new Region__c();
        regObj.Name='Mumbai';
        regObj.RegionCode__c='045';
        insert regObj;
        
        Order_Type__c ordObj = new Order_Type__c();
        ordObj.Name='ZORD';
        ordObj.Description__c='abc';
        ordObj.Division__c=divObj.Id;
        ordObj.Order_Type_Code__c='ZORD';
        insert ordObj;
        
        State_Tax_Structure__c statetax = new State_Tax_Structure__c();
        statetax.State_Name__c = 'Maharashtra';
        statetax.Country__c = 'India';          
        statetax.Tax__c = 10;           
        statetax.State_Code__c = '13';
        statetax.AdditionalTax__c = 30;
        statetax.SalesOrg__c = salesOrg.Id;
        insert statetax;
        
         Depot__c depObj=new Depot__c();
        depObj.Name='Pune';
        depObj.Country__c='India';
        depObj.Location__c='Pune';
        depObj.Depot_Code__c='PUN1';
        depObj.Active__c=true;
        depObj.SalesOrg__c=salesorg.Id;
        depObj.Region__c=statetax.Id;
        insert depObj;
        
        SKU__c skuObj=new SKU__c();
        skuObj.Name='SAATHI';
        skuObj.SKU_Description__c='Saathi';
        skuObj.Active__c=true;
        skuObj.Brand_Name__c='brdskuname';
        skuObj.SKU_Pack__c=1.00;
        skuObj.Division__c=divObj.Id;
        skuObj.Group__c='SAATHI';
        skuObj.GST__c=18;
        skuObj.Pack_Size__c=10;
        skuObj.Product_Name__c=pro.Id;
        skuObj.Sales_Org__c=salesOrg.Id;
        skuObj.SKU_Code__c='52';
        skuObj.UOM__c='KG';
        skuObj.Combination_Key__c='Cooooooo000011111';
        insert skuObj;
        
        Distributor_Margin__c dmObj= new Distributor_Margin__c();
        dmObj.SKU_Code__c=skuObj.Id;
        dmObj.Discount__c=7.00;
        dmObj.Active__c=true;
        dmObj.Batch__c='dmbatch';
        dmObj.Depot_Code__c=depObj.Id;
        dmObj.Distribution_Channel__c=discObj.Id;
        dmObj.Division__c=divObj.Id;
        dmObj.PG_CODE__c=pgcode.Id;
        dmObj.Sales_Org__c=salesOrg.Id;
        dmObj.PrIce_List_Type__c=pltmaster.Id;
        dmObj.UOM__c='KG';
        dmObj.CurrencyIsoCode='INR';
        dmObj.StartDate__c = system.today();
        dmObj.EndDate__c = system.today()+1;
        dmObj.Material_Group__c=pro.Id;
        dmObj.Region_of_Delivery_Depot__c=statetax.Id;
        dmObj.Region__c=statetax.Id;
        insert dmObj;
        
        Placement__c pObj= new Placement__c();
        pObj.SKU_Code__c=skuObj.Id;
        pObj.Discount__c=7.00;
        pObj.Active__c=true;
        pObj.Batch__c='dmbatch';
        pObj.Depot_Code__c=depObj.Id;
        pObj.Distribution_Channel__c=discObj.Id;
        pObj.Division__c=divObj.Id;
        pObj.PG_Code__c=pgcode.Id;
        pObj.StartDate__c = system.today();
        pObj.EndDate__c = system.today()+1;
        pObj.Sales_Org__c=salesOrg.Id;
        pObj.SKU_Code__c=skuObj.Id;
        pObj.PrIce_List_Type__c=pltmaster.Id;
        pObj.UOM__c='KG';
        pObj.CurrencyIsoCode='INR';
        pObj.Material_Group__c=pro.Id;
        pObj.Region_of_Delivery_Depot__c=statetax.Id;
        pObj.Region__c=statetax.Id;
        insert pObj;
        
        System.debug('skuObj test:------'+skuObj);
        System.debug('dmObj test :------'+dmObj);
        
        /*Payment_Term__c  ptObj=new Payment_Term__c();
        ptObj.Name='';
        ptObj.Active__c='';
        ptObj.Payment_Term__c='';
        ptObj.Payment_Term_Code__c='';*/
        
        Account acnt= new Account();
        acnt.Name = 'Azhar skinternational';
        acnt.Email__c='azhar.shaikh@skinternational.com';
        acnt.BillingCity ='Pune';
        acnt.BillingCountry='India';
        acnt.RecordTypeId=devRecordTypeId;
        acnt.Mobile__c='9867341712';
        acnt.Phone='020256580';
        acnt.Sales_Org__c=salesOrg.Id;
        acnt.SAP_Code__c='SAP123456';
        acnt.Depot_Code__c=depObj.Id;
        acnt.Distribution_Channel__c=discObj.Id;
        acnt.Division__c=divObj.Id;
        //acnt.PriceGroupCode__c=pgcode.id;
        acnt.State_Tax_Structure__c=statetax.Id;
        //   acnt.Region__c=regObj.Id;
        //acnt.Region__c=statetax.Id;
        //acnt.PrIce_List_Type__c=pltmaster.Id;
        insert acnt;
        System.debug('acnt class :-----'+acnt);
        
        
        SKU_Pack_Size__c skpsizeObj= new SKU_Pack_Size__c();
        skpsizeObj.Pack_Size__c='20';
        skpsizeObj.SKU__c=skuObj.Id;
        skpsizeObj.UOM__c='KG';
        skpsizeObj.Depot__c=depObj.Id;
        insert skpsizeObj;
        
        Contact conObj=new Contact();
        conObj.FirstName='Abc';
        conObj.LastName='test';
        conObj.Accountid=acnt.Id;
        insert conObj;
        
        UserRole usroleObj=new UserRole();
        usroleObj.Name='Sk International';
        
        Credit_Info__c creObj= new Credit_Info__c();
        creObj.Distributor__c=acnt.Id;
        creObj.Credit_Limit__c=1000;
        creObj.Balance_Limit__c=1000;
        creObj.Used_Limit__c=1000;
        creObj.Distributor_Code__c='1000500';
        insert creObj;
        
        /*Outstanding_Ageing__c outObj=new Outstanding_Ageing__c();
outObj.Name='testout';
outObj.Net_Outstanding__c='Rs';
insert outObj;*/
        
        Shipping_Location__c shpObj =new Shipping_Location__c();
        shpObj.Location_Name__c='Mumbai';
        shpObj.Distributor__c=acnt.Id;
        shpObj.City__c='Pune';
        shpObj.Pincode__c='4200011';
        shpObj.State__c='Maharashtra';
        shpObj.Country__c='India';
        shpObj.SAP_Code__c=acnt.SAP_Code__c;
        insert shpObj;
        
        DistributorSalesAreaMapping__c disareaObj=new DistributorSalesAreaMapping__c();
        disareaObj.DistributionChannel__c=discObj.Id;
        disareaObj.Distributor__c=acnt.Id;
        disareaObj.SalesOrg__c=salesOrg.Id;
        disareaObj.Division__c=divObj.Id;
        disareaObj.PrIceListTypeMaster__c=pltmaster.Id;
        disareaObj.PriceGroupMaster__c=pgcode.id;
        disareaObj.AccountOwner__c = UserInfo.getUserId();
        insert disareaObj;
        
        Distributor_Depot_Mapping__c disDepMap=new Distributor_Depot_Mapping__c();
        disDepMap.Distributor__c=acnt.Id;
        disDepMap.Depot__c=depObj.Id;
        insert disDepMap;
        
        PriceBookMaster__c pbmObj= new PriceBookMaster__c();
        pbmObj.SKUCode__c=skuObj.Id;
        pbmObj.DepotCode__c=depObj.Id;
        pbmObj.Price__c=520;
        pbmObj.Sales_Org__c=salesOrg.Id;
        pbmObj.Division__c=divObj.Id;
        pbmObj.StartDate__c = system.today();
        pbmObj.EndDate__c = system.today()+1;
        pbmObj.PG_CODE__c=pgcode.Id;
        pbmObj.UOM__c='NOS';
        pbmObj.Active__c=true;
        pbmObj.Batch__c='test';
        pbmObj.CompositeKey__c='test1';
        pbmObj.PrIce_List_Type__c=pltmaster.Id;
        pbmObj.CurrencyIsoCode='INR';
        pbmObj.Price_Book_Change__c=true;
        insert pbmObj;
        //pbmObj.Order_Type__c=ordObj.Id;
        
        PricebookDiscount__c PbDis = new PricebookDiscount__c();
        PbDis.Batch__c = 'test';                                               
        PbDis.DepotCode__c = depObj.Id;                                  
        PbDis.DistributorCustomerCode__c = acnt.Id;                              
        PbDis.EndDate__c = System.today()+1;                         
        PbDis.PerUnit__c = 1.00;                                                 
        PbDis.PG_Code__c = pgcode.Id;                                   
        PbDis.SKUCode__c = skuObj.Id;                             
        PbDis.StartDate__c = system.today();                         
        PbDis.Active__c = false;                                               
        PbDis.Price__c = 200.00;                                                 
        PbDis.UOM__c = 'KG';                                                   
        PbDis.CompositeKey__c = '01-04-2016BHA103000000000000692001';           
        insert PbDis;
        
        User userObj = new User();
        userObj.Alias='Austin';
        userObj.Email='steve.austin@mid.org';
        userObj.ContactId=conObj.Id;
        userObj.UserRoleId=usroleObj.id;
        userObj.Username='steve.austin@mid.org';
        userObj.ProfileId=p.Id;
        userObj.IsActive=true;
        userObj.Show_Inventory__c=false;
        userObj.Show_Credit_Limit__c=false;
        userObj.LastName='Terriotory Manager';
        userObj.CommunityNickname = 'zonalExe1222 Di'; 
        userObj.TimeZoneSidKey = 'Asia/Kolkata'; 
        userObj.LocaleSidKey = 'en_IN';                                    
        userObj.LanguageLocaleKey = 'en_US';                                             
        userObj.ForecastEnabled = false;                                                     
        userObj.EmailEncodingKey = 'ISO-8859-1';  
        insert userObj;
        
        System.debug('userObj :----------- '+userObj);
        
        TM_Depot_Mapping__c TMDepoMap = new TM_Depot_Mapping__c();
        TMDepoMap.Depot__c = depObj.Id;        // Depot
        TMDepoMap.Territory_Manager__c = userObj.id;  // Territory Manager
        insert TMDepoMap;
        
        Inventory__c invObj=new Inventory__c();
        invObj.SKU__c=skuObj.Id;
        invObj.Batch_Number__c = 'CMUMTX2506'; 
        invObj.Stock_Quantity__c=20000.00;
        invObj.In_transit_stock_quantity__c=15000.00;
        invObj.Sales_Org__c=salesOrg.Id;
        invObj.Depot__c=depObj.Id;
        invObj.Division__c=divObj.Id;
        invObj.UOM__c='L';
        invObj.SKU_Depot__c ='sd1';
        insert invObj;
        
        OrderTemplate__c ordTempObj =new OrderTemplate__c();
        ordTempObj.DistributorCustomerCode__c=acnt.Id;
        ordTempObj.Name='SAATHI 120.00 ML';
        insert ordTempObj;
        
        OrderTemplateItem__c ordTempItem = new OrderTemplateItem__c();
        ordTempItem.Name = 'SAATHI';
        ordTempItem.OrderTemplate__c=ordTempObj.Id;
        ordTempItem.SKU__c = skuObj.Id;
        insert ordTempItem;
        
        Order__c orObj=new Order__c();
        orObj.Bill_To_Party__c=acnt.Id;
        orObj.Order_Date__c=system.today();
        orObj.Order_Raise_By__c='Distributor';
        orObj.Order_Status__c='Pending';
        orObj.Vat__c=statetax.Tax__c;
        orObj.Sales_Org__c =salesOrg.Id; 
        orObj.Shipping_Location__c=shpObj.Id;        
        orObj.Distribution_Channel__c =discObj.Id; 
        orObj.Division__c = divObj.Id;
        insert orObj;
        
        Sales_Order__c soObj=new Sales_Order__c();
        soObj.Sold_to_Party__c = acnt.Id;
        soObj.Bill_To_Party__c = acnt.Id;
        soObj.Order_Date__c = System.today();
        soObj.Order_Raise_By__c = 'Distributor';
        soObj.Order_Status__c = 'Open';
        soObj.CreatedFrom__c = 'SFDC';
        soObj.Order__c = orObj.Id;
        soObj.Sales_Org_lk__c = salesOrg.Id;
        soObj.Distribution_Channel_lk__c = discObj.Id;
        soObj.Division_lk__c = divObj.Id;
        soObj.PONumber__c = '2500';
        insert soObj;
        
        OrderLineItem__c ordItem = new OrderLineItem__c();
        ordItem.Item_Status__c = 'test';          
        ordItem.SKU_Name__c = skuObj.Id; 
        ordItem.Item_Number__c = '10';          
        ordItem.UOM__c = 'L';                   
        ordItem.No_of_Case__c = 1;            
        ordItem.Invoice_Discount__c = 0.00;     
        ordItem.Quantity__c = 100;          
        ordItem.Special_Discount__c = 0.00;     
        ordItem.Price__c = 23000;            
        ordItem.Order__c = orObj.Id;    
        ordItem.Stock_Available__c = false;  
        insert ordItem;   
        
        Sales_Order_Line_Item__c  solIObj= new Sales_Order_Line_Item__c();
        solIObj.SKU_Name__c = skuObj.Id;
        solIObj.PriceBookMaster__c = pbmObj.Id;
        solIObj.Sale_Order__c= soObj.id;
        solIObj.Item_Status__c = 'Active';
        solIObj.No_of_Case__c = 20;
        solIObj.DepotDepot__c = depObj.Id; 
        solIObj.UOM__c = 'KG';
        insert solIObj;
        
    }
    
    static testMethod void method(){
        Account acnt=[Select Id from Account];
        Order__c ord=[Select Id from Order__c];
        Sku__c sku=[Select Id from Sku__c];
        OrderTemplate__c ort=[Select Id from OrderTemplate__c];
        Depot__c dep=[Select Id from Depot__c];
        
        PageReference pageref=Page.OrderIndiaControllerVer2;
        Test.setCurrentPage(pageref);
        pageref.getParameters().put('acid',acnt.id);
        
        //OrderIndiaControllerVer2 orderIndia=new OrderIndiaControllerVer2();
        ApexPages.StandardController sc= new ApexPages.StandardController(ord);
        OrderIndiaControllerVer2 controller=new OrderIndiaControllerVer2(sc);
        //
        
        controller.depoId = dep.id;
        controller.state = 'Maharashtra';
        controller.country = 'India';
        controller.PO = '23423';
        controller.fetchDistributorDetails();
        controller.fetchSKUData();
        controller.searchProdValue = 'SAATHI';
        controller.searchProduct();
        controller.skuIdChosen = sku.Id;
        
        controller.addSKU();
        controller.createOrder();
        controller.updateSKU();
        controller.calculateTax();
        controller.refreshOrderValue();
        controller.templateName = 'test';
        controller.saveTemplate();
        controller.tempIdChosen = ort.Id;
        controller.confirmOrder();
        controller.editOrder();
        controller.showOrderTemplates();
        controller.loadTemplate();
        controller.getTemplateName();
        controller.showOrderHistory();
        controller.changeDepot();
        controller.addSOLineItem();
        controller.createSalesOrder();
        controller.redirectFunction();
        
    }
    static testMethod void method2(){
        Account acnt=[Select Id from Account];
        Order__c ord=[Select Id from Order__c];
        Sku__c sku=[Select Id from Sku__c];
        OrderTemplate__c ort=[Select Id from OrderTemplate__c];
        Depot__c dep=[Select Id from Depot__c];
        
        PageReference pageref2=Page.OrderIndiaControllerVer2;
        Test.setCurrentPage(pageref2);
        pageref2.getParameters().put('acid',acnt.id);
        ApexPages.StandardController sc2= new ApexPages.StandardController(ord);
        OrderIndiaControllerVer2 controller2=new OrderIndiaControllerVer2(sc2);
      	controller2.depoId = dep.id;
        controller2.fetchDistributorDetails();
        controller2.fetchSKUData();
        controller2.skuIdChosen = sku.Id;
        controller2.addSKU();
        controller2.deleteSKU();
        controller2.deleteAllSKU();
        
        controller2.throwEx = true;
        controller2.fetchDistributorDetails();
        
        controller2.fetchSKUData();
        
        controller2.searchProdValue = 'SAATHI';
        controller2.searchProduct();
        
        controller2.addSKU();
        
        controller2.createOrder();
        
        controller2.updateSKU();
        
        controller2.deleteSKU();
        
        controller2.calculateTax();
        
        controller2.refreshOrderValue();
        
        controller2.templateName = 'test';
        
        controller2.saveTemplate();
        controller2.tempIdChosen = ord.Id;
        
        controller2.saveOrder();
        
        controller2.confirmOrder();
        
        controller2.editOrder();
        
        controller2.showOrderTemplates();
        
        controller2.loadTemplate();
        
        controller2.getTemplateName();
        
        controller2.showOrderHistory();
        
        controller2.changeDepot();
        
        controller2.addSOLineItem();
        
        controller2.createSalesOrder();
        //controller2.setOrderType();
        
        controller2.deleteAllSKU();
        controller2.redirectFunction();
        
    }
}