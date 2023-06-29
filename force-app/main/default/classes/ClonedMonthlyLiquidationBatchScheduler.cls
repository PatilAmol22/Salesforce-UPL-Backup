global class ClonedMonthlyLiquidationBatchScheduler implements Schedulable {
 global void execute(SchedulableContext SC) {
        ClonedMonthlyLiquidationBatch mlb = new ClonedMonthlyLiquidationBatch();
        database.executeBatch(mlb);
    }
}