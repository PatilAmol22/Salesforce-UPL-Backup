/*
     Class Name : SWALLiquidationStatusMailSchedule
     Description : Schedule Class to trigger mail for Liquidation Status for SWAL
     Author : Abhineet Kumar
     Date : 15/09/2022
 */
global class SWALLiquidationStatusMailSchedule implements Schedulable {
	 global void execute(SchedulableContext sc){
         //Get liq valid period
         Integer dayNum = System.today().day();
         Integer currMonth = System.today().Month();
         MultiCountry_Liquidation__c mcLiq = MultiCountry_Liquidation__c.getValues('SWAL');
         Decimal startDateNum = mcLiq.Liquidation_Start_Day__c;
         Integer daysCount = Integer.valueOf(System.Label.StatusMailDaysCount); //Get days count from custom Label

         if(mcLiq.Active__c = true && (dayNum <= startDateNum+daysCount) && mcLiq.Active_Month__c){
             Database.executeBatch(new SWALLiquidationStatusMailBatch(),10);
         }
     }
}