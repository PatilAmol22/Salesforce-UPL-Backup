/**************************************************************************************************
* Name               : Grz_AdobeContractDetails                                                      
* Description        : Used for Customer Onboarding                                                                
* Test Class         : Grz_AdobeContractDetailsTest                                                                
* Created By         : Aashima Puri (Grazitti)   
* JIRA               : APPS-2665
**************************************************************************************************/
//Method to get details of contract
public with sharing class Grz_AdobeContractDetails {
    @AuraEnabled(cacheable=true)
    public static responseClass getSAandAccData(String recordId){
        responseClass returnValue=new responseClass();
        List<String> gstStatusList=System.Label.Grz_GSTStatus.split(',');
        List<Profile> pname=[Select name from profile where id =:userinfo.getProfileId()];
        List<contractDetailsMobileView__c> mobileview = new List<contractDetailsMobileView__c>();
        Map<String,contractDetailsMobileView__c> mobileViewSection= contractDetailsMobileView__c.getAll();
        system.debug('mobileViewSection---'+mobileViewSection);
        for(contractDetailsMobileView__c acc:mobileViewSection.values()){
            if(acc.Active__c){
                mobileview.add(acc);
            }
        }
        system.debug('mobileview---'+mobileview.size());
        
        returnValue.mobileviewSection = mobileview[0];
        if(!pname.isEmpty() && (pname[0].name =='Territory Manager' || pname[0].name =='Territory Manager SWAL' || pname[0].name =='System Administrator')){
            List<DistributorSalesAreaMapping__c> SAData=[Select id,Sales_Org_Code__c,SalesOrg__r.Company_Name__c,SalesOrg__r.Corporate_Office_Address__c,SalesOrg__r.Registered_office_Address__c,Distributor__r.GST_Validated__c,Distributor__r.GST_Status__c,Distributor__r.Non_GST_Customer__c,Distributor__r.Constitution_of_Business__c,Distributor__r.Name,Distributor__r.Email__c,Distributor__r.Mobile__c,Distributor__r.Tax_Number_3__c,Distributor__r.PAN_Number__c,Distributor__r.BillingStreet,Distributor__r.BillingCity,Distributor__r.BillingPostalCode,Distributor__r.BillingState,Distributor__r.BillingCountry,Distributor__r.Billing_Street_2__c,Distributor__r.First_Name__c,Relative_Name__c,Relative_Position__c,Relative_Head_quartered_Address__c,Relative_Department__c,Relative_Relationship__c,Total_of_liability__c,Total_No_of_years_in_business__c,Total_Business_in_Year_1__c,Total_Business_in_Year_2__c,Total_Business_in_Year_3__c,Total_Business_in_Year_4__c,Ratio_of_Cash_Credit_Purchase_in_busines__c,Ratio_of_Cash_Credit_Purchases_in_Year_1__c,Ratio_of_Cash_Credit_Purchases_in_Year_2__c,Ratio_of_Cash_Credit_Purchases_in_Year_3__c,Ratio_of_Cash_Credit_Purchases_in_Year_4__c,Year_of_Establishment__c,Shop_Establishment_Act_License_No__c,Insectticides_License_No__c,Fertilizer_License_No__c,Seeds_License_No__c,Bank_Name__c,Account_Number__c,IFSC_Code__c,Insectticides_Valid_till_date__c,Fertilizer_Valid_till_date__c,Seeds_Valid_till_date__c,Is_relative_worked_with_UPL__c,Contract_Details_Submitted__c,(Select id,ContentDocument.title from contentdocumentlinks order by systemmodstamp desc) from DistributorSalesAreaMapping__c where id=:recordId];
            system.debug('Sales area----'+SAData[0].Year_of_Establishment__c);
            system.debug('Sales area----Shop_Establishment_Act_License_No__c'+SAData[0].Shop_Establishment_Act_License_No__c);
            system.debug('Sales area----Insectticides_License_No__c'+SAData[0].Insectticides_License_No__c);
            system.debug('Sales area----Fertilizer_License_No__c'+SAData[0].Fertilizer_License_No__c);
            system.debug('Sales area----Seeds_License_No__c'+SAData[0].Seeds_License_No__c);
            if(!SAData.isEmpty()){
                
                List<AggregateResult> signingAuthList=[Select count(Id) from On_Boarding_Annexure_3__c where Sales_Area__c=:recordId];
                if(!signingAuthList.isEmpty()){
                    returnValue.signingAuthorityRecords=Integer.valueOf(signingAuthList[0].get('expr0'));
                }   
                else{
                    returnValue.signingAuthorityRecords=0;
                }
                
                List<AggregateResult> partnerList=[Select count(Id) from On_Boarding_Partner__c where Sales_Area__c=:recordId];
                if(!partnerList.isEmpty()){
                    returnValue.partnerRecords=Integer.valueOf(partnerList[0].get('expr0'));
                }   
                else{
                    returnValue.partnerRecords=0;
                }
                
                List<String> SalesOrgCodeList=System.Label.Grz_IndiaSalesOrgCode.split(',');
                if(SalesOrgCodeList.contains(SAData[0].Sales_Org_Code__c)){
                    if(SAData[0].Distributor__c!=null){
                        if(SAData[0].Distributor__r.GST_Validated__c==false){
                            returnValue.Message='Kindly validate GST first';
                            returnValue.Status=false;
                        }
                        else if(SAData[0].Distributor__r.GST_Validated__c==true && SAData[0].Distributor__r.Non_GST_Customer__c==false && gstStatusList.contains(SAData[0].Distributor__r.GST_Status__c)){
                            returnValue.Message='Kindly acknowledge to move forward as a non GST customer first';
                            returnValue.Status=false;
                        }
                        else if(SAData[0].Contract_Details_Submitted__c==true){
                            returnValue.Message='Contract details are already submitted';
                            returnValue.Status=false;
                        }
                        else{
                            returnValue.Message='Success';
                            returnValue.Status=true;
                            returnValue.SalesAreaRecord=SAData[0];
                        }
                    }
                }
                else{
                    returnValue.Message='This functionality is available for India, SWAL, UPL SAS and ALS India';
                    returnValue.Status=false;
                }
            }
        }
        else{
            returnValue.Message='This functionality is for Territory managers only';
            returnValue.Status=false;
        }
        
        return returnValue;
    }
    
    public class responseClass{
        @AuraEnabled public String Message      {get;set;}
        @AuraEnabled public Boolean Status      {get;set;}
        @AuraEnabled public DistributorSalesAreaMapping__c SalesAreaRecord      {get;set;}
        @AuraEnabled public contractDetailsMobileView__c mobileviewSection       {get;set;}
        @AuraEnabled public Integer signingAuthorityRecords      {get;set;}
        @AuraEnabled public Integer partnerRecords      {get;set;}
    }
    public class responseFileClass{
        @AuraEnabled public String Status      {get;set;}
        @AuraEnabled public List<ContentDocument> documentList      {get;set;}
    }
    
    
    
    
    //Method to update the title of document uploaded for contracts
    @AuraEnabled
    public static responseFileClass updateFileName(String filename, List<String> documentIdVal,String salesAreaId){
        responseFileClass res=new responseFileClass();
        List<String> docToBeConsidered=new List<String>();
        List<String> docToBeDeleted=new List<String>();
        //if(filename=='profilePhoto'){
        for(String s:documentIdVal){
            if(contentSizePublic(s,filename)=='ERROR'){
                docToBeDeleted.add(s);
            }
            /*else if(contentSizePublic(s,filename)=='ERROR 1'){
                docToBeDeleted.add(s);
            }*/
            else{
                docToBeConsidered.add(s);
            }
        }
        /*}
else{
docToBeConsidered=documentIdVal;
}*/
        if(!docToBeDeleted.isEmpty()){
            List<ContentDocument> condecList=[Select id,title from contentdocument where Id IN :docToBeDeleted];
            delete condecList;
            Integer profilePhotoSize=Integer.valueOf(System.Label.Grz_OnboardingProfilePhotoSize);
        	Integer otherFilesSize=Integer.valueOf(System.Label.Grz_OnboardingFileSize);
            if(filename=='profilePhoto'){
                res.Status='File size cannot be greater than '+String.valueOf(profilePhotoSize)+' kb';
            }
            else{
                res.Status='File size cannot be greater than '+String.valueOf(otherFilesSize/1000)+' mb';
            }
            res.documentList=condecList;
            return res;
        }
        List<ContentDocument> condecList=[Select id,title from contentdocument where Id IN :docToBeConsidered];
        List<ContentDocument> cdList=condecList;
        for(Integer i=0;i<condecList.size();i++){
            if(i==0)
                cdList[i].Title= filename;
            else
                cdList[i].Title= filename + i;
        }
        update cdList;
        if(filename=='bankFile' && res.Status!='' && res.Status!=null && res.Status!='undefined'){
            res.Status='Partial Upload Successful';
        }
        else{
            res.Status='Upload Successful';
        }
        
        res.documentList=condecList;
        
        if(filename=='profilePhoto'){
            List<ContentVersion> conversionList=[Select id,versiondata from contentversion where contentdocumentid IN :documentIdVal and title= :filename];
            System.debug('conversionList==>'+conversionList);
            List<DistributorSalesAreaMapping__c> salesAreaList=[Select id,profile_photo__c from DistributorSalesAreaMapping__c where id = :salesAreaId];
            System.debug('salesAreaList==>'+salesAreaList);
            if(!salesAreaList.isEmpty() && !conversionList.isEmpty()){
                salesAreaList[0].profile_photo__c =  EncodingUtil.base64Encode(conversionList[0].versiondata);
            }
            update salesAreaList;
        }
        return res;
    }
    //Method to save data of contract
    @AuraEnabled
    public static void saveData(List<String> deleteCheckBoxDocs,String salesAreaDetails, String salesAreaId,String deletedRecordList,String upsertedRecordList,String insertedRecordList){
        system.debug('salesAreaDetails==>'+salesAreaDetails);
        system.debug('salesAreaId==>'+salesAreaId);
        system.debug('deletedRecordList==>'+deletedRecordList);
        system.debug('upsertedRecordList==>'+upsertedRecordList);
        system.debug('insertedRecordList==>'+insertedRecordList);
        system.debug('deleteCheckBoxDocs==>'+deleteCheckBoxDocs);
        
        if(!deleteCheckBoxDocs.isEMpty()){
            List<ContentDocument> cdList=[Select id from ContentDocument where id IN :deleteCheckBoxDocs];
            delete cdList;
        }
        
        List<Object> deletedRecordList1=(List<Object>)JSON.deserializeUntyped(deletedRecordList);
        List<Object> upsertedRecordList1=(List<Object>)JSON.deserializeUntyped(upsertedRecordList);
        List<Object> insertedRecordList1=(List<Object>)JSON.deserializeUntyped(insertedRecordList);
        system.debug('deletedRecordList1==>'+deletedRecordList1);
        system.debug('upsertedRecordList1==>'+upsertedRecordList1);
        system.debug('insertedRecordList1==>'+insertedRecordList1);
        List<sObject> deletedRecordList11=convertToListsObject(deletedRecordList1,salesAreaId);
        List<sObject> upsertedRecordList11=convertToListsObject(upsertedRecordList1,salesAreaId);
        List<sObject> insertedRecordList11=convertToListsObject(insertedRecordList1,salesAreaId);
        system.debug('deletedRecordList11==>'+deletedRecordList11);
        system.debug('upsertedRecordList11==>'+upsertedRecordList11);
        system.debug('insertedRecordList11==>'+insertedRecordList11);
        if(!deletedRecordList11.isEmpty()){
            List<sObject> deletedRecordList111=new List<sObject>();
            for(sObject s:deletedRecordList11){
                if(null!=s.Id){
                    deletedRecordList111.add(s);
                }
            }
            if(!deletedRecordList111.isEmpty()){
                delete deletedRecordList111;
            }
        }
        if(!insertedRecordList11.isEmpty()){
            insert insertedRecordList11;
        }
        if(!upsertedRecordList11.isEmpty()){
            upsert upsertedRecordList11;
        }
        Map<String,Object> salesAreaMap=(Map<String,Object>)JSON.deserializeUntyped(salesAreaDetails);
        String fieldNames='';
        for(String s:salesAreaMap.keySet()){
            fieldNames=s+','+fieldNames;
        }
        fieldNames=fieldNames.removeEnd(',');
        system.debug('fieldNames==>'+fieldNames);
        String query='Select Id,'+fieldNames+' from DistributorSalesAreaMapping__c where id= \''+salesAreaId+'\'';
        List<DistributorSalesAreaMapping__c> saRecordList=Database.query(query);
        if(!saRecordList.isEmpty()){
            DistributorSalesAreaMapping__c saRecord=new DistributorSalesAreaMapping__c(Id=saRecordList[0].Id);
            for(String i:salesAreaMap.keySet()){
                system.debug('i==>'+i);
                system.debug('checkFieldType(i)==>'+checkFieldType(i));
                system.debug('salesAreaMap.get(i)==>'+salesAreaMap.get(i));
                if(checkFieldType(i)=='DOUBLE' || checkFieldType(i)=='CURRENCY'){
                    if(salesAreaMap.get(i)!='')
                        saRecord.put(i,double.valueOf(salesAreaMap.get(i)));
                    else
                        saRecord.put(i,0);   
                }
                else if(checkFieldType(i)=='DATE'){
                    if(salesAreaMap.get(i)!='')
                        saRecord.put(i,date.valueOf(String.valueOf(salesAreaMap.get(i))));
                    else
                        saRecord.put(i,NULL); 
                    
                }
                else{
                    saRecord.put(i,salesAreaMap.get(i));
                }
            }
            update saRecord;
        }
        
        //Maintain files as per data entered
        List<contentdocument> delIdList=new List<contentdocument>();
        
        List<contentdocumentlink> cdList=[Select id,ContentDocumentid,ContentDocument.title from contentdocumentlink where linkedentityid= :salesAreaId];
        if(salesAreaMap.get('Year_of_Establishment__c')==''){
            for(contentdocumentlink c:cdList){
                if(c.contentdocument.title=='yearOfEstablishmentFile'){
                    delIdList.add(new contentdocument(Id=c.contentdocument.id));
                }
            }
        }
        if(salesAreaMap.get('Shop_Establishment_Act_License_No__c')==''){
            for(contentdocumentlink c:cdList){
                if(c.contentdocument.title=='shopEstablishmentFile'){
                    delIdList.add(new contentdocument(Id=c.contentdocument.id));
                }
            }
        }
        if(salesAreaMap.get('Insectticides_License_No__c')==''){
            for(contentdocumentlink c:cdList){
                if(c.contentdocument.title=='pesticideFile'){
                    delIdList.add(new contentdocument(Id=c.contentdocument.id));
                }
            }
        }
        if(salesAreaMap.get('Fertilizer_License_No__c')==''){
            for(contentdocumentlink c:cdList){
                if(c.contentdocument.title=='fertilizerFile'){
                    delIdList.add(new contentdocument(Id=c.contentdocument.id));
                }
            }
        }
        if(salesAreaMap.get('Seeds_License_No__c')==''){
            for(contentdocumentlink c:cdList){
                if(c.contentdocument.title=='seedsLicenseFile'){
                    delIdList.add(new contentdocument(Id=c.contentdocument.id));
                }
            }
        }
        
        if(!delIdList.isEmpty()){
            delete delIdList;
        }
    }
    //Method to check the type of field for dynamic saving of record
    public static String checkFieldType(String fieldName){
        Map<String, Schema.SObjectField> M = Schema.SObjectType.DistributorSalesAreaMapping__c.fields.getMap();
        Schema.SObjectField field = M.get(fieldName);
        Schema.DisplayType FldType = field.getDescribe().getType();
        String fieldType=String.valueOf(FldType);
        return fieldType;
    }
    
    //Method to convert List<Objec> to List<sObject> for communication of data from lwc to apex
    public static List<sObject> convertToListsObject(List<Object> objectList,String salesAreaId){
        List<sObject> sObjectList=new List<sObject>();
        for(Object o:objectList){
            Map<String, Object> m = (Map<String, Object>)o;
            String key = (String)m.get('objectAPIName');
            String id = '';
            if(m.containsKey('Id')){
                id=(String)m.get('Id');
            }
            key = key.toLowerCase();
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(key);
            SObject sObj = targetType.newSObject();
            Map<String, Schema.SObjectField> fields = targetType.getDescribe().fields.getMap();
            for (String fieldName : m.keySet()) {
                Schema.SObjectField fld = fields.get(fieldName);
                if(fld!=null){
                    Schema.DisplayType FldType = fld.getDescribe().getType();
                    String fieldType=String.valueOf(FldType);
                    if (fld != null) {
                        if (fld.getDescribe().isCreateable() && fld.getDescribe().isUpdateable()) {
                            system.debug('fieldType==>'+fieldType);
                            system.debug('fieldName==>'+fieldName);
                            if(fieldType=='DOUBLE' || fieldType=='CURRENCY'){
                                sObj.put(fieldName, double.valueOf(m.get(fieldName))); 
                            }
                            else if(fieldType=='PERCENT'){
                                sObj.put(fieldName, decimal.valueOf(String.valueOf(m.get(fieldName))));
                            }
                            else{
                                sObj.put(fieldName, m.get(fieldName)); 
                            }
                            
                        }
                    }
                }
                
            }
            sObj.put('Sales_Area__c',salesAreaId);
            if(id!=null && id!='' && !id.contains('-')){
                sObj.Id=id;
            }
            sObjectList.add(sObj);
        }
        return sObjectList;
    }
    
    @AuraEnabled
    public static String checkAttachmentsSize(String linkedRecordId) {
        List<ContentDocumentLink> cdlist = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: linkedRecordId];
        Integer totalFilesSize=Integer.valueOf(System.Label.Grz_OnboardingFileSize);
        List<String> ContentDocIdList = new List<String>();   
        
        for(ContentDocumentLink cld : cdlist){
            ContentDocIdList.add(cld.ContentDocumentId);
        }
		
        
        List<ContentDocument> DocList = [select id,contentsize from ContentDocument where id in : ContentDocIdList];
        Integer totalSIze=0;
        for(ContentDocument doc : DocList){
            totalSIze = totalSIze + doc.contentsize;   
        }   
        
        if(totalSIze > totalFilesSize*1024){
            system.debug('size value==='+totalSIze);
            return 'ERROR';
        }
        else{
            system.debug('size value==='+totalSIze);
            return 'SUCCESS';
        }
    }
    
     @AuraEnabled  
    public static String deleteFiles(List<String> sdocumentIdList){ 
        String msg = 'Not Deleted';
        List<ContentDocument> docToBeDeleted = [select id,contentsize from ContentDocument where id =: sdocumentIdList]; 
        if(!docToBeDeleted.isEmpty()){
            delete docToBeDeleted;
            msg = 'deleted';
        }
        return msg;
    }
    
    //Method to check file size
    @AuraEnabled
    public static String contentSizePublic(String docid,String fileName) {
        Integer profilePhotoSize=Integer.valueOf(System.Label.Grz_OnboardingProfilePhotoSize);
        
        List<ContentDocument> Doc = [select id,contentsize from ContentDocument where id =: docid limit 1];
        if(!Doc.isEMpty()){
            integer size = Doc[0].contentsize;
            if(fileName=='profilePhoto'){
                if(size > (profilePhotoSize*1024)){
                    system.debug('size value==='+size);
                    //Delete Doc[0];
                    return 'ERROR';
                }
                else{
                    system.debug('size value==='+size);
                    return 'SUCCESS';
                }      
            }
            /*else{										// Code Commented by sumit
                if(size > (otherFilesSize*1024)){
                    system.debug('size value==='+size);
                    //Delete Doc[0];
                    return 'ERROR 1';
                }
                else {
                    system.debug('size value==='+size);
                    return 'SUCCESS';
                }     
            }*/
            
        }
        return 'File does not exist';    
    }
}