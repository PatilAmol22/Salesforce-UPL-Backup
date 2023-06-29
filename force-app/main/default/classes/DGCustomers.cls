/*******************************************************************************************
* @Name         DGCustomers
* @Author       Prashant Kumbhar <prashant.kumbhar@skinternational.com>
* @Date         30/03/2023
* @Group        SKI
* @Description  This class contains methods related to Demand Generation to Fetch Customers.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Prashant         30/03/2023           Initial Creation                                                      
*******************************************************************************************/

public without sharing class DGCustomers {
    @AuraEnabled
    public static List<sObject> getdistributour(String rebateId) {
        String customer='';
        Set<sObject> distributor=new Set<sObject>();
        if(rebateId !=null){
         System.debug('Rebate Id is'+rebateId);   
         Set<Sub_Distributor__c>  dist=new Set<Sub_Distributor__c>([Select Distributor__c,Distributor__r.Name from Sub_Distributor__c where Rebate_Contract__c=:rebateId]);
        System.debug('distributor is'+dist);
         Set<Rebate_Contract__c> rebate=new Set<Rebate_Contract__c>([Select Distributor__c,Distributor__r.Name from Rebate_Contract__c where id=:rebateId]);
        System.debug('distributor is rebate'+rebate);
            
            if(dist !=null){
                for(sObject a:dist)
                {
                distributor.add(a);       
                }
            }
            if(rebate !=null){
                for(sObject r:rebate)
                {
                 distributor.add(r);
                }
            }   
        }
        List<sObject> cust=new List<sObject>(distributor);
        System.debug('Customer value is'+cust);
        return cust;
    }
    
   
}