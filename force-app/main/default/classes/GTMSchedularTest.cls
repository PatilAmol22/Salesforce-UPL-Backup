@isTest
public class GTMSchedularTest {
    static testMethod void validateData(){
         Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        //Id accountRecordTypeIdForLead = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id accountRecordLead = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Lead Customer').getRecordTypeId();
        Id recordTypeGtmId = Schema.SObjectType.GTM_Details__c.getRecordTypeInfosByName().get('Crop Allocation').getRecordTypeId();
        
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Argentina',            // Sales Org Name
            Company_Code__c = '5631',        // Company Code
            Sales_Org_Code__c = '5631',      // Sales Org Code
            Country_Code__c = 'AR'          // Country Code
        );
        insert salesOrgObj;
        
        Division__c divisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert divisionObj;
        
        Distribution_Channel__c distChannelObj = new Distribution_Channel__c(
            Name = 'Direct',                    // Distribution Channel Name
            Distribution_Channel_Code__c = '10'  // Distribution Channel Code
        );
        insert distChannelObj;
        
        //SELECT Id, Name, For_Contry__c, Sales_Org_Code__c FROM Login_Country__c;
        Login_Country__c logCountryObj = new Login_Country__c();
        logCountryObj.Name ='Argentina'; 
        logCountryObj.For_Contry__c ='Argentina';
        logCountryObj.Sales_Org_Code__c ='5631';
        insert logCountryObj;
        
        
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
        
        System.runAs(sobj1) {
            Account AccObj = new Account(
                Sales_Org__c = salesOrgObj.Id,                // Sales Org
                Depot_Code__c = 'AR13',                             // Depot Code
                Name = 'ABENAMA S.A.',                             // Account Name
                RecordTypeId = accountRecordTypeId,                         // Account Record Type
                Account_Type__c = 'Sold To Party',                  // Account Type           
                Last_Name__c = 'ABENAMA S.A.',                      // Last Name            
                Division__c = divisionObj.Id,                    // Division Name
                Is_Community_Active__c = false,                     // Is Community Active
                Distribution_Channel__c = distChannelObj.Id,        // Distribution Channel
                //Lead_Customer__c = '9758',                          // Lead Customer
                Lead_Customer_Ownership__c = sobj1.Id,     // Lead Customer Ownership
                Lead_Customer_Type__c = 'Government',                 // Lead Customer Type
                Path_Finder__c = false                             // Path Finder
            );
            insert AccObj;
            
            //this is for Lead CIstomer
            Account AccObj1 = new Account(
                Sales_Org__c = salesOrgObj.Id,                // Sales Org
                Depot_Code__c = 'AR13',                             // Depot Code
                Name = 'ABENAMA S.A.',                             // Account Name
                RecordTypeId = accountRecordLead,                         // Account Record Type
                Account_Type__c = 'Sold To Party',                  // Account Type           
                Last_Name__c = 'ABENAMA S.A.',                      // Last Name            
                Division__c = divisionObj.Id,                    // Division Name
                Is_Community_Active__c = false,                     // Is Community Active
                Distribution_Channel__c = distChannelObj.Id,        // Distribution Channel
                //Lead_Customer__c = '9758',                          // Lead Customer
                Lead_Customer_Ownership__c = sobj1.Id,     // Lead Customer Ownership
                Lead_Customer_Type__c = 'Government',                 // Lead Customer Type
                Path_Finder__c = false                             // Path Finder
            );
            insert AccObj1;
            
            
            GTM__c gtmObj = new GTM__c(
                Sales_Rep_Name__c = 'UPL Ltd.',          // Sales Rep Name
                Fiscal_Year__c = '2020-2021',              // Fiscal Year
                Role__c = 'UPL Management',                // Role
                Sales_Org__c = salesOrgObj.Id,          // Sales Org
                Email__c = 'satkari@skinternational.com',  // Email
                GTM_Status__c = 'Draft',                   // GTM Status
                Sales_Rep__c = sobj1.Id          // Sales Rep
            );
            insert gtmObj;
            
            GTM_Details__c gtmDetalObj = new GTM_Details__c(
                GTM_Customer__c = AccObj.Id,            // GTM Customer
                RecordTypeId = recordTypeGtmId,                       // Record Type
                GTM__c = gtmObj.Id,                       // GTM
               // GTM_Details__c = 'a8F5D0000004Ibj',               // GTM Details
                isSubmitted__c = false                         // isSubmitted
                //Crop__c = 'a085D000006R08y'                      // Crop
            );
            insert gtmDetalObj;
            
            
            //this is for Lead customer
            GTM__c gtmObj1 = new GTM__c(
                Sales_Rep_Name__c = 'UPL Ltd.',          // Sales Rep Name
                Fiscal_Year__c = '2020-2021',              // Fiscal Year
                Role__c = 'UPL Management',                // Role
                Sales_Org__c = salesOrgObj.Id,          // Sales Org
                Email__c = 'satkari@skinternational.com',  // Email
                GTM_Status__c = 'Draft',                   // GTM Status
                Sales_Rep__c = sobj1.Id          // Sales Rep
            );
            insert gtmObj1;
            
            GTM_Details__c gtmDetalObj1 = new GTM_Details__c(
                GTM_Customer__c = AccObj1.Id,            // GTM Customer
                RecordTypeId = recordTypeGtmId,                       // Record Type
                GTM__c = gtmObj1.Id,                       // GTM
               // GTM_Details__c = 'a8F5D0000004Ibj',               // GTM Details
                isSubmitted__c = false                         // isSubmitted
                //Crop__c = 'a085D000006R08y'                      // Crop
            );
            insert gtmDetalObj1;
            
            Test.StartTest();
            GTMSchedular testsche = new GTMSchedular();
            String sch = '0 0 23 * * ?';
            system.schedule('Test status Check', sch, testsche );
            Test.stopTest();
            
            
        }//end of run as
        
    }
    
    

}