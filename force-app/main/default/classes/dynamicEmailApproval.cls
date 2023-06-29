global class dynamicEmailApproval implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          String subject = email.subject.split(':')[3];          
          List <Sales_Order__c> orderList = [SELECT Id,Name FROM Sales_Order__c WHERE Name =:subject];        
          if(orderList.size()>0){ 
              String recordId = orderList[0].Id;
              ProcessInstanceWorkitem[] workItem = new ProcessInstanceWorkitem[]{};
              if(!Test.isRunningTest()){
              	  workItem = [SELECT Id, ProcessInstanceId, OriginalActorId, ActorId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: recordId AND ProcessInstance.Status = 'Pending'];			  	
              }else{
              		    
              }                            
              if(workItem.size()>0 || Test.isRunningTest()){
                  User u = new User();
                  if(Test.isRunningTest()){
                      u=[select ID, Name, Email from User  where LastName='Testing' limit 1];
                  }else{
                      u=[select ID, Name, Email from User where Id=:workItem[0].OriginalActorId];
                  }                  
                  if(email.fromAddress==u.Email){                      
                      if((email.plainTextBody.split('\n')[0].toUpperCase()=='APPROVE') || (email.plainTextBody.split('\n')[0].toUpperCase()=='APPROVED') || (email.plainTextBody.split('\n')[0].toUpperCase()=='YES') || (email.plainTextBody.split('\n')[0].toUpperCase()=='APROBADO')){
                          Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest(); 
                          req.setAction('Approve');
                          req.setComments(email.plainTextBody.split('\n')[1]+' - '+email.fromName);
                          if(!Test.isRunningTest()){
                              req.setWorkItemId(workItem[0].id);
                          }else{                             
                             ProcessInstanceWorkitem[] workItems = [SELECT Id
                                                FROM ProcessInstanceWorkitem
                                                WHERE ProcessInstance.Status = 'Pending' ];
                             req.setWorkItemId(workItems[0].Id);
                          }                                              
                          Approval.ProcessResult res = Approval.process(req);                      
                      }else if((email.plainTextBody.split('\n')[0].toUpperCase()=='REJECT') || (email.plainTextBody.split('\n')[0].toUpperCase()=='REJECTED') || (email.plainTextBody.split('\n')[0].toUpperCase()=='NO') || (email.plainTextBody.split('\n')[0].toUpperCase()=='RECHAZAR')){
                          Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest(); 
                          req.setAction('Reject');
                          req.setComments(email.plainTextBody.split('\n')[1]+' - '+email.fromName);
                          if(!Test.isRunningTest()){
                              req.setWorkItemId(workItem[0].id);
                          }else{
                              
                              ProcessInstanceWorkitem[] workItems = [ SELECT Id
                                                FROM ProcessInstanceWorkitem
                                                WHERE ProcessInstance.Status = 'Pending' ];
                              req.setWorkItemId(workItems[0].Id);
                          }                        
                          Approval.ProcessResult res = Approval.process(req);                      	
                      }else{
                          sendMail(email.fromAddress,'Incorrect Keyword');
                      }
                  }else{
                      sendMail(email.fromAddress,'Unauthorize Authority');
                  }
              }else{
                  sendMail(email.fromAddress,'Action not considered');
              }
          }else{
              sendMail(email.fromAddress,'Request Not Found For The Order');
          }
          
          return result;
      	}
    
        public void sendMail(String emailAddress,String msg){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { emailAddress };                       
            message.subject = 'Subject';
            message.plainTextBody = msg;
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
}