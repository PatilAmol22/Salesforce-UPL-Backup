global class MexicoApprovalReminderScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        MexicoApprovalReminder rem = new MexicoApprovalReminder(); 
        Database.executebatch(rem);
    }
}