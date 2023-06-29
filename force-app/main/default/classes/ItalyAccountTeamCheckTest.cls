@isTest
public class ItalyAccountTeamCheckTest {
    @testSetup
    static void allDataForThisTestClass(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Italy';
        sorg.Description__c='Italy';
        sorg.Sales_Org_Code__c='2410';
        insert sorg;
        
        
        PrIce_List_Type_Master__c pltmaster= new PrIce_List_Type_Master__c();
        pltmaster.Price_List_Type__c='03';
        insert pltmaster;
        
        //Auto_Number__c auto = new Auto_Number__c();
        //auto.Name='FarmerCode';
        //auto.Sequence__c='11';
        //insert auto;
        
        
        
        Depot__c dp =new Depot__c ();
        dp.Name='Pune';
        dp.Country__c='India';
        dp.Location__c='Pune';
        dp.Depot_Code__c='PUN1';
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
        sku.Group__c='DOST';
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='L';
        sku.Active__c=True;
        sku.GST__c=18;
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
        PbMaster.CompositeKey__c='c1';
        PbMaster.PrIce_List_Type__c=pltmaster.Id;
        insert PbMaster; 
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZORD';              
        ordType.Description__c = 'India';    
        ordType.Order_Type_Code__c = 'ZORD';
        insert ordType;
        
        Region__c reg = new Region__c();
        reg.RegionHead__c = UserInfo.getUserId();
        insert reg;
        
        Account acc = new Account();
        acc.Name='Bhavik Devdhar';
        acc.Last_Name__c='Devdhar';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='9967341759';
        acc.Phone='020256589';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Pune';
        acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        acc.Region__c = reg.Id;
        insert acc;
        
        DistributorSalesAreaMapping__c dsmObj = new DistributorSalesAreaMapping__c();
        dsmObj.Distributor__c = acc.Id;
        dsmObj.SalesOrg__c = sorg.Id;
        dsmObj.DistributionChannel__c = disbj.Id; 
        dsmObj.PriceGroupMaster__c =pg.id;
        dsmObj.Division__c = Divbj.Id;
        dsmObj.AccountOwner__c = UserInfo.getUserId();
        dsmObj.PrIceListTypeMaster__c=pltmaster.Id;
        insert dsmObj;
        
        contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName=acc.Last_Name__c;
        insert con;
        
        userrole  usrole = new userrole();
        usrole.Name ='Bhavik Devdhar Customer User';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'PartnerCommunity Distributor Profile'];
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'himanshua.mehta@skinternational.com';                             
        sobj1.ProfileId  = p.ID;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='Terriotory Manager';
        sobj1.CommunityNickname = 'zonalExe1222 Di'; 
        sobj1.TimeZoneSidKey = 'Asia/Kolkata'; 
        // sobj1.Contact.AccountID = acc.id;// Time Zone
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId=usrole.id;
        sobj1.ContactId=con.Id;
        insert sobj1;
        
        TM_Depot_Mapping__c TMDepoMap = new TM_Depot_Mapping__c();
        TMDepoMap.Depot__c = dp.Id;        // Depot
        TMDepoMap.Territory_Manager__c = sobj1.id;  // Territory Manager
        insert TMDepoMap;
        
        SpecialInvoiceDiscount__c spelDis = new SpecialInvoiceDiscount__c();
        spelDis.Active__c = false;                                             
        spelDis.Batch__c = 'test';                                                 
        spelDis.DepotCode__c =dp.Id;                                             
        spelDis.Price__c = 191;                                                
        spelDis.DistributorCustomerCode__c = acc.Id;                   
        spelDis.EndDate__c =System.today()+1;                          
        spelDis.PerUnit__c = 1.0;                                                   
        spelDis.PG_Code__c =Pg.Id;                                             
        spelDis.SKUCode__c = sku.Id;                          
        spelDis.StartDate__c = system.today();                         
        spelDis.UOM__c = 'KG';                                                   
        spelDis.CompositeKey__c = '000100122814-06-2016000000000000710002'; 
        spelDis.PrIce_List_Type__c=pltmaster.Id;        
        insert spelDis;
        
        Inventory__c invObj = new Inventory__c( );
        invObj.Stock_Quantity__c = 10;   
        invObj.Batch_Number__c = 'CMUMTX2506'; 
        invObj.Depot__c = dp.Id;    
        invObj.UOM__c = 'L';                    
        invObj.Storage_Location__c = 'MAIN';  
        invObj.SKU__c = sku.Id;  
        invObj.SKU_Depot__c ='sd1';           
        insert invObj;
        
        PricebookDiscount__c PbDis = new PricebookDiscount__c();
        PbDis.Batch__c = 'test';                                               
        PbDis.DepotCode__c = dp.Id;                                  
        PbDis.DistributorCustomerCode__c = acc.Id;                              
        PbDis.EndDate__c = System.today()+1;                         
        PbDis.PerUnit__c = 1.00;                                                 
        PbDis.PG_Code__c = Pg.Id;                                   
        PbDis.SKUCode__c = sku.Id;                             
        PbDis.StartDate__c = system.today();                         
        PbDis.Active__c = false;                                               
        PbDis.Price__c = 200.00;                                                 
        PbDis.UOM__c = 'KG';                                                   
        PbDis.CompositeKey__c = '01-04-2016BHA103000000000000692001';           
        PbDis.PrIce_List_Type__c=pltmaster.Id;
        PbDis.Sales_Org__c = sorg.Id;
        insert PbDis;
        
        Distributor_Depot_Mapping__c dsMap =new Distributor_Depot_Mapping__c();
        dsMap.Distributor__c = acc.id;
        dsMap.Depot__c=dp.Id;
        insert dsMap;
        
        SKU_Pack_Size__c spObj = new SKU_Pack_Size__c();
        spObj.Depot__c = dp.Id;
        spObj.UOM__c = 'L';
        spObj.SKU__c = sku.Id;
        spObj.Pack_Size__c = '5';
        insert spObj;
        
        Credit_Info__c crdIf = new Credit_Info__c();
        crdIf.Credit_Limit__c=1000;
        crdIf.Percentage_Used__c=100.0;
        crdIf.Allocated_Limit__c=0.0;
        crdIf.Distributor__c=acc.Id;
        crdIf.Distributor_Code__c='0001001225';
        crdIf.Sales_Org__c=sorg.Id;
        insert crdIf;
        
        OrderTemplate__c ordTemp =new OrderTemplate__c();
        ordTemp.DistributorCustomerCode__c=acc.Id;
        ordTemp.Name='DOST 500.00 ML';
        insert ordTemp;
        
        OrderTemplateItem__c ordTempItem = new OrderTemplateItem__c();
        ordTempItem.Name = 'DOST';
        ordTempItem.OrderTemplate__c=ordTemp.Id;
        ordTempItem.SKU__c = sku.Id;
        insert ordTempItem;
        
        State_Tax_Structure__c statetax = new State_Tax_Structure__c();
        statetax.State_Name__c = 'Maharashtra';
        statetax.Country__c = 'India';          
        statetax.Tax__c = 10;           
        statetax.State_Code__c = '13';
        statetax.AdditionalTax__c = 30;
        statetax.SalesOrg__c = sorg.Id;
        insert statetax;
        
        List<Account> accList = new List<Account>();
        for(Integer i=0;i<20;i++){
            Account acc1 = new Account();
            acc1.Name='Sayan Majumder'+i;
            acc1.Last_Name__c='Majumder'+i;
            acc1.SAP_Code__c='SAP996005'+i;
            acc1.RecordTypeId=devRecordTypeId;
            acc1.Mobile__c='9967341750'+i;
            acc1.Phone='020256581'+i;
            acc1.Sales_Org__c=sorg.Id;
            acc1.Division__c=Divbj.Id;
            acc1.Distribution_Channel__c=disbj.Id;
            acc1.BillingCity='Pune';
            acc1.Depot_Code__c = 'PUN1';
            acc1.Region__c = reg.id;
            accList.add(acc1);
        }
        insert accList;
        
        
        List<Territory_Distributor__c> terr = new List<Territory_Distributor__c>();
        for(Integer i=0;i<20;i++){
            Territory_Distributor__c t = new Territory_Distributor__c();
            t.SalesOrg__c = sOrg.Id;
            t.TerritoryManager__c = sobj1.Id;
            terr.add(t);
        }
        insert terr;
        
        
        
        List<Shipping_Location__c> ShippingList = new List<Shipping_Location__c>();
        for(Integer i=0;i<20;i++){
            Shipping_Location__c shippLoc1 =new Shipping_Location__c();
            shippLoc1.Location_Name__c ='Test Location'+i; 
            shippLoc1.Distributor__c=accList[i].Id;
            shippLoc1.City__c='Kolkata';
            shippLoc1.SAP_Code__c='SAP0001';
            shippLoc1.Sales_Org__c=sorg.Id;
            shippLoc1.OwnerId = sobj1.Id;
            shippLoc1.Territory_Distributor__c = terr[i].Id;
            ShippingList.add(shippLoc1);
        }
        insert ShippingList;
        
        
    }
    static testMethod void method(){
        ItalyAccountTeamCheck b = new ItalyAccountTeamCheck();
        database.executebatch(b,150);
        ItalyAccountTeamCheck  sch = new ItalyAccountTeamCheck();
        String sch1 = '0 59 17 2 * ? 2021';
        system.schedule('ItalyAccountTeamCheck', sch1, sch);
    }
}