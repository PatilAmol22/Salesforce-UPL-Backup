@isTest
public class OrderIndiaTest {
    
    //testing data setup for all methods in this class
    @testSetup
    static void allTheDataForThisTestClass() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Test.startTest();
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='UPL SAS';
        sorg.Description__c='UPL SAS';
        sorg.Sales_Org_Code__c='1410';//1000';
        sorg.Company_Code__c='1400';            // Updated for RITM0491228 GRZ(Dheeraj Sharma) 20-01-2023
        insert sorg;
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        PrIce_List_Type_Master__c pltmaster= new PrIce_List_Type_Master__c();
        pltmaster.Price_List_Type__c='03';
        //pltmaster.Zone_Name__c='Test Zone';//This field is Not available in Prod.Check before deploying.
        insert pltmaster;
        
        //Auto_Number__c auto = new Auto_Number__c();
        //auto.Name='FarmerCode';
        //auto.Sequence__c='11';
        //insert auto;
        
        Depot__c dp =new Depot__c ();
        dp.Name='Pune';
        dp.Country__c='India';
        dp.Location__c='Pune';
        dp.Depot_Code__c='PUN1';
        dp.SalesOrg__c=sorg.Id;      
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
        sku.GST__c=18;
        sku.Combination_Key__c='Cooooooo000011111';
        insert sku;
        
         
        SKU__c sku1 = new SKU__c();
        sku1.Name='DOST1';
        sku1.SKU_Code__c='704003';
        sku1.SKU_Pack__c=1.00;
        sku1.SKU_UOM__c='L';
        sku1.Group__c='DOST1';
        sku1.Pack_Size__c=10.00;
        sku1.Product_Name__c=pro.Id;
        sku1.Sales_Org__c = sorg.Id;
        sku1.UOM__c='L';
        sku1.Active__c=True;
        sku1.GST__c=18;
        sku1.Combination_Key__c='Cooooooo000011341';
        insert sku1;
        List<PriceBookMaster__c> PBList=New  List<PriceBookMaster__c>();
        PriceBookMaster__c PbMaster = new PriceBookMaster__c();
        PbMaster.SKUCode__c = sku.id;           
        PbMaster.DepotCode__c =dp.id;         
        PbMaster.Price__c = 34500;                    
        PbMaster.PG_CODE__c =Pg.Id;  
        PbMaster.UOM__c = 'NOS';                          
        PbMaster.StartDate__c = system.today();
        PbMaster.EndDate__c = system.today()+1;
        PbMaster.Active__c = true;                      
        PbMaster.PerUnit__c = 1;                       
        PbMaster.Batch__c ='test'; 
        PbMaster.CompositeKey__c='c1';
        PbMaster.PrIce_List_Type__c=pltmaster.Id;
        PbMaster.Payment_Term__c='ZV47';
        PBList.add(PbMaster);
        
        PriceBookMaster__c PbMaster1 = new PriceBookMaster__c();
        PbMaster1.SKUCode__c = sku1.id;           
        PbMaster1.DepotCode__c =dp.id;         
        PbMaster1.Price__c = 34500;                    
        PbMaster1.PG_CODE__c =Pg.Id;  
        PbMaster1.UOM__c = 'NOS';                          
        PbMaster1.StartDate__c = system.today();
        PbMaster1.EndDate__c = system.today()+1;
        PbMaster1.Active__c = true;                      
        PbMaster1.PerUnit__c = 1;                       
        PbMaster1.Batch__c ='test1'; 
        PbMaster1.CompositeKey__c='c123';
        PbMaster1.PrIce_List_Type__c=pltmaster.Id;
        PBList.add(PbMaster1);
        Insert PBList;
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZORD';              
        ordType.Description__c = 'Credit';    
        ordType.Order_Type_Code__c = 'ZORD';
        ordType.SalesOrg__c=sorg.Id;
        insert ordType;
        
        Account acc = new Account();
        acc.Name='Bhavik Devdhar';
        acc.Last_Name__c='Devdhar';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='9967341759';
        acc.Phone='020256589';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Pune';
        acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        acc.Payment_Terms__c='Zv48';
        //sayan 14.4
        //acc.Decision_Maker__pc = 'No';
        //sayan 14.4
        //  acc.OwnerId=sobj.Id;
        insert acc;
        //Added by Nandhini
        Matching_Discount__c matchDiscount=new Matching_Discount__c();
        matchDiscount.DistributorCustomerCode__c=acc.Id;
        matchDiscount.StartDate__c=system.today();
        matchDiscount.EndDate__c=system.today()+2;
        matchDiscount.SKUCode__c=sku.Id;
        matchDiscount.CompositeKey__c='223234';
        matchDiscount.Price__c=50;
        insert matchDiscount;
        
        DistributorSalesAreaMapping__c dsmObj = new DistributorSalesAreaMapping__c();
        dsmObj.Distributor__c = acc.Id;
        dsmObj.SalesOrg__c = sorg.Id;
        dsmObj.DistributionChannel__c = disbj.Id; 
        dsmObj.PriceGroupMaster__c =pg.id;
        dsmObj.Division__c = Divbj.Id;
        dsmObj.AccountOwner__c = UserInfo.getUserId();
        dsmObj.PrIceListTypeMaster__c=pltmaster.Id;
        //dsmObj.Company_Code__c='Test';
        insert dsmObj;
        
        contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName=acc.Last_Name__c;
        insert con;
        
        /*userrole  usrole = new userrole();
        usrole.Name ='Bhavik Devdhar Customer User';
        
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
        insert sobj1;*/
        
        TM_Depot_Mapping__c TMDepoMap = new TM_Depot_Mapping__c();
        TMDepoMap.Depot__c = dp.Id;        // Depot
        TMDepoMap.Territory_Manager__c = UserInfo.getUserId();  // Territory Manager
        insert TMDepoMap;
        
        Shipping_Location__c shippLoc =new Shipping_Location__c();
        shippLoc.Location_Name__c ='Same as Billing Address'; 
        shippLoc.Region__c='S.No:46/1, A1 Building, First Floor, Office No.101 E-Space, Wadgoan Sheri,Nagar Rd, Aga Nagar,';
        shippLoc.Distributor__c=acc.Id;
        shippLoc.City__c='Pune';
        shippLoc.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc.SAP_Code__c='SAP0001';
        shippLoc.State__c='13';
        shippLoc.Sales_Org__c=sorg.Id;
        insert shippLoc;
        
        Shipping_Location__c shippLoc2 =new Shipping_Location__c();
        shippLoc2.Location_Name__c ='Mumbai'; 
        shippLoc2.Region__c='S.No:46/1, A1 Building, First Floor, Office No.101 E-Space, Wadgoan Sheri,Nagar Rd, Aga Nagar,';
        shippLoc2.Distributor__c=acc.Id;
        shippLoc2.City__c='Pune';
        //shippLoc2.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc2.SAP_Code__c = acc.SAP_Code__c;
        shippLoc2.State__c='13';
        shippLoc2.Sales_Org__c=sorg.Id;
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
		spelDis.PrIce_List_Type__c=pltmaster.Id;        
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
        PbDis.PrIce_List_Type__c=pltmaster.Id;
        PbDis.Sales_Org__c = sorg.Id;
        insert PbDis;
        
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
        statetax.Country__c = 'India';          
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
        insert ord;
        //Modified by Nandhini
        List<OrderLineItem__c> orderLineItemList=new List<OrderLineItem__c>();
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
        ordItem.Payment_Term__c='Zv47';
        orderLineItemList.add(ordItem) ; 
        
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
        
        orderLineItemList.add(ordItem1) ; 
        insert orderLineItemList;
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=ord.id;
        insert attach;
        
        Test.stopTest();
    }
/*  
* Name: confirmOrder    
* return:void
* Description: APPS-4845-This method responsible to cover ConfirmOrder method.
*/
    Public Static testMethod void confirmOrder(){
        Test.startTest();
        Account acc = [Select id From Account];
        Order__c ord = [Select id From Order__c];
        List<Sku__c> sku = [Select id From SKu__c];
        //OrderTemplate__c ordTemp = [Select id From OrderTemplate__c];
        Depot__c dpObj = [Select id From Depot__c];
        //PriceBookMaster__c pbMaster=[Select Id from PriceBookMaster__c where SKU__c =:sku[1] Limit 1];
        PageReference pageRef = Page.OrderIndia;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('acid',acc.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ord);
        OrderIndiaController orderIndia = new OrderIndiaController(sc);
        orderIndia.depoId = dpObj.id;
        orderIndia.state = 'Maharashtra';
        orderIndia.country = 'India';
        orderIndia.PO = '23423';
        orderIndia.accountId=acc.Id;
       
        orderIndia.fetchDistributorDetails();
        orderIndia.skuIdChosen = sku[0].Id;
        orderIndia.addSKU();
        orderIndia.orderSaved=true;
        orderIndia.confirmOrder();
        orderIndia.setOrderType();
        orderIndia.orderId=ord.Id;
        orderIndia.skuIdChosen = sku[1].Id;
        orderIndia.addSKU();
        Id loggedInUser=UserInfo.getUserId();
        String userIdString=String.valueOf(loggedInUser);
        orderIndia.tmID=userIdString;
        orderIndia.zmID=userIdString;
       
        orderIndia.templateName='test';
        orderIndia.pbdPercent=20;
        orderIndia.sidPercent=25;
        
        orderIndia.profilName='PartnerCommunity Distributor Profile';
        orderIndia.confirmOrder();
        
        List<Sales_Order__c> salesOrderList=[Select id from Sales_Order__c];
        System.assert(salesOrderList.size()>1);
        orderIndia.selectedCompany='1400';
        orderIndia.creditSalesArea();
        orderIndia.redirectFunction();
       
        OrderIndiaController.DistributorWrapper distributorWrapper=new OrderIndiaController.DistributorWrapper();
        distributorWrapper.salesOrgNames='India';
        distributorWrapper.creditLimit=5000;
        distributorWrapper.daysArrears=10;
        distributorWrapper.creditUsed=2000;
        distributorWrapper.paymentOutstanding=2500;
        distributorWrapper.greaterThan90=20;
        OrderIndiaController.CreditParse creditWrap=new OrderIndiaController.CreditParse();
        creditWrap.CreditLimit='2000';
        creditWrap.CreditExposure='1000';
        creditWrap.BalanceLimit='1000';
        
        Test.stopTest();
    }
    static testMethod void method() {
        Account acc = [Select id From Account];
        Order__c ord = [Select id From Order__c];
        Sku__c sku = [Select id From SKu__c Limit 1];
        OrderTemplate__c ordTemp = [Select id From OrderTemplate__c];
        Depot__c dpObj = [Select id From Depot__c];
        
        PageReference pageRef = Page.OrderIndia;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('acid',acc.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ord);
        OrderIndiaController ordmanage = new OrderIndiaController(sc);
        ordmanage.depoId = dpObj.id;
        ordmanage.state = 'Maharashtra';
        ordmanage.country = 'India';
        ordmanage.PO = '23423';
        ordmanage.fetchDistributorDetails();
        ordmanage.fetchSKUData();
        ordmanage.searchProdValue = 'DOST';
        ordmanage.searchProduct();
        ordmanage.skuIdChosen = sku.Id;
        
        ordmanage.addSKU();
        ordmanage.addSKU();
        ordmanage.createOrder();
        ordmanage.updateSKU();
        ordmanage.calculateTax();
        ordmanage.refreshOrderValue();
        ordmanage.templateName = 'test';
        ordmanage.saveTemplate();
        ordmanage.tempIdChosen = ordTemp.Id;
        ordmanage.confirmOrder();
        ordmanage.editOrder();
        ordmanage.showOrderTemplates();
        ordmanage.loadTemplate();
        Test.startTest();
        ordmanage.getTemplateName();
        ordmanage.showOrderHistory();
        ordmanage.changeDepot();
        ordmanage.addSOLineItem();
        ordmanage.createSalesOrder();
        Test.stopTest();
        //ordmanage.setOrderType();
        //ordmanage.redirectFunction();
    }
    
    static testMethod void method2(){
        Account acc = [Select id From Account];
        Order__c ord = [Select id From Order__c];
        Sku__c sku = [Select id From SKu__c Limit 1];
        OrderTemplate__c ordTemp = [Select id From OrderTemplate__c];
        Depot__c dpObj = [Select id From Depot__c];
        
        //Logic to execute Exception Handling & deleteSKU()
        PageReference pageRef2 = Page.OrderIndia;
        Test.setCurrentPage(pageRef2);
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(ord);
        OrderIndiaController ordmanage2 = new OrderIndiaController(sc2);
        ordmanage2.depoId = dpObj.id;
        ordmanage2.fetchDistributorDetails();
        ordmanage2.fetchSKUData();
        ordmanage2.skuIdChosen = sku.Id;
        ordmanage2.addSKU();
        ordmanage2.deleteSKU();
        ordmanage2.deleteAllSKU();
        
        ordmanage2.throwEx = true;
        ordmanage2.fetchDistributorDetails();
        
        ordmanage2.fetchSKUData();
        
        ordmanage2.searchProdValue = 'DOST';
        ordmanage2.searchProduct();
        
        ordmanage2.addSKU();
        
        ordmanage2.createOrder();
        
        ordmanage2.updateSKU();
        
        ordmanage2.deleteSKU();
        
        ordmanage2.calculateTax();
        
        ordmanage2.refreshOrderValue();
        
        ordmanage2.templateName = 'test';
        
        ordmanage2.saveTemplate();
        ordmanage2.tempIdChosen = ordTemp.Id;
        
        ordmanage2.saveOrder();
        Test.startTest();
        ordmanage2.confirmOrder();
        
        ordmanage2.editOrder();
        
        ordmanage2.showOrderTemplates();
        
        ordmanage2.loadTemplate();
        
        ordmanage2.getTemplateName();
        
        ordmanage2.showOrderHistory();
        
        ordmanage2.changeDepot();
        
        ordmanage2.addSOLineItem();
        
        ordmanage2.createSalesOrder();
        //   ordmanage2.setOrderType();
        
        ordmanage2.deleteAllSKU();
        Test.stopTest();
        //End of Logic
    }
    
/*
    * Description: Test Class for UPL Sales Details Custom Metadata in UtilityClass
	* Param: NA
	* return : NA
    * */
     @isTest
    static void testSalesOrgDetails(){
        Test.startTest();
        	System.assertNotEquals(0 , UtilityClass.getSalesOrgDetails().size(), 'No SalesOrder details returned');
        Test.stopTest();
    }
    
    /*
    * Description: Test Class for existing UPL Sales Details in custom settings
	* Param: NA
	* return : NA
    * */
    @isTest
    static void testExistingSalesOrgDetails(){
        Test.startTest();
        	UtilityClass.getSalesOrgIndiaSAS();
        	UtilityClass.getCompanyCodeIndiaSAS();
        	UtilityClass.getSalesOrgIndiaOld();
        Test.stopTest();
    }
}