global with sharing class InvokePDF {
    
    //Method Invoked by Process builder
    @InvocableMethod
    global static void savePDF(List<String> idList){ 
        try{
            System.debug('----------InvokePDF----------');
            
            //Getting first record ID from List of IDs
            String recordId = idList[0];
            System.debug('Record Id: '+recordId);
            
            //Query CSR Object for all the necessary fields to be populated in PDF
            List<CSR__c> csrList = [SELECT Id, Name, RecordType.DeveloperName, RecordType.Name
                                    FROM CSR__c WHERE ID = :recordId]; 
            System.debug('csrList: '+csrList);
            
            //Assign returned result to CSR Object
            CSR__c csrObj = csrList[0];
            
            PageReference pagePdf;
            
            //Redirect to CSR Page based on CSR Record Type to generate appropriate PDF
            if(csrObj.RecordType.DeveloperName == 'Standard' ){   
                pagePdf = Page.AttachPdfCSR;
                System.debug('Standard');
            }
            else{
                pagePdf = Page.AttachPDFOutSideCSR;
                System.debug('Outside CSR');
            }
            
            //Pass serialized CSR object as param to VF
            pagePdf.getParameters().put('id', recordId);
            
            //Get PDF as Blob and save to Attachment against CSR record
          Blob pdfPageBlob ;//= pagePdf.getContentAsPDF();
        if(!test.isRunningTest()){
                system.debug('inside If');
                pdfPageBlob = pagePdf.getContentAsPDF();// ApexPages.currentPage().getContentAsPDF();
            }else{
                pdfPageBlob = blob.valueof('TEST');
            }
            Attachment attachObj = new Attachment();
     
            attachObj.Body = pdfPageBlob; 
            attachObj.ParentID = recordId; 
            attachObj.Name = 'CSR '+csrObj.RecordType.Name+' '+csrObj.Name+'.pdf';
            attachObj.Description = 'CSR '+csrObj.RecordType.Name;
            insert attachObj;     

            System.debug('attachObj: '+attachObj);
            USSharePointFileTransfer.CallCSRServiceforFileTransfer(recordId);
            
        }
        catch(Exception ex){
            //Print debug logs in case of exception
            System.debug('Attach PDF CSR Exception');
            System.debug('Ex Line No: '+ex.getLineNumber());
            System.debug('Ex Message: '+ex.getMessage());
            System.debug('Stack Trace: '+ex.getStackTraceString());
        }
    } 
}