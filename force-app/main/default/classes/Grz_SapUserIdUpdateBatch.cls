/**************************************************************************************************
* Name               : Grz_SapUserIdUpdateBatch                                                      
* Description        : Batch class to update SAP_UserId__c field on Account so that SAP Integration can work
* Created Date       : 21/07/2022                                                                 
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/  
global class Grz_SapUserIdUpdateBatch implements Database.Batchable<sObject>, Schedulable{
    global Database.QueryLocator start(Database.BatchableContext bc){
        Set<String> salesOrgCodeSet = new Set<String>();
        List<String> sapUserIdList = System.Label.Grz_SapUserIdMapping.split(',');
        for (String st : sapUserIdList){
            salesOrgCodeSet.add(st.substringBefore('-').trim());
        }
        String query = 'SELECT Id, Sales_Org_Code__c, Customer_Region__c, Sap_UserId__c FROM Account WHERE RecordType.DeveloperName =\'Distributor\' AND Sales_Org_Code__c IN: salesOrgCodeSet AND Sap_UserId__c = null AND SAP_Customer_Code__c != null';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Account> objectList){
        List<String> dataList = System.Label.Grz_SapUserIdMapping.split(',');
        Map<String, String> salesOrgToSapUserIdMap = new Map<String, String>();
        for (String st : dataList){
            salesOrgToSapUserIdMap.put(st.substringBefore('-').trim(), st.substringAfter('-').trim());
        }
        List<Account> listToUpdate = new List<Account>();
        for (Account acc : objectList){
            if(salesOrgToSapUserIdMap.get(acc.Sales_Org_Code__c) != null && salesOrgToSapUserIdMap.get(acc.Sales_Org_Code__c) != 'Region_Mapping'){
                acc.Sap_UserId__c = salesOrgToSapUserIdMap.get(acc.Sales_Org_Code__c);
            }else{
                if(acc.Customer_Region__c != null){
                    acc.Sap_UserId__c = 'UPLINTCRM' + acc.Customer_Region__c;
                }
            }
            listToUpdate.add(acc);
        }
        if (listToUpdate.size() > 0){
            List<Database.SaveResult> updateResults = Database.update (listToUpdate, false);
            for (Integer i = 0; i < updateResults.size(); i++){
                if (!updateResults.get(i).isSuccess()){
                    // DML operation failed
                    Database.Error error = updateResults.get(i).getErrors().get(0);
                    String failedDML = error.getMessage();
                    system.debug('failedDML' + failedDML);

                    listToUpdate.get(i);//failed record from the list
                    system.debug('Failed ID' + listToUpdate.get(i).Id);
                }

            }
        }
    }

    global void finish(Database.BatchableContext bc){
    }

    //GRZ(Nikhil Verma) added to schedule batch class
    global void execute(SchedulableContext sc) {
        Grz_SapUserIdUpdateBatch b = new Grz_SapUserIdUpdateBatch(); 
        database.executebatch(b);
    }

}