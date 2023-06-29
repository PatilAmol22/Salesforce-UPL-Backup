/* 
@Author : Pranav Dinakaran
@Class_Description : Schedued CLass to Check for those accounts which is owned by India and Swal Tm so share Record Accordingly
*/

public class ShareSwalIndiaClass{
    public List<DistributorSalesAreaMapping__c> SalesAreaList;
    public List<AccountShare> AccountShareList;
    public Map<String,String> AccountFlagMap;
    
    //Constructor to Implement the logic 
    public ShareSwalIndiaClass(){
        AccountShareList = new List <AccountShare>();
        
        // Retrieve all Sales Area Record where OwnerDosentMatch__c formul Check box is True
        SalesAreaList = new List<DistributorSalesAreaMapping__c>([select id, name, AccountOwner__c,Distributor__c,AccountOwnerActive__c, CurrentAccountOwner__c, OwnerDosentMatch__c 
                                                                                                    from DistributorSalesAreaMapping__c 
                                                                                                    where OwnerDosentMatch__c = True AND (Sales_Org_Code__c='1000' OR Sales_Org_Code__c='1210')]);
        
         system.debug('Sales Area List ---> '+SalesAreaList);
         AccountFlagMap = new Map<String,String>(); 
         for(DistributorSalesAreaMapping__c  salesArea : SalesAreaList){
              system.debug('Inside For Loop');
              // One Account may have multiple Sales ARea records so check if Account is already shared if not then only share
                     if(AccountFlagMap.containsKey(String.valueof(salesArea.Distributor__c))){
                                          system.debug('Inside If Condition');                        
                     }
                // Create Account Share Record.     
                     else{
                         system.debug('Inside else Condition');                        
                           if(salesArea.AccountOwnerActive__c == True){
                                AccountShare ac = new AccountShare();
                                ac.UserOrGroupId = salesArea.AccountOwner__c;
                                ac.Rowcause ='Manual';
                                ac.AccountID = salesArea.Distributor__c;
                                ac.CaseAccessLevel='Read';
                                ac.AccountAccessLevel ='Read';
                                ac.OpportunityAccessLevel ='Read';
                                AccountShareList.add(ac);
                              // After Creation put it Account Value in Map so that next time Share Record should not be created.
                              AccountFlagMap.put(string.valueof(salesArea.Distributor__c),string.valueof(salesArea.AccountOwner__c));  
                             }
                     }
                    
                  
         }
         // Insert AccountSHareList
         if(AccountShareList.size()>0)
        insert AccountShareList;
    }
}