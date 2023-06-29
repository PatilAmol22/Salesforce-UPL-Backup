/*
* Name : UPL_GeneralCase_EditCreation_Controller
* Created on : 26th May 2020
* Developer : Varun Shrivastava                               
* Description : To create UPL General Case record 
* Last Stable Backup : 
*/
public class UPL_GeneralCase_EditCreation_Controller {
    
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
    public String caseType{get;set;}
    public String caseStatus{get;set;} //Divya
    public String caseSubQuery{get;set;}
    public String caseQRC{get;set;}
    public Case caseOtherRecord{get;set;}
    //Added for Product Recommendation start    
    public Boolean showProductRecommendation{get;set;}
    public Boolean hideSection{get;set;}
    public Map<String,String> caseProductRecommendationMap{get;set;}
    public Boolean disableHideSection{get;set;}
    //Added for Product Recommendation End
  public Boolean hideCrop{get;set;}
    //Added by Varun : Start : INCTASK0376033
    public Case clonedCaseRecord;
    //Added by Varun : End : INCTASK0376033
    //Added by Varun Shrivastava start Report POC
    public Boolean l1AgentUser=false;
    public Boolean l2AgentUser=false;
    public Boolean l0AgentUser=false;
    public String profileName = '';
    //Added by Varun Shrivastava end Report POC
   //Added by Kuhinoor 
	public Boolean isCallerType{get;set;}
    public Boolean callerName{get;set;}
    public Boolean callerNumber{get;set;}
    // End here
    
    public UPL_GeneralCase_EditCreation_Controller() {
        caseId = ApexPages.currentPage().getParameters().get('Id');
        caseRecordTypeName = '';
        loggedInUserName = '';
        caseOwnerName = '';
        showSection = false;
        //Added for Product Recommendation Start
        showProductRecommendation = false;
        hideSection = false;
        hideCrop = false;
        disableHideSection  =true;
        caseProductRecommendationMap = new Map<String, String>();
        //Added for Product Recommendation End
        //Added by Kuhinoor 
		isCallerType = false;
        callerName = true;
        callerNumber =  true;  
		// End here
        
        fieldNameList = new List<String>();
        caseFieldAPIToLabelMap = new Map<String, String>();
        String mode = ApexPages.currentPage().getParameters().get('Mode');
        caseId = ApexPages.currentPage().getParameters().get('RecordId');
        caseQuery = '';
        isErrorOccured = false;
        caseQueryFields = '';
        caseId = ApexPages.currentPage().getParameters().get('id');
        UPLRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
        string akcRetailerCaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC Retailer').getRecordTypeId();
        string swalGeneralCaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('SWAL General Case').getRecordTypeId();
        string swalRetailerCaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('SWAL Retailer').getRecordTypeId();
        string F3_C3_CaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('F3/C3/Sales Team').getRecordTypeId();    
        string nurtutrFrmCaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('nurture.farm care').getRecordTypeId();
        accountId = ApexPages.currentPage().getParameters().get('accountId');
        User loggedInUser = [Select Id,Name,Profile.Name from User where ID = :UserInfo.getUserId() limit 1];
        profileName = loggedInUser.Profile.Name;
        system.debug('profileName is '+profileName);
      //Added by Varun Shrivastava start Report POC     
      
        List<GroupMember> queueMemberL1 = [Select UserOrGroupId,GroupId,Group.Name From GroupMember where UserOrGroupId = :loggedInUser.ID  and Group.Name in ('QRC Technical Queue','QRC Non Technical Queue')];
        List<GroupMember> queueMemberL2 = [Select UserOrGroupId,GroupId,Group.Name From GroupMember where UserOrGroupId = :loggedInUser.ID  and Group.Name in ('QRC Technical Queue L2','QRC Non Technical Queue L2')];
        if(queueMemberL1.size() > 0){
            l1AgentUser = true;
        }    
        if(queueMemberL2.size() > 0){
            l2AgentUser = true;
        }
        if (queueMemberL1.size() <= 0 && queueMemberL2.size() <= 0 && profileName != 'System Administrator'){
            l0AgentUser = true;
        }
        //Added by Varun Shrivastava End Report POC
        
        if(caseId != null){
            editFunctionality();
            caseFieldAPIToLabelMap = new Map<String, String>();
            if(caseRecord != null){
                caseRecordTypeName = caseRecord.RecordType.Name;
                caseOwnerName = caseRecord.Owner.Name;

                //Added by Kuhinoor
				String CaseRecordId = caseRecord.RecordTypeId;
				if(CaseRecordId == UPLRecordTypeID || CaseRecordId == akcRetailerCaseRecordType || 
                   CaseRecordId == swalGeneralCaseRecordType || CaseRecordId == swalRetailerCaseRecordType 
                   || CaseRecordId == F3_C3_CaseRecordType || CaseRecordId == nurtutrFrmCaseRecordType ){
					isCallerType = true;
					if(caseRecord.Caller_Type__c == 'Account Holder'){
						callerName = false;
						callerNumber =  false;  
					}
				}
				//End Here
                
                for(String  fieldName: fieldNameList){
                    //Added by Varun Shrivastava Product Recommendation Start
            if(fieldName.containsIgnoreCase('Measure_') || fieldName.containsIgnoreCase('Dose_') || fieldName.containsIgnoreCase('Product_Recommended_')){
                if(caseProductRecommendationMap.size()> 0)
                    continue;
                else{
                       caseProductRecommendationMap.put('Product_Recommended_1_gc__c',fieldMap.get('Product_Recommended_1_gc__c').getDescribe().getLabel());
                         caseProductRecommendationMap.put('Dose_1_gc__c',fieldMap.get('Dose_1_gc__c').getDescribe().getLabel());
                         caseProductRecommendationMap.put('Measure_1_gc__c',fieldMap.get('Measure_1_gc__c').getDescribe().getLabel());
                       caseProductRecommendationMap.put('Product_Recommended_2_gc__c',fieldMap.get('Product_Recommended_2_gc__c').getDescribe().getLabel());
                            caseProductRecommendationMap.put('Dose_2__c',fieldMap.get('Dose_2__c').getDescribe().getLabel());
                            caseProductRecommendationMap.put('Measure_2__c',fieldMap.get('Measure_2__c').getDescribe().getLabel());
                       caseProductRecommendationMap.put('Product_Recommended_3_gc__c',fieldMap.get('Product_Recommended_3_gc__c').getDescribe().getLabel());
                            caseProductRecommendationMap.put('Dose_3__c',fieldMap.get('Dose_3__c').getDescribe().getLabel());
                           caseProductRecommendationMap.put('Measure_3__c',fieldMap.get('Measure_3__c').getDescribe().getLabel());
                     caseProductRecommendationMap.put('Product_Recommended_4__c',fieldMap.get('Product_Recommended_4__c').getDescribe().getLabel());
                            caseProductRecommendationMap.put('Dose_4__c',fieldMap.get('Dose_4__c').getDescribe().getLabel());
                            caseProductRecommendationMap.put('Measure_4__c',fieldMap.get('Measure_4__c').getDescribe().getLabel());
              }
            }else
            //Added by Varun Shrivastava Product Recommendation End
            
            
                    caseFieldAPIToLabelMap.put(fieldName,fieldMap.get(fieldName).getDescribe().getLabel());  
                }    
            }  
            if(caseFieldAPIToLabelMap.size() > 0)
                showSection = true;
            //Added for Product Recommendation Start
        if(caseProductRecommendationMap.size() > 0){
            showProductRecommendation = true;
            disableHideSection = false;
        }
        //Added for Product Recommendation End
            //System.assert(false,'caseFieldAPIToLabelMap : '+caseFieldAPIToLabelMap);
        } 
        
    }
    
    public void doNothing(){
        //This is for default AF called.
    }
    
    public void editFunctionality(){
          showPage = false;
            showSection = false;
            String type='Case';
            //Added for Product Recommendation Start
            showProductRecommendation = false;
            hideSection = false;
            disableHideSection  =true;
            caseProductRecommendationMap = new Map<String, String>();
          //Added for Product Recommendation End
            fieldNameList = new List<String>();
            schemaMap = Schema.getGlobalDescribe();
            caseSchema = schemaMap.get(type);
            fieldMap = caseSchema.getDescribe().fields.getMap();
            caseFieldAPIToLabelMap = new Map<String,String>();
            caseQueryFields = '';
            Case tempCase = [Select Type,Sub_Query__c,QRC__c,QRC_type__c,Status from Case where id = :caseId limit 1];
            if(tempCase != null){
                caseType = tempCase.Type;
                caseStatus = tempCase.Status; //Divya
                caseSubQuery = tempCase.Sub_Query__c;
                caseQRC = tempCase.QRC_type__c; // WIT-002
                if(tempCase.Type == 'Product Recommendation')
              hideCrop = true;
            else
              hideCrop = false;
              }
            List<UPL_General_Case_Type__mdt> caseRequiredCustomMdtRecord = [Select ID,Required_Fields__c from UPL_General_Case_Type__mdt where Type__c = :caseType AND Sub_Query__c = :caseSubQuery AND QRC__c = :caseQRC Limit 1];
            if(caseRequiredCustomMdtRecord.size() > 0){
                String requiredFields = caseRequiredCustomMdtRecord[0].Required_Fields__c;
                fieldNameList = requiredFields.split(':');
            }
        if(!fieldNameList.contains('Description')){
            fieldNameList.add('Description');
        }
        if((caseStatus == 'Escalated-L2' || caseStatus == 'Escalated-L1' || caseStatus == 'Closed' || caseStatus == 'Reopen')&&(caseQRC != 'Query')){
           fieldNameList.add('Level_2_Comments__c');
           fieldNameList.add('Level_1_Comments__c');
        }
            system.debug('fieldNameList'+fieldNameList);
            for(String  fieldName: fieldNameList){
                caseQueryFields = caseQueryFields + fieldName + ',';
            }
            caseQuery = 'Select Id,'+ caseQueryFields + 'ContactId,AccountId,'+
                'Sent_to_ZM__c,Origin__c,Status,Type,Reopened_Close_Date__c,Reopened_Start_Date__c,Reopened_Case__c,Crop_pick__c,Other_Crop_Name__c,FO_Number__c,Sub_Query__c,QRC__c,Department__c,QRC_Category__c,QRC_sub_category__c,QRC_type__c,Reason_for_calling__c,Product_1__c,Product_1_Size__c,Product_1_Measure__c, Product_Type__c,Product_2__c,Product_2_Measure__c,Product_2_Size__c,OwnerId,Follow_Up_Status_1__c,Follow_Up_Status_2__c,Follow_Up_Status_3__c,Follow_Up_1_Date_Time__c,Follow_Up_2_Date_Time__c,Follow_Up_3_Date_Time__c,Customer_Type__c,RecordType.Name,Owner.Name, Priority,L1_Agent_Start_Time__c,L2_Agent_Start_Time__c,Caller_Type__c,Caller_Name__c,Caller_Number__c from Case where id = :caseId limit 1';   
            //Adding Priority field in query: SCTASK0380406 
          caseRecord = Database.query(caseQuery);
            //Added by Varun : clonedCaseRecord Start INCTASK0376033
            clonedCaseRecord = caseRecord.clone(true,true,false,false);
            //Added by Varun : clonedCaseRecord End INCTASK0376033
            //Added by Varun Shrivastava : Report POC Start
            if(l1AgentUser && caseRecord.L1_Agent_Start_Time__c == null)
                caseRecord.L1_Agent_Start_Time__c = System.now();
          if(l2AgentUser && caseRecord.L2_Agent_Start_Time__c == null)
                caseRecord.L2_Agent_Start_Time__c = System.now();
              
          //Added by Varun Shrivastava : Report POC End
        
            caseOtherRecord = caseRecord;
          if(caseRecord != null){
              // WIT-002- Kuhinoor
              if(caseRecord.QRC_Category__c == 'Agronomy'){
                  showProductRecommendation = true;
            	  disableHideSection = true;
              }
              
                for(String  fieldName: fieldNameList){
                    //Added by Varun Shrivastava Product Recommendation Start
            if(fieldName.containsIgnoreCase('Measure_') || fieldName.containsIgnoreCase('Dose_') || fieldName.containsIgnoreCase('Product_Recommended_')){
                if(caseProductRecommendationMap.size()> 0)
                    continue;
                else{
                       caseProductRecommendationMap.put('Product_Recommended_1_gc__c',fieldMap.get('Product_Recommended_1_gc__c').getDescribe().getLabel());
                         caseProductRecommendationMap.put('Dose_1_gc__c',fieldMap.get('Dose_1_gc__c').getDescribe().getLabel());
                         caseProductRecommendationMap.put('Measure_1_gc__c',fieldMap.get('Measure_1_gc__c').getDescribe().getLabel());
                       caseProductRecommendationMap.put('Product_Recommended_2_gc__c',fieldMap.get('Product_Recommended_2_gc__c').getDescribe().getLabel());
                            caseProductRecommendationMap.put('Dose_2__c',fieldMap.get('Dose_2__c').getDescribe().getLabel());
                            caseProductRecommendationMap.put('Measure_2__c',fieldMap.get('Measure_2__c').getDescribe().getLabel());
                       caseProductRecommendationMap.put('Product_Recommended_3_gc__c',fieldMap.get('Product_Recommended_3_gc__c').getDescribe().getLabel());
                            caseProductRecommendationMap.put('Dose_3__c',fieldMap.get('Dose_3__c').getDescribe().getLabel());
                           caseProductRecommendationMap.put('Measure_3__c',fieldMap.get('Measure_3__c').getDescribe().getLabel());
                     caseProductRecommendationMap.put('Product_Recommended_4__c',fieldMap.get('Product_Recommended_4__c').getDescribe().getLabel());
                            caseProductRecommendationMap.put('Dose_4__c',fieldMap.get('Dose_4__c').getDescribe().getLabel());
                            caseProductRecommendationMap.put('Measure_4__c',fieldMap.get('Measure_4__c').getDescribe().getLabel());
              }
            }else
            //Added by Varun Shrivastava Product Recommendation End
            
            
                    caseFieldAPIToLabelMap.put(fieldName,fieldMap.get(fieldName).getDescribe().getLabel());  
                }    
            }
        //Added for Product Recommendation Start
        if(caseProductRecommendationMap.size() > 0){
            showProductRecommendation = true;
            disableHideSection= false;
        }
        //Added for Product Recommendation End
        hideOtherFields();
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
        caseQueryFields='';
        List<UPL_General_Case_Type__mdt> caseRequiredCustomMdtRecord = [Select ID,Required_Fields__c from UPL_General_Case_Type__mdt where Type__c = :caseOtherRecord.Type AND Sub_Query__c = :caseOtherRecord.Sub_Query__c AND QRC__c = :caseOtherRecord.QRC__c Limit 1];
        if(caseRequiredCustomMdtRecord.size() > 0){
            String requiredFields = caseRequiredCustomMdtRecord[0].Required_Fields__c;
            fieldNameList = requiredFields.split(':');
        }
        if(fieldNameList.size() > 0){
            showSection = true;
        }
        for(String  fieldName: fieldNameList){
            //Added by Varun Shrivastava Product Recommendation Start
            if(fieldName.containsIgnoreCase('Measure_') || fieldName.containsIgnoreCase('Dose_') || fieldName.containsIgnoreCase('Product_Recommended_')){
                if(caseProductRecommendationMap.size()> 0)
                    continue;
                else{
                    caseProductRecommendationMap.put('Product_Recommended_1_gc__c',fieldMap.get('Product_Recommended_1_gc__c').getDescribe().getLabel());
                    caseProductRecommendationMap.put('Dose_1_gc__c',fieldMap.get('Dose_1_gc__c').getDescribe().getLabel());
                    caseProductRecommendationMap.put('Measure_1_gc__c',fieldMap.get('Measure_1_gc__c').getDescribe().getLabel());
                    caseProductRecommendationMap.put('Product_Recommended_2_gc__c',fieldMap.get('Product_Recommended_2_gc__c').getDescribe().getLabel());
                    caseProductRecommendationMap.put('Dose_2__c',fieldMap.get('Dose_2__c').getDescribe().getLabel());
                    caseProductRecommendationMap.put('Measure_2__c',fieldMap.get('Measure_2__c').getDescribe().getLabel());
                    caseProductRecommendationMap.put('Product_Recommended_3_gc__c',fieldMap.get('Product_Recommended_3_gc__c').getDescribe().getLabel());
                    caseProductRecommendationMap.put('Dose_3__c',fieldMap.get('Dose_3__c').getDescribe().getLabel());
                    caseProductRecommendationMap.put('Measure_3__c',fieldMap.get('Measure_3__c').getDescribe().getLabel());
                    caseProductRecommendationMap.put('Product_Recommended_4__c',fieldMap.get('Product_Recommended_4__c').getDescribe().getLabel());
                    caseProductRecommendationMap.put('Dose_4__c',fieldMap.get('Dose_4__c').getDescribe().getLabel());
                    caseProductRecommendationMap.put('Measure_4__c',fieldMap.get('Measure_4__c').getDescribe().getLabel());
                    caseQueryFields = caseQueryFields + 'Product_Recommended_1_gc__c,Dose_1_gc__c,Measure_1_gc__c,Product_Recommended_2_gc__c,Dose_2__c,Measure_2__c' + ',';
                    caseQueryFields = caseQueryFields + 'Product_Recommended_3_gc__c,Dose_3__c,Measure_3__c,Product_Recommended_4__c,Dose_4__c,Measure_4__c' + ',';
                }
            }else
                //Added by Varun Shrivastava Product Recommendation End
            { 
                caseFieldAPIToLabelMap.put(fieldName,fieldMap.get(fieldName).getDescribe().getLabel());  
              caseQueryFields = caseQueryFields + fieldName + ',';
            }
        }
        caseQuery = 'Select Id,'+ caseQueryFields + 'ContactId,AccountId,'+
                'Sent_to_ZM__c,Origin__c,Reopened_Close_Date__c,Reopened_Start_Date__c,Reopened_Case__c,Status,Type,Crop_pick__c,Other_Crop_Name__c,FO_Number__c,Sub_Query__c,QRC__c,Customer_Type__c,Caller_Type__c,Caller_Name__c,Caller_Number__c,Follow_Up_Status_1__c,Follow_Up_Status_2__c,Follow_Up_Status_3__c,Follow_Up_1_Date_Time__c,Follow_Up_2_Date_Time__c,Follow_Up_3_Date_Time__c,OwnerId,RecordType.Name,Owner.Name, Priority from Case where id = :caseId limit 1';   
        //Adding Priority field in query: SCTASK0380406    
        caseRecord = Database.query(caseQuery);
          
        //Added for Product Recommendation Start
        if(caseProductRecommendationMap.size() > 0){
            showProductRecommendation = true;
            disableHideSection = false;
        }
        //Added for Product Recommendation End
    }
    
    public void hideOtherFields(){
        if(caseRecord.Type == 'Product Recommendation')
        hideCrop = true;
        else
        hideCrop = false;    
    }
    
    
  public String checkValidations(){
        String errorMessage = null;
        if(caseRecord.Type == 'Product Recommendation' && caseRecord.Product_Recommendation_Case__c  == null){
            errorMessage = 'Product Recommendation Case is required field for Product Recommendation Type.';
        }
        if(caseRecord.Origin__c == null || caseRecord.Origin__c == ''){
            errorMessage = 'Please Select Case Origin.';
        }
      
        /*if(caseRecord.QRC__c == 'Query' && caseRecord.Status != 'Closed'){
            errorMessage = 'Please Select Status as Closed for Query Case.';
        }*/
        /*if((caseRecord.QRC__c == 'Request' || caseRecord.QRC__c == 'Complaint') && caseRecord.Status != 'Escalated-L1'){
            errorMessage = 'Please Select Status as Escalated-L1 for Request and Complaint type Case.';
        }
*/
        //Added by Varun : INCTASK0431458 30 March 2021 Start
        if((caseRecord.Status != 'Escalated-L1' && caseRecord.Status != 'Escalated-L2' && caseRecord.Status != 'Closed'&& caseRecord.Status != 'Reopen')){
            errorMessage = 'Please Select Status as Closed or Escalated L1 or Escalate L2 or Reopen';
        }
        //Added by Varun : INCTASK0431458 30 March 2021 End
        if( !isCallerType && (caseRecord.Customer_Type__c == null || caseRecord.Customer_Type__c == '')){
            errorMessage = 'Please Select Customer Type.';
        }
       // Added by Kuhinoor
        if(isCallerType && String.isBlank(caseRecord.Caller_Type__c)){
            errorMessage = 'Please Select Caller Type.';
        }
        // End here
      
        if(caseRecord.QRC_Category__c == null || caseRecord.QRC_Category__c == ''){
            errorMessage = 'Please Select Category.';
        }
        if(caseRecord.QRC_sub_category__c == null || caseRecord.QRC_sub_category__c == ''){
            errorMessage = 'Please Sub Category.';
        }
        if(caseRecord.QRC_type__c == null || caseRecord.QRC_type__c == ''){
            errorMessage = 'Please Select QRC.';
        }
         return errorMessage;
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
            //Added by Varun for L2 Routing Change
            //Added by Varun : INCTASK0376033 start
            System.debug('Old staus: '+clonedCaseRecord.Status+' Updated status : '+caseRecord.Status);
            //Updated by Varun Shrivastava: INCTASK0402006 26 Feb 2021 Start
            //if(clonedCaseRecord.Status != caseRecord.Status && clonedCaseRecord.Status != 'Closed'){
            if(clonedCaseRecord.Status != caseRecord.Status && caseRecord.Status != 'Closed'){
            //Updated by Varun Shrivastava: INCTASK0402006 26 Feb 2021 End
                if(caseRecord.Status == 'Escalated-L1' || caseRecord.Status == 'Escalated-L2' || caseRecord.Status == 'Reopen'){
                    AssignmentRule AR = new AssignmentRule(); 
                    AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1]; 
                    Database.DMLOptions dmlOpts = new Database.DMLOptions();
                    dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
                    if(caseRecord.QRC__c == 'Request' || caseRecord.QRC__c == 'Complaint')
                        caseRecord.setOptions(dmlOpts);    
                }
            }
            //--------------------Added to capture Follow up Date/Time-----------------------
            if(clonedCaseRecord.Follow_Up_Status_1__c != caseRecord.Follow_Up_Status_1__c){
                caseRecord.Follow_Up_1_Date_Time__c = System.now();   
            }
            if(clonedCaseRecord.Follow_Up_Status_2__c != caseRecord.Follow_Up_Status_2__c){
                caseRecord.Follow_Up_2_Date_Time__c = System.now();   
            }
            if(clonedCaseRecord.Follow_Up_Status_3__c != caseRecord.Follow_Up_Status_3__c){
                caseRecord.Follow_Up_3_Date_Time__c = System.now();   
            }
            //----------Added to capture Reopened Case Start Date and Close Date-------------
            if(clonedCaseRecord.Status != caseRecord.Status && caseRecord.Status=='Reopen'){
                caseRecord.Reopened_Case__c = true;  
                caseRecord.Reopened_Start_Date__c = System.now();
                if(caseRecord.Reopened_Close_Date__c <=System.now()){
                 //System.assert(false,'Test');
                 caseRecord.Reopened_Close_Date__c = NULL;
                }
                    
            }
            if(clonedCaseRecord.Status != caseRecord.Status && clonedCaseRecord.Status=='Reopen')
            {
                caseRecord.Reopened_Case__c = false;  
                caseRecord.Reopened_Close_Date__c = System.now();  
            }
            //---------------------------------------------------------------------------------
            //Added by Varun : INCTASK0376033 End
            //Added by Varun for L2 Routing Change
            caseRecord.Type = caseOtherRecord.Type;
            caseRecord.Sub_Query__c = caseOtherRecord.Sub_Query__c;
            //Added by Varun Shrivastava : Report POC Start
          if(l1AgentUser)
            caseRecord.L1_Agent_Close_Time__c = System.now();
          if(l2AgentUser)
              caseRecord.L2_Agent_Close_Time__c = System.now();
          if(l0AgentUser)
              caseRecord.L0_Agent_Close_Time__c = System.now();
          //Added by Varun Shrivastava : Report POC End
            update caseRecord;
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
                PageReference pageRef = new PageReference('/apex/Case_UPL_GeneralCase_Creation?RecordId=&Mode=');
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
    
    public void showRecomSec(){
        if(caseOtherRecord.QRC_Category__c == 'Agronomy' && caseOtherRecord.QRC_type__c != null){
            showProductRecommendation = true;
            disableHideSection = false;
        }else{
            showProductRecommendation = false;
        }
    }
    
}