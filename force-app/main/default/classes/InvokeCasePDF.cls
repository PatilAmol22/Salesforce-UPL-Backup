global with sharing class InvokeCasePDF {
    
    //Method Invoked by Process builder
    @InvocableMethod
    global static void savePDF(List<String> idList){ 
        try{
            System.debug('----------InvokePDF----------');
            
            //Getting first record ID from List of IDs
            String recordId = idList[0];
            System.debug('Record Id: '+recordId);
            
            //Query CSR Object for all the necessary fields to be populated in PDF
            List<Case> caseList = [SELECT Id, CaseNumber,
                                   RecordType.DeveloperName,
                                   RecordType.Name, OwnerId
                                   FROM Case WHERE ID = :recordId]; 
            System.debug('caseList: '+caseList);
            
            //Assign returned result to CSR Object
            Case caseObj = caseList[0];
            
            //Redirect to CSR Page based on CSR Record Type to generate appropriate PDF 
            PageReference pagePdf = Page.AttachPdfCase;
            System.debug('Standard');
            
            //Pass serialized Case object as param to VF
            pagePdf.getParameters().put('id', recordId);
            
            //Get PDF as Blob and save to Attachment against case record
            Blob pdfPageBlob; //= pagePdf.getContent();
            
            if(!test.isRunningTest()){
                system.debug('inside If');
                pdfPageBlob = pagePdf.getContentAsPDF();// ApexPages.currentPage().getContentAsPDF();
            }else{
                pdfPageBlob = blob.valueof('TEST');
            }
            
            Attachment attachObj = new Attachment();
            attachObj.Body = pdfPageBlob; 
            attachObj.ParentID = recordId; 
            attachObj.Name = 'Case '+' '+caseObj.CaseNumber+'.pdf';
            attachObj.Description = 'Case '+caseObj.RecordType.Name;
            insert attachObj; 
            
            System.debug('attachObj: '+attachObj);
            USSharePointFileTransfer.CallCaseServiceforFileTransfer(recordId);
      
        }
        catch(Exception ex){
            //Print debug logs in case of exception
            System.debug('Attach PDF Case Exception');
            System.debug('Ex Line No: '+ex.getLineNumber());
            System.debug('Ex Message: '+ex.getMessage());
            System.debug('Stack Trace: '+ex.getStackTraceString());
        }
    } 
    
}