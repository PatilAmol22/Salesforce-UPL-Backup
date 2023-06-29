/*******************************************************************************************
* @Name         Sales Forecast Generation
* @Author       Azhar Shaikh
* @Date         13/08/2021
* @Group        SKI
* @Description  This class is getting called from LWC and Aura components to read CSV file.
*******************************************************************************************/
public without sharing class MassUploadSalesAgreementController {
    
    /*
    * @Description - This method will return Sales Forecast Setting..
    * @Param - N/A
    * @return  - LIst of Sales Forecast Setting.
    */
    @AuraEnabled
    public static List<Sales_Forecast_Setting__c> getsalesforecastsetting(){
        return [SELECT Id, Name, Active_Forecast_Month__c, Start_Day_Of_Approval__c, End_Day_Of_Approval__c, Start_Day_of_Submission__c, End_Day_of_Submission__c, Sales_Org__c FROM Sales_Forecast_Setting__c limit 1];
    }

    /*
    * @Description - This method will read CSV file and will call respective methods.
    * @Param Id- document id
    * @return Boolean - status value.
    */
    @AuraEnabled
    public static boolean readCSVFile(Id documentId){
        //System.debug('documentId :'+documentId);
        boolean istrue=false;
        if(documentId != null) {
            
            // getting File Data based on document id 
            ContentVersion objVersion = [SELECT Id,title, VersionData FROM ContentVersion WHERE ContentDocumentId =:documentId];
            //System.debug('VersionData  :'+objVersion.VersionData);
            String userId = UserInfo.getUserId();
            String salesOrgId=[Select id from Sales_Org__c where Sales_Org_Code__c='5191' limit 1].Id;
            istrue=FileUtilitySalesAgreementSchdeule.processAttachment('SalesAgreementSchedule',userId,salesOrgId, null, null, objVersion.VersionData); // SKI(Nik) : #CR155 : File name issue while upload : 13-07-2022	// objVersion.title
            if(istrue){
               // System.debug('istrue : '+istrue);
                Database.executeBatch(new SalesAgreementReadAndPopulateBatch(), 2000);
            }
            // split the file data
            //list<String> lstCSVLines = objVersion.VersionData.toString().split('\n');
        }
        return istrue;
    }
    
}