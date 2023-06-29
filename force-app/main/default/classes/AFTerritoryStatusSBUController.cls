/*
Class Name : AFTerritoryStatusSBUController
Description : Controller class for showing AF Territory Status to SBU
Author : Bonny Mathews
Date : 05/08/2022
*/
public class AFTerritoryStatusSBUController {
	public Map<String,List<territoryStatusWrap>> terrStatusWrapMap {get;set;}
    public String sbuCode {get;set;}
    public String liqMnth {get;set;}
    
    public Boolean getAFTerritoryStatusSBUList() {
        terrStatusWrapMap = new Map<String,List<territoryStatusWrap>>();
        String liqMonth;
        String fisYear;
        //Populate Month Map
        MAP<Integer,String> monthMap = new MAP<Integer,String>();
        monthMap.put(4,'Apr');
        monthMap.put(5,'May');
        monthMap.put(6,'Jun');
        monthMap.put(7,'Jul');
        monthMap.put(8,'Aug');
        monthMap.put(9,'Sept');
        monthMap.put(10,'Oct');
        monthMap.put(11,'Nov');
        monthMap.put(12,'Dec');
        monthMap.put(1,'Jan');
        monthMap.put(2,'Feb');
        monthMap.put(3,'Mar');

        Integer curMonth = Date.Today().Month();
        if(curMonth >= 2 && curMonth <= 12){
            liqMonth = monthMap.get(curMonth-1);
        }else if(curMonth == 1){
            liqMonth = monthMap.get(curMonth+11);
        }
        liqMnth = liqMonth;
        String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
        if(curMonth == 4){
            Integer fiscalyr = Integer.valueOf(currentFiscalYear)-2;
            fisYear = String.valueOf(fiscalyr)+'-'+String.valueOf(Integer.valueOf(currentFiscalYear)-1);
        }else{
            Integer fiscalyr = Integer.valueOf(currentFiscalYear)-1;
            fisYear = String.valueOf(fiscalyr)+'-'+currentFiscalYear;
        }

        //Querying territory status
        for(Territory_Distributor__c terr : [SELECT Id,Name,TerritoryCode__c,Zone__r.Name, (SELECT Approval_Status__c FROM Liquidations_Approval_History__r WHERE Month__c = :liqMonth  AND LAP_Fiscal_Year__c = :fisYear) FROM Territory_Distributor__c WHERE SBU__r.SBUCode__c = :sbuCode AND Present_in_KEDE__c = true AND (NOT (Name LIKE 'CIL%' OR Name LIKE 'SAIB%' OR Name LIKE 'Vector%' OR Name LIKE '%-b' OR Name LIKE '%- b' OR Name LIKE '%Provision')) ORDER BY Zone__r.Name,Name Asc]){
            territoryStatusWrap terrWrap = new territoryStatusWrap();
            terrWrap.territoryName = terr.Name;
            terrWrap.territoryCode = terr.TerritoryCode__c;
            if(terr.Liquidations_Approval_History__r.size() > 0){
                terrWrap.status = terr.Liquidations_Approval_History__r[0].Approval_Status__c;
            }else{
                terrWrap.status = 'Not Started';
            }
            
            if(terrStatusWrapMap.containsKey(terr.Zone__r.Name)){
                terrStatusWrapMap.get(terr.Zone__r.Name).add(terrWrap);
            }else{
                terrStatusWrapMap.put(terr.Zone__r.Name,new List<territoryStatusWrap>{terrWrap});
            }
        }
        return true;
    }
    
    //wrapper class
    public class territoryStatusWrap {
        public String territoryName {get;set;}
        public String territoryCode {get;set;}
        public String status {get;set;}
    }
}