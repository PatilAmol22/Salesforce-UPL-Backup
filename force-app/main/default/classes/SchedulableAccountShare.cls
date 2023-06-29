global class SchedulableAccountShare implements Schedulable {
 global void execute(SchedulableContext sc) {
//Using AccountModifiedBatchClass for sharing the Account Owner of Sales Area
     //   AccountShareBatchClass b = new AccountShareBatchClass();
       
        //Parameters of ExecuteBatch(context,BatchSize)
        AccountModifiedBatchClass b=new AccountModifiedBatchClass();
        database.executebatch(b,1000);
     }
}