@isTest
public class SearchPageControllerTest {
    static testMethod void Method() {
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
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
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='1000';
        sorg.Description__c='India';
        sorg.Sales_Org_Code__c='1000';
        insert sorg;
        
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
        PbMaster.CompositeKey__c='c1';
        insert PbMaster; 
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZORD';              
        ordType.Description__c = 'India';    
        ordType.Order_Type_Code__c = 'ZORD';
        insert ordType;
        
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
        //  acc.OwnerId=sobj.Id;
        insert acc;
        
        Shipping_Location__c shippLoc =new Shipping_Location__c();
        shippLoc.Location_Name__c ='Same as Billing Address'; 
        shippLoc.Region__c='S.No:46/1, A1 Building, First Floor, Office No.101 E-Space, Wadgoan Sheri,Nagar Rd, Aga Nagar,';
        shippLoc.Distributor__c=acc.Id;
        shippLoc.City__c='Pune';
        shippLoc.Sold_To_Party_SAP_Code__c=acc.SAP_Code__c;
        shippLoc.SAP_Code__c='SAP0001';
        shippLoc.State__c='13';
        insert shippLoc;
        
        State_Tax_Structure__c statetax = new State_Tax_Structure__c();
        statetax.State_Name__c = 'Maharashtra';
        statetax.Country__c = 'India';          
        statetax.Tax__c = 10;           
        statetax.State_Code__c = '13';
        statetax.AdditionalTax__c = 30;      
        insert statetax;
        
        Order__c ord = new Order__c();
        ord.Shipping_Location__c = shippLoc.id;  
        ord.Bill_To_Party__c = acc.Id;        
        ord.Order_Date__c = system.today();  
        ord.Order_Raise_By__c = 'Distributor';            
        ord.VAT__c = statetax.Tax__c;                            
        ord.Order_Status__c = 'Pending';                    
        ord.Additional_Tax__c =statetax.AdditionalTax__c;                   
        //ord.RegionalManager__c = '005N0000002dGKO',      
        ord.Sales_Org__c =sorg.Id;          
        ord.Distribution_Channel__c =disbj.Id; 
        ord.Division__c = Divbj.Id;
        insert ord;
                PageReference pageRef3 = Page.myproduct;
            Test.setCurrentPage(pageRef3);
            ApexPages.StandardController sc3 = new ApexPages.StandardController(ord);
           // OrderRedirectController ordredirect = new OrderRedirectController(sc3);
        SearchPageController searchObj = new SearchPageController(sc3);
    }
    
}