/*
Created On : 9th August 2018
Developer: Ketan Khatri
Description: The Class which will be called from process builder to assign and share credit info record with Customer Region Mapping Users
Last Stable backup : CreditInfo_Share_Brazil_V2.0 
*/

global without sharing class CreditInfo_Share_Brazil {
    
    @InvocableMethod
    global static void assignNshare(List<String> CredInfoID){ 
        System.debug('Inside Invokable assignNshare Method');
        
        Account Acc = new Account(); 
        Credit_Info__c ci = new Credit_Info__c();
        
        Set<Id> accIdSet = new Set<Id>();
        
        List<Customer_and_Region_Mapping__c> crmList = new List<Customer_and_Region_Mapping__c>();
        List<Credit_Info__Share> ciShare = new List<Credit_Info__Share>(); 
        List<Credit_Info__c> ciList = new List<Credit_Info__c>(); 
        List<Credit_Info__c> ciUpdateList = new List<Credit_Info__c>(); 
        List<Account> accList = new List<Account>();
        
        Map<String,List<Customer_and_Region_Mapping__c>> crmMap = new Map<String,List<Customer_and_Region_Mapping__c>>();
        Map<String,List<Credit_Info__c>> creditInfoMap = new Map<String,List<Credit_Info__c>>();
        
        try{
            ciList = [SELECT Id, Distributor__c FROM Credit_Info__c WHERE ID in :CredInfoID];
            
            List<Credit_Info__c> ciTempList;
            
            for(Credit_Info__c ciObj : ciList ){   //To populate credit info map with Distributor ID as key.
                
                accIdSet.add(ciObj.Distributor__c); //to fetch accounts and their CRM records
                
                if(creditInfoMap.containsKey(ciObj.Distributor__c)){ //If contains key,the get the list and add one more credInfo to that list
                    ciTempList = new List<Credit_Info__c>();
                    ciTempList = creditInfoMap.get(ciObj.Distributor__c);
                    ciTempList.add(ciObj);
                    creditInfoMap.put(ciObj.Distributor__c,ciTempList);
                }
                
                else{
                    ciTempList = new List<Credit_Info__c>();
                    ciTempList.add(ciObj);
                    creditInfoMap.put(ciObj.Distributor__c,ciTempList);                    
                }
            }
            
            
           /* for(Credit_Info__c ciObj :ciList){
               accIdSet.add(ciObj.Distributor__c); 
            }*/
            
            accList = [SELECT Id, Name,(SELECT Id, Customer_Name__c, Active__c, SAP_Code__c, CustomerRegion__c
                       FROM Customers_and_Region_Mapping__r)
                       FROM Account WHERE Id in : accIdSet ];
            
            crmList = [SELECT Id, Customer_Name__c, Active__c, SAP_Code__c, CustomerRegion__c,
                       CustomerRegion__r.TerritoryManager__c FROM Customer_and_Region_Mapping__c 
                       WHERE Customer_Name__c in : accIdSet ];
            
            for(Account ac:accList){ //To populate customer region mapping MAP with Distributor ID as Key again.
                
                List<Customer_and_Region_Mapping__c> crmTempList;
                for(Customer_and_Region_Mapping__c crmObj :crmList){
                    if(ac.Id == crmObj.Customer_Name__c ){
                        if(crmMap.containsKey(ac.Id)){
                        crmTempList  = new List<Customer_and_Region_Mapping__c>();   
                        crmTempList = crmMap.get(ac.Id);
                            
                        crmTempList.add(crmObj);
                        crmMap.put(ac.Id,crmTempList);    
                        }
                        
                        else{
                        
                        crmTempList  = new List<Customer_and_Region_Mapping__c>();
                        crmTempList.add(crmObj);
                        crmMap.put(ac.Id,crmTempList); 
                            
                        }
                    }
                }
            }
            
                 List<Credit_Info__c> ciTempLst;
                 List<Customer_and_Region_Mapping__c> crmTempList;
            
            //Logic for changing Owner and Sharing Record
            
             for(String ciKey : creditInfoMap.keySet()){
                  
                 ciTempLst = creditInfoMap.get(ciKey);
                 for(Credit_Info__c ciObj : ciTempLst){
                 if(crmMap.containsKey(ciKey)){
                     crmTempList = new List<Customer_and_Region_Mapping__c>();
                     crmTempList = crmMap.get(ciKey);
                     
                     //If account has only 1 CRM record then change owner
                     if(crmTempList.size()==1){ 
                         System.debug('Inside If --> '+ci);
                         ciObj.OwnerId = crmTempList[0].CustomerRegion__r.TerritoryManager__c;
                         if(ciObj.OwnerId != null)
                         ciUpdateList.add(ciObj);               
                     }
					//If account has multiple CRM records then make first one the owner and share record with others            
                     else{
                         System.debug('Inside else 1 --> '+crmList.size());
                         for(integer i=0; i<crmTempList.size();i++){
                             if(i==0){
                                 System.debug('Inside if 2  --> '+crmList.size());
                                 ciObj.OwnerId = crmTempList[i].CustomerRegion__r.TerritoryManager__c;
                                 if(ciObj.OwnerId != null)
                                 ciUpdateList.add(ciObj);
                             }
                             else{
                                 System.debug('Inside else 2 Sharing logic --> '+crmList.size());
                                 Credit_Info__Share cis = new Credit_Info__Share();
                                 cis.ParentId = ciObj.Id;
                                 cis.AccessLevel = 'Read';
                                 cis.UserOrGroupId  = crmTempList[i].CustomerRegion__r.TerritoryManager__c;                                 
                                 cis.RowCause = 'Manual';
                                 if(cis.UserOrGroupId != null)
                                 ciShare.add(cis);
                             }
                         }                         
                     } 
                 }
                 
                 
                 
                 }
            }
          
            if(ciUpdateList.size()>0){
			update ciUpdateList;      
            }
            
            if(ciShare.size()>0){
            upsert ciShare;
            }
            
            
        }
        catch(Exception ex){
            System.debug('Line Number ---> '+ ex.getLineNumber());
            System.debug('Error Message ---> '+ ex.getMessage());
        }

}
}