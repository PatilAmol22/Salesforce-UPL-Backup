/**************************************************************************************************
* Name               : Grz_OnboardingDataDynamic                                                      
* Description        : Used for Customer Onboarding                                                                
* Created By         : Sumit Kumar(Grazitti)   
* JIRA               : APPS-2662,APPS-2665
**************************************************************************************************/
public with sharing class Grz_OnboardingDataDynamic {
    @AuraEnabled
    public static List<sObject> getTableData(String ObjectAPIName, String query,String recordId){
        String objQuery = query+' where Sales_Area__c = \''+recordId+'\' order by createddate';
        System.debug('recordId==>'+recordId);
        System.debug('query : --'+ objQuery);
        List<sObject> getDataList  = Database.query(objQuery);
        System.debug('getDataList : '+getDataList);
        return getDataList;
    }
    
    @AuraEnabled
    public static List<String> getPickList(String objectName, String fieldName) {
        List<String> values = new List<String>();
        List<Schema.DescribeSobjectResult> results = Schema.describeSObjects(new List<String>{objectName});
        
        for(Schema.DescribeSobjectResult res : results) {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
                if (entry.isActive()) {
                    values.add(entry.getValue());
                }
            }
        }
        return values;
    }
}