public class PreventDuplicateRecordHandler {

    
    Public static void beforeInsertCombinationKey(List<Brazil_Region_SKU_Combination__c> newList){
        for(Brazil_Region_SKU_Combination__c brnew : newList){

   for(Brazil_Region_SKU_Combination__c br: [Select Id, Combination_Key__c from Brazil_Region_SKU_Combination__c]){
   
     if(brnew.Combination_Key__c == br.Combination_Key__c){brnew.Combination_Key__c.addError('You can not create duplicate record with two same combination key .');
   
         
    }
   }
        }
    }
    
    Public static void beforeUpdateCombinationKey(List<Brazil_Region_SKU_Combination__c> brNewList, Map<Id, Brazil_Region_SKU_Combination__c> oldMap){
        
        //set<String> combSet = new Set<String>();
        //for(Brazil_Region_SKU_Combination__c brOld : oldMap.values()){
        //      combSet.add(oldMap.get(brOld.Id).Combination_Key__c);
       // }
        //
        //
        Set<String> setStr = new Set<String>();
        List<Brazil_Region_SKU_Combination__c> leadObj = new List<Brazil_Region_SKU_Combination__c>();
        List<Brazil_Region_SKU_Combination__c> leadList=[Select Id, Combination_Key__c, Sales_District__c, SKU__c From Brazil_Region_SKU_Combination__c Where Combination_Key__c != null];
        for(Brazil_Region_SKU_Combination__c d1:leadList){setStr.add(d1.Combination_Key__c);
            
        }
        
        for(Brazil_Region_SKU_Combination__c br : brNewList){
            if(oldMap != null && br.Combination_Key__c != oldMap.get(br.id).Combination_Key__c){
                
                 if(setStr.contains(br.Combination_Key__c)){ br.Combination_Key__c.addError('Do not allow to duplicate Records .');  
                                                           }
                   
              
                
               // if(combSet.contains(br.Combination_Key__c)){
                 // br.addError('You can not create duplicate record with two same combination key .');  
                 // }
                 
            }
        }
   
   }
   
  
    
    
    
    
}


  /* public class PreventDuplicateRecordHandler {
    
    public static void beforeInsertCombinationKey(List<Brazil_Region_SKU_Combination__c> leadObjList){
        Set<String> setStr = new Set<String>();
         List<Brazil_Region_SKU_Combination__c> leadObj = new List<Brazil_Region_SKU_Combination__c>();
        List<Brazil_Region_SKU_Combination__c> leadList=[Select Id, Combination_Key__c, Sales_District__c, SKU__c From Brazil_Region_SKU_Combination__c Where Combination_Key__c != null];
        for(Brazil_Region_SKU_Combination__c d1:leadList){
            setStr.add(d1.Combination_Key__c);
        }
        
          for(Brazil_Region_SKU_Combination__c e1:leadObjList){
                if(setStr.contains(e1.Combination_Key__c)){
                    e1.Combination_Key__c.addError('Do not allow duplicate Email');
                }
            }
        
    } 
    
    
}*/