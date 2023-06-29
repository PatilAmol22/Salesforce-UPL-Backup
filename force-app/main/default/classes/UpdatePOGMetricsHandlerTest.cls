@isTest
public class UpdatePOGMetricsHandlerTest {
      
   
    static testMethod void allTheDataForThisTestClass() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Description__c='Brazil';
        sorg.Sales_Org_Code__c='5191';
        sorg.Is_Active_Forecast__c = true;
        insert sorg;
        system.debug('Test Class Data - Sales Org **** -' + sorg);
        /* Report report = new Report(
            FolderName = 'Brazil Reports',
            Name = 'Sales Agreement (Forecast)'
        );
        insert report; */

        RecordType depoRcdTp = [SELECT Id FROM RecordType WHERE name = 'Depot' and isActive = true LIMIT 1];

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
        brzlU.CommunityNickname = 'zonal7Exe12221 Di'; 
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
            Active_Forecast_Month__c = 'March',                         // Active Forecast Month
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
        system.debug('Test Class Data - sfs **** -' + sfs);

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
        region.Batch_Number__c='Batch 1';
       // region.SBU__c = sbu.Id;                                                                           
        insert region;

        system.debug('Test Class Data - region **** -' + region);

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

        Customer_and_Region_Mapping__c crm = new Customer_and_Region_Mapping__c(
            Customer_Name__c = acc.id,// Customer Name
            Active__c = true,                      // Active
            CustomerRegion__c = territory.Id,
            Distribution_Channel__c = disbj.id,
            Division__c = div.id,
            Sales_Org__c = sorg.id
        );
        insert crm;
        
        Forecast_Account__c fa = new Forecast_Account__c(
            Account__c = acc.id,
            Territory__c = territory.id,
            Combination_Key__c = territory.TerritoryCode__c+acc.SAP_Code__c,
            OwnerId = user.id,
            Dummy_Customer__c =false
        );
        insert fa;

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
        
        Product2 proCh = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 30 KG',          // Product Name
            Product_Code__c = '000000000005250382',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250382',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 30 KG',     // Product Description
            parent__c = pro.id
        );
        insert proCh;
        
        Product2 pro2 = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 10 KG',          // Product Name
            //RecordTypeId = skuRcdTp.Id,
            Product_Code__c = '000000000005250381',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250381',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 10 KG',     // Product Description
            Parent__c = pro.id
        );
        insert pro2;
        
        Product2 proCh2 = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 40 KG',          // Product Name
            Product_Code__c = '000000000005250383',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250383',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 40 KG',     // Product Description
            parent__c = pro2.id
        );
        insert proCh2;

        ID standardPBID = Test.getStandardPricebookId();
        system.debug('standardPBID ** -' + standardPBID);

        insert new PriceBookEntry(Product2Id=pro.Id, Pricebook2Id=standardPBID, UnitPrice=100, isActive=true);

        Pricebook2 pb = new Pricebook2(
            Name = 'March2022BR0005',                  // Price Book Name
            IsActive = true,                           // Active
            Is_Used_for_Forecast__c = true,            // Is Used for Forecast
            Sales_District__c = region.id,     // Sales District
            Combination_Key__c = 'March2022BR00005',      // Combination Key
            Sales_Org__c = sorg.id,          // Sales Org
            Price_Book_Category__c = 'Forecast',       // Price Book Category
            Type__c = 'Monthly',                       // Type
            Start_Date__c = system.today(),  // Start Date
            Month__c = '03',                           // Month
            End_Date__c = system.today(),   // End Date
            Year__c = '2022'                          // Year
        );
        insert pb;

        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        
        PricebookEntry pbe = new PricebookEntry(
            Product2Id = pro.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'March2022BR00055191000000000005250380'  // Combination Key
        );
        pbeList.add(pbe);
        
        PricebookEntry pbe2 = new PricebookEntry(
            Product2Id = proCh.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'March2022BR00055191000000000005250382'  // Combination Key
        );
        //pbeList.add(pbe2);
        
        PricebookEntry pbe3 = new PricebookEntry(
            Product2Id = pro2.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'March2022BR00055191000000000005250381'  // Combination Key
        );
       // pbeList.add(pbe3);
        
        PricebookEntry pbe4 = new PricebookEntry(
            Product2Id = proCh2.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'March2022BR00055191000000000005250383'  // Combination Key
        );
       // pbeList.add(pbe4);
        
        insert pbeList;
        //insert pbe;

        // Sales Agreement Created for all 12 months
        SalesAgreement sa = new SalesAgreement(
            Status = 'Draft',                                           // Status
            Name = 'SABR114032022',                                       // Name
            StartDate = system.today(),                        // Start Date
            AccountId = acc.id,                                // Account
            ScheduleFrequency = 'Monthly',                                // Schedule Frequency 
            ScheduleCount = 12,                                         // Schedule Count
            EndDate = system.today(),                           // End Date
            PricebookId = pb.id,                              // Price Book
            Region__c = territory.id,                                // Region
            Clone_the_existing_Forecast__c = false,                        // Clone the existing Forecast
            Year__c = '2022',                                             // Year
            Active_Forecast_Month_Number__c = '03',                       // Active Forecast Month (Number)
            Active_Forecast_Month__c = 'March',                             // Active Forecast Month
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
            PricebookEntryId = pbeList[0].id, 
            Last_Consensus__c = 1, 
            Budget_Price__c = 3, 
            Earlier_Planned_Quantity__c = 10
        );
        insert sap;
        
        List<SalesAgreement> saList=new List<SalesAgreement>();
        for(Integer j=1;j<=12;j++){
             String dateStr='01/'+j+'/2022';
            String endDate='02/'+j+'/2022';
            SalesAgreement sAgmt = new SalesAgreement();
            sAgmt.Status = 'Draft';                                           // Status
            sAgmt.Name = 'SABR114032022';                                       // Name
            sAgmt.StartDate = date.parse(dateStr);                        // Start Date
            sAgmt.AccountId = acc.id;                                // Account
            sAgmt.ScheduleFrequency = 'Monthly';                                // Schedule Frequency 
            sAgmt.ScheduleCount = 12;                                         // Schedule Count
            sAgmt.EndDate = date.parse(endDate);                           // End Date
            sAgmt.PricebookId = pb.id;                              // Price Book
            //LastModifiedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),  // Last Modified Date
            //CreatedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),       // Created Date
            sAgmt.Region__c = territory.id;                               // Region
            sAgmt.Clone_the_existing_Forecast__c = true;                        // Clone the existing Forecast
            sAgmt.Year__c = '2022';                                             // Year
            sAgmt.Cloned_from_Sales_Agreement__c = sa.Id;           // Cloned from Sales Agreement
            sAgmt.Active_Forecast_Month_Number__c = '03';                       // Active Forecast Month (Number)
            sAgmt.Active_Forecast_Month__c = 'March';                             // Active Forecast Month
            sAgmt.Sales_Agreement_Schedule_Frequency_Allow__c ='Monthly';
        	saList.add(sAgmt);
        
        }
        insert saList;
        System.debug('saList size :'+saList.size());
        System.debug('saList :'+saList);
        List<SalesAgreementProduct> sapList=new List<SalesAgreementProduct>();
        for(Integer i=0; i<saList.size();i++){
            SalesAgreementProduct sap11 = new SalesAgreementProduct();
            sap11.SalesPrice = 1.00;                                          // Sales Price
            sap11.InitialPlannedQuantity = 1;                                 // Initial Total Quantity
            sap11.DiscountPercentage = 0.00;                                    // Discount Percentage
            sap11.Name = 'Test'; 
            sap11.CurrencyIsoCode = 'USD'; 
            if(i ==0 || i ==1 || i==2){
                sap11.PricebookEntryId = pbeList[0].id; 
            }
            else if(i ==3 || i ==4 || i==5){
                sap11.PricebookEntryId = pbeList[0].id; 
            }
            else if(i ==6 || i ==7 || i==8){
                sap11.PricebookEntryId = pbeList[0].id; 
            }
            else if(i ==9 || i ==10 || i==11){
                sap11.PricebookEntryId = pbeList[0].id; 
            }
            sap11.SalesAgreementId = saList[i].id; 
            
            sap11.Last_Consensus__c = 1; 
            sap11.Budget_Price__c = 3; 
            sap11.Earlier_Planned_Quantity__c = 10;
            sapList.add(sap11);   
        }
        insert sapList;
        //EOC
        List<SKU__c> skuList = new List<SKU__c>();
        SKU__c skuobj = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250380',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250380',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj);
        //insert skuobj;
        
        SKU__c skuobj2 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250381',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250381',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj2);
        //insert skuobj2;
        
        SKU__c skuobj3 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250382',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250382',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj3);
        
        SKU__c skuobj4 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250383',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250383',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj4);
        insert skuList;
        
        Stock_In_Channel__c sic = new Stock_In_Channel__c(
            Channel__c = acc.id,   // Channel
            Combination_Key__c = '0001037362',  // Combination Key
            Enable_Last_Month__c = false,       // Enable Last Month
            Sales_Org__c = sorg.Id,   // Sales Org
            Territory__c = territory.Id,   // Territory
            Year__c = '2022'                   // Year
        );
        insert sic;
        
        List<Stock_In_Channel_Detail__c> sicdList = new List<Stock_In_Channel_Detail__c>();
        Stock_In_Channel_Detail__c sicd = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[0].Id,             // SKU
            June_Volume__c = 600.00,                // June Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            March_Volume__c = 300.00,               // March Volume
            August_Volume__c = 800.00,              // August Volume
            May_Sales__c = 0.00,                    // May Sales
            May_Volume__c = 500.00,                 // May Volume
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            January_Volume__c = 100.00,             // January Volume
            September_Volume__c = 900.00,           // September Volume
            July_Volume__c = 700.00                // July Volume
        );
        sicdList.add(sicd);
        
        Stock_In_Channel_Detail__c sicd2 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[1].Id,             // SKU
            June_Volume__c = 600.00,                // June Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            March_Volume__c = 300.00,               // March Volume
            August_Volume__c = 800.00,              // August Volume
            May_Sales__c = 0.00,                    // May Sales
            May_Volume__c = 500.00,                 // May Volume
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            January_Volume__c = 100.00,             // January Volume
            September_Volume__c = 900.00,           // September Volume
            July_Volume__c = 700.00                // July Volume
        );
        sicdList.add(sicd2);
        
        Stock_In_Channel_Detail__c sicd3 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[2].Id,             // SKU
            June_Volume__c = 600.00,                // June Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            March_Volume__c = 300.00,               // March Volume
            August_Volume__c = 800.00,              // August Volume
            May_Sales__c = 0.00,                    // May Sales
            May_Volume__c = 500.00,                 // May Volume
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            January_Volume__c = 100.00,             // January Volume
            September_Volume__c = 900.00,           // September Volume
            July_Volume__c = 700.00                // July Volume
        );
        sicdList.add(sicd3);
        
        Stock_In_Channel_Detail__c sicd4 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[3].Id,             // SKU
            June_Volume__c = 600.00,                // June Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            March_Volume__c = 300.00,               // March Volume
            August_Volume__c = 800.00,              // August Volume
            May_Sales__c = 0.00,                    // May Sales
            May_Volume__c = 500.00,                 // May Volume
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            January_Volume__c = 100.00,             // January Volume
            September_Volume__c = 900.00,           // September Volume
            July_Volume__c = 700.00                // July Volume
        );
        sicdList.add(sicd4);
        insert sicdList;
        
        List<BW_Data__c> bwList = new List<BW_Data__c>();
        
        BW_Data__c sobj = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[0].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022003',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj2 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[0].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022003',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        

        BW_Data__c sobj3 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[1].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022003',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj4 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[1].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022003',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj5 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[2].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022003',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
       
        
        BW_Data__c sobj6 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[2].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022003',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        

        BW_Data__c sobj7 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[3].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2021',            // Fiscal Year
            Fiscal_Year_Period__c = '2021002',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj8 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[3].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2020',            // Fiscal Year
            Fiscal_Year_Period__c = '2021002',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        bwList.add(sobj);
        bwList.add(sobj2);
        bwList.add(sobj3);
        bwList.add(sobj4);
        bwList.add(sobj5);
        bwList.add(sobj6);
        bwList.add(sobj7);
        bwList.add(sobj8);
        insert bwList;
        
        List<Account_Target__c> atList = new List<Account_Target__c>();
        Account_Target__c at1 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '3',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = pro.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503802022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at1);
        
        Account_Target__c at2 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '3',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = proCh.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503822022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at2);
        
        Account_Target__c at3 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '3',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = pro2.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503812022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at3);
        
        Account_Target__c at4 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '3',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = proCh2.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503832022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at4);
        
        insert atList;
        
        List<Open_Order__c> ooList=new List<Open_Order__c>();
        for(Integer i=1;i<=12;i++){
            String dateStr='01/'+i+'/2023';
            Open_Order__c oo = new Open_Order__c();
            //oo.Business_Unit__c = 'a1M0k000000404k';               // Business Unit
            oo.Customer__c = acc.id;                      // Customer
            oo.Region__c = territory.Id;                        // Region
            if(i==1 || i==2 || i==3){
                oo.Product__c = skuList[0].Id;                       // Product
            }
            else if(i==4 || i==5 || i==6){
                oo.Product__c = skuList[1].Id;                       // Product
            }
            else if(i==7 || i==8 || i==9){
                oo.Product__c = skuList[2].Id;                       // Product
            }
            else if(i==10 || i==11 || i==12){
                oo.Product__c = skuList[3].Id;                       // Product
            }
            
            oo.Data_de_Faturamento__c = date.parse(dateStr);  // Data de Faturamento
            oo.Qty_ORD__c = 20;                                    // Qty ORD
            oo.Net_Sales_ORD__c = 900.00;                            // Net Sales ORD
        	ooList.add(oo);
        }
        for(Integer i=1;i<=12;i++){
            String dateStr='01/'+i+'/2021';
            Open_Order__c oo = new Open_Order__c();
            //oo.Business_Unit__c = 'a1M0k000000404k';               // Business Unit
            oo.Customer__c = acc.id;                      // Customer
            oo.Region__c = territory.Id;                        // Region
            if(i==1 || i==2 || i==3){
                oo.Product__c = skuList[0].Id;                       // Product
            }
            else if(i==4 || i==5 || i==6){
                oo.Product__c = skuList[1].Id;                       // Product
            }
            else if(i==7 || i==8 || i==9){
                oo.Product__c = skuList[2].Id;                       // Product
            }
            else if(i==10 || i==11 || i==12){
                oo.Product__c = skuList[3].Id;                       // Product
            }
            oo.Data_de_Faturamento__c = date.parse(dateStr);  // Data de Faturamento
            oo.Qty_ORD__c = 20;                                    // Qty ORD
            oo.Net_Sales_ORD__c = 900.00;                            // Net Sales ORD
        	ooList.add(oo);
        }
        insert ooList;
        
        Open_Order__c oo3 = new Open_Order__c(
            //Business_Unit__c = 'a1M0k000000404k',               // Business Unit
            Customer__c = acc.id,                      // Customer
            Region__c = territory.Id,                        // Region
            Product__c = skuList[3].Id,                       // Product
            Data_de_Faturamento__c = date.parse('01/1/2022'),  // Data de Faturamento
            Qty_ORD__c = 20,                                    // Qty ORD
            Net_Sales_ORD__c = 900.00                            // Net Sales ORD
        );
        insert oo3;
        
        Open_Order__c oo4 = new Open_Order__c(
            //Business_Unit__c = 'a1M0k000000404k',               // Business Unit
            Customer__c = acc.id,                      // Customer
            Region__c = territory.Id,                        // Region
            Product__c = skuList[0].Id,                       // Product
            Data_de_Faturamento__c = date.parse('01/1/2021'),  // Data de Faturamento
            Qty_ORD__c = 20,                                    // Qty ORD
            Net_Sales_ORD__c = 900.00                            // Net Sales ORD
        );
        insert oo4;
        
        test.startTest();
        List<SalesAgreementProduct> sapListT=[select Id, SalesAgreement.Account.SAP_Code__c,PricebookEntry.Product2.Product_code__c,
                                                                                               SalesAgreement.Region__r.TerritoryCode__c,SalesAgreement.Sale_Org_Code__c,
                                                                                               SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreement.Year__c from SalesAgreementProduct limit 1];
        List<SalesAgreementProductSchedule> sapsListT=[Select id,Name,Combination_Key__c,SalesAgreementProductId from SalesAgreementProductSchedule where SalesAgreementProductId=:sapListT[0].Id limit 1];
        System.debug('sapsListT :'+sapsListT);
        UpdatePOGMetricsHandler.insertCombinationKey(sapsListT);
        
        List<SalesAgreementProductSchedule> sapsList=[Select id,Name,SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c,SalesAgreementProduct.PricebookEntry.Product2.Product_code__c,
                                                                                                       SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c,SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c,
                                                                                                       SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreementProduct.SalesAgreement.Year__c,Combination_Key__c,SalesAgreementProductId,Is_Update_Metrics__c from SalesAgreementProductSchedule];
            System.debug('sapsList test :'+sapsList.size());
        	Map<String,SalesAgreementProductSchedule> maptest = new Map<String,SalesAgreementProductSchedule>();
            for(SalesAgreementProductSchedule sapT:sapsList){
                String combinationKey='';
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Year__c;
                            combinationKey+=sapT.SalesAgreementProduct.PricebookEntry.Product2.Product_code__c;
                            //if(String.isNotBlank(combinationKey)){
                                sapT.Combination_Key__c=combinationKey+sapT.Name;
                            //} 
                sapT.Is_Update_Metrics__c=true;
                if(!maptest.containsKey(sapT.Combination_Key__c)){
                      maptest.put(sapT.Combination_Key__c,sapT);  
                }
            }
        
        System.debug('sapsList test 2 :'+JSON.serializePretty(maptest.values()));
          	update maptest.values();  
            UpdatePOGMetricsHandler.updateMethod(sapsList);
        
        test.stopTest();
        
    }
    
    /*static testMethod void test(){
        test.startTest();
        List<SalesAgreementProduct> sapList=[select Id, SalesAgreement.Account.SAP_Code__c,PricebookEntry.Product2.Product_code__c,
                                                                                               SalesAgreement.Region__r.TerritoryCode__c,SalesAgreement.Sale_Org_Code__c,
                                                                                               SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreement.Year__c from SalesAgreementProduct limit 1];
        List<SalesAgreementProductSchedule> sapsList=[Select id,Name,Combination_Key__c,SalesAgreementProductId from SalesAgreementProductSchedule where SalesAgreementProductId=:sapList[0].Id limit 1];
        System.debug('sapsList :'+sapsList);
        UpdatePOGMetricsHandler.insertCombinationKey(sapsList);
        
        test.stopTest();
    }
    static testMethod void test2(){
        test.startTest();
        
        try{
            List<SalesAgreementProduct> sapList=[select Id, SalesAgreement.Account.SAP_Code__c,PricebookEntry.Product2.Product_code__c,
                                                 SalesAgreement.Region__r.TerritoryCode__c,SalesAgreement.Sale_Org_Code__c,
                                                 SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreement.Year__c from SalesAgreementProduct];
            System.debug('sapList test :'+sapList);
            List<SalesAgreementProductSchedule> sapsList=[Select id,Name,SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c,SalesAgreementProduct.PricebookEntry.Product2.Product_code__c,
                                                                                                       SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c,SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c,
                                                                                                       SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreementProduct.SalesAgreement.Year__c,Combination_Key__c,SalesAgreementProductId,Is_Update_Metrics__c from SalesAgreementProductSchedule];
            System.debug('sapsList test :'+sapsList);
            for(SalesAgreementProductSchedule sap:sapsList){
                String combinationKey='';
                            combinationKey+=sap.SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c;
                            combinationKey+=sap.SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c;
                            combinationKey+=sap.SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c;
                            combinationKey+=sap.SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c;
                            combinationKey+=sap.SalesAgreementProduct.SalesAgreement.Year__c;
                            combinationKey+=sap.SalesAgreementProduct.PricebookEntry.Product2.Product_code__c;
                            //if(String.isNotBlank(combinationKey)){
                                sap.Combination_Key__c=combinationKey+sap.Name;
                            //} 
                sap.Is_Update_Metrics__c=true;
            }
          	update sapsList;  
            UpdatePOGMetricsHandler.updateMethod(sapsList);
        }catch(Exception e){
            System.debug(e);
        }
        test.stopTest();
    }*/
    
    static testMethod void allTheDataForThisTestClass2() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Description__c='Brazil';
        sorg.Sales_Org_Code__c='5191';
        sorg.Is_Active_Forecast__c = true;
        insert sorg;
        system.debug('Test Class Data - Sales Org **** -' + sorg);
        /* Report report = new Report(
            FolderName = 'Brazil Reports',
            Name = 'Sales Agreement (Forecast)'
        );
        insert report; */

        RecordType depoRcdTp = [SELECT Id FROM RecordType WHERE name = 'Depot' and isActive = true LIMIT 1];

        Account acc = new Account(
            Name = 'MAURICIO BERNARDO SCHOLTEN E OUTROS [View Hierarchy]',// Account Name
            SAP_Code__c = '0001419272',                                     // SAP Customer Code
            Mobile__c = '000000000000000000',                               // Mobile
            Email__c = 'mauri@xxx2.com',                            // Email
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
        user.Alias = 'zonaa2';                                                            
        user.Email = 'skim@skinternational1232.com';                             
        user.ProfileId  = p.ID;                                                     
        user.Username = 'zonal_aaexe1232@upl1223332.com.devbox';                                    
        user.IsActive = true;  
        user.LastName='Terriotory Manager';
        user.CommunityNickname = 'zonalExe12222 Di'; 
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
        brzlU.Alias = 'zonaa22';                                                            
        brzlU.Email = 'sk@skinternational2.com';                             
        brzlU.ProfileId  = p.ID;                                                     
        brzlU.Username = 'zonal7_aaexe1232@upl12233322.com.devbox1';                                    
        brzlU.IsActive = true;  
        brzlU.LastName='TM';
        brzlU.CommunityNickname = 'zonal7Exe122222 Di'; 
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
            Active_Forecast_Month__c = 'May',                         // Active Forecast Month
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
        system.debug('Test Class Data - sfs **** -' + sfs);

        Zone__c zone =  new Zone__c();
        zone.SalesOrg__c = sorg.Id;
        zone.Name = 'BU MATO GROSSO2';
        zone.ZoneCode__c = 'BR002';              
        zone.ZonalHead__c = user.Id;
        //  zone.SBU_Code__c = sbu.Id;
        insert zone;

        Region__c region = new Region__c();
        region.Name = 'MATO GROSSO DO SUL2';
        region.RegionCode__c =  'BR0002';
        region.SalesOrg__c = sorg.Id;
        region.Zone__c = zone.Id;
        region.RegionHead__c = user.Id;
        region.BrazilAnalyst__c = brzlU.Id;   
        region.Batch_Number__c='Batch 1';
       // region.SBU__c = sbu.Id;                                                                           
        insert region;

        system.debug('Test Class Data - region **** -' + region);

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

        Customer_and_Region_Mapping__c crm = new Customer_and_Region_Mapping__c(
            Customer_Name__c = acc.id,// Customer Name
            Active__c = true,                      // Active
            CustomerRegion__c = territory.Id,
            Distribution_Channel__c = disbj.id,
            Division__c = div.id,
            Sales_Org__c = sorg.id
        );
        insert crm;
        
        Forecast_Account__c fa = new Forecast_Account__c(
            Account__c = acc.id,
            Territory__c = territory.id,
            Combination_Key__c = territory.TerritoryCode__c+acc.SAP_Code__c,
            OwnerId = user.id,
            Dummy_Customer__c =false
        );
        insert fa;

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
        
        Product2 proCh = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 30 KG',          // Product Name
            Product_Code__c = '000000000005250382',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250382',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 30 KG',     // Product Description
            parent__c = pro.id
        );
        insert proCh;
        
        Product2 pro2 = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 10 KG',          // Product Name
            //RecordTypeId = skuRcdTp.Id,
            Product_Code__c = '000000000005250381',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250381',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 10 KG',     // Product Description
            Parent__c = pro.id
        );
        insert pro2;
        
        Product2 proCh2 = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 40 KG',          // Product Name
            Product_Code__c = '000000000005250383',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250383',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 40 KG',     // Product Description
            parent__c = pro2.id
        );
        insert proCh2;

        ID standardPBID = Test.getStandardPricebookId();
        system.debug('standardPBID ** -' + standardPBID);

        insert new PriceBookEntry(Product2Id=pro.Id, Pricebook2Id=standardPBID, UnitPrice=100, isActive=true);

        Pricebook2 pb = new Pricebook2(
            Name = 'May2022BR0005',                  // Price Book Name
            IsActive = true,                           // Active
            Is_Used_for_Forecast__c = true,            // Is Used for Forecast
            Sales_District__c = region.id,     // Sales District
            Combination_Key__c = 'May2022BR00005',      // Combination Key
            Sales_Org__c = sorg.id,          // Sales Org
            Price_Book_Category__c = 'Forecast',       // Price Book Category
            Type__c = 'Monthly',                       // Type
            Start_Date__c = system.today(),  // Start Date
            Month__c = '05',                           // Month
            End_Date__c = system.today(),   // End Date
            Year__c = '2022'                          // Year
        );
        insert pb;

        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        
        PricebookEntry pbe = new PricebookEntry(
            Product2Id = pro.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'May2022BR00055191000000000005250380'  // Combination Key
        );
        pbeList.add(pbe);
        
        PricebookEntry pbe2 = new PricebookEntry(
            Product2Id = proCh.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'May2022BR00055191000000000005250382'  // Combination Key
        );
        //pbeList.add(pbe2);
        
        PricebookEntry pbe3 = new PricebookEntry(
            Product2Id = pro2.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'May2022BR00055191000000000005250381'  // Combination Key
        );
       // pbeList.add(pbe3);
        
        PricebookEntry pbe4 = new PricebookEntry(
            Product2Id = proCh2.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'May2022BR00055191000000000005250383'  // Combination Key
        );
       // pbeList.add(pbe4);
        
        insert pbeList;
        //insert pbe;

        // Sales Agreement Created for all 12 months
        SalesAgreement sa = new SalesAgreement(
            Status = 'Draft',                                           // Status
            Name = 'SABR114052022',                                       // Name
            StartDate = system.today(),                        // Start Date
            AccountId = acc.id,                                // Account
            ScheduleFrequency = 'Monthly',                                // Schedule Frequency 
            ScheduleCount = 12,                                         // Schedule Count
            EndDate = system.today(),                           // End Date
            PricebookId = pb.id,                              // Price Book
            Region__c = territory.id,                                // Region
            Clone_the_existing_Forecast__c = false,                        // Clone the existing Forecast
            Year__c = '2022',                                             // Year
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
            PricebookEntryId = pbeList[0].id, 
            Last_Consensus__c = 1, 
            Budget_Price__c = 3, 
            Earlier_Planned_Quantity__c = 10
        );
        insert sap;
        
        List<SalesAgreement> saList=new List<SalesAgreement>();
        for(Integer j=1;j<=12;j++){
             String dateStr='01/'+j+'/2022';
            String endDate='02/'+j+'/2022';
            SalesAgreement sAgmt = new SalesAgreement();
            sAgmt.Status = 'Draft';                                           // Status
            sAgmt.Name = 'SABR114032022';                                       // Name
            sAgmt.StartDate = date.parse(dateStr);                        // Start Date
            sAgmt.AccountId = acc.id;                                // Account
            sAgmt.ScheduleFrequency = 'Monthly';                                // Schedule Frequency 
            sAgmt.ScheduleCount = 12;                                         // Schedule Count
            sAgmt.EndDate = date.parse(endDate);                           // End Date
            sAgmt.PricebookId = pb.id;                              // Price Book
            //LastModifiedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),  // Last Modified Date
            //CreatedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),       // Created Date
            sAgmt.Region__c = territory.id;                               // Region
            sAgmt.Clone_the_existing_Forecast__c = true;                        // Clone the existing Forecast
            sAgmt.Year__c = '2022';                                             // Year
            sAgmt.Cloned_from_Sales_Agreement__c = sa.Id;           // Cloned from Sales Agreement
            sAgmt.Active_Forecast_Month_Number__c = '05';                       // Active Forecast Month (Number)
            sAgmt.Active_Forecast_Month__c = 'May';                             // Active Forecast Month
            sAgmt.Sales_Agreement_Schedule_Frequency_Allow__c ='Monthly';
        	saList.add(sAgmt);
        
        }
        insert saList;
        System.debug('saList size :'+saList.size());
        System.debug('saList :'+saList);
        List<SalesAgreementProduct> sapList=new List<SalesAgreementProduct>();
        for(Integer i=0; i<saList.size();i++){
            SalesAgreementProduct sap11 = new SalesAgreementProduct();
            sap11.SalesPrice = 1.00;                                          // Sales Price
            sap11.InitialPlannedQuantity = 1;                                 // Initial Total Quantity
            sap11.DiscountPercentage = 0.00;                                    // Discount Percentage
            sap11.Name = 'Test'; 
            sap11.CurrencyIsoCode = 'USD'; 
            if(i ==0 || i ==1 || i==2){
                sap11.PricebookEntryId = pbeList[0].id; 
            }
            else if(i ==3 || i ==4 || i==5){
                sap11.PricebookEntryId = pbeList[0].id; 
            }
            else if(i ==6 || i ==7 || i==8){
                sap11.PricebookEntryId = pbeList[0].id; 
            }
            else if(i ==9 || i ==10 || i==11){
                sap11.PricebookEntryId = pbeList[0].id; 
            }
            sap11.SalesAgreementId = saList[i].id; 
            
            sap11.Last_Consensus__c = 1; 
            sap11.Budget_Price__c = 3; 
            sap11.Earlier_Planned_Quantity__c = 10;
            sapList.add(sap11);   
        }
        insert sapList;
        //EOC
        List<SKU__c> skuList = new List<SKU__c>();
        SKU__c skuobj = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250380',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250380',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj);
        //insert skuobj;
        
        SKU__c skuobj2 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250381',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250381',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj2);
        //insert skuobj2;
        
        SKU__c skuobj3 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250382',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250382',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj3);
        
        SKU__c skuobj4 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250383',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250383',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj4);
        insert skuList;
        
        Stock_In_Channel__c sic = new Stock_In_Channel__c(
            Channel__c = acc.id,   // Channel
            Combination_Key__c = '0001037362',  // Combination Key
            Enable_Last_Month__c = false,       // Enable Last Month
            Sales_Org__c = sorg.Id,   // Sales Org
            Territory__c = territory.Id,   // Territory
            Year__c = '2022'                   // Year
        );
        insert sic;
        
        List<Stock_In_Channel_Detail__c> sicdList = new List<Stock_In_Channel_Detail__c>();
        Stock_In_Channel_Detail__c sicd = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[0].Id,             // SKU
            June_Volume__c = 600.00,                // June Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            May_Sales__c = 0.00,                    // May Sales
            May_Volume__c = 500.00,                 // May Volume
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            January_Volume__c = 100.00,             // January Volume
            September_Volume__c = 900.00,           // September Volume
            July_Volume__c = 700.00                // July Volume
        );
        sicdList.add(sicd);
        
        Stock_In_Channel_Detail__c sicd2 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[1].Id,             // SKU
            June_Volume__c = 600.00,                // June Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            May_Volume__c = 300.00,               // May Volume
            August_Volume__c = 800.00,              // August Volume
            May_Sales__c = 0.00,                    // May Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            January_Volume__c = 100.00,             // January Volume
            September_Volume__c = 900.00,           // September Volume
            July_Volume__c = 700.00                // July Volume
        );
        sicdList.add(sicd2);
        
        Stock_In_Channel_Detail__c sicd3 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[2].Id,             // SKU
            June_Volume__c = 600.00,                // June Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            May_Volume__c = 300.00,               // May Volume
            August_Volume__c = 800.00,              // August Volume
            May_Sales__c = 0.00,                    // May Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            January_Volume__c = 100.00,             // January Volume
            September_Volume__c = 900.00,           // September Volume
            July_Volume__c = 700.00                // July Volume
        );
        sicdList.add(sicd3);
        
        Stock_In_Channel_Detail__c sicd4 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[3].Id,             // SKU
            June_Volume__c = 600.00,                // June Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            May_Volume__c = 300.00,               // May Volume
            August_Volume__c = 800.00,              // August Volume
            May_Sales__c = 0.00,                    // May Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            January_Volume__c = 100.00,             // January Volume
            September_Volume__c = 900.00,           // September Volume
            July_Volume__c = 700.00                // July Volume
        );
        sicdList.add(sicd4);
        insert sicdList;
        
        List<BW_Data__c> bwList = new List<BW_Data__c>();
        
        BW_Data__c sobj = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[0].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022005',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj2 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[0].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022005',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        

        BW_Data__c sobj3 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[1].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022005',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj4 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[1].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022005',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj5 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[2].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022005',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
       
        
        BW_Data__c sobj6 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[2].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022005',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        

        BW_Data__c sobj7 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[3].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2021',            // Fiscal Year
            Fiscal_Year_Period__c = '2021006',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj8 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[3].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2020',            // Fiscal Year
            Fiscal_Year_Period__c = '2021005',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        bwList.add(sobj);
        bwList.add(sobj2);
        bwList.add(sobj3);
        bwList.add(sobj4);
        bwList.add(sobj5);
        bwList.add(sobj6);
        bwList.add(sobj7);
        bwList.add(sobj8);
        insert bwList;
        
        List<Account_Target__c> atList = new List<Account_Target__c>();
        Account_Target__c at1 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '5',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = pro.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503802022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at1);
        
        Account_Target__c at2 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '5',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = proCh.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503822022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at2);
        
        Account_Target__c at3 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '5',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = pro2.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503812022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at3);
        
        Account_Target__c at4 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '5',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = proCh2.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503832022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at4);
        
        insert atList;
        
        List<Open_Order__c> ooList=new List<Open_Order__c>();
        for(Integer i=1;i<=12;i++){
            String dateStr='01/'+i+'/2023';
            Open_Order__c oo = new Open_Order__c();
            //oo.Business_Unit__c = 'a1M0k000000404k';               // Business Unit
            oo.Customer__c = acc.id;                      // Customer
            oo.Region__c = territory.Id;                        // Region
            if(i==1 || i==2 || i==3){
                oo.Product__c = skuList[0].Id;                       // Product
            }
            else if(i==4 || i==5 || i==6){
                oo.Product__c = skuList[1].Id;                       // Product
            }
            else if(i==7 || i==8 || i==9){
                oo.Product__c = skuList[2].Id;                       // Product
            }
            else if(i==10 || i==11 || i==12){
                oo.Product__c = skuList[3].Id;                       // Product
            }
            
            oo.Data_de_Faturamento__c = date.parse(dateStr);  // Data de Faturamento
            oo.Qty_ORD__c = 20;                                    // Qty ORD
            oo.Net_Sales_ORD__c = 900.00;                            // Net Sales ORD
        	ooList.add(oo);
        }
        for(Integer i=1;i<=12;i++){
            String dateStr='01/'+i+'/2021';
            Open_Order__c oo = new Open_Order__c();
            //oo.Business_Unit__c = 'a1M0k000000404k';               // Business Unit
            oo.Customer__c = acc.id;                      // Customer
            oo.Region__c = territory.Id;                        // Region
            if(i==1 || i==2 || i==3){
                oo.Product__c = skuList[0].Id;                       // Product
            }
            else if(i==4 || i==5 || i==6){
                oo.Product__c = skuList[1].Id;                       // Product
            }
            else if(i==7 || i==8 || i==9){
                oo.Product__c = skuList[2].Id;                       // Product
            }
            else if(i==10 || i==11 || i==12){
                oo.Product__c = skuList[3].Id;                       // Product
            }
            oo.Data_de_Faturamento__c = date.parse(dateStr);  // Data de Faturamento
            oo.Qty_ORD__c = 20;                                    // Qty ORD
            oo.Net_Sales_ORD__c = 900.00;                            // Net Sales ORD
        	ooList.add(oo);
        }
        insert ooList;
        
        Open_Order__c oo3 = new Open_Order__c(
            //Business_Unit__c = 'a1M0k000000404k',               // Business Unit
            Customer__c = acc.id,                      // Customer
            Region__c = territory.Id,                        // Region
            Product__c = skuList[3].Id,                       // Product
            Data_de_Faturamento__c = date.parse('01/1/2022'),  // Data de Faturamento
            Qty_ORD__c = 20,                                    // Qty ORD
            Net_Sales_ORD__c = 900.00                            // Net Sales ORD
        );
        insert oo3;
        
        Open_Order__c oo4 = new Open_Order__c(
            //Business_Unit__c = 'a1M0k000000404k',               // Business Unit
            Customer__c = acc.id,                      // Customer
            Region__c = territory.Id,                        // Region
            Product__c = skuList[0].Id,                       // Product
            Data_de_Faturamento__c = date.parse('01/1/2021'),  // Data de Faturamento
            Qty_ORD__c = 20,                                    // Qty ORD
            Net_Sales_ORD__c = 900.00                            // Net Sales ORD
        );
        insert oo4;
        
        test.startTest();
        List<SalesAgreementProduct> sapListT=[select Id, SalesAgreement.Account.SAP_Code__c,PricebookEntry.Product2.Product_code__c,
                                                                                               SalesAgreement.Region__r.TerritoryCode__c,SalesAgreement.Sale_Org_Code__c,
                                                                                               SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreement.Year__c from SalesAgreementProduct limit 1];
        List<SalesAgreementProductSchedule> sapsListT=[Select id,Name,Combination_Key__c,SalesAgreementProductId from SalesAgreementProductSchedule where SalesAgreementProductId=:sapListT[0].Id limit 1];
        System.debug('sapsListT :'+sapsListT);
        UpdatePOGMetricsHandler.insertCombinationKey(sapsListT);
        
        List<SalesAgreementProductSchedule> sapsList=[Select id,Name,SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c,SalesAgreementProduct.PricebookEntry.Product2.Product_code__c,
                                                                                                       SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c,SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c,
                                                                                                       SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreementProduct.SalesAgreement.Year__c,Combination_Key__c,SalesAgreementProductId,Is_Update_Metrics__c from SalesAgreementProductSchedule];
            System.debug('sapsList test :'+sapsList.size());
        	Map<String,SalesAgreementProductSchedule> maptest = new Map<String,SalesAgreementProductSchedule>();
            for(SalesAgreementProductSchedule sapT:sapsList){
                String combinationKey='';
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Year__c;
                            combinationKey+=sapT.SalesAgreementProduct.PricebookEntry.Product2.Product_code__c;
                            //if(String.isNotBlank(combinationKey)){
                                sapT.Combination_Key__c=combinationKey+sapT.Name;
                            //} 
                sapT.Is_Update_Metrics__c=true;
                if(!maptest.containsKey(sapT.Combination_Key__c)){
                      maptest.put(sapT.Combination_Key__c,sapT);  
                }
            }
        
        System.debug('sapsList test 2 :'+JSON.serializePretty(maptest.values()));
          	update maptest.values();  
            UpdatePOGMetricsHandler.updateMethod(sapsList);
        
        test.stopTest();
        
    }
    
    static testMethod void allTheDataForThisTestClass3() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Description__c='Brazil';
        sorg.Sales_Org_Code__c='5191';
        sorg.Is_Active_Forecast__c = true;
        insert sorg;
        system.debug('Test Class Data - Sales Org **** -' + sorg);
        /* Report report = new Report(
            FolderName = 'Brazil Reports',
            Name = 'Sales Agreement (Forecast)'
        );
        insert report; */

        RecordType depoRcdTp = [SELECT Id FROM RecordType WHERE name = 'Depot' and isActive = true LIMIT 1];

        Account acc = new Account(
            Name = 'MAURICIO BERNARDO SCHOLTEN E OUTROS [View Hierarchy]',// Account Name
            SAP_Code__c = '0001419272',                                     // SAP Customer Code
            Mobile__c = '000000000000000000',                               // Mobile
            Email__c = 'mauri@xxx2.com',                            // Email
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
        user.Alias = 'zonaa2';                                                            
        user.Email = 'skim@skinternational1232.com';                             
        user.ProfileId  = p.ID;                                                     
        user.Username = 'zonal_aaexe1232@upl1223332.com.devbox';                                    
        user.IsActive = true;  
        user.LastName='Terriotory Manager';
        user.CommunityNickname = 'zonalExe12222 Di'; 
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
        brzlU.Alias = 'zonaa22';                                                            
        brzlU.Email = 'sk@skinternational2.com';                             
        brzlU.ProfileId  = p.ID;                                                     
        brzlU.Username = 'zonal7_aaexe1232@upl12233322.com.devbox1';                                    
        brzlU.IsActive = true;  
        brzlU.LastName='TM';
        brzlU.CommunityNickname = 'zonal7Exe122222 Di'; 
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
            Active_Forecast_Month__c = 'June',                         // Active Forecast Month
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
        system.debug('Test Class Data - sfs **** -' + sfs);

        Zone__c zone =  new Zone__c();
        zone.SalesOrg__c = sorg.Id;
        zone.Name = 'BU MATO GROSSO2';
        zone.ZoneCode__c = 'BR002';              
        zone.ZonalHead__c = user.Id;
        //  zone.SBU_Code__c = sbu.Id;
        insert zone;

        Region__c region = new Region__c();
        region.Name = 'MATO GROSSO DO SUL2';
        region.RegionCode__c =  'BR0002';
        region.SalesOrg__c = sorg.Id;
        region.Zone__c = zone.Id;
        region.RegionHead__c = user.Id;
        region.BrazilAnalyst__c = brzlU.Id;   
        region.Batch_Number__c='Batch 1';
       // region.SBU__c = sbu.Id;                                                                           
        insert region;

        system.debug('Test Class Data - region **** -' + region);

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

        Customer_and_Region_Mapping__c crm = new Customer_and_Region_Mapping__c(
            Customer_Name__c = acc.id,// Customer Name
            Active__c = true,                      // Active
            CustomerRegion__c = territory.Id,
            Distribution_Channel__c = disbj.id,
            Division__c = div.id,
            Sales_Org__c = sorg.id
        );
        insert crm;
        
        Forecast_Account__c fa = new Forecast_Account__c(
            Account__c = acc.id,
            Territory__c = territory.id,
            Combination_Key__c = territory.TerritoryCode__c+acc.SAP_Code__c,
            OwnerId = user.id,
            Dummy_Customer__c =false
        );
        insert fa;

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
        
        Product2 proCh = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 30 KG',          // Product Name
            Product_Code__c = '000000000005250382',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250382',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 30 KG',     // Product Description
            parent__c = pro.id
        );
        insert proCh;
        
        Product2 pro2 = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 10 KG',          // Product Name
            //RecordTypeId = skuRcdTp.Id,
            Product_Code__c = '000000000005250381',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250381',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 10 KG',     // Product Description
            Parent__c = pro.id
        );
        insert pro2;
        
        Product2 proCh2 = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 40 KG',          // Product Name
            Product_Code__c = '000000000005250383',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250383',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 40 KG',     // Product Description
            parent__c = pro2.id
        );
        insert proCh2;

        ID standardPBID = Test.getStandardPricebookId();
        system.debug('standardPBID ** -' + standardPBID);

        insert new PriceBookEntry(Product2Id=pro.Id, Pricebook2Id=standardPBID, UnitPrice=100, isActive=true);

        Pricebook2 pb = new Pricebook2(
            Name = 'June2022BR0005',                  // Price Book Name
            IsActive = true,                           // Active
            Is_Used_for_Forecast__c = true,            // Is Used for Forecast
            Sales_District__c = region.id,     // Sales District
            Combination_Key__c = 'June2022BR00005',      // Combination Key
            Sales_Org__c = sorg.id,          // Sales Org
            Price_Book_Category__c = 'Forecast',       // Price Book Category
            Type__c = 'Monthly',                       // Type
            Start_Date__c = system.today(),  // Start Date
            Month__c = '06',                           // Month
            End_Date__c = system.today(),   // End Date
            Year__c = '2022'                          // Year
        );
        insert pb;

        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        
        PricebookEntry pbe = new PricebookEntry(
            Product2Id = pro.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'June2022BR00055191000000000005250380'  // Combination Key
        );
        pbeList.add(pbe);
        
        PricebookEntry pbe2 = new PricebookEntry(
            Product2Id = proCh.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'June2022BR00055191000000000005250382'  // Combination Key
        );
        //pbeList.add(pbe2);
        
        PricebookEntry pbe3 = new PricebookEntry(
            Product2Id = pro2.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'June2022BR00055191000000000005250381'  // Combination Key
        );
       // pbeList.add(pbe3);
        
        PricebookEntry pbe4 = new PricebookEntry(
            Product2Id = proCh2.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'June2022BR00055191000000000005250383'  // Combination Key
        );
       // pbeList.add(pbe4);
        
        insert pbeList;
        //insert pbe;

        // Sales Agreement Created for all 12 months
        SalesAgreement sa = new SalesAgreement(
            Status = 'Draft',                                           // Status
            Name = 'SABR114052022',                                       // Name
            StartDate = system.today(),                        // Start Date
            AccountId = acc.id,                                // Account
            ScheduleFrequency = 'Monthly',                                // Schedule Frequency 
            ScheduleCount = 12,                                         // Schedule Count
            EndDate = system.today(),                           // End Date
            PricebookId = pb.id,                              // Price Book
            Region__c = territory.id,                                // Region
            Clone_the_existing_Forecast__c = false,                        // Clone the existing Forecast
            Year__c = '2022',                                             // Year
            Active_Forecast_Month_Number__c = '06',                       // Active Forecast Month (Number)
            Active_Forecast_Month__c = 'June',                             // Active Forecast Month
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
            PricebookEntryId = pbeList[0].id, 
            Last_Consensus__c = 1, 
            Budget_Price__c = 3, 
            Earlier_Planned_Quantity__c = 10
        );
        insert sap;
        
        List<SalesAgreement> saList=new List<SalesAgreement>();
        for(Integer j=1;j<=12;j++){
             String dateStr='01/'+j+'/2022';
            String endDate='02/'+j+'/2022';
            SalesAgreement sAgmt = new SalesAgreement();
            sAgmt.Status = 'Draft';                                           // Status
            sAgmt.Name = 'SABR114032022';                                       // Name
            sAgmt.StartDate = date.parse(dateStr);                        // Start Date
            sAgmt.AccountId = acc.id;                                // Account
            sAgmt.ScheduleFrequency = 'Monthly';                                // Schedule Frequency 
            sAgmt.ScheduleCount = 12;                                         // Schedule Count
            sAgmt.EndDate = date.parse(endDate);                           // End Date
            sAgmt.PricebookId = pb.id;                              // Price Book
            //LastModifiedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),  // Last Modified Date
            //CreatedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),       // Created Date
            sAgmt.Region__c = territory.id;                               // Region
            sAgmt.Clone_the_existing_Forecast__c = true;                        // Clone the existing Forecast
            sAgmt.Year__c = '2022';                                             // Year
            sAgmt.Cloned_from_Sales_Agreement__c = sa.Id;           // Cloned from Sales Agreement
            sAgmt.Active_Forecast_Month_Number__c = '06';                       // Active Forecast Month (Number)
            sAgmt.Active_Forecast_Month__c = 'June';                             // Active Forecast Month
            sAgmt.Sales_Agreement_Schedule_Frequency_Allow__c ='Monthly';
        	saList.add(sAgmt);
        
        }
        insert saList;
        System.debug('saList size :'+saList.size());
        System.debug('saList :'+saList);
        List<SalesAgreementProduct> sapList=new List<SalesAgreementProduct>();
        for(Integer i=0; i<saList.size();i++){
            SalesAgreementProduct sap11 = new SalesAgreementProduct();
            sap11.SalesPrice = 1.00;                                          // Sales Price
            sap11.InitialPlannedQuantity = 1;                                 // Initial Total Quantity
            sap11.DiscountPercentage = 0.00;                                    // Discount Percentage
            sap11.Name = 'Test'; 
            sap11.CurrencyIsoCode = 'USD'; 
            sap11.PricebookEntryId = pbeList[0].id; 
            sap11.SalesAgreementId = saList[i].id; 
            sap11.Last_Consensus__c = 1; 
            sap11.Budget_Price__c = 3; 
            sap11.Earlier_Planned_Quantity__c = 10;
            sapList.add(sap11);   
        }
        insert sapList;
        //EOC
        List<SKU__c> skuList = new List<SKU__c>();
        SKU__c skuobj = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250380',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250380',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj);
        //insert skuobj;
        
        SKU__c skuobj2 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250381',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250381',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj2);
        //insert skuobj2;
        
        SKU__c skuobj3 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250382',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250382',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj3);
        
        SKU__c skuobj4 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250383',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250383',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj4);
        insert skuList;
        
        Stock_In_Channel__c sic = new Stock_In_Channel__c(
            Channel__c = acc.id,   // Channel
            Combination_Key__c = '0001037362',  // Combination Key
            Enable_Last_Month__c = false,       // Enable Last Month
            Sales_Org__c = sorg.Id,   // Sales Org
            Territory__c = territory.Id,   // Territory
            Year__c = '2022'                   // Year
        );
        insert sic;
        
        List<Stock_In_Channel_Detail__c> sicdList = new List<Stock_In_Channel_Detail__c>();
        Stock_In_Channel_Detail__c sicd = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[0].Id,             // SKU
            June_Volume__c = 600.00,                // June Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            June_Sales__c = 0.00,                    // June Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            January_Volume__c = 100.00,             // January Volume
            September_Volume__c = 900.00,           // September Volume
            July_Volume__c = 700.00                // July Volume
        );
        sicdList.add(sicd);
        
        Stock_In_Channel_Detail__c sicd2 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[1].Id,             // SKU
            June_Volume__c = 600.00,                // June Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            June_Sales__c = 0.00,                    // June Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            January_Volume__c = 100.00,             // January Volume
            September_Volume__c = 900.00,           // September Volume
            July_Volume__c = 700.00                // July Volume
        );
        sicdList.add(sicd2);
        
        Stock_In_Channel_Detail__c sicd3 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[2].Id,             // SKU
            June_Volume__c = 600.00,                // June Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            June_Sales__c = 0.00,                    // June Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            January_Volume__c = 100.00,             // January Volume
            September_Volume__c = 900.00,           // September Volume
            July_Volume__c = 700.00                // July Volume
        );
        sicdList.add(sicd3);
        
        Stock_In_Channel_Detail__c sicd4 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[3].Id,             // SKU
            June_Volume__c = 600.00,                // June Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            June_Sales__c = 0.00,                    // June Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            January_Volume__c = 100.00,             // January Volume
            September_Volume__c = 900.00,           // September Volume
            July_Volume__c = 700.00                // July Volume
        );
        sicdList.add(sicd4);
        insert sicdList;
        
        List<BW_Data__c> bwList = new List<BW_Data__c>();
        
        BW_Data__c sobj = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[0].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022006',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj2 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[0].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022006',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        

        BW_Data__c sobj3 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[1].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022006',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj4 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[1].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022006',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj5 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[2].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022006',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
       
        
        BW_Data__c sobj6 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[2].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022006',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        

        BW_Data__c sobj7 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[3].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2021',            // Fiscal Year
            Fiscal_Year_Period__c = '2021006',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj8 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[3].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2020',            // Fiscal Year
            Fiscal_Year_Period__c = '2021006',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        bwList.add(sobj);
        bwList.add(sobj2);
        bwList.add(sobj3);
        bwList.add(sobj4);
        bwList.add(sobj5);
        bwList.add(sobj6);
        bwList.add(sobj7);
        bwList.add(sobj8);
        insert bwList;
        
        List<Account_Target__c> atList = new List<Account_Target__c>();
        Account_Target__c at1 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '6',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = pro.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503802022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at1);
        
        Account_Target__c at2 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '6',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = proCh.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503822022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at2);
        
        Account_Target__c at3 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '6',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = pro2.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503812022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at3);
        
        Account_Target__c at4 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '6',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = proCh2.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503832022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at4);
        
        insert atList;
        
        List<Open_Order__c> ooList=new List<Open_Order__c>();
        for(Integer i=1;i<=12;i++){
            String dateStr='01/'+i+'/2023';
            Open_Order__c oo = new Open_Order__c();
            //oo.Business_Unit__c = 'a1M0k000000404k';               // Business Unit
            oo.Customer__c = acc.id;                      // Customer
            oo.Region__c = territory.Id;                        // Region
            if(i==1 || i==2 || i==3){
                oo.Product__c = skuList[0].Id;                       // Product
            }
            else if(i==4 || i==5 || i==6){
                oo.Product__c = skuList[1].Id;                       // Product
            }
            else if(i==7 || i==8 || i==9){
                oo.Product__c = skuList[2].Id;                       // Product
            }
            else if(i==10 || i==11 || i==12){
                oo.Product__c = skuList[3].Id;                       // Product
            }
            
            oo.Data_de_Faturamento__c = date.parse(dateStr);  // Data de Faturamento
            oo.Qty_ORD__c = 20;                                    // Qty ORD
            oo.Net_Sales_ORD__c = 900.00;                            // Net Sales ORD
        	ooList.add(oo);
        }
        for(Integer i=1;i<=12;i++){
            String dateStr='01/'+i+'/2021';
            Open_Order__c oo = new Open_Order__c();
            //oo.Business_Unit__c = 'a1M0k000000404k';               // Business Unit
            oo.Customer__c = acc.id;                      // Customer
            oo.Region__c = territory.Id;                        // Region
            if(i==1 || i==2 || i==3){
                oo.Product__c = skuList[0].Id;                       // Product
            }
            else if(i==4 || i==5 || i==6){
                oo.Product__c = skuList[1].Id;                       // Product
            }
            else if(i==7 || i==8 || i==9){
                oo.Product__c = skuList[2].Id;                       // Product
            }
            else if(i==10 || i==11 || i==12){
                oo.Product__c = skuList[3].Id;                       // Product
            }
            oo.Data_de_Faturamento__c = date.parse(dateStr);  // Data de Faturamento
            oo.Qty_ORD__c = 20;                                    // Qty ORD
            oo.Net_Sales_ORD__c = 900.00;                            // Net Sales ORD
        	ooList.add(oo);
        }
        insert ooList;
        
        Open_Order__c oo3 = new Open_Order__c(
            //Business_Unit__c = 'a1M0k000000404k',               // Business Unit
            Customer__c = acc.id,                      // Customer
            Region__c = territory.Id,                        // Region
            Product__c = skuList[3].Id,                       // Product
            Data_de_Faturamento__c = date.parse('01/1/2022'),  // Data de Faturamento
            Qty_ORD__c = 20,                                    // Qty ORD
            Net_Sales_ORD__c = 900.00                            // Net Sales ORD
        );
        insert oo3;
        
        Open_Order__c oo4 = new Open_Order__c(
            //Business_Unit__c = 'a1M0k000000404k',               // Business Unit
            Customer__c = acc.id,                      // Customer
            Region__c = territory.Id,                        // Region
            Product__c = skuList[0].Id,                       // Product
            Data_de_Faturamento__c = date.parse('01/1/2021'),  // Data de Faturamento
            Qty_ORD__c = 20,                                    // Qty ORD
            Net_Sales_ORD__c = 900.00                            // Net Sales ORD
        );
        insert oo4;
        
        test.startTest();
        List<SalesAgreementProduct> sapListT=[select Id, SalesAgreement.Account.SAP_Code__c,PricebookEntry.Product2.Product_code__c,
                                                                                               SalesAgreement.Region__r.TerritoryCode__c,SalesAgreement.Sale_Org_Code__c,
                                                                                               SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreement.Year__c from SalesAgreementProduct limit 1];
        List<SalesAgreementProductSchedule> sapsListT=[Select id,Name,Combination_Key__c,SalesAgreementProductId from SalesAgreementProductSchedule where SalesAgreementProductId=:sapListT[0].Id limit 1];
        System.debug('sapsListT :'+sapsListT);
        UpdatePOGMetricsHandler.insertCombinationKey(sapsListT);
        
        List<SalesAgreementProductSchedule> sapsList=[Select id,Name,SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c,SalesAgreementProduct.PricebookEntry.Product2.Product_code__c,
                                                                                                       SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c,SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c,
                                                                                                       SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreementProduct.SalesAgreement.Year__c,Combination_Key__c,SalesAgreementProductId,Is_Update_Metrics__c from SalesAgreementProductSchedule];
            System.debug('sapsList test :'+sapsList.size());
        	Map<String,SalesAgreementProductSchedule> maptest = new Map<String,SalesAgreementProductSchedule>();
            for(SalesAgreementProductSchedule sapT:sapsList){
                String combinationKey='';
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Year__c;
                            combinationKey+=sapT.SalesAgreementProduct.PricebookEntry.Product2.Product_code__c;
                            //if(String.isNotBlank(combinationKey)){
                                sapT.Combination_Key__c=combinationKey+sapT.Name;
                            //} 
                sapT.Is_Update_Metrics__c=true;
                if(!maptest.containsKey(sapT.Combination_Key__c)){
                      maptest.put(sapT.Combination_Key__c,sapT);  
                }
            }
        
        System.debug('sapsList test 2 :'+JSON.serializePretty(maptest.values()));
          	update maptest.values();  
            UpdatePOGMetricsHandler.updateMethod(sapsList);
        
        test.stopTest();
        
    }
    
    static testMethod void allTheDataForThisTestClass4() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Description__c='Brazil';
        sorg.Sales_Org_Code__c='5191';
        sorg.Is_Active_Forecast__c = true;
        insert sorg;
        system.debug('Test Class Data - Sales Org **** -' + sorg);
        /* Report report = new Report(
            FolderName = 'Brazil Reports',
            Name = 'Sales Agreement (Forecast)'
        );
        insert report; */

        RecordType depoRcdTp = [SELECT Id FROM RecordType WHERE name = 'Depot' and isActive = true LIMIT 1];

        Account acc = new Account(
            Name = 'MAURICIO BERNARDO SCHOLTEN E OUTROS [View Hierarchy]',// Account Name
            SAP_Code__c = '0001419272',                                     // SAP Customer Code
            Mobile__c = '000000000000000000',                               // Mobile
            Email__c = 'mauri@xxx2.com',                            // Email
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
        user.Alias = 'zonaa2';                                                            
        user.Email = 'skim@skinternational1232.com';                             
        user.ProfileId  = p.ID;                                                     
        user.Username = 'zonal_aaexe1232@upl1223332.com.devbox';                                    
        user.IsActive = true;  
        user.LastName='Terriotory Manager';
        user.CommunityNickname = 'zonalExe12222 Di'; 
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
        brzlU.Alias = 'zonaa22';                                                            
        brzlU.Email = 'sk@skinternational2.com';                             
        brzlU.ProfileId  = p.ID;                                                     
        brzlU.Username = 'zonal7_aaexe1232@upl12233322.com.devbox1';                                    
        brzlU.IsActive = true;  
        brzlU.LastName='TM';
        brzlU.CommunityNickname = 'zonal7Exe122222 Di'; 
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
            Active_Forecast_Month__c = 'July',                         // Active Forecast Month
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
        system.debug('Test Class Data - sfs **** -' + sfs);

        Zone__c zone =  new Zone__c();
        zone.SalesOrg__c = sorg.Id;
        zone.Name = 'BU MATO GROSSO2';
        zone.ZoneCode__c = 'BR002';              
        zone.ZonalHead__c = user.Id;
        //  zone.SBU_Code__c = sbu.Id;
        insert zone;

        Region__c region = new Region__c();
        region.Name = 'MATO GROSSO DO SUL2';
        region.RegionCode__c =  'BR0002';
        region.SalesOrg__c = sorg.Id;
        region.Zone__c = zone.Id;
        region.RegionHead__c = user.Id;
        region.BrazilAnalyst__c = brzlU.Id;   
        region.Batch_Number__c='Batch 1';
       // region.SBU__c = sbu.Id;                                                                           
        insert region;

        system.debug('Test Class Data - region **** -' + region);

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

        Customer_and_Region_Mapping__c crm = new Customer_and_Region_Mapping__c(
            Customer_Name__c = acc.id,// Customer Name
            Active__c = true,                      // Active
            CustomerRegion__c = territory.Id,
            Distribution_Channel__c = disbj.id,
            Division__c = div.id,
            Sales_Org__c = sorg.id
        );
        insert crm;
        
        Forecast_Account__c fa = new Forecast_Account__c(
            Account__c = acc.id,
            Territory__c = territory.id,
            Combination_Key__c = territory.TerritoryCode__c+acc.SAP_Code__c,
            OwnerId = user.id,
            Dummy_Customer__c =false
        );
        insert fa;

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
        
        Product2 proCh = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 30 KG',          // Product Name
            Product_Code__c = '000000000005250382',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250382',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 30 KG',     // Product Description
            parent__c = pro.id
        );
        insert proCh;
        
        Product2 pro2 = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 10 KG',          // Product Name
            //RecordTypeId = skuRcdTp.Id,
            Product_Code__c = '000000000005250381',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250381',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 10 KG',     // Product Description
            Parent__c = pro.id
        );
        insert pro2;
        
        Product2 proCh2 = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 40 KG',          // Product Name
            Product_Code__c = '000000000005250383',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250383',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 40 KG',     // Product Description
            parent__c = pro2.id
        );
        insert proCh2;

        ID standardPBID = Test.getStandardPricebookId();
        system.debug('standardPBID ** -' + standardPBID);

        insert new PriceBookEntry(Product2Id=pro.Id, Pricebook2Id=standardPBID, UnitPrice=100, isActive=true);

        Pricebook2 pb = new Pricebook2(
            Name = 'July2022BR0005',                  // Price Book Name
            IsActive = true,                           // Active
            Is_Used_for_Forecast__c = true,            // Is Used for Forecast
            Sales_District__c = region.id,     // Sales District
            Combination_Key__c = 'July2022BR00005',      // Combination Key
            Sales_Org__c = sorg.id,          // Sales Org
            Price_Book_Category__c = 'Forecast',       // Price Book Category
            Type__c = 'Monthly',                       // Type
            Start_Date__c = system.today(),  // Start Date
            Month__c = '07',                           // Month
            End_Date__c = system.today(),   // End Date
            Year__c = '2022'                          // Year
        );
        insert pb;

        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        
        PricebookEntry pbe = new PricebookEntry(
            Product2Id = pro.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'July2022BR00055191000000000005250380'  // Combination Key
        );
        pbeList.add(pbe);
        
        PricebookEntry pbe2 = new PricebookEntry(
            Product2Id = proCh.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'July2022BR00055191000000000005250382'  // Combination Key
        );
        //pbeList.add(pbe2);
        
        PricebookEntry pbe3 = new PricebookEntry(
            Product2Id = pro2.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'July2022BR00055191000000000005250381'  // Combination Key
        );
       // pbeList.add(pbe3);
        
        PricebookEntry pbe4 = new PricebookEntry(
            Product2Id = proCh2.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'July2022BR00055191000000000005250383'  // Combination Key
        );
       // pbeList.add(pbe4);
        
        insert pbeList;
        //insert pbe;

        // Sales Agreement Created for all 12 months
        SalesAgreement sa = new SalesAgreement(
            Status = 'Draft',                                           // Status
            Name = 'SABR114052022',                                       // Name
            StartDate = system.today(),                        // Start Date
            AccountId = acc.id,                                // Account
            ScheduleFrequency = 'Monthly',                                // Schedule Frequency 
            ScheduleCount = 12,                                         // Schedule Count
            EndDate = system.today(),                           // End Date
            PricebookId = pb.id,                              // Price Book
            Region__c = territory.id,                                // Region
            Clone_the_existing_Forecast__c = false,                        // Clone the existing Forecast
            Year__c = '2022',                                             // Year
            Active_Forecast_Month_Number__c = '07',                       // Active Forecast Month (Number)
            Active_Forecast_Month__c = 'July',                             // Active Forecast Month
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
            PricebookEntryId = pbeList[0].id, 
            Last_Consensus__c = 1, 
            Budget_Price__c = 3, 
            Earlier_Planned_Quantity__c = 10
        );
        insert sap;
        
        List<SalesAgreement> saList=new List<SalesAgreement>();
        for(Integer j=1;j<=12;j++){
             String dateStr='01/'+j+'/2022';
            String endDate='02/'+j+'/2022';
            SalesAgreement sAgmt = new SalesAgreement();
            sAgmt.Status = 'Draft';                                           // Status
            sAgmt.Name = 'SABR114032022';                                       // Name
            sAgmt.StartDate = date.parse(dateStr);                        // Start Date
            sAgmt.AccountId = acc.id;                                // Account
            sAgmt.ScheduleFrequency = 'Monthly';                                // Schedule Frequency 
            sAgmt.ScheduleCount = 12;                                         // Schedule Count
            sAgmt.EndDate = date.parse(endDate);                           // End Date
            sAgmt.PricebookId = pb.id;                              // Price Book
            //LastModifiedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),  // Last Modified Date
            //CreatedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),       // Created Date
            sAgmt.Region__c = territory.id;                               // Region
            sAgmt.Clone_the_existing_Forecast__c = true;                        // Clone the existing Forecast
            sAgmt.Year__c = '2022';                                             // Year
            sAgmt.Cloned_from_Sales_Agreement__c = sa.Id;           // Cloned from Sales Agreement
            sAgmt.Active_Forecast_Month_Number__c = '07';                       // Active Forecast Month (Number)
            sAgmt.Active_Forecast_Month__c = 'July';                             // Active Forecast Month
            sAgmt.Sales_Agreement_Schedule_Frequency_Allow__c ='Monthly';
        	saList.add(sAgmt);
        
        }
        insert saList;
        System.debug('saList size :'+saList.size());
        System.debug('saList :'+saList);
        List<SalesAgreementProduct> sapList=new List<SalesAgreementProduct>();
        for(Integer i=0; i<saList.size();i++){
            SalesAgreementProduct sap11 = new SalesAgreementProduct();
            sap11.SalesPrice = 1.00;                                          // Sales Price
            sap11.InitialPlannedQuantity = 1;                                 // Initial Total Quantity
            sap11.DiscountPercentage = 0.00;                                    // Discount Percentage
            sap11.Name = 'Test'; 
            sap11.CurrencyIsoCode = 'USD'; 
            sap11.PricebookEntryId = pbeList[0].id; 
            sap11.SalesAgreementId = saList[i].id; 
            sap11.Last_Consensus__c = 1; 
            sap11.Budget_Price__c = 3; 
            sap11.Earlier_Planned_Quantity__c = 10;
            sapList.add(sap11);   
        }
        insert sapList;
        //EOC
        List<SKU__c> skuList = new List<SKU__c>();
        SKU__c skuobj = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250380',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250380',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj);
        //insert skuobj;
        
        SKU__c skuobj2 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250381',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250381',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj2);
        //insert skuobj2;
        
        SKU__c skuobj3 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250382',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250382',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj3);
        
        SKU__c skuobj4 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250383',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250383',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj4);
        insert skuList;
        
        Stock_In_Channel__c sic = new Stock_In_Channel__c(
            Channel__c = acc.id,   // Channel
            Combination_Key__c = '0001037362',  // Combination Key
            Enable_Last_Month__c = false,       // Enable Last Month
            Sales_Org__c = sorg.Id,   // Sales Org
            Territory__c = territory.Id,   // Territory
            Year__c = '2022'                   // Year
        );
        insert sic;
        
        List<Stock_In_Channel_Detail__c> sicdList = new List<Stock_In_Channel_Detail__c>();
        Stock_In_Channel_Detail__c sicd = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[0].Id,             // SKU
            July_Volume__c = 600.00,                // July Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            July_Sales__c = 0.00,                    // July Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            January_Volume__c = 100.00,             // January Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd);
        
        Stock_In_Channel_Detail__c sicd2 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[1].Id,             // SKU
            July_Volume__c = 600.00,                // July Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            July_Sales__c = 0.00,                    // July Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            January_Volume__c = 100.00,             // January Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd2);
        
        Stock_In_Channel_Detail__c sicd3 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[2].Id,             // SKU
            July_Volume__c = 600.00,                // July Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            July_Sales__c = 0.00,                    // July Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            January_Volume__c = 100.00,             // January Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd3);
        
        Stock_In_Channel_Detail__c sicd4 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[3].Id,             // SKU
            July_Volume__c = 600.00,                // July Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            July_Sales__c = 0.00,                    // July Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            January_Volume__c = 100.00,             // January Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd4);
        insert sicdList;
        
        List<BW_Data__c> bwList = new List<BW_Data__c>();
        
        BW_Data__c sobj = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[0].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022007',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj2 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[0].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022007',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        

        BW_Data__c sobj3 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[1].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022007',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj4 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[1].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022007',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj5 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[2].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022007',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
       
        
        BW_Data__c sobj6 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[2].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022007',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        

        BW_Data__c sobj7 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[3].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2021',            // Fiscal Year
            Fiscal_Year_Period__c = '2021007',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj8 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[3].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2020',            // Fiscal Year
            Fiscal_Year_Period__c = '2021007',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        bwList.add(sobj);
        bwList.add(sobj2);
        bwList.add(sobj3);
        bwList.add(sobj4);
        bwList.add(sobj5);
        bwList.add(sobj6);
        bwList.add(sobj7);
        bwList.add(sobj8);
        insert bwList;
        
        List<Account_Target__c> atList = new List<Account_Target__c>();
        Account_Target__c at1 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '7',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = pro.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503802022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at1);
        
        Account_Target__c at2 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '7',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = proCh.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503822022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at2);
        
        Account_Target__c at3 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '7',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = pro2.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503812022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at3);
        
        Account_Target__c at4 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '7',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = proCh2.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503832022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at4);
        
        insert atList;
        
        List<Open_Order__c> ooList=new List<Open_Order__c>();
        for(Integer i=1;i<=12;i++){
            String dateStr='01/'+i+'/2023';
            Open_Order__c oo = new Open_Order__c();
            //oo.Business_Unit__c = 'a1M0k000000404k';               // Business Unit
            oo.Customer__c = acc.id;                      // Customer
            oo.Region__c = territory.Id;                        // Region
            if(i==1 || i==2 || i==3){
                oo.Product__c = skuList[0].Id;                       // Product
            }
            else if(i==4 || i==5 || i==6){
                oo.Product__c = skuList[1].Id;                       // Product
            }
            else if(i==7 || i==8 || i==9){
                oo.Product__c = skuList[2].Id;                       // Product
            }
            else if(i==10 || i==11 || i==12){
                oo.Product__c = skuList[3].Id;                       // Product
            }
            
            oo.Data_de_Faturamento__c = date.parse(dateStr);  // Data de Faturamento
            oo.Qty_ORD__c = 20;                                    // Qty ORD
            oo.Net_Sales_ORD__c = 900.00;                            // Net Sales ORD
        	ooList.add(oo);
        }
        for(Integer i=1;i<=12;i++){
            String dateStr='01/'+i+'/2021';
            Open_Order__c oo = new Open_Order__c();
            //oo.Business_Unit__c = 'a1M0k000000404k';               // Business Unit
            oo.Customer__c = acc.id;                      // Customer
            oo.Region__c = territory.Id;                        // Region
            if(i==1 || i==2 || i==3){
                oo.Product__c = skuList[0].Id;                       // Product
            }
            else if(i==4 || i==5 || i==6){
                oo.Product__c = skuList[1].Id;                       // Product
            }
            else if(i==7 || i==8 || i==9){
                oo.Product__c = skuList[2].Id;                       // Product
            }
            else if(i==10 || i==11 || i==12){
                oo.Product__c = skuList[3].Id;                       // Product
            }
            oo.Data_de_Faturamento__c = date.parse(dateStr);  // Data de Faturamento
            oo.Qty_ORD__c = 20;                                    // Qty ORD
            oo.Net_Sales_ORD__c = 900.00;                            // Net Sales ORD
        	ooList.add(oo);
        }
        insert ooList;
        
        Open_Order__c oo3 = new Open_Order__c(
            //Business_Unit__c = 'a1M0k000000404k',               // Business Unit
            Customer__c = acc.id,                      // Customer
            Region__c = territory.Id,                        // Region
            Product__c = skuList[3].Id,                       // Product
            Data_de_Faturamento__c = date.parse('01/1/2022'),  // Data de Faturamento
            Qty_ORD__c = 20,                                    // Qty ORD
            Net_Sales_ORD__c = 900.00                            // Net Sales ORD
        );
        insert oo3;
        
        Open_Order__c oo4 = new Open_Order__c(
            //Business_Unit__c = 'a1M0k000000404k',               // Business Unit
            Customer__c = acc.id,                      // Customer
            Region__c = territory.Id,                        // Region
            Product__c = skuList[0].Id,                       // Product
            Data_de_Faturamento__c = date.parse('01/1/2021'),  // Data de Faturamento
            Qty_ORD__c = 20,                                    // Qty ORD
            Net_Sales_ORD__c = 900.00                            // Net Sales ORD
        );
        insert oo4;
        
        test.startTest();
        List<SalesAgreementProduct> sapListT=[select Id, SalesAgreement.Account.SAP_Code__c,PricebookEntry.Product2.Product_code__c,
                                                                                               SalesAgreement.Region__r.TerritoryCode__c,SalesAgreement.Sale_Org_Code__c,
                                                                                               SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreement.Year__c from SalesAgreementProduct limit 1];
        List<SalesAgreementProductSchedule> sapsListT=[Select id,Name,Combination_Key__c,SalesAgreementProductId from SalesAgreementProductSchedule where SalesAgreementProductId=:sapListT[0].Id limit 1];
        System.debug('sapsListT :'+sapsListT);
        UpdatePOGMetricsHandler.insertCombinationKey(sapsListT);
        
        List<SalesAgreementProductSchedule> sapsList=[Select id,Name,SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c,SalesAgreementProduct.PricebookEntry.Product2.Product_code__c,
                                                                                                       SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c,SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c,
                                                                                                       SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreementProduct.SalesAgreement.Year__c,Combination_Key__c,SalesAgreementProductId,Is_Update_Metrics__c from SalesAgreementProductSchedule];
            System.debug('sapsList test :'+sapsList.size());
        	Map<String,SalesAgreementProductSchedule> maptest = new Map<String,SalesAgreementProductSchedule>();
            for(SalesAgreementProductSchedule sapT:sapsList){
                String combinationKey='';
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Year__c;
                            combinationKey+=sapT.SalesAgreementProduct.PricebookEntry.Product2.Product_code__c;
                            //if(String.isNotBlank(combinationKey)){
                                sapT.Combination_Key__c=combinationKey+sapT.Name;
                            //} 
                sapT.Is_Update_Metrics__c=true;
                if(!maptest.containsKey(sapT.Combination_Key__c)){
                      maptest.put(sapT.Combination_Key__c,sapT);  
                }
            }
        
        System.debug('sapsList test 2 :'+JSON.serializePretty(maptest.values()));
          	update maptest.values();  
            UpdatePOGMetricsHandler.updateMethod(sapsList);
        
        test.stopTest();
        
    }
    
    static testMethod void allTheDataForThisTestClass5() {		
		Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Description__c='Brazil';
        sorg.Sales_Org_Code__c='5191';
        sorg.Is_Active_Forecast__c = true;
        insert sorg;
        system.debug('Test Class Data - Sales Org **** -' + sorg);
        /* Report report = new Report(
            FolderName = 'Brazil Reports',
            Name = 'Sales Agreement (Forecast)'
        );
        insert report; */

        RecordType depoRcdTp = [SELECT Id FROM RecordType WHERE name = 'Depot' and isActive = true LIMIT 1];

        Account acc = new Account(
            Name = 'MAURICIO BERNARDO SCHOLTEN E OUTROS [View Hierarchy]',// Account Name
            SAP_Code__c = '0001419272',                                     // SAP Customer Code
            Mobile__c = '000000000000000000',                               // Mobile
            Email__c = 'mauri@xxx2.com',                            // Email
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
        user.Alias = 'zonaa2';                                                            
        user.Email = 'skim@skinternational1232.com';                             
        user.ProfileId  = p.ID;                                                     
        user.Username = 'zonal_aaexe1232@upl1223332.com.devbox';                                    
        user.IsActive = true;  
        user.LastName='Terriotory Manager';
        user.CommunityNickname = 'zonalExe12222 Di'; 
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
        brzlU.Alias = 'zonaa22';                                                            
        brzlU.Email = 'sk@skinternational2.com';                             
        brzlU.ProfileId  = p.ID;                                                     
        brzlU.Username = 'zonal7_aaexe1232@upl12233322.com.devbox1';                                    
        brzlU.IsActive = true;  
        brzlU.LastName='TM';
        brzlU.CommunityNickname = 'zonal7Exe122222 Di'; 
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
            Active_Forecast_Month__c = 'January',                         // Active Forecast Month
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
        system.debug('Test Class Data - sfs **** -' + sfs);

        Zone__c zone =  new Zone__c();
        zone.SalesOrg__c = sorg.Id;
        zone.Name = 'BU MATO GROSSO2';
        zone.ZoneCode__c = 'BR002';              
        zone.ZonalHead__c = user.Id;
        //  zone.SBU_Code__c = sbu.Id;
        insert zone;

        Region__c region = new Region__c();
        region.Name = 'MATO GROSSO DO SUL2';
        region.RegionCode__c =  'BR0002';
        region.SalesOrg__c = sorg.Id;
        region.Zone__c = zone.Id;
        region.RegionHead__c = user.Id;
        region.BrazilAnalyst__c = brzlU.Id;   
        region.Batch_Number__c='Batch 1';
       // region.SBU__c = sbu.Id;                                                                           
        insert region;

        system.debug('Test Class Data - region **** -' + region);

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

        Customer_and_Region_Mapping__c crm = new Customer_and_Region_Mapping__c(
            Customer_Name__c = acc.id,// Customer Name
            Active__c = true,                      // Active
            CustomerRegion__c = territory.Id,
            Distribution_Channel__c = disbj.id,
            Division__c = div.id,
            Sales_Org__c = sorg.id
        );
        insert crm;
        
        Forecast_Account__c fa = new Forecast_Account__c(
            Account__c = acc.id,
            Territory__c = territory.id,
            Combination_Key__c = territory.TerritoryCode__c+acc.SAP_Code__c,
            OwnerId = user.id,
            Dummy_Customer__c =false
        );
        insert fa;

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
        
        Product2 proCh = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 30 KG',          // Product Name
            Product_Code__c = '000000000005250382',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250382',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 30 KG',     // Product Description
            parent__c = pro.id
        );
        insert proCh;
        
        Product2 pro2 = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 10 KG',          // Product Name
            //RecordTypeId = skuRcdTp.Id,
            Product_Code__c = '000000000005250381',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250381',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 10 KG',     // Product Description
            Parent__c = pro.id
        );
        insert pro2;
        
        Product2 proCh2 = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 40 KG',          // Product Name
            Product_Code__c = '000000000005250383',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250383',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 40 KG',     // Product Description
            parent__c = pro2.id
        );
        insert proCh2;

        ID standardPBID = Test.getStandardPricebookId();
        system.debug('standardPBID ** -' + standardPBID);

        insert new PriceBookEntry(Product2Id=pro.Id, Pricebook2Id=standardPBID, UnitPrice=100, isActive=true);

        Pricebook2 pb = new Pricebook2(
            Name = 'January2022BR0005',                  // Price Book Name
            IsActive = true,                           // Active
            Is_Used_for_Forecast__c = true,            // Is Used for Forecast
            Sales_District__c = region.id,     // Sales District
            Combination_Key__c = 'January2022BR00005',      // Combination Key
            Sales_Org__c = sorg.id,          // Sales Org
            Price_Book_Category__c = 'Forecast',       // Price Book Category
            Type__c = 'Monthly',                       // Type
            Start_Date__c = system.today(),  // Start Date
            Month__c = '01',                           // Month
            End_Date__c = system.today(),   // End Date
            Year__c = '2022'                          // Year
        );
        insert pb;

        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        
        PricebookEntry pbe = new PricebookEntry(
            Product2Id = pro.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'January2022BR00055191000000000005250380'  // Combination Key
        );
        pbeList.add(pbe);
        
        PricebookEntry pbe2 = new PricebookEntry(
            Product2Id = proCh.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'January2022BR00055191000000000005250382'  // Combination Key
        );
        //pbeList.add(pbe2);
        
        PricebookEntry pbe3 = new PricebookEntry(
            Product2Id = pro2.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'January2022BR00055191000000000005250381'  // Combination Key
        );
       // pbeList.add(pbe3);
        
        PricebookEntry pbe4 = new PricebookEntry(
            Product2Id = proCh2.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'January2022BR00055191000000000005250383'  // Combination Key
        );
       // pbeList.add(pbe4);
        
        insert pbeList;
        //insert pbe;

        // Sales Agreement Created for all 12 months
        SalesAgreement sa = new SalesAgreement(
            Status = 'Draft',                                           // Status
            Name = 'SABR114052022',                                       // Name
            StartDate = system.today(),                        // Start Date
            AccountId = acc.id,                                // Account
            ScheduleFrequency = 'Monthly',                                // Schedule Frequency 
            ScheduleCount = 12,                                         // Schedule Count
            EndDate = system.today(),                           // End Date
            PricebookId = pb.id,                              // Price Book
            Region__c = territory.id,                                // Region
            Clone_the_existing_Forecast__c = false,                        // Clone the existing Forecast
            Year__c = '2022',                                             // Year
            Active_Forecast_Month_Number__c = '01',                       // Active Forecast Month (Number)
            Active_Forecast_Month__c = 'January',                             // Active Forecast Month
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
            PricebookEntryId = pbeList[0].id, 
            Last_Consensus__c = 1, 
            Budget_Price__c = 3, 
            Earlier_Planned_Quantity__c = 10
        );
        insert sap;
        
        List<SalesAgreement> saList=new List<SalesAgreement>();
        for(Integer j=1;j<=12;j++){
             String dateStr='01/'+j+'/2022';
            String endDate='02/'+j+'/2022';
            SalesAgreement sAgmt = new SalesAgreement();
            sAgmt.Status = 'Draft';                                           // Status
            sAgmt.Name = 'SABR114032022';                                       // Name
            sAgmt.StartDate = date.parse(dateStr);                        // Start Date
            sAgmt.AccountId = acc.id;                                // Account
            sAgmt.ScheduleFrequency = 'Monthly';                                // Schedule Frequency 
            sAgmt.ScheduleCount = 12;                                         // Schedule Count
            sAgmt.EndDate = date.parse(endDate);                           // End Date
            sAgmt.PricebookId = pb.id;                              // Price Book
            //LastModifiedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),  // Last Modified Date
            //CreatedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),       // Created Date
            sAgmt.Region__c = territory.id;                               // Region
            sAgmt.Clone_the_existing_Forecast__c = true;                        // Clone the existing Forecast
            sAgmt.Year__c = '2022';                                             // Year
            sAgmt.Cloned_from_Sales_Agreement__c = sa.Id;           // Cloned from Sales Agreement
            sAgmt.Active_Forecast_Month_Number__c = '01';                       // Active Forecast Month (Number)
            sAgmt.Active_Forecast_Month__c = 'January';                             // Active Forecast Month
            sAgmt.Sales_Agreement_Schedule_Frequency_Allow__c ='Monthly';
        	saList.add(sAgmt);
        
        }
        insert saList;
        System.debug('saList size :'+saList.size());
        System.debug('saList :'+saList);
        List<SalesAgreementProduct> sapList=new List<SalesAgreementProduct>();
        for(Integer i=0; i<saList.size();i++){
            SalesAgreementProduct sap11 = new SalesAgreementProduct();
            sap11.SalesPrice = 1.00;                                          // Sales Price
            sap11.InitialPlannedQuantity = 1;                                 // Initial Total Quantity
            sap11.DiscountPercentage = 0.00;                                    // Discount Percentage
            sap11.Name = 'Test'; 
            sap11.CurrencyIsoCode = 'USD'; 
            sap11.PricebookEntryId = pbeList[0].id; 
            sap11.SalesAgreementId = saList[i].id; 
            sap11.Last_Consensus__c = 1; 
            sap11.Budget_Price__c = 3; 
            sap11.Earlier_Planned_Quantity__c = 10;
            sapList.add(sap11);   
        }
        insert sapList;
        //EOC
        List<SKU__c> skuList = new List<SKU__c>();
        SKU__c skuobj = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250380',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250380',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj);
        //insert skuobj;
        
        SKU__c skuobj2 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250381',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250381',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj2);
        //insert skuobj2;
        
        SKU__c skuobj3 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250382',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250382',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj3);
        
        SKU__c skuobj4 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250383',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250383',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj4);
        insert skuList;
        
        Stock_In_Channel__c sic = new Stock_In_Channel__c(
            Channel__c = acc.id,   // Channel
            Combination_Key__c = '0001037362',  // Combination Key
            Enable_Last_Month__c = false,       // Enable Last Month
            Sales_Org__c = sorg.Id,   // Sales Org
            Territory__c = territory.Id,   // Territory
            Year__c = '2022'                   // Year
        );
        insert sic;
        
        List<Stock_In_Channel_Detail__c> sicdList = new List<Stock_In_Channel_Detail__c>();
        Stock_In_Channel_Detail__c sicd = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[0].Id,             // SKU
            January_Volume__c = 600.00,                // January Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            January_Sales__c = 0.00,                    // January Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd);
        
        Stock_In_Channel_Detail__c sicd2 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[1].Id,             // SKU
            January_Volume__c = 600.00,                // January Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            January_Sales__c = 0.00,                    // January Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd2);
        
        Stock_In_Channel_Detail__c sicd3 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[2].Id,             // SKU
            January_Volume__c = 600.00,                // January Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            January_Sales__c = 0.00,                    // January Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd3);
        
        Stock_In_Channel_Detail__c sicd4 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[3].Id,             // SKU
            January_Volume__c = 600.00,                // January Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            January_Sales__c = 0.00,                    // January Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd4);
        insert sicdList;
        
        List<BW_Data__c> bwList = new List<BW_Data__c>();
        
        BW_Data__c sobj = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[0].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022001',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj2 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[0].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022001',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        

        BW_Data__c sobj3 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[1].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022001',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj4 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[1].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022001',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj5 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[2].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022001',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
       
        
        BW_Data__c sobj6 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[2].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022001',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        

        BW_Data__c sobj7 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[3].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2021',            // Fiscal Year
            Fiscal_Year_Period__c = '2021001',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj8 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[3].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2020',            // Fiscal Year
            Fiscal_Year_Period__c = '2021001',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        bwList.add(sobj);
        bwList.add(sobj2);
        bwList.add(sobj3);
        bwList.add(sobj4);
        bwList.add(sobj5);
        bwList.add(sobj6);
        bwList.add(sobj7);
        bwList.add(sobj8);
        insert bwList;
        
        List<Account_Target__c> atList = new List<Account_Target__c>();
        Account_Target__c at1 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '1',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = pro.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503802022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at1);
        
        Account_Target__c at2 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '1',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = proCh.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503822022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at2);
        
        Account_Target__c at3 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '1',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = pro2.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503812022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at3);
        
        Account_Target__c at4 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '1',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = proCh2.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503832022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at4);
        
        insert atList;
        
        List<Open_Order__c> ooList=new List<Open_Order__c>();
        for(Integer i=1;i<=12;i++){
            String dateStr='01/'+i+'/2023';
            Open_Order__c oo = new Open_Order__c();
            //oo.Business_Unit__c = 'a1M0k000000404k';               // Business Unit
            oo.Customer__c = acc.id;                      // Customer
            oo.Region__c = territory.Id;                        // Region
            if(i==1 || i==2 || i==3){
                oo.Product__c = skuList[0].Id;                       // Product
            }
            else if(i==4 || i==5 || i==6){
                oo.Product__c = skuList[1].Id;                       // Product
            }
            else if(i==7 || i==8 || i==9){
                oo.Product__c = skuList[2].Id;                       // Product
            }
            else if(i==10 || i==11 || i==12){
                oo.Product__c = skuList[3].Id;                       // Product
            }
            
            oo.Data_de_Faturamento__c = date.parse(dateStr);  // Data de Faturamento
            oo.Qty_ORD__c = 20;                                    // Qty ORD
            oo.Net_Sales_ORD__c = 900.00;                            // Net Sales ORD
        	ooList.add(oo);
        }
        for(Integer i=1;i<=12;i++){
            String dateStr='01/'+i+'/2021';
            Open_Order__c oo = new Open_Order__c();
            //oo.Business_Unit__c = 'a1M0k000000404k';               // Business Unit
            oo.Customer__c = acc.id;                      // Customer
            oo.Region__c = territory.Id;                        // Region
            if(i==1 || i==2 || i==3){
                oo.Product__c = skuList[0].Id;                       // Product
            }
            else if(i==4 || i==5 || i==6){
                oo.Product__c = skuList[1].Id;                       // Product
            }
            else if(i==7 || i==8 || i==9){
                oo.Product__c = skuList[2].Id;                       // Product
            }
            else if(i==10 || i==11 || i==12){
                oo.Product__c = skuList[3].Id;                       // Product
            }
            oo.Data_de_Faturamento__c = date.parse(dateStr);  // Data de Faturamento
            oo.Qty_ORD__c = 20;                                    // Qty ORD
            oo.Net_Sales_ORD__c = 900.00;                            // Net Sales ORD
        	ooList.add(oo);
        }
        insert ooList;
        
        Open_Order__c oo3 = new Open_Order__c(
            //Business_Unit__c = 'a1M0k000000404k',               // Business Unit
            Customer__c = acc.id,                      // Customer
            Region__c = territory.Id,                        // Region
            Product__c = skuList[3].Id,                       // Product
            Data_de_Faturamento__c = date.parse('01/1/2022'),  // Data de Faturamento
            Qty_ORD__c = 20,                                    // Qty ORD
            Net_Sales_ORD__c = 900.00                            // Net Sales ORD
        );
        insert oo3;
        
        Open_Order__c oo4 = new Open_Order__c(
            //Business_Unit__c = 'a1M0k000000404k',               // Business Unit
            Customer__c = acc.id,                      // Customer
            Region__c = territory.Id,                        // Region
            Product__c = skuList[0].Id,                       // Product
            Data_de_Faturamento__c = date.parse('01/1/2021'),  // Data de Faturamento
            Qty_ORD__c = 20,                                    // Qty ORD
            Net_Sales_ORD__c = 900.00                            // Net Sales ORD
        );
        
        insert oo4;
        
        test.startTest();
        List<SalesAgreementProduct> sapListT=[select Id, SalesAgreement.Account.SAP_Code__c,PricebookEntry.Product2.Product_code__c,
                                                                                               SalesAgreement.Region__r.TerritoryCode__c,SalesAgreement.Sale_Org_Code__c,
                                                                                               SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreement.Year__c from SalesAgreementProduct limit 1];
        List<SalesAgreementProductSchedule> sapsListT=[Select id,Name,Combination_Key__c,SalesAgreementProductId from SalesAgreementProductSchedule where SalesAgreementProductId=:sapListT[0].Id limit 1];
        System.debug('sapsListT :'+sapsListT);
        UpdatePOGMetricsHandler.insertCombinationKey(sapsListT);
        
        List<SalesAgreementProductSchedule> sapsList=[Select id,Name,SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c,SalesAgreementProduct.PricebookEntry.Product2.Product_code__c,
                                                                                                       SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c,SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c,
                                                                                                       SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreementProduct.SalesAgreement.Year__c,Combination_Key__c,SalesAgreementProductId,Is_Update_Metrics__c from SalesAgreementProductSchedule];
            System.debug('sapsList test :'+sapsList.size());
        	Map<String,SalesAgreementProductSchedule> maptest = new Map<String,SalesAgreementProductSchedule>();
            for(SalesAgreementProductSchedule sapT:sapsList){
                String combinationKey='';
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Year__c;
                            combinationKey+=sapT.SalesAgreementProduct.PricebookEntry.Product2.Product_code__c;
                            //if(String.isNotBlank(combinationKey)){
                                sapT.Combination_Key__c=combinationKey+sapT.Name;
                            //} 
                sapT.Is_Update_Metrics__c=true;
                if(!maptest.containsKey(sapT.Combination_Key__c)){
                      maptest.put(sapT.Combination_Key__c,sapT);  
                }
            }
        
        System.debug('sapsList test 2 :'+JSON.serializePretty(maptest.values()));
          	update maptest.values();  
            UpdatePOGMetricsHandler.updateMethod(sapsList);
        
        test.stopTest();
	}
    
    static testMethod void allTheDataForThisTestClass6() {		
		Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Description__c='Brazil';
        sorg.Sales_Org_Code__c='5191';
        sorg.Is_Active_Forecast__c = true;
        insert sorg;
        system.debug('Test Class Data - Sales Org **** -' + sorg);
        /* Report report = new Report(
            FolderName = 'Brazil Reports',
            Name = 'Sales Agreement (Forecast)'
        );
        insert report; */

        RecordType depoRcdTp = [SELECT Id FROM RecordType WHERE name = 'Depot' and isActive = true LIMIT 1];

        Account acc = new Account(
            Name = 'MAURICIO BERNARDO SCHOLTEN E OUTROS [View Hierarchy]',// Account Name
            SAP_Code__c = '0001419272',                                     // SAP Customer Code
            Mobile__c = '000000000000000000',                               // Mobile
            Email__c = 'mauri@xxx2.com',                            // Email
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
        user.Alias = 'zonaa2';                                                            
        user.Email = 'skim@skinternational1232.com';                             
        user.ProfileId  = p.ID;                                                     
        user.Username = 'zonal_aaexe1232@upl1223332.com.devbox';                                    
        user.IsActive = true;  
        user.LastName='Terriotory Manager';
        user.CommunityNickname = 'zonalExe12222 Di'; 
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
        brzlU.Alias = 'zonaa22';                                                            
        brzlU.Email = 'sk@skinternational2.com';                             
        brzlU.ProfileId  = p.ID;                                                     
        brzlU.Username = 'zonal7_aaexe1232@upl12233322.com.devbox1';                                    
        brzlU.IsActive = true;  
        brzlU.LastName='TM';
        brzlU.CommunityNickname = 'zonal7Exe122222 Di'; 
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
            Active_Forecast_Month__c = 'April',                         // Active Forecast Month
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
        system.debug('Test Class Data - sfs **** -' + sfs);

        Zone__c zone =  new Zone__c();
        zone.SalesOrg__c = sorg.Id;
        zone.Name = 'BU MATO GROSSO2';
        zone.ZoneCode__c = 'BR002';              
        zone.ZonalHead__c = user.Id;
        //  zone.SBU_Code__c = sbu.Id;
        insert zone;

        Region__c region = new Region__c();
        region.Name = 'MATO GROSSO DO SUL2';
        region.RegionCode__c =  'BR0002';
        region.SalesOrg__c = sorg.Id;
        region.Zone__c = zone.Id;
        region.RegionHead__c = user.Id;
        region.BrazilAnalyst__c = brzlU.Id;   
        region.Batch_Number__c='Batch 1';
       // region.SBU__c = sbu.Id;                                                                           
        insert region;

        system.debug('Test Class Data - region **** -' + region);

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

        Customer_and_Region_Mapping__c crm = new Customer_and_Region_Mapping__c(
            Customer_Name__c = acc.id,// Customer Name
            Active__c = true,                      // Active
            CustomerRegion__c = territory.Id,
            Distribution_Channel__c = disbj.id,
            Division__c = div.id,
            Sales_Org__c = sorg.id
        );
        insert crm;
        
        Forecast_Account__c fa = new Forecast_Account__c(
            Account__c = acc.id,
            Territory__c = territory.id,
            Combination_Key__c = territory.TerritoryCode__c+acc.SAP_Code__c,
            OwnerId = user.id,
            Dummy_Customer__c =false
        );
        insert fa;

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
        
        Product2 proCh = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 30 KG',          // Product Name
            Product_Code__c = '000000000005250382',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250382',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 30 KG',     // Product Description
            parent__c = pro.id
        );
        insert proCh;
        
        Product2 pro2 = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 10 KG',          // Product Name
            //RecordTypeId = skuRcdTp.Id,
            Product_Code__c = '000000000005250381',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250381',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 10 KG',     // Product Description
            Parent__c = pro.id
        );
        insert pro2;
        
        Product2 proCh2 = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 40 KG',          // Product Name
            Product_Code__c = '000000000005250383',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250383',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 40 KG',     // Product Description
            parent__c = pro2.id
        );
        insert proCh2;

        ID standardPBID = Test.getStandardPricebookId();
        system.debug('standardPBID ** -' + standardPBID);

        insert new PriceBookEntry(Product2Id=pro.Id, Pricebook2Id=standardPBID, UnitPrice=100, isActive=true);

        Pricebook2 pb = new Pricebook2(
            Name = 'April2022BR0005',                  // Price Book Name
            IsActive = true,                           // Active
            Is_Used_for_Forecast__c = true,            // Is Used for Forecast
            Sales_District__c = region.id,     // Sales District
            Combination_Key__c = 'April2022BR00005',      // Combination Key
            Sales_Org__c = sorg.id,          // Sales Org
            Price_Book_Category__c = 'Forecast',       // Price Book Category
            Type__c = 'Monthly',                       // Type
            Start_Date__c = system.today(),  // Start Date
            Month__c = '04',                           // Month
            End_Date__c = system.today(),   // End Date
            Year__c = '2022'                          // Year
        );
        insert pb;

        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        
        PricebookEntry pbe = new PricebookEntry(
            Product2Id = pro.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'April2022BR00055191000000000005250380'  // Combination Key
        );
        pbeList.add(pbe);
        
        PricebookEntry pbe2 = new PricebookEntry(
            Product2Id = proCh.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'April2022BR00055191000000000005250382'  // Combination Key
        );
        //pbeList.add(pbe2);
        
        PricebookEntry pbe3 = new PricebookEntry(
            Product2Id = pro2.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'April2022BR00055191000000000005250381'  // Combination Key
        );
       // pbeList.add(pbe3);
        
        PricebookEntry pbe4 = new PricebookEntry(
            Product2Id = proCh2.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'April2022BR00055191000000000005250383'  // Combination Key
        );
       // pbeList.add(pbe4);
        
        insert pbeList;
        //insert pbe;

        // Sales Agreement Created for all 12 months
        SalesAgreement sa = new SalesAgreement(
            Status = 'Draft',                                           // Status
            Name = 'SABR114052022',                                       // Name
            StartDate = system.today(),                        // Start Date
            AccountId = acc.id,                                // Account
            ScheduleFrequency = 'Monthly',                                // Schedule Frequency 
            ScheduleCount = 12,                                         // Schedule Count
            EndDate = system.today(),                           // End Date
            PricebookId = pb.id,                              // Price Book
            Region__c = territory.id,                                // Region
            Clone_the_existing_Forecast__c = false,                        // Clone the existing Forecast
            Year__c = '2022',                                             // Year
            Active_Forecast_Month_Number__c = '04',                       // Active Forecast Month (Number)
            Active_Forecast_Month__c = 'April',                             // Active Forecast Month
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
            PricebookEntryId = pbeList[0].id, 
            Last_Consensus__c = 1, 
            Budget_Price__c = 3, 
            Earlier_Planned_Quantity__c = 10
        );
        insert sap;
        
        List<SalesAgreement> saList=new List<SalesAgreement>();
        for(Integer j=1;j<=12;j++){
             String dateStr='01/'+j+'/2022';
            String endDate='02/'+j+'/2022';
            SalesAgreement sAgmt = new SalesAgreement();
            sAgmt.Status = 'Draft';                                           // Status
            sAgmt.Name = 'SABR114032022';                                       // Name
            sAgmt.StartDate = date.parse(dateStr);                        // Start Date
            sAgmt.AccountId = acc.id;                                // Account
            sAgmt.ScheduleFrequency = 'Monthly';                                // Schedule Frequency 
            sAgmt.ScheduleCount = 12;                                         // Schedule Count
            sAgmt.EndDate = date.parse(endDate);                           // End Date
            sAgmt.PricebookId = pb.id;                              // Price Book
            //LastModifiedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),  // Last Modified Date
            //CreatedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),       // Created Date
            sAgmt.Region__c = territory.id;                               // Region
            sAgmt.Clone_the_existing_Forecast__c = true;                        // Clone the existing Forecast
            sAgmt.Year__c = '2022';                                             // Year
            sAgmt.Cloned_from_Sales_Agreement__c = sa.Id;           // Cloned from Sales Agreement
            sAgmt.Active_Forecast_Month_Number__c = '04';                       // Active Forecast Month (Number)
            sAgmt.Active_Forecast_Month__c = 'April';                             // Active Forecast Month
            sAgmt.Sales_Agreement_Schedule_Frequency_Allow__c ='Monthly';
        	saList.add(sAgmt);
        
        }
        insert saList;
        System.debug('saList size :'+saList.size());
        System.debug('saList :'+saList);
        List<SalesAgreementProduct> sapList=new List<SalesAgreementProduct>();
        for(Integer i=0; i<saList.size();i++){
            SalesAgreementProduct sap11 = new SalesAgreementProduct();
            sap11.SalesPrice = 1.00;                                          // Sales Price
            sap11.InitialPlannedQuantity = 1;                                 // Initial Total Quantity
            sap11.DiscountPercentage = 0.00;                                    // Discount Percentage
            sap11.Name = 'Test'; 
            sap11.CurrencyIsoCode = 'USD'; 
            sap11.PricebookEntryId = pbeList[0].id; 
            sap11.SalesAgreementId = saList[i].id; 
            sap11.Last_Consensus__c = 1; 
            sap11.Budget_Price__c = 3; 
            sap11.Earlier_Planned_Quantity__c = 10;
            sapList.add(sap11);   
        }
        insert sapList;
        //EOC
        List<SKU__c> skuList = new List<SKU__c>();
        SKU__c skuobj = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250380',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250380',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj);
        //insert skuobj;
        
        SKU__c skuobj2 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250381',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250381',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj2);
        //insert skuobj2;
        
        SKU__c skuobj3 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250382',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250382',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj3);
        
        SKU__c skuobj4 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250383',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250383',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj4);
        insert skuList;
        
        Stock_In_Channel__c sic = new Stock_In_Channel__c(
            Channel__c = acc.id,   // Channel
            Combination_Key__c = '0001037362',  // Combination Key
            Enable_Last_Month__c = false,       // Enable Last Month
            Sales_Org__c = sorg.Id,   // Sales Org
            Territory__c = territory.Id,   // Territory
            Year__c = '2022'                   // Year
        );
        insert sic;
        
        List<Stock_In_Channel_Detail__c> sicdList = new List<Stock_In_Channel_Detail__c>();
        Stock_In_Channel_Detail__c sicd = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[0].Id,             // SKU
            January_Volume__c = 600.00,                // January Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            January_Sales__c = 0.00,                    // January Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd);
        
        Stock_In_Channel_Detail__c sicd2 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[1].Id,             // SKU
            January_Volume__c = 600.00,                // January Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            January_Sales__c = 0.00,                    // January Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd2);
        
        Stock_In_Channel_Detail__c sicd3 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[2].Id,             // SKU
            January_Volume__c = 600.00,                // January Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            January_Sales__c = 0.00,                    // January Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd3);
        
        Stock_In_Channel_Detail__c sicd4 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[3].Id,             // SKU
            January_Volume__c = 600.00,                // January Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            January_Sales__c = 0.00,                    // January Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            October_Volume__c = 1000.00,           // October Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd4);
        insert sicdList;
        
        List<BW_Data__c> bwList = new List<BW_Data__c>();
        
        BW_Data__c sobj = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[0].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022004',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj2 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[0].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022004',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        

        BW_Data__c sobj3 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[1].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022004',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj4 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[1].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022004',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj5 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[2].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022004',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
       
        
        BW_Data__c sobj6 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[2].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022004',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        

        BW_Data__c sobj7 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[3].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2021',            // Fiscal Year
            Fiscal_Year_Period__c = '2021004',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj8 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[3].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2020',            // Fiscal Year
            Fiscal_Year_Period__c = '2021004',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        bwList.add(sobj);
        bwList.add(sobj2);
        bwList.add(sobj3);
        bwList.add(sobj4);
        bwList.add(sobj5);
        bwList.add(sobj6);
        bwList.add(sobj7);
        bwList.add(sobj8);
        insert bwList;
        
        List<Account_Target__c> atList = new List<Account_Target__c>();
        Account_Target__c at1 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '4',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = pro.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503802022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at1);
        
        Account_Target__c at2 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '4',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = proCh.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503822022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at2);
        
        Account_Target__c at3 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '4',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = pro2.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503812022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at3);
        
        Account_Target__c at4 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '4',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = proCh2.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503832022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at4);
        
        insert atList;
        
        List<Open_Order__c> ooList=new List<Open_Order__c>();
        for(Integer i=1;i<=12;i++){
            String dateStr='01/'+i+'/2023';
            Open_Order__c oo = new Open_Order__c();
            //oo.Business_Unit__c = 'a1M0k000000404k';               // Business Unit
            oo.Customer__c = acc.id;                      // Customer
            oo.Region__c = territory.Id;                        // Region
            if(i==1 || i==2 || i==3){
                oo.Product__c = skuList[0].Id;                       // Product
            }
            else if(i==4 || i==5 || i==6){
                oo.Product__c = skuList[1].Id;                       // Product
            }
            else if(i==7 || i==8 || i==9){
                oo.Product__c = skuList[2].Id;                       // Product
            }
            else if(i==10 || i==11 || i==12){
                oo.Product__c = skuList[3].Id;                       // Product
            }
            
            oo.Data_de_Faturamento__c = date.parse(dateStr);  // Data de Faturamento
            oo.Qty_ORD__c = 20;                                    // Qty ORD
            oo.Net_Sales_ORD__c = 900.00;                            // Net Sales ORD
        	ooList.add(oo);
        }
        for(Integer i=1;i<=12;i++){
            String dateStr='01/'+i+'/2021';
            Open_Order__c oo = new Open_Order__c();
            //oo.Business_Unit__c = 'a1M0k000000404k';               // Business Unit
            oo.Customer__c = acc.id;                      // Customer
            oo.Region__c = territory.Id;                        // Region
            if(i==1 || i==2 || i==3){
                oo.Product__c = skuList[0].Id;                       // Product
            }
            else if(i==4 || i==5 || i==6){
                oo.Product__c = skuList[1].Id;                       // Product
            }
            else if(i==7 || i==8 || i==9){
                oo.Product__c = skuList[2].Id;                       // Product
            }
            else if(i==10 || i==11 || i==12){
                oo.Product__c = skuList[3].Id;                       // Product
            }
            oo.Data_de_Faturamento__c = date.parse(dateStr);  // Data de Faturamento
            oo.Qty_ORD__c = 20;                                    // Qty ORD
            oo.Net_Sales_ORD__c = 900.00;                            // Net Sales ORD
        	ooList.add(oo);
        }
        insert ooList;
        
        Open_Order__c oo3 = new Open_Order__c(
            //Business_Unit__c = 'a1M0k000000404k',               // Business Unit
            Customer__c = acc.id,                      // Customer
            Region__c = territory.Id,                        // Region
            Product__c = skuList[3].Id,                       // Product
            Data_de_Faturamento__c = date.parse('01/1/2022'),  // Data de Faturamento
            Qty_ORD__c = 20,                                    // Qty ORD
            Net_Sales_ORD__c = 900.00                            // Net Sales ORD
        );
        insert oo3;
        
        Open_Order__c oo4 = new Open_Order__c(
            //Business_Unit__c = 'a1M0k000000404k',               // Business Unit
            Customer__c = acc.id,                      // Customer
            Region__c = territory.Id,                        // Region
            Product__c = skuList[0].Id,                       // Product
            Data_de_Faturamento__c = date.parse('01/1/2021'),  // Data de Faturamento
            Qty_ORD__c = 20,                                    // Qty ORD
            Net_Sales_ORD__c = 900.00                            // Net Sales ORD
        );
        insert oo4;
        
        test.startTest();
        List<SalesAgreementProduct> sapListT=[select Id, SalesAgreement.Account.SAP_Code__c,PricebookEntry.Product2.Product_code__c,
                                                                                               SalesAgreement.Region__r.TerritoryCode__c,SalesAgreement.Sale_Org_Code__c,
                                                                                               SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreement.Year__c from SalesAgreementProduct limit 1];
        List<SalesAgreementProductSchedule> sapsListT=[Select id,Name,Combination_Key__c,SalesAgreementProductId from SalesAgreementProductSchedule where SalesAgreementProductId=:sapListT[0].Id limit 1];
        System.debug('sapsListT :'+sapsListT);
        UpdatePOGMetricsHandler.insertCombinationKey(sapsListT);
        
        List<SalesAgreementProductSchedule> sapsList=[Select id,Name,SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c,SalesAgreementProduct.PricebookEntry.Product2.Product_code__c,
                                                                                                       SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c,SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c,
                                                                                                       SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreementProduct.SalesAgreement.Year__c,Combination_Key__c,SalesAgreementProductId,Is_Update_Metrics__c from SalesAgreementProductSchedule];
            System.debug('sapsList test :'+sapsList.size());
        	Map<String,SalesAgreementProductSchedule> maptest = new Map<String,SalesAgreementProductSchedule>();
            for(SalesAgreementProductSchedule sapT:sapsList){
                String combinationKey='';
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Year__c;
                            combinationKey+=sapT.SalesAgreementProduct.PricebookEntry.Product2.Product_code__c;
                            //if(String.isNotBlank(combinationKey)){
                                sapT.Combination_Key__c=combinationKey+sapT.Name;
                            //} 
                sapT.Is_Update_Metrics__c=true;
                if(!maptest.containsKey(sapT.Combination_Key__c)){
                      maptest.put(sapT.Combination_Key__c,sapT);  
                }
            }
        
        System.debug('sapsList test 2 :'+JSON.serializePretty(maptest.values()));
          	update maptest.values();  
            UpdatePOGMetricsHandler.updateMethod(sapsList);
        
        test.stopTest();
	}
    
    static testMethod void allTheDataForThisTestClass7() {		
		Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Description__c='Brazil';
        sorg.Sales_Org_Code__c='5191';
        sorg.Is_Active_Forecast__c = true;
        insert sorg;
        system.debug('Test Class Data - Sales Org **** -' + sorg);
        /* Report report = new Report(
            FolderName = 'Brazil Reports',
            Name = 'Sales Agreement (Forecast)'
        );
        insert report; */

        RecordType depoRcdTp = [SELECT Id FROM RecordType WHERE name = 'Depot' and isActive = true LIMIT 1];

        Account acc = new Account(
            Name = 'MAURICIO BERNARDO SCHOLTEN E OUTROS [View Hierarchy]',// Account Name
            SAP_Code__c = '0001419277',                                     // SAP Customer Code
            Mobile__c = '000000000000000000',                               // Mobile
            Email__c = 'mauri@xxx7.com',                            // Email
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

        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'System Administrator'];

        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName=acc.Last_Name__c;
        con.MobilePhone ='9876543217';
        con.Phone = '5592619037';
        insert con;        
        
        userrole  usrole = new userrole();
        usrole.Name ='Regional/Zonal Managers for Spain';

        User user = new User();
        user.Alias = 'zonaa2';                                                            
        user.Email = 'skim@skinternational1237.com';                             
        user.ProfileId  = p.ID;                                                     
        user.Username = 'zonal_aaexe1232@upl1223337.com.devbox';                                    
        user.IsActive = true;  
        user.LastName='Terriotory Manager7';
        user.CommunityNickname = 'zonalExe12227 Di'; 
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
        brzlU.Alias = 'zonaa22';                                                            
        brzlU.Email = 'sk@skinternational72.com';                             
        brzlU.ProfileId  = p.ID;                                                     
        brzlU.Username = 'zonal7_aaexe1232@upl122333272.com.devbox1';                                    
        brzlU.IsActive = true;  
        brzlU.LastName='TM';
        brzlU.CommunityNickname = 'zonal7Exe1222272 Di'; 
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
            Active_Forecast_Month__c = 'February',                         // Active Forecast Month
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
        system.debug('Test Class Data - sfs **** -' + sfs);

        Zone__c zone =  new Zone__c();
        zone.SalesOrg__c = sorg.Id;
        zone.Name = 'BU MATO GROSSO7';
        zone.ZoneCode__c = 'BR002';              
        zone.ZonalHead__c = user.Id;
        //  zone.SBU_Code__c = sbu.Id;
        insert zone;

        Region__c region = new Region__c();
        region.Name = 'MATO GROSSO DO SUL2';
        region.RegionCode__c =  'BR0002';
        region.SalesOrg__c = sorg.Id;
        region.Zone__c = zone.Id;
        region.RegionHead__c = user.Id;
        region.BrazilAnalyst__c = brzlU.Id;   
        region.Batch_Number__c='Batch 1';
       // region.SBU__c = sbu.Id;                                                                           
        insert region;

        system.debug('Test Class Data - region **** -' + region);

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

        Customer_and_Region_Mapping__c crm = new Customer_and_Region_Mapping__c(
            Customer_Name__c = acc.id,// Customer Name
            Active__c = true,                      // Active
            CustomerRegion__c = territory.Id,
            Distribution_Channel__c = disbj.id,
            Division__c = div.id,
            Sales_Org__c = sorg.id
        );
        insert crm;
        
        Forecast_Account__c fa = new Forecast_Account__c(
            Account__c = acc.id,
            Territory__c = territory.id,
            Combination_Key__c = territory.TerritoryCode__c+acc.SAP_Code__c,
            OwnerId = user.id,
            Dummy_Customer__c =false
        );
        insert fa;

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
        
        Product2 proCh = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 30 KG',          // Product Name
            Product_Code__c = '000000000005250382',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250382',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 30 KG',     // Product Description
            parent__c = pro.id
        );
        insert proCh;
        
        Product2 pro2 = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 10 KG',          // Product Name
            //RecordTypeId = skuRcdTp.Id,
            Product_Code__c = '000000000005250381',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250381',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 10 KG',     // Product Description
            Parent__c = pro.id
        );
        insert pro2;
        
        Product2 proCh2 = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 40 KG',          // Product Name
            Product_Code__c = '000000000005250383',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250383',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 40 KG',     // Product Description
            parent__c = pro2.id
        );
        insert proCh2;

        ID standardPBID = Test.getStandardPricebookId();
        system.debug('standardPBID ** -' + standardPBID);

        insert new PriceBookEntry(Product2Id=pro.Id, Pricebook2Id=standardPBID, UnitPrice=100, isActive=true);

        Pricebook2 pb = new Pricebook2(
            Name = 'February2022BR0005',                  // Price Book Name
            IsActive = true,                           // Active
            Is_Used_for_Forecast__c = true,            // Is Used for Forecast
            Sales_District__c = region.id,     // Sales District
            Combination_Key__c = 'February2022BR00005',      // Combination Key
            Sales_Org__c = sorg.id,          // Sales Org
            Price_Book_Category__c = 'Forecast',       // Price Book Category
            Type__c = 'Monthly',                       // Type
            Start_Date__c = system.today(),  // Start Date
            Month__c = '02',                           // Month
            End_Date__c = system.today(),   // End Date
            Year__c = '2022'                          // Year
        );
        insert pb;

        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        
        PricebookEntry pbe = new PricebookEntry(
            Product2Id = pro.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'February2022BR00055191000000000005250380'  // Combination Key
        );
        pbeList.add(pbe);
        
        PricebookEntry pbe2 = new PricebookEntry(
            Product2Id = proCh.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'February2022BR00055191000000000005250382'  // Combination Key
        );
        //pbeList.add(pbe2);
        
        PricebookEntry pbe3 = new PricebookEntry(
            Product2Id = pro2.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'February2022BR00055191000000000005250381'  // Combination Key
        );
       // pbeList.add(pbe3);
        
        PricebookEntry pbe4 = new PricebookEntry(
            Product2Id = proCh2.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'February2022BR00055191000000000005250383'  // Combination Key
        );
       // pbeList.add(pbe4);
        
        insert pbeList;
        //insert pbe;

        // Sales Agreement Created for all 12 months
        SalesAgreement sa = new SalesAgreement(
            Status = 'Draft',                                           // Status
            Name = 'SABR114022022',                                       // Name
            StartDate = system.today(),                        // Start Date
            AccountId = acc.id,                                // Account
            ScheduleFrequency = 'Monthly',                                // Schedule Frequency 
            ScheduleCount = 12,                                         // Schedule Count
            EndDate = system.today(),                           // End Date
            PricebookId = pb.id,                              // Price Book
            Region__c = territory.id,                                // Region
            Clone_the_existing_Forecast__c = false,                        // Clone the existing Forecast
            Year__c = '2022',                                             // Year
            Active_Forecast_Month_Number__c = '02',                       // Active Forecast Month (Number)
            Active_Forecast_Month__c = 'February',                             // Active Forecast Month
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
            PricebookEntryId = pbeList[0].id, 
            Last_Consensus__c = 1, 
            Budget_Price__c = 3, 
            Earlier_Planned_Quantity__c = 10
        );
        insert sap;
        
        List<SalesAgreement> saList=new List<SalesAgreement>();
        for(Integer j=1;j<=12;j++){
             String dateStr='01/'+j+'/2022';
            String endDate='02/'+j+'/2022';
            SalesAgreement sAgmt = new SalesAgreement();
            sAgmt.Status = 'Draft';                                           // Status
            sAgmt.Name = 'SABR114022022';                                       // Name
            sAgmt.StartDate = date.parse(dateStr);                        // Start Date
            sAgmt.AccountId = acc.id;                                // Account
            sAgmt.ScheduleFrequency = 'Monthly';                                // Schedule Frequency 
            sAgmt.ScheduleCount = 12;                                         // Schedule Count
            sAgmt.EndDate = date.parse(endDate);                           // End Date
            sAgmt.PricebookId = pb.id;                              // Price Book
            //LastModifiedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),  // Last Modified Date
            //CreatedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),       // Created Date
            sAgmt.Region__c = territory.id;                               // Region
            sAgmt.Clone_the_existing_Forecast__c = true;                        // Clone the existing Forecast
            sAgmt.Year__c = '2022';                                             // Year
            sAgmt.Cloned_from_Sales_Agreement__c = sa.Id;           // Cloned from Sales Agreement
            sAgmt.Active_Forecast_Month_Number__c = '02';                       // Active Forecast Month (Number)
            sAgmt.Active_Forecast_Month__c = 'February';                             // Active Forecast Month
            sAgmt.Sales_Agreement_Schedule_Frequency_Allow__c ='Monthly';
        	saList.add(sAgmt);
        
        }
        insert saList;
        System.debug('saList size :'+saList.size());
        System.debug('saList :'+saList);
        List<SalesAgreementProduct> sapList=new List<SalesAgreementProduct>();
        for(Integer i=0; i<saList.size();i++){
            SalesAgreementProduct sap11 = new SalesAgreementProduct();
            sap11.SalesPrice = 1.00;                                          // Sales Price
            sap11.InitialPlannedQuantity = 1;                                 // Initial Total Quantity
            sap11.DiscountPercentage = 0.00;                                    // Discount Percentage
            sap11.Name = 'Test'; 
            sap11.CurrencyIsoCode = 'USD'; 
            sap11.PricebookEntryId = pbeList[0].id; 
            sap11.SalesAgreementId = saList[i].id; 
            sap11.Last_Consensus__c = 1; 
            sap11.Budget_Price__c = 3; 
            sap11.Earlier_Planned_Quantity__c = 10;
            sapList.add(sap11);   
        }
        insert sapList;
        //EOC
        List<SKU__c> skuList = new List<SKU__c>();
        SKU__c skuobj = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250380',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250380',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj);
        //insert skuobj;
        
        SKU__c skuobj2 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250381',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250381',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj2);
        //insert skuobj2;
        
        SKU__c skuobj3 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250382',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250382',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj3);
        
        SKU__c skuobj4 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250383',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250383',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj4);
        insert skuList;
        
        Stock_In_Channel__c sic = new Stock_In_Channel__c(
            Channel__c = acc.id,   // Channel
            Combination_Key__c = '0001037362',  // Combination Key
            Enable_Last_Month__c = false,       // Enable Last Month
            Sales_Org__c = sorg.Id,   // Sales Org
            Territory__c = territory.Id,   // Territory
            Year__c = '2022'                   // Year
        );
        insert sic;
        
        List<Stock_In_Channel_Detail__c> sicdList = new List<Stock_In_Channel_Detail__c>();
        Stock_In_Channel_Detail__c sicd = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[0].Id,             // SKU
            January_Volume__c = 600.00,                // January Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            January_Sales__c = 0.00,                    // January Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            February_Volume_Co__c = 200.00,
            October_Volume__c = 1000.00,           // October Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd);
        
        Stock_In_Channel_Detail__c sicd2 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[1].Id,             // SKU
            January_Volume__c = 600.00,                // January Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            January_Sales__c = 0.00,                    // January Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            February_Volume_Co__c = 200.00,
            October_Volume__c = 1000.00,           // October Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd2);
        
        Stock_In_Channel_Detail__c sicd3 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[2].Id,             // SKU
            January_Volume__c = 600.00,                // January Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            January_Sales__c = 0.00,                    // January Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            February_Volume_Co__c = 200.00,
            October_Volume__c = 1000.00,           // October Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd3);
        
        Stock_In_Channel_Detail__c sicd4 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[3].Id,             // SKU
            January_Volume__c = 600.00,                // January Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            January_Sales__c = 0.00,                    // January Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            February_Volume_Co__c = 200.00,
            October_Volume__c = 1000.00,           // October Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd4);
        insert sicdList;
        
        List<BW_Data__c> bwList = new List<BW_Data__c>();
        
        BW_Data__c sobj = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[0].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022002',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj2 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[0].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022002',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        

        BW_Data__c sobj3 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[1].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022002',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj4 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[1].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022002',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj5 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[2].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022002',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
       
        
        BW_Data__c sobj6 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[2].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022002',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        

        BW_Data__c sobj7 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[3].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2021',            // Fiscal Year
            Fiscal_Year_Period__c = '2021002',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj8 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[3].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2020',            // Fiscal Year
            Fiscal_Year_Period__c = '2021002',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        bwList.add(sobj);
        bwList.add(sobj2);
        bwList.add(sobj3);
        bwList.add(sobj4);
        bwList.add(sobj5);
        bwList.add(sobj6);
        bwList.add(sobj7);
        bwList.add(sobj8);
        insert bwList;
        
        List<Account_Target__c> atList = new List<Account_Target__c>();
        Account_Target__c at1 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '2',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = pro.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503802022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at1);
        
        Account_Target__c at2 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '2',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = proCh.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503822022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at2);
        
        Account_Target__c at3 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '2',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = pro2.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503812022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at3);
        
        Account_Target__c at4 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '2',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = proCh2.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503832022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at4);
        
        insert atList;
        
        List<Open_Order__c> ooList=new List<Open_Order__c>();
        for(Integer i=1;i<=12;i++){
            String dateStr='01/'+i+'/2023';
            Open_Order__c oo = new Open_Order__c();
            //oo.Business_Unit__c = 'a1M0k000000404k';               // Business Unit
            oo.Customer__c = acc.id;                      // Customer
            oo.Region__c = territory.Id;                        // Region
            if(i==1 || i==2 || i==3){
                oo.Product__c = skuList[0].Id;                       // Product
            }
            else if(i==4 || i==5 || i==6){
                oo.Product__c = skuList[1].Id;                       // Product
            }
            else if(i==7 || i==8 || i==9){
                oo.Product__c = skuList[2].Id;                       // Product
            }
            else if(i==10 || i==11 || i==12){
                oo.Product__c = skuList[3].Id;                       // Product
            }
            
            oo.Data_de_Faturamento__c = date.parse(dateStr);  // Data de Faturamento
            oo.Qty_ORD__c = 20;                                    // Qty ORD
            oo.Net_Sales_ORD__c = 900.00;                            // Net Sales ORD
        	ooList.add(oo);
        }
        for(Integer i=1;i<=12;i++){
            String dateStr='01/'+i+'/2021';
            Open_Order__c oo = new Open_Order__c();
            //oo.Business_Unit__c = 'a1M0k000000404k';               // Business Unit
            oo.Customer__c = acc.id;                      // Customer
            oo.Region__c = territory.Id;                        // Region
            if(i==1 || i==2 || i==3){
                oo.Product__c = skuList[0].Id;                       // Product
            }
            else if(i==4 || i==5 || i==6){
                oo.Product__c = skuList[1].Id;                       // Product
            }
            else if(i==7 || i==8 || i==9){
                oo.Product__c = skuList[2].Id;                       // Product
            }
            else if(i==10 || i==11 || i==12){
                oo.Product__c = skuList[3].Id;                       // Product
            }
            oo.Data_de_Faturamento__c = date.parse(dateStr);  // Data de Faturamento
            oo.Qty_ORD__c = 20;                                    // Qty ORD
            oo.Net_Sales_ORD__c = 900.00;                            // Net Sales ORD
        	ooList.add(oo);
        }
        insert ooList;
        
        Open_Order__c oo3 = new Open_Order__c(
            //Business_Unit__c = 'a1M0k000000404k',               // Business Unit
            Customer__c = acc.id,                      // Customer
            Region__c = territory.Id,                        // Region
            Product__c = skuList[3].Id,                       // Product
            Data_de_Faturamento__c = date.parse('01/1/2022'),  // Data de Faturamento
            Qty_ORD__c = 20,                                    // Qty ORD
            Net_Sales_ORD__c = 900.00                            // Net Sales ORD
        );
        insert oo3;
        
        Open_Order__c oo4 = new Open_Order__c(
            //Business_Unit__c = 'a1M0k000000404k',               // Business Unit
            Customer__c = acc.id,                      // Customer
            Region__c = territory.Id,                        // Region
            Product__c = skuList[0].Id,                       // Product
            Data_de_Faturamento__c = date.parse('01/1/2021'),  // Data de Faturamento
            Qty_ORD__c = 20,                                    // Qty ORD
            Net_Sales_ORD__c = 900.00                            // Net Sales ORD
        );
        insert oo4;
        
        test.startTest();
        List<SalesAgreementProduct> sapListT=[select Id, SalesAgreement.Account.SAP_Code__c,PricebookEntry.Product2.Product_code__c,
                                                                                               SalesAgreement.Region__r.TerritoryCode__c,SalesAgreement.Sale_Org_Code__c,
                                                                                               SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreement.Year__c from SalesAgreementProduct limit 1];
        List<SalesAgreementProductSchedule> sapsListT=[Select id,Name,Combination_Key__c,SalesAgreementProductId from SalesAgreementProductSchedule where SalesAgreementProductId=:sapListT[0].Id limit 1];
        System.debug('sapsListT :'+sapsListT);
        UpdatePOGMetricsHandler.insertCombinationKey(sapsListT);
        
        List<SalesAgreementProductSchedule> sapsList=[Select id,Name,SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c,SalesAgreementProduct.PricebookEntry.Product2.Product_code__c,
                                                                                                       SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c,SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c,
                                                                                                       SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreementProduct.SalesAgreement.Year__c,Combination_Key__c,SalesAgreementProductId,Is_Update_Metrics__c from SalesAgreementProductSchedule];
            System.debug('sapsList test :'+sapsList.size());
        	Map<String,SalesAgreementProductSchedule> maptest = new Map<String,SalesAgreementProductSchedule>();
            for(SalesAgreementProductSchedule sapT:sapsList){
                String combinationKey='';
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Year__c;
                            combinationKey+=sapT.SalesAgreementProduct.PricebookEntry.Product2.Product_code__c;
                            //if(String.isNotBlank(combinationKey)){
                                sapT.Combination_Key__c=combinationKey+sapT.Name;
                            //} 
                sapT.Is_Update_Metrics__c=true;
                if(!maptest.containsKey(sapT.Combination_Key__c)){
                      maptest.put(sapT.Combination_Key__c,sapT);  
                }
            }
        
        System.debug('sapsList test 2 :'+JSON.serializePretty(maptest.values()));
          	update maptest.values();  
            UpdatePOGMetricsHandler.updateMethod(sapsList);
        
        test.stopTest();
	}

    static testMethod void allTheDataForThisTestClass8() {		
		Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Description__c='Brazil';
        sorg.Sales_Org_Code__c='5191';
        sorg.Is_Active_Forecast__c = true;
        insert sorg;
        system.debug('Test Class Data - Sales Org **** -' + sorg);
        /* Report report = new Report(
            FolderName = 'Brazil Reports',
            Name = 'Sales Agreement (Forecast)'
        );
        insert report; */

        RecordType depoRcdTp = [SELECT Id FROM RecordType WHERE name = 'Depot' and isActive = true LIMIT 1];

        Account acc = new Account(
            Name = 'MAURICIO BERNARDO SCHOLTEN E OUTROS [View Hierarchy]',// Account Name
            SAP_Code__c = '0001419278',                                     // SAP Customer Code
            Mobile__c = '000000000000000000',                               // Mobile
            Email__c = 'mauri@xxx8.com',                            // Email
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

        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'System Administrator'];

        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName=acc.Last_Name__c;
        con.MobilePhone ='9876543218';
        con.Phone = '5592619038';
        insert con;        
        
        userrole  usrole = new userrole();
        usrole.Name ='Regional/Zonal Managers for Spain';

        User user = new User();
        user.Alias = 'zonaa2';                                                            
        user.Email = 'skim@skinternational1238.com';                             
        user.ProfileId  = p.ID;                                                     
        user.Username = 'zonal_aaexe1232@upl1223338.com.devbox';                                    
        user.IsActive = true;  
        user.LastName='Terriotory Manager8';
        user.CommunityNickname = 'zonalExe12228 Di'; 
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
        brzlU.Alias = 'zonaa22';                                                            
        brzlU.Email = 'sk@skinternational82.com';                             
        brzlU.ProfileId  = p.ID;                                                     
        brzlU.Username = 'zonal7_aaexe1232@upl122333282.com.devbox1';                                    
        brzlU.IsActive = true;  
        brzlU.LastName='TM';
        brzlU.CommunityNickname = 'zonal7Exe1222282 Di'; 
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
            Active_Forecast_Month__c = 'August',                         // Active Forecast Month
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
        system.debug('Test Class Data - sfs **** -' + sfs);

        Zone__c zone =  new Zone__c();
        zone.SalesOrg__c = sorg.Id;
        zone.Name = 'BU MATO GROSSO8';
        zone.ZoneCode__c = 'BR002';              
        zone.ZonalHead__c = user.Id;
        //  zone.SBU_Code__c = sbu.Id;
        insert zone;

        Region__c region = new Region__c();
        region.Name = 'MATO GROSSO DO SUL2';
        region.RegionCode__c =  'BR0002';
        region.SalesOrg__c = sorg.Id;
        region.Zone__c = zone.Id;
        region.RegionHead__c = user.Id;
        region.BrazilAnalyst__c = brzlU.Id;   
        region.Batch_Number__c='Batch 1';
       // region.SBU__c = sbu.Id;                                                                           
        insert region;

        system.debug('Test Class Data - region **** -' + region);

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

        Customer_and_Region_Mapping__c crm = new Customer_and_Region_Mapping__c(
            Customer_Name__c = acc.id,// Customer Name
            Active__c = true,                      // Active
            CustomerRegion__c = territory.Id,
            Distribution_Channel__c = disbj.id,
            Division__c = div.id,
            Sales_Org__c = sorg.id
        );
        insert crm;
        
        Forecast_Account__c fa = new Forecast_Account__c(
            Account__c = acc.id,
            Territory__c = territory.id,
            Combination_Key__c = territory.TerritoryCode__c+acc.SAP_Code__c,
            OwnerId = user.id,
            Dummy_Customer__c =false
        );
        insert fa;

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
        
        Product2 proCh = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 30 KG',          // Product Name
            Product_Code__c = '000000000005250382',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250382',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 30 KG',     // Product Description
            parent__c = pro.id
        );
        insert proCh;
        
        Product2 pro2 = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 10 KG',          // Product Name
            //RecordTypeId = skuRcdTp.Id,
            Product_Code__c = '000000000005250381',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250381',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 10 KG',     // Product Description
            Parent__c = pro.id
        );
        insert pro2;
        
        Product2 proCh2 = new Product2(
            Name = '2,4-D 880 SP (DEZ GOLD) 40 KG',          // Product Name
            Product_Code__c = '000000000005250383',            // Product Code
            IsActive = true,                                   // Active
            Is_Forecast_Required__c = false,                    // Is Forecast Required
            Combination_Key__c = '5191000000000005250383',     // Combination Key
            Sales_Org__c = sorg.id,                  // Sales Org
            Popular__c = false,                                // Popular
            Power_Brand__c = false,                            // Power Brand
            Division__c = div.id,                   // Division
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Default_Quantity_For_Sales_Agreement__c = 1.00,  // Default Quantity For Sales Agreement
            Description = '2,4-D 880 SP (DEZ GOLD) 40 KG',     // Product Description
            parent__c = pro2.id
        );
        insert proCh2;

        ID standardPBID = Test.getStandardPricebookId();
        system.debug('standardPBID ** -' + standardPBID);

        insert new PriceBookEntry(Product2Id=pro.Id, Pricebook2Id=standardPBID, UnitPrice=100, isActive=true);

        Pricebook2 pb = new Pricebook2(
            Name = 'August2022BR0005',                  // Price Book Name
            IsActive = true,                           // Active
            Is_Used_for_Forecast__c = true,            // Is Used for Forecast
            Sales_District__c = region.id,     // Sales District
            Combination_Key__c = 'August2022BR00005',      // Combination Key
            Sales_Org__c = sorg.id,          // Sales Org
            Price_Book_Category__c = 'Forecast',       // Price Book Category
            Type__c = 'Monthly',                       // Type
            Start_Date__c = system.today(),  // Start Date
            Month__c = '08',                           // Month
            End_Date__c = system.today(),   // End Date
            Year__c = '2022'                          // Year
        );
        insert pb;

        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        
        PricebookEntry pbe = new PricebookEntry(
            Product2Id = pro.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'August2022BR00055191000000000005250380'  // Combination Key
        );
        pbeList.add(pbe);
        
        PricebookEntry pbe2 = new PricebookEntry(
            Product2Id = proCh.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'August2022BR00055191000000000005250382'  // Combination Key
        );
        //pbeList.add(pbe2);
        
        PricebookEntry pbe3 = new PricebookEntry(
            Product2Id = pro2.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'August2022BR00055191000000000005250381'  // Combination Key
        );
       // pbeList.add(pbe3);
        
        PricebookEntry pbe4 = new PricebookEntry(
            Product2Id = proCh2.id,                            // Product
            IsActive = true,                                             // Active
            Pricebook2Id = pb.id,                            // Price Book
            UnitPrice = 95.00,                                           // List Price
            UseStandardPrice = false,                                    // Use Standard Price
            Budget_Price__c = 115.00,                                    // Budget Price
            Combination_Key__c = 'August2022BR00055191000000000005250383'  // Combination Key
        );
       // pbeList.add(pbe4);
        
        insert pbeList;
        //insert pbe;

        // Sales Agreement Created for all 12 months
        SalesAgreement sa = new SalesAgreement(
            Status = 'Draft',                                           // Status
            Name = 'SABR114082022',                                       // Name
            StartDate = system.today(),                        // Start Date
            AccountId = acc.id,                                // Account
            ScheduleFrequency = 'Monthly',                                // Schedule Frequency 
            ScheduleCount = 12,                                         // Schedule Count
            EndDate = system.today(),                           // End Date
            PricebookId = pb.id,                              // Price Book
            Region__c = territory.id,                                // Region
            Clone_the_existing_Forecast__c = false,                        // Clone the existing Forecast
            Year__c = '2022',                                             // Year
            Active_Forecast_Month_Number__c = '08',                       // Active Forecast Month (Number)
            Active_Forecast_Month__c = 'August',                             // Active Forecast Month
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
            PricebookEntryId = pbeList[0].id, 
            Last_Consensus__c = 1, 
            Budget_Price__c = 3, 
            Earlier_Planned_Quantity__c = 10
        );
        insert sap;
        
        List<SalesAgreement> saList=new List<SalesAgreement>();
        for(Integer j=1;j<=12;j++){
             String dateStr='01/'+j+'/2022';
            String endDate='02/'+j+'/2022';
            SalesAgreement sAgmt = new SalesAgreement();
            sAgmt.Status = 'Draft';                                           // Status
            sAgmt.Name = 'SABR114082022';                                       // Name
            sAgmt.StartDate = date.parse(dateStr);                        // Start Date
            sAgmt.AccountId = acc.id;                                // Account
            sAgmt.ScheduleFrequency = 'Monthly';                                // Schedule Frequency 
            sAgmt.ScheduleCount = 12;                                         // Schedule Count
            sAgmt.EndDate = date.parse(endDate);                           // End Date
            sAgmt.PricebookId = pb.id;                              // Price Book
            //LastModifiedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),  // Last Modified Date
            //CreatedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),       // Created Date
            sAgmt.Region__c = territory.id;                               // Region
            sAgmt.Clone_the_existing_Forecast__c = true;                        // Clone the existing Forecast
            sAgmt.Year__c = '2022';                                             // Year
            sAgmt.Cloned_from_Sales_Agreement__c = sa.Id;           // Cloned from Sales Agreement
            sAgmt.Active_Forecast_Month_Number__c = '08';                       // Active Forecast Month (Number)
            sAgmt.Active_Forecast_Month__c = 'August';                             // Active Forecast Month
            sAgmt.Sales_Agreement_Schedule_Frequency_Allow__c ='Monthly';
        	saList.add(sAgmt);
        
        }
        insert saList;
        System.debug('saList size :'+saList.size());
        System.debug('saList :'+saList);
        List<SalesAgreementProduct> sapList=new List<SalesAgreementProduct>();
        for(Integer i=0; i<saList.size();i++){
            SalesAgreementProduct sap11 = new SalesAgreementProduct();
            sap11.SalesPrice = 1.00;                                          // Sales Price
            sap11.InitialPlannedQuantity = 1;                                 // Initial Total Quantity
            sap11.DiscountPercentage = 0.00;                                    // Discount Percentage
            sap11.Name = 'Test'; 
            sap11.CurrencyIsoCode = 'USD'; 
            sap11.PricebookEntryId = pbeList[0].id; 
            sap11.SalesAgreementId = saList[i].id; 
            sap11.Last_Consensus__c = 1; 
            sap11.Budget_Price__c = 3; 
            sap11.Earlier_Planned_Quantity__c = 10;
            sapList.add(sap11);   
        }
        insert sapList;
        //EOC
        List<SKU__c> skuList = new List<SKU__c>();
        SKU__c skuobj = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250380',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250380',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj);
        //insert skuobj;
        
        SKU__c skuobj2 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250381',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250381',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj2);
        //insert skuobj2;
        
        SKU__c skuobj3 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250382',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250382',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj3);
        
        SKU__c skuobj4 = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250383',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '5191000000000005250383',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        skuList.add(skuobj4);
        insert skuList;
        
        Stock_In_Channel__c sic = new Stock_In_Channel__c(
            Channel__c = acc.id,   // Channel
            Combination_Key__c = '0001037362',  // Combination Key
            Enable_Last_Month__c = false,       // Enable Last Month
            Sales_Org__c = sorg.Id,   // Sales Org
            Territory__c = territory.Id,   // Territory
            Year__c = '2022'                   // Year
        );
        insert sic;
        
        List<Stock_In_Channel_Detail__c> sicdList = new List<Stock_In_Channel_Detail__c>();
        Stock_In_Channel_Detail__c sicd = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[0].Id,             // SKU
            January_Volume__c = 600.00,                // January Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            August_Volume_Co__c = 800.00,
            January_Sales__c = 0.00,                    // January Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            February_Volume_Co__c = 200.00,
            October_Volume__c = 1000.00,           // October Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd);
        
        Stock_In_Channel_Detail__c sicd2 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[1].Id,             // SKU
            January_Volume__c = 600.00,                // January Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            August_Volume_Co__c = 800.00,
            January_Sales__c = 0.00,                    // January Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            February_Volume_Co__c = 200.00,
            October_Volume__c = 1000.00,           // October Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd2);
        
        Stock_In_Channel_Detail__c sicd3 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[2].Id,             // SKU
            January_Volume__c = 600.00,                // January Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            August_Volume_Co__c = 800.00,
            January_Sales__c = 0.00,                    // January Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            February_Volume_Co__c = 200.00,
            October_Volume__c = 1000.00,           // October Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd3);
        
        Stock_In_Channel_Detail__c sicd4 = new Stock_In_Channel_Detail__c(
            SKU__c = skuList[3].Id,             // SKU
            January_Volume__c = 600.00,                // January Volume
            Stock_In_Channel__c = sic.Id,  // Stock In Channel
            April_Volume__c = 400.00,               // April Volume
            April_Volume_Co__c = 400.00,               // April Volume
            August_Volume__c = 800.00,              // August Volume
            August_Volume_Co__c = 800.00,
            January_Sales__c = 0.00,                    // January Sales
            December_Volume__c = 1200.00,          // December Volume
            November_Volume__c = 1100.00,          // November Volume
            December_Volume_Co__c = 300.00,         // December Volume (Company)
            February_Volume__c = 200.00,            // February Volume
            February_Volume_Co__c = 200.00,
            October_Volume__c = 1000.00,           // October Volume
            September_Volume__c = 900.00
        );
        sicdList.add(sicd4);
        insert sicdList;
        
        List<BW_Data__c> bwList = new List<BW_Data__c>();
        
        BW_Data__c sobj = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[0].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022008',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj2 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[0].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022008',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        

        BW_Data__c sobj3 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[1].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022008',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj4 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[1].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022008',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj5 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[2].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022008',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
       
        
        BW_Data__c sobj6 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[2].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2022',            // Fiscal Year
            Fiscal_Year_Period__c = '2022008',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        

        BW_Data__c sobj7 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[3].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2021',            // Fiscal Year
            Fiscal_Year_Period__c = '2021008',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        
        
        BW_Data__c sobj8 = new BW_Data__c(
            Name = 'a4A0k000000Gfmg',         // BW Data Name
            Value_Type__c = '10',               // Value Type
            Sales_Org__c = sorg.Id,   // Sales Org
            Account__c = acc.id,     // Account
            SKU__c = skuList[3].Id,         // SKU
            Territory__c = territory.Id,   // Territory
            Fiscal_Year__c = '2020',            // Fiscal Year
            Fiscal_Year_Period__c = '2021008',  // Fiscal Year Period
            Net_Sales__c = 5200.00,             // Net Sales
            Sales_Quantity__c = 144.00,       // Sales Quantity
            Sales_Value__c = 16700.00,          // Sales Value
            CurrencyIsoCode = 'USD'
        );
        bwList.add(sobj);
        bwList.add(sobj2);
        bwList.add(sobj3);
        bwList.add(sobj4);
        bwList.add(sobj5);
        bwList.add(sobj6);
        bwList.add(sobj7);
        bwList.add(sobj8);
        insert bwList;
        
        List<Account_Target__c> atList = new List<Account_Target__c>();
        Account_Target__c at1 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '8',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = pro.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503802022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at1);
        
        Account_Target__c at2 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '8',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = proCh.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503822022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at2);
        
        Account_Target__c at3 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '8',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = pro2.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503812022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at3);
        
        Account_Target__c at4 = new Account_Target__c(
            Region__c = territory.Id,                        // Region
            Month__c = '8',                                            // Month
            Year__c = '2022',                                          // Year
            Quantity__c = 500.00,                                   // Quantity
            Price__c = 222.22,                                       // Price
            Product__c = proCh2.Id,                            // Product
            Combination_Key__c = 'BR21051910000000000052503832022',  // Combination Key
            Sales_Org__c = sorg.Id                          // Sales Org
        );
        atList.add(at4);
        
        insert atList;
        
        List<Open_Order__c> ooList=new List<Open_Order__c>();
        for(Integer i=1;i<=12;i++){
            String dateStr='01/'+i+'/2023';
            Open_Order__c oo = new Open_Order__c();
            //oo.Business_Unit__c = 'a1M0k000000404k';               // Business Unit
            oo.Customer__c = acc.id;                      // Customer
            oo.Region__c = territory.Id;                        // Region
            if(i==1 || i==2 || i==3){
                oo.Product__c = skuList[0].Id;                       // Product
            }
            else if(i==4 || i==5 || i==6){
                oo.Product__c = skuList[1].Id;                       // Product
            }
            else if(i==7 || i==8 || i==9){
                oo.Product__c = skuList[2].Id;                       // Product
            }
            else if(i==10 || i==11 || i==12){
                oo.Product__c = skuList[3].Id;                       // Product
            }
            
            oo.Data_de_Faturamento__c = date.parse(dateStr);  // Data de Faturamento
            oo.Qty_ORD__c = 20;                                    // Qty ORD
            oo.Net_Sales_ORD__c = 900.00;                            // Net Sales ORD
        	ooList.add(oo);
        }
        for(Integer i=1;i<=12;i++){
            String dateStr='01/'+i+'/2021';
            Open_Order__c oo = new Open_Order__c();
            //oo.Business_Unit__c = 'a1M0k000000404k';               // Business Unit
            oo.Customer__c = acc.id;                      // Customer
            oo.Region__c = territory.Id;                        // Region
            if(i==1 || i==2 || i==3){
                oo.Product__c = skuList[0].Id;                       // Product
            }
            else if(i==4 || i==5 || i==6){
                oo.Product__c = skuList[1].Id;                       // Product
            }
            else if(i==7 || i==8 || i==9){
                oo.Product__c = skuList[2].Id;                       // Product
            }
            else if(i==10 || i==11 || i==12){
                oo.Product__c = skuList[3].Id;                       // Product
            }
            oo.Data_de_Faturamento__c = date.parse(dateStr);  // Data de Faturamento
            oo.Qty_ORD__c = 20;                                    // Qty ORD
            oo.Net_Sales_ORD__c = 900.00;                            // Net Sales ORD
        	ooList.add(oo);
        }
        insert ooList;
        
        Open_Order__c oo3 = new Open_Order__c(
            //Business_Unit__c = 'a1M0k000000404k',               // Business Unit
            Customer__c = acc.id,                      // Customer
            Region__c = territory.Id,                        // Region
            Product__c = skuList[3].Id,                       // Product
            Data_de_Faturamento__c = date.parse('01/1/2022'),  // Data de Faturamento
            Qty_ORD__c = 20,                                    // Qty ORD
            Net_Sales_ORD__c = 900.00                            // Net Sales ORD
        );
        insert oo3;
        
        Open_Order__c oo4 = new Open_Order__c(
            //Business_Unit__c = 'a1M0k000000404k',               // Business Unit
            Customer__c = acc.id,                      // Customer
            Region__c = territory.Id,                        // Region
            Product__c = skuList[0].Id,                       // Product
            Data_de_Faturamento__c = date.parse('01/1/2021'),  // Data de Faturamento
            Qty_ORD__c = 20,                                    // Qty ORD
            Net_Sales_ORD__c = 900.00                            // Net Sales ORD
        );
        insert oo4;
        
        test.startTest();
        List<SalesAgreementProduct> sapListT=[select Id, SalesAgreement.Account.SAP_Code__c,PricebookEntry.Product2.Product_code__c,
                                                                                               SalesAgreement.Region__r.TerritoryCode__c,SalesAgreement.Sale_Org_Code__c,
                                                                                               SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreement.Year__c from SalesAgreementProduct limit 1];
        List<SalesAgreementProductSchedule> sapsListT=[Select id,Name,Combination_Key__c,SalesAgreementProductId from SalesAgreementProductSchedule where SalesAgreementProductId=:sapListT[0].Id limit 1];
        System.debug('sapsListT :'+sapsListT);
        UpdatePOGMetricsHandler.insertCombinationKey(sapsListT);
        
        List<SalesAgreementProductSchedule> sapsList=[Select id,Name,SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c,SalesAgreementProduct.PricebookEntry.Product2.Product_code__c,
                                                                                                       SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c,SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c,
                                                                                                       SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreementProduct.SalesAgreement.Year__c,Combination_Key__c,SalesAgreementProductId,Is_Update_Metrics__c from SalesAgreementProductSchedule];
            System.debug('sapsList test :'+sapsList.size());
        	Map<String,SalesAgreementProductSchedule> maptest = new Map<String,SalesAgreementProductSchedule>();
            for(SalesAgreementProductSchedule sapT:sapsList){
                String combinationKey='';
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c;
                            combinationKey+=sapT.SalesAgreementProduct.SalesAgreement.Year__c;
                            combinationKey+=sapT.SalesAgreementProduct.PricebookEntry.Product2.Product_code__c;
                            //if(String.isNotBlank(combinationKey)){
                                sapT.Combination_Key__c=combinationKey+sapT.Name;
                            //} 
                sapT.Is_Update_Metrics__c=true;
                if(!maptest.containsKey(sapT.Combination_Key__c)){
                      maptest.put(sapT.Combination_Key__c,sapT);  
                }
            }
        
        System.debug('sapsList test 2 :'+JSON.serializePretty(maptest.values()));
          	update maptest.values();  
            UpdatePOGMetricsHandler.updateMethod(sapsList);
        
        test.stopTest();
	}
    
}