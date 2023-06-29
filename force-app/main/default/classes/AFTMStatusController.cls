/*
     Class Name : AFTMStatusController
     Description : Controller for VF component for AF TM Status
     Author : Abhineet Kumar
     Date : 17/09/2022
 */
public class AFTMStatusController {
	public List<Territory_Distributor__c> terrTMStatusList {get;set;}
    public String zoneId {get;set;}
    
    public Boolean getAFTMStatusList() {
        String salesOrgCodeAF = System.Label.AF_Sales_Org_Code_Label;
        String salesOrgCodeNewAF = System.Label.New_AF_Sales_Org_Code_Label;
    	terrTMStatusList = [SELECT Id,Name,TerritoryCode__c,TerritoryManager__r.Name,UGDN__c FROM Territory_Distributor__c WHERE Zone__c = :zoneId AND Present_in_KEDE__c = true AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision')) ORDER BY Name Asc];
        if(terrTMStatusList.size()>0){
        	return true;
        }
        else return false;
    }
}