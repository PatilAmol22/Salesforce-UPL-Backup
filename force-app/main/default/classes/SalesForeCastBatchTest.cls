@isTest (SeeAllData=true)
public class SalesForeCastBatchTest {
    static testMethod void validateHelloWorld() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
               
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Description__c='Brazil';
        sorg.Sales_Org_Code__c='5191';
        sorg.Is_Active_Forecast__c = true;
        insert sorg;
        //system.debug('Test Class Data - Sales Org **** -' + sorg);
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

        /* Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName=acc.Last_Name__c;
        con.MobilePhone ='9876543210';
        con.Phone = '5592619031';
        insert con;  */       
        
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
        region.Batch_Number__c = 'Batch 1';                                                                           
        insert region;

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
        
        Forecast_Account__c facc = new Forecast_Account__c();
        facc.Account__c = acc.id;
        facc.Territory__c = territory.id;
        facc.Combination_Key__c = territory.TerritoryCode__c+acc.SAP_Code__c;
        insert facc;

        String recordType = 'Distributor';
        String accountType = 'Sold To Party';
        Boolean forecastReq = true;
        String month ='10';
        String year = '2022';
        String email = 'test@yz.com';
        String batch1 = 'Batch 1';

        Sales_Forecast_Setting__c sfs = new Sales_Forecast_Setting__c(
            Sales_Org__c = sorg.id,                       // Sales Org
            Configuration_on_Sales_Forecast_Metric__c = 3.00,         // % Configuration on Sales Forecast Metric
            Sales_Agreement_Schedule_Frequency_Allow__c = 'Monthly',  // Sales Agreement Schedule Frequency Allow
            Active_Forecast_Month__c = 'October',                         // Active Forecast Month
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
        
        String query1 = 'SELECT Id, Name, Account__c, Territory__c, Territory__r.Region__c, '+
                                    +' Account__r.SAP_Code__c, Territory__r.TerritoryCode__c, Territory__r.TerritoryManager__c, '+
                                    +' Territory__r.Region__r.RegionHead__c '+
                                    +' FROM Forecast_Account__c WHERE Account__r.RecordType.Name = \''+ recordType + '\' '+
                                    +' AND Account__r.Account_Type__c = \''+ accountType + '\' AND '+
                                    +' Account__r.Sales_Org__r.Sales_Org_Code__c = \''+ sorg.Sales_Org_Code__c + '\' AND '+
                                    +' Territory__r.Region__r.Batch_Number__c = \''+ batch1 + '\' LIMIT 1';

        SalesForeCastBatch bcn = new SalesForeCastBatch(month,year,sfs,query1,'AutoProgram',email,sorg.Sales_Org_Code__c);
        ID batchprocessid = Database.executeBatch(bcn,1);
        
    }
}