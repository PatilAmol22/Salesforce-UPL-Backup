/*
* Name: File Utility
* Created On: 17 Feb 2017
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Utility Class for splitting, storing CSV Attachments.
*/
public class FileUtility {
    
    public static String getDateTime(String fileName){
        System.debug('fileName: '+fileName);
        String result = '';
        if(String.isNotBlank(fileName)){
            try{
                fileName = fileName.substringAfter('_').removeEnd('.txt');
                
                if(fileName.length()>15){
                    Integer endIndex = fileName.indexOf('-', fileName.indexOf('-',fileName.indexOf('-')+1)+1);
                    String dte = fileName.substring(0,endIndex);
                    String tme = fileName.substring(endIndex+1).replaceAll('-',':');
                    result = dte+' '+tme;
                    System.debug('result: '+result);
                    System.debug('datetime: '+DateTime.valueOf(result));
                }
            }
            catch(Exception e){
                System.debug('Line No: '+e.getLineNumber()+' Error message: '+e.getMessage());    
                return result;
            }
        }
        
        return result;
    }
    
    //Method to process Binary/Text Attachments and Split them as per size
    public static void processAttachment(String fileName, String fromAddress, String emailSubject, Blob body){
        SplitString splitObj = new SplitString();
        
        List<String> csvData = new List<String>();
        csvData = splitObj.safeSplit(body.toString(), '\n');
        
        String asOfNow = getDateTime(fileName);
        
        //Record to save Original File
        BusinessDashboard__c bdObj = new BusinessDashboard__c();
        bdObj.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Original File').getRecordTypeId();
        bdObj.EmailSubject__c =  emailSubject;
        bdObj.Status__c = 'Completed';
        bdObj.FromAddress__c = fromAddress;
        bdObj.Rows__c = csvData.size();
        bdObj.Header__c = csvData[0].replaceAll('\u0009','');
        if(String.isNotBlank(asOfNow)){
            bdObj.As_of_now__c = DateTime.valueOf(asOfNow);
        }
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
            divideCsv = csvData.size()/5;
        }
        system.debug('dividecsv===='+divideCsv);
        //End of Logic
        
        List<String> csvAttachment = new List<String>();
        String csv = '';
                
        String header = csvData[0].replaceAll('\u0009','').trim();
        
        for(Integer j=1; j < csvData.size(); j++){
            
            csvAttachment.add(csvData[j].replaceAll('\u0009','').trim());
            
            if(j==divideCsv){
                csv = String.join(csvAttachment, '\r\n');
                csv+='\r\n';
                createSplitRecord(fromAddress, header, csvAttachment.size(), csv, fileName, bdObj.Id, asOfNow);
                csvAttachment.clear();
            }
            else if(j==divideCsv*2){
                csv = String.join(csvAttachment, '\r\n');
                csv+='\r\n';
                createSplitRecord(fromAddress, header, csvAttachment.size(), csv, fileName, bdObj.Id, asOfNow);
                csvAttachment.clear();
            }else if(j==divideCsv*3){
                csv = String.join(csvAttachment, '\r\n');
                csv+='\r\n';
                createSplitRecord(fromAddress, header, csvAttachment.size(), csv, fileName, bdObj.Id, asOfNow);
                csvAttachment.clear();
            }else if(j==divideCsv*4){
                csv = String.join(csvAttachment, '\r\n');
                csv+='\r\n';
                createSplitRecord(fromAddress, header, csvAttachment.size(), csv, fileName, bdObj.Id, asOfNow);
                csvAttachment.clear();
            }
            
            else if(j==csvData.size()-1){
                csv = String.join(csvAttachment, '\r\n');
                csv+='\r\n';  
                createSplitRecord(fromAddress, header, csvAttachment.size(), csv, fileName, bdObj.Id, asOfNow);
                csvAttachment.clear();
            }
        }
    }
    
    //Method to create split file records and store attachments
    public static void createSplitRecord(String fromAddress, String header, Integer csvSize, String csv, String fileName, Id bdId, String asOfNow){
        BusinessDashboard__c bdObj = new BusinessDashboard__c();
        bdObj.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
        bdObj.OriginalFile__c = bdId;
        bdObj.EmailSubject__c =  fileName.substringBefore('.')+' (Split - 1)'; //fileName.removeEnd('.txt')+' (Split - 1)';
        bdObj.FromAddress__c = fromAddress;
        bdObj.Status__c = 'Draft';
        bdObj.Rows__c = csvSize;
        bdObj.Header__c = header;
        if(String.isNotBlank(asOfNow)){
            bdObj.As_of_now__c = DateTime.valueOf(asOfNow);
        }
        insert bdObj;
        
        Attachment attachment = new Attachment();
        attachment.ParentId = bdObj.Id;
        attachment.Name = fileName.substringBefore('.')+'.csv'; //fileName.removeEnd('.txt')+'.csv';
        attachment.Body = Blob.valueof(csv);
        insert attachment;
    }
}