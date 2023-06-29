/*
    Developer Name : Pravin J.
    Batch Class - ClosureFoBatch
*/
global class ClosureFo_Scheduler implements Schedulable{
   global void execute(SchedulableContext sc) {
      Database.executeBatch(new ClosureFoBatch(),200);
   }
}