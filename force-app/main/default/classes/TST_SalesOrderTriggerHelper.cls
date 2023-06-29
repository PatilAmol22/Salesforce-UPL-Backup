/* Name : TST_SalesOrderTriggerHelper
 * Covergae Class : SalesOrderTriggerHelper
 * Created By: Varun Shrivastava
*/
@isTest(seeAllData=False)
private class TST_SalesOrderTriggerHelper {
	@Testsetup
    static void setupTestData(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Depot__c dp =new Depot__c ();
        dp.Name='IndiaDepot';
        dp.Country__c='India';
        dp.Location__c='Jaipur';
        dp.Depot_Code__c='JP1';
        insert dp;
        
    	Sales_Org__c salesorg = new Sales_Org__c();
        salesorg.Name = 'Swal';          
        salesorg.Description__c = 'Swal';   
        salesorg.Company_Code__c = '1210';    
        salesorg.Sales_Org_Code__c = '1200';
        insert salesorg;
        
        Duplicate_Sales_Order_Org__c customSettingRecord = new Duplicate_Sales_Order_Org__c();
        customSettingRecord.Name = 'Swal';
        customSettingRecord.Sales_Org_Code__c = '1200';
        customSettingRecord.Check_Duplicate__c = true;
        insert customSettingRecord;
        
        Region__c regObj= new Region__c();
        regObj.Name='Mumbai';
        regObj.RegionCode__c='045';
        insert regObj;
        
        SBU__c SBUObj = new SBU__c();
        SBUObj.SBUUser__c = UserInfo.getUserId();
        SBUObj.SBUCode__c = 'SBU2';
        SBUObj.SalesOrg__c = salesorg.id;
        insert SBUObj;
        
        Zone__c zoneObj = new Zone__c();
        zoneObj.Name = 'Maharashtra';             
        zoneObj.SalesOrg__c = salesorg.Id;   
        zoneObj.ZoneCode__c = 'Z16';               
        zoneObj.ZonalHead__c = UserInfo.getUserId();  
        zoneObj.SBUCode__c = SBUObj.Id;    
        insert zoneObj;
        
        Territory_Distributor__c territoryObj = new Territory_Distributor__c();
        territoryObj.Name = 'Dhule';
        territoryObj.TerritoryCode__c = '398';
        territoryObj.SalesOrg__c = salesorg.id;
        territoryObj.Region__c = regObj.id;
        territoryObj.TerritoryManager__c = UserInfo.getUserId();
        territoryObj.Zone__c = zoneObj.id;
        territoryObj.SBU__c = SBUObj.Id;
        territoryObj.Present_in_KEDE__c = true;
        territoryObj.Neglected__c = false;
        insert territoryObj;
        
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
        
            
        Account acnt= new Account();
        acnt.Name = 'Test Account';
        acnt.Email__c='varshriv@ulp-ltd.com';
        acnt.BillingCity ='Pune';
        acnt.BillingCountry='India';
        acnt.Territory_Distributor__c = territoryObj.ID;
        acnt.RecordTypeId=devRecordTypeId;
        acnt.Mobile__c='9867341712';
        acnt.Phone='020256580';
        acnt.Sales_Org__c=salesOrg.Id;
        acnt.SAP_Code__c='SAP123456';
        acnt.Depot_Code__c=depObj.Id;
        acnt.Distribution_Channel__c=discObj.Id;
        acnt.Division__c=divObj.Id;
        acnt.State_Tax_Structure__c=statetax.Id;
        insert acnt;
        
        Product2 productObj = new Product2(
            Name = 'BISECT',                     // Product Name
            ProductCode = '71501',                 // Product Code
            Product_Code__c = '71501',             // Product Code
            IsActive = false,                      // Active
            Active__c = false,                     // Active
            Sales_Org__c = salesorg.id,      // Sales Org
            Combination_Key__c = '7150156311010',  // Combination Key
            Popular__c = false,                    // Popular
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = false     // Active For Liquidation
        );
        insert productObj;
        
         SKU__c sku = new SKU__c(
            Name = '6 LTS',                                   // SKU Name
            SKU_Code__c = '000000000006010097',                 // SKU Code
            Product_Name__c = productObj.id,                // Product Name
            UOM__c = 'L',                                       // UOM
            Distribution_Channel__c = discObj.Id,        // Distribution Channel
            Pack_Size__c = 0.00,                                // Pack Size
            Division__c = divObj.Id,                    // Division
            Sales_Org__c = salesorg.Id,                   // Sales Org
            Multiple_of__c = 20.00,                             // Multiple Of
            Combination_Key__c = '56311010000000000006010097',  // Combination Key
            Active__c = true,                                   // Active
            Brand_Name__c = 'BISECT 6LTS'                      // Brand Name
        );
        insert sku;
        
        PriceBookMaster__c PbMaster = new PriceBookMaster__c();
        PbMaster.SKUCode__c = sku.id;           
        PbMaster.DepotCode__c =dp.id;         
        PbMaster.Price__c = 34500;    
        PbMaster.MinPrice__c = 3000;
        PbMaster.PG_CODE__c =Pg.Id;  
        PbMaster.UOM__c = 'NOS';                          
        PbMaster.StartDate__c = system.today();
        PbMaster.EndDate__c = system.today()+1;
        PbMaster.Active__c = true;                      
        PbMaster.PerUnit__c = 1;                       
        PbMaster.Batch__c ='test'; 
        PbMaster.CompositeKey__c='c1';
        insert PbMaster; 
        
        
        
       
        
        contact con = new Contact();
        con.AccountId=acnt.Id;
        con.MobilePhone = '123456789';
        con.LastName='Test Contact';
        con.Phone = '123456789';
        insert con;
        
        userrole  usrole = new userrole();
        usrole.Name ='Territory Manager SWAL Kolkata (Barasat)';
        
        Profile p = [Select id from Profile where Name = 'Territory Manager SWAL' limit 1];
      
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = '30012882@upl-ltd.com.invalid';                             
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
        //sobj1.ContactId=con.Id;
        insert sobj1;
        
        TM_Depot_Mapping__c TMDepoMap = new TM_Depot_Mapping__c();
        TMDepoMap.Depot__c = dp.Id;        // Depot
        TMDepoMap.Territory_Manager__c = sobj1.id;  // Territory Manager
        insert TMDepoMap;
        
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
        dsMap.Distributor__c = acnt.id;
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
        crdIf.Distributor__c=acnt.Id;
        crdIf.Distributor_Code__c='0001001225';
        crdIf.Sales_Org__c = salesorg.id;
        insert crdIf;
        
        //Data for Shipping Location
        Shipping_Location__c shippingLocationObj = new Shipping_Location__c(
            Location_Name__c = 'ADECO AGROPECUARIA S.A.',// Location Name
            Distributor__c = acnt.Id,            // Distributor
            SAP_Code__c = '00010132925631',                // SAP Code
            City__c = 'Kolkata',         // City
            State__c = '01',                               // State
            Country__c = 'India',                             // Country
            Pincode__c = '1640',                           // Pincode
            Sold_To_Party_SAP_Code__c = '0001013292',      // Sold To Party (SAP Code)
            Sales_Org__c = salesorg.Id,              // Sales Org
            
            Distribution_Channel__c = discObj.Id,   // Distribution Channel
            Division__c = divObj.id               // Division
        );
        insert shippingLocationObj;
        
       //Data for Order Object 
        Order__c orderObj = new Order__c(
            Order_Date__c = system.today(),     // Order Date
            Order_Raise_By__c = 'Territory Manager',      // Order Raise By
            Order_Status__c = 'Approved',                 // Order Status
            Sales_Org__c = salesorg.id,             // Sales Org
            Division__c = divObj.id,              // Division
            Distribution_Channel__c = discObj.id,  // Distribution Channel
            Bill_To_Party__c = acnt.Id,         // Bill To Party
            Shipping_Location__c = shippingLocationObj.id     // Shipping Location
        );
        insert orderObj;
        
       //for credit card
         Payment_Method__c paymentMethodCreditObj = new Payment_Method__c(
            Name = 'Credit Card',                   // Payment Method Name
            Sales_Org__c = salesorg.Id,  // Sales Org
            Payment_Method_Code__c = 'CD1',     // Payment Method Code
            Active__c = true                  // Active
        );
        insert paymentMethodCreditObj;
        
        
        //data for Payment Term for 30 days
        Payment_Term__c paymentTermObj = new Payment_Term__c(
            Payment_Term_Code__c = '0015',                     // Payment Term Code
            Payment_Term__c = '30 dias',                         // Payment Term
            Payterms_Desc__c = 'Pagamento estrito em 30 dias.',  // Payterms Desc
            Maturity_Date_Mandatory__c = 'Yes',                  // Maturity Date Mandatory
            Sales_Org__c = salesorg.Id,                    // Sales Org
            Active__c = false                                   // Active
        );
        insert paymentTermObj;
        
        Sales_Order__c salesOrderRecord = new Sales_Order__c();
        salesOrderRecord.Division_lk__c = divObj.Id;
        salesOrderRecord.Total_Amount__c = 5000;
        salesOrderRecord.Order_Date__c = Date.today();
        salesOrderRecord.CreatedFrom__c = 'SFDC';
        salesOrderRecord.Order_Raise_By__c = 'Territory Manager';
        salesOrderRecord.Order_Status__c = 'Open';
        salesOrderRecord.Sold_to_Party__c = acnt.ID;
        salesOrderRecord.Bill_To_Party__c = acnt.ID;
        salesOrderRecord.Sales_Org_lk__c = salesorg.Id;
        salesOrderRecord.Order__c = orderObj.ID;
        salesOrderRecord.Credit_Term__c = paymentTermObj.ID;
        salesOrderRecord.TerritoryManager__c = sobj1.ID;
        insert salesOrderRecord;
        
    }
    
    static testMethod void checkDuplicateMethodFunctionality(){
        Test.startTest();
        Division__c div = [Select ID from Division__c limit 1];
        Account acc = [Select id from Account limit 1];
        Sales_Org__c salesOrgRecord = [Select ID from Sales_Org__c limit 1];
        Order__c orderRecord = [Select id from Order__c limit 1];
        
        Sales_Order__c salesOrderRecord = new Sales_Order__c();
        salesOrderRecord.Division_lk__c = div.Id;
        salesOrderRecord.Total_Amount__c = 5000;
        salesOrderRecord.Order_Date__c = Date.today();
        salesOrderRecord.Sales_Org_lk__c = salesOrgRecord.ID;
        salesOrderRecord.CreatedFrom__c = 'SFDC';
        salesOrderRecord.Sold_to_Party__c = acc.ID;
        salesOrderRecord.Order__c = orderRecord.ID;
        insert salesOrderRecord;
        salesOrderRecord.PONumber__c = 'Test Number';
        update salesOrderRecord;
        SalesOrderTriggerHelper.rejectDuplicateOrder(new List<Sales_Order__c>{salesOrderRecord});
        Test.stopTest();
    }
}