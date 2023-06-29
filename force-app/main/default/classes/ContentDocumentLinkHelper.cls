/*
* Name: ContentDocumentLinkHelper
* Created On: 25 Jan 2023
* Author: Abhinay kurmi patel
* Description: Controller for trigger ContentDocumentLinkTrigger
* Supporting Classes: Trigger name is ContentDocumentLinkTrigger and test class is ContentDocumentLinkTriggerTest
*/

public class ContentDocumentLinkHelper 
{
    public static void InsertDocumentAndUpdateContractmanagementField(List<ContentDocumentLink> conList)
    {
        List<String> conParentId=new List<String>();
        
        for(ContentDocumentLink con:conList)
        {    
            String pId=con.LinkedEntityId;
            if(pId.startsWith('a7p')){
            	conParentId.add(con.LinkedEntityId);
            }	
        }
        List<Contract_management__c> ConmngList = [Select id,Contract_Attached__c From Contract_management__c Where Id=:conParentId];
        List<Contract_management__c> ConmngList2 = new List<Contract_management__c>();
        for(Contract_management__c conmng:ConmngList)
        {
            Contract_management__c cminstance = new Contract_management__c();
            cminstance.Id = conmng.Id;
            cminstance.Contract_Attached__c = true;
            ConmngList2.add(cminstance);
        }
        if(ConmngList2.size()>0)
        {
            update ConmngList2;
        }   
    }
    
    public static void fileExtensionISPDF(List<ContentDocumentLink> conList)
    {
        Set<String> contentDocId = new Set<String>();
            Map<String,String> fileTypeMap = new Map<String,String>();
            for(ContentDocumentLink cd : conList){
                String tempId = cd.LinkedEntityId;
                if(tempId.startsWith('a7p')){
                    contentDocId.add(cd.ContentDocumentID);
                }
            }
            
            if(!contentDocId.isEmpty()){
                for(ContentDocument conDoc : [Select Id,FileType from ContentDocument where Id In : contentDocId]){
                    fileTypeMap.put(conDoc.Id,conDoc.FileType);
                }
                
                if(!fileTypeMap.isEmpty()){
                    for(ContentDocumentLink cd : conList){
                        String tempId = cd.LinkedEntityId;
                        if(tempId.startsWith('a7p') && fileTypeMap.containsKey(cd.ContentDocumentID)){
                            if(fileTypeMap.get(cd.ContentDocumentID) != 'PDF'){
                                cd.addError('Error');
                            }
                        }
                    }
                    
                }
            }
        }  
}