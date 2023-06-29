public without sharing class SalesForecast {
    @AuraEnabled(cacheable=true)
    public static List<Sales_Forecast_Setting__c> getSalesForecast(){
        List<Sales_Forecast_Setting__c> sf=[SELECT Id, Name, Sales_Org__c, Sales_Org__r.Name, Sales_Agreement_Schedule_Frequency_Allow__c, Active_Forecast_Month__c, Schedule_Frequency_Allowed__c, Currency_Allowed__c, Start_Day_Of_Approval__c, End_Day_Of_Approval__c, Configuration_on_Sales_Forecast_Metric__c, Clone_the_existing_Forecast_Previous_mon__c, Create_a_forecast_based_on_the__c, Admin_Profile_Name__c, Start_Day_of_Submission__c, End_Day_of_Submission__c FROM Sales_Forecast_Setting__c where Sales_Org__r.Sales_Org_Code__c='5191' limit 1];
        system.debug('data----'+sf);
        return sf;
    }

    @AuraEnabled
    public static string updateSalesForecast(String sa,String Month,String Frequency,String C,Integer sds,Integer eds,Integer sda,Integer eda,Decimal sfm,Boolean cef,Boolean cf){
        Sales_Forecast_Setting__c sf=[SELECT Id, Name, Sales_Org__c, Sales_Org__r.Name, Sales_Agreement_Schedule_Frequency_Allow__c, Active_Forecast_Month__c, Schedule_Frequency_Allowed__c, Currency_Allowed__c, Start_Day_Of_Approval__c, End_Day_Of_Approval__c, Configuration_on_Sales_Forecast_Metric__c, Clone_the_existing_Forecast_Previous_mon__c, Create_a_forecast_based_on_the__c, Admin_Profile_Name__c, Start_Day_of_Submission__c, End_Day_of_Submission__c FROM Sales_Forecast_Setting__c where Sales_Org__r.Sales_Org_Code__c='5191' limit 1];
        System.debug('Configuration_on_Sales_Forecast_Metric__c---'+sfm);
        sf.Sales_Agreement_Schedule_Frequency_Allow__c=sa;
        sf.Active_Forecast_Month__c=Month;
        sf.Schedule_Frequency_Allowed__c=Frequency;
        sf.Currency_Allowed__c=C;
        sf.Start_Day_Of_Approval__c=sda;
        sf.End_Day_Of_Approval__c=eda;
        sf.Start_Day_of_Submission__c=sds;
        sf.End_Day_of_Submission__c=eds;
        sf.Configuration_on_Sales_Forecast_Metric__c=sfm;
        sf.Clone_the_existing_Forecast_Previous_mon__c=cef;
        sf.Create_a_forecast_based_on_the__c=cf;
        update sf;
        System.debug(sf);
        return 'Updated Succesfully';
    }
}