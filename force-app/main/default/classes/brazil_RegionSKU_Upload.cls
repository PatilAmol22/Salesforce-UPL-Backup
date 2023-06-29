/*
* Ticket : SCTASK0398608 (RITM0176543) Add a parameter on a minimum date to bill the product by regional Brazil
* Name: brazil_RegionSKU_Upload
* Created By : Priya Dhawan
*/
public without sharing class brazil_RegionSKU_Upload {    
    public virtual class BaseException extends Exception {}
    public class OtherException extends BaseException {}
  
     @AuraEnabled
     public static File_Attachment__c getAllRecordId(){
         return[select Id,Name From File_Attachment__c WHERE Name = 'Brazil Region SKU Data'];
     }
      
      //Download URL's for CSV Templates on Interface
      @AuraEnabled
      Public static List<String> getDownloadURLForTemplates(){
          String InstanceURL = URL.getOrgDomainUrl().toExternalForm();      
          List<Document> ListDocumentId = [SELECT Id, Name, DeveloperName from Document WHERE DeveloperName LIKE 'Brazil_Region_%' Order By Name ASC LIMIT 1];
          List<String> DownloadURLForTemplates = new List<String>();
          DownloadURLForTemplates.add(InstanceURL+'/servlet/servlet.FileDownload?file='+ListDocumentId[0].Id);
          //DownloadURLForTemplates.add(InstanceURL+'/servlet/servlet.FileDownload?file='+ListDocumentId[1].Id);
          Return DownloadURLForTemplates;
      }
      
      @AuraEnabled
      public static void readCSVFileBr(Id idContentDocument){
          
          SplitString splitObj = new SplitString();
          list<String> csvData = new list<String>();
          list<String> lstCSVLines = new list<String>();
          Blob body;
          
          if(idContentDocument != null) {
              ContentVersion objVersion = [SELECT Id, OwnerId, VersionData FROM ContentVersion WHERE ContentDocumentId =:idContentDocument];
              body = objVersion.VersionData;
              
              csvData = splitObj.safeSplit(body.toString(), '\n');    
              
              Integer divideCsv = 0;
          
          if(csvData.size()<=5000){
              divideCsv = csvData.size();
          }
          else if(csvData.size()<=10010){
              divideCsv = csvData.size()/2;
          }
          else{
              divideCsv = csvData.size()/5;
          }
              String header = csvData[0].replaceAll('\u0009','').trim();
              
              for(Integer j=1; j < csvData.size(); j++){
                  
              lstCSVLines.add(csvData[j].replaceAll('\u0009','').trim());
              
              if(j==divideCsv){ 
                 if(Test.isRunningTest()) { 
                     system.debug('** lstCSVLines ' +lstCSVLines);
                   system.debug('** In header ' +header);
                 }
                     else {
                  uploadBr(lstCSVLines,header);
                  lstCSVLines.clear();
                 }
              }
               else if(j==divideCsv*2){
                  if(Test.isRunningTest()) { 
                     system.debug('** lstCSVLines ' +lstCSVLines);
                   system.debug('** In header ' +header);
                 }
                     else {
                  uploadBr(lstCSVLines,header);
                  lstCSVLines.clear();
                 }            
                 }
                  else if(j==csvData.size()-1){
                        if(Test.isRunningTest()) { 
                     system.debug('** lstCSVLines ' +lstCSVLines);
                   system.debug('** In header ' +header);
                 }
                     else {
                  uploadBr(lstCSVLines,header);
                  lstCSVLines.clear();
                 }
                  }             
          }       
          }          
      }
      
      
  @future
     public static void uploadBr(list<String> lstCSVLines,String header)
      {   
                        lstCSVLines.add(0,header);					  
              
          String row='';
          list<Brazil_Region_SKU_Combination__c> lstToInsertOrUpdate = new list<Brazil_Region_SKU_Combination__c>();      
          //Database.SaveResult[] strList;
          Database.upsertResult[] strList;		 
          List<String> errorList=new List<String>();
          List<String> successList=new List<String>();
          String combinationKey = '';
          List<String> eList=new List<String>();
          List<String> successListRows= new List<String>();
          Database.Error[] errs;
          set<string> combiSet= new set<string>();
          
          successList.add(system.label.FU_Record_ID+','+header);
          errorList.add(header+','+system.label.FU_Error_Description);    
          
              for(Integer i = 1; i < lstCSVLines.size(); i++){
                 Brazil_Region_SKU_Combination__c brObj =new Brazil_Region_SKU_Combination__c();
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
                          // System.debug('**csvRowData 0  -> '  +(csvRow[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim())+(csvRow[2].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim())+'00000000000'+csvRow[1].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
  
                      //if(operationType=='Insert'){ if(operationType=='Insert' || operationType=='Update'){
                      system.debug('**Inside Insert ->' +csvRow.size() + ' '+csvRow );
                      if(csvRow.size()!=6) throw new OtherException('Incorrect CSV');  // modified by Atish@Wipro
                      
                      if(!combiSet.contains((csvRow[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()) + (csvRow[1].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim())))
                      {
                          system.debug('**Inside Uniqui record');  
                          brObj.Sales_District__r=new Region__c(RegionCode__c=csvRow[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                      
                      if((csvRow[1].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==6){
                           brObj.SKU__r=new SKU__c(Combination_Key__c=(csvRow[2].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim())+'000000000000'+csvRow[1].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()); }
                      
                      if((csvRow[1].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()).length()==7){
                           brObj.SKU__r=new SKU__c(Combination_Key__c=(csvRow[2].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim())+'00000000000'+csvRow[1].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()); }
                      brObj.Availability__c = csvRow[3].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim();
                      
                      brObj.Date__c = Date.valueOf(csvRow[4].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
                      brObj.Maximum_Date__c = Date.valueOf(csvRow[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()); //added by Atish@Wipro

                      brObj.Unique_Key__c= (csvRow[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()) + (csvRow[1].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());        
                      
                      combiSet.add((csvRow[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()) + (csvRow[1].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim()));
                          system.debug('** Combination Set' +combiSet);
                          }
                          else{
                              throw new OtherException('Duplicate Record Found in CSV');
                          }  
                   // added by Atish@Wipro   
                  if( brObj.Date__c >  brObj.Maximum_Date__c )
                  {
                   brObj.addError('Error');
                   System.debug('Error value');

                  }
                  else{
                      lstToInsertOrUpdate.add(brObj);
                      successListRows.add(row);
                  }
                  }
                  catch(Exception e){
                       System.debug('stack trace --->'+ e.getStackTraceString());
                      
                      if(e.getMessage()=='Incorrect CSV'){
                          System.debug('##Inside Incorrect CSV '+e.getMessage());
                          eList.add(e.getMessage());
                          //return eListDistributorInventory;
                      }
                      else{
                          System.debug('##Inside Error CSV '+e.getMessage());
                          errorList.add(row+','+e.getMessage());
                      }
                      
                  }
              }
              //Handling Insert and Update			
             // If(operationType=='Insert' || operationType=='Update')  {
              if(lstToInsertOrUpdate.size()>0){
                  System.debug('**lstToInsertOrUpdate --> '+lstToInsertOrUpdate); 
                  Schema.SObjectField uniqueField = Brazil_Region_SKU_Combination__c.Fields.Unique_Key__c;
                  strList=Database.upsert(lstToInsertOrUpdate,uniqueField,false);             
              }
                  else{
                   System.debug('Data Not Found');
              }
               System.debug('**listtoInsertOrUpdate --> ' +lstToInsertOrUpdate);
               System.debug('**strList --> '+strList);
              if(strList!=null){
              for(Integer i=0;i<strList.size();i++){      
                  if(!strList[i].isSuccess()){
                      errs=strList[i].getErrors();
                      errorList.add(lstCSVLines[i+1]+','+errs[0].getMessage()); 
                      eList.add(strList[i].getErrors()[0].getMessage()); 
                  }
                  else {
                      system.debug('List of success--->'+lstToInsertOrUpdate[i]);
                      successList.add(lstToInsertOrUpdate[i].get('Id')+','+successListRows[i]);                  
                  }
                } 
              }
              else if(strList==null){
                  for(Integer i=0;i<errorList.size();i++){ 
                  eList.add(errorList[i]);
                  }
              }           
                 // sendMail(String.join(errorList,'\r\n'),String.join(successList,'\r\n'),errorList.size()-1,successList.size()-1);
                        
          }
          
          public static void sendMail(String err,String scc,Integer errCount,Integer sccCount){
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
  
          /*DateTime d = system.Today() ;
          String dateString =  d.format('dd/MM/yyyy') ;
          +system.label.FU_Date+ ' '+dateString+'<br/><br/>'*/
          
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          mail.setUseSignature(false);
          mail.setToAddresses(new String[] {UserInfo.getUserEmail()});
          mail.setSenderDisplayName('Salesforce Support');
          mail.setBccSender(false);
          mail.setUseSignature(false);
              
          mail.setSubject('Salesforce - Resultado da Carga do Mapeamento Regional / Produto');
          mail.setHtmlBody(system.label.FU_Dear_User+'<br/><br/>'+system.label.Upload_Template_Email+'<br/><br/>'+system.label.Japan_Incorrect_CSV+'<br/><br/>'+system.label.FU_No_Of_Errors+' '+errCount+'<br/><br/>'+system.label.FU_No_Of_Success+' '+sccCount+'<br/><br/>'+system.label.FU_Regards+'<br/>'+system.label.FU_UPL_SA+'<br />');
                  
          mail.setFileAttachments(new Messaging.EmailFileAttachment[] {successAttach,errorAttach}); 
  
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
      }
      
  }