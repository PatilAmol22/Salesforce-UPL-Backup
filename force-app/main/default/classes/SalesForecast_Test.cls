@isTest
public class SalesForecast_Test {
    static testMethod void test(){
        
        Sales_Org__c sorg = new Sales_Org__c(
            Name = 'Brazil',           
            Description__c = 'Brazil',  
            Sales_Org_Code__c = '5191',
            Is_Active_Forecast__c = true
        );
        insert sorg; 
        
        Sales_Forecast_Setting__c sf=new Sales_Forecast_Setting__c();
        sf.Active_Forecast_Month__c='March';
        sf.Clone_the_existing_Forecast_Previous_mon__c=true;
        sf.Configuration_on_Sales_Forecast_Metric__c=2;
        sf.Create_a_forecast_based_on_the__c=true;
        sf.Currency_Allowed__c='USD';
        sf.End_Day_Of_Approval__c=5;
        sf.End_Day_of_Submission__c=5;
        sf.Sales_Agreement_Schedule_Frequency_Allow__c='Monthly';
        sf.Sales_Org__c=sorg.Id;
        sf.Schedule_Frequency_Allowed__c='10';
        sf.Start_Day_Of_Approval__c=2;
        sf.Start_Day_of_Submission__c=2;
        
        insert sf;
        
        test.startTest();
        SalesForecast.getSalesForecast();
        Salesforecast.updateSalesForecast('Monthly', 'March', '10', 'USD', 2, 5, 2, 5, 2, true, true);
        test.stopTest();
        
        
    }
        
}