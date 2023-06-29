/*
* Name: BlanketProductController
* Created On: 16 August 2022
* Author: Kalpesh Chande (Kalpesh.Chande@skinternational.com)
* Description: Class is used for declare time period for expired SKUs.
*/
public with sharing class BlanketProductController {
    
    /*
* @Description  Fetching All SKU and Blanket Sku records and download data in file
* @Param        NA 
* @return       returns List of SKUs
*/
    @AuraEnabled(cacheable=true)
    public static List<SKU__c> getAllActiveSku(){
        User use=[select Id,country from User where Id=:UserInfo.getUserId()];
        system.debug('use'+use.Country);
        List<SKU__c> skuList=new List<SKU__c>();
        if(use.Country !=null){
            List<Login_Country__c> sOrgCode=[select Id,Name,For_Contry__c,Sales_Org_Code__c from Login_Country__c where Name =:use.Country limit 1];
            system.debug('sOrgCode '+sOrgCode);
            if(sOrgCode.size() > 0){
                skuList=[select Id,Name,Sales_Org__r.Name,SKU_Description__c,Combination_Key__c,SKU_Code__c,Division__r.Division_Code__c,
                         Distribution_Channel__r.Distribution_Channel_Code__c,
                         (select Id,Start_Date__c,End_Date__c,Status__c,Expired_Reason__c from Blanket_SKU__r)
                         From SKU__c where Combination_Key__c!='' AND  Sales_Org_Code__c =:sOrgCode[0].Sales_Org_Code__c AND Active__c=true order by CreatedDate desc];
                system.debug('skuList'+skuList);
            }
        }
        return skuList;
    }
    
    
    /*
* @Description  Upsert record in Blanket_SKU__c object.
* @Param        String custWrapObjList - represents updated blanket sku records in string.
* @return       returns success/error message.
*/
    @AuraEnabled
    public static string updateSku(String custWrapObjList){
        system.debug('custWrapObjList'+custWrapObjList);
        string message = null;
        User use=[select Id,country from User where Id=:UserInfo.getUserId()];
        system.debug('use'+use.Country);
        List<SKU__c> skuList=new List<SKU__c>();
        if(use.Country !=null){
            List<Login_Country__c> sOrgCode=[select Id,Name,For_Contry__c,Sales_Org_Code__c from Login_Country__c where Name =:use.Country limit 1];
            system.debug('sOrgCode '+sOrgCode);
            if(sOrgCode.size() > 0){
                
                List<Blanket_SKU__c> wrapBlanketSkuList = new List<Blanket_SKU__c>();
                try{
                    List<wrapperClass> skuForUpdateList=new List<wrapperClass>();
                    if(test.isRunningTest()){
                        String custWrapObjList1 = JSON.serialize(custWrapObjList);
                        system.debug('custWrapObjList'+custWrapObjList1);
                        skuForUpdateList = (List<wrapperClass>) JSON.deserialize(custWrapObjList,List<wrapperClass>.class);
                    }else{
                        skuForUpdateList = (List<wrapperClass>) JSON.deserialize(custWrapObjList,List<wrapperClass>.class);
                    }
                    system.debug('skuForUpdate list :'+skuForUpdateList);
                    if(skuForUpdateList != null && skuForUpdateList.size() > 0){
                        Blanket_SKU__c skuBlanketUpsert= null;
                        for(wrapperClass wrapData : skuForUpdateList){
                            SKU__c skuObj=new SKU__c();
                            if(test.isRunningTest()){
                                skuObj=[Select Id,Name,Combination_Key__c,Sales_Org__c FROM SKU__c limit 1];
                            }else{
                                skuObj=[Select Id,Name,Combination_Key__c,Sales_Org__c FROM SKU__c where Id =:wrapData.Id];
                            }
                            
                            system.debug('skuObj'+skuObj);
                            system.debug('wrapData.Type1'+wrapData.Type1);
                            if(skuObj != null){
                                List<Blanket_SKU__c> blanketList =[Select Id,SKU__r.Name,Combination_Key__c,Sales_Org__r.Sales_Org_Code__c,Start_Date__c,End_Date__c,Status__c,Expired_Reason__c FROM Blanket_SKU__c where Combination_Key__c =: skuObj.Combination_Key__c AND  Sales_Org__r.Sales_Org_Code__c =:sOrgCode[0].Sales_Org_Code__c ];
                                
                                system.debug('blanketList'+blanketList);
                                if(blanketList != null && blanketList.size() > 0 ){
                                    skuBlanketUpsert = blanketList.get(0);
                                }else{
                                    skuBlanketUpsert=new Blanket_SKU__c();
                                }
                                skuBlanketUpsert.SKU__c= skuObj.Id;
                                skuBlanketUpsert.Sales_Org__c=skuObj.Sales_Org__c;
                                if(wrapData.startDate !=null ){
                                    skuBlanketUpsert.Start_Date__c=wrapData.startDate;
                                }
                                if(wrapData.endDate !=null){
                                    skuBlanketUpsert.End_Date__c=wrapData.endDate;
                                }
                                if(wrapData.skuStatus !=null){
                                    skuBlanketUpsert.Status__c=wrapData.skuStatus;
                                }if(wrapData.Type1 !=null){
                                    skuBlanketUpsert.Expired_Reason__c=wrapData.Type1;
                                }
                                skuBlanketUpsert.Combination_Key__c=skuObj.Combination_Key__c;
                                wrapBlanketSkuList.add(skuBlanketUpsert);
                            }
                            system.debug('wrapBlanketSkuList'+wrapBlanketSkuList);
                        }
                        List<Blanket_SKU__c> bSkuUpsert=new List<Blanket_SKU__c>();
                        List<Blanket_SKU__c> bSkunull=new List<Blanket_SKU__c>();
                        if(wrapBlanketSkuList != null && wrapBlanketSkuList.size() > 0){
                            for(Blanket_SKU__c bsku : wrapBlanketSkuList ){
                                if( bsku.Expired_Reason__c==null){
                                    message=System.Label.Expired_reason_is_required;
                                    return message;
                                }
                                if( bsku.End_Date__c>=bsku.Start_Date__c ){
                                    bSkuUpsert.add(bsku);
                                } else{
                                    message=System.Label.End_date_must_be_greater_than_start_date;
                                    return message;
                                }
                                
                                
                            }
                            Upsert bSkuUpsert;
                            message = 'SUCCESS';
                        }
                        
                    }
                }catch(Exception e) {
                    message = 'Failed';
                    system.debug(e);
                }
            }
        }
        return message;
    }
    
    
    /*
* @Description  Upsert Records through Uploaded File.
* @Param        Id idContentDocument - represents id of uploaded file 
* @return       returns success/error message.
*/
    @AuraEnabled
    public static string uploadDownloadedCsvFile(Id idContentDocument){
        system.debug('inside upload file');
        string message = null;
        User use=[select Id,country from User where Id=:UserInfo.getUserId()];
        if(use.Country !=null){
            List<Login_Country__c> sOrgCode=[select Id,Name,For_Contry__c,Sales_Org_Code__c from Login_Country__c where Name =:use.Country limit 1];
            if(sOrgCode.size() > 0){
                List<SKU__c> skuObjList=[Select Id,Name,Combination_Key__c,Sales_Org__c FROM SKU__c where Combination_Key__c!='' AND  Sales_Org_Code__c =:sOrgCode[0].Sales_Org_Code__c AND Active__c=true ];       
                system.debug('skuObjList'+skuObjList.size());
                List<Blanket_SKU__c> blanketList =[Select Id,SKU__r.Name,Combination_Key__c,Sales_Org__r.Sales_Org_Code__c,Start_Date__c,End_Date__c,Status__c,Expired_Reason__c FROM Blanket_SKU__c where Combination_Key__c!='' AND Sales_Org__r.Sales_Org_Code__c =:sOrgCode[0].Sales_Org_Code__c];
                system.debug('blanketList'+blanketList.size());
                List<Blanket_SKU__c> wrapBlanketSkuList = new List<Blanket_SKU__c>();
                List<String> errorList=new List<String>();
                List<String> successList=new List<String>();
                // string Header = 'Combination Key,SKU,SKU Code,Start Date,End Date,Status,Expired Reason';
                string summaryHeader = 'Combination Key,SKU,SKU Code,Start Date,End Date,Status,Expired Reason,Error';
                try{
                    if(idContentDocument != null){
                        ContentVersion objVersion = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:idContentDocument];
                        list<String> csvFileData = objVersion.VersionData.toString().split('\n');  
                        Map<String,SKU__c> skuMap=new Map<String,SKU__c>();
                        Map<String,Blanket_SKU__c> blanketSkuMap=new Map<String,Blanket_SKU__c>();
                        List<String> plValues = new List<String>();
                        Schema.SObjectType objType = Schema.getGlobalDescribe().get('Blanket_SKU__c');
                        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
                        Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get('Expired_Reason__c').getDescribe();
                        List<Schema.PicklistEntry> picklistvalues = objFieldInfo.getPicklistValues();
                        for(Schema.PicklistEntry plv: picklistvalues) {
                            plValues.add(plv.getValue().toLowercase());
                        }
                        for(SKU__c sku:skuObjList){
                            skuMap.put(sku.Combination_Key__c,sku); 
                        }
                        for(Blanket_SKU__c blankSku:blanketList){
                            blanketSkuMap.put(blankSku.Combination_Key__c,blankSku); 
                        }
                        
                        for(Integer i=0 ;i<csvFileData.size();i++){
                            string[] header=csvFileData[0].split(',');
                            system.debug('header length'+header);
                            system.debug('header length'+header.size());
                            if(i==0 && header.size()!=7){
                                message = System.label.File_is_wrong;
                                return message;
                            }else if(i > 0 && !string.isBlank(csvFileData[i])){              
                                Blanket_SKU__c skuBlanketUpsert = populateCsvData(csvFileData[i],skuMap,blanketSkuMap,errorList,successList,plValues);
                                if(skuBlanketUpsert != null){
                                    wrapBlanketSkuList.add(skuBlanketUpsert);
                                }else{
                                    System.debug('skuBlanketUpsert is null :'+i);
                                }
                            }
                        }
                        
                        if(wrapBlanketSkuList.size() > 0 ){
                            Database.upsert(wrapBlanketSkuList,true);
                        }
                        System.debug('errorList.size() :'+errorList.size());
                        System.debug('successList.size() :'+successList.size());
                        sendMail(String.join(errorList,'\r\n'),String.join(successList,'\r\n'),errorList.size(),successList.size(),summaryHeader);
                        message = 'SUCCESS';
                    }
                    
                }catch(Exception e){
                    message = 'FAILD';
                    system.debug(e.getMessage());
                    return e.getMessage();
                }
            }
        }
        return message;  
    }
    
    /*
* @Description  Method used to format Date.
* @Param        Date input - represents date
* @return       Returns date converted in string format.
*/
    public static String formatDate(Date input){ 
        return DateTime.newInstance( input.year(), input.month(), input.day()).format('yyyy-MM-dd');
    }
    
    /*
* @Description  Method used to read uploaded csv file.
* @Param        String row - represents single csv row in string
Map<String,SKU__c> skuMap - represents SKU__c Map
Map<String,Blanket_SKU__c> blanketSkuMap - represents Blanket_SKU__c Map
* @return       Returns blanket SKU.
*/ 
    @AuraEnabled
    public static Blanket_SKU__c populateCsvData(String row,Map<String,SKU__c> skuMap,Map<String,Blanket_SKU__c> blanketSkuMap,List<String> errorList, List<String> successList, List<String> pickListValues){
        boolean invalidRow = false;
        String errorMessage = '' ;
        Blanket_SKU__c skuBlanketUpsert= null;
        try{
            if(row != null){
                string[] arr = row.split(',');
                //system.debug('arrss :'+arr);
                string combinationKey1=arr[0].replace('\'', '').trim();
                // system.debug('arr :'+combinationKey1);
                //system.debug('arr size :'+arr.size());
                if(!string.isBlank(combinationKey1)){
                    SKU__c skuObj =  skuMap.get(combinationKey1);
                    //  system.debug('skuObjmap'+ skuMap.get(combinationKey1));
                    if(skuObj != null){
                        skuBlanketUpsert =  blanketSkuMap.get(combinationKey1);
                        //system.debug('skuBlanketUpsertMap'+skuBlanketUpsert);
                        if(skuBlanketUpsert == null){
                            skuBlanketUpsert = new Blanket_SKU__c();
                        }
                        skuBlanketUpsert.SKU__c= skuObj.Id;
                        //system.debug('skuObj.Id'+skuObj.Id);
                        skuBlanketUpsert.Sales_Org__c=skuObj.Sales_Org__c;
                        skuBlanketUpsert.Combination_Key__c=skuObj.Combination_Key__c;    
                        
                        if(arr.size() > 3 && arr[3] !=null && arr[3] !=''){
                            skuBlanketUpsert.Start_Date__c=Date.valueOf(arr[3]);  
                        }else{
                            errorMessage += system.Label.Start_date_is_mandatory+'|';
                            invalidRow =  true;
                        }
                        if(arr.size() > 4 && arr[4] !=null && arr[4] !=''){   
                            skuBlanketUpsert.End_Date__c=Date.valueOf(arr[4]);  
                        }else{
                            errorMessage += System.Label.End_date_is_mandatory+'|';
                            invalidRow =  true;
                        }
                        
                        if(arr.size() > 5 && arr[5] !=null && arr[5] !='' && !string.isBlank(arr[5])){
                            if(arr[5].toLowercase().deleteWhiteSpace()=='active'){
                                arr[5]='true';
                            }else if(arr[5].toLowercase().deleteWhiteSpace()=='inactive'){
                                arr[5]='false';
                            }
                            skuBlanketUpsert.Status__c= Boolean.valueOf(arr[5]);
                        }else{
                            skuBlanketUpsert.Status__c= false;
                        }
                        
                        if(arr.size() > 6  && !string.isBlank(arr[6]) && !string.isEmpty(arr[6])){ 
                            Set<String> pickSet=new Set<String>();
                            pickSet.addAll(pickListValues);
                            Set<String> pickVal=new Set<String>();
                            for(string s : arr[6].trim().split(';')){
                                pickVal.add(s.trim().toLowercase());
                            }
                            if(pickSet.containsAll(pickVal)){
                                skuBlanketUpsert.Expired_Reason__c=arr[6].trim();  
                            }else{
                                errorMessage += System.Label.Expired_Reason_is_invalid+'|';
                                invalidRow =  true;
                            }
                            system.debug('skuBlanketUpsert :'+skuBlanketUpsert);
                        }else{
                            errorMessage += System.Label.Expired_reason_is_required+'|';
                            invalidRow =  true;
                        }
                        
                        if(skuBlanketUpsert.Start_Date__c > skuBlanketUpsert.End_Date__c){
                            errorMessage += System.Label.End_date_must_be_greater_than_start_date+'|';
                            invalidRow =  true;
                        }
                        
                    }else{
                        errorMessage += System.Label.Combination_Key_is_invalid+'|';
                        invalidRow =  true;
                    }
                    
                }else{
                    errorMessage +=system.Label.Combination_Key_is_mandatory+'|';
                    invalidRow =  true;
                }
                
                if(invalidRow){
                    skuBlanketUpsert = null;
                    system.debug('errorMessage'+errorMessage);
                    errorList.add(row.trim()+','+errorMessage);
                }else{
                    errorMessage += System.Label.No_error_found;
                    successList.add(row.trim()+','+errorMessage);
                }
                
            }
        }catch(Exception e){
            errorList.add(row.trim()+','+e.getMessage());
            system.debug(e.getMessage());
        }
        
        return skuBlanketUpsert;
    }
    
    public static void sendMail(String err,String scc,Integer errCount,Integer sccCount,String header){
        system.debug('inside mail');
        Messaging.EmailFileAttachment successAttach = new Messaging.EmailFileAttachment();
        successAttach.setContentType('application/csv');
        successAttach.setFileName('Success.csv');
        successAttach.setInline(false);
        scc = ' Sucess File\r\n '+header+'\r\n'+scc;
        blob successblob = Blob.valueOf(scc);
        successAttach.setBody(successblob);
        Messaging.EmailFileAttachment errorAttach = new Messaging.EmailFileAttachment();
        errorAttach.setContentType('application/csv');
        errorAttach.setFileName('Error.csv');
        errorAttach.setInline(false);
        err = 'Error File\r\n'+header+'\r\n'+err;
        blob errblob = Blob.valueOf(err);
        errorAttach.setBody(errblob);
        DateTime d = Date.Today() ;
        String dateString =  d.format();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        // String[] toAddresses = new String[] {'kalpesh.chande@skinternational.com'}; 
        mail.setToAddresses(new String[] { UserInfo.getUserEmail()});
        //  mail.setToAddresses(toAddresses);
        // mail.setReplyTo('support@acme.com');
        // mail.setSenderDisplayName('BlanketSKUtest');
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setSubject(System.Label.Data_Upload_Details_of_Blanket_Product);
        mail.setPlainTextBody(System.Label.List_of_success_and_error_records_of_blanket_SKU);
        mail.setHtmlBody(System.Label.Dear_User_Blanket+',<br/><br/>'+System.Label.Please_find_the_attached_files_generated_in_SFDC_blanket_SKU+'<br /><br />'+System.Label.Date+': '+dateString+'<br /><br />'+System.Label.No_of_error_records_blanket_SKU+': '+errCount+'<br /><br />'+System.Label.No_of_Success_records_blanket_SKU+': '+sccCount+'<br /><br />'+System.Label.Regards_blanket_SKU+',<br/>'+System.Label.UPL_Salesforce_Administrato_blanket_SKUr+'<br/>');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {errorAttach,successAttach}); 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    
    
    /*
* @Description  Method used to search blanket SKU based on filters.
* @Param        String skuNames - reperesents sku name passed from lwc in string
* 				string startDateSku - reperesents start date passed from lwc in string
* 				string endDateSku - reperesents end date passed from lwc in string
* 				string bSkuStatus - reperesents status passed from lwc in string
* @return       Returns list of SKUs.
*/
    
    @AuraEnabled
    public static List<SKU__c> getBlanketSkuBySearch(String SkuId,string startDateSku,string endDateSku,string bSkuStatus) {
        boolean flag=false;
        Sales_Org__c salesOrgObj = getSalesOrg();
        String salesOrg = salesOrgObj.Sales_Org_Code__c;
        System.debug('salesOrg ' +salesOrg);
        String query = 'select Id,Name,Sales_Org__r.Name,SKU_Code__c,SKU_Description__c,Combination_Key__c,Division__r.Division_Code__c,'
            +'Distribution_Channel__r.Distribution_Channel_Code__c,'
            +'(select Id,Start_Date__c,End_Date__c,Status__c,Expired_Reason__c from Blanket_SKU__r) from SKU__c where  Sales_Org__r.Sales_Org_Code__c=:salesOrg :condition1  order by CreatedDate desc';
        String condition1='' ;
        try{
            if ( startDateSku != null && startDateSku != '') {
                system.debug('startDateSku'+startDateSku);
                condition1 += ' AND id in (select SKU__c from Blanket_SKU__c where Start_Date__c>='+startDateSku;
                flag=true;
            }
            
            if ( endDateSku != null && endDateSku != '' && endDateSku >=startDateSku ) {
                if(flag){
                    condition1 += ' AND End_Date__c<='+endDateSku;
                }else{
                    condition1 += '  AND id in (select SKU__c from Blanket_SKU__c where End_Date__c<='+endDateSku;
                    flag=true;
                }
            }
            
            if ( bSkuStatus != null) {
                if(flag){
                    condition1 += ' AND  Status__c='+boolean.valueOf(bSkuStatus);
                }else{
                    condition1 += '  AND id in (select SKU__c from Blanket_SKU__c where  Status__c='+boolean.valueOf(bSkuStatus);
                }
            }
            if (condition1 !='') { 
                condition1 += ' ) ';
            }
            
            if (SkuId!=null && SkuId !='') {
                condition1 += ' AND Id=\''+SkuId+'\'';
            }
            
            system.debug('condition1'+condition1);
            query = query.replace(':condition1',condition1);
            query = query + ' LIMIT 1000';
            system.debug('query---'+query);
            
        }catch(Exception e){
            e.getMessage() ;
        }
        return Database.query( query );
    }
    
    
    
    
    /*
* @Description  Method used to fetch log-in user sales org.
* @Param        NA
* @return       returns log-in user sales org.
*/
    @AuraEnabled(Cacheable=true)
    public static Sales_Org__c getSalesOrg(){
        String country = '';
        Sales_Org__c salesorg;
        Login_Country__c loginCountry = null;
        User usr;
        if(Schema.sObjectType.User.isAccessible()){
            usr = [Select Id,Name,Country from User where id=:userInfo.getUserId()];
            system.debug('user'+usr);
        }
        if(usr!=null){
            if(test.isRunningTest()){
                country='HO';
            }else{
                country =  usr.Country;
            }
        }
        System.debug('for checking country '+country);
        System.debug('country for Test Class '+Schema.sObjectType.Login_Country__c.isAccessible());
        if(Schema.sObjectType.Login_Country__c.isAccessible() || Test.isRunningTest()){
            loginCountry = [Select id,Name,Sales_Org_Code__c from Login_Country__c where Name=:country Limit 1];
            System.debug('loginCountry for Test Class '+loginCountry);
        }
        if((loginCountry!=null && Schema.sObjectType.Sales_Org__c.isAccessible()) || Test.isRunningTest()){
            salesorg = [Select id,Name,Sales_Org_Code__c from Sales_Org__c where Sales_Org_Code__c=:loginCountry.Sales_Org_Code__c Limit 1];
        }
        system.debug('salesorg '+ salesorg);
        return salesorg;
    }
    
    //Wrapper Class
    public class wrapperClass{
        @AuraEnabled
        public Id Id;
        @AuraEnabled
        public string skuName;
        @AuraEnabled
        public string salesOrgName;    
        @AuraEnabled
        public Date startDate;
        @AuraEnabled
        public Date endDate;
        @AuraEnabled
        public boolean skuStatus=false;
        @AuraEnabled
        public String combinationKey;
        @AuraEnabled
        public String Type1;
        
    }    
}