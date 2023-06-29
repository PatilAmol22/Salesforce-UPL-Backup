/**************************************************************************************************
* Name               : AccountStrategicClass                                                      
* Description        : Controller class for AccountStrategicCustomerProfile VF
* Created Date       : 13/07/2022                                                                 
* Created By         : Ishita (Grazitti)   
* Ticket Number		 :  RITM0245056
**************************************************************************************************/ 
public class AccountStrategicClass {
    public Id AccountID{get;set;}
    public List<Contact> contactdetails{get;set;}
    public AccountStrategicClass(ApexPages.StandardController stdController) {
        AccountID = (Id)ApexPages.currentPage().getParameters().get('id');
        contactdetails = [SELECT Id, (select id, Key_customer_stakeholder__c, Business_Goals_Opportunities_For_UPL__c, Actions_To_Help_Achieve_Goals__c, Key_customer_stakeholder__r.Name, Current_Benchmark__c, Description__c, Timeline__c from Business_Goals__r), Name, FirstName, LastName, Account.Name, Role__c, Relationship__c, Relationship_goals__c, Stages_of_involvement__c FROM Contact where Account.Id =: AccountID];
    }
}