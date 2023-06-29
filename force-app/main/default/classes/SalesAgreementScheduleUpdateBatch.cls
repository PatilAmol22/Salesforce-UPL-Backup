global class SalesAgreementScheduleUpdateBatch implements Database.Batchable<sObject>{

  global String month = '';
  global String year = '';
  global String query = '';
  global String email = '';
 
  public SalesAgreementScheduleUpdateBatch(String mnth, String yr, String qry, String eml) {
      this.month = mnth;
      this.year = yr;
      this.query = qry;
      this.email = eml;
  }

  global Database.QueryLocator start(Database.BatchableContext BC){
     // system.debug('SalesAgreementScheduleUpdateBatch start method ****');
      /* system.debug('year>>----->'+ year);
      system.debug('month>>----->'+ month);
      system.debug('query>>----->'+ query); */
      return Database.getQueryLocator(query);
   }
 
   global void execute(Database.BatchableContext BC, List<SalesAgreementProductSchedule> scope){
       system.debug('scope ---> '+ scope);
      //system.debug('SalesAgreementScheduleUpdateBatch execute method ****');
      /* system.debug('year>>----->'+ year);
      system.debug('month>>----->'+ month);

      
      system.debug('scope.size() ---> '+ scope.size()); */
      try{
        /*if(scope.size()>0){
          update scope;
        }*/
        if(scope.size()>0){
                Set<Id> salesAgreementIds = new Set<Id>();
                Set<String> SAIdSet=new Set<String>();
                boolean combinationCheck = false;
                for(SalesAgreementProductSchedule SAPS:scope){
                    if(SAPS.Combination_Key__c == null){
                        //System.Debug('Step 1 > ' + combinationCheck);
                        if(SAPS.SalesAgreementProductId!=null){
                            salesAgreementIds.add(SAPS.SalesAgreementProductId);
                        }
                        if(SAPS.SalesAgreementProduct.SalesAgreement.Clone_the_existing_Forecast__c){ // sap is SalesAgreementProduct of current reference 
                            SAIdSet.add(SAPS.SalesAgreementProduct.SalesAgreement.Cloned_from_Sales_Agreement__c);
                        }
                    }
                }
                
                List<SalesAgreementProductSchedule> SalesAgreementProductScheduleList=new List<SalesAgreementProductSchedule>([select Id,Name,PlannedQuantity,Combination_Key__c, SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c,SalesAgreementProduct.PricebookEntry.Product2.Product_code__c,
                                                                                                                               SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c,SalesAgreementProduct.SalesAgreement.Year__c,SalesAgreementProduct.SalesAgreement.Clone_the_existing_Forecast__c,
                                                                                                                               SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c,SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c
                                                                                                                               from SalesAgreementProductSchedule where SalesAgreementProduct.SalesAgreement.Id IN:SAIdSet]);
                Map<String,SalesAgreementProductSchedule> sapsCombinationKeyMap=new Map<String,SalesAgreementProductSchedule>();
                for(SalesAgreementProductSchedule productSchedule:SalesAgreementProductScheduleList){
                    
                    String recordName=productSchedule.Name;
                    String salesOrgCode=productSchedule.SalesAgreementProduct.SalesAgreement.Sale_Org_Code__c;
                    String customerCode=productSchedule.SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c;
                    String territoryCode=productSchedule.SalesAgreementProduct.SalesAgreement.Region__r.TerritoryCode__c;
                    String monthNumber=productSchedule.SalesAgreementProduct.SalesAgreement.Active_Forecast_Month_Number__c;
                    String year=productSchedule.SalesAgreementProduct.SalesAgreement.Year__c;
                    String productCode=productSchedule.SalesAgreementProduct.PricebookEntry.Product2.Product_code__c;
                    String combinationKey=salesOrgCode+customerCode+territoryCode+monthNumber+year+productCode+recordName;
                   // System.Debug('combinationKey  >> ' + combinationKey);     
                    sapsCombinationKeyMap.put(combinationKey,productSchedule);
                }
            
                if(salesAgreementIds.size()>0){
                   // System.Debug('Step 3 > ' + combinationCheck);
                    Map<Id, SalesAgreementProduct> salesAgrementsMap = new Map<Id, SalesAgreementProduct>([select Id, SalesAgreement.Account.SAP_Code__c,PricebookEntry.Product2.Product_code__c,
                                                                                                       SalesAgreement.Region__r.TerritoryCode__c,SalesAgreement.Sale_Org_Code__c,
                                                                                                       SalesAgreement.Active_Forecast_Month_Number__c,SalesAgreement.Year__c,
                                                                                                       SalesAgreement.Cloned_from_Sales_Agreement__r.Active_Forecast_Month_Number__c,
                                                                                                       SalesAgreement.Cloned_from_Sales_Agreement__r.Year__c
                                                                                                       from SalesAgreementProduct where Id in :salesAgreementIds]);
                
                    for(SalesAgreementProductSchedule SAPS:scope){
                        SalesAgreementProduct sap=null;
                        if(SAPS.SalesAgreementProductId!=null){
                            sap=salesAgrementsMap.get(SAPS.SalesAgreementProductId);
                            //System.debug('sap :'+sap);
                            String combinationKey='';
                            combinationKey+=sap.SalesAgreement.Sale_Org_Code__c;
                            combinationKey+=sap.SalesAgreement.Account.SAP_Code__c;
                            combinationKey+=sap.SalesAgreement.Region__r.TerritoryCode__c;
                            combinationKey+=sap.SalesAgreement.Active_Forecast_Month_Number__c;
                            combinationKey+=sap.SalesAgreement.Year__c;
                            combinationKey+=sap.PricebookEntry.Product2.Product_code__c;
                            if(String.isNotBlank(combinationKey)){
                                SAPS.Combination_Key__c=combinationKey+SAPS.Name;
                            }
                            
                            String recordName=SAPS.Name;
                            String salesOrgCode=sap.SalesAgreement.Sale_Org_Code__c;
                            String customerCode=sap.SalesAgreement.Account.SAP_Code__c;
                            String territoryCode=sap.SalesAgreement.Region__r.TerritoryCode__c;
                            String monthNumber=sap.SalesAgreement.Cloned_from_Sales_Agreement__r.Active_Forecast_Month_Number__c;
                            String year=sap.SalesAgreement.Cloned_from_Sales_Agreement__r.Year__c;
                            String productCode=sap.PricebookEntry.Product2.Product_code__c;
                            
                            String combinationKey2=salesOrgCode+customerCode+territoryCode+monthNumber+year+productCode+recordName;
                            if(sapsCombinationKeyMap.containsKey(combinationKey2)){
                                SAPS.Last_Consensus__c=sapsCombinationKeyMap.get(combinationKey2).PlannedQuantity;
                                SAPS.PlannedQuantity=Integer.valueOf(sapsCombinationKeyMap.get(combinationKey2).PlannedQuantity);
                            }
                            else{
                                SAPS.PlannedQuantity= Integer.valueOf(SAPS.SalesAgreementProduct.PricebookEntry.Product2.Default_Quantity_For_Sales_Agreement__c);
                            }
                           // SAPS.Is_Update_Metrics__c = true;
                        }
                    }
                    
                    if(scope.size()>0){
                        update scope;
                    }
                }
        }  
          
      }
      catch(Exception ex){
        system.debug('Exception in SalesAgreementScheduleUpdateBatch execute method ');
        system.debug('Exception is - ' + ex);
        system.debug('Exception at Line no  - ' + ex.getLineNumber());
          RecordType rcdTp = new RecordType();
          rcdTp = [SELECT Id, Name, DeveloperName, Description, SobjectType, IsActive FROM RecordType WHERE 
                        SobjectType = 'Monitor_Log__c' AND DeveloperName = 'Brazil' ORDER BY LastModifiedDate LIMIT 1];

          Monitor_Log__c ml=new Monitor_Log__c();
          ml.Line_Number__c=ex.getLineNumber();
          ml.Module__c='SalesAgreementScheduleUpdateBatch';
          ml.Message__c=ex.getStackTraceString();
          ml.OwnerId = UserInfo.getUserId();
          if(rcdTp != null){
              ml.RecordTypeId = rcdTp.Id;
          }
          insert ml;
      }
      
      
    }
 
    global void finish(Database.BatchableContext BC){
     
      Boolean flag = false;

      List<String> jobIdList = new List<String>();
      List<Salesforecast_Batch_Process__c> sfbpList = new List<Salesforecast_Batch_Process__c>();
      sfbpList = [SELECT Id, Name, Job_Id__c FROM Salesforecast_Batch_Process__c WHERE 
                Name IN ('SU Batch 1','SU Batch 2','SU Batch 3')];
       
        if(sfbpList.size()>0){ 
    
            for(Salesforecast_Batch_Process__c sfbp : sfbpList){
                if(sfbp.Job_Id__c != null){
                jobIdList.add(sfbp.Job_Id__c);
                }
            }
    
            if(jobIdList.size()>0){
                List<AsyncApexJob> aaj = new List<AsyncApexJob>();
                aaj = [SELECT Id, JobType, Status, ApexClass.Name FROM AsyncApexJob WHERE ApexClass.Name='SalesAgreementScheduleUpdateBatch' 
                        AND Status = 'Completed' AND ID IN: jobIdList];
                if(aaj.size() == 3){
                    flag = true;
    
                    for(Salesforecast_Batch_Process__c sfbp : sfbpList){
                        if(sfbp.Name == 'SU Batch 1'){
                            sfbp.Job_Id__c = '';
                        }
                        else if(sfbp.Name == 'SU Batch 2'){
                            sfbp.Job_Id__c = '';
                        }
                        else if(sfbp.Name == 'SU Batch 3'){
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
            /* List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            List<String> sendTo = new List<String>();
            sendTo.add(email);
            mail.setToAddresses(sendTo);
            
            List<String> ccTo = new List<String>();
            ccTo.add('satkari@skinternational.com');
            mail.setCcAddresses(ccTo);
            
            String sub = 'Atualização das Métricas para Forecast: '+month+'-'+year;
            mail.setSubject(sub);
            
            String body = 'As métricas para o Planejamento de Vendas foram atualizadas com sucesso.  <br></br> <br></br> Atenciosamente,<br></br>Administração Salesforce UPL';
            
            mail.setHtmlBody(body);
            
            mails.add(mail);
            
            Messaging.sendEmail(mails); */
            Integer mnthVal = Integer.ValueOf(month);
            UpdateSalesAgreementMetricsController.executeBatch(getMonthName(mnthVal),year);
        }
    }
    
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