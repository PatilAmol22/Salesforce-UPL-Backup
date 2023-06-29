@isTest
public class ParentChildSkuMappingControllerTest {

    static testMethod void validateHelloWorld() {
        RecordType skuRcdTp = [SELECT Id FROM RecordType WHERE name = 'SKU' and isActive = true LIMIT 1];
       
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Description__c='Brazil';
        sorg.Sales_Org_Code__c='5191';
        sorg.Is_Active_Forecast__c = true;
        insert sorg;

        Division__c div = new Division__c();
        div.Name = 'Decco';
        div.Description__c = 'Decco';
        div.Division_Code__c = 'DC0';
        insert div;

        Product2 pro = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 20 KG',          // Product Name
            RecordTypeId = skuRcdTp.Id,
            Product_Code__c = '000000000005250380',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = true,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250380',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 20 KG'     // Product Description
        );
        insert pro;

        Product2 pro2 = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 10 KG',          // Product Name
            RecordTypeId = skuRcdTp.Id,
            Product_Code__c = '000000000005250381',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250381',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 10 KG',     // Product Description
            Parent__c = pro.id
        );
        insert pro2;

        Product2 pro3 = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 30 KG',          // Product Name
            RecordTypeId = skuRcdTp.Id,
            Product_Code__c = '000000000005250382',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250382',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 30 KG'     // Product Description
        );
        insert pro3;

        List<ParentChildSkuMappingController.ParentChildSKUWrapper> skuList = ParentChildSkuMappingController.getChildSKUList('');

        for(ParentChildSkuMappingController.ParentChildSKUWrapper pcw : skuList){
            pcw.prodIdParent = pro.id;
        }

        ParentChildSkuMappingController.saveMapping(JSON.serialize(skuList));

        List<ParentChildSkuMappingController.ParentChildSKUWrapper> pcwList = new List<ParentChildSkuMappingController.ParentChildSKUWrapper>();
        ParentChildSkuMappingController.ParentChildSKUWrapper pcw = new ParentChildSkuMappingController.ParentChildSKUWrapper();
        pcw.prodCode = pro2.Product_Code__c;
        pcw.prodCodeParent = pro.Product_Code__c;
        pcwList.add(pcw);

        pcw.prodCode = pro2.Product_Code__c;
        pcw.prodCodeParent = '000000000005250300';
        pcwList.add(pcw);

        pcw.prodCode = '000000000005250400';
        pcw.prodCodeParent = pro.Product_Code__c;
        pcwList.add(pcw);

        ParentChildSkuMappingController.uploadCSV(JSON.serialize(pcwList));
    }
}