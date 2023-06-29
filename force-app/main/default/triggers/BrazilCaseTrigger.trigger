/* Developer Name : Pranav Dinakaran
Purpose: To remove acces on of previous barter user and give access to new barter User

* CR: APPS-2074
* Author: EY
* ModifiedDate: 02-Nov-2022 19:01 AM IST
Updated Lines: 13, 136-198
*/
trigger BrazilCaseTrigger on Case (after insert, after Update, before Update,Before Insert) {
    
    Id Case_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Brazil_Case_Process).getRecordTypeId();
    Id colombiaRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Colombia_Case').getRecordTypeId();
    Id recordTypeShowId = Schema.SObjectType.Case.RecordTypeInfosByName.get('RCMCase').RecordTypeId;
    //Added by Nandhini
    Id iberiaRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Iberia_Community_Cases').getRecordTypeId();
    Boolean isSpainOrPortugal=false;
    //Added by N
    Id GermanyRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Germany_record_Type').getRecordTypeId();
    Boolean isGermany=false;
    
    Boolean isRCMCaseTrue = false;
    for(Case caseRecord : Trigger.new){
        if(caseRecord.RecordtypeId == recordTypeShowId){
            isRCMCaseTrue = true;
            break;
        }
    }
    boolean isColombiaRecord = false;  //Start: CR: APPS-2074 : changes
    List<CaseShare> ExistingCaseShareList = new List<CaseShare>();
    List<CaseShare> CaseShareInsertList = new List<CaseShare>();
    List<CaseShare> CaseShareDeleteList = new List<CaseShare>();
    List<WrapClass> WrapObjectList = new List<WrapClass>();
    Set<ID> CaseIDSet = new Set<ID>();
    //RITM0464580-Added by Nandhini to invoke case assignment rule for nurture case whenever case is updated through Inline edit.
    if(Trigger.isAfter && Trigger.isUpdate && CaseTriggerHandlerNurture.recursiveCheck) {
        CaseTriggerHandlerNurture.recursiveCheck=false;
        CaseTriggerHandlerNurture.InvokeCaseAssignmentForInlineEdit(trigger.new,Trigger.OldMap); 
    }
    for(Case c : trigger.new){
        if(c.RecordtypeId == Case_recordTypeId && c.Brazil_Analyst__c != Null){
            system.debug('Brazil Case');
            Case case_old = (Case)Trigger.oldMap.get(c.id);
            system.debug('case old values'+case_old.Brazil_Analyst__c);
            
            if(case_old .Brazil_Analyst__c!= c.Brazil_Analyst__c){
                system.debug('Inside if condition after comparing new and old values');
                if(case_old .Brazil_Analyst__c != Null){
                    CaseIDSet.add(c.id);                    
                    //WraperClass  
                    wrapClass wrapObject = new wrapClass();
                    wrapObject.CaseID = c.id;
                    wrapObject.OldUserID = case_old.Brazil_Analyst__c;
                    wrapObject.NewUserID = c.Brazil_Analyst__c;     
                    wrapObject.CaseOwnerID =c.OwnerID;                  
                    wrapObjectList.add(wrapObject);
                }    
            }
        }
    }
    
    ExistingCaseShareList = [Select id,CaseID,UserOrGroupId,RowCause  from CaseSHare where CaseID in: CaseIDSet AND RowCause='Manual'];
    system.debug('ExistingCaseShareList-->'+ExistingCaseShareList);
    
    for(wrapClass wc : wrapObjectList ){
        //For inserting Share Record
        if(wc.CaseOwnerID != wc.NewUserID){
            CaseShare csh = new CaseShare();
            csh.CaseID = wc.CaseID;
            csh.UserOrGroupId = wc.NewUserID;
            csh.RowCause ='Manual';
            csh.CaseAccessLevel='Edit';
            CaseShareInsertList.add(csh);        
        }        
        //For Deleting Share Record
        for(CaseShare ch : ExistingCaseShareList){
            if(ch.CaseID == wc.CaseID && ch.UserOrGroupId == wc.OldUserID){
                CaseShareDeleteList.add(ch);
            }
        }
    }
    // for Inserting and deleting Share Record
    if(CaseShareInsertList.size()>0)
        insert  CaseShareInsertList;
    
    if(CaseShareDeleteList.size()>0)
        delete CaseShareDeleteList;
    /*------ Grazitti code starts here -------------------------*/ 
    if(trigger.IsBefore && trigger.IsInsert){
        Grz_IndiaCaseCreationRCMHandler.updateCaseOwnerName(trigger.new);//Method added by mohit garg (Grazitti) -17/02/2023 APPS-4742
        BrazilCaseTriggerHelper.updateEntitlementOnCase(trigger.new);
        Grazitti_IndiaCaseModuleController.countOpenCaseStatusValueBeforeInsert(trigger.new);  // confirm Additional Fro India Case Moodule        
   
    //Added by Nandhini:Spain case Management:APPS-5135
        for(Case caseRec : Trigger.new){
            if(caseRec.RecordtypeId == iberiaRecordTypeId){
                isSpainOrPortugal = true;
                break;
            }
        }
        if(isSpainOrPortugal){
            
            ColombiaCaseHandler.spainCaseAssignment(Trigger.new,trigger.newMap,true,false);
            ColombiaCaseHandler.validationOnCreateCase(Trigger.new);
        }
        
       // ColombiaCaseHandler.changeOwner(Trigger.new);
        for(Case caseRec : Trigger.new){
            if(caseRec.RecordtypeId == GermanyRecordTypeId){
                isGermany = true;
                break;
            }
        }
        if(isGermany){
            ColombiaCaseHandler.GermanyCaseAssignment(Trigger.new,trigger.newMap,true,false);
          }

    }
    
      
    
    if(trigger.IsUpdate && trigger.IsBefore){        
        BrazilCaseTriggerHelper.shareCase(Trigger.new, Trigger.OldMap);
        BrazilCaseTriggerHelper.populateRejectReason(Trigger.new); 
        Grazitti_IndiaCaseModuleController.countOpenCaseStatusValueBeforeUpdate(trigger.new, trigger.oldMap);  // confirm Additional for India Case Module  
    
    //Added by Nandhinii:Spain case Management:APPS-5135
        for(Case caseRec : Trigger.new){
            if(caseRec.RecordtypeId == iberiaRecordTypeId){
                isSpainOrPortugal = true;
                break;
            }
        }
        if(isSpainOrPortugal){
            String runningUserProfile=[Select Id,Name from Profile where Id =:Userinfo.getProfileId()].Name;
            ColombiaCaseHandler.spainCaseAssignment(Trigger.new,trigger.OldMap,false,true);
            ColombiaCaseHandler.validationOnClosingTheCase(Trigger.new,trigger.OldMap,runningUserProfile);
            ColombiaCaseHandler.EscalateSpainAndPortugalCase(Trigger.new,trigger.OldMap);
            ColombiaCaseHandler.ReopenedCount(Trigger.new,trigger.OldMap,false,true);
        }
        
            for(Case caseRec : Trigger.new){
            if(caseRec.RecordtypeId == GermanyRecordTypeId){
                isGermany = true;
                break;
            }
        }
        if(isGermany){
            String runningUserProfile=[Select Id,Name from Profile where Id =:Userinfo.getProfileId()].Name;
            ColombiaCaseHandler.GermanyCaseAssignment(Trigger.new,trigger.OldMap,false,true);
            
        }
        
    }
    /*------ Grazitti code Ends here -------------------------*/
    
    //added by grazitti for sending sms when case is created from UPL partner portal
    if(trigger.IsAfter && trigger.IsInsert){        
        System.debug('Inside after insert trigger For India');
        Grz_IndiaCaseTriggerHelper.sendCaseSmsComm(Trigger.new);
        Grz_IndiaCaseTriggerHelper.sendEmailOnCaseCreation(trigger.newMap);
        if(isRCMCaseTrue){
             Grz_IndiaCaseCreationRCMHandler.caseCreationEmail(trigger.newMap); // Method added by Mohit Garg (Grazitti)- 13-02-2023 (APPS-4742)
        }
        //Grazitti_IndiaCaseModuleController.sendEmailOnCaseCreation(trigger.newMap);  //  Additional For India Case Module
        //  //Grz_CaseDetailClass.escalatePortalCase(trigger.newmap);  //  Test India Case Module Escalation 2 Email  
        //Grz_MexicoCaseTriggerHelper.submitProcessApprovalRequestMexico(Trigger.new);
    }
    
    if(trigger.IsAfter && trigger.IsUpdate){   
        if(Grz_checkRecursiveTriggerCase.runOnce() ){     //code added for avoide recursion GRZ(Sumit Kumar) Jira Ticket No. RITM0427885 modified on 29-09-2022
            System.debug('1111');
            Grz_IndiaCaseTriggerHelper.checkStatusChangeForCase(trigger.newMap,trigger.oldMap);
            
            System.debug('2222');
            Grazitti_IndiaCaseModuleController.sendEmailOnHOAfterCaseReopn2Times(trigger.oldmap, trigger.new);  // Additional For India Case Module H. O. Admin 
            System.debug('3333');
            Grazitti_IndiaCaseModuleController.sendEmailOnDepotatCaseReopen1Time(trigger.oldmap, trigger.new);  //  Additional Line for Reopen 1 Time    
            System.debug('4444');
            //Test EScalation 2 //  Grz_CaseDetailClass.escalatePortalCase(trigger.newmap);  //  Test India Case Module Escalation 2 Email  
            
            //Grazitti_IndiaCaseModuleController.sendEmailOnCaseEscalation1(trigger.oldmap, trigger.new);  //  Additional Batch Test Esc 1  
            //Grazitti_IndiaCaseModuleController.sendEmailOnCaseEscalation2(trigger.oldmap, trigger.new);  //  Additional Batch Test Esc 2 
            SubmitForApproval.SubmitforApprovalAfterUpdate(trigger.oldMap, trigger.new);  //  Additional Line to Approval Process  
        	if(isRCMCaseTrue){
                SubmitForApproval.SubmitforApprovalAfterUpdate1(trigger.oldMap, trigger.new);  // Method added by Mohit Garg (Grazitti)- 13-02-2023 - APPS-4742
                Grz_IndiaCaseCreationRCMHandler.caseCloseEmail(trigger.newmap, trigger.oldmap);// Method added by Mohit Garg (Grazitti)- 13-02-2023 - APPS-4742
                Grz_IndiaCaseCreationRCMHandler.caseApprovalEmail(trigger.newmap, trigger.oldmap);// Method added by Mohit Garg (Grazitti)- 13-02-2023 - APPS-4742
            }
         }
    }
    
    
    // Wrapper Class to hold data   
    public class wrapClass{
        ID CaseID;
        ID OldUserID;
        ID NewUserID;
        ID CaseOwnerID;
        
        public wrapClass(){
            CaseID = Null;
            OldUserID = Null;
            NewUserID = Null;
            CaseOwnerID = null;     
        }
    }  
    // Added by kuhinoor for HFX 
    if(Trigger.operationType == TriggerOperation.BEFORE_INSERT){
        HFXAccountMappingHandler.accountMapping(trigger.new);
    }
    
    /*if(Trigger.operationType == TriggerOperation.AFTER_INSERT || Trigger.operationType == TriggerOperation.AFTER_UPDATE ){
HFXAccountMappingHandler.afterInsertUpdate(trigger.newMap, trigger.isInsert, trigger.isUpdate);
}*/
    
    
    //Start: CR: APPS-2074 : This part will update Colombia user and Asignee field based on type during both insert and update scenario
    for(Case caseRecord : Trigger.new){
        if(caseRecord.RecordtypeId == colombiaRecordTypeId){
            isColombiaRecord = true;
            break;
        }
    }
    if(isColombiaRecord){
        String runningUserProfile=[Select Id,Name from Profile where Id =:Userinfo.getProfileId()].Name;
        //CAMILA MURILLO
        
        if(Trigger.isBefore && Trigger.isInsert) {
            Map<String,User> userMap = ColombiaCaseHandler.getUserDetails();
            Map<String,String> colombiaAssigneeUserDetails = ColombiaCaseHandler.getColombiaAssigneeCaseDetails();
            for(Case caseObj : Trigger.new){
                System.debug('Entered into for loop----');
                System.debug('check Case Type'+caseObj.Type);
                if(null != caseObj 
                   && runningUserProfile.equals('Business Center Coordinator Colombia') //change this to Business Center Coordinator
                   && UserInfo.getUserName().equalsIgnoreCase(System.Label.Colombia_Case_Camila_Murillo) //change Camila's UserName while testing --- done
                   && null != userMap && userMap.containsKey(caseObj.Type)){
                       System.debug('check Case Type'+caseObj.Type);
                       System.debug('Entered into If block');
                       User userData = userMap.get(caseObj.type);
                       caseObj.Colombia_User__c = userData.Id;
                       caseObj.Assignee__c = colombiaAssigneeUserDetails.get(userData.Username);
                       caseObj.Status ='New';
                       //caseObj.OwnerId = userData.Id;
                   }                
            }
        }
        
        if(Trigger.isBefore && Trigger.isUpdate){
            System.debug('Before Update is getting called');
            for(Case caseObj : Trigger.new){
                if(Trigger.oldMap.get(caseObj.Id).Type != caseObj.Type){
                    Map<String,User> userMap = ColombiaCaseHandler.getUserDetails();
                    Map<String,String> colombiaAssigneeUserDetails = ColombiaCaseHandler.getColombiaAssigneeCaseDetails();
                    User user = userMap.get(caseObj.Type);
                    System.debug('Case type if different');
                    System.debug('caseObj.Type >>>>>>>' +caseObj.Type);
                    if(userMap.containsKey(caseObj.Type)){
                        User userData = userMap.get(caseObj.Type);
                        System.debug('userData in Update>>>>>>'+userData);
                        caseObj.Colombia_User__c = userData.Id;
                        caseObj.Assignee__c = colombiaAssigneeUserDetails.get(userData.Username);
                        //caseObj.OwnerId = userData.Id;
                    }
                } 
            }
        }
        
        //Validation message if inappropriate user tries to close the case
        if(Trigger.isBefore && Trigger.isUpdate){
            for(Case ca : Trigger.new){
                system.debug('Before update state check-------->'+ca.status);
                case oldcaseRec=Trigger.oldMap.get(ca.id);
                if(oldcaseRec.status!=ca.status && (ca.Status.equals('Closed') || ca.Status.equals('Cerrado'))){
                    System.debug('Is Colombia UserName exist >>>>>>>>>'+ String.isNotBlank(ca.Colombia_User__c));
                    System.debug('Is Colombia UserName same as OwnerI >>>>>>>>>'+  (String.valueOf(ca.OwnerId) == String.valueOf(ca.Colombia_User__c)));
                    System.debug('Is Colombia UserName is the runningUser >>>>>>>>>'+ (String.valueOf(ca.Colombia_User__c) == String.valueOf(UserInfo.getUserId())));
                    
                    System.debug('Is Colombia UserName exist >>>>>>>>>'+ String.isNotBlank(ca.Colombia_User__c));
                    System.debug('Is Colombia UserName same as OwnerId >>>>>>>>>'+ (String.valueOf(ca.OwnerId) == String.valueOf(ca.Colombia_User__c)));
                    System.debug('Is Colombia UserName is the runningUser >>>>>>>>>'+ (String.valueOf(ca.Colombia_User__c) == String.valueOf(UserInfo.getUserId())));
                    
                    System.debug('Is escalated UserName exist >>>>>>>>>'+ String.isNotBlank(ca.EscalationUser__c));
                    System.debug('Is escalated UserName same as OwnerId >>>>>>>>>'+ (String.valueOf(ca.OwnerId) == String.valueOf(ca.EscalationUser__c)));
                    System.debug('Is escalated UserName is the runningUser >>>>>>>>>'+ (String.valueOf(ca.EscalationUser__c) == String.valueOf(UserInfo.getUserId())));
                    
                    if((UserInfo.getUserId()==ca.ownerid) 
                       || (String.isNotBlank(ca.Colombia_User__c)  && ca.Colombia_User__c == UserInfo.getUserId())
                       || (String.isNotBlank(ca.EscalationUser__c)  && ca.EscalationUser__c == UserInfo.getUserId())){//||ca.Colombia_User__r.username.equalsIgnoreCase(UserInfo.getUserName()))
                           System.debug('Valid User>>>>>>>>>>>>>>>>>>>>>>>>>..');
                       }else {
                           ca.addError('You are not a valid person to close the case');
                       }
                    
                    
                }
            }
        } 
        //CR: APPS-2074 -Added by nandhini for case share  
        if(Trigger.isAfter && Trigger.isInsert) {
            ColombiaCaseHandler.caseShareColombia(trigger.new,trigger.newMap,true,false); 
        }
        if(Trigger.isAfter && Trigger.isUpdate){
            ColombiaCaseHandler.caseShareColombia(trigger.new,trigger.oldmap,false,true);    
        }
        
    }
    //End: CR: APPS-2074 : changes   
}