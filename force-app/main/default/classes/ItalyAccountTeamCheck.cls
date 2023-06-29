public class ItalyAccountTeamCheck implements Database.Batchable<sObject> ,System.Schedulable,Database.Stateful{
    static String query;
    static Map<String,Shipping_Location__c> options = new Map<String,Shipping_Location__c>();   
    public List<String> Email_List;
    public Map<String,AccountTeamMember> newMap;
    
    public ItalyAccountTeamCheck(){
        Email_List = new List<String>();
        newMap = new Map<String,AccountTeamMember>();
    }
    
    
    // The batch job starts
    public Database.Querylocator start(Database.BatchableContext bc){
        String query = 'SELECT Id,Distributor__c,OwnerId FROM Shipping_Location__c WHERE Sales_Org_Code__c=\'2410\' AND OwnerIsTMCheck__c=true';
        System.debug('>>>> start ' + query);
        return Database.getQuerylocator(query);
    } 
    
    // The batch job executes and operates on one batch of records
    public void execute(Database.BatchableContext bc, List<Shipping_Location__c> scope){
        System.debug('>>>> execute ' + scope.size());
        for(Shipping_Location__c a:scope){
            options.put(a.Id,a);
        }
        List<AccountTeamMember> recordsToInsertList = new List<AccountTeamMember>();
        Integer AccountTeamMembers;
        if(!options.isEmpty()){
            for(String h:options.keySet()){
                AccountTeamMembers = 0;
                AccountTeamMembers =  [SELECT Count() FROM AccountTeamMember WHERE AccountId = :options.get(h).Distributor__c 
                                       AND UserId = :options.get(h).OwnerId];
                if(AccountTeamMembers == 0){
                    recordsToInsertList.add(New AccountTeamMember(AccountId = options.get(h).Distributor__c,
                                                                  TeamMemberRole = 'Territory Manager',
                                                                  AccountAccessLevel = 'Read',
                                                                  UserId = options.get(h).OwnerId));
                }
                AccountTeamMembers = 0;
            }
            system.debug('recordsToInsertList SAYAN-->'+recordsToInsertList);
            if(!recordsToInsertList.isEmpty()){
                Database.SaveResult[] SaveResultList = Database.insert(recordsToInsertList,false);
                for (Database.SaveResult sr : SaveResultList) {
                    String Row;
                    if (sr.isSuccess()){
                        // Operation was successful, so get the ID of the record that was processed
                        List<AccountTeamMember> SuccessId=[SELECT Id,AccountAccessLevel,AccountId,CreatedById,CreatedDate,UserId
                                                           FROM AccountTeamMember WHERE Id = :sr.getId()];
                        system.debug('SuccessId>>'+SuccessId);
                        for(AccountTeamMember j:SuccessId){
                            if(!newMap.containsKey(j.Id)){
                                newMap.put(j.Id,j);
                                Row = newMap.get(j.Id).AccountId+','+newMap.get(j.Id).AccountAccessLevel+','+newMap.get(j.Id).CreatedById+','+newMap.get(j.Id).CreatedDate+','+newMap.get(j.Id).UserId;
                                Email_List.add(Row);
                            }
                        }
                    }
                    else{
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Account fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }
            recordsToInsertList.clear();
        }
        system.debug('>>>>'+Email_List);
    }
    
    // The batch job finishes
    public void finish(Database.BatchableContext bc){
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :bc.getJobId()]; 
        System.debug('>>>> finish ' + job.Status);
        system.debug('>>>>'+Email_List);
        String csvBody='';
        try{
            if(Email_List != null && Email_List.size() > 0){
                for(String AccTeamRecords:Email_List){
                    csvBody=csvBody+AccTeamRecords+'\n';
                }
                String emailBody = 'Hello Team \n\nAfter the Integration flow has run, '+Email_List.size()+' records got failed and inserted by ItalyAccountTeamCheck class.\n\nThanks ';
                string csvHeader='Distributor id, Account Access Level, Created By Id, Created Date, User Id'+'\n';
                csvBody = csvHeader + csvBody;
                System.debug('Error Message : '+Email_List+ ' Msg : '+csvBody);
                Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
                Blob csvBlob = Blob.valueOf(csvBody); 
                string csvname= 'Inserted Records.csv';
                csvAttachment.setFileName(csvname);
                csvAttachment.setBody(csvBlob);  
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {'ibmgroup@upllimited.onmicrosoft.com'};
                mail.setToAddresses(toAddresses);
                mail.setSubject('Account Team Member insertion details');
                mail.setPlainTextBody(emailBody);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});    
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        catch(Exception exc){
            System.assert(false,'Excetion caused in Sending Mails : '+exc.getMessage());
        }
    }
    public void execute(SchedulableContext sc){
        ItalyAccountTeamCheck b = new ItalyAccountTeamCheck();
        database.executebatch(b,100);
    }
}