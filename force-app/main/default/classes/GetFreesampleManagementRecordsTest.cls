@isTest
public with sharing class GetFreesampleManagementRecordsTest {
    @TestSetup
    static void makeData(){
        
        Sales_Org__c sales_org = new Sales_Org__c();
        sales_org.Name = 'Japan';
        sales_org.Sales_Org_Code__c = '6731';
        sales_org.CurrencyIsoCode = 'INR';
        insert sales_org;

        Zone__c zone1 = new Zone__c();
        zone1.Name = 'Nagoya';
        zone1.ZoneCode__c = 'JP04';
        zone1.SalesOrg__c = sales_org.Id;
        insert zone1;

        Region__c region = new Region__c();
        region.Region_Name__c = 'Okinawa-ken';
        region.RegionCode__c = '47';
        region.SalesOrg__c = sales_org.Id;
        region.Zone__c = zone1.Id;
        //region.Sales_Org_Code__c = '6731';
        insert region;

        Product2 prod2 = new Product2();
        prod2.Name = 'Adjuv & Form. Agents';
        prod2.CurrencyIsoCode  = 'INR';
        prod2.Combination_Key__c = 'A2019901067311010';
        prod2.Sales_Org__c = sales_org.Id;
        insert prod2;

        Free_Sample_Management__c fms = new Free_Sample_Management__c();
        fms.Sales_Office__c =  zone1.Id;
        fms.Area__c = region.Id;
        //fms.Product_provided_for_trial__c = prod2.Id;
        insert fms;

    }

    static testmethod void testGetTotalRecordcount(){
        GetFreesampleManagementRecords.getTotalRecordcount('', '');
        GetFreesampleManagementRecords.getTotalRecordcount('adj%', '');
        GetFreesampleManagementRecords.getTotalRecordcount('', 'A201%');
        GetFreesampleManagementRecords.onfilter('adj%', 'A201%','5','0','>');
        GetFreesampleManagementRecords.onfilter('', 'A201%','5','0','>');
        GetFreesampleManagementRecords.onfilter('adj%', '','5','0','>');
        GetFreesampleManagementRecords.onfilter('', '','5','5','<');
        GetFreesampleManagementRecords.onfilter('', '','5','5','>');
        GetFreesampleManagementRecords.getLastRecord();
       
    }
}