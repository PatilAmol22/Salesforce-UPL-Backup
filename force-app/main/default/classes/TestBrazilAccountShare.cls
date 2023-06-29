@isTest
public class TestBrazilAccountShare {
    
    /*
    //inserting all data into database for testing 
    @testSetup
    static void allTheDataForThisTestClass() {
        Id recordTypeId1 = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Sales Order').getRecordTypeId(); 
        Id recordTypeId = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Simulation').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name  = 'Brazil Sales Person' LIMIT 1];                     //Brazil Sales Person Profile
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Office Manager' LIMIT 1];            //Brazil Sales Office Manager Profile
        Profile p2 = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Director' LIMIT 1];                  //Brazil Sales Director Profile
        Profile p3 = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales District Manager' LIMIT 1];          // Brazil Sales District Manager Profile
        Profile p4 = [SELECT Id FROM Profile WHERE Name = 'Brazil Customer Service User' LIMIT 1];           // Brazil Customer Service User Profile
        Profile p5 = [SELECT Id FROM Profile WHERE Name = 'Brazil Barter Manager' LIMIT 1];                  // Brazil Barter Mananger User Profile
        
        
        Sales_Org__c sorg = new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Sales_Org_Code__c='5191';
        insert sorg;
        
        Depot__c dep = new Depot__c(
            Name = 'UPL Do Brasil - Aparecida de Goiania',  // Depot Name
            Country__c = 'Brazil',                          // Country
            Depot_Code__c = 'BR04',                         // Depot Code
            Active__c = true,                               // Active
            SalesOrg__c = sorg.Id                           // Sales Org
        );
        insert dep;
        
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        
        User SBUuser = new User(
            Alias = 'CASSIO',                                                            // Alias
            Email = 'shama@skinternational.com',                                         // Email
            ProfileId = p2.Id,                                                           // Profile
            Username = '20005676@uniphos5.com.upltest',                                   // Username
            IsActive = true,                                                             // Active
            CommunityNickname = 'XCASSIO',    
            LastName='DIRETOR DE',
            Title = 'DIRETOR DE NEGOCIOS NORTE',                                         // Title
            TimeZoneSidKey = 'America/Sao_Paulo',                     
            LocaleSidKey = 'en_IN',                                                      // Locale
            LanguageLocaleKey = 'pt_BR',                                                 // Language
            ForecastEnabled = false,                                                     // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',                                             // Email Encoding
            Territory__c = 'GESTÃO NORTE',                                               // Territory
            EnableDepot__c = false,                                                      // Enable Depot
            Show_List_Value__c = true,                                                   // Show List Value (Brazil)
            Show_Credit_Limit__c = false,                                                // Show Credit Limit
            Show_Inventory__c = false,                                                   // Show Inventory
            Show_Pricing__c = false,                                                     // Show Pricing
            Show_Inventory_Column__c = false,                                            // Show Inventory Column
            Show_InTransit__c = false,                                                   // Show InTransit
            Show_InTransit_Values__c = false                                             // Show InTransit Values
        );
        
        insert SBUuser;
        
        SBU__c sbu = new SBU__c(
            SBUUser__c = SBUuser.Id,                                                   // SBU User
            Brazil_SBU_Name__c = 'GESTÃO NORTE',                                       // Brazil SBU Name
            SBUCode__c = 'BR1',                                                        // SBU Code
            SalesOrg__c = sorg.Id                                                      // Sales Org
        );
        insert sbu;
        //added 
        User BarterUser = new User(
            Alias = 'MARCELO',                                                                      // Alias
            Email = 'ganesh.chaurasia@skinternational.com',                                          // Email
            ProfileId = p5.Id,                                                                // Profile
            Username = '200054786@uniphos.com.upltest',                                            // Username
            IsActive = true,  
            LastName='Gavazi',
            CommunityNickname = 'XMARCELO',  // Nickname
            TimeZoneSidKey = 'America/Sao_Paulo',          
            LocaleSidKey = 'en_IN',                                                // Locale
            LanguageLocaleKey = 'pt_BR',                                                       // Language
            ForecastEnabled = false,                                                              // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',           // Email Encoding
            EnableDepot__c = false,                                                               // Enable Depot
            Show_List_Value__c = false,                                                           // Show List Value (Brazil)
            Show_Credit_Limit__c = false,                                                         // Show Credit Limit
            Show_Inventory__c = false,                                                            // Show Inventory
            Show_Pricing__c = false,                                                              // Show Pricing
            Show_Inventory_Column__c = false,                                                     // Show Inventory Column
            Show_InTransit__c = false,                                                            // Show InTransit
            Show_InTransit_Values__c = false                                                     // Show InTransit Values
        );
        insert BarterUser;
        
        
        User ZonalHeadUser = new User(
            Alias = 'GERSON',                                                           
            Email = 'shama@skinternational.com',                                        
            ProfileId = p1.Id,                                                           
            Username = '20000679@uniphos6.com.upltest',                                  
            IsActive = true,                                                             
            LastName='LUIZ LEVANDOWSKI',
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
            Show_Credit_Limit__c = false,                                               
            Show_Inventory__c = false,                                                
            Show_Pricing__c = false,                                                    
            Show_Inventory_Column__c = false,                                           
            Show_InTransit__c = false,                                                   
            Show_InTransit_Values__c = false                                            
        );
        insert ZonalHeadUser;
        
        
        Zone__c zone= new Zone__c();
        zone.SalesOrg__c=sorg.Id;
        zone.Name='BU MATO GROSSO';
        zone.ZoneCode__c = 'BR10';              
        zone.ZonalHead__c=ZonalHeadUser.Id;
        //  zone.SBU_Code__c=sbu.Id;
        insert zone;
        
        
        User regioHeadUser = new User(
            Alias = 'ALEXANDE',                                                             // Alias
            Email = 'shama@skinternational.com',                                            // Email
            ProfileId = p3.Id,                                                              // Profile
            Username = '20004449@uniphos1.com.upltest',                                      // Username
            IsActive = true,                                                                // Active
            CommunityNickname = 'XALEXANDER',                                                // Nickname
            LastName='PARAGUACU MONTEIRO DE OLIVEIRA',
            Title = 'GERENTE COMERCIAL',                                                    // Title
            TimeZoneSidKey = 'America/Sao_Paulo',        
            LocaleSidKey = 'en_IN',                                         
            LanguageLocaleKey = 'pt_BR',                                                  // Language
            ForecastEnabled = false,                                                        // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',     
            Region__c = 'MATO GROSSO DO SUL',                                               // Region
            EnableDepot__c = false,                                                         // Enable Depot
            Show_List_Value__c = true,                                                      // Show List Value (Brazil)
            Show_Credit_Limit__c = false,                                                   // Show Credit Limit
            Show_Inventory__c = false,                                                      // Show Inventory
            Show_Pricing__c = false,                                                        // Show Pricing
            Show_Inventory_Column__c = false,                                               // Show Inventory Column
            Show_InTransit__c = false,                                                      // Show InTransit
            Show_InTransit_Values__c = false                                                // Show InTransit Values
        );
        insert regioHeadUser;
        
        
        User BrazilAnaUser = new User(
            Alias = 'MILENI',                                                                              // Alias
            Email = 'shama@skinternational.com',                                                           // Email
            ProfileId = p4.Id,                                                                             // Profile
            Username = '20004688@uniphos2.com.upltest',                                                     // Username
            IsActive = true,                                                                               // Active
            CommunityNickname = 'XMILENI .PEREIRA DA SILVA',                                                // Nickname
            LastName='PEREIRA DA SILVA',
            Title = 'ANALISTA DE CUSTOMER SERVICE PL',                                                     // Title
            TimeZoneSidKey = 'America/Sao_Paulo',                      
            LocaleSidKey = 'en_IN',                                                         
            LanguageLocaleKey = 'pt_BR',                                                                 // Language
            ForecastEnabled = false,                                                                       // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',                    
            Territory__c = 'ADMINISTRAÇÃO DE VENDAS',                                                      // Territory
            EnableDepot__c = false,                                                                        // Enable Depot
            Show_List_Value__c = false,                                                                    // Show List Value (Brazil)
            Show_Credit_Limit__c = false,                                                                  // Show Credit Limit
            Show_Inventory__c = false,                                                                     // Show Inventory
            Show_Pricing__c = false,                                                                       // Show Pricing
            Show_Inventory_Column__c = false,                                                              // Show Inventory Column
            Show_InTransit__c = false,                                                                     // Show InTransit
            Show_InTransit_Values__c = false                                                              // Show InTransit Values
        );
        insert BrazilAnaUser;
        
        
        Region__c region = new Region__c();
        region.Name='MATO GROSSO DO SUL';
        region.RegionCode__c= 'BR1010';
        region.SalesOrg__c=sorg.Id;
        region.Zone__c=zone.Id;
        region.RegionHead__c=regioHeadUser.Id;
        region.BrazilAnalyst__c =BrazilAnaUser.Id;    
        region.SBU__c =sbu.Id;                                                                           
        insert region;
        
        
        User userTerMan = new User(
            Alias = 'wflav',                                                            // Alias
            Email = 'shama@skinternational.com',                                          // Email
            ProfileId = p.Id,                                                             // Profile
            Username = '20005489@uniphos3.com.upltest',                                    // Username
            IsActive = true,                                                              // Active
            LastName='FLAVIO DA SILVA',
            CommunityNickname = 'XWEDERSON ',                                               // Nickname
            Title = 'RTV JR',                                                             // Title
            TimeZoneSidKey = 'America/Sao_Paulo',     
            LocaleSidKey = 'en_IN',                                           
            LanguageLocaleKey = 'pt_BR',                                                // Language
            ForecastEnabled = false,                                                      // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',  
            Territory__c = 'Araxá',                                             // Territory
            EnableDepot__c = false,                                                       // Enable Depot
            Show_List_Value__c = false,                                                   // Show List Value (Brazil)
            Show_Credit_Limit__c = false,                                                 // Show Credit Limit
            Show_Inventory__c = false,                                                    // Show Inventory
            Show_Pricing__c = false,                                                      // Show Pricing
            Show_Inventory_Column__c = false,                                             // Show Inventory Column
            Show_InTransit__c = false,                                                    // Show InTransit
            Show_InTransit_Values__c = false                                             // Show InTransit Values
        );
        insert userTerMan;
        
        
        
        
        Territory_Distributor__c territory= new Territory_Distributor__c();
        territory.Name='Araxá';
        territory.TerritoryCode__c='BR165';
        territory.SBU__c =sbu.Id;     
        territory.Region__c=region.id;
        territory.SalesOrg__c=sorg.Id;
        territory.RegionDesciption__c = 'BR1001102 CHPS';                       
        territory.Zone__c=zone.Id;
        territory.TerritoryManager__c = userTerMan.Id;
        insert territory;
        
        
        Division__c div = new Division__c();
        div.Name='Decco';
        div.Description__c='Decco';
        div.Division_Code__c = 'DC';
        insert div;      
        
        
        Price_Book__c pbook= new Price_Book__c();
        pbook.Name='BRL : Price List [DO NOT MODIFY]';
        pbook.Division__c=div.Id;
        pbook.Valid_From__c=system.today();
        pbook.Expiry_Date__c=system.today()+360;
        insert pbook;
        
        Distribution_Channel__c dChannel= new Distribution_Channel__c();
        dChannel.Name='10';
        dChannel.Distribution_Channel_Code__c = '10';
        
        insert dChannel;
        
        Payment_Method__c pMethod = new Payment_Method__c();
        pMethod.Name='Credit Rule';
        pMethod.Payment_Method_Code__c='I';
        //  pMethod.Distribution_Channel__c=dChannel.id;
        //  pMethod.Division__c=div.Id;
        pMethod.Sales_Org__c=sorg.Id;
        pMethod.Active__c=True;
        insert pMethod;
        
        Inco_Term__c inco = new Inco_Term__c();
        inco.Name='CIF';
        inco.IncoTerm_Code__c='CIF';
        inco.IncoTerm_Desc__c='Custo, seguro & frete';
        inco.Sales_Org__c=sorg.Id;
        inco.Division__c=div.Id;
        inco.Distribution_Channel__c=dChannel.Id;
        inco.Active__c=true;
        insert inco;
        
        Price_Book_Sales_District__c pbsd=new Price_Book_Sales_District__c();
        pbsd.Price_Book__c=pbook.Id;
        pbsd.Sales_District1__c=region.Id;
        insert pbsd;
        
        //account details  
        Account acc = new Account();
        acc.Name='LEONARDO PASSINATO';
        acc.Email__c = 'ganesh039@gmail.com';
        acc.Last_Name__c='PASSINATO';
        acc.SAP_Code__c='2028843';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='9967341759';
        acc.Phone='01234567891';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Div.Id;
        acc.Distribution_Channel__c=dChannel.Id;
        acc.BillingCity='MINEIROS';
        acc.SAP_Code__c='2028843';
        acc.Depot_Code__c=dep.Id;
        acc.Tax_Number_3__c='114415455';
        acc.Tax_Number_1__c='114414523';
        acc.Customer_Region__c='AC';
        acc.Customer_Group__c='001';
        acc.Program_Margin_Discount__c=0.00;
        acc.Active__c=true;
        acc.Search_Terms_1__c='LEONARDO PASSINATO';
        acc.Search_Terms_2__c='FAZ SEUBAK';
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name='LEONARDO DICAPRIO';
        acc1.Email__c = 'ganesh0539@gmail.com';
        acc1.Last_Name__c='DECAPRIO';
        acc1.SAP_Code__c='2028844';
        acc1.RecordTypeId=devRecordTypeId;
        acc1.Mobile__c='9967341759';
        acc1.Phone='01234567891';
        acc1.Sales_Org__c=sorg.Id;
        acc1.Division__c=Div.Id;
        acc1.Distribution_Channel__c=dChannel.Id;
        acc1.BillingCity='MINEIROS';
        acc1.Depot_Code__c=dep.Id;
        acc1.Tax_Number_3__c='114415456';
        acc1.Tax_Number_1__c='114445896';
        acc1.Customer_Region__c='AC';
        acc1.Customer_Group__c='675';
        acc1.Program_Margin_Discount__c=0.00;
        acc1.Active__c=true;
        acc1.Search_Terms_1__c='LEONARDO DICAPRIO';
        acc1.Search_Terms_2__c='FAZ SEUBAK1';
        insert acc1;
        
        
        Account acc2 = new Account();
        acc2.Name='SK INTERNATIONAL';
        acc2.Email__c = 'ganesh0339@gmail.com';
        acc2.Last_Name__c='INTERNATIONAL';
        acc2.SAP_Code__c='2028845';
        acc2.RecordTypeId=devRecordTypeId;
        acc2.Mobile__c='9967341759';
        acc2.Phone='01234567891';
        acc2.Sales_Org__c=sorg.Id;
        acc2.Division__c=Div.Id;
        acc2.Distribution_Channel__c=dChannel.Id;
        acc2.BillingCity='MINEIROS';
        acc2.Depot_Code__c=dep.Id;
        acc2.Tax_Number_3__c='114415457';
        acc2.Tax_Number_1__c='114411425';
        acc2.Customer_Region__c='AC';
        acc2.Customer_Group__c='005';
        acc2.Program_Margin_Discount__c=0.00;
        acc2.Active__c=true;
        acc2.Search_Terms_1__c='SK INTERNATIONAL';
        acc2.Search_Terms_2__c='FAZ SEUBAK2';
        insert acc2;
        
        
        //Account and region mapping record
        Customer_and_Region_Mapping__c custRegMap = new Customer_and_Region_Mapping__c(
            Customer_Name__c = acc2.Id, // Customer Name
            CustomerRegion__c = territory.Id,  // Customer Region
            Active__c = true                       // Active
        );
        insert custRegMap;
        
        
        
        
        
        
        Business_Rule__c BusinessRule = new Business_Rule__c(
            Name = 'GR NUTRIÇÂO',              // Business Rule Name
            Sales_Org__c = sorg.Id,            // Sales Org
            Taxes__c = 30.00,                  // Taxes
            Total_Order_Margin__c = 45.00,     // Total Order Margin >=
            Freight__c = 6.90,                 // Freight
            List_Price_Discount__c = 5.00
            // Default__c = true                    // List Price Discount <=
        );
        insert BusinessRule;
        
        
        
        Associate_Group__c asGroup = new Associate_Group__c(
            Name = 'Sales Person',               // Name
            Business_Rule__c = BusinessRule.Id  // Business Rule
        );
        insert asGroup;
        
        
        Employee_Details__c EmpDetail = new Employee_Details__c(
            User__c = userTerMan.Id,          
            Associate_Group__c = asGroup.Id 
        );
        insert EmpDetail;
        
        
        Associate_Group__c asGroupSDM = new Associate_Group__c(
            Name = 'Sales District',               // Name
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
            Name = 'Director',                // Business Rule Name
            Taxes__c = 2.14,                   // Taxes (%)
            Total_Order_Margin__c = 0.00,      // Total Order Margin >=
            Freight__c = 1.29,                 // Freight (%)
            List_Price_Discount__c = 100.00,   // List Price Discount <=
            Default__c = true,                 // Default
            AppliedFor__c = 'Sales Director'  // Applied For
        );
        insert bRuleSD;
        
        Business_Rule__c bRuleSOM = new Business_Rule__c(
            Name = 'BU Gerente',                   // Business Rule Name
            Taxes__c = 2.14,                         // Taxes (%)
            Total_Order_Margin__c = 40.00,           // Total Order Margin >=
            Freight__c = 1.29,                       // Freight (%)
            List_Price_Discount__c = 5.00,           // List Price Discount <=
            Default__c = true,                       // Default
            AppliedFor__c = 'Sales Office Manager'  // Applied For
        );
        insert bRuleSOM;
        
        Business_Rule__c bRuleSDM = new Business_Rule__c(
            Name = 'Gerente',                        // Business Rule Name
            Taxes__c = 20.00,                          // Taxes (%)
            Total_Order_Margin__c = 20.00,             // Total Order Margin >=
            Freight__c = 20.00,                        // Freight (%)
            List_Price_Discount__c = 20.00,            // List Price Discount <=
            Default__c = true,                         // Default
            AppliedFor__c = 'Sales District Manager'  // Applied For
        );
        insert bRuleSDM;
        
        Business_Rule__c bRuleSP = new Business_Rule__c(
            Name = 'Sales Person',             // Business Rule Name
            Taxes__c = 52.00,                // Taxes (%)
            Total_Order_Margin__c = 60.00,   // Total Order Margin >=
            Freight__c = 12.00,              // Freight (%)
            List_Price_Discount__c = 85.00,  // List Price Discount <=
            Default__c = true,               // Default
            AppliedFor__c = 'Sales Person'  // Applied For
        );
        insert bRuleSP;
        
        
        //default business rule end
        
        
        
        
        
        ExchangeRate__c ExchngRte = new ExchangeRate__c(
            FromCurrency__c = 'USD',                                 // From Currency
            ToCurrency__c = 'BRL',                                   // To Currency
            ExchangeRate__c = 3.45 ,                                 // Exchange Rate
            UpdatedDate__c = system.today()+45                       // Updated Date
        );
        insert ExchngRte;
        
        
        
        SKU__c skuRecord = new SKU__c(
            Name = 'a1C0k000000A1ug',                                // SKU Name
            SKU_Code__c = '000000000006302802',                      // SKU Code
            SKU_Description__c = 'MANZATE 800WP 25KG PAPER BAG_BR',  // SKU Description
            UOM__c = 'KG',
            Division__c = div.Id,                                    // Division
            Sales_Org__c = sorg.Id,                                  // Sales Org
            Multiple_of__c = 25.00,                                  // Multiple Of
            Combination_Key__c = '519110000000000006302802',         // Combination Key
            Active__c = true                                         // Active
        );
        insert skuRecord;
        
        
        
        
        
        
        Material_Plant_Relation__c MPRelation = new Material_Plant_Relation__c(
            Name = 'MANZATE 800WP 25KG PAPER BAG_BR',              // Material Plant Relation Name
            Material_Code__c = '000000000006302802',               // Material Code
            Active__c = true,                                      // Active
            Material_Desc__c = 'MANZATE 800WP 25KG PAPER BAG_BR',  // Material Desc
            Depot__c =dep.Id,                        
            Material_Ledger_Cost__c = 13.26,                       // Material Ledger Cost
            MC_Currency__c = 'BRL',                                // MC Currency
            Replacement_Cost__c = 2.10,                            // Replacement Cost
            RC_Currency__c = 'USD',                                // RC Currency
            SKU__c = skuRecord.Id,                        
            Sales_Org__c =sorg.Id                      
        );
        insert MPRelation;
        
        Culture__c culture = new Culture__c(
            Name = 'Algodão',                  // Culture Name
            Culture_Code__c = 'B01',           // Culture Code
            Culture_Desc__c = 'Algodão',       // Culture Desc
            Distribution_Channel__c = dChannel.Id,    // Distribution Channel
            Active__c = true,                 
            Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id 
        );
        insert culture;
        
        
        Payment_Term__c payTerm = new Payment_Term__c(
            Payment_Term_Code__c = '28',                       
            Payterms_Desc__c = 'dentro de 90 dias s/desconto', 
            Sales_Org__c = sorg.Id,                            
            Days_to_calc_interest__c = 0,                     
            Maturity_Date_Mandatory__c = 'Yes',                 
            Active__c = true                                   
        );
        insert payTerm;
        
        Material_Registration__c matReg = new Material_Registration__c(
            Name = '2,4-D NORTOX 1X20L',                   
            Effective_From__c =  Date.newInstance(2010,10,10),  
            Effective_To__c = Date.newInstance(2020,10,10),    
            Sales_Org__c = sorg.Id,                        
            State__c = 'AC',                               
            SKU__c = skuRecord.Id,                         
            SKU_Reg_Code__c = '5250109'                     
        );
        insert matReg;
        
        Price_Book_Details__c PBdetails = new Price_Book_Details__c(
            SKU__c =skuRecord.Id,                    
            Monthly_Interest_Rate__c = 1.00,         
            Price_Book__c = pbook.Id,               
            Exchange_Rate__c = 3.00,                
            Unit_Price__c = 120.00,                 
            Minimum_Price__c = 75.00,               
            Sales_District1__c = region.Id          
        );
        insert PBdetails;
      //  User Sp = [SELECT Id FROM User WHERE profileId IN (SELECT id FROM Profile WHERE Name = 'Brazil Sales Person') AND isActive = true AND LastName ='FLAVIO DA SILVA' LIMIT 1];
        
        Sales_Order__c sobj = new Sales_Order__c(
            OwnerId = userTerMan.Id,
            SFDC_Order_Number__c = '8360',                    // SFDC Order Number
            SAP_Order_Number__c = '7009090604',                // SAP Order Number
            Order_Cancel__c = false,    
            Sales_Org_lk__c=sorg.Id,                            // Order Cancel
            Order_Status__c = 'Not yet processed',             // Order Status
            OrderSubStatus__c = 'Approved',                    // Order Sub-Status
            Region_Territory__c = territory.Id,                 // Region / Territory
            RequestforCancellationCheck__c = false,            // Request for Cancellation
            //  BarterManager__c = BarterUser.Id,
            Flag_Status__c = 'dislike\n',                      // Flag Status
            BrazilOrderSubmittedforApproval__c = true,         // Brazil Order Submitted for Approval
            SalesOfficeManager__c = ZonalHeadUser.Id,         // Sales Office Manager
            Price_Book__c = pbook.Id,                         // Price Book
            SalesDistrictManager__c =  regioHeadUser.Id,   
            Inco_Term__c = inco.Id,
            Currency_Brazil__c = 'Billing USD / Payment USD',  // Currency (Brazil)
            Key_Account__c = false,                            // Key Account
            Sold_to_Party__c = acc1.Id,                        // Sold to Party
            Valid_From__c = system.today(),
            //  PaymentMethod__c = pMethod.Id,// Valid From
            Valid_To__c = system.today()+350,                  // Valid To
            Payment_Term__c = payTerm.Id,                     // Payment Term
            Type_of_Order__c = 'CONTRATO MÃE'                 // Type of Order
        );
        insert sobj;
        
        Sales_Order_Line_Item__c soLineItm = new Sales_Order_Line_Item__c(
            Sale_Order__c = sobj.Id,         // Sale Order
            SKU_Name__c = skuRecord.Id,           // SKU Name
            Item_Number__c = 10,                       // Item Number
            Item_Status__c = 'Not yet processed',      // Item Status
            Item_Cancel__c = false,                    // Item Cancel
            Order_Item_Key__c = '836010',              // OrderNumber_Item_Key
            Sales_Org__c = sorg.Id,          // Sales Org
            PriceBookDetail__c = PBdetails.Id, // Price Book Detail
            Approval_Flag__c = 0,                      // Approval Flag
            ExchangeRate__c = ExchngRte.id,       // Exchange Rate
            OrderQuantityEdited__c = false,            // Order Quantity Edited
            Time_in_months__c = 0,                     // Time in months
            Days__c = 0,                               // Days
            DateofFAT__c =  system.today()+1,
            Quantity__c = 450.00,                      // Quantity
            UnitValue__c = 100.00,                     // Unit Value
            UnitValuewithInterest__c = 100.00,         // Unit Value with Interest
            InterestRate__c = 0.00,                    // Interest Rate
            TotalTax__c = 0.00,                        // Total Tax
            TotalFreight__c = 0.00,                    // Total Freight
            TotalPunctuality__c = 0.00,                // Total Punctuality
            TotalLedgerCost__c = 0.00,                 // Total Ledger Cost
            TotalReplacementCost__c = 0.00            // Total Replacement Cost
        );
        insert soLineItm;    
        //OrderRequestController.getCustomers( sobj.Type_of_Order__c, acc1.Customer_Group__c, acc1.Id);
        //OrderRequestController.getMOPriceBookDetails(pbook.Id,sobj.Id, dep.Id, acc.Customer_Region__c,sobj.Id);
        //system.debug('soId1'+sobj.Id);
        
        
    } 
    
    static testMethod void method2(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name  = 'Brazil Sales Person' LIMIT 1]; 
        
        User userTerMan1 = new User(
            Alias = 'WES',                                                            // Alias
            Email = 'shama11@skinternational.com',                                          // Email
            ProfileId = p.Id,                                                             // Profile
            Username = '20205489@uniphos3.com.upltest',                                    // Username
            IsActive = true,                                                              // Active
            LastName='BARBOSA DErCAMARGO',
            CommunityNickname = 'Xyu ',                                               // Nickname
            Title = 'RuiR',                                                             // Title
            TimeZoneSidKey = 'America/Sao_Paulo',     
            LocaleSidKey = 'en_IN',                                           
            LanguageLocaleKey = 'pt_BR',                                                // Language
            ForecastEnabled = false,                                                      // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',  
            Territory__c = 'Araxá',                                             // Territory
            EnableDepot__c = false,                                                       // Enable Depot
            Show_List_Value__c = false,                                                   // Show List Value (Brazil)
            Show_Credit_Limit__c = false,                                                 // Show Credit Limit
            Show_Inventory__c = false,                                                    // Show Inventory
            Show_Pricing__c = false,                                                      // Show Pricing
            Show_Inventory_Column__c = false,                                             // Show Inventory Column
            Show_InTransit__c = false,                                                    // Show InTransit
            Show_InTransit_Values__c = false ,
            country='Brazil'
        );
        insert userTerMan1;
        
        Sales_org__c sorg=[select Id from Sales_org__c where Sales_Org_Code__c='5191'];
        Account acc = [Select id,Customer_Group__c,Customer_Region__c From Account where Sales_Org__c=:sorg.id AND Last_Name__c='PASSINATO' limit 1]; 
        
        
        
        //User Sp = [SELECT Id FROM User WHERE profileId IN (SELECT id FROM Profile WHERE Name = 'Brazil Sales Person') AND isActive = true AND LastName ='FLAVIO DA SILVA' LIMIT 1];
       
        
        
        Price_Book_Details__c pbdetails1= [select Id,Unit_Price__c,Monthly_Interest_Rate__c,SKU__c from Price_Book_Details__c Limit 1];
        Price_Book__c pricebook=[select Id from Price_Book__c Limit 1];
        Depot__c dep=[select Id from Depot__c where SalesOrg__c=:sorg.Id limit 1]; 
        SKU__c skurec=[select Id,SKU_Description__c,SKU_Code__c,Multiple_of__c from SKU__c limit 1];
        Culture__c culture=[select Id from Culture__c limit 1];
        Material_Registration__c matreg= [select Id, Name, Sales_Org__c, SKU__c, State__c from Material_Registration__c limit 1];
        Inco_Term__c incoTm =[select Id, Name from Inco_Term__c where IncoTerm_Code__c='CIF' limit 1];
        
        
        List<OrderRequestController.SalesOrderItem> solst = new List<OrderRequestController.SalesOrderItem>(); 
        OrderRequestController.SalesOrderItem wrapObj = new OrderRequestController.SalesOrderItem();
        wrapObj.productId = skurec.id;
        wrapObj.fatDate = '02/05/2018';
        wrapObj.qty = 100;
        wrapObj.listValue = 50;
        wrapObj.unitValue = 32;
        wrapObj.unitValueWithInterest = 32; 
        wrapObj.productCode= skurec.SKU_Code__c;
        wrapObj.totalValue =12816;
        wrapObj.interestRate = 0;
        wrapObj.days = 0;
        wrapObj.cultureDesc =culture.Id;
        wrapObj.priceBookDetailId=pbdetails1.Id;
        wrapObj.productName='';
        wrapObj.inventory=0;
        wrapObj.discount=16.35;
        wrapObj.replacementMargin=0;
        wrapObj.ledgerMargin=63.1;
        wrapObj.totalValueWithInterest=0;
        wrapObj.timeInMonths=0;
        wrapObj.multipleOf=0;
        solst.add(wrapObj);
        String serlizeStr = JSON.serialize(solst);  
        
        
        
        
        List<OrderRequestController.PriceDetail> WrapPriceList = new List<OrderRequestController.PriceDetail>(); 
        OrderRequestController.PriceDetail WrapPrice = new OrderRequestController.PriceDetail();
        WrapPrice.skuId = skurec.Id;
        WrapPrice.skuDescription = skurec.SKU_Description__c;
        WrapPrice.unitValue = pbdetails1.Unit_Price__c;
        WrapPrice.pricebookId = pbdetails1.Id;
        WrapPrice.skuCode =skurec.SKU_Code__c;
        WrapPrice.multipleOf = skurec.Multiple_of__c;
        WrapPrice.monthlyInterestRate =pbdetails1.Monthly_Interest_Rate__c ;
        WrapPrice.regState = matreg.State__c;
        WrapPriceList.add(WrapPrice);
        
        List<OrderRequestController.AuditHistory> auditWrapList = new List<OrderRequestController.AuditHistory>(); 
        OrderRequestController.AuditHistory auditWrap = new OrderRequestController.AuditHistory();
        auditWrap.createdDate = System.now();
        auditWrap.stepStatus = '';
        auditWrap.originalActorName = '';
        auditWrap.actorName = '';
        auditWrap.comments ='submitted';      
        auditWrapList.add(auditWrap);
        
        List<OrderRequestController.FlagStatus> flagList = new List<OrderRequestController.FlagStatus>(); 
        OrderRequestController.FlagStatus FlagWrap = new OrderRequestController.FlagStatus();
        FlagWrap.flagMessage = '';
        FlagWrap.flagStatus = '';
        flagList.add(FlagWrap);
        
        
        
        List<OrderRequestController.SOMBalance> SOMlist = new List<OrderRequestController.SOMBalance>(); 
        OrderRequestController.SOMBalance wrapSOM = new OrderRequestController.SOMBalance();
        wrapSOM.productId=skurec.Id;
        wrapSOM.product = skurec.SKU_Description__c ;
        wrapSOM.quantity = '3425';
        wrapSOM.balance = '5';
        wrapSOM.percent ='21' ;
        SOMlist.add(wrapSOM);
        
        Sales_Order__c soChild = new Sales_Order__c();
        soChild.Type_of_Order__c = 'VENDA NORMAL';                 // Type of Order
        soChild.Currency_Brazil__c = 'Billing USD / Payment USD';  // Currency (Brazil)
        soChild.Valid_From__c =System.today();          // Valid From
        soChild.BrazilOrderSubmittedforApproval__c = true;         // Brazil Order Submitted for Approval
        soChild.Valid_To__c = System.today()+365;          // Valid To
        soChild.PONumber__c  ='qweet';    
        soChild.Inco_Term__c =incotm.Id;
        soChild.Key_Account__c = false;  
        soChild.Purchase_Order_Date__c = System.today()+5;
        soChild.Business_Discount__c = 0.00;                      // Business Discount
        soChild.Financial_Discount__c = 0.00;                     // Financial Discount
        soChild.Sold_to_Party__c = acc.Id;       // Sold to Party
        
        
        System.runAs(userTerMan1) {
            OrderRequestController.getOrderFields();   
            OrderRequestController.getBusinessRule(soChild.Id, userTerMan1.Id);
             OrderRequestController.getKeyCustomers(userTerMan1.Id,soChild.Type_of_Order__c, acc.Customer_Group__c, acc.Id);
            //OrderRequestController.getSOM();
            //OrderRequestController.getCustomers( soChild.Type_of_Order__c, acc.Customer_Group__c, acc.Id);
         
            
            
        }
    }
    static testMethod void method3(){
        
        
         Profile p = [SELECT Id FROM Profile WHERE Name  = 'Brazil Sales Person' LIMIT 1]; 
        
        User userTerMan1 = new User(
            Alias = 'WES',                                                            // Alias
            Email = 'shama11@skinternational.com',                                          // Email
            ProfileId = p.Id,                                                             // Profile
            Username = '20205489@uniphos3.com.upltest',                                    // Username
            IsActive = true,                                                              // Active
            LastName='BARBOSA DErCAMARGO',
            CommunityNickname = 'Xyu ',                                               // Nickname
            Title = 'RuiR',                                                             // Title
            TimeZoneSidKey = 'America/Sao_Paulo',     
            LocaleSidKey = 'en_IN',                                           
            LanguageLocaleKey = 'pt_BR',                                                // Language
            ForecastEnabled = false,                                                      // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',  
            Territory__c = 'Araxá',                                             // Territory
            EnableDepot__c = false,                                                       // Enable Depot
            Show_List_Value__c = false,                                                   // Show List Value (Brazil)
            Show_Credit_Limit__c = false,                                                 // Show Credit Limit
            Show_Inventory__c = false,                                                    // Show Inventory
            Show_Pricing__c = false,                                                      // Show Pricing
            Show_Inventory_Column__c = false,                                             // Show Inventory Column
            Show_InTransit__c = false,                                                    // Show InTransit
            Show_InTransit_Values__c = false ,
            country='Brazil'
        );
        insert userTerMan1;
        
        Sales_org__c sorg=[select Id from Sales_org__c where Sales_Org_Code__c='5191'];
        Account acc2 = [Select id,Customer_Group__c,Customer_Region__c From Account where Sales_Org__c=:sorg.id AND Last_Name__c='INTERNATIONAL' limit 1]; 
        Sales_Order__c soMother = [Select id,Type_of_Order__c From Sales_Order__c where SalesOrgCode__c = '5191' AND Type_of_Order__c = 'CONTRATO MÃE' limit 1];
        
       // User Sp = [SELECT Id FROM User WHERE profileId IN (SELECT id FROM Profile WHERE Name = 'Brazil Sales Person') AND isActive = true AND LastName ='FLAVIO DA SILVA' LIMIT 1];
      
        
        Price_Book_Details__c pbdetails1= [select Id,Unit_Price__c,Monthly_Interest_Rate__c,SKU__c from Price_Book_Details__c Limit 1];
        Price_Book__c pricebook=[select Id from Price_Book__c Limit 1];
        Depot__c dep=[select Id from Depot__c where SalesOrg__c=:sorg.Id limit 1]; 
        SKU__c skurec=[select Id,SKU_Description__c,SKU_Code__c,Multiple_of__c from SKU__c limit 1];
        Culture__c culture=[select Id from Culture__c limit 1];
        Material_Registration__c matreg= [select Id, Name, Sales_Org__c, SKU__c, State__c from Material_Registration__c limit 1];
        Inco_Term__c incoTm =[select Id, Name from Inco_Term__c where IncoTerm_Code__c='CIF' limit 1];

        
        Sales_Order__c so2 = new Sales_Order__c();
        SO2.Sales_Order__c=soMother.Id;
        so2.Type_of_Order__c = 'ORDEM FILHA';                 // Type of Order
        so2.Currency_Brazil__c = 'Billing USD / Payment USD';  // Currency (Brazil)
        so2.Valid_From__c =System.today();          // Valid From
        so2.BrazilOrderSubmittedforApproval__c = true;         // Brazil Order Submitted for Approval
        so2.Valid_To__c = System.today()+365;          // Valid To
        so2.PONumber__c  ='qweet1';    
        so2.Inco_Term__c =incotm.Id;
        so2.Key_Account__c = false;  
        so2.Purchase_Order_Date__c = System.today()+5;
        so2.Business_Discount__c = 0.00;                      // Business Discount
        so2.Financial_Discount__c = 0.00;                     // Financial Discount
        so2.Sold_to_Party__c = acc2.Id;       // Sold to Party
        
        List<OrderRequestController.SalesOrderItem> solst = new List<OrderRequestController.SalesOrderItem>(); 
        OrderRequestController.SalesOrderItem wrapObj = new OrderRequestController.SalesOrderItem();
        wrapObj.productId = skurec.id;
        wrapObj.fatDate = '02/05/2018';
        wrapObj.qty = 50;
        wrapObj.listValue = 50;
        wrapObj.unitValue = 32;
        wrapObj.unitValueWithInterest = 32;
        wrapObj.productCode= skurec.SKU_Code__c;
        wrapObj.totalValue =12816;
        wrapObj.interestRate = 0;
        wrapObj.days = 0;
        wrapObj.cultureDesc =culture.Id;
        wrapObj.priceBookDetailId=pbdetails1.Id;
        wrapObj.productName='';
        wrapObj.inventory=0;
        wrapObj.discount=16.35;
        wrapObj.replacementMargin=0;
        wrapObj.ledgerMargin=63.1;
        wrapObj.totalValueWithInterest=0;
        wrapObj.timeInMonths=0;
        wrapObj.multipleOf=0;
        solst.add(wrapObj);
        String serlizeStr = JSON.serialize(solst);  
        
        System.runAs(userTerMan1) {
            Territory_Distributor__c tdObj = [Select Id From Territory_Distributor__c WHERE TerritoryCode__c='BR165'];
            tdObj.TerritoryManager__c = userTerMan1.Id;
            update tdObj;
            OrderRequestController.getOrderFields();  
            //OrderRequestController.getCustomers( so2.Type_of_Order__c, acc2.Customer_Group__c, acc2.Id);
            OrderRequestController.getKeyCustomers(userTerMan1.Id, so2.Type_of_Order__c, acc2.Customer_Group__c,acc2.Id);
            OrderRequestController.saveSalesOrder(so2, serlizeStr, false, false);
            OrderRequestController.getBusinessRule(so2.Id, userTerMan1.Id);
            
            
            
        }
    }
    
   /* static testMethod void method4(){
        
         Profile p = [SELECT Id FROM Profile WHERE Name  = 'Brazil Sales Person' LIMIT 1]; 
        
        User userTerMan1 = new User(
            Alias = 'WES',                                                            // Alias
            Email = 'shama11@skinternational.com',                                          // Email
            ProfileId = p.Id,                                                             // Profile
            Username = '20205489@uniphos3.com.upltest',                                    // Username
            IsActive = true,                                                              // Active
            LastName='BARBOSA DErCAMARGO',
            CommunityNickname = 'Xyu ',                                               // Nickname
            Title = 'RuiR',                                                             // Title
            TimeZoneSidKey = 'America/Sao_Paulo',     
            LocaleSidKey = 'en_IN',                                           
            LanguageLocaleKey = 'pt_BR',                                                // Language
            ForecastEnabled = false,                                                      // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',  
            Territory__c = 'Araxá',                                             // Territory
            EnableDepot__c = false,                                                       // Enable Depot
            Show_List_Value__c = false,                                                   // Show List Value (Brazil)
            Show_Credit_Limit__c = false,                                                 // Show Credit Limit
            Show_Inventory__c = false,                                                    // Show Inventory
            Show_Pricing__c = false,                                                      // Show Pricing
            Show_Inventory_Column__c = false,                                             // Show Inventory Column
            Show_InTransit__c = false,                                                    // Show InTransit
            Show_InTransit_Values__c = false ,
            country='Brazil'
        );
        insert userTerMan1;
        
        Sales_org__c sorg=[select Id from Sales_org__c where Sales_Org_Code__c='5191'];
        Account acc2 = [Select id,Customer_Group__c,Customer_Region__c From Account where Sales_Org__c=:sorg.id AND Last_Name__c='INTERNATIONAL' limit 1]; 
        
       // User Sp = [SELECT Id FROM User WHERE profileId IN (SELECT id FROM Profile WHERE Name = 'Brazil Sales Person') AND isActive = true AND LastName ='FLAVIO DA SILVA' LIMIT 1];
       
        
        Price_Book_Details__c pbdetails1= [select Id,Unit_Price__c,Monthly_Interest_Rate__c,SKU__c from Price_Book_Details__c Limit 1];
        Price_Book__c pricebook=[select Id from Price_Book__c Limit 1];
        Depot__c dep=[select Id from Depot__c where SalesOrg__c=:sorg.Id limit 1]; 
        SKU__c skurec=[select Id,SKU_Description__c,SKU_Code__c,Multiple_of__c from SKU__c limit 1];
        Culture__c culture=[select Id from Culture__c limit 1];
        Material_Registration__c matreg= [select Id, Name, Sales_Org__c, SKU__c, State__c from Material_Registration__c limit 1];
        Inco_Term__c incoTm =[select Id, Name from Inco_Term__c where IncoTerm_Code__c='CIF' limit 1];

        
        Sales_Order__c so2 = new Sales_Order__c();
        
        so2.Type_of_Order__c = 'VENDA NORMAL';                 // Type of Order
        so2.Currency_Brazil__c = 'Billing USD / Payment USD';  // Currency (Brazil)
        so2.Valid_From__c =System.today();          // Valid From
        so2.BrazilOrderSubmittedforApproval__c = true;         // Brazil Order Submitted for Approval
        so2.Valid_To__c = System.today()+365;          // Valid To
        so2.PONumber__c  ='qweet1';    
        so2.Inco_Term__c =incotm.Id;
        so2.Key_Account__c = false;  
        so2.Purchase_Order_Date__c = System.today()+5;
        so2.Business_Discount__c = 0.00;                      // Business Discount
        so2.Financial_Discount__c = 0.00;                     // Financial Discount
        so2.Sold_to_Party__c = acc2.Id;       // Sold to Party
        
        List<OrderRequestController.SalesOrderItem> solst = new List<OrderRequestController.SalesOrderItem>(); 
        OrderRequestController.SalesOrderItem wrapObj = new OrderRequestController.SalesOrderItem();
        //  wrapObj.productId = skurec.id;
        wrapObj.fatDate = '02/05/2018';
        wrapObj.qty = 50;
        wrapObj.listValue = 50;
        wrapObj.unitValue = 32;
        wrapObj.unitValueWithInterest = 32;
        wrapObj.productCode= skurec.SKU_Code__c;
        wrapObj.totalValue =12816;
        wrapObj.interestRate = 0;
        wrapObj.days = 0;
        wrapObj.cultureDesc =culture.Id;
        wrapObj.priceBookDetailId=pbdetails1.Id;
        wrapObj.productName='';
        wrapObj.inventory=0;
        wrapObj.discount=16.35;
        wrapObj.replacementMargin=0;
        wrapObj.ledgerMargin=63.1;
        wrapObj.totalValueWithInterest=0;
        wrapObj.timeInMonths=0;
        wrapObj.multipleOf=0;
        solst.add(wrapObj);
        String serlizeStr = JSON.serialize(solst);  
        
        System.runAs(userTerMan1) {
            Territory_Distributor__c tdObj = [Select Id From Territory_Distributor__c WHERE TerritoryCode__c='BR165'];
            tdObj.TerritoryManager__c = userTerMan1.Id;
            update tdObj;
            OrderRequestController.getOrderFields();  
            OrderRequestController.getCustomers( so2.Type_of_Order__c, acc2.Customer_Group__c, acc2.Id);
            OrderRequestController.getKeyCustomers(userTerMan1.Id, so2.Type_of_Order__c, acc2.Customer_Group__c,acc2.Id);
            OrderRequestController.saveSalesOrder(so2, serlizeStr, false, false);
            OrderRequestController.getBusinessRule(so2.Id, userTerMan1.Id);
            
        }
    }*/
}