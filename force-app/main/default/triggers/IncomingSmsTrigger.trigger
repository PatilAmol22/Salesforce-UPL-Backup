trigger IncomingSmsTrigger on smagicinteract__Incoming_SMS__c (before insert) {
    
    if(Trigger.isBefore && Trigger.isInsert){
        
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Set<String> mobileNoSet = new Set<String>();
        
        for(smagicinteract__Incoming_SMS__c smsObj:Trigger.New){
            if(String.isNotBlank(smsObj.smagicinteract__Mobile_Number__c)){
                //Remove '91' from Mobile No
                mobileNoSet.add(smsObj.smagicinteract__Mobile_Number__c.removeStart('91'));
            }
        }
        
        //Mapping Account Mobile to Account ID
        List<Account> accountList = [SELECT Id, Mobile__c FROM Account WHERE Mobile__c IN: mobileNoSet AND RecordTypeID=:distributorRecordTypeId];
        System.debug('accountList:'+accountList);
        Map<String, Id> accountIDMap = new Map<String, Id>();
        for(Account accObj:accountList){
            accountIDMap.put(accObj.Mobile__c, accObj.Id);
        }
        System.debug('accountIDMap:'+accountIDMap);
        for(smagicinteract__Incoming_SMS__c smsObj:Trigger.New){
        System.debug('smsObj.smagicinteract__Mobile_Number__c:'+smsObj.smagicinteract__Mobile_Number__c);
            if(String.isNotBlank(smsObj.smagicinteract__Mobile_Number__c)){
                
                //Create New Case with RecordType = 'Distributor'
                Case caseObj = new Case();
                //caseObj.Subject = smsObj.smagicinteract__SMS_Text__c; 
                caseObj.Description = smsObj.smagicinteract__SMS_Text__c;
                caseObj.Origin = 'SMS';
                caseObj.Status = 'New';
                caseObj.RecordTypeId = caseRecordTypeId;
          		System.debug('contains: '+accountIDMap.containsKey(smsObj.smagicinteract__Mobile_Number__c));
                //If Mobile No. found in SFDC, insert New Case with existing Account
                if(accountIDMap.containsKey(smsObj.smagicinteract__Mobile_Number__c.removeStart('91'))){
                    caseObj.AccountId = accountIDMap.get(smsObj.smagicinteract__Mobile_Number__c.removeStart('91'));
                    insert caseObj;   
                    
                    smsObj.smagicinteract__Case__c = caseObj.Id;
                }
                //If Mobile No. not found in SFDC, insert New Account AND insert New Case corressponding to New Account
                else{
                    Account newAccount = new Account();
                    newAccount.Name = 'Not Provided';
                    newAccount.Last_Name__c = 'Not Provided';
                    newAccount.Mobile__c = smsObj.smagicinteract__Mobile_Number__c.removeStart('91');
                    newAccount.RecordTypeId = distributorRecordTypeId;
                    //newAccount.Decision_Maker__pc = 'Yes';
                    insert newAccount;
                    System.debug('newAccount: '+newAccount);
                    
                    caseObj.AccountId = newAccount.id;
                    insert caseObj;
                    
                    smsObj.smagicinteract__Case__c = caseObj.Id;
                }
            }
        }
    }
}