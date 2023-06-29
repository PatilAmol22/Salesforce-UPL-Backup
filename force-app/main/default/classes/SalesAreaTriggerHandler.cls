public class  SalesAreaTriggerHandler  {
    
    public static void  shareSalesAreaOwnerwithAccount(List<DistributorSalesAreaMapping__c> newList){
        for(DistributorSalesAreaMapping__c salesarea :newList){
            
            salesarea.isAccountOwnerChanged__c=true;
        }
     
  }
   
    public static void  updateShareSalesAreaOwnerwithAccount(List<DistributorSalesAreaMapping__c> newList,Map<id,DistributorSalesAreaMapping__c> oldMap){
    System.debug('after update trigger inside');
         
         List<WrapClass> WrapCLassList = new List<WrapClass>();
  Set<Id> AccountSet = new Set<Id>();
  List<AccountShare> deleteAccountShareList = new List<AccountShare>();
        List<DistributorSalesAreaMapping__c> salesAreaMapping=new List<DistributorSalesAreaMapping__c>();
    for(DistributorSalesAreaMapping__c salesarea :newList){
        DistributorSalesAreaMapping__c oldsales = (DistributorSalesAreaMapping__c)Trigger.oldMap.get(salesarea.id);
        system.debug('SaleAreaTrigger - OldSales---> '+oldsales);
        if(oldSales.AccountOwner__c != salesarea.AccountOwner__c &&  oldSales.AccountOwner__c != Null && salesarea.Distributor__r.OwnerId!=salesarea.AccountOwner__c ){
            salesarea.isAccountOwnerChanged__c=true;
            salesAreaMapping.add(salesArea);
           AccountSet.add(salesarea.Distributor__c);
           WrapCLass wc = new WrapCLass();
           wc.Old_UserID = STring.valueOf(oldSales.AccountOwner__c);
           wc.AccountID = String.valueof(salesarea.Distributor__c);
            wc.New_UserId=String.valueOf(salesarea.AccountOwner__c);
           WrapCLassList.add(wc);
      }
    }
    List<AccountShare> AccountShareList = new List<AccountShare>([Select id, AccountID, UserOrGroupId,RowCause  from AccountShare where AccountID in: AccountSet and rowcause='Manual' ]);
if(AccountShareList.size()>0)
{
   System.debug('AccountShareList'+AccountShareList	);
    for(WrapClass w : WrapCLassList){
        for(AccountShare acs : AccountShareList){
            if(w.AccountID == String.valueof(acs.AccountID)  &&  w.Old_UserID ==  String.valueof(acs.UserOrGroupId)){
               deleteAccountShareList.add(acs);
            }}}
        if(deleteAccountShareList.size()>0)
        {
          delete deleteAccountShareList;
        }

}}
  public class WrapClass{
     String Old_UserID;
     String AccountID; 
        String New_UserId;
         public WrapCLass(){
             Old_UserID='';
            AccountID =''; 
             New_UserId='';
         }
    }
}