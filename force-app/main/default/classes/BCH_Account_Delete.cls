global class BCH_Account_Delete implements Database.Batchable<sObject>,Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([Select id,RecordType.Name, Mobile__c, Name,IsPersonAccount from Account where CreatedBy.Name = 'Varun Shrivastava' and RecordType.Name = 'Distributor' and CreatedDate > 2021-06-14T15:50:43.343+05:30 ]);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accountRecordList){
        
        if(accountRecordList.size() > 0)
        delete accountRecordList;
       
	}
    
    global void finish(Database.BatchableContext bc){
        
    }
    
}