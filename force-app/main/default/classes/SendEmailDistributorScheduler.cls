global class SendEmailDistributorScheduler implements Schedulable{

    global void execute(SchedulableContext sc) {
		SendEmailDistributorsBatch batchObj = new SendEmailDistributorsBatch();
        Database.executeBatch(batchObj,1);           
    }
}