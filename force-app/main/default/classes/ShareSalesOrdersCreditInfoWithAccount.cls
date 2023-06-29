/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This apex is used for Sharing Account, Sales orders and credit info with key Account manager
*
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Swapnil More   <swapnil.more@in.ibm.com>
* @modifiedBy     Swapnil More   <swapnil.more@in.ibm.com>
* @maintainedBy   Swapnil More   <swapnil.more@in.ibm.com>
* @version        1.0
* @created        2020-02-21
* @modified       2020-02-21
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
*                 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
global without sharing class ShareSalesOrdersCreditInfoWithAccount {
    @InvocableMethod
    public static void GrantRemoveAccess(list<WrapperInputParameters> LiWrapper){
        try{
        list<accountShare> AccShareDelete = new list<accountShare>();
        list<accountShare> AccShareInsert = new list<accountShare>();
            //Sales Order
        list<Sales_Order__Share> SOSDelete = new list<Sales_Order__Share>();
        list<Sales_Order__Share> liSOShare = new list<Sales_Order__Share>();
            //Credit Info
        List<Credit_Info__c> liCI = new List<Credit_Info__c>();
        list<Credit_Info__Share> CISDelete = new List<Credit_Info__Share>();
        list<Credit_Info__Share> liCIShare = new list<Credit_Info__Share>();
            //Invoice
        list<Invoice__Share> InvDelete = new list<Invoice__Share>();
        list<Invoice__Share> InvShare = new list<Invoice__Share>();
            
        Map<id,OldNewKAM> mapAccOldNewKAM = new Map<id,OldNewKAM>();
        
        set<Id> setaccountIds = new set<Id>();
        for(WrapperInputParameters Wrapper: LiWrapper){
            OldNewKAM O = new OldNewKAM();
            O.OldKAM = Wrapper.OldKAM;
            O.NewKAM = Wrapper.NewKAM;
            mapAccOldNewKAM.put(Wrapper.AccId, O);
        }
        
        //Delete existing account share instance related to old KAM
        List<accountShare> LiaccShare = [select id, AccountId, UserOrGroupId, AccountAccessLevel, 
                                         OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel, RowCause, LastModifiedDate, LastModifiedById, IsDeleted 
                                         FROM AccountShare where RowCause = 'Manual' and AccountId in :mapAccOldNewKAM.keyset()
                                         and AccountAccessLevel = 'Read' and OpportunityAccessLevel = 'Read' and 
                                         CaseAccessLevel = 'Read' and ContactAccessLevel = 'Read'];
        //map of accounts
        Map<id,Account> mapAccount = new Map<id,Account>([select id,ownerId from Account 
                                                          where id in :mapAccOldNewKAM.keyset()]);
        for(accountShare AccS: LiaccShare){
           if(string.isNotBlank(mapAccOldNewKAM.get(AccS.AccountId).OldKAM) && string.isNotBlank(AccS.UserOrGroupId)){
            if(mapAccOldNewKAM.get(AccS.AccountId).OldKAM == AccS.UserOrGroupId){
                AccShareDelete.add(AccS);
            }
            }
        }
      
        //Delete existing Sales order share instance related to old KAM
        map<id,Sales_Order__c> MapSO = new map<id,Sales_Order__c>([select id,Sold_to_Party__c from Sales_order__c
                                                                   where Sold_to_Party__c in :mapAccOldNewKAM.keyset()]);
        
        for(Sales_Order__Share SO: [SELECT UserOrGroupId, RowCause, ParentId, LastModifiedDate, 
                                    LastModifiedById, IsDeleted, Id, AccessLevel 
                                    FROM Sales_Order__Share where ParentId in :MapSO.keySet()
                                    and RowCause = 'Sharing_with_KAK__c' and AccessLevel = 'Read']){
                                       
                                        if(string.isNotBlank(mapAccOldNewKAM.get(MapSO.get(SO.ParentId).Sold_to_Party__c).OldKAM)
                                           && string.isNotBlank(SO.UserOrGroupId)){                              
                                               if(mapAccOldNewKAM.get(MapSO.get(SO.ParentId).Sold_to_Party__c).OldKAM == SO.UserOrGroupId){
                                                   SOSDelete.add(SO);
                                               }
                                           }
                                        
                                    }
        
        //Delete existing Credit Info share instance related to old KAM
        map<id,Credit_Info__c> MapCI = new map<id,Credit_Info__c>([select id,Distributor__c from Credit_Info__c
                                                                   where Distributor__c in :mapAccOldNewKAM.keyset()]);
        
        for(Credit_Info__Share CI: [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause, 
                                    LastModifiedDate, LastModifiedById, IsDeleted 
                                    FROM Credit_Info__Share where ParentId in :MapCI.keySet()
                                    and RowCause = 'Share_with_KAM__c' and AccessLevel = 'Read']){
                                        if(string.isNotBlank(mapAccOldNewKAM.get(MapCI.get(CI.ParentId).Distributor__c).OldKAM)
                                           && string.isNotBlank(CI.UserOrGroupId)){
                                               if(mapAccOldNewKAM.get(MapCI.get(CI.ParentId).Distributor__c).OldKAM == CI.UserOrGroupId){
                                                   CISDelete.add(CI);
                                               }
                                           }
                                        
                                    }
            
        //Delete existing Invoice share instance related to old KAM
        map<id,Invoice__c> MapINV = new map<id,Invoice__c>([select id,Sold_to_Party__c from Invoice__c
                                                                   where Sold_to_Party__c in :mapAccOldNewKAM.keyset()]);
        
        for(Invoice__Share INVS: [SELECT UserOrGroupId, RowCause, ParentId, LastModifiedDate, 
                                    LastModifiedById, IsDeleted, Id, AccessLevel 
                                    FROM Invoice__Share where ParentId in :MapINV.keySet()
                                    and RowCause = 'Sharing_with_KAM__c' and AccessLevel = 'Read']){
                                       
                                        if(string.isNotBlank(mapAccOldNewKAM.get(MapINV.get(INVS.ParentId).Sold_to_Party__c).OldKAM)
                                           && string.isNotBlank(INVS.UserOrGroupId)){                              
                                               if(mapAccOldNewKAM.get(MapINV.get(INVS.ParentId).Sold_to_Party__c).OldKAM == INVS.UserOrGroupId){
                                                   InvDelete.add(INVS);
                                               }
                                           }
                                        
                                    }
        
       
        for(WrapperInputParameters Wrapper: LiWrapper){
            //if NewKAM is blank then do not share account record
            if(string.isNotBlank(Wrapper.NewKAM) && string.isNotBlank(mapAccount.get(Wrapper.AccId).OwnerId)){
            if(mapAccount.get(Wrapper.AccId).OwnerId != Wrapper.NewKAM){
            //Account sharing with KAM
            
            if(!string.isBlank(Wrapper.NewKAM)){
                Accountshare AccShare = new AccountShare();
                AccShare.AccountId = Wrapper.AccId;
                AccShare.UserOrGroupId = Wrapper.NewKAM;
                AccShare.AccountAccessLevel = System.Label.KAMAcess;//Edit
                AccShare.CaseAccessLevel = System.Label.KAMAcess;//'Read';
                AccShare.ContactAccessLevel = System.Label.KAMAcess;
                AccShare.OpportunityAccessLevel = System.Label.KAMAcess;
                //insert AccShare;
                AccShareInsert.add(AccShare);
            }
            }
            } 
        }
            
        //Sales Order sharing with KAM
        for (Sales_Order__c SO: MapSO.values()){
            if(string.isNotBlank(mapAccOldNewKAM.get(SO.Sold_to_Party__c).NewKAM)){
               
                Sales_Order__Share SOSAdd = new Sales_Order__Share();
                SOSAdd.parentId = SO.Id;
                SOSAdd.userorgroupId = mapAccOldNewKAM.get(SO.Sold_to_Party__c).NewKAM;
                SOSAdd.Accesslevel = System.Label.KAMAcess;
                SOSAdd.RowCause = Schema.Sales_order__Share.RowCause.Sharing_with_KAK__C;
                liSOShare.add(SOSAdd) ;
                }
            
        }
            
            //Invoice sharing with KAM
        for (Invoice__c INV: MapINV.values()){
            if(string.isNotBlank(mapAccOldNewKAM.get(INV.Sold_to_Party__c).NewKAM)){
               
                Invoice__Share INVAdd = new Invoice__Share();
                INVAdd.parentId = INV.Id;
                INVAdd.userorgroupId = mapAccOldNewKAM.get(INV.Sold_to_Party__c).NewKAM;
                INVAdd.Accesslevel = System.Label.KAMAcess;
                INVAdd.RowCause = Schema.Invoice__Share.RowCause.Sharing_with_KAM__c;
                InvShare.add(INVAdd) ;
                }
            
        }
        
        
        //Crredit information sharing with KAM
        for (Credit_Info__c SO: MapCI.values()){
            
            if(string.isNotBlank(mapAccOldNewKAM.get(SO.Distributor__c).NewKAM)){  
                Credit_Info__Share SOSAdd = new Credit_Info__Share();
                SOSAdd.parentId = SO.Id;
                SOSAdd.userorgroupId = mapAccOldNewKAM.get(SO.Distributor__c).NewKAM;
                SOSAdd.Accesslevel = System.Label.KAMAcess;
                SOSAdd.RowCause = Schema.Credit_Info__Share.RowCause.Share_with_KAM__C;
                liCIShare.add(SOSAdd) ;
            }
        }
        
        
        //deleting exisitng account share object
        if(AccShareDelete.size()>0){
            delete AccShareDelete;
        } 
        //Inserting account share object
        if(AccShareInsert.size()>0){
            insert AccShareInsert;
        } 
           
        //deleting existing sales order share
        if(SOSDelete.size()>0){
            delete SOSDelete;
        }
        //Inserting Invoice share object
        if(InvShare.size()>0){
            insert InvShare;
        } 
        //deleting existing Invoice share
        if(InvDelete.size()>0){
            delete InvDelete;
        }
        //inserting sales order share
        if(liSOShare.size()>0){
            insert liSOShare;
        }
        //deleting credit info sharing
        if(CISDelete.size()>0){
            delete CISDelete;
        }
        //insert credit info share 
        if(liCIShare.size()>0){
            insert liCIShare;
        }
        }
        catch(Exception E){
            System.debug('Exception occured ... '+e.getLineNumber());  
        }
        
        
    }
    
    global class WrapperInputParameters {
        @InvocableVariable
        global ID AccId;
        @InvocableVariable
        global String OldKAM;
        @InvocableVariable
        global String NewKAM;
        
    }
    
    public class OldNewKAM {
        public String OldKAM;
        Public String NewKAM;
    }
    
}