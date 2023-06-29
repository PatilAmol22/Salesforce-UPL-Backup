/* 
Name : OrderDetailsController
Description : this class use to display order and contract details in HFX case console page
*/
public class OrderDetailsController {
    
     @AuraEnabled
    public static list<Contract> getContracts(String caseId){
        //system.debug('-->'+caseId);
        if(caseId != null){
            List<Case> accList = [SELECT Id, AccountId from case WHERE Id =: caseId ];
            String caseAccId = accList != null && accList.size()> 0 ? accList[0].accountId : null;
            if(caseAccId != null){
                List<Contract> contractList = [SELECT Id, contractNumber, status, ListingId__c 
                                               FROM contract 
                                               WHERE accountId =:caseAccId OR SellerAccount__c =: caseAccId ];
                return contractList != null && contractList.size() > 0 ? contractList : null;
            }
        }
        return null;
    }
	
    @AuraEnabled
    public static list<Order> getOrders(String caseId){ 
        //system.debug('-->>'+caseId);
        if(caseId != null){
            List<Case> accList = [SELECT Id, AccountId from case WHERE Id =: caseId ];
            String caseAccId = accList != null && accList.size()> 0 ? accList[0].accountId : null;
            system.debug('AccId-->>'+caseAccId);
            if(String.isNotBlank(caseAccId)){
                List<Order> orderList = [SELECT Id, orderNumber, Status, Stripe_Payment_Details__c 
                                            FROM Order WHERE ContractId != null AND 
                                            (AccountId = :caseAccId OR contract.SellerAccount__c =:caseAccId)];
                //system.debug('orderList-->'+orderList);
                return orderList.size() > 0 ? orderList : null;
            }
        }
        return null;
    }
}