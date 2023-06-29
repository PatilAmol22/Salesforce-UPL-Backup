/*
@Author: Pranav Dinakaran
@Class_ Description: Apex Batch Class to set update Person Account Fully Registered By and Fully Registered Date
*/
global class BatchAccountUpdate implements Database.Batchable<sObject>{
    
    public List<Account> AllRegisteredList;
    public List<User> ActiveRegisteredByUserList;
    public List<User> InactiveSupervisorList;
    public Map<String,String> ActiveRegisteredByUserMap; 
    
    // Constructor where we Prepare ActiveRegisteredByUserMap 
    global BatchAccountUpdate(){
        ActiveRegisteredByUserList = [SELECT Id, FirstName, LastName, UserRole.name,IsActive 
                                                     FROM User 
                                                     WHERE (UserRole.name LIKE '%Call%' OR UserRole.name LIKE '%CC Lead%') 
                                                     AND Isactive= true ];
       InactiveSupervisorList =[SELECT Id, FirstName, LastName,userName, UserRole.name,IsActive 
                                                     FROM User
                                                    where UserName like'%Rameshniket.patil@concentrix.com%' AND ISActive = true limit 1]; 
        ActiveRegisteredByUserMap = new Map<String,String>();
        for(User ur : ActiveRegisteredByUserList){
            String temp = ur.FirstName+' '+ur.LastName; 
            ActiveRegisteredByUserMap.put(temp,ur.id);    
        }
    }
    
    // Batch Start Method to retrieve those Accounts where status is fully registered  but Fully Registered by field is null
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query;
        if(Test.isRunningTest()){
           query = 'SELECT Id, Registration_By__c, Registration_Status__c, Fully_Registered_By__c, Fully_Registered_Date__c, Registered_DateTime__c, Registered_DateTime_text__c, Name FROM Contact where Fully_Registered_By__c = Null AND Registration_Status__c=\'Fully Registered\' limit 5';
        }
        else{
            query = 'SELECT Id, Registration_By__c, Registration_Status__c, Fully_Registered_By__c, Fully_Registered_Date__c, Registered_DateTime__c, Registered_DateTime_text__c, Name FROM Contact where Fully_Registered_By__c = Null AND Registration_Status__c=\'Fully Registered\'';
        }
        
        System.debug('Database.getQueryLocator(query):'+Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }
    // Batch Execute Method to update Accounts and capture Fully Registered User and Date/Time
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        System.debug('ActiveRegisteredByUserMap: '+ActiveRegisteredByUserMap);
        for(Contact conObj : scope){
            if(ActiveRegisteredByUserMap.containsKey(conObj.Registration_By__c)){
                conObj.Fully_Registered_By__c = ActiveRegisteredByUserMap.get(conObj.Registration_By__c);
                conObj.Fully_Registered_Date__c = conObj.Registered_DateTime__c;
            }
            else{
                conObj.Fully_Registered_By__c = InactiveSupervisorList[0].id;
                conObj.Fully_Registered_Date__c = conObj.Registered_DateTime__c;
            }
        }
        System.debug('scope: '+scope);
        update scope;
    }  
    
    global void finish(Database.BatchableContext BC){
        
    }
}