public class AccountUpdateController {

    @InvocableMethod
  	public static void getAccountNames(List<ID> territoryIdLsit) {
    	List<Account> accountToUpdateList = [Select Id from Account where Territory_Distributor__c in :territoryIdLsit];
    	List<ID> accountIdList = new List<Id>();
        for(Account account : accountToUpdateList){
            accountIdList.add(account.ID);
        }
        //Sales Area Owner Update -Modified By Nandhini To Pass territoryIdLsit to the AccountUpdateBatch
        AccountUpdateBatch batchInstance = new AccountUpdateBatch(accountIdList,territoryIdLsit);
        Database.executeBatch(batchInstance, 1);
    }
}