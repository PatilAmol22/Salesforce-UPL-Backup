/*
* 	Test Class Name - SalesAreaUpdateBatchTest
*   Author : EY (Harshaprasad Srustu)
*   Batch Class - SalesAreaUpdateBatch
*   CreatedDate: 12-DEC-2022
*   Description - Custom logic to provide update the SalesArea' AccountOwner upon change on TerritoryManager from territory record
 * 				associated to respective SalesOrg
**/
@isTest
public class SalesAreaUpdateBatchTest {

    public static testMethod void testBatch() {
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Distributor').RecordTypeId;
	    Id systemAdminProfile = [SELECT Id,name FROM Profile WHERE Name = 'System Administrator'].Id;

        //inserting first test userrecord.
        User userRecord = new User();
        userRecord.Alias = 'zonaa';                                                            
        userRecord.Email = 'test@yopmail.com';                             
        userRecord.ProfileId  = systemAdminProfile;                                                     
        userRecord.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        userRecord.IsActive = true;  
        userRecord.LastName='Terriotory Manager';
        userRecord.CommunityNickname = 'zonalExe1222 Di'; 
        userRecord.TimeZoneSidKey = 'Asia/Kolkata'; 
        // sobj1.Contact.AccountID = acc.id;// Time Zone
        userRecord.LocaleSidKey = 'en_IN';                                    
        userRecord.LanguageLocaleKey = 'en_US';                                             
        userRecord.ForecastEnabled = false;                                                     
        userRecord.EmailEncodingKey = 'ISO-8859-1';    
        userRecord.Show_Inventory__c = false;                                                     
        userRecord.Show_Credit_Limit__c = false; 
        insert userRecord;
        
        Sales_Org__c salesorg = new Sales_Org__c();
        salesorg.Name = 'Swal';          
        salesorg.Description__c = 'Swal';   
        salesorg.Company_Code__c = '1210';    
        salesorg.Sales_Org_Code__c = '1210';
        insert salesorg;
        
        Region__c regObj= new Region__c();
        regObj.Name='Mumbai';
        regObj.RegionCode__c='045';
        insert regObj;
        
        SBU__c SBUObj = new SBU__c();
        SBUObj.SBUUser__c = UserInfo.getUserId();
        SBUObj.SBUCode__c = 'SBU2';
        SBUObj.SalesOrg__c = salesorg.id;
        insert SBUObj;
        
        Zone__c zoneObj = new Zone__c();
        zoneObj.Name = 'Maharashtra';             
        zoneObj.SalesOrg__c = salesorg.Id;   
        zoneObj.ZoneCode__c = 'Z16';               
        zoneObj.ZonalHead__c = UserInfo.getUserId();  
        zoneObj.SBUCode__c = SBUObj.Id;    
        insert zoneObj;
        
        Territory_Distributor__c territoryObj = new Territory_Distributor__c();
        territoryObj.Name = 'Dhule';
        territoryObj.TerritoryCode__c = '398';
        territoryObj.SalesOrg__c = salesorg.id;
        territoryObj.Region__c = regObj.id;
        territoryObj.TerritoryManager__c = userRecord.Id;
        territoryObj.Zone__c = zoneObj.id;
        territoryObj.SBU__c = SBUObj.Id;
        territoryObj.Present_in_KEDE__c = true;
        territoryObj.Neglected__c = false;
        insert territoryObj;
        List<id> TerritoryList=new List<id>();
        TerritoryList.add(territoryObj.id);
        territoryObj.TerritoryManager__c = UserInfo.getUserId();
        update territoryObj;
        
        State_Tax_Structure__c statetax = new State_Tax_Structure__c();
        statetax.State_Name__c = 'Maharashtra';
        statetax.Country__c = 'India';          
        statetax.Tax__c = 10;           
        statetax.State_Code__c = '13';
        statetax.AdditionalTax__c = 30;
        statetax.SalesOrg__c = salesOrg.Id;
        insert statetax;
        
        Depot__c depObj=new Depot__c();
        depObj.Name='Pune';
        depObj.Country__c='India';
        depObj.Location__c='Pune';
        depObj.Depot_Code__c='PUN1';
        depObj.Active__c=true;
        depObj.SalesOrg__c=salesorg.Id;
        depObj.Region__c=statetax.Id;
        insert depObj;
        
        Distribution_Channel__c discObj=new Distribution_Channel__c();
        discObj.Name='10';
        discObj.Description__c='xyz';
        discObj.Distribution_Channel_Code__c='2012';
        insert discObj;
        
        Division__c divObj= new Division__c();
        divObj.Name='Abc';
        divObj.Description__c = 'xyz';
        divObj.Division_Code__c= '10';
        insert divObj;
        
        Account acnt= new Account();
        acnt.Name = 'Test Account';
        acnt.Email__c='abc@test.com';
        acnt.BillingCity ='Pune';
        acnt.BillingCountry='India';
        acnt.Territory_Distributor__c = territoryObj.ID;
        acnt.RecordTypeId = accRecordTypeId;
        acnt.Mobile__c='9999999999';
        acnt.Phone='020256580';
        acnt.Sales_Org__c=salesOrg.Id;
        acnt.SAP_Code__c='SAP123456';
        acnt.Depot_Code__c=depObj.Id;
        acnt.Distribution_Channel__c=discObj.Id;
        acnt.Division__c=divObj.Id;
        acnt.State_Tax_Structure__c=statetax.Id;
        insert acnt;
        
        DistributorSalesAreaMapping__c distributorSalesAreaMappingObj = new DistributorSalesAreaMapping__c(            
            AccountType__c = 'Sold To Party',          // Account Type
            Distributor__c = acnt.Id,          // Distributor
            SalesOrg__c = salesorg.Id,             // Sales Org
            OrderBlock__c = false,                       // Order Block
            DistributionChannel__c = discObj.Id,  // Distribution Channel
            Division__c = divObj.Id,             // Division
            AccountOwner__c = userRecord.Id,         // Account Owner
            Manually_Created__c = True,                 // Manually Created
            Territory__c = territoryObj.Id
        );
        insert distributorSalesAreaMappingObj;
        
        
        DistributorSalesAreaMapping__c salesAreaMappingSecondRecord = new DistributorSalesAreaMapping__c(
            AccountType__c = 'Sold To Party',          // Account Type
            Distributor__c = acnt.Id,          // Distributor
            SalesOrg__c = salesorg.Id,             // Sales Org
            OrderBlock__c = false,                       // Order Block
            // DistributionChannel__c = Distribution_ChannelObj.Id,  // Distribution Channel
            // Division__c = DivisionObj.Id,             // Division
            AccountOwner__c = userRecord.Id,         // Account Owner
            Manually_Created__c = True,                 // Manually Created
            Territory__c = territoryObj.Id
        );
        insert salesAreaMappingSecondRecord;
        Test.StartTest();    
            System.runAs(userRecord){
                SalesAreaUpdateBatch runSalesAreaBatch = new SalesAreaUpdateBatch(TerritoryList);
                Database.executeBatch(runSalesAreaBatch);
                runSalesAreaBatch.insertExceptionRecords('SalesAreaUpdateBatch','Execute','All are not processed','Credit Info');
            }                
        Test.stopTest();
    }
}