global class CreateAccountTeamMemberBatchScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        CreateAccountTeamMemberBatchClass obj = new CreateAccountTeamMemberBatchClass();
        database.executebatch(obj);

    }
}