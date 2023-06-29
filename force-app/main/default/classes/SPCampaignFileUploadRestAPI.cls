@RestResource(urlMapping='/SPCampaignFileUpload/v1/*')
global class SPCampaignFileUploadRestAPI {
    @HttpPost
    global static void attachDoc(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        
        String fName = req.params.get('FileName');
        String recordTypeName = req.params.get('RecordTypeName');
        system.debug('recordTypeName>>--->'+recordTypeName);
        Blob postContent = req.requestBody; 
        
        //Pass FileName & Blob to File Utility for File Splitting
        processData(postContent,recordTypeName);
        
    }
    
    public static void processData(blob csvfileBody,String recordTypeName){
        try{
            List<String> errorCSVList = new List<String>();
            List<String> successCSVList = new List<String>();
            //Map<id,SKU__c> skMap=new Map<id,SKU__c>();
            SplitString splitObj = new SplitString();
            
            //Logic to parse CSV row by row
            List<String> csvData = new List<String>();
            //blob csvBlob = csvFile.Body;
            String strCSVFile = csvfileBody.toString();
            csvData  = strCSVFile.split('\r\n');
            //csvData = splitObj.safeSplit(strCSVFile, '\r\n');
            system.debug('csvData>>--->'+csvData);
            Boolean isTrue=true;
            successCSVList.add('Record ID,'+csvData[0]);
            errorCSVList.add(csvData[0]+',Error Description');
            
            List<PriceBookMaster__c> upsertPricebookList = new List<PriceBookMaster__c>();
            List<PriceBookMaster__c> upsertPricebookList2 = new List<PriceBookMaster__c>();
            List<PricebookDiscount__c> upsertPricebookDiscountList = new List<PricebookDiscount__c>();
            List<PricebookDiscount__c> upsertPricebookDiscountList2 = new List<PricebookDiscount__c>();
            List<SpecialInvoiceDiscount__c> upsertSpecInvDiscountList = new List<SpecialInvoiceDiscount__c>();
            List<SpecialInvoiceDiscount__c> upsertSpecInvDiscountList2 = new List<SpecialInvoiceDiscount__c>();
            List<ZSP1_Discount__c> upsertZSP1DiscountList = new List<ZSP1_Discount__c>();
            List<ZSP1_Discount__c> upsertZSP1DiscountList2 = new List<ZSP1_Discount__c>();
            List<PriceBookMaster__c> errorPricebookList = new List<PriceBookMaster__c>();
            List<PricebookDiscount__c> errorPricebookDiscountList = new List<PricebookDiscount__c>();
            List<SpecialInvoiceDiscount__c> errorSpecInvDiscountList = new List<SpecialInvoiceDiscount__c>();
            List<ZSP1_Discount__c> errorZSP1DiscountList = new List<ZSP1_Discount__c>();
            
            Map<String,String> mapStr= new Map<String,String>();
            Map<String,String> mapErrorStr= new Map<String,String>();
            Map<String,String> mapStrUom= new Map<String,String>();
            Set<String> uomSet=new Set<String>(); 
            List<SKU__c> skuObjList=[Select id, Name, SKU_Code__c, UOM__c from SKU__c Where Sales_Org_Code__c='2510' or Sales_Org_Code__c='2481' or Sales_Org_Code__c='2541'];
            for(SKU__c skuOb:skuObjList){
                String scode=skuOb.SKU_Code__c;
                mapStrUom.put(scode, skuOb.UOM__c);
            }
            if(recordTypeName!=null){
                FileUploadRESTAPIV2.processData('Iberia & Portugal',recordTypeName,recordTypeName,csvData,mapStrUom,successCSVList,errorCSVList);
            }
            
            sendEmail(String.join(successCSVList, '\r\n'), String.join(errorCSVList, '\r\n'), successCSVList.size(), errorCSVList.size()-1);    
        } catch(Exception e){
            
        }  
    }
    
    //Method to Notify User with Success/Error Files after Upload
    public static void sendEmail(String successFile, String errorFile, Integer successCount, Integer errorCount){
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
            mail.setSubject('Campaign Pricebook Upload Status');
            mail.setHtmlBody('Dear User,<br /><br />Please find attached files generated in SFDC while uploading the Campaign Pricebook<br /><br />Date: '+dateString+'<br /><br />No. of error records: '+errorCount+'<br /><br />Regards,<br/>UPL Salesforce Administrator<br />');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { successAttach, errorAttach}); 
            
            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
           }catch(Exception ex){
               system.debug('ex : '+ex.getStackTraceString());
           }
    }
}