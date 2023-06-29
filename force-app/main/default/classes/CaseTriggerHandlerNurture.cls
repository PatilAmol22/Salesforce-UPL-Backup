/**
* Apex class Name: CaseTriggerHandlerNurture
* Author: EY (Ishu Mittal)
* APPS-APPS-5243
* ModifiedDate: 24 May 2023
* Description: Added condition of UPL Consumer Product
* */
public class CaseTriggerHandlerNurture {
    public static boolean recursiveCheck=true;
    //This method captures the edit start and end time for L0,L1 & L2 users.
    //Time gets captured in case record itself
    public static void updateTimeInCase(List<case> newCaseLst,Map<id,case> oldCaseMap)
    {
        Boolean l0AgentUser=false;
        Boolean l1AgentUser=false;
        Boolean l2AgentUser=false;
        Id nutureFarmRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('nurture.farm care').getRecordTypeId();
        for(Case eachCase:newCaseLst)
        {
            if(eachCase.recordtypeid==nutureFarmRecordTypeId)
            {
                if(eachCase.ownerId==oldCaseMap.get(eachCase.id).ownerid)
                {
                    Id currentUserId=UserInfo.getUserId();
                    User loggedInUser = [Select Id,Name,Profile.Name from User where ID = :UserInfo.getUserId() limit 1];
                    String profileName = loggedInUser.Profile.Name;
                    List<GroupMember> queueMemberL1 = [Select UserOrGroupId,GroupId,Group.Name From GroupMember where UserOrGroupId = :currentUserId  and Group.Name in ('QRC Technical Queue','L1 Complete Queue')];
                    List<GroupMember> queueMemberL2 = [Select UserOrGroupId,GroupId,Group.Name From GroupMember where UserOrGroupId = :currentUserId  and Group.Name in ('QRC Technical Queue L2','L2 Complete Queue')];
                    if(queueMemberL1.size() > 0){
                        l1AgentUser = true;
                    }    
                    if(queueMemberL2.size() > 0){
                        l2AgentUser = true;
                    }
                    if (queueMemberL1.size() <= 0 && queueMemberL2.size() <= 0 && profileName != 'System Administrator'){
                        l0AgentUser = true;
                    }
                    if(eachCase.Status != oldCaseMap.get(eachCase.id).Status && oldCaseMap.get(eachCase.id).Status == 'Closed')
                    {
                        AssignmentRule AR = new AssignmentRule();
                        AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
                        Database.DMLOptions dmlOpts = new Database.DMLOptions();
                        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
                        eachCase.setOptions(dmlOpts);
                        
                    }
                    if(l1AgentUser && eachCase.L1_Agent_Start_Time__c == null)
                    {
                        eachCase.L1_Agent_Start_Time__c = System.now();
                    }
                    
                    if(l2AgentUser && eachCase.L2_Agent_Start_Time__c == null)
                    {
                        eachCase.L2_Agent_Start_Time__c = System.now();
                    }
                    if(l1AgentUser)
                    {
                        eachCase.L1_Agent_Close_Time__c=System.now();
                    }
                    if(l2AgentUser)
                    {
                        eachCase.L2_Agent_Close_Time__c=System.now();
                    }
                    if(l0AgentUser)
                    {
                        eachCase.L0_Agent_Close_Time__c=System.now();
                    }
                }
                
            }
        
        
        }
        // <!--New Changes(start) - Ishu (for UPL Consumer)-->
        Id uplConsumerProductTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('UPL_consumer_product').getRecordTypeId();
        for(Case eachCase : newCaseLst) {
            if(eachCase.recordtypeid == uplConsumerProductTypeId) {
                if(eachCase.ownerId == oldCaseMap.get(eachCase.id).ownerid) {
                    String profileName = [Select Profile.Name from User where ID = :UserInfo.getUserId() limit 1].Profile.Name;
                    
                    List<GroupMember> queueMemberL1 = [Select UserOrGroupId,GroupId,Group.Name From GroupMember where UserOrGroupId = :UserInfo.getUserId()  and Group.Name in ('UPL consumer product')];
                      List<GroupMember> queueMemberL2 = [Select UserOrGroupId,GroupId,Group.Name From GroupMember where UserOrGroupId = :UserInfo.getUserId()  and Group.Name in ('UPL consumer product L2')];
                    
                    if(null != queueMemberL1 && 0 < queueMemberL1.size()){
                        l1AgentUser = true;
                    }    
                    
                    if ((null != queueMemberL1 && 0 < queueMemberL1.size())  && profileName != 'System Administrator'){
                        l0AgentUser = true;
                    }
                    
                    
                    if(eachCase.Status != oldCaseMap.get(eachCase.id).Status && oldCaseMap.get(eachCase.id).Status == 'Closed') {
                        String assignmentId = [SELECT ID FROM AssignmentRule WHERE SobjectType = 'Case' and Active = true limit 1].Id;
                        Database.DMLOptions dmlOpts = new Database.DMLOptions();
                        dmlOpts.assignmentRuleHeader.assignmentRuleId= assignmentId;
                        eachCase.setOptions(dmlOpts); 
                    }
                    
                    if(l1AgentUser && eachCase.L1_Agent_Start_Time__c == null) {
                        eachCase.L1_Agent_Start_Time__c = System.now();
                    }
                    
                    if(l1AgentUser) {
                        eachCase.L1_Agent_Close_Time__c=System.now();
                    }
                    
                    if(l2AgentUser) {
                        eachCase.L2_Agent_Close_Time__c=System.now();
                    }
                    
                    if(l0AgentUser) {
                        eachCase.L0_Agent_Close_Time__c=System.now();
                    }
                }   
            }        
        } 
        // <!--New Changes(end) - Ishu -->
    }

    /*  
* Name: InvokeCaseAssignmentForInlineEdit    
* return:void
* Description: RITM0464580-This method responsible to Invoke Case assignment Rule when record is getting 
updated through inline Edit.
*/    
    public static void InvokeCaseAssignmentForInlineEdit(List<case> newUpdatedCase,Map<id,case> oldcase)
    {
        system.debug('inside method');
        Id NurtureFarmCareId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('nurture_farm_care').getRecordTypeId();
        
       // Id sellerSupportGeneralId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Sellersupport_General').getRecordTypeId();

        Id uplComsumerProductId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('UPL_consumer_product').getRecordTypeId();

        AssignmentRule  CaseAR = new AssignmentRule();
        CaseAR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= CaseAR.id;
        
        set<id> newlyUpdatedIds=new set<id>();
        
        for( case newcase:newUpdatedCase)
        {
            if(newcase.RecordtypeId==NurtureFarmCareId&&(newcase.status!=oldcase.get(newcase.id).status))
            {
            // RITM0481463-Case change from Escalated L1 to Escalated L2
               /* if((oldcase.get(newcase.id).status.equalsIgnoreCase('Escalated-L1') && newcase.status.equalsIgnoreCase('Escalated-L2'))){
                   newlyUpdatedIds.add(newcase.id); 
                }*/
                if((oldcase.get(newcase.id).status.equalsIgnoreCase('Closed') && newcase.status.equalsIgnoreCase('Escalated-L1'))||(oldcase.get(newcase.id).status.equalsIgnoreCase('Closed') && newcase.status.equalsIgnoreCase('Reopen')))
                {
                   newlyUpdatedIds.add(newcase.id); 
                }
                
            }
            
            if(newcase.RecordtypeId==uplComsumerProductId&&(newcase.status!=oldcase.get(newcase.id).status))
            {
            // RITM0481463-Case change from Escalated L1 to Escalated L2
               /* if((oldcase.get(newcase.id).status.equalsIgnoreCase('Escalated-L1') && newcase.status.equalsIgnoreCase('Escalated-L2'))){
                   newlyUpdatedIds.add(newcase.id); 
                }*/
                if((oldcase.get(newcase.id).status.equalsIgnoreCase('Closed') && newcase.status.equalsIgnoreCase('Escalated-L1'))||(oldcase.get(newcase.id).status.equalsIgnoreCase('Closed') && newcase.status.equalsIgnoreCase('Reopen')))
                {
                   newlyUpdatedIds.add(newcase.id); 
                }
                if(newcase.status.equalsIgnoreCase('Escalated-L2'))
                {
                   newlyUpdatedIds.add(newcase.id);  
                }
                
            }
            
            //Added by nandhini
  /*          if(newcase.RecordtypeId==sellerSupportGeneralId && (newcase.status!=oldcase.get(newcase.id).status)){
                if(newcase.status.equalsIgnoreCase('Escalated-L2')){
                    newlyUpdatedIds.add(newcase.id); 
                }
            }*/
            
        }
        List<Case> casesTobeUpdated=new list<Case>();
        if(newlyUpdatedIds!=null&&!newlyUpdatedIds.isEmpty()){
            for(Case ca:[select id from Case where id in:newlyUpdatedIds]) 
            {
                Case c=new Case(id=ca.id);
                //c.id=ca.id;
                c.setOptions(dmlOpts);
                casesTobeUpdated.add(c);
            }
        }
        if(null != casesTobeUpdated && !CasesTobeUpdated.isEmpty())
        {
            try{
                Database.Update(casesTobeUpdated,false) ;
            }
            catch(Exception e)
            {
                System.debug('Exception caused in Update : '+e.getMessage());
            }
        } 
    }
    
    // Add Below Method for RITM0449691  GRZ(Dheeraj Sharma) 27-12-2022 

    Public static void insertSkuUnitCostOnCase(list<Case> caseList,Map<Id,Case> oldMapList){
        Set<Id> skuId =new Set<Id>();
        Map<Id,Decimal> skuMap = new Map<Id,Decimal>();
        Set<Id> salesOrgIds = new Set<Id>();
        for(sales_Org__c sOrg : [SELECT Id , sales_org_code__c from sales_org__c where sales_org_code__c='3100' OR sales_org_code__c='3710']){
        	salesOrgIds.add(sOrg.Id);
        }
        for(Case cs :caseList){
            if(salesOrgIds != null && salesOrgIds.contains(cs.SalesOrg__c) && cs.Pack_Size_SKU__c !=null && ( oldMapList == null || cs.pack_size_sku__c != oldMapList.get(cs.id).pack_size_sku__c)){
                skuId.add(cs.Pack_Size_SKU__c);
            }
        }
        if(skuId.size()>0){
            for(sku__c sku :[SELECT Id , unit_cost__c from sku__c where Id In :skuId]){
            	skuMap.put(sku.id,sku.Unit_Cost__c);
            }
            for(case cas : caseList){
                if(skuMap.containskey(cas.pack_size_sku__c)){
                    cas.sku_unit_cost__c = skuMap.get(cas.pack_size_sku__c);
                }
        	}
        } 
    }       
    // End for RITM0449691  GRZ(Dheeraj Sharma)27-12-2022 
    
    
}