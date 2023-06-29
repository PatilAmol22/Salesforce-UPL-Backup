/*----------Nikhil------------*/
@isTest
public class ChangeLiquidationPermissionCltrl_test{
    static testmethod void  testPermission(){
        
         Sales_Org__c salorg = new Sales_Org__c();
         salorg.name = 'India';
         salorg.Sales_Org_Code__c = '1000';
         insert salorg; 
         
         Territory_Distributor__c territory = new Territory_Distributor__c();
         territory.Name = 'Narayangaon';
         territory.Neglected__c = false;
         territory.Present_in_KEDE__c = true;
         territory.TerritoryCode__c = '397';
         
         territory.SalesOrg__c = salorg.id;
         insert territory;
         
         Country__c country=new Country__c(Name='India',Country_Id__c='91');
         insert country;
         
         State__c state= new State__c(
              Name = 'Uttar Pradesh',                 // State Name
              State_Code__c = '9',                     // State Code
              Country__c = 'India',                    // Country
              Active__c = true,                        // Active
              State_Code_Census__c = '9',              // State Code Census
              State_Name_Census__c = 'UTTAR PRADESH',  // State Name Census
              Country_Akc__c = country.id,             // Country
              SalesOrg__c= salorg.id
            );
            insert state;
            
            Product2 sobj4 = new Product2(
              Name = 'ULALA',                                    // Product Name
              //Product_Code__c = '74400',                           // Product Code
              Active__c = true,                                    // Active
              Sales_Org__c = salorg.id,                    // Sales Org
              Combination_Key__c = '7440010002010',                // Combination Key
              Popular__c = false,                                  // Popular
             // VF_Image__c = '/resource/1474914704000/No_Image',    // VF Image
              //Brand_Type__c = 'Strategic Brand',                   // Brand Type
              Power_Brand__c = true,                               // Power Brand
              //Sales_Org_Code__c ='1000',                          // Sales Org Code
              Active_For_Liquidation__c = true,                    // Active For Liquidation
              //SalesOrgDistributionChannelDivison__c = '10002010',  // SalesOrg+Distribution Channel + Divison
              //New_Combination_Key_without_SWAL__c = '744001000',   // New Combination Key without SWAL
              //New_Combination_Key_for_SWAL__c = '7440010002010',   // New Combination Key for SWAL
             // Indication_Type__c = 'Others',                       // Indication Type
              Budget_NRV__c = 30.00                             // Budget NRV
            );
            insert sobj4;
            
         Liquidation_Annual_Plan__c sobj = new Liquidation_Annual_Plan__c(
             // Fiscal_Start_Date__c = Date.valueOf('1-4-2018'),// Fiscal Start Date
              FIscal_Year__c = '2018-2019',                     // FIscal Year
              //Fiscal_End_Date__c = Date.valueOf('31-3-2019'),   // Fiscal End Date
              SentToBatch__c = true,                            // Sent To Batch
              State__c = state.Id                     // State
            );
            insert sobj;
            
            
            Opening_Inventory2__c sobj3 = new Opening_Inventory2__c(
              Product__c = sobj4.Id,                 // Product
              Opening_Inventory_Cooperatives__c = 0,          // Opening Inventory Cooperatives
              Opening_Inventory__c = 0,                       // Opening Inventory
              Opening_Inventory_Govt__c = 0,                  // Opening Inventory Govt
              Liquidation_Annual_Plan__c = sobj.Id,   // Liquidation Annual Plan
              YTD_Sales_Corporate__c = 0,                     // YTD Sales Corporate
              X15_days_lock__c = false,                         // 15 days lock
              YTD_Sales_Govt__c = 0,                          // YTD Sales Govt
              //RecordTypeId = 'undefined',                       // Record Type
              YTD_Sales__c = 0                               // YTD Sales
              //State__c = 'a040k000006kq4w',                     // State
              //combination_key__c = '5900210002018-201923SAIB',  // combination key
              //Period__c = '0'                                  // Period
            );
            insert sobj3;
            
          Liquidation2__c sobj2 = new Liquidation2__c(
              Opening_Inventory2__c = sobj3.Id,           // Opening Inventory2
              Liquidation_Annual_Plan__c = sobj.Id,        // Liquidation Annual Plan
              Product__c = sobj4.Id,                        // Product
              Type__c = 'Trade',                                     // Type
              submitted__c = false,                                  // submitted
              Month__c = 'Aug',                                      // Month
              //Liquidation__c = '0',                                  // Liquidation
              //Plan_for_the_month__c = '0',                           // Plan for the month
              //Inventory_in_Kg_Cooperatives__c = '0',                 // Inventory in Kg Cooperatives
              //Inventory_in_Kg_Govt__c = '0',                         // Inventory in Kg Govt
              //Retailers_Inventory__c = '0',                          // Retailers Inventory
              //Distributors_Inventory__c = '0',                       // Distributors Inventory
              //Plan_for_the_next_month__c = '0',                      // Plan for the next month
              Territory__c = territory.Id,                      // Territory
              //YTD_Sales__c = '0',                                    // YTD Sales
              //combination_key__c = '6820510002018-2019235TRADEAug',  // combination key
              submitted_trade__c = false                            // submitted_trade
              //Territory_Code__c = '235'                            // Territory Code
              
            );
            insert sobj2;
            
            ChangeLiquidationPermissionCltrl chngPer=new ChangeLiquidationPermissionCltrl();
            chngPer.stateTerritoryList();
            chngPer.liqdtnAnlPlnPicklist();
            chngPer.liqMonthPicklist();
            chngPer.updtLiqDetailPermission();
             
                        
            
      }    
}