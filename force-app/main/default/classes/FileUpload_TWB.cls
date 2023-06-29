public class FileUpload_TWB {
    public virtual class BaseException extends Exception {}
    public class OtherException extends BaseException {}

    
    @AuraEnabled
   public static List<File_Attachment__c> getAllRecordId(){
       return[select Id,Name From File_Attachment__c WHERE Name = 'Territory Wise Budget'];
   }
    
    //Download URL's for CSV Templates on Interface
    @AuraEnabled
    Public static List<String> getDownloadURLForTemplates(){
        String InstanceURL = URL.getOrgDomainUrl().toExternalForm();      
        List<Document> ListDocumentId = [SELECT Id, Name, DeveloperName from Document WHERE DeveloperName LIKE 'FU_TWB_Template'];
        List<String> DownloadURLForTemplates = new List<String>();
        DownloadURLForTemplates.add(InstanceURL+'/servlet/servlet.FileDownload?file='+ListDocumentId[0].Id);
        Return DownloadURLForTemplates;
    }
   
    
    
    @AuraEnabled
    Public static List<String> readCSVFile(Id idContentDocument){
        String row='';
        list<Territory_Wise_Budget__c> lstToUpsert = new list<Territory_Wise_Budget__c>();
        
        List<String> errorList=new List<String>();
        List<String> successList=new List<String>();
        List<String> eList=new List<String>();
        List<String> successListRows= new List<String>();
        
        Database.UpsertResult[] strList;
        Database.Error[] errs;

        
        if(idContentDocument != null) {
            ContentVersion objVersion = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:idContentDocument];
           	
            list<String> lstCSVLines = objVersion.VersionData.toString().split('\n');
            lstCSVLines[0] = lstCSVLines[0].replaceAll('\n',' ');
             successList.add(system.label.FU_Record_ID+','+lstCSVLines[0]);
             errorList.add(lstCSVLines[0]+','+system.label.FU_Error_Description);

            
                for(Integer i = 1; i < lstCSVLines.size(); i++){
                Territory_Wise_Budget__c ObjTWB =new Territory_Wise_Budget__c();
                row=lstCSVLines[i];
               
                 String csvLine = String.valueOf(lstCSVLines[i]);
                 String prevLine = csvLine;
                 Integer startIndex;
                 Integer endIndex;

        while(csvLine.indexOf('"') > -1){
        
            if(startIndex == null){
                startIndex = csvLine.indexOf('"');
                csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
            }else{
                if(endIndex == null){
                    endIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                }
            }
            
            if(startIndex != null && endIndex != null){
                String sub = csvLine.substring(startIndex, endIndex);
                sub = sub.replaceAll(',', ':comma:');
                csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                startIndex = null;
                endIndex = null;
            }
        }

                list<String> csvRow = csvLine.split(',');
                
                try{
                    if(csvRow.size()!=7) throw new OtherException('Incorrect CSV');
                    
                   ObjTWB.Territory__r = new Territory_Distributor__c (TerritoryCode__c = 'SW'+csvRow[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                   ObjTWB.Product__r = new Product2 (Combination_Key__c = (csvRow[1]+'1210'+csvRow[2]+csvRow[3]).replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                  
                   ObjTWB.Budget__c = Decimal.ValueOf(csvRow[4].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                   ObjTWB.Month__c = (csvRow[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                   ObjTWB.Year__c = (csvRow[6].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                    //Combination key = territory code + product code + month + year
                   ObjTWB.Combination_Key__c = ('SW'+csvRow[0]+csvRow[1]+csvRow[5]+csvRow[6]).replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
               
                   lstToUpsert.add(ObjTWB); 
                   successListRows.add(row);
               }
                catch(Exception e){
                     System.debug('stack trace --->'+ e.getStackTraceString());
                    if(e.getMessage()=='Incorrect CSV'){
                        eList.add(e.getMessage());
                        return eList;
                    }
                    else{
                    errorList.add(row+','+e.getMessage());
                    }
                  }
                }
            
            Schema.SObjectField f = Territory_Wise_Budget__c.Fields.Combination_Key__c;
            
            if(lstToUpsert.size()>0){
                System.debug('lstToUpsert====> '+lstToUpsert);   
                    strList=Database.Upsert(lstToUpsert,f,false);               
            }else{
                 System.debug('Data Not Found');
            }
            if(strList!=null){
            for(Integer i=0;i<strList.size();i++){      
                if(!strList[i].isSuccess()){
                    errs=strList[i].getErrors();
                    errorList.add(lstCSVLines[i+1]+','+errs[0].getMessage());
                    eList.add(strList[i].getErrors()[0].getMessage()); 
                }
                else {
                    successList.add(lstToUpsert[i].get('Id')+','+successListRows[i]);                   
                }
              } 
            }
            else if(strList==null){
                for(Integer i=0;i<errorList.size();i++){
                eList.add(errorList[i]);
                }
            }            
            sendMail(String.join(errorList,'\r\n'),String.join(successList,'\r\n'),errorList.size()-1,successList.size()-1);           
    }
        return eList;
    }
    
    public static void sendMail(String err,String scc,Integer errCount,Integer sccCount){
        system.debug('err--->'+err);
        system.debug('scc--->'+scc);
        Messaging.EmailFileAttachment successAttach = new Messaging.EmailFileAttachment();
        successAttach.setContentType('application/csv');
        successAttach.setFileName('Success.csv');
        successAttach.setInline(false);
        successAttach.Body = Blob.valueOf(scc);

        Messaging.EmailFileAttachment errorAttach = new Messaging.EmailFileAttachment();
        errorAttach.setContentType('application/csv');
        errorAttach.setFileName('Error.csv');
        errorAttach.setInline(false);
        errorAttach.Body = Blob.valueOf(err);

        DateTime d = Date.Today() ;
        String dateString =  d.format('dd/MM/yyyy') ;

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
      	mail.setToAddresses(new String[] {UserInfo.getUserEmail()});
        //mail.setToAddresses(new String[] {'virag.mhatre@skinternational.com'});
        //mail.setToAddresses(new String[] {'tejas.chavan@skinternational.com'});
        mail.setSenderDisplayName('Salesforce Support');
        mail.setBccSender(false);
        mail.setUseSignature(false);

            mail.setSubject('Data upload details of Territory Wise Budget');
            mail.setPlainTextBody('Data upload details of Territory Wise Budget');
            mail.setHtmlBody(system.label.FU_Dear_User+'<br/><br/>'+'Please find the attached generated files while uploading Territory Wise Budget data'+'<br/><br/>'+system.label.FU_Date+ ' '+dateString+'<br/><br/>'+system.label.FU_No_Of_Errors+' '+errCount+'<br/><br/>'+system.label.FU_No_Of_Success+' '+sccCount+'<br/><br/>'+system.label.FU_Regards+'<br/>'+system.label.FU_UPL_SA+'<br />');
        
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {successAttach,errorAttach}); 

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}