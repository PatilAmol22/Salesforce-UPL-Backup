public class atmTriggerHandler {
 public static void  shareSalesOrder(List<AccountTeamMember> newList){
     map<id,id> atmIdAcc = new map<id,id>();
     list<Sales_Order__share> shareList = new list<Sales_Order__share>();
	 map<id,list<Sales_Order__c>> soToATMAcc = new map<id,list<Sales_Order__c>>();
	 list<Sales_Order__c> listSo = new list<Sales_Order__c> ();
	 list<string> test = new list<string>();
     list<AccountTeamMember> toShareATM = new list<AccountTeamMember>();
     list<Sales_Order__c> salesOrderAcc = new list<Sales_Order__c>();
     Database.SaveResult[] shareInsertResult;
     
		for(AccountTeamMember ateam:newList)
		{
         atmIdAcc.put(ateam.id,ateam.accountId);
		}
		system.debug('**Map ATM ID to account  -> ' +atmIdAcc);
        
		
     if(atmIdAcc!=null && atmIdAcc.size()>0){
		toShareATM = [select id,AccountId,UserId from AccountTeamMember where Id IN: atmIdAcc.keySet() 
                         AND (account.Sales_Org_Code__c='5710' 
                              OR account.Sales_Org_Code__c='6451' 
                              OR account.Sales_Org_Code__c='6410') limit 49999];
        salesOrderAcc = [select id,Sold_to_Party__c,SalesOrgCode__c from Sales_Order__c where Sold_to_Party__c IN: atmIdAcc.values() 
                         AND (SalesOrgCode__c='5710'
                              OR SalesOrgCode__c='6451'
                              OR SalesOrgCode__c='6410') limit 49999];
         }
    
     system.debug('**Queried ATM -> ' +toShareATM);
     system.debug('**Queried SO -> ' +salesOrderAcc);
     
     if(salesOrderAcc!=null && salesOrderAcc.size()>0){
        for(Sales_Order__c sorders:salesOrderAcc){
		/*listSo.add(sorders);
		soToATMAcc.put(sorders.Sold_to_Party__c,listSo); */
        if(!soToATMAcc.containsKey(sorders.Sold_to_Party__c)){
           system.debug('**Inside If where no SO');
        soToATMAcc.put(sorders.Sold_to_Party__c, new List<Sales_Order__c>());
         }
        soToATMAcc.get(sorders.Sold_to_Party__c).add(sorders);
		}
     }
		system.debug('**#Map Of Account to SO -> ' +soToATMAcc);
        
     if(toShareATM.size()>0 && soToATMAcc.size()>0){
		for(AccountTeamMember aTMember:toShareATM){
		for(Sales_Order__c sorder:soToATMAcc.get(aTMember.AccountId)){
		Sales_Order__share shareSO = new Sales_Order__share();
		shareSO.ParentId = sorder.Id;
		shareSO.UserOrGroupId = aTMember.UserId ;
		shareSO.AccessLevel = 'Read';
		shareSO.RowCause = 'Manual';
		shareList.add(shareSO); 	   
        }
		}
     }
     
     if(shareList!=null && shareList.size()>0){
		shareInsertResult = Database.insert(shareList,false);
		system.debug('**share result -> ' +shareInsertResult);
     }
  }
    
 public static void  deleteShareSalesOrder(List<AccountTeamMember> oldList){
    list<Sales_Order__share> shareDelete = new list<Sales_Order__share>();
    map<id,id> userAccMap = new map<id,id>();
    set<id> atmIds = new set<id>();
    set<id> soIds = new set<id>();
    list<Sales_Order__share> sharedRecord = new list<Sales_Order__share>();
    Database.DeleteResult[] drList;

        for(AccountTeamMember accTM:oldList){
            atmIds.add(accTM.id);
         }
        system.debug('**list atmIds -> ' +atmIds);
        
        list<AccountTeamMember> toShareATM = [select id,AccountId,UserId from AccountTeamMember where Id IN: atmIds 
                                              AND (account.Sales_Org_Code__c='5710'
                                                   OR account.Sales_Org_Code__c='6451'
                                                   OR account.Sales_Org_Code__c='6410') limit 49999];		
        system.debug('**list toShareATM -> ' +toShareATM);
        
     if(toShareATM.size()>0){
        for(AccountTeamMember accountTM:toShareATM){
        userAccMap.put(accountTM.UserId,accountTM.AccountId);
         }
     }
        system.debug('**userAccMap -> ' +userAccMap);
		
        list<Sales_Order__c> listSO = [select id,Sold_to_Party__c,SalesOrgCode__c from Sales_Order__c where Sold_to_Party__c IN: userAccMap.values() 
                                       AND (SalesOrgCode__c='5710'
                                            OR SalesOrgCode__c='6451'
                                            OR SalesOrgCode__c='6410') limit 49999];
        system.debug('**listSO -> ' +listSO);
        
     if(listSO.size()>0){
        for(Sales_Order__c salesO:listSO){
        soIds.add(salesO.id);
         }
     }
        system.debug('**soIds set -> ' +soIds);
        
     if(soIds.size()>0 && userAccMap.size()>0){
         sharedRecord = [SELECT Id, ParentId, UserOrGroupId, RowCause FROM Sales_Order__share where UserOrGroupId IN:userAccMap.keySet() and ParentId IN:soIds];
          }
         
        if(sharedRecord.size()>0){
        for(Sales_Order__share sharedRec : sharedRecord)
        {
          shareDelete.add(sharedRec);
         }
        }
        system.debug('**shareDelete List -> ' +shareDelete);

        if(shareDelete.size()>0){
        drList = Database.delete(shareDelete, false);
        system.debug('**DeleteResult -> ' +drList);
         }
     }
}