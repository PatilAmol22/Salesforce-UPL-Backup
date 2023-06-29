@isTest
public class ChatBot_getSBUTest {
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
        
         
        
        addUsrRole();
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
        td.Present_in_KEDE__c = true ;
        td.Neglected__c = false;
        
        insert td;
    }
    
    @isTest
    static void getSBUDataTest(){
    	List<ChatBot_getSBU.PrechatInput> lst_preinput = new List<ChatBot_getSBU.PrechatInput>();
        ChatBot_getSBU.PrechatInput preinput = new ChatBot_getSBU.PrechatInput();
        preinput.sCountryName = 'India';
        preinput.sUserId = [Select id,Name from User limit 1].Id;
        preinput.sUserRole = 'SBU';
        lst_preinput.add(preinput);
        
         User usr = [Select id from User limit 1];
         System.RunAs(usr)
         {
            Test.startTest();
             ChatBot_getSBU.getSBUData(lst_preinput);
             
             Test.stopTest();
         }
    }
    
    @future
    public static void addUsrRole(){
         UserRole user_role = new UserRole(Name = 'SBU');
        insert user_role;
    }
}