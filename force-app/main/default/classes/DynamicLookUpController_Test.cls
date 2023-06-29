@isTest
public class DynamicLookUpController_Test {
            
    public static TestMethod void dynamicController(){

        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='2510';
        sorg.Description__c='Spain';
        sorg.Sales_Org_Code__c='2510';
        insert sorg;

        Distribution_Channel__c disbj = new Distribution_Channel__c();
        disbj.Name = '67';                      
        disbj.Distribution_Channel_Code__c = '67';  
        disbj.Description__c='test';
        insert disbj;
        
        Division__c divsn = new Division__c();
        divsn.Name = '10';         
        divsn.Description__c = '10';    
        divsn.Division_Code__c = '10'; 
        insert divsn;
            
        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        insert pro;

        RecordType shipLocRcdTp = [SELECT Id FROM RecordType WHERE name = 'Storage Location' and isActive = true LIMIT 1];

        Depot__c depo =new Depot__c ();
        depo.Name='ES51';
        depo.recordtypeId=shipLocRcdTp.id;
        depo.Country__c='Spain';
        depo.Location__c='NORTE';
        depo.Depot_Code__c='ES51';
        depo.SalesOrg__c = sorg.ID;
        depo.Plant_Desc__c= '';
        depo.Active__c = true;
        insert depo;
        
        SKU__c sku = new SKU__c();
        sku.Name='DOST';
        sku.SKU_Code__c='000000000006001071';
        sku.SKU_Pack__c=1.00;
        sku.SKU_UOM__c='L';
        sku.Multiple_Of__c=5;
        sku.Group__c='DOST';
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='L';
        sku.Division__c = divsn.id;
        sku.Distribution_Channel__c = disbj.id;
        sku.Active__c=True;
        sku.Combination_Key__c='Cooooooo000011111';
        sku.SKU_Description__c = 'SKU';
        insert sku; 

        PriceBookMaster__c sobj = new PriceBookMaster__c(
        SKUCode__c = sku.id,                      // SKU Code
        Price__c = 45.00,                                    // Price / Max Price
        DepotCode__c = depo.id,                    // Depot Code
        Final_Price__c = 0.00,                               // Final Price
        StartDate__c = system.today(),             // Start Date
        EndDate__c = system.today(),              // End Date
        UOM__c = 'L',                                        // UOM
        Division__c = divsn.id,                 // Division
        DistributionChannel__c = disbj.id,          // Distribution Channel
        Active__c = true,                                    // Active
        PerUnit__c = 1,                                    // Per Unit
        CompositeKey__c = 'SW0625207010000000000006001071',  // CompositeKey
        Sales_Org__c = sorg.Id,                    // Sales Org
        Price_Book_Change__c = false                        // Price_Book_Change
        //Customized_Product__c = false                       // Customized Product
        );
        insert sobj;
        
        
        
        PriceBook_Indonesia_Discount__c prIndObj = new PriceBook_Indonesia_Discount__c(
            Active__c = false,                                         // Active
            UOM__c = 'KG',                                               // UOM
            Division__c = divsn.Id,                             // Division
            BeforeSwalActivity__c = false,                               // Before Swal Activity
            Price__c = 15000,                                            // Discount Price
            CompositeKey__c = 'ID0103641000000000000618017801-06-2019',  // CompositeKey
            StartDate__c = System.today(),                     // Start Date
            EndDate__c = System.today(),                      // End Date
            Sales_Org__c = sorg.Id,                            // Sales Org
            SKUCode__c = sku.Id                              // SKU Code
        );
        insert prIndObj;
        
        DynamicLookUpController.fetchLookUpValues('SKUCode__r.SKU_Description__c', 'SKUCode__r.SKU_Code__c','SKU',' ,SKUCode__c, SKUCode__r.Name, SKUCode__r.SKU_Description__c, SKUCode__r.SKU_Code__c ','PriceBookMaster__c','order by Name limit 5');
        //added by vishal CR#146 
        DynamicLookUpController.fetchLookUpValues('SKUCode__r.SKU_Description__c', 'SKUCode__r.SKU_Code__c','SKU',' ,SKUCode__c, SKUCode__r.Name, SKUCode__r.SKU_Description__c, SKUCode__r.SKU_Code__c ','PriceBook_Indonesia_Discount__c','order by Name limit 5');
        //end by vishal
        DynamicLookUpController.fetchLookUpValues('SKU_Description__c', 'SKU_Code__c','SKU',' , SKU_Description__c, SKU_Code__c ','SKU__c','order by Name limit 5');
    }
}