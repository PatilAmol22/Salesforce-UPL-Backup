/*
Name : AccountAndCaseCreationCtlr
Description : This class use to create/update account and multiple cases.
Author : Kuhinoor
Tracker ID : WIT-002
*/
public class AccountAndCaseCreationCtlr {
    public Account accountObj{get;set;}
    public String currentRecordId{get;set;}
    public case callerCase{get;set;} 
    public List<CaseWrapperCls> caseList{get;set;}
    public Integer removeIndex{get;set;}
    public user userObj{get;set;}
    public Boolean showHeader{get;set;}
    Public Map<String, RecordType> recordTypeMap = new Map<String, RecordType>();
    Public String selectedRecTypeId{get;set;}
    Public String selectedDepartMent{get;set;}
    Public Integer caseindex{get;set;}
    Public Boolean isPersonAccount{get;set;}
    Public String lnameStr{get;set;}
    Public String fnameStr{get;set;}
    Public List<SelectOption> options{get;set;}
    public String fnameErr{get;set;}
    public String lnameErr{get;set;}
    public Boolean isCalrAcc{get;set;}
    Public String selCaseRecTypeId{get;set;}
    Public Integer caseIndx{get;set;}
    public String recordTypeName{get;set;}
    Public String caseRecordTypeID;
    public boolean isRegister{get;set;}
    Public String catVar{get;set;}
    Public String depVar{get;set;}
    Public String subCatVar{get;set;}

       //Constructor
    public AccountAndCaseCreationCtlr(){
        catVar='none';
        depVar='none';
        subCatVar='none';
        caseindex=1;
        isCalrAcc = true;
        fnameErr = 'none';
        lnameErr = 'none';
        showHeader = false;
        isRegister = true;
        caseList = new List<CaseWrapperCls>();
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        caseRecordTypeID = ApexPages.currentPage().getParameters().get('RecordTypeId');
        String accountId = ApexPages.currentPage().getParameters().get('accountId');
        if(String.isNotBlank(caseRecordTypeID)){
            recordTypeName = Schema.SObjectType.case.getRecordTypeInfosById().get(caseRecordTypeID).getName();    
        }
        if(String.isNotBlank(accountId)){
             accountObj = [SELECT Id, Name, PersonMobilePhone,LastName,FirstName, isPersonAccount,Using_Smart_Phone__c,
                   PIN__c,StateName__c,District__c,Tehsil__c,VillageName__c,SMS_Voice_Consent__c,Acre__c,RecordTypeId,
                   Primary_Crop__c,Preferred_Language__pc,Using_Watsapp__c,Village__c,Village__pc,Mobile__c,Capacity__c,
                   Other_Capacity__c,Distributor_Name__c        
                   FROM account WHERE Id =: accountId ];
            isPersonAccount = accountObj.isPersonAccount;
            lnameStr = accountObj.LastName;
            fnameStr = accountObj.FirstName;
            selectedRecTypeId = accountObj.RecordTypeId;
        }else{
            recordTypes();
            accountObj = new Account();
        }
        
        userObj = [SELECT Id, Name, UGDN_Number__c FROM user WHERE Id=: UserInfo.getUserId() ];
       
        callerCase = new case();
        callerCase.RecordTypeId = caseRecordTypeID; 
        callerCase.OwnerId = userObj.Id;
        callerCase.L0_Agent_Start_Time__c = system.now();
       caseList.add(new CaseWrapperCls(callerCase, false,false));
    }
    
    /*
     Name: addRow
     Description : Add new case in list
    */
    public void addRow(){
        caseindex=caseindex+1;
        caseList.add(new CaseWrapperCls(new case(RecordTypeId = caseRecordTypeID,L0_Agent_Start_Time__c= system.now(),
                                                Caller_Type__c = callerCase.Caller_Type__c, Origin__c = callerCase.Origin__c,
                                                Caller_Name__c = callerCase.Caller_Name__c, Caller_Number__c = callerCase.Caller_Number__c
                                                ), false, false));
    }
    
    /*
     Name: removeRow
     Description : this method use to remove rows for case List
    */
    public void removeRow(){
                caseindex=caseindex-1;
        caseList.remove(removeIndex);
    }
    
    /*
     Name: saveCases
     Description : This method use to save the records
    */
    public PageReference saveCases(){
        Savepoint sp = Database.setSavepoint();
        List<case> caseListInsert = new List<case>();
         String errormsg = checkValidations();
        if(errormsg != null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, errormsg));
            return null;
        }
        try{
            if(isPersonAccount){
                accountObj.LastName = lnameStr;
                accountObj.FirstName = fnameStr;
            }
            if(!isRegister){
                //if(accountObj.Name != null){
                    //accountObj.Name = 'Unknoown';
                //}
            }
            accountObj.RecordTypeId = selectedRecTypeId;
            upsert accountObj;
            
            String accId = accountObj.Id;
            
            AssignmentRule AR = new AssignmentRule();
            AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
            
            for(CaseWrapperCls cs : caseList){
                cs.cse.accountId = accId;
                cs.cse.Subject = cs.cse.Reason_for_calling__c;
                cs.cse.L0_Agent_Close_Time__c = system.now();
                if(cs.cse.status != 'Closed'){
                   cs.cse.setOptions(dmlOpts); 
                }  
                caseListInsert.add(cs.cse);
                System.debug('added by guduli'+cs.cse);
            }
            
            if(caseListInsert.size() > 0){
                insert caseListInsert;                
            }
        }catch(Exception ex){
            system.debug(ex);
            Database.rollback(sp);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, ex.getMessage()));
            return null;
        }
        //system.debug('caseList-->>'+caseList);
        return new PageReference('/'+accountObj.Id);
    }
    
    /*
     Name: checkValidations
     Description : this method use to validate account and case records
    */
    public String checkValidations(){
        String errorMessage = null;
        Integer i = 1;
        if(isPersonAccount && String.isBlank(lnameStr)){
            lnameErr = 'block';
            errorMessage = 'Last name is required.';
            return errorMessage;
        }
        if(isPersonAccount && String.isBlank(fnameStr)){
            fnameErr = 'block';
            errorMessage = 'First name is required.';
            return errorMessage;
        }
        if(String.isBlank(selectedRecTypeId) || selectedRecTypeId =='None'){
            errorMessage = 'Select account record type';
            return errorMessage;
        }
        system.debug('caseList-->'+caseList);
        for(CaseWrapperCls cs : caseList ){
            case caseRecord = cs.cse;
            if((caseRecord.Status != 'Escalated-L1' && caseRecord.Status != 'Closed')){
                errorMessage = 'Case'+i+' - Please Select Status as Closed or Escalated L1';
                break;
            }
           // System.debug('@@@@@@'+(caseRecord.Order_number__c).substring(6,7));
            if(caseRecord.Order_number__c!=null){
             if(((Integer.valueOf((String.valueOf(caseRecord.Order_number__c)).length()))!=16) && caseRecord.QRC_Category__c=='Order Related'){
                 errorMessage = 'Case'+i+' - Please enter 16 digit Order Number';
                break;
             } 
                if(((caseRecord.Order_number__c).substring(6,7)!='-') && caseRecord.QRC_Category__c=='Order Related')
             {
                 errorMessage = 'Case'+i+' - Please enter correct format of Order Number(XXXXXX-XXXXXXXXX)';
                break;
             }}   
            if( String.isBlank(caseRecord.Reason_for_calling__c)){
                errorMessage = 'Case'+i+' - Please select reason for calling.';
                break;
            }
            if( String.isBlank(caseRecord.QRC_type__c)){
                errorMessage = 'Case'+i+' - Please Select QRC.';
                break;
            }
            if( caseRecord.QRC_type__c == 'Query' && caseRecord.Status != 'Closed'){
                errorMessage = 'Case'+i+' - Please Select Status as Closed for Query Case.';
                break;
            }
            i++;
        }
        return errorMessage;
    }
    
    /*
     Name: toggleCallerField
     Description : toggle caller name and number section
    */
    public void toggleCallerField(){ 
        if(callerCase.Caller_Type__c == 'Account Holder'){ 
            isCalrAcc = false;
        }else{
            isCalrAcc =  true;  
        }
    }
    
    /*
     Name: recordTypes
     Description : Method display available record types for account creation
    */
     public void recordTypes(){
            options = new List<SelectOption>();
            List<RecordType> recordTypeList =[SELECT Id, Name, DeveloperName,isPersontype, SobjectType 
                                              FROM RecordType 
                                              where SobjectType ='Account' AND 
                                              DeveloperName IN ('AKC_Retailer','PreRegistered_Farmer','F3_C3_Sales_Team','UnRegistered_Farmer_Retailer')];
            options.add(new SelectOption('', 'None'));
            for(RecordType rt : recordTypeList){
                recordTypeMap.put(rt.Id, rt);
                options.add(new SelectOption(rt.Id, rt.Name));
            }
        }
    
    /*
     Name: chnageRecordType
     Description : Method for change account record type
    */
    public void chnageRecordType(){
        system.debug('selectedRecTypeId-->>'+selectedRecTypeId);
        isPersonAccount = recordTypeMap.get(selectedRecTypeId).isPersontype;
        if(recordTypeMap.get(selectedRecTypeId).DeveloperName == 'UnRegistered_Farmer_Retailer'){
            isRegister = false;
        }else{
            isRegister = true;
        }
        system.debug('isPersonAccount-->>'+isPersonAccount);
        accountObj = new Account();
        
        
    }   
    
   /*
     Name: showProdSec
     Description : this menthod show recomendation products list
    */
    public void showProdSec(){
       
        case cs = caseList[caseIndx-1].cse;
        if(cs.QRC_Category__c == 'Agronomy' && cs.QRC_type__c != null){
            caseList[caseIndx-1].showProductRecomDisplay = true;
        }else{
            caseList[caseIndx-1].showProductRecomDisplay = false;
        }
        
          }
     public void showComSec(){
         //caseIndx
         case cs = caseList[caseIndx-1].cse;
         system.debug(cs);
         cs.Department__c='Outbound (Connected)';
         cs.Reference_Variable__c=true;
         cs.Reference_Variable2__c=false;
         cs.Order_number__c=null;
              //section1 = true;
              //section2 = false;         
         system.debug('catVar'+ cs.Reference_Variable__c);
          }
     public void hideComSec(){
         case cs = caseList[caseIndx-1].cse;
         cs.Reference_Variable__c=false;
         cs.Reference_Variable2__c=false;
         cs.Department__c=depVar;
         cs.QRC_Category__c='none';
         cs.Order_number__c=null;
         //system.debug('catVar');
          }
     public void showCatSec(){
         case cs = caseList[caseIndx-1].cse;
         cs.QRC_Category__c=catVar;
          cs.QRC_sub_category__c='none';
        // system.debug('catVar');
          }
    public void showCatSubSec(){
         case cs = caseList[caseIndx-1].cse;
         cs.Reference_Variable2__c=true;
         cs.Reference_Variable__c=false;
         cs.QRC_sub_category__c	=subCatVar;
        // system.debug('catVar');
          }
    public void hideCatSec(){
        case cs = caseList[caseIndx-1].cse;
         cs.Reference_Variable2__c=false;
         cs.Reference_Variable__c=false;
         cs.QRC_Category__c=catVar; 
        cs.Order_number__c=null;
         cs.QRC_sub_category__c='none';
         //system.debug('catVar');
          }
     public void hideSubCatSec(){
        case cs = caseList[caseIndx-1].cse;
         cs.Reference_Variable2__c=false;
         cs.Reference_Variable__c=false;
          cs.Department__c=depVar;
         system.debug('catVar@@@'+catVar);
         system.debug('subCatVar@@@'+subCatVar);
          cs.QRC_Category__c=catVar; 
          cs.QRC_sub_category__c=subCatVar; 
          cs.Order_number__c=null;
         //system.debug('catVar');
          }
    /*
     Name: showProductRecom
     Description : this method used in action funtion to hide/show product section
    */
    public void showProductRecom(){
        //caseList[0].showProductRecom = true;
    }
    
     /*
     Name: cancel
     Description : this method redirect to account page
    */
    public PageReference cancel(){
        return new PageReference('/001/o');
    }
    
    /*
     Name: CaseWrapperCls
     Description :  this is wrapper class
    */
    public class CaseWrapperCls{
        public case cse{get;set;}
        public boolean showProductRecom{get;set;}
        public boolean showProductRecomDisplay{get;set;}
        public CaseWrapperCls(case cse, boolean showProductRecom, boolean showProductRecomDisplay){
            this.cse = cse;
            this.showProductRecom = showProductRecom;
            this.showProductRecomDisplay = showProductRecomDisplay;
        }    
    }
    
    }