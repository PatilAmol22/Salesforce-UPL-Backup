/**************************************************************************************************
* Name             : grz_UpdateAccountOnAgrementApproval                                                      
* Created Date     : 18-01-2023                                                                        
* Project/JIRA     : UPL                                                                        
* Created By       : Meenu Thakur (Grazitti)                                                                        
* Last Modified By : Meenu Thakur (Grazitti) 18-01-2023                                                                        
**************************************************************************************************/

trigger grz_UpdateAccountOnAgrementApproval on echosign_dev1__SIGN_AgreementEvent__c (before insert,after insert) {
    
    if(Trigger.isAfter && Trigger.isInsert)
    {
        grz_UpdateAccountOnApprovalHandler.updateAccountOnApproval(Trigger.new);
    }
}