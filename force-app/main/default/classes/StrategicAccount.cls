/**************************************************************************************************
* Name               : StrategicAccount                                                      
* Description        : Controller class for grz_StrategicAccount LWC Component
* Created Date       : 13/07/2022                                                                 
* Created By         : Ishita (Grazitti) 
* Ticket Number		 :  RITM0245056
**************************************************************************************************/
public class StrategicAccount {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsRelatedToAccount(String accId) {
        system.debug('accId >> ' + accId);
        return [SELECT Id, Name, FirstName, Role__c, Relationship__c, Relationship_goals__c, Stages_of_involvement__c,LastName, Email, Phone from Contact where AccountId = :accId];
    }

}