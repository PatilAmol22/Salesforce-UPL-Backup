@isTest
public class ChatBot_getSalesDistrictsTest {
    

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
        
        Sales_District__c sd=new Sales_District__c();
        sd.Name = 'TestName';
        sd.User__c = u.id;
        sd.Sales_District_Code__c='12234';
        
        insert sd;
    }
    
    @istest
    static void getSalesDistrictDataTest(){
        
        List<ChatBot_getSalesDistricts.PrechatInput> lst_preinput1 = new List<ChatBot_getSalesDistricts.PrechatInput>();
        ChatBot_getSalesDistricts.PrechatInput preinput1 = new ChatBot_getSalesDistricts.PrechatInput();
        preinput1.sUserName = 'test';
        preinput1.sUserId = [select id,Name from User limit 1].Id;
        preinput1.sCountryName = 'Indonesia';
        lst_preinput1.add(preinput1);
        
        List<ChatBot_getSalesDistricts.PrechatInput> lst_preinput2 = new List<ChatBot_getSalesDistricts.PrechatInput>();
        ChatBot_getSalesDistricts.PrechatInput preinput2 = new ChatBot_getSalesDistricts.PrechatInput();
        preinput2.sUserName = 'test';
        preinput2.sUserId = [select id,Name from User limit 1].Id;
        preinput2.sCountryName = 'Australia';
        lst_preinput2.add(preinput2);
        
		List<ChatBot_getSalesDistricts.PrechatInput> lst_preinput3 = new List<ChatBot_getSalesDistricts.PrechatInput>();
        ChatBot_getSalesDistricts.PrechatInput preinput3 = new ChatBot_getSalesDistricts.PrechatInput();
        preinput3.sUserName = 'test';
        preinput3.sUserId = [select id,Name from User limit 1].Id;
        preinput3.sCountryName = 'Australia';
        lst_preinput3.add(preinput3);

		List<ChatBot_getSalesDistricts.PrechatInput> lst_preinput4 = new List<ChatBot_getSalesDistricts.PrechatInput>();
        ChatBot_getSalesDistricts.PrechatInput preinput4 = new ChatBot_getSalesDistricts.PrechatInput();
        preinput4.sUserName = 'test';
        preinput4.sUserId = [select id,Name from User limit 1].Id;
        preinput4.sCountryName = 'Indonesia';
        lst_preinput4.add(preinput4);

        
  		ChatBot_getSalesDistricts.getSalesDistrictData(lst_preinput1);  
        ChatBot_getSalesDistricts.getSalesDistrictData(lst_preinput2);  
        ChatBot_getSalesDistricts.getSalesDistrictData(lst_preinput3);
        ChatBot_getSalesDistricts.getSalesDistrictData(lst_preinput4);
        
    }

}