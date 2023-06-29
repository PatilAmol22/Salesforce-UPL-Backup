@isTest
public class OrderRequestControllerTest {
    
    
    private Static String  SO_id='';
    //inserting all data into database for testing 
    @testSetup
    static void allTheDataForThisTestClass() {
        test.startTest();
        Id recordTypeId1 = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Sales Order').getRecordTypeId(); 
        Id recordTypeId = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Simulation').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Profile p =  [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person' LIMIT 1];                     //Brazil Sales Person Profile
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Office Manager' LIMIT 1];            //Brazil Sales Office Manager Profile
        Profile p2 = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Director' LIMIT 1];                  //Brazil Sales Director Profile
        Profile p3 = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales District Manager' LIMIT 1];          // Brazil Sales District Manager Profile
        Profile p4 = [SELECT Id FROM Profile WHERE Name = 'Brazil Customer Service User' LIMIT 1];           // Brazil Customer Service User Profile
        Profile p5 = [SELECT Id FROM Profile WHERE Name = 'Brazil Barter Manager' LIMIT 1];                  // Brazil Barter Mananger User Profile
        
        //Priya
        Trigger_Settings__c newtri = new Trigger_Settings__c();
        newtri.Name = 'SOLICombKeyTrigger';
        newtri.isActive__c = true;
        insert newtri;
        
        Trigger_Settings__c trig = new Trigger_Settings__c();
        trig.Name = 'salesOrderShareTriger';
        trig.isActive__c = true;
        insert trig;
        //Priya
        
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
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name = 'FarmerCode';
        auto.Sequence__c = '11';
        insert auto;
        
        User SBUuser = new User(
            Alias = 'CASSIO',                                                             // Alias
            Email = 'shama@skinternational.com',                                          // Email
            ProfileId = p2.Id,                                                            // Profile
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
        
        insert SBUuser;
        
        SBU__c sbu = new SBU__c(
            SBUUser__c = SBUuser.Id,                                                    // SBU User
            Brazil_SBU_Name__c = 'GESTÃO NORTE',                                        // Brazil SBU Name
            SBUCode__c = 'BR1',
            GSD__c =SBUuser.Id,
            REH__c = SBUuser.Id,
            SalesOrg__c = sorg.Id                                                      // Sales Org
        );
        insert sbu;
        
        
        //added 
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
        
        //added 
        User userTerManTerri = new User(
            Alias = 'WES',                                                             // Alias
            Email = 'userTerManTerri@skinternational.com',                                           // Email
            ProfileId = p.Id,                                                              // Profile
            Username = '12320205489@uniphos3.com.upltest',                                     // Username
            IsActive = false,                                                               // Active
            LastName = 'BARBOSA DErCAMARGO Test7', 
            CommunityNickname = 'Xyu Test7 ',                                                // Nickname
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
        insert userTerManTerri;
        
        
        User BarterUser = new User(
            Alias = 'MARCELO',                                                                       // Alias
            Email = 'ganesh.chaurasia@skinternational.com',                                           // Email
            ProfileId = p5.Id,                                                                 // Profile
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
        
        insert BarterUser;
        
        
        User ZonalHeadUser = new User(
            Alias = 'GERSON',                                                            
            Email = 'shama@skinternational.com',                                         
            ProfileId = p1.Id,                                                            
            Username = '20000679@uniphos6.com.upltest',                                   
            IsActive = true,                                                              
            LastName = 'LUIZ LEVANDOWSKI', 
            CommunityNickname = 'XGERSON ',  
            Title = 'GERENTE SR DE NEGOCIOS',                                          
            TimeZoneSidKey = 'America/Sao_Paulo',      
            LocaleSidKey = 'en_IN',                                      
            LanguageLocaleKey = 'pt_BR',                                                
            ForecastEnabled = false,                                                      
            EmailEncodingKey = 'ISO-8859-1',  
            Zone__c = 'BU MATO GROSSO',                                                 
            EnableDepot__c = false,                                                       
            Show_List_Value__c = true,                                                   
            Show_Credit_LIMIT__c = false,                                                
            Show_Inventory__c = false,                                                 
            Show_Pricing__c = false,                                                     
            Show_Inventory_Column__c = false,                                            
            Show_InTransit__c = false,                                                    
            Show_InTransit_Values__c = false                                            
        );
        insert ZonalHeadUser;
        
        
        Zone__c zone =  new Zone__c();
        zone.SalesOrg__c = sorg.Id;
        zone.Name = 'BU MATO GROSSO';
        zone.ZoneCode__c = 'BR10';              
        zone.ZonalHead__c = ZonalHeadUser.Id;
        //  zone.SBU_Code__c = sbu.Id;
        insert zone;
        
        User regioHeadUser = new User(
            Alias = 'ALEXANDE',                                                              // Alias
            Email = 'shama@skinternational.com',                                             // Email
            ProfileId = p3.Id,                                                               // Profile
            Username = '20004449@uniphos1.com.upltest',                                       // Username
            IsActive = true,                                                                 // Active
            CommunityNickname = 'XALEXANDER',                                                 // Nickname
            LastName = 'PARAGUACU MONTEIRO DE OLIVEIRA', 
            Title = 'GERENTE COMERCIAL',                                                     // Title
            TimeZoneSidKey = 'America/Sao_Paulo',         
            LocaleSidKey = 'en_IN',                                          
            LanguageLocaleKey = 'pt_BR',                                                   // Language
            ForecastEnabled = false,                                                         // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',      
            Region__c = 'MATO GROSSO DO SUL',                                                // Region
            EnableDepot__c = false,                                                          // Enable Depot
            Show_List_Value__c = true,                                                       // Show List Value (Brazil)
            Show_Credit_LIMIT__c = false,                                                    // Show Credit LIMIT
            Show_Inventory__c = false,                                                       // Show Inventory
            Show_Pricing__c = false,                                                         // Show Pricing
            Show_Inventory_Column__c = false,                                                // Show Inventory Column
            Show_InTransit__c = false,                                                       // Show InTransit
            Show_InTransit_Values__c = false                                                // Show InTransit Values
        );
        insert regioHeadUser;
        
        User BrazilAnaUser = new User(
            Alias = 'MILENI',                                                                               // Alias
            Email = 'shama@skinternational.com',                                                            // Email
            ProfileId = p4.Id,                                                                              // Profile
            Username = '20004688@uniphos2.com.upltest',                                                      // Username
            IsActive = true,                                                                                // Active
            CommunityNickname = 'XMILENI .PEREIRA DA SILVA',                                                 // Nickname
            LastName = 'PEREIRA DA SILVA', 
            Title = 'ANALISTA DE CUSTOMER SERVICE PL',                                                      // Title
            TimeZoneSidKey = 'America/Sao_Paulo',                       
            LocaleSidKey = 'en_IN',                                                          
            LanguageLocaleKey = 'pt_BR',                                                                  // Language
            ForecastEnabled = false,                                                                        // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',                     
            Territory__c = 'ADMINISTRAÇÃO DE VENDAS',                                                       // Territory
            EnableDepot__c = false,                                                                         // Enable Depot
            Show_List_Value__c = false,                                                                     // Show List Value (Brazil)
            Show_Credit_LIMIT__c = false,                                                                   // Show Credit LIMIT
            Show_Inventory__c = false,                                                                      // Show Inventory
            Show_Pricing__c = false,                                                                        // Show Pricing
            Show_Inventory_Column__c = false,                                                               // Show Inventory Column
            Show_InTransit__c = false,                                                                      // Show InTransit
            Show_InTransit_Values__c = false                                                              // Show InTransit Values
        );
        
        insert BrazilAnaUser;
        
        Region__c region = new Region__c();
        region.Name = 'MATO GROSSO DO SUL';
        region.RegionCode__c =  'BR1010';
        region.SalesOrg__c = sorg.Id;
        region.Zone__c = zone.Id;
        region.RegionHead__c = regioHeadUser.Id;
        region.BrazilAnalyst__c = BrazilAnaUser.Id;    
        region.SBU__c = sbu.Id;                                                                           
        insert region;
        
        User userTerMan = new User(
            Alias = 'wflav',                                                             // Alias
            Email = 'shama@skinternational.com',                                           // Email
            ProfileId = p.Id,                                                              // Profile
            Username = '20005489@uniphos3.com.upltest',                                     // Username
            IsActive = true,                                                               // Active
            LastName = 'FLAVIO DA SILVA', 
            CommunityNickname = 'XWEDERSON ',                                                // Nickname
            Title = 'RTV JR',                                                              // Title
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
            Show_InTransit_Values__c = false                                             // Show InTransit Values
        );
        insert userTerMan;
        
        Territory_Distributor__c territory =  new Territory_Distributor__c();
        territory.Name = 'Araxá';
        territory.TerritoryCode__c = 'BR165';
        territory.SBU__c = sbu.Id;     
        territory.Region__c = region.id;
        territory.SalesOrg__c = sorg.Id;
        territory.RegionDesciption__c = 'BR1001102 CHPS';                       
        territory.Zone__c = zone.Id;
        territory.TerritoryManager__c = userTerMan.Id; //userTerMan
        //territory.TerritoryManagerActive__c = true;
        insert territory;
        
        Territory_Distributor__c territory1 =  new Territory_Distributor__c();
        territory.Name = 'Regional P';
        territory.TerritoryCode__c = 'BR166';
        territory.SBU__c = sbu.Id;     
        territory.Region__c = region.id;
        territory.SalesOrg__c = sorg.Id;
        territory.RegionDesciption__c = 'BR1001103 CHPS';                       
        territory.Zone__c = zone.Id;
        territory.TerritoryManager__c = userTerMan1.Id;
        //territory.TerritoryManagerActive__c = true;
        insert territory1;
        
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
        
        Payment_Method__c pMethod = new Payment_Method__c();
        pMethod.Name = 'Credit Rule';
        pMethod.Payment_Method_Code__c = 'I';
        //  pMethod.Distribution_Channel__c = dChannel.id;
        //  pMethod.Division__c = div.Id;
        pMethod.Sales_Org__c = sorg.Id;
        pMethod.Active__c = True;
        insert pMethod;
        
        Inco_Term__c inco = new Inco_Term__c();
        inco.Name = 'CIF';
        inco.IncoTerm_Code__c = 'CIF';
        inco.IncoTerm_Desc__c = 'Custo,  seguro & frete';
        inco.Sales_Org__c = sorg.Id;
        inco.Division__c = div.Id;
        inco.Distribution_Channel__c = dChannel.Id;
        inco.Active__c = true;
        insert inco;
        
        Price_Book_Sales_District__c pbsd = new Price_Book_Sales_District__c();
        pbsd.Price_Book__c = pbook.Id;
        pbsd.Sales_District1__c = region.Id;
        insert pbsd;
        
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
        acc.key_account_manager__c = userTerMan1.Id;
        acc.Price_Conversion_Group__c = 'A';
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'LEONARDO DICAPRIO';
        acc1.Email__c = 'ganesh0539@gmail.com';
        acc1.Last_Name__c = 'DECAPRIO';
        acc1.SAP_Code__c = '2028844';
        acc1.RecordTypeId = devRecordTypeId;
        acc1.Mobile__c = '9967341759';
        acc1.Phone = '01234567891';
        acc1.Sales_Org__c = sorg.Id;
        acc1.Division__c = Div.Id;
        acc1.Distribution_Channel__c = dChannel.Id;
        acc1.BillingCity = 'MINEIROS';
        acc1.Depot_Code__c = dep.Id;
        acc1.Tax_Number_3__c = '114415456';
        acc1.Tax_Number_1__c = '114445896';
        acc1.Customer_Region__c = 'AC';
        acc1.Customer_Group__c = '675';
        acc1.Program_Margin_Discount__c = 0.00;
        acc1.Active__c = true;
        acc1.Search_Terms_1__c = 'LEONARDO DICAPRIO';
        acc1.Search_Terms_2__c = 'FAZ SEUBAK1';
        acc1.key_account_manager__c = userTerMan1.Id;
        acc1.Price_Conversion_Group__c = 'A';
        insert acc1;
        
        
        Account acc2 = new Account();
        acc2.Name = 'SK INTERNATIONAL';
        acc2.Email__c = 'ganesh0339@gmail.com';
        acc2.Last_Name__c = 'INTERNATIONAL';
        acc2.SAP_Code__c = '2028845';
        acc2.RecordTypeId = devRecordTypeId;
        acc2.Mobile__c = '9967341759';
        acc2.Phone = '01234567891';
        acc2.Sales_Org__c = sorg.Id;
        acc2.Division__c = Div.Id;
        acc2.Distribution_Channel__c = dChannel.Id;
        acc2.BillingCity = 'MINEIROS';
        acc2.Depot_Code__c = dep.Id;
        acc2.Tax_Number_3__c = '114415457';
        acc2.Tax_Number_1__c = '114411425';
        acc2.Customer_Region__c = 'AC';
        acc2.Customer_Group__c = '005';
        acc2.Program_Margin_Discount__c = 0.00;
        acc2.Active__c = true;
        acc2.Search_Terms_1__c = 'SK INTERNATIONAL';
        acc2.Search_Terms_2__c = 'FAZ SEUBAK2';
        //acc2.Customer_Region__c = 'BA';
        acc2.key_account_manager__c = userTerMan1.Id;
        acc2.Price_Conversion_Group__c = 'A';
        
        insert acc2;
        
        //Account and region mapping record
        Customer_and_Region_Mapping__c custRegMap = new Customer_and_Region_Mapping__c(
            Customer_Name__c = acc2.Id,  // Customer Name
            CustomerRegion__c = territory.Id,   // Customer Region
            Active__c = true
            
        );
        insert custRegMap;
        
        /*  List<Business_Rule__c> brList = [Select Id, Name, Taxes__c, Freight__c From Business_Rule__c];
Map<String, Business_Rule__c> businessRulesMap1 = new  Map<String, Business_Rule__c>();
for(Business_Rule__c br : [SELECT Id, Name, Taxes__c, Freight__c FROM Business_Rule__c]){
businessRulesMap1.put(br.Name, br);
}  
orderRequestController.getAccountIDMethod(acc2.Id); */
        
        
        Business_Rule__c BusinessRule = new Business_Rule__c(
            Name = 'GR NUTRIÇÂO',               // Business Rule Name
            Sales_Org__c = sorg.Id,             // Sales Org
            Taxes__c = 30.00,                   // Taxes
            Total_Order_Margin__c = 45.00,      // Total Order Margin > = 
            Freight__c = 6.90,                  // Freight
            List_Price_Discount__c = 5.00
            // Default__c = true                    // List Price Discount < = 
        );
        insert BusinessRule;
        
        Associate_Group__c asGroup = new Associate_Group__c(
            Name = 'Sales Person',                // Name
            Business_Rule__c = BusinessRule.Id  // Business Rule
        );
        insert asGroup;
        
        Employee_Details__c EmpDetail = new Employee_Details__c(
            User__c = userTerMan.Id,           
            Associate_Group__c = asGroup.Id 
        );
        insert EmpDetail;
        
        Associate_Group__c asGroupSDM = new Associate_Group__c(
            Name = 'Sales District',                // Name
            Business_Rule__c = BusinessRule.Id  // Business Rule
        );
        insert asGroupSDM;
        
        Employee_Details__c EmpDetailSDM = new Employee_Details__c(
            User__c = regioHeadUser.Id,           
            Associate_Group__c = asGroup.Id  
        );
        insert EmpDetailSDM;
        
        Employee_Details__c EmpDetailSOM = new Employee_Details__c(
            User__c = ZonalHeadUser.Id,           
            Associate_Group__c = asGroup.Id 
        );
        insert EmpDetailSOM;
        
        Employee_Details__c EmpDetailSD = new Employee_Details__c(
            User__c = SBUuser.Id,           
            Associate_Group__c = asGroup.Id  
        );
        insert EmpDetailSD;
        
        
        //default business Rule.
        Business_Rule__c bRuleSD = new Business_Rule__c(
            Name = 'Director',                 // Business Rule Name
            Taxes__c = 2.14,                    // Taxes (%)
            Total_Order_Margin__c = 0.00,       // Total Order Margin > = 
            Freight__c = 1.29,                  // Freight (%)
            List_Price_Discount__c = 100.00,    // List Price Discount < = 
            Default__c = true,                  // Default
            AppliedFor__c = 'Sales Director'  // Applied For
        );
        insert bRuleSD;
        
        Business_Rule__c bRuleSOM = new Business_Rule__c(
            Name = 'BU Gerente',                    // Business Rule Name
            Taxes__c = 2.14,                          // Taxes (%)
            Total_Order_Margin__c = 40.00,            // Total Order Margin > = 
            Freight__c = 1.29,                        // Freight (%)
            List_Price_Discount__c = 5.00,            // List Price Discount < = 
            Default__c = true,                        // Default
            AppliedFor__c = 'Sales Office Manager'  // Applied For
        );
        insert bRuleSOM;
        
        Business_Rule__c bRuleSDM = new Business_Rule__c(
            Name = 'Gerente',                         // Business Rule Name
            Taxes__c = 20.00,                           // Taxes (%)
            Total_Order_Margin__c = 20.00,              // Total Order Margin > = 
            Freight__c = 20.00,                         // Freight (%)
            List_Price_Discount__c = 20.00,             // List Price Discount < = 
            Default__c = true,                          // Default
            AppliedFor__c = 'Sales District Manager'  // Applied For
        );
        insert bRuleSDM;
        
        Business_Rule__c bRuleSP = new Business_Rule__c(
            Name = 'Sales Person',              // Business Rule Name
            Taxes__c = 52.00,                 // Taxes (%)
            Total_Order_Margin__c = 60.00,    // Total Order Margin > = 
            Freight__c = 12.00,               // Freight (%)
            List_Price_Discount__c = 85.00,   // List Price Discount < = 
            Default__c = true,                // Default
            AppliedFor__c = 'Sales Person'  // Applied For
        );
        insert bRuleSP;
        
        
        //default business rule end
        
        ExchangeRate__c ExchngRte = new ExchangeRate__c(
            FROMCurrency__c = 'USD',                                  // FROM Currency
            ToCurrency__c = 'BRL',                                    // To Currency
            ExchangeRate__c = 3.45 ,                                  // Exchange Rate
            UpdatedDate__c = system.today()+45                       // Updated Date
        );
        insert ExchngRte;
        
        
        //===================== Added by SKI Start Here===========
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        //==+================= Added by SKI End Here===========
        
        SKU__c skuRecord = new SKU__c(
            Name = 'a1C0k000000A1ug',                                 // SKU Name
            SKU_Code__c = '000000000006302802',                       // SKU Code
            SKU_Description__c = 'MANZATE 800WP 25KG PAPER BAG_BR',   // SKU Description
            UOM__c = 'KG', 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Multiple_of__c = 25.00,                                   // Multiple Of
            Combination_Key__c = '519110000000000006302802',          // Combination Key
            Active__c = true,
            brand_name__c = 'MANZATE',// Active
            Unit_Cost__c = 10.00
        );
        insert skuRecord;
        
        discount_matrix__c d = new discount_matrix__c();
        d.Brand_Name__c = 'MANZATE'; 
        d.Combination_key__c = 'MANZATE5191';
        d.Sales_Director__c = 5;
        d.Sales_District_Manager__c = 5;
        d.Sales_Person__c = 5;
        d.BU_Manager__c = 5;
        insert d;
        
        customer_conversion_factor__c cf = new customer_conversion_factor__c();
        cf.Conversion_Factor__c = 3;
        cf.Customer_Group__c = 'A';
        cf.Combination_Key__c = 'A5191';
        insert cf;
        
        Market_Variation__c MV = new Market_Variation__c();
        MV.Market_Variation__c = 5;
        MV.Region_Code__c = 'BR165';
        MV.SKU_Brand__c = 'MANZATE';
        MV.Combination_Key__c = 'BR165MANZATE5191';
        insert MV;
        
        Sales_District_Cost__c SDC = new Sales_District_Cost__c();
        SDC.Region_Code__c = 'BR165';
        SDC.Sales_District_Cost__c = 5;
        SDC.Combination_Key__c = 'BR1655191';
        insert SDC;
        
        Material_Plant_Relation__c MPRelation = new Material_Plant_Relation__c(
            Name = 'MANZATE 800WP 25KG PAPER BAG_BR',               // Material Plant Relation Name
            Material_Code__c = '000000000006302802',                // Material Code
            Active__c = true,                                       // Active
            Material_Desc__c = 'MANZATE 800WP 25KG PAPER BAG_BR',   // Material Desc
            Depot__c = dep.Id,                         
            Material_Ledger_Cost__c = 13.26,                        // Material Ledger Cost
            MC_Currency__c = 'BRL',                                 // MC Currency
            Replacement_Cost__c = 2.10,                             // Replacement Cost
            RC_Currency__c = 'USD',                                 // RC Currency
            SKU__c = skuRecord.Id,                         
            Sales_Org__c = sorg.Id                      
        );
        insert MPRelation;
        
        Culture__c culture = new Culture__c(
            Name = 'Algodão',                   // Culture Name
            Culture_Code__c = 'B01',            // Culture Code
            Culture_Desc__c = 'Algodão',        // Culture Desc
            Distribution_Channel__c = dChannel.Id,     // Distribution Channel
            Active__c = true,                  
            Division__c = div.Id,                 // Division
            Sales_Org__c = sorg.Id 
        );
        insert culture;
        
        Payment_Term__c payTerm = new Payment_Term__c(
            Payment_Term_Code__c = 'BR71',                        
            Payterms_Desc__c = 'INFORMAR VENCIMENTO',  
            Sales_Org__c = sorg.Id,                             
            Days_to_calc_interest__c = 0,                      
            Maturity_Date_Mandatory__c = 'Yes',                  
            Active__c = true                                   
        );
        
        insert payTerm;
        
        Material_Registration__c matReg = new Material_Registration__c(
            Name = '2, 4-D NORTOX 1X20L',                    
            Effective_FROM__c =  Date.newInstance(2010, 10, 10),   
            Effective_To__c = Date.newInstance(2020, 10, 10),     
            Sales_Org__c = sorg.Id,                         
            State__c = 'AC',                                
            SKU__c = skuRecord.Id,                          
            SKU_Reg_Code__c = '5250109'                     
        );
        insert matReg;
        
        Price_Book_Details__c PBdetails = new Price_Book_Details__c(
            SKU__c = skuRecord.Id,                     
            Monthly_Interest_Rate__c = 1.00,          
            Price_Book__c = pbook.Id,                
            Exchange_Rate__c = 3.00,                 
            Unit_Price__c = 120.00,                  
            Minimum_Price__c = 75.00,                
            Sales_District1__c = region.Id, 
            Minimum_Price_R__c = 5.00,        // Minimum Price R $
            Minimum_Price_U__c =2.00,        // Minimum Price U $
            Unit_Price_R__c = 28.14,          // Unit Price R $
            Unit_Price_U__c = 8.54,           // Unit Price U $
            Future_Sales_Price_R__c = 25.00,  // Future Sales Price R $
            Future_Sales_Price_U__c = 30.00,  // Future Sales Price U $
            Volume__c = 3000.00,             // Volume
            Equivalence__c = 0.00,            // % Equivalence
            Group__c = '001',                   // Group
            Sub_Group__c = 'Orthene',           // Sub Group
            Anchor__c = 'SIM',                  // Anchor
            Sub_Group_Required__c = 'SIM' 
        );
        insert PBdetails;
        
        Campaign_Group__c campaignGroupObj = new Campaign_Group__c(
            Campaign__c = pbook.Id,            // Campaign
            Do_not_generate_group_discount__c = false,    // Do not generate group discount
            Will_you_have_a_sub_product_group__c = 'No',  // Will you have a sub product group?
            Group_Discount__c = 2.00,                     // Group Discount
            Name_of_the_group__c = '001',                 // Name of the group
            Limited_volume__c = false                    // Limited volume ?
        );
        insert campaignGroupObj;
        
        Sales_Order__c sobj = new Sales_Order__c(
            OwnerId = userTerMan.Id, 
            SFDC_Order_Number__c = '8360',                     // SFDC Order Number
            SAP_Order_Number__c = '7009090604',                 // SAP Order Number
            Order_Cancel__c = false,     
            Sales_Org_lk__c = sorg.Id,                             // Order Cancel
            Order_Status__c = 'Not yet processed',              // Order Status
            OrderSubStatus__c = 'Approved',                     // Order Sub-Status
            Region_Territory__c = territory.Id,                  // Region / Territory
            RequestforCancellationCheck__c = false,  
            BudgetApprovalCheck__c = false,// Request for Cancellation
            //  BarterManager__c = BarterUser.Id, 
            Flag_Status__c = 'dislike\n',                       // Flag Status
            BrazilOrderSubmittedforApproval__c = true,          // Brazil Order Submitted for Approval
            SalesOfficeManager__c = ZonalHeadUser.Id,          // Sales Office Manager
            Price_Book__c = pbook.Id,                          // Price Book
            SalesDistrictManager__c =  regioHeadUser.Id,    
            Inco_Term__c = inco.Id, 
            Currency_Brazil__c = 'Billing USD / Payment USD',   // Currency (Brazil)
            Key_Account__c = false,                             // Key Account
            Sold_to_Party__c = acc1.Id,                         // Sold to Party
            Valid_FROM__c = system.today(), 
            //  PaymentMethod__c = pMethod.Id, // Valid FROM
            Valid_To__c = system.today()+350,                   // Valid To
            Payment_Term__c = payTerm.Id,                     // Payment Term
            Type_of_Order__c = 'CONTRATO MÃE'                 // Type of Order
        );
        insert sobj;
        SO_id=sobj.Id;
        test.stopTest();
        Sales_Order_Line_Item__c soLineItm = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj.Id,          // Sale Order
            SKU_Name__c = skuRecord.Id,            // SKU Name
            Item_Number__c = 10,                        // Item Number
            Item_Status__c = 'Not yet processed',       // Item Status
            Item_Cancel__c = false,                     // Item Cancel
            Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
            Sales_Org__c = sorg.Id,           // Sales Org
            PriceBookDetail__c = PBdetails.Id,  // Price Book Detail
            Approval_Flag__c = 0,                       // Approval Flag
            ExchangeRate__c = ExchngRte.id,        // Exchange Rate
            OrderQuantityEdited__c = false,             // Order Quantity Edited
            Time_in_months__c = 0,                      // Time in months
            Days__c = 0,                                // Days
            DateofFAT__c =  system.today()+1, 
            Quantity__c = 450.00,                       // Quantity
            UnitValue__c = 100.00,                      // Unit Value
            UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
            InterestRate__c = 0.00,                     // Interest Rate
            TotalTax__c = 0.00,                         // Total Tax
            TotalFreight__c = 0.00,                     // Total Freight
            TotalPunctuality__c = 0.00,                 // Total Punctuality
            TotalLedgerCost__c = 0.00,                  // Total Ledger Cost
            TotalReplacementCost__c = 0.00 ,
            Customer_Conversion_Factor__c = 1// Total Replacement Cost
        );
        insert soLineItm;
        
        /*
//OrderRequestController.getCustomers(userTerMan.Id,  sobj.Type_of_Order__c,  acc1.Customer_Group__c,  acc1.Id);
//OrderRequestController.getMOPriceBookDetails(pbook.Id, sobj.Id,  dep.Id,  acc.Customer_Region__c, sobj.Id,  true);
OrderRequestController.signOrder(sobj);
//OrderRequestController.getSalesOrderItems(sobj.Id);
OrderRequestController.FlagStatus status = OrderRequestController.checkFlag(sobj.Id, false, 'ORDEM FILHA', 'Draft');
OrderRequestController.FlagStatus status1 = OrderRequestController.checkFlag(sobj.Id, false, 'BONIFICAÇÃO', 'Draft');
OrderRequestController.FlagStatus status2 = OrderRequestController.checkFlag(sobj.Id, false, 'REMESSA PARA TESTE', 'Draft');
//System.debug('soId1'+sobj.Id);

*/    
        
    } 
    
    @isTest
    static  void method2(){
        
        //Profile p = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person' LIMIT 1]; 
       
        User userTerMan1 = [select id from user where Email = 'shama11@skinternational.com' limit 1];
        
        Region__c reg1 = [select id,name,RegionCode__c from Region__c limit 1];
        SBU__c sbObj1 = [select id, name from SBU__c limit 1];
        Sales_Org__c saleOrg1 = [select id,name from Sales_Org__c limit 1];
        Zone__c zo1 = [select id,name from Zone__c limit 1];
        
        Territory_Distributor__c territory4 =  new Territory_Distributor__c();
        territory4.Name = 'Raj';
        territory4.TerritoryCode__c = 'BR170';
        territory4.SBU__c = sbObj1.Id;     
        territory4.Region__c = reg1.id;
        territory4.SalesOrg__c = saleOrg1.Id;
        territory4.RegionDesciption__c = 'BR1001102 CHPS';                       
        territory4.Zone__c = zo1.Id;
        territory4.TerritoryManager__c = userTerMan1.Id; //userTerMan
        
        insert territory4;
        
        //Territory_Distributor__c tdList = [SELECT ID, Name,TerritoryManager__c, TerritoryCode__c, Region__c,Region__r.RegionCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR170'];
        
        system.debug('**User 891 ->' +userTerMan1);
        //system.debug('**Territory Distributor 891 ->' +tdList);
        
        
        Division__c divRec = [select id from Division__c limit 1];
        SKU__c skuRec1 = new SKU__c(
            Name = 'a1C0k000000A1ug',                                 // SKU Name
            SKU_Code__c = '000000000006302803',                       // SKU Code
            SKU_Description__c = 'Kit ',   // SKU Description
            UOM__c = 'KG', 
            Division__c = divRec.Id,                                     // Division
            Sales_Org__c = saleOrg1.Id,                                  // Sales Org
            Multiple_of__c = 25.00,                                   // Multiple Of
            Combination_Key__c = '519110000000000006302803',          // Combination Key
            Active__c = true,
            Kit_Product__c = true,
            brand_name__c = 'MANZATE Kit'// Active
        );
        insert skuRec1;
        
        Brazil_Region_SKU_Combination__c newRec1 = new Brazil_Region_SKU_Combination__c(
            Sales_District__c = reg1.Id,
            SKU__c = skuRec1.Id,
            Date__c = System.today(),
            Availability__c = 'No'
        );
        insert newRec1;
        
        /*new User(
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
insert userTerMan1;*/
        
        discount_matrix__c d = new discount_matrix__c();
        d.Brand_Name__c = 'MANZATE_Test Pithoragarh1'; 
        d.Combination_key__c = 'MANZATE5191';
        d.Sales_Director__c = 5;
        d.Sales_District_Manager__c = 5;
        d.Sales_Person__c = 5;
        d.BU_Manager__c = 5;
        insert d;
        
        customer_conversion_factor__c cf = new customer_conversion_factor__c();
        cf.Conversion_Factor__c = 3;
        cf.Customer_Group__c = 'A';
        cf.Combination_Key__c = 'A5191BRDTEST';
        insert cf;
        
        Market_Variation__c MV = new Market_Variation__c();
        MV.Market_Variation__c = 5;
        MV.Region_Code__c = 'BR165';
        MV.SKU_Brand__c = 'MANZATE';
        MV.Combination_Key__c = 'BR165MANZATE5191';
        insert MV;
        
        Sales_District_Cost__c SDC = new Sales_District_Cost__c();
        SDC.Region_Code__c = 'BR165';
        SDC.Sales_District_Cost__c = 5;
        SDC.Combination_Key__c = 'BR1655191';
        insert SDC;
        
        Key_Account_Manager__c KAM = new Key_Account_Manager__c();
        KAM.Brazil_User__c = userTerMan1.Id;
        insert KAM;
        
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '5191'];
        Account acc = [SELECT id, Customer_Group__c, Customer_Region__c FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'PASSINATO' LIMIT 1]; 
        list<string> lisi = OrderRequestController.getSeller();
        Price_Book_Details__c pbdetails1 =  [SELECT Id, Unit_Price__c, Monthly_Interest_Rate__c, SKU__c FROM Price_Book_Details__c LIMIT 1];
        Price_Book__c pricebook = [SELECT Id FROM Price_Book__c LIMIT 1];
        Depot__c dep = [SELECT Id FROM Depot__c WHERE SalesOrg__c = :sorg.Id LIMIT 1]; 
        SKU__c skurec = [SELECT Id, SKU_Description__c, SKU_Code__c, Multiple_of__c,brand_name__c FROM SKU__c LIMIT 1];
        system.debug('Brand Name'+skurec.brand_name__c);
        Culture__c culture = [SELECT Id FROM Culture__c LIMIT 1];
        Material_Registration__c matreg =  [SELECT Id,  Name,  Sales_Org__c,  SKU__c,  State__c FROM Material_Registration__c LIMIT 1];
        Inco_Term__c incoTm = [SELECT Id,  Name FROM Inco_Term__c WHERE IncoTerm_Code__c = 'CIF' LIMIT 1];
        
        List<OrderRequestController.SalesOrderItem> solst = new List<OrderRequestController.SalesOrderItem>(); 
        OrderRequestController.SalesOrderItem wrapObj = new OrderRequestController.SalesOrderItem();
        wrapObj.productId = skurec.id;
        wrapObj.fatDate = '02/05/2018';
        wrapObj.qty = 100;
        wrapObj.listValue = 50;
        wrapObj.unitValue = 32;
        wrapObj.unitValueWithInterest = 32;
        wrapObj.productCode =  skurec.SKU_Code__c;
        wrapObj.totalValue = 12816;
        wrapObj.interestRate = 0;
        wrapObj.days = 0;
        wrapObj.cultureDesc = culture.Id;
        wrapObj.priceBookDetailId = pbdetails1.Id;
        wrapObj.productName = '';
        wrapObj.inventory = 0;
        wrapObj.discount = 16.35;
        wrapObj.replacementMargin = 0;
        wrapObj.ledgerMargin = 63.1;
        wrapObj.totalValueWithInterest = 0;
        wrapObj.timeInMonths = 0;
        wrapObj.multipleOf = 0;
        solst.add(wrapObj);
        
        
        
        String serlizeStr = JSON.serialize(solst);  
        
        List<OrderRequestController.PriceDetail> WrapPriceList = new List<OrderRequestController.PriceDetail>(); 
        OrderRequestController.PriceDetail WrapPrice = new OrderRequestController.PriceDetail();
        WrapPrice.skuId = skurec.Id;
        WrapPrice.skuDescription = skurec.SKU_Description__c;
        WrapPrice.unitValue = pbdetails1.Unit_Price__c;
        WrapPrice.pricebookId = pbdetails1.Id;
        WrapPrice.skuCode = skurec.SKU_Code__c;
        WrapPrice.multipleOf = skurec.Multiple_of__c;
        WrapPrice.monthlyInterestRate = pbdetails1.Monthly_Interest_Rate__c ;
        WrapPrice.regState = matreg.State__c;
        WrapPriceList.add(WrapPrice);
        
        List<OrderRequestController.AuditHistory> auditWrapList = new List<OrderRequestController.AuditHistory>(); 
        OrderRequestController.AuditHistory auditWrap = new OrderRequestController.AuditHistory();
        auditWrap.createdDate = System.now();
        auditWrap.stepStatus = '';
        auditWrap.originalActorName = '';
        auditWrap.actorName = '';
        auditWrap.comments = 'submitted';      
        auditWrapList.add(auditWrap);
        
        List<OrderRequestController.FlagStatus> flagList = new List<OrderRequestController.FlagStatus>(); 
        OrderRequestController.FlagStatus FlagWrap = new OrderRequestController.FlagStatus();
        FlagWrap.flagMessage = '';
        FlagWrap.flagStatus = '';
        flagList.add(FlagWrap);
         Test.startTest();
        List<OrderRequestController.SOMQuantity> qtyList = new List<OrderRequestController.SOMQuantity>(); 
        OrderRequestController.SOMQuantity qtyWrap = new OrderRequestController.SOMQuantity();
        qtyWrap.priceList = new List<OrderRequestController.PriceDetail>();
        qtyWrap.productList =  new List<String>();
        qtyList.add(qtyWrap);
        
        List<OrderRequestController.SOMBalance> SOMlist = new List<OrderRequestController.SOMBalance>(); 
        OrderRequestController.SOMBalance wrapSOM = new OrderRequestController.SOMBalance();
        wrapSOM.productId = skurec.Id;
        wrapSOM.product = skurec.SKU_Description__c ;
        wrapSOM.quantity = '3425';
        wrapSOM.balance = '5';
        wrapSOM.percent = '21' ;
        SOMlist.add(wrapSOM);
        
        Id recordTypeId = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Simulation').getRecordTypeId(); 
        //soChild.RecordTypeId = recordTypeId;
        
        Sales_Order__c soChild = new Sales_Order__c();
        soChild.RecordTypeId = recordTypeId;
        
        soChild.Type_of_Order__c = 'VENDA NORMAL';                 // Type of Order
        soChild.Currency_Brazil__c = 'Billing USD / Payment USD';  // Currency (Brazil)
        soChild.Valid_FROM__c = System.today();          // Valid FROM
        soChild.BrazilOrderSubmittedforApproval__c = true;         // Brazil Order Submitted for Approval
        soChild.Valid_To__c = System.today()+365;          // Valid To
        soChild.PONumber__c = 'qweet';
        soChild.BudgetApprovalCheck__c = false;
        soChild.Inco_Term__c = incotm.Id;
        soChild.Key_Account__c = false;  
        soChild.Purchase_Order_Date__c = System.today()+5;
        soChild.Business_Discount__c = 0.00;                      // Business Discount
        soChild.Financial_Discount__c = 0.00;                     // Financial Discount
        soChild.Sold_to_Party__c = acc.Id;       // Sold to Party
        soChild.Sales_Org_lk__c = sorg.Id;
        
        
        Admin_MPT_Colombia__c adminMPT = new Admin_MPT_Colombia__c();
        adminMPT.Active__c = true;
        adminMPT.Approval_Level__c = 'Level 2';
        adminMPT.Sales_Org__c = sorg.Id;
        adminMPT.Level_3_below__c = 15;
        adminMPT.Level_2_min__c = 15.01;    
        adminMPT.Level_2_max__c = 20.00;
        adminMPT.Level_1_min__c = 20.01;
        adminMPT.Level_1_max__c = 30.00;
        insert adminMPT;
        
        
        System.runAs(userTerMan1) {
            //OrderRequestController.getOrderFields(true,userInfo.getUserId(),false, false, acc.Id,'ORDEM FILHA' , false,false);  
            OrderRequestController.getOrderFields(true,userInfo.getUserId(),false, false, acc.Id,'ORDEM FILHA' , false,false);  
            /*OrderRequestController.getOrderFields(true, false, acc.Id,'ORDEM FILHA' , false);  
OrderRequestController.getOrderFields(true, true, acc.Id,'ORDEM FILHA' , false);   
OrderRequestController.getOrderFields(true, true, acc.Id,'ORDEM FILHA' , false);   
OrderRequestController.getOrderFields(true, false, acc.Id,'ORDEM FILHA' , true);  */ 
            
            OrderRequestController.getBusinessRule(soChild.Id,  userTerMan1.Id);
            OrderRequestController.getShippingLoations(acc.Id);
            list<string> lisi2 = OrderRequestController.getSeller();
            //OrderRequestController.getKeyCustomers(userTerMan1.Id, soMother.Type_of_Order__c,  acc.Customer_Group__c,  acc.Id);
            //OrderRequestController.getSOM(userTerMan1.Id);
            OrderRequestController.getCustomers(userTerMan1.Id,  soChild.Type_of_Order__c,  acc.Customer_Group__c,  acc.Id,'null');
            OrderRequestController.getSalesDistrict();
            system.debug('soChild'+soChild);
            //OrderRequestController.simulateSalesOrder(soChild,  serlizeStr);
            OrderRequestController.getSeller();
            OrderRequestController.getPriceBookDetails(pricebook.Id,  dep.id,  acc.Customer_Region__c,acc.Id,false);
             OrderRequestController.getPriceBookDetails(pricebook.Id,  dep.id,  acc.Customer_Region__c,acc.Id,true);
            //OrderRequestController.fetchKitComponentProduct(pricebook.Id,  dep.id,  acc.Customer_Region__c);
            //OrderRequestController.rollbackSalesOrder(soChild,  serlizeStr,  false,'');
           
            //OrderRequestController.getSOM(userTerMan1.Id, 'BR165');
            //OrderRequestController.saveSalesOrder(soChild,  serlizeStr,  false,  false);
            //OrderRequestController.processApproval(true,  soChild.id,  'Approve');
            //OrderRequestController.signOrder(soChild);
            //OrderRequestController.deleteSalesOrder(soChild.Id);
        }
        Test.stopTest();
        OrderRequestController.customProcessApproval(true,  soChild.id,  'Approve');
        //Priya
        /*User dempSOM = [select id from user where Alias = 'GERSON' limit 1];
System.runAs(dempSOM){
OrderRequestController.simulateSalesOrder(soChild,  serlizeStr);
OrderRequestController.deleteSalesOrder(soChild.Id);
}*/
        //Priya
    }
    
    static testMethod void method3(){
        
        //Profile p = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person' LIMIT 1]; 
        User userTerMan1 = [select id from user where Email = 'shama11@skinternational.com' limit 1];  
        /* User userTerMan1 = new User(
Alias = 'WES',                                                             // Alias
Email = 'shama11@skinternational.com',                                           // Email
ProfileId = p.Id,                                                              // Profile
Username = '20205489113555@uniphos3.com.upltest',   //2020548911@uniphos3.com.upltest                                  // Username
IsActive = true,                                                               // Active
LastName = 'BARBOSA DErCAMARGO', 
CommunityNickname = 'Xyuabc',   //Xyu                                             // Nickname
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
insert userTerMan1; */
        
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '5191'];
        Account acc2 = [SELECT id, Customer_Group__c, Customer_Region__c FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'INTERNATIONAL' LIMIT 1]; 
        Sales_Order__c soMother = [SELECT id, Type_of_Order__c FROM Sales_Order__c WHERE SalesOrgCode__c = '5191' AND Type_of_Order__c = 'CONTRATO MÃE' LIMIT 1];
        
        Price_Book_Details__c pbdetails1 =  [SELECT Id, Unit_Price__c, Monthly_Interest_Rate__c,Future_Sales_Price_R__c, Future_Sales_Price_U__c, Unit_Price_R__c,
                                             Unit_Price_U__c, Minimum_Price_U__c, Minimum_Price_R__c, Volume__c, SKU__c FROM Price_Book_Details__c LIMIT 1];
        Price_Book__c pricebook = [SELECT Id FROM Price_Book__c LIMIT 1];
        Depot__c dep = [SELECT Id FROM Depot__c WHERE SalesOrg__c = :sorg.Id LIMIT 1]; 
        SKU__c skurec = [SELECT Id, SKU_Description__c, SKU_Code__c, Multiple_of__c FROM SKU__c LIMIT 1];
        Culture__c culture = [SELECT Id FROM Culture__c LIMIT 1];
        //Material_Registration__c matreg =  [SELECT Id,  Name,  Sales_Org__c,  SKU__c,  State__c FROM Material_Registration__c LIMIT 1];
        Inco_Term__c incoTm = [SELECT Id,  Name FROM Inco_Term__c WHERE IncoTerm_Code__c = 'CIF' LIMIT 1];
        Region__c reg1 = [select id,name,RegionCode__c from Region__c limit 1];
        Zone__c zo1 = [select id,name from Zone__c limit 1];
        SBU__c sbObj1 = [select id, name from SBU__c limit 1];
        
        Territory_Distributor__c territory7 =  new Territory_Distributor__c();
        territory7.Name = 'Taj';
        territory7.TerritoryCode__c = 'BR190';
        territory7.SBU__c = sbObj1.Id;     
        territory7.Region__c = reg1.id;
        territory7.SalesOrg__c = sorg.Id;
        territory7.RegionDesciption__c = 'BR1001102 CHPS';                       
        territory7.Zone__c = zo1.Id;
        territory7.TerritoryManager__c = userTerMan1.Id; //userTerMan
        insert territory7;
        
        Territory_Distributor__c tdList = [SELECT ID, Name,TerritoryManager__c, TerritoryCode__c, Region__c,Region__r.RegionCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR190'];
        
        system.debug('**User child order ->' +userTerMan1);
        system.debug('**Territory Distributor child order ->' +tdList);
        
        Brazil_Region_SKU_Combination__c newRec1 = new Brazil_Region_SKU_Combination__c(
            Sales_District__c = reg1.Id,
            SKU__c = skurec.Id,
            Date__c = System.today(),
            Availability__c = 'No'
        );
        insert newRec1;
        
        Sales_Order__c so2 = new Sales_Order__c();
        SO2.Sales_Order__c = soMother.Id;
        so2.Type_of_Order__c = 'ORDEM FILHA';                 // Type of Order
        so2.Currency_Brazil__c = 'Billing USD / Payment USD';  // Currency (Brazil)
        so2.Valid_FROM__c = System.today();          // Valid FROM
        so2.BrazilOrderSubmittedforApproval__c = true;         // Brazil Order Submitted for Approval
        so2.Valid_To__c = System.today()+365;          // Valid To
        so2.PONumber__c = 'qweet1';   
        so2.BudgetApprovalCheck__c = false;
        so2.Inco_Term__c = incotm.Id;
        so2.Key_Account__c = false;  
        so2.Purchase_Order_Date__c = System.today()+5;
        so2.Business_Discount__c = 0.00;                      // Business Discount
        so2.Financial_Discount__c = 0.00;                     // Financial Discount
        so2.Sold_to_Party__c = acc2.Id;       // Sold to Party
        so2.Sales_Org_lk__c = sorg.Id;
        
        Sales_Order__c so3 = new Sales_Order__c();
        So3.Sales_Order__c = soMother.Id;
        so3.Type_of_Order__c = 'ORDEM FILHA';                 // Type of Order
        so3.Currency_Brazil__c = 'Billing USD / Payment USD';  // Currency (Brazil)
        so3.Valid_FROM__c = System.today();          // Valid FROM
        so3.BrazilOrderSubmittedforApproval__c = true;         // Brazil Order Submitted for Approval
        so3.Valid_To__c = System.today()+365;          // Valid To
        so3.PONumber__c = 'qweet1';   
        so3.BudgetApprovalCheck__c = false;
        so3.Inco_Term__c = incotm.Id;
        so3.Key_Account__c = false;  
        so3.Purchase_Order_Date__c = System.today()+5;
        so3.Business_Discount__c = 0.00;                      // Business Discount
        so3.Financial_Discount__c = 0.00;                     // Financial Discount
        so3.Sold_to_Party__c = acc2.Id;       // Sold to Party
        so3.Sales_Org_lk__c = sorg.Id;
        
        List<OrderRequestController.StructOrderLineItem> structsolst = new List<OrderRequestController.StructOrderLineItem>(); 
        OrderRequestController.StructOrderLineItem structwrapObj = new OrderRequestController.StructOrderLineItem();
        structwrapObj.skuCategory = '';  
        structwrapObj.isManual = false;    
        structwrapObj.interestRateBRL =1.0;
        structwrapObj.interestRateUSD =2.0;
        structwrapObj.interestDate ='';
        structwrapObj.volDifference ='2545';
        structwrapObj.totalValStr ='231231';    
        structwrapObj.totalValWithInterestStr='232';
        structwrapObj.priceWithInterestStr ='342';
        structwrapObj.discountedInitialPriceStr = '3423';
        structwrapObj.soItemId = '';    
        structwrapObj.combinationkey = pbdetails1.Id;
        structwrapObj.multipleOf = 0;
        structwrapObj.campGrp ='001';
        structwrapObj.camSubgrp='orthene';
        structwrapObj.skuId= skurec.id;
        structwrapObj.skuDesc='';
        structwrapObj.cultureId ='';
        structwrapObj.cultureDesc ='';
        structwrapObj.UOM ='';    
        structwrapObj.volume = 0;
        structwrapObj.prdctVol= 2000;
        structwrapObj.intialPrice= 230;
        structwrapObj.invoiceDate='02/05/2018';
        structwrapObj.grpDiscount=0;
        structwrapObj.fspPrice =0;
        structwrapObj.totalVal= 0; 
        structwrapObj.costBRL= 56;
        structwrapObj.costUSD= 67;
        structwrapObj.intialPriceDisount= 0;
        structwrapObj.priceWithInterest= 0;
        structwrapObj.FinalUnitPrice= 878780;
        structwrapObj.totalValWithInterest= 0;
        structwrapObj.equivalence = 0;
        structwrapObj.isTrue = true; 
        structwrapObj.interestRate = 2;  
        structwrapObj.days = 5;
        structwrapObj.timeInMonths = 10; 
        structsolst.add(structwrapObj);
        Test.startTest(); 
        List<OrderRequestController.SalesOrderItem> solst = new List<OrderRequestController.SalesOrderItem>(); 
        OrderRequestController.SalesOrderItem wrapObj = new OrderRequestController.SalesOrderItem();
        wrapObj.productId = skurec.id;
        wrapObj.fatDate = '02/05/2018';
        wrapObj.qty = 50;
        wrapObj.listValue = 50;
        wrapObj.unitValue = 32;
        wrapObj.unitValueWithInterest = 32;
        wrapObj.productCode =  skurec.SKU_Code__c;
        wrapObj.totalValue = 12816;
        wrapObj.interestRate = 0;
        wrapObj.days = 0;
        wrapObj.cultureDesc = culture.Id;
        wrapObj.priceBookDetailId = pbdetails1.Id;
        wrapObj.productName = '';
        wrapObj.inventory = 0;
        wrapObj.discount = 16.35;
        wrapObj.replacementMargin = 0;
        wrapObj.ledgerMargin = 63.1;
        wrapObj.totalValueWithInterest = 0;
        wrapObj.timeInMonths = 0;
        wrapObj.multipleOf = 0;
        solst.add(wrapObj);
        
        
        
        String serlizeStr = JSON.serialize(solst);  
        String serlizeStr1 = JSON.serialize(structsolst);  
        Territory_Distributor__c tdObj = [SELECT Id,TerritoryCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR165'];
        /*tdObj.TerritoryManager__c = userTerMan1.Id;
update tdObj;*/
        Admin_MPT_Colombia__c adminMPT = new Admin_MPT_Colombia__c();
        adminMPT.Active__c = true;
        adminMPT.Approval_Level__c = 'Level 2';
        adminMPT.Sales_Org__c = sorg.Id;
        adminMPT.Level_3_below__c = 15;
        adminMPT.Level_2_min__c = 15.01;    
        adminMPT.Level_2_max__c = 20.00;
        adminMPT.Level_1_min__c = 20.01;
        adminMPT.Level_1_max__c = 30.00;
        insert adminMPT;
        
        System.runAs(userTerMan1) {
            OrderRequestController.getOrderFields(true,userInfo.getUserId(),false, false, acc2.Id,'ORDEM FILHA' , false,false);  
            //  OrderRequestController.getOrderFields(true,userInfo.getUserId(),false, false, acc2.Id,'ORDEM FILHA' , false,false);  
            //OrderRequestController.getSOM(userTerMan1.Id);
            System.debug('Usr Id---> '+userTerMan1.Id);
            //OrderRequestController.simulateSalesOrder(so2,json.serialize(solst));
            //Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '5191' LIMIT 1];
            Payment_Term__c payTerm = new Payment_Term__c(
                Payment_Term_Code__c = 'BR71',                        
                Payterms_Desc__c = 'INFORMAR VENCIMENTO',  
                Sales_Org__c = sorg.Id,                             
                Days_to_calc_interest__c = 0,                      
                Maturity_Date_Mandatory__c = 'Yes',                  
                Active__c = true                                   
            );
            
            insert payTerm;
            payterm.Active__c = true;
            update payterm;
            OrderRequestController.getPBPaymentTerms(pricebook.Id);
            OrderRequestController.getCustomers( userTerMan1.Id,  so2.Type_of_Order__c,  acc2.Customer_Group__c,  acc2.Id,'null');
            OrderRequestController.getKeyCustomers(userTerMan1.Id,  so2.Type_of_Order__c,  acc2.Customer_Group__c, acc2.Id);
            OrderRequestController.validateQuantitySOC(pricebook.Id, soMother.Id,  dep.Id,  acc2.Customer_Region__c, so2.Id, serlizeStr,false);
            OrderRequestController.validateQuantitySOC(pricebook.Id, soMother.Id,  dep.Id,  acc2.Customer_Region__c, so2.Id, serlizeStr,true);
            OrderRequestController.saveSalesOrder(so2,  serlizeStr,  false,  false,null);
            OrderRequestController.getCustomerConversionFactor(acc2.Id,'test');
            OrderRequestController.getPriceListValuesSalesRep(userTerMan1.Id);
            // OrderRequestController.saveStructuresalesOrder(So3,  serlizeStr1,  serlizeStr1);
            OrderRequestController.getBusinessRule(so2.Id,  userTerMan1.Id);
            //test method for structure Order 
            Attachment attach = new Attachment(
                parentId = so2.id,
                Body = EncodingUtil.base64Decode('fdestdctyrgdybdrtnuftyuytmiynu'),
                Name = 'fileName',
                ContentType = '.pdf');
            insert attach;
            OrderRequestController.getStructSalesOrderItems(so2.Id);
            //OrderRequestController.fetchStructureCampaign(pricebook.Id,'');
            OrderRequestController.saveChunk(so2.Id,'fileName','gdsytrsrthj','bdftytrdcu',attach.Id);
            OrderRequestController.saveChunk(so2.Id,'fileName','gdsytrsrthj','bdftytrdcu','');
            //OrderRequestController.processApproval(false, SO_id, 'Test...');
            //
            
            
            
            OrderRequestController.StructCampaignDetailWrap scd= new OrderRequestController.StructCampaignDetailWrap();
            OrderRequestController.CampaignGroupWrap cgw= new OrderRequestController.CampaignGroupWrap();
            OrderRequestController.CampaignSubGroupWrap csgw= new OrderRequestController.CampaignSubGroupWrap();
            OrderRequestController.PriceBookDetailWrap pbdw= new OrderRequestController.PriceBookDetailWrap();
            OrderRequestController.StructOrderLineItem soli= new OrderRequestController.StructOrderLineItem();
            OrderRequestController.PriceBookPaymentTermWrapper pricBookPayObj = new OrderRequestController.PriceBookPaymentTermWrapper();
        }
        Test.stopTest(); 
    }
    static testMethod void method4(){
        test.startTest(); 
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person' LIMIT 1]; 
        
        User userTerMan1 = new User(
            Alias = 'WES',                                                             // Alias
            Email = 'shama11@skinternational.com',                                           // Email
            ProfileId = p.Id,                                                              // Profile
            Username = '202054891111456@uniphos3.com.upltest',       //202054891111@uniphos3.com.upltest                              // Username
            IsActive = true,                                                               // Active
            LastName = 'BARBOSA DErCAMARGO', 
            CommunityNickname = 'Xyuabc',      //Xyu                                           // Nickname
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
        
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '5191'];
        Account acc2 = [SELECT id, Customer_Group__c, Customer_Region__c FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'INTERNATIONAL' LIMIT 1]; 
        Sales_Order__c soMother = [SELECT id, Type_of_Order__c FROM Sales_Order__c WHERE SalesOrgCode__c = '5191' AND Type_of_Order__c = 'CONTRATO MÃE' LIMIT 1];
        
        Price_Book_Details__c pbdetails1 =  [SELECT Id, Unit_Price__c, Monthly_Interest_Rate__c,Future_Sales_Price_R__c, Future_Sales_Price_U__c, Unit_Price_R__c,
                                             Unit_Price_U__c, Minimum_Price_U__c, Minimum_Price_R__c, Volume__c, SKU__c FROM Price_Book_Details__c LIMIT 1];
        Price_Book__c pricebook = [SELECT Id FROM Price_Book__c LIMIT 1];
        //Depot__c dep = [SELECT Id FROM Depot__c WHERE SalesOrg__c = :sorg.Id LIMIT 1]; 
        SKU__c skurec = [SELECT Id, SKU_Description__c, SKU_Code__c, Multiple_of__c FROM SKU__c LIMIT 1];
        //Culture__c culture = [SELECT Id FROM Culture__c LIMIT 1];
        //Material_Registration__c matreg =  [SELECT Id,  Name,  Sales_Org__c,  SKU__c,  State__c FROM Material_Registration__c LIMIT 1];
        Inco_Term__c incoTm = [SELECT Id,  Name FROM Inco_Term__c WHERE IncoTerm_Code__c = 'CIF' LIMIT 1];
        
        
        Sales_Order__c so3 = new Sales_Order__c();
        So3.Sales_Order__c = soMother.Id;
        so3.Type_of_Order__c = 'ORDEM FILHA';                 // Type of Order
        so3.Currency_Brazil__c = 'Billing USD / Payment USD';  // Currency (Brazil)
        so3.Valid_FROM__c = System.today();          // Valid FROM
        so3.BrazilOrderSubmittedforApproval__c = true;         // Brazil Order Submitted for Approval
        so3.Valid_To__c = System.today()+365;          // Valid To
        so3.PONumber__c = 'qweet1';   
        so3.BudgetApprovalCheck__c = false;
        so3.Inco_Term__c = incotm.Id;
        so3.Key_Account__c = false;  
        so3.Purchase_Order_Date__c = System.today()+5;
        so3.Business_Discount__c = 0.00;                      // Business Discount
        so3.Financial_Discount__c = 0.00;                     // Financial Discount
        so3.Sold_to_Party__c = acc2.Id;  
        so3.Price_Book__c = pricebook.Id;
        so3.Sales_Org_lk__c = sorg.Id;
        OrderRequestController.getPriceBookValues(pricebook.Id);
        OrderRequestController.getCultureDesc(pricebook.Id,'CONTRATO MÃE',soMother.Id);
        
        OrderRequestController.getCultureDesc(pricebook.Id,'ORDEM FILHA',soMother.Id);
        List<OrderRequestController.StructOrderLineItem> structsolst = new List<OrderRequestController.StructOrderLineItem>(); 
        OrderRequestController.StructOrderLineItem structwrapObj = new OrderRequestController.StructOrderLineItem();
        structwrapObj.skuCategory = '';  
        structwrapObj.isManual = false;    
        structwrapObj.interestRateBRL =1.0;
        structwrapObj.interestRateUSD =2.0;
        structwrapObj.interestDate ='';
        structwrapObj.volDifference ='2545';
        structwrapObj.totalValStr ='231231';    
        structwrapObj.totalValWithInterestStr='232';
        structwrapObj.priceWithInterestStr ='342';
        structwrapObj.discountedInitialPriceStr = '3423';
        structwrapObj.soItemId = '';    
        structwrapObj.combinationkey = pbdetails1.Id;
        structwrapObj.multipleOf = 0;
        structwrapObj.campGrp ='001';
        structwrapObj.camSubgrp='orthene';
        structwrapObj.skuId= skurec.id;
        structwrapObj.skuDesc='';
        structwrapObj.cultureId ='';
        structwrapObj.cultureDesc ='';
        structwrapObj.UOM ='';    
        structwrapObj.volume = 0;
        structwrapObj.prdctVol= 2000;
        structwrapObj.intialPrice= 230;
        structwrapObj.invoiceDate='02/05/2018';
        structwrapObj.grpDiscount=0;
        structwrapObj.fspPrice =0;
        structwrapObj.totalVal= 0; 
        structwrapObj.costBRL= 56;
        structwrapObj.costUSD= 67;
        structwrapObj.intialPriceDisount= 0;
        structwrapObj.priceWithInterest= 0;
        structwrapObj.FinalUnitPrice= 878780;
        structwrapObj.totalValWithInterest= 0;
        structwrapObj.equivalence = 0;
        structwrapObj.isTrue = true; 
        structwrapObj.interestRate = 2;  
        structwrapObj.days = 5;
        structwrapObj.timeInMonths = 10; 
        structsolst.add(structwrapObj);
        
        
        String serlizeStr1 = JSON.serialize(structsolst);  
        Territory_Distributor__c tdObj = [SELECT Id,TerritoryCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR165' LIMIT 1];
        /*     tdObj.TerritoryManager__c = userTerMan1.Id;
update tdObj;
*/
        Admin_MPT_Colombia__c adminMPT = new Admin_MPT_Colombia__c();
        adminMPT.Active__c = true;
        adminMPT.Approval_Level__c = 'Level 2';
        adminMPT.Sales_Org__c = sorg.Id;
        adminMPT.Level_3_below__c = 15;
        adminMPT.Level_2_min__c = 15.01;    
        adminMPT.Level_2_max__c = 20.00;
        adminMPT.Level_1_min__c = 20.01;
        adminMPT.Level_1_max__c = 30.00;
        insert adminMPT;
        System.runAs(userTerMan1) {
            OrderRequestController.getOrderFields(true,userInfo.getUserId(),false, false, acc2.Id,'ORDEM FILHA' , false,false);  
            //  OrderRequestController.getOrderFields(true,userInfo.getUserId(),false, false, acc2.Id,'ORDEM FILHA' , false,false);  
            
            OrderRequestController.saveStructuresalesOrder(So3,  serlizeStr1,  serlizeStr1);
            OrderRequestController.getPriceBookT(So3.id);
            OrderRequestController.StructCampaignDetailWrap scd= new OrderRequestController.StructCampaignDetailWrap();
            OrderRequestController.CampaignGroupWrap cgw= new OrderRequestController.CampaignGroupWrap();
            OrderRequestController.CampaignSubGroupWrap csgw= new OrderRequestController.CampaignSubGroupWrap();
            OrderRequestController.PriceBookDetailWrap pbdw= new OrderRequestController.PriceBookDetailWrap();
            OrderRequestController.StructOrderLineItem soli= new OrderRequestController.StructOrderLineItem();
            OrderRequestController.PriceBookPaymentTermWrapper pricBookPayObj = new OrderRequestController.PriceBookPaymentTermWrapper();
            set<id> userIds = new set<id>();
            userIds.add(userTerMan1.Id);
            Map<Id, Employee_Details__c> a = OrderRequestController.getBusinessRuleMap(userIds);
            //user u = [select id from user where username = '20005489@uniphos3.com.upltest'];
            //List<sales_order__c> liso = OrderRequestController.getSOM(u.Id,'BR165');
            
        }
        test.stopTest(); 
    }
    
    static testMethod void method5(){
        test.startTest(); 
        User userTerMan1 = [select id from user where Email = 'shama11@skinternational.com' limit 1]; 
        
        OrderRequestController.getMinValDisc('VENDA NORMAL');
        
        
        Key_Account_Manager__c KAM = new Key_Account_Manager__c();
        KAM.Brazil_User__c = userTerMan1.Id;
        KAM.Active__c = true;
        insert KAM;  
        
        
        system.runAs(userTerMan1){
            list<string> a = OrderRequestController.getSeller();
        }
        
        test.stopTest(); 
    }
    @isTest
    static  void method6(){
        
        //Profile p = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person' LIMIT 1]; 
        User userTerMan1 = [select id from user where Email = 'shama11@skinternational.com' limit 1];  
        User userTerMan123 = [select id from user where Email = 'userTerManTerri@skinternational.com' limit 1]; 
        //user userTerMan = [select id from user where Email = 'shama@skinternational.com' limit 1];
        
        
        Region__c reg = [select id,name,RegionCode__c from Region__c limit 1];
        Zone__c zo = [select id,name from Zone__c limit 1];
        SBU__c sbObj = [select id, name from SBU__c limit 1];
        Sales_Org__c sorg = new Sales_Org__c();
        sorg.Name = 'Brazil';
        sorg.Sales_Org_Code__c = '5191';
        insert sorg;
        
        Territory_Distributor__c territory5 =  new Territory_Distributor__c();
        territory5.Name = 'Deccan';
        territory5.TerritoryCode__c = 'BR160';
        territory5.SBU__c = sbObj.Id;     
        territory5.Region__c = reg.id;
        territory5.SalesOrg__c = sorg.Id;
        //territory5.i
        territory5.RegionDesciption__c = 'BR1001102 CHPS';                       
        territory5.Zone__c = zo.Id;
        territory5.TerritoryManager__c = userTerMan123.Id; //userTerMan
        //territory5.TerritoryManagerActive__c = false;
        insert territory5;
        
        OrderRequestController.typeofOrderBonification(userTerMan123.Id,'BR160');
        OrderRequestController.getSOM(userTerMan123.Id,'BR160');
        
        //Territory_Distributor__c tdList = [SELECT ID, Name,TerritoryManager__c, TerritoryCode__c, Region__c,Region__r.RegionCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR160' LIMIT 1];
        //system.debug('**User ->' +userTerMan1);
        //system.debug('**Territory Distributor ->' +tdList);
        
        
        
        //Depot__c oDep = new Depot__c(Name = 'Test');
        Id depotRecordTypeId = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();
        Depot__c dep = new Depot__c(Name = 'test', Depot_Code__c = 'Test123', SalesOrg__c = sorg.Id, RecordTypeId = depotRecordTypeId, Active__c = true);
        insert dep;
        
        //Depot__c dep = [SELECT Id, Depot_Code__c FROM Depot__c WHERE SalesOrg__c = :sorg.Id AND Id = :acc.Depot_Code__c LIMIT 1]; 
        Account acc = new Account(Name = 'Test', SAP_Code__c = '12345', Depot_Code__c = dep.Id);
        insert acc;
        
        //Account acc = [SELECT id, Customer_Group__c, Customer_Region__c, Depot_Code__c FROM Account WHERE Name = 'AGROPOLLO COMERCIAL AGRICOLA LTDA' LIMIT 1]; 
        
        string sDepotCode = dep.Depot_Code__c;
        
        list<string> lisi = OrderRequestController.getSeller();
        Division__c div = [select id from Division__c limit 1];
        SKU__c skuRecord = new SKU__c(
            Name = 'a1C0k000000A1ug',                                 // SKU Name
            SKU_Code__c = '000000000006302803',                       // SKU Code
            SKU_Description__c = 'Kit ',   // SKU Description
            UOM__c = 'KG', 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Multiple_of__c = 25.00,                                   // Multiple Of
            Combination_Key__c = '519110000000000006302803',          // Combination Key
            Active__c = true,
            Kit_Product__c = true,
            brand_name__c = 'MANZATE Kit',// Active
            Unit_Cost__c = 10.00
        );
        insert skuRecord;
        SKU__c skuRecord1 = new SKU__c(
            Name = 'a1C0k000000A1ue',                                 // SKU Name
            SKU_Code__c = '000000000006302804',                       // SKU Code
            SKU_Description__c = 'MANZATE 800WP 25KG PAPER BAG_BR 1',   // SKU Description
            UOM__c = 'KG', 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Multiple_of__c = 25.00,                                   // Multiple Of
            Combination_Key__c = '519110000000000006302804',          // Combination Key
            Active__c = true,
            brand_name__c = 'MANZATE1',// Active
            Unit_Cost__c = 10.00
        );
        insert skuRecord1;
        
        Brazil_Region_SKU_Combination__c newRec = new Brazil_Region_SKU_Combination__c(
            Sales_District__c = reg.Id,
            SKU__c = skuRecord.Id,
            Date__c = System.today(),
            Availability__c = 'No'
        );
        
        insert newRec;
       
        Price_Book_Details__c pbdetails1 =  [SELECT Id,SKU__r.id, Unit_Price__c, Monthly_Interest_Rate__c, SKU__c FROM Price_Book_Details__c LIMIT 1];
        pbdetails1.Kit_SKU__c = skuRecord.id;
        pbdetails1.Minimum_Price_U__c = 1;
        update pbdetails1;
        Price_Book_Details__c pbdetails2 = pbdetails1.clone(false, false, false, false);
        pbdetails2.SKU__c = skuRecord1.id;
        pbdetails2.Kit_SKU__c = skuRecord.id;
        insert pbdetails2;
        Price_Book__c pricebook = [SELECT Id FROM Price_Book__c LIMIT 1];
        pricebook.Kit_Price_Book__c = true;
        update pricebook;
        
        Component__c compRecord = new Component__c(
            Component_Item_Category__c = 'CTCV',                       
            Component_Quantity__c = 10,   
            Component_SKU__c = pbdetails1.SKU__r.id, 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Kit_SKU__c = skuRecord.id,                                   
            Combination_Key__c = '519110000000000006302803'        
        );
        insert compRecord;
        Component__c compRecord1 = new Component__c(
            Component_Item_Category__c = 'CTCV',                       
            Component_Quantity__c = 10,   
            Component_SKU__c = pbdetails2.SKU__r.id, 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Kit_SKU__c = skuRecord.id,                                   
            Combination_Key__c = '519110000000000006302804'        
        );
        insert compRecord1;
        Payment_Term__c payTerm = new Payment_Term__c(
            Payment_Term_Code__c = 'BR71',                        
            Payterms_Desc__c = 'INFORMAR VENCIMENTO',  
            Sales_Org__c = sorg.Id,                             
            Days_to_calc_interest__c = 0,                      
            Maturity_Date_Mandatory__c = 'Yes',                  
            Active__c = true                                   
        );
        insert payTerm;
        Inco_Term__c incoTm = [SELECT Id,  Name FROM Inco_Term__c WHERE IncoTerm_Code__c = 'CIF' LIMIT 1];
        Territory_Distributor__c territory = [SELECT Id,TerritoryCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR165'];
        Sales_Order__c sobj = new Sales_Order__c(
            OwnerId = userTerMan1.Id, 
            SFDC_Order_Number__c = '83601',                     // SFDC Order Number
            SAP_Order_Number__c = '7009090605',                 // SAP Order Number
            Order_Cancel__c = false,     
            Sales_Org_lk__c = sorg.Id,                             // Order Cancel
            Order_Status__c = 'Not yet processed',              // Order Status
            OrderSubStatus__c = 'Approved',                     // Order Sub-Status
            Region_Territory__c = territory.Id,                  // Region / Territory
            RequestforCancellationCheck__c = false,  
            BudgetApprovalCheck__c = false,// Request for Cancellation
            //  BarterManager__c = BarterUser.Id, 
            Flag_Status__c = 'dislike\n',                       // Flag Status
            BrazilOrderSubmittedforApproval__c = true,          // Brazil Order Submitted for Approval
            //SalesOfficeManager__c = ZonalHeadUser.Id,          // Sales Office Manager
            Price_Book__c = pricebook.Id,                          // Price Book
            //SalesDistrictManager__c =  regioHeadUser.Id,    
            Inco_Term__c = incoTm.Id, 
            Currency_Brazil__c = 'Billing USD / Payment USD',   // Currency (Brazil)
            Key_Account__c = false,                             // Key Account
            Sold_to_Party__c = acc.Id,                         // Sold to Party
            Valid_FROM__c = system.today(), 
            Kit_Order__C = true,
            //  PaymentMethod__c = pMethod.Id, // Valid FROM
            Valid_To__c = system.today()+350,                   // Valid To
            Payment_Term__c = payTerm.Id,                     // Payment Term
            Type_of_Order__c = 'CONTRATO MÃE'                 // Type of Order
        );
        insert sobj;
        
        
        Sales_Order__c sobj1 = new Sales_Order__c(
            OwnerId = userTerMan1.Id, 
            
            Order_Cancel__c = false,     
            Sales_Org_lk__c = sorg.Id,                             // Order Cancel
            Order_Status__c = 'Not yet processed',              // Order Status
            OrderSubStatus__c = 'Pending',                     // Order Sub-Status
            Region_Territory__c = territory.Id,                  // Region / Territory
            RequestforCancellationCheck__c = false,  
            BudgetApprovalCheck__c = false,// Request for Cancellation
            //  BarterManager__c = BarterUser.Id, 
            Flag_Status__c = 'dislike\n',                       // Flag Status
            BrazilOrderSubmittedforApproval__c = true,          // Brazil Order Submitted for Approval
            //SalesOfficeManager__c = ZonalHeadUser.Id,          // Sales Office Manager
            Price_Book__c = pricebook.Id,                          // Price Book
            //SalesDistrictManager__c =  regioHeadUser.Id,    
            Inco_Term__c = incoTm.Id, 
            Currency_Brazil__c = 'Billing USD / Payment USD',   // Currency (Brazil)
            Key_Account__c = false,                             // Key Account
            Sold_to_Party__c = acc.Id,                         // Sold to Party
            Valid_FROM__c = system.today(), 
            Sales_Order__c =  sobj.Id,                  
            Payment_Term__c = payTerm.Id,                     // Payment Term
            Type_of_Order__c = 'BONIFICAÇÃO'                 // Type of Order
        );
        insert sobj1;
        
        
        SO_id=sobj.Id;
        ExchangeRate__c ExchngRte = new ExchangeRate__c(
            FROMCurrency__c = 'USD',                                  // FROM Currency
            ToCurrency__c = 'BRL',                                    // To Currency
            ExchangeRate__c = 3.45 ,                                  // Exchange Rate
            UpdatedDate__c = system.today()+45                       // Updated Date
        );
        insert ExchngRte;
        Test.startTest(); 
        Sales_Order_Line_Item__c soLineItm = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj.Id,          // Sale Order
            SKU_Name__c = skuRecord.Id,            // SKU Name
            Kit_Product__C = true,
            Item_Number__c = 10,                        // Item Number
            Item_Status__c = 'Not yet processed',       // Item Status
            Item_Cancel__c = false,                     // Item Cancel
            Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
            Sales_Org__c = sorg.Id,           // Sales Org
            PriceBookDetail__c = pbdetails1.Id,  // Price Book Detail
            Approval_Flag__c = 0,                       // Approval Flag
            ExchangeRate__c = ExchngRte.id,        // Exchange Rate
            OrderQuantityEdited__c = false,             // Order Quantity Edited
            Time_in_months__c = 0,                      // Time in months
            Days__c = 0,                                // Days
            DateofFAT__c =  system.today()+1, 
            Quantity__c = 450.00,                       // Quantity
            UnitValue__c = 100.00,                      // Unit Value
            UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
            InterestRate__c = 0.00,                     // Interest Rate
            TotalTax__c = 0.00,                         // Total Tax
            Tax__c = 1.00,
            Freight__c = 1.00,
            TotalFreight__c = 0.00,                     // Total Freight
            TotalPunctuality__c = 0.00,                 // Total Punctuality
            TotalLedgerCost__c = 0.00,                  // Total Ledger Cost
            TotalReplacementCost__c = 0.00 ,
            Customer_Conversion_Factor__c = 1// Total Replacement Cost
        );
        insert soLineItm;
          
        Sales_Order_Line_Item__c soLineItm1 = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj.Id,          // Sale Order
            SKU_Name__c = skuRecord.Id,            // SKU Name
            Item_Number__c = 20,                        // Item Number
            Kit_Product__C = false,
            Item_Status__c = 'Not yet processed',       // Item Status
            Item_Cancel__c = false,                     // Item Cancel
            Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
            Sales_Org__c = sorg.Id,           // Sales Org
            PriceBookDetail__c = pbdetails1.Id,  // Price Book Detail
            Approval_Flag__c = 0,                       // Approval Flag
            ExchangeRate__c = ExchngRte.id,        // Exchange Rate
            OrderQuantityEdited__c = false,             // Order Quantity Edited
            Time_in_months__c = 0,                      // Time in months
            Days__c = 0,                                // Days
            DateofFAT__c =  system.today()+1, 
            Quantity__c = 450.00,                       // Quantity
            UnitValue__c = 100.00,                      // Unit Value
            UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
            InterestRate__c = 0.00,                     // Interest Rate
            TotalTax__c = 0.00,                         // Total Tax
            Tax__c = 1.00,
            Freight__c = 1.00,
            TotalFreight__c = 0.00,                     // Total Freight
            TotalPunctuality__c = 0.00,                 // Total Punctuality
            TotalLedgerCost__c = 0.00,                  // Total Ledger Cost
            TotalReplacementCost__c = 0.00 ,
            Customer_Conversion_Factor__c = 1,// Total Replacement Cost
            Kit_Item_Number__C = 10
        );
        
        insert soLineItm1;
        
        Sales_Order_Line_Item__c soLineItm3 = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj1.Id,          // Sale Order
            SKU_Name__c = skuRecord.Id,            // SKU Name
            Kit_Product__C = true,
            Item_Number__c = 10,
            CurrencyIsoCode='BRL',
            //Price_List_Total_Value__c=123,// Item Number
            Item_Status__c = 'Not yet processed',       // Item Status
            Item_Cancel__c = false,                     // Item Cancel
            Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
            Sales_Org__c = sorg.Id,           // Sales Org
            PriceBookDetail__c = pbdetails1.Id,  // Price Book Detail
            Approval_Flag__c = 0,                       // Approval Flag
            ExchangeRate__c = ExchngRte.id,        // Exchange Rate
            OrderQuantityEdited__c = false,             // Order Quantity Edited
            Time_in_months__c = 2,                      // Time in months
            Days__c =1,                                // Days
            DateofFAT__c =  system.today()+1, 
            Quantity__c = 450.00,                       // Quantity
            UnitValue__c = 100.00,                      // Unit Value
            UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
            InterestRate__c = 1.00,                     // Interest Rate
            TotalTax__c = 1.00,                         // Total Tax
            Tax__c = 1.00,
            Freight__c = 1.00,
            TotalFreight__c = 1.00,                     // Total Freight
            TotalPunctuality__c = 1.00,                 // Total Punctuality
            TotalLedgerCost__c = 1.00,                  // Total Ledger Cost
            TotalReplacementCost__c = 1.00 ,
            Customer_Conversion_Factor__c = 1// Total Replacement Cost
        );
        insert soLineItm3;
        
        Material_Plant_Relation__c mpr = new Material_Plant_Relation__c();
        mpr.COGSinfo__c=123;
        mpr.Active__c=true;
        mpr.Depot__c=acc.Depot_Code__c;
        mpr.Material_Code__c='000000000006302803'; 
        mpr.Replacement_Cost__c=12;
        mpr.SKU__c=skuRecord.id;
        insert mpr;
        
        
        
        // OrderRequestController.getReplacementCost(skuRecord.id);
        OrderRequestController.relatedOrder(sobj1.id);
        OrderRequestController.relatedOrder1(sobj1.id);
        OrderRequestController.getOrderSubStatus(sobj1.id);
        /* OrderRequestController.getCreatedDate(sobj1.id);
// OrderRequestController.getSalesOrder(sobj1.id);
// OrderRequestController.getStructSalesOrderItems(sobj1.id);
//OrderRequestController.relatedOrder(sobj1.id);
// OrderRequestController.processApproval(true, sobj1.id, 'Test');
// OrderRequestController.getrelatedSalesOrder(sobj.id);
// OrderRequestController.deleteSalesOrder(sobj.id);
// OrderRequestController.cogsValueUpdate(skuRecord.id,acc.id);
// OrderRequestController.getReplacementCost(skuRecord.Id);

Culture__c culture = [SELECT Id FROM Culture__c LIMIT 1];
List<OrderRequestController.SalesOrderItem> solst = new List<OrderRequestController.SalesOrderItem>(); 
OrderRequestController.SalesOrderItem wrapObj = new OrderRequestController.SalesOrderItem();
wrapObj.productId = skuRecord.id;
wrapObj.fatDate = '02/05/2018';
wrapObj.qty = 100;
wrapObj.listValue = 50;
wrapObj.unitValue = 32;
wrapObj.unitValueWithInterest = 32;
wrapObj.productCode =  skuRecord.SKU_Code__c;
wrapObj.totalValue = 12816;
wrapObj.interestRate = 0;
wrapObj.days = 0;
wrapObj.cultureDesc = culture.Id;
wrapObj.priceBookDetailId = pbdetails1.Id;
wrapObj.productName = '';
wrapObj.inventory = 0;
wrapObj.discount = 16.35;
wrapObj.replacementMargin = 0;
wrapObj.ledgerMargin = 63.1;
wrapObj.totalValueWithInterest = 0;
wrapObj.timeInMonths = 0;
wrapObj.multipleOf = 0;
wrapObj.kitProduct = true;
wrapObj.kitNo = 10;
//refKitNo = 
solst.add(wrapObj);
String serlizeStr = JSON.serialize(solst); 

List<OrderRequestController.PriceDetail> lstPriceDetail = new List<OrderRequestController.PriceDetail>();
OrderRequestController.PriceDetail oPD = new OrderRequestController.PriceDetail();
oPD.pricebookId = pricebook.Id;
oPD.skuId = skuRecord.Id;
oPD.kitSKU = skuRecord.Id;
lstPriceDetail.add(oPD);

List<Id> kitSKUs = new List<Id>();
kitSKUs.add(dep.id);

System.runAs(userTerMan1) {
// OrderRequestController.getPriceBookDetails(pricebook.Id,  dep.id,  acc.Customer_Region__c, acc.Id);
// OrderRequestController.getMOPriceBookDetails(pricebook.Id, sobj.id, dep.id, acc.Customer_Region__c, sobj.id, false);
OrderRequestController.fetchKitComponentProduct(lstPriceDetail,  kitSKUs,  pricebook.Id);
OrderRequestController.getSalesOrderItems(sobj.id);
OrderRequestController.getCreatedDate(sobj.id);
OrderRequestController.getInventory(sobj.id);
OrderRequestController.getSelloutMinpriceFactor();

// OrderRequestController.saveSalesOrder(sobj,  serlizeStr,  false,  false);

}
*/
        
        
        Test.stopTest(); 
    }  
    
    
    
    static testMethod void method9(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person' LIMIT 1]; 
        //User userTerMan1 = [select id from user where Email = 'roberta.marcondes@upl-ltd.com' limit 1];  
        User userTerMan1 = new User(
            Alias = 'WES',                                                             // Alias
            Email = 'shama11@skinternational.com',                                           // Email
            ProfileId = p.Id,                                                              // Profile
            Username = 'test@uniphos3.com.upltest',                                     // Username
            IsActive = true,                                                               // Active
            LastName = 'BARBOSA DErCAMARGO', 
            CommunityNickname = 'XyuTest',                                                // Nickname
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
            country = 'Brazil',
            TM_Code__c = 'Test'
        );
        insert userTerMan1;
        
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '5191'];
        Account acc2 = [SELECT id, Customer_Group__c, Customer_Region__c FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'INTERNATIONAL' LIMIT 1]; 
        acc2.Customer_Region__c='SP';
        update acc2;
        Sales_Order__c soMother = [SELECT id, Type_of_Order__c FROM Sales_Order__c WHERE SalesOrgCode__c = '5191' AND Type_of_Order__c = 'CONTRATO MÃE' LIMIT 1];
        
        Price_Book_Details__c pbdetails1 =  [SELECT Id, Unit_Price__c, Monthly_Interest_Rate__c,Future_Sales_Price_R__c, Future_Sales_Price_U__c, Unit_Price_R__c,
                                             Unit_Price_U__c, Minimum_Price_U__c, Minimum_Price_R__c, Volume__c, SKU__c FROM Price_Book_Details__c LIMIT 1];
        Price_Book__c pricebook = [SELECT Id,USD_Rate__c FROM Price_Book__c LIMIT 1];
        pricebook.USD_Rate__c=5.02;
        pricebook.CurrencyIsoCode='USD';
        update pricebook;
                Price_Book__c pricebook1 = [SELECT Id,USD_Rate__c FROM Price_Book__c LIMIT 1];
        pricebook1.USD_Rate__c=5.02;
       // pricebook.CurrencyIsoCode='USD';
        update pricebook1;
        Depot__c dep = [SELECT Id FROM Depot__c WHERE SalesOrg__c = :sorg.Id LIMIT 1]; 
        SKU__c skurec = [SELECT Id, SKU_Description__c, SKU_Code__c, Multiple_of__c FROM SKU__c LIMIT 1];
        Culture__c culture = [SELECT Id FROM Culture__c LIMIT 1];
        //Material_Registration__c matreg =  [SELECT Id,  Name,  Sales_Org__c,  SKU__c,  State__c FROM Material_Registration__c LIMIT 1];
        Inco_Term__c incoTm = [SELECT Id,  Name FROM Inco_Term__c WHERE IncoTerm_Code__c = 'CIF' LIMIT 1];
        Region__c reg1 = [select id,name,RegionCode__c from Region__c limit 1];
        Zone__c zo1 = [select id,name from Zone__c limit 1];
        SBU__c sbObj1 = [select id, name from SBU__c limit 1];
        ExchangeRate__c ExchngRte = new ExchangeRate__c(
            FROMCurrency__c = 'USD',                                  // FROM Currency
            ToCurrency__c = 'BRL',                                    // To Currency
            ExchangeRate__c = 3.45 ,                                  // Exchange Rate
            UpdatedDate__c = system.today()+45                       // Updated Date
        );
        Territory_Distributor__c territory7 =  new Territory_Distributor__c();
        territory7.Name = 'Taj';
        territory7.TerritoryCode__c = 'BR190';
        territory7.SBU__c = sbObj1.Id;     
        territory7.Region__c = reg1.id;
        territory7.SalesOrg__c = sorg.Id;
        territory7.RegionDesciption__c = 'BR1001102 CHPS';                       
        territory7.Zone__c = zo1.Id;
        territory7.TerritoryManager__c = userTerMan1.Id; //userTerMan
        insert territory7;
        
        Territory_Distributor__c tdList = [SELECT ID, Name,TerritoryManager__c, TerritoryCode__c, Region__c,Region__r.RegionCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR190'];
        
        system.debug('**User child order ->' +userTerMan1);
        system.debug('**Territory Distributor child order ->' +tdList);
        
        Brazil_Region_SKU_Combination__c newRec1 = new Brazil_Region_SKU_Combination__c(
            Sales_District__c = reg1.Id,
            SKU__c = skurec.Id,
            Date__c = System.today(),
            Availability__c = 'No'
        );
        insert newRec1;
        
        Account acc = [SELECT id,Depot_Code__c, Customer_Group__c, Customer_Region__c FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'PASSINATO' LIMIT 1];
        
        
        Material_Plant_Relation__c MPRelation = new Material_Plant_Relation__c(
            Name = 'MANZATE 800WP 25KG PAPER BAG_BR',               // Material Plant Relation Name
            Material_Code__c = '000000000006302802',                // Material Code
            Active__c = true,                                       // Active
            Material_Desc__c = 'MANZATE 800WP 25KG PAPER BAG_BR',   // Material Desc
            Depot__c = dep.Id,                         
            Material_Ledger_Cost__c = 13.26,                        // Material Ledger Cost
            MC_Currency__c = 'BRL',                                 // MC Currency
            Replacement_Cost__c = 2.10,                             // Replacement Cost
            RC_Currency__c = 'USD',                                 // RC Currency
            SKU__c = skurec.Id,                         
            Sales_Org__c = sorg.Id 
        );
        insert MPRelation;
        Sales_Order__c so2 = new Sales_Order__c();
        SO2.Sales_Order__c = soMother.Id;
        so2.Type_of_Order__c = 'ORDEM FILHA';                 // Type of Order
        so2.Currency_Brazil__c = 'Billing USD / Payment USD';  // Currency (Brazil)
        so2.Valid_FROM__c = System.today();          // Valid FROM
        so2.BrazilOrderSubmittedforApproval__c = true;         // Brazil Order Submitted for Approval
        so2.Valid_To__c = System.today()+365;          // Valid To
        so2.PONumber__c = 'qweet1';   
        so2.BudgetApprovalCheck__c = false;
        so2.Inco_Term__c = incotm.Id;
        so2.Key_Account__c = false;  
        so2.Purchase_Order_Date__c = System.today()+5;
        so2.Business_Discount__c = 0.00;                      // Business Discount
        so2.Financial_Discount__c = 0.00;                     // Financial Discount
        so2.Sold_to_Party__c = acc2.Id;       // Sold to Party
        so2.Sales_Org_lk__c = sorg.Id;
        so2.CurrencyIsoCode = 'BRL';
        so2.Punctuality_Discount__c=1.2;
        insert so2;
        so2.Price_Book__c=pricebook.id;
        Sales_Order__c so3 = new Sales_Order__c();
        So3.Sales_Order__c = soMother.Id;
        so3.Type_of_Order__c = 'ORDEM FILHA';                 // Type of Order
        so3.Currency_Brazil__c = 'Billing USD / Payment USD';  // Currency (Brazil)
        so3.Valid_FROM__c = System.today();          // Valid FROM
        so3.BrazilOrderSubmittedforApproval__c = true;         // Brazil Order Submitted for Approval
        so3.Valid_To__c = System.today()+365;          // Valid To
        so3.PONumber__c = 'qweet1';   
        so3.BudgetApprovalCheck__c = false;
        so3.Inco_Term__c = incotm.Id;
        so3.Key_Account__c = false;  
        so3.Purchase_Order_Date__c = System.today()+5;
        so3.Business_Discount__c = 0.00;                      // Business Discount
        so3.Financial_Discount__c = 0.00;                     // Financial Discount
        so3.Sold_to_Party__c = acc2.Id;       // Sold to Party
        so3.Sales_Org_lk__c = sorg.Id;
        
        
        Sales_Order__c so4 = new Sales_Order__c();
        so4.Sales_Order__c = soMother.Id;
        so4.Type_of_Order__c = 'ORDEM FILHA';                 // Type of Order
        so4.Currency_Brazil__c = 'Billing USD / Payment USD';  // Currency (Brazil)
        so4.Valid_FROM__c = System.today();          // Valid FROM
        so4.BrazilOrderSubmittedforApproval__c = true;         // Brazil Order Submitted for Approval
        so4.Valid_To__c = System.today()+365;          // Valid To
        so4.PONumber__c = 'qweet1';   
        so4.BudgetApprovalCheck__c = false;
        so4.Inco_Term__c = incotm.Id;
        so4.Key_Account__c = false;  
        so4.Purchase_Order_Date__c = System.today()+5;
        so4.Business_Discount__c = 0.00;                      // Business Discount
        so4.Financial_Discount__c = 0.00;                     // Financial Discount
        so4.Sold_to_Party__c = acc2.Id;       // Sold to Party
        so4.Sales_Org_lk__c = sorg.Id;
        so4.CurrencyIsoCode = 'BRL';
        so4.Punctuality_Discount__c=1.2;
        so4.Order_Status__c='Cancelled';
        insert so4;
        List<OrderRequestController.StructOrderLineItem> structsolst = new List<OrderRequestController.StructOrderLineItem>(); 
        OrderRequestController.StructOrderLineItem structwrapObj = new OrderRequestController.StructOrderLineItem();
        structwrapObj.skuCategory = '';  
        structwrapObj.isManual = false;    
        structwrapObj.interestRateBRL =1.0;
        structwrapObj.interestRateUSD =2.0;
        structwrapObj.interestDate ='';
        structwrapObj.volDifference ='2545';
        structwrapObj.totalValStr ='231231';    
        structwrapObj.totalValWithInterestStr='232';
        structwrapObj.priceWithInterestStr ='342';
        structwrapObj.discountedInitialPriceStr = '3423';
        structwrapObj.soItemId = '';    
        structwrapObj.combinationkey = pbdetails1.Id;
        structwrapObj.multipleOf = 0;
        structwrapObj.campGrp ='001';
        structwrapObj.camSubgrp='orthene';
        structwrapObj.skuId= skurec.id;
        structwrapObj.skuDesc='';
        structwrapObj.cultureId ='';
        structwrapObj.cultureDesc ='';
        structwrapObj.UOM ='';    
        structwrapObj.volume = 0;
        structwrapObj.prdctVol= 2000;
        structwrapObj.intialPrice= 230;
        structwrapObj.invoiceDate='02/05/2018';
        structwrapObj.grpDiscount=0;
        structwrapObj.fspPrice =0;
        structwrapObj.totalVal= 0; 
        structwrapObj.costBRL= 56;
        structwrapObj.costUSD= 67;
        structwrapObj.intialPriceDisount= 0;
        structwrapObj.priceWithInterest= 0;
        structwrapObj.FinalUnitPrice= 878780;
        structwrapObj.totalValWithInterest= 1000;
        structwrapObj.equivalence = 0;
        structwrapObj.isTrue = true; 
        structwrapObj.interestRate = 2;  
        structwrapObj.days = 5;
        structwrapObj.timeInMonths = 10; 
        structsolst.add(structwrapObj);
        
        List<OrderRequestController.SalesOrderItem> solst = new List<OrderRequestController.SalesOrderItem>(); 
        OrderRequestController.SalesOrderItem wrapObj = new OrderRequestController.SalesOrderItem();
        map<string,decimal> soMap=new map<string,decimal>();
         wrapObj.Ids= skurec.id;
        wrapObj.productId = skurec.id;
        wrapObj.fatDate = '02/05/2018';
        wrapObj.qty = 50;
        wrapObj.listValue = 50;
        wrapObj.unitValue = 32;
        wrapObj.unitValueWithInterest = 32;
        wrapObj.productCode =  skurec.SKU_Code__c;
        wrapObj.totalValue = 12816;
        wrapObj.interestRate = 0;
        wrapObj.days = 0;
        wrapObj.cultureDesc = culture.Id;
        wrapObj.priceBookDetailId = pbdetails1.Id;
        wrapObj.productName = '';
        wrapObj.inventory = 0;
        wrapObj.discount = 16.35;
        wrapObj.replacementMargin = 0;
        wrapObj.ledgerMargin = 63.1;
        wrapObj.totalValueWithInterest = 110;
        wrapObj.timeInMonths = 0;
        wrapObj.CustomerConversionFactor = 1;
        wrapObj.multipleOf = 0;
         soMap.put(wrapObj.productId, wrapObj.unitValue);
        solst.add(wrapObj);
        

       
        String serlizeStr = JSON.serialize(solst);  
        String serlizeStr1 = JSON.serialize(structsolst);  
        Territory_Distributor__c tdObj = [SELECT Id,TerritoryCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR165'];
        
        /*tdObj.TerritoryManager__c = userTerMan1.Id;
update tdObj;*/
        
        
        Business_Rule__c BusinessRule = new Business_Rule__c(
            Name = 'SP',               // Business Rule Name
            Sales_Org__c = sorg.Id,             // Sales Org
            Taxes__c = 30.00,                   // Taxes
            Total_Order_Margin__c = 45.00,      // Total Order Margin > = 
            Freight__c = 6.90,                  // Freight
            List_Price_Discount__c = 5.00
            // Default__c = true                    // List Price Discount < = 
        );
        insert BusinessRule;
        
        Associate_Group__c asGroup = new Associate_Group__c(
            Name = 'Sales Person',                // Name
            Business_Rule__c = BusinessRule.Id  // Business Rule
        );
        insert asGroup;
        
        Employee_Details__c EmpDetail = new Employee_Details__c(
            User__c = userTerMan1.id,           
            Associate_Group__c = asGroup.Id 
        );
        insert EmpDetail;
        
        List<OrderRequestController.Salesorder> sordlist = new List<OrderRequestController.Salesorder>(); 
        OrderRequestController.Salesorder sord = new OrderRequestController.Salesorder();
        sord.Numero_do_Pedido = 1;
        sord.Management = 'Test' ;
        sord.Mes_do_pedido = '3425';
        sord.Business_Unit = '5';
        sord.Customer_Group = 'LS' ;
        sord.Customer = 'Test Acc';
        sord.Brand = 'Test';
        sord.Prod_Code = 123425;
        sord.Product_Description = 'Test Dec';
        sord.Quantity = 21 ;
        sord.Order_Sales_FV_USD = 123.3;
        sord.Order_Total_Cogs_USD = 123.3;
        sord.Order_Gross_Margin_PV_USD = 123.3;
        sord.Price_List_Sales_FV_USD = 123.3;
        sord.Currency1 = 'USD' ;
        sordlist.add(sord);
        
        
        
        System.runAs(userTerMan1) {
            OrderRequestController.getOrderFields(true,userInfo.getUserId(),false, false, acc.Id,'ORDEM FILHA' , false,false);  
            //OrderRequestController.getOrderFields(true,userInfo.getUserId(),false, false, acc.Id,'ORDEM FILHA' , false,false);  
            //OrderRequestController.getSOM(userTerMan1.Id);
            System.debug('Usr Id---> '+userTerMan1.Id);
            // OrderRequestController.getSOM(userTerMan1.Id,'BR165');
            // OrderRequestController.getPBPaymentTerms(pricebook.Id);
            // OrderRequestController.getCustomers( userTerMan1.Id,  so2.Type_of_Order__c,  acc2.Customer_Group__c,  acc2.Id);
            // OrderRequestController.getKeyCustomers(userTerMan1.Id,  so2.Type_of_Order__c,  acc2.Customer_Group__c, acc2.Id);
            // OrderRequestController.validateQuantitySOC(pricebook.Id, soMother.Id,  dep.Id,  acc2.Customer_Region__c, so2.Id, serlizeStr);
            //OrderRequestController.saveSalesOrder(so2,  serlizeStr,  false,  false);
            OrderRequestController.getCustomerTaxFreight('SP');
            OrderRequestController.totalrepcostlogic(serlizeStr,  'BRL',  3.04,  acc2.id);
            OrderRequestController.updatePresentValueByBarter(serlizeStr, pricebook.Id,1.00);
            OrderRequestController.updateBarterLineitem(serlizeStr,pricebook.Id,soMap);
             OrderRequestController.updateBarterLineitem(serlizeStr,pricebook1.Id,soMap);
            OrderRequestController.ChildReplacementMargin(so2, serlizeStr);
            OrderRequestController.barterDiscountUpdate(so2, serlizeStr,true);
            OrderRequestController.barterDiscountUpdate(so4, serlizeStr,false);
            OrderRequestController.getMaterialPlantRelationObjListSimulate();
            OrderRequestController.getMaterialPlantRelationSimulate();
            OrderRequestController.getMaterialPlantRelationObjListBR00();
            /*OrderRequestController.dealScoringValidCall(so2,serlizeStr,acc2.id, null);
OrderRequestController.simulateSalesOrder(so2,serlizeStr);
OrderRequestController.isBrazilUsercheck();
OrderRequestController.isBrazilSalesUsercheck();*/
            
            //RITM0355165 - Brazil sales order enhancement to track revenue of cancel order
            //OrderRequestController.getLast24MonthsSalesOrders();
            //RITM0355165 - Brazil sales order enhancement to track revenue of cancel order
            
            //OrderRequestController.getCustomerConversionFactor(acc2.Id);
            //OrderRequestController.getPriceListValuesSalesRep(userTerMan1.Id);
            // OrderRequestController.saveStructuresalesOrder(So3,  serlizeStr1,  serlizeStr1);
            OrderRequestController.getBusinessRule(so2.Id,  userTerMan1.Id);
            
            //test method for structure Order 
            Attachment attach = new Attachment(
                parentId = so2.id,
                Body = EncodingUtil.base64Decode('fdestdctyrgdybdrtnuftyuytmiynu'),
                Name = 'fileName',
                ContentType = '.pdf');
            // insert attach;
            // OrderRequestController.getStructSalesOrderItems(so2.Id);
            //OrderRequestController.fetchStructureCampaign(pricebook.Id,'');
            //  OrderRequestController.saveChunk(so2.Id,'fileName','gdsytrsrthj','bdftytrdcu',attach.Id);
            //  OrderRequestController.saveChunk(so2.Id,'fileName','gdsytrsrthj','bdftytrdcu','');
            //OrderRequestController.processApproval(true, SO_id, 'Test...');
            //
            
            
            
            /*OrderRequestController.StructCampaignDetailWrap scd= new OrderRequestController.StructCampaignDetailWrap();
OrderRequestController.CampaignGroupWrap cgw= new OrderRequestController.CampaignGroupWrap();
OrderRequestController.CampaignSubGroupWrap csgw= new OrderRequestController.CampaignSubGroupWrap();
OrderRequestController.PriceBookDetailWrap pbdw= new OrderRequestController.PriceBookDetailWrap();
OrderRequestController.StructOrderLineItem soli= new OrderRequestController.StructOrderLineItem();
OrderRequestController.PriceBookPaymentTermWrapper pricBookPayObj = new OrderRequestController.PriceBookPaymentTermWrapper();
*/
        }
        test.stopTest(); 
    }
    
    static testMethod void method12(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person' LIMIT 1]; 
        //User userTerMan1 = [select id from user where Email = 'roberta.marcondes@upl-ltd.com' limit 1];  
        User userTerMan1 = new User(
            Alias = 'WES',                                                             // Alias
            Email = 'shama11@skinternational.com',                                           // Email
            ProfileId = p.Id,                                                              // Profile
            Username = 'test@uniphos3.com.upltest',                                     // Username
            IsActive = true,                                                               // Active
            LastName = 'BARBOSA DErCAMARGO', 
            CommunityNickname = 'XyuTest',                                                // Nickname
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
            country = 'Brazil',
            TM_Code__c = 'Test'
        );
        insert userTerMan1;
        
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '5191'];
        Account acc2 = [SELECT id, Customer_Group__c, Customer_Region__c FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'INTERNATIONAL' LIMIT 1]; 
        acc2.Customer_Region__c='SP';
        update acc2;
        Sales_Order__c soMother = [SELECT id, Type_of_Order__c FROM Sales_Order__c WHERE SalesOrgCode__c = '5191' AND Type_of_Order__c = 'CONTRATO MÃE' LIMIT 1];
        
        Price_Book_Details__c pbdetails1 =  [SELECT Id, Unit_Price__c, Monthly_Interest_Rate__c,Future_Sales_Price_R__c, Future_Sales_Price_U__c, Unit_Price_R__c,
                                             Unit_Price_U__c, Minimum_Price_U__c, Minimum_Price_R__c, Volume__c, SKU__c FROM Price_Book_Details__c LIMIT 1];
        Price_Book__c pricebook = [SELECT Id,USD_Rate__c FROM Price_Book__c LIMIT 1];
        pricebook.USD_Rate__c=5.02;
        update pricebook;
        Depot__c dep = [SELECT Id FROM Depot__c WHERE SalesOrg__c = :sorg.Id LIMIT 1]; 
        SKU__c skurec = [SELECT Id, SKU_Description__c, SKU_Code__c, Multiple_of__c FROM SKU__c LIMIT 1];
        Culture__c culture = [SELECT Id FROM Culture__c LIMIT 1];
        //Material_Registration__c matreg =  [SELECT Id,  Name,  Sales_Org__c,  SKU__c,  State__c FROM Material_Registration__c LIMIT 1];
        Inco_Term__c incoTm = [SELECT Id,  Name FROM Inco_Term__c WHERE IncoTerm_Code__c = 'CIF' LIMIT 1];
        Region__c reg1 = [select id,name,RegionCode__c from Region__c limit 1];
        Zone__c zo1 = [select id,name from Zone__c limit 1];
        SBU__c sbObj1 = [select id, name from SBU__c limit 1];
        ExchangeRate__c ExchngRte = new ExchangeRate__c(
            FROMCurrency__c = 'USD',                                  // FROM Currency
            ToCurrency__c = 'BRL',                                    // To Currency
            ExchangeRate__c = 3.45 ,                                  // Exchange Rate
            UpdatedDate__c = system.today()+45                       // Updated Date
        );
        Territory_Distributor__c territory7 =  new Territory_Distributor__c();
        territory7.Name = 'Taj';
        territory7.TerritoryCode__c = 'BR190';
        territory7.SBU__c = sbObj1.Id;     
        territory7.Region__c = reg1.id;
        territory7.SalesOrg__c = sorg.Id;
        territory7.RegionDesciption__c = 'BR1001102 CHPS';                       
        territory7.Zone__c = zo1.Id;
        territory7.TerritoryManager__c = userTerMan1.Id; //userTerMan
        insert territory7;
        
        Territory_Distributor__c tdList = [SELECT ID, Name,TerritoryManager__c, TerritoryCode__c, Region__c,Region__r.RegionCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR190'];
        
        system.debug('**User child order ->' +userTerMan1);
        system.debug('**Territory Distributor child order ->' +tdList);
        
        Brazil_Region_SKU_Combination__c newRec1 = new Brazil_Region_SKU_Combination__c(
            Sales_District__c = reg1.Id,
            SKU__c = skurec.Id,
            Date__c = System.today(),
            Availability__c = 'No'
        );
        insert newRec1;
        
        Account acc = [SELECT id,Depot_Code__c, Customer_Group__c, Customer_Region__c FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'PASSINATO' LIMIT 1];
        
        
        Material_Plant_Relation__c MPRelation = new Material_Plant_Relation__c(
            Name = 'MANZATE 800WP 25KG PAPER BAG_BR',               // Material Plant Relation Name
            Material_Code__c = '000000000006302802',                // Material Code
            Active__c = true,                                       // Active
            Material_Desc__c = 'MANZATE 800WP 25KG PAPER BAG_BR',   // Material Desc
            Depot__c = dep.Id,                         
            Material_Ledger_Cost__c = 13.26,                        // Material Ledger Cost
            MC_Currency__c = 'BRL',                                 // MC Currency
            Replacement_Cost__c = 2.10,                             // Replacement Cost
            RC_Currency__c = 'USD',                                 // RC Currency
            SKU__c = skurec.Id,                         
            Sales_Org__c = sorg.Id                      
        );
        insert MPRelation;
        Sales_Order__c so2 = new Sales_Order__c();
        SO2.Sales_Order__c = soMother.Id;
        so2.Type_of_Order__c = 'ORDEM FILHA';                 // Type of Order
        so2.Currency_Brazil__c = 'Billing USD / Payment USD';  // Currency (Brazil)
        so2.Valid_FROM__c = System.today();          // Valid FROM
        so2.BrazilOrderSubmittedforApproval__c = true;         // Brazil Order Submitted for Approval
        so2.Valid_To__c = System.today()+365;          // Valid To
        so2.PONumber__c = 'qweet1';   
        so2.BudgetApprovalCheck__c = false;
        so2.Inco_Term__c = incotm.Id;
        so2.Key_Account__c = false;  
        so2.Purchase_Order_Date__c = System.today()+5;
        so2.Business_Discount__c = 0.00;                      // Business Discount
        so2.Financial_Discount__c = 0.00;                     // Financial Discount
        so2.Sold_to_Party__c = acc2.Id;       // Sold to Party
        so2.Sales_Org_lk__c = sorg.Id;
        so2.CurrencyIsoCode = 'BRL';
        so2.Punctuality_Discount__c=1.2;
        insert so2;
        so2.Price_Book__c=pricebook.id;
        Sales_Order__c so3 = new Sales_Order__c();
        So3.Sales_Order__c = soMother.Id;
        so3.Type_of_Order__c = 'ORDEM FILHA';                 // Type of Order
        so3.Currency_Brazil__c = 'Billing USD / Payment USD';  // Currency (Brazil)
        so3.Valid_FROM__c = System.today();          // Valid FROM
        so3.BrazilOrderSubmittedforApproval__c = true;         // Brazil Order Submitted for Approval
        so3.Valid_To__c = System.today()+365;          // Valid To
        so3.PONumber__c = 'qweet1';   
        so3.BudgetApprovalCheck__c = false;
        so3.Inco_Term__c = incotm.Id;
        so3.Key_Account__c = false;  
        so3.Purchase_Order_Date__c = System.today()+5;
        so3.Business_Discount__c = 0.00;                      // Business Discount
        so3.Financial_Discount__c = 0.00;                     // Financial Discount
        so3.Sold_to_Party__c = acc2.Id;       // Sold to Party
        so3.Sales_Org_lk__c = sorg.Id;
        
        
        Sales_Order__c so4 = new Sales_Order__c();
        so4.Sales_Order__c = soMother.Id;
        so4.Type_of_Order__c = 'ORDEM FILHA';                 // Type of Order
        so4.Currency_Brazil__c = 'Billing USD / Payment USD';  // Currency (Brazil)
        so4.Valid_FROM__c = System.today();          // Valid FROM
        so4.BrazilOrderSubmittedforApproval__c = true;         // Brazil Order Submitted for Approval
        so4.Valid_To__c = System.today()+365;          // Valid To
        so4.PONumber__c = 'qweet1';   
        so4.BudgetApprovalCheck__c = false;
        so4.Inco_Term__c = incotm.Id;
        so4.Key_Account__c = false;  
        so4.Purchase_Order_Date__c = System.today()+5;
        so4.Business_Discount__c = 0.00;                      // Business Discount
        so4.Financial_Discount__c = 0.00;                     // Financial Discount
        so4.Sold_to_Party__c = acc2.Id;       // Sold to Party
        so4.Sales_Org_lk__c = sorg.Id;
        so4.CurrencyIsoCode = 'BRL';
        so4.Punctuality_Discount__c=1.2;
        so4.Order_Status__c='Cancelled';
        insert so4;
        List<OrderRequestController.StructOrderLineItem> structsolst = new List<OrderRequestController.StructOrderLineItem>(); 
        OrderRequestController.StructOrderLineItem structwrapObj = new OrderRequestController.StructOrderLineItem();
        structwrapObj.skuCategory = '';  
        structwrapObj.isManual = false;    
        structwrapObj.interestRateBRL =1.0;
        structwrapObj.interestRateUSD =2.0;
        structwrapObj.interestDate ='';
        structwrapObj.volDifference ='2545';
        structwrapObj.totalValStr ='231231';    
        structwrapObj.totalValWithInterestStr='232';
        structwrapObj.priceWithInterestStr ='342';
        structwrapObj.discountedInitialPriceStr = '3423';
        structwrapObj.soItemId = '';    
        structwrapObj.combinationkey = pbdetails1.Id;
        structwrapObj.multipleOf = 0;
        structwrapObj.campGrp ='001';
        structwrapObj.camSubgrp='orthene';
        structwrapObj.skuId= skurec.id;
        structwrapObj.skuDesc='';
        structwrapObj.cultureId ='';
        structwrapObj.cultureDesc ='';
        structwrapObj.UOM ='';    
        structwrapObj.volume = 0;
        structwrapObj.prdctVol= 2000;
        structwrapObj.intialPrice= 230;
        structwrapObj.invoiceDate='02/05/2018';
        structwrapObj.grpDiscount=0;
        structwrapObj.fspPrice =0;
        structwrapObj.totalVal= 0; 
        structwrapObj.costBRL= 56;
        structwrapObj.costUSD= 67;
        structwrapObj.intialPriceDisount= 0;
        structwrapObj.priceWithInterest= 0;
        structwrapObj.FinalUnitPrice= 878780;
        structwrapObj.totalValWithInterest= 1000;
        structwrapObj.equivalence = 0;
        structwrapObj.isTrue = true; 
        structwrapObj.interestRate = 2;  
        structwrapObj.days = 5;
        structwrapObj.timeInMonths = 10; 
        structsolst.add(structwrapObj);
        
        List<OrderRequestController.SalesOrderItem> solst = new List<OrderRequestController.SalesOrderItem>(); 
        OrderRequestController.SalesOrderItem wrapObj = new OrderRequestController.SalesOrderItem();
        wrapObj.productId = skurec.id;
        wrapObj.fatDate = '02/05/2018';
        wrapObj.qty = 50;
        wrapObj.listValue = 50;
        wrapObj.unitValue = 32;
        wrapObj.unitValueWithInterest = 32;
        wrapObj.productCode =  skurec.SKU_Code__c;
        wrapObj.totalValue = 12816;
        wrapObj.interestRate = 0;
        wrapObj.days = 0;
        wrapObj.cultureDesc = culture.Id;
        wrapObj.priceBookDetailId = pbdetails1.Id;
        wrapObj.productName = '';
        wrapObj.inventory = 0;
        wrapObj.discount = 16.35;
        wrapObj.replacementMargin = 0;
        wrapObj.ledgerMargin = 63.1;
        wrapObj.totalValueWithInterest = 110;
        wrapObj.timeInMonths = 0;
        wrapObj.CustomerConversionFactor = 1;
        wrapObj.multipleOf = 0;
        solst.add(wrapObj);
        
        
        
        String serlizeStr = JSON.serialize(solst);  
        String serlizeStr1 = JSON.serialize(structsolst);  
        Territory_Distributor__c tdObj = [SELECT Id,TerritoryCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR165'];
        
        /*tdObj.TerritoryManager__c = userTerMan1.Id;
update tdObj;*/
        
        
        Business_Rule__c BusinessRule = new Business_Rule__c(
            Name = 'SP',               // Business Rule Name
            Sales_Org__c = sorg.Id,             // Sales Org
            Taxes__c = 30.00,                   // Taxes
            Total_Order_Margin__c = 45.00,      // Total Order Margin > = 
            Freight__c = 6.90,                  // Freight
            List_Price_Discount__c = 5.00
            // Default__c = true                    // List Price Discount < = 
        );
        insert BusinessRule;
        
        Associate_Group__c asGroup = new Associate_Group__c(
            Name = 'Sales Person',                // Name
            Business_Rule__c = BusinessRule.Id  // Business Rule
        );
        insert asGroup;
        
        Employee_Details__c EmpDetail = new Employee_Details__c(
            User__c = userTerMan1.id,           
            Associate_Group__c = asGroup.Id 
        );
        insert EmpDetail;
        
        List<OrderRequestController.Salesorder> sordlist = new List<OrderRequestController.Salesorder>(); 
        OrderRequestController.Salesorder sord = new OrderRequestController.Salesorder();
        sord.Numero_do_Pedido = 1;
        sord.Management = 'Test' ;
        sord.Mes_do_pedido = '3425';
        sord.Business_Unit = '5';
        sord.Customer_Group = 'LS' ;
        sord.Customer = 'Test Acc';
        sord.Brand = 'Test';
        sord.Prod_Code = 123425;
        sord.Product_Description = 'Test Dec';
        sord.Quantity = 21 ;
        sord.Order_Sales_FV_USD = 123.3;
        sord.Order_Total_Cogs_USD = 123.3;
        sord.Order_Gross_Margin_PV_USD = 123.3;
        sord.Price_List_Sales_FV_USD = 123.3;
        sord.Currency1 = 'USD' ;
        sordlist.add(sord);
        
        
        
        System.runAs(userTerMan1) {
            
            
            OrderRequestController.dealScoringValidCall(so2,serlizeStr,acc2.id, null);
            // updated by sumit
            OrderRequestController.simulateSalesOrder(so2,serlizeStr,false);
            OrderRequestController.getRegionCode();
            OrderRequestController.isBrazilUsercheck();
            OrderRequestController.isBrazilSalesUsercheck();
            
            //RITM0355165 - Brazil sales order enhancement to track revenue of cancel order
            //OrderRequestController.getLast24MonthsSalesOrders();
            //RITM0355165 - Brazil sales order enhancement to track revenue of cancel order
            
            //OrderRequestController.getCustomerConversionFactor(acc2.Id);
            //OrderRequestController.getPriceListValuesSalesRep(userTerMan1.Id);
            // OrderRequestController.saveStructuresalesOrder(So3,  serlizeStr1,  serlizeStr1);
            OrderRequestController.getBusinessRule(so2.Id,  userTerMan1.Id);
            
            //test method for structure Order 
            Attachment attach = new Attachment(
                parentId = so2.id,
                Body = EncodingUtil.base64Decode('fdestdctyrgdybdrtnuftyuytmiynu'),
                Name = 'fileName',
                ContentType = '.pdf');
            
            
            
            OrderRequestController.StructCampaignDetailWrap scd= new OrderRequestController.StructCampaignDetailWrap();
            OrderRequestController.CampaignGroupWrap cgw= new OrderRequestController.CampaignGroupWrap();
            OrderRequestController.CampaignSubGroupWrap csgw= new OrderRequestController.CampaignSubGroupWrap();
            OrderRequestController.PriceBookDetailWrap pbdw= new OrderRequestController.PriceBookDetailWrap();
            OrderRequestController.StructOrderLineItem soli= new OrderRequestController.StructOrderLineItem();
            OrderRequestController.PriceBookPaymentTermWrapper pricBookPayObj = new OrderRequestController.PriceBookPaymentTermWrapper();
        }
        test.stopTest(); 
    }
    
    public class MockHttpResponseGenerator2 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('[{"Prod_Code": 6302691, "Recommended_price": 217.92, "DDS_Grade": "Very Good Quality"}] ');
            res.setStatusCode(200);
            return res;
        }
    }
    
    static testMethod void method10(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person' LIMIT 1]; 
        //User userTerMan1 = [select id from user where Email = 'roberta.marcondes@upl-ltd.com' limit 1];  
        User userTerMan1 = new User(
            Alias = 'WES',                                                             // Alias
            Email = 'shama11@skinternational.com',                                           // Email
            ProfileId = p.Id,                                                              // Profile
            Username = 'test@uniphos3.com.upltest',                                     // Username
            IsActive = true,                                                               // Active
            LastName = 'BARBOSA DErCAMARGO', 
            CommunityNickname = 'XyuTest',                                                // Nickname
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
            country = 'Brazil',
            TM_Code__c = 'Test'
        );
        insert userTerMan1;
        
        Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '5191'];
        Account acc2 = [SELECT id, Customer_Group__c, Customer_Region__c FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'INTERNATIONAL' LIMIT 1]; 
        acc2.Customer_Region__c='SP';
        update acc2;
        Sales_Order__c soMother = [SELECT id, Type_of_Order__c FROM Sales_Order__c WHERE SalesOrgCode__c = '5191' AND Type_of_Order__c = 'CONTRATO MÃE' LIMIT 1];
        
        Price_Book_Details__c pbdetails1 =  [SELECT Id, Unit_Price__c, Monthly_Interest_Rate__c,Future_Sales_Price_R__c, Future_Sales_Price_U__c, Unit_Price_R__c,
                                             Unit_Price_U__c, Minimum_Price_U__c, Minimum_Price_R__c, Volume__c, SKU__c FROM Price_Book_Details__c LIMIT 1];
        Price_Book__c pricebook = [SELECT Id,USD_Rate__c FROM Price_Book__c LIMIT 1];
        pricebook.USD_Rate__c=5.02;
        update pricebook;
        Depot__c dep = [SELECT Id FROM Depot__c WHERE SalesOrg__c = :sorg.Id LIMIT 1]; 
        SKU__c skurec = [SELECT Id, SKU_Description__c, SKU_Code__c, Multiple_of__c FROM SKU__c LIMIT 1];
        Culture__c culture = [SELECT Id FROM Culture__c LIMIT 1];
        //Material_Registration__c matreg =  [SELECT Id,  Name,  Sales_Org__c,  SKU__c,  State__c FROM Material_Registration__c LIMIT 1];
        Inco_Term__c incoTm = [SELECT Id,  Name FROM Inco_Term__c WHERE IncoTerm_Code__c = 'CIF' LIMIT 1];
        Region__c reg1 = [select id,name,RegionCode__c from Region__c limit 1];
        Zone__c zo1 = [select id,name from Zone__c limit 1];
        SBU__c sbObj1 = [select id, name from SBU__c limit 1];
        ExchangeRate__c ExchngRte = new ExchangeRate__c(
            FROMCurrency__c = 'USD',                                  // FROM Currency
            ToCurrency__c = 'BRL',                                    // To Currency
            ExchangeRate__c = 3.45 ,                                  // Exchange Rate
            UpdatedDate__c = system.today()+45                       // Updated Date
        );
        Territory_Distributor__c territory7 =  new Territory_Distributor__c();
        territory7.Name = 'Taj';
        territory7.TerritoryCode__c = 'BR190';
        territory7.SBU__c = sbObj1.Id;     
        territory7.Region__c = reg1.id;
        territory7.SalesOrg__c = sorg.Id;
        territory7.RegionDesciption__c = 'BR1001102 CHPS';                       
        territory7.Zone__c = zo1.Id;
        territory7.TerritoryManager__c = userTerMan1.Id; //userTerMan
        insert territory7;
        
        Territory_Distributor__c tdList = [SELECT ID, Name,TerritoryManager__c, TerritoryCode__c, Region__c,Region__r.RegionCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR190'];
        
        system.debug('**User child order ->' +userTerMan1);
        system.debug('**Territory Distributor child order ->' +tdList);
        
        Brazil_Region_SKU_Combination__c newRec1 = new Brazil_Region_SKU_Combination__c(
            Sales_District__c = reg1.Id,
            SKU__c = skurec.Id,
            Date__c = System.today(),
            Availability__c = 'No'
        );
        insert newRec1;
        
        Account acc = [SELECT id,Depot_Code__c, Customer_Group__c, Customer_Region__c FROM Account WHERE Sales_Org__c = :sorg.id AND Last_Name__c = 'PASSINATO' LIMIT 1];
        
        
        Material_Plant_Relation__c MPRelation = new Material_Plant_Relation__c(
            Name = 'MANZATE 800WP 25KG PAPER BAG_BR',               // Material Plant Relation Name
            Material_Code__c = '000000000006302802',                // Material Code
            Active__c = true,                                       // Active
            Material_Desc__c = 'MANZATE 800WP 25KG PAPER BAG_BR',   // Material Desc
            Depot__c = dep.Id,                         
            Material_Ledger_Cost__c = 13.26,                        // Material Ledger Cost
            MC_Currency__c = 'BRL',                                 // MC Currency
            Replacement_Cost__c = 2.10,                             // Replacement Cost
            RC_Currency__c = 'USD',                                 // RC Currency
            SKU__c = skurec.Id,                         
            Sales_Org__c = sorg.Id                      
        );
        insert MPRelation;
        Sales_Order__c so2 = new Sales_Order__c();
        SO2.Sales_Order__c = soMother.Id;
        so2.Type_of_Order__c = 'ORDEM FILHA';                 // Type of Order
        so2.Currency_Brazil__c = 'Billing USD / Payment USD';  // Currency (Brazil)
        so2.Valid_FROM__c = System.today();          // Valid FROM
        so2.BrazilOrderSubmittedforApproval__c = true;         // Brazil Order Submitted for Approval
        so2.Valid_To__c = System.today()+365;          // Valid To
        so2.PONumber__c = 'qweet1';   
        so2.BudgetApprovalCheck__c = false;
        so2.Inco_Term__c = incotm.Id;
        so2.Key_Account__c = false;  
        so2.Purchase_Order_Date__c = System.today()+5;
        so2.Business_Discount__c = 0.00;                      // Business Discount
        so2.Financial_Discount__c = 0.00;                     // Financial Discount
        so2.Sold_to_Party__c = acc2.Id;       // Sold to Party
        so2.Sales_Org_lk__c = sorg.Id;
        so2.CurrencyIsoCode = 'BRL';
        so2.Punctuality_Discount__c=1.2;
        so2.Order_Status__c='Cancelled';
        insert so2;
        so2.Price_Book__c=pricebook.id;
        Sales_Order__c so3 = new Sales_Order__c();
        So3.Sales_Order__c = soMother.Id;
        so3.Type_of_Order__c = 'ORDEM FILHA';                 // Type of Order
        so3.Currency_Brazil__c = 'Billing USD / Payment USD';  // Currency (Brazil)
        so3.Valid_FROM__c = System.today();          // Valid FROM
        so3.BrazilOrderSubmittedforApproval__c = true;         // Brazil Order Submitted for Approval
        so3.Valid_To__c = System.today()+365;          // Valid To
        so3.PONumber__c = 'qweet1';   
        so3.BudgetApprovalCheck__c = false;
        so3.Inco_Term__c = incotm.Id;
        so3.Key_Account__c = false;  
        so3.Purchase_Order_Date__c = System.today()+5;
        so3.Business_Discount__c = 0.00;                      // Business Discount
        so3.Financial_Discount__c = 0.00;                     // Financial Discount
        so3.Sold_to_Party__c = acc2.Id;       // Sold to Party
        so3.Sales_Org_lk__c = sorg.Id;
        
        
        List<OrderRequestController.StructOrderLineItem> structsolst = new List<OrderRequestController.StructOrderLineItem>(); 
        OrderRequestController.StructOrderLineItem structwrapObj = new OrderRequestController.StructOrderLineItem();
        structwrapObj.skuCategory = '';  
        structwrapObj.isManual = false;    
        structwrapObj.interestRateBRL =1.0;
        structwrapObj.interestRateUSD =2.0;
        structwrapObj.interestDate ='';
        structwrapObj.volDifference ='2545';
        structwrapObj.totalValStr ='231231';    
        structwrapObj.totalValWithInterestStr='232';
        structwrapObj.priceWithInterestStr ='342';
        structwrapObj.discountedInitialPriceStr = '3423';
        structwrapObj.soItemId = '';    
        structwrapObj.combinationkey = pbdetails1.Id;
        structwrapObj.multipleOf = 0;
        structwrapObj.campGrp ='001';
        structwrapObj.camSubgrp='orthene';
        structwrapObj.skuId= skurec.id;
        structwrapObj.skuDesc='';
        structwrapObj.cultureId ='';
        structwrapObj.cultureDesc ='';
        structwrapObj.UOM ='';    
        structwrapObj.volume = 0;
        structwrapObj.prdctVol= 2000;
        structwrapObj.intialPrice= 230;
        structwrapObj.invoiceDate='02/05/2018';
        structwrapObj.grpDiscount=0;
        structwrapObj.fspPrice =0;
        structwrapObj.totalVal= 0; 
        structwrapObj.costBRL= 56;
        structwrapObj.costUSD= 67;
        structwrapObj.intialPriceDisount= 0;
        structwrapObj.priceWithInterest= 0;
        structwrapObj.FinalUnitPrice= 878780;
        structwrapObj.totalValWithInterest= 1000;
        structwrapObj.equivalence = 0;
        structwrapObj.isTrue = true; 
        structwrapObj.interestRate = 2;  
        structwrapObj.days = 5;
        structwrapObj.timeInMonths = 10; 
        structsolst.add(structwrapObj);
        
        List<OrderRequestController.SalesOrderItem> solst = new List<OrderRequestController.SalesOrderItem>(); 
        OrderRequestController.SalesOrderItem wrapObj = new OrderRequestController.SalesOrderItem();
        wrapObj.productId = skurec.id;
        wrapObj.fatDate = '02/05/2018';
        wrapObj.qty = 50;
        wrapObj.listValue = 50;
        wrapObj.unitValue = 32;
        wrapObj.unitValueWithInterest = 32;
        wrapObj.productCode =  skurec.SKU_Code__c;
        wrapObj.totalValue = 12816;
        wrapObj.interestRate = 0;
        wrapObj.days = 0;
        wrapObj.cultureDesc = culture.Id;
        wrapObj.priceBookDetailId = pbdetails1.Id;
        wrapObj.productName = '';
        wrapObj.inventory = 0;
        wrapObj.discount = 16.35;
        wrapObj.replacementMargin = 0;
        wrapObj.ledgerMargin = 63.1;
        wrapObj.totalValueWithInterest = 110;
        wrapObj.timeInMonths = 0;
        wrapObj.multipleOf = 0;
        solst.add(wrapObj);
        
        
        List<OrderRequestController.Inventory> solst1 = new List<OrderRequestController.Inventory>(); 
        OrderRequestController.Inventory wrapObj1 = new OrderRequestController.Inventory();
        wrapObj1.qty =500.00;
        wrapObj1.inventoryactive =false;
        wrapObj1.inventoryblockalert = 'alert';
        wrapObj1.productname = 'SPERTO';
        wrapObj1.year = '02/05/2018';
        wrapObj1.year1 = '02/05/2019';
        wrapObj1.totalqty = 10000.00;
        solst1.add(wrapObj1);
        
        
        String serlizeStr = JSON.serialize(solst);  
        String serlizeStr1 = JSON.serialize(structsolst);  
        Territory_Distributor__c tdObj = [SELECT Id,TerritoryCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR165'];
        
        /*tdObj.TerritoryManager__c = userTerMan1.Id;
update tdObj;*/
        
        
        Business_Rule__c BusinessRule = new Business_Rule__c(
            Name = 'SP',               // Business Rule Name
            Sales_Org__c = sorg.Id,             // Sales Org
            Taxes__c = 30.00,                   // Taxes
            Total_Order_Margin__c = 45.00,      // Total Order Margin > = 
            Freight__c = 6.90,                  // Freight
            List_Price_Discount__c = 5.00
            // Default__c = true                    // List Price Discount < = 
        );
        insert BusinessRule;
        
        Associate_Group__c asGroup = new Associate_Group__c(
            Name = 'Sales Person',                // Name
            Business_Rule__c = BusinessRule.Id  // Business Rule
        );
        insert asGroup;
        
        Employee_Details__c EmpDetail = new Employee_Details__c(
            User__c = userTerMan1.id,           
            Associate_Group__c = asGroup.Id 
        );
        insert EmpDetail;
        
        
        
        System.runAs(userTerMan1) {
            OrderRequestController.getOrderFields(true,userInfo.getUserId(),false, false, acc.Id,'ORDEM FILHA' , false,false);  
            OrderRequestController.signOrder(so2);
            
        }
        test.stopTest(); 
    }
    /* @isTest
static void method11(){
test.startTest(); 
//Profile p = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person' LIMIT 1]; 
User userTerMan1 = [select id from user where Email = 'shama11@skinternational.com' limit 1];  
User userTerMan123 = [select id from user where Email = 'userTerManTerri@skinternational.com' limit 1]; 
//user userTerMan = [select id from user where Email = 'shama@skinternational.com' limit 1];
Region__c reg = [select id,name,RegionCode__c from Region__c limit 1];
Zone__c zo = [select id,name from Zone__c limit 1];
SBU__c sbObj = [select id, name from SBU__c limit 1];
Sales_Org__c saleOrg = [select id,name,Sales_Org_Code__c from Sales_Org__c limit 1];

Territory_Distributor__c territory5 =  new Territory_Distributor__c();
territory5.Name = 'Deccan';
territory5.TerritoryCode__c = 'BR160';
territory5.SBU__c = sbObj.Id;     
territory5.Region__c = reg.id;
territory5.SalesOrg__c = saleOrg.Id;
//territory5.i
territory5.RegionDesciption__c = 'BR1001102 CHPS';                       
territory5.Zone__c = zo.Id;
territory5.TerritoryManager__c = userTerMan123.Id; //userTerMan
//territory5.TerritoryManagerActive__c = false;
insert territory5;

OrderRequestController.typeofOrderBonification(userTerMan123.Id,'BR160');
OrderRequestController.getSOM(userTerMan123.Id,'BR160');

//Territory_Distributor__c tdList = [SELECT ID, Name,TerritoryManager__c, TerritoryCode__c, Region__c,Region__r.RegionCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR160' LIMIT 1];
//system.debug('**User ->' +userTerMan1);
//system.debug('**Territory Distributor ->' +tdList);

Sales_org__c sorg = [SELECT Id FROM Sales_org__c WHERE Sales_Org_Code__c = '5191' LIMIT 1];

//Depot__c oDep = new Depot__c(Name = 'Test');
Id depotRecordTypeId = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();
Depot__c dep = new Depot__c(Name = 'test', Depot_Code__c = 'Test123', SalesOrg__c = sorg.Id, RecordTypeId = depotRecordTypeId, Active__c = true);
insert dep;

//Depot__c dep = [SELECT Id, Depot_Code__c FROM Depot__c WHERE SalesOrg__c = :sorg.Id AND Id = :acc.Depot_Code__c LIMIT 1]; 
Account acc = new Account(Name = 'Test', SAP_Code__c = '12345', Depot_Code__c = dep.Id);
insert acc;

//Account acc = [SELECT id, Customer_Group__c, Customer_Region__c, Depot_Code__c FROM Account WHERE Name = 'AGROPOLLO COMERCIAL AGRICOLA LTDA' LIMIT 1]; 

string sDepotCode = dep.Depot_Code__c;

list<string> lisi = OrderRequestController.getSeller();
Division__c div = [select id from Division__c limit 1];
SKU__c skuRecord = new SKU__c(
Name = 'a1C0k000000A1ug',                                 // SKU Name
SKU_Code__c = '000000000006302803',                       // SKU Code
SKU_Description__c = 'Kit ',   // SKU Description
UOM__c = 'KG', 
Division__c = div.Id,                                     // Division
Sales_Org__c = sorg.Id,                                  // Sales Org
Multiple_of__c = 25.00,                                   // Multiple Of
Combination_Key__c = '519110000000000006302803',          // Combination Key
Active__c = true,
Kit_Product__c = true,
brand_name__c = 'MANZATE Kit',// Active
Unit_Cost__c = 10.00
);
insert skuRecord;
SKU__c skuRecord1 = new SKU__c(
Name = 'a1C0k000000A1ue',                                 // SKU Name
SKU_Code__c = '000000000006302804',                       // SKU Code
SKU_Description__c = 'MANZATE 800WP 25KG PAPER BAG_BR 1',   // SKU Description
UOM__c = 'KG', 
Division__c = div.Id,                                     // Division
Sales_Org__c = sorg.Id,                                  // Sales Org
Multiple_of__c = 25.00,                                   // Multiple Of
Combination_Key__c = '519110000000000006302804',          // Combination Key
Active__c = true,
brand_name__c = 'MANZATE1',// Active
Unit_Cost__c = 10.00
);
insert skuRecord1;

Brazil_Region_SKU_Combination__c newRec = new Brazil_Region_SKU_Combination__c(
Sales_District__c = reg.Id,
SKU__c = skuRecord.Id,
Date__c = System.today(),
Availability__c = 'No'
);

insert newRec;


Price_Book_Details__c pbdetails1 =  [SELECT Id,SKU__r.id, Unit_Price__c, Monthly_Interest_Rate__c, SKU__c FROM Price_Book_Details__c LIMIT 1];
pbdetails1.Kit_SKU__c = skuRecord.id;
pbdetails1.Minimum_Price_U__c = 1;
update pbdetails1;
Price_Book_Details__c pbdetails2 = pbdetails1.clone(false, false, false, false);
pbdetails2.SKU__c = skuRecord1.id;
pbdetails2.Kit_SKU__c = skuRecord.id;
insert pbdetails2;
Price_Book__c pricebook = [SELECT Id FROM Price_Book__c LIMIT 1];
pricebook.Kit_Price_Book__c = true;
update pricebook;

Component__c compRecord = new Component__c(
Component_Item_Category__c = 'CTCV',                       
Component_Quantity__c = 10,   
Component_SKU__c = pbdetails1.SKU__r.id, 
Division__c = div.Id,                                     // Division
Sales_Org__c = sorg.Id,                                  // Sales Org
Kit_SKU__c = skuRecord.id,                                   
Combination_Key__c = '519110000000000006302803'        
);
insert compRecord;
Component__c compRecord1 = new Component__c(
Component_Item_Category__c = 'CTCV',                       
Component_Quantity__c = 10,   
Component_SKU__c = pbdetails2.SKU__r.id, 
Division__c = div.Id,                                     // Division
Sales_Org__c = sorg.Id,                                  // Sales Org
Kit_SKU__c = skuRecord.id,                                   
Combination_Key__c = '519110000000000006302804'        
);
insert compRecord1;
Payment_Term__c payTerm = new Payment_Term__c(
Payment_Term_Code__c = 'BR71',                        
Payterms_Desc__c = 'INFORMAR VENCIMENTO',  
Sales_Org__c = sorg.Id,                             
Days_to_calc_interest__c = 0,                      
Maturity_Date_Mandatory__c = 'Yes',                  
Active__c = true                                   
);
insert payTerm;
Inco_Term__c incoTm = [SELECT Id,  Name FROM Inco_Term__c WHERE IncoTerm_Code__c = 'CIF' LIMIT 1];
Territory_Distributor__c territory = [SELECT Id,TerritoryCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR165'];
Sales_Order__c sobj = new Sales_Order__c(
OwnerId = userTerMan1.Id, 
SFDC_Order_Number__c = '83601',                     // SFDC Order Number
SAP_Order_Number__c = '7009090605',                 // SAP Order Number
Order_Cancel__c = false,     
Sales_Org_lk__c = sorg.Id,                             // Order Cancel
Order_Status__c = 'Not yet processed',              // Order Status
OrderSubStatus__c = 'Approved',                     // Order Sub-Status
Region_Territory__c = territory.Id,                  // Region / Territory
RequestforCancellationCheck__c = false,  
BudgetApprovalCheck__c = false,// Request for Cancellation
//  BarterManager__c = BarterUser.Id, 
Flag_Status__c = 'dislike\n',                       // Flag Status
BrazilOrderSubmittedforApproval__c = true,          // Brazil Order Submitted for Approval
//SalesOfficeManager__c = ZonalHeadUser.Id,          // Sales Office Manager
Price_Book__c = pricebook.Id,                          // Price Book
//SalesDistrictManager__c =  regioHeadUser.Id,    
Inco_Term__c = incoTm.Id, 
Currency_Brazil__c = 'Billing USD / Payment USD',   // Currency (Brazil)
Key_Account__c = false,                             // Key Account
Sold_to_Party__c = acc.Id,                         // Sold to Party
Valid_FROM__c = system.today(), 
Kit_Order__C = true,
//  PaymentMethod__c = pMethod.Id, // Valid FROM
Valid_To__c = system.today()+350,                   // Valid To
Payment_Term__c = payTerm.Id,                     // Payment Term
Type_of_Order__c = 'CONTRATO MÃE'                 // Type of Order
);
insert sobj;


Sales_Order__c sobj1 = new Sales_Order__c(
OwnerId = userTerMan1.Id, 

Order_Cancel__c = false,     
Sales_Org_lk__c = sorg.Id,                             // Order Cancel
Order_Status__c = 'Not yet processed',              // Order Status
OrderSubStatus__c = 'Pending',                     // Order Sub-Status
Region_Territory__c = territory.Id,                  // Region / Territory
RequestforCancellationCheck__c = false,  
BudgetApprovalCheck__c = false,// Request for Cancellation
//  BarterManager__c = BarterUser.Id, 
Flag_Status__c = 'dislike\n',                       // Flag Status
BrazilOrderSubmittedforApproval__c = true,          // Brazil Order Submitted for Approval
//SalesOfficeManager__c = ZonalHeadUser.Id,          // Sales Office Manager
Price_Book__c = pricebook.Id,                          // Price Book
//SalesDistrictManager__c =  regioHeadUser.Id,    
Inco_Term__c = incoTm.Id, 
Currency_Brazil__c = 'Billing USD / Payment USD',   // Currency (Brazil)
Key_Account__c = false,                             // Key Account
Sold_to_Party__c = acc.Id,                         // Sold to Party
Valid_FROM__c = system.today(), 
Sales_Order__c =  sobj.Id,                  
Payment_Term__c = payTerm.Id,                     // Payment Term
Type_of_Order__c = 'BONIFICAÇÃO'                 // Type of Order
);
insert sobj1;


SO_id=sobj.Id;
ExchangeRate__c ExchngRte = new ExchangeRate__c(
FROMCurrency__c = 'USD',                                  // FROM Currency
ToCurrency__c = 'BRL',                                    // To Currency
ExchangeRate__c = 3.45 ,                                  // Exchange Rate
UpdatedDate__c = system.today()+45                       // Updated Date
);
insert ExchngRte;
Sales_Order_Line_Item__c soLineItm = new Sales_Order_Line_Item__c(
Sale_Order__c = sobj.Id,          // Sale Order
SKU_Name__c = skuRecord.Id,            // SKU Name
Kit_Product__C = true,
Item_Number__c = 10,                        // Item Number
Item_Status__c = 'Not yet processed',       // Item Status
Item_Cancel__c = false,                     // Item Cancel
Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
Sales_Org__c = sorg.Id,           // Sales Org
PriceBookDetail__c = pbdetails1.Id,  // Price Book Detail
Approval_Flag__c = 0,                       // Approval Flag
ExchangeRate__c = ExchngRte.id,        // Exchange Rate
OrderQuantityEdited__c = false,             // Order Quantity Edited
Time_in_months__c = 0,                      // Time in months
Days__c = 0,                                // Days
DateofFAT__c =  system.today()+1, 
Quantity__c = 450.00,                       // Quantity
UnitValue__c = 100.00,                      // Unit Value
UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
InterestRate__c = 0.00,                     // Interest Rate
TotalTax__c = 0.00,                         // Total Tax
Tax__c = 1.00,
Freight__c = 1.00,
TotalFreight__c = 0.00,                     // Total Freight
TotalPunctuality__c = 0.00,                 // Total Punctuality
TotalLedgerCost__c = 0.00,                  // Total Ledger Cost
TotalReplacementCost__c = 0.00 ,
Customer_Conversion_Factor__c = 1// Total Replacement Cost
);
insert soLineItm;

Sales_Order_Line_Item__c soLineItm1 = new Sales_Order_Line_Item__c(
Sale_Order__c = sobj.Id,          // Sale Order
SKU_Name__c = skuRecord.Id,            // SKU Name
Item_Number__c = 20,                        // Item Number
Kit_Product__C = false,
Item_Status__c = 'Not yet processed',       // Item Status
Item_Cancel__c = false,                     // Item Cancel
Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
Sales_Org__c = sorg.Id,           // Sales Org
PriceBookDetail__c = pbdetails1.Id,  // Price Book Detail
Approval_Flag__c = 0,                       // Approval Flag
ExchangeRate__c = ExchngRte.id,        // Exchange Rate
OrderQuantityEdited__c = false,             // Order Quantity Edited
Time_in_months__c = 0,                      // Time in months
Days__c = 0,                                // Days
DateofFAT__c =  system.today()+1, 
Quantity__c = 450.00,                       // Quantity
UnitValue__c = 100.00,                      // Unit Value
UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
InterestRate__c = 0.00,                     // Interest Rate
TotalTax__c = 0.00,                         // Total Tax
Tax__c = 1.00,
Freight__c = 1.00,
TotalFreight__c = 0.00,                     // Total Freight
TotalPunctuality__c = 0.00,                 // Total Punctuality
TotalLedgerCost__c = 0.00,                  // Total Ledger Cost
TotalReplacementCost__c = 0.00 ,
Customer_Conversion_Factor__c = 1,// Total Replacement Cost
Kit_Item_Number__C = 10
);

insert soLineItm1;

Sales_Order_Line_Item__c soLineItm3 = new Sales_Order_Line_Item__c(
Sale_Order__c = sobj1.Id,          // Sale Order
SKU_Name__c = skuRecord.Id,            // SKU Name
Kit_Product__C = true,
Item_Number__c = 10,                        // Item Number
Item_Status__c = 'Not yet processed',       // Item Status
Item_Cancel__c = false,                     // Item Cancel
Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
Sales_Org__c = sorg.Id,           // Sales Org
PriceBookDetail__c = pbdetails1.Id,  // Price Book Detail
Approval_Flag__c = 0,                       // Approval Flag
ExchangeRate__c = ExchngRte.id,        // Exchange Rate
OrderQuantityEdited__c = false,             // Order Quantity Edited
Time_in_months__c = 2,                      // Time in months
Days__c =1,                                // Days
DateofFAT__c =  system.today()+1, 
Quantity__c = 450.00,                       // Quantity
UnitValue__c = 100.00,                      // Unit Value
UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
InterestRate__c = 1.00,                     // Interest Rate
TotalTax__c = 1.00,                         // Total Tax
Tax__c = 1.00,
Freight__c = 1.00,
TotalFreight__c = 1.00,                     // Total Freight
TotalPunctuality__c = 1.00,                 // Total Punctuality
TotalLedgerCost__c = 1.00,                  // Total Ledger Cost
TotalReplacementCost__c = 1.00 ,
Customer_Conversion_Factor__c = 1// Total Replacement Cost
);
insert soLineItm3;

Material_Plant_Relation__c mpr = new Material_Plant_Relation__c();
mpr.COGSinfo__c=123;
mpr.Active__c=true;
mpr.Depot__c=acc.Depot_Code__c;
mpr.Material_Code__c='000000000006302803'; 
mpr.Replacement_Cost__c=12;
mpr.SKU__c=skuRecord.id;
insert mpr;




// OrderRequestController.getReplacementCost(skuRecord.id);
OrderRequestController.relatedOrder(sobj1.id);
OrderRequestController.relatedOrder1(sobj1.id);
OrderRequestController.getOrderSubStatus(sobj1.id);
// OrderRequestController.getCreatedDate(sobj1.id);
OrderRequestController.getSalesOrder(sobj1.id);
OrderRequestController.getStructSalesOrderItems(sobj1.id);
OrderRequestController.relatedOrder(sobj1.id);
OrderRequestController.processApproval(true, sobj1.id, 'Test');
OrderRequestController.getrelatedSalesOrder(sobj.id);
OrderRequestController.deleteSalesOrder(sobj.id);
OrderRequestController.cogsValueUpdate(skuRecord.id,acc.id);
// OrderRequestController.getReplacementCost(skuRecord.Id);

Culture__c culture = [SELECT Id FROM Culture__c LIMIT 1];
List<OrderRequestController.SalesOrderItem> solst = new List<OrderRequestController.SalesOrderItem>(); 
OrderRequestController.SalesOrderItem wrapObj = new OrderRequestController.SalesOrderItem();
wrapObj.productId = skuRecord.id;
wrapObj.fatDate = '02/05/2018';
wrapObj.qty = 100;
wrapObj.listValue = 50;
wrapObj.unitValue = 32;
wrapObj.unitValueWithInterest = 32;
wrapObj.productCode =  skuRecord.SKU_Code__c;
wrapObj.totalValue = 12816;
wrapObj.interestRate = 0;
wrapObj.days = 0;
wrapObj.cultureDesc = culture.Id;
wrapObj.priceBookDetailId = pbdetails1.Id;
wrapObj.productName = '';
wrapObj.inventory = 0;
wrapObj.discount = 16.35;
wrapObj.replacementMargin = 0;
wrapObj.ledgerMargin = 63.1;
wrapObj.totalValueWithInterest = 0;
wrapObj.timeInMonths = 0;
wrapObj.multipleOf = 0;
wrapObj.kitProduct = true;
wrapObj.kitNo = 10;
//refKitNo = 
solst.add(wrapObj);
String serlizeStr = JSON.serialize(solst); 

List<OrderRequestController.PriceDetail> lstPriceDetail = new List<OrderRequestController.PriceDetail>();
OrderRequestController.PriceDetail oPD = new OrderRequestController.PriceDetail();
oPD.pricebookId = pricebook.Id;
oPD.skuId = skuRecord.Id;
oPD.kitSKU = skuRecord.Id;
lstPriceDetail.add(oPD);

List<Id> kitSKUs = new List<Id>();
// kitSKUs.add(dep.id);
kitSKUs.add(skuRecord.id);


System.runAs(userTerMan1) {
// OrderRequestController.getPriceBookDetails(pricebook.Id,  dep.id,  acc.Customer_Region__c, acc.Id);
// OrderRequestController.getMOPriceBookDetails(pricebook.Id, sobj.id, dep.id, acc.Customer_Region__c, sobj.id, false);
OrderRequestController.fetchKitComponentProduct(lstPriceDetail,  kitSKUs,  pricebook.Id);
OrderRequestController.getSalesOrderItems(sobj.id);
//OrderRequestController.getCreatedDate(sobj.id);
OrderRequestController.getInventory(sobj.id);
OrderRequestController.getSelloutMinpriceFactor();

// OrderRequestController.saveSalesOrder(sobj,  serlizeStr,  false,  false);

}



test.stopTest(); 
}  */
    @isTest
    static  void method61(){
        
        //Profile p = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person' LIMIT 1]; 
        User userTerMan1 = [select id from user where Email = 'shama11@skinternational.com' limit 1];  
        User userTerMan123 = [select id from user where Email = 'userTerManTerri@skinternational.com' limit 1]; 
        //user userTerMan = [select id from user where Email = 'shama@skinternational.com' limit 1];
        
        
        Region__c reg = [select id,name,RegionCode__c from Region__c limit 1];
        Zone__c zo = [select id,name from Zone__c limit 1];
        SBU__c sbObj = [select id, name from SBU__c limit 1];
        Sales_Org__c sorg = new Sales_Org__c();
        sorg.Name = 'Brazil';
        sorg.Sales_Org_Code__c = '5191';
        insert sorg;
        
        Territory_Distributor__c territory5 =  new Territory_Distributor__c();
        territory5.Name = 'Deccan';
        territory5.TerritoryCode__c = 'BR160';
        territory5.SBU__c = sbObj.Id;     
        territory5.Region__c = reg.id;
        territory5.SalesOrg__c = sorg.Id;
        //territory5.i
        territory5.RegionDesciption__c = 'BR1001102 CHPS';                       
        territory5.Zone__c = zo.Id;
        territory5.TerritoryManager__c = userTerMan123.Id; //userTerMan
        //territory5.TerritoryManagerActive__c = false;
        insert territory5;
        
        // OrderRequestController.typeofOrderBonification(userTerMan123.Id,'BR160');
        // OrderRequestController.getSOM(userTerMan123.Id,'BR160');
        
        //Territory_Distributor__c tdList = [SELECT ID, Name,TerritoryManager__c, TerritoryCode__c, Region__c,Region__r.RegionCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR160' LIMIT 1];
        //system.debug('**User ->' +userTerMan1);
        //system.debug('**Territory Distributor ->' +tdList);
        
        
        
        //Depot__c oDep = new Depot__c(Name = 'Test');
        Id depotRecordTypeId = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();
        Depot__c dep = new Depot__c(Name = 'test', Depot_Code__c = 'Test123', SalesOrg__c = sorg.Id, RecordTypeId = depotRecordTypeId, Active__c = true);
        insert dep;
        
        //Depot__c dep = [SELECT Id, Depot_Code__c FROM Depot__c WHERE SalesOrg__c = :sorg.Id AND Id = :acc.Depot_Code__c LIMIT 1]; 
        Account acc = new Account(Name = 'Test', SAP_Code__c = '12345', Depot_Code__c = dep.Id);
        insert acc;
        
        //Account acc = [SELECT id, Customer_Group__c, Customer_Region__c, Depot_Code__c FROM Account WHERE Name = 'AGROPOLLO COMERCIAL AGRICOLA LTDA' LIMIT 1]; 
        
        string sDepotCode = dep.Depot_Code__c;
        
        list<string> lisi = OrderRequestController.getSeller();
        Division__c div = [select id from Division__c limit 1];
        SKU__c skuRecord = new SKU__c(
            Name = 'a1C0k000000A1ug',                                 // SKU Name
            SKU_Code__c = '000000000006302803',                       // SKU Code
            SKU_Description__c = 'Kit ',   // SKU Description
            UOM__c = 'KG', 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Multiple_of__c = 25.00,                                   // Multiple Of
            Combination_Key__c = '519110000000000006302803',          // Combination Key
            Active__c = true,
            Kit_Product__c = true,
            brand_name__c = 'MANZATE Kit',// Active
            Unit_Cost__c = 10.00
        );
        insert skuRecord;
        SKU__c skuRecord1 = new SKU__c(
            Name = 'a1C0k000000A1ue',                                 // SKU Name
            SKU_Code__c = '000000000006302804',                       // SKU Code
            SKU_Description__c = 'MANZATE 800WP 25KG PAPER BAG_BR 1',   // SKU Description
            UOM__c = 'KG', 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Multiple_of__c = 25.00,                                   // Multiple Of
            Combination_Key__c = '519110000000000006302804',          // Combination Key
            Active__c = true,
            brand_name__c = 'MANZATE1',// Active
            Unit_Cost__c = 10.00
        );
        insert skuRecord1;
        
        Brazil_Region_SKU_Combination__c newRec = new Brazil_Region_SKU_Combination__c(
            Sales_District__c = reg.Id,
            SKU__c = skuRecord.Id,
            Date__c = System.today(),
            Availability__c = 'No'
        );
        
        insert newRec;
        
        
        Price_Book_Details__c pbdetails1 =  [SELECT Id,SKU__r.id, Unit_Price__c, Monthly_Interest_Rate__c, SKU__c FROM Price_Book_Details__c LIMIT 1];
        pbdetails1.Kit_SKU__c = skuRecord.id;
        pbdetails1.Minimum_Price_U__c = 1;
        update pbdetails1;
        Price_Book_Details__c pbdetails2 = pbdetails1.clone(false, false, false, false);
        pbdetails2.SKU__c = skuRecord1.id;
        pbdetails2.Kit_SKU__c = skuRecord.id;
        insert pbdetails2;
        Price_Book__c pricebook = [SELECT Id FROM Price_Book__c LIMIT 1];
        pricebook.Kit_Price_Book__c = true;
        update pricebook;
        
        Component__c compRecord = new Component__c(
            Component_Item_Category__c = 'CTCV',                       
            Component_Quantity__c = 10,   
            Component_SKU__c = pbdetails1.SKU__r.id, 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Kit_SKU__c = skuRecord.id,                                   
            Combination_Key__c = '519110000000000006302803'        
        );
        insert compRecord;
        Component__c compRecord1 = new Component__c(
            Component_Item_Category__c = 'CTCV',                       
            Component_Quantity__c = 10,   
            Component_SKU__c = pbdetails2.SKU__r.id, 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Kit_SKU__c = skuRecord.id,                                   
            Combination_Key__c = '519110000000000006302804'        
        );
        insert compRecord1;
        Payment_Term__c payTerm = new Payment_Term__c(
            Payment_Term_Code__c = 'BR71',                        
            Payterms_Desc__c = 'INFORMAR VENCIMENTO',  
            Sales_Org__c = sorg.Id,                             
            Days_to_calc_interest__c = 0,                      
            Maturity_Date_Mandatory__c = 'Yes',                  
            Active__c = true                                   
        );
        insert payTerm;
        Inco_Term__c incoTm = [SELECT Id,  Name FROM Inco_Term__c WHERE IncoTerm_Code__c = 'CIF' LIMIT 1];
        Territory_Distributor__c territory = [SELECT Id,TerritoryCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR165'];
        Sales_Order__c sobj = new Sales_Order__c(
            OwnerId = userTerMan1.Id, 
            SFDC_Order_Number__c = '83601',                     // SFDC Order Number
            SAP_Order_Number__c = '7009090605',                 // SAP Order Number
            Order_Cancel__c = false,     
            Sales_Org_lk__c = sorg.Id,                             // Order Cancel
            Order_Status__c = 'Not yet processed',              // Order Status
            OrderSubStatus__c = 'Approved',                     // Order Sub-Status
            Region_Territory__c = territory.Id,                  // Region / Territory
            RequestforCancellationCheck__c = false,  
            BudgetApprovalCheck__c = false,// Request for Cancellation
            //  BarterManager__c = BarterUser.Id, 
            Flag_Status__c = 'dislike\n',                       // Flag Status
            BrazilOrderSubmittedforApproval__c = true,          // Brazil Order Submitted for Approval
            //SalesOfficeManager__c = ZonalHeadUser.Id,          // Sales Office Manager
            Price_Book__c = pricebook.Id,                          // Price Book
            //SalesDistrictManager__c =  regioHeadUser.Id,    
            Inco_Term__c = incoTm.Id, 
            Currency_Brazil__c = 'Billing USD / Payment USD',   // Currency (Brazil)
            Key_Account__c = false,                             // Key Account
            Sold_to_Party__c = acc.Id,                         // Sold to Party
            Valid_FROM__c = system.today(), 
            Kit_Order__C = true,
            //  PaymentMethod__c = pMethod.Id, // Valid FROM
            Valid_To__c = system.today()+350,                   // Valid To
            Payment_Term__c = payTerm.Id,                     // Payment Term
            Type_of_Order__c = 'CONTRATO MÃE'                 // Type of Order
        );
        insert sobj;
        
        
        Sales_Order__c sobj1 = new Sales_Order__c(
            OwnerId = userTerMan1.Id, 
            
            Order_Cancel__c = false,     
            Sales_Org_lk__c = sorg.Id,                             // Order Cancel
            Order_Status__c = 'Not yet processed',              // Order Status
            OrderSubStatus__c = 'Pending',                     // Order Sub-Status
            Region_Territory__c = territory.Id,                  // Region / Territory
            RequestforCancellationCheck__c = false,  
            BudgetApprovalCheck__c = false,// Request for Cancellation
            //  BarterManager__c = BarterUser.Id, 
            Flag_Status__c = 'dislike\n',                       // Flag Status
            BrazilOrderSubmittedforApproval__c = true,          // Brazil Order Submitted for Approval
            //SalesOfficeManager__c = ZonalHeadUser.Id,          // Sales Office Manager
            Price_Book__c = pricebook.Id,                          // Price Book
            //SalesDistrictManager__c =  regioHeadUser.Id,    
            Inco_Term__c = incoTm.Id, 
            Currency_Brazil__c = 'Billing USD / Payment USD',   // Currency (Brazil)
            Key_Account__c = false,                             // Key Account
            Sold_to_Party__c = acc.Id,                         // Sold to Party
            Valid_FROM__c = system.today(), 
            Sales_Order__c =  sobj.Id,                  
            Payment_Term__c = payTerm.Id,                     // Payment Term
            Type_of_Order__c = 'BONIFICAÇÃO'                 // Type of Order
        );
        insert sobj1;
        
        
        SO_id=sobj.Id;
        ExchangeRate__c ExchngRte = new ExchangeRate__c(
            FROMCurrency__c = 'USD',                                  // FROM Currency
            ToCurrency__c = 'BRL',                                    // To Currency
            ExchangeRate__c = 3.45 ,                                  // Exchange Rate
            UpdatedDate__c = system.today()+45                       // Updated Date
        );
        insert ExchngRte;
        Test.startTest();
        Sales_Order_Line_Item__c soLineItm = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj.Id,          // Sale Order
            SKU_Name__c = skuRecord.Id,            // SKU Name
            Kit_Product__C = true,
            Item_Number__c = 10,                        // Item Number
            Item_Status__c = 'Not yet processed',       // Item Status
            Item_Cancel__c = false,                     // Item Cancel
            Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
            Sales_Org__c = sorg.Id,           // Sales Org
            PriceBookDetail__c = pbdetails1.Id,  // Price Book Detail
            Approval_Flag__c = 0,                       // Approval Flag
            ExchangeRate__c = ExchngRte.id,        // Exchange Rate
            OrderQuantityEdited__c = false,             // Order Quantity Edited
            Time_in_months__c = 0,                      // Time in months
            Days__c = 0,                                // Days
            DateofFAT__c =  system.today()+1, 
            Quantity__c = 450.00,                       // Quantity
            UnitValue__c = 100.00,                      // Unit Value
            UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
            InterestRate__c = 0.00,                     // Interest Rate
            TotalTax__c = 0.00,                         // Total Tax
            Tax__c = 1.00,
            Freight__c = 1.00,
            TotalFreight__c = 0.00,                     // Total Freight
            TotalPunctuality__c = 0.00,                 // Total Punctuality
            TotalLedgerCost__c = 0.00,                  // Total Ledger Cost
            TotalReplacementCost__c = 0.00 ,
            Customer_Conversion_Factor__c = 1// Total Replacement Cost
        );
        insert soLineItm;
        
        Sales_Order_Line_Item__c soLineItm1 = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj.Id,          // Sale Order
            SKU_Name__c = skuRecord.Id,            // SKU Name
            Item_Number__c = 20,                        // Item Number
            Kit_Product__C = false,
            Item_Status__c = 'Not yet processed',       // Item Status
            Item_Cancel__c = false,                     // Item Cancel
            Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
            Sales_Org__c = sorg.Id,           // Sales Org
            PriceBookDetail__c = pbdetails1.Id,  // Price Book Detail
            Approval_Flag__c = 0,                       // Approval Flag
            ExchangeRate__c = ExchngRte.id,        // Exchange Rate
            OrderQuantityEdited__c = false,             // Order Quantity Edited
            Time_in_months__c = 0,                      // Time in months
            Days__c = 0,                                // Days
            DateofFAT__c =  system.today()+1, 
            Quantity__c = 450.00,                       // Quantity
            UnitValue__c = 100.00,                      // Unit Value
            UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
            InterestRate__c = 0.00,                     // Interest Rate
            TotalTax__c = 0.00,                         // Total Tax
            Tax__c = 1.00,
            Freight__c = 1.00,
            TotalFreight__c = 0.00,                     // Total Freight
            TotalPunctuality__c = 0.00,                 // Total Punctuality
            TotalLedgerCost__c = 0.00,                  // Total Ledger Cost
            TotalReplacementCost__c = 0.00 ,
            Customer_Conversion_Factor__c = 1,// Total Replacement Cost
            Kit_Item_Number__C = 10
        );
        
        insert soLineItm1;
        
        Sales_Order_Line_Item__c soLineItm3 = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj1.Id,          // Sale Order
            SKU_Name__c = skuRecord.Id,            // SKU Name
            Kit_Product__C = true,
            Item_Number__c = 10,                        // Item Number
            Item_Status__c = 'Not yet processed',       // Item Status
            Item_Cancel__c = false,                     // Item Cancel
            Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
            Sales_Org__c = sorg.Id,           // Sales Org
            PriceBookDetail__c = pbdetails1.Id,  // Price Book Detail
            Approval_Flag__c = 0,                       // Approval Flag
            ExchangeRate__c = ExchngRte.id,        // Exchange Rate
            OrderQuantityEdited__c = false,             // Order Quantity Edited
            Time_in_months__c = 2,                      // Time in months
            Days__c =1,                                // Days
            DateofFAT__c =  system.today()+1, 
            Quantity__c = 450.00,                       // Quantity
            UnitValue__c = 100.00,                      // Unit Value
            UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
            InterestRate__c = 1.00,                     // Interest Rate
            TotalTax__c = 1.00,                         // Total Tax
            Tax__c = 1.00,
            Freight__c = 1.00,
            TotalFreight__c = 1.00,                     // Total Freight
            TotalPunctuality__c = 1.00,                 // Total Punctuality
            TotalLedgerCost__c = 1.00,                  // Total Ledger Cost
            TotalReplacementCost__c = 1.00 ,
            Customer_Conversion_Factor__c = 1// Total Replacement Cost
        );
        insert soLineItm3;
        
        Material_Plant_Relation__c mpr = new Material_Plant_Relation__c();
        mpr.COGSinfo__c=123;
        mpr.Active__c=true;
        mpr.Depot__c=acc.Depot_Code__c;
        mpr.Material_Code__c='000000000006302803'; 
        mpr.Replacement_Cost__c=12;
        mpr.SKU__c=skuRecord.id;
        insert mpr;
        
        
        
        // OrderRequestController.getReplacementCost(skuRecord.id);
        // OrderRequestController.relatedOrder(sobj1.id);
        //  OrderRequestController.relatedOrder1(sobj1.id);
        //  OrderRequestController.getOrderSubStatus(sobj1.id);
        //  OrderRequestController.getCreatedDate(sobj1.id);
        OrderRequestController.getSalesOrder(sobj1.id);
        OrderRequestController.getStructSalesOrderItems(sobj1.id);
        // OrderRequestController.relatedOrder(sobj1.id);
        OrderRequestController.processApproval(true, sobj1.id, 'Test');
        OrderRequestController.getrelatedSalesOrder(sobj.id);
        
        
        
        
        Test.stopTest(); 
    } 
    
    
    
    
    @isTest
    static  void method61Javed(){
       
        //Profile p = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person' LIMIT 1]; 
        User userTerMan1 = [select id from user where Email = 'shama11@skinternational.com' limit 1];  
        User userTerMan123 = [select id from user where Email = 'userTerManTerri@skinternational.com' limit 1]; 
        //user userTerMan = [select id from user where Email = 'shama@skinternational.com' limit 1];
        
        
        Region__c reg = [select id,name,RegionCode__c from Region__c limit 1];
        Zone__c zo = [select id,name from Zone__c limit 1];
        SBU__c sbObj = [select id, name from SBU__c limit 1];
        Sales_Org__c sorg = new Sales_Org__c();
        sorg.Name = 'Brazil';
        sorg.Sales_Org_Code__c = '5191';
        insert sorg;
        
        Territory_Distributor__c territory5 =  new Territory_Distributor__c();
        territory5.Name = 'Deccan';
        territory5.TerritoryCode__c = 'BR160';
        territory5.SBU__c = sbObj.Id;     
        territory5.Region__c = reg.id;
        territory5.SalesOrg__c = sorg.Id;
        //territory5.i
        territory5.RegionDesciption__c = 'BR1001102 CHPS';                       
        territory5.Zone__c = zo.Id;
        territory5.TerritoryManager__c = userTerMan123.Id; //userTerMan
        //territory5.TerritoryManagerActive__c = false;
        insert territory5;
        
        // OrderRequestController.typeofOrderBonification(userTerMan123.Id,'BR160');
        // OrderRequestController.getSOM(userTerMan123.Id,'BR160');
        
        //Territory_Distributor__c tdList = [SELECT ID, Name,TerritoryManager__c, TerritoryCode__c, Region__c,Region__r.RegionCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR160' LIMIT 1];
        //system.debug('**User ->' +userTerMan1);
        //system.debug('**Territory Distributor ->' +tdList);
        
        
        
        //Depot__c oDep = new Depot__c(Name = 'Test');
        Id depotRecordTypeId = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();
        Depot__c dep = new Depot__c(Name = 'test', Depot_Code__c = 'Test123', SalesOrg__c = sorg.Id, RecordTypeId = depotRecordTypeId, Active__c = true);
        insert dep;
        
        //Depot__c dep = [SELECT Id, Depot_Code__c FROM Depot__c WHERE SalesOrg__c = :sorg.Id AND Id = :acc.Depot_Code__c LIMIT 1]; 
        Account acc = new Account(Name = 'Test', SAP_Code__c = '12345', Depot_Code__c = dep.Id);
        insert acc;
        
        //Account acc = [SELECT id, Customer_Group__c, Customer_Region__c, Depot_Code__c FROM Account WHERE Name = 'AGROPOLLO COMERCIAL AGRICOLA LTDA' LIMIT 1]; 
        
        string sDepotCode = dep.Depot_Code__c;
        
        list<string> lisi = OrderRequestController.getSeller();
        Division__c div = [select id from Division__c limit 1];
        SKU__c skuRecord = new SKU__c(
            Name = 'a1C0k000000A1ug',                                 // SKU Name
            SKU_Code__c = '000000000006302803',                       // SKU Code
            SKU_Description__c = 'Kit ',   // SKU Description
            UOM__c = 'KG', 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Multiple_of__c = 25.00,                                   // Multiple Of
            Combination_Key__c = '519110000000000006302803',          // Combination Key
            Active__c = true,
            Kit_Product__c = true,
            brand_name__c = 'MANZATE Kit',// Active
            Unit_Cost__c = 10.00
        );
        insert skuRecord;
        SKU__c skuRecord1 = new SKU__c(
            Name = 'a1C0k000000A1ue',                                 // SKU Name
            SKU_Code__c = '000000000006302804',                       // SKU Code
            SKU_Description__c = 'MANZATE 800WP 25KG PAPER BAG_BR 1',   // SKU Description
            UOM__c = 'KG', 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Multiple_of__c = 25.00,                                   // Multiple Of
            Combination_Key__c = '519110000000000006302804',          // Combination Key
            Active__c = true,
            brand_name__c = 'MANZATE1',// Active
            Unit_Cost__c = 10.00
        );
        insert skuRecord1;
        
        Brazil_Region_SKU_Combination__c newRec = new Brazil_Region_SKU_Combination__c(
            Sales_District__c = reg.Id,
            SKU__c = skuRecord.Id,
            Date__c = System.today(),
            Availability__c = 'No'
        );
        
        insert newRec;
        
        
        Price_Book_Details__c pbdetails1 =  [SELECT Id,SKU__r.id, Unit_Price__c, Monthly_Interest_Rate__c, SKU__c FROM Price_Book_Details__c LIMIT 1];
        pbdetails1.Kit_SKU__c = skuRecord.id;
        pbdetails1.Minimum_Price_U__c = 1;
        update pbdetails1;
        Price_Book_Details__c pbdetails2 = pbdetails1.clone(false, false, false, false);
        pbdetails2.SKU__c = skuRecord1.id;
        pbdetails2.Kit_SKU__c = skuRecord.id;
        insert pbdetails2;
        Price_Book__c pricebook = [SELECT Id FROM Price_Book__c LIMIT 1];
        pricebook.Kit_Price_Book__c = true;
        update pricebook;
        
        Component__c compRecord = new Component__c(
            Component_Item_Category__c = 'CTCV',                       
            Component_Quantity__c = 10,   
            Component_SKU__c = pbdetails1.SKU__r.id, 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Kit_SKU__c = skuRecord.id,                                   
            Combination_Key__c = '519110000000000006302803'        
        );
        insert compRecord;
        Component__c compRecord1 = new Component__c(
            Component_Item_Category__c = 'CTCV',                       
            Component_Quantity__c = 10,   
            Component_SKU__c = pbdetails2.SKU__r.id, 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Kit_SKU__c = skuRecord.id,                                   
            Combination_Key__c = '519110000000000006302804'        
        );
        insert compRecord1;
        Payment_Term__c payTerm = new Payment_Term__c(
            Payment_Term_Code__c = 'BR71',                        
            Payterms_Desc__c = 'INFORMAR VENCIMENTO',  
            Sales_Org__c = sorg.Id,                             
            Days_to_calc_interest__c = 0,                      
            Maturity_Date_Mandatory__c = 'Yes',                  
            Active__c = true                                   
        );
        insert payTerm;
        Inco_Term__c incoTm = [SELECT Id,  Name FROM Inco_Term__c WHERE IncoTerm_Code__c = 'CIF' LIMIT 1];
        Territory_Distributor__c territory = [SELECT Id,TerritoryCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR165'];
        Sales_Order__c sobj = new Sales_Order__c(
            OwnerId = userTerMan1.Id, 
            SFDC_Order_Number__c = '83601',                     // SFDC Order Number
            SAP_Order_Number__c = '7009090605',                 // SAP Order Number
            Order_Cancel__c = false,     
            Sales_Org_lk__c = sorg.Id,                             // Order Cancel
            Order_Status__c = 'Not yet processed',              // Order Status
            OrderSubStatus__c = 'Approved',                     // Order Sub-Status
            Region_Territory__c = territory.Id,                  // Region / Territory
            RequestforCancellationCheck__c = false,  
            BudgetApprovalCheck__c = false,// Request for Cancellation
            //  BarterManager__c = BarterUser.Id, 
            Flag_Status__c = 'dislike\n',                       // Flag Status
            BrazilOrderSubmittedforApproval__c = true,          // Brazil Order Submitted for Approval
            //SalesOfficeManager__c = ZonalHeadUser.Id,          // Sales Office Manager
            Price_Book__c = pricebook.Id,                          // Price Book
            //SalesDistrictManager__c =  regioHeadUser.Id,    
            Inco_Term__c = incoTm.Id, 
            Currency_Brazil__c = 'Billing USD / Payment USD',   // Currency (Brazil)
            Key_Account__c = false,                             // Key Account
            Sold_to_Party__c = acc.Id,                         // Sold to Party
            Valid_FROM__c = system.today(), 
            Kit_Order__C = true,
            //  PaymentMethod__c = pMethod.Id, // Valid FROM
            Valid_To__c = system.today()+350,                   // Valid To
            Payment_Term__c = payTerm.Id,                     // Payment Term
            Type_of_Order__c = 'CONTRATO MÃE'                 // Type of Order
        );
        insert sobj;
        
        
        Sales_Order__c sobj1 = new Sales_Order__c(
            OwnerId = userTerMan1.Id, 
            
            Order_Cancel__c = false,     
            Sales_Org_lk__c = sorg.Id,                             // Order Cancel
            Order_Status__c = 'Not yet processed',              // Order Status
            OrderSubStatus__c = 'Pending',                     // Order Sub-Status
            Region_Territory__c = territory.Id,                  // Region / Territory
            RequestforCancellationCheck__c = false,  
            BudgetApprovalCheck__c = false,// Request for Cancellation
            //  BarterManager__c = BarterUser.Id, 
            Flag_Status__c = 'dislike\n',                       // Flag Status
            BrazilOrderSubmittedforApproval__c = true,          // Brazil Order Submitted for Approval
            //SalesOfficeManager__c = ZonalHeadUser.Id,          // Sales Office Manager
            Price_Book__c = pricebook.Id,                          // Price Book
            //SalesDistrictManager__c =  regioHeadUser.Id,    
            Inco_Term__c = incoTm.Id, 
            Currency_Brazil__c = 'Billing USD / Payment USD',   // Currency (Brazil)
            Key_Account__c = false,                             // Key Account
            Sold_to_Party__c = acc.Id,                         // Sold to Party
            Valid_FROM__c = system.today(), 
            Sales_Order__c =  sobj.Id,                  
            Payment_Term__c = payTerm.Id,                     // Payment Term
            Type_of_Order__c = 'BONIFICAÇÃO'                 // Type of Order
        );
        insert sobj1;
        
        
        SO_id=sobj.Id;
        ExchangeRate__c ExchngRte = new ExchangeRate__c(
            FROMCurrency__c = 'USD',                                  // FROM Currency
            ToCurrency__c = 'BRL',                                    // To Currency
            ExchangeRate__c = 3.45 ,                                  // Exchange Rate
            UpdatedDate__c = system.today()+45                       // Updated Date
        );
        insert ExchngRte;
         Test.startTest();
        Sales_Order_Line_Item__c soLineItm = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj.Id,          // Sale Order
            SKU_Name__c = skuRecord.Id,            // SKU Name
            Kit_Product__C = true,
            Item_Number__c = 10,                        // Item Number
            Item_Status__c = 'Not yet processed',       // Item Status
            Item_Cancel__c = false,                     // Item Cancel
            Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
            Sales_Org__c = sorg.Id,           // Sales Org
            PriceBookDetail__c = pbdetails1.Id,  // Price Book Detail
            Approval_Flag__c = 0,                       // Approval Flag
            ExchangeRate__c = ExchngRte.id,        // Exchange Rate
            OrderQuantityEdited__c = false,             // Order Quantity Edited
            Time_in_months__c = 0,                      // Time in months
            Days__c = 0,                                // Days
            DateofFAT__c =  system.today()+1, 
            Quantity__c = 450.00,                       // Quantity
            UnitValue__c = 100.00,                      // Unit Value
            UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
            InterestRate__c = 0.00,                     // Interest Rate
            TotalTax__c = 0.00,                         // Total Tax
            Tax__c = 1.00,
            Freight__c = 1.00,
            TotalFreight__c = 0.00,                     // Total Freight
            TotalPunctuality__c = 0.00,                 // Total Punctuality
            TotalLedgerCost__c = 0.00,                  // Total Ledger Cost
            TotalReplacementCost__c = 0.00 ,
            Customer_Conversion_Factor__c = 1// Total Replacement Cost
        );
        insert soLineItm;
        
        Sales_Order_Line_Item__c soLineItm1 = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj.Id,          // Sale Order
            SKU_Name__c = skuRecord.Id,            // SKU Name
            Item_Number__c = 20,                        // Item Number
            Kit_Product__C = false,
            Item_Status__c = 'Not yet processed',       // Item Status
            Item_Cancel__c = false,                     // Item Cancel
            Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
            Sales_Org__c = sorg.Id,           // Sales Org
            PriceBookDetail__c = pbdetails1.Id,  // Price Book Detail
            Approval_Flag__c = 0,                       // Approval Flag
            ExchangeRate__c = ExchngRte.id,        // Exchange Rate
            OrderQuantityEdited__c = false,             // Order Quantity Edited
            Time_in_months__c = 0,                      // Time in months
            Days__c = 0,                                // Days
            DateofFAT__c =  system.today()+1, 
            Quantity__c = 450.00,                       // Quantity
            UnitValue__c = 100.00,                      // Unit Value
            UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
            InterestRate__c = 0.00,                     // Interest Rate
            TotalTax__c = 0.00,                         // Total Tax
            Tax__c = 1.00,
            Freight__c = 1.00,
            TotalFreight__c = 0.00,                     // Total Freight
            TotalPunctuality__c = 0.00,                 // Total Punctuality
            TotalLedgerCost__c = 0.00,                  // Total Ledger Cost
            TotalReplacementCost__c = 0.00 ,
            Customer_Conversion_Factor__c = 1,// Total Replacement Cost
            Kit_Item_Number__C = 10
        );
        
        insert soLineItm1;
        
        Sales_Order_Line_Item__c soLineItm3 = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj1.Id,          // Sale Order
            SKU_Name__c = skuRecord.Id,            // SKU Name
            Kit_Product__C = true,
            Item_Number__c = 10,                        // Item Number
            Item_Status__c = 'Not yet processed',       // Item Status
            Item_Cancel__c = false,                     // Item Cancel
            Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
            Sales_Org__c = sorg.Id,           // Sales Org
            PriceBookDetail__c = pbdetails1.Id,  // Price Book Detail
            Approval_Flag__c = 0,                       // Approval Flag
            ExchangeRate__c = ExchngRte.id,        // Exchange Rate
            OrderQuantityEdited__c = false,             // Order Quantity Edited
            Time_in_months__c = 2,                      // Time in months
            Days__c =1,                                // Days
            DateofFAT__c =  system.today()+1, 
            Quantity__c = 450.00,                       // Quantity
            UnitValue__c = 100.00,                      // Unit Value
            UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
            InterestRate__c = 1.00,                     // Interest Rate
            TotalTax__c = 1.00,                         // Total Tax
            Tax__c = 1.00,
            Freight__c = 1.00,
            TotalFreight__c = 1.00,                     // Total Freight
            TotalPunctuality__c = 1.00,                 // Total Punctuality
            TotalLedgerCost__c = 1.00,                  // Total Ledger Cost
            TotalReplacementCost__c = 1.00 ,
            Customer_Conversion_Factor__c = 1// Total Replacement Cost
        );
        insert soLineItm3;
        
        Material_Plant_Relation__c mpr = new Material_Plant_Relation__c();
        mpr.COGSinfo__c=123;
        mpr.Active__c=true;
        mpr.Depot__c=acc.Depot_Code__c;
        mpr.Material_Code__c='000000000006302803'; 
        mpr.Replacement_Cost__c=12;
        mpr.SKU__c=skuRecord.id;
        insert mpr;
        
        OrderRequestController.deleteSalesOrder(sobj.id);
        OrderRequestController.cogsValueUpdate(skuRecord.id,acc.id);
        // OrderRequestController.getReplacementCost(skuRecord.Id);
        
        Culture__c culture = [SELECT Id FROM Culture__c LIMIT 1];
        List<OrderRequestController.SalesOrderItem> solst = new List<OrderRequestController.SalesOrderItem>(); 
        OrderRequestController.SalesOrderItem wrapObj = new OrderRequestController.SalesOrderItem();
        wrapObj.productId = skuRecord.id;
        wrapObj.fatDate = '02/05/2018';
        wrapObj.qty = 100;
        wrapObj.listValue = 50;
        wrapObj.unitValue = 32;
        wrapObj.unitValueWithInterest = 32;
        wrapObj.productCode =  skuRecord.SKU_Code__c;
        wrapObj.totalValue = 12816;
        wrapObj.interestRate = 0;
        wrapObj.days = 0;
        wrapObj.cultureDesc = culture.Id;
        wrapObj.priceBookDetailId = pbdetails1.Id;
        wrapObj.productName = '';
        wrapObj.inventory = 0;
        wrapObj.discount = 16.35;
        wrapObj.replacementMargin = 0;
        wrapObj.ledgerMargin = 63.1;
        wrapObj.totalValueWithInterest = 0;
        wrapObj.timeInMonths = 0;
        wrapObj.multipleOf = 0;
        wrapObj.kitProduct = true;
        wrapObj.kitNo = 10;
        //refKitNo = 
        solst.add(wrapObj);
        String serlizeStr = JSON.serialize(solst); 
        
        List<OrderRequestController.PriceDetail> lstPriceDetail = new List<OrderRequestController.PriceDetail>();
        OrderRequestController.PriceDetail oPD = new OrderRequestController.PriceDetail();
        oPD.pricebookId = pricebook.Id;
        oPD.skuId = skuRecord.Id;
        oPD.kitSKU = skuRecord.Id;
        lstPriceDetail.add(oPD);
        
        List<Id> kitSKUs = new List<Id>();
        kitSKUs.add(dep.id);
        
        System.runAs(userTerMan1) {
            // OrderRequestController.getPriceBookDetails(pricebook.Id,  dep.id,  acc.Customer_Region__c, acc.Id);
            // OrderRequestController.getMOPriceBookDetails(pricebook.Id, sobj.id, dep.id, acc.Customer_Region__c, sobj.id, false);
            
            // OrderRequestController.saveSalesOrder(sobj,  serlizeStr,  false,  false);
            
        }
        
        
        Test.stopTest(); 
    } 
    
    
    
    
    
    @isTest
    static  void method62(){
       
        //Profile p = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person' LIMIT 1]; 
        User userTerMan1 = [select id from user where Email = 'shama11@skinternational.com' limit 1];  
        User userTerMan123 = [select id from user where Email = 'userTerManTerri@skinternational.com' limit 1]; 
        //user userTerMan = [select id from user where Email = 'shama@skinternational.com' limit 1];
        
        
        Region__c reg = [select id,name,RegionCode__c from Region__c limit 1];
        Zone__c zo = [select id,name from Zone__c limit 1];
        SBU__c sbObj = [select id, name from SBU__c limit 1];
        Sales_Org__c sorg = new Sales_Org__c();
        sorg.Name = 'Brazil';
        sorg.Sales_Org_Code__c = '5191';
        insert sorg;
        
        Territory_Distributor__c territory5 =  new Territory_Distributor__c();
        territory5.Name = 'Deccan';
        territory5.TerritoryCode__c = 'BR160';
        territory5.SBU__c = sbObj.Id;     
        territory5.Region__c = reg.id;
        territory5.SalesOrg__c = sorg.Id;
        //territory5.i
        territory5.RegionDesciption__c = 'BR1001102 CHPS';                       
        territory5.Zone__c = zo.Id;
        territory5.TerritoryManager__c = userTerMan123.Id; //userTerMan
        //territory5.TerritoryManagerActive__c = false;
        insert territory5;
        
        // OrderRequestController.typeofOrderBonification(userTerMan123.Id,'BR160');
        // OrderRequestController.getSOM(userTerMan123.Id,'BR160');
        
        //Territory_Distributor__c tdList = [SELECT ID, Name,TerritoryManager__c, TerritoryCode__c, Region__c,Region__r.RegionCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR160' LIMIT 1];
        //system.debug('**User ->' +userTerMan1);
        //system.debug('**Territory Distributor ->' +tdList);
        
        
        
        //Depot__c oDep = new Depot__c(Name = 'Test');
        Id depotRecordTypeId = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();
        Depot__c dep = new Depot__c(Name = 'test', Depot_Code__c = 'Test123', SalesOrg__c = sorg.Id, RecordTypeId = depotRecordTypeId, Active__c = true);
        insert dep;
        
        //Depot__c dep = [SELECT Id, Depot_Code__c FROM Depot__c WHERE SalesOrg__c = :sorg.Id AND Id = :acc.Depot_Code__c LIMIT 1]; 
        Account acc = new Account(Name = 'Test', SAP_Code__c = '12345', Depot_Code__c = dep.Id);
        insert acc;
        
        //Account acc = [SELECT id, Customer_Group__c, Customer_Region__c, Depot_Code__c FROM Account WHERE Name = 'AGROPOLLO COMERCIAL AGRICOLA LTDA' LIMIT 1]; 
        
        string sDepotCode = dep.Depot_Code__c;
        
        list<string> lisi = OrderRequestController.getSeller();
        Division__c div = [select id from Division__c limit 1];
        SKU__c skuRecord = new SKU__c(
            Name = 'a1C0k000000A1ug',                                 // SKU Name
            SKU_Code__c = '000000000006302803',                       // SKU Code
            SKU_Description__c = 'Kit ',   // SKU Description
            UOM__c = 'KG', 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Multiple_of__c = 25.00,                                   // Multiple Of
            Combination_Key__c = '519110000000000006302803',          // Combination Key
            Active__c = true,
            Kit_Product__c = true,
            brand_name__c = 'MANZATE Kit',// Active
            Unit_Cost__c = 10.00
        );
        insert skuRecord;
        SKU__c skuRecord1 = new SKU__c(
            Name = 'a1C0k000000A1ue',                                 // SKU Name
            SKU_Code__c = '000000000006302804',                       // SKU Code
            SKU_Description__c = 'MANZATE 800WP 25KG PAPER BAG_BR 1',   // SKU Description
            UOM__c = 'KG', 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Multiple_of__c = 25.00,                                   // Multiple Of
            Combination_Key__c = '519110000000000006302804',          // Combination Key
            Active__c = true,
            brand_name__c = 'MANZATE1',// Active
            Unit_Cost__c = 10.00
        );
        insert skuRecord1;
        
        Brazil_Region_SKU_Combination__c newRec = new Brazil_Region_SKU_Combination__c(
            Sales_District__c = reg.Id,
            SKU__c = skuRecord.Id,
            Date__c = System.today(),
            Availability__c = 'No'
        );
        
        insert newRec;
        
        
        Price_Book_Details__c pbdetails1 =  [SELECT Id,SKU__r.id, Unit_Price__c, Monthly_Interest_Rate__c, SKU__c FROM Price_Book_Details__c LIMIT 1];
        pbdetails1.Kit_SKU__c = skuRecord.id;
        pbdetails1.Minimum_Price_U__c = 1;
        update pbdetails1;
        Price_Book_Details__c pbdetails2 = pbdetails1.clone(false, false, false, false);
        pbdetails2.SKU__c = skuRecord1.id;
        pbdetails2.Kit_SKU__c = skuRecord.id;
        insert pbdetails2;
        Price_Book__c pricebook = [SELECT Id FROM Price_Book__c LIMIT 1];
        pricebook.Kit_Price_Book__c = true;
        update pricebook;
        
        Component__c compRecord = new Component__c(
            Component_Item_Category__c = 'CTCV',                       
            Component_Quantity__c = 10,   
            Component_SKU__c = pbdetails1.SKU__r.id, 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Kit_SKU__c = skuRecord.id,                                   
            Combination_Key__c = '519110000000000006302803'        
        );
        insert compRecord;
        Component__c compRecord1 = new Component__c(
            Component_Item_Category__c = 'CTCV',                       
            Component_Quantity__c = 10,   
            Component_SKU__c = pbdetails2.SKU__r.id, 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Kit_SKU__c = skuRecord.id,                                   
            Combination_Key__c = '519110000000000006302804'        
        );
        insert compRecord1;
        Payment_Term__c payTerm = new Payment_Term__c(
            Payment_Term_Code__c = 'BR71',                        
            Payterms_Desc__c = 'INFORMAR VENCIMENTO',  
            Sales_Org__c = sorg.Id,                             
            Days_to_calc_interest__c = 0,                      
            Maturity_Date_Mandatory__c = 'Yes',                  
            Active__c = true                                   
        );
        insert payTerm;
        Inco_Term__c incoTm = [SELECT Id,  Name FROM Inco_Term__c WHERE IncoTerm_Code__c = 'CIF' LIMIT 1];
        Territory_Distributor__c territory = [SELECT Id,TerritoryCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR165'];
        Sales_Order__c sobj = new Sales_Order__c(
            OwnerId = userTerMan1.Id, 
            SFDC_Order_Number__c = '83601',                     // SFDC Order Number
            SAP_Order_Number__c = '7009090605',                 // SAP Order Number
            Order_Cancel__c = false,     
            Sales_Org_lk__c = sorg.Id,                             // Order Cancel
            Order_Status__c = 'Not yet processed',              // Order Status
            OrderSubStatus__c = 'Approved',                     // Order Sub-Status
            Region_Territory__c = territory.Id,                  // Region / Territory
            RequestforCancellationCheck__c = false,  
            BudgetApprovalCheck__c = false,// Request for Cancellation
            //  BarterManager__c = BarterUser.Id, 
            Flag_Status__c = 'dislike\n',                       // Flag Status
            BrazilOrderSubmittedforApproval__c = true,          // Brazil Order Submitted for Approval
            //SalesOfficeManager__c = ZonalHeadUser.Id,          // Sales Office Manager
            Price_Book__c = pricebook.Id,                          // Price Book
            //SalesDistrictManager__c =  regioHeadUser.Id,    
            Inco_Term__c = incoTm.Id, 
            Currency_Brazil__c = 'Billing USD / Payment USD',   // Currency (Brazil)
            Key_Account__c = false,                             // Key Account
            Sold_to_Party__c = acc.Id,                         // Sold to Party
            Valid_FROM__c = system.today(), 
            Kit_Order__C = true,
            //  PaymentMethod__c = pMethod.Id, // Valid FROM
            Valid_To__c = system.today()+350,                   // Valid To
            Payment_Term__c = payTerm.Id,                     // Payment Term
            Type_of_Order__c = 'CONTRATO MÃE'                 // Type of Order
        );
        insert sobj;
        
        
        Sales_Order__c sobj1 = new Sales_Order__c(
            OwnerId = userTerMan1.Id, 
            
            Order_Cancel__c = false,     
            Sales_Org_lk__c = sorg.Id,                             // Order Cancel
            Order_Status__c = 'Not yet processed',              // Order Status
            OrderSubStatus__c = 'Pending',                     // Order Sub-Status
            Region_Territory__c = territory.Id,                  // Region / Territory
            RequestforCancellationCheck__c = false,  
            BudgetApprovalCheck__c = false,// Request for Cancellation
            //  BarterManager__c = BarterUser.Id, 
            Flag_Status__c = 'dislike\n',                       // Flag Status
            BrazilOrderSubmittedforApproval__c = true,          // Brazil Order Submitted for Approval
            //SalesOfficeManager__c = ZonalHeadUser.Id,          // Sales Office Manager
            Price_Book__c = pricebook.Id,                          // Price Book
            //SalesDistrictManager__c =  regioHeadUser.Id,    
            Inco_Term__c = incoTm.Id, 
            Currency_Brazil__c = 'Billing USD / Payment USD',   // Currency (Brazil)
            Key_Account__c = false,                             // Key Account
            Sold_to_Party__c = acc.Id,                         // Sold to Party
            Valid_FROM__c = system.today(), 
            Sales_Order__c =  sobj.Id,                  
            Payment_Term__c = payTerm.Id,                     // Payment Term
            Type_of_Order__c = 'BONIFICAÇÃO'                 // Type of Order
        );
        insert sobj1;
        
        
        SO_id=sobj.Id;
        ExchangeRate__c ExchngRte = new ExchangeRate__c(
            FROMCurrency__c = 'USD',                                  // FROM Currency
            ToCurrency__c = 'BRL',                                    // To Currency
            ExchangeRate__c = 3.45 ,                                  // Exchange Rate
            UpdatedDate__c = system.today()+45                       // Updated Date
        );
        insert ExchngRte;
         Test.startTest(); 
        Sales_Order_Line_Item__c soLineItm = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj.Id,          // Sale Order
            SKU_Name__c = skuRecord.Id,            // SKU Name
            Kit_Product__C = true,
            Item_Number__c = 10,                        // Item Number
            Item_Status__c = 'Not yet processed',       // Item Status
            Item_Cancel__c = false,                     // Item Cancel
            Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
            Sales_Org__c = sorg.Id,           // Sales Org
            PriceBookDetail__c = pbdetails1.Id,  // Price Book Detail
            Approval_Flag__c = 0,                       // Approval Flag
            ExchangeRate__c = ExchngRte.id,        // Exchange Rate
            OrderQuantityEdited__c = false,             // Order Quantity Edited
            Time_in_months__c = 0,                      // Time in months
            Days__c = 0,                                // Days
            DateofFAT__c =  system.today()+1, 
            Quantity__c = 450.00,                       // Quantity
            UnitValue__c = 100.00,                      // Unit Value
            UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
            InterestRate__c = 0.00,                     // Interest Rate
            TotalTax__c = 0.00,                         // Total Tax
            Tax__c = 1.00,
            Freight__c = 1.00,
            TotalFreight__c = 0.00,                     // Total Freight
            TotalPunctuality__c = 0.00,                 // Total Punctuality
            TotalLedgerCost__c = 0.00,                  // Total Ledger Cost
            TotalReplacementCost__c = 0.00 ,
            Customer_Conversion_Factor__c = 1// Total Replacement Cost
        );
        insert soLineItm;
        
        Sales_Order_Line_Item__c soLineItm1 = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj.Id,          // Sale Order
            SKU_Name__c = skuRecord.Id,            // SKU Name
            Item_Number__c = 20,                        // Item Number
            Kit_Product__C = false,
            Item_Status__c = 'Not yet processed',       // Item Status
            Item_Cancel__c = false,                     // Item Cancel
            Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
            Sales_Org__c = sorg.Id,           // Sales Org
            PriceBookDetail__c = pbdetails1.Id,  // Price Book Detail
            Approval_Flag__c = 0,                       // Approval Flag
            ExchangeRate__c = ExchngRte.id,        // Exchange Rate
            OrderQuantityEdited__c = false,             // Order Quantity Edited
            Time_in_months__c = 0,                      // Time in months
            Days__c = 0,                                // Days
            DateofFAT__c =  system.today()+1, 
            Quantity__c = 450.00,                       // Quantity
            UnitValue__c = 100.00,                      // Unit Value
            UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
            InterestRate__c = 0.00,                     // Interest Rate
            TotalTax__c = 0.00,                         // Total Tax
            Tax__c = 1.00,
            Freight__c = 1.00,
            TotalFreight__c = 0.00,                     // Total Freight
            TotalPunctuality__c = 0.00,                 // Total Punctuality
            TotalLedgerCost__c = 0.00,                  // Total Ledger Cost
            TotalReplacementCost__c = 0.00 ,
            Customer_Conversion_Factor__c = 1,// Total Replacement Cost
            Kit_Item_Number__C = 10
        );
        
        insert soLineItm1;
        
        Sales_Order_Line_Item__c soLineItm3 = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj1.Id,          // Sale Order
            SKU_Name__c = skuRecord.Id,            // SKU Name
            Kit_Product__C = true,
            Item_Number__c = 10,                        // Item Number
            Item_Status__c = 'Not yet processed',       // Item Status
            Item_Cancel__c = false,                     // Item Cancel
            Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
            Sales_Org__c = sorg.Id,           // Sales Org
            PriceBookDetail__c = pbdetails1.Id,  // Price Book Detail
            Approval_Flag__c = 0,                       // Approval Flag
            ExchangeRate__c = ExchngRte.id,        // Exchange Rate
            OrderQuantityEdited__c = false,             // Order Quantity Edited
            Time_in_months__c = 2,                      // Time in months
            Days__c =1,                                // Days
            DateofFAT__c =  system.today()+1, 
            Quantity__c = 450.00,                       // Quantity
            UnitValue__c = 100.00,                      // Unit Value
            UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
            InterestRate__c = 1.00,                     // Interest Rate
            TotalTax__c = 1.00,                         // Total Tax
            Tax__c = 1.00,
            Freight__c = 1.00,
            TotalFreight__c = 1.00,                     // Total Freight
            TotalPunctuality__c = 1.00,                 // Total Punctuality
            TotalLedgerCost__c = 1.00,                  // Total Ledger Cost
            TotalReplacementCost__c = 1.00 ,
            Customer_Conversion_Factor__c = 1// Total Replacement Cost
        );
        insert soLineItm3;
        
        Material_Plant_Relation__c mpr = new Material_Plant_Relation__c();
        mpr.COGSinfo__c=123;
        mpr.Active__c=true;
        mpr.Depot__c=acc.Depot_Code__c;
        mpr.Material_Code__c='000000000006302803'; 
        mpr.Replacement_Cost__c=12;
        mpr.SKU__c=skuRecord.id;
        insert mpr;
        
        
        
        Culture__c culture = [SELECT Id FROM Culture__c LIMIT 1];
        List<OrderRequestController.SalesOrderItem> solst = new List<OrderRequestController.SalesOrderItem>(); 
        OrderRequestController.SalesOrderItem wrapObj = new OrderRequestController.SalesOrderItem();
        wrapObj.productId = skuRecord.id;
        wrapObj.fatDate = '02/05/2018';
        wrapObj.qty = 100;
        wrapObj.listValue = 50;
        wrapObj.unitValue = 32;
        wrapObj.unitValueWithInterest = 32;
        wrapObj.productCode =  skuRecord.SKU_Code__c;
        wrapObj.totalValue = 12816;
        wrapObj.interestRate = 0;
        wrapObj.days = 0;
        wrapObj.cultureDesc = culture.Id;
        wrapObj.priceBookDetailId = pbdetails1.Id;
        wrapObj.productName = '';
        wrapObj.inventory = 0;
        wrapObj.discount = 16.35;
        wrapObj.replacementMargin = 0;
        wrapObj.ledgerMargin = 63.1;
        wrapObj.totalValueWithInterest = 0;
        wrapObj.timeInMonths = 0;
        wrapObj.multipleOf = 0;
        wrapObj.kitProduct = true;
        wrapObj.kitNo = 10;
        //refKitNo = 
        solst.add(wrapObj);
        String serlizeStr = JSON.serialize(solst); 
        
        List<OrderRequestController.PriceDetail> lstPriceDetail = new List<OrderRequestController.PriceDetail>();
        OrderRequestController.PriceDetail oPD = new OrderRequestController.PriceDetail();
        oPD.pricebookId = pricebook.Id;
        oPD.skuId = skuRecord.Id;
        oPD.kitSKU = skuRecord.Id;
        lstPriceDetail.add(oPD);
        
        List<Id> kitSKUs = new List<Id>();
        kitSKUs.add(dep.id);
        
        List<Sales_Order_Line_Item__c> soitemlist = new List<Sales_Order_Line_Item__c>();
        soitemlist.add(soLineItm3);
        Map<id,List<Sales_Order_Line_Item__c>> soitemmap = new Map<id,List<Sales_Order_Line_Item__c>>();
        soitemmap.put(kitSKUs[0],soitemlist);
        
        
        Depot__c dep2 = new Depot__c(
            Name = 'UPL Do Brasil - Aparecida de Goiania',   // Depot Name
            Country__c = 'Brazil',                           // Country
            Depot_Code__c = 'BR07',                          // Depot Code
            Active__c = true,                                // Active
            SalesOrg__c = sorg.Id                           // Sales Org
        );
        insert dep2;
        
        Material_Plant_Relation__c MPRelation1 = new Material_Plant_Relation__c(
            Name = 'MANZATE 800WP 25KG PAPER BAG_BR',               // Material Plant Relation Name
            Material_Code__c = '000000000006302802',                // Material Code
            Active__c = true,                                       // Active
            Material_Desc__c = 'MANZATE 800WP 25KG PAPER BAG_BR',   // Material Desc
            Depot__c = dep2.Id,                         
            Material_Ledger_Cost__c = 13.26,                        // Material Ledger Cost
            MC_Currency__c = 'BRL',                                 // MC Currency
            Replacement_Cost__c = 2.10,                             // Replacement Cost
            RC_Currency__c = 'USD',                                 // RC Currency
            SKU__c = skuRecord.Id,                         
            Sales_Org__c = sorg.Id                      
        );
        insert MPRelation1;
        
        System.runAs(userTerMan1) {
            // OrderRequestController.getPriceBookDetails(pricebook.Id,  dep.id,  acc.Customer_Region__c, acc.Id);
            // OrderRequestController.getMOPriceBookDetails(pricebook.Id, sobj.id, dep.id, acc.Customer_Region__c, sobj.id, false);
            OrderRequestController.fetchKitComponentProduct(lstPriceDetail,  kitSKUs,  pricebook.Id);
            OrderRequestController.fetchMOKitComponentProduct(lstPriceDetail,  kitSKUs,  pricebook.Id,soitemmap);
            
            
            // OrderRequestController.saveSalesOrder(sobj,  serlizeStr,  false,  false);
            
        }
        
        
        
        Test.stopTest(); 
    }
    
    
    
    
    @isTest
    static  void method62Javed(){
        
        //Profile p = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person' LIMIT 1]; 
        User userTerMan1 = [select id from user where Email = 'shama11@skinternational.com' limit 1];  
        User userTerMan123 = [select id from user where Email = 'userTerManTerri@skinternational.com' limit 1]; 
        //user userTerMan = [select id from user where Email = 'shama@skinternational.com' limit 1];
        
        
        Region__c reg = [select id,name,RegionCode__c from Region__c limit 1];
        Zone__c zo = [select id,name from Zone__c limit 1];
        SBU__c sbObj = [select id, name from SBU__c limit 1];
        Sales_Org__c sorg = new Sales_Org__c();
        sorg.Name = 'Brazil';
        sorg.Sales_Org_Code__c = '5191';
        insert sorg;
        
        Territory_Distributor__c territory5 =  new Territory_Distributor__c();
        territory5.Name = 'Deccan';
        territory5.TerritoryCode__c = 'BR160';
        territory5.SBU__c = sbObj.Id;     
        territory5.Region__c = reg.id;
        territory5.SalesOrg__c = sorg.Id;
        //territory5.i
        territory5.RegionDesciption__c = 'BR1001102 CHPS';                       
        territory5.Zone__c = zo.Id;
        territory5.TerritoryManager__c = userTerMan123.Id; //userTerMan
        //territory5.TerritoryManagerActive__c = false;
        insert territory5;
        
        // OrderRequestController.typeofOrderBonification(userTerMan123.Id,'BR160');
        // OrderRequestController.getSOM(userTerMan123.Id,'BR160');
        
        //Territory_Distributor__c tdList = [SELECT ID, Name,TerritoryManager__c, TerritoryCode__c, Region__c,Region__r.RegionCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR160' LIMIT 1];
        //system.debug('**User ->' +userTerMan1);
        //system.debug('**Territory Distributor ->' +tdList);
        
        
        
        //Depot__c oDep = new Depot__c(Name = 'Test');
        Id depotRecordTypeId = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();
        Depot__c dep = new Depot__c(Name = 'test', Depot_Code__c = 'Test123', SalesOrg__c = sorg.Id, RecordTypeId = depotRecordTypeId, Active__c = true);
        insert dep;
        
        //Depot__c dep = [SELECT Id, Depot_Code__c FROM Depot__c WHERE SalesOrg__c = :sorg.Id AND Id = :acc.Depot_Code__c LIMIT 1]; 
        Account acc = new Account(Name = 'Test', SAP_Code__c = '12345', Depot_Code__c = dep.Id);
        insert acc;
        
        //Account acc = [SELECT id, Customer_Group__c, Customer_Region__c, Depot_Code__c FROM Account WHERE Name = 'AGROPOLLO COMERCIAL AGRICOLA LTDA' LIMIT 1]; 
        
        string sDepotCode = dep.Depot_Code__c;
        
        list<string> lisi = OrderRequestController.getSeller();
        Division__c div = [select id from Division__c limit 1];
        SKU__c skuRecord = new SKU__c(
            Name = 'a1C0k000000A1ug',                                 // SKU Name
            SKU_Code__c = '000000000006302803',                       // SKU Code
            SKU_Description__c = 'Kit ',   // SKU Description
            UOM__c = 'KG', 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Multiple_of__c = 25.00,                                   // Multiple Of
            Combination_Key__c = '519110000000000006302803',          // Combination Key
            Active__c = true,
            Kit_Product__c = true,
            brand_name__c = 'MANZATE Kit',// Active
            Unit_Cost__c = 10.00
        );
        insert skuRecord;
        SKU__c skuRecord1 = new SKU__c(
            Name = 'a1C0k000000A1ue',                                 // SKU Name
            SKU_Code__c = '000000000006302804',                       // SKU Code
            SKU_Description__c = 'MANZATE 800WP 25KG PAPER BAG_BR 1',   // SKU Description
            UOM__c = 'KG', 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Multiple_of__c = 25.00,                                   // Multiple Of
            Combination_Key__c = '519110000000000006302804',          // Combination Key
            Active__c = true,
            brand_name__c = 'MANZATE1',// Active
            Unit_Cost__c = 10.00
        );
        insert skuRecord1;
        
        Brazil_Region_SKU_Combination__c newRec = new Brazil_Region_SKU_Combination__c(
            Sales_District__c = reg.Id,
            SKU__c = skuRecord.Id,
            Date__c = System.today(),
            Availability__c = 'No'
        );
        
        insert newRec;
        
        
        Price_Book_Details__c pbdetails1 =  [SELECT Id,SKU__r.id, Unit_Price__c, Monthly_Interest_Rate__c, SKU__c FROM Price_Book_Details__c LIMIT 1];
        pbdetails1.Kit_SKU__c = skuRecord.id;
        pbdetails1.Minimum_Price_U__c = 1;
        update pbdetails1;
        Price_Book_Details__c pbdetails2 = pbdetails1.clone(false, false, false, false);
        pbdetails2.SKU__c = skuRecord1.id;
        pbdetails2.Kit_SKU__c = skuRecord.id;
        insert pbdetails2;
        Price_Book__c pricebook = [SELECT Id FROM Price_Book__c LIMIT 1];
        pricebook.Kit_Price_Book__c = true;
        update pricebook;
        
        Component__c compRecord = new Component__c(
            Component_Item_Category__c = 'CTCV',                       
            Component_Quantity__c = 10,   
            Component_SKU__c = pbdetails1.SKU__r.id, 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Kit_SKU__c = skuRecord.id,                                   
            Combination_Key__c = '519110000000000006302803'        
        );
        insert compRecord;
        Component__c compRecord1 = new Component__c(
            Component_Item_Category__c = 'CTCV',                       
            Component_Quantity__c = 10,   
            Component_SKU__c = pbdetails2.SKU__r.id, 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Kit_SKU__c = skuRecord.id,                                   
            Combination_Key__c = '519110000000000006302804'        
        );
        insert compRecord1;
        Payment_Term__c payTerm = new Payment_Term__c(
            Payment_Term_Code__c = 'BR71',                        
            Payterms_Desc__c = 'INFORMAR VENCIMENTO',  
            Sales_Org__c = sorg.Id,                             
            Days_to_calc_interest__c = 0,                      
            Maturity_Date_Mandatory__c = 'Yes',                  
            Active__c = true                                   
        );
        insert payTerm;
        //code added by sumit
        List<Inventory_Control__c> icList = new List<Inventory_Control__c>();
        Inventory_Control__c icObj = new Inventory_Control__c();
        icObj.BU__c = '5191';
        icObj.Quantity__c = 5000000;
        icObj.Product__c = 'CONSIST';
        icObj.Fiscal_Year__c = '22/23';
        icObj.Inventory_Active__c = true ;
        icObj.Inventory_Block_Alert__c = 'Alert';
        icList.add(icObj);
        
        Inventory_Control__c icObj1 = new Inventory_Control__c();
        icObj1.BU__c = '5190';
        icObj1.Quantity__c = 5000000;
        icObj1.Product__c = 'CONSIST';
        icObj1.Fiscal_Year__c = '22/23';
        icObj1.Inventory_Active__c = true ;
        icObj1.Inventory_Block_Alert__c = 'Alert';
        icList.add(icObj1);
        insert icList;
            
        Inco_Term__c incoTm = [SELECT Id,  Name FROM Inco_Term__c WHERE IncoTerm_Code__c = 'CIF' LIMIT 1];
        Territory_Distributor__c territory = [SELECT Id,TerritoryCode__c FROM Territory_Distributor__c WHERE TerritoryCode__c = 'BR165'];
        Sales_Order__c sobj = new Sales_Order__c(
            OwnerId = userTerMan1.Id, 
            SFDC_Order_Number__c = '83601',                     // SFDC Order Number
            SAP_Order_Number__c = '7009090605',                 // SAP Order Number
            Order_Cancel__c = false,     
            Sales_Org_lk__c = sorg.Id,                             // Order Cancel
            Order_Status__c = 'Not yet processed',              // Order Status
            OrderSubStatus__c = 'Approved',                     // Order Sub-Status
            Region_Territory__c = territory.Id,                  // Region / Territory
            RequestforCancellationCheck__c = false,  
            BudgetApprovalCheck__c = false,// Request for Cancellation
            //  BarterManager__c = BarterUser.Id, 
            Flag_Status__c = 'dislike\n',                       // Flag Status
            BrazilOrderSubmittedforApproval__c = true,          // Brazil Order Submitted for Approval
            //SalesOfficeManager__c = ZonalHeadUser.Id,          // Sales Office Manager
            Price_Book__c = pricebook.Id,                          // Price Book
            //SalesDistrictManager__c =  regioHeadUser.Id,    
            Inco_Term__c = incoTm.Id, 
            Currency_Brazil__c = 'Billing USD / Payment USD',   // Currency (Brazil)
            Key_Account__c = false,                             // Key Account
            Sold_to_Party__c = acc.Id,                         // Sold to Party
            Valid_FROM__c = system.today(), 
            Kit_Order__C = true,
            //  PaymentMethod__c = pMethod.Id, // Valid FROM
            Valid_To__c = system.today()+350,                   // Valid To
            Payment_Term__c = payTerm.Id,                     // Payment Term
            Type_of_Order__c = 'CONTRATO MÃE'                 // Type of Order
        );
        insert sobj;
        
        
        Sales_Order__c sobj1 = new Sales_Order__c(
            OwnerId = userTerMan1.Id, 
            
            Order_Cancel__c = false,     
            Sales_Org_lk__c = sorg.Id,                             // Order Cancel
            Order_Status__c = 'Not yet processed',              // Order Status
            OrderSubStatus__c = 'Pending',                     // Order Sub-Status
            Region_Territory__c = territory.Id,                  // Region / Territory
            RequestforCancellationCheck__c = false,  
            BudgetApprovalCheck__c = false,// Request for Cancellation
            //  BarterManager__c = BarterUser.Id, 
            Flag_Status__c = 'dislike\n',                       // Flag Status
            BrazilOrderSubmittedforApproval__c = true,          // Brazil Order Submitted for Approval
            //SalesOfficeManager__c = ZonalHeadUser.Id,          // Sales Office Manager
            Price_Book__c = pricebook.Id,                          // Price Book
            //SalesDistrictManager__c =  regioHeadUser.Id,    
            Inco_Term__c = incoTm.Id, 
            Currency_Brazil__c = 'Billing USD / Payment USD',   // Currency (Brazil)
            Key_Account__c = false,                             // Key Account
            Sold_to_Party__c = acc.Id,                         // Sold to Party
            Valid_FROM__c = system.today(), 
            Sales_Order__c =  sobj.Id,                  
            Payment_Term__c = payTerm.Id,                     // Payment Term
            Type_of_Order__c = 'BONIFICAÇÃO'                 // Type of Order
        );
        insert sobj1;
        
        
        SO_id=sobj.Id;
        ExchangeRate__c ExchngRte = new ExchangeRate__c(
            FROMCurrency__c = 'USD',                                  // FROM Currency
            ToCurrency__c = 'BRL',                                    // To Currency
            ExchangeRate__c = 3.45 ,                                  // Exchange Rate
            UpdatedDate__c = system.today()+45                       // Updated Date
        );
        insert ExchngRte;
         Test.startTest();
        Sales_Order_Line_Item__c soLineItm = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj.Id,          // Sale Order
            SKU_Name__c = skuRecord.Id,            // SKU Name
            Kit_Product__C = true,
            Item_Number__c = 10,                        // Item Number
            Item_Status__c = 'Not yet processed',       // Item Status
            Item_Cancel__c = false,                     // Item Cancel
            Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
            Sales_Org__c = sorg.Id,           // Sales Org
            PriceBookDetail__c = pbdetails1.Id,  // Price Book Detail
            Approval_Flag__c = 0,                       // Approval Flag
            ExchangeRate__c = ExchngRte.id,        // Exchange Rate
            OrderQuantityEdited__c = false,             // Order Quantity Edited
            Time_in_months__c = 0,                      // Time in months
            Days__c = 0,                                // Days
            DateofFAT__c =  system.today()+1, 
            Quantity__c = 450.00,                       // Quantity
            UnitValue__c = 100.00,                      // Unit Value
            UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
            InterestRate__c = 0.00,                     // Interest Rate
            TotalTax__c = 0.00,                         // Total Tax
            Tax__c = 1.00,
            Freight__c = 1.00,
            TotalFreight__c = 0.00,                     // Total Freight
            TotalPunctuality__c = 0.00,                 // Total Punctuality
            TotalLedgerCost__c = 0.00,                  // Total Ledger Cost
            TotalReplacementCost__c = 0.00 ,
            Customer_Conversion_Factor__c = 1// Total Replacement Cost
        );
        insert soLineItm;
         
        Sales_Order_Line_Item__c soLineItm1 = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj.Id,          // Sale Order
            SKU_Name__c = skuRecord.Id,            // SKU Name
            Item_Number__c = 20,                        // Item Number
            Kit_Product__C = false,
            Item_Status__c = 'Not yet processed',       // Item Status
            Item_Cancel__c = false,                     // Item Cancel
            Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
            Sales_Org__c = sorg.Id,           // Sales Org
            PriceBookDetail__c = pbdetails1.Id,  // Price Book Detail
            Approval_Flag__c = 0,                       // Approval Flag
            ExchangeRate__c = ExchngRte.id,        // Exchange Rate
            OrderQuantityEdited__c = false,             // Order Quantity Edited
            Time_in_months__c = 0,                      // Time in months
            Days__c = 0,                                // Days
            DateofFAT__c =  system.today()+1, 
            Quantity__c = 450.00,                       // Quantity
            UnitValue__c = 100.00,                      // Unit Value
            UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
            InterestRate__c = 0.00,                     // Interest Rate
            TotalTax__c = 0.00,                         // Total Tax
            Tax__c = 1.00,
            Freight__c = 1.00,
            TotalFreight__c = 0.00,                     // Total Freight
            TotalPunctuality__c = 0.00,                 // Total Punctuality
            TotalLedgerCost__c = 0.00,                  // Total Ledger Cost
            TotalReplacementCost__c = 0.00 ,
            Customer_Conversion_Factor__c = 1,// Total Replacement Cost
            Kit_Item_Number__C = 10
        );
        
        insert soLineItm1;
        
        Sales_Order_Line_Item__c soLineItm3 = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj1.Id,          // Sale Order
            SKU_Name__c = skuRecord.Id,            // SKU Name
            Kit_Product__C = true,
            Item_Number__c = 10,                        // Item Number
            Item_Status__c = 'Not yet processed',       // Item Status
            Item_Cancel__c = false,                     // Item Cancel
            Order_Item_Key__c = '836010',               // OrderNumber_Item_Key
            Sales_Org__c = sorg.Id,           // Sales Org
            PriceBookDetail__c = pbdetails1.Id,  // Price Book Detail
            Approval_Flag__c = 0,                       // Approval Flag
            ExchangeRate__c = ExchngRte.id,        // Exchange Rate
            OrderQuantityEdited__c = false,             // Order Quantity Edited
            Time_in_months__c = 2,                      // Time in months
            Days__c =1,                                // Days
            DateofFAT__c =  system.today()+1, 
            Quantity__c = 450.00,                       // Quantity
            UnitValue__c = 100.00,                      // Unit Value
            UnitValuewithInterest__c = 100.00,          // Unit Value with Interest
            InterestRate__c = 1.00,                     // Interest Rate
            TotalTax__c = 1.00,                         // Total Tax
            Tax__c = 1.00,
            Freight__c = 1.00,
            TotalFreight__c = 1.00,                     // Total Freight
            TotalPunctuality__c = 1.00,                 // Total Punctuality
            TotalLedgerCost__c = 1.00,                  // Total Ledger Cost
            TotalReplacementCost__c = 1.00 ,
            Customer_Conversion_Factor__c = 1// Total Replacement Cost
        );
        insert soLineItm3;
        
        Material_Plant_Relation__c mpr = new Material_Plant_Relation__c();
        mpr.COGSinfo__c=123;
        mpr.Active__c=true;
        mpr.Depot__c=acc.Depot_Code__c;
        mpr.Material_Code__c='000000000006302803'; 
        mpr.Replacement_Cost__c=12;
        mpr.SKU__c=skuRecord.id;
        insert mpr;
        
        
        
        Culture__c culture = [SELECT Id FROM Culture__c LIMIT 1];
        List<OrderRequestController.SalesOrderItem> solst = new List<OrderRequestController.SalesOrderItem>(); 
        OrderRequestController.SalesOrderItem wrapObj = new OrderRequestController.SalesOrderItem();
        wrapObj.productId = skuRecord.id;
        wrapObj.fatDate = '02/05/2018';
        wrapObj.qty = 100;
        wrapObj.listValue = 50;
        wrapObj.unitValue = 32;
        wrapObj.unitValueWithInterest = 32;
        wrapObj.productCode =  skuRecord.SKU_Code__c;
        wrapObj.totalValue = 12816;
        wrapObj.interestRate = 0;
        wrapObj.days = 0;
        wrapObj.cultureDesc = culture.Id;
        wrapObj.priceBookDetailId = pbdetails1.Id;
        wrapObj.productName = '';
        wrapObj.inventory = 0;
        wrapObj.discount = 16.35;
        wrapObj.replacementMargin = 0;
        wrapObj.ledgerMargin = 63.1;
        wrapObj.totalValueWithInterest = 0;
        wrapObj.timeInMonths = 0;
        wrapObj.multipleOf = 0;
        wrapObj.kitProduct = true;
        wrapObj.kitNo = 10;
        //refKitNo = 
        solst.add(wrapObj);
        String serlizeStr = JSON.serialize(solst); 
        
        List<OrderRequestController.PriceDetail> lstPriceDetail = new List<OrderRequestController.PriceDetail>();
        OrderRequestController.PriceDetail oPD = new OrderRequestController.PriceDetail();
        oPD.pricebookId = pricebook.Id;
        oPD.skuId = skuRecord.Id;
        oPD.kitSKU = skuRecord.Id;
        lstPriceDetail.add(oPD);
        
        List<Id> kitSKUs = new List<Id>();
        kitSKUs.add(dep.id);
        
        List<Sales_Order_Line_Item__c> soitemlist = new List<Sales_Order_Line_Item__c>();
        soitemlist.add(soLineItm3);
        Map<id,List<Sales_Order_Line_Item__c>> soitemmap = new Map<id,List<Sales_Order_Line_Item__c>>();
        soitemmap.put(kitSKUs[0],soitemlist);
        Map<String,Decimal> mapofsales = new Map<String,Decimal>();
        mapofsales.put(soLineItm3.Id,90);
        Depot__c dep2 = new Depot__c(
            Name = 'UPL Do Brasil - Aparecida de Goiania',   // Depot Name
            Country__c = 'Brazil',                           // Country
            Depot_Code__c = 'BR07',                          // Depot Code
            Active__c = true,                                // Active
            SalesOrg__c = sorg.Id                           // Sales Org
        );
        insert dep2;
        
        Material_Plant_Relation__c MPRelation1 = new Material_Plant_Relation__c(
            Name = 'MANZATE 800WP 25KG PAPER BAG_BR',               // Material Plant Relation Name
            Material_Code__c = '000000000006302802',                // Material Code
            Active__c = true,                                       // Active
            Material_Desc__c = 'MANZATE 800WP 25KG PAPER BAG_BR',   // Material Desc
            Depot__c = dep2.Id,                         
            Material_Ledger_Cost__c = 13.26,                        // Material Ledger Cost
            MC_Currency__c = 'BRL',                                 // MC Currency
            Replacement_Cost__c = 2.10,                             // Replacement Cost
            RC_Currency__c = 'USD',                                 // RC Currency
            SKU__c = skuRecord.Id,                         
            Sales_Org__c = sorg.Id                      
        );
        insert MPRelation1;
        
        //  System.runAs(userTerMan1) {
        // OrderRequestController.getPriceBookDetails(pricebook.Id,  dep.id,  acc.Customer_Region__c, acc.Id);
        // OrderRequestController.getMOPriceBookDetails(pricebook.Id, sobj.id, dep.id, acc.Customer_Region__c, sobj.id, false);
       
        OrderRequestController.getSalesOrderItems(sobj.id);
        OrderRequestController.getCreatedDate(sobj.id);
        OrderRequestController.getInventory(sobj.id);
        OrderRequestController.getSelloutMinpriceFactor();
        OrderRequestController.getReplacementCost(skuRecord.Id);
         OrderRequestController.updateBarter(mapofsales,10,10,10,mapofsales,mapofsales);
        // OrderRequestController.saveSalesOrder(sobj,  serlizeStr,  false,  false);
        
        //  }
        
        
        
        Test.stopTest(); 
    }
    
    static testMethod void SKUUpdateAPITest(){
        Sales_Order__c sobj =[select id,SAP_Order_Number__c from Sales_Order__c where SAP_Order_Number__c = '7009090604'];
        OrderRequestController.FlagStatus status = OrderRequestController.checkFlag(sobj.Id, false, 'ORDEM FILHA', 'Draft');
        OrderRequestController.FlagStatus status1 = OrderRequestController.checkFlag(sobj.Id, false, 'BONIFICAÇÃO', 'Draft');
        OrderRequestController.FlagStatus status2 = OrderRequestController.checkFlag(sobj.Id, false, 'REMESSA PARA TESTE', 'Draft');
        OrderRequestController.latestExchangeRate();
        OrderRequestController.isSOCancelProcessCheck(sobj.id);
        OrderRequestController.isSOItemsEditProcessCheck(sobj.id);
        OrderRequestController.validateSAPResponse(true,sobj.id,'Test','isSOCancelProcess');
        OrderRequestController.validateSAPResponse(true,sobj.id,'Test','isSOItemsEditProcess');
       
        // OrderRequestController.SKUUpdateAPI(sobj.id);
        //     OrderRequestController.latestExchangeRate();
    }
    
}