global class UpdateMetricsBatchNoTwo implements Database.Batchable<sObject>{
    
    public String emailId=null,month=null,year=null;
    public Id salesAgreementId=null;
    public boolean isPlannedQtyManualCheck=false;
    public List<SalesAgreementProductSchedule> lstSalesAgreementProductSchedule = new List<SalesAgreementProductSchedule>();
    public UpdateMetricsBatchNoTwo(String month, String year, String emailId){
        this.emailId=emailId;
        this.month=month;
        this.year=year;
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query=null;
        String batch_number='Batch 2';
        /* System.debug('in batch 2 year in batch 2 '+year);
        System.debug('in batch 2 month in batch 2 '+month); */
        query='SELECT Id, Name, Is_Update_Metrics__c,Planned_Quantity_Manual_Check__c FROM SalesAgreementProductSchedule where year__c=\''+year+'\' AND month__c=\''+month+'\' AND SalesAgreementProduct.SalesAgreement.Region__r.Region__r.Batch_Number__c=\''+ batch_number + '\' AND SalesAgreementProduct.SalesAgreement.Is_SA_to_be_used_in_account_forecast__c=true '+(Test.isRunningTest()?' LIMIT 1':'');
        //query='SELECT Id, Name, Is_Update_Metrics__c,Planned_Quantity_Manual_Check__c FROM SalesAgreementProductSchedule where year__c=\''+year+'\' AND month__c=\''+month+'\' AND SalesAgreementProduct.SalesAgreement.Is_SA_to_be_used_in_account_forecast__c=true AND SalesAgreementProduct.SalesAgreement.Region__r.Region__r.Batch_Number__c=:batch_number';
            
        //System.debug('query : '+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<SalesAgreementProductSchedule> scope){
        //System.debug('scope : '+scope);
        for (SalesAgreementProductSchedule sapc : scope) {
            sapc.Is_Update_Metrics__c = true;
            lstSalesAgreementProductSchedule.add(sapc);
        }
        //System.debug(' in batch 2 lstSalesAgreementProductSchedule :'+lstSalesAgreementProductSchedule);
        update lstSalesAgreementProductSchedule;
    }
    global void finish(Database.BatchableContext bc){
        //System.debug('lstSalesAgreementProductSchedule size :'+lstSalesAgreementProductSchedule.size());
        Set<Id> jobIds=new Set<Id>();
        for(Salesforecast_Batch_Process__c sbpObj:[Select Name,Job_Id__c from Salesforecast_Batch_Process__c where Name IN ('UM Batch 1', 'UM Batch 3') ]){
            jobIds.add(sbpObj.Job_Id__c);
        }
        
        List<AsyncApexJob> apexJobList=[SELECT Id, JobType, Status, ApexClassId, CompletedDate, JobItemsProcessed FROM AsyncApexJob where Id IN : jobIds And Status='Completed' And JobType='BatchApex'];
        boolean isMailSent=false;
        
        if(apexJobList.size()==2){
            //isMailSent=SendMail(emailId,month,year); // commented by Nik (SKI) for CR#162...
            /* ------------------------- Start Nik (SKI) : CR#162 ------------------------------------------------- */
            isMailSent= true; 
            NonForecastAccountMetricsUpdateBatch bcn1 = new NonForecastAccountMetricsUpdateBatch(month,year,emailId);
            ID batchprocessid = Database.executeBatch(bcn1,1);
            /* ------------------------- End Nik (SKI) : CR#162 ------------------------------------------------- */
        }
        
        /*if(Test.isRunningTest()){     // commented by Nik (SKI) for CR#162...
            isMailSent=SendMail(emailId,month,year);
        }*/

        if(isMailSent){
            List<Salesforecast_Batch_Process__c> sbpL=[Select Name,Job_Id__c from Salesforecast_Batch_Process__c where Job_Id__c!=null And (Name='UM Batch 1' OR Name='UM Batch 2' OR Name='UM Batch 3')];
            for(Salesforecast_Batch_Process__c sbpO:sbpL){
                sbpO.Job_Id__c='';
            }      
            update sbpL;      
        }
        
    }    
    /* ---------------------------------- Start Nik (SKI) : CR#162 -------------------------------------------- */
    /*public static boolean SendMail(String emailId,String mnth, String yr){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String sub = 'Atualização das Métricas para Forecast: '+getMonthNumber(mnth)+'-'+yr;
        //System.debug('emailId :'+emailId);  
        String[] email = new String[]{emailId,'satkari@skinternational.com'};
        mail.setToAddresses(email);
        mail.setSubject(sub);
        //mail.setPlainTextBody('Total '+lstSalesAgreementProductSchedule.size()+' Metrics Updated Of Sales Agreement Product Schedule');
        mail.setHtmlBody('Prezado Usuário, <br><br> As métricas para o Planejamento de Vendas foram atualizadas com sucesso. <br><br> Atenciosamente,<br>Administração SalesForce UPL');
        Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
        return true;
    }
    
    public static Integer getMonthNumber(String mnth){
        Map<String,Integer> monthMap = new Map<String,Integer>();
                monthMap.put('January',01);
                monthMap.put('February',02);
                monthMap.put('March',03);
                monthMap.put('April',04);
                monthMap.put('May',05);
                monthMap.put('June',06);
                monthMap.put('July',07);
                monthMap.put('August',08);
                monthMap.put('September',09);
                monthMap.put('October',10);
                monthMap.put('November',11);
                monthMap.put('December',12);

        return  monthMap.get(mnth);       
    }*/
    /* ---------------------------------- End Nik (SKI) : CR#162 -------------------------------------------- */
}