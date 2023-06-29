global class Grz_CaseEscalationSchedular implements Schedulable{
   global void execute(SchedulableContext sc) {
      Database.executeBatch(new Grz_CaseEscalationBatch(),100);
       Database.executeBatch(new Grz_IndiaCaseModuleEscalate2Batch(),100);
       Database.executeBatch(new Grz_IndiaCaseMOduleHOBatch(),100);
   }
}