@RestResource(urlMapping='/CountryRegionFileUpload/v1/*')
global class CountryRegionFileUploadAPI{
    @HttpPost
    global static void attachDoc(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        
        String fName = req.params.get('FileName');
        String recordTypeName = req.params.get('RecordTypeName');
        system.debug('fName>>--->'+fName);
        system.debug('recordTypeName>>--->'+recordTypeName);
        Blob postContent = req.requestBody; 
        
        List<String> uCAList=new List<String>();
        List<User_Country_Adoption__c> uCAObj=[SELECT Id FROM User_Country_Adoption__c];
        delete uCAObj;
        List<User_Country_Adoption__c> uCAObjList=[SELECT Id FROM User_Country_Adoption__c];
        System.debug('uCAObjList size :  '+uCAObjList.size());
        if(uCAObjList.size()==0){
            //Pass FileName & Blob to File Utility for File Splitting
            processData(postContent);
        }  
    }
    public static void processData(blob csvfileBody){
        List<User_Country_Adoption__c> insertUserCountryAdoption = new List<User_Country_Adoption__c>();
        List<String> errorCSVList = new List<String>();
        List<String> successCSVList = new List<String>();
        
        try{
            List<String> csvData = new List<String>();
            String strCSVFile = csvfileBody.toString();
            csvData  = strCSVFile.split('\r\n');
            String row = '';
            successCSVList.add('Record ID,'+csvData[0]);
            errorCSVList.add(csvData[0]+',Error Description');
            
            if(csvData.size()>0){
            for(Integer i=1;i<csvData.size();i++){
                try{
                    List<String> csvLineItem = new List<String>();
                    row = csvData[i];
                    csvLineItem = csvData[i].split(',');
                    User_Country_Adoption__c userCountryAdoptionObj=new User_Country_Adoption__c();
                    for(Integer j=0;j<csvLineItem.size();j++){
                        System.debug(''+csvLineItem[j]);
                        if(j==0){
                            if(String.isNotBlank(csvLineItem[j])){
                                
                                //Region text	
                                userCountryAdoptionObj.Region__c = csvLineItem[j];
                            }
                        }
                        else if(j==1){
                            if(String.isNotBlank(csvLineItem[j])){
                                //Country text
                               userCountryAdoptionObj.Country__c = csvLineItem[j];
                            }
                        }
                        else if(j==2){
                            if(String.isNotBlank(csvLineItem[j])){
                                //Module text
                               userCountryAdoptionObj.Module__c = csvLineItem[j];
                            }
                        }
                        
                    }
                    insertUserCountryAdoption.add(userCountryAdoptionObj);
                    System.debug('insertUserCountryAdoption size : '+insertUserCountryAdoption.size());
                    System.debug('insertUserCountryAdoption : '+insertUserCountryAdoption);
                }catch(Exception e){
                    errorCSVList.add(row+','+e.getMessage());
                }
                
            }
            }
            
            if(insertUserCountryAdoption.size()>0){
                Database.SaveResult[] sr = Database.insert(insertUserCountryAdoption, false);
                System.debug('sr : '+sr);
                System.debug('sr.size(): '+sr.size());
                for(Integer i=0;i<sr.size();i++){ 
                    if (sr[i].isSuccess()) {
                        successCSVList.add(insertUserCountryAdoption[i].get('Id')+','+csvData[i+1]);
                    }
                    else {
                        Database.Error[] errs = sr[i].getErrors();
                        errorCSVList.add(csvData[i+1]+','+errs[0].getMessage());
                    }
                }
                
                sendEmail(String.join(successCSVList, '\r\n'), String.join(errorCSVList, '\r\n'), successCSVList.size(), errorCSVList.size());
            }
            
        }catch(Exception e){
            System.debug('Error message : '+e.getMessage());
        }    
    }
    
    //Method to Notify User with Success/Error Files after Upload
    public static void sendEmail(String successFile, String errorFile, Integer successCount, Integer errorCount){
        system.debug('successFile : '+successFile);
        system.debug('errorFile : '+errorFile);
        system.debug('successCount : '+successCount);
        system.debug('errorCount : '+errorCount);
        try{
            Messaging.EmailFileAttachment successAttach = new Messaging.EmailFileAttachment();
            successAttach.setContentType('application/csv');
            successAttach.setFileName('Success.csv');
            successAttach.setInline(false);
            successAttach.Body = Blob.valueOf(successFile);
            Messaging.EmailFileAttachment errorAttach = new Messaging.EmailFileAttachment();
            errorAttach.setContentType('application/csv');
            errorAttach.setFileName('Error.csv');
            errorAttach.setInline(false);
            errorAttach.Body = Blob.valueOf(errorFile);
            
            DateTime d = Date.Today() ;
            String dateString =  d.format('dd/MM/yyyy') ;
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setToAddresses(new String[] { UserInfo.getUserEmail()});
            mail.setSubject('Country Region Module Upload Status');
            mail.setHtmlBody('Dear User,<br /><br />Please find attached files generated in SFDC while uploading the CSV File<br /><br />Date: '+dateString+'<br /><br />No. of error records: '+errorCount+'<br /><br />Regards,<br/>UPL Salesforce Administrator<br />');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { successAttach, errorAttach}); 
            
            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
           }catch(Exception ex){
               system.debug('ex : '+ex.getStackTraceString());
           }
    }
 
}