//// UPL-2-I386: Modified by:Ankita Saxena Changes in Travel request  for Indonesia
global with sharing class IndonesiaTravelExpenseSummaryController {
    global String mte_id{get;set;} 
    
    
    global list<Expense_Item__c> eiList{
        get{
            try{
            eiList = [SELECT id, Name, CreatedBy.Name, CreatedBy.TM_Code__c, CreatedBy.Territory__c,Item__c, Date__c,Purpose__c,Month__c, Location__c, Amount__c, Remarks__c,Monthly_Travel_Expenses__r.status__c, Monthly_Travel_Expenses__r.RM_status__c,Monthly_Travel_Expenses__r.NSM_status__c,Monthly_Travel_Expenses__r.NMM_status__c,Monthly_Travel_Expenses__r.CH_status__c,Monthly_Travel_Expenses__r.RegionalManager__r.name,Monthly_Travel_Expenses__r.NationalSalesManager__r.name,Monthly_Travel_Expenses__r.CountryHead__r.name,Item_Limit__c FROM Expense_Item__c where Monthly_Travel_Expenses__c =:mte_id]; 
            return eiList;
            }catch(exception e){
                return null;
            }
        }set;
    }
    global Integer sum{
        get{
            list<Expense_Item__c> eiList1 = [SELECT id, Name, CreatedBy.Name, CreatedBy.TM_Code__c, 
                                             CreatedBy.Territory__c,Item__c, Date__c,Purpose__c,Month__c, Location__c, 
                                             Amount__c, Remarks__c,Monthly_Travel_Expenses__r.status__c, Monthly_Travel_Expenses__r.RM_status__c,
                                             Monthly_Travel_Expenses__r.NSM_status__c,Monthly_Travel_Expenses__r.NMM_status__c,Monthly_Travel_Expenses__r.CH_status__c,Monthly_Travel_Expenses__r.RegionalManager__r.name,Monthly_Travel_Expenses__r.NationalSalesManager__r.name,Monthly_Travel_Expenses__r.CountryHead__r.name,Item_Limit__c FROM Expense_Item__c where Monthly_Travel_Expenses__c =:mte_id]; 
        integer temp = 0;
        for(Expense_Item__c eiObj  : eiList1){
            if(eiObj.Amount__c != null)
                temp = temp +Integer.valueof(eiObj.Amount__c); 
            //Sum =  sum +Integer.valueof(eiObj.Amount__c);  
        }
            return temp;
        }
        set;
    }
    global Map<string, decimal> activityAmountMap{
        get{
            activityAmountMap = new Map<String, decimal>();
        	for(Expense_Item__c eiObj  : eiList){
                if(activityAmountMap != null && activityAmountMap.keySet() != null && activityAmountMap.containsKey(eiObj.Item__c) && activityAmountMap.get(eiObj.Item__c) != null){
                    decimal amtMap = eiObj.amount__c + activityAmountMap.get(eiObj.Item__c);
                    system.debug('amtMap -->' +amtMap);
                    activityAmountMap.put(eiObj.Item__c,amtMap);
                        
                }
                else{
                    activityAmountMap.put(eiObj.Item__c,eiObj.Amount__c);
                }
            } 
            return activityAmountMap;
        }set;}
    
    global Map<string, String> activityLimitMap{
        get{
            activityLimitMap = new Map<String, String>();
        	for(Expense_Item__c eiObj  : eiList){
                activityLimitMap.put(eiObj.Item__c,eiObj.Item_Limit__c);
            } 
            return activityLimitMap;
        }set;}
    
    global set<String> keys{
        get{
           if(activityAmountMap != null && activityAmountMap.keySet() != null)
            keys = activityAmountMap.keySet();
        	system.debug('key--->'+keys);
            return keys;
        }set;}
}