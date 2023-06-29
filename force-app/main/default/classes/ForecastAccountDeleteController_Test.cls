@isTest
public class ForecastAccountDeleteController_Test {
    static testMethod void validateMethod() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        List<Forecast_Account__c> ForeAccountList=new List<Forecast_Account__c>();
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Description__c='Brazil';
        sorg.Sales_Org_Code__c='5191';
        sorg.Is_Active_Forecast__c = true;
        insert sorg;
        
        Account acc = new Account(
            Name = 'MAURICIO BERNARDO SCHOLTEN E OUTROS [View Hierarchy]',// Account Name
            SAP_Code__c = '0001419276',                                     // SAP Customer Code
            Mobile__c = '000000000000000000',                               // Mobile
            Email__c = 'mauri@xxx.com',                            // Email
            Order_Block__c = false,                                         // Order Block
            // Brazil_Depot_Code__c = 'a0w0k000000s2gs',                       // Depot
            // Depot_Code__c = 'a0w0k000000s2gsAAA',                           // Depot Code
            Sales_Org__c = sorg.id,                               // Sales Org
            taxjurcode__c = 'GO 5218805',                                   // taxjurcode
            Is_Forecast_Required__c = true,                                 // Is Forecast Required
            TaxNumber2__c = '12031688880',                                  // Tax Number 2
            Account_Type__c = 'Sold To Party',                              // Account Type
            //CustomerRegion__pc = 'GO',                                      // Customer Region
            Final_Approval_Date__c = system.today(),             // Final Approval Date
            Customer_Group__c = '069',                                      // Customer Group(Attribute 6)
            Last_Name__c = 'MAURICIO BERNARDO SCHOLTEN E OUTROS',           // Last Name
            OwnersetbyProcess__c = false,                                   // Owner set by Process
            RecordTypeId = devRecordTypeId                                     // Account Record Type
        );
        insert acc;
        
        Account acc2 = new Account(
            Name = 'MAURICIO BERNARDO SCHOLTEN E OUTROS [View Hierarchy]',// Account Name
            SAP_Code__c = '0001419277',                                     // SAP Customer Code
            Mobile__c = '00000000000000000',                               // Mobile
            Email__c = 'mauri@xx.com',                            // Email
            Order_Block__c = false,                                         // Order Block
            // Brazil_Depot_Code__c = 'a0w0k000000s2gs',                       // Depot
            // Depot_Code__c = 'a0w0k000000s2gsAAA',                           // Depot Code
            Sales_Org__c = sorg.id,                               // Sales Org
            taxjurcode__c = 'GO 5218805',                                   // taxjurcode
            Is_Forecast_Required__c = true,                                 // Is Forecast Required
            TaxNumber2__c = '12031688881',                                  // Tax Number 2
            Account_Type__c = 'Sold To Party',                              // Account Type
            //CustomerRegion__pc = 'GO',                                      // Customer Region
            Final_Approval_Date__c = system.today(),             // Final Approval Date
            Customer_Group__c = '069',                                      // Customer Group(Attribute 6)
            Last_Name__c = 'MAURICIO BERNARDO SCHOLTEN E OUTROS',           // Last Name
            OwnersetbyProcess__c = false,                                   // Owner set by Process
            RecordTypeId = devRecordTypeId                                     // Account Record Type
        );
        insert acc2;
        
        Account acc3 = new Account(
            Name = 'MAURICIO BERNARDO SCHOLTEN E OUTROS [View Hierarchy]',// Account Name
            SAP_Code__c = '0001419279',                                     // SAP Customer Code
            Mobile__c = '0000000000000000',                               // Mobile
            Email__c = 'mauri@x.com',                            // Email
            Order_Block__c = false,                                         // Order Block
            // Brazil_Depot_Code__c = 'a0w0k000000s2gs',                       // Depot
            // Depot_Code__c = 'a0w0k000000s2gsAAA',                           // Depot Code
            Sales_Org__c = sorg.id,                               // Sales Org
            taxjurcode__c = 'GO 5218805',                                   // taxjurcode
            Is_Forecast_Required__c = true,                                 // Is Forecast Required
            TaxNumber2__c = '12031688881',                                  // Tax Number 2
            Account_Type__c = 'Sold To Party',                              // Account Type
            //CustomerRegion__pc = 'GO',                                      // Customer Region
            Final_Approval_Date__c = system.today(),             // Final Approval Date
            Customer_Group__c = '069',                                      // Customer Group(Attribute 6)
            Last_Name__c = 'MAURICIO BERNARDO SCHOLTEN E OUTROS',           // Last Name
            OwnersetbyProcess__c = false,                                   // Owner set by Process
            RecordTypeId = devRecordTypeId                                     // Account Record Type
        );
        insert acc3;
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'System Administrator'];
        
        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName=acc.Last_Name__c;
        con.MobilePhone ='9876543210';
        con.Phone = '5592619031';
        insert con;        
        
        
        Zone__c zone =  new Zone__c();
        zone.SalesOrg__c = sorg.Id;
        zone.Name = 'BU MATO GROSSO';
        zone.ZoneCode__c = 'BR000';              
        
        //  zone.SBU_Code__c = sbu.Id;
        insert zone;
        
        Region__c region = new Region__c();
        region.Name = 'MATO GROSSO DO SUL';
        region.RegionCode__c =  'BR0000';
        region.SalesOrg__c = sorg.Id;
        region.Zone__c = zone.Id;
        
        
        // region.SBU__c = sbu.Id;                                                                           
        insert region;
        
        //system.debug('Test Class Data - region **** -' + region);
        
        Territory_Distributor__c territory =  new Territory_Distributor__c();
        territory.Name = 'Araxá';
        territory.TerritoryCode__c = 'BR000';
        //territory.SBU__c = sbu.Id;     
        territory.Region__c = region.id;
        territory.SalesOrg__c = sorg.Id;
        territory.RegionDesciption__c = 'BR1001102 CHPS';                       
        territory.Zone__c = zone.Id;
        
        // territory.TerritoryManagerActive__c = false;
        insert territory;
        
        Division__c div = new Division__c();
        div.Name = 'Decco';
        div.Description__c = 'Decco';
        div.Division_Code__c = 'DC0';
        insert div;
        
        Distribution_Channel__c disbj = new Distribution_Channel__c();
        disbj.Name = '10';                      
        disbj.Distribution_Channel_Code__c = '00';  
        disbj.Description__c='10';
        //disbj.Sales_Org__c = sorg.id;
        insert disbj;
        
        Customer_and_Region_Mapping__c crm = new Customer_and_Region_Mapping__c(
            Customer_Name__c = acc.id,// Customer Name
            Active__c = true,                      // Active
            CustomerRegion__c = territory.Id,
            Distribution_Channel__c = disbj.id,
            Division__c = div.id,
            Sales_Org__c = sorg.id
        );
        insert crm;
        
        Customer_and_Region_Mapping__c crm2 = new Customer_and_Region_Mapping__c(
            Customer_Name__c = acc2.id,// Customer Name
            Active__c = true,                      // Active
            CustomerRegion__c = territory.Id,
            Distribution_Channel__c = disbj.id,
            Division__c = div.id,
            Sales_Org__c = sorg.id
        );
        insert crm2;
        
        Forecast_Account__c fa = new Forecast_Account__c(
            
            Account__c = acc.id,
            Territory__c = territory.id,
            Combination_Key__c = territory.TerritoryCode__c+acc.SAP_Code__c,
            
            Dummy_Customer__c =false
        );
        insert fa;
        
        Forecast_Account__c fa2 = new Forecast_Account__c(
            
            Account__c = acc3.id,
            Territory__c = territory.id,
            Combination_Key__c = territory.TerritoryCode__c+acc3.SAP_Code__c,
            
            Dummy_Customer__c =true
        );
        insert fa2;
        List<Forecast_Account__c> faNames=[Select name from Forecast_Account__c limit 2];
        System.debug('faNames'+faNames);
        
        Product2 pro = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 20 KG',          // Product Name
            Product_Code__c = '000000000005250380',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = true,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250380',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 20 KG'     // Product Description
        );
        insert pro;
        ID standardPBID = Test.getStandardPricebookId();
        system.debug('standardPBID ** -' + standardPBID);
        
        insert new PriceBookEntry(Product2Id=pro.Id, Pricebook2Id=standardPBID, UnitPrice=100, isActive=true);
        Pricebook2 pb = new Pricebook2(
            Name = 'June2021BR0005',                  // Price Book Name
            IsActive = true,                           // Active
            Is_Used_for_Forecast__c = true,            // Is Used for Forecast
            Sales_District__c = region.id,     // Sales District
            Combination_Key__c = 'June2023BR00005',      // Combination Key
            Sales_Org__c = sorg.id,          // Sales Org
            Price_Book_Category__c = 'Forecast',       // Price Book Category
            Type__c = 'Monthly',                       // Type
            Start_Date__c = system.today(),  // Start Date
            Month__c = '06',                           // Month
            End_Date__c = system.today(),   // End Date
            Year__c = '2023' 
            
        );
        insert pb;
        PricebookEntry pbe = new PricebookEntry(
            Product2Id = pro.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'June2023BR00055191000000000005250383'  // Combination Key
        );
        insert pbe;
        
        SalesAgreement sa = new SalesAgreement(
            Status = 'Draft',                                           // Status
            Name = 'SABR114052021',                                       // Name
            StartDate = system.today(),                        // Start Date
            AccountId = acc.id,                                // Account
            ScheduleFrequency = 'Monthly',                                // Schedule Frequency 
            ScheduleCount = 12,                                         // Schedule Count
            EndDate = system.today(),                           // End Date
            PricebookId = pb.id,                              // Price Book
            //LastModifiedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),  // Last Modified Date
            //CreatedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),       // Created Date
            Region__c = territory.id,                                // Region
            Clone_the_existing_Forecast__c = false,                        // Clone the existing Forecast
            Year__c = '2023',                                             // Year
            //Cloned_from_Sales_Agreement__c = '0YA0k000000006o',           // Cloned from Sales Agreement
            Active_Forecast_Month_Number__c = '05',                       // Active Forecast Month (Number)
            Active_Forecast_Month__c = 'May',                             // Active Forecast Month
            Sales_Agreement_Schedule_Frequency_Allow__c ='Monthly'
        );
        insert sa;
        
        SalesAgreementProduct sap = new SalesAgreementProduct(
            SalesPrice = 1.00,                                          // Sales Price
            InitialPlannedQuantity = 1,                                 // Initial Total Quantity
            DiscountPercentage = 0.00,                                    // Discount Percentage
            Name = 'Test', 
            CurrencyIsoCode = 'USD', 
            SalesAgreementId = sa.id, 
            PricebookEntryId = pbe.id, 
            //ProductId = pro.id, 
            //ListPrice = 1, 
            //Combination_Key__c = , 
            Last_Consensus__c = 1, 
            Budget_Price__c = 3, 
            Earlier_Planned_Quantity__c = 10
        );
        insert sap;
        
        
        List<SalesAgreement> saList=new List<SalesAgreement>();
        for(Integer j=1;j<=12;j++){
            String dateStr='01/'+j+'/2023';
            SalesAgreement sAgmt = new SalesAgreement();
            sAgmt.Status = 'Draft';                                           // Status
            sAgmt.Name = 'SABR114042021';                                       // Name
            sAgmt.StartDate = date.parse(dateStr);                        // Start Date
            sAgmt.AccountId = acc.id;                                // Account
            sAgmt.ScheduleFrequency = 'Monthly';                                // Schedule Frequency 
            sAgmt.ScheduleCount = 12;                                         // Schedule Count
            sAgmt.EndDate = date.parse(dateStr);                           // End Date
            sAgmt.PricebookId = pb.id;                              // Price Book
            //LastModifiedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),  // Last Modified Date
            //CreatedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),       // Created Date
            sAgmt.Region__c = territory.id;                               // Region
            sAgmt.Clone_the_existing_Forecast__c = true;                        // Clone the existing Forecast
            sAgmt.Year__c = '2023';                                             // Year
            sAgmt.Cloned_from_Sales_Agreement__c = sa.Id;           // Cloned from Sales Agreement
            sAgmt.Active_Forecast_Month_Number__c = '05';                       // Active Forecast Month (Number)
            sAgmt.Active_Forecast_Month__c = 'May';                             // Active Forecast Month
            sAgmt.Sales_Agreement_Schedule_Frequency_Allow__c ='Monthly';
            saList.add(sAgmt);
            
        }
        insert saList;
        //System.debug('saList size :'+saList.size());
        //System.debug('saList :'+saList);
        /*List<SalesAgreementProduct> sapList=new List<SalesAgreementProduct>();
for(SalesAgreement sAgmt:saList){
SalesAgreementProduct sap11 = new SalesAgreementProduct();
sap11.SalesPrice = 1.00;  // Sales Price
sap11.InitialPlannedQuantity = 1;                                 // Initial Total Quantity
sap11.DiscountPercentage = 0.00;                                    // Discount Percentage
sap11.Name = 'Test'; 
sap11.CurrencyIsoCode = 'USD';

sap11.SalesAgreementId = sAgmt.id; 
sap11.PricebookEntryId = pbe.id; 
sap11.Last_Consensus__c = 1; 
sap11.Budget_Price__c = 3; 
sap11.Earlier_Planned_Quantity__c = 10;
sapList.add(sap11);   
}*/
        
        // insert sapList;        
        
        test.startTest();
        List<ForecastAccountDeleteController.ForecastAccountWrapper> wrapperList = ForecastAccountDeleteController.getForecastAccount();
        ForecastAccountDeleteController.deleteForecastAccount(faNames);
        test.stopTest();
        
        
        
    }
}