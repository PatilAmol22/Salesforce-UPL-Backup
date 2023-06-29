//CREATED TriggerHandler FOR INVENTORY CONTROL BY HARSHIT&ANMOL@WIPRO FOR (US IU-001) ---START

public class inventoryTriggerHandler {
    // comment below code for RITM0574791 GRZ(Javed Ahmed) 20-06-2023
    /*public static void inventorycontrolImport(List<Inventory_Control__c> newList){
Inventory_Parameter1__mdt ip1 = [SELECT minute__c from Inventory_Parameter1__mdt ];

DateTime dtTime = System.now().addMinutes(-Integer.valueOf(ip1.minute__c));
List<Inventory_Control__c> lstInvCon = [SELECT Id FROM Inventory_Control__c where createdDate <: dtTime Order by CreatedDate ASC LIMIT 1];
for (Inventory_Control__c c : newList) {
if (lstInvCon.size() > 0) {
c.addError('Please delete Inventory before import.');
}
}
}*/
    
    public static void inventorycontrolDuplicate(List<Inventory_Control__c> listInventory){
        // comment below code for RITM0574791 GRZ(Javed Ahmed) 20-06-2023
        /*  System.debug('listInventory'+listInventory);
Map<String,String> newMap = new Map<String,String>();
list<String> d = new list<String>();
list<String> du = new list<String>();



System.debug('d:  '+d);


System.debug('du:'+du);




for(Inventory_Control__c i : listInventory){
System.debug('i.Product__c+i.BU__c+i.Fiscal_Year__c'+i.BU__c + i.Fiscal_Year__c + i.Product__c);

if(du.contains(i.BU__c + i.Fiscal_Year__c + i.Product__c)){
System.debug('inside');
i.addError('Duplicate Inventory records can not be inserted');

}else{
du.add(i.BU__c + i.Fiscal_Year__c + i.Product__c);
}

}*/
        set<Id> inventoryId= new set<Id>();
        map<String,Inventory_Control__c> inventoryControlMap= new map<String,Inventory_Control__c>();
        for(Inventory_Control__c i : listInventory){
            if(i.BU__c!=null && i.Fiscal_Year__c!=null && i.Product__c!=null){
                inventoryControlMap.put(i.BU__c+i.Fiscal_Year__c+i.Product__c,i);
            }
        }
        list<Inventory_Control__c> matchingProductNameList= new list<Inventory_Control__c>();
        map<string,Inventory_Control__c> mathingMAp= new map<string,Inventory_Control__c>();
        if(inventoryControlMap!=null && inventoryControlMap.size()>0){
            matchingProductNameList=[select id,name,CombinationKey__c,Product__c,Quantity__c,Fiscal_Year__c from Inventory_Control__c
                                     where CombinationKey__c  IN: inventoryControlMap.keySet()];
            system.debug('matchingProductNameList:'+matchingProductNameList);
           
            for(Inventory_Control__c c:matchingProductNameList){
                mathingMAp.put(c.CombinationKey__c,c);
            }
            system.debug('matchingProductNameListsize:'+matchingProductNameList.size());
            if(matchingProductNameList!=null && matchingProductNameList.size()>0){
                for(Inventory_Control__c i : listInventory){
                    if(mathingMAp.containskey(i.CombinationKey__c)){
                    i.IsDeleted__c=true;
                    }
                }
            }
            if(matchingProductNameList!=null && matchingProductNameList.size()>0){
                for(Inventory_Control__c ic:matchingProductNameList){
                    if(inventoryControlMap.containskey(ic.CombinationKey__c)){
                        if(ic.Quantity__c!=null && ic.Quantity__c!=inventoryControlMap.get(ic.CombinationKey__c).Quantity__c 
                           && ic.Fiscal_Year__c==inventoryControlMap.get(ic.CombinationKey__c).Fiscal_Year__c 
                           && ic.Product__c==inventoryControlMap.get(ic.CombinationKey__c).Product__c ){
                               ic.Quantity__c= inventoryControlMap.get(ic.CombinationKey__c).Quantity__c;
                           }
                    }
                }
            }
            if(matchingProductNameList!=null && matchingProductNameList.size()>0){
                update matchingProductNameList;
            }
            
            /* if(matchingProductNameList.size()>0){
for(Inventory_Control__c i : listInventory){

i.adderror('you cannot insert record beacuse record already present with same name and same fiscal yuear');
}
}*/
            
            
        }       
    }       
    public static void delRecords(list<Inventory_Control__c>delRecordList){
        set<Id> recId= new set<Id>();
        set<Id> delSet= new set<Id>();
        map<String,Inventory_Control__c> inventoryControlMap= new map<String,Inventory_Control__c>();
        for(Inventory_Control__c i : delRecordList){
            if(i.IsDeleted__c==true){
                recId.add(i.id);
            }
        }
        system.debug('recId:'+recId);
         system.debug('recIdsize:'+recId.size());
        list<Inventory_Control__c> delList=[select id,name,Product__c,Fiscal_Year__c, Quantity__c from Inventory_Control__c where id in:recId];
          system.debug('delListsize:'+delList.size());
         system.debug('delList:'+delList);
        if(delList.size()>0){
            delete delList;
        }
    }
}