@isTest
public class StockReturnEntry_Test{

    public static testmethod void stockEntryMethod(){
    
     User terrman = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
         );  
         insert terrman;
         
          User regman = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
         );  
         insert regman;
         
          User zoneman = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Managers'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
         );  
         insert zoneman ;
         
          User sbuHead = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'SBU Profile'].Id, //Sales Head Pune
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
         );  
         insert sbuHead ;
         
       Sales_Org__c salorg = new Sales_Org__c();
         salorg.name = 'India';
         salorg.Sales_Org_Code__c = '1000';
         insert salorg; 
       
      SBU__c sbu = new SBU__c(
          Brazil_SBU_Name__c = 'GESTÃO SEDE',  // Brazil SBU Name
          SBUCode__c = 'BR0',                  // SBU Code
          SalesOrg__c = salorg.id,
          SBUUser__c =  sbuHead.id    // Sales Org
        );
        insert sbu;  
        
       Zone__c zone = new Zone__c(
              Name = 'BU CERRADO',            // Zone Name
              SalesOrg__c = salorg.id,  // Sales Org
              ZoneCode__c = 'BR40',         // Zone Code
              ZonalHead__c = zoneman.id
            );
            insert zone;
            
        Region__c region = new Region__c(
              Name = 'TRIANGULO',                  // Region Name
              RegionCode__c = 'BR4003',              // Region Code
              SalesOrg__c = salorg.id,       // Sales Org
              RegionHead__c = regman.id,
              Zone__c = zone.id     
            );
        insert region;
        
         Territory_Distributor__c territory = new Territory_Distributor__c();
         territory.Name = 'Narayangaon';
         territory.TerritoryManager__c = terrman.id;
         territory.TerritoryCode__c = '397';
         territory.Region__c = region.id;
         territory.Zone__c = zone.id;
         territory.SBU__c = sbu.id;
         territory.Present_in_KEDE__c = true;
         territory.Neglected__c = false;
         
         insert territory;
         
          Id recordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
          
          Account accObj = new Account(
              Name = 'AKASH KRUSHI KENDRA',
              Last_Name__c = 'AKASH KRUSHI KENDRA - MANDRUP',       // Last Name
               recordtypeid = recordTypeIdAccount,                // Mobile
              OwnersetbyProcess__c = true,                          // Owner set by Process
              Status__c = 'Active',                                 // Status
              Zone__c = 'Pune',   
              Sales_Org__c  =  salorg.id,                                 // Zone
              Cust_Group__c = '189',                                // Customer Group
              Territory_Code__c = '189',                            // Territory Code
              ApprovedbyRegionalManager__c = false,                 // Approved by Regional Manager
              ApprovedbyZonalHead__c = false,
              ApprovalStatus__c = 'Draft',  
              OwnerId  =  terrman.id
                                      // Approval Status
        );
        insert accObj;
        
        Depot__c depot = new Depot__c(
          Name = 'Pune',                  // Depot Name
          Country__c = 'India',             // Country
          Location__c = 'Pune',             // Location
          Depot_Code__c = 'PUN1',           // Depot Code
          SalesOrg__c = salorg.id  // Sales Org
        );
        insert depot;
     
         Distributor_Depot_Mapping__c distDepotMapp = new Distributor_Depot_Mapping__c(
              Depot__c = depot.id,      // Depot
              Distributor__c = accObj.id  // Distributor
            );
            insert distDepotMapp;
            
        Invoice__c invoice = new Invoice__c(
              Billing_Doc_Number__c = '1419428599',       // Billing Doc Number
              Billing_Date__c =date.parse('12/5/2018'),  // Billing Date
              PO_Number__c = 'ORDER BY MAHATME-4.2',        // PO Number
              Sold_To_Party__c =accObj.id ,         // Sold To Party
               Sales_Org__c = salorg.id            // Sales Org
            );
            insert invoice;
            
       
         Product2 prodct = new Product2(
          Name = 'MICRONUTRIENT',              // Product Name
          ProductCode = '25201',                 // Product Code
          Product_Code__c = '25201',             // Product Code
          Sales_Org__c = salorg.id,      // Sales Org
          Combination_Key__c = '2520112102092'  // Combination Key
          );
        insert prodct;     
            
       SKU__c sku = new SKU__c(
              Name = '100 GM',                                  // SKU Name
              SKU_Code__c = '000000000000998002',                 // SKU Code
              Product_Name__c = prodct.id,                // Product Name
              SKU_Description__c = 'INVADE-100 GM',               // SKU Description
              UOM__c = 'KG',                                      // UOM
              GST__c = 18,                                        // GST
              Pack_Size__c = 6.00,                                // Pack Size
              Sales_Org__c = salorg.id,                   // Sales Org
              Combination_Key__c = '10002010000000000000998002',  // Combination Key
              Active__c = true,                                   // Active
              Brand_Name__c = 'INVADE'                           // Brand Name
            );
            insert sku;
            
      Invoice_Line_Item__c invLineItem = new Invoice_Line_Item__c(
          Invoice__c = invoice.id, // Invoice
          Quantity__c = 18.00,              // Quantity
          SKU__c = sku.id,       // SKU
          Batch__c = 'HNJIVD2025',          // Batch
          Net_Value__c = 111330.00,         // Net Value
          Status__c = 'C',                  // Status
          Depot__c = depot.id    // Depot
        );
        insert invLineItem ;
        
         Stock_Return__c stkRtnObj = new Stock_Return__c(
          Customer_Name__c = accObj.id,        // Customer Name
          Depot__c = depot.id,                // Depot
          Territory__c = territory.id           // Territory
            );
         insert stkRtnObj ;
        
         Stock_Return_Values__c stkRtnValObj = new Stock_Return_Values__c();
        stkRtnValObj.Admin_Days__c = 30; 
        stkRtnValObj.Freight_Rate__c =2.5;
        insert stkRtnValObj;
       
     ApexPages.StandardController sc = new ApexPages.StandardController(stkRtnObj);
     StockReturnEntry stkRtnEntryObj = new StockReturnEntry(sc);
     stkRtnEntryObj.distributorId = accObj.id;
     stkRtnEntryObj.invoiceId = invoice.id;
     stkRtnEntryObj.prodName = sku.Product_with_SKU__c;
     stkRtnEntryObj.invoiceItemId = invLineItem.id;
     stkRtnEntryObj.returnDate = date.newInstance(system.today().year(),system.today().Month(),system.today().day());
     stkRtnEntryObj.stkRtnQty = '10.00';
     stkRtnEntryObj.rowNum = 1;
     stkRtnEntryObj.resonStkReturn = 'fbfdghdfhdsfhhhdhsh';
     stkRtnEntryObj.getDistCodeDepot();
     stkRtnEntryObj.changeInvoiceList();
     stkRtnEntryObj.changeProductlist();
     stkRtnEntryObj.updateInvoiceId();
     stkRtnEntryObj.updateinv();
      stkRtnEntryObj.distributorId = accObj.id;
     stkRtnEntryObj.invoiceId = invoice.id;
     stkRtnEntryObj.prodName = sku.Product_with_SKU__c;
     stkRtnEntryObj.invoiceItemId = invLineItem.id;
     stkRtnEntryObj.returnDate = date.newInstance(system.today().year(),system.today().Month(),system.today().day());
     stkRtnEntryObj.stkRtnQty = '10.00';
     stkRtnEntryObj.addToItemList();
     stkRtnEntryObj.updatelineitem();
     stkRtnEntryObj.removeItem();
     stkRtnEntryObj.saveReturnItems();
     
    }


}