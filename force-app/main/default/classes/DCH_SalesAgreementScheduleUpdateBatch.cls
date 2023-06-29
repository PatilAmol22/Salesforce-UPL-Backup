/*******************************************************************************************
* @Name         Sales Forecast Schedule Updation (Dutch)
* @Author       Nikhil Dhoke
* @Date         16/05/2023
* @Group        SKI
* @Description  This batch class will Update Sales Agreement Product Schedules (For DUTCH).
*******************************************************************************************/
global class DCH_SalesAgreementScheduleUpdateBatch implements Database.Batchable<sObject> {

    global String saId = '';
    global Integer year = System.Today().Year();
    global String query = '';
    global String salesOrgCode = '';
    global Boolean isSingle = false;


    /*
    * @Description - This batch get called from DCH_SalesAgreementController class or from anonymous window. Constructor which initialises all the respective input values with the instance variables.
    * @Param String saId - Salesagreement id,
             Integer yr - year,
             Boolean isSingle - true or false,
             String salesOrgCode - sales org code.
    * @return  - N/A.
    */
    global DCH_SalesAgreementScheduleUpdateBatch(String saId, Integer yr, Boolean isSingle, String salesOrgCode) {
        this.saId = saId;
        this.year = yr;
        this.isSingle = isSingle;
        this.salesOrgCode = salesOrgCode;
    }

    /*
    * @Description - Standard method of a Batchable interface which get called after constructor.
    * @Param - BatchableContext
    * @return  - query result.
    */
    global Database.QueryLocator start(Database.BatchableContext BC){
     /*  system.debug('start method ****');
      system.debug('query>>----->'+ query); */
      if(isSingle == true){
        query = 'SELECT Id, AccountId, Year__c, StartDate, Cloned_from_Sales_Agreement__c, Cloned_from_Sales_Agreement__r.Cloned_from_Sales_Agreement__c FROM SalesAgreement WHERE Id = \''+ saId + '\'';
      }
      else{
        query = 'SELECT Id, AccountId, Year__c, StartDate, Sale_Org_Code__c, Cloned_from_Sales_Agreement__c, Cloned_from_Sales_Agreement__r.Cloned_from_Sales_Agreement__c FROM SalesAgreement WHERE CALENDAR_YEAR(StartDate) = '+ year +' AND Sale_Org_Code__c = \''+ salesOrgCode + '\'';
      }
      return Database.getQueryLocator(query);
   }

   /*
    * @Description - Standard method of a Batchable interface which get called after start method. This method will call method from DCH_SalesAgreementController class to Update SalesAgreement Product Schedules.
    * @Param - BatchableContext, List of SalesAgreement
    * @return  - N/A.
    */
   global void execute(Database.BatchableContext BC, List<SalesAgreement> scope){
       //system.debug('scope - ' + JSON.serializePretty(scope));
    try{
        if(scope.size()>0){
            DCH_SalesAgreementController.updateSchedules(scope[0].Id,scope[0].AccountId,year,salesOrgCode, scope[0].Cloned_from_Sales_Agreement__c, scope[0].Cloned_from_Sales_Agreement__r.Cloned_from_Sales_Agreement__c);
        }
    }
    catch(Exception ex){
        system.debug('Exception in batch execute method ');
        system.debug('Exception is - ' + ex);
        system.debug('Exception at Line no  - ' + ex.getLineNumber());
    }
   }

   /*
    * @Description - Standard method of a Batchable interface which get called after execute method. This method will send an email.
    * @Param - BatchableContext
    * @return  - N/A.
    */
   global void finish(Database.BatchableContext BC){
    try{
        User activeUser = [SELECT Id, Email FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        List<String> sendTo = new List<String>();
        sendTo.add(activeUser.Email);
        mail.setToAddresses(sendTo);

        List<String> ccTo = new List<String>();
        //ccTo.add('shreyashi.ghosh@skinternational.com');
        //ccTo.add('pedro.nery@upl-ltd.com');
        //ccTo.add('rafael.chiavenato@upl-ltd.com');
        //ccTo.add('satkari@skinternational.com');
        mail.setCcAddresses(ccTo);

        String sub = System.Label.Salesagreement_Product_Schedules_are_updated_successfully +' : '+year;
        mail.setSubject(sub);

        String body = 'Dear User,<br><br> Salesagreement Product Schedules for the Year -'+year+ ' are updated successfully. <br>Administrator SalesForce UPL';

        mail.setHtmlBody(body);

        mails.add(mail);

        Messaging.sendEmail(mails);
    }
    catch(Exception ex){
        system.debug('Exception in batch finish method ');
        system.debug('Exception is - ' + ex);
        system.debug('Exception at Line no  - ' + ex.getLineNumber());
    }
   }
}