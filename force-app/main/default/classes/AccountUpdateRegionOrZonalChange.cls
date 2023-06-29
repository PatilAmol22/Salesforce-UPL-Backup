public class AccountUpdateRegionOrZonalChange {
    @InvocableMethod
    public static void getAccountNames(List<TerritoryInfo> TerritoryInfos) {
        system.debug('territoryIdLsit :'+TerritoryInfos);
        List<Id> territoryIds=new List<Id>();
        for(TerritoryInfo TMRec :TerritoryInfos){
            for(id TMId:TMRec.territoryList){
                territoryIds.add(TMId);
            }
            
        }
        system.debug('final collected id:'+territoryIds);
        List<Account> accountToUpdateList = [Select Id from Account where Territory_Distributor__c in :territoryIds];
        List<ID> accountIdList = new List<Id>();
        for(Account account : accountToUpdateList){
            accountIdList.add(account.ID);
        }
        //Sales Area Owner Update -Modified By Nandhini To Pass territoryIdLsit to the AccountUpdateBatch
        AccountUpdateBatch batchInstance = new AccountUpdateBatch(accountIdList,territoryIds);
        Database.executeBatch(batchInstance, 1);
        
    }
    public class TerritoryInfo{
        @InvocableVariable(label='Territory Ids' description='Collecting Territory ids' required=true)
        public List<Id> territoryList;
    }
}