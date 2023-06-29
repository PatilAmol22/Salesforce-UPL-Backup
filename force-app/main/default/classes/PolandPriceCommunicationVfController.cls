public class PolandPriceCommunicationVfController {
	public boolean isTrue{get;set;}
    public String messageStr{get;set;}
    public String pId='';
    public PolandPriceCommunicationVfController(ApexPages.standardController con){
		pId=con.getId();
    }
    
    public void sendAttachmentMethod(){
       	System.debug('pId :'+pId);
        String useremail=UserInfo.getUserEmail();
        System.debug('useremail :'+useremail);
        
        if(pId!=null){
            Map<String,List<String>> acntIdMap = new Map<String,List<String>>();
           	List<Account> accntList=[Select id, (Select id,Name,Email from contacts where Email!=null) from Account where Sales_Org_Code__c='2941'];
            for(Account acntObj:accntList){
                for(Contact conOBj:acntObj.contacts){
                    List<String> contEmailList=new List<String>();
                    if(!acntIdMap.containsKey(acntObj.Id)){
                        contEmailList.add(conOBj.Email);
                        acntIdMap.put(acntObj.Id,contEmailList);
                    }else{
                        acntIdMap.get(acntObj.Id).add(conOBj.Email);
                    }
                }
            }
            
            List<Poland_Price_Communication__c> pPCList=[Select Id,Account__c,Description__c from Poland_Price_Communication__c where Id=:pId limit 1];
            for(Poland_Price_Communication__c pcObj:pPCList){
                if(acntIdMap.containsKey(pcObj.Account__c)){
                    List<Blob> blobList=new List<Blob>();
                    List<String> fileNameList=new List<String>();
                    List<String> filetypeList=new List<String>();
                    Map<String,String> contenttypeMap=new Map<String,String>();
                    String[] contentTypeList= new String[]{'application/html','application/java-archive','application/javascript','application/msword','application/octet-stream','application/octet-stream;type=unknown','application/opx','application/pdf','application/postscript','application/rtf','application/vnd.google-apps.document','application/vnd.google-apps.drawing','application/vnd.google-apps.form','application/vnd.google-apps.presentation','application/vnd.google-apps.script','application/vnd.google-apps.spreadsheet','application/vnd.ms-excel','application/vnd.ms-excel.sheet.macroEnabled.12','application/vnd.ms-infopath','application/vnd.ms-powerpoint','application/vnd.ms-powerpoint.presentation.macroEnabled.12','application/vnd.ms-word.document.macroEnabled.12','application/vnd.oasis.opendocument.presentation','application/vnd.oasis.opendocument.spreadsheet','application/vnd.oasis.opendocument.text','application/vnd.openxmlformats-officedocument.presentationml.presentation','application/vnd.openxmlformats-officedocument.presentationml.slideshow','application/vnd.openxmlformats-officedocument.presentationml.template','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet','application/vnd.openxmlformats-officedocument.spreadsheetml.template','application/vnd.openxmlformats-officedocument.wordprocessingml.document','application/vnd.openxmlformats-officedocument.wordprocessingml.template','application/vnd.visio','application/x-gzip','application/x-java-source','application/x-javascript','application/x-shockwave-flash','application/x-sql','application/x-zip-compressed','application/xhtml+xml','application/xml','application/zip','audio/mp4','audio/mpeg','audio/x-aac','audio/x-ms-wma','audio/x-ms-wmv','audio/x-wav','image/bmp','image/gif','image/jpeg','image/png','image/svg+xml','image/tiff','image/vnd.adobe.photoshop','image/vnd.dwg','image/x-photoshop','message/rfc822','text/css','text/csv','text/html','text/plain','text/rtf','text/snote','text/stypi','text/webviewhtml','text/x-c','text/x-c++','text/xml','video/mp4','video/mpeg','video/quicktime','video/x-m4v','video/x-ms-asf','video/x-msvideo'};
					for(String str:contentTypeList){
                        String[] strSplit= str.split('/');
                        contenttypeMap.put(strSplit[1], str);
                    }
                     
                    
                    List<ContentDocumentLink> cdlList=[SELECT Id, LinkedEntityId, ContentDocumentId, SystemModstamp, IsDeleted FROM ContentDocumentLink where LinkedEntityId=:pId and IsDeleted=false];
                    Set<String> ContentDocumentIdSet=new Set<String>();
                    for(ContentDocumentLink cdlObj:cdlList){
                        ContentDocumentIdSet.add(cdlObj.ContentDocumentId);
                    }
                    List<ContentVersion> cvList=[SELECT Id, Title, Description, ContentBodyId, VersionData, ContentDocumentId,FileType,FileExtension  FROM ContentVersion where ContentDocumentId IN : ContentDocumentIdSet];
                    for(ContentVersion cvObj:cvList){
                        blobList.add(cvObj.VersionData);
                        fileNameList.add(cvObj.Title);
                        if(contenttypeMap.containsKey(cvObj.FileExtension)){
                            filetypeList.add(contenttypeMap.get(cvObj.FileExtension));
                        }
                    }
                    System.debug('blobList : '+blobList);
                    System.debug('fileNameList : '+fileNameList);
                    messageStr='Attachments sent successfully';
                    sendEmail(blobList,fileNameList,filetypeList,acntIdMap.get(pcObj.Account__c),pcObj.Description__c,useremail);
                }
            }
        }
    }
    //Method to Notify User with Success/Error Files after Upload
    public static void sendEmail(List<Blob> fileAttach, List<String> fileName,List<String> filetype, List<String> emailStr,String Description, String useremail){
        
        List<Messaging.EmailFileAttachment> successAttachList=new List<Messaging.EmailFileAttachment>();
        
        for(Integer i=0;i<fileAttach.size();i++){
            Messaging.EmailFileAttachment successAttach = new Messaging.EmailFileAttachment();
            successAttach.setContentType(filetype[i]);
            successAttach.setInline(false);
            successAttach.setFileName(fileName[i]);
            successAttach.Body = fileAttach[i];
            successAttachList.add(successAttach);
        }
        DateTime d = Date.Today() ;
        String dateString =  d.format('dd/MM/yyyy') ;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        //mail.setBccAddresses(emailStr);
        mail.setToAddresses(emailStr);
        mail.setCcAddresses(new String[]{useremail});
        mail.setSubject('Poland Price Communication File Attachment');
        //mail.setHtmlBody('Dear User,<br /><br />Please find the price communication attached to this email.<br />'+Description+'<br /><br />Date: '+dateString+'<br /><br />Regards,<br/>UPL Salesforce Administrator<br />');
        if(Description!=null){
            mail.setHtmlBody('Dear User,<br /><br />Please find the price communication attached to this email.<br />'+Description+'<br /><br />Date: '+dateString+'<br /><br />Regards,<br/>UPL Salesforce Administrator<br />');
        }else{
            mail.setHtmlBody('Dear User,<br /><br />Please find the price communication attached to this email.<br /><br />Date: '+dateString+'<br /><br />Regards,<br/>UPL Salesforce Administrator<br />'); 
        }
        mail.setFileAttachments(successAttachList); 
        
        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}