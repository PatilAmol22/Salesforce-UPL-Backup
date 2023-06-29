global class InventoryLiqEmailService2 implements Messaging.InboundEmailHandler{
    public Map<String,String> combinationKeyMap;
    public List<Opening_Inventory2__c> OIList;
    public String emailSubject ='';
    
    
    public InventoryLiqEmailService2(){
        combinationKeyMap= new Map<String,String>();
        OIList = new List<Opening_Inventory2__c>();
    }
    global Messaging.InboundEmailResult  handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
        
        Date dateofToday = Date.today();
        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        try{
            
            System.debug('email :- '+email);
            emailSubject = email.Subject;
            emailSubject = emailSubject.substring(emailSubject.indexOf(':') + 1);
            
            if(email.textAttachments != NULL){
                System.debug('textAttachments ');
                for(Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments){       
                    system.debug('tAttachment.body>>--->'+tAttachment.body);
                    if(tAttachment.filename.endsWith('.txt')||tAttachment.filename.endsWith('.csv')){
                    System.debug('inside tAttachment');
                  		//FileUtility.processAttachment(tAttachment.fileName, email.fromAddress, emailSubject, tAttachment.body);
                        
                    //fileBody = tAttachment.body;    
                	}
                }
            }
            
            if(email.binaryAttachments!= NULL){
                System.debug('binaryAttachments');
                for(Messaging.InboundEmail.BinaryAttachment attach: email.binaryAttachments){
                    
                    if(attach.filename.endsWith('.txt')||attach.filename.endsWith('.csv')){
                        System.debug('inside BinaryAttachment');
                    FileUtility.processAttachment(attach.filename, email.fromAddress, emailSubject, attach.body);
                    }     
                }
            }
            
            List<SchedulerSettings__c> listSettings= [Select Id, Name, Batch_Size__c , Enabled__c From SchedulerSettings__c Where Name Like 'InventoryLiquidationBatchSize'];
            for(SchedulerSettings__c schObj: listSettings){
                if(schObj.Enabled__c==true){
                   // Database.executeBatch(new BatchInventoryLiquidation(), Integer.valueOf(schObj.Batch_Size__c)); 
                Database.executeBatch(new BusinessDashboardReadAndPopulateBatch(), Integer.valueOf(schObj.Batch_Size__c));
                }
            }
            
        }catch(Exception e){
            result.success = false;
            System.debug(''+e.getMessage());
            System.debug(''+e.getLineNumber());
            
            result.message = 'Due to Technical Reasons,Your data cannot be updated.';
            
        }
        
        return result;
    }
    
    
}