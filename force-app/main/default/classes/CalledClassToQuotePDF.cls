global class CalledClassToQuotePDF{
    //public Id qId='';
    
   
    
    
    webservice static void CalledClassToQuotePDFID(Id quteId){       
        PageReference thePDF = Page.QuotationPDF;
        thePDF.getParameters().put('qid',quteId);
        thePDF.setRedirect(true);
        
        quotedocument qd = new quotedocument();
        
        if(Test.isRunningTest()) { 
            qd.document = blob.valueOf('Unit.Test');
        } else {
            qd.document = thePDF.getContentAsPDF();
        }
        
        
        qd.quoteId = quteId;
        insert qd;
        
    }
    
    /* webservice static void CalledClassToQuotePDFID(Id quteId){       
        System.debug('Quote id is '+quteId);
        PageReference pg;
        PageReference pdf = Page.QuotationPDF;
        Attachment attach = new Attachment();  
        pdf.getParameters().put('qid',quteId);
        Blob body;
        try {
            body = pdf.getContent();
        } catch (VisualforceException e) {
            body = Blob.valueOf('Error : ' + e);
        }
        attach.Body = body;
        //System.debug('name of Sales Order '+soObj.Name);
        attach.Name = 'Quotation '+Datetime.now().format('dd-MM-yyyy HH:mm')+'.pdf';
        attach.ParentId = quteId;
        insert attach; 
       // pg = new PageReference('/'+quteId);    
        
    }*/
    
    
}