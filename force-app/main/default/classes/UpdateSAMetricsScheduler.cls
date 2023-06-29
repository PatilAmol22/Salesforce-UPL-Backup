global class UpdateSAMetricsScheduler implements Schedulable {
   global void execute(SchedulableContext SC) {
      
       List<Sales_Forecast_Setting__c> sfsList=[SELECT Id, Name, Active_Forecast_Month__c, Start_Day_Of_Approval__c, End_Day_Of_Approval__c, Start_Day_of_Submission__c, End_Day_of_Submission__c, Sales_Org__c FROM Sales_Forecast_Setting__c where Sales_Org__r.Sales_Org_Code__c='5191' limit 1];
       String month=sfsList[0].Active_Forecast_Month__c;
       Integer year=System.today().Year();
       UpdateSalesAgreementMetricsController.executeBatch(month, String.valueOf(year));        
   }
}