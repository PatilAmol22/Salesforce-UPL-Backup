public class AccountTriggerHandler {
    // RITM0566084 (To Update Account Owner for NAM when Territory is changed) Added by GRZ (Nikhil Verma) 03-06-2023
    public static void updateAccountOwnerNAM(List<Account> newList, Map<Id,Account> oldMap){
        Set<Id> territoryIdSet = new Set<Id>();
        for(Account acc : newList){
            if(acc.Sales_Org_Code__c == '3100'  && acc.Territory_Distributor__c != null && oldMap.get(acc.Id).Territory_Distributor__c != acc.Territory_Distributor__c){
                territoryIdSet.add(acc.Territory_Distributor__c);
            }
        }
        if(territoryIdSet != null && !territoryIdSet.isEmpty()){
            Map<Id,Id> territoryToOwnerMap = new Map<Id,Id>();
            for(Territory_Distributor__c td : [SELECT Id,TerritoryManager__c FROM Territory_Distributor__c WHERE ID IN:territoryIdSet AND TerritoryManagerActive__c = true AND Sales_Org_Code__c = '3100']){
                territoryToOwnerMap.put(td.Id, td.TerritoryManager__c);
            }
            if(territoryToOwnerMap != null){
                for(Account acc : newList){
                    if(acc.Sales_Org_Code__c == '3100'  && acc.Territory_Distributor__c != null && oldMap.get(acc.Id).Territory_Distributor__c != acc.Territory_Distributor__c && territoryToOwnerMap.containsKey(acc.Territory_Distributor__c)){
                        acc.OwnerId = territoryToOwnerMap.get(acc.Territory_Distributor__c);
                    }
                }
            }
        }
    }
    public static void updateSalesArea(List<Account> newList, Map<Id,Account> oldMap){
        set<Id> devisionSet= new set<Id>();
        set<Id> distributionSet= new set<Id>();
        set<Id> accId= new set<Id>();
        map<Id,Account> accMap= new Map<Id,Account>();
        for(Account acc : newList){
            accId.add(acc.Id);
        }
        list<Account> accList= [select id,Distribution_Channel__c,Division__c ,Payment_Term_Code__c from account Where id in:
                                accId  FOR UPDATE ];
        if(accList.size()>0){
            for(Account acc : newList){
                if(acc.Sales_Org_Code__c == '7110'){
                    if(acc.Division__c!=null && acc.Distribution_Channel__c!=null && oldMap.get(acc.Id).Payment_Term_Code__c != acc.Payment_Term_Code__c 
                       && acc.Account_Type__c=='Sold To Party'){
                           devisionSet.add(acc.Division__c);
                           distributionSet.add(acc.Distribution_Channel__c);
                           accMap.put(acc.Id,acc);
                       }
                }
                system.debug('devisionSet:'+devisionSet);
                system.debug('devisionSetSize:'+devisionSet.size());
                system.debug('distributionSet:'+distributionSet);
                system.debug('accMap:'+accMap);
                list<DistributorSalesAreaMapping__c> salesAreaList= new list<DistributorSalesAreaMapping__c>();
                if(devisionSet!=null && distributionSet!=null && accId!=null){
                    for(DistributorSalesAreaMapping__c dsm:[select id,name,Division__c,Distributor__c,DistributionChannel__c,Payment_Term__c 
                                                            from DistributorSalesAreaMapping__c where Distributor__c IN:accMap.keyset()
                                                            and Division__c IN:devisionSet and DistributionChannel__c IN:distributionSet ]){
                                                                if(accMap.containsKey(dsm.Distributor__c)){
                                                                    dsm.Payment_Term__c=accMap.get(dsm.Distributor__c).Payment_Term_Code__c;
                                                                    salesAreaList.add(dsm);     
                                                                }
                                                            }
                    system.debug('salesAreaList:'+salesAreaList);
                    system.debug('size:'+salesAreaList.size());
                    if(salesAreaList.size()>0){
                        update salesAreaList;
                    }
                }
            }
        }
    }
    
    /*
    * Description: Farmer first Implementation Project - Stamp the Expiry Date based on Gold or Silver selection.
	* Param: newAccountList
	* Param: oldAccountMap
    * Param: isInsert, isUpdate
	* return : void
    * */
    public static void caputureExpiryDate(List<Account> newAccountList, Map<Id,Account> oldAccountMap,Boolean isInsert,Boolean isUpdate){
        if(isInsert){
            for(Account acc:newAccountList){
                if(acc.RecordTypeId.equals(UPLConstantClass.farmerRecordTypeId)
                   || acc.RecordTypeId.equals(UPLConstantClass.preRegisteredfarmerRTId)                   
                   || acc.RecordTypeId.equals(UPLConstantClass.unRegisteredFarmerRetailerRTId)){
                       if(String.isNotBlank(acc.Subscription_type__c)){
                           if(acc.Subscription_type__c.equalsIgnoreCase('Gold')){
                               acc.Expiry_date__c=system.today().addDays(90);
                           }
                           if(acc.Subscription_type__c.equalsIgnoreCase('Silver')){
                               acc.Expiry_date__c=system.today().addDays(30);
                           }
                           if(acc.Subscription_Start_Date__c==null){
                               acc.Subscription_Start_Date__c=system.today();
                           }    
                           system.debug('acc.Expiry_date__c :'+acc.Expiry_date__c);
                           system.debug('acc.Subscription_Start_Date__c :'+acc.Subscription_Start_Date__c);
                       }   
                   }
            }
        }
        
        
        if(isUpdate){
            for(Account acc:newAccountList){
                if(acc.RecordTypeId.equals(UPLConstantClass.farmerRecordTypeId)
                   || acc.RecordTypeId.equals(UPLConstantClass.preRegisteredfarmerRTId)                   
                   || acc.RecordTypeId.equals(UPLConstantClass.unRegisteredFarmerRetailerRTId)){
                       if((acc.Subscription_type__c != oldAccountMap.get(acc.Id).Subscription_type__c) && String.isNotBlank(acc.Subscription_type__c)){
                           if(acc.Subscription_type__c.equalsIgnoreCase('Gold')){
                               acc.Expiry_date__c=system.today().addDays(90);
                           }
                           if(acc.Subscription_type__c.equalsIgnoreCase('Silver')){
                               acc.Expiry_date__c=system.today().addDays(30);
                           }
                           if(acc.Subscription_Start_Date__c==null){
                               acc.Subscription_Start_Date__c=system.today();
                           }  
                       }
                       system.debug('acc.Expiry_date__c in update :'+acc.Expiry_date__c);  
                       system.debug('acc.Subscription_Start_Date__c :'+acc.Subscription_Start_Date__c);
                   }
            }
        }
    }
}