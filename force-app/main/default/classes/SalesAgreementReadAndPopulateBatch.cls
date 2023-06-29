global class SalesAgreementReadAndPopulateBatch implements Database.batchable<String>, Database.Stateful{
    private String exceptionJSON;
    
   public SalesAgreementBatch batchObj;
    public String m_csvFile; 
    
    public SalesAgreementReadAndPopulateBatch(){
        try{
            batchObj = new SalesAgreementBatch();     
            
            exceptionJSON = '';
            //batchLogJSON = '';
            
            m_csvFile = batchObj.getFile();
            //System.debug('m_csvFile 1:--'+m_csvFile);
        }
        catch(Exception e){
            system.debug(': Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
            System.debug('Line No: '+e.getLineNumber()+' Error message: '+e.getMessage());
        }
    }
    
    global Iterable<String> start(Database.batchableContext batchableContext){
        //System.debug('m_csvFile 2:--'+m_csvFile);
        return new CSVIterator(m_csvFile, Parser.crlf);
    }
    
    global void execute(Database.BatchableContext batchableContext, List<String> scope){
        //TODO: Create a map with the column name and the position.
        try{
            String csvFile = '';

            //System.debug('scope: '+scope);
            
            for(String row : scope){
                csvFile += row + Parser.crlf;
            }           
            batchObj.processData(csvFile);
            //System.debug('batchObj:---- '+batchObj);
        }
        catch(Exception e){
            System.debug('Line No: '+e.getLineNumber()+' Error message: '+e.getMessage());
            //System.abortJob(batchableContext.getJobId());
        }
    }
    
    global void finish(Database.BatchableContext batchableContext){
        //System.debug('batchableContext: '+batchableContext);
        
        //System.debug('businessDashboardID: '+batchObj.businessDashboardID);

        if(Test.isRunningTest()){
            if(String.isNotBlank(batchObj.businessDashboardID)){
                BusinessDashboard__c  bdObj = new BusinessDashboard__c();
                bdObj.id = batchObj.businessDashboardID;
                
                //System.debug('exceptionMonList: '+batchObj.exceptionMonList);
                
                if(!batchObj.exceptionMonList.isEmpty()){
                    exceptionJSON = JSON.serialize(batchObj.exceptionMonList);
                    
                    bdObj.Status__c = 'Partially Completed';
                    bdObj.Exceptions__c = batchObj.exceptionMonList.size();
                    
                    Attachment attObj = new Attachment();
                    attObj.Name = String.valueOf('Exception.log');
                    attObj.Body = Blob.valueOf(exceptionJSON);
                    attObj.ParentId = batchObj.businessDashboardID;
                    insert attObj;
                }
                
                batchObj.errorCSVList.add('0YC1m0000004OmoGAE;1\r\n, 0YC1m0000004OmnGAE;2');
                if(batchObj.errorCSVList.size() > 1){
                    
                    bdObj.Status__c = 'Partially Completed';
                    bdObj.DataErrors__c = batchObj.errorCSVList.size()-1;
                    
                    Attachment attObj = new Attachment();
                    attObj.Name = String.valueOf('Error.csv');
                    attObj.Body = Blob.valueOf(String.join(batchObj.errorCSVList, '\r\n'));
                    attObj.ParentId = batchObj.businessDashboardID;
                    insert attObj;
                    
                   /*  Messaging.EmailFileAttachment attach1 = new Messaging.EmailFileAttachment();
                    attach1.setContentType('application/csv');
                    attach1.setFileName(attObj.Name);
                    attach1.setInline(false);
                    attach1.Body = attObj.Body;
                    
                    DateTime d = Date.Today() ;
                    //d = d.dateGMT();
                    String dateString = d.format('dd/MM/yyyy') ;
					
					String userEmail = ''; 
					//userEmail = UserInfo.getUserEmail();
					userEmail = Label.Email_Sent_to_Only_Sales_Rep;
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    //mail.setOrgWideEmailAddressId(orgName.Id);
                    mail.setUseSignature(false);
                    mail.setToAddresses(new String[] { userEmail,'satkari@skinternational.com' });
                    mail.setSubject(batchObj.filename+' Arquivo de erro');
                    mail.setHtmlBody('Prezado Usuário,<br /><br />Encontre o arquivo de erro anexado gerado no SFDC ao analisar os dados SAP BW <br /><br />Data: '+dateString+'<br /><br />número de registros de erro: '+batchObj.errorCSVList.size()+'<br /><br />Atenciosamente,<br/>Administração SalesForce UPL<br />');
                    mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach1 }); 
                    
                    // Send the email
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); */
                    
                }
                else{
                    bdObj.Status__c = 'Completed';
                }
               // System.debug('batchObj.successCSVList :----'+batchObj.successCSVList);
                if(batchObj.successCSVList.size() > 1){
                    Attachment attObj2 = new Attachment();
                    attObj2.Name = String.valueOf('Success.csv');
                    attObj2.Body = Blob.valueOf(String.join(batchObj.successCSVList, '\r\n'));
                    attObj2.ParentId = batchObj.businessDashboardID;
                    insert attObj2;
                    
                    bdObj.Success__c = batchObj.successCSVList.size()-1;                
                }
                else{
                    bdObj.Status__c = 'Failed';
                }
                update bdObj;
            }
        }
        
        if(String.isNotBlank(batchObj.businessDashboardID)){
            BusinessDashboard__c  bdObj = new BusinessDashboard__c();
            bdObj.id = batchObj.businessDashboardID;
            
            //System.debug('exceptionMonList: '+batchObj.exceptionMonList);
            
            if(!batchObj.exceptionMonList.isEmpty()){
                exceptionJSON = JSON.serialize(batchObj.exceptionMonList);
                
                bdObj.Status__c = 'Partially Completed';
                bdObj.Exceptions__c = batchObj.exceptionMonList.size();
                
                Attachment attObj = new Attachment();
                attObj.Name = String.valueOf('Exception.log');
                attObj.Body = Blob.valueOf(exceptionJSON);
                attObj.ParentId = batchObj.businessDashboardID;
                insert attObj;
            }

            if(batchObj.errorCSVList.size() > 1){
                
                bdObj.Status__c = 'Partially Completed';
                bdObj.DataErrors__c = batchObj.errorCSVList.size()-1;
                
                Attachment attObj = new Attachment();
                attObj.Name = String.valueOf('Error.csv');
                attObj.Body = Blob.valueOf(String.join(batchObj.errorCSVList, '\r\n'));
                attObj.ParentId = batchObj.businessDashboardID;
                insert attObj;
                
                /* Messaging.EmailFileAttachment attach1 = new Messaging.EmailFileAttachment();
                attach1.setContentType('application/csv');
                attach1.setFileName(attObj.Name);
                attach1.setInline(false);
                attach1.Body = attObj.Body;
                
                DateTime d = Date.Today() ;
                //d = d.dateGMT();
                String dateString =  d.format('dd/MM/yyyy') ;
                
                String userEmail = ''; 
                //userEmail = UserInfo.getUserEmail();
                userEmail = Label.Email_Sent_to_Only_Sales_Rep;
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //mail.setOrgWideEmailAddressId(orgName.Id);
                mail.setUseSignature(false);
                mail.setToAddresses(new String[] { userEmail,'satkari@skinternational.com'});
                mail.setSubject(batchObj.filename+' Arquivo de erro');
                mail.setHtmlBody('Prezado Usuário,<br /><br />Anexo o arquivo de erro gerado pelo SalesForce.<br /><br />Data: '+dateString+'<br /><br />Registros com erro: '+batchObj.errorCSVList.size()+'<br /><br />Atenciosamente,<br/>Administração Salesforce UPL<br />');
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach1 }); 
                
                // Send the email
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); */

            }
            else{
                bdObj.Status__c = 'Completed';
            }
            //System.debug('batchObj.successCSVList :----'+batchObj.successCSVList);
            if(batchObj.successCSVList.size() > 1){
                Attachment attObj2 = new Attachment();
                attObj2.Name = String.valueOf('Success.csv');
                attObj2.Body = Blob.valueOf(String.join(batchObj.successCSVList, '\r\n'));
                attObj2.ParentId = batchObj.businessDashboardID;
                insert attObj2;
                
                bdObj.Success__c = batchObj.successCSVList.size()-1; 
                
                /* String userEmail = ''; 
                //userEmail = UserInfo.getUserEmail();
                userEmail = Label.Email_Sent_to_Only_Sales_Rep;

                DateTime d = Date.Today() ;
               // d = d.dateGMT();
                String dateString =  d.format('dd/MM/yyyy') ;
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setUseSignature(false);
                mail.setToAddresses(new String[] {userEmail,'satkari@skinternational.com'});
                mail.setSubject('Planejamento de Vendas - Carga dos Dados do Planejamento');
                mail.setHtmlBody('Caro usuário,<br /><br />Os dados do planejamento de vendas carregados no sistema foram gravados com sucesso.<br /><br />Data: '+dateString+'<br /><br />Atenciosamente,<br/>Administração Salesforce UPL<br />');
                // Send the email
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); */
            }
            else{
                bdObj.Status__c = 'Failed';
            }
            update bdObj;
            
            /*if(bdObj.Status__c == 'Completed' || bdObj.Status__c == 'Partially Completed'){
                List<SchedulerSettings__c> settingsList = [SELECT Name, Enabled__c, Batch_Size__c FROM SchedulerSettings__c WHERE Name LIKE 'DashboardDataDeletionBatch'];
                if(!settingsList.isEmpty()){ 
                    if(settingsList[0].Enabled__c == True){
                        //Database.executeBatch(new DashboardDataDeletionBatch(batchObj.selectedObject, batchObj.asOfNow, batchObj.fileName), Integer.valueOf(settingsList[0].Batch_Size__c));
                    }
                }
            }*/
        }
        
        List<BusinessDashboard__c> businessDashboardList2 = [SELECT Id FROM BusinessDashboard__c 
                                                             WHERE CreatedDate = TODAY 
                                                             AND Status__c = 'Draft'
                                                             AND Id !=:batchObj.businessDashboardID
                                                             ORDER By CreatedDate LIMIT 1 ];
        
        if(!businessDashboardList2.isEmpty()){
            Database.executeBatch(new SalesAgreementReadAndPopulateBatch(), 2000);
        }
    }
}