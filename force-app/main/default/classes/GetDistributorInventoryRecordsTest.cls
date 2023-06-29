@isTest
public with sharing class GetDistributorInventoryRecordsTest {
    
    @TestSetup
    static void makeData(){
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account a = new Account();
        a.Name = 'test_acc';
        a.Email__c= 'email@example.com';
        a.RecordTypeId = recordTypeId;
        //a.Distributor_Code__c = 'DC1000';
        a.CurrencyIsoCode = 'USD';
        insert a;
        
        SKU__c sku1 = new SKU__c();
        sku1.Name = 'a1C0k000000idgd';
        sku1.SKU_Description__c = 'test sku';
        sku1.SKU_Code__c = '000000000005290244';
        sku1.CurrencyIsoCode = 'INR';
        sku1.Combination_Key__c = '67311010000000000005290244';
        insert sku1;
        
        Zone__c zone1 = new Zone__c();
        zone1.Name = 'Tokyo';
        zone1.ZoneCode__c = 'JP03';
        insert zone1;
        
        Distributor_Inventory__c di = new Distributor_Inventory__c();
        //di.Area__c = ID.valueOf('a1B0k000000CdiFEAS');
        di.Distributor__c = a.Id;
        di.Fiscal_Year__c = '2020';
        di.Material__c  = sku1.Id;
        di.Month__c = '8';
        di.Office__c = zone1.Id;
        di.Pesticidal_Year__c = '2020';
        //di.Region__c = 'Hubli';
        di.Single_pack_number__c = 5;    
        insert di;
        
        EnglishSalesTeamChatbotSetting__c chatsetting = new EnglishSalesTeamChatbotSetting__c(Name = 'Eisenstein Connected App Setting',
                                                                                              ConsumerKey__c ='3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJ',
                                                                                              End_Point__c ='email@test.com',
                                                                                              siteBase__c='https://test.salesforce.com');
        insert chatsetting;
    }
    
    static testmethod void testGetTotalRecordcount(){
        /*GetDistributorInventoryRecords.getTotalRecordcount('','','','');
GetDistributorInventoryRecords.getTotalRecordcount('test%','','','');
GetDistributorInventoryRecords.getTotalRecordcount('','DC1%','','');
GetDistributorInventoryRecords.onfilter('test%','DC1%','','','5','0','>');
GetDistributorInventoryRecords.onfilter('','DC1%','5','','','0','>');
GetDistributorInventoryRecords.onfilter('test%','','','','5','5','<');
GetDistributorInventoryRecords.onfilter('','','','','5','0','>'); */
        
        GetDistributorInventoryRecords.getTotalRecordcount('test%','','','','8','2020');
        GetDistributorInventoryRecords.getTotalRecordcount('','DC1%','','','8','2020');
        GetDistributorInventoryRecords.getTotalRecordcount('test%','','','','8','');
        GetDistributorInventoryRecords.getTotalRecordcount('test%','','','','','2020');
        GetDistributorInventoryRecords.getTotalRecordcount('','DC1%','','','8','');
        GetDistributorInventoryRecords.getTotalRecordcount('','DC1%','','','','2020');
        GetDistributorInventoryRecords.getTotalRecordcount('','','','','8','2020');
        GetDistributorInventoryRecords.getTotalRecordcount('test%','','','','','');
        GetDistributorInventoryRecords.getTotalRecordcount('','DC1%','','','','');
        GetDistributorInventoryRecords.getTotalRecordcount('','','','','8','');
        GetDistributorInventoryRecords.getTotalRecordcount('','','','','','2020');
        GetDistributorInventoryRecords.getTotalRecordcount('','','','','','');
        GetDistributorInventoryRecords.onfilter('test%','','','','8','2020','5','0','>');
        GetDistributorInventoryRecords.onfilter('','DC1%','8','','','2020','5','0','>');
        GetDistributorInventoryRecords.onfilter('test%','','','','8','','5','0','>');
        GetDistributorInventoryRecords.onfilter('test%','','','','','2020','5','0','>');
        GetDistributorInventoryRecords.onfilter('','DC1%','','','','2020','5','0','>');
        GetDistributorInventoryRecords.onfilter('','DC1%','','','8','','5','0','>');
        GetDistributorInventoryRecords.onfilter('','','','','8','2020','5','0','>');
        GetDistributorInventoryRecords.onfilter('test%','','','','','','5','0','>');
        GetDistributorInventoryRecords.onfilter('','DC1%','','','','','5','0','>');
        GetDistributorInventoryRecords.onfilter('','','','','8','','5','0','>');
        GetDistributorInventoryRecords.onfilter('','','','','','2020','5','0','>');
        GetDistributorInventoryRecords.onfilter('','','','','','','5','5','<');
        GetDistributorInventoryRecords.onfilter('','','','','','','5','0','>');
        
        GetDistributorInventoryRecords.getLastRecord();
        List<Distributor_Inventory__c> newlist = [SELECT Id FROM Distributor_Inventory__c];
        List<Id> idlist = new List<Id>();
        for( Distributor_Inventory__c temp:newlist ){
            idlist.add( temp.Id );
        }
        GetDistributorInventoryRecords.deleteRecords( idlist );
    }
    
    
}