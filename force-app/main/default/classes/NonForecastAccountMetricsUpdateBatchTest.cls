@isTest
public class NonForecastAccountMetricsUpdateBatchTest {
    static testMethod void validateHelloWorld() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Description__c='Brazil';
        sorg.Sales_Org_Code__c='5191';
        sorg.Is_Active_Forecast__c = true;
        insert sorg;
       // system.debug('Test Class Data - Sales Org **** -' + sorg);
        /* Report report = new Report(
            FolderName = 'Brazil Reports',
            Name = 'Sales Agreement (Forecast)'
        );
        insert report; */

        RecordType depoRcdTp = [SELECT Id FROM RecordType WHERE name = 'Depot' and isActive = true LIMIT 1];

        Account acc = new Account(
            Name = 'MAURICIO BERNARDO SCHOLTEN E OUTROS [View Hierarchy]',// Account Name
            SAP_Code__c = 'Spot000',                                     // SAP Customer Code
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
            Name = 'BERNARDO SCHOLTEN E OUTROS [View Hierarchy]',// Account Name
            SAP_Code__c = '0001419276',                                     // SAP Customer Code
            Mobile__c = '000000000000000001',                               // Mobile
            Email__c = 'mau@xxx.com',                            // Email
            Order_Block__c = false,                                         // Order Block
           // Brazil_Depot_Code__c = 'a0w0k000000s2gs',                       // Depot
           // Depot_Code__c = 'a0w0k000000s2gsAAA',                           // Depot Code
            Sales_Org__c = sorg.id,                               // Sales Org
            taxjurcode__c = 'GO 5218806',                                   // taxjurcode
            Is_Forecast_Required__c = true,                                 // Is Forecast Required
            TaxNumber2__c = '12031688881',                                  // Tax Number 2
            Account_Type__c = 'Sold To Party',                              // Account Type
            //CustomerRegion__pc = 'GO',                                      // Customer Region
            Final_Approval_Date__c = system.today(),             // Final Approval Date
            Customer_Group__c = '069',                                      // Customer Group(Attribute 6)
            Last_Name__c = 'BERNARDO SCHOLTEN E OUTROS',           // Last Name
            OwnersetbyProcess__c = false,                                   // Owner set by Process
            RecordTypeId = devRecordTypeId                                     // Account Record Type
        );
        insert acc2;

        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'System Administrator'];

        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName=acc.Last_Name__c;
        con.MobilePhone ='9876543210';
        con.Phone = '5592619031';
        insert con;        
        
        userrole  usrole = new userrole();
        usrole.Name ='Regional/Zonal Managers for Spain';

        User user = new User();
        user.Alias = 'zonaa';                                                            
        user.Email = 'skim@skinternational123.com';                             
        user.ProfileId  = p.ID;                                                     
        user.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        user.IsActive = true;  
        user.LastName='Terriotory Manager';
        user.CommunityNickname = 'zonalExe1222 Di'; 
        user.TimeZoneSidKey = 'Asia/Kolkata'; 
        user.LocaleSidKey = 'en_IN';                                    
        user.LanguageLocaleKey = 'en_US';                                             
        user.ForecastEnabled = false;                                                     
        user.EmailEncodingKey = 'ISO-8859-1';    
        user.Show_Inventory__c = false;                                                     
        user.Show_Credit_Limit__c = false; 
        user.UserRoleId=usrole.id;
        //user.ContactId=con.Id;
        user.Country = 'Brazil';
        insert user;

        User brzlU = new User();
        brzlU.Alias = 'zonaa2';                                                            
        brzlU.Email = 'sk@skinternational.com';                             
        brzlU.ProfileId  = p.ID;                                                     
        brzlU.Username = 'zonal7_aaexe1232@upl122333.com.devbox1';                                    
        brzlU.IsActive = true;  
        brzlU.LastName='TM';
        brzlU.CommunityNickname = 'zonal7Exe1222 Di'; 
        brzlU.TimeZoneSidKey = 'Asia/Kolkata'; 
        brzlU.LocaleSidKey = 'en_IN';                                    
        brzlU.LanguageLocaleKey = 'en_US';                                             
        brzlU.ForecastEnabled = false;                                                     
        brzlU.EmailEncodingKey = 'ISO-8859-1';    
        brzlU.Show_Inventory__c = false;                                                     
        brzlU.Show_Credit_Limit__c = false; 
        brzlU.UserRoleId=usrole.id;
        //brzlU.ContactId=con.Id;
        brzlU.Country = 'Brazil';
        brzlU.ManagerId = user.Id;
        brzlU.Country_Head__c = user.Id;
        
        insert brzlU;     

        Sales_Forecast_Setting__c sfs = new Sales_Forecast_Setting__c(
            Sales_Org__c = sorg.id,                       // Sales Org
            Configuration_on_Sales_Forecast_Metric__c = 3.00,         // % Configuration on Sales Forecast Metric
            Sales_Agreement_Schedule_Frequency_Allow__c = 'Monthly',  // Sales Agreement Schedule Frequency Allow
            Active_Forecast_Month__c = 'December',                         // Active Forecast Month
            Schedule_Frequency_Allowed__c = '12',                     // Schedule Frequency Allowed
            Currency_Allowed__c = 'USD',                              // Currency Allowed
            Start_Day_of_Submission__c = 2,                         // Start Day of Submission
            End_Day_of_Submission__c = 5,                           // End Day of Submission
            Start_Day_Of_Approval__c = 7,                           // Start Day Of Approval
            End_Day_Of_Approval__c = 14,                            // End Day Of Approval
            Clone_the_existing_Forecast_Previous_mon__c = true,       // Clone the existing Forecast
            Create_a_forecast_based_on_the__c = true                 // Create a forecast based on the PPBAU
        );
        insert sfs;
        //system.debug('Test Class Data - sfs **** -' + sfs);

        Zone__c zone =  new Zone__c();
        zone.SalesOrg__c = sorg.Id;
        zone.Name = 'BU MATO GROSSO';
        zone.ZoneCode__c = 'BR000';              
        zone.ZonalHead__c = user.Id;
        //  zone.SBU_Code__c = sbu.Id;
        insert zone;

        Region__c region = new Region__c();
        region.Name = 'MATO GROSSO DO SUL';
        region.RegionCode__c =  'BR0000';
        region.SalesOrg__c = sorg.Id;
        region.Zone__c = zone.Id;
        region.RegionHead__c = user.Id;
        region.BrazilAnalyst__c = brzlU.Id;    
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
        territory.TerritoryManager__c = user.Id;
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

        Forecast_Account__c fa = new Forecast_Account__c(
            Account__c = acc.id,
            Combination_Key__c = territory.TerritoryCode__c+''+acc.SAP_Code__c,
            Dummy_Customer__c = false,
            Territory__c = territory.id
        );
        insert fa;

        /* Forecast_Account__c fa2 = new Forecast_Account__c(
            Account__c = acc2.id,
            Combination_Key__c = territory.TerritoryCode__c+''+acc2.SAP_Code__c,
            Dummy_Customer__c = false,
            Territory__c = territory.id
        );
        insert fa2; */

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

        SKU__c sku = new SKU__c(
            SKU_Description__c = '2,4-D 880 SP (DEZ GOLD) 20 KG',   // SKU Description
            Active_For_Liquidation__c = false,              // Active For Liquidation
            Name = '2,4-D 880 SP (DEZ GOLD) 20 KG',                   // SKU Name
            SKU_Code__c = '000000000005250380',             // SKU Code
            Product_Category__c = 'INSECTICIDES',           // Product Category
            UOM__c = 'KG',                                   // UOM
            Division__c = div.id,                // Division
            Sales_Org__c = sorg.id,               // Sales Org
            Multiple_of__c = 20.00,                       // Multiple Of
            Combination_Key__c = '5191000000000005250380',  // Combination Key
            //PriceList_Active__c = false,                    // PriceList Active
            Active__c = true,                               // Active
            Brand_Name__c = 'SHENZI',                       // Brand Name
           // Inventory_Dynamic_Check_Italy__c = false,       // Inventory Dynamic Check
            //Inventory_order_Flag__c = 'Red',                // Inventory order Flag
           // Special_SKU__c = false,                         // Price Block SKU
            //Kit_Product__c = false,                         // Kit Product
            Is_Forecast_Required__c = true,                 // Is Forecast Required
            //Industrial_SKU__c = false,                      // Industrial SKU
            Material_Group__c = '625004'                   // Material Group
        );
        insert sku;

        List<Open_Order__c> openList = new List<Open_Order__c>();

        Open_Order__c oo1 = new Open_Order__c(
            Business_Unit__c = zone.id,             // Business Unit
            Region__c = territory.id,                      // Region
            Customer__c = acc.id,                    // Customer
            Regional_Code__c = region.id,               // Regional Code
            Product__c = sku.id,                     // Product
            Data_de_Faturamento__c = Date.valueOf('2023-1-1'),  // Data de Faturamento
            Sales_Rep__c = user.Id,                   // Sales Rep
            Qty_ORD__c = 280,                                 // Qty ORD
            Net_Sales_ORD__c = 27753.00                        // Net Sales ORD
        );
        openList.add(oo1);

        Open_Order__c oo5 = new Open_Order__c(
            Business_Unit__c = zone.id,             // Business Unit
            Region__c = territory.id,                      // Region
            Customer__c = acc.id,                    // Customer
            Regional_Code__c = region.id,               // Regional Code
            Product__c = sku.id,                     // Product
            Data_de_Faturamento__c = Date.valueOf('2023-1-1'),  // Data de Faturamento
            Sales_Rep__c = user.Id,                   // Sales Rep
            Qty_ORD__c = 280,                                 // Qty ORD
            Net_Sales_ORD__c = 27753.00                        // Net Sales ORD
        );
        openList.add(oo5);

        Open_Order__c oo2 = new Open_Order__c(
            Business_Unit__c = zone.id,             // Business Unit
            Region__c = territory.id,                      // Region
            Customer__c = acc.id,                    // Customer
            Regional_Code__c = region.id,               // Regional Code
            Product__c = sku.id,                     // Product
            Data_de_Faturamento__c = Date.valueOf('2021-9-1'),  // Data de Faturamento
            Sales_Rep__c = user.Id,                   // Sales Rep
            Qty_ORD__c = 280,                                 // Qty ORD
            Net_Sales_ORD__c = 27753.00                        // Net Sales ORD
        );
        openList.add(oo2);

        Open_Order__c oo6 = new Open_Order__c(
            Business_Unit__c = zone.id,             // Business Unit
            Region__c = territory.id,                      // Region
            Customer__c = acc.id,                    // Customer
            Regional_Code__c = region.id,               // Regional Code
            Product__c = sku.id,                     // Product
            Data_de_Faturamento__c = Date.valueOf('2021-9-1'),  // Data de Faturamento
            Sales_Rep__c = user.Id,                   // Sales Rep
            Qty_ORD__c = 280,                                 // Qty ORD
            Net_Sales_ORD__c = 27753.00                        // Net Sales ORD
        );
        openList.add(oo6);

        Open_Order__c oo3 = new Open_Order__c(
            Business_Unit__c = zone.id,             // Business Unit
            Region__c = territory.id,                      // Region
            Customer__c = acc2.id,                    // Customer
            Regional_Code__c = region.id,               // Regional Code
            Product__c = sku.id,                     // Product
            Data_de_Faturamento__c = Date.valueOf('2023-1-1'),  // Data de Faturamento
            Sales_Rep__c = user.Id,                   // Sales Rep
            Qty_ORD__c = 280,                                 // Qty ORD
            Net_Sales_ORD__c = 27753.00                        // Net Sales ORD
        );
        openList.add(oo3);

        Open_Order__c oo7 = new Open_Order__c(
            Business_Unit__c = zone.id,             // Business Unit
            Region__c = territory.id,                      // Region
            Customer__c = acc2.id,                    // Customer
            Regional_Code__c = region.id,               // Regional Code
            Product__c = sku.id,                     // Product
            Data_de_Faturamento__c = Date.valueOf('2023-1-1'),  // Data de Faturamento
            Sales_Rep__c = user.Id,                   // Sales Rep
            Qty_ORD__c = 280,                                 // Qty ORD
            Net_Sales_ORD__c = 27753.00                        // Net Sales ORD
        );
        openList.add(oo7);

        Open_Order__c oo4 = new Open_Order__c(
            Business_Unit__c = zone.id,             // Business Unit
            Region__c = territory.id,                      // Region
            Customer__c = acc2.id,                    // Customer
            Regional_Code__c = region.id,               // Regional Code
            Product__c = sku.id,                     // Product
            Data_de_Faturamento__c = Date.valueOf('2021-10-1'), // Data de Faturamento
            Sales_Rep__c = user.Id,                   // Sales Rep
            Qty_ORD__c = 280,                                 // Qty ORD
            Net_Sales_ORD__c = 27753.00                        // Net Sales ORD
        );
        openList.add(oo4);

        Open_Order__c oo8 = new Open_Order__c(
            Business_Unit__c = zone.id,             // Business Unit
            Region__c = territory.id,                      // Region
            Customer__c = acc2.id,                    // Customer
            Regional_Code__c = region.id,               // Regional Code
            Product__c = sku.id,                     // Product
            Data_de_Faturamento__c = Date.valueOf('2021-10-1'), // Data de Faturamento
            Sales_Rep__c = user.Id,                   // Sales Rep
            Qty_ORD__c = 280,                                 // Qty ORD
            Net_Sales_ORD__c = 27753.00                        // Net Sales ORD
        );
        openList.add(oo8);

        insert openList;

        ID standardPBID = Test.getStandardPricebookId();
        //system.debug('standardPBID ** -' + standardPBID);

        insert new PriceBookEntry(Product2Id=pro.Id, Pricebook2Id=standardPBID, UnitPrice=100, isActive=true);

        Pricebook2 pb = new Pricebook2(
            Name = 'December2022BR0005',                  // Price Book Name
            IsActive = true,                           // Active
            Is_Used_for_Forecast__c = true,            // Is Used for Forecast
            Sales_District__c = region.id,     // Sales District
            Combination_Key__c = 'December2022BR00005',      // Combination Key
            Sales_Org__c = sorg.id,          // Sales Org
            Price_Book_Category__c = 'Forecast',       // Price Book Category
            Type__c = 'Monthly',                       // Type
            Start_Date__c = system.today(),  // Start Date
            Month__c = '12',                           // Month
            End_Date__c = system.today()+30,   // End Date
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
            Combination_Key__c = 'December2022BR00055191000000000005250383'  // Combination Key
        );
        insert pbe;

        SalesAgreement sa = new SalesAgreement(
            Status = 'Draft',                                           // Status
            Name = 'SABR114122022',                                       // Name
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
            Year__c = '2022',                                             // Year
            //Cloned_from_Sales_Agreement__c = '0YA0k000000006o',           // Cloned from Sales Agreement
            Active_Forecast_Month_Number__c = '12',                       // Active Forecast Month (Number)
            Active_Forecast_Month__c = 'December',                             // Active Forecast Month
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
             String dateStr='01/'+j+'/2021';
            SalesAgreement sAgmt = new SalesAgreement();
            sAgmt.Status = 'Draft';                                           // Status
            sAgmt.Name = 'SABR114122022';                                       // Name
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
            sAgmt.Year__c = '2022';                                             // Year
            sAgmt.Cloned_from_Sales_Agreement__c = sa.Id;           // Cloned from Sales Agreement
            sAgmt.Active_Forecast_Month_Number__c = '12';                       // Active Forecast Month (Number)
            sAgmt.Active_Forecast_Month__c = 'December';                             // Active Forecast Month
            sAgmt.Sales_Agreement_Schedule_Frequency_Allow__c ='Monthly';
        	saList.add(sAgmt);
        
        }
        insert saList;
        //System.debug('saList size :'+saList.size());
        //System.debug('saList :'+saList);
        List<SalesAgreementProduct> sapList=new List<SalesAgreementProduct>();
        for(SalesAgreement sAgmt:saList){
            SalesAgreementProduct sap11 = new SalesAgreementProduct();
            sap11.SalesPrice = 1.00;                                          // Sales Price
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
        }
        insert sapList;
        //EOC
       
        NonForecastAccountMetricsUpdateBatch bcn = new NonForecastAccountMetricsUpdateBatch('December','2022','test@ybl.com');
        ID batchprocessid = Database.executeBatch(bcn,1);
    }
}