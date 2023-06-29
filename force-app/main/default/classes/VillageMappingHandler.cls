public class VillageMappingHandler {
    public static void beforeInsertUpdate(List<Account> accList, Map<Id, account> oldMap, Boolean isInesrt, Boolean isUpdate){
        villageMap(accList);
        populateVillageData(accList, oldMap,isInesrt,isUpdate);
    }
    
    public static void villageMap(List<Account> accList){
        Set<String> villSet = new Set<String>();
        Set<String> districtSet = new Set<String>();
        Set<String> stateSet = new Set<String>();
        Map<String, Village__c> villMap = new Map<String, Village__c>();
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Farmer').getRecordTypeId();
        Id AkcRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('AKC_Retailer').getRecordTypeId();
        
        for(Account acc : accList){
            if((acc.recordTypeId == RecordTypeId || acc.recordTypeId == AkcRecordTypeId) && String.isNotBlank(acc.VillageName__c)){
                villSet.add(acc.VillageName__c);
                districtSet.add(acc.District__c);
                stateSet.add(acc.StateName__c);
            }
        }
        
        if(villSet.size()> 0 ){
            List<Village__c> villResult = [SELECT Id,name,District__c,state__c, tehsil__r.Name FROM Village__c WHERE Name IN : villSet 
                                           AND District__c IN :districtSet AND state__c IN :stateSet ]; 
            if(villResult != null && villResult.size() > 0 ){
                for(Village__c vill : villResult){
                    String villname = vill.name.trim(); //vill.name.Split('-')[0].trim();
                    villMap.put(villname, vill);    
                }
                
                for(Account acc : accList){
                    if(acc.VillageName__c != null && acc.VillageName__c != '') {
                        String villNameStr = acc.VillageName__c.trim();
                        if(villMap.containsKey(villNameStr) && villMap.get(villNameStr).state__c == acc.StateName__c
                           && villMap.get(villNameStr).District__c == acc.District__c ){ 
                               acc.Village__pc = villMap.get(villNameStr).Id;
                        }
                    }    
                }
            }
        }
    }
    
    public static void populateVillageData(List<Account> accList, Map<Id, account> oldMap,Boolean isInesrt, Boolean isUpdate){
        Set<Id> villId = new Set<Id>();
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('F3_C3_Sales_Team').getRecordTypeId();
        Id RecordTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('AKC_Retailer').getRecordTypeId();
        Id RecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SWAL_Retailer').getRecordTypeId();
        for(Account acc : accList){
            if(acc.RecordTypeId == RecordTypeId && String.isNotBlank(acc.Village__c) 
               || acc.RecordTypeId == RecordTypeId2 && String.isNotBlank(acc.Village__c) 
               || acc.RecordTypeId == RecordTypeId3 && String.isNotBlank(acc.Village__c)) {
                if(isInesrt) {
                    villId.add(acc.Village__c);
                } else if(isUpdate && (oldMap.containsKey(acc.Id) && oldMap.get(acc.Id).Village__c != acc.Village__c )) {
                    villId.add(acc.Village__c);
                }  
            }
        }
        
        if(villId.size() > 0 ){
            Map<Id, Village__c> villMap = new Map<Id, Village__c>([SELECT Id,District__c,state__c, tehsil__r.Name,Postal_Code__c 
                                                                   FROM Village__c where ID IN : villId]);
            for(Account acc : accList){
                if(villMap.containsKey(acc.Village__c)){
                    Village__c villObj = villMap.get(acc.Village__c);
                    acc.StateName__c = villObj.state__c;
                    acc.District__c = villObj.District__c;
                    acc.PIN__c = villObj.Postal_Code__c;
                    acc.Tehsil__c = villObj.tehsil__r.Name;
                }
            }
        }
    }
}