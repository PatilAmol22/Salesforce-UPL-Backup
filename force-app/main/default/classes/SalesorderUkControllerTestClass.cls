@isTest
public class SalesorderUkControllerTestClass {
    
    static testMethod void SalesorderUkController() {
        
        Product2 pro = new Product2();
        pro.Name = 'Test Product';
        pro.ProductCode = '121312';
        pro.Combination_Key__c = '86433';
        insert pro;
        /* ------------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 --------- */
        Login_Country__c logCountryObj = new Login_Country__c();
        logCountryObj.Name ='United Kingdom'; 
        logCountryObj.For_Contry__c ='United Kingdom';
        logCountryObj.Sales_Org_Code__c ='2031';
        logCountryObj.Delivery_Date__c= true;
        logCountryObj.PO_Date__c = true;
        logCountryObj.Show_Delivery_Date__c = true;
        logCountryObj.Show_PO_Date__c = true;
        insert logCountryObj;
        
        Login_Country__c logCountryObj2 = new Login_Country__c();
        logCountryObj2.Name ='Ireland'; 
        logCountryObj2.For_Contry__c ='Ireland';
        logCountryObj2.Sales_Org_Code__c ='2032';
        logCountryObj2.Delivery_Date__c= true;
        logCountryObj2.PO_Date__c = true;
        logCountryObj2.Show_Delivery_Date__c = true;
        logCountryObj2.Show_PO_Date__c = true;
        insert logCountryObj2;
        /* ---------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 -------------- */
        
        Sales_Org__c soc = new Sales_Org__c();
        soc.Name = 'United Kingdom';
        soc.Description__c = 'United Kingdom';
        soc.Sales_Org_Code__c = '2031';                  
        soc.Continent__c = 'Europe';
        soc.Company_Code__c = '2031';
        soc.Country_Code__c = 'UK';
        insert soc;
        
        Payment_Term__c paymentTermObj = new Payment_Term__c(
            Payment_Term__c = 'Net 7 days',   // Payment Term
            Payment_Term_Code__c = 'UK01',      // Payment Term Code
            Payterms_Desc__c = 'Net 7 days',    // Payterms Desc
            Sales_Org__c = soc.Id,   // Sales Org
            Days_to_calc_interest__c = 0,     // Days (to calc interest)
            Active__c = true,                   // Active
            CombinationKey__c = '5710UK01'     // CombinationKey
        );
        insert paymentTermObj; 
        
        Distribution_Channel__c DistributionChannelObj = new Distribution_Channel__c(
            Name = '20',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '20',  // Distribution Channel Code
            Description__c='test'
        );
        insert DistributionChannelObj;
        
        SKU__c sku = new SKU__c();
        sku.Brand_Name__c = 'Brand';
        sku.Pack_Size__c =0.00;
        sku.Unit_Cost__c =200;
        sku.Area_Manager_MSP__c =150;
        sku.Sales_Agent_MSP__c = 500;
        sku.Sales_Director_MSP__c = 50;
        sku.Sales_Org__c = soc.Id;
        sku.Material_type__c = 'Fert';       
        sku.Product_Name__c = pro.Id;
        sku.UOM__c = 'L';
        sku.Active__c = true;
        sku.Distribution_Channel__c = DistributionChannelObj.Id;
        sku.SKU_Code__c = '2031';
        sku.Combination_Key__c = '27654';
        insert sku;
        
        
        
        account acc1 = new account();
        acc1.Name = 'Test345999';
        acc1.Phone = '87656687';
        acc1.Depot_Code__c = 'vghdfg';
        acc1.SAP_Code__c = '12567345';
        //acc1.RecordTypeId = devRecordAcc;
        acc1.Business_Type__c ='B to C';
        acc1.Incoterms_Part_2__c = 'FREIGHT PAID BY UPL';
        acc1.Payment_Term_Code__c = paymentTermObj.Id;                          // Payment Term Code
        acc1.Payment_Terms__c = 'UK07';         
        acc1.Distribution_Channel__c = DistributionChannelObj.Id;
        acc1.AuthorizationGroupSalesoffice__c='';
        acc1.Tax_classification_for_customer__c ='1';
        acc1.Account_Type__c = 'Sold_to_Party__c';
        acc1.Distributor_Name__c = 'UK';
        acc1.Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA';         // Billing Street 1
        acc1.Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE';  // Billing Street 2
        acc1.Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO'; 
        acc1.Sales_Org__c = soc.id;
        insert acc1 ;
        
        
        Depot__c depot = new Depot__c();
        depot.Name = 'UK12';
        depot.Location__c ='UK12';
        depot.Depot_Code__c = 'UK12';
        depot.SalesOrg__c = soc.Id;
        insert depot;
        
        
        
        PriceBookMaster__c pbm = new PriceBookMaster__c();
        pbm.DepotCode__c =depot.Id;
        pbm.SKUCode__c = sku.Id;
        pbm.UOM__c= 'L';
        pbm.DistributorCustomerCode__c = acc1.Id;
        pbm.CompositeKey__c ='werty456787';
        pbm.Active__c = true;
        pbm.StartDate__c = date.today();
        pbm.EndDate__c = date.today();
        pbm.Active__c = true;
        insert pbm;
        
        Order_Type__c ot = new Order_Type__c();
        ot.Name ='ZOR1';
        ot.Description__c = 'ZOR1';
        ot.SalesOrg__c = soc.Id;
        ot.Combination_Key__c = '203110ZOR1';
        ot.Order_Type_Code__c = 'ZOR1';
        insert ot;
                
        Division__c DivisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert DivisionObj;
        
          
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [
            SELECT Id, Title, LatestPublishedVersionId 
            FROM ContentDocument
        ];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acc1.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        SalesorderUkController.docWrapper docWrap = new SalesorderUkController.docWrapper();
        List<SalesorderUkController.docWrapper> docWrapList = new List<SalesorderUkController.docWrapper>();
        docWrap.name = 'dov';
        docWrap.base64 = '231';
        docWrap.contentVersionId = contentVersion.id;
        docWrap.documentId=documents[0].Id;
        docWrapList.add(docWrap);
        String seralizeddocWrap = JSON.serialize(docWrapList);
      
        Price_Group_Master__c priceGroupMasterObj = new Price_Group_Master__c(
            PG_Code__c = '95',                // PG Code
            Description_Colombia__c = 'Casagro'  // Description
        );
        insert priceGroupMasterObj;
        
        DistributorSalesAreaMapping__c dsam = new DistributorSalesAreaMapping__c();
        dsam.AccountType__c = 'Sold To Party';
        dsam.DistributionChannel__c = depot.Id;
        dsam.Distributor__c = acc1.id;
        dsam.SalesOrg__c =soc.Id;
        dsam.OrderBlock__c = false;                   
        dsam.DistributionChannel__c = DistributionChannelObj.id; 
        dsam.Division__c = divisionObj.id;             
        dsam.PriceGroupMaster__c = priceGroupMasterObj.id; 
        insert dsam ; 
        
        
        Shipping_Location__c slc = new Shipping_Location__c();
        slc.Billing_Street_6__c = 'jbskj';
        slc.Distributor__c = acc1.Id;
        slc.SAP_Code__c = '12567345';
        slc.Active__c = true;
        slc.Expiry_Date__c = date.today();
        insert slc;
        
        Inco_term__c itc = new Inco_term__c();
        itc.Active__c = true;
        itc.Name = 'ITC';
        itc.Combination_Key__c = '7687b';
        itc.IncoTerm_Code__c = '9869';
        itc.Sales_Org__c =  acc1.Sales_Org__c;
        insert itc;
        
        Order__c ord =new Order__c();
        ord.Bill_To_Party__c = acc1.Id;
        ord.Order_Date__c = date.today();
        ord.Order_Status__c = 'Draft';
        ord.Order_Type__c = ot.Id;
        insert ord;
        
        OrderLineItem__c oli = new OrderLineItem__c();
        oli.Order__c = ord.Id;
        oli.UOM__c = 'L';
        oli.Price_Book_Master__c = pbm.Id;
        oli.Quantity__c = 100;
        oli.Accrual_Discount__c = 10;
        oli.Per_Unit_Discount_UK__c = 10;
        oli.Price__c =10000;
        oli.Shipping_Date__c = date.today();
        oli.Comment__c = 'Great';
        oli.Delivery_Date__c = System.today()+30; // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022..
        insert oli;
        
        
        Sales_order__c salesorder= new Sales_order__c();
        salesorder.Depot__c = depot.Id;
        salesorder.Purchase_Order_Date__c = date.today();
        salesorder.Sold_to_Party__c = acc1.Id;
        salesorder.Order_Type_lk__c = ot.Id;
        salesorder.PONumber__c = '786cch';
        salesorder.Order_Status__c = 'Rejected';
        salesorder.Purchase_Order_Date__c = System.today()+30;  // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022..
        insert salesorder;
          System.Test.startTest(); // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022..
        Sales_Order_Line_Item__c soli = new Sales_Order_Line_Item__c();
        soli.PriceBookMaster__c = pbm.Id;
        soli.SKU_Name__c = sku.Id;
        soli.Item_Number__c =56;
        soli.Sequence_Number__c = 87;
        soli.Sale_Order__c = salesorder.Id;
        soli.Per_Unit_Discount__c = 10;
        soli.Quantity__c = 100;
        soli.Price__c = 1000;
        soli.UOM__c = 'L';
        soli.Delivery_Date__c = System.today()+30;  // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022..
        insert soli;
              
        Payments__c pay = new Payments__c();
        pay.Customer_Name__c = acc1.id;
        pay.Net_Overdue__c = 1000;
        insert pay;
        
        Outstanding_Ageing__c ogac = new Outstanding_Ageing__c();
        ogac.Net_Outstanding__c = 100;
        ogac.Customer_Code__c = acc1.Id;
        insert ogac;
        
        Distributor_Depot_Mapping__c ddm = new Distributor_Depot_Mapping__c();
        ddm.Distributor__c = acc1.Id;
        ddm.Depot__c = depot.id;
        insert ddm;
        
        
        Credit_Info__c ci = new Credit_Info__c();
        ci.Sales_Org__c = soc.Id;
        ci.Allocated_Limit__c = 0.00;
        ci.Credit_Limit__c = 100;
        ci.Balance_Limit__c = 1000;
        ci.Used_Limit__c = 450;
        ci.Internal_Limit__c = 748;
        ci.Distributor__c = acc1.Id; //Insert failed
        insert ci;
        
        Stock_Requirement__c sr = new Stock_Requirement__c(); 
        sr.Depot__c = depot.Id;
        sr.SKU__c = sku.Id;
        sr.UOM__c = 'L';
        sr.Sales_Org__c = soc.Id;
        //sr.Available_Stock__c = 200; // not writeable
        sr.Delivery_Stock__c =100;
        //sr.Outgoing_Reservations__c =20; // not writeable
        sr.SKU__c = sku.Id;
        sr.Stock_In_Transit__c =10;
        sr.Purchase_Order_Stock__c =20;
        sr.Unrestricted_Stock__c = 10;
        insert sr;
        
        
        Order__c order = new Order__c();  
        ord.Bill_To_Party__c = acc1.Id;        
        ord.Order_Date__c = system.today();  
        ord.Order_Status__c = 'Draft';                    
        ord.Sales_Org__c =soc.Id; 
        insert order;
        
        
        
        PriceBookMaster__c priceBookMasterObj1 = new PriceBookMaster__c(
            DistributorCustomerCode__c =acc1.Id,         // Distributor Customer Code
            SKUCode__c = sku.Id,    
            PG_CODE__c =priceGroupMasterObj.Id,
            Price__c = 60000.00,                                      // Price / Max Price
            DepotCode__c = depot.Id,                         // Depot Code
            MinPrice__c = 41000.00,                                   // Min Price
            Final_Price__c = 0.00,                                    // Final Price
            StartDate__c = System.today(),                // Start Date
            EndDate__c = System.today()+10,                    // End Date
            UOM__c = 'L',                                             // UOM
            Division__c = DivisionObj.Id,                          // Division
            DistributionChannel__c = distributionChannelObj.Id,               // Distribution Channel
            Sales_Org__c = soc.Id,
            CompositeKey__c ='c12'// Sales Org
        );
        insert priceBookMasterObj1;
        
        SalesorderUkController.DistributorWrapper distributorobj  = new  SalesorderUkController.DistributorWrapper();
        List<SalesorderUkController.DistributorWrapper> obj = new List<SalesorderUkController.DistributorWrapper>();
        distributorobj.internalCredit = 10;
        distributorobj.creditLimit = 20;
        distributorobj.creditUsed =1;
        distributorobj.netOverdue = 0;
        distributorobj.paymentOutstanding = 0;
        distributorobj.creditBalance =0;
        distributorobj.sapCode = '2031';   
        obj.add(distributorobj);
        String seralizedistributorobj = JSON.serialize(distributorobj); 
        
        SalesorderUkController.CartWrapper  cart = new  SalesorderUkController.CartWrapper();
        List< SalesorderUkController.CartWrapper> cartObj = new List< SalesorderUkController.CartWrapper>();
        cart.cartOrderId = '';  
        cart.errorMessage='';   
        cart.grossNetPrice=0;   
        cart.orderType =ot.id;
        cart.Net_Amount=0;
        cart.Net_QuantityLiters='0L';
        cart.Net_QuantityKgs='0KG';
        cart.Totaldiscount=0;
        
        List<SalesorderUkController.SalesOrderItem> soiList1=new List<SalesorderUkController.SalesOrderItem>();
        SalesorderUkController.SalesOrderItem SOLI1=new SalesorderUkController.SalesOrderItem();
        SOLI1.skuId=sku.Id;
        SOLI1.productCode='';
        SOLI1.ordrId='';
        SOLI1.UOM='L';
        SOLI1.shipDate=String.valueOf(System.today());
        SOLI1.qty=10;
        SOLI1.unitValue=20;
        SOLI1.materialPrice=30;
        SOLI1.discount=5;
        SOLI1.personalNotes='Test';
        SOLI1.pricebookId=priceBookMasterObj1.Id;
        SOLI1.deliveryDate = String.valueOf(System.today()+30); // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022..
        soiList1.add(SOLI1);
        cart.soiList=soiList1;
        
        cartObj.add(cart);
        
        String seralizeOrder = JSON.serialize(cart);

        SalesorderUkController.CartWrapper  cart2 = new  SalesorderUkController.CartWrapper();
        cart2.cartOrderId = '';  
        cart2.errorMessage='';   
        cart2.grossNetPrice=0;   
        cart2.orderType =ot.id;
        cart2.Net_Amount=0;
        cart2.Net_QuantityLiters='0L';
        cart2.Net_QuantityKgs='0KG';
        cart2.Totaldiscount=0;
        
        List<SalesorderUkController.SalesOrderItem> soiList2=new List<SalesorderUkController.SalesOrderItem>();
        cart2.soiList=soiList2;
        String seralizeOrder2 = JSON.serialize(cart2);
 
        
        List<SalesorderUkController.SalesOrderItem> OwrapObjlst = new List<SalesorderUkController.SalesOrderItem>(); 
        SalesorderUkController.SalesOrderItem OwrapObj = new SalesorderUkController.SalesOrderItem();
        OwrapObj.UOM = 'L';    
        OwrapObj.itemNo = 0; 
        OwrapObj.skuId = sku.Id; 
        OwrapObj.customerCode = '76876';
        OwrapObj.unitValue= 34;
        OwrapObj.productCode = ''; 
        OwrapObj.skuName = sku.Name;
        OwrapObj.skucode= sku.Id;
        OwrapObj.ordrId = ord.Id;    
        OwrapObj.priceBookDetailId = ''; 
        OwrapObj.productName = '';   
        OwrapObj.materialPrice =0;   
        OwrapObj.shipDate = String.valueOf(System.today());
        OwrapObj.shipDateformatted='';
        OwrapObj.qty = 10;    
        OwrapObj.oliId =oli.id;  
        OwrapObj.discount = 0;   
        OwrapObj.multipleOf = 0; 
        OwrapObj.netPrice = 1000;   
        OwrapObj.personalNotes='vvjhvjhv ';
        OwrapObj.salesOrderItemId = '';
        OwrapObj.pricebookId= priceBookMasterObj1.Id;
        OwrapObj.discountvalue=5;
        OwrapObj.deliveryDate = String.valueOf(System.today()+30); // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022..
        OwrapObjlst.add(OwrapObj);
        
        SalesorderUkController.SalesOrderItem OwrapObj2 = new SalesorderUkController.SalesOrderItem();
        OwrapObj2.UOM = 'L';    
        OwrapObj2.itemNo = 0; 
        OwrapObj2.skuId = sku.Id; 
        OwrapObj2.customerCode = '76876';
        OwrapObj2.unitValue= 34;
        OwrapObj2.productCode = ''; 
        OwrapObj2.skuName = sku.Name;
        OwrapObj2.skucode= sku.Id;
        OwrapObj2.ordrId = salesorder.Id;    
        OwrapObj2.priceBookDetailId = ''; 
        OwrapObj2.productName = '';   
        OwrapObj2.materialPrice =0;   
        OwrapObj2.shipDate = String.valueOf(System.today());
        OwrapObj2.shipDateformatted='';
        OwrapObj2.qty = 10;    
        OwrapObj2.oliId =soli.id;  
        OwrapObj2.discount = 0;   
        OwrapObj2.multipleOf = 0; 
        OwrapObj2.netPrice = 1000;   
        OwrapObj2.personalNotes='vvjhvjhv ';
        OwrapObj2.salesOrderItemId = '';
        OwrapObj2.pricebookId= priceBookMasterObj1.Id;
        OwrapObj2.discountvalue=5;
        OwrapObj2.deliveryDate = String.valueOf(System.today()+30); // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022..
        OwrapObjlst.add(OwrapObj2);
        
        String serlizeStr1 = JSON.serialize(OwrapObj); 
        String serlizeStr3 = JSON.serialize(OwrapObj2); 
        String serlizeStr2 = JSON.serialize(OwrapObjlst);
        BusinessHours   bh; 
        List<BusinessHours> temp = [SELECT ID, Name, IsDefault, IsActive From BusinessHours 
                                    WHERE Name =: System.Label.UK_Business_Hours];
        for (BusinessHours b : temp) {
            bh = b;
        }
        String test = OwrapObj.shipDate+' 00:00:00';
        string test2 = OwrapObj.shipDate;
        DateTime now = DateTime.valueOfGmt(test);
        string seleceddate=string.valueOf(now.format('EEEE'));
        system.debug('day=='+now.format('EEEE'));
        Boolean isHoliday = !BusinessHours.isWithin(bh.Id, now);
        pricebook2 pbook = new pricebook2();
        pbook.Name = 'Standard Price Book';
        pbook.IsActive = true;
        pbook.Description = 'dhvahfjh';
        insert pbook;
        
        SalesorderUkController.PriceDetail pd = new SalesorderUkController.PriceDetail();
        pd.UOM = 'N/A';    
        pd.itemNo = 0; 
        pd.skuId = ''; 
        pd.customerCode ='';   
        pd.skuDescription = '';    
        pd.skuBrand = '';  
        pd.skuCategory = '';   
        pd.shipDate = ''; 
        pd.shipDateformatted='';
        pd.unitCost =0;    
        pd.materialPrice = 0;  
        pd.pricebookId = pbook.Id;
        pd.days = 0;   
        pd.skuCode = '';   
        pd.multipleOf = 0; 
        pd.orderItemId = '';   
        pd.approxStock=0;
        pd.unitValue=0;
        pd.unitPrice=0;
        pd.totalPrice=0;        
        
        
        SalesorderUkController.AuditHistory  au = new SalesorderUkController.AuditHistory();
        au.actorName = 'jbd';
        au.comments ='Done';
        au.createdDate = date.today();
        au.stepStatus ='done';
        
        
        SalesorderUkController.getOrderFields(salesorder.Id, 'SalesOrder');
        SalesorderUkController.fetchDistributorDetails(acc1.Id);
        SalesorderUkController.getShippingLoations(acc1.Id);
        SalesorderUkController.getIncoTerms(acc1.Id);
        SalesorderUkController.getSalesOrder(salesorder.Id);
        SalesorderUkController.getAllDocuments(acc1.Id);
        //SalesorderUkController.getSkuData(acc1.Id, 'Brand');  
        SalesorderUkController.getSkuData(acc1.Id,'');
        
        SalesorderUkController.saveOrder(acc1.Id, serlizeStr1 , ot.Id, order.Id, 'currencycode', 'Account');
        SalesorderUkController.saveOrder(acc1.Id, serlizeStr1 , ot.Id, '', 'currencycode', 'Account');
        SalesorderUkController.saveOrder(salesorder.Id, serlizeStr1 , ot.Id, order.Id, 'currencycode', 'SalesOrder');
        SalesorderUkController.OrderItems(cart,salesorder.Id, OwrapObj, 'currencycode','SalesOrder');   
        SalesorderUkController.updateOrderLineItems(serlizeStr1,'Account' ) ;
        SalesorderUkController.updateOrderLineItems(serlizeStr3,'SalesOrder' ) ;
        SalesorderUkController.getCartOrderItems(acc1.Id,'Salesord');   
        SalesorderUkController.getsalesorderLineItems(salesorder.Id);    
         System.Test.stopTest();   // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022..
        SalesorderUkController.saveSalesOrder(acc1.Id,seralizedistributorobj,seralizeOrder,'Submitted',itc.Id,slc.id,'Checking','786cch',seralizeddocWrap,true, 'AUD','Account',String.valueOf(System.today()+30)); // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022..
        SalesorderUkController.saveSalesOrder(salesorder.Id,seralizedistributorobj,seralizeOrder2,'Submitted',itc.Id,slc.id,'Checking','786cch',seralizeddocWrap,true, 'AUD','SalesOrder',String.valueOf(System.today()+30));   // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022..  
        SalesorderUkController.saveOrderItems(salesorder, OwrapObjlst);
        SalesorderUkController.generateData(acc1.Id);    
        SalesorderUkController.sortAuditHistory(); 
        SalesorderUkController.deleteOrderLineItem(oli.Id, order.Id, '1', false, 'Account'); 
        SalesorderUkController.deleteOrderLineItem(soli.Id, salesorder.Id, '1', true, 'SalesOrder');
        
        //SalesorderUkController.findMinDateValue();
        //SalesorderUkController.approvalProcess(acc1.Id);
        
        
    }
}