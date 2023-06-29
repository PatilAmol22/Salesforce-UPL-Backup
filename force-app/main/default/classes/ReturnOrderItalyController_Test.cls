@isTest
public class ReturnOrderItalyController_Test 
{
    static testMethod void validateGetBlankOrderItemList()
    {
        Test.startTest();
        ReturnOrderItalyController.getBlankOrderItemList();
        Test.stopTest();
    }
   
    Static testmethod void validateSaveOrderWithOutAccount()
    {
        //Inserting Order__c Data
        Order__c order = new Order__c();
        insert Order;        
        
        Test.startTest();
        ReturnOrderItalyController.saveOrder('','',order.id,false,'');
        Test.stopTest();
    }
    
    Static testmethod void validateSaveOrderWithAccount()
    {
        String sapCode = '123456';
        String accountid;
        Account account = new Account();
        
        //Inserting Account data
        account = TestDataFactory.CreateAccount(sapCode);
        account.id = accountid;
        
        //Inserting Sales_Org__c data
        Sales_Org__c salesOrg = new Sales_Org__c();
        salesOrg.Sales_Org_Code__c = '2410';
        salesOrg.Country_Code__c = 'IT';
        Insert salesOrg;
        
        Test.startTest();
        ReturnOrderItalyController.saveOrder(accountid,'','',false,'');
        Test.stopTest();
    }
    
    static testmethod void validateUpdateOrderLineItems()
    {
        Test.startTest();
        ReturnOrderItalyController.updateOrderLineItems('');
        Test.stopTest();
        
    }
    
    static testmethod void validateDeleteOrderItems()
    {
        //Inserting Order Data
        Order__c order = new Order__c();
        insert Order;
        
        Test.startTest();
        ReturnOrderItalyController.deleteOrderItems(Order.id);
        Test.stopTest();
        
    }
     static testmethod void validateDeleteOrderItems2()
    {
        //Inserting Order Data
        Order__c order = new Order__c();
        insert Order;
        
        Test.startTest();
        ReturnOrderItalyController.deleteOrderItems(null);
        Test.stopTest();
        
    }
    static testMethod void validateDeleteOItem()
    {
        Test.startTest();
        ReturnOrderItalyController.deleteOItem('','','');
        Test.stopTest();
    }
    
    static testMethod void validateSalesOrderPDF()
    {
        String sapCode = '123456';
        String accountid;
        Account account = new Account();
        
        //Inserting Account data
        account = TestDataFactory.CreateAccount(sapCode);
        account.id = accountid;
        
        Test.startTest();
        ReturnOrderItalyController.saveSalesOrderPFD(accountid);
        Test.stopTest();
    }
    
    static testMethod void validateGetCartOrderItems()
    {
        String sapCode = '123456';
        String accountid;
        
        Account account = new Account();
        
        //Inserting Account data
        account = TestDataFactory.CreateAccount(sapCode);
        account.id = accountid;
        
        //Inserting Order Data
        Order__c order = new Order__c();
        order.Order_Status__c = 'Draft';
        order.Bill_To_Party__c = accountid;
        order.Order_Type_Italy__c = 'Return Order';
        Insert order;
        
        //Inserting Order Line Item Data
        OrderLineItem__c orderLineItem = new OrderLineItem__c();
        orderLineItem.Order__c = order.id;
        Insert orderLineItem;
        
        Test.startTest();
        ReturnOrderItalyController.getCartOrderItems(accountid);
        Test.stopTest();
    } 
    
    
    static testMethod void validateGetShippingLoations()
    {
        String sapCode = '123456';
        String accountid;
        
        Account account = new Account();
        
        //Inserting Account data
        account = TestDataFactory.CreateAccount(sapCode);
        account.id = accountid;
        
        Test.startTest();
        ReturnOrderItalyController.getShippingLoations(accountid);
        Test.stopTest();    
    }
    
    static testMethod void validategetSalesOrderItems()
    {
        //Inserting Sales Order data
        Sales_Order__c SalesOrder = new Sales_Order__c();
        Insert SalesOrder;
        
        //Inserting Sales_Order_Line_Item__c data
        Sales_Order_Line_Item__c SalesOrderLineItem = new Sales_Order_Line_Item__c();
        SalesOrderLineItem.Sale_Order__c = SalesOrder.id;
        SalesOrderLineItem.Inventory_Description_Italy__c = 'testing';
        SalesOrderLineItem.Rebate_2__c = 10;
        SalesOrderLineItem.Product_Type_Italy__c = 'Vendita';
        SalesOrderLineItem.FinalPrice2__c = 10;
        Insert SalesOrderLineItem;
        
        
        Test.startTest();
        ReturnOrderItalyController.getSalesOrderItems(SalesOrder.Id);
        Test.stopTest();    
    }
    
    static testMethod void validategetSalesOrder()
    {
        //Inserting Sales Order data
        Sales_Order__c SalesOrder = new Sales_Order__c();
        SalesOrder.Order_Type_Italy__c = 'Return Order';
        Insert SalesOrder;
        
        
        Test.startTest();
        ReturnOrderItalyController.getSalesOrder(SalesOrder.Id);
        ReturnOrderItalyController.getSalesSTP(SalesOrder.Id);
        Test.stopTest();    
    }
    
    static testMethod void validatesaveOrderItems()
    {
        List<Sales_Org__c> SalesOrgList = New List<Sales_Org__c>();
        List<Sales_Order_Line_Item__c> SalesOrderItemList = New List<Sales_Order_Line_Item__c>();
        List<ReturnOrderItalyController.SalesOrderItem> SalesOrderItemWrapper = New List<ReturnOrderItalyController.SalesOrderItem>();
        
        ReturnOrderItalyController.SalesOrderItem dataObj = new ReturnOrderItalyController.SalesOrderItem();
        
        //Insert Product
        Product2  Product = new Product2 ();
        Product.Name = 'MANZATE 82 WP';
        Product.Combination_Key__c ='12345testqw';
        Insert Product;
        
        
        //Inserting Sales Order data
        Sales_Order__c SalesOrder = new Sales_Order__c();
        Insert SalesOrder;
        
        //Inserting Sales_Order_Line_Item__c data
        /*Sales_Order_Line_Item__c SalesOrderLineItem = new Sales_Order_Line_Item__c();
        SalesOrderLineItem.Sale_Order__c = SalesOrder.id;
        SalesOrderLineItem.Inventory_Description_Italy__c = 'testing';
        SalesOrderLineItem.Rebate_2__c = 10;
        SalesOrderLineItem.Product_Type_Italy__c = 'Omaggio';
        SalesOrderLineItem.FinalPrice2__c = 10;
        SalesOrderLineItem.Accrual_Discount__c = 5;
        SalesOrderItemList.add(SalesOrderLineItem);
        Insert SalesOrderItemList; */
        
        //Insert Sales Org Data
        Sales_Org__c SalesOrg = New Sales_Org__c();
        SalesOrg.Sales_Org_Code__c = '2410';
        SalesOrgList.add(SalesOrg);
        Insert SalesOrgList;
        
        //Insert Depot Data
        Depot__c Depot = New Depot__c();
        Depot.Depot_Code__c = 'IT00';
        Insert Depot;
        
        //Insert Distribution_Channel__c
        Distribution_Channel__c DistributionChannel = new Distribution_Channel__c();
        DistributionChannel.Distribution_Channel_Code__c = '20';
        Insert DistributionChannel;
        
        //Insert SKU Data
        SKU__c SKU = New SKU__c();
        SKU.Sales_Org__c = SalesOrg.id; 
        SKU.Sales_Agent_MSP__c = 10;
        SKU.Area_Manager_MSP__c = 10;
        SKU.Sales_Director_MSP__c = 10;
        SKU.Active__c = true;
        SKU.SKU_Code__c = '123456789';
        SKU.Distribution_Channel__c = DistributionChannel.Id;
        Insert SKU;
        
        
        dataObj.typeOfProduct = 'Omaggio';
        dataObj.qty = 10;
        dataobj.productId = String.valueOf(SKU.Id);
        dataobj.shipDate = String.valueOf(date.today());
        SalesOrderItemWrapper.add(dataObj);
        
        
        Test.startTest();
        ReturnOrderItalyController.saveOrderItems(SalesOrder,SalesOrderItemWrapper,SalesOrgList,'','');
        // ReturnOrderItalyController.saveSalesOrder(SalesOrder,'Test');
        Test.stopTest();    
    } 
    
    static testMethod void validatesaveOrderItems2()
    {
        List<Sales_Org__c> SalesOrgList = New List<Sales_Org__c>();
        List<Sales_Order_Line_Item__c> SalesOrderItemList = New List<Sales_Order_Line_Item__c>();
        List<ReturnOrderItalyController.SalesOrderItem> SalesOrderItemWrapper = New List<ReturnOrderItalyController.SalesOrderItem>();
        ReturnOrderItalyController.SalesOrderItem dataObj = new ReturnOrderItalyController.SalesOrderItem();
        String serlizeStr;
        
        //Insert Product
        /*Product2  Product = new Product2 ();
        Product.Name = 'MANZATE 82 WP';
        Product.Combination_Key__c = '123454567ywedewd';
        Insert Product; */
        
        
        //Inserting Sales Order data
        Sales_Order__c SalesOrder = new Sales_Order__c();
        Insert SalesOrder;
        
       /* //Inserting Sales_Order_Line_Item__c data
        Sales_Order_Line_Item__c SalesOrderLineItem = new Sales_Order_Line_Item__c();
        SalesOrderLineItem.Sale_Order__c = SalesOrder.id;
        SalesOrderLineItem.Inventory_Description_Italy__c = 'testing';
        SalesOrderLineItem.Rebate_2__c = 10;
        SalesOrderLineItem.Product_Type_Italy__c = 'Omaggio';
        SalesOrderLineItem.FinalPrice2__c = 10;
        SalesOrderLineItem.Accrual_Discount__c = 5;
        SalesOrderItemList.add(SalesOrderLineItem);
        Insert SalesOrderItemList; */
        
        //Insert Sales Org Data
        Sales_Org__c SalesOrg = New Sales_Org__c();
        SalesOrg.Sales_Org_Code__c = '2410';
        SalesOrgList.add(SalesOrg);
        Insert SalesOrgList;
        
        //Insert Depot Data
        Depot__c Depot = New Depot__c();
        Depot.Depot_Code__c = 'IT00';
        Insert Depot;
        
        //Insert Distribution_Channel__c
        Distribution_Channel__c DistributionChannel = new Distribution_Channel__c();
        DistributionChannel.Distribution_Channel_Code__c = '20';
        Insert DistributionChannel;
        
        //Insert SKU Data
        SKU__c SKU = New SKU__c();
        SKU.Sales_Org__c = SalesOrg.id; 
        SKU.Sales_Agent_MSP__c = 10;
        SKU.Area_Manager_MSP__c = 10;
        SKU.Sales_Director_MSP__c = 10;
        SKU.Active__c = true;
        SKU.SKU_Code__c = '123456789';
        SKU.Distribution_Channel__c = DistributionChannel.Id;
        Insert SKU;
        
        
        dataObj.typeOfProduct = 'Vendita';
        dataObj.qty = 10;
        dataobj.productId = String.valueOf(SKU.Id);
        dataobj.shipDate = String.valueOf(date.today());
        SalesOrderItemWrapper.add(dataObj);
        
        serlizeStr = JSON.serialize(SalesOrderItemWrapper);  
        
        //Inserting User Data
        User u1 =TestDataFactory.CreateUser();
        
        userrole  usrole = new userrole();
        usrole.Name ='Customer User';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'System Administrator'];
        
        User sobj1 = new User();
        sobj1.Alias = 'TestUser';                                                            
        sobj1.Email = 'swapnil.more@in.ibm.com';                             
        sobj1.ProfileId  = p.ID;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122334.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='More';
        sobj1.CommunityNickname = 'zonalExe1223 Di'; 
        sobj1.TimeZoneSidKey = 'America/Sao_Paulo'; 
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId=usrole.id;
        sobj1.Marketing_Manager__c = u1.id;
        insert sobj1;
        
        Test.startTest();
        ReturnOrderItalyController.saveOrderItems(SalesOrder,SalesOrderItemWrapper,SalesOrgList,'','');
        System.runAs(sobj1)
        {
            ReturnOrderItalyController.saveSalesOrder(SalesOrder,serlizeStr);            
        }
        ReturnOrderItalyController.updateOrderLineItems(serlizeStr);
        Test.stopTest();    
    } 
    
    static testMethod void validatesaveOrder2()
    {
        List<Sales_Org__c> SalesOrgList = New List<Sales_Org__c>();
        List<Sales_Order_Line_Item__c> SalesOrderItemList = New List<Sales_Order_Line_Item__c>();
        List<ReturnOrderItalyController.SalesOrderItem> SalesOrderItemWrapper = New List<ReturnOrderItalyController.SalesOrderItem>();
        ReturnOrderItalyController.SalesOrderItem dataObj = new ReturnOrderItalyController.SalesOrderItem();
        String serlizeStr;
        
        //Insert Product
        /*Product2  Product = new Product2 ();
        Product.Name = 'MANZATE 82 WP';
        Product.Combination_Key__c = '123456test';
        Insert Product; */
        
        
        //Inserting Sales Order data
        Sales_Order__c SalesOrder = new Sales_Order__c();
        Insert SalesOrder;
        
        //Inserting Sales_Order_Line_Item__c data
       /*Sales_Order_Line_Item__c SalesOrderLineItem = new Sales_Order_Line_Item__c();
        SalesOrderLineItem.Sale_Order__c = SalesOrder.id;
        SalesOrderLineItem.Inventory_Description_Italy__c = 'testing';
        SalesOrderLineItem.Rebate_2__c = 10;
        SalesOrderLineItem.Product_Type_Italy__c = 'Omaggio';
        SalesOrderLineItem.FinalPrice2__c = 10;
        SalesOrderLineItem.Accrual_Discount__c = 5;
        SalesOrderItemList.add(SalesOrderLineItem);
        Insert SalesOrderItemList; */
        
        //Insert Sales Org Data
        Sales_Org__c SalesOrg = New Sales_Org__c();
        SalesOrg.Sales_Org_Code__c = '2410';
        SalesOrgList.add(SalesOrg);
        Insert SalesOrgList;
        
        //Insert Depot Data
        Depot__c Depot = New Depot__c();
        Depot.Depot_Code__c = 'IT00';
        Insert Depot;
        
        //Insert Distribution_Channel__c
        Distribution_Channel__c DistributionChannel = new Distribution_Channel__c();
        DistributionChannel.Distribution_Channel_Code__c = '20';
        Insert DistributionChannel;
        
        //Insert SKU Data
        SKU__c SKU = New SKU__c();
        SKU.Sales_Org__c = SalesOrg.id; 
        SKU.Sales_Agent_MSP__c = 10;
        SKU.Area_Manager_MSP__c = 10;
        SKU.Sales_Director_MSP__c = 10;
        SKU.Active__c = true;
        SKU.SKU_Code__c = '123456789';
        SKU.Distribution_Channel__c = DistributionChannel.Id;
        Insert SKU;
        
        
        dataObj.typeOfProduct = 'Vendita';
        dataObj.qty = 10;
        dataobj.productId = String.valueOf(SKU.Id);
        dataobj.shipDate = String.valueOf(date.today());
        SalesOrderItemWrapper.add(dataObj);
        
        serlizeStr = JSON.serialize(SalesOrderItemWrapper);  
        
        //Inserting User Data
        User u1 =TestDataFactory.CreateUser();
        
        userrole  usrole = new userrole();
        usrole.Name ='Customer User';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Customer Service & Finance Manager Italy'];
        
        User sobj1 = new User();
        sobj1.Alias = 'TestUser';                                                            
        sobj1.Email = 'swapnil.more@in.ibm.com';                             
        sobj1.ProfileId  = p.ID;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122334.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='More';
        sobj1.CommunityNickname = 'zonalExe1223 Di'; 
        sobj1.TimeZoneSidKey = 'America/Sao_Paulo'; 
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId=usrole.id;
        sobj1.Country_Head__c = u1.id;
        
        insert sobj1;
        
        //Insert Order_Type__c data
        Order_Type__c OrderType =  New Order_Type__c();
        OrderType.Order_Type_Code__c = 'ZIR1';
        OrderType.SalesOrg__c =  SalesOrg.Id;
       
        Insert OrderType;
        
        Test.startTest();
        System.runAs(sobj1)
        {
            ReturnOrderItalyController.saveSalesOrder(SalesOrder,serlizeStr);            
        }
        Test.stopTest();    
    } 
    
    static testMethod void validatesaveOrderItems3()
    {
        List<Sales_Org__c> SalesOrgList = New List<Sales_Org__c>();
        List<Sales_Order_Line_Item__c> SalesOrderItemList = New List<Sales_Order_Line_Item__c>();
        List<ReturnOrderItalyController.SalesOrderItem> SalesOrderItemWrapper = New List<ReturnOrderItalyController.SalesOrderItem>();
        ReturnOrderItalyController.SalesOrderItem dataObj = new ReturnOrderItalyController.SalesOrderItem();
        String serlizeStr;
        
        //Insert Product
        Product2  Product = new Product2 ();
        Product.Name = 'MANZATE 82 WP';
        Product.Combination_Key__c = '1234test';
        Insert Product;
        
        
        //Inserting Sales Order data
        Sales_Order__c SalesOrder = new Sales_Order__c();
        Insert SalesOrder;
        
        //Inserting Sales_Order_Line_Item__c data
        /*Sales_Order_Line_Item__c SalesOrderLineItem = new Sales_Order_Line_Item__c();
        SalesOrderLineItem.Sale_Order__c = SalesOrder.id;
        SalesOrderLineItem.Inventory_Description_Italy__c = 'testing';
        SalesOrderLineItem.Rebate_2__c = 10;
        SalesOrderLineItem.Product_Type_Italy__c = 'Omaggio';
        SalesOrderLineItem.FinalPrice2__c = 10;
        SalesOrderLineItem.Accrual_Discount__c = 5;
        SalesOrderItemList.add(SalesOrderLineItem);
        Insert SalesOrderItemList;*/
        
        //Insert Sales Org Data
        Sales_Org__c SalesOrg = New Sales_Org__c();
        SalesOrg.Sales_Org_Code__c = '2410';
        SalesOrgList.add(SalesOrg);
        Insert SalesOrgList;
        
        //Insert Depot Data
        Depot__c Depot = New Depot__c();
        Depot.Depot_Code__c = 'IT00';
        Insert Depot;
        
        //Insert Distribution_Channel__c
        Distribution_Channel__c DistributionChannel = new Distribution_Channel__c();
        DistributionChannel.Distribution_Channel_Code__c = '20';
        Insert DistributionChannel;
        
        //Insert SKU Data
        SKU__c SKU = New SKU__c();
        SKU.Sales_Org__c = SalesOrg.id; 
        SKU.Sales_Agent_MSP__c = 10;
        SKU.Area_Manager_MSP__c = 10;
        SKU.Sales_Director_MSP__c = 10;
        SKU.Active__c = true;
        SKU.SKU_Code__c = '123456789';
        SKU.Distribution_Channel__c = DistributionChannel.Id;
        Insert SKU;
        
        
        dataObj.typeOfProduct = 'Vendita';
        dataObj.qty = 10;
        dataobj.productId = String.valueOf(SKU.Id);
        dataobj.shipDate = String.valueOf(date.today());
        dataobj.TransContribution = null;
        dataobj.TransContribution2 = null;
        SalesOrderItemWrapper.add(dataObj);
        
        serlizeStr = JSON.serialize(SalesOrderItemWrapper);  
        
        
        Test.startTest();
        ReturnOrderItalyController.updateOrderLineItems(serlizeStr);
        Test.stopTest();    
    } 
    
    static testMethod void validateOrderItems()
    {
        ReturnOrderItalyController.CartWrapper Cart = New ReturnOrderItalyController.CartWrapper();
        ReturnOrderItalyController.SalesOrderItem SalesOrderItem = New ReturnOrderItalyController.SalesOrderItem();
        
        //Inserting Order Data
        Order__c order = new Order__c();
        Insert order;
        
        //Insert Sales Org Data
        Sales_Org__c SalesOrg = New Sales_Org__c();
        SalesOrg.Sales_Org_Code__c = '2410';
        Insert SalesOrg;
        
        //Insert SKU Data
        SKU__c SKU = New SKU__c();
        SKU.Sales_Org__c = SalesOrg.id; 
        SKU.Sales_Agent_MSP__c = 10;
        SKU.Area_Manager_MSP__c = 10;
        SKU.Sales_Director_MSP__c = 10;
        SKU.Active__c = true;
        SKU.SKU_Code__c = '123456789';
        Insert SKU;
        
        SalesOrderItem.typeOfProduct = 'Omaggio';
        SalesOrderItem.qty = 10;
        SalesOrderItem .productId = String.valueOf(SKU.Id);
        SalesOrderItem.shipDate = String.valueOf(date.today());
        
        ReturnOrderItalyController.OrderItems(Cart,order,SalesOrderItem);
        
    }
    
    static testMethod void validategetPaymentTermCustomerMap()
    {
        Test.startTest();
        ReturnOrderItalyController.getPaymentTermCustomerMap('');
        Test.stopTest();
    }
    
    static testMethod void validatefetchDistributorDetails()
    {
        String sapCode = '123456';
        
        //Insert Payment_Term__c
        Payment_Term__c PaymentTerm = new Payment_Term__c();
        PaymentTerm.Payment_Term_Code__c = '123456';
        Insert PaymentTerm; 
        
        Account account = new Account();
        
        //Inserting Account data
        account = TestDataFactory.CreateAccount(sapCode);
        account.Payment_Term_Code__c = PaymentTerm.Id;
        Update account;
        
        //Inserting Distribution_Channel__c
        Distribution_Channel__c DistributionChannel = New Distribution_Channel__c();
        DistributionChannel.Distribution_Channel_Code__c = '67';
        Insert DistributionChannel;
        
        //Inserting DistributorSalesAreaMapping__c data
        DistributorSalesAreaMapping__c DistributorSalesAreaMappingData = new DistributorSalesAreaMapping__c();
        DistributorSalesAreaMappingData.Distributor__c = account.Id;
        DistributorSalesAreaMappingData.Manually_Created__c = false;
        DistributorSalesAreaMappingData.DistributionChannel__c = DistributionChannel.Id;
        Insert DistributorSalesAreaMappingData;
        
        //Insert Payments__c
        Payments__c Payment = New Payments__c();
        Payment.Net_Overdue__c = 10;
        Payment.Customer_Name__c = account.Id;
        Insert Payment;
        
        //Insert Credit_Info__c
        Credit_Info__c CreditInfo = New Credit_Info__c();
        CreditInfo.Distributor__c = account.Id;
        CreditInfo.Credit_Limit__c = 10;
        CreditInfo.Used_Limit__c = 10;
        CreditInfo.Balance_Limit__c = 10;
        CreditInfo.DAYS_ARREARS__c = 10;
        CreditInfo.Internal_Limit__c = 10;
        Insert CreditInfo;
        
        //Insert Distributor_Depot_Mapping__c
        Distributor_Depot_Mapping__c DepotMapping = new Distributor_Depot_Mapping__c();
        Insert DepotMapping;
        
        // Insert Trans_Contribution__c
        Trans_Contribution__c TransContri = New Trans_Contribution__c();
        TransContri.Name = 'Test';
        Insert TransContri;
        
        
        Test.startTest();
        ReturnOrderItalyController.fetchDistributorDetails(String.valueOf(account.id));
        ReturnOrderItalyController.getOrderFields(String.valueOf(account.id));
        Test.stopTest();
        
    } 
    
    static testMethod void validategetPaymentTermMap1()
    {
        //Inserting SalesOrg Data
        Sales_Org__c SalesOrg = New Sales_Org__c();
        SalesOrg.Sales_Org_Code__c = '2410';
        Insert SalesOrg;
        
        //Insert Payment Data
        Payment_Term__c PaymentTerm = New Payment_Term__c();
        PaymentTerm.Sales_Org__c = SalesOrg.id;
        PaymentTerm.Sequence_Number__c = 2;
        PaymentTerm.Payment_Term_Code__c ='Test';
        Insert PaymentTerm;
        
        Test.startTest();
        ReturnOrderItalyController.getPaymentTermMap1();
        Test.stopTest();
    } 
    
    static testMethod void validateGetProductTypes()
    {
        Test.startTest();
        ReturnOrderItalyController.getProductTypes();
        Test.stopTest();
    } 
    
    static testMethod void validategetSkuData()
    {
        String sapCode = '123456';
        String accountid;
        Account account = new Account();
        
        //Inserting Account data
        account = TestDataFactory.CreateAccount(sapCode);
        account.id = accountid;
        
        //Inserting Depot Data
        Depot__c Depot = new Depot__c();
        Depot.Location__c = 'IT00';
        Insert Depot;
        
        //Inserting SalesOrg Data
        Sales_Org__c SalesOrg = New Sales_Org__c();
        SalesOrg.Sales_Org_Code__c = '2410';
        Insert SalesOrg;
        
        //Insert SKU Data
        SKU__c SKU = New SKU__c();
        SKU.Sales_Org__c = SalesOrg.id; 
        SKU.Sales_Agent_MSP__c = 10;
        SKU.Area_Manager_MSP__c = 10;
        SKU.Sales_Director_MSP__c = 10;
        SKU.Active__c = true;
        SKU.SKU_Code__c = '123456789';
        Insert SKU;
        
        //Inserting PriceBookMaster__c data
        PriceBookMaster__c PriceBookMaster = new PriceBookMaster__c();
        PriceBookMaster.PG_CODE__c = NULL;
        PriceBookMaster.DistributorCustomerCode__c = NULL;
        PriceBookMaster.DepotCode__c = Depot.Id;
        PriceBookMaster.StartDate__c = Date.Today();
        PriceBookMaster.SKUCode__c = SKU.id;
        
        Test.startTest();
        ReturnOrderItalyController.getSkuData(accountid,'');
        Test.stopTest();
    } 
    
    static testMethod void validateprocessApproval()
    {
        //Inserting Sales Order Data
        Sales_Order__c SalesOrder = new Sales_Order__c();
        Insert SalesOrder;
        
        //Creating a process Instance
        ProcessInstance Process = new ProcessInstance();
        Process.TargetObjectId = SalesOrder.id;   
        
        //Creating Audit History
        AuditHistory__c AuditHistory = new AuditHistory__c();
        AuditHistory.SalesOrder__c = SalesOrder.Id;
        Insert AuditHistory;
        
        Test.startTest();
        ReturnOrderItalyController.processApproval(true,SalesOrder.Id,'Approved');
        Test.stopTest();
    }
    
    static testMethod void validateSortAuditHistory()
    {
        Test.startTest();
        ReturnOrderItalyController.sortAuditHistory();
        Test.stopTest();
    }  
    
    static testMethod void validategetPaymentTermMap()
    {
        Test.startTest();
        ReturnOrderItalyController.getPaymentTermMap('');
        Test.stopTest();
    }  
}