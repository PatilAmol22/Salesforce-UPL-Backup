@isTest
public class BrazilAccountShareTest {
    
    @isTest
    public static void testMethod1(){
        Profile p =  [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person' LIMIT 1];
        
        Sales_Org__c sorg = new Sales_Org__c();
        sorg.Name = 'Brazil';
        sorg.Sales_Org_Code__c = '5191';
        insert sorg;
        
        User userTerMan1 = new User(
            Alias = 'WES',                                                             // Alias
            Email = 'shama11@skinternational.com',                                           // Email
            ProfileId = p.Id,                                                              // Profile
            Username = '20205489@uniphos3.com.upltest',                                     // Username
            IsActive = true,                                                               // Active
            LastName = 'BARBOSA DErCAMARGO', 
            CommunityNickname = 'Xyu ',                                                // Nickname
            Title = 'RuiR',                                                              // Title
            TimeZoneSidKey = 'America/Sao_Paulo',      
            LocaleSidKey = 'en_IN',                                            
            LanguageLocaleKey = 'pt_BR',                                                 // Language
            ForecastEnabled = false,                                                       // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',   
            Territory__c = 'Araxá',                                              // Territory
            EnableDepot__c = false,                                                        // Enable Depot
            Show_List_Value__c = false,                                                    // Show List Value (Brazil)
            Show_Credit_LIMIT__c = false,                                                  // Show Credit LIMIT
            Show_Inventory__c = false,                                                     // Show Inventory
            Show_Pricing__c = false,                                                       // Show Pricing
            Show_Inventory_Column__c = false,                                              // Show Inventory Column
            Show_InTransit__c = false,                                                     // Show InTransit
            Show_InTransit_Values__c = false , 
            country = 'Brazil'
        );
        insert userTerMan1;
        SBU__c sbu = new SBU__c(
            SBUUser__c = userTerMan1.Id,                                                    // SBU User
            Brazil_SBU_Name__c = 'GESTÃO NORTE',                                        // Brazil SBU Name
            SBUCode__c = 'BR1',
            GSD__c =userTerMan1.Id,
            REH__c = userTerMan1.Id,
            SalesOrg__c = sorg.Id                                                      // Sales Org
        );
        insert sbu;
        
        Zone__c zone =  new Zone__c();
        zone.SalesOrg__c = sorg.Id;
        zone.Name = 'BU MATO GROSSO';
        zone.ZoneCode__c = 'BR10';              
        zone.ZonalHead__c = userTerMan1.Id;
        //  zone.SBU_Code__c = sbu.Id;
        insert zone;
        
        Region__c region = new Region__c();
        region.Name = 'MATO GROSSO DO SUL';
        region.RegionCode__c =  'BR1010';
        region.SalesOrg__c = sorg.Id;
        region.Zone__c = zone.Id;
        region.RegionHead__c = userTerMan1.Id;
        region.BrazilAnalyst__c = userTerMan1.Id;    
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
        territory.TerritoryManager__c = userTerMan1.Id; //userTerMan
        //territory.TerritoryManagerActive__c = true;
        insert territory;
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
         Division__c div = new Division__c();
        div.Name = 'Decco';
        div.Description__c = 'Decco';
        div.Division_Code__c = 'DC';
        insert div; 
        
           Distribution_Channel__c dChannel =  new Distribution_Channel__c();
        dChannel.Name = '10';
        dChannel.Distribution_Channel_Code__c = '10';
        
        insert dChannel;
        
        Depot__c dep = new Depot__c(
            Name = 'UPL Do Brasil - Aparecida de Goiania',   // Depot Name
            Country__c = 'Brazil',                           // Country
            Depot_Code__c = 'BR04',                          // Depot Code
            Active__c = true,                                // Active
            SalesOrg__c = sorg.Id                           // Sales Org
        );
        insert dep;
        
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
        acc.key_account_manager__c = userTerMan1.Id;
        acc.Price_Conversion_Group__c = 'A';
        insert acc;
        
        
         Customer_and_Region_Mapping__c custRegMap = new Customer_and_Region_Mapping__c(
            Customer_Name__c = acc.Id,  // Customer Name
            CustomerRegion__c = territory.Id,   // Customer Region
            Active__c = true
           
        );
        insert custRegMap;
        
        system.runAs(userTerMan1){
            BrazilAccountShare.getKeyCustomers(userTerMan1.Id, 
                                              '',
                                              '',
                                              acc.Id);
             BrazilAccountShare.getKeyCustomers(userTerMan1.Id, 
                                              'CONTRATO MÃE',
                                              '',
                                              acc.Id);
             BrazilAccountShare.getKeyCustomers(userTerMan1.Id, 
                                              'ORDEM FILHA',
                                              '',
                                              acc.Id);
          BrazilAccountShare.getKeyCustomersForSDM('BR165','001');  
        }

    }
    
}