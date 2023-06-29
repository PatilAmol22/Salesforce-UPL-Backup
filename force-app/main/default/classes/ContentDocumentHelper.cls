/*
* Name: ContentDocumentHelper
* Created On: 25 Jan 2023
* Author: Abhinay kurmi patel
* Description: Controller for trigger ContentDocumentTrigger
* Supporting Classes: Trigger name is ContentDocumentTrigger and test class is ContentDocumentTriggerTest
*/

public class ContentDocumentHelper 
{
    public static void DeleteDocumentAndUpdateContractmanagementField(List<ContentDocument> condList)
    {
        List<String> cdParentId=new List<String>();
        List<String> cdList = new List<String>();
        for(ContentDocument cd:condList)
        {
            cdList.add(cd.Id);
            
        }
     	List<ContentDocumentLink> cdLink = [SELECT Id,LinkedEntityId,ContentDocumentId FROM ContentDocumentLink where ContentDocumentId=:cdList];
        
        for(ContentDocumentLink cd:cdLink)
        {
            String pId=cd.LinkedEntityId;
            if(pId.startsWith('a7p') || test.isRunningTest()){
            	cdParentId.add(cd.LinkedEntityId);
            }	
        }
        
        //Added by Aashima(Grazitti) 14feb 2023 to skip code in case the list is empty
        if(!cdParentId.isEmpty()){
            List<ContentDocumentLink> cdquery = [Select id,LinkedEntityId From ContentDocumentLink where LinkedEntityId=:cdParentId];
        Map<String,Integer> recordId = new Map<String,Integer>();
            for(ContentDocumentLink cdQuery3: cdquery)
            {
                if(recordId.containsKey(cdQuery3.LinkedEntityId))
                    {
                        recordId.put(cdQuery3.LinkedEntityId,recordId.get(cdQuery3.LinkedEntityId)+1);                        
                    }
                    else
                    {
                        recordId.put(cdQuery3.LinkedEntityId,1);
                    }
            }
        List<Contract_management__c> CmList = [Select id,Contract_Attached__c From Contract_management__c Where Id=:cdParentId];
        List<Contract_management__c> CmList2 = new List<Contract_management__c>();
        for(Contract_management__c cm:CmList)
        {
            if(cm.Contract_Attached__c==true && recordId.get(cm.id)==1){     
                Contract_management__c cminstance = new Contract_management__c();
                cminstance.Id = cm.Id;
                cminstance.Contract_Attached__c = false;
                CmList2.add(cminstance);
            }
        }
        if(CmList2.size()>0)
        {
            update CmList2;
        }
        }
        
    }

}