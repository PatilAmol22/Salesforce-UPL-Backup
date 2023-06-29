/*
Class Name : AFLiquidationStatusMailSBUSchedule
Description : Schedulable class for scheduling AFLiquidationStatusMailSBUBatch
Author : Bonny Mathews
Date : 05/08/2022
*/
global class AFLiquidationStatusMailSBUSchedule implements schedulable{
    global static void execute(SchedulableContext sc){
        //Get liq valid period
        Boolean validLiqPeriod = LiquidationAFSWALUtility.LiquidationStatusMail('AF');
        if(validLiqPeriod){
           Database.executeBatch(new AFLiquidationStatusMailSBUBatch(),10); 
        }
    }
}