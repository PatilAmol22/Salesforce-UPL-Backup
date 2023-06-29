/**
* Apex class Name: NewCaseCreationController
* Author: EY (Ishu Mittal)
* APPS-
* Modified Date : 25-May-2023
* Description: Added the methods for new Record Type-UPL Comsumer Product
* */
public without sharing class NewCaseCreationController {
   @AuraEnabled(cacheable=true)
    public static Map<String,Nurture_Case_visibility__mdt> getMetadataInfo(){
        Map<String,Nurture_Case_visibility__mdt> metadataMap=new Map<String,Nurture_Case_visibility__mdt>();
        List<Nurture_Case_visibility__mdt> metadataList=[Select Id,SubCategory_ReasonForCall__c,Insect_List__c,Crop_Stage__c from Nurture_Case_visibility__mdt];
        for(Nurture_Case_visibility__mdt casevisibility:metadataList){
            metadataMap.put(casevisibility.SubCategory_ReasonForCall__c,casevisibility);
        }
        return metadataMap;
    }
    @AuraEnabled(cacheable=true)
    public static List<RecordType> getAccRecordTypes(){
        
        List<RecordType> recordTypeLst=[select id,Name from RecordType where SobjectType='Account' and IsActive=true
                                        and name in ('AKC Retailer','F3/C3/Sales Team','UnRegistered Farmer/Retailer','PreRegistered Farmer')];
        return recordTypeLst;
    }
    /**
* Author: EY (Ishu Mittal)
* APPS-5243
* Modified Date : 25-May-2023
* Description: Added the methods to fetch new Record Type 
* */
     @AuraEnabled(cacheable=true)
    public static List<RecordType> getAccRecordTypesforUplConsumerProduct(){
        
        List<RecordType> recordTypeLst=[select id,Name from RecordType where SobjectType='Account' and IsActive=true
                                        and developerName in ('Register_Consumer','Un_Register_Consumer')];
        return recordTypeLst;
    }
    
    @AuraEnabled
    public static string getCaseRecTypeName(Id recTypeId){
        String returnVal='';
        List<RecordType> recordTypeLst=[select id,Name from RecordType where SobjectType='Case' and id=:recTypeId];
        if(recordTypeLst.size()>0)
        {
            returnVal=recordTypeLst[0].Name;
        }
        returnVal=returnVal!=''?returnVal:'error';
        return returnVal;  
    }
    /*Added by Ishu Mittal for CR-APPS4721
     *Fetching Details of Metadata Nurture_Farm_Care_Description__mdt 
*/
@AuraEnabled
    public static Map<String,String> getIssueTypeFromMetaData(){
        Map<String,String> getDescriptionDataforIssueType=new Map<String,String>();
        List<Nurture_Farm_Care_Description__mdt> descrptionInfoList=[Select id,Issue_Type__c,Template__c from Nurture_Farm_Care_Description__mdt];
       for(Nurture_Farm_Care_Description__mdt description :descrptionInfoList )
       {
           getDescriptionDataforIssueType.put(description.Issue_Type__c,description.Template__c);
       }
        System.debug('getDescriptionDataforIssueType---->'+getDescriptionDataforIssueType);
        return   getDescriptionDataforIssueType;
    }
   
    
 
    @AuraEnabled
    public static Id insertAcc(Id recType,String mobile, String language, Id village, String name, String useSmartPhone,String useWhatsApp, Id distProd, String distribName){
        Map<id,RecordType> recordTypeLst=new Map<id,RecordType>([select id,Name from RecordType where SobjectType='Account' and IsActive=true
                                                                 and IsPersonType=true]);
        Id akcRetailerRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC Retailer').getRecordTypeId();
        Account acc=new Account();
        acc.recordtypeid=recType;
        String newName=name!=null?name:'Unregistered Customer';
        
        acc.Using_Smart_Phone__c=useSmartPhone;
        acc.Using_Watsapp__c=useWhatsApp;
        
        if(recordTypeLst.size()>0)
        {
            if(recordTypeLst.keySet().contains(recType))
            {
                acc.LastName=newName;
                
                if(language!=null)
                {
                    acc.Preferred_Language__pc=language;
                }
                acc.Village__pc=village;
                acc.PersonMobilePhone=mobile;
                
            }
            else {
                acc.Name=newName;
                if(language!=null)
                {
                    acc.Language__c=language;
                }
                acc.mobile__c=mobile;
                acc.Village__c=village;
            }
        }
        /*if(akcRetailerRecordType==recType)
{
acc.Distributor_Where_You_Buy_UPL_Products__c=distProd;
acc.Distributor_Name__c=distribName;
}*/
        insert acc;
        return acc.id;
    }
    
    /*
    * Description: create account record for UPL consumer.
	* Param: recType, mobile, language,village, state, pincode, name, useSmartPhone, useWhatsApp, distProd, distribName
	* return : Id
    * Added By :Ishu
    * */

     @AuraEnabled
    public static Id insertAccforUPLConsumer(Id recType,String mobile, String language, Id village,Id state,Id pincode,
                                             String name, String useSmartPhone,String useWhatsApp, Id distProd, 
                                             String distribName) {                                           
        Account accountRecord = new Account(recordtypeid =recType, 
                                  			Name = String.isNotBlank(name) ? name : 'Unregistered Customer',
                                            Using_Smart_Phone__c = useSmartPhone, Using_Watsapp__c = useWhatsApp,
                                  			Language__c = String.isNotBlank(language) ? language : '',
                                  			mobile__c = mobile, Village__c = village, India_state__c = state,
                                  			Pin_Code__c = pincode);
        insert accountRecord;
        return accountRecord.id;
    }
    
    
    @AuraEnabled
    public static String updateAcc(Id accId, String mobile, String language, Id village, String name, String useSmartPhone,String useWhatsApp,Boolean accChangeFlag){
        String returnVal='';
        if(accChangeFlag==true)
        {
            Account eachAcc=new Account(); 
            Map<id,RecordType> recordTypeLst=new Map<id,RecordType>([select id,Name from RecordType where SobjectType='Account' and IsActive=true
                                                                     and IsPersonType=true]);
            List<Account> accLst=[select id,recordtypeid,PersonMobilePhone,mobile__c,Name,LastName,Using_Smart_Phone__c,Using_Watsapp__c,Preferred_Language__pc,Language__c,Village__pc,Village__c from Account where id=:accId limit 1];
            if(accLst.size()>0)
            {
                for(Account eachAcc1:accLst)
                {
                    //eachAcc.PersonMobilePhone=mobile;
                    
                    
                    eachAcc.id=eachAcc1.id;
                    eachAcc.Using_Smart_Phone__c=useSmartPhone;
                    eachAcc.Using_Watsapp__c=useWhatsApp;
                    if(recordTypeLst.keySet().contains(eachAcc1.recordtypeid))
                    {
                        //eachAcc.FirstName='';
                        eachAcc.LastName=name;
                        if(language!=null)
                        {
                            eachAcc.Preferred_Language__pc=language;
                        }
                        eachAcc.Village__pc=village;
                        eachAcc.PersonMobilePhone=mobile;
                        
                    }
                    else {
                        
                        eachAcc.Name=name;
                        if(language!=null)
                        {
                            eachAcc.Language__c=language;
                        }
                        eachAcc.mobile__c=mobile;
                        eachAcc.Village__c=village;
                    }
                    
                }
                update eachAcc;
                returnVal='success';
            }
            
        }
        else {
            returnVal='success';
        }
        
        return returnVal;
    }
    
    
    /*
    * Description: create account record for UPL consumer.
	* Param: recType, mobile, language,village, state, pincode, name, useSmartPhone, useWhatsApp, distProd, distribName
	* return : returnVal
    * Added By :Ishu
    * */
    @AuraEnabled
    public static String updateAccforUPLComsumer(Id accId, String mobile, String language, Id village, String name, String useSmartPhone,String useWhatsApp, boolean accChangeFlag,String state,String pincode){
        String returnVal='';
        String Id = [SELECT Id from Account where id=:accId limit 1].Id;
        if(accChangeFlag && null != Id){
               Account accountToBeUpdated = new Account(Id = Id, Using_Smart_Phone__c = useSmartPhone,
                                             Using_Watsapp__c = useWhatsApp, Name = name,
                                             Language__c= String.isNotBlank(language) ? language : '',
                                             mobile__c = mobile, Village__c = village, India_state__c = state,
                                             Pin_Code__c = pincode);
               update accountToBeUpdated;
               returnVal='success'; 
        } else {
            returnVal='success';
        }
       return returnVal;
    }
    

    @AuraEnabled
    public static string insertCase1(String callerType, String origin,String callerName, String callerPhone, Id recordtypeId,
                                     Id accId,String department, String category, String subCategory,String reasonForCall, String qRC, String status, 
                                     Boolean complaintFlag, String comDepartment, String comCategory,String comSubCategory, String comReasonForCall, 
                                     Boolean productFlag, String productType, String product1, String product2,String dose1, String dose2, String measure1,
                                     String measure2,Object caseinfos ,String callId ,String orderNum ,String prodName1 ,String prodName2 ,String stateHead ,String brandName){
                                        //RITM0466996-Added by Nandhini-To capture Customer Related to Value
                                        Map<Object, Object> caseInfoMap = (Map<Object, Object>)caseinfos;
                                        system.debug('caseinfosMap description'+caseInfoMap.get('description'));
                                         AssignmentRule AR = new AssignmentRule();
                                         AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
                                         Database.DMLOptions dmlOpts = new Database.DMLOptions();
                                         dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
                                         Case caseRec=new Case();
                                         caseRec.recordtypeId=recordtypeId;
                                         caseRec.AccountId=accId;
                                         caseRec.L0_Agent_Start_Time__c  = System.now();
                                         caseRec.L0_Agent_Close_Time__c  = System.now();
                                         //INC0427580 - Added by Srinivas- To avoid call id entry for origin=whatsapp or any other means
                                         caseRec.Origin__c=origin;
                                         if(caseRec.Origin!='WhatsApp'&& callId!=null && callId!='')
                                         {
                                            caseRec.Call_Id__c=callId;
                                         }
                                         else {
                                            List<Genesys_Details__c> accLst=[select id,Call_Id__c from Genesys_Details__c where Account__c=:accId order by createdDate desc limit 1];
                                            if(accLst.size()>0 && caseRec.Origin!='WhatsApp')
                                            {
                                                caseRec.Call_Id__c=accLst[0].Call_Id__c;
                                            }
                                         }
                                         caseRec.Department__c=department;
                                         caseRec.QRC_Category__c=category;
                                         caseRec.QRC_sub_category__c=subCategory;
                                         caseRec.Reason_for_calling__c=reasonForCall;
                                         caseRec.Subject=reasonForCall;
                                         caseRec.QRC_type__c=qRC;
                                         caseRec.Status=status;
                                         caseRec.Caller_Type__c=callerType;
                                         
                                         //caseRec.Origin__c=origin;
                                         caseRec.Caller_Name__c=callerName;
                                         caseRec.Caller_Number__c=callerPhone;
                                         caseRec.Description=(string)caseInfoMap.get('description');
                                         //Added by nandhini
                                        caseRec.Customer_Related_To__c=(string)caseInfoMap.get('customerRelated');
                                         //Added by Mahesh
                                         if(reasonForCall=='Request for Video call'){
                                            caseRec.QRC_Time_Slot__c=string.valueOf(caseInfoMap.get('timeSlotValue')); 
                                         }
                                         
                                          //Added by Mahesh- RITM0572481
                                         if(reasonForCall=='Unable to scan a product'){
                                            caseRec.Crop_Name__c=string.valueOf(caseInfoMap.get('cropNameValue')); 
                                         }else if(reasonForCall=='How to scan product'){
                                              caseRec.Crop_Name__c=string.valueOf(caseInfoMap.get('cropNameValue')); 
                                         }else if(reasonForCall=='Bar Code Missing'){
                                              caseRec.Crop_Name__c=string.valueOf(caseInfoMap.get('cropNameValue')); 
                                         }else if(reasonForCall=='Mandi Price info'){
                                              caseRec.Crop_Name__c=string.valueOf(caseInfoMap.get('cropNameValue')); 
                                         }else if(reasonForCall=='Mandi Price Incorrect'){
                                              caseRec.Crop_Name__c=string.valueOf(caseInfoMap.get('cropNameValue')); 
                                         }else if(reasonForCall=='Rainfall info'){
                                              caseRec.Crop_Name__c=string.valueOf(caseInfoMap.get('cropNameValue')); 
                                         }else if(reasonForCall=='Wind speed info'){
                                              caseRec.Crop_Name__c=string.valueOf(caseInfoMap.get('cropNameValue')); 
                                         }else if(reasonForCall=='Temperature info'){
                                              caseRec.Crop_Name__c=string.valueOf(caseInfoMap.get('cropNameValue')); 
                                         }
                                         
                                         caseRec.setOptions(dmlOpts);
                                         if(complaintFlag==true)
                                         {
                                             caseRec.Complaint_Department__c=comDepartment;
                                             caseRec.Complaint_Category__c=comCategory;
                                             caseRec.Complaint_Sub_category__c=comSubCategory;
                                             caseRec.Complaint_Reason_for_call__c=comReasonForCall;
                                         }
                                         if(productFlag==true)
                                         {
                                             caseRec.Product_Type__c=productType;
                                             caseRec.Product_1__c=product1;
                                             caseRec.Product_2__c=product2!=null?product2:'';
                                             caseRec.Product_1_Size__c=dose1;
                                             caseRec.Product_2_Size__c=dose2!=null?dose2:'';
                                             caseRec.Product_1_Measure__c=measure1;
                                             caseRec.Product_2_Measure__c=measure2!=null?measure2:'';
                                         }
                                         if(String.isNotBlank(orderNum))
                                         {
                                            caseRec.Order_number__c=orderNum;
                                         }
                                         if(String.isNotBlank(prodName1))
                                         {
                                            caseRec.Product_Name_1__c=prodName1;
                                         }
                                         if(String.isNotBlank(prodName2))
                                         {
                                            caseRec.Product_Name_2__c=prodName2;
                                         }
                                         if(String.isNotBlank(stateHead))
                                         {
                                            caseRec.State_Head__c=stateHead;
                                         }
                                         if(String.isNotBlank(brandName))
                                         {
                                            caseRec.Multibrand_Name__c=brandName;
                                         }
                                         insert caseRec;
                                         return caseRec.id;
                                     }
    
    //Added By Ishu Mittal for new record Type
    /*
    * Description: create case record for UPL consumer.
	* Param: recType, mobile, language,village, state, pincode, name, useSmartPhone, useWhatsApp, distProd, distribName
	* return : returnVal
    * */
     @AuraEnabled
    public static string insertPrimaryCaseForUPLConsumer(CaseSection arrayCase) {                  
        
        Map<Object, Object> caseInfoMap = (Map<Object, Object>) arrayCase.caseinfos;
        Id assignmentId = [SELECT id FROM AssignmentRule WHERE SobjectType = 'Case' and Active = true limit 1].Id;
        Case caseRecord = insertCaseSMRecord(arrayCase, caseInfoMap, assignmentId);
        
        return caseRecord.id; 
    }
    
    //Generic code to insert record into Case Object for UPL consumer
    public static Case insertCaseSMRecord(CaseSection arrayCase , Map<Object, Object> caseInfoMap, Id assignmentId){
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId = assignmentId;
        
        Case caseRec = new Case();
        
        caseRec.recordtypeId = arrayCase.recordtypeId;
        caseRec.Account_Record_type__c = arrayCase.recordId;
        caseRec.Account_Consumer__c = arrayCase.accId;
        caseRec.L0_Agent_Start_Time__c  = System.now();
        caseRec.L0_Agent_Close_Time__c  = System.now();
        
        caseRec.Origin__c = arrayCase.origin;
        if(caseRec.Origin != 'WhatsApp'&& String.isNotBlank(arrayCase.callId)) {
            caseRec.Call_Id__c=arrayCase.callId;
        } else {
            List<Genesys_Details__c> accLst = [SELECT id,Call_Id__c FROM Genesys_Details__c WHERE Account__c=:arrayCase.accId ORDER BY createdDate DESC limit 1];
            if(accLst.size()>0 && caseRec.Origin!='WhatsApp') {
                caseRec.Call_Id__c=accLst[0].Call_Id__c;
            }
        }
        caseRec.Department__c=arrayCase.department;
        caseRec.QRC_Category__c=arrayCase.category;
        caseRec.QRC_sub_category__c=arrayCase.subCategory;
        caseRec.Reason_for_call1__c=arrayCase.reasonForCall;
        caseRec.Subject=arrayCase.reasonForCall;
        caseRec.QRC1__c=arrayCase.qRC;
        caseRec.Status=arrayCase.status;
        caseRec.Caller_Type__c=arrayCase.callerType;
       
        //caseRec.Origin__c=origin;
        caseRec.Caller_Name__c=arrayCase.callerName;
        caseRec.Caller_Number__c=arrayCase.callerPhone;
        caseRec.Description=(string)caseInfoMap.get('description');
        caseRec.Order_Id__c=arrayCase.orderId;
        caseRec.Purchased_From__c=arrayCase.purchasedFrom;
        caseRec.Batch_Number__c=arrayCase.batchNumber;
        //Added by nandhini
        caseRec.Customer_Related_To__c=(string)caseInfoMap.get('customerRelated');
        //added by mahesh- RITM0562254
        if(arrayCase.reasonForCall=='Request for Video call'){
            caseRec.QRC_Time_Slot__c=String.valueOf(caseInfoMap.get('timeSlotValue'));
        }
        
         //added by mahesh-RITM0572481 
        if(arrayCase.reasonForCall=='Unable to scan a product'){
            caseRec.Crop_Name__c=String.valueOf(caseInfoMap.get('cropNameValue'));
        }else if(arrayCase.reasonForCall=='How to scan product'){
            caseRec.Crop_Name__c=String.valueOf(caseInfoMap.get('cropNameValue'));
        }else if(arrayCase.reasonForCall=='Bar Code Missing'){
            caseRec.Crop_Name__c=String.valueOf(caseInfoMap.get('cropNameValue'));
        }else if(arrayCase.reasonForCall=='Mandi Price info'){
            caseRec.Crop_Name__c=String.valueOf(caseInfoMap.get('cropNameValue'));
        }else if(arrayCase.reasonForCall=='Mandi Price Incorrect'){
            caseRec.Crop_Name__c=String.valueOf(caseInfoMap.get('cropNameValue'));
        }else if(arrayCase.reasonForCall=='Rainfall info'){
            caseRec.Crop_Name__c=String.valueOf(caseInfoMap.get('cropNameValue'));
        }else if(arrayCase.reasonForCall=='Wind speed info'){
            caseRec.Crop_Name__c=String.valueOf(caseInfoMap.get('cropNameValue'));
        }else if(arrayCase.reasonForCall=='Temperature info'){
            caseRec.Crop_Name__c=String.valueOf(caseInfoMap.get('cropNameValue'));
        }
        
        caseRec.setOptions(dmlOpts);
        if(arrayCase.complaintFlag){
            caseRec.Complaint_Department__c=arrayCase.comDepartment;
            caseRec.Complaint_Category__c=arrayCase.comCategory;
            caseRec.Complaint_Sub_category__c=arrayCase.comSubCategory;
            caseRec.Complaint_Reason_for_call__c=arrayCase.comReasonForCall;
        }
        if(arrayCase.productFlag){
            caseRec.Product_Type__c=arrayCase.productType;
            caseRec.Product_1__c=arrayCase.product1;
            caseRec.Product_2__c=arrayCase.product2!=null?arrayCase.product2:'';
            caseRec.Product_1_Size__c=arrayCase.dose1;
            caseRec.Product_2_Size__c=arrayCase.dose2!=null?arrayCase.dose2:'';
            caseRec.Product_1_Measure__c=arrayCase.measure1;
            caseRec.Product_2_Measure__c=arrayCase.measure2!=null?arrayCase.measure2:'';
        }
        
        caseRec.Order_number__c= String.isNotBlank(arrayCase.orderNum) ? arrayCase.orderNum : '';
        caseRec.Product_Name_1__c = String.isNotBlank(arrayCase.prodName1) ? arrayCase.prodName1 : '';
        caseRec.Product_Name_2__c = String.isNotBlank(arrayCase.prodName2) ? arrayCase.prodName2 : '';
        caseRec.State_Head__c= String.isNotBlank(arrayCase.stateHead) ? arrayCase.stateHead : '' ;
        caseRec.Multibrand_Name__c = String.isNotBlank(arrayCase.brandName) ? arrayCase.brandName : '';
        
        insert caseRec; 
        
        return caseRec;
    }
    
    @AuraEnabled
    public static string insertCase2(String callerType, String origin,String callerName, String callerPhone, Id recordtypeId,
                                     Id accId,String department, String category, String subCategory,String reasonForCall, String qRC, String status, 
                                     Boolean complaintFlag, String comDepartment, String comCategory,String comSubCategory, String comReasonForCall, 
                                     Boolean productFlag, String productType, String product1, String product2,String dose1, String dose2, String measure1,String measure2,
                                     Object caseinfos,String callId,String orderNum ,String prodName1 ,String prodName2 ,String stateHead ,String brandName ){
                                         //RITM0466996-Added by Nandhini-To capture Customer Related to Value
                                         Map<Object, Object> caseInfoMap = (Map<Object, Object>)caseinfos;
                                         system.debug('caseinfosMap description'+caseInfoMap.get('description'));
                                         AssignmentRule AR = new AssignmentRule();
                                         AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
                                         Database.DMLOptions dmlOpts = new Database.DMLOptions();
                                         dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
                                         Case caseRec=new Case();
                                         caseRec.recordtypeId=recordtypeId;
                                         caseRec.AccountId=accId;
                                         caseRec.Department__c=department;
                                         caseRec.L0_Agent_Start_Time__c  = System.now();
                                         caseRec.L0_Agent_Close_Time__c  = System.now();
                                         //INC0427580 - Added by Srinivas- To avoid call id entry for origin=whatsapp or any other means
                                         caseRec.Origin__c=origin;
                                         if(caseRec.Origin!='WhatsApp'&&callId!=null && callId!='')
                                         {
                                            caseRec.Call_Id__c=callId;
                                         }
                                         else {
                                            List<Genesys_Details__c> accLst=[select id,Call_Id__c from Genesys_Details__c where Account__c=:accId order by createdDate desc limit 1];
                                            if(accLst.size()>0 && caseRec.Origin!='WhatsApp' )
                                            {
                                                caseRec.Call_Id__c=accLst[0].Call_Id__c;
                                            }
                                         }
                                         caseRec.QRC_Category__c=category;
                                         caseRec.QRC_sub_category__c=subCategory;
                                         caseRec.Reason_for_calling__c=reasonForCall;
                                         caseRec.Subject=reasonForCall;
                                         caseRec.QRC_type__c=qRC;
                                         caseRec.Status=status;
                                         caseRec.Caller_Type__c=callerType;
                                         
                                         caseRec.Origin__c=origin;
                                         caseRec.Caller_Name__c=callerName;
                                         caseRec.Caller_Number__c=callerPhone;
                                        caseRec.Description=(string)caseInfoMap.get('description');
                                         //Added by nandhini
                                        caseRec.Customer_Related_To__c=(string)caseInfoMap.get('customerRelated');
                                         //Added by Mahesh -RITM0562254
                                         if(reasonForCall=='Request for Video call'){
                                            caseRec.QRC_Time_Slot__c=string.valueOf(caseInfoMap.get('timeSlotValue'));
                                         }
                                          //Added by Mahesh -RITM0572481
                                         if(reasonForCall=='Unable to scan a product'){
                                            caseRec.Crop_Name__c=string.valueOf(caseInfoMap.get('cropNameValue'));
                                         }else if(reasonForCall=='How to scan product'){
                                            caseRec.Crop_Name__c=string.valueOf(caseInfoMap.get('cropNameValue'));
                                         }else if(reasonForCall=='Bar Code Missing'){
                                            caseRec.Crop_Name__c=string.valueOf(caseInfoMap.get('cropNameValue'));
                                         }else if(reasonForCall=='Mandi Price info'){
                                            caseRec.Crop_Name__c=string.valueOf(caseInfoMap.get('cropNameValue'));
                                         }else if(reasonForCall=='Mandi Price Incorrect'){
                                            caseRec.Crop_Name__c=string.valueOf(caseInfoMap.get('cropNameValue'));
                                         }else if(reasonForCall=='Rainfall info'){
                                            caseRec.Crop_Name__c=string.valueOf(caseInfoMap.get('cropNameValue'));
                                         }else if(reasonForCall=='Wind speed info'){
                                            caseRec.Crop_Name__c=string.valueOf(caseInfoMap.get('cropNameValue'));
                                         }else if(reasonForCall=='Temperature info'){
                                            caseRec.Crop_Name__c=string.valueOf(caseInfoMap.get('cropNameValue'));
                                         }
                                        

                                         caseRec.setOptions(dmlOpts);
                                         if(complaintFlag==true)
                                         {
                                             caseRec.Complaint_Department__c=comDepartment;
                                             caseRec.Complaint_Category__c=comCategory;
                                             caseRec.Complaint_Sub_category__c=comSubCategory;
                                             caseRec.Complaint_Reason_for_call__c=comReasonForCall;
                                         }
                                         if(productFlag==true)
                                         {
                                             caseRec.Product_Type__c=productType;
                                             caseRec.Product_1__c=product1;
                                             caseRec.Product_2__c=product2;
                                             caseRec.Product_1_Size__c=dose1;
                                             caseRec.Product_2_Size__c=dose2;
                                             caseRec.Product_1_Measure__c=measure1;
                                             caseRec.Product_2_Measure__c=measure2;
                                         }
                                         if(String.isNotBlank(orderNum))
                                         {
                                            caseRec.Order_number__c=orderNum;
                                         }
                                         if(String.isNotBlank(prodName1))
                                         {
                                            caseRec.Product_Name_1__c=prodName1;
                                         }
                                         if(String.isNotBlank(prodName2))
                                         {
                                            caseRec.Product_Name_2__c=prodName2;
                                         }
                                         if(String.isNotBlank(stateHead))
                                         {
                                            caseRec.State_Head__c=stateHead;
                                         }
                                         if(String.isNotBlank(brandName))
                                         {
                                            caseRec.Multibrand_Name__c=brandName;
                                         }
                                         insert caseRec;
                                         return caseRec.id;
                                     }
   /*  @AuraEnabled
    public static string insertSecondCaseforUPLConsumer(CaseSection arrayCase){
        Map<Object, Object> caseInfoMap = (Map<Object, Object>) arrayCase.caseinfos;
        Id assignmentId = [SELECT id FROM AssignmentRule WHERE SobjectType = 'Case' and Active = true limit 1].Id;
        Case caseRecord = insertCaseSMRecord(arrayCase, caseInfoMap, assignmentId);
        
        return caseRecord.id;
    }*/
    
    @AuraEnabled
    public static String getCallId(String mobile,String disposition, String accId , String callerNum ){
        Genesys_API__mdt apiVals=[select DeveloperName,End_Point_URL__c from Genesys_API__mdt where DeveloperName='Disposition'];
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String callid='';
        String mobStr='';
        String dispositionStr='';
        String callidStr='';
        if(String.isNotBlank(callerNum))
        {
            mobile=callerNum;
        }
        if(accId!=null && accId!='')
        {
            List<Genesys_Details__c> accLst=[select id,Call_Id__c from Genesys_Details__c where Account__c=:accId order by createdDate desc limit 1];
            if(accLst.size()>0)
            {
                callid=accLst[0].Call_Id__c!=null?accLst[0].Call_Id__c:'';
                //if(callid!=null && callid!='')
                //{
                //callidStr='&CallID='+callid;
                //}
            }
            
        }
        //String newDispo=disposition.replace(' ', '%20');
        //callidStr='&CallID='+callid;
        //mobStr='Mobile='+mobile;
        //dispositionStr='&Disposition='+newDispo;
        /*if(mobile!=null && mobile!='')
{
mobStr='Mobile='+mobile;
}
if(disposition!=null && disposition!='')
{
dispositionStr='&Disposition='+disposition;
}*/
        
        String endPointStr = apiVals.End_Point_URL__c;
        request.setEndpoint(endPointStr);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/JSON');
        JSONGenerator bodyBuilder = JSON.createGenerator(false);
        bodyBuilder.writeStartObject();
        bodyBuilder.writeStringField('CallID', callid);
        bodyBuilder.writeStringField('Mobile', mobile);
        bodyBuilder.writeStringField('Disposition', disposition);
        bodyBuilder.writeEndObject();
        request.setBody(bodyBuilder.getAsString());
        HttpResponse response = new HttpResponse();
        response=http.send(request);
        if (response.getStatusCode() == 200) {
            //Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String,object> mapper=(map<String,object>)JSON.deserializeUntyped(response.getBody());
            String val=(String)mapper.get('CallID');
            return val;
        }
        else {
            return 'error';
        }
    }
    
    @AuraEnabled
    public static List<String> getPrefLangOptions(){
        
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Preferred_Language__pc.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }

    @AuraEnabled
    public static String updateCaseRecs(String accId,String callId){
        Boolean listFlag=false;
        List<Case> caseLst=new List<Case>();
        if(accId!=null && accId!='')
        {
            caseLst=[select id,Origin__c,call_id__c from case where accountid=:accId limit 10];
            for(case eachCase:caseLst)
            {
                //INC0427580 - Added by Srinivas- To avoid call id entry for origin=whatsapp or any other means
                if(String.isBlank(eachCase.call_id__c)&& eachCase.Origin__c!='WhatsApp')
                {
                    eachCase.call_id__c=callId;
                    listFlag=true;
                }
            }
        }
        if(listFlag)
        {
            update caseLst;
        }
        return 'success';
        

    }
    
    
    
    @AuraEnabled
    public static AccDetails getExistAccDetails(Id recId,String objName){
        //List<RecordType> recordTypeLst=[select id,Name from RecordType where SobjectType='Account' and IsActive=true
                                        //and name= 'PreRegistered Farmer'];
        Map<id,RecordType> recordTypeLst=new Map<id,RecordType>([select id,Name from RecordType where SobjectType='Account' and IsActive=true
                                        and IsPersonType=true]);
        AccDetails accDet=new AccDetails();
        if(objName=='Account')
        {
            List<Account> accLst=[select id,name,PersonMobilePhone,mobile__c,Village__pc,Village__c,Preferred_Language__pc,Language__c,Using_Smart_Phone__c,Using_Watsapp__c,recordtypeid,recordtype.name,StateName__c,PIN__c,India_state__c,Pin_Code__c,Subscription_type__c,Expiry_date__c from Account where id=:recId];
            for(Account eachAcc:accLst)
            {  
                Id village=eachAcc.Village__pc!=null?eachAcc.Village__pc:eachAcc.Village__c;
               
               
                
                String lang=eachAcc.Preferred_Language__pc!=null?eachAcc.Preferred_Language__pc:eachAcc.Language__c!=null?eachAcc.Language__c:'';
                accDet.id=eachAcc.id;
                accDet.name=eachAcc.name;
                //if(eachAcc.recordtypeid==recordTypeLst[0].id)
                if(recordTypeLst.keySet().contains(eachAcc.recordtypeid))
                {
                    
                    accDet.mobile=eachAcc.PersonMobilePhone;
                    
                }
                else {
                    
                    accDet.mobile=eachAcc.mobile__c;
                }
                accDet.village=village;
                accDet.prefLang=lang;
                accDet.usingSmartPhone=eachAcc.Using_Smart_Phone__c;
                accDet.usingWhatsapp=eachAcc.Using_Watsapp__c;
                accDet.recTypeIdAcc=eachAcc.recordtypeid;
                accDet.recTypeNameAcc=eachAcc.recordtype.name;
                accDet.statusMsg='success';
                accDet.state=eachAcc.India_state__c;
                accDet.pincode=eachAcc.Pin_Code__c;
                accDet.subscription=eachAcc.Subscription_type__c;
                accDet.expiryDate=eachAcc.Expiry_date__c;
            }
            if(accLst.size()==0)
            {
                accDet.statusMsg='error';
            }
        }
        else {
            accDet.statusMsg='error';
        }
        
        return accDet;    
    }
    
    
    public class AccDetails {
        @AuraEnabled
        public id id{get;set;}
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public String mobile{get;set;}
        @AuraEnabled
        public Id village{get;set;}
        @AuraEnabled
        public String usingSmartPhone{get;set;}
        @AuraEnabled
        public String usingWhatsapp{get;set;}
        @AuraEnabled
        public String prefLang{get;set;}
        @AuraEnabled
        public Id recTypeIdAcc{get;set;}
        @AuraEnabled
        public String recTypeNameAcc{get;set;}
        @AuraEnabled
        public String statusMsg{get;set;}
        @AuraEnabled
        public String state{get;set;}
        @AuraEnabled 
        public String pincode{get;set;}
        @AuraEnabled
        public String subscription{get;set;}
        @AuraEnabled
        public Date expiryDate{get;set;}
    }
    
    public class CaseSection {
  @AuraEnabled public String callerType { get; set; }
  @AuraEnabled public String origin { get; set; }
         @AuraEnabled public String callerName { get; set; }
  @AuraEnabled public String callerPhone { get; set; }
         @AuraEnabled public Id recordtypeId { get; set; }
  @AuraEnabled public Id accId { get; set; }
         @AuraEnabled public String department { get; set; }
  @AuraEnabled public String category { get; set; }
         @AuraEnabled public String subCategory { get; set; }
  @AuraEnabled public String reasonForCall { get; set; }
         @AuraEnabled public String qRC { get; set; }
  @AuraEnabled public String status { get; set; }
         @AuraEnabled public Boolean complaintFlag { get; set; }
  @AuraEnabled public String comDepartment { get; set; }
         @AuraEnabled public String comCategory { get; set; }
  @AuraEnabled public String comSubCategory { get; set; }
         @AuraEnabled public Boolean productFlag { get; set; }
  @AuraEnabled public String productType { get; set; }
         @AuraEnabled public String comReasonForCall { get; set; }
  @AuraEnabled public String product1 { get; set; }
         @AuraEnabled public String product2 { get; set; }
  @AuraEnabled public String dose1 { get; set; }
         @AuraEnabled public String dose2 { get; set; }
  @AuraEnabled public String measure1 { get; set; }
         @AuraEnabled public String measure2 { get; set; }
  @AuraEnabled public  Object caseinfos  { get; set; }
         @AuraEnabled public String callId { get; set; }
  @AuraEnabled public String orderNum { get; set; }
         @AuraEnabled public String prodName2 { get; set; }
  @AuraEnabled public  String stateHead  { get; set; }
         @AuraEnabled public String prodName1 { get; set; }
  @AuraEnabled public String brandName { get; set; }
 @AuraEnabled public String orderId { get; set; }
  @AuraEnabled public String BatchNumber { get; set; }  
        @AuraEnabled public String purchasedFrom { get; set; } 
         @AuraEnabled public String recordID { get; set; }  
        @AuraEnabled public String timeSlot{get; set;}
        @AuraEnabled public String cropName{get; set;}//RITM0572481-added by Mahesh
}
}