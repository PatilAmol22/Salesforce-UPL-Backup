global class BCH_Account_Update implements Database.Batchable<sObject>,Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        if(test.isRunningTest()){
             return Database.getQueryLocator([Select Id,PersonMobilePhone,Using_Smart_Phone__c from Account where Recordtype.Name = 'PreRegistered Farmer' AND Using_Smart_Phone__c =NULL]);    
        }
        return Database.getQueryLocator([Select Id,PersonMobilePhone,Using_Smart_Phone__c from Account where Recordtype.Name = 'PreRegistered Farmer' AND Using_Smart_Phone__c =NULL AND CreatedBy.Name = 'Varun Shrivastava']);
        }
    
    global void execute(Database.BatchableContext bc, List<Account> accountRecordList){
        List<Account> accountLstToUpdate = new List<Account>();
        if(accountRecordList.size() > 0)
        {
            for(Account acc : accountRecordList)
            {
                if(acc.PersonMobilePhone !=null)
                acc.Using_Smart_Phone__c ='Yes';
                else if(acc.PersonMobilePhone ==null)
                acc.Using_Smart_Phone__c ='No';
                accountLstToUpdate.add(acc);
            }
        }  
        if(accountLstToUpdate.size()>0)
        {
            UPDATE accountLstToUpdate;
        }
        System.debug('accountLstToUpdate------>'+accountLstToUpdate.size());
	}
    
    global void finish(Database.BatchableContext bc){
        
    }
    
}