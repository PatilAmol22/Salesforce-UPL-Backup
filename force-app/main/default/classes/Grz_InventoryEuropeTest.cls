@isTest
public class Grz_InventoryEuropeTest {
      static testMethod void GetEuropeInventory(){
        
        Id depordRecod = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();
        Id storageRecod = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Storage Location').getRecordTypeId();
        
        List<string> OrgValues = new List<string>();
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Hungary',           // Sales Org Name
            Company_Code__c = '2920',      // Company Code
            Sales_Org_Code__c = '2921',    // Sales Org Code
            Country_Code__c = 'HU'        // Country Codes
        );
        insert salesOrgObj;
        OrgValues.add(salesOrgObj.Sales_Org_Code__c);
        
                
        Depot__c depotObj = new Depot__c(
            Name = 'HU00',                             // Depot Name
            Location__c = 'HU00',                        // Location            // Sales Org
            Depot_Code__c = 'HU00',                      // Depot Cod
            Country__c = 'Europe',
            Active__c = true,                               // Active
            RecordtypeId=depordRecod,
            SalesOrg__c = salesOrgObj.Id 
        );
        insert depotObj;
        
      
         Depot__c StrogeLocation = new Depot__c(
            Name = 'WH01',                             // Depot Name
            Location__c = 'WH01',                        // Location            // Sales Org
            Depot_Code__c = 'WH01',                      // Depot Cod
            Country__c = 'Europe',
            Active__c = true,    
             Depot__c=depotObj.id,
            RecordtypeId=storageRecod
        );
        insert StrogeLocation;
        
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Division__c Divbj = new Division__c();
        Divbj.Name = '10';         
        Divbj.Description__c = null;    
        Divbj.Division_Code__c = '10'; 
        insert Divbj;
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZZOD';              
        ordType.Description__c = 'Europe';    
        ordType.Order_Type_Code__c = 'ZZOD';
        insert ordType;
        
        Distribution_Channel__c DistributionChannelObj = new Distribution_Channel__c(
            Name = '20',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '20',  // Distribution Channel Code
            Description__c='test'
        );
        insert DistributionChannelObj;
        
       // Account acc = new Account();
      //  acc.Name='Bhavik Devdhar';
      //  acc.Last_Name__c='Devdhar';
      //  acc.PriceGroupCode__c=pg.id;
    //    acc.SAP_Code__c='SAP996734';
    //    acc.Mobile__c='9967341759';
    //    acc.Phone='020256589';
   //     acc.Sales_Org__c=salesOrgObj.Id;
   //     acc.Division__c=Divbj.Id;
  //      acc.Distribution_Channel__c=DistributionChannelObj.Id;
  //      acc.BillingCity='Pune';
   //     acc.Order_Type__c=ordType.Id;
  //      acc.Depot_Code__c = 'PUN1';
        //  acc.OwnerId=sobj.Id;
  //      insert acc;
        

        Grz_InventoryEurope.getEuropeOrg();
        
        
        
        
        Product2 productObj = new Product2(
            Name = 'ALPHA CYPER 10% EC',         // Product Name
            Product_Code__c = '65100',             // Product Code
            Active__c = false,                     // Active
            Sales_Org__c = salesOrgObj.Id,      // Sales Org
            Combination_Key__c = '6510057106710',  // Combination Key
            Popular__c = false,                    // Popular
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = false,     // Active For Liquidation
            //  Multiple_Of__c = 0.0,                // Multiple Of
            Budget_NRV__c = 0.00                // Budget NRV
        );
        insert productObj;
        
        SKU__c skuObj = new SKU__c(
            Name = 'AC650 (DEVRINOL FL) 4 X 5 LT (GB)',                         // SKU Name
            SKU_Code__c = '000000000000933015',                 // SKU Code
            Product_Name__c = productObj.Id,                // Product Nam
            SKU_Description__c = 'checking',        // SKU Description
            UOM__c = 'L',                                       // UOM
            Distribution_Channel__c = DistributionChannelObj.Id,        // Distribution Channel
            Pack_Size__c = 0.00,                              // Pack Size
            Division__c = Divbj.Id,   
            Unit_Cost__c = 200,
            Area_Manager_MSP__c =150,
            Sales_Agent_MSP__c =500,
            Sales_Director_MSP__c =50,
            Sales_Org__c = salesOrgObj.Id,                   // Sales Org
            Combination_Key__c = '57106710000000000006180633',  // Combination Key
            Material_type__c = 'FERT',                          // Material type
            Active__c = true,                                   // Active
            Brand_Name__c = 'Brand',                          // Brand Name
            Inventory_Description_Italy__c='Stock available'
        );
        insert skuObj;
   
       
        
        
     //    PriceBookMaster__c pbm = new PriceBookMaster__c();
     //   pbm.DepotCode__c =depotObj.Id;
     //   pbm.SKUCode__c = skuObj.Id;
    //    pbm.UOM__c= 'L';
   //     pbm.DistributorCustomerCode__c = acc.Id;
    //    pbm.CompositeKey__c ='werty456787';
    //    pbm.Active__c = true;
   //     pbm.StartDate__c = date.today();
   //     pbm.EndDate__c = date.today();
   //     pbm.Active__c = true;
   //     insert pbm;
        
        
        
        Stock_Requirement__c sr = new Stock_Requirement__c();
        sr.Depot__c = depotObj.Id;
        sr.Combination_Key__c ='267676287';
        sr.Sales_Org__c = salesOrgObj.Id;
        sr.SKU__c = skuObj.Id;
        sr.Unrestricted_Stock__c = 10;
        
        insert sr;
        
        //Date someDate = Date.newInstance(2016, 4, 28);
       String iso8601 = Datetime.now().format('yyyy-MM-dd');
        List<String> dates = new List<String>();
        dates.add(iso8601);
        
        Inventory__c inObj = new Inventory__c();
        inObj.Allocated_Quantity__c = 222;
        inObj.Expiry_Date__c = date.today();
        inObj.Distribution_Channel__c = DistributionChannelObj.Id;
        inObj.Depot__c = depotObj.Id;
        inObj.SKU__c =  skuObj.Id;
        inObj.Sales_Org__c =salesOrgObj.Id;
        inObj.SKU_Depot__c ='23232';
        inObj.Expiry_Date__c=Date.newInstance(2016, 4, 28);
        inObj.Production_Date__c=Date.newInstance(2016, 4, 28);
        inObj.Storage_Location_Depot__c = StrogeLocation.Id;
        inObj.Division__c = Divbj.Id;
        insert inObj;
        

        
        List<string> allval = new List<string>();
        allval.add('ALL');
        //  wrap.WrapperPageResult = lis;
        Grz_InventoryEurope.getInventories(10.00, 5, 'HU00' ,true,OrgValues,'SKU__r.SKU_Description__c', skuObj.SKU_Description__c);
        Grz_InventoryEurope.getInventories(10.00, 5, 'HU00' ,false,OrgValues,'SKU__r.SKU_Description__c', skuObj.SKU_Description__c);
        Grz_InventoryEurope.getInventories(10.00, 5, 'HU00' ,false,allval,'SKU__r.SKU_Code__c', skuObj.Sku_code__c);
        Grz_InventoryEurope.getInventories(10.00, 5, 'HU00' ,true,allval,'SKU__r.SKU_Code__c', skuObj.Sku_code__c);
        Grz_InventoryEurope.getInventories(10.00, 5, 'HU00' ,false,OrgValues,'SKU__r.Brand_Name__c', skuObj.Brand_Name__c);
        Grz_InventoryEurope.getInventories(10.00, 5, 'HU00' ,true,OrgValues,'SKU__r.Brand_Name__c', skuObj.Brand_Name__c);
        Grz_InventoryEurope.getInventories(10.00, 5, 'HU00' ,true,OrgValues,'Depot_Code__c', StrogeLocation.Depot_Code__c);
        Grz_InventoryEurope.getInventories(10.00, 5, 'HU00' ,false,OrgValues,'Depot_Code__c', StrogeLocation.Depot_Code__c);
        Grz_InventoryEurope.getInventories(10.00, 5, 'HU00' ,false,OrgValues,'Depot_Code__c', '');
        Grz_InventoryEurope.getInventories(10.00, 5, 'HU00' ,true,OrgValues,'Depot_Code__c', '');
        
        
        
    } 
}