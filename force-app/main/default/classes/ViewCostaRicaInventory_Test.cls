@isTest
public class ViewCostaRicaInventory_Test {
    
    static testMethod void testMethod1(){
        
        User u2 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Country ='Costa Rica'
        );  
        
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name Like '%Colombia%' LIMIT 1 ].Id,
            LastName = 'last',
            Email = 'puser001@amamama.com',
            Username = 'puser001@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias1',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Country ='Colombia'
        );  
        
        Inventory_Material_Type__c matType = new Inventory_Material_Type__c(
            Name = 'HAWA',                 // Material Type Name
            Material_Type_Name__c = 'HAWA' // Material Type Name
        );
        insert matType;
        
        
        
        Sales_Org__c salesorg = new Sales_Org__c(
            Name = 'Costa Rica',           // Sales Org Name
            Description__c = 'Costa Rica',   // Description
            Company_Code__c = '5300',    // Company Code
            Sales_Org_Code__c = '5310',// Sales Org Code
            Continent__c = 'South America'
        );
        insert salesorg;
        
        Depot__c depot = new Depot__c(
            Name = 'CR00',                // Depot Name
            Country__c = 'Costa Rica',            // Country
            Location__c = 'CR00',           // Location
            Depot_Code__c = 'CR00',           // Depot Code
            SalesOrg__c = salesorg.id,  // Sales Org
            //Plant_Desc__c = 'BL02',           // Plant Desc
            Active__c = true                 // Active
        );
        insert depot ;
        
        TM_Depot_Mapping__c tdmObj = new TM_Depot_Mapping__c(
          Depot__c = depot.Id,
            Territory_Manager__c = u1.Id
        );
        insert tdmObj;
        
        Product2 product = new Product2(
            Name = 'FG PURCHASED',               // Product Name
            ProductCode = 'RM005',                 // Product Code
            Product_Code__c = 'RM005',             // Product Code
            IsActive = false,                      // Active
            Active__c = false,                     // Active
            Sales_Org__c = salesorg.id,      // Sales Org
            Combination_Key__c = 'RM00564102010',  // Combination Key
            Popular__c = false,                    // Popular
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = false,     // Active For Liquidation
           
            Budget_NRV__c = 0.00                  // Budget NRV
        );
        insert product ;
        
        SKU__c sku = new SKU__c(
            Name = '1 KG',                                                  // SKU Name
            SKU_Code__c = '000000000006303809', 
            Product_Name__c = product.id,                              // SKU Code
            SKU_Description__c = 'Devona Disperss ( Copp sulp +Manco)  1kg',  // SKU Description
            UOM__c = 'KG',                                                    // UOM
            GST__c = 18,                                                      // GST
            Pack_Size__c = 10.00,                                             // Pack Size
            Sales_Org__c = salesorg.id,                                 // Sales Org
            Combination_Key__c = '12102010000000000006303809',                // Combination Key
            Active__c = true,
            Inventory_Material_Type__c =  matType.id                                                // Active
        );
        insert sku;
        
        Inventory__c inv = new Inventory__c(
            SKU_Depot__c = '13124124241244',              // SKU Depot
            Depot__c = depot.id,                   // Depot
            SKU__c = sku.id,                     // SKU
            Stock_Quantity__c = 32.00,                      // Stock Quantity
            Sales_Org__c = salesorg.id               // Sales Org
            
        );
        insert inv;
        
        Stock_Requirement__c stkreq = new Stock_Requirement__c(
            SKU__c = sku.id,     // SKU
            Depot__c = depot.id,     // Depot
            Unrestricted_Stock__c = 45.00,    // Unrestricted Stock
            Sales_Order_Stock__c = 34.00,     // Sales Order Stock
            Delivery_Stock__c = 28.00,        // Delivery Stock
            Purchase_Order_Stock__c = 84.00,  // Purchase Order Stock
            Stock_In_Transit__c = 23.00,      // Stock In Transit
            UOM__c = 'DR'                    // UOM
        );
        insert stkreq;
        
        //Run as Australia User
        Test.startTest();
        system.runAs(u2){
            ViewCostaRicaInventory obj = new  ViewCostaRicaInventory();
            ViewCostaRicaInventory.getInventories(1,10,'BL02;',true,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('Product/Sku','kg',1,10,'BL02;',true,'All');
            ViewCostaRicaInventory.getDepot();
            
            ViewCostaRicaInventory.getInventories(1,10,'BL02;',true,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('','kg',1,10,'BL02;',true,'All');
            
           
            ViewCostaRicaInventory.getInventories(1,10,'BL02;',true,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('storage Location','kg',1,10,'BL02;',true,'All');
            
            ViewCostaRicaInventory.getInventories(1,10,'BL02;',true,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('Brand Name','kg',1,10,'BL02;',true,'All');
        }
        Test.stopTest();   
        //Run as Australia User
       /* u2.Country  = 'Belgium';
        update u2;*/
        system.runAs(u1){
            ViewCostaRicaInventory obj = new  ViewCostaRicaInventory();
            ViewCostaRicaInventory.getInventories(1,10,'BL02;',true,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('Product/Sku','kg',1,10,'BL02;',true,'All');
            
            
            ViewCostaRicaInventory.getInventories(1,10,'BL02;',true,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('','kg',1,10,'BL02;',true,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('Product/Sku','',1,10,'BL02;',true,'All');
            
           
            ViewCostaRicaInventory.getInventories(1,10,'BL02;',true,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('storage Location','kg',1,10,'BL02;',true,'All');
        }
        
     // Run as Admin
            ViewCostaRicaInventory obj = new  ViewCostaRicaInventory();
            ViewCostaRicaInventory.getInventories(1,10,'BL02;',true,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('SKU Code','kg',1,10,'BL02;',true,'All');
         
            
            //ViewColombiaInventory.getInventories(1,10);
            //ViewColombiaInventory.getBySKUAndSLocation('','kg',1,10);
            
           
         //   ViewColombiaInventory.getInventories(1,10);
           // ViewColombiaInventory.getBySKUAndSLocation('storage Location','kg',1,10);
       
    
    }
    static testMethod void testMethod2(){
        
        User u2 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name Like '%Colombia%' LIMIT 1 ].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Country ='Colombia'
        );  
        
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name Like '%Colombia%' LIMIT 1].Id,
            LastName = 'last',
            Email = 'puser001@amamama.com',
            Username = 'puser001@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias1',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Country ='Costa Rica'
        );  
        
        Inventory_Material_Type__c matType = new Inventory_Material_Type__c(
            Name = 'HAWA',                 // Material Type Name
            Material_Type_Name__c = 'HAWA' // Material Type Name
        );
        insert matType;
        
        
        
        Sales_Org__c salesorg = new Sales_Org__c(
            Name = 'Costa Rica',           // Sales Org Name
            Description__c = 'Costa Rica',   // Description
            Company_Code__c = '5300',    // Company Code
            Sales_Org_Code__c = '5310',// Sales Org Code
            Continent__c = 'South America'
        );
        insert salesorg;
        
        Depot__c depot = new Depot__c(
            Name = 'CR00',                // Depot Name
            Country__c = 'Costa Rica',            // Country
            Location__c = 'CR00',           // Location
            Depot_Code__c = 'CR00',           // Depot Code
            SalesOrg__c = salesorg.id,  // Sales Org
            Plant_Desc__c = 'CR00',           // Plant Desc
            Active__c = true                 // Active
        );
        insert depot ;
        
        TM_Depot_Mapping__c tdmObj = new TM_Depot_Mapping__c(
          Depot__c = depot.Id,
            Territory_Manager__c = u1.Id
        );
        insert tdmObj;
        
        Product2 product = new Product2(
            Name = 'FG PURCHASED',               // Product Name
            ProductCode = 'RM005',                 // Product Code
            Product_Code__c = 'RM005',             // Product Code
            IsActive = false,                      // Active
            Active__c = false,                     // Active
            Sales_Org__c = salesorg.id,      // Sales Org
            Combination_Key__c = 'RM00564102010',  // Combination Key
            Popular__c = false,                    // Popular
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = false,     // Active For Liquidation
           
            Budget_NRV__c = 0.00                  // Budget NRV
        );
        insert product ;
        
        SKU__c sku = new SKU__c(
            Name = '1 KG',                                                  // SKU Name
            SKU_Code__c = '000000000006303809', 
            Product_Name__c = product.id,                              // SKU Code
            SKU_Description__c = 'Devona Disperss ( Copp sulp +Manco)  1kg',  // SKU Description
            UOM__c = 'KG',                                                    // UOM
            GST__c = 18,                                                      // GST
            Pack_Size__c = 10.00,                                             // Pack Size
            Sales_Org__c = salesorg.id,                                 // Sales Org
            Combination_Key__c = '12102010000000000006303809',                // Combination Key
            Active__c = true,
            Inventory_Material_Type__c =  matType.id                                                // Active
        );
        insert sku;
        
        Inventory__c inv = new Inventory__c(
            SKU_Depot__c = '13124124241244',              // SKU Depot
            Depot__c = depot.id,                   // Depot
            SKU__c = sku.id,                     // SKU
            Stock_Quantity__c = 32.00,                      // Stock Quantity
            Sales_Org__c = salesorg.id               // Sales Org
            
        );
        insert inv;
        
        Stock_Requirement__c stkreq = new Stock_Requirement__c(
            SKU__c = sku.id,     // SKU
            Depot__c = depot.id,     // Depot
            Unrestricted_Stock__c = 45.00,    // Unrestricted Stock
            Sales_Order_Stock__c = 34.00,     // Sales Order Stock
            Delivery_Stock__c = 28.00,        // Delivery Stock
            Purchase_Order_Stock__c = 84.00,  // Purchase Order Stock
            Stock_In_Transit__c = 23.00,      // Stock In Transit
            UOM__c = 'DR'                    // UOM
        );
        insert stkreq;
        
        //Run as Australia User
        Test.startTest();
        system.runAs(u2){
            ViewCostaRicaInventory obj = new  ViewCostaRicaInventory();
            ViewCostaRicaInventory.getInventories(1,10,'BL02;',false,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('Product/Sku','PM Filling',1,10,'BL02;',false,'All');
            ViewCostaRicaInventory.getDepot();
            
            ViewCostaRicaInventory.getInventories(1,10,'BL02;',false,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('','PM Filling',1,10,'BL02;',false,'All');
            
           
            ViewCostaRicaInventory.getInventories(1,10,'BL02;',false,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('storage Location','PM Filling',1,10,'BL02;',false,'All');
            
            ViewCostaRicaInventory.getInventories(1,10,'BL02;',true,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('Brand Name','kg',1,10,'BL02;',true,'All');
        }
        Test.stopTest();   
        //Run as Australia User
       /* u2.Country  = 'Belgium';
        update u2;*/
        system.runAs(u1){
            ViewCostaRicaInventory obj = new  ViewCostaRicaInventory();
            ViewCostaRicaInventory.getInventories(1,10,'BL02;',false,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('Product/Sku','PM Filling',1,10,'BL02;',false,'All');
            
            
            ViewCostaRicaInventory.getInventories(1,10,'BL02;',false,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('','PM Filling',1,10,'BL02;',false,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('Product/Sku','',1,10,'BL02;',false,'All');
            
           
            ViewCostaRicaInventory.getInventories(1,10,'BL02;',false,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('storage Location','PM Filling',1,10,'BL02;',false,'All');
            
            ViewCostaRicaInventory.getInventories(1,10,'BL02;',true,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('Brand Name','kg',1,10,'BL02;',true,'All');
        }
        
     // Run as Admin
            ViewCostaRicaInventory obj = new  ViewCostaRicaInventory();
            ViewCostaRicaInventory.getInventories(1,10,'BL02;',false,'All');
            ViewCostaRicaInventory.getBySKUAndSLocation('SKU Code','PM Filling',1,10,'BL02;',false,'All');
         	ViewCostaRicaInventory.getSpainOrg();
            ViewCostaRicaInventory.WrapStockReqInventory ww = new ViewCostaRicaInventory.WrapStockReqInventory();
            //ViewColombiaInventory.getInventories(1,10);
            //ViewColombiaInventory.getBySKUAndSLocation('','kg',1,10);
            
           
         //   ViewColombiaInventory.getInventories(1,10);
           // ViewColombiaInventory.getBySKUAndSLocation('storage Location','kg',1,10);
       
    
    }
}