public class DownLoadPDFQuoteController {
    
    
    @AuraEnabled
    public static String downloadPdf(String recordIdOfQuote){
        String response  ='';
        if(recordIdOfQuote!=''){
            Quote quoteObj =[SELECT id, Sales_Org_Code__c,Name,Status 
                             FROM Quote
                             WHERE Id=:recordIdOfQuote];
            System.debug('quoteObj.Status '+quoteObj.Status);
            System.debug('quoteObj.Sales_Org_Code__c '+quoteObj.Sales_Org_Code__c);
            
            //sales Org for East Africa is 2000
            //Sales Org for CAM and Mutlicountry is 5310 and 5320 
            
            if(quoteObj.Status=='Approved' || quoteObj.Status == 'Auto Approved'){
                PageReference thePDF;
                System.debug('quoteObj.Sales_Org_Code__c '+quoteObj.Sales_Org_Code__c);
                if(quoteObj.Sales_Org_Code__c=='2000' || Test.isRunningTest()){
                    thePDF = Page.QuotationPDF;
                    System.debug('Inside East Africa Pdf Downloads 1');
                }
                
                //5711   5712
                //changes due to UPL-CR130 vishal Pawar 24 march 2021 
                //if(quoteObj.Sales_Org_Code__c=='5310' || quoteObj.Sales_Org_Code__c=='5320'){
                if(quoteObj.Sales_Org_Code__c=='5711' || quoteObj.Sales_Org_Code__c=='5712'){
                    System.debug('Inside CAM Pdf Downloads');
                    thePDF = Page.QuotationPDFCAM;
                    System.debug('Inside CAM Pdf Downloads 1');
                }
                thePDF.getParameters().put('qid',recordIdOfQuote);
                thePDF.setRedirect(true);
                quotedocument qd = new quotedocument();
                if(Test.isRunningTest()) { 
                    qd.document = blob.valueOf('Unit.Test');
                } else {
                    qd.document = thePDF.getContentAsPDF();
                }
                //quotedocument qd = new quotedocument();
                //qd.document = thePDF.getContentAsPDF();
                qd.quoteId = recordIdOfQuote;
                insert qd;
                System.debug('Quote Id is '+qd);
                
                
                /*PageReference pg;
PageReference pdf = Page.QuotationPDF;
Attachment attach = new Attachment();  
pdf.getParameters().put('qid',recordIdOfQuote);
Blob body;
try {
body = pdf.getContent();
} catch (VisualforceException e) {
body = Blob.valueOf('Error : ' + e);
}
attach.Body = body;
//System.debug('name of Sales Order '+soObj.Name);
attach.Name = 'Quotation '+Datetime.now().format('dd-MM-yyyy HH:mm')+'.pdf';
attach.ParentId = recordIdOfQuote;
insert attach; */
                response ='success';
            }else{
                response ='failure';
            }
        }
        System.debug('Response is '+response);
        return  response ;
        
        
    }
    
}