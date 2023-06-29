global class BatchParsingScheduler implements Schedulable{
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new BusinessDashboardReadAndPopulateBatch (),600);
    }
}