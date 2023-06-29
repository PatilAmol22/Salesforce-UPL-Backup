@isTest

private  class GTMCompetitionTest {
        static testMethod void  getGTMCompetition() {
             User argentinaUsr = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager Argentina'].Id,
             LastName = 'Santiago',
             Email = 'sandeep.vishwakarma@skinternational.com',
             Username = 'test@test.com' + System.currentTimeMillis(),
             CompanyName = 'SK international',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US',
	         Country = 'Argentina'
             );
              insert argentinaUsr;
        
            System.runAs(argentinaUsr){
        Id competitorRecordType = Schema.SObjectType.GTM_Details__c.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id accountRecordLead = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Lead Customer').getRecordTypeId();
          Competitor__c com=new Competitor__c();
                //Id=com.Id,
                com.Name='test';
                com.Status__c='test';

            
            insert com;
            GTM__c  gtm=new GTM__c();
                         //Name='test',
            gtm.Fiscal_Year__c='2022-2023';
            gtm.Email__c='prashant.kumbhar@skinternational.com';
            gtm.GTM_Status__c='test';
            gtm.Sales_Rep_Name__c='test';
            gtm.Role__c='Manager';
             insert gtm;
            
            
       
            Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Argentina',            // Sales Org Name
            Company_Code__c = '5631',        // Company Code
            Sales_Org_Code__c = '5631',      // Sales Org Code
            Country_Code__c = 'AR'          // Country Code
        );
            insert salesOrgObj;
            Login_Country__c logCountryObj = new Login_Country__c();
            logCountryObj.Name ='Argentina'; 
            logCountryObj.For_Contry__c ='Argentina';
             logCountryObj.Sales_Org_Code__c ='5631';
            insert logCountryObj;
            
            Account acc=new Account();
            acc.Sales_Org__c = salesOrgObj.Id;                // Sales Org
            acc.Depot_Code__c = 'AR13';                             // Depot Code
            acc.Name = 'Test';                            // Account Name
            acc.RecordTypeId = accountRecordTypeId;                         // Account Record Type
            acc.Account_Type__c = 'Sold To Party';                 // Account Type           
            acc.Last_Name__c = 'Test';                  // Last Name            
            acc.Is_Community_Active__c = false;                     // Is Community Active
                                   
           // acc.Lead_Customer_Type__c = 'Retailer';                 // Lead Customer Type
            acc.Path_Finder__c = false;          
            insert acc;
            
        GTM_Details__c gtmdet =new GTM_Details__c(); 
            gtmdet.GTM_Customer__c=acc.id;
              gtmdet.GTM__c=gtm.id;
            gtmdet.Competitor_Name_1__c=com.id;
            gtmdet.Indicate_share_wallet_of_competitor_1__c=5;
            gtmdet.Competitor_Name_2__c=com.id;
            gtmdet.Indicate_share_wallet_of_competitor_2__c=7;
            gtmdet.Competitor_Name_3__c=com.id;
            gtmdet.Indicate_share_wallet_of_competitor_3__c=8;
            gtmdet.Competitor_Name_4__c=com.id;
            gtmdet.Indicate_share_wallet_of_competitor_4__c=9;
            gtmdet.Competitor_Name_5__c=com.id;
            gtmdet.Indicate_share_wallet_of_competitor_5__c=3;
            gtmdet.Competitor_Name_6__c=com.id;
            gtmdet.Indicate_share_wallet_of_competitor_6__c=4;
            gtmdet.Competitor_Name_7__c=com.id;
            gtmdet.Indicate_share_wallet_of_competitor_7__c=4;
            gtmdet.Competitor_Name_8__c=com.id;
            gtmdet.Indicate_share_wallet_of_competitor_8__c=6;
            gtmdet.UPL_Position__c=2;
            gtmdet.UPLs_share_of_wallet__c=15;
            gtmdet.isSubmitted__c=True;
            gtmdet.Is_Duplicate_GTM_Record__c = false; //this line added by Naresh Kumar EY Team #RITM0378285
            gtmdet.Sales_Org__c=salesOrgObj.Id;
            gtmdet.RecordTypeId=competitorRecordType;
            insert  gtmdet;
            
            GTM_Country_Configuration__c gtcou= new GTM_Country_Configuration__c();
                //Id=gtcou.Id,
                //Name='test',
                gtcou.Instruction_Competitor__c=gtm.id; 
                gtcou.Sales_Org__c=salesOrgObj.Id; 
                insert gtcou;
               
            GTM_Country_Configuration__c gtcou1= new GTM_Country_Configuration__c();
                //Id=gtcou.Id,
                //Name='test',
                gtcou1.Instruction_Identification__c=gtm.id; 
                gtcou1.Sales_Org__c=salesOrgObj.Id; 
                insert gtcou1;
            
           Competitior_Sales_Org_Mapping__c co=new Competitior_Sales_Org_Mapping__c();
            co.Competitor__c=com.id; 
            co.Display_Name__c='Bayer';
             co.Status__c='Active';
             co.Sales_Org__c=salesOrgObj.Id;
            
            insert co;
       
       
        
        GTMCompetition.getGTMCompetition('year');
       // GTMCompetition.createGTMDetail('year');
        //GTMCompetition.getInstructions1();
       // GTMCompetition.getInstructions2();           
       // GTMCompetition.getCompetitorDetails();
        //GTMCompetition.updateGTMDetails(gtmdet);
        GTMCompetition.updateshare(gtmdet.Id);
        GTMCompetition.getGtm('year');
        GTMCompetition.updateGTM(gtm.Id,'Role__c','UPl');
        GTMCompetition.updateGTM(gtm.Id,'Email__c','pkumbhar@gmail.com');
        GTMCompetition.updateGTM(gtm.Id,'Sales_Rep_Name__c','salesrep1');
        
            }
    
    }
}