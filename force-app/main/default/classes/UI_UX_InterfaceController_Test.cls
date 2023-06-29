/*
Created On : 8th Aug 2020
Created by: Pallavi Gite
Description: Used for CAM Custom compact Layout(UI UX Interface)
*/

@isTest
private class UI_UX_InterfaceController_Test {
    static testMethod void validateInterface() {
        
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        
        
        //Price_Group_Master__c pgCodesobj = new Price_Group_Master__c(
         //   PG_Code__c = 'Y6'             // PG Code
       // );
        //insert pgCodesobj;
        
        Distribution_Channel__c disChannelsobj = new Distribution_Channel__c(
            Name = 'Depot',                     // Distribution Channel Name
            Distribution_Channel_Code__c = '20'  // Distribution Channel Code
        );
        insert disChannelsobj;
        
        Division__c divobj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert divobj;
        
        Price_Group_Costa_Rica__c priceGroupsobj = new Price_Group_Costa_Rica__c(
            Name = 'Growth',            // Price Group - Costa Rica Name
            Price_Group_Code__c = 'C20'  // Price Group Code
            //User__c = '0050k000003rmSc'  // User
        );
        insert priceGroupsobj;
        
        Sales_Org__c salesOrgobj = new Sales_Org__c(
            Name = 'Costa Rica',           // Sales Org Name
            Company_Code__c = '5300',        // Company Code
            Sales_Org_Code__c = '5310',      // Sales Org Code
            Country_Code__c = 'CR'          // Country Code
        );
        insert salesOrgobj;
        
        Account accobj = new Account(
            Name = 'HACIENDA OJO DE AGUA S.A.',     // Account Name
            RecordTypeId = recordTypeId,                                // Account Record Type
            Last_Name__c = 'HACIENDA OJO DE AGUA S.A.',                // Last Name
            SAP_Code__c = '0001022461',                                // SAP Customer Code
           // Email__pc = 'servicioaproveedor@grupopelon.com',           // Email
            //Order_Block__c = false,                                    // Order Block
            //TaxNumber1__c = '3-101-000000',                            // Tax Number 1
            Account_Type__c = 'Sold To Party',                         // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',               // Incoterms (Part 2)
           // Price_Group_Costa_Rica__c = priceGroupsobj.Id,             // Customer Segment - Costa Rica
            //Unproductive_Call_Backend_Support__c = false,              // Unproductive Call (Backend) Support
            //AuthorizationGroupSalesoffice__c = 'S091',                 // Authorization Group (Sales office)
            //Prospect_to_Distributor__c = false,                        // Prospect to Distributor
            
            LanguageKey__c = 'EN',                                     // Language Key
            Billing_Street_1__c = 'SAN JOSE, SANTA ANA, POZOS, RADI',  // Billing Street 1
            CountryKey__c = 'IN',                                      // Country Key
            Billing_Street_3__c = 'GUAPILES2',                         // Billing Street 3
            Sales_Org__c = salesOrgobj.Id,                          // Sales Org
            ShippingConditions__c = '01',                              // Shipping Conditions
            
            Division__c = divobj.Id,                           // Division Name
            Distribution_Channel__c = disChannelsobj.Id,               // Distribution Channel
            CustomerAccountGroup__c = 'Z031',                          // Customer Account Group
            Depot_Code__c = 'CR00',                                    // Depot Code
            //PriceGroupCode__c = pgCodesobj.Id,                     // Price Group Code
                                      // Inco Term
            Payment_Terms__c = 'UK07',                                 // Payment Terms
            Is_Fixed_Rate_Available_Italy__c = false,                  // Is Fixed Rate Available
            Tax_classification_for_customer__c = '1'                  // Tax classification for customer
        );
        insert accobj;
        
        Credit_Info__c creditInfoObj = new Credit_Info__c(
            Distributor_Code__c = '00010224615310',// Distributor Code
            Distributor__c = accobj.Id,      // Distributor
            Credit_Limit__c = 320000.00,             // Credit Limit
            Balance_Limit__c = 193192.61,            // Balance Limit
            Internal_Limit__c = 0.00,                // Internal Limit
            Percentage_Used__c = 160.00,           // Percentage Used
            Used_Limit__c = 513192.61,               // Used Limit
            Sum_Open_Item__c = 513193,           // Outstanding
            Sales_Org__c = salesOrgobj.Id        // Sales Org
        );
        insert creditInfoObj;
        
        Outstanding_Ageing__c OutAgeingObj = new Outstanding_Ageing__c(
            X0_30__c = 0.00,                      // 0-30
            X31_60__c = 43691279.60,                // 31-60
            X181_210__c = 0.00,                     // 181-210
            X61_75__c = 141710.00,                  // 61-75
            X211_Above__c = 60747646.83,            // 211 Above
            X76_90__c = 139569.60,                  // 76-90
            X91_120__c = 0.00,                      // 91-120
            X121_150__c = 0.00,                     // 121-150
            X151_180__c = 0.00,                     // 151-180
            Customer_Code__c = accobj.Id,   // Customer Code
            Net_Outstanding__c = 45909126.37,       // Net Outstanding
            Sales_Org__c=salesOrgobj.Id
            //Combination_Key__c = '00010224615310'  // Combination Key
        );
        insert OutAgeingObj;
        
        Payments__c collectionObj = new Payments__c(
            Bounce__c = 0.00,                    // Bounce
            Customer_Name__c = accobj.Id,  // Customer Name
            X1_15__c = 0.00,                       // 1 - 15
            Company_Code__c =salesOrgobj.Id,   // Company Code
            X16_30__c = 0.00,                      // 16-30
            X31_60__c = 0.00,                      // 31-60
            X61_90__c = 0.00,                      // 61-90
            X91_120__c = 0.00,                     // 91-120
            Forecasted_Collection__c = 0.00,       // Forecasted Collection
            Total_Collectibles__c = 253823817.14,  // Total Collectibles
            Net_Overdue__c = 253823817.14,         // Net Overdue
            Total_Collection__c = 0.00,            // Total Collection
            Non_Forecasted_Collection__c = 0.00   // Non-Forecasted Collection
        );
        insert collectionObj;
        UI_UX_InterfaceController.fetchDatas(accobj.Id);
        
        
    }
}