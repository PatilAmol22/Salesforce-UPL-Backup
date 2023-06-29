public without sharing class UpdateMetricsController {
  @AuraEnabled
    public static void updateMetrics(Id sAID) {
        //System.debug('Id: '+sAID);
        /*List<SalesAgreementProductSchedule> sapsList=[SELECT Id, Name, Is_Update_Metrics__c FROM SalesAgreementProductSchedule where SalesAgreementProduct.SalesAgreement.Id=:sAID];
        for(SalesAgreementProductSchedule saps:sapsList){
            saps.Is_Update_Metrics__c=true;
        }
        if(sapsList.size()>0){
            update sapsList;
            System.debug('sapsList :'+sapsList);  
        }*/
        String userEmail = ''; 
        //userEmail = UserInfo.getUserEmail();
        userEmail = Label.Email_Sent_to_SalesRep_or_SDM;
        //System.debug('userEmail : '+userEmail);
        UpdateMetricsBatch batchObj=new UpdateMetricsBatch(sAID,true,userEmail);
        Database.executeBatch(batchObj,200);
    }
}