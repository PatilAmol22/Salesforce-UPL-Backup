/*
     Class Name : SWALTMStatusController
     Description : Controller for VF component for SWAL TM Status
     Author : Abhineet Kumar
     Date : 17/09/2022
 */
public class SWALTMStatusController {
    public List<Territory_Distributor__c> terrTMStatusList {get;set;}
    public String regionId {get;set;}
    
    public Boolean getSWALTMStatusList() {
    	terrTMStatusList = [SELECT Id,Name,TerritoryCode__c,TerritoryManager__r.Name,UGDN__c FROM Territory_Distributor__c WHERE Region__c = :regionId AND Present_in_KEDE__c = true AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision')) ORDER BY Name Asc];
        if(terrTMStatusList.size()>0){
        	return true;
        }
        else return false;
    }
    

}