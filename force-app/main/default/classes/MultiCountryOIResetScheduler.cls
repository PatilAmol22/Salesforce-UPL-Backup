global class MultiCountryOIResetScheduler implements Schedulable{
global void execute(SchedulableContext SC) {
        MultiCountryOIResetBatch orb = new MultiCountryOIResetBatch();
        database.executeBatch(orb);
    }
}