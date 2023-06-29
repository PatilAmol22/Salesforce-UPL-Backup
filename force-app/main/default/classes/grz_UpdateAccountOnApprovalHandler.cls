/**************************************************************************************************
* Name             : grz_UpdateAccountOnApprovalHandler (Trigger: grz_UpdateAccountOnAgrementApproval)                                                      
* Description      : To Update the status of Sales Area on approval type change 
* Test Class       :                                                      
* Created Date     : 18-01-2023                                                                        
* Project/JIRA     : UPL                                                                        
* Created By       : Meenu Thakur (Grazitti)                                                                        
* Last Modified By : Meenu Thakur (Grazitti) 18-01-2023                                                                        
**************************************************************************************************/

public class grz_UpdateAccountOnApprovalHandler {
public static void updateAccountOnApproval(List<echosign_dev1__SIGN_AgreementEvent__c> listOfSignedAgreementEvent){
    List<string> groupsEmails=new List<string>();
    List<DistributorSalesAreaMapping__c> updateSalesArea=new List<DistributorSalesAreaMapping__c>();
    map<id,echosign_dev1__SIGN_AgreementEvent__c> mapOfSalesareaIdVsEvent=new map<id,echosign_dev1__SIGN_AgreementEvent__c>();
    for(echosign_dev1__SIGN_AgreementEvent__c signAgreementEvent : listOfSignedAgreementEvent)
    {
        if(signAgreementEvent.Sales_Area_Id__c!=null){
            mapOfSalesareaIdVsEvent.put(signAgreementEvent.Sales_Area_Id__c,signAgreementEvent);
        }
    }
    
    List<User> listofUsers=[select id, email from user where id in (SELECT UserOrGroupId FROM GroupMember where Group.DeveloperName='GBS_Approver_Group')];
    if(!listofUsers.isEmpty()){
        for(User us:listofUsers){
            groupsEmails.add(us.email);
        }  
    }
    
    if(Test.isRunningTest())groupsEmails.add('taruni.uce@test.com');
    
        system.debug('groupsEmails==='+groupsEmails);
    if(!mapOfSalesareaIdVsEvent.isEmpty()){
        for(DistributorSalesAreaMapping__c salesarea: [SELECT id,Stage__c,Substage__c,Customer_Email__c,Territory_Manager__c,Territory_Manager__r.Email,First_Approver__c,First_Approver__r.Email,Second_Approver__c,Second_Approver__r.Email 
                                                        FROM DistributorSalesAreaMapping__c 
                                                        WHERE Id IN:mapOfSalesareaIdVsEvent.keyset()])
        {
            if(mapOfSalesareaIdVsEvent.containskey(salesarea.id)){
                if(mapOfSalesareaIdVsEvent.get(salesarea.id).echosign_dev1__Type__c =='SENT'){
                    if(salesarea.Customer_Email__c == mapOfSalesareaIdVsEvent.get(salesarea.id).echosign_dev1__Participant_Email__c){
                        salesarea.Stage__c='Pending with customer';
                    }
                }
                else if(mapOfSalesareaIdVsEvent.get(salesarea.id).echosign_dev1__Type__c =='SENT FOR APPROVAL')
                {
                    if(salesarea.Territory_Manager__r.Email == mapOfSalesareaIdVsEvent.get(salesarea.id).echosign_dev1__Participant_Email__c){
                         salesarea.Stage__c='Pending with TM';
                    }
                   else if(salesarea.First_Approver__r.Email == mapOfSalesareaIdVsEvent.get(salesarea.id).echosign_dev1__Participant_Email__c){
                        salesarea.Stage__c='Pending with approver 1';
                    }
                    
                    else if(salesarea.Second_Approver__r.Email == mapOfSalesareaIdVsEvent.get(salesarea.id).echosign_dev1__Participant_Email__c){
                        salesarea.Stage__c='Pending with company signing authority (ZBH/SBU)';
                    }
                   
                    else if(groupsEmails!=null && !groupsEmails.isEmpty()){
                        if(groupsEmails.contains(mapOfSalesareaIdVsEvent.get(salesarea.id).echosign_dev1__Participant_Email__c)){
                            salesarea.Stage__c='Pending with GBS';
                        }
                    }
                }
                else if (mapOfSalesareaIdVsEvent.get(salesarea.id).echosign_dev1__Type__c =='SENT FOR ACCEPTANCE'){
                        if(groupsEmails!=null && !groupsEmails.isEmpty()){
                        if(groupsEmails.contains(mapOfSalesareaIdVsEvent.get(salesarea.id).echosign_dev1__Participant_Email__c)){
                            salesarea.Stage__c='Pending with GBS';
                        }
                    }
                }
                else if(mapOfSalesareaIdVsEvent.get(salesarea.id).echosign_dev1__Type__c =='APPROVED' || mapOfSalesareaIdVsEvent.get(salesarea.id).echosign_dev1__Type__c =='ACCEPTED'){
                    if(groupsEmails!=null && !groupsEmails.isEmpty()){
                        if(groupsEmails.contains(mapOfSalesareaIdVsEvent.get(salesarea.id).echosign_dev1__Participant_Email__c)){
                            salesarea.Stage__c='Pending with GBS';
                            salesarea.Substage__c='Contract Approved';
                        }
                    }
                }
                else if(mapOfSalesareaIdVsEvent.get(salesarea.id).echosign_dev1__Type__c =='DECLINED'){
                    if(groupsEmails!=null && !groupsEmails.isEmpty()){
                        if(groupsEmails.contains(mapOfSalesareaIdVsEvent.get(salesarea.id).echosign_dev1__Participant_Email__c)){
                            salesarea.Stage__c='Pending with GBS';
                            salesarea.Substage__c='Contract Rejected';
                        }
                    }
                }
                updateSalesArea.add(salesarea);
            }
        }
        if(updateSalesArea!=null && !updateSalesArea.isEmpty()){
            system.debug('updateSalesArea==='+updateSalesArea);
            update updateSalesArea;
        }
    }
}
}