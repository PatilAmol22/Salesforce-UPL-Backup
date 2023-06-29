global class SalesForeCastDeleteBatch implements Database.Batchable<sObject>{
    global String month = '';
    global String year = '';
    global String query = '';
    global String salesOrgCode = '';
    global String email = '';
    
    global SalesForeCastDeleteBatch(String mnth, String yr, String qry, String orgCode, String eml) {
        this.month = mnth;
        this.year = yr;
        this.query = qry;
        this.salesOrgCode = orgCode;   
        this.email = eml;    
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        /* system.debug('start method ****');
        system.debug('year>>----->'+ year);
        system.debug('month>>----->'+ month);
        system.debug('query>>----->'+ query); */
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<SalesAgreement> scope){
        /* system.debug('execute method ****');
        system.debug('scope ---> '+ scope); */
        try{
          if(scope.size()>0){
            SalesForeCastController.deleteSalesForeCast(scope[0].Id,month,year,salesOrgCode);
          }
        }
        catch(Exception ex){
          system.debug('Exception in batch execute method ');
          system.debug('Exception is - ' + ex);
          system.debug('Exception at Line no  - ' + ex.getLineNumber());
        }        
    }

    global void finish(Database.BatchableContext BC){
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
  
        String sub = 'Planejamento de Vendas : '+getMonthNumber(month)+'-'+year;
        mail.setSubject(sub);
  
       // String body = 'Caro usuário,<br></br><br></br> A criação do planejamento de vendas para o mês '+month+'-'+year+ ' está finalizada.  <br></br> <br></br> Atenciosamente,<br></br>Administração Salesforce UPL';
        String body = 'Prezado Usuário,<br></br><br></br> Os Acordos de Vendas de  '+getMonthNumber(month)+'-'+year+ ' foram deletados com sucesso.  <br></br> <br></br> Atenciosamente,<br></br>Administração SalesForce UPL';
        
  
        mail.setHtmlBody(body);
  
        mails.add(mail);
  
        Messaging.sendEmail(mails);
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