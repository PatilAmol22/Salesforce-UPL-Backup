@isTest
public class CreditInfoShare_Test {
    
    static testMethod void method2(){
    
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person' LIMIT 1];
        List<String> CredInfoID = new List<String>();
        Test.startTest();
        
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
        
        User user1 = new User(
            Alias = 'CASSIO',                                                             // Alias
            Email = 'shama@skinternational.com',                                          // Email
            ProfileId = p.Id,                                                            // Profile
            Username = '20005676@uniphos5.com.upltest',                                    // Username
            IsActive = true,                                                              // Active
            CommunityNickname = 'XCASSIO',     
            LastName = 'DIRETOR DE', 
            Title = 'DIRETOR DE NEGOCIOS NORTE',                                          // Title
            TimeZoneSidKey = 'America/Sao_Paulo',                      
            LocaleSidKey = 'en_IN',                                                       // Locale
            LanguageLocaleKey = 'pt_BR',                                                  // Language
            ForecastEnabled = false,                                                      // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',                                              // Email Encoding
            Territory__c = 'GESTÃO NORTE',                                                // Territory
            EnableDepot__c = false,                                                       // Enable Depot
            Show_List_Value__c = true,                                                    // Show List Value (Brazil)
            Show_Credit_LIMIT__c = false,                                                 // Show Credit LIMIT
            Show_Inventory__c = false,                                                    // Show Inventory
            Show_Pricing__c = false,                                                      // Show Pricing
            Show_Inventory_Column__c = false,                                             // Show Inventory Column
            Show_InTransit__c = false,                                                    // Show InTransit
            Show_InTransit_Values__c = false                                             // Show InTransit Values
        );
        
        
        User user2 = new User(
            Alias = 'MARCELO',                                                                       // Alias
            Email = 'ganesh.chaurasia@skinternational.com',                                           // Email
            ProfileId = p.Id,                                                                 // Profile
            Username = '200054786@uniphos.com.upltest',                                             // Username
            IsActive = true,   
            LastName = 'Gavazi', 
            CommunityNickname = 'XMARCELO',   // Nickname
            TimeZoneSidKey = 'America/Sao_Paulo',           
            LocaleSidKey = 'en_IN',                                                 // Locale
            LanguageLocaleKey = 'pt_BR',                                                        // Language
            ForecastEnabled = false,                                                               // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',            // Email Encoding
            EnableDepot__c = false,                                                                // Enable Depot
            Show_List_Value__c = false,                                                            // Show List Value (Brazil)
            Show_Credit_LIMIT__c = false,                                                          // Show Credit LIMIT
            Show_Inventory__c = false,                                                             // Show Inventory
            Show_Pricing__c = false,                                                               // Show Pricing
            Show_Inventory_Column__c = false,                                                      // Show Inventory Column
            Show_InTransit__c = false,                                                             // Show InTransit
            Show_InTransit_Values__c = false                                                     // Show InTransit Values
        );
        insert user2;
        
        SBU__c sbu = new SBU__c(
            SBUUser__c = user2.Id,                                                    // SBU User
            Brazil_SBU_Name__c = 'GESTÃO NORTE',                                        // Brazil SBU Name
            SBUCode__c = 'BR1',                                                         // SBU Code
            SalesOrg__c = sorg.Id                                                      // Sales Org
        );
        insert sbu;
        
        Zone__c zone =  new Zone__c();
        zone.SalesOrg__c = sorg.Id;
        zone.Name = 'BU MATO GROSSO';
        zone.ZoneCode__c = 'BR10';              
        zone.ZonalHead__c = user2.Id;
        //  zone.SBU_Code__c = sbu.Id;
        insert zone;
        
        
        Region__c region = new Region__c();
        region.Name = 'MATO GROSSO DO SUL';
        region.RegionCode__c =  'BR1010';
        region.SalesOrg__c = sorg.Id;
        region.Zone__c = zone.Id;
        region.RegionHead__c = user1.Id;           
        region.SBU__c = sbu.Id;                                                                           
        insert region;
        
        Territory_Distributor__c territory =  new Territory_Distributor__c();
        territory.Name = 'Araxá';
        territory.TerritoryCode__c = 'BR165';
        territory.SBU__c = sbu.Id;     
        territory.Region__c = region.id;
        territory.SalesOrg__c = sorg.Id;
        territory.RegionDesciption__c = 'BR1001102 CHPS';                       
        territory.Zone__c = zone.Id;
        territory.TerritoryManager__c = user1.Id;       
        insert territory;
        
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
        Account acc = new Account();
        try{ 
            
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
          
            acc.Depot_Code__c = dep.Id;
            acc.Customer_Group__c = '001';
            acc.Active__c = true;
            insert acc;
            System.debug('Inside try Debug----> ');
        }catch(Exception ex){
            
            System.debug('Error log in test class - '+ ex.getMessage());
        }
        
        Contact con = new Contact(
            Account = acc,                          // Account Name
            Title = 'Test Contact',  // Title
            LastName='Khatri',
            Phone = '(229)942-8338',                   // Phone
            Email = 'mblack@cniag.com',
            Owned_Land_in_Acer__c = 20,
            Leased_Land_in_Acer__c =30
            
        );
        insert con;
        
        Customer_and_Region_Mapping__c custRegMap1 = new Customer_and_Region_Mapping__c(
            Customer_Name__c = acc.Id,  // Customer Name
            CustomerRegion__c = territory.Id,   // Customer Region
            Active__c = true                       // Active
        );
        insert custRegMap1;
        
        Customer_and_Region_Mapping__c custRegMap2 = new Customer_and_Region_Mapping__c(
            Customer_Name__c = acc.Id,  // Customer Name
            CustomerRegion__c = territory.Id,   // Customer Region
            Active__c = true                       // Active
        );
        insert custRegMap2;
        
        Credit_Info__c ciobj = new Credit_Info__c(
            Distributor_Code__c = '00010333235191',        // Distributor Code
            Distributor__c = acc.Id,              // Distributor
            Limite_Clean__c = 2000000.00,                    // Limite Clean
            Credit_Exposure__c = 221600.00,                  // Credit Exposure
            Limite_Linha__c = 3500000.00,                    // Limite Linha
            Credit_rep_group__c = 'ZB2',                     // Credit rep. group
            Receivalbles__c = 427800.00,                     // Receivalbles
            Cust_cred_group__c = 'BR09',                     // Cust.cred.group
            Special_Liabil__c = 206200.00,                   // Special Liabil
            Next_int_review__c = System.today(),//System.Date('30-6-2018'),  // Next int.review
            Cred_info_number__c = 'C+',                      // Cred.info number
            Credit_Account__c = '0001033323',                // Sharing Check
            Credit_Limit__c = 2000000.00,                    // Credit Limit
            Balance_Limit__c = 1778400.00,                   // Balance Limit
            Internal_Limit__c = 3500000.00,                  // Internal Limit
            Percentage_Used__c = 11.00,                      // Percentage Used
            Used_Limit__c = 221600.00,                       // Used Limit
            Sum_Open_Item__c = 221600,                       // Outstanding
            Sales_Org__c = sorg.Id                // Sales Org
        );
        insert ciobj;  
       
        CredInfoID.add(ciobj.Id);        
        CreditInfo_Share_Brazil.assignNshare(CredInfoID);
        
        Test.stopTest(); 
    }

}