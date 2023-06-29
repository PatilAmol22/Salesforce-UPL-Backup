/*
@Developer Name: Pranav Dinakaran
@Description: To delete share record  when Customer Region Mapping record is deleted
*/

trigger CustomerRegionMappingTrigger on Customer_and_Region_Mapping__c (before delete) {
  
  List<Territory_Distributor__c> TerrList = new List<Territory_Distributor__c>([select id, name, TerritoryManager__c
                                                                                                      from Territory_Distributor__c where TerritoryManager__c != Null ]);
  Map<String, String> TerritoryUserMap = new Map<String, String>();                                                                                                    
  for(Territory_Distributor__c t : TerrList){
      if( t.TerritoryManager__c != NULL){
          TerritoryUserMap.put(String.Valueof(t.id),String.Valueof(t.TerritoryManager__c));
      }
  }                                                                                                      
  Set<Id> AccountSet = new Set<Id>();
  List<AccountShare> deleteAccountShareList = new List<AccountShare>();
  List<WrapClass> wrapClassList = new List<WrapClass>();
  
  
    for(Customer_and_Region_Mapping__c  custReg: trigger.old){
              AccountSet.add(custReg.Customer_Name__c);
              if(TerritoryUserMap.containsKey(String.valueof(custReg.CustomerRegion__c))){
                  WrapClass wc = new WrapClass();
                  wc.Old_UserID = TerritoryUserMap.get(String.valueof(custReg.CustomerRegion__c));
                  wc.AccountID = String.valueof(custReg.Customer_Name__c);
                  wrapClassList.add(wc);
              }
        }
    List<AccountShare> AccountShareList = new List<AccountShare>([Select id, AccountID, UserOrGroupId,RowCause  
                                                                                            from AccountShare 
                                                                                            where AccountID in: AccountSet  
                                                                                            AND RowCause ='Manual']);
                                                                                            
                                                                                            
                                                                                            
    for(WrapClass w : WrapCLassList){
        for(AccountShare acs : AccountShareList){
            if(w.AccountID == String.valueof(acs.AccountID)  &&  w.Old_UserID ==  String.valueof(acs.UserOrGroupId)){
                deleteAccountShareList.add(acs);
            }
        }
    }
    
    if(deleteAccountShareList.size()>0)
        delete deleteAccountShareList;
    
    public class WrapClass{
     String Old_UserID;
     String AccountID; 
         public WrapCLass(){
             Old_UserID='';
            AccountID =''; 
         }
    }                                                                                        
}