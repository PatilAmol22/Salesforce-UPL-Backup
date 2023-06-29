/**
* Trigger handler Name: ColombiaCaseHandler
* Author: EY
* CR: APPS-2074
* CreatedDate: 
* ModifiedDate: 28-Oct-2022 02:10 AM IST 
				02-Nov-2022 19:01 AM IST 
* Description: This is handler class for ColombiaCasetrigger
* */

public without sharing class ColombiaCaseHandler {
    

    public static final String ESCALATED = System.Label.Colombia_Case_Escalated;//Escalated status
    
    public static final String INVOICE_ENG ='Invoice';
    public static final String CREDITLIMIT_ENG ='Credit Limit'; 
    public static final String DISPATCH_ENG = 'Dispatch';//'Despachos';
    public static final String PAYMENTSANDRECEIPTS_ENG ='Payments & Receipts'; 
    public static final String PRODUCTAVAILABILITY_ENG ='Product Availability';
    public static final String PRODUCTCOMPLAINTSBYFARMERS_ENG ='Product Complaints by Farmers'; 
    public static final String ORDERUPDATE_ENG = 'Order Update';
    public static final String ORDERCANCELLATION_ENG = 'Order Cancellation';
    public static final String OTHER_ENG = 'Other';
    public static final String SHIPPINGADDRESS_ENG ='Shipping Address';//'Dirección de Envío - Actualización información del cliente';
    public static final String OUTSTANDING_ENG ='Outstanding';
    public static final String PRODUCTLEAKAGE_ENG ='Product Leakage';
    public static final String ProductRelated_ENG ='Product Related';
    
    public static Map<String,String> assigneeTitleMapUpdate = new Map<String,String>();
    public static Map<String,String> assigneeCreatorMap = null;
   //Added by Nandhini 
   public Static Id iberiaRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Iberia_Community_Cases').getRecordTypeId();
 //Added by N
    public Static Id GermanyRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Germany_record_Type').getRecordTypeId();
    
    
    public static Map<String,User> getUserDetails() {
        
        List<User> colombiaUserList = null;
        Map<String,String> assigneeCreatorMap = getColombiaAssigneeCaseDetails();
        system.debug('assigneeTitleMap>>>>>>>>>>>>>>>'+assigneeCreatorMap);
        try{
            colombiaUserList = [select id,email,name,title,isActive,username from User where username IN :assigneeCreatorMap.keySet() and IsActive =: true];
            system.debug('Assign User List-->'+colombiaUserList);
        }catch(Exception ex){
            System.debug('Exception Message-->'+ex.getMessage());
        }
        
        Map<String,User> userMap = new Map<String,User>();
        if(null != colombiaUserList && !colombiaUserList.isEmpty()
            && null != mcolombiaCaseDetailsMap && !mcolombiaCaseDetailsMap.isEmpty()){
            for(User colUserObj : colombiaUserList){
             
                if(colUserObj.Username == System.Label.ColombiaMariaMu_ozUr){ // In custom label added username
                   
                        userMap.put(INVOICE_ENG,colUserObj);
                    
                }else if(colUserObj.Username == system.Label.colombia_Mairon_Lancheros_user){ // user record not available in uat.  rColombia_Mairon_Lancheros_Ur
                   
                        userMap.put(CREDITLIMIT_ENG,colUserObj); 
                        userMap.put(OUTSTANDING_ENG,colUserObj);
                    
                }else if(colUserObj.Username == System.Label.Colombia_Myriam_Ocampo_ur){ // In custom label added username
                    
                        userMap.put(DISPATCH_ENG,colUserObj);
                    
                }else if(colUserObj.Username == System.Label.Colombia_Oscar_Artunduaga_Ur){  // In custom label added username
                   
                        userMap.put(PAYMENTSANDRECEIPTS_ENG,colUserObj);
                    
                }else if(colUserObj.Username == System.Label.colombia_Yeny_Bastidas_ur){  // In custom label added username
                    
                        userMap.put(PRODUCTAVAILABILITY_ENG,colUserObj);
                }else if(colUserObj.Username == System.Label.Colombia_Carol_Olmos_Ur){  // In custom label added username   //20034778@upl-ltd.com	
                   
                        userMap.put(PRODUCTCOMPLAINTSBYFARMERS_ENG,colUserObj);
                   
                    userMap.put(PRODUCTLEAKAGE_ENG,colUserObj);
                    userMap.put(ProductRelated_ENG,colUserObj);
                }else if(colUserObj.Username == System.Label.Colombia_Luisana_Campana_Ur){ // In custom label added username
                    
                        userMap.put(ORDERCANCELLATION_ENG,colUserObj);
                        userMap.put(ORDERUPDATE_ENG,colUserObj);
                        userMap.put(SHIPPINGADDRESS_ENG,colUserObj);
                    
                }else if(colUserObj.Username == System.Label.Colombia_Alex_Alzate_Ur){ // In custom label added username
                        userMap.put(OTHER_ENG,colUserObj);  
                }
                system.debug('Debug Users For---->'+colUserObj);
            }//end loop
        }        
        return userMap;
    }
    
/*
    * Description: Retrieve all Colombia_Case_module__mdt details exist in Colombia_Case_module__mdt custom metadata Types
	* Param: NA
	* return : mcolombiaCaseDetailsMap
    * */

  public static Map<String, String> mAssigneeDetailsMap;
  public static Map<String,Colombia_Case_module__mdt> mcolombiaCaseDetailsMap;
  public static Map<String, String> getColombiaAssigneeCaseDetails(){
      if(mcolombiaCaseDetailsMap == null || mAssigneeDetailsMap == null){
          mcolombiaCaseDetailsMap = new Map<String, Colombia_Case_module__mdt>();
          mAssigneeDetailsMap = new Map<String, String>();
          List<Colombia_Case_module__mdt> colombiaCaseDetailsList = [select id,Label,Running_User__c,Assign__c,Assign_User__c,Creator_Profile__c,
                                                          Escalate__c,Escalation_User__c,Assignee_Username__c,Escalate_User_Name__c from Colombia_Case_module__mdt];
          for(Colombia_Case_module__mdt colombiaCaseDetail : colombiaCaseDetailsList){
             mcolombiaCaseDetailsMap.put(colombiaCaseDetail.Label, colombiaCaseDetail); 
          }
          
          if(null != mcolombiaCaseDetailsMap && !mcolombiaCaseDetailsMap.isEmpty()){
              for(Colombia_Case_module__mdt csmtd : mcolombiaCaseDetailsMap.values()){
                  mAssigneeDetailsMap.put(csmtd.Assignee_Username__c, csmtd.Assign__c);
              }  
          }
      }
	return mAssigneeDetailsMap;
  }
    
    
    public static void caseShareColombia(List<case>newcaselist,Map<id,case>oldCaseMap,Boolean isinsert,Boolean isupdate)
    {
        Map<id,id> mapofCaeIdAndUser=new Map<id,id>();
        Map<id,id> mapofCaeIdAndEscalationUser=new Map<id,id>();
        Map<id,id> oldSetofCaesShared=new Map<id,id>();
        Map<id,id> oldSetofEscalateCaesShared=new Map<id,id>();
        set<id> setofColombiaUser=new set<id>();
        set<id> setofescalationUser=new set<id>();
        List<caseshare> recordsToBeDeleted=new List<caseshare>();
        List<CaseShare> newSetOFCases=new List<CaseShare>();
        if(isinsert)
        {
            for(case ca:newcaselist)
            {
                if(!mapofCaeIdAndUser.containskey(ca.id)&&ca.Colombia_User__c!=null)
                {
                    mapofCaeIdAndUser.put(ca.id,ca.Colombia_User__c);
                }
                
            }
            
            for(id Caseids:mapofCaeIdAndUser.keyset())
            {
                CaseShare cs=new CaseShare();
                cs.CaseId=Caseids;
                cs.UserOrGroupId=mapofCaeIdAndUser.get(Caseids);
                cs.CaseAccessLevel='Edit';
                cs.RowCause='Manual';
                newSetOFCases.add(cs);
            }
            if(newSetOFCases.size()>0)
            {
               insert newSetOFCases;  
            }
           
            system.debug('casesharelist' +newSetOFCases);
        }
        if(isupdate)
        {
            for(case ca:newcaselist)
            {
                case oldcase=oldCaseMap.get(ca.id);
                if(ca.Colombia_User__c!=oldcase.Colombia_User__c)
                {
                    if(!mapofCaeIdAndUser.containskey(ca.id)&&ca.Colombia_User__c!=null)
                    {
                        mapofCaeIdAndUser.put(ca.id,ca.Colombia_User__c);
                    } 
                    if(!oldSetofCaesShared.containskey(oldcase.Colombia_User__c)&&oldcase.Colombia_User__c!=null)
                    {
                        oldSetofCaesShared.put(ca.id,oldcase.Colombia_User__c);
                    }
                    
                }
            }
            
           
            for(case ca:newcaselist)
            {
                case oldcase=oldCaseMap.get(ca.id);
                if(ca.EscalationUser__c!=oldcase.EscalationUser__c)
                {
                    if(!mapofCaeIdAndEscalationUser.containskey(ca.id)&&ca.EscalationUser__c!=null)
                    {
                        mapofCaeIdAndEscalationUser.put(ca.id,ca.EscalationUser__c);
                    } 
                     if(!oldSetofEscalateCaesShared.containskey(oldcase.Colombia_User__c)&&oldcase.EscalationUser__c!=null)
                    {
                        oldSetofEscalateCaesShared.put(ca.id,oldcase.EscalationUser__c);
                    }
                    
                }
            }
            if(mapofCaeIdAndUser.keyset()!=null)
            {
            for(id Caseids:mapofCaeIdAndUser.keyset())
            {
                CaseShare cs=new CaseShare();
                cs.CaseId=Caseids;
                cs.UserOrGroupId=mapofCaeIdAndUser.get(Caseids);
                cs.CaseAccessLevel='Edit';
                cs.RowCause='Manual';
                newSetOFCases.add(cs);
            }
            }
            if(mapofCaeIdAndEscalationUser.keyset()!=null)
            {
            for(id Caseids:mapofCaeIdAndEscalationUser.keyset())
            {
                CaseShare cs=new CaseShare();
                cs.CaseId=Caseids;
                cs.UserOrGroupId=mapofCaeIdAndEscalationUser.get(Caseids);
                cs.CaseAccessLevel='Edit';
                cs.RowCause='Manual';
                newSetOFCases.add(cs);
            }
            }
            if(newSetOFCases.size()>0)
            {
              insert newSetOFCases;  
            }
            
            
            //this is to revoke
            if(oldSetofCaesShared.values()!=null) {
            setofColombiaUser.addAll(oldSetofCaesShared.values()); 
              }
            if(oldSetofEscalateCaesShared.values()!=null)
            {
             setofescalationUser.addAll(oldSetofEscalateCaesShared.values());
            }
            if(oldSetofCaesShared.keyset()!=null &&setofColombiaUser!=null)
            {           
            for(caseshare cso:[select id,CaseId,UserOrGroupId from caseShare where CaseId IN:oldSetofCaesShared.keyset() and UserOrGroupId IN:setofColombiaUser limit 49999])
            {
                if(oldSetofCaesShared.containskey(cso.CaseId)&&oldSetofCaesShared.get(cso.CaseId)==cso.UserOrGroupId)
                {
                   recordsToBeDeleted.add(cso); 
                }
            }
              
            }
            
            if(oldSetofEscalateCaesShared.keyset()!=null &&setofescalationUser!=null)
            {
               for(caseshare cso:[select id,CaseId,UserOrGroupId from caseShare where CaseId IN:oldSetofEscalateCaesShared.keyset() and UserOrGroupId IN:setofescalationUser limit 49999])
            {
                if(oldSetofEscalateCaesShared.containskey(cso.CaseId)&&oldSetofEscalateCaesShared.get(cso.CaseId)==cso.UserOrGroupId)
                {
                   recordsToBeDeleted.add(cso); 
                }
            } 
            }
            if(recordsToBeDeleted.size()>0)
            {
                delete recordsToBeDeleted;
            }
        }
        
    }
   /*
    * Added by :Nandhini
    * Description: Case should be Open when a new case is getting created :APPS-5135
	* Param: New case List.
	* return : void
    * */
     public static void validationOnCreateCase(List<case> newcaselist){
        String errorMessage = System.Label.spain_case_created_with_Open_status;
        for(Case caseRec:newcaselist){
            if(caseRec.RecordtypeId == iberiaRecordTypeId){
                if(caseRec.Status!='Open'){
                    caseRec.addError(errorMessage);
                }
            }
        }
    }
    /*
    * Added by :Nandhini
    * Description: Validation for Spain case Management CR :APPS-5135
	* Param: New case List,Old case Map,Running user profile.
	* return : void
    * */

    public static void validationOnClosingTheCase(List<case>newcaselist,Map<id,case>oldCaseMap,String runningUserprofileName){
        
        String errorMessage = System.Label.Spain_Case_Close_Error_Message;
        String caseReopenErrorMessage = System.Label.Spain_CaseReopen_Message;
        String caseReopenMessage = System.Label.spain_Case_reopen;
        String statusCannotBeChanged = System.Label.spain_and_portugal_status_should_not_be_changed;
        for(Case caseRec:newcaselist){
            if(caseRec.RecordtypeId == iberiaRecordTypeId){
                system.debug('new case status :'+caseRec.Status);
                system.debug('old case status :'+oldCaseMap.get(caseRec.Id).Status); 
                if(caseRec.Status != oldCaseMap.get(caseRec.Id).Status && caseRec.Status=='Closed'){
                    if(UserInfo.getUserId() != caseRec.ownerid && caseRec.User_Assigned__c != UserInfo.getUserId() && caseRec.EscalationUser__c != UserInfo.getUserId()){
                        caseRec.addError(errorMessage);
                    }
                }
                if(caseRec.Reopened_Count__c > 1 && caseRec.Status=='Open' && caseRec.Status != oldCaseMap.get(caseRec.Id).Status &&(oldCaseMap.get(caseRec.Id).Status == 'Closed' || oldCaseMap.get(caseRec.Id).Status == 'Escalated') ){
                    caseRec.addError(caseReopenErrorMessage);
                }
                if(caseRec.Status=='Open' && oldCaseMap.get(caseRec.Id).Status != 'Closed'&& caseRec.Status != oldCaseMap.get(caseRec.Id).Status ){
                    caseRec.addError(caseReopenMessage);
                }
                if((caseRec.Status=='Closed' || caseRec.Status=='Escalated')&& caseRec.Status != oldCaseMap.get(caseRec.Id).Status && runningUserprofileName.equalsIgnoreCase('Customer Partner Community Plus User - Iberia')){
                    caseRec.addError(statusCannotBeChanged);
                }
            }
        }
    } 
     /*
    * Added by :Nandhini
    * Description: This will update the Reopened count field whenever case status is changed from Closed to Open  :APPS-5135
	* Param: New case List,Old case Map,whether it is invoked from Insert or Update.
	* return : void
    * */

    public static void ReopenedCount(List<case> newcaselist,Map<id,case> oldCaseMap,Boolean isinsert,Boolean isupdate){
        if(isUpdate){
            for(Case caseRec:newcaselist){
                if(caseRec.RecordtypeId == iberiaRecordTypeId){
                    system.debug('case status :'+caseRec.Status);
                    system.debug('case Old status :'+oldCaseMap.get(caseRec.Id).Status);
                    if(caseRec.Status != oldCaseMap.get(caseRec.Id).Status && caseRec.Status =='Open' && oldCaseMap.get(caseRec.Id).Status =='Closed'){
                        Decimal reopenCount =oldCaseMap.get(caseRec.Id).Reopened_Count__c;
                        if(reopenCount != null){
                            caseRec.Reopened_Count__c =reopenCount + 1; 
                        }
                        else{
                            caseRec.Reopened_Count__c =1;
                        }
                    }
                }
            }
        }
    }
     /*
    * Added by :Nandhini
    * Description: If a case is reopened for 2nd time,case will be escalated automatically  :APPS-5135
	* Param: New case List,Old case Map
	* return : void
    * */
   
    public static void EscalateSpainAndPortugalCase(List<case> newcaselist,Map<id,case> oldCaseMap){
        List<Colombia_Case_Module__mdt> caseEscalationMetadataDetails = [select id,Running_User__c,Assign__c,Assign_User__c,Creator_Profile__c,Case_Type__c,Label,
                                                                         Escalate__c,Escalation_User__c,Assignee_Username__c,Escalate_User_Name__c,Sales_Org_Code_Country__c from Colombia_Case_module__mdt where Sales_Org_Code_Country__c='Iberia'];
        Set<String> escalateUserSet = new Set<String>();
        if(caseEscalationMetadataDetails != null && !caseEscalationMetadataDetails.isEmpty()){
            for(Colombia_Case_module__mdt csmtd : caseEscalationMetadataDetails){
                escalateUserSet.add(csmtd.Escalate_User_Name__c);
            }
        }
        
        
        Map<String,Id> escalateUserMapIberia = new Map<String,Id>();
        Map<String,String> escalateIberia = new Map<String,String>();
        
        Map<String,Id> userMap = new Map<String,Id>();
        
        if(escalateUserSet !=null && !escalateUserSet.isEmpty()){
            List<User> ecalationUserList = [select id,email,name,username,title,isActive from User where username IN: escalateUserSet and IsActive =: true];
            for(User us:ecalationUserList){
                userMap.put(us.username,us.Id);
                
            } 
        }
        if(caseEscalationMetadataDetails != null && !caseEscalationMetadataDetails.isEmpty()){
            for(Colombia_Case_module__mdt csmtd : caseEscalationMetadataDetails){
                
                if(csmtd.Sales_Org_Code_Country__c =='Iberia'){
                    if(userMap.containsKey(csmtd.Escalate_User_Name__c)){
                        Id escalationUserId =userMap.get(csmtd.Escalate_User_Name__c);
                        escalateUserMapIberia.put(csmtd.Case_Type__c,escalationUserId);
                        escalateIberia.put(csmtd.Case_Type__c,csmtd.Escalate__c);
                    } 
                }
                
            }
        }
        for(Case caseRec:newcaselist){
            if(caseRec.RecordtypeId == iberiaRecordTypeId){
                if(caseRec.Status != oldCaseMap.get(caseRec.Id).Status && caseRec.Status =='Open' && oldCaseMap.get(caseRec.Id).Status =='Closed' && oldCaseMap.get(caseRec.Id).Reopened_Count__c >= 1){
                    Decimal reopenCount =caseRec.Reopened_Count__c;
                    if(reopenCount != null){
                        caseRec.Reopened_Count__c =reopenCount + 1; 
                    }
                    if(caseRec.Sales_Org_Code__C == 'Iberia'){
                        if(escalateIberia.containsKey(caseRec.Type)){
                            caseRec.Escalate__c = escalateIberia.get(caseRec.Type);
                        }
                        
                        if(escalateUserMapIberia.containskey(caseRec.Type)){
                            caseRec.EscalationUser__c = escalateUserMapIberia.get(caseRec.Type); 
                            caseRec.Status='Escalated';
                        }
                    }
                }
            }
        }
        
    }
     /*
    * Added by :Nandhini
    * Description: Whenever a casde is created or type is updated,Assign and User assgned fields will be updated  :APPS-5135
	* Param: New case List,Old case Map,whether it is invoked from Insert or Update.
	* return : void
    * */

    public static void spainCaseAssignment(List<case>newcaselist,Map<id,case>oldCaseMap,Boolean isinsert,Boolean isupdate){
        
        List<Colombia_Case_Module__mdt> customMetadataDetails = [select id,Running_User__c,Assign__c,Assign_User__c,Creator_Profile__c,Case_Type__c,Label,
                                                                 Escalate__c,Escalation_User__c,Assignee_Username__c,Escalate_User_Name__c,Sales_Org_Code_Country__c from Colombia_Case_module__mdt where Sales_Org_Code_Country__c ='Iberia'];
        Set<String> assignedUsedSet = new Set<String>();
        Map<String,Id> assignedUserMapIberia = new Map<String,Id>();
        Map<String,String> assigneMapIberia = new Map<String,String>();
        
        if(customMetadataDetails != null && !customMetadataDetails.isEmpty()){
            for(Colombia_Case_module__mdt cusMetaInfo : customMetadataDetails){
                assignedUsedSet.add(cusMetaInfo.Assignee_Username__c);
            }
        }
        Map<String,Id> userMap = new Map<String,Id>();
        if(assignedUsedSet !=null && !assignedUsedSet.isEmpty()){
            List<User> assignedUserList = [select id,email,name,username,title,isActive from User where username IN: assignedUsedSet and IsActive =: true];
            for(User us:assignedUserList){
                userMap.put(us.username,us.Id); 
            } 
        }
        if(customMetadataDetails != null && !customMetadataDetails.isEmpty()){
            for(Colombia_Case_module__mdt csmtd : customMetadataDetails){
                
                if(csmtd.Sales_Org_Code_Country__c =='Iberia'){
                    if(userMap.containsKey(csmtd.Assignee_Username__c)){
                        Id assigneUserId =userMap.get(csmtd.Assignee_Username__c);
                        assignedUserMapIberia.put(csmtd.Case_Type__c,assigneUserId);
                        assigneMapIberia.put(csmtd.Case_Type__c,csmtd.Assign__c);
                    } 
                }
            }
        }
        
        if(isinsert){
            for(Case caseRec:newcaselist){
                if(caseRec.RecordtypeId == iberiaRecordTypeId){
                    if(caseRec.Sales_Org_Code__C == 'Iberia'){
                        if(assigneMapIberia.containskey(caseRec.Type)){
                            caseRec.Assignee__c =assigneMapIberia.get(caseRec.Type); 
                        }
                        
                        if(assignedUserMapIberia.containskey(caseRec.Type)){
                            caseRec.User_Assigned__c = assignedUserMapIberia.get(caseRec.Type); 
                        }
                    }
                }
            }  
        }
        if(isUpdate){
            for(Case caseRec:newcaselist){
                if(caseRec.RecordtypeId == iberiaRecordTypeId){
                    if(caseRec.Type != oldCaseMap.get(caseRec.Id).Type){
                        if(caseRec.Sales_Org_Code__C == 'Iberia'){
                            if(assigneMapIberia.containskey(caseRec.Type)){
                                caseRec.Assignee__c =assigneMapIberia.get(caseRec.Type); 
                            }
                            
                            if(assignedUserMapIberia.containskey(caseRec.Type)){
                                caseRec.User_Assigned__c = assignedUserMapIberia.get(caseRec.Type); 
                            }
                        }
                    }
                }
            }
        }
    }
    
     public static void GermanyCaseAssignment(List<case>newcaselist,Map<id,case>oldCaseMap,Boolean isinsert,Boolean isupdate){
        
        List<Colombia_Case_Module__mdt> customMetadataDetails = [select id,Running_User__c,Assign__c,Assign_User__c,Creator_Profile__c,Case_Type__c,Label,
                                                                 Escalate__c,Escalation_User__c,Assignee_Username__c,Escalate_User_Name__c,Sales_Org_Code_Country__c from Colombia_Case_module__mdt where Sales_Org_Code_Country__c ='Germany'];
        system.debug('customMetadataDetails-->'+customMetadataDetails);
         system.debug('customMetadataDetails size-->'+customMetadataDetails.size());
        Set<String> assignedUsedSet = new Set<String>();
        Map<String,Id> assignedUserMapGermany = new Map<String,Id>();
        Map<String,String> assigneMapGermany = new Map<String,String>();
        
        if(customMetadataDetails != null && !customMetadataDetails.isEmpty()){
            for(Colombia_Case_module__mdt cusMetaInfo : customMetadataDetails){
                assignedUsedSet.add(cusMetaInfo.Assignee_Username__c);
            }
        }
        system.debug('assignedUsedSet-->'+assignedUsedSet);
        Map<String,Id> userMap = new Map<String,Id>();
        if(assignedUsedSet !=null && !assignedUsedSet.isEmpty()){
            List<User> assignedUserList = [select id,email,name,username,title,isActive from User where username IN: assignedUsedSet and IsActive =: true];
            for(User us:assignedUserList){
                userMap.put(us.username,us.Id); 
            } 
        }
         system.debug('userMap-->'+userMap);
        if(customMetadataDetails != null && !customMetadataDetails.isEmpty()){
            for(Colombia_Case_module__mdt csmtd : customMetadataDetails){
                system.debug('csmtd-->'+csmtd);
                if(csmtd.Sales_Org_Code_Country__c =='Germany'){
                    system.debug('csmtd.Assignee_Username__c-->'+csmtd.Assignee_Username__c);
                    if(userMap.containsKey(csmtd.Assignee_Username__c)){
                        Id assigneUserId =userMap.get(csmtd.Assignee_Username__c);
                        assignedUserMapGermany.put(csmtd.Case_Type__c,assigneUserId);
                        assigneMapGermany.put(csmtd.Case_Type__c,csmtd.Assign__c);
                    } 
                }
            }
        }
        system.debug('assignedUserMapGermany-->'+assignedUserMapGermany);
         system.debug('assigneMapGermany-->'+assigneMapGermany);
        if(isinsert){
            for(Case caseRec:newcaselist){
                if(caseRec.RecordtypeId == GermanyRecordTypeId){
                    if(caseRec.Sales_Org_Code__C == 'Germany'){
                        system.debug('assigneMapGermany.get(caseRec.Type)-->'+assigneMapGermany.get(caseRec.Type));
                        system.debug('case type-->'+caseRec.Type);
                        if(assigneMapGermany.containskey(caseRec.Type)){
                            caseRec.Assignee__c =assigneMapGermany.get(caseRec.Type); 
                        }
                         system.debug('caseRec.Assignee__c####'+caseRec.Assignee__c);
                            
                        if(assignedUserMapGermany.containskey(caseRec.Type)){
                            caseRec.User_Assigned__c = assignedUserMapGermany.get(caseRec.Type); 
                        }
                         system.debug('caseRec.User_Assigned__c####'+caseRec.User_Assigned__c);
                    }
                }
            }  
        }
        if(isUpdate){
            for(Case caseRec:newcaselist){
                if(caseRec.RecordtypeId == GermanyRecordTypeId){
                    if(caseRec.Type != oldCaseMap.get(caseRec.Id).Type){
                        if(caseRec.Sales_Org_Code__C == 'Germany'){
                            if(assigneMapGermany.containskey(caseRec.Type)){
                                caseRec.Assignee__c =assigneMapGermany.get(caseRec.Type); 
                            }
                         system.debug('caseRec.Assignee__c####'+caseRec.Assignee__c);                           
                            
                            if(assignedUserMapGermany.containskey(caseRec.Type)){
                                caseRec.User_Assigned__c = assignedUserMapGermany.get(caseRec.Type); 
                            }
                      system.debug('caseRec.User_Assigned__c####'+caseRec.User_Assigned__c);
                        }
                    }
                    
                }
            }
        }
    }
    
    /*public static void changeOwner(List<Case> caseList){
    Id colombiaRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Spain_Cases').getRecordTypeId();
        for(Case cs:caseList){
            if(cs.RecordtypeId == colombiaRecordTypeId){
                 cs.ownerId ='0055D000005Nz7f';
              }
        }
  
    }*/
}