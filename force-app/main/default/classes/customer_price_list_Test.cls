@isTest
public class customer_price_list_Test {
static testMethod void customer_price_list_Test(){
    insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
          Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
          sorg=[SELECT Id,sales_org_code__c from sales_org__c];
          list<sales_org__c> salesorgId= [SELECT ID  FROM sales_org__c where sales_org_code__c=: sorg.sales_org_code__c];
       
    Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
     	User usr = new User(LastName = 'user',
                           FirstName='test',
                           Alias = 'utest',
                           Email = 'test@test.com',
                           Username = 'test@test.com',
                           ProfileId = profileId.id
                           
                           );
    
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
         EmailEncodingKey='UTF-8',
         LanguageLocaleKey='en_US',
         LocaleSidKey='en_US',
         TimeZoneSidKey='America/Los_Angeles'
         );  
         insert sbuHead ;
    SBU__c sbu = new SBU__c(
          Brazil_SBU_Name__c = 'GESTÃO SEDE',  // Brazil SBU Name
          SBUCode__c = 'BR0',                  // SBU Code
          SalesOrg__c = salesorgId[0].id,
          SBUUser__c =  sbuHead.id    // Sales Org
        );
        insert sbu;  
        
       Zone__c zone = new Zone__c(
              Name = 'BU CERRADO',            // Zone Name
              SalesOrg__c = salesorgId[0].id,  // Sales Org
              ZoneCode__c = 'BR40',         // Zone Code
              ZonalHead__c = zoneman.id
            );
            insert zone;
            
        Region__c region = new Region__c(
              Name = 'TRIANGULO',                  // Region Name
              RegionCode__c = 'BR4003',              // Region Code
              SalesOrg__c = salesorgId[0].id,       // Sales Org
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
    	 territory.SalesOrg__c=salesorgId[0].id;  
         insert territory;
    Account acc = TestDataFactory.CreateAccount('SAP996734');
    acc.Customer_Group__c= '1';
    update acc;
    Customer_Conversion_factor__c ccf= new Customer_Conversion_factor__c();
    ccf.Conversion_Factor__c=0.5;
    ccf.Customer_Group__c='1';
    insert ccf;
        Customer_and_Region_Mapping__c crmObj =  new Customer_and_Region_Mapping__c();
        crmObj.Customer_Name__c = acc.Id;
        crmObj.Sales_Org__c =salesorgId[0].Id;
        crmObj.CustomerRegion__c=salesorgId[0].Id;
        crmObj.CustomerRegion__c =territory.Id;
        insert crmObj;
        
    
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
          	Interest_Rate_R__c = 1.0,
           	isActive__c = True,
            Status__c = 'Approved',
            Base_Price_Book__c = false
        );
        insert priceBookObj;
     Price_Book_Sales_District__c pbsd=new Price_Book_Sales_District__c();
        pbsd.Price_Book__c=priceBookObj.Id;
        pbsd.Sales_District1__c=region.Id;
        insert pbsd;
     
        /*SKU__c skuRecord = new SKU__c(
            //Name = 'a1C0k000000A1ug',                                // SKU Name
            SKU_Code__c = '000000000006302802',                      // SKU Code
            SKU_Description__c = 'MANZATE 800WP 25KG PAPER BAG_BR',  // SKU Description
            UOM__c = 'KG',
            Division__c = div.Id,                                    // Division
            Sales_Org__c = salesorgId[0].Id,                              // Sales Org
            Multiple_of__c = 25.00,                                  // Multiple Of
            Combination_Key__c = '519110000000000006302802',         // Combination Key
            Active__c = true                                         // Active
        );
    SKU__c skuRecord = new SKU__c(
        Name = 'a1C0k000000A1ug', // SKU Name
        SKU_Code__c = '000000000006302802', // SKU Code
        SKU_Description__c = 'MANZATE 800WP 25KG PAPER BAG_BR', // SKU Description
        UOM__c = 'KG',
        Division__c = div.Id, // Division
        Sales_Org__c = salesorgId[0].Id, // Sales Org
        Multiple_of__c = 25.00, // Multiple Of
        Combination_Key__c = '519110000000000006302802', // Combination Key
        Active__c = true // Active
    );
    insert skuRecord;*/
    
      Price_Book_Details__c PBdetails = new Price_Book_Details__c(
            //SKU__c =skuRecord.Id,                    
            Monthly_Interest_Rate__c = 1.00,         
            Price_Book__c = priceBookObj.Id,  
            Exchange_Rate__c = 3.00,                
            Unit_Price_R__c = 120.00,                 
            Minimum_Price__c = 75.00, 
          	Future_Sales_Price_R__c=50,
          	Future_Sales_Price_U__c=45,
          	Minimum_Price_U__c=34,
            Minimum_Price_R__c=25,
            Unit_Price_U__c=56,           
            CurrencyIsoCode='BRL',
            Sales_District1__c = region.Id          
        );
    insert PBdetails;
     Test.startTest();
    List <customer_price_list.customerRegion> cr= new List<customer_price_list.customerRegion>();
    list<Customer_and_Region_Mapping__c > crmList= new list <Customer_and_Region_Mapping__c >();
    List<customer_price_list.custPriceBookList> cpList= new List<customer_price_list.custPriceBookList>();
    list<customer_price_list.custPriceList> custpList= new list<customer_price_list.custPriceList>();
    cr=customer_price_list.getSalesDistrict();
    crmList=customer_price_list.getCustomers(territory.id);
    cpList=customer_price_list.getPriceBookList(territory.id,acc.id);    
    Boolean br=customer_price_list.getProfileVisibility();
    system.runAs(sbuHead){
        cr=customer_price_list.getSalesDistrict();
    crmList=customer_price_list.getCustomers(crmObj.id);
    cpList=customer_price_list.getPriceBookList(crmObj.id,acc.id);    
    br=customer_price_list.getProfileVisibility();
        system.debug(acc.id+': '+crmObj.id+': '+priceBookObj.id);
     custpList=customer_price_list.getPriceLists(acc.id,crmObj.id,priceBookObj.id);
        
        
    }
    system.runAs(zoneman){
        cr=customer_price_list.getSalesDistrict();
    crmList=customer_price_list.getCustomers(crmObj.id);
    cpList=customer_price_list.getPriceBookList(crmObj.id,acc.id);    
    br=customer_price_list.getProfileVisibility(); 
        
    }
    system.runAs(terrman){
        cr=customer_price_list.getSalesDistrict();
    crmList=customer_price_list.getCustomers(crmObj.id);
    cpList=customer_price_list.getPriceBookList(crmObj.id,acc.id);    
    br=customer_price_list.getProfileVisibility(); 
        
    }
   system.runAs(regman){
        cr=customer_price_list.getSalesDistrict();
    crmList=customer_price_list.getCustomers(crmObj.id);
    cpList=customer_price_list.getPriceBookList(crmObj.id,acc.id);    
    br=customer_price_list.getProfileVisibility(); 
        
    }
     Test.stopTest();     
}
}