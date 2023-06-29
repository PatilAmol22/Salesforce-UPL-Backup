@isTest
private class SearchController_Test {
    static testMethod void validateData() {
        Id recordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        
        userrole  usrole = new userrole();
        usrole.Name ='Regional/Zonal Managers for Spain';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Standard User'];        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'skim@skinternational123.com';                             
        sobj1.ProfileId  = p.ID;
        // sobj1.ContactId=con.Id;
        sobj1.UserRoleId=usrole.id;
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = true; 
        sobj1.Country ='Argentina'; 
        sobj1.LastName='Terriotory Manager';
        sobj1.CommunityNickname = 'zonalExe1222 Di'; 
        sobj1.TimeZoneSidKey = 'Asia/Kolkata'; 
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        
        
        insert sobj1;
        
        Login_Country__c logCountryObj = new Login_Country__c();
        logCountryObj.Name ='Argentina'; 
        logCountryObj.For_Contry__c ='Argentina';
        logCountryObj.Sales_Org_Code__c ='5631';
        insert logCountryObj;
            
        
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Argentina',           // Sales Org Name
            Description__c = 'Argentina',   // Description
            Company_Code__c = '5631',       // Company Code
            Sales_Org_Code__c = '5631',     // Sales Org Code
            Country_Code__c = 'AR',         // Country Code
            Is_Active_Forecast__c = false  // Is Active Forecast
        );
        insert salesOrgObj;
        
        
        Division__c divisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert divisionObj;
        
        Account accObj = new Account(
            Name = 'ABADIA ALFREDO G.Y MARSIC',// Account Name
            Mobile__c = '12345678901234567890',                             // Mobile
            
            Email__c = 'ganagroloberia@gmail.com',                          // Email
            Depot_Code__c = 'AR13',                                         // Depot Code
            Order_Block__c = false,                                         // Order Block
            Business_Type__c = 'B to C',                                    // Business Type
            Is_Fixed_Rate_Available_Italy__c = false,                       // Is Fixed Rate Available
            Is_Special_Rate_Available__c = false,                           // Is Special Rate Available
            Sales_Org__c = salesOrgObj.Id,                              // Sales Org
            Tax_Number_1__c = '30707577890',                                // Tax Number 1
            Sales_Org_CD__c = '5631',                                       // Sales Org Code
            Account_Type__c = 'Sold To Party',                              // Account Type
            Division__c = divisionObj.Id,                                // Division Name
            //Distribution_Channel__c = 'a0x5D000002phn2',                    // Distribution Channel
            //Sales_District__c = 'a1g5D000001YRWU',                          // Sales District
            RecordTypeId = recordTypeId,                                     // Account Record Type
            Distributor_Type__c = 'UPL Distributor',                        // Distributor Type
            Is_Community_Active__c = false,                                 // Is Community Active
            Need_Community_Approval__c = false,                             // Need Community Approval
            Country__c = 'Other',                                           // Org Name
            Tax_classification_for_customer__c = '1',                       // Tax classification for customer
            Lead_Customer__c = '1234',                                      // Lead Customer
            Is_Forecast_required__c = false,                                // Is Forecast required
            Last_Name__c = 'ABADIA ALFREDO G.Y MARSICO JORGE A.',           // Last Name
            Billing_Street_1__c = 'Av. Mitre 496',                          // Billing Street 1
            Billing_Street_2__c = 'Av. Mitre Nro. 496',                     // Billing Street 2
            OwnersetbyProcess__c = false                                   // Owner set by Process
        );
        insert accObj;
        
        List<String> lstS = new list<String>();
        lstS.add('Id');
        lstS.add('Name'); 
        System.runAs(sobj1){
            
        
        SearchController.search('Account', lstS, 'ABADIA', 'Lead Customer');
        SearchController.search('Account', lstS, 'ABADIA', 'Non Lead Customer');
        SearchController.searchUsers('User',lstS, 'searchTerm');
        }
        
        
    }
}