/*
Class Name : SWALLiquidationStatusMailZMMSchedule
Description : Schedulable class for scheduling SWALLiquidationStatusMailZMMBatch
Author : Bonny Mathews
Date : 05/08/2022
*/
global class SWALLiquidationStatusMailZMMSchedule implements Schedulable {
	 global void execute(SchedulableContext sc){
         //Get liq valid period
         Boolean validLiqPeriod = LiquidationAFSWALUtility.LiquidationStatusMail('SWAL');
       	 if(validLiqPeriod){
           Database.executeBatch(new SWALLiquidationStatusMailZMMBatch(),10); 
         }
     }
}