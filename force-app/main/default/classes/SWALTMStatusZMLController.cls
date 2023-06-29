/*
Class Name : SWALTMStatusZMLController
Description : Controller class for showing SWAL TM Status to ZML
Author : Bonny Mathews
Date : 05/08/2022
*/
public class SWALTMStatusZMLController {
	public Map<String,List<Territory_Distributor__c>> terrTMStatusMap {get;set;}
    public String zoneCode {get;set;}
    
    public Boolean getSWALTMStatusList() {
        terrTMStatusMap = new Map<String,List<Territory_Distributor__c>>();
        for(Territory_Distributor__c terr : [SELECT Id,Region__r.Name,Name,TerritoryCode__c,TerritoryManager__r.Name,UGDN__c FROM Territory_Distributor__c WHERE Zone__r.ZoneCode__c = :zoneCode AND Present_in_KEDE__c = true AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision')) ORDER BY Region__r.Name,Name Asc]){
            if(terrTMStatusMap.containsKey(terr.Region__r.Name)){
                terrTMStatusMap.get(terr.Region__r.Name).add(terr);
            }else{
                terrTMStatusMap.put(terr.Region__r.Name,new List<Territory_Distributor__c>{terr});
            }
        }

        if(!terrTMStatusMap.isEmpty()){
        	return true;
        }
        else return false;
    }
}