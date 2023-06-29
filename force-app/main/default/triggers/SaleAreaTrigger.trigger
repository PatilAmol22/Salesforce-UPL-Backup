/* 
Developer Name ; Pranav Dinakaran
Description : Trigger to  remove share reocrd of previous user
*/
trigger SaleAreaTrigger on DistributorSalesAreaMapping__c (before update,before insert) {
    //Trigger was inactive before so commenting the previous code
     /*List<WrapClass> WrapCLassList = new List<WrapClass>();
  Set<Id> AccountSet = new Set<Id>();
  List<AccountShare> deleteAccountShareList = new List<AccountShare>();
    for(DistributorSalesAreaMapping__c salesarea : trigger.new){
        DistributorSalesAreaMapping__c oldsales = (DistributorSalesAreaMapping__c)Trigger.oldMap.get(salesarea.id);
        system.debug('SaleAreaTrigger - OldSales---> '+oldsales);
        if(oldSales.AccountOwner__c != salesarea.AccountOwner__c &&  oldSales.AccountOwner__c != Null){
           AccountSet.add(salesarea.Distributor__c);
           WrapCLass wc = new WrapCLass();
           wc.Old_UserID = STring.valueOf(oldSales.AccountOwner__c);
           wc.AccountID = String.valueof(salesarea.Distributor__c);
           WrapCLassList.add(wc);
      }
    }
    List<AccountShare> AccountShareList = new List<AccountShare>([Select id, AccountID, UserOrGroupId,RowCause  from AccountShare where AccountID in: AccountSet  AND RowCause ='Manual']);
    
    for(WrapClass w : WrapCLassList){
        for(AccountShare acs : AccountShareList){
            if(w.AccountID == String.valueof(acs.AccountID)  &&  w.Old_UserID ==  String.valueof(acs.UserOrGroupId)){
                deleteAccountShareList.add(acs);
            }
        }
    }
    
    if(deleteAccountShareList.size()>0)
        try{
            delete deleteAccountShareList;
            }
            Catch(Exception e){
                System.debug('Exception :'+ e.getMessage());
                System.debug('List>>>'+deleteAccountShareList);
            }
    
    
    public class WrapClass{
     String Old_UserID;
     String AccountID; 
         public WrapCLass(){
             Old_UserID='';
            AccountID =''; 
         }
    }*/
/* 
Developer Name : Ishu Mittal
Description : Trigger to  give access to Sales Area Account Owner the share acess to Account.
Ticket No:RITM0400199
Modify on:10-08-2022
Making this trigger as inactive and commenting the below code as we are using Batch class for sharing
*/
  /*  if(trigger.isUpdate && trigger.isbefore)
    {
      SalesAreaTriggerHandler.updateShareSalesAreaOwnerwithAccount(trigger.new,trigger.oldMap);
    }
 else if(trigger.isInsert && trigger.isbefore)
  {
      SalesAreaTriggerHandler.shareSalesAreaOwnerwithAccount(trigger.new);
  }*/
     
    

}