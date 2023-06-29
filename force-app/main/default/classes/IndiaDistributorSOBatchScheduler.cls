global class IndiaDistributorSOBatchScheduler implements Schedulable{

    public static String sched = '0 0 0/1 1/1 * ? *';  //Every hour

    global static String scheduleMe() {
        IndiaDistributorSOBatchScheduler SC = new IndiaDistributorSOBatchScheduler(); 
        return System.schedule('India Distributor SO Batch Scheduler', sched, SC);
    }

    global void execute(SchedulableContext sc) {
        IndiaDistributorOrderUpdateBatch b1 = new IndiaDistributorOrderUpdateBatch();
        //b1.execute(BC, salesOrderList);
        Database.executeBatch(b1,200);
        
        
    }
}