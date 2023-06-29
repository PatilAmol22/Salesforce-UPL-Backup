@isTest
public class OrderMexicoTest {
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
        sorg.Name='Mexico';
        sorg.Description__c='Mexico';
        sorg.Sales_Org_Code__c='5100';
        insert sorg;
        
        Crop__c crops = new Crop__c();
        crops.active__c=true;
        crops.name = 'Apple';
        crops.SalesOrg__c = sorg.id;
        crops.CurrencyIsoCode='INR';
        insert crops;
        
        
        RecordType Supplier_RecTypeId = [SELECT Id FROM RecordType WHERE name = 'Storage Location' and isActive = true LIMIT 1];
        Depot__c dp =new Depot__c ();
        dp.Name='NORTE';
        dp.recordtypeId=Supplier_RecTypeId.id;
        dp.Country__c='Mexico';
        dp.Location__c='NORTE';
        //dp.Depot_Code__c='MX51';
        dp.Depot_Code__c='MX00';
        dp.SalesOrg__c = sorg.ID;
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
          Distribution_Channel__c disbj2 = new Distribution_Channel__c();
        disbj2.Name = '67';                      
        disbj2.Distribution_Channel_Code__c = '67';  
        disbj2.Description__c='test';
        insert disbj2;
        
        Division__c Divbj2 = new Division__c();
        Divbj2.Name = '11';         
        Divbj2.Description__c = null;    
        Divbj2.Division_Code__c = '11'; 
        insert Divbj2;
        
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
        sku.Multiple_Of__c=5;
        sku.Group__c='DOST';
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='L';
        
        sku.Active__c=True;
        
        sku.Combination_Key__c='Cooooooo000011111';
        insert sku;
   
        
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
        PbMaster.CurrencyIsoCode='MXN'; 
        PbMaster.Division__c= Divbj.ID;
        PbMaster.CompositeKey__c='c1';
      //  PbMaster.DistributorCustomerCode__c='';
        insert PbMaster; 
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZORD';              
        ordType.Description__c = 'Indonesia';    
        ordType.Order_Type_Code__c = 'ZORD';
        insert ordType;
        
        Payment_Method__c payment_method = new Payment_Method__c(
  Name = 'CHEQUE NOMINATIVO',      // Payment Method Name
  Sales_Org__c = sorg.ID,  // Sales Org
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
  Sales_Org__c = sorg.ID,   // Sales Org
  CombinationKey__c = '51000004',     // CombinationKey
  Active__c = true                   // Active
);
insert payment_term;
        
       Inco_Term__c Inco_terms = new Inco_Term__c(
  Name = 'CFR',                                      // Inco Term Name
  IncoTerm_Code__c = 'CFR',                            // IncoTerm Code
  IncoTerm_Desc__c = 'NOSOTROS ENVIAMOS EL PRODUCTO',  // IncoTerm Desc
  Active__c = true,                                    // Active
  Sales_Org__c = sorg.ID                    // Sales Org
);
insert Inco_terms; 
        
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
        //  acc.OwnerId=sobj.Id;
        insert acc;
         PbMaster.DistributorCustomerCode__c=acc.id;
        update PbMaster; 
        Price_Group_Master__c priceGroup = new Price_Group_Master__c(
              PG_Code__c = '01'// PG Code
        );
        insert priceGroup;
        
        DistributorSalesAreaMapping__c sobj = new DistributorSalesAreaMapping__c(
              AccountType__c = 'Sold To Party',          // Account Type
              Distributor__c = acc.id,          // Distributor
              SalesOrg__c = sorg.id,             // Sales Org
              OrderBlock__c = false,                       // Order Block
              DistributionChannel__c = disbj.id,  // Distribution Channel
              Division__c = Divbj.id,             // Division
                    // Account Owner
              PriceGroupMaster__c = priceGroup.id     // Price Group Master
            );
            insert sobj;
               DistributorSalesAreaMapping__c sobj2 = new DistributorSalesAreaMapping__c(
              AccountType__c = 'Sold To Party',          // Account Type
              Distributor__c = acc.id,          // Distributor
              SalesOrg__c = sorg.id,             // Sales Org
              OrderBlock__c = false,                       // Order Block
              DistributionChannel__c = disbj.id,  // Distribution Channel
              Division__c = Divbj2.id,             // Division
                    // Account Owner
              PriceGroupMaster__c = priceGroup.id     // Price Group Master
            );
            insert sobj2;
        
        contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName=acc.Last_Name__c;
        insert con;
        
        userrole  usrole = new userrole();
        usrole.Name ='Regional/Zonal Managers for Mexico';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'PartnerCommunity Distributor Profile'];
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';    
        sobj1.Crop_Selection__c=true;                                                        
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
        insert sobj1;
        
        Sales_Org__c salesOrg  = new Sales_Org__c();
        salesOrg.Name = 'Mexico';
        salesOrg.Company_Code__c = '5000';
        salesOrg.Country_Code__c = 'MX';
        salesOrg.Sales_Org_Code__c = '5100';
        insert salesOrg;
        
        TM_Depot_Mapping__c TMDepoMap = new TM_Depot_Mapping__c();
        TMDepoMap.Depot__c = dp.Id;        // Depot
        TMDepoMap.Territory_Manager__c = sobj1.id;  // Territory Manager
        insert TMDepoMap;
         system.debug('Account ID = '+acc.Id);
        Shipping_Location__c shippLoc =new Shipping_Location__c();
        shippLoc.Location_Name__c ='Same as Billing Address'; 
        shippLoc.Region__c='S.No:46/1, A1 Building, First Floor, Office No.101 E-Space, Wadgoan Sheri,Nagar Rd, Aga Nagar,';
        shippLoc.Distributor__c=acc.Id;
        shippLoc.City__c='Pune';
        shippLoc.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc.SAP_Code__c='SAP0001';
        shippLoc.State__c='13';
        shippLoc.Sales_Org__c = salesOrg.id;
        insert shippLoc;
       
        Shipping_Location__c shippLoc2 =new Shipping_Location__c();
        shippLoc2.Location_Name__c ='Mumbai'; 
        shippLoc2.Region__c='S.No:46/1, A1 Building, First Floor, Office No.101 E-Space, Wadgoan Sheri,Nagar Rd, Aga Nagar,';
        shippLoc2.Distributor__c=acc.Id;
        shippLoc2.City__c='Pune';
        //shippLoc2.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc2.SAP_Code__c = acc.SAP_Code__c;
        shippLoc2.State__c='13';
        shippLoc2.Sales_Org__c = salesOrg.id;
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
		PbDis.Sales_Org__c = salesOrg.Id;        
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
        crdIf.Sales_Org__c = salesOrg.id;
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
        statetax.Country__c = 'Indonesia';          
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
        ord.Remarks_Long__c='test';
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
        insert ordItem; 
    }
    
    static testMethod void method() {
        Account acc = [Select id From Account];
        Order__c ord = [Select id From Order__c];
        List<Sales_Org__c>  sorg = [select id from Sales_Org__c ];
        Sku__c sku = [Select id From SKu__c];
        OrderTemplate__c ordTemp = [Select id From OrderTemplate__c];
        Payment_Method__c payment_method =[Select id From Payment_Method__c];
Payment_Term__c payment_term =[Select id From Payment_Term__c ];
Inco_Term__c Inco_terms=[Select id From Inco_Term__c];
        PageReference pageRef = Page.OrderIndonesia;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('acid',acc.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ord);
        OrderMexicoController ordmanage = new OrderMexicoController(sc);
        ordmanage.SelectedCurrency='MXN';
       
        //ordmanage.PO = '23423';
           ordmanage.SelectedCurrency='MXN';
        ordmanage.PO = '23423';
        //ordmanage.userDepotCode='MX51';
        ordmanage.userDepotCode='MX00';
        
        ordmanage.changeOrderFor();
      //  ordmanage.fetchDistributorDetails();
        ordmanage.Payment_Methods = Payment_Method.id;
        ordmanage.Payment_Terms = Payment_Term.id;
        ordmanage.Inco_Terms = Inco_terms.id; 
        ordmanage.fetchSKUData();
        ordmanage.searchProdValue = 'DOST';
        ordmanage.searchProduct();
        ordmanage.skuIdChosen= sku.Id;

        ordmanage.addSKU();
        ordmanage.addSKU();
        ordmanage.createOrder();
       // ordmanage.createSalesOrder2('MXN',sorg[0].id+'',true,true,true);
        ordmanage.updateSKU();
       
        ordmanage.refreshOrderValue();
        ordmanage.templateName = 'test';
        ordmanage.saveTemplate();
        ordmanage.tempIdChosen = ordTemp.Id;
        ordmanage.confirmOrder();
        ordmanage.editOrder();
        ordmanage.showOrderTemplates();
        ordmanage.loadTemplate();
        ordmanage.getTemplateName();
        ordmanage.showOrderHistory();
        ordmanage.changeDepot();
        ordmanage.addCharIntoRemark('sajhdbnbasdjasdasvdbasvdnbvansbdvnsavdnbsvadvanbdsvnavsndbvansbdvnb   sadvbasdvnbavsndbvanvdsnasvbd nbsadvnbsvandbvansd vbnasdnbavsd bv');
        //ordmanage.redirectFunction();
    }
    
    static testMethod void method2(){
        Account acc = [Select id From Account];
        Order__c ord = [Select id From Order__c];
        Sku__c sku = [Select id From SKu__c];
        OrderTemplate__c ordTemp = [Select id From OrderTemplate__c];
        
        //Logic to execute Exception Handling & deleteSKU()
        PageReference pageRef2 = Page.OrderIndonesia;
        Test.setCurrentPage(pageRef2);
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(ord);
        OrderMexicoController ordmanage2 = new OrderMexicoController(sc2);
       ordmanage2.skuIdChosen= sku.Id;
        ordmanage2.SelectedCurrency='MXN';
        ordmanage2.fetchDistributorDetails();
        ordmanage2.fetchSKUData();
      
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

        

        ordmanage2.refreshOrderValue();

        ordmanage2.templateName = 'test';

        ordmanage2.saveTemplate();
        ordmanage2.tempIdChosen = ordTemp.Id;

        ordmanage2.saveOrder();

        ordmanage2.confirmOrder();

        ordmanage2.editOrder();
        ordmanage2.showOrderTemplates();

        ordmanage2.loadTemplate();

        ordmanage2.getTemplateName();

        ordmanage2.showOrderHistory();

        ordmanage2.changeDepot();

        ordmanage2.deleteAllSKU();
        ordmanage2.redirectFunction();
        //End of Logic
    }
}