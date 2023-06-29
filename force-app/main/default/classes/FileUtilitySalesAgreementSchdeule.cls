/*
* Name: File Utility
* Created On: 05/04/2021
* Author: Azhar Shaikh
* Description: Utility Class for splitting, storing CSV Attachments.
*/
public class FileUtilitySalesAgreementSchdeule {
    
    public static String getDateTime(String fileName){
        //System.debug('fileName: '+fileName);
        String result = '';
        if(String.isNotBlank(fileName)){
            try{
                fileName = fileName.substringAfter('_').removeEnd('.txt');
                
                if(fileName.length()>15){
                    Integer endIndex = fileName.indexOf('-', fileName.indexOf('-',fileName.indexOf('-')+1)+1);
                    String dte = fileName.substring(0,endIndex);
                    String tme = fileName.substring(endIndex+1).replaceAll('-',':');
                    result = dte+' '+tme;
                    //System.debug('result: '+result);
                    //System.debug('datetime: '+DateTime.valueOf(result));
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
    public static boolean processAttachment(String fileName, String userId, String salesOrgId, String fromAddress, String emailSubject, Blob body){
        SplitString splitObj = new SplitString();
        
        boolean isTrue=true;
        
        List<String> csvData = new List<String>();
        //System.debug('body size '+body.size());
        csvData = splitObj.safeSplit(body.toString(), '\n');
        String idStr=UserInfo.getUserId();
        String userCountry=[SELECT Id, Country FROM User where Id=:idStr][0].Country;
        //System.debug('userCountry : '+userCountry);
        //String[] headerSplit = csvData[0].split(',');
        String[] headerSplit = csvData[0].split(';'); //Used for Brazil Country
        
        if(headerSplit.size()>2){
            isTrue=false;
            //System.debug('1');
            /* Added on 4-11-2022 for Account Target */
            String RegionCode=headerSplit[0].trim();
            String SKUCode=headerSplit[1].trim();
            String Quantity=headerSplit[2].trim();
            String Month=headerSplit[3].trim();
            //System.debug('RegionCode '+RegionCode+' SKUCode '+SKUCode+' Quantity '+Quantity+' Month'+Month);
            if(RegionCode.equalsIgnoreCase('Region Code') && (SKUCode.equalsIgnoreCase('SKU Code')) && (Quantity.equalsIgnoreCase('Quantity')) && (Month.equalsIgnoreCase('Month'))){
                isTrue=true;
               // System.debug('Account Target Upload');
            }
            /* Added on 4-11-2022 for Account Target */
            
        }else {
            //System.debug('headerSplit[0] :'+headerSplit[0]);
            //System.debug('headerSplit[1] :'+headerSplit[1]);
            String updateID=headerSplit[0].trim();
            String PlannedQuantity=headerSplit[1].trim();
            if(updateID.equalsIgnoreCase('Update Id') && (PlannedQuantity.equalsIgnoreCase('Planned Quantity') || PlannedQuantity.equalsIgnoreCase('Quantidade planejada'))){
                isTrue=true;
                System.debug('2');
            }else{
                isTrue=false;
                System.debug('3');
            }
        }
        
        
        String asOfNow = getDateTime(fileName);
        
        //Record to save Original File
        BusinessDashboard__c bdObj = new BusinessDashboard__c();
        bdObj.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Original File').getRecordTypeId();
        bdObj.EmailSubject__c =  emailSubject;
        bdObj.Status__c = 'Completed';
        bdObj.User__c = userId;
        bdObj.Sales_Org__c=salesOrgId;
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
        //System.debug('csv data is'+csvData.size());
        Integer csvSize =  csvData.size();
        if(csvSize<=5000){
            divideCsv = csvSize;
        }
        else if(csvSize<=10000){
            divideCsv = csvSize/2;
        }
        else{
            divideCsv = csvSize/3;
        }
        //End of Logic
        
        List<String> csvAttachment = new List<String>();
        String csv = '';
                
        String header = csvData[0].replaceAll('\u0009','').trim();
        //System.debug('csv data size'+csvSize);
        
        for(Integer j=1; j < csvSize; j++){
            
            csvAttachment.add(csvData[j].replaceAll('\u0009','').trim());
            
            if(j==divideCsv){
                csv = String.join(csvAttachment, '\r\n');
                csv+='\r\n';
                createSplitRecord(userId,salesOrgId,fromAddress, header, csvAttachment.size(), csv, fileName, bdObj.Id, asOfNow);
                csvAttachment.clear();
            }
            else if(j==divideCsv*2){
                csv = String.join(csvAttachment, '\r\n');
                csv+='\r\n';
                createSplitRecord(userId,salesOrgId,fromAddress, header, csvAttachment.size(), csv, fileName, bdObj.Id, asOfNow);
                csvAttachment.clear();
            }
            else if(j==csvSize-1)
            //else if(j==divideCsv*6)
            {
                
                csv = String.join(csvAttachment, '\r\n');
                csv+='\r\n';  
                createSplitRecord(userId,salesOrgId,fromAddress, header, csvAttachment.size(), csv, fileName, bdObj.Id, asOfNow);
                csvAttachment.clear();
            }
        }
        
        return isTrue;
    }
    
    //Method to create split file records and store attachments
    public static void createSplitRecord(String userId, String salesOrgId, String fromAddress, String header, Integer csvSize, String csv, String fileName, Id bdId, String asOfNow){
        BusinessDashboard__c bdObj = new BusinessDashboard__c();
        bdObj.RecordTypeId = Schema.SObjectType.BusinessDashboard__c.getRecordTypeInfosByName().get('Split File').getRecordTypeId();
        bdObj.OriginalFile__c = bdId;
        bdObj.EmailSubject__c =  fileName.substringBefore('.')+' (Split - 1)'; //fileName.removeEnd('.txt')+' (Split - 1)';
        bdObj.FromAddress__c = fromAddress;
        bdObj.User__c = userId;
        bdObj.Sales_Org__c=salesOrgId;
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