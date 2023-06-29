/*******************************************************************************************
* @Name         Sales Forecast Generation
* @Author       Nikhil Dhoke
* @Date         13/08/2021
* @Group        SKI
* @Description  This batch class will create Sales Forecasts.
*******************************************************************************************/
global class SalesForeCastBatch implements Database.Batchable<sObject>{

  global String month = '';
  global String year = '';
  global String query = '';
  global Sales_Forecast_Setting__c sfs = new Sales_Forecast_Setting__c();
  global String type = '';
  global String email = '';
  global String salesOrg_Code = '';

  /*
  * @Description - This batch get called from SalesForeCastController class. Constructor which initialises all the respective input values with the instance variables.
  * @Param String - month, year, Sales Forecast Setting record, query, type of operation, email id, Sales Org code
  * @return  - N/A.
  */
  global SalesForeCastBatch(String mnth, String yr, Sales_Forecast_Setting__c fs, String qry, String tp, String eml, String salesOrg) {
      this.month = mnth;
      this.year = yr;
      this.sfs = fs;
      this.query = qry;
      this.type = tp;
      this.email = eml;
      this.salesOrg_Code = salesOrg;
  }

  /*
  * @Description - Standard method of a Batchable interface which get called after constructor.
  * @Param - BatchableContext
  * @return  - query result.
  */
  global Database.QueryLocator start(Database.BatchableContext BC){
     /*  system.debug('start method ****');
      system.debug('year>>----->'+ year);
      system.debug('month>>----->'+ month);
      system.debug('sfs>>----->'+ sfs);
      system.debug('type>>----->'+ type);
      system.debug('query>>----->'+ query); */
      //String str = 'SELECT id, name from Account Limit 5';
      return Database.getQueryLocator(query);
   }
 
  /*
  * @Description - Standard method of a Batchable interface which get called after start method. This method will call method from SalesForeCastController class to create SalesAgreements.
  * @Param - BatchableContext, List of Forecast Account
  * @return  - N/A.
  */
   global void execute(Database.BatchableContext BC, List<Forecast_Account__c> scope){
      /* system.debug('execute method ****');
      system.debug('year>>----->'+ year);
      system.debug('month>>----->'+ month);

      system.debug('scope ---> '+ scope); */
      try{
        if(scope.size()>0){
          /* ---------------- Start SKI(Nik) : #CR155 : Ownership Logic added... : 13-07-2022	------------- */
          String ownrId = '';
          if(scope[0].Territory__r.TerritoryManager__c != null){
            ownrId = scope[0].Territory__r.TerritoryManager__c;
          }
          else if(scope[0].Territory__r.Region__r.RegionHead__c != null){
            ownrId = scope[0].Territory__r.Region__r.RegionHead__c;
          }
          else if(scope[0].Territory__r.Zone__r.ZonalHead__c != null){
            ownrId = scope[0].Territory__r.Zone__r.ZonalHead__c;
          }

          SalesForeCastController.createSalesForeCast(scope[0].Account__c,scope[0].Territory__r.Region__c,scope[0].Account__r.SAP_Code__c,scope[0].Territory__r.TerritoryCode__c,scope[0].Territory__c,ownrId,month,year,sfs,type,scope[0].Territory__r.Region__r.RegionHead__c);
          /* ----------------- End SKI(Nik) : #CR155 : Ownership Logic added... : 13-07-2022 ----------- */
        }
      }
      catch(Exception ex){
        system.debug('Exception in batch execute method ');
        system.debug('Exception is - ' + ex);
        system.debug('Exception at Line no  - ' + ex.getLineNumber());
      }
      
      
    }
 
    /*
    * @Description - Standard method of a Batchable interface which get called after execute method. This method will send an email and will call SalesAgreementScheduleUpdateBatch batch class.
    * @Param - BatchableContext
    * @return  - N/A.
    */
    global void finish(Database.BatchableContext BC){
      /* system.debug('finish method ****');
      system.debug('year>>----->'+ year);
      system.debug('month>>----->'+ month);
      system.debug('email>>----->'+ email); */
      try{

      
        Boolean flag = false;

        List<String> jobIdList = new List<String>();
        List<Salesforecast_Batch_Process__c> sfbpList = new List<Salesforecast_Batch_Process__c>();
        sfbpList = [SELECT Id, Name, Job_Id__c FROM Salesforecast_Batch_Process__c WHERE 
                  Name IN ('SA Batch 1','SA Batch 2','SA Batch 3')];

        if(sfbpList.size()>0){
          
          for(Salesforecast_Batch_Process__c sfbp : sfbpList){
            if(sfbp.Job_Id__c != null){
              jobIdList.add(sfbp.Job_Id__c);
            }
          }

          if(jobIdList.size()>0){
            List<AsyncApexJob> aaj = new List<AsyncApexJob>();
            aaj = [SELECT Id, JobType, Status, ApexClass.Name FROM AsyncApexJob WHERE ApexClass.Name='SalesForeCastBatch' 
                  AND Status = 'Completed' AND ID IN: jobIdList];
            if(aaj.size() == 3){
              flag = true;

              for(Salesforecast_Batch_Process__c sfbp : sfbpList){
                if(sfbp.Name == 'SA Batch 1'){
                    sfbp.Job_Id__c = '';
                }
                else if(sfbp.Name == 'SA Batch 2'){
                    sfbp.Job_Id__c = '';
                }
                else if(sfbp.Name == 'SA Batch 3'){
                    sfbp.Job_Id__c = '';
                }
              }

              update sfbpList;
            }       
          }
        }
        
        if(Test.isRunningTest()){
            flag = true;
        }  
        if(flag == true){
          List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
          List<String> sendTo = new List<String>();
          sendTo.add(email);
          mail.setToAddresses(sendTo);
    
          List<String> ccTo = new List<String>();
          //ccTo.add('shreyashi.ghosh@skinternational.com');
          //ccTo.add('pedro.nery@upl-ltd.com');
          //ccTo.add('rafael.chiavenato@upl-ltd.com');
          ccTo.add('satkari@skinternational.com');
          mail.setCcAddresses(ccTo);
    
          String sub = 'Planejamento de Vendas : '+month+'-'+year;
          mail.setSubject(sub);
    
          String body = 'Prezado Usuário,<br><br> A criação do planejamento de vendas para o mês '+month+'-'+year+ ' está finalizada. <br> As Métricas ainda estão em processamento. Você receberá um e-mail quando finalizado. <br><br> Atenciosamente,<br>Administração SalesForce UPL';
    
          mail.setHtmlBody(body);
    
          mails.add(mail);
    
          Messaging.sendEmail(mails);

        /*  Map<Integer,String> monthMap = new Map<Integer,String>();
          monthMap.put(01,'January');
          monthMap.put(02,'February');
          monthMap.put(03,'March');
          monthMap.put(04,'April');
          monthMap.put(05,'May');
          monthMap.put(06,'June');
          monthMap.put(07,'July');
          monthMap.put(08,'August');
          monthMap.put(09,'September');
          monthMap.put(10,'October');
          monthMap.put(11,'November');
          monthMap.put(12,'December'); */

          Integer mnthVal = 0;
          String mnth2 = '';

          mnthVal = Integer.ValueOf(month);

          mnth2 = getMonthName(mnthVal);
          String batch1 = 'Batch 1';
          String batch2 = 'Batch 2';
          String batch3 = 'Batch 3';

          String query1 = 'SELECT Id, Name, SalesAgreementProduct.SalesAgreementId, SalesAgreementProductId, '+
                    +' SalesAgreementProduct.SalesAgreement.Clone_the_existing_Forecast__c,SalesAgreementProduct.SalesAgreement.Cloned_from_Sales_Agreement__c,SalesAgreementProduct.PricebookEntry.Product2.Default_Quantity_For_Sales_Agreement__c, '+
                        +' StartDate, EndDate, Combination_Key__c, Month__c, Year__c, Sales_Org__c,SalesAgreementProduct.SalesAgreement.Region__r.Region__r.Batch_Number__c '+
                        +' FROM SalesAgreementProductSchedule WHERE Month__c = \''+ mnth2 + '\' '+
                        +' AND Year__c = \''+ year + '\' AND Combination_Key__c = null AND '+
                        +' Sales_Org__c = \''+ salesOrg_Code + '\' AND SalesAgreementProduct.SalesAgreement.Region__r.Region__r.Batch_Number__c=\''+ batch1 + '\' ';
          
          String query2 = 'SELECT Id, Name, SalesAgreementProduct.SalesAgreementId, SalesAgreementProductId, '+
                    +' SalesAgreementProduct.SalesAgreement.Clone_the_existing_Forecast__c,SalesAgreementProduct.SalesAgreement.Cloned_from_Sales_Agreement__c,SalesAgreementProduct.PricebookEntry.Product2.Default_Quantity_For_Sales_Agreement__c, '+	
                        +' StartDate, EndDate, Combination_Key__c, Month__c, Year__c, Sales_Org__c, SalesAgreementProduct.SalesAgreement.Region__r.Region__r.Batch_Number__c '+
                        +' FROM SalesAgreementProductSchedule WHERE Month__c = \''+ mnth2 + '\' '+
                        +' AND Year__c = \''+ year + '\' AND Combination_Key__c = null AND '+
                        +' Sales_Org__c = \''+ salesOrg_Code + '\' AND SalesAgreementProduct.SalesAgreement.Region__r.Region__r.Batch_Number__c=\''+ batch2 + '\' ';
                        
          String query3 = 'SELECT Id, Name, SalesAgreementProduct.SalesAgreementId, SalesAgreementProductId, '+
                    +' SalesAgreementProduct.SalesAgreement.Clone_the_existing_Forecast__c,SalesAgreementProduct.SalesAgreement.Cloned_from_Sales_Agreement__c,SalesAgreementProduct.PricebookEntry.Product2.Default_Quantity_For_Sales_Agreement__c, '+	
                        +' StartDate, EndDate, Combination_Key__c, Month__c, Year__c, Sales_Org__c, SalesAgreementProduct.SalesAgreement.Region__r.Region__r.Batch_Number__c '+
                        +' FROM SalesAgreementProductSchedule WHERE Month__c = \''+ mnth2 + '\' '+
                        +' AND Year__c = \''+ year + '\' AND Combination_Key__c = null AND '+
                        +' Sales_Org__c = \''+ salesOrg_Code + '\' AND SalesAgreementProduct.SalesAgreement.Region__r.Region__r.Batch_Number__c=\''+ batch3 + '\' ';              
                        
          SalesAgreementScheduleUpdateBatch bcn1 = new SalesAgreementScheduleUpdateBatch(month,year,query1,email);
          ID batchprocessid1 = Database.executeBatch(bcn1,500);
          
          SalesAgreementScheduleUpdateBatch bcn2 = new SalesAgreementScheduleUpdateBatch(month,year,query2,email);
          ID batchprocessid2 = Database.executeBatch(bcn2,500);
          
          SalesAgreementScheduleUpdateBatch bcn3 = new SalesAgreementScheduleUpdateBatch(month,year,query3,email);
          ID batchprocessid3 = Database.executeBatch(bcn3,500);
          
          if(Test.isRunningTest() == false){
              System.FlexQueue.moveJobToFront(batchprocessid1);
              System.FlexQueue.moveAfterJob(batchprocessid2,batchprocessid1);
              System.FlexQueue.moveAfterJob(batchprocessid3,batchprocessid2);              
          }

          List<Salesforecast_Batch_Process__c> sfbpList2 = new List<Salesforecast_Batch_Process__c>();
          sfbpList2 = [SELECT Id, Name, Job_Id__c FROM Salesforecast_Batch_Process__c WHERE 
                      Name IN ('SU Batch 1','SU Batch 2','SU Batch 3')];

          for(Salesforecast_Batch_Process__c sfbp : sfbpList2){
              if(sfbp.Name == 'SU Batch 1'){
                  sfbp.Job_Id__c = batchprocessid1;
              }
              else if(sfbp.Name == 'SU Batch 2'){
                  sfbp.Job_Id__c = batchprocessid2;
              }
              else if(sfbp.Name == 'SU Batch 3'){
                  sfbp.Job_Id__c = batchprocessid3;
              }
          }
          
          if(sfbpList2.size()>0){
              update sfbpList2;
          }  
          
        }
      }
      catch(Exception ex){
        System.debug('Exception in SalesForecastBatch finish method at line no- '+  ex.getLineNumber() + ' Exception is -'+ ex);
      }
      
   }

   /*
    * @Description - This method is called in this same batch class from other methods.
    * @Param - month number
    * @return  - month name from map for respective number.
    */
   public static String getMonthName(Integer num){
    Map<Integer,String> monthMap = new Map<Integer,String>();
            monthMap.put(01,'January');
            monthMap.put(02,'February');
            monthMap.put(03,'March');
            monthMap.put(04,'April');
            monthMap.put(05,'May');
            monthMap.put(06,'June');
            monthMap.put(07,'July');
            monthMap.put(08,'August');
            monthMap.put(09,'September');
            monthMap.put(10,'October');
            monthMap.put(11,'November');
            monthMap.put(12,'December');

    return  monthMap.get(num);       
}
}