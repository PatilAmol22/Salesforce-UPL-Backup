global class AKCEmailBatch implements Database.Batchable<sObject>{
    global string query = '';
    global List<Case> listCase = new List<Case>();
    global List<Id> idList;
    global List<User> userList;
    global String[] emailList;
    global String[] toList;
    global String caseOwnerId;

    global AKCEmailBatch(String query){
        this.query = query;
        //listCase = new List<Case>();
        system.debug('query'+ this.query);
    }

    global Database.QueryLocator start(Database.BatchableContext BC){ 
          string query = '';
          query = this.query;
          system.debug('query>>----->'+ query);
            
          return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Case> caseList){
        System.debug('Execute from Batch called.... ');
        System.debug('caseList size..- '+caseList.size());
        
        idList = new List<Id>();
        userList = new List<User>();
        emailList = new List<String>();
        toList = new List<String>();
        caseOwnerId = '';
        toList.add('ankur.raj@upl-ltd.com');             // hardcode value of Users from UPL.....
        toList.add('Swapani.Kulkarni1@concentrix.com');
         // toList.add('nikhil.dhoke@skinternational.com');
          

       try {

            if(caseList.size()>0){
                for(Case obj : caseList){
                    Case cs = new Case();
                    cs.Id = obj.Id;
                    cs.Status = 'Pending';
                    caseOwnerId = obj.Created_By__c;

                    toList.add(obj.Zonal_Manager__r.email); 
                    listCase.add(cs);
                    
                    if(obj.Data_Pattern_Territory__r.SBU_Head_Id__c!=null){
                        idList.add(obj.Data_Pattern_Territory__r.SBU_Head_Id__c);
                    }
                    if(obj.Data_Pattern_Territory__r.TerritoryManager__c!=null){
                        idList.add(obj.Data_Pattern_Territory__r.TerritoryManager__c);
                    }
                    if(obj.Data_Pattern_Territory__r.Zonal_Marketing_Manager_1_Id__c!=null){
                        idList.add(obj.Data_Pattern_Territory__r.Zonal_Marketing_Manager_1_Id__c);
                    }
                }
            }

            if(listCase.size()>0){
                update listCase;

                    if(idList.size()>0){
                        userList = [select Id, name,email from User where Id IN :idList];
                    }

                    if(userList.size()>0){
                        for(User usr : userList){
                            emailList.add(usr.email);
                        }
                    }
                   // emailList.add('prashant.chinchpure@skinternational.com');

                 Id templateId =  [select id, name from EmailTemplate where developername = 'AKC_Data_Pattern'].id;
                System.debug('Template Id is...- '+templateId);

                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                //String[] toAddresses = new String[] {'prashant.chinchpure@skinternational.com'};
                email.setToAddresses(toList);          // To...
                email.setCcAddresses(emailList);    // Cc... 
                // Who you are sending the email to
                email.setTargetObjectId(caseOwnerId);  // case owner id ....(created by Id)
                email.setWhatId(listCase[0].Id);                    //Case Record Id ....
               // email.setorgWideEmailAddressId(orgWideEmailId);
                email.setTemplateId(templateId);
                email.saveAsActivity = false;
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 

               System.debug('caseOwnerId ,...- '+caseOwnerId);
               System.debug('toList ,...- '+toList);
               System.debug('emailList ,...- '+emailList);

            } 

       } catch (Exception e) {
           System.debug('Exception in Execute method....- '+e);
       }      
     
    }

    global void finish(Database.BatchableContext BC){
    //TODO:check if checkbox true then update
    System.debug('listCase size... '+listCase.size());
        System.debug('listCase ... '+listCase);
        

        List<Case> listOfCase = new List<Case>();
        listOfCase = [SELECT Id, AccountId, CaseNumber, RecordTypeId, RecordType.Name, TimeLine_Flag_count__c,
                      Status, CreatedDate, Created_By__c, Zonal_Manager__r.email, Data_Pattern_Territory__r.SBU_Head_Id__c, Data_Pattern_Territory__r.TerritoryManager__c, 
                      Data_Pattern_Territory__r.Zonal_Marketing_Manager_1_Id__c FROM Case where  Status='Open' AND 
                      RecordType.Name='Data Pattern Calling form' AND TimeLine_Flag_count__c='0' 
                      AND CreatedDate<=LAST_N_DAYS:2 LIMIT 1];

        String rcrdTp = 'Data Pattern Calling form';
        String sts = 'Open';
        String cnt = '0';
        String qry ='SELECT Id, AccountId, CaseNumber, RecordTypeId, RecordType.Name, TimeLine_Flag_count__c, Status, CreatedDate, Created_By__c, Zonal_Manager__r.email, Data_Pattern_Territory__r.SBU_Head_Id__c, Data_Pattern_Territory__r.TerritoryManager__c, Data_Pattern_Territory__r.Zonal_Marketing_Manager_1_Id__c FROM Case where  Status=\''+sts+'\' AND RecordType.Name=\''+rcrdTp+'\' AND TimeLine_Flag_count__c=\''+cnt+'\' AND CreatedDate<=LAST_N_DAYS:2 LIMIT 1';              

        if(listOfCase.size()>0){
            AKCEmailBatch btch = new AKCEmailBatch(qry);
            database.executebatch(btch,1);
        }
    
    }
}