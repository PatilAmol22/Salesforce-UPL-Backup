@isTest(SeeAllData=false)
private class ViewAustraliaInventory_Test {
    
    @TestSetup
    static void setupTestData(){
        	Inventory_Material_Type__c matType = new Inventory_Material_Type__c(
            Name = 'HAWA',                 
            Material_Type_Name__c = 'HAWA' 
       		 );
            
            Sales_Org__c salesorg = new Sales_Org__c(
            Name = 'Australia',           
            Description__c = 'Australia',   
            Company_Code__c = '6000',    
            Sales_Org_Code__c = '6100'
        );
        insert salesorg;
        
        Depot__c depot = new Depot__c(
            Name = 'UPL-Australia',                
            Country__c = 'Australia',            
            Location__c = 'UPL-Australia',           
            Depot_Code__c = 'AU00',           
            SalesOrg__c = salesorg.id,  
            Active__c = true                 
        );
        insert depot ;
        
        
        Product2 product = new Product2(
            Name = 'FG PURCHASED',               
            ProductCode = 'RM005',                 
            Product_Code__c = 'RM005',             
            IsActive = false,                      
            Active__c = false,                     
            Sales_Org__c = salesorg.id,      
            Combination_Key__c = 'RM00564102010',  
            Popular__c = false,                    
            Power_Brand__c = false,                
            Active_For_Liquidation__c = false,     
            Budget_NRV__c = 0.00                  
        );
        insert product ;
        
        SKU__c sku = new SKU__c(
            Name = '1 KG',                                                  
            SKU_Code__c = '000000000006303809', 
            Product_Name__c = product.id,                              
            SKU_Description__c = 'Devona Disperss ( Copp sulp +Manco)  1kg',  
            UOM__c = 'KG',                                                    
            GST__c = 18,                                                      
            Pack_Size__c = 10.00,                                             
            Sales_Org__c = salesorg.id,                                 
            Combination_Key__c = '12102010000000000006303809',               
            Active__c = true,
            Inventory_Material_Type__c =  matType.id                                               
        );
        insert sku;
        
        Inventory__c inv = new Inventory__c(
            SKU_Depot__c = '13124124241244',              
            Depot__c = depot.id,                   
            SKU__c = sku.id,                     
            Stock_Quantity__c = 32.00,                      
            Sales_Org__c = salesorg.id               
            
        );
        insert inv;
        
        Stock_Requirement__c stkreq = new Stock_Requirement__c(
            SKU__c = sku.id,     
            Depot__c = depot.id,     
            Unrestricted_Stock__c = 45.00,    
            Sales_Order_Stock__c = 34.00,     
            Delivery_Stock__c = 28.00,        
            Purchase_Order_Stock__c = 84.00,  
            Stock_In_Transit__c = 23.00,      
            UOM__c = 'DR'                  
        );
        insert stkreq;
        
    }
    
    static testMethod void testMethod1(){
        User admin = [Select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        User nonAdmin = [Select Id from User where Profile.Name like '%Australia%' and isActive = true limit 1];
        Depot__c depot = [Select Id from Depot__c where  Depot_Code__c = 'AU00' limit 1];
        TM_Depot_Mapping__c tdmObj = new TM_Depot_Mapping__c(
        	Depot__c = depot.Id,
            Territory_Manager__c = nonAdmin.Id
        );
        insert tdmObj;
        
        Test.startTest();
        system.runAs(admin){
            ViewAustraliaInventory obj = new  ViewAustraliaInventory();
            ViewAustraliaInventory.getInventories(1,10,'BL02;',true);
            ViewAustraliaInventory.getBySKUAndSLocation('Product/Sku','kg',1,10,'BL02;',true);
            ViewAustraliaInventory.getDepot();
            
            ViewAustraliaInventory.getInventories(1,10,'BL02;',true);
            ViewAustraliaInventory.getBySKUAndSLocation('','kg',1,10,'BL02;',true);
            
           
            ViewAustraliaInventory.getInventories(1,10,'BL02;',true);
            ViewAustraliaInventory.getBySKUAndSLocation('storage Location','kg',1,10,'BL02;',true);
            
            ViewAustraliaInventory.getInventories(1,10,'BL02;',true);
            ViewAustraliaInventory.getBySKUAndSLocation('Brand Name','kg',1,10,'BL02;',true);
        }
        Test.stopTest();   
        system.runAs(nonAdmin){
            ViewAustraliaInventory obj = new  ViewAustraliaInventory();
            ViewAustraliaInventory.getInventories(1,10,'BL02;',true);
            ViewAustraliaInventory.getBySKUAndSLocation('Product/Sku','kg',1,10,'BL02;',true);
            
            
            ViewAustraliaInventory.getInventories(1,10,'BL02;',true);
            ViewAustraliaInventory.getBySKUAndSLocation('','kg',1,10,'BL02;',true);
            ViewAustraliaInventory.getBySKUAndSLocation('Product/Sku','',1,10,'BL02;',true);
            
           
            ViewAustraliaInventory.getInventories(1,10,'BL02;',true);
            ViewAustraliaInventory.getBySKUAndSLocation('storage Location','kg',1,10,'BL02;',true);
        }
            ViewAustraliaInventory obj = new  ViewAustraliaInventory();
            ViewAustraliaInventory.getInventories(1,10,'BL02;',true);
            ViewAustraliaInventory.getBySKUAndSLocation('SKU Code','kg',1,10,'BL02;',true);
    
    }
}