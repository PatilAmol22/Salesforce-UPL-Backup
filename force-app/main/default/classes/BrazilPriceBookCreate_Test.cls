@isTest
public class BrazilPriceBookCreate_Test {
static testMethod void BrazilPriceBookCreate_Test(){
    insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
          Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
          sorg=[SELECT Id,sales_org_code__c from sales_org__c];
          list<sales_org__c> salesorgId= [SELECT ID  FROM sales_org__c where sales_org_code__c=: sorg.sales_org_code__c];
       
    Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
    //============================================================================== Added by SKI Start Here
    //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook; 
    //============================================================================== Added by SKI End Here
    Division__c  div = new Division__c(
            Name = 'Agro Formulation',
            Division_Code__c = '10'
        );
        insert div;
        
       Price_Book__c priceBookObj = new Price_Book__c(
            Name = 'LISTA ABRIL ZARTAN - REGIONAL TRIANGULO - PRAZO AGOSTO 2017',
            Division__c = div.id,                                           
            Valid_From__c = system.today(),
            Expiry_Date__c = system.today(),
           	isActive__c = True,
            Status__c = 'Approved',
            Base_Price_Book__c = false,
           Interest_Rate_R__c=10,
           Interest_Rate_U__c=10
        );
        insert priceBookObj;
    	Region__c region = new Region__c(
              Name = 'TRIANGULO',                  // Region Name
              RegionCode__c = 'BR4003',              // Region Code
              SalesOrg__c = salesorgId[0].id      // Sales Org
                 
            );
        insert region;  
     	Price_Book_Sales_District__c pbsd=new Price_Book_Sales_District__c();
        pbsd.Price_Book__c=priceBookObj.Id;
        pbsd.Sales_District1__c=region.Id;
        insert pbsd;
    SKU__c skuRecord = new SKU__c(
            Name = 'a1C0k000000A1ug',                                // SKU Name
        	Brand_Name__c='test',
            SKU_Code__c = '000000000006302802',                      // SKU Code
            SKU_Description__c = 'MANZATE 800WP 25KG PAPER BAG_BR',  // SKU Description
            UOM__c = 'KG',
            Division__c = div.Id,                                    // Division
            Sales_Org__c = salesorgId[0].Id,                              // Sales Org
            Multiple_of__c = 25.00,                                  // Multiple Of
            Combination_Key__c = '519110000000000006302802',         // Combination Key
            Active__c = true                                         // Active
        );
        insert skuRecord;
      Price_Book_Details__c PBdetails = new Price_Book_Details__c(
            SKU__c =skuRecord.Id,                    
            Monthly_Interest_Rate__c = 1.00,         
            Price_Book__c = priceBookObj.Id,               
            Exchange_Rate__c = 3.00,                
            Unit_Price_R__c = 120.00,                 
            Minimum_Price__c = 15.00, 
          	Future_Sales_Price_R__c=50,
          	Future_Sales_Price_U__c=45,
            Future_Sales_Price__c=34,
          	Minimum_Price_U__c=34,
            Minimum_Price_R__c=25,
          	Unit_Price__c=20,
            Unit_Price_U__c=56,           
            CurrencyIsoCode='BRL',
            Sales_District1__c = region.Id          
        );
    insert PBdetails;
    
    
    Sales_District_Cost__c SDC= new Sales_District_Cost__c(
    	Region__c=region.id,
        Sales_District_Cost__c=100
    );
    insert SDC; 
    Market_Variation__c MV= new Market_Variation__c(
    SKU_Brand__c='test',
        Sales_District__c=region.id,
        Region_Code__c='BR4003',
        Combination_Key__c='BR4003test5191',
        Market_Variation__c=100
    );    
    insert MV;
    
    Discount_Matrix__c DM= new Discount_Matrix__c(
    Brand_Name__c='test',
    BU_Manager__c=100,
    Sales_Director__c=100,
    Sales_District_Manager__c=100,
    Sales_Person__c=100
    );
    insert DM;
        
    List <Id> pbcList= new List<Id>();
    pbcList.add(priceBookObj.id);
 
    Test.startTest();
    BrazilPriceBookCreate.CreatePriceBook(pbcList);
    Test.stopTest();
}
    static testMethod void BrazilPriceBookCreate_TestKit(){
    insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
          Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
          sorg=[SELECT Id,sales_org_code__c from sales_org__c];
          list<sales_org__c> salesorgId= [SELECT ID  FROM sales_org__c where sales_org_code__c=: sorg.sales_org_code__c];
       
    Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        //============================================================================== Added by SKI Start Here
    //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook; 
    //============================================================================== Added by SKI End Here
    Division__c  div = new Division__c(
            Name = 'Agro Formulation',
            Division_Code__c = '10'
        );
        insert div;
        
       Price_Book__c priceBookObj = new Price_Book__c(
            Name = 'LISTA ABRIL ZARTAN - REGIONAL TRIANGULO - PRAZO AGOSTO 2017',
            Division__c = div.id,                                           
            Valid_From__c = system.today(),
            Expiry_Date__c = system.today(),
           	isActive__c = True,
            Status__c = 'Approved',
            Base_Price_Book__c = false,
           Interest_Rate_R__c=10,
           Interest_Rate_U__c=10,
           Kit_Price_Book__c=true
        );
        insert priceBookObj;
    	Region__c region = new Region__c(
              Name = 'TRIANGULO',                  // Region Name
              RegionCode__c = 'BR4003',              // Region Code
              SalesOrg__c = salesorgId[0].id      // Sales Org
                 
            );
        insert region;  
     	Price_Book_Sales_District__c pbsd=new Price_Book_Sales_District__c();
        pbsd.Price_Book__c=priceBookObj.Id;
        pbsd.Sales_District1__c=region.Id;
        insert pbsd;
    SKU__c skuRecord = new SKU__c(
            Name = 'a1C0k000000A1ug',                                // SKU Name
        	Brand_Name__c='test',
            SKU_Code__c = '000000000006302802',                      // SKU Code
            SKU_Description__c = 'MANZATE 800WP 25KG PAPER BAG_BR',  // SKU Description
            UOM__c = 'KG',
            Division__c = div.Id,                                    // Division
            Sales_Org__c = salesorgId[0].Id,                              // Sales Org
            Multiple_of__c = 25.00,                                  // Multiple Of
            Combination_Key__c = '519110000000000006302802',         // Combination Key
            Active__c = true                                         // Active
        );
        insert skuRecord;
      Price_Book_Details__c PBdetails = new Price_Book_Details__c(
            SKU__c =skuRecord.Id,                    
            Monthly_Interest_Rate__c = 1.00,         
            Price_Book__c = priceBookObj.Id,               
            Exchange_Rate__c = 3.00,                
            Unit_Price_R__c = 120.00,                 
            Minimum_Price__c = 15.00, 
          	Future_Sales_Price_R__c=50,
          	Future_Sales_Price_U__c=45,
            Future_Sales_Price__c=34,
          	Minimum_Price_U__c=34,
            Minimum_Price_R__c=25,
          	Unit_Price__c=20,
            Unit_Price_U__c=56,           
            CurrencyIsoCode='BRL',
            Sales_District1__c = region.Id  ,
          Kit_SKU__c =skuRecord.Id
        );
    insert PBdetails;
    
    
    Sales_District_Cost__c SDC= new Sales_District_Cost__c(
    	Region__c=region.id,
        Sales_District_Cost__c=100
    );
    insert SDC; 
    Market_Variation__c MV= new Market_Variation__c(
    SKU_Brand__c='test',
        Sales_District__c=region.id,
        Region_Code__c='BR4003',
        Combination_Key__c='BR4003test5191',
        Market_Variation__c=100
    );    
    insert MV;
    
    Discount_Matrix__c DM= new Discount_Matrix__c(
    Brand_Name__c='test',
    BU_Manager__c=100,
    Sales_Director__c=100,
    Sales_District_Manager__c=100,
    Sales_Person__c=100
    );
    insert DM;
        
    List <Id> pbcList= new List<Id>();
    pbcList.add(priceBookObj.id);
 
    Test.startTest();
    BrazilPriceBookCreate.CreatePriceBook(pbcList);
    Test.stopTest();
}
}