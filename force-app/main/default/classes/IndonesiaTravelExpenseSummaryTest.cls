//// UPL-2-I386: Modified by:Ankita Saxena Changes in Travel request  for Indonesia
@isTest
public class IndonesiaTravelExpenseSummaryTest {
    @testSetup static void setup() {
        Profile p = [SELECT Id FROM Profile WHERE Name  = 'Territory Manager Indonesia' LIMIT 1];                     //Indonesia Profile
        Profile p1 = [SELECT Id FROM Profile WHERE Name  = 'National sales Manager indonesia' LIMIT 1];                     //NSM Profile
        Profile p2 = [SELECT Id FROM Profile WHERE Name  = 'Regional/Zonal Indonesia' LIMIT 1];                     //RM Profile
        Profile p3 = [SELECT Id FROM Profile WHERE Name  = 'Sales Head Indonesia' LIMIT 1];                     //CH Profile
        
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
            Monthly_Travel_Expenses__c = monthly_travel_expense_obj2.Id,  // Monthly Travel Expense
            Month__c = 'MAR 2018'                           // Month
        );
        insert expense_item_obj1; 
        
    }
    
    
    
    static testMethod void validateClass() {
        IndonesiaTravelExpenseSummaryController indonesiaTravelExpenseSummaryController = new IndonesiaTravelExpenseSummaryController();
        indonesiaTravelExpenseSummaryController.mte_id = [select id from Monthly_Travel_Expense__c limit 1].id;
        List<Expense_Item__c> meList = [SELECT id, Name, CreatedBy.Name, CreatedBy.TM_Code__c, CreatedBy.Territory__c,Item__c, Date__c,Purpose__c,Month__c, Location__c, Amount__c, Remarks__c,Monthly_Travel_Expenses__r.status__c, Monthly_Travel_Expenses__r.RM_status__c,Monthly_Travel_Expenses__r.NSM_status__c,Monthly_Travel_Expenses__r.NMM_status__c,Monthly_Travel_Expenses__r.CH_status__c,Monthly_Travel_Expenses__r.RegionalManager__r.name,Monthly_Travel_Expenses__r.NationalSalesManager__r.name,Monthly_Travel_Expenses__r.CountryHead__r.name,Item_Limit__c FROM Expense_Item__c ];
        System.assertEquals(indonesiaTravelExpenseSummaryController.eiList, meList);
        System.assertEquals(indonesiaTravelExpenseSummaryController.sum, 66.00);
        Map<string, decimal> activityAmountMap = new Map<string, decimal>{meList[0].Item__c => 66.00};
        System.assertEquals(indonesiaTravelExpenseSummaryController.activityAmountMap,activityAmountMap);
        Map<string, String> activityLimitMap = new Map<string, String>{meList[0].Item__c => '350000'};
        System.assertEquals(indonesiaTravelExpenseSummaryController.activityLimitMap, activityLimitMap);
        Set<String> keys = new Set<String>{meList[0].Item__c};
        System.assertEquals(indonesiaTravelExpenseSummaryController.keys, keys);
    }
}