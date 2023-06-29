/*
Apex Class : DataUploadController
Created By : Keyuri Pophale(kpophale@in.ibm.com)
*/
public without sharing class DataUploadController {

    @AuraEnabled
    public static String passFileAura(String file,String ftype){
        system.debug('ftype:'+ftype);
        String []filelines;
        //String myFile = EncodingUtil.urlDecode(file, 'UTF-8');
        List<string> inputvalues = new list<string>();
        filelines = file.split('\n');
        system.debug('file'+file);
        
        List<Account> accountList = [SELECT id,SAP_Code__c, Sales_Org_Code__c from Account where sales_org_code__c = '5661'];
        Map<String,Id> accountMap = new Map<String,Id>();
        if(accountList.size() > 0){
            for(Account acc : accountList){
                accountMap.put(acc.SAP_Code__c,acc.id);
            }
        }
        List<SKU__c> skuObjList=[Select id, Name, SKU_Code__c, UOM__c from SKU__c Where Sales_Org_Code__c='5661'];
        Map<String,Id> skuMap = new Map<String,Id>();
        if(skuObjList.size() > 0){
            for(SKU__c sku : skuObjList){
                skuMap.put(sku.SKU_Code__c,sku.Id);
            }
        }
        
        List<String> errorList = new List<String>();
        try{
            if(ftype == 'Distributor-SKU Mapping'){
                List<Distributor_SKU_Mapping__c> distskuList = new List<Distributor_SKU_Mapping__c>();
                for (Integer i=1;i<filelines.size();i++)
                {
                    Distributor_SKU_Mapping__c sObj = new Distributor_SKU_Mapping__c();
                    List<String> csvLineItem = filelines[i].split(',');
                    String combinationKey = '5661';
                    sObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = '5661');
                    sObj.CurrencyIsoCode = 'USD';
                    if(String.isNotBlank(csvLineItem[0].trim())){
                        sObj.Conversion_Quantity__c = (csvLineItem[0].trim()=='')?0 : decimal.valueOf(csvLineItem[0].trim());
                    }
                    if(String.isNotBlank(csvLineItem[1].trim())){
                        sObj.Distributor_Sales_Office_Code__c = csvLineItem[1].trim();
                    }
                    if(String.isNotBlank(csvLineItem[2].trim())){
                        sObj.Distributor_Sales_Office_Name__c = csvLineItem[2].trim();
                    }                    
                    if(String.isNotBlank(csvLineItem[3].trim())){
                        sObj.Distributor_SKU_Code__c = csvLineItem[3].trim();
                    }
                    if(String.isNotBlank(csvLineItem[4].trim())){
                        sObj.Distributor_SKU_Name__c = csvLineItem[4].trim();
                    }
                    if(String.isNotBlank(csvLineItem[5].trim())){
                        sObj.Distributor_UOM__c = csvLineItem[5].trim();
                    }
                    if(String.isNotBlank(csvLineItem[6].trim())){
                        sObj.Distributor__c = accountMap.get(csvLineItem[6].trim());
                        combinationKey += csvLineItem[6].trim();
                    }
                    if(String.isNotBlank(csvLineItem[7].trim())){
                        String code = csvLineItem[7].trim();
                        if(code.length()==6){
                            code = '000000000000'+csvLineItem[7].trim();
                        }
                        else if(code.length()==7){
                            code = '00000000000'+csvLineItem[7].trim();
                        }
                        sObj.SKU__c = skuMap.get(code);
                        combinationKey += code;
                    }
                    if(String.isNotBlank(csvLineItem[8].trim())){
                        sObj.Distributor_City__c = csvLineItem[8].trim();
                        //combinationKey += csvLineItem[8].trim();
                    }
                    if(String.isNotBlank(csvLineItem[9].trim())){
                        sObj.Distributor_City_Code__c = csvLineItem[9].trim();
                        combinationKey += csvLineItem[9].trim();
                    }
                    if(String.isNotBlank(csvLineItem[10].trim())){
                        sObj.Unit_Price__c = Decimal.valueOf(csvLineItem[10].trim());
                    }
                    if(String.isNotBlank(csvLineItem[11].trim())){
                        sObj.UPL_Sales_Office_Name__r = new Zone__c(ZoneCode__c  = csvLineItem[11].trim());
                        combinationKey += csvLineItem[11].trim();
                     }
                   
                    if(String.isNotBlank(csvLineItem[12])){
                        Date d = Date.valueOf(csvLineItem[12].trim());
                        sObj.Valid_from__c = d;
                        combinationKey += csvLineItem[12].trim();
                    }
                    if(String.isNotBlank(csvLineItem[13])){
                        sObj.Valid_To__c = Date.valueOf(csvLineItem[13].trim());
                        combinationKey += csvLineItem[13].trim();
                    }
                    sObj.Combination_Key__c = combinationKey;
                    distskuList.add(sObj);  
                }
                Database.UpsertResult[] sDataUpload=  Database.upsert(distskuList,Distributor_SKU_Mapping__c.Combination_Key__c,false);
                for(Integer i=0;i<sDataUpload.size();i++){
                    if (!sDataUpload.get(i).isSuccess()){
                        Database.Error err = sDataUpload.get(i).getErrors().get(0);
                        errorList.add('Error - '+err.getMessage() + '\nStatus Code : '+err.getStatusCode()+'\n Fields : '+err.getFields());
                        System.debug('Error - '+err.getMessage() + '\nStatus Code : '+err.getStatusCode()+'\n Fields : '+err.getFields());
                    }
                }
            }
            else if(ftype == 'Price Book'){
                List<PriceBookMaster__c> pbmList = new List<PriceBookMaster__c>();
                for (Integer i=1;i<filelines.size();i++)
                {
                    PriceBookMaster__c sObj = new PriceBookMaster__c();
                    List<String> csvLineItem = filelines[i].split(',');
                    String combinationKey = '5661';
                    sObj.Sales_Org__r = new Sales_Org__c(Sales_Org_Code__c = '5661');
                    if(String.isNotBlank(csvLineItem[0].trim())){
                        sObj.DistributionChannel__r = new Distribution_Channel__c(Distribution_Channel_Code__c = csvLineItem[0].trim());
                        combinationKey += csvLineItem[0].trim();
                    }
                    if(String.isNotBlank(csvLineItem[1].trim())){
                        sObj.Division__r = new Division__c(Division_Code__c = csvLineItem[1].trim());
                        combinationKey += csvLineItem[1].trim();
                    }
                    sObj.DepotCode__r = new Depot__c(Depot_Code__c = 'CL00');
                    sObj.CurrencyIsoCode = 'USD';
                    if(String.isNotBlank(csvLineItem[2].trim())){
                        String code = csvLineItem[2].trim();
                        if(code.length()==6){
                            code = '000000000000'+csvLineItem[2].trim();
                        }
                        else if(code.length()==7){
                            code = '00000000000'+csvLineItem[2].trim();
                        }
                        combinationKey += code;
                        sObj.SKUCode__r = new SKU__c(Combination_Key__c = combinationKey);
                        
                    }
                    if(String.isNotBlank(csvLineItem[3])){
                        sObj.UOM__c =csvLineItem[3];
                     }
                    if(String.isNotBlank(csvLineItem[4])){
                        sObj.Price__c = Decimal.valueOf(csvLineItem[4].trim());
                    }
                    if(String.isNotBlank(csvLineItem[5])){
                        Date d = Date.valueOf(csvLineItem[5]);
                        sObj.StartDate__c = d;
                        combinationKey += csvLineItem[5];
                    }
                
                    if(String.isNotBlank(csvLineItem[6])){
                        sObj.EndDate__c = Date.valueOf(csvLineItem[6]);
                        combinationKey += csvLineItem[6];
                    }
                    if(String.isNotBlank(csvLineItem[7].trim())){
                        sObj.DistributorCustomerCode__c = accountMap.get(csvLineItem[7].trim());
                    }
                    sObj.CompositeKey__c = 'CL00'+csvLineItem[7].trim()+combinationKey;
                    pbmList.add(sObj);
                }  
                Database.UpsertResult[] sDataUpload=  Database.upsert(pbmList,PriceBookMaster__c.CompositeKey__c,false);
                for(Integer i=0;i<sDataUpload.size();i++){
                    if (!sDataUpload.get(i).isSuccess()){
                        Database.Error err = sDataUpload.get(i).getErrors().get(0);
                        errorList.add('Error - '+err.getMessage() + '\nStatus Code : '+err.getStatusCode()+'\n Fields : '+err.getFields());
                        System.debug('Error - '+err.getMessage() + '\nStatus Code : '+err.getStatusCode()+'\n Fields : '+err.getFields());
                    }
                }
            }
        }catch(Exception ex){
            System.debug('Line No: '+ex.getLineNumber()+' Message: '+ex.getMessage()+' Cause: '+ex.getCause());
            errorList.add(' Message: '+ex.getMessage());
        }
        String returnString;
        try{
            if(errorList.size() > 0){
                List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
                string finalstr;
                for(String err: errorList)
                {
                    string recordString = '"'+err+'" \n';
                    finalstr = finalstr +recordString;
                }
                String loggedInUser= UserInfo.getUserEmail();
                Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                blob csvBlob = Blob.valueOf(finalstr);
                string csvname= 'Data Upload Error File.csv';
                csvAttc.setFileName(csvname);
                csvAttc.setBody(csvBlob);
                efaList.add(csvAttc);
                Messaging.SingleEmailMessage emailsend =new Messaging.SingleEmailMessage();
                String[] toAddresses = new list<string> {loggedInUser};
                    String subject ='Data Upload Error';
                emailsend.setSubject(subject);
                emailsend.setToAddresses( toAddresses );
                emailsend.setPlainTextBody('Attached records could not be updated. Error messages are listed.');
                emailsend.setFileAttachments(efaList);
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailsend});
                returnString = 'NoSuccess';
            }
            else{
                
                String loggedInUser= UserInfo.getUserEmail();
                Messaging.SingleEmailMessage emailsend =new Messaging.SingleEmailMessage();
                String[] toAddresses = new list<string> {loggedInUser};
                    String subject ='Data Upload Success';
                emailsend.setSubject(subject);
                emailsend.setToAddresses( toAddresses );
                emailsend.setPlainTextBody('All of the records were uploaded succesfully.');
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailsend});
                returnString = 'success';
            }
        }catch(Exception ex){
            System.debug('Line No: '+ex.getLineNumber()+' Message: '+ex.getMessage()+' Cause: '+ex.getCause());
            returnString = 'Exception Occurred. Please contact system administrator for further details';
        }
        return returnString;
    }
    
    @AuraEnabled
    public static String getDocument()
    {
        List<document> DocumentList = new List<document>(); 
        String Templatefile = '/servlet/servlet.FileDownload?file=';
        String newTemplatefile;
        DocumentList = [select Name from document where Name = 'Price Book Template'];
        if(DocumentList.size()>0){
            newTemplatefile = Templatefile+DocumentList[0].Id;
        }
        return newTemplatefile;
    }
    @AuraEnabled
    public static String getDocument1()
    {
        List<document> DocumentList = new List<document>(); 
        String Templatefile = '/servlet/servlet.FileDownload?file=';
        String newTemplatefile;
        DocumentList = [select Name from document where Name = 'Distributor-SKU Mapping Template'];
        if(DocumentList.size()>0){
            newTemplatefile = Templatefile+DocumentList[0].Id;
        }
        return newTemplatefile;
    }
    
}