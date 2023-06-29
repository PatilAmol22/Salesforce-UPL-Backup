public class sendSMSNurture {
 @AuraEnabled
    public static String csvFileRead(Id contentDocumentId){
         if(contentDocumentId != null) {
            ContentVersion contentVersionObj = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];
            list<String> csvRecordsList = contentVersionObj.VersionData.toString().split('\n');
            set<String> preferredLanguages=new Set<String>();
            Map<String,String> messageMap=new Map<String,String>();
            List<SMS_Template__c> smsTemplateList = new List<SMS_Template__c>();
            for(Integer i = 1; i < csvRecordsList.size(); i++){
                list<String> csvRowData = csvRecordsList[i].split(',');
                System.debug('csvRowData====> '+csvRowData);
                system.debug('mobile number :'+csvRowData[0]);
                preferredLanguages.add(csvRowData[1].trim());
                system.debug('preferredLanguages :'+preferredLanguages);
            }
             if(preferredLanguages !=null && !preferredLanguages.isEmpty()){
               smsTemplateList = [Select id, Text__c,Name__c from SMS_Template__c where ObjectName__c = 'SWAL_Account' AND Name__c IN:preferredLanguages];//chack Langugaes with harsha 
  
             }
             if(smsTemplateList !=null && !smsTemplateList.isEmpty()){
                 for(SMS_Template__c smsTemp:smsTemplateList) {
                     messageMap.put(smsTemp.Name__c,smsTemp.Text__c);
                 } 
                 
             }
             system.debug('messageMap :'+messageMap);
            //sendSMSNurtureBatch smsBatch=new sendSMSNurtureBatch(csvRecordsList,messageMap);
           // Database.executeBatch(smsBatch,1);
             
             
             
              /*for(Integer i = 1; i < csvRecordsList.size(); i++){
                list<String> csvRowData = csvRecordsList[i].split(',');
                  if(messageMap.containsKey(csvRowData[1].trim())){
                      String encodedcontent = EncodingUtil.urlEncode(messageMap.get(csvRowData[1].trim()), 'UTF-8');
                      IntegrationWithKarix.sendSMS(encodedcontent,csvRowData[0] , contentDocumentId , 'Nurture');//check account Id with Harsha
                  }  
              }*/
         }
        
        return 'success';
    }
}