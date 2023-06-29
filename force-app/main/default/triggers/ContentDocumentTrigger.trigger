/*
* Name: ContentDocumentTrigger
* Created On: 25 Jan 2023
* Author: Abhinay kurmi patel
* Description: Trigger to Delete document and Update field from contract management object for Contract management (France)
* Supporting Classes: ContentDocumentHelper (For Test Coverage ContentDocumentTriggerTest)
*/

trigger ContentDocumentTrigger on ContentDocument (before delete, before insert) 
{
    
    /*if(Trigger.isInsert && Trigger.isBefore ){
        for(ContentDocument cd : Trigger.new){
            if(cd.fileType != 'PDF'){
                cd.addError('Error');
            }
        }
    }*/
     
    if(Trigger.isDelete && Trigger.isBefore)
    {
        ContentDocumentHelper.DeleteDocumentAndUpdateContractmanagementField(Trigger.old);
    }
    /*if(Trigger.isInsert && Trigger.isBefore)
    {
        ContentDocumentHelper.FileExtensionContractmanagementField(Trigger.new);
    }*/
}