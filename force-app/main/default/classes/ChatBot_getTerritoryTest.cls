@isTest
public class ChatBot_getTerritoryTest {

    @testSetup
    static void makeData(){
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'India',            // Sales Org Name
            Description__c = 'India',    // Description
            Company_Code__c = '1000',    // Company Code
            Sales_Org_Code__c = '1000'  // Sales Org Code
        );
        insert salesOrgObj;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
            LastName = 'test',
            Email = 'test@test.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            Country='India',
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            isActive = true
            //  UserRoleId =  ur.Id
        );  
        insert u;
        
        SBU__c SBUObj = new SBU__c(
            SBUUser__c = u.Id, // SBU User
            SBUCode__c = 'SBU2',              // SBU Code
            SalesOrg__c = salesOrgObj.id  // Sales Org
        );
        insert SBUObj;
        
        Zone__c zoneObj = new Zone__c(
            Name = 'Indore',                 // Zone Name
            SalesOrg__c = salesOrgObj.Id,   // Sales Org
            ZoneCode__c = 'Z16',               // Zone Code
            ZonalHead__c = u.Id,  // Zonal Head
            ZMMUser__c = u.Id,
            SBUCode__c = SBUObj.Id    // SBU Code
        );
        insert zoneObj;
        
        Region__c regionObj = new Region__c(
            Name = 'TRIANGULO',                  // Region Name
            RegionCode__c = 'BR4003',              // Region Code
            SalesOrg__c =salesOrgObj.id,       // Sales Org
            // RegionHead__c = u1.id,     // Region Head
            Zone__c = zoneObj.id
            
        );
        insert regionObj;
        
        Territory_Distributor__c td = new Territory_Distributor__c();
        td.Name = 'Narayangaon';
        td.TerritoryCode__c = '398';
        td.SalesOrg__c = salesOrgObj.id;
        td.Region__c = regionObj.id;
        td.TerritoryManager__c = u.Id;
        td.Zone__c = zoneObj.id;
        td.SBU__c = SBUObj.Id;
        td.SalesOrg__c = salesOrgObj.id;
        td.Present_in_KEDE__c = true ;
        td.Neglected__c = false;
        
        insert td;
        
    }
    
    @istest
    static void getTerritoryDataTest(){
        
        List<ChatBot_getTerritory.PrechatInput> lst_preinput1 = new List<ChatBot_getTerritory.PrechatInput>();
        ChatBot_getTerritory.PrechatInput preinput1 = new ChatBot_getTerritory.PrechatInput();
       	
        preinput1.sUserName = 'test';
        preinput1.sUserRole = 'TM';
        preinput1.sUserId = [select id,Name from User limit 1].Id;
        preinput1.sCountryName = 'India';
        lst_preinput1.add(preinput1);
        
        List<ChatBot_getTerritory.PrechatInput> lst_preinput2 = new List<ChatBot_getTerritory.PrechatInput>();
        ChatBot_getTerritory.PrechatInput preinput2 = new ChatBot_getTerritory.PrechatInput();
       
        preinput2.sUserName = 'test';
        preinput2.sUserRole = 'ZM';
        preinput2.sUserId = [select id,Name from User limit 1].Id;
        preinput2.sCountryName = 'India';
        lst_preinput2.add(preinput2);
        
        List<ChatBot_getTerritory.PrechatInput> lst_preinput3 = new List<ChatBot_getTerritory.PrechatInput>();
        ChatBot_getTerritory.PrechatInput preinput3 = new ChatBot_getTerritory.PrechatInput();
       	
        preinput3.sUserName = 'test';
        preinput3.sUserRole = 'SBU';
        preinput3.sUserId = [select id,Name from User limit 1].Id;
        preinput3.sCountryName = 'India';
        lst_preinput3.add(preinput3);
        
        List<ChatBot_getTerritory.PrechatInput> lst_preinput4 = new List<ChatBot_getTerritory.PrechatInput>();
        ChatBot_getTerritory.PrechatInput preinput4 = new ChatBot_getTerritory.PrechatInput();
       	
        preinput4.sUserName = 'test';
        preinput4.sUserRole = 'TM';
        preinput4.sUserId = [select id,Name from User limit 1].Id;
        preinput4.sCountryName = 'Swal';
        lst_preinput4.add(preinput4);
        
        List<ChatBot_getTerritory.PrechatInput> lst_preinput5 = new List<ChatBot_getTerritory.PrechatInput>();
        ChatBot_getTerritory.PrechatInput preinput5 = new ChatBot_getTerritory.PrechatInput();
       	
        preinput5.sUserName = 'test';
        preinput5.sUserRole = 'ZM';
        preinput5.sUserId = [select id,Name from User limit 1].Id;
        preinput5.sCountryName = 'Swal';
        lst_preinput5.add(preinput5);

        List<ChatBot_getTerritory.PrechatInput> lst_preinput6 = new List<ChatBot_getTerritory.PrechatInput>();
        ChatBot_getTerritory.PrechatInput preinput6 = new ChatBot_getTerritory.PrechatInput();
       	
        preinput6.sUserName = 'test';
        preinput6.sUserRole = 'SBU';
        preinput6.sUserId = [select id,Name from User limit 1].Id;
        preinput6.sCountryName = 'Swal';
        lst_preinput6.add(preinput6);
        
         List<ChatBot_getTerritory.PrechatInput> lst_preinput7 = new List<ChatBot_getTerritory.PrechatInput>();
        ChatBot_getTerritory.PrechatInput preinput7 = new ChatBot_getTerritory.PrechatInput();
       	
        preinput7.sUserName = 'test';
        preinput7.sUserRole = 'RM';
        preinput7.sUserId = [select id,Name from User limit 1].Id;
        preinput7.sCountryName = 'Swal';
        lst_preinput7.add(preinput7);
        
		ChatBot_getTerritory.getTerritoryData(lst_preinput1);  
        ChatBot_getTerritory.getTerritoryData(lst_preinput2);  
        ChatBot_getTerritory.getTerritoryData(lst_preinput3);  
        ChatBot_getTerritory.getTerritoryData(lst_preinput4);  
        ChatBot_getTerritory.getTerritoryData(lst_preinput5);  
        ChatBot_getTerritory.getTerritoryData(lst_preinput6);  
        ChatBot_getTerritory.getTerritoryData(lst_preinput7);
    }
    
    
    
}