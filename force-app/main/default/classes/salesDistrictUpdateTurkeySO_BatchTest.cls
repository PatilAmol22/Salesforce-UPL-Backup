@isTest
private class salesDistrictUpdateTurkeySO_BatchTest {

@testSetup
    static void allTestData() {
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        //Id SOrecordTypeId = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Sales Order').getRecordTypeId(); 
                
        /*Trigger_Settings__c newtri = new Trigger_Settings__c();
        newtri.Name = 'SOLICombKeyTrigger';
        newtri.isActive__c = true;
        insert newtri;
        
        Trigger_Settings__c trig = new Trigger_Settings__c();
        trig.Name = 'salesOrderShareTriger';
        trig.isActive__c = true;
        insert trig;*/
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'District Manager for Turkey'];
        
        User usr1 = new User();
        usr1.Alias = 'zonaa';                                                            
        usr1.Email = 'test@test.com';                             
        usr1.ProfileId  = p.ID;                                                     
        usr1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        usr1.IsActive = true;  
        usr1.LastName='Terriotory Manager';
        usr1.CommunityNickname = 'zonalExe1222 Di'; 
        usr1.TimeZoneSidKey = 'Asia/Kolkata'; 
        usr1.LocaleSidKey = 'en_IN';                                    
        usr1.LanguageLocaleKey = 'en_US';                                             
        usr1.ForecastEnabled = false;                                                     
        usr1.EmailEncodingKey = 'ISO-8859-1';    
        usr1.Show_Inventory__c = false;                                                     
        usr1.Show_Credit_Limit__c = false; 
        insert usr1;
        
        User usr2 = new User();
        usr2.Alias = 'Testaa';                                                            
        usr2.Email = 'test01@test.com';                             
        usr2.ProfileId  = p.ID;                                                     
        usr2.Username = 'test_aaexe1232@upl122333.com.devbox';                                    
        usr2.IsActive = true;  
        usr2.LastName='Terriotory Manager';
        usr2.CommunityNickname = 'testExe1222 Di'; 
        usr2.TimeZoneSidKey = 'Asia/Kolkata'; 
        usr2.LocaleSidKey = 'en_IN';                                    
        usr2.LanguageLocaleKey = 'en_US';                                             
        usr2.ForecastEnabled = false;                                                     
        usr2.EmailEncodingKey = 'ISO-8859-1';    
        usr2.Show_Inventory__c = false;                                                     
        usr2.Show_Credit_Limit__c = false; 
        insert usr2;
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Turkey';
        sorg.Description__c='Turkey';
        sorg.Sales_Org_Code__c='7110';
        insert sorg;

        Order_Type__c  orderTypeObj = new Order_Type__c(
            Name = 'ZTO0',                  // Order Type Name
            Description__c = 'Free Samples',     // Description
            Order_Type_Code__c = 'ZTO0',      // Order Type Code
            SalesOrg__c = sorg.Id  // Sales Org
        );
        insert orderTypeObj;
        
        Depot__c dp =new Depot__c ();
        dp.Name='Turkey';
        dp.Country__c='Turkey';
        dp.Location__c='Turkey';
        dp.Depot_Code__c='TR00';
        insert dp;
       
        Distribution_Channel__c disbj = new Distribution_Channel__c();
        disbj.Name = 'Depot';                      
        disbj.Distribution_Channel_Code__c = '20';  
        disbj.Description__c='test';
        insert disbj;
        
        Division__c Divbj = new Division__c();
        Divbj.Name = 'Agro Formulation';         
        Divbj.Description__c = null;    
        Divbj.Division_Code__c = '10'; 
        insert Divbj;
        
        SKU__c sku = new SKU__c();
        sku.Name= '300 ML';
        sku.SKU_Code__c='000000000005300189';
        sku.SKU_Pack__c= 0.00;
        sku.SKU_UOM__c='L';
        sku.Distribution_Channel__c = disbj.Id;
        sku.Division__c = Divbj.Id;
        sku.Pack_Size__c=0.00;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='L';
        sku.Material_type__c = 'HAWA';
        sku.Brand_Name__c = 'ADITYA'; 
        sku.Active__c=True;
        sku.Combination_Key__c='7110201000000000005300189';
        sku.Multiple_of__c = 5.00;
        insert sku;
        
        Sales_District__c salesD = new Sales_District__c();
        salesD.name='Test';
        salesD.Sales_District_Code__c='080880';
        salesD.SalesOrg__c=sorg.Id;
        salesD.User__c=usr1.id;
        insert salesD;
       

        Account acc = new Account();
        acc.Name='Test one';
        acc.Last_Name__c='one';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP000004';
        acc.Order_Block__c = false;  
        acc.Account_Type__c = 'Sold To Party';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='9867213275';
        acc.Phone='98745632';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity= '35210 Alsancak / IZMIR';
        acc.Order_Type__c=orderTypeObj.Id;
        acc.Sales_District__c=salesD.Id;
        insert acc;
        
        
        Shipping_Location__c shippLoc =new Shipping_Location__c();
        shippLoc.Location_Name__c ='IZMIR GÜMRÜK MÜDÜRLÜGÜ'; 
        shippLoc.Region__c='S.No:46/1, A1 Building, First Floor, Office No.101 E-Space, Wadgoan Sheri,Nagar Rd, Aga Nagar,';
        shippLoc.Distributor__c=acc.Id;
        shippLoc.City__c='IZMIR, TURKEY';
        shippLoc.Sales_Org__c=sorg.Id;
        shippLoc.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc.SAP_Code__c='SAP0dd001';
        shippLoc.State__c='turkey';
        insert shippLoc;

       Sales_Order__c soObj = new Sales_Order__c(
            //   RecordType = '0120k0000000ZbF',                // Record Type
            SFDC_Order_Number__c = '01000',                  // SFDC Order Number
            Order_Raise_By__c = 'District Manager',          // Order Raised By
            Order_Status__c = 'Rejected',  
            Remarks__c = 'DomesticSalesSK',// Order Status
            Order_Date__c = system.today(),
            Division_lk__c = Divbj.Id,                       // Division
            Distribution_Channel_lk__c = disbj.Id,           // Distribution Channel
            Order_Type_lk__c = orderTypeObj.Id,               // Order Type
            Sold_to_Party__c = acc.Id,                       // Sold to Party
            Bill_To_Party__c = acc.Id,                        // Bill To Party
            Ship_To_Party__c = shippLoc.Id ,                  // Ship To Party
            CreatedFrom__c = 'SFDC', 
            Sales_Org_lk__c = sorg.Id // Created From
        );
        insert soObj;
        
        Sales_Order_Line_Item__c soLineItem = new Sales_Order_Line_Item__c(
            Sale_Order__c = soObj.Id,     // Sale Order
            SKU_Name__c = sku.Id,       // SKU Name
            Item_Status__c = 'Active',             // Item Status
            Item_Number__c = 10,                   // Item Number
            DepotDepot__c =  dp.Id,      // Depot
            Campaign_Discount__c = 2.00,           // Campaign Discount
            UOM__c = 'L',                         // UOM
            Net_Price__c = 47040.00,               // Net Price
            MinPrice__c = 295.00,                  // Min Price
            Quantity__c = 1.00,                    // Quantity
            Material_Discount__c = 4.00,           // Material Discount
            FinalPrice__c = 50000.00,              // FinalPrice
            Distributor_Discount__c = 0.00,        // Distributor Discount
            Comment__c = 'test01',                   // Comment
            Price__c = 47040.00                   // Value
        );
        insert soLineItem;
        
    }
    
@isTest 
    static void batchTestSO(){ 
        list<id> salesDistrictIdList = new list<id>();
        list<Sales_District__c> sdNList = new list<Sales_District__c>();
        list<Sales_District__c> sdList = [select id,User__c,User__r.Alias from Sales_District__c limit 1];

        user usr = [SELECT Id,Alias FROM user where Alias = 'Testaa' limit 1];
        
        Test.startTest();
         for(Sales_District__c sdl:sdList){
         sdL.User__c = usr.id;
         sdNList.add(sdl);
         salesDistrictIdList.add(sdl.id);
        }
        update sdNList;
         //sdList[0].User__c = usr.id;
         //update sdList;
         salesDistrictUpdateTurkeySO_Batch batchObj = new salesDistrictUpdateTurkeySO_Batch(salesDistrictIdList);
         database.executebatch(batchObj);
        Test.stopTest();
        
    }     
}