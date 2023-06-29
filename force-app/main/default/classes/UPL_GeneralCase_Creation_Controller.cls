/*
* Name : UPL_GeneralCase_Creation_Controller
* Created on : 4th May 2020
* Developer : Varun Shrivastava                               
* Description : To create UPL General Case record 
* Last Stable Backup : 
*/
public class UPL_GeneralCase_Creation_Controller {
    
    public Case caseRecord{get;set;}
    public String caseRecordTypeName{get;set;}
    public String loggedInUserName{get;set;}
    public String caseOwnerName{get;set;}
    public string caseId{get;set;}
    public List<String> fieldNameList{get;set;}
    public Boolean showSection{get;set;} 
    public Boolean showPage{get;set;} 
    public Map<String,String> caseFieldAPIToLabelMap{get;set;}
    public String caseQueryFields{get;set;}
    public String caseQuery;
    public Boolean isErrorOccured{get;set;}
    public String accountId;
    public Map<String, Schema.SObjectType> schemaMap;
    public Schema.SObjectType caseSchema;
    public Map<String, Schema.SObjectField> fieldMap;
    public String UPLRecordTypeID;
    public String caseType;
    public String caseSubQuery;
    //Added for Product Recommendation start    
    public Boolean showProductRecommendation{get;set;}
    public Boolean hideSection{get;set;}
    public Map<String,String> caseProductRecommendationMap{get;set;}
    public Boolean disableHideSection{get;set;}
    public Boolean hideCrop{get;set;}
    //Added for Product Recommendation End
    //
    public Boolean isCallerType{get;set;}
    public Boolean callerName{get;set;}
    public Boolean callerNumber{get;set;}
    
    public UPL_GeneralCase_Creation_Controller(ApexPages.StandardController controller) {
        caseRecord = (Case)controller.getRecord();
        caseRecordTypeName = '';
        loggedInUserName = '';
        caseOwnerName = '';
        showSection = false;
        //Added for Product Recommendation Start
        showProductRecommendation = false;
        hideSection = false;
        disableHideSection  =true;
        caseProductRecommendationMap = new Map<String, String>();
        hideCrop = false;
        //Added for Product Recommendation End
        isCallerType = false;
        callerName = true;
        callerNumber =  true;  
        fieldNameList = new List<String>();
        caseFieldAPIToLabelMap = new Map<String, String>();
        String mode = ApexPages.currentPage().getParameters().get('Mode');
        caseId = ApexPages.currentPage().getParameters().get('RecordId');
        
        caseQuery = '';
        isErrorOccured = false;
        caseQueryFields = '';
        caseId = ApexPages.currentPage().getParameters().get('id');
        String caseRecordTypeID = ApexPages.currentPage().getParameters().get('RecordTypeId');
        UPLRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
        string akcRetailerCaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC Retailer').getRecordTypeId();
        string swalGeneralCaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('SWAL General Case').getRecordTypeId();
        string swalRetailerCaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('SWAL Retailer').getRecordTypeId();
        string F3_C3_CaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('F3/C3/Sales Team').getRecordTypeId();
        
        accountId = ApexPages.currentPage().getParameters().get('accountId');
        //Added by Varun Shrivastava : Report POC Start
        caseRecord.L0_Agent_Start_Time__c = System.now();
        //Added by Varun Shrivastava : Report POC End
        User loggedInUser = [Select Id,Name from User where ID = :UserInfo.getUserId() limit 1];
        if(caseId != null){
           initiateRedirect();
        }else{
            showPage = true;
            if(caseRecordTypeID == UPLRecordTypeID){
                caseRecord.RecordTypeId = UPLRecordTypeID;
                caseRecordTypeName = 'AKC General Case';
                isCallerType = true;
            }
            if(caseRecordTypeID == akcRetailerCaseRecordType){
                caseRecord.RecordTypeId = akcRetailerCaseRecordType;
                caseRecordTypeName = 'AKC Retailer';
                isCallerType = true;
            }

            //Added By kuhinoor
            if(caseRecordTypeID == F3_C3_CaseRecordType){
                caseRecord.RecordTypeId = F3_C3_CaseRecordType;
                caseRecordTypeName = 'F3/C3/Sales Team';
                isCallerType = true;
            }
            // End here
            
            if(caseRecordTypeID == swalGeneralCaseRecordType){
                caseRecord.RecordTypeId = swalGeneralCaseRecordType;
                caseRecordTypeName = 'SWAL General Case';
                isCallerType = true;
            }
            if(caseRecordTypeID == swalRetailerCaseRecordType){
                caseRecord.RecordTypeId = swalRetailerCaseRecordType;
                caseRecordTypeName = 'SWAL Retailer';
                isCallerType = true;
            }
            
            if(loggedInUser != null){
                loggedInUserName = loggedInUser.Name;
                caseOwnerName = loggedInUserName;
            }
            caseRecord.OwnerId = loggedInUser.ID;
            if(accountId != null && accountId != ''){
                Account account  = [Select ID,Contact_Id__pc from Account where id = :accountId limit 1];
                caseRecord.AccountId = account.ID;
                caseRecord.ContactId = account.Contact_Id__pc;
            }
        }
    }
    
    
    public PageReference initiateRedirect(){
        try{
            caseId = ApexPages.currentPage().getParameters().get('id');
            
            if(caseId != null){
                
                UPLRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
                string akcRetailerCaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC Retailer').getRecordTypeId();
                string swalGeneralCaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('SWAL General Case').getRecordTypeId();
                string swalRetailerCaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('SWAL Retailer').getRecordTypeId();
                string F3_C3_CaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('F3/C3/Sales Team').getRecordTypeId();
                //WIT-002
            	string nurtutrFrmCaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('nurture.farm care').getRecordTypeId();
            
                
                Case caseTempRecord = [Select id,RecordTypeId,FO_Number__c,Type,Sub_Query__c,ContactId,Status,AccountId,Sent_to_ZM__c,Origin__c,Priority,L0_Agent_Start_Time__c,L0_Agent_Close_Time__c from Case where Id = :caseId limit 1];
                //Adding Priority field in query: SCTASK0380406 
                if(caseTempRecord.RecordTypeId != UPLRecordTypeID && caseTempRecord.RecordTypeId != swalGeneralCaseRecordType && 
                  caseTempRecord.RecordTypeId != akcRetailerCaseRecordType && caseTempRecord.RecordTypeId != swalRetailerCaseRecordType && 
                  caseTempRecord.RecordTypeId != F3_C3_CaseRecordType && 
                  caseTempRecord.RecordTypeId != nurtutrFrmCaseRecordType ){ // WIT-002
                    PageReference pageRef = new PageReference('/'+caseTempRecord.ID+'/e?nooverride=1');
                    pageRef.setRedirect(true);
                    return pageRef;
                }else
                {
                    PageReference pageRef = new PageReference('/apex/Case_UPL_GeneralCase_Edit?id='+caseTempRecord.ID);
                    pageRef.setRedirect(true)   ;
                    return pageRef;
                }
            }
        }
        catch(Exception exc){
            System.debug('Line : '+exc.getLineNumber() + ' Msg : '+exc.getMessage());
        }
        return null;
    }
    
    public void renderSections(){
        String type='Case';
        showSection = false;
        fieldNameList = new List<String>();
        schemaMap = Schema.getGlobalDescribe();
        caseSchema = schemaMap.get(type);
        caseFieldAPIToLabelMap = new Map<String,String>();
        //Added for Product Recommendation Start
        showProductRecommendation = false;
        hideSection = false;
        caseProductRecommendationMap = new Map<String, String>();
        disableHideSection = false;
        //Added for Product Recommendation End
        fieldMap = caseSchema.getDescribe().fields.getMap();
        List<UPL_General_Case_Type__mdt> caseRequiredCustomMdtRecord = [Select ID,Required_Fields__c from UPL_General_Case_Type__mdt where Type__c = :caseRecord.Type AND Sub_Query__c = :caseRecord.Sub_Query__c AND QRC__c = :caseRecord.QRC__c Limit 1];
        if(caseRequiredCustomMdtRecord.size() > 0){
            String requiredFields = caseRequiredCustomMdtRecord[0].Required_Fields__c;
            fieldNameList = requiredFields.split(':');
        }
        
        if(!fieldNameList.contains('Description')){
            fieldNameList.add('Description');
        }
        if(fieldNameList.contains('Level_1_Comments__c')){
            fieldNameList.remove(fieldNameList.indexOf('Level_1_Comments__c'));
            //fieldNameList.get('Level_1_Comments__c');
        }
        if(fieldNameList.contains('Level_2_Comments__c')){
            fieldNameList.remove(fieldNameList.indexOf('Level_2_Comments__c'));
            //fieldNameList.get('Level_1_Comments__c');
        }
        
        if(fieldNameList.size() > 0){
            showSection = true;
        }
        //Added by Varun Shrivastava End
        fieldNameList.sort();
        for(String  fieldName: fieldNameList){
            //Added by Varun Shrivastava Product Recommendation Start
            if(fieldName.containsIgnoreCase('Measure_') || fieldName.containsIgnoreCase('Dose_') || fieldName.containsIgnoreCase('Product_Recommended_')){
                if(caseProductRecommendationMap.containsKey('Product_Recommended_1_gc__c') || caseProductRecommendationMap.containsKey('Dose_1_gc__c') || caseProductRecommendationMap.containsKey('Measure_1_gc__c'))
                    continue;
                else{
                           caseProductRecommendationMap.put('Product_Recommended_1_gc__c',fieldMap.get('Product_Recommended_1_gc__c').getDescribe().getLabel());
                           caseProductRecommendationMap.put('Dose_1_gc__c',fieldMap.get('Dose_1_gc__c').getDescribe().getLabel());
                           caseProductRecommendationMap.put('Measure_1_gc__c',fieldMap.get('Measure_1_gc__c').getDescribe().getLabel());
                }
            }else
            //Added by Varun Shrivastava Product Recommendation End
            caseFieldAPIToLabelMap.put(fieldName,fieldMap.get(fieldName).getDescribe().getLabel());  
            caseQueryFields = caseQueryFields + fieldName + ',';
        }
        if(caseProductRecommendationMap.size() > 0){
            showProductRecommendation = true;
        }
    }
    
    public void doNothing(){
        //This is for default AF called.
    }
    
    /*public void addProductRecommendation(){
        String type='Case';
        caseSchema = schemaMap.get(type);
        fieldMap = caseSchema.getDescribe().fields.getMap();
        if(!caseProductRecommendationMap.containsKey('Product_Recommended_2_gc__c')){
                       caseProductRecommendationMap.put('Product_Recommended_2_gc__c',fieldMap.get('Product_Recommended_2_gc__c').getDescribe().getLabel());
                       caseProductRecommendationMap.put('Dose_2__c',fieldMap.get('Dose_2__c').getDescribe().getLabel());
                       caseProductRecommendationMap.put('Measure_2__c',fieldMap.get('Measure_2__c').getDescribe().getLabel());
                
        }else 
            if(!caseProductRecommendationMap.containsKey('Product_Recommended_3_gc__c')){
                       caseProductRecommendationMap.put('Product_Recommended_3_gc__c',fieldMap.get('Product_Recommended_3_gc__c').getDescribe().getLabel());
                       caseProductRecommendationMap.put('Dose_3__c',fieldMap.get('Dose_3__c').getDescribe().getLabel());
                       caseProductRecommendationMap.put('Measure_3__c',fieldMap.get('Measure_3__c').getDescribe().getLabel());
            }
        else if(!caseProductRecommendationMap.containsKey('Product_Recommended_4__c')){ 
                       caseProductRecommendationMap.put('Product_Recommended_4__c',fieldMap.get('Product_Recommended_4__c').getDescribe().getLabel());
                       caseProductRecommendationMap.put('Dose_4__c',fieldMap.get('Dose_4__c').getDescribe().getLabel());
                       caseProductRecommendationMap.put('Measure_4__c',fieldMap.get('Measure_4__c').getDescribe().getLabel());
            
        }
    }
    */
    public String checkValidations(){
        String errorMessage = null;
        /*if(caseRecord.Product_Recommended_1_gc__c != null || caseRecord.Product_Recommended_2_gc__c != null 
           || caseRecord.Product_Recommended_3_gc__c != null || caseRecord.Product_Recommended_4__c != null){
               List<Case> existingProductRecommendedCaseList = [Select Id from Case where AccountId = :caseRecord.AccountId AND 
                                                     ContactId = :caseRecord.ContactId AND (
                                                     (Product_Recommended_1_gc__c = :caseRecord.Product_Recommended_1_gc__c AND Product_Recommended_1_gc__c != null 
                                                      and Dose_1_gc__c = :caseRecord.Dose_1_gc__c and Dose_1_gc__c != null and Measure_1_gc__c = :caseRecord.Measure_1_gc__c and Measure_1_gc__c != null)
                                                      OR
                                                     (Product_Recommended_2_gc__c = :caseRecord.Product_Recommended_2_gc__c AND Product_Recommended_2_gc__c != null 
                                                      and Dose_2__c = :caseRecord.Dose_2__c and Dose_2__c != null and Measure_2__c = :caseRecord.Measure_2__c and Measure_2__c != null)
                                                     OR
                                                         (Product_Recommended_3_gc__c = :caseRecord.Product_Recommended_3_gc__c AND Product_Recommended_3_gc__c != null 
                                                      and Dose_3__c = :caseRecord.Dose_3__c and Dose_3__c != null and Measure_3__c = :caseRecord.Measure_3__c and Measure_3__c != null)
                                                     OR
                                                         (Product_Recommended_4__c = :caseRecord.Product_Recommended_4__c AND Product_Recommended_4__c != null 
                                                      and Dose_4__c = :caseRecord.Dose_4__c and Dose_4__c != null and Measure_4__c = :caseRecord.Measure_4__c and Measure_4__c != null)
                                                     )];
               if(existingProductRecommendedCaseList != null && existingProductRecommendedCaseList.size () > 0 && (!caseRecord.Override_Product_Recommendation__c)){
                   errorMessage = 'Case Can not be created because product has already been Recommended. If you still want to proceed, Select Override Recommended Product';
               }
                                                         
           }*/
        if(caseRecord.Type == 'Product Recommendation' && caseRecord.Product_Recommendation_Case__c == null){
            errorMessage = 'Product Recommendation Case is required field for Product Recommendation Type.';
        }
        if(caseRecord.Origin__c == null || caseRecord.Origin__c == ''){
            errorMessage = 'Please Select Case Origin.';
        }
        /*if(caseRecord.QRC__c == 'Query' && caseRecord.Status != 'Closed'){
            errorMessage = 'Please Select Status as Closed for Query Case.';
        }*/
       /* if((caseRecord.QRC__c == 'Request' || caseRecord.QRC__c == 'Complaint') && caseRecord.Status != 'Escalated-L1'){
            errorMessage = 'Please Select Status as Escalated-L1 for Request and Complaint type Case.';
        }*/  //Moumita(SCTASK0395053)
        //Added by Varun : INCTASK0431458 30 March 2021 Start
        if((caseRecord.Status != 'Escalated-L1' && caseRecord.Status != 'Closed')){
            errorMessage = 'Please Select Status as Closed or Escalated L1';
        }
        //Added by Varun : INCTASK0431458 30 March 2021 End
        
        if(!isCallerType && (caseRecord.Customer_Type__c == null || caseRecord.Customer_Type__c == '')){
            errorMessage = 'Please Select Customer Type.';
        }
        // Added by Kuhinoor
        if(isCallerType && String.isBlank(caseRecord.Caller_Type__c)){
            errorMessage = 'Please Select Caller Type.';
        }
        // End here
        // Added by Kuhinoor to validate caller number.
        if(isCallerType && callerNumber && ( String.isNotBlank(caseRecord.Caller_Number__c) && caseRecord.Caller_Number__c.length() < 10)){
            errorMessage = 'Please enter valid caller number.';
        }
        // End here
        if(caseRecord.Type == null || caseRecord.Type == ''){
            errorMessage = 'Please Select Case Type.';
        }
        if(caseRecord.Sub_Query__c == null || caseRecord.Sub_Query__c == ''){
            errorMessage = 'Please Sub Query.';
        }
        if(caseRecord.QRC__c == null || caseRecord.QRC__c == ''){
            errorMessage = 'Please Select QRC.';
        }
         return errorMessage;
    }
    
    
    public void hideOtherFields(){
        if(caseRecord.Type == 'Product Recommendation')
        hideCrop = true;
        else
        hideCrop = false;    
    }
    
    public PageReference saveFunctionality(){
        isErrorOccured = false;
        String errormsg = checkValidations();
        if(errormsg != null){
            isErrorOccured = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, errormsg));
            return null;
            
        }
        try{
            //Added by Varun Shrivastava:INCTASK0402006 26 Feb 2021 Start
            if(caseRecord.Status == 'Escalated-L1' || caseRecord.Status == 'Escalated-L2'){
            //Added by Varun Shrivastava:INCTASK0402006  26 Feb 2021  End
            AssignmentRule AR = new AssignmentRule(); //Divya
            AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1]; //Divya
            Database.DMLOptions dmlOpts = new Database.DMLOptions();//Divya
            dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;//Divya
            if(caseRecord.QRC__c == 'Request' || caseRecord.QRC__c == 'Complaint')
                caseRecord.setOptions(dmlOpts);//Divya
           //Added by Varun Shrivastava:INCTASK0402006  26 Feb 2021 Start
            } 
            //Added by Varun Shrivastava:INCTASK0402006 26 Feb 2021 End
            //Added by Varun Shrivastava : Report POC Start
            caseRecord.L0_Agent_Close_Time__c = System.now();
            //Added by Varun Shrivastava : Report POC End
            insert caseRecord;
          
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Record Saved Successfully'));
            PageReference pageRef = new PageReference('/'+caseRecord.ID);
            pageRef.setRedirect(true);
            return pageRef;
            
        }
        catch(Exception exceptionRecord){
            isErrorOccured = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, exceptionRecord.getMessage()));
        }
        return null;
    }
    
    public PageReference saveAndNewFunctionality(){
        try{
            saveFunctionality();
            if(!isErrorOccured){
                PageReference pageRef = new PageReference('/apex/Case_UPL_GeneralCase_Creation?RecordId=&Mode=&RecordTypeId='+caseRecord.RecordTypeId + '&accountId='+caseRecord.AccountId);
                pageRef.setRedirect(true);
                return pageRef;
            }
            else{
                return null;
            }
            
            
        }
        catch(Exception exceptionRecord){
            isErrorOccured = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, exceptionRecord.getMessage()));
            return null;
        }
    }
    
    public PageReference cancelFunctionality(){
        PageReference pageRef = new PageReference('/500/o');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public void toggleCallerField(){
        if(caseRecord.Caller_Type__c == 'Account Holder'){
            callerName = false;
            callerNumber =  false;  
        }else{
            callerName = true;
            callerNumber =  true;  
        }
    }
    
}