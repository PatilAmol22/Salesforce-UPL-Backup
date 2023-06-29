// Tests for MassSASubmitApprovalExtensionTest
@isTest
private class MassSASubmitApprovalExtensionTest {
    
    
    static testMethod void testSubmitApprovalRecords() {
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Profile p =  [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person' LIMIT 1];
        
        Sales_Org__c sorg = new Sales_Org__c();
        sorg.Name = 'Brazil';
        sorg.Sales_Org_Code__c = '5191';
        insert sorg;
        
        Depot__c dep = new Depot__c(
            Name = 'UPL Do Brasil - Aparecida de Goiania',   // Depot Name
            Country__c = 'Brazil',                           // Country
            Depot_Code__c = 'BR04',                          // Depot Code
            Active__c = true,                                // Active
            SalesOrg__c = sorg.Id                           // Sales Org
        );
        insert dep;
        
        userrole  usrole = new userrole();
        usrole.Name ='Sales Person (BR389)';
        
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
        
        
        Division__c div = new Division__c();
        div.Name = 'Decco';
        div.Description__c = 'Decco';
        div.Division_Code__c = 'DC';
        insert div;      
        
        Price_Book__c pbook =  new Price_Book__c();
        pbook.Name = 'BRL : Price List [DO NOT MODIFY]';
        pbook.Division__c = div.Id;
        pbook.Valid_FROM__c = system.today();
        pbook.Expiry_Date__c = system.today()+360;
        insert pbook;
        
        Distribution_Channel__c dChannel =  new Distribution_Channel__c();
        dChannel.Name = '10';
        dChannel.Distribution_Channel_Code__c = '10';
        
        insert dChannel;
        
        
        //account details  
        Account acc = new Account();
        acc.Name = 'LEONARDO PASSINATO';
        acc.Email__c = 'ganesh039@gmail.com';
        acc.Last_Name__c = 'PASSINATO';
        acc.SAP_Code__c = '2028843';
        acc.RecordTypeId = devRecordTypeId;
        acc.Mobile__c = '9967341759';
        acc.Phone = '01234567891';
        acc.Sales_Org__c = sorg.Id;
        acc.Division__c = Div.Id;
        acc.Distribution_Channel__c = dChannel.Id;
        acc.BillingCity = 'MINEIROS';
        acc.SAP_Code__c = '2028843';
        acc.Depot_Code__c = dep.Id;
        acc.Tax_Number_3__c = '114415455';
        acc.Tax_Number_1__c = '114414523';
        acc.Customer_Region__c = 'AC';
        acc.Customer_Group__c = '001';
        acc.Program_Margin_Discount__c = 0.00;
        acc.Active__c = true;
        acc.Search_Terms_1__c = 'LEONARDO PASSINATO';
        acc.Search_Terms_2__c = 'FAZ SEUBAK';
        acc.key_account_manager__c = user.Id;
        acc.Price_Conversion_Group__c = 'A';
        insert acc;
        
        Sales_Forecast_Setting__c sfs = new Sales_Forecast_Setting__c(
            //Sales_Org__c = sorg.id,                       // Sales Org //Sales_Org__c
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
        region.BrazilAnalyst__c = brzlU.Id; //brzlU.Id   
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
        
        Pricebook2 pb = new Pricebook2(
            Name = 'June2021BR0005',                  // Price Book Name
            IsActive = true,                           // Active
            Is_Used_for_Forecast__c = true,            // Is Used for Forecast
            Sales_District__c = region.id,     // Sales District
            Combination_Key__c = 'June2021BR00005',      // Combination Key
            Sales_Org__c = sorg.id,          // Sales Org
            Price_Book_Category__c = 'Forecast',       // Price Book Category
            Type__c = 'Monthly',                       // Type
            Start_Date__c = system.today(),  // Start Date
            Month__c = '06',                           // Month
            End_Date__c = system.today(),   // End Date
            Year__c = '2021'                          // Year
        );
        insert pb;
        
        SalesAgreement sa = new SalesAgreement(
            Status = 'Draft',                                           // Status
            Name = 'SABR114052021',                                       // Name
            StartDate = system.today(),                        // Start Date
            //CurrencyIsoCode = 'USD - U.s. Dollar',//
            AccountId = acc.id,                                // Account
            ScheduleFrequency = 'Monthly',                                // Schedule Frequency 
            OwnerId = user.id,
            Currency__c = 'USD - U.s. Dollar',//
            ScheduleCount = 12,                                         // Schedule Count
            EndDate = system.today()+360,//                           // End Date
            PricebookId = pb.id,                              // Price Book
            //LastModifiedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),  // Last Modified Date
            //CreatedDate = Datetime.valueOf('10-5-2021 6:21 pm:00'),       // Created Date
            Region__c = territory.id,//                                // Region
            Clone_the_existing_Forecast__c = false,                        // Clone the existing Forecast
            Year__c = '2022',//                                             // Year
            //Cloned_from_Sales_Agreement__c = '0YA0k000000006o',           // Cloned from Sales Agreement
            Active_Forecast_Month_Number__c = '05',//                       // Active Forecast Month (Number)
            Active_Forecast_Month__c = 'May',//                             // Active Forecast Month
            Sales_Agreement_Schedule_Frequency_Allow__c ='Monthly'
        );
        insert sa;
        
        
        List<SalesAgreement> sagm = [Select Id, name from SalesAgreement Where id =: sa.id Limit 1];
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(sagm);
        sc.setSelected(sagm);
        MassSASubmitApprovalExtension extension = new MassSASubmitApprovalExtension(sc);
        
        System.assertEquals('1', extension.getMySelectedSize());
        System.assertNotEquals(null, extension.submitApprovalRecords());
        
    }
    
    static testMethod void testSelectedSize() {
        List<Lead> leads = new List<Lead>();
        leads.add(new Lead(LastName='test'));
        
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(leads);
        sc.setSelected(leads);
        MassSASubmitApprovalExtension extension = new MassSASubmitApprovalExtension(sc);
        
        System.assertEquals('1', extension.getMySelectedSize());
    }
    
}