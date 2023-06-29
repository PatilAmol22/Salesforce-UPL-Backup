global class UpdateMetricsBatch implements Database.Batchable<sObject>{
    
    public String emailId=null,month=null,year=null;
    public Id salesAgreementId=null;
    public boolean isPlannedQtyManualCheck=false;
    public List<SalesAgreementProductSchedule> lstSalesAgreementProductSchedule = new List<SalesAgreementProductSchedule>();
    public UpdateMetricsBatch(String month, String year, String emailId){
        this.emailId=emailId;
        this.month=month;
        this.year=year;
    }
    public UpdateMetricsBatch(Id salesAgreementId,boolean isPlannedQtyManualCheck,String emailId){
        this.salesAgreementId=salesAgreementId;
        this.isPlannedQtyManualCheck=isPlannedQtyManualCheck;
        this.emailId=emailId;
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query=null;
        //System.debug('salesAgreementId :'+salesAgreementId);
        if(!String.isEmpty(salesAgreementId)){
            query='SELECT Id, Name, Is_Update_Metrics__c,Planned_Quantity_Manual_Check__c FROM SalesAgreementProductSchedule where SalesAgreementProduct.SalesAgreement.Id=\''+salesAgreementId+'\''+(Test.isRunningTest()?' LIMIT 1':'');
        }else{
            query='SELECT Id, Name, Is_Update_Metrics__c,Planned_Quantity_Manual_Check__c FROM SalesAgreementProductSchedule where year__c=\''+year+'\' AND month__c=\''+month+'\' AND SalesAgreementProduct.SalesAgreement.Is_SA_to_be_used_in_account_forecast__c=true '+(Test.isRunningTest()?' LIMIT 1':'');
        }
        //System.debug('query : '+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<SalesAgreementProductSchedule> scope){
        //System.debug('scope : '+scope);
        for (SalesAgreementProductSchedule sapc : scope) {
            sapc.Is_Update_Metrics__c = true;
            lstSalesAgreementProductSchedule.add(sapc);
        }
        //System.debug('lstSalesAgreementProductSchedule :'+lstSalesAgreementProductSchedule);
        update lstSalesAgreementProductSchedule;
    }
    global void finish(Database.BatchableContext bc){
        //System.debug('salesAgreementId :'+salesAgreementId);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //System.debug('emailId :'+emailId);  
        String[] email = new String[]{emailId,'satkari@skinternational.com'};
        mail.setToAddresses(email);
        String sub = 'Atualização das Métricas para Forecast: '+getMonthNumber(month)+'-'+year;
        mail.setSubject('Updated Metrics');
        //mail.setPlainTextBody('Total '+lstSalesAgreementProductSchedule.size()+' Metrics Updated Of Sales Agreement Product Schedule');
        mail.setPlainTextBody('Prezado Usuário, <br><br> As métricas para o Planejamento de Vendas foram atualizadas com sucesso. <br><br> Atenciosamente,<br>Administração SalesForce UPL');
        Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});  
        
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
    }
 
 
}