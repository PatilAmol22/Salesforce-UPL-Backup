/*
     Class Name : AFLiquidationStatusMailSchedule
     Description : Schedule Class to trigger mail for Liquidation Status for AF
     Author : Abhineet Kumar
     Date : 15/09/2022
 */
global class AFLiquidationStatusMailSchedule implements schedulable{
    global static void execute(SchedulableContext sc){
        //Get liq valid period
        Integer dayNum = System.today().day();
        Integer currMonth = System.today().Month();
        MultiCountry_Liquidation__c mcLiq = MultiCountry_Liquidation__c.getValues('AF');
        Decimal startDateNum = mcLiq.Liquidation_Start_Day__c;
        Integer daysCount = Integer.valueOf(System.Label.StatusMailDaysCount); //Get days count from custom Label

        if(mcLiq.Active__c = true && (dayNum <= startDateNum+daysCount) && mcLiq.Active_Month__c){
            Database.executeBatch(new AFLiquidationStatusMailBatch(),10);
        }
    }
}