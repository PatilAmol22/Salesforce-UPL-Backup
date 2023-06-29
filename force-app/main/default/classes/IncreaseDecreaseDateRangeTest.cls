@isTest
public class IncreaseDecreaseDateRangeTest {
@testSetup
    static void allTheDataForThisTestClass() {
        Date d = date.today();
        Increase_Decrease_Percentage__c idp=new Increase_Decrease_Percentage__c();
        idp.Start_Date__c =d;
        idp.End_Date__c =d.addDays(10);
        idp.Percentage__c = 10;
        //idp.Status__c = 'Approved';
        idp.CurrencyIsoCode = 'BRL';
       insert idp; 
        
    }
     static testMethod void method1(){
        Date d = date.today();
        Increase_Decrease_Percentage__c idp1=new Increase_Decrease_Percentage__c();
        idp1.Start_Date__c =d.addDays(1);
        idp1.End_Date__c =d.addDays(13);
        idp1.Percentage__c = 5;
       // idp1.Status__c = 'Approved';
        idp1.CurrencyIsoCode = 'USD';
        insert idp1; 
        
        }
    
    static testMethod void method2(){
        Date d = date.today();
        Increase_Decrease_Percentage__c idp1=new Increase_Decrease_Percentage__c();
        idp1.Start_Date__c =d.addDays(100);
        idp1.End_Date__c =d.addDays(123);
        idp1.Percentage__c = 7;
       // idp1.Status__c = 'Approved';
        idp1.CurrencyIsoCode = 'BRL';
        insert idp1; 
        
        }
    
    
    
}