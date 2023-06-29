trigger StockAvailableTrigger on Stock_Requirement__c (after insert,after update,after delete,after undelete) {
    
    double stockReqIT00=0;
    double stockReqFR11=0;
    Map<String,String> SkuIDMap=new Map<String,String>();
    Map<String,String> SkuSalesOrgMap=new Map<String,String>();
    Map<String,String> DepotCodeMap=new Map<String,String>();
    Map<String,double> StRMap=new Map<String,double>();
    
    
    for(SKU__c skuObj:[SELECT Id, Name, SKU_Code__c, Available_Stock_Italy__c, Sales_Org_Code__c, Sales_Org__c FROM SKU__c where Sales_Org_Code__c='2410' AND Distribution_Channel__r.Distribution_Channel_Code__c='20' AND Division__r.Division_Code__c='10']){
        SkuIDMap.put(skuObj.Id, skuObj.Id);
        SkuSalesOrgMap.put(skuObj.Id, skuObj.Sales_Org_Code__c);
    }
    for(Depot__c depotObj:[SELECT Id, Name, Depot_Code__c, Depot__c, SalesOrg__c FROM Depot__c where Depot_Code__c='IT00' OR Depot_Code__c='FR11' ]){
        DepotCodeMap.put(depotObj.Id, depotObj.Depot_Code__c);
    }
    try{
        for(Stock_Requirement__c strObj:[SELECT Id, Name, SKU__c, Depot__c,Depot__r.Depot_code__c, Available_Stock__c FROM Stock_Requirement__c where Depot__r.Depot_code__c IN ('IT00','FR11') ]){
            StRMap.put(strObj.SKU__c+''+strObj.Depot__r.Depot_code__c, strObj.Available_Stock__c);
        }
    }catch(Exception e){
        
    }
    
    if(Trigger.isInsert || Trigger.isUpdate){
        List<SKU__c> Skulist=new List<SKU__c>();
        for(Stock_Requirement__c srObj:Trigger.New){
            System.debug('srObj :'+srObj);
            String skuID=srObj.SKU__c;
            String depotID=srObj.Depot__c;
            SKU__c skuObj=new SKU__c(); 
            if(SkuSalesOrgMap.get(skuID)=='2410'){
                if(SkuIDMap.containsKey(skuID)){
                    skuObj.id=SkuIDMap.get(skuID);
                    if(DepotCodeMap.get(srObj.Depot__c)=='IT00'){
                        double strValue=0;
                        if(StRMap.containsKey(SkuIDMap.get(skuID)+''+'FR11')){
                            strValue=StRMap.get(SkuIDMap.get(skuID)+''+'FR11');
                            stockReqIT00 = srObj.Available_Stock__c+strValue; 
                        }else{
                            stockReqIT00 = srObj.Available_Stock__c;
                        }
                        skuObj.Available_Stock_Italy__c=stockReqIT00;
                        Skulist.add(skuObj);
                        System.debug('Skulist : '+Skulist);
                        
                    }
                }
            }
            
        }
        update Skulist;
        
        List<SKU__c> Skulist2=new List<SKU__c>();
        for(Stock_Requirement__c srObj:Trigger.New){
            System.debug('srObj :'+srObj);
            String skuID=srObj.SKU__c;
            String depotID=srObj.Depot__c;
            SKU__c skuObj2=new SKU__c(); 
            if(SkuSalesOrgMap.get(skuID)=='2410'){
                if(SkuIDMap.containsKey(skuID)){
                    skuObj2.id=SkuIDMap.get(skuID);
                    if(DepotCodeMap.get(srObj.Depot__c)=='FR11'){
                        double strValue=0;
                        if(StRMap.containsKey(SkuIDMap.get(skuID)+''+'IT00')){
                            strValue=StRMap.get(SkuIDMap.get(skuID)+''+'IT00');
                            stockReqFR11 = srObj.Available_Stock__c + strValue; 
                        }else{
                            stockReqFR11 = srObj.Available_Stock__c;
                        }
                        
                        skuObj2.Available_Stock_Italy__c=stockReqFR11;
                        Skulist2.add(skuObj2);
                        System.debug('Skulist : '+Skulist);
                    }
                    
                }
            }
            
        }
        update Skulist2;
    }
    
    if(Trigger.isDelete){
        List<SKU__c> Skulist=new List<SKU__c>();
        for(Stock_Requirement__c srObj:Trigger.Old){
            System.debug('srObj on delete :'+srObj);
            String skuID=srObj.SKU__c;
            if(SkuSalesOrgMap.get(skuID)=='2410'){
                if(SkuIDMap.containsKey(skuID)){
                    SKU__c skuObj=new SKU__c(); 
                    skuObj.id=SkuIDMap.get(skuID);
                    if(DepotCodeMap.get(srObj.Depot__c)=='IT00'){
                        double strValue=0;
                        strValue=StRMap.get(SkuIDMap.get(skuID)+''+'FR11');
                        stockReqIT00 = strValue; 

                        if(stockReqIT00!=null){
                            skuObj.Available_Stock_Italy__c=stockReqIT00;
                        }else{
                            skuObj.Available_Stock_Italy__c=0;
                        }
                     Skulist.add(skuObj);   
                    }
                    System.debug('skuObj 1 : '+skuObj);
                    
                }
            }
        }
        update Skulist;
        
        List<SKU__c> Skulist2=new List<SKU__c>();
        for(Stock_Requirement__c srObj:Trigger.Old){
            System.debug('srObj on delete :'+srObj);
            String skuID=srObj.SKU__c;
            if(SkuSalesOrgMap.get(skuID)=='2410'){
                if(SkuIDMap.containsKey(skuID)){
                    SKU__c skuObj=new SKU__c(); 
                    skuObj.id=SkuIDMap.get(skuID);
                    if(DepotCodeMap.get(srObj.Depot__c)=='FR11'){
                        double strValue=0;
                        strValue=StRMap.get(SkuIDMap.get(skuID)+''+'IT00');
                        stockReqFR11 = strValue;

                        if(stockReqFR11!=null){
                            skuObj.Available_Stock_Italy__c=stockReqFR11;
                        }else{
                            skuObj.Available_Stock_Italy__c=0;
                        }
                     Skulist2.add(skuObj);
                    }
                    System.debug('skuObj 2 : '+skuObj);
                    
                }
            }
        }
        update Skulist2;
    }

    /*if(Trigger.isUndelete){
        for(Stock_Requirement__c srObj:Trigger.new){
            System.debug('srObj on undelete :'+srObj);
            String skuID=srObj.SKU__c;
            if(SkuSalesOrgMap.get(skuID)=='2410'){
                if(SkuIDMap.containsKey(skuID)){
                    SKU__c skuObj=new SKU__c(); 
                    skuObj.id=SkuIDMap.get(skuID);
                    if(DepotCodeMap.get(srObj.Depot__c)=='IT00'){
                        double strValue=0;
                        strValue=StRMap.get(SkuIDMap.get(skuID)+''+'FR11');
                        stockReqIT00 = strValue; 

                        if(stockReqIT00!=null){
                            skuObj.Available_Stock_Italy__c=stockReqIT00;
                        }else{
                            skuObj.Available_Stock_Italy__c=0;
                        }
                        
                    }else if(DepotCodeMap.get(srObj.Depot__c)=='FR11'){
                        double strValue=0;
                        strValue=StRMap.get(SkuIDMap.get(skuID)+''+'IT00');
                        stockReqFR11 = strValue;

                        if(stockReqFR11!=null){
                            skuObj.Available_Stock_Italy__c=stockReqFR11;
                        }else{
                            skuObj.Available_Stock_Italy__c=0;
                        }
                        
                    }
                    System.debug('skuObj : '+skuObj);
                    update skuObj;
                }
            }
        }
    }*/
}