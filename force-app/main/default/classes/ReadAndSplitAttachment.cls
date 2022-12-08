/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-08-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ReadAndSplitAttachment implements Queueable{
    
    public void execute(QueueableContext context) {
        System.debug('Hello');
    }

    // validateAttachment
    // readAttachment
    // SplitAttachment
   
    public static String getFile(String fileName){
        System.debug('fileName: '+fileName);
        String result = '';
        if(String.isNotBlank(fileName)){
            try{
                fileName = fileName.substringAfter('_').removeEnd('.txt');
                
                
            }
            catch(Exception e){
                System.debug('Line No: '+e.getLineNumber()+' Error message: '+e.getMessage());    
                return result;
            }
        }
        
        return result;
    }
    


public static boolean processFile(String fileName, String userId, String salesOrgId, Blob body){
        SplitString splitObj = new SplitString();
        
        boolean isTrue=true;
        
        List<String> csvData = new List<String>();
        System.debug('body size '+body.size());
        csvData = splitObj.safeSplit(body.toString(), '\n');
        String idStr=UserInfo.getUserId();
        String userCountry=[SELECT Id, Country FROM User where Id=:idStr][0].Country;
        
        
        //Record to save Original File
        Mass_Upload_CSV__c bdObj = new Mass_Upload_CSV__c();
        bdObj.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Original File').getRecordTypeId();
        bdObj.Status__c = 'Completed';
        //bdObj.User__c = userId;
        //bdObj.Sales_Org__c=salesOrgId;
        //bdObj.Rows__c = csvData.size();
        //bdObj.Header__c = csvData[0].replaceAll('\u0009','');
        insert bdObj;
        
        //Insert Original Email Attachment
        Attachment attachment = new Attachment();
        attachment.ParentId = bdObj.Id;
        attachment.Name = filename;
        attachment.Body = body;
        insert attachment;
        
        //Calculate number of rows & number of splits to be performed on the csv
        Integer divideCsv = 0;
        
        if(csvData.size()<=5000){
            divideCsv = csvData.size();
        }
        else if(csvData.size()<=10000){
            divideCsv = csvData.size()/2;
        }
        else{
            divideCsv = csvData.size()/3;
        }
        //End of Logic
        
        List<String> csvAttachment = new List<String>();
        String csv = '';
                
        String header = csvData[0].replaceAll('\u0009','').trim();
        
        for(Integer j=1; j < csvData.size(); j++){
            
            csvAttachment.add(csvData[j].replaceAll('\u0009','').trim());
            
            if(j==divideCsv){
                csv = String.join(csvAttachment, '\r\n');
                csv+='\r\n';
                createSplitFile(userId,salesOrgId, header, csvAttachment.size(), csv, fileName, bdObj.Id);
                csvAttachment.clear();
            }
            else if(j==divideCsv*2){
                csv = String.join(csvAttachment, '\r\n');
                csv+='\r\n';
                createSplitFile(userId,salesOrgId, header, csvAttachment.size(), csv, fileName, bdObj.Id);
                csvAttachment.clear();
            }
            else if(j==csvData.size()-1){
                csv = String.join(csvAttachment, '\r\n');
                csv+='\r\n';  
                createSplitFile(userId,salesOrgId, header, csvAttachment.size(), csv, fileName, bdObj.Id);
                csvAttachment.clear();
            }
        }
        
        return isTrue;
    }
    

public static void createSplitFile(String userId, String salesOrgId,String header, Integer csvSize, String csv, String fileName, Id bdId){
        Mass_Upload_CSV__c bdObj = new Mass_Upload_CSV__c();
        bdObj.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
       // bdObj.OriginalFile__c = bdId;
      //  bdObj.User__c = userId;
       // bdObj.Sales_Org__c=salesOrgId;
       // bdObj.Status__c = 'Draft';
        //bdObj.Rows__c = csvSize;
       //bdObj.Header__c = header;
        insert bdObj;
        
        Attachment attachment = new Attachment();
        attachment.ParentId = bdObj.Id;
        attachment.Name = fileName.substringBefore('.')+'.csv'; //fileName.removeEnd('.txt')+'.csv';
        attachment.Body = Blob.valueof(csv);
        insert attachment;
    }

}