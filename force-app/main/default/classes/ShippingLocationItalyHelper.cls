public class ShippingLocationItalyHelper
{
    public static void updateOwnerToSL(List<Shipping_Location__c> lstSLoc)
    {
        Set<Id> stSLIds = new Set<Id>();
        Set<Id> accIdsDis = new Set<Id>();
        Map<Id,Account> accMap = new Map<Id,Account>();
        Boolean isRunOnce=false;
            for(Shipping_Location__c obSL : lstSLoc)
            {
                if(obSL.Sales_Org_Code__c == '2410' && obSL.Territory_Distributor__c != null && obSL.TerritoryManager__c != null && obSL.OwnerId != obSL.TerritoryManager__c)
                {
                    stSLIds.add(obSL.Id);
                    accIdsDis.add(obSL.Distributor__c);
                }
            }
            
            if(!accIdsDis.isEmpty()){
                for(Account acc : [SELECT ID FROM Account WHERE ID IN : accIdsDis ORDER BY ID]){
                    accMap.put(acc.Id, acc);
                }
            }
            Set<Id> SLTMIds = new Set<Id>();
            map<Account, Set<Id>> mapAccVsTMOwner = new map<Account, Set<Id>>();
            List<AccountTeamMember> ATMList= [SELECT id, userid from AccountTeamMember where accountid in :accIdsDis];
            List<id> UserIdsInATM = new List<id>();
            for(AccountTeamMember ATM : ATMList)
            {
                UserIdsInATM.add(ATM.userid);
            }
            
            List<ACcountTeamMember> lstATMTobeIns = new List<AccountTeamMember>();
            
            List<Shipping_Location__c> lstSL = [Select Id,Distributor__c,TerritoryManager__c,OwnerId, LastModifiedBy.Name from Shipping_Location__c where Id IN:stSLIds ORDER BY Distributor__c];
            System.debug('SLLList==>'+lstSL);
            if(lstSL.size() > 0)
            {
                for(Shipping_Location__c obSL : lstSL)
                {
                    obSL.OwnerId = obSL.TerritoryManager__c;
                    if(obSL.LastModifiedBy.Name.Contains(System.Label.ShippingLocationRelatedLabel))
                    {
                        obSL.Is_Updated_from_SAP__c = True;
                    }
                    SLTMIds.add(obSL.TerritoryManager__c);
                    mapAccVsTMOwner.put(accMap.get(obSL.Distributor__c),SLTMIds);
                    
                    if(!UserIdsInATM.contains(obSL.TerritoryManager__c))
                    {
                        AccountTeamMember TeamMemberAd=new AccountTeamMember();
                        TeamMemberAd.AccountId=obSL.distributor__c;
                        TeamMemberAd.UserId=obsl.TerritoryManager__c;
                        TeamMemberAd.TeamMemberRole = 'Territory Manager';
                        TeamMemberAd.AccountAccessLevel = 'Read';
                        lstATMTobeIns.add(TeamMemberAd);
                    }
                    
                    
                
                
                }
                //System.debug('mapAccVsTMOwner==>'+mapAccVsTMOwner);
                update lstSL;
                     System.debug('BINGOO==>'+lstATMTobeIns);
                    /*if(lstATMTobeIns.size() > 0)
                    {
                        insert lstATMTobeIns;
                    }*/
                
            }

    }
}