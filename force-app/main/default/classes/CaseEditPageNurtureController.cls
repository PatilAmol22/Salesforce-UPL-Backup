public without sharing class CaseEditPageNurtureController {
    
    @AuraEnabled
    public static String updateCaseRecord(case caseToUpdate, id recId,Datetime startTime)
    {
        String returnVal='success';
        Boolean l0AgentUser=false;
        Boolean l1AgentUser=false;
        Boolean l2AgentUser=false;
        Id currentUserId=UserInfo.getUserId();
        User loggedInUser = [Select Id,Name,Profile.Name from User where ID = :UserInfo.getUserId() limit 1];
        String profileName = loggedInUser.Profile.Name;
        List<Case> caseLst=[select id,CaseNumber,Status,L1_Agent_Start_Time__c,L2_Agent_Start_Time__c,L1_Agent_Close_Time__c,L2_Agent_Close_Time__c,L0_Agent_Close_Time__c,
                    AccountId,Department__c,QRC_Category__c,QRC_sub_category__c,Reason_for_calling__c,QRC_type__c,
                    Order_number__c,Subject,Description,Level_1_Comments__c,Level_2_Comments__c,Origin,State_Head__c,Multibrand_Name__c,
                    Follow_Up_Status__c,SuppliedEmail,Priority,Customer_Related_To__c from case where id=:recId];
        List<GroupMember> queueMemberL1 = [Select UserOrGroupId,GroupId,Group.Name From GroupMember where UserOrGroupId = :currentUserId  and Group.Name in ('QRC Technical Queue','QRC Non Technical Queue')];
        List<GroupMember> queueMemberL2 = [Select UserOrGroupId,GroupId,Group.Name From GroupMember where UserOrGroupId = :currentUserId  and Group.Name in ('QRC Technical Queue L2','QRC Non Technical Queue L2')];
        if(queueMemberL1.size() > 0){
            l1AgentUser = true;
        }    
        if(queueMemberL2.size() > 0){
            l2AgentUser = true;
        }
        if (queueMemberL1.size() <= 0 && queueMemberL2.size() <= 0 && profileName != 'System Administrator'){
            l0AgentUser = true;
        }

        
                
        if(caseLst.size()>0)
        {
            if(caseLst[0].Status != caseToUpdate.Status && caseLst[0].Status == 'Closed')
            {
                AssignmentRule AR = new AssignmentRule();
                AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
                Database.DMLOptions dmlOpts = new Database.DMLOptions();
                dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
                caseLst[0].setOptions(dmlOpts);
                
            }
            
            if(caseToUpdate.QRC_type__c=='Query' && caseToUpdate.Status != 'Closed' )
            {
                returnVal='error';
            }


            if(l1AgentUser && caseLst[0].L1_Agent_Start_Time__c == null)
            {
                caseLst[0].L1_Agent_Start_Time__c = startTime;
            }
            
            if(l2AgentUser && caseLst[0].L2_Agent_Start_Time__c == null)
            {
                caseLst[0].L2_Agent_Start_Time__c = startTime;
            }
            caseLst[0].AccountId=caseToUpdate.AccountId;
            caseLst[0].Department__c=caseToUpdate.Department__c;
            caseLst[0].QRC_Category__c=caseToUpdate.QRC_Category__c;
            caseLst[0].QRC_sub_category__c=caseToUpdate.QRC_sub_category__c;
            caseLst[0].Reason_for_calling__c=caseToUpdate.Reason_for_calling__c;
            caseLst[0].QRC_type__c=caseToUpdate.QRC_type__c;
            caseLst[0].Order_number__c=caseToUpdate.Order_number__c;
            caseLst[0].Multibrand_Name__c=caseToUpdate.Multibrand_Name__c;
            caseLst[0].Description=caseToUpdate.Description;
            caseLst[0].Level_1_Comments__c=caseToUpdate.Level_1_Comments__c;
            caseLst[0].Level_2_Comments__c=caseToUpdate.Level_2_Comments__c;
            caseLst[0].Status=caseToUpdate.Status;
            caseLst[0].Origin=caseToUpdate.Origin;
            caseLst[0].State_Head__c=caseToUpdate.State_Head__c;
            caseLst[0].Follow_Up_Status__c=caseToUpdate.Follow_Up_Status__c;
            //RITM0466996-Added by Nandhini-To capture Customer Related to Value
            caseLst[0].Customer_Related_To__c=caseToUpdate.Customer_Related_To__c;
            if(l1AgentUser)
            {
                caseLst[0].L1_Agent_Close_Time__c=System.now();
            }
            if(l2AgentUser)
            {
                caseLst[0].L2_Agent_Close_Time__c=System.now();
            }
            if(l0AgentUser)
            {
                caseLst[0].L0_Agent_Close_Time__c=System.now();
            }
            
        }
        if(returnVal=='success')
        {
            update caseLst;
        }
        
        return returnVal;
    } 
}