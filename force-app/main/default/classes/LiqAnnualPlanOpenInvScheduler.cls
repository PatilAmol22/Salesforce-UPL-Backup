/*
     Class Name : LiqAnnualPlanOpenInvScheduler
     Description : Scheduler Class For LiquidationAnnualPlanOpenInventoryBatch class
     Author : Bonny Mathews
     Date : 21/11/2022
 */
global class LiqAnnualPlanOpenInvScheduler implements Schedulable {
	global void execute(SchedulableContext SC) {
        LiquidationAnnualPlanOpenInventoryBatch liqLAPOI = new LiquidationAnnualPlanOpenInventoryBatch();
        Database.executeBatch(liqLAPOI,10);
    }
}