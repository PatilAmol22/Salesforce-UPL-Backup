global class invoiceUpdateScheduler implements Schedulable{
    global void execute(SchedulableContext SC) {
        invoiceUpdateBatch iub = new invoiceUpdateBatch();
        database.executeBatch(iub,50);
    }
}