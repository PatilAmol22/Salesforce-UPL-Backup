@isTest
public class OpportunityTriggerHandlerTest {
    @isTest
    public static void testChurnOpp(){
        Test.startTest();
        Account acc = new Account();
        acc.name = 'test';
        acc.SAP_Code__c = '0000012345';
        insert acc;
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Churn_Cross_Sell').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Year__c = '2023';
        opp.Name = 'test';
        opp.Month__c = '9';
        opp.Type = 'Churn';
        opp.Customer_Name__c = 'Test';
        opp.Customer_Code__c = '12345';
        opp.Sales_Rep_Id__c = '12345';
        opp.RecordTypeId = recordTypeId;
        insert opp;
        Task tsk = new Task();
        tsk.Subject = 'test';
        tsk.WhatId = opp.Id;
        insert tsk;
        opp.StageName = 'Offer accepted';
        update opp;
        Test.stopTest();
    }
}