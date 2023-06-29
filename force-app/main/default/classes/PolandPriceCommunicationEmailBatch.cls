global class PolandPriceCommunicationEmailBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {

        boolean isEmailChecked=true;
        boolean isEmailSent=false;
        String query = 'SELECT Id,Description__c,Contact__c,Contact__r.Email FROM Poland_Price_Communication__c where isEmailChecked__c='+isEmailChecked+' AND isEmailSent__c='+isEmailSent+'';

        return Database.getQueryLocator(query);

    }
    
    global void execute(Database.BatchableContext BC, List<Poland_Price_Communication__c> pcList) {
		
        String emailStr=pcList[0].Contact__r.Email;	
        String descriptionStr=pcList[0].Contact__r.Email;
        for(Poland_Price_Communication__c pPCObj : pcList){
            pPCObj.isEmailSent__c=true; 
        }
        update pcList;
		sendEmailMethod(pcList, emailStr);
         

    }   

    global void finish(Database.BatchableContext BC) {

    }
    
    public static void sendEmailMethod(List<Poland_Price_Communication__c> polandPriceCommList, String emailStr){
        
        String pId=polandPriceCommList[0].Id;
        if(pId!=null){
            if(emailStr!=null){
                    List<Blob> blobList=new List<Blob>();
                    List<String> fileNameList=new List<String>();
                    List<String> filetypeList=new List<String>();
                    Map<String,String> contenttypeMap=new Map<String,String>();
                    
                    String[] contentTypeList= new String[]{'application/html','application/java-archive','application/javascript','application/msword','application/octet-stream','application/octet-stream;type=unknown','application/opx','application/pdf','application/postscript','application/rtf','application/vnd.google-apps.document','application/vnd.google-apps.drawing','application/vnd.google-apps.form','application/vnd.google-apps.presentation','application/vnd.google-apps.script','application/vnd.google-apps.spreadsheet','application/vnd.ms-excel','application/vnd.ms-excel.sheet.macroEnabled.12','application/vnd.ms-infopath','application/vnd.ms-powerpoint','application/vnd.ms-powerpoint.presentation.macroEnabled.12','application/vnd.ms-word.document.macroEnabled.12','application/vnd.oasis.opendocument.presentation','application/vnd.oasis.opendocument.spreadsheet','application/vnd.oasis.opendocument.text','application/vnd.openxmlformats-officedocument.presentationml.presentation','application/vnd.openxmlformats-officedocument.presentationml.slideshow','application/vnd.openxmlformats-officedocument.presentationml.template','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet','application/vnd.openxmlformats-officedocument.spreadsheetml.template','application/vnd.openxmlformats-officedocument.wordprocessingml.document','application/vnd.openxmlformats-officedocument.wordprocessingml.template','application/vnd.visio','application/x-gzip','application/x-java-source','application/x-javascript','application/x-shockwave-flash','application/x-sql','application/x-zip-compressed','application/xhtml+xml','application/xml','application/zip','audio/mp4','audio/mpeg','audio/x-aac','audio/x-ms-wma','audio/x-ms-wmv','audio/x-wav','image/bmp','image/gif','image/jpeg','image/png','image/svg+xml','image/tiff','image/vnd.adobe.photoshop','image/vnd.dwg','image/x-photoshop','message/rfc822','text/css','text/csv','text/html','text/plain','text/rtf','text/snote','text/stypi','text/webviewhtml','text/x-c','text/x-c++','text/xml','video/mp4','video/mpeg','video/quicktime','video/x-m4v','video/x-ms-asf','video/x-msvideo','application/vnd.ms-word'};
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
                        if(cvObj.FileExtension=='xls' || cvObj.FileExtension=='xlsx'){
                            filetypeList.add('application/vnd.ms-excel');
                        }
                        if(cvObj.FileExtension=='doc' || cvObj.FileExtension=='docx'){
                            filetypeList.add('application/vnd.ms-word');
                        }
                        if(cvObj.FileExtension=='jpg'){
                            filetypeList.add('image/jpeg');
                        }
                        if(cvObj.FileExtension=='txt'){
                            filetypeList.add('text/plain');
                        }
                        if(contenttypeMap.containsKey(cvObj.FileExtension)){
                            filetypeList.add(contenttypeMap.get(cvObj.FileExtension));
                        }
                    }
                    System.debug('blobList : '+blobList);
                    System.debug('fileNameList : '+fileNameList);
                	System.debug('filetypeList : '+filetypeList);
                    //if(!Test.isRunningTest()){
                        sendEmail(blobList,fileNameList,filetypeList,emailStr,polandPriceCommList[0].Description__c);
					//}
                    
            }
              
    	}
    }
    public static void sendEmail(List<Blob> fileAttach, List<String> fileName,List<String> filetype, String emailStr,String Description){
        
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
        //mail.setUseSignature(false);
        mail.setToAddresses(new String[]{emailStr});
        mail.setSubject('Cennik UPL');
        if(Description!=null){
            mail.setHtmlBody('Drogi Odbiorco,<br /><br />W załączniku przesyłamy aktualny cennik.<br />'+Description+'<br /><br />Data: '+dateString+'<br /><br />Serdecznie pozdrawiamy,<br/>Zespół UPL<br />');
        }else{
            mail.setHtmlBody('Drogi Odbiorco,<br /><br />W załączniku przesyłamy aktualny cennik.<br /><br />Data: '+dateString+'<br /><br />Serdecznie pozdrawiamy,<br/>Zespół UPL<br />'); 
        }
        mail.setFileAttachments(successAttachList); 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}