public class GeneratePDFForItaly {
    
    public static void ProcessSalesorderForItaly(Id recordId){
        
        try{
            
            Sales_Order__c soObj = new Sales_Order__c();
            soObj  = [select id,Name, Status__c,Order_Status__c,PDF_Generation_manually__c From Sales_order__c WHERE Id=:recordId LIMIT 1];
            if(soObj.Order_Status__c=='Open' || soObj.Order_Status__c=='In attesa di creazione in SAP' || soObj.PDF_Generation_manually__c==true){
                Attachment attach;
                PageReference pdf = Page.SalesOrderItalyPDF;
                attach = new Attachment(); 
                pdf.getParameters().put('soid',recordId);
                Blob body;
                
                if(Test.isRunningTest()) { 
                    body = blob.valueOf('Unit.Test');
                } else {
                    body = pdf.getContent();
                }
                
                attach.Body = body;
                attach.Name = soObj.Name+'.pdf';
                attach.ParentId = recordId;
                system.debug('Added to check the Record @@@pdf '+attach);
                Database.SaveResult srList=database.insert(attach,false) ;
                if (srList.isSuccess()) {
                    
                    System.debug('Successfully inserted account. Account ID:@@@pdf ' + srList.getId());
                }
                else {
                    
                    for(Database.Error err : srList.getErrors()) {
                        System.debug('The following error has occurred.pdf');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error:@@@pdf ' + err.getFields());
                    }
                }
            } 
        }
        catch(Exception ex){
            System.debug('Errro Occure Line Number '+ex.getLineNumber());
            System.debug('Errro Occure Message '+ex.getMessage());
        }
        
        
        
    }//end of MEthod ProcessSalesorderForItaly
}//end of Class