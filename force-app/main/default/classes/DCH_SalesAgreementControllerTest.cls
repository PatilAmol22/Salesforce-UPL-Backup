@isTest (seeAllData=true)
public class DCH_SalesAgreementControllerTest {
    static testMethod void validateHelloWorld() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Germany';
        sorg.Description__c='Germany';
        sorg.Sales_Org_Code__c='2191';
        insert sorg;

        Account acc = new Account(
            Name = 'MAURICIO  [View Hierarchy]',// Account Name
            SAP_Code__c = '0001419276',                                     // SAP Customer Code
            Mobile__c = '0000000000001000',                               // Mobile
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
            RecordTypeId = devRecordTypeId                           // Account Record Type
        );
        insert acc;

        Division__c div = new Division__c();
        div.Name = 'Decco';
        div.Description__c = 'Decco';
        div.Division_Code__c = 'DC0';
        insert div;

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
            Description = '2,4-D 880 SP (DEZ GOLD) 20 KG',     // Product Description
            Active__c = true
        );
        insert pro;

        ID standardPBID = Test.getStandardPricebookId();
        //system.debug('standardPBID ** -' + standardPBID);

        insert new PriceBookEntry(Product2Id=pro.Id, Pricebook2Id=standardPBID, UnitPrice=100, isActive=true);

        Zone__c zone =  new Zone__c();
        zone.SalesOrg__c = sorg.Id;
        zone.Name = 'BU MATO GROSSO';
        zone.ZoneCode__c = 'BR000';              
        //zone.ZonalHead__c = user.Id;
        //  zone.SBU_Code__c = sbu.Id;
        insert zone;

        Region__c region = new Region__c();
        region.Name = 'MATO GROSSO DO SUL';
        region.RegionCode__c =  'BR0000';
        region.SalesOrg__c = sorg.Id;
        region.Zone__c = zone.Id;
        //region.RegionHead__c = user.Id;
        //region.BrazilAnalyst__c = brzlU.Id;    
       // region.SBU__c = sbu.Id;                                                                           
        insert region;

        Pricebook2 pb = new Pricebook2(
            Name = 'October2022BR0005',                  // Price Book Name
            IsActive = true,                           // Active
            Is_Used_for_Forecast__c = true,            // Is Used for Forecast
            Sales_District__c = region.id,     // Sales District
            Combination_Key__c = 'October2022BR00005',      // Combination Key
            Sales_Org__c = sorg.id,          // Sales Org
            Price_Book_Category__c = 'Forecast',       // Price Book Category
            Type__c = 'Monthly',                       // Type
            Start_Date__c = system.today(),  // Start Date
            Month__c = '10',                           // Month
            End_Date__c = system.today()+60,   // End Date
            Year__c = '2022'                          // Year
        );
        insert pb;        

        PricebookEntry pbe = new PricebookEntry(
            Product2Id = pro.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'October2022BR00055191000000000005250383'  // Combination Key
        );
        insert pbe;

        SalesAgreement sa = new SalesAgreement(
            Status = 'Draft',                                           // Status
            Name = 'SABR114092023',                                       // Name
            StartDate = system.today(),                        // Start Date
            AccountId = acc.id,                                // Account
            ScheduleFrequency = 'Yearly',                                // Schedule Frequency 
            ScheduleCount = 1,                                         // Schedule Count
            //EndDate = system.today(),                           // End Date
            PricebookId = pb.id,                              // Price Book
            //Region__c = territory.id,                                // Region
            Clone_the_existing_Forecast__c = false,                        // Clone the existing Forecast
            Year__c = '2023'                                           // Year
            //Cloned_from_Sales_Agreement__c = '0YA0k000000006o',           // Cloned from Sales Agreement
            //Active_Forecast_Month_Number__c = '09',                       // Active Forecast Month (Number)
            //Active_Forecast_Month__c = 'September',                             // Active Forecast Month
            //Sales_Agreement_Schedule_Frequency_Allow__c ='Monthly'
        );
        insert sa;

        SalesAgreementProduct sap = new SalesAgreementProduct(
            SalesPrice = 1.00,                                          // Sales Price
            InitialPlannedQuantity = 1,                                 // Initial Total Quantity
            DiscountPercentage = 0.00,                                    // Discount Percentage
            Name = 'Test', 
            CurrencyIsoCode = 'EUR', 
            SalesAgreementId = sa.id, 
            PricebookEntryId = pbe.id, 
            //ProductId = pro.id, 
            //ListPrice = 1, 
            Last_Consensus__c = 1, 
            Budget_Price__c = 3, 
            Earlier_Planned_Quantity__c = 10
        );
        insert sap;

        SalesAgreement sa2 = new SalesAgreement(
            Status = 'Draft',                                           // Status
            Name = 'SABR114092022',                                       // Name
            StartDate = system.today()-365,                        // Start Date
            AccountId = acc.id,                                // Account
            ScheduleFrequency = 'Yearly',                                // Schedule Frequency 
            ScheduleCount = 1,                                         // Schedule Count
            PricebookId = pb.id,                              // Price Book
            Clone_the_existing_Forecast__c = false,                        // Clone the existing Forecast
            Year__c = '2022'                                           // Year
        );
        insert sa2;

        SalesAgreementProduct sap2 = new SalesAgreementProduct(
            SalesPrice = 1.00,                                          // Sales Price
            InitialPlannedQuantity = 1,                                 // Initial Total Quantity
            DiscountPercentage = 0.00,                                    // Discount Percentage
            Name = 'Test2', 
            CurrencyIsoCode = 'EUR', 
            SalesAgreementId = sa2.id, 
            PricebookEntryId = pbe.id, 
            //ProductId = pro.id, 
            //ListPrice = 1, 
            Last_Consensus__c = 1, 
            Budget_Price__c = 3, 
            Earlier_Planned_Quantity__c = 10
        );
        insert sap2;

        SalesAgreement sa3 = new SalesAgreement(
            Status = 'Draft',                                           // Status
            Name = 'SABR114092021',                                       // Name
            StartDate = system.today()-730,                        // Start Date
            AccountId = acc.id,                                // Account
            ScheduleFrequency = 'Yearly',                                // Schedule Frequency 
            ScheduleCount = 1,                                         // Schedule Count
            PricebookId = pb.id,                              // Price Book
            Clone_the_existing_Forecast__c = false,                        // Clone the existing Forecast
            Year__c = '2021'                                           // Year
        );
        insert sa3;

        SalesAgreementProduct sap3 = new SalesAgreementProduct(
            SalesPrice = 1.00,                                          // Sales Price
            InitialPlannedQuantity = 1,                                 // Initial Total Quantity
            DiscountPercentage = 0.00,                                    // Discount Percentage
            Name = 'Test2', 
            CurrencyIsoCode = 'EUR', 
            SalesAgreementId = sa3.id, 
            PricebookEntryId = pbe.id, 
            //ProductId = pro.id, 
            //ListPrice = 1, 
            Last_Consensus__c = 1, 
            Budget_Price__c = 3, 
            Earlier_Planned_Quantity__c = 10
        );
        insert sap3;

        DCH_SalesAgreementController.callBatchClass(sa.Id);
        DCH_SalesAgreementController.updateSchedules(sa.Id,acc.Id,2023,'2191',sa2.Id,sa3.Id);
    }
}