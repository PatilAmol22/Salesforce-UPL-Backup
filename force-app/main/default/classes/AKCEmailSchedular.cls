global class AKCEmailSchedular implements Schedulable{

    global List<Case> listCase;

    global void execute(SchedulableContext SC) {
      System.debug('Execute from Schedular called.... ');
        try{ 
           string query = ''; 
             listCase = new List<Case>(); 
             listCase =[SELECT Id, AccountId, CaseNumber, RecordTypeId, RecordType.Name, TimeLine_Flag_count__c,
                        Status, CreatedDate, Created_By__c, Zonal_Manager__r.email, Data_Pattern_Territory__r.SBU_Head_Id__c, Data_Pattern_Territory__r.TerritoryManager__c, 
                        Data_Pattern_Territory__r.Zonal_Marketing_Manager_1_Id__c FROM Case where  Status='Open' AND 
                        RecordType.Name='Data Pattern Calling form' AND TimeLine_Flag_count__c='0' 
                        AND CreatedDate<=LAST_N_DAYS:2 LIMIT 1];

             if(Test.isRunningTest()){

                listCase =[SELECT Id, AccountId, CaseNumber, RecordTypeId, RecordType.Name, TimeLine_Flag_count__c,
                        Status, CreatedDate, Created_By__c, Zonal_Manager__r.email, Data_Pattern_Territory__r.SBU_Head_Id__c, Data_Pattern_Territory__r.TerritoryManager__c, 
                        Data_Pattern_Territory__r.Zonal_Marketing_Manager_1_Id__c FROM Case where  Status='Open' AND 
                        RecordType.Name='Data Pattern Calling form' AND TimeLine_Flag_count__c='0' 
                        AND CreatedDate<=LAST_N_DAYS:2 LIMIT 1]; 

             }

             if(listCase.size()>0){

                String rcrdTp = 'Data Pattern Calling form';
                String sts = 'Open';
                String cnt = '0';
                query ='SELECT Id, AccountId, CaseNumber, RecordTypeId, RecordType.Name, TimeLine_Flag_count__c, Status, CreatedDate, Created_By__c, Zonal_Manager__r.email, Data_Pattern_Territory__r.SBU_Head_Id__c, Data_Pattern_Territory__r.TerritoryManager__c, Data_Pattern_Territory__r.Zonal_Marketing_Manager_1_Id__c FROM Case where  Status=\''+sts+'\' AND RecordType.Name=\''+rcrdTp+'\' AND TimeLine_Flag_count__c=\''+cnt+'\' AND CreatedDate<=LAST_N_DAYS:2 LIMIT 1';              

                if(Test.isRunningTest()){
                  query ='SELECT Id, AccountId, CaseNumber, RecordTypeId, RecordType.Name, TimeLine_Flag_count__c, Status, CreatedDate, Created_By__c, Zonal_Manager__r.email, Data_Pattern_Territory__r.SBU_Head_Id__c, Data_Pattern_Territory__r.TerritoryManager__c, Data_Pattern_Territory__r.Zonal_Marketing_Manager_1_Id__c FROM Case where  Status=\''+sts+'\' AND RecordType.Name=\''+rcrdTp+'\' AND TimeLine_Flag_count__c=\''+cnt+'\' AND CreatedDate<=LAST_N_DAYS:2 LIMIT 1';              
                }

                system.debug('query :- '+ query);
                AKCEmailBatch btch = new AKCEmailBatch(query);
                database.executebatch(btch,1);

             } 

        }
        catch(Exception e){
            System.debug('Exception>>----->'+e);
          }
        }
}