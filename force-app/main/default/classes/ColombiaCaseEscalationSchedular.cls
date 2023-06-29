/*
*   Author : EY
*   Schedular Class - ColombiaCaseEscalationSchedule
*   CR: APPS-2074
*   CreatedDate: 15-Oct-2022
*   Modified Date: 02-Nov-2022
*   Description - If no action on case in 48 hours, 
                  then case should be escalated. 
                  An email will be sent to respective users 
**/
global class ColombiaCaseEscalationSchedular implements Schedulable{
    global void execute(SchedulableContext sc) {
      Database.executeBatch(new ColombiaCaseEscalationBatch(),5);
      Database.executeBatch(new SpainPortugalCaseEscalationBatch(),5);
      
    }
}