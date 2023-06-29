global class Schedule_Mexico_Case_Escalation_Batch implements schedulable
{
    global void execute(SchedulableContext sc)
    {
    Mexico_Case_Escalation_Batch b = new Mexico_Case_Escalation_Batch(); 
      database.executebatch(b,10);
    }
}