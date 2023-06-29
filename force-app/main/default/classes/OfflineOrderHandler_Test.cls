@istest(seealldata=true)
public class OfflineOrderHandler_Test{
    
      /* 
        -----------------------------
        Developer Name - Pravin J.
        Created Date -  18/09/2017
        Last Modified Date - -------
        Description - class created for
        Mobile Development Purpose
        ------------------------------
    */
    
    
    
    
    public OfflineOrderHandler_Test(){
        System.debug('--Constructor Calling--');    
    }    
    
    
     public static void init(){
     
            //Account Rectype
            Id brazilAccRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();   
            //Depot Rectype
            Id brazilDepotRecType = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();   
            
            System.debug('brazilAccRecType-->'+brazilAccRecType +'brazilDepotRecType ---->'+brazilDepotRecType );
            Profile p = [SELECT Id,Name FROM Profile WHERE Name='Territory Manager'];
       
          System.debug(' Profile p-->'+ p );
          
            User usr = new User(
                Alias = 'standt',
                Email='standarduser@testorg.com', 
                EmailEncodingKey='UTF-8', 
                LastName='Testing', 
                LanguageLocaleKey='en_US',
                IsActive=true, 
                LocaleSidKey='en_US',
                ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles',
                UserName='Pravin2standarduser@testorg.com'
            );
            insert usr;
            System.debug('User iNSERTED->'+ usr ); 
            
            Sales_Org__c sobjSalesOrg = new Sales_Org__c(
                Name = 'Brazil',           // Sales Org Name
                Sales_Org_Code__c = '51911',  // Sales Org Code
                Company_Code__c = '51901',    // Company Code
                Country_Code__c = 'BZ'      // Country Code
            );
            insert sobjSalesOrg;
            System.debug('sobjSalesOrg iNSERTED->'+ sobjSalesOrg );
            
            /*
            Auto_Number__c auto = new Auto_Number__c();
            auto.Name='FarmerCode';
            auto.Sequence__c='111';
            insert auto;
            
             System.debug('Auto_Number__c iNSERTED->'+ auto);*/
            
            Depot__c sobjDepot = new Depot__c(
                Name = 'UPL Do Brasil - Bahia',
                Country__c = 'Brazil',
                Depot_Code__c = 'BR061',
                RecordTypeId = brazilDepotRecType,
                Active__c = true,              
                SalesOrg__c = sobjSalesOrg.Id
            );
            insert sobjDepot;
            
             System.debug('sobjDepot iNSERTED->'+ sobjDepot);
            
            Account sobjAccount = new Account(
                Active__c = true,                        // Active
                SAP_Code__c = '0801028102',
                Name='Pravin Jagadale100',               
                Last_Name__c = 'Padmavati Agro Agency 1000',   // Last Name
                Status__c = 'Active',
                Mobile__c='9697300596',
                RecordTypeId = brazilAccRecType
                
            );
            insert sobjAccount;
            
              System.debug('sobjAccount iNSERTED->'+ sobjAccount);
              
            Shipping_Location__c sobjShippingLoc = new Shipping_Location__c(
                Location_Name__c = 'PADMAVATI KRISHI UDYOG - brazil100',
                SAP_Code__c = '0402503058', 
                Distributor__c = sobjAccount.Id,
                Sold_To_Party_SAP_Code__c = '0001447758'
            );
            insert sobjShippingLoc;
            
             System.debug('sobjShippingLoc iNSERTED->'+ sobjShippingLoc);
             
            Product2 sobjProduct = new Product2(
                Name = 'ACEPHATE 40 SL',
                ProductCode = '68205',
                Product_Code__c = '68205',
                IsActive = false,
                Sales_Org__c = sobjSalesOrg.id,      // Sales Org
                Combination_Key__c = '0020510088010',  // Combination Key
                Popular__c = false,                    // Popular
                Power_Brand__c = false                // Power Brand
            );
            insert sobjProduct ;
            
            Distribution_Channel__c sobjdistChannel = new Distribution_Channel__c(
                Name = '20',                        // Distribution Channel Name
                Distribution_Channel_Code__c = '88'  // Distribution Channel Code
                );
            insert sobjdistChannel;
            
            Division__c sobjDiv = new Division__c(
                Name = 'Agro Formulation',// Division Name
                Division_Code__c = '99'    // Division Code
                );
            insert sobjDiv;
            
            SKU__c sobjSku = new SKU__c(
                Name = 'a1C0k0000000vD5',                              // SKU Name
                SKU_Code__c = '0000011100000022052',                      // SKU Code
                Product_Name__c = sobjProduct.id,                     // Product Name
                SKU_Description__c = 'ACEPHATE 40SL (E) - 500 ML HDPE',  // SKU Description
                UOM__c = 'L',                                            // UOM
                Distribution_Channel__c = sobjdistChannel.id,             // Distribution Channel
                Division__c = sobjDiv.id,                         // Division
                Pack_Size__c = 5.00,                                     // Pack Size
                Sales_Org__c = sobjSalesOrg.id,                        // Sales Org
                Combination_Key__c = '10002010232300000000682052',       // Combination Key
                Active__c = false                                       // Active
            );
            insert sobjSku;
            
            String prdtId= String.valueof(sobjProduct.id);
             String skuId= String.valueof(sobjSku.id);
            
           
         
            Offline_Mobile_Order__c sobjOffMobile = new Offline_Mobile_Order__c(
                Sales_Org_txt__c = sobjSalesOrg.Id,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  // Sales Org txt
                Status__c = 'Completed',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 // Status
                Account_txt__c = sobjAccount.Id,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      // Account
                Depot_txt__c =sobjDepot.Id,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        // Depot
                Order_Type__c = 'Credit',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   // Order Type
                    Order_Raised_By__c = usr.Id,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  // Order Raised By
                Shipping_Location_txt__c = 'Nashik  13 India',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              // Shipping Location
                Shipping_Location_Id__c = sobjShippingLoc.id,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            // Shipping Location Id
                Offline_Mobile_LineItem__c = '[{"product_name":"AISHWARYA","product_id":"'+prdtId+'","sku_name":"250 ML","sku_id":"'+skuId+'","sku_qty":"10.0","stock_qty":"0","in_transit_qty":"0","price":"641.0","base_price":"641.0","special_dis":"0.0","invoice_dis":"0.0","total_amount":"641.0","list_price":"641.0","product_image":"no_image","pack_Size":"10.0","no_case_size":"1","Order_Raised_By__c":""}]'  // Offline Mobile LineItem
            );
            insert sobjOffMobile;
            
             
             System.debug('sobjOffMobile iNSERTED->'+ sobjOffMobile);
    }
     
    private static testMethod void test1(){
    
        test.startTest();
        init();
        
        test.stopTest();
    
    }
    
    
}