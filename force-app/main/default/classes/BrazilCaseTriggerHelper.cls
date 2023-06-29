public class BrazilCaseTriggerHelper {
    
   /* Public Static Void shareCaseWithCreator(List<Case> lstNewCases, Map<Id,Case> mapOldCases){
        Map<Id,CaseTeamMember> mapMembersToAdd=new Map<Id,CaseTeamMember>();
        CaseTeamRole objCaseTeamRole=new CaseTeamRole();
       for(Case objCase:lstNewCases){     
        	if(objCase.RecordTypeId==Label.GZ_Brazil_Case_Record_Id){ 
        String oldOwnerId = mapOldCases.get(objCase.Id).ownerId;
        String newOwnerid = objCase.ownerId;

        if(!newOwnerid.equalsIgnoreCase(mapOldCases.get(objCase.Id).ownerId) 
            && oldOwnerId.subString(0,3) == '005')
        {
            //verify if the oldOwnerId ever exists as Case Team members
            List<CaseTeamMember> lstCaseTeamMember = [SELECT MemberId FROM CaseTeamMember
                                                    WHERE ParentId =: objCase.Id
                                                    AND MemberId =: oldOwnerId];

            if(lstCaseTeamMember.size() == 0)
            { 
                mapMembersToAdd.put(objCase.Id, 
                   new CaseTeamMember(             
                          ParentId = objCase.Id,                           
                          MemberId = oldOwnerId
                        )
                    ); 
                 system.debug('mapMembersToAdd--'+mapMembersToAdd);
            }            
        }
            }
        }
    if (!mapMembersToAdd.isEmpty()){ 
        system.debug('mapMembersToAdd90900'+mapMembersToAdd);
        objCaseTeamRole = [SELECT Id FROM CaseTeamRole WHERE Name = 'Case Creator' LIMIT 1]; 
        for (CaseTeamMember objCaseTeamMember : mapMembersToAdd.values())
        {
            objCaseTeamMember.TeamRoleId = objCaseTeamRole.Id;
        }             
        if (!mapMembersToAdd.isEmpty())
        {
            insert mapMembersToAdd.values();
        }

    }    
    }*/
    
    Public static Void populateRejectReason(List<Case> csList){
        List<String> rejectedCases=new List<String>();
        for(Case c:csList){
            if(c.Brazil_Pending_Analyst_SLA_Violated__c==true && c.Brazil_Escalation_Manager__c!=null){
                c.OwnerId=c.Brazil_Escalation_Manager__c;
            }
            if(c.status=='Rejeitado' && c.RecordTypeId==Label.GZ_Brazil_Case_Record_Id){
                rejectedCases.add(c.Id); 
            }
        }
        if(rejectedCases.size()>0){
            Map<String,String> stepCommentMap=new Map<String,String>();  
            List<ProcessInstance> piList=[SELECT Id, TargetObjectId, Status, (SELECT Id, ActorId, Comments, ProcessInstanceId FROM Steps where stepstatus='rejected') FROM ProcessInstance where TargetObjectId IN :rejectedCases];
            for(ProcessInstance p:piList){
                if(p.steps.size()>0){
                    stepCommentMap.put(p.TargetObjectId, p.steps.get(0).Comments);  
                }                
            }
            for(Case c:csList){
                if(stepCommentMap.get(c.Id)!=null){
                    c.Brazil_Case_Reject_Reason__c=stepCommentMap.get(c.Id);
                }
                
            }
        }
    }
    
    Public static void updateEntitlementOnCase(List<Case> csList){
        system.debug('inside updateEntitlementOnCase');
        List<Entitlement> entLst=[SELECT Id, Name, Type FROM Entitlement where Name ='Brazil SLAs']; 
        if(entLst.size()>0){
            system.debug('entLst==='+entLst);
            string caseID=Label.GZ_Brazil_Case_Record_Id;
            system.debug('caseID---'+caseID);
            for(Case c:csList){
                if(c.RecordTypeId==Label.GZ_Brazil_Case_Record_Id){
                    system.debug('c.RecordTypeId---'+c.RecordTypeId);
                    c.EntitlementId=entLst[0].Id; 
                    
                    system.debug('c.EntitlementId==='+c.EntitlementId);
                }               
            }  
        }        
    }
   
    Public Static Void shareCase(List<Case> lstNewCases, Map<Id,Case> mapOldCases){
        Map<string,CaseTeamMember> mapMembersToAdd=new Map<string,CaseTeamMember>();
        List<String> csTeam=new List<String>{'Case Creator','Case Approver one','Case Approver two','Case Approver three'}; 
        Map<String,Id> objCaseTeamRoleMap = new  Map<String,Id>(); 
        for(CaseTeamRole ct:[SELECT Id,Name FROM CaseTeamRole WHERE Name IN:csTeam]){
        objCaseTeamRoleMap.put(ct.Name,ct.id);
        }
        for(Case objCase:lstNewCases){     
            if(objCase.RecordTypeId==Label.GZ_Brazil_Case_Record_Id){ 
                String oldOwnerId = mapOldCases.get(objCase.Id).ownerId;
                String newOwnerid = objCase.ownerId;
                Map<string,CaseTeamMember> existingMembers=new Map<string,CaseTeamMember>();
                if(!newOwnerid.equalsIgnoreCase(mapOldCases.get(objCase.Id).ownerId) 
                   && oldOwnerId.subString(0,3) == '005')
                {
                    //verify if the oldOwnerId ever exists as Case Team members
                    List<CaseTeamMember> lstCaseTeamMember = [SELECT MemberId FROM CaseTeamMember
                                                              WHERE ParentId =: objCase.Id
                                                              AND MemberId =: oldOwnerId];
                    for(CaseTeamMember ctm:lstCaseTeamMember){
                      existingMembers.put(ctm.MemberId,ctm);  
                    }
                    System.debug('existingMembers==>'+existingMembers);
                    if(lstCaseTeamMember.size() == 0)
                    { 
                        if(existingMembers.get(objCase.CreatedById)==null){
                        mapMembersToAdd.put(objCase.CreatedById,new CaseTeamMember(ParentId = objCase.Id,MemberId = objCase.CreatedById , TeamRoleId=objCaseTeamRoleMap.get('Case Creator')));    
                        }
                        if(objCase.Brazil_Sales_District_Manager__c!=null 
                           && existingMembers.get(objCase.Brazil_Sales_District_Manager__c)==null){
                            mapMembersToAdd.put(objCase.Brazil_Sales_District_Manager__c,new CaseTeamMember(ParentId = objCase.Id,MemberId = objCase.Brazil_Sales_District_Manager__c, TeamRoleId=objCaseTeamRoleMap.get('Case Approver one')));
                        }   
                        if(objCase.Brazil_Sales_Office_Manager__c!=null 
                          && existingMembers.get(objCase.Brazil_Sales_Office_Manager__c)==null){
                            mapMembersToAdd.put(objCase.Brazil_Sales_Office_Manager__c,new CaseTeamMember(ParentId = objCase.Id,MemberId = objCase.Brazil_Sales_Office_Manager__c, TeamRoleId=objCaseTeamRoleMap.get('Case Approver two')));                  
                        }
                        if(objCase.Brazil_Escalation_Manager__c!=null
                          && existingMembers.get(objCase.Brazil_Escalation_Manager__c)==null){
                            mapMembersToAdd.put(objCase.Brazil_Escalation_Manager__c,new CaseTeamMember(ParentId = objCase.Id,MemberId = objCase.Brazil_Escalation_Manager__c, TeamRoleId=objCaseTeamRoleMap.get('Case Approver three')));                  
                        }
                        
                    }            
                }
            }
        }
        if (!mapMembersToAdd.isEmpty()){                        
            
             insert mapMembersToAdd.values();
            
        }    
    }
}