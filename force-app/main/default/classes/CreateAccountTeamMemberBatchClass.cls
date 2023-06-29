public class CreateAccountTeamMemberBatchClass implements Database.batchable<sObject>{ 

    public Database.QueryLocator start(Database.BatchableContext BC){
        String Query='select Id,Sales_Org__c,Distributor__r.PriceGroupCode__c,Distributor__r.Distribution_Channel__c,Distributor__r.Division__c,Is_Updated_from_SAP__c,distributor__c,TerritoryManager__c from Shipping_Location__c where Is_Updated_from_SAP__c=true';
       return Database.getQueryLocator(query);
    }     
    public void execute(Database.BatchableContext info, List<Shipping_Location__c> scope){
       System.debug('BINGOO=>>'+scope);      
       Set<Id> accIdsDis = new Set<Id>();
       Set<Id> shippingLocationIds = new Set<Id>();
        for(Shipping_Location__c obSP : scope)
        {    
            accIdsDis.add(obSP.distributor__c);
            shippingLocationIds.add(obSP.Id);
        }
       List<DistributorSalesAreaMapping__c> SalesAreaListToBeDeleted = [Select Id from DistributorSalesAreaMapping__c where Shipping_Location__c IN:shippingLocationIds AND Manually_Created__c = true];
       List<DistributorSalesAreaMapping__c> SalesAreaListToBeInserted = new List<DistributorSalesAreaMapping__c>();
       List<ACcountTeamMember> lstATMTobeInsUnique = new List<AccountTeamMember>();
       List<ACcountTeamMember> lstATMTobeIns = new List<AccountTeamMember>();
       map<Account, Set<Id>> mapAccVsTMOwner = new map<Account, Set<Id>>();
         List<AccountTeamMember> ATMList= [SELECT id, userid from AccountTeamMember where accountid in :accIdsDis];
         List<id> UserIdsInATM = new List<id>();
         for(AccountTeamMember ATM : ATMList)
         {
             UserIdsInATM.add(ATM.userid);
         }
         
       for(Shipping_Location__c obSP : scope)
       {
            obSP.Is_Updated_from_SAP__c = false;
            if(!UserIdsInATM.contains(obSP.TerritoryManager__c))
             {
               AccountTeamMember TeamMemberAd=new AccountTeamMember();
               TeamMemberAd.AccountId=obSP.distributor__c;
               TeamMemberAd.UserId=obSP.TerritoryManager__c;
               TeamMemberAd.TeamMemberRole = 'Territory Manager';
               TeamMemberAd.AccountAccessLevel = 'Read';
               lstATMTobeIns.add(TeamMemberAd);
             }
             
             DistributorSalesAreaMapping__c obSalesArea = new DistributorSalesAreaMapping__c();
             obSalesArea.AccountOwner__c = obSP.TerritoryManager__c;
             obSalesArea.DistributionChannel__c = obSP.Distributor__r.Distribution_Channel__c;
             obSalesArea.Distributor__c = obSP.distributor__c;
             obSalesArea.Division__c = obSP.Distributor__r.Division__c;
             obSalesArea.Manually_Created__c = true;
             obSalesArea.PriceGroupMaster__c = obSP.Distributor__r.PriceGroupCode__c;
             obSalesArea.SalesOrg__c = obSP.Sales_Org__c;
             obSalesArea.Shipping_Location__c = obSP.Id;
             SalesAreaListToBeInserted.add(obSalesArea);
           
       }
       if(ATMList.size() > 0)
       {
           delete ATMList; 
       }
       if(SalesAreaListToBeDeleted.size() > 0)
       {
           delete SalesAreaListToBeDeleted;
       }
       Set<AccountTeamMember> stATMTemp = new Set<AccountTeamMember>();
       stATMTemp.addAll(lstATMTobeIns);
       lstATMTobeInsUnique.addAll(stATMTemp);
       if(lstATMTobeInsUnique.size() > 0)
       {
           insert lstATMTobeInsUnique;
       }
       if(SalesAreaListToBeInserted.size() > 0)
       {
           insert SalesAreaListToBeInserted;
       }
       update scope;
   }     
    public void finish(Database.BatchableContext info){     
    } 
 }