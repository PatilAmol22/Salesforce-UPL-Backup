public class GeneratePDFForArgentina {
    
    
   
    
    @InvocableMethod
    public static void generatePDF(List<String> sId){
        System.debug('id is send by Process Builder' +sId);
        integer size = sId.size();
        
        if(size>0){
            PageReference pdf = Page.Quotation;
            Attachment attach = new Attachment();  
            Sales_Order__c sObj = new Sales_Order__c();
            
            sObj = [select id,ownerId from Sales_Order__c WHERE Id in:sId LIMIT 1];
            
            String sId1 = sObj.Id; 
            
            List<Sales_Order_Line_Item__c> soliList = new List<Sales_Order_Line_Item__c>();
            soliList =[select id,Name,Sale_Order__c From Sales_Order_Line_Item__c WHERE Sale_Order__c=:sId1];
            
           if(soliList.size()>0){
                pdf.getParameters().put('soid',sId1);
                Blob body;
                try {  
                    body = pdf.getContent();
                } 
                catch (VisualforceException e) {
                    body = Blob.valueOf('Error : ' + e);
                }
                attach.Body = body; 
                attach.Name = 'Quotation '+Datetime.now().format('dd-MM-yyyy HH:mm')+'.pdf';
                attach.ParentId = sId1;
                insert attach;
               //-----------------------------------
                Id NotifyTemplateId;
                NotifyTemplateId = [select id, name from EmailTemplate where developername = : 'InternalApprovalConfirmation'].Id;
 
					Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    
                    email.setTemplateId(NotifyTemplateId);
                    System.debug('NotifyTemplateId');
                    email.setTargetObjectId(sObj.OwnerId);
                     System.debug('u.Id---> '+sObj.ownerId);  
                    email.setWhatId(sObj.id);
                    System.debug('SalesObj.Id ----> '+sObj.id);
                   
                    email.setSaveAsActivity(false);
                    
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                
                //-------------------------------------
            }
            
        }
        
    }   
}