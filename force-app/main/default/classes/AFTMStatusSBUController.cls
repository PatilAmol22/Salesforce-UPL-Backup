/*
Class Name : AFTMStatusSBUController
Description : Controller class for showing AF TM Status to SBU
Author : Bonny Mathews
Date : 05/08/2022
*/
public class AFTMStatusSBUController {
	public Map<String,List<Territory_Distributor__c>> terrTMStatusMap {get;set;}
    public String sbuCode {get;set;}
    
    public Boolean getAFTMStatusList() {
        terrTMStatusMap = new Map<String,List<Territory_Distributor__c>>();
        for(Territory_Distributor__c terr : [SELECT Id,Zone__r.Name,Name,TerritoryCode__c,TerritoryManager__r.Name,UGDN__c FROM Territory_Distributor__c WHERE SBU__r.SBUCode__c = :sbuCode AND Present_in_KEDE__c = true AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision')) ORDER BY Zone__r.Name,Name Asc]){
            if(terrTMStatusMap.containsKey(terr.Zone__r.Name)){
                terrTMStatusMap.get(terr.Zone__r.Name).add(terr);
            }else{
                terrTMStatusMap.put(terr.Zone__r.Name,new List<Territory_Distributor__c>{terr});
            }
        }

        if(!terrTMStatusMap.isEmpty()){
        	return true;
        }
        else return false;
    }
}