@isTest
private class BrazilSalesOrderTaxAndFreightUpdate_Test {
    
@testSetup
    static void allTestData() {
 Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Trigger_Settings__c trig = new Trigger_Settings__c();
        trig.Name = 'salesOrderShareTriger';
        trig.isActive__c = true;
        insert trig;
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'RC (Commercial Representative) NUCO Colombia'];
        
        User usr2 = new User();
        usr2.Alias = 'Testaa';                                                            
        usr2.Email = 'test01@test.com';                             
        usr2.ProfileId  = p.ID;                                                     
        usr2.Username = 'test_aaexe1232@upl122333.com.devbox';                                    
        usr2.IsActive = true;  
        usr2.LastName='Terriotory Manager';
        usr2.CommunityNickname = 'testExe1222 Di'; 
        usr2.TimeZoneSidKey = 'Asia/Kolkata'; 
        // usr2.Contact.AccountID = acc.id;// Time Zone
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
        sorg.Name='Brazil';
        sorg.Description__c='Brazil';
        sorg.Sales_Org_Code__c='5191';
        insert sorg;
        
        RecordType Supplier_RecTypeId = [SELECT Id FROM RecordType WHERE name = 'Storage Location' and isActive = true LIMIT 1];
        
        Depot__c dp =new Depot__c ();
        dp.Name='br15';
        dp.recordtypeId=Supplier_RecTypeId.id;
        dp.Country__c='Brazil';
        dp.Location__c='NORTE';
        dp.Depot_Code__c='Br15';
        dp.SalesOrg__c = sorg.ID;
        insert dp;
        
        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        insert Pro;
      
        Distribution_Channel__c disbj = new Distribution_Channel__c();
        disbj.Name = '20';                      
        disbj.Distribution_Channel_Code__c = '20';  
        disbj.Description__c='test';
        insert disbj;
        
        Division__c Divbj2 = new Division__c();
        Divbj2.Name = '11';         
        Divbj2.Description__c = null;    
        Divbj2.Division_Code__c = '11'; 
        insert Divbj2;
        
        Division__c Divbj = new Division__c();
        Divbj.Name = '10';         
        Divbj.Description__c = null;    
        Divbj.Division_Code__c = '10'; 
        insert Divbj;
        
        
        SKU__c sku = new SKU__c();
        sku.Name='DOST';
        sku.SKU_Code__c='704002';
        sku.SKU_Pack__c=1.00;
        sku.SKU_UOM__c='L';
        sku.Multiple_Of__c=5;
        sku.Group__c='DOST';
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='L';
        sku.Active__c=True;
        sku.Combination_Key__c='Cooooooo000011111';        
        insert sku;
   
        
        PriceBookMaster__c PbMaster = new PriceBookMaster__c();
        PbMaster.SKUCode__c = sku.id;           
        PbMaster.DepotCode__c =dp.id;         
        PbMaster.Price__c = 34500;                    
        PbMaster.PG_CODE__c =Pg.Id;  
        PbMaster.UOM__c = 'NOS';                          
        PbMaster.StartDate__c = system.today();
        PbMaster.EndDate__c = system.today()+1;
        PbMaster.Active__c = true;                      
        PbMaster.PerUnit__c = 1;                       
        PbMaster.Batch__c ='test'; 
        PbMaster.CurrencyIsoCode='USD'; 
        PbMaster.Division__c= Divbj.ID;
        PbMaster.CompositeKey__c='c1';
        
      //  PbMaster.DistributorCustomerCode__c='';
        insert PbMaster; 
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZORU';              
        ordType.Description__c = 'Costa Rica';    
        ordType.Order_Type_Code__c = 'ZORU';
        insert ordType;
        
        Business_Rule__c br = new Business_Rule__c();
        br.Name = 'BA';
        br.Taxes__c = 3.38;
        br.Freight__c = 0.62;
        br.Total_Order_Margin__c = -100000;
        br.List_Price_Discount__c = 3;
        
        insert br;
        
        Account acc = new Account();
        acc.Name='Test';
        acc.Last_Name__c='last Test';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP123456';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='8600000000';
        acc.Phone='020250000';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='';
        acc.Customer_Region__c = 'BA';
        acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        //  acc.OwnerId=sobj.Id;
        insert acc;
       
        Shipping_Location__c shippLoc2 =new Shipping_Location__c();
        shippLoc2.Location_Name__c ='Mumbai'; 
        shippLoc2.Region__c='S.No:46/1, A1 Building, First Floor, Office No.101 E-Space, Wadgoan Sheri,Nagar Rd, Aga Nagar,';
        shippLoc2.Distributor__c=acc.Id;
        shippLoc2.City__c='Pune';
        shippLoc2.Sales_org__c=sorg.Id;
        //shippLoc2.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc2.SAP_Code__c = acc.SAP_Code__c;
        shippLoc2.State__c='13';        
        insert shippLoc2;
        
    }
    
 @isTest 
    static void insertTriggerTest(){ 
        account act = [select id, name from account limit 1];
        Shipping_Location__c shippLoc =[select id from Shipping_Location__c limit 1];
        Order_Type__c ordTyp = [select id from Order_Type__c limit 1];
        Sales_Org__c salesOrg = [select id from Sales_Org__c limit 1];
        Distribution_Channel__c  disObj = [select id from Distribution_Channel__c limit 1];
        Division__c divObj = [select id from Division__c limit 1];
        SKU__c skObj = [select id from SKU__c limit 1];
        PriceBookMaster__c PbMast = [select id from PriceBookMaster__c limit 1];
        Depot__c depo = [select id from Depot__c limit 1];
        
        
        Test.startTest();
        
        Sales_Order__c soObj=new Sales_Order__c();
        soObj.Sold_to_Party__c = act.Id;
        soObj.Bill_To_Party__c = act.Id;
        soObj.Ship_To_Party__c = shippLoc.Id;
        soObj.Order_Date__c = System.today();
        soObj.Order_Type_lk__c = ordTyp.Id;
        soObj.Order_Raise_By__c = 'Distributor';
        soObj.Order_Status__c = 'Rejected';
        soObj.CreatedFrom__c = 'SFDC';
        soObj.Sales_Org_lk__c = salesOrg.ID;
        soObj.Distribution_Channel_lk__c = disObj.Id;
        soObj.Division_lk__c = divObj.Id;
        soObj.Price_Entry_Flag__c = false;
        insert soObj;


        Test.stopTest();
        
    } 
}