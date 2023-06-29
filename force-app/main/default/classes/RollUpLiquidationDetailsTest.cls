@isTest
public with sharing class RollUpLiquidationDetailsTest {
    @TestSetup
    static void makeData(){
            User usr_regional_manager = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Regional/Zonal Indonesia'].Id,
            firstName = 'UPL Ltd.',    
            LastName = 'RM',
            Email = 'test@test.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Country = 'Indonesia',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
            insert usr_regional_manager;
    }

    @IsTest
    static void testRollupDetails(){
        EnglishSalesTeamChatbotSetting__c chatsetting = new EnglishSalesTeamChatbotSetting__c(Name = 'Eisenstein Connected App Setting',ConsumerKey__c ='3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJ',
        End_Point__c ='email@test.com',siteBase__c='https://test.salesforce.com');
        insert chatsetting;
        Test.startTest();
        User u = [Select id,Name from User limit 1];
        System.runAs(u){
            Map<String,Liquidation2__c> map_liq = RollUpLiquidationDetails.rollUpLiquidation('');      
        }
        Test.stopTest();
        
    }
}