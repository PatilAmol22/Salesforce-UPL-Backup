Public Class DistributorDocument{
    Public DistributorDocument__c docObj {get;set;}
    //Public attachment attachObj ;
    public String selectedDocument{get;set;}
    Public String AcntId {get;set;}
    Public transient String mydocId {get;set;}
    public transient boolean check {get;set;}
    public transient Blob BlobFileValue {get;set;}
    public String SuccessMessage{get;set;}
    public String fname {get;set;}
    public List<SelectOption> statusOptions { get;set; }
    
    public DistributorDocument(ApexPages.StandardController controller) {
        
       
        docObj = new DistributorDocument__c();
        mydocId = '';
        SuccessMessage='';
        check = false;
        try{
            AcntId = ApexPages.currentPage().getParameters().get('id');
            System.debug('AcntId===>'+AcntId);
        }
        catch(Exception ex){
            system.debug('Exception '+ex.getLineNumber()+'Cause'+ex.getCause());
        }
         Schema.DescribeFieldResult statusFieldDescription = DistributorDocument__c.Document_List__c.getDescribe();
        statusOptions = new list<SelectOption>();
        statusOptions.add(new SelectOption('None','-- None --'));
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues())
        {
            statusOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }  
        
        
    }
    
    public pagereference UploadFile(){
        try{
             PageReference pageRef = new PageReference('/'+AcntId );
                    
            
             if(docObj.Document_List__c==null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter File name'));
                    return null;
                    
                }
                
                else{
               

                if(BlobFileValue  == null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter file before you upload'));
                    return null;  
                }
                else{
                   // BlobFileValue = attachObj.Body;
                    System.debug('--BlobFileValue Size--'+BlobFileValue.Size());
                    System.debug('--fname--'+fname);
                    System.debug('--AcntId--'+AcntId);
                    System.debug('--docObj.Description__c--'+docObj.Description__c);
                    docObj.Distributor__c = AcntId;
                    insert docObj;
                    Attachment attachObj = new Attachment();
                    attachObj.Name = fname;
                    attachObj.parentId = docObj.id;
                    attachObj.body = BlobFileValue;
                    
                    
                    if(docObj.Description__c != null && docObj.Description__c != ''){
                        attachObj.description = docObj.Description__c;
                    }
                    //Attachment insertattach = new Attachment();
                    //insertattach = attachObj;
                    Insert attachObj ;
                    docObj.Document_Name__c=fname;
                    docObj.Attachement_ID__c=attachObj.Id;
                    update docObj;
                    System.debug('docObj'+docObj);
                    System.debug('--attachObj--'+attachObj);
                    if(attachObj.Id!=Null){
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Document Uploaded Succesfully...'));

                    }
                    
                    // attachObj = new Attachment();
                   /* while(attachObj.Id==null){
                        check = false;    
                    }
                    check = true;
                    SuccessMessage ='File Uploaded Successfully';*/
               
                   pageRef.setRedirect(true);
                   return null;

                }
            }
           
        }
        catch(Exception ex){
            System.debug('Exception:'+ex.getCause()+'LineNumber:'+ex.getLineNumber()+'Message:'+ex.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Message==>'+ex.getMessage()+'Line No==>'+ex.getLinenumber()));
            return null;
        }
    }
    
  /*  Public boolean getcheckinsert(){
        if(check){
            return true;
        }
        else{
            return false;
        }
    }*/
}