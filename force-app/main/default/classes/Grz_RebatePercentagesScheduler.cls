/*Class to schedule the rebate percentages upload class
 * test class: BRRebateModule_Test
 * Gurubaksh Grewal(Grazitti) (RITM0523779 )
 * Date Created:05-04-23
 * Last Modified:17-04-23
 * */
global class Grz_RebatePercentagesScheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
      Grz_RebatePercentagesUploader.upsRebPercentages();
   }
}