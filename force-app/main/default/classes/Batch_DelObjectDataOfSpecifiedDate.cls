global class Batch_DelObjectDataOfSpecifiedDate implements Database.Batchable<sObject>,Database.Stateful{
    
    /*
        Written By - Pravin J.
        Created Date - 08-05-2017
         
        Requirment Descrption :-
        on the Basis of Object and Date Selection we are deleting data from objects.
    */
    
    // Var Declaration.
    
    
    public String objectName; 
    public String StringQuery;
    public list<String> lstOfObjectNames ;
    public DateTime specifiedDate1;
    public DateTime specifiedDate2;
   
       
    public Batch_DelObjectDataOfSpecifiedDate(String objectName,DateTime specifiedDate){
        
         System.debug('Constructor==>');
        
         
        try{
            
            specifiedDate1 = specifiedDate;                           
           
            StringQuery =  'SELECT ID FROM '+objectName+' ';
            StringQuery += 'WHERE CreatedDate <=: specifiedDate1 ';
            
            System.debug('StringQuery==>'+StringQuery);
            
        }catch(Exception Ex){
             System.debug('ErrorLineNumber==>'+ex.getLinenUmber());
             System.debug('Error_Msg==>'+ex.getMessage());
        }
    }  
          
    global Database.Querylocator start(Database.BatchableContext bc){
           
            return database.getQueryLocator(stringQuery);
    }
    
    global void execute(Database.BatchableContext bc,list<sObject> lstOfObjDetail){
        
        System.debug('DeletedData_Size==>'+lstOfObjDetail.size());
        
        try{
                 if(lstOfObjDetail.size()>0){
                    delete lstOfObjDetail;
                 }
        
        }catch(Exception ex){
            System.debug('ErrorLineNumber==>'+ex.getLinenUmber());
            System.debug('Error_Msgs==>'+ex.getMessage());
        } 
       
    }    
    global void finish(Database.BatchableContext bc){    
    
        try{
            
            AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email    from AsyncApexJob where Id =:BC.getJobId()];
      
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'pravin.jagadale@skinternational.com'};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Match Merge Batch ' + a.Status);
            mail.setPlainTextBody('Hello Pravin , <Br/>Records processed ' + a.TotalJobItems +   'with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        }catch(Exception ex){
            System.debug('ErrorLineNumber==>'+ex.getLinenUmber());
            System.debug('Error_Msgs==>'+ex.getMessage());
        }
     }
}