global class MultiCountryMonthlyLiquidationScheduler implements Schedulable{
    global void execute(SchedulableContext SC) {
        MultiCountryMonthlyLiquidationBatch mlb = new MultiCountryMonthlyLiquidationBatch();
        database.executeBatch(mlb);
    }
}