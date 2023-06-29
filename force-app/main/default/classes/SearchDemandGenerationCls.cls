/*******************************************************************************************
* @Name         DemandGeneration
* @Author       Amol Patil <amol.patil@skinternational.com>
* @Date         13/02/2023
* @Group        SKI
* @Description  This class contains method to Fetch related Contract ID & Budget balance of Demand Generation .
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0             Amol Patil         13/02/2023         Initial Creation                                                      
*******************************************************************************************/
public without sharing class SearchDemandGenerationCls {
    @AuraEnabled
    public static Rebate_Contract__c getSearchDemandGeneration(String racId) {
        system.debug('racId@@@:'+racId);
        if(racId !=null){
        ServiceHelper.getAuthentication(racId);
        }
        try {

            return [SELECT Name,Type__c,Start_Date__c,End_Date__c,(SELECT Id,Name,SAP_Document_Number__c,Distributor__r.Name,tolabel(Event_Type__c), Planned_Value__c, Actual_Budget__c,tolabel(Status__c),Sub_Status__c
                    FROM Demand_Generations__r) 
                    FROM Rebate_Contract__c
                    WHERE Name =:racId];
            
                } catch (Exception e) {
               System.debug('@@@@==>'+e);
               return null;
                }
    }   
}