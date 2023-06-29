@isTest
public class SpainPortugalCampaign_Test {
    
      public static TestMethod void SpainPortugalCampaign(){
       Sales_Org__c salorg = new Sales_Org__c();
             salorg.name = 'Spain';
             salorg.Sales_Org_Code__c = '2510';
             insert salorg; 
       
          Crop__c crpObj = new Crop__c(
                Name = 'Potato',               // Crop Name
                Active__c = true,                 // Active
                SalesOrg__c = salorg.id  // Sales Org
               // Liquidation__c = false           // Liquidation
           );
           insert crpObj;  
    Product2 Product = new Product2(
          Name = 'ABAMECTIN 1.8% EC',        // Product Name
          Product_Code__c = '130',             // Product Code
          Active__c = true,                   // Active
          Sales_Org__c = salorg.id,
          Combination_Key__c = '2520112102092'   // Sales Org
        );
        insert Product;
    
  SKU__c sku = new SKU__c(
          Name = 'a1C0k000000V2aR',                              // SKU Name
          SKU_Code__c = '000000000005000448',                      // SKU Code
          Product_Name__c = Product.id,                     // Product Name
          SKU_Description__c = 'Abamectina 1,8% EC (Cormite) 5L',  // SKU Description
          UOM__c = 'L',                                            // UOM
          Sales_Org__c = salorg.id,                        // Sales Org
          Active__c = true                                       // Active
        );
        insert sku;
        
        
            
        Account accObj = new Account(
              Name = 'AKASH KRUSHI KENDRA',
              Last_Name__c = 'AKASH KRUSHI KENDRA - MANDRUP',       // Last Name
              OwnersetbyProcess__c = true,                          // Owner set by Process
              Status__c = 'Active',                                 // Status 
              Account_Type__c = 'Sold To Party',
              Sales_Org__c  =  salorg.id,                                 // Zone
              Cust_Group__c = '189',                                // Customer Group
              Territory_Code__c = '189',                            // Territory Code
              ApprovedbyRegionalManager__c = false,                 // Approved by Regional Manager
              ApprovedbyZonalHead__c = false,
              ApprovalStatus__c = 'Draft'                          // Approval Status
        );
        insert accObj;
        
          Shipping_Location__c spLoc= new Shipping_Location__c(
          Location_Name__c = 'Agroquimicos Bosch, S.L.',// Location Name
          SAP_Code__c = '0002020575',                     // SAP Code
          Distributor__c = accObj.id ,             // Distributor
          City__c = 'ALGINET (Valencia)',                 // City
          State__c = '46',                                // State
          Country__c = 'ES',                              // Country
          Pincode__c = '46230',                           // Pincode
          Sales_Org__c = salorg.id               // Sales Org
        );
        insert spLoc;
    
      Invoice__c invc1 = new Invoice__c(
              Billing_Doc_Number__c = '2111202291',       // Billing Doc Number
              Billing_Date__c = system.TODAY()-35,  // Billing Date
              Sold_To_Party__c = accObj.id,         // Sold To Party
              Delivery_Number__c = '8804792056',            // Delivery Number
              Ship_to_Party__c = spLoc.id,         // Ship to Party
              Sales_Org__c = salorg.id,             // Sales Org
              Billing_Status__c = 'M'                      // Billing Status
             
            );
            insert invc1;
            
            Invoice__c invc2 = new Invoice__c(
              Billing_Doc_Number__c = '2111202292',       // Billing Doc Number
              Billing_Date__c = system.TODAY()-35,  // Billing Date
              Sold_To_Party__c = accObj.id,         // Sold To Party
              Delivery_Number__c = '8804792052',            // Delivery Number
              Ship_to_Party__c = spLoc.id,         // Ship to Party
              Sales_Org__c = salorg.id,             // Sales Org
              Billing_Status__c = 'M'                      // Billing Status
              
            );
            insert invc2;
            system.debug('invc2>>--->'+invc2);
            Invoice_Line_Item__c invLnItm1 = new Invoice_Line_Item__c(
              Invoice__c = invc1.id,                 // Invoice
              Quantity__c = 300.00,                           // Quantity
              Invoice_Item__c = '000010',                       // Invoice Item
              Product__c = Product.id,                   // Product
              Batch__c = 'Z1608-5526',                          // Batch
              SKU__c = sku.id,                       // SKU
              UOM__c = 'KG',                                    // UOM
              Tax_Value__c = 150.00,                            // Tax Value
              Status__c = 'Posting document has been created',  // Status
              Net_Value__c = 1500.00,                           // Net Value
              SalesOrg__c = salorg.id                  // Sales Org
            );
            insert invLnItm1;
            
            Invoice_Line_Item__c invLnItm2 = new Invoice_Line_Item__c(
              Invoice__c = invc2.id,                 // Invoice
              Quantity__c = 300.00,                           // Quantity
              Invoice_Item__c = '000012',                       // Invoice Item
              Product__c = Product.id,                   // Product
              Batch__c = 'Z1608-5527',                          // Batch
              SKU__c = sku.id,                       // SKU
              UOM__c = 'KG',                                    // UOM
              Tax_Value__c = 150.00,                            // Tax Value
              Status__c = 'Posting document has been created',  // Status
              Net_Value__c = 1500.00,                           // Net Value
              SalesOrg__c = salorg.id                  // Sales Org
            );
            insert invLnItm2;
    
    Spain_Portugal_Campaign__c spCampaign = new Spain_Portugal_Campaign__c(
          Name = 'Spain Portugal',                   // Spain Portugal Campaign Name
          Start_Date__c =system.today(),  // Start Date
          Status__c = 'Planned',                       // Status
          End_Date__c = system.today()    // End Date
            );
          insert spCampaign;

   
    Customer_Forecast_Information__c CFI = new Customer_Forecast_Information__c(
          Customer__c = accObj.id,               // Customer
          Spain_Portugal_Campaign__c = spCampaign.id,  // Spain Portugal Campaign
          Forecast_Amount__c = 852.000,                  // Forecast Amount
          SKU__c = sku.id                      // SKU
        );
        insert CFI;
    
    Campaign_Crop_Details__c CampCropDtl = new Campaign_Crop_Details__c(
          Crop__c = crpObj.id,                   // Crop
          Spain_Portugal_Campaign__c = spCampaign.id  // Spain Portugal Campaign
        );
        insert CampCropDtl;
    
    Campaign_Demo_Protocol__c campDemoProtocol = new Campaign_Demo_Protocol__c(
          Objectives__c = 'Objective',                   // Objectives
          Spain_Portugal_Campaign__c = spCampaign.id,  // Spain Portugal Campaign
          Start_Date__c =system.today(),      // Start Date
          Cost__c = 5200.000,                           // Cost
          End_Date__c = system.today(),        // End Date
          Status__c = 'CONTRACT'                          // Status
        );
        insert campDemoProtocol;
    
    Expense_Activity__c ExpAct = new Expense_Activity__c(
          Activity__c = 'Promotional Input',             // Activity
          Spain_Portugal_Campaign__c = spCampaign.id,  // Spain Portugal Campaign
          Budgeted_Cost__c = 75000.000,                 // Budgeted Cost
          Actual_Cost__c = 78000.000                   // Actual Cost
        );
        insert ExpAct;
          
        string custForecastInfo = '['+JSON.serialize(CFI)+']';
        system.debug(custForecastInfo);  
        string cropDetail = '['+JSON.serialize(CampCropDtl)+']';
        string DemoProtocol = '['+JSON.serialize(campDemoProtocol)+']';
        string expenseAct = '['+JSON.serialize(ExpAct)+']';
              
    SpainProtugalCampaign SpainPortugalCampObj = new SpainProtugalCampaign();
        SpainProtugalCampaign.fetchAllRecordData(spCampaign.id);
        SpainProtugalCampaign.getselectOptions('Spain_Portugal_Campaign__c', 'CurrencyIsoCode');
        SpainProtugalCampaign.getselectOptions('Spain_Portugal_Campaign__c', 'Status__c');
        SpainProtugalCampaign.getloginuserName();
        SpainProtugalCampaign.saveSpainCampaign(spCampaign,custForecastInfo,cropDetail,DemoProtocol,expenseAct,custForecastInfo,cropDetail,DemoProtocol,expenseAct);
      }   
}