//Created by Naresh Kumar EY Team #RITM0378285

@isTest
public class ScheduleBatchGtmDetailsRecordUpdateTest {

     static testMethod void validateData(){
		  Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        //Id accountRecordTypeIdForLead = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id accountRecordLead = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Lead Customer').getRecordTypeId();
        Id recordTypeGtmId = Schema.SObjectType.GTM_Details__c.getRecordTypeInfosByName().get('Crop Allocation').getRecordTypeId();
        Id  CompetitorRecordType = Schema.SObjectType.GTM_Details__c.getRecordTypeInfosByDeveloperName().get('Competitor').getRecordTypeId();
          Id  Profile_PotentialRecordType = Schema.SObjectType.GTM_Details__c.getRecordTypeInfosByDeveloperName().get('Profile_Potential').getRecordTypeId();
		 Id  OutlookRecordType = Schema.SObjectType.GTM_Details__c.getRecordTypeInfosByDeveloperName().get('Outlook').getRecordTypeId();
    	 Id  Product_Category_AllocationRecordType = Schema.SObjectType.GTM_Details__c.getRecordTypeInfosByDeveloperName().get('Product_Category_Allocation').getRecordTypeId();
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
            
            //this for crop allocation
            GTM_Details__c gtmDetalObj = new GTM_Details__c(
                GTM_Customer__c = AccObj.Id,            // GTM Customer
                RecordTypeId = recordTypeGtmId,                       // Record Type
                GTM__c = gtmObj.Id,                       // GTM
               // GTM_Details__c = 'a8F5D0000004Ibj',               // GTM Details
                isSubmitted__c = false, IS_Duplicate_GTM_Record__c = false                      // isSubmitted
                                  
            );
            insert gtmDetalObj;
             DateTime dtc = DateTime.newInstanceGMT(2022,7,26, 9,21,46);
        	Test.setCreatedDate(gtmDetalObj.id, dtc);
            
            //this for crop allocation
              GTM_Details__c gtmDetalObj1 = new GTM_Details__c(
                GTM_Customer__c = AccObj.Id,            // GTM Customer
                RecordTypeId = recordTypeGtmId,                       // Record Type
                GTM__c = gtmObj.Id,                       // GTM
               // GTM_Details__c = 'a8F5D0000004Ibj',               // GTM Details
                isSubmitted__c = false , IS_Duplicate_GTM_Record__c = false                        // isSubmitted
                                 
            );
            insert gtmDetalObj1;
             DateTime dtc2 = DateTime.newInstanceGMT(2022,7,26, 9,25,46);
        	Test.setCreatedDate(gtmDetalObj1.id, dtc2);
            
            
            //Competitor record type
                GTM_Details__c gtmDetalObjComp = new GTM_Details__c(
                GTM_Customer__c = AccObj.Id,            // GTM Customer
                RecordTypeId = CompetitorRecordType,                       // Record Type
                GTM__c = gtmObj.Id,                       // GTM
               // GTM_Details__c = 'a8F5D0000004Ibj',               // GTM Details
                isSubmitted__c = false,                    // isSubmitted
                IS_Duplicate_GTM_Record__c = false   //IS Duplicate GTM Record 
            );
            insert gtmDetalObjComp;
             DateTime dtcomp = DateTime.newInstanceGMT(2022,7,26, 9,21,46);
        	Test.setCreatedDate(gtmDetalObjComp.id, dtcomp);
            
				//Competitor record type         
              GTM_Details__c gtmDetalObjComp1 = new GTM_Details__c(
                GTM_Customer__c = AccObj.Id,            // GTM Customer
                RecordTypeId = CompetitorRecordType,                       // Record Type
                GTM__c = gtmObj.Id,                       // GTM
               // GTM_Details__c = 'a8F5D0000004Ibj',               // GTM Details
                isSubmitted__c = false ,                   // isSubmitted
              IS_Duplicate_GTM_Record__c = false        //IS Duplicate GTM Record 
            );
            insert gtmDetalObjComp1;
             DateTime dtccomp1 = DateTime.newInstanceGMT(2022,7,26, 9,25,46);
        	Test.setCreatedDate(gtmDetalObjComp1.id, dtccomp1);
            
            
            
    
             //Profile & Potential  record
                GTM_Details__c gtmDetalObjPro = new GTM_Details__c(
                GTM_Customer__c = AccObj.Id,            // GTM Customer
                RecordTypeId = Profile_PotentialRecordType,                       // Record Type
                GTM__c = gtmObj.Id,                       // GTM
               // GTM_Details__c = 'a8F5D0000004Ibj',               // GTM Details
                isSubmitted__c = false,                      // isSubmitted
                  IS_Duplicate_GTM_Record__c = false        //IS Duplicate GTM Record 
            );
            insert gtmDetalObjPro;
             DateTime dtPro = DateTime.newInstanceGMT(2022,7,26, 9,21,46);
        	Test.setCreatedDate(gtmDetalObjPro.id, dtpro);
            
            //this for Profile & Potential  record
              GTM_Details__c gtmDetalObjPro1 = new GTM_Details__c(
                GTM_Customer__c = AccObj.Id,            // GTM Customer
                RecordTypeId = Profile_PotentialRecordType,                       // Record Type
                GTM__c = gtmObj.Id,                       // GTM
               // GTM_Details__c = 'a8F5D0000004Ibj',               // GTM Details
                isSubmitted__c = false ,                         // isSubmitted
                    IS_Duplicate_GTM_Record__c = false        //IS Duplicate GTM Record 
                
            );
            insert gtmDetalObjPro1;
             DateTime dtcpro1 = DateTime.newInstanceGMT(2022,7,26, 9,25,46);
        	Test.setCreatedDate(gtmDetalObjPro1.id, dtcpro1);
            
            
            
            
            
            
            
               //Product Category Allocation RecordType
                GTM_Details__c gtmDetalObjPCat = new GTM_Details__c(
                GTM_Customer__c = AccObj.Id,            // GTM Customer
                RecordTypeId = Product_Category_AllocationRecordType,                       // Record Type
                GTM__c = gtmObj.Id,                       // GTM
               // GTM_Details__c = 'a8F5D0000004Ibj',               // GTM Details
                isSubmitted__c = false,                     // isSubmitted
                  IS_Duplicate_GTM_Record__c = false        //IS Duplicate GTM Record 
            );
            insert gtmDetalObjPCat;
             DateTime dtPCat = DateTime.newInstanceGMT(2022,7,26, 9,21,46);
        	Test.setCreatedDate(gtmDetalObjPCat.id, dtPCat);
            
            //this for Product_Category_AllocationRecordType  record
              GTM_Details__c gtmDetalObjPCat1 = new GTM_Details__c(
                GTM_Customer__c = AccObj.Id,            // GTM Customer
                RecordTypeId = Product_Category_AllocationRecordType,                       // Record Type
                GTM__c = gtmObj.Id,                       // GTM
               // GTM_Details__c = 'a8F5D0000004Ibj',               // GTM Details
                isSubmitted__c = false ,                       // isSubmitted
                  IS_Duplicate_GTM_Record__c = false        //IS Duplicate GTM Record 
            );
            insert gtmDetalObjPCat1;
             DateTime dtPCat1 = DateTime.newInstanceGMT(2022,7,26, 9,25,46);
        	Test.setCreatedDate(gtmDetalObjPCat1.id, dtPCat1);
              
            
            
            
            
                         //Outlook record
                GTM_Details__c gtmDetalObjOut = new GTM_Details__c(
                GTM_Customer__c = AccObj.Id,            // GTM Customer
                RecordTypeId = OutlookRecordType,                       // Record Type
                GTM__c = gtmObj.Id,                       // GTM
               // GTM_Details__c = 'a8F5D0000004Ibj',               // GTM Details
                isSubmitted__c = false,                       // isSubmitted
                  IS_Duplicate_GTM_Record__c = false        //IS Duplicate GTM Record 
            );
            insert gtmDetalObjOut;
             DateTime dtout = DateTime.newInstanceGMT(2022,7,26, 9,21,46);
        	Test.setCreatedDate(gtmDetalObjOut.id, dtout);
            
            //this for Outlook  record
              GTM_Details__c gtmDetalObjOut1 = new GTM_Details__c(
                GTM_Customer__c = AccObj.Id,            // GTM Customer
                RecordTypeId = OutlookRecordType,                       // Record Type
                GTM__c = gtmObj.Id,                       // GTM
               // GTM_Details__c = 'a8F5D0000004Ibj',               // GTM Details
                isSubmitted__c = false ,                         // isSubmitted
                  IS_Duplicate_GTM_Record__c = false        //IS Duplicate GTM Record 
            );
            insert gtmDetalObjOut1;
             DateTime dtout1 = DateTime.newInstanceGMT(2022,7,26, 9,25,46);
        	Test.setCreatedDate(gtmDetalObjOut1.id, dtout1);
            
         //Execting Schedule class
            Test.StartTest();
            String cronExp ='0 00 00 ? 2-7 *';
            SchedableBatchForGtmRecordsUpdate testSchedule = new SchedableBatchForGtmRecordsUpdate();
            System.schedule('Argentina Update Schedule Test', cronExp, testSchedule);       
            Test.stopTest();
            
            
        }//end of run as
        
     }
    
 
}