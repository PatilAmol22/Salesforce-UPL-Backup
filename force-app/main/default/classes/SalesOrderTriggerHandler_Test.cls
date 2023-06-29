@isTest
private class SalesOrderTriggerHandler_Test {
    
    @testVisible static List<Inventory_Parameter1__mdt> ip1 { 
        get {
            if ( ip1 == null )
                ip1 = [ SELECT Sales_Org_BU__c from Inventory_Parameter1__mdt ]; 
            return ip1;
        } set; }
    
    private static testmethod void OrderCancellationTest(){
        Test.startTest();
        Product2 prod = new Product2();
        prod.ProductCode = '56700';
        prod.Product_Code__c='56700';
        prod.Name='Siri';
        prod.popular__c = true;
        prod.Combination_Key__c='RM0055100';
        //prod.id = ;
        insert prod;
        
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Costa Ricas';
        sorg.Description__c='Costa Ricas';
        sorg.Sales_Org_Code__c='5191';
        insert sorg;
        
        Sales_Order__c so = new Sales_Order__c();
        so.Order_Status__c = 'Open';
        so.Type_of_Order__c = 'VENDA NORMAL';
        
        
        insert so;
        
        SKU__c skObj = [select id,Brand_Name__c,SKU_Code__c from SKU__c];
        SKU__c sku1 = new SKU__c();
        sku1.SKU_Code__c = '6633220';
        sku1.Brand_Name__c = 'SPERTO';
        sku1.Sales_Org__c = sorg.id;
        insert sku1;
        
        Zone__c z1 = new Zone__c();
        z1.ZoneCode__c = 'BR15';
        insert z1;
        
        Territory_Distributor__c u1 = new Territory_Distributor__c();
        u1.Name = 'BR73506402';
        u1.Zone__c = z1.Id;
        //Zone_r.ZoneCode__c = 'BR15';
        u1.SalesOrg__c = sorg.id;
        //u1.TerritoryManagerActive__c = True;
        u1.TerritoryManager__c= UserInfo.getUserId();
        u1.BarterManager__c= UserInfo.getUserId();
        insert u1;
        
        Inventory_Parameter1__mdt ip1 = [SELECT id,Sales_Org_BU__c from Inventory_Parameter1__mdt ];
        
        set<Id> soId = new set<Id>();
        
        soId.add(so.Id);
        Set<string> setBrandName = new Set<string>();
        List<Sales_Order_Line_Item__c> soliobj = [select id,Quantity__c,Sale_Order__c,SKU_Name__c,Quantity_Billed__c,DateofFAT__c,Unbilled_Quatity__c,SKU_Name__r.Brand_Name__c from Sales_Order_Line_Item__c];
        Sales_Order_Line_Item__c soli = new Sales_Order_Line_Item__c();
        soli.Sale_Order__c = so.Id;
        soli.Quantity__c = 1000;
        soli.SKU_Name__c = skObj.Id;
        soli.DateofFAT__c = system.today();
        
        
        //soli.Brazil_Product__c = prod.Name;
        soli.SKU_Name__c = sku1.id;
        //soli.Brand_Name__c = sku1.id;
        soli.Unbilled_Quatity__c = 500;
        soli.Quantity_Billed__c = 500;
        //soli.Sale_Order__r.Order_Status__c = 'Cancelled';
        
        insert soli;
        
        so.Sales_Org_lk__c = sorg.Id;
        so.Order_Status__c = 'Cancelled';
        update so;
        
        List<Inventory_Control__c> f = [select Id,Product_Name__c,BU__c,Quantity__c,Fiscal_Year__c from Inventory_Control__c];
        Inventory_Control__c f1 = new Inventory_Control__c();
        f1.BU__c = u1.Zone__c;
        f1.Product_Name__c = prod.id;
        f1.Product__c='SPERTO';
        f1.BU__c ='BR15';
        f1.Quantity__c = 1000;
        f1.Fiscal_Year__c = '22/23';
        //f1.CombinationKey1__c = '1234T';
        insert f1;
        

        
        Test.stopTest();
        
    } 
    @testSetup
    static void allTestData() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Trigger_Settings__c newtri = new Trigger_Settings__c();
        newtri.Name = 'SOLICombKeyTrigger';
        newtri.isActive__c = true;
        insert newtri;
        
        Trigger_Settings__c trig = new Trigger_Settings__c();
        trig.Name = 'salesOrderShareTriger';
        trig.isActive__c = true;
        insert trig;
        
        Trigger_Settings__c newSetting = new Trigger_Settings__c();
        newSetting.Name = 'atmTrigger';
        newSetting.isActive__c = true;
        insert newSetting;
        
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
        sorg.Name='Costa Rica';
        sorg.Description__c='Costa Rica';
        sorg.Sales_Org_Code__c='5710';
        insert sorg;
        //Added by Nandhini
        Sales_Org__c sorgMexico =new Sales_Org__c();
        sorgMexico.Name='Mexico';
        sorgMexico.Description__c='Mexico';
        sorgMexico.Sales_Org_Code__c='5100';
        insert sorgMexico;
        Sales_Org__c sorgBR =new Sales_Org__c();
        sorgBR.Name='Brazil';
        sorgBR.Description__c='Brazil';
        sorgBR.Sales_Org_Code__c='5191';
        insert sorgBR;
        
        Zone__c objZone = new Zone__c();
        objZone.Name = 'Test';
        objZone.SalesOrg__c = sorgBR.Id;
        objZone.ZoneCode__c = '5191';
        insert objZone;
        
        RecordType Supplier_RecTypeId = [SELECT Id FROM RecordType WHERE name = 'Storage Location' and isActive = true LIMIT 1];
        
        Depot__c dp =new Depot__c ();
        dp.Name='CO51';
        dp.recordtypeId=Supplier_RecTypeId.id;
        dp.Country__c='Costa Rica';
        dp.Location__c='NORTE';
        dp.Depot_Code__c='CO51';
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
        sku.Brand_Name__c='TestBrand';        
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
        
        Account acc = new Account();
        acc.Name='Nikhil';
        acc.Last_Name__c='Dhoke';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='8600000000';
        acc.Phone='020250000';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Mumbai';
        acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        //  acc.OwnerId=sobj.Id;
        insert acc;
        
        AccountTeamMember atm = new AccountTeamMember();
        atm.AccountId = acc.id;
        atm.UserId= usr2.id;
        atm.TeamMemberRole='Territory Manager';
        atm.AccountAccessLevel = 'Read';
        atm.CaseAccessLevel= 'None';
        atm.ContactAccessLevel='None';
        atm.OpportunityAccessLevel='None';
        insert atm;
        
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
        Sales_Org__c salesOrg = [select id from Sales_Org__c where Sales_Org_Code__c = '5710' limit 1];
        Sales_Org__c sorgBRL = [select id from Sales_Org__c where Sales_Org_Code__c = '5191' limit 1];
        Distribution_Channel__c  disObj = [select id from Distribution_Channel__c limit 1];
        Division__c divObj = [select id from Division__c limit 1];
        SKU__c skObj = [select id from SKU__c limit 1];
        PriceBookMaster__c PbMast = [select id from PriceBookMaster__c limit 1];
        Depot__c depo = [select id from Depot__c limit 1];
        Zone__c oZone = [select id from Zone__c limit 1];
        
        
        Test.startTest();
        
        Territory_Distributor__c ObjTD = new Territory_Distributor__c();
        ObjTD.Name = 'Test';
        ObjTD.Zone__c = oZone.Id;
        ObjTD.SalesOrg__c = sorgBRL.Id;
        ObjTD.TerritoryManager__c = UserInfo.getUserId();
        insert ObjTD;
        
        Inventory_Control__c ObjInv = new Inventory_Control__c();
        ObjInv.Quantity__c = 12345678;
        ObjInv.Product__c = 'TestBrand';
        ObjInv.Fiscal_Year__c = '22/23';
        ObjInv.BU__c = '5191';
       // ObjInv.CombinationKey1__c = '123T';
        insert ObjInv;
        
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
        soObj.SDM_Approval_On_Order_Item_Edit_Cancel__c = true; //Added by Mohit Garg(Grazitti)-(02-02-2023)
        insert soObj;
        
        Sales_Order_Line_Item__c  solIObj= new Sales_Order_Line_Item__c();
        solIObj.Sale_Order__c= soObj.id;
        solIObj.SKU_Name__c = skObj.Id;
        solIObj.PriceBookMaster__c = PbMast.Id;
        solIObj.Item_Status__c = 'Active';
        solIObj.No_of_Case__c = 1;
        solIObj.Item_Number__c = 10;  
        solIObj.Invoice_Discount__c = 0.00;    
        solIObj.Manager_Price__c=10;
        solIObj.Director_Price__c=10; 
        solIObj.multipleOf__c=5;
        solIObj.MinPrice__c=25;
        solIObj.MaxPrice__c=24;
        solIObj.FinalPrice__c=28;
        solIObj.Quantity__c = 100;          
        solIObj.Special_Discount__c = 0.00;     
        solIObj.Price__c = 23000;         
        solIObj.DepotDepot__c = depo.Id; 
        solIObj.UOM__c = 'KG';
        solIObj.DateofFAT__c = System.today().addDays(1);
        insert solIObj;
        
        Test.stopTest();
        
    } 
    @isTest
    public static void errorMessageFix(){
        Account acc = [select id, name from account limit 1];
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='India';
        sorg.Description__c='India';
        sorg.Sales_Org_Code__c='1410';
        Insert sorg;
        Sales_Order__c so = new Sales_Order__c();
        so.Sold_to_Party__c = acc.Id;
        so.Bill_To_Party__c = acc.Id;
        so.Order_Date__c = system.today();
        so.CreatedFrom__c = 'SFDC';
        so.OwnerId = UserInfo.getUserId();
        so.Sales_Org_lk__c = sorg.Id;
        so.SalesOrg__c = sorg.Id;
        so.Order_Status__c = 'Draft';
        so.GP_Lista__c=30000.000;
        
        Insert so;
        //so.SDM_Rejected_OrderItem_Edit_Approval__c=true;
        Transaction_Log__c ts=new Transaction_Log__c();
        ts.Sales_Order__c=so.Id;
        ts.Status__c='ERROR';
        ts.Message__c='Credit check SAP test';
        
        Insert ts;
        Test.startTest();
        so.Order_Status__c = 'Error from SAP';
        so.ErrorMessage__c= System.Label.India_Error_Message;
        update so;
        Test.stopTest();
    }
    
    @isTest 
    static void onBeforeUpdateTestCoverage(){ 
        Account act = [select id, name from account limit 1];
        Shipping_Location__c shippLoc =[select id from Shipping_Location__c limit 1];
        Order_Type__c ordTyp = [select id from Order_Type__c limit 1];
        Sales_Org__c salesOrg = [select id from Sales_Org__c where Sales_Org_Code__c = '5100' limit 1];
        Sales_Org__c sorgBRL = [select id from Sales_Org__c where Sales_Org_Code__c = '5191' limit 1];
        Distribution_Channel__c  disObj = [select id from Distribution_Channel__c limit 1];
        Division__c divObj = [select id from Division__c limit 1];
        SKU__c skObj = [select id from SKU__c limit 1];
        PriceBookMaster__c PbMast = [select id from PriceBookMaster__c limit 1];
        Depot__c depo = [select id from Depot__c limit 1];
        Zone__c oZone = [select id from Zone__c limit 1];
        
        
        Test.startTest();
        
        Territory_Distributor__c ObjTD = new Territory_Distributor__c();
        ObjTD.Name = 'Test';
        ObjTD.Zone__c = oZone.Id;
        ObjTD.SalesOrg__c = sorgBRL.Id;
        ObjTD.TerritoryManager__c = UserInfo.getUserId();
        insert ObjTD;
        
        Inventory_Control__c ObjInv = new Inventory_Control__c();
        ObjInv.Quantity__c = 12345678;
        ObjInv.Product__c = 'TestBrand';
        ObjInv.Fiscal_Year__c = '22/23';
        ObjInv.BU__c = '5191';
       // ObjInv.CombinationKey1__c = '12345T';
        insert ObjInv;
        
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
        
        Sales_Order_Line_Item__c  solIObj= new Sales_Order_Line_Item__c();
        solIObj.Sale_Order__c= soObj.id;
        solIObj.SKU_Name__c = skObj.Id;
        solIObj.PriceBookMaster__c = PbMast.Id;
        solIObj.Item_Status__c = 'Active';
        solIObj.No_of_Case__c = 1;
        solIObj.Item_Number__c = 10;  
        solIObj.Invoice_Discount__c = 0.00;    
        solIObj.Manager_Price__c=10;
        solIObj.Director_Price__c=10; 
        solIObj.multipleOf__c=5;
        solIObj.MinPrice__c=25;
        solIObj.MaxPrice__c=24;
        solIObj.FinalPrice__c=28;
        solIObj.Quantity__c = 100;          
        solIObj.Special_Discount__c = 0.00;     
        solIObj.Price__c = 23000;         
        solIObj.DepotDepot__c = depo.Id; 
        solIObj.UOM__c = 'KG';
        solIObj.DateofFAT__c = System.today().addDays(1);
        insert solIObj;
        soObj.Approval_Status__c='Pending@Director';
        update soObj;
        Test.stopTest();  
    }     
    // Added by Nikhil
    @isTest
    public static void NAMOrderTest(){
        Test.startTest();
        Id recordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Distributor').RecordTypeId;
        Sales_Org__c sorg = Grz_TestDataFactory.createSalesOrg(true, 'USA', '3100');
        
        Distribution_Channel__c  disObj = new Distribution_Channel__c();
        disObj.Name = 'USA';                      
        disObj.Distribution_Channel_Code__c = '200';  
        disObj.Description__c='testusa';
        insert disObj;
        Division__c divObj = new Division__c();
        divObj.Name = 'USA';         
        divObj.Description__c = null;    
        divObj.Division_Code__c = '100'; 
        insert divObj;
        Account acc = Grz_TestDataFactory.createAccount(false, 'Test Account',recordTypeId);
        acc.Sales_Org__c = sorg.Id;
        insert acc;
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager' LIMIT 1];
        
        User usr1 = new User(
            firstname = 'Test',
            lastName = 'NAM', 
            Alias = 'tnam',                                                                   
            Email = 'test@gmail.com',                                       
            ProfileId = profileId.Id,                                                             
            Username = 'test@upl-ltd.com.upltest',                                         
            IsActive = true,                                                                   
            CommunityNickname = 'test.nam',
            TimeZoneSidKey = 'Asia/Kolkata',               
            LocaleSidKey = 'en_US',                                                  
            LanguageLocaleKey = 'en_US',                                                     
            ForecastEnabled = false,                                                           
            Phone = '7722034447',                                                    
            EmailEncodingKey = 'ISO-8859-1',
            Zone__c = 'Pune'                                                           
        );
        insert usr1;
        DistributorSalesAreaMapping__c dsm = new DistributorSalesAreaMapping__c();
        dsm.Distributor__c = acc.Id;
        dsm.Division__c = divObj.Id;
        dsm.DistributionChannel__c = disObj.Id;
        dsm.SalesOrg__c = sorg.Id;
        dsm.AccountOwner__c = usr1.Id;
        insert dsm;
        Sales_Order__c salesObj1 = Grz_TestDataFactory.createSalesOrderRecord(false, '132312311','Approved',Date.today(), acc.Id);
        salesObj1.Sales_Org_lk__c = sorg.Id;
        salesObj1.Invoice_Status__c = 'test';
        salesObj1.Valid_From__c = system.today();
        salesObj1.Distribution_Channel_lk__c = disObj.Id;
        salesObj1.Division_lk__c = divObj.Id;
        salesObj1.Sold_to_Party__c = acc.Id;
        insert salesObj1; 
        Test.stopTest();
    }
}