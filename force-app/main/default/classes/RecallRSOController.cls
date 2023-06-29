/*******************************************************************************************
* @Name         ReCallApproval
* @Author       Satish Tiware <satish.tiware@skinternational.com>
* @Date         13/02/2023
* @Group        SKI
* @Description  This class contains all  methods related to Recall Approval Sub Status.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0           Satish Tiware      13/02/2023           Initial Creation                                                      
*******************************************************************************************/

public without sharing class RecallRSOController {
/*
  * @Description  Fetching Return Sales order Details using respective Return Sales Order Id.
  * @Param        recordId 
  * @return       returns Return Sales order record Details
  */   
@AuraEnabled
    public Static Return_Sales_Order__c getRSO(String recordId){
         Id rsoId=recordId.replace('"','');
         System.debug('RecordId'+rsoId);
        List<Return_Sales_Order__c> rsoList = [SELECT Id, Name, Order_Status__c, RSO_SFDC_Number__c,RSO_Raised_By__c,Refusal__c,
                                         RSO_SAP_Number__c, Return_Type__c, Return_Amount__c, Sub_Status__c,Necessary_Technical_Inspection__c
                                         FROM Return_Sales_Order__c where Id =: rsoId LIMIT 1];
        if(rsoList.size()>0){
            return rsoList[0];
           
        }
        return new Return_Sales_Order__c();
        
}
   /*
  * @Description  Fetching Sub Status values from Custom Metadata.
  * @Param        None
  * @return       returns list of Sub Status Values.
  */   
  
   @AuraEnabled(cacheable=true)
    public static List<RSO_Sub_Status__mdt> getPicklistValue(String Type1,String RsoRaisedBy,String RecStatus,String Refusal){
        List<RSO_Sub_Status__mdt> subStatuslist =[SELECT Id, Label, RSO_Raised_By__c, Return_Type__c,Refusal__c, Sub_Status__c, DeveloperName 
                                            FROM RSO_Sub_Status__mdt
                                            where Return_Type__c=:Type1 AND RSO_Raised_By__c=:RsoRaisedBy AND Refusal__c=:Refusal LIMIT 1];
        System.debug('RecordList'+subStatuslist);
        return subStatuslist;
        
    }
    
      /*
  * @Description  Update Return Sales order Details using Sub Status,RecordId and RSo Raised By.
  * @Param        Sub Status,RecordId and RSo Raised By
  * @return       Update Return Sales order sub Status Details.
  */
    @AuraEnabled
    public static Return_Sales_Order__c updateRSO(String recordId,String picklistValue,string comment){
      /*  Return_Sales_Order__c updatersoList = [SELECT Id, Name, Order_Status__c, RSO_SFDC_Number__c, 
                                         RSO_SAP_Number__c, Return_Type__c, Return_Amount__c, Sub_Status__c 
                                         FROM Return_Sales_Order__c where Id =: recordId LIMIT 1];
    */
            
         Id rsoId=recordId.replace('"','');
        System.debug('RecordId'+rsoId);
        System.debug('Record Id'+recordId);
        System.debug('Value'+picklistValue);

        String result='';
        Return_Sales_Order__c rsoObj = new Return_Sales_Order__c();
        rsoObj.Id=rsoId;
        rsoObj.Sub_Status__c=picklistValue;
        rsoObj.Comment__c=comment;
        update rsoObj;
        
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         
          String[] toAddresses = new String[] {System.label.Email_Service_Address};
          mail.setToAddresses(toAddresses);
          String[] ccAddresses = new String[] {'Satkari@skinternational.com'};
          mail.setCcAddresses(ccAddresses);
          mail.setSenderDisplayName('Display name for email');
          mail.setSubject(rsoObj.Id);
          mail.setPlainTextBody('This is PlainTextBody');
          mail.setHtmlBody('Your Link <a href=https://www.salesforce.com/>click here.</a>');
        if(!Test.isRunningTest()){
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        }
         System.debug('Email Sent');
         return rsoObj;
    }  
             
    }