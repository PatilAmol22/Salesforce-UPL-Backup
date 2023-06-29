@isTest
public class WeatherForecastCtlrTest {
    private static testMethod void unit1(){
        Id AccRecordId = Schema.SObjectType.account.getRecordTypeInfosByDeveloperName().get('Hannaford_Farm').getRecordTypeId();
        Account acc = new Account(Name = 'Test', Email__c = 'kuhinoor.barbhuiya@ibm.com',
                                  LegacyId__c='112233', Mobile__c='1234567890',recordTypeId = AccRecordId);
        // insert acc;
       
        
        Test.setMock(HttpCalloutMock.class, new WeatherHttpCalloutMock()); 
       // WeatherForecastCtlr.getForecast(acc.Id); 
        WeatherForecastCtlr we = new WeatherForecastCtlr();
        we.init();
        WeatherForecastCtlr.getForecast(acc.Id); 
        we.getnxt();
        we.getprev();
        we.next();
        we.previous();
        we.beginning();
        we.end();
        we.moreRows();
        we.lessRows();
        we.getWeatherData();
    }
    
    private static testMethod void unit2(){
        Id AccRecordId = Schema.SObjectType.account.getRecordTypeInfosByDeveloperName().get('Hannaford_Farm').getRecordTypeId();
        Account acc = new Account(Name = 'Test', Email__c = 'kuhinoor.barbhuiya@ibm.com',
                                  LegacyId__c='112233', Mobile__c='1234567890',recordTypeId = AccRecordId);
        // insert acc;
        
        Test.setMock(HttpCalloutMock.class, new WeatherHourlyHttpCalloutMock()); 
        WeatherForecastCtlr we = new WeatherForecastCtlr();
        we.init2();
        
    }
}