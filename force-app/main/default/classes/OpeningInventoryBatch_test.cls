@isTest
public class OpeningInventoryBatch_test{
         static testmethod void  testBatch(){
         Sales_Org__c salorg = new Sales_Org__c();
         salorg.name = 'India';
         salorg.Sales_Org_Code__c = '1000';
         insert salorg; 
         
         Product2 pdct = new Product2(
              Name = 'ATRAZINE 50 SC',             // Product Name
              ProductCode = '88852',                 // Product Code
              Product_Code__c = '88852',             // Product Code
              IsActive = true,
              Budget_NRV__c=90.00,
              Active_For_Liquidation__c =true,                      // Active
              Sales_Org__c = salorg.id,      // Sales Org
              Combination_Key__c = '8885210002010',  // Combination Key
              Popular__c = false, 
               Active__c = false,                   // Popular
              Power_Brand__c = false,
              Indication_Type__c = 'Fungicide'              // Power Brand
                 
            );
            insert pdct;
            
            /*Product2 pdct1 = new Product2(
              Name = 'ATRAZINE 50 SC',             // Product Name
              ProductCode = '88852',                 // Product Code
              Product_Code__c = '88852',             // Product Code
              IsActive = false,                      // Active
              Active__c = false,                     // Active
              Sales_Org__c = salorg.id,      // Sales Org
              Combination_Key__c = '8885210002010',  // Combination Key
              Popular__c = false,                    // Popular
                  // Brand Type
              Power_Brand__c = false,                // Power Brand
              Multiple_Of__c = 0.0,                  // Multiple Of
              Indication_Type__c = 'Fungicide'      // Indication Type
            );
            insert pdct1;*/
         
         Territory_Distributor__c territory = new Territory_Distributor__c();
         territory.Name = 'Narayangaon';
         territory.TerritoryCode__c = '398';
         territory.SalesOrg__c = salorg.id;
         insert territory;
         
         Territory_Distributor__c territory1 = new Territory_Distributor__c();
         territory.Name = 'Akola';
         territory.TerritoryCode__c = '393';
         territory.SalesOrg__c = salorg.id;
         insert territory1;
         
         Territory_Distributor__c territory2 = new Territory_Distributor__c();
         territory.Name = 'Sangamner';
         territory.TerritoryCode__c = '390';
         territory.SalesOrg__c = salorg.id;
         insert territory2;


         Liquidation_Annual_Plan__c liqannlPln = new Liquidation_Annual_Plan__c(
                  Fiscal_Start_Date__c = Date.newInstance(2018, 04, 01),// Fiscal Start Date
                  FIscal_Year__c = '2018-2019',                     // FIscal Year
                  Fiscal_End_Date__c = Date.newInstance(2019,31, 03),   // Fiscal End Date
                  Territory_Name__c = territory.id,            // Territory Name
                  SentToBatch__c = false                           // Sent To Batch
                  );
         insert liqannlPln;
         
         Liquidation_Annual_Plan__c liqannlPln1 = new Liquidation_Annual_Plan__c(
                  Fiscal_Start_Date__c = Date.newInstance(2018, 04, 01),// Fiscal Start Date
                  FIscal_Year__c = '2018-2019',                     // FIscal Year
                  Fiscal_End_Date__c = Date.newInstance(2019,31, 03),   // Fiscal End Date
                  Territory_Name__c = territory1.id,            // Territory Name
                  SentToBatch__c = false                           // Sent To Batch
                  );
         insert liqannlPln1;
         
         Liquidation_Annual_Plan__c liqannlPln2 = new Liquidation_Annual_Plan__c(
                  Fiscal_Start_Date__c = Date.newInstance(2018, 04, 01),// Fiscal Start Date
                  FIscal_Year__c = '2018-2019',                     // FIscal Year
                  Fiscal_End_Date__c = Date.newInstance(2019,31, 03),   // Fiscal End Date
                  Territory_Name__c = territory2.id,            // Territory Name
                  SentToBatch__c = false                           // Sent To Batch
                  );
         insert liqannlPln2;
         string query = 'SELECT Name,Id,SentToBatch__c,FIscal_Year__c,Territory_Name__c,Sales_Qty_External_Key_Annual_Plan__c,Fiscal_Start_Date__c,Fiscal_End_Date__c FROM Liquidation_Annual_Plan__c WHERE SentToBatch__c = false Limit 1';
         OpeningInventoryBatch  batchObj = new OpeningInventoryBatch(query);
          DataBase.executeBatch(batchObj,1);
         }

}