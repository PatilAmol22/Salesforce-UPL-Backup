/*
* Name: ContentDocumentLinkTrigger
* Created On: 25 Jan 2023
* Author: Abhinay kurmi patel
* Description: Trigger to Insert and Update field to attach documents for Contract management (France)
* Supporting Classes: ContentDocumentLinkHelper (For Test Coverage ContentDocumentLinkTriggerTest)
*/

trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert,before insert) 
{
    if(Trigger.isInsert && Trigger.isAfter)
    {
        ContentDocumentLinkHelper.InsertDocumentAndUpdateContractmanagementField(Trigger.new);
    }
    
    
    if(Trigger.isInsert && Trigger.isBefore)
    {
        ContentDocumentLinkHelper.fileExtensionISPDF(Trigger.new);
    }  
}