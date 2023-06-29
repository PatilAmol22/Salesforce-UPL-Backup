@isTest
private class TravelExpensesTest {
    
    @testSetup
    static void allTheDataForThisTestClass() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name  = 'Territory Manager Indonesia' LIMIT 1];                     //Indonesia Profile
        Profile p1 = [SELECT Id FROM Profile WHERE Name  = 'National sales Manager indonesia' LIMIT 1];                     //NSM Profile
        Profile p2 = [SELECT Id FROM Profile WHERE Name  = 'Regional/Zonal Indonesia' LIMIT 1];                     //RM Profile
        Profile p3 = [SELECT Id FROM Profile WHERE Name  = 'Sales Head Indonesia' LIMIT 1];                     //CH Profile
        
        
        User tm_user = new User(
            Alias = 'dasw',                                                         // Alias
            Email = 'abc@skinternational.com',                                  // Email
            ProfileId = p.Id,                                                       // Profile
            Username = 'daswir364123@.com.upltest', 
            LastName='daswir',// lastname
            IsActive = true,                                                             // Active
            CommunityNickname = 'Daswir Display54457',  // Nickname
            Title = 'SALES EXECUTIVE',                                                   // Title
            TimeZoneSidKey = 'Asia/Kolkata',           // Time Zone
            LocaleSidKey = 'en_IN',                                            // Locale
            LanguageLocaleKey = 'en_US',                                               // Language
            ForecastEnabled = false,                                                     // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',  // Email Encoding


            SAP_User_Password__c = 'init123',                                            // SAP User Password
            Territory__c = 'Dhule',                                                      // Territory
            Zone__c = 'Indonesia',                                                       // Zone
            EnableDepot__c = true,                                                       // Enable Depot
            Show_List_Value__c = false,                                                  // Show List Value (Brazil)
            Show_Credit_Limit__c = true,                                                 // Show Credit Limit
            Show_Inventory__c = false,                                                   // Show Inventory
            Show_Pricing__c = false,                                                     // Show Pricing
            Show_Inventory_Column__c = true,                                             // Show Inventory Column
            Show_InTransit__c = false,                                                   // Show InTransit
            Show_InTransit_Values__c = false                                            // Show InTransit Values
        );
        insert tm_user;
        
        User nsm_user = new User(
            Alias = 'RAJESHJA',                                                                 // Alias
            Email = 'abc2@skinternational.com',                                         // Email
            ProfileId = p1.Id,                                                              // Profile
            Username = 'manish3607832@com.upltest',    
            LastName='manish',// lastname// Username
            IsActive = true,                                                                    // Active
            CommunityNickname = 'RAJESH.JADHAV123456',  // Nickname
            Title = 'Regional Manager',                                                         // Title
            TimeZoneSidKey = 'Asia/Kolkata',                  // Time Zone
            LocaleSidKey = 'en_IN',                                                   // Locale
            LanguageLocaleKey = 'en_US',                                                      // Language
            ForecastEnabled = false,                                                            // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',         // Email Encoding


            SAP_User_Password__c = 'init123',                                                   // SAP User Password
            Territory__c = 'Pune',                                                              // Territory
            Zone__c = 'Indonesia',                                                              // Zone
            EnableDepot__c = true,                                                              // Enable Depot
            Show_List_Value__c = false,                                                         // Show List Value (Brazil)
            Show_Credit_Limit__c = true,                                                        // Show Credit Limit
            Show_Inventory__c = true,                                                           // Show Inventory
            Show_Pricing__c = false,                                                            // Show Pricing
            Show_Inventory_Column__c = true,                                                    // Show Inventory Column
            Show_InTransit__c = true,                                                           // Show InTransit
            Show_InTransit_Values__c = true                                                    // Show InTransit Values
        );
        insert nsm_user;
        
        User rm_user = new User(
            Alias = 'vipi',                                                              // Alias
            Email = 'abc3@skinternational.com',                                  // Email
            ProfileId = P2.Id,                                                       // Profile
            Username = 'test21874@com.upltest',
            LastName='test',// lastname
            IsActive = true,                                                             // Active
            CommunityNickname = 'Vipin Display65432',   // Nickname
            Title = 'SALES EXECUTIVE',                                                   // Title
            TimeZoneSidKey = 'Asia/Kolkata',           // Time Zone
            LocaleSidKey = 'en_IN',                                            // Locale
            LanguageLocaleKey = 'en_US',                                               // Language
            ForecastEnabled = false,                                                     // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',  // Email Encoding


            SAP_User_Password__c = 'init123',                                            // SAP User Password
            Territory__c = 'Wardha',                                                     // Territory
            Zone__c = 'Indonesia',                                                       // Zone
            EnableDepot__c = true,                                                       // Enable Depot
            Show_List_Value__c = false,                                                  // Show List Value (Brazil)
            Show_Credit_Limit__c = true,                                                 // Show Credit Limit
            Show_Inventory__c = false,                                                   // Show Inventory
            Show_Pricing__c = false,                                                     // Show Pricing
            Show_Inventory_Column__c = true,                                             // Show Inventory Column
            Show_InTransit__c = false,                                                   // Show InTransit
            Show_InTransit_Values__c = false                                            // Show InTransit Values
        );
        insert rm_user;
        
        User ch_user = new User(
            Alias = 'SACHINJA',                                                                 // Alias
            Email = 'abc4@skinternational.com',                                         // Email
            ProfileId = p3.Id,                                                              // Profile
            Username = 'devendra3608421@ab.com.upltest',
             LastName='devendra',// lastname
            IsActive = true,                                                                    // Active
            CommunityNickname = 'SACHIN.JADHAV5434567',  // Nickname
            Title = 'SALES EXECUTIVE',                                                          // Title
            TimeZoneSidKey = 'Asia/Kolkata',                  // Time Zone
            LocaleSidKey = 'en_IN',                                                   // Locale
            LanguageLocaleKey = 'en_US',                                                      // Language
            ForecastEnabled = false,                                                            // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',         // Email Encoding

          
            SAP_User_Password__c = 'init123',                                                   // SAP User Password
            Territory__c = 'Pimpalgaon(B)',                                                     // Territory
            Zone__c = 'Indonesia',                                                              // Zone
            EnableDepot__c = true,                                                              // Enable Depot
            Show_List_Value__c = false,                                                         // Show List Value (Brazil)
            Show_Credit_Limit__c = true,                                                        // Show Credit Limit
            Show_Inventory__c = true,                                                           // Show Inventory
            Show_Pricing__c = false,                                                            // Show Pricing
            Show_Inventory_Column__c = true,                                                    // Show Inventory Column
            Show_InTransit__c = false,                                                          // Show InTransit
            Show_InTransit_Values__c = false                                                   // Show InTransit Values
        );
        insert ch_user;
        
        Monthly_Travel_Expense__c monthly_travel_expense_obj1 = new Monthly_Travel_Expense__c(
            Month__c = 'MAR 2018',                      // Month
            RegionalManager__c = rm_user.Id,       // Regional Manager
            NationalSalesManager__c = nsm_user.Id,  // National Sales Manager
            CountryHead__c = ch_user.Id           // Country Head
        );
        insert monthly_travel_expense_obj1;
        
        Monthly_Travel_Expense__c monthly_travel_expense_obj2 = new Monthly_Travel_Expense__c(
            Month__c = 'MAR 2019',                      // Month
            RegionalManager__c = rm_user.Id,       // Regional Manager
            NationalSalesManager__c = nsm_user.Id,  // National Sales Manager
            CountryHead__c = ch_user.Id           // Country Head
        );
        insert monthly_travel_expense_obj2;
        
        Expense_Item__c expense_item_obj1 = new Expense_Item__c(
            Item__c = 'BUSINESS MEAL - BASE ON BILL',      // Item
            Amount__c = 66.00,                               // Amount
            Date__c = System.today(),             // Travel Date
            Location__c = 'sajdjs',                          // Location
            Purpose__c = 'sadkk',                            // Purpose
            Monthly_Travel_Expenses__c = monthly_travel_expense_obj1.Id,  // Monthly Travel Expense
            Month__c = 'MAR 2018'                           // Month
        );
        insert expense_item_obj1;
        
        Expense_Item__c expense_item_obj2 = new Expense_Item__c(
            Item__c = 'BUSINESS MEAL - BASE ON BILL',      // Item
            Amount__c = 66.00,                               // Amount
            Date__c = System.today(),             // Travel Date
            Location__c = 'sajdjs',                          // Location
            Purpose__c = 'sadkk',                            // Purpose
            Monthly_Travel_Expenses__c = monthly_travel_expense_obj2.Id,  // Monthly Travel Expense
            Month__c = 'MAR 2019'                           // Month
        );
        insert expense_item_obj2;
        
        Monthly_Travel_Expense__c monthly_travel_expense_obj = new Monthly_Travel_Expense__c(
            Month__c = 'MAR 2017',                      // Month
            RegionalManager__c = rm_user.Id,       // Regional Manager
            NationalSalesManager__c = nsm_user.Id,  // National Sales Manager
            CountryHead__c = ch_user.Id           // Country Head
        );
        insert monthly_travel_expense_obj;
        
        Expense_Item__c expense_item_obj = new Expense_Item__c(
            Item__c = 'BUSINESS MEAL - BASE ON BILL',      // Item
            Amount__c = 66.00,                               // Amount
            Date__c = System.today(),             // Travel Date
            Location__c = 'sajdjs',                          // Location
            Purpose__c = 'sadkk',                            // Purpose
            Monthly_Travel_Expenses__c = monthly_travel_expense_obj.Id,  // Monthly Travel Expense
            Month__c = 'MAR 2017'                           // Month
        );
        insert expense_item_obj;
        
    }
    
    static testMethod void method2(){
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name  = 'National sales Manager indonesia' LIMIT 1];                     //NSM Profile
        Profile p2 = [SELECT Id FROM Profile WHERE Name  = 'Regional/Zonal Indonesia' LIMIT 1];                     //RM Profile
        Profile p3 = [SELECT Id FROM Profile WHERE Name  = 'Sales Head Indonesia' LIMIT 1];                     //CH Profile
        
        User nsm_user = new User(
            Alias = 'RAJESHJA',                                                                 // Alias
            Email = 'abc2@skinternational.com',                                         // Email
            ProfileId = p1.Id,                                                              // Profile
            Username = 'manish36078321@com.upltest',    
            LastName='manish',// lastname// Username
            IsActive = true,                                                                    // Active
            CommunityNickname = 'RAJESH.JADHAV12345',  // Nickname
            Title = 'Regional Manager',                                                         // Title
            TimeZoneSidKey = 'Asia/Kolkata',                  // Time Zone
            LocaleSidKey = 'en_IN',                                                   // Locale
            LanguageLocaleKey = 'en_US',                                                      // Language
            ForecastEnabled = false,                                                            // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',         // Email Encoding


            SAP_User_Password__c = 'init123',                                                   // SAP User Password
            Territory__c = 'Pune',                                                              // Territory
            Zone__c = 'Indonesia',                                                              // Zone
            EnableDepot__c = true,                                                              // Enable Depot
            Show_List_Value__c = false,                                                         // Show List Value (Brazil)
            Show_Credit_Limit__c = true,                                                        // Show Credit Limit
            Show_Inventory__c = true,                                                           // Show Inventory
            Show_Pricing__c = false,                                                            // Show Pricing
            Show_Inventory_Column__c = true,                                                    // Show Inventory Column
            Show_InTransit__c = true,                                                           // Show InTransit
            Show_InTransit_Values__c = true                                                    // Show InTransit Values
        );
        insert nsm_user;
        
        User rm_user = new User(
            Alias = 'vipi',                                                              // Alias
            Email = 'abc3@skinternational.com',                                  // Email
            ProfileId = P2.Id,                                                       // Profile
            Username = 'test218741@com.upltest',
            LastName='test',// lastname
            IsActive = true,                                                             // Active
            CommunityNickname = 'Vipin Display6543',   // Nickname
            Title = 'SALES EXECUTIVE',                                                   // Title
            TimeZoneSidKey = 'Asia/Kolkata',           // Time Zone
            LocaleSidKey = 'en_IN',                                            // Locale
            LanguageLocaleKey = 'en_US',                                               // Language
            ForecastEnabled = false,                                                     // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',  // Email Encoding


            SAP_User_Password__c = 'init123',                                            // SAP User Password
            Territory__c = 'Wardha',                                                     // Territory
            Zone__c = 'Indonesia',                                                       // Zone
            EnableDepot__c = true,                                                       // Enable Depot
            Show_List_Value__c = false,                                                  // Show List Value (Brazil)
            Show_Credit_Limit__c = true,                                                 // Show Credit Limit
            Show_Inventory__c = false,                                                   // Show Inventory
            Show_Pricing__c = false,                                                     // Show Pricing
            Show_Inventory_Column__c = true,                                             // Show Inventory Column
            Show_InTransit__c = false,                                                   // Show InTransit
            Show_InTransit_Values__c = false                                            // Show InTransit Values
        );
        insert rm_user;
        
        User ch_user = new User(
            Alias = 'SACHINJA',                                                                 // Alias
            Email = 'abc4@skinternational.com',                                         // Email
            ProfileId = p3.Id,                                                              // Profile
            Username = 'devendra36084211@ab.com.upltest',
             LastName='devendra',// lastname
            IsActive = true,                                                                    // Active
            CommunityNickname = 'SACHIN.JADHAV543456',  // Nickname
            Title = 'SALES EXECUTIVE',                                                          // Title
            TimeZoneSidKey = 'Asia/Kolkata',                  // Time Zone
            LocaleSidKey = 'en_IN',                                                   // Locale
            LanguageLocaleKey = 'en_US',                                                      // Language
            ForecastEnabled = false,                                                            // Allow Forecasting
            EmailEncodingKey = 'ISO-8859-1',         // Email Encoding

          
            SAP_User_Password__c = 'init123',                                                   // SAP User Password
            Territory__c = 'Pimpalgaon(B)',                                                     // Territory
            Zone__c = 'Indonesia',                                                              // Zone
            EnableDepot__c = true,                                                              // Enable Depot
            Show_List_Value__c = false,                                                         // Show List Value (Brazil)
            Show_Credit_Limit__c = true,                                                        // Show Credit Limit
            Show_Inventory__c = true,                                                           // Show Inventory
            Show_Pricing__c = false,                                                            // Show Pricing
            Show_Inventory_Column__c = true,                                                    // Show Inventory Column
            Show_InTransit__c = false,                                                          // Show InTransit
            Show_InTransit_Values__c = false                                                   // Show InTransit Values
        );
        insert ch_user;
        
        
        List<Monthly_Travel_Expense__c> arrayList= [Select Id,Name, Month__c,CreatedBy.Name, TotalAmount__c from Monthly_Travel_Expense__c];
        Monthly_Travel_Expense__c mtn_obj = new Monthly_Travel_Expense__c(
            Month__c = 'MAR 2018',                      // Month
            RegionalManager__c = rm_user.Id,       // Regional Manager
            NationalSalesManager__c = nsm_user.Id,  // National Sales Manager
            CountryHead__c = ch_user.Id           // Country Head
        );
        
        List<Monthly_Travel_Expense__c> tempList = new List<Monthly_Travel_Expense__c>();
        tempList.add(mtn_obj);
        Monthly_Travel_Expense__c ob=  [Select Id,Name, Month__c,  TotalAmount__c, CreatedById, CreatedBy.Name from Monthly_Travel_Expense__c limit 1];
        Expense_Item__c eob=  [SELECT id, Name, Item__c, Date__c, Purpose__c,Month__c, Location__c, Amount__c,Remarks__c FROM Expense_Item__c limit 1];
        List<Expense_Item__c> expenseItemList= [SELECT id, Name, Item__c, Date__c, Purpose__c,Month__c, Location__c, Amount__c,Remarks__c FROM Expense_Item__c limit 1];
        TravelExpensesController.getMonthItemsType();
        TravelExpensesController.getYearItemsType();
        TravelExpensesController.getItemsType();
        TravelExpensesController.getMTExpense(arrayList);
        TravelExpensesController.getPerMTExpense(ob.Id);
        TravelExpensesController.getExistPerMTExpense(eob.Id);
        TravelExpensesController.updateTravelExpense(eob);
        TravelExpensesController.deleteMTERecord(ob, ob.Id);
        TravelExpensesController.deletePerMTERecord(eob, eob.Id);
        TravelExpensesController.getProfileName();
		TravelExpensesController.getActivities(1,1,'Name',true,'');
        TravelExpensesController.saveTravelExpense(expenseItemList);
        TravelExpensesController.addMonth(tempList);
    }
    
}