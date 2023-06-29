@isTest
public class AccountTriggerHandlerTest {
	@isTest
    public static void testOnwerNAM(){
        Sales_Org__c sOrg = new Sales_Org__c(
            Name = 'USA',
            Description__c = 'USA',
            Sales_Org_Code__c = '3100'
        );
        insert sOrg;
        
        Account accObj = new account();
        accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        accObj.Email__c = 'test@gmail.com';
        accObj.Name = 'Test';
        accObj.BillingPostalCode = '400014';
        accObj.Sales_Org__c = sorg.Id;
        insert accObj;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager' LIMIT 1];
        
        User usr1 = new User(
            firstname = 'Test',
            lastName = 'NAM', 
            Alias = 'tnam',                                                                   
            Email = 'test@gmail.com',                                       
            ProfileId = profileId.Id,                                                             
            Username = 'test@upl-ltd.com.upltest',                                         
            IsActive = true,                                                                   
            CommunityNickname = 'test.nam',
            TimeZoneSidKey = 'Asia/Kolkata',               
            LocaleSidKey = 'en_US',                                                  
            LanguageLocaleKey = 'en_US',                                                     
            ForecastEnabled = false,                                                           
            Phone = '7722034447',                                                    
            EmailEncodingKey = 'ISO-8859-1',
            Zone__c = 'Pune'                                                           
        );
        insert usr1;
        
        Territory_Distributor__c td = new Territory_Distributor__c();
        td.Name = '4101';
        td.TerritoryCode__c = '4101';
        td.TerritoryManager__c = usr1.Id;
        td.SalesOrg__c = sOrg.Id;
		insert td;
        
        accObj.Territory_Distributor__c = td.Id;
        
        Test.startTest();
        update accObj;
        Test.stopTest();
        
    }
}