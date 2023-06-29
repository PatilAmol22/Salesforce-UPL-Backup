public class ViewItalyInventory_Controller {
    public static string userId;
    public static list<User_Material_Type_Mapping__c> listUser;
    public static string materialType;
    
    public static  String salesOrg_filter; 
    public static  String salesOrg; 
    
    public static map<String,Stock_Requirement__c > StkReq_Map;
    public static map<String,Inventory__c> inventory_Map_Batchwise;
    public static map<String,Inventory__c> inventory_Map;
    
    public  ViewItalyInventory_Controller(){
        
        System.debug('Cons-------');
        listUser = new list<User_Material_Type_Mapping__c>();
        materialType ='';
        userId ='';
        salesOrg_filter = ''; 
        salesOrg = '';
        
    }
    //Called by init on load
    @AuraEnabled 
    public static WrapperPageResult getInventories(Decimal pageNumber,Integer recordToDisply ){ 
        try{
            StkReq_Map = new map<String,Stock_Requirement__c >();
            inventory_Map = new map<String,Inventory__c>();
            inventory_Map_Batchwise = new map<String,Inventory__c>();
            
            userId = UserInfo.getUserId();
            User LoginUser = [SELECT Id, Country,Profile.Name FROM User Where Id=:userId];
            String inventory_Query ='';
            String Stk_Req_Query ='';
            
            System.debug('LoginUser Italy'+ LoginUser);
            salesOrg_filter = ' Storage_Location_Depot__r.Country__c = \'Italy\'';     //'2410';
            salesOrg =' (Depot__r.Country__c = \'Italy\'  AND SKU__r.SKU_Description__c !=\'\') AND ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0 )';
            //' Depot__r.Country__c = \'Italy\'  AND SKU__r.SKU_Description__c !=\'\' ';
            System.debug('salesOrg_filter ----> '+salesOrg_filter +'Vs LoginUser.Country'+LoginUser.Country);
            
            list<WrapStockReqInventory> lstWrapStkReqInventObj = new list<WrapStockReqInventory>();
            Integer pageSize = recordToDisply;  
            Integer offset = ((Integer)pageNumber - 1) * pageSize; 
            WrapperPageResult wObj = new WrapperPageResult();
            wObj.pageSize = pageSize;
            wObj.page = (Integer) pageNumber; 
            
            list<Stock_Requirement__c> lstStkreq = new list<Stock_Requirement__c>();
            list<Inventory__c> lstInventory = new list<Inventory__c>();
            
            
            Stk_Req_Query = ' SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.Depot_Code__c,';
            Stk_Req_Query +=' Unrestricted_Stock__c, Purchase_Order_Stock__c,Outgoing_Reservations__c,Net_Stock_Europe__c,Stock_In_Transit__c,UOM__c, ';                
            Stk_Req_Query +=' Outgoing_Reservations_Italy__c,Net_Stock_Italy__c FROM Stock_Requirement__c ';
            Stk_Req_Query +=' WHERE SKU__r.Active__c = true and SKU__r.Material_type__c != \'ROH\' AND '+salesOrg+'  order by SKU__r.SKU_Description__c  LIMIT :recordToDisply  OFFSET :offset'; // Updated for INC0418898 GRZ(Dheeraj Sharma) 05-12-2022 

            
            System.debug('Stk_Req_Query--> '+Stk_Req_Query);
            lstStkreq = database.query(Stk_Req_Query);                
            system.debug('salesOrg_filter>>--->'+salesOrg_filter); 
            
//inventory_Query  = 'SELECT Id, Name,Storage_Location_Depot__c,Batch_Number__c, Storage_Location_Depot__r.name,Storage_Location_Depot__r.Depot_Code__c, Depot__r.Depot_Code__c, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Stock_Quantity__c,UOM__c FROM Inventory__c WHERE '+ salesOrg_filter;
            inventory_Query +=' SELECT Id, Name,Production_Date__c,Expiry_Date__c,Storage_Location_Depot__c,Batch_Number__c, Storage_Location_Depot__r.name, ';
            inventory_Query +=' Storage_Location_Depot__r.Depot_Code__c, Depot__r.Depot_Code__c, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,';
            inventory_Query +=' Stock_Quantity__c,UOM__c FROM Inventory__c WHERE SKU__r.Active__c = true and '+ salesOrg_filter; // Updated for INC0418898 GRZ(Dheeraj Sharma) 05-12-2022 

            lstInventory = database.query(inventory_Query);
            
               /************** Italy Sales Area Manager  Duplication Logic*******/
            if(LoginUser.Profile.Name =='Area Manager Italy'){//
                for(Stock_Requirement__c  stk :lstStkreq  ){
                    string key = stk.Depot__r.Depot_Code__c + stk.SKU__r.SKU_Description__c;
                    if(StkReq_Map.containsKey(key)){
                    	Stock_Requirement__c StkObj = StkReq_Map.get(key);
                        StkObj.Unrestricted_Stock__c   += stk.Unrestricted_Stock__c;
                        StkObj.Purchase_Order_Stock__c += stk.Purchase_Order_Stock__c;
                        StkObj.Stock_In_Transit__c     +=  stk.Stock_In_Transit__c;
                        
                        StkObj.Outgoing_Reservations_Italy__c += stk.Outgoing_Reservations__c; 
                        StkObj.Net_Stock_Italy__c += stk.Net_Stock_Europe__c;
                        //System.debug('StkObj.Outgoing_Reservations_Italy__c '+StkObj.Outgoing_Reservations_Italy__c);
                        //System.debug('StkObj.Net_Stock_Italy__c '+StkObj.Net_Stock_Italy__c);
                        
                        StkReq_Map.put(key,StkObj);
                    }
                    else{
                        stk.Outgoing_Reservations_Italy__c = stk.Outgoing_Reservations__c; 
                        stk.Net_Stock_Italy__c = stk.Net_Stock_Europe__c;
                        StkReq_Map.put(key,stk);
                    }
            }
             lstStkreq =  StkReq_Map.values();
             StkReq_Map.clear();   
           
            }
            
            /************** Italy Sales Area Manager  Duplication Logic*******/
              
          
            
             /************** Italy  Duplication Patch*******/
            
            for(Stock_Requirement__c  stk :lstStkreq  ){
            string key = stk.Depot__r.Depot_Code__c + stk.SKU__r.SKU_Code__c;
            StkReq_Map.put(key,stk);
            }
            
            for(Inventory__c inv :lstInventory){
                string key_batchWise = inv.Depot__r.Depot_Code__c + inv.SKU__r.SKU_Code__c + inv.Storage_Location_Depot__r.Depot_Code__c + inv.Batch_Number__c;
                string key = inv.Depot__r.Depot_Code__c + inv.SKU__r.SKU_Code__c + inv.Storage_Location_Depot__r.Depot_Code__c ;
                if(!inventory_Map_Batchwise.containsKey(key_batchWise)){
                    
                    inventory_Map_Batchwise.put(key_batchWise, inv); 
                }
                
            }
            
            for(Inventory__c inv :inventory_Map_Batchwise.values()){
               
                string key = inv.Depot__r.Depot_Code__c + inv.SKU__r.SKU_Code__c + inv.Storage_Location_Depot__r.Depot_Code__c ;
                if(inventory_Map.containsKey(key)){
                    Inventory__c invObj = inventory_Map.get(key);
                    invObj.Stock_Quantity__c += inv.Stock_Quantity__c;
                    inventory_Map.put(key, invObj);
                }
                else{
                    inventory_Map.put(key, inv);
                }
                
            }
            
            /************** Italy  Duplication Patch*******/
            
           
            wObj.total = [SELECT COUNT() FROM Stock_Requirement__c 
                          WHERE  SKU__r.Active__c = true AND Depot__r.Country__c = 'Italy' AND SKU__r.SKU_Description__c !='' // Updated for INC0418898 GRZ(Dheeraj Sharma) 05-12-2022 
                         AND  ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0  )];
                      
            for(Stock_Requirement__c sreq : StkReq_Map.values()){
                WrapStockReqInventory wrapObj = new WrapStockReqInventory(); 
                wrapObj.stkReq = sreq;
                
                for(Inventory__c inv : inventory_Map.values()){
                    if(sreq.SKU__r.SKU_Code__c == inv.SKU__r.SKU_Code__c){
                        wrapObj.lstStrLocInv.add(inv);   
                    }
                }                 
                lstWrapStkReqInventObj.add(wrapObj);   
            } 
            wObj.listWrapStkReqInv = lstWrapStkReqInventObj;
           
            system.debug('pageSize>>--->'+  wObj.pageSize );
            system.debug('page>>--->'+wObj.page);
            return wObj;  
        }
        catch(Exception e){
            system.debug('Error Message >>--->'+e.getMessage());
            system.debug('Error Message Line Number >>--->'+e.getLineNumber());
            return null;
        }
    } 
    // This method used for retrieving the list of Inventory records based on the search string 
    @AuraEnabled 
    public static WrapperPageResult getBySKUAndSLocation(String fieldName ,string value,Decimal pageNumber,Integer recordToDisply) { 
        try{
            StkReq_Map = new map<String,Stock_Requirement__c >();
            inventory_Map = new map<String,Inventory__c>();
            inventory_Map_Batchwise = new map<String,Inventory__c>();
            system.debug('Method start');
            if( fieldName == 'Product/Sku'){
                value = value.toUpperCase();
            }
            userId = UserInfo.getUserId();           
            User LoginUser = [SELECT Id, Country,Profile.Name FROM User Where Id=:userId];
            System.debug('LoginUser Italy'+ LoginUser);
            salesOrg_filter = ' Storage_Location_Depot__r.Country__c = \'Italy\'';     //'2410' AND Storage_Location_Depot__r.SalesOrg__r.Sales_Org_Code__c = \'2410\'d
            salesOrg ='(Depot__r.Country__c = \'Italy\' AND SKU__r.SKU_Description__c !=\'\') AND ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0 ) ';
            
            materialType = '';
            
            list<WrapStockReqInventory> lstWrapStkReqInventObj = new list<WrapStockReqInventory>();
            list<Stock_Requirement__c> lstStkreq = new list<Stock_Requirement__c>();
            list<Inventory__c> lstInventory = new list<Inventory__c>();
            Integer pageSize = 0;
            pageSize = recordToDisply;  
            system.debug('pageSize>>--->'+pageSize);
            
            Integer offset = ((Integer)pageNumber - 1) * pageSize;
            system.debug('offset>>--->'+offset);
            WrapperPageResult wObj = new WrapperPageResult();
            wObj.pageSize = pageSize;
            wObj.page = (Integer) pageNumber; 
            
            string stkReqQuery = '';
            string invtryQuery = '';
            string salesOrgFil = salesOrg_filter;
            Boolean isStorageloc = false;
            
            
            system.debug('value>>--->'+value);
            system.debug('fieldName>>--->'+fieldName);
            if(!String.isBlank(value)){
                value = '%'+value+'%';
                if( fieldName == 'Product/Sku'){
                    
// stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE (SKU__r.SKU_Description__c  like :value OR SKU__r.Product_with_SKU__c like :value) AND '+salesOrg+' order by SKU__r.SKU_Description__c';
                    stkReqQuery = ' SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.Depot_Code__c,  Unrestricted_Stock__c,';
                    stkReqQuery +=' Purchase_Order_Stock__c,Outgoing_Reservations__c,Net_Stock_Europe__c,Stock_In_Transit__c,UOM__c, ';                
                    stkReqQuery +=' Outgoing_Reservations_Italy__c,Net_Stock_Italy__c FROM Stock_Requirement__c ';
                    stkReqQuery +=' WHERE (SKU__r.SKU_Description__c  like :value OR SKU__r.Product_with_SKU__c like :value) AND '+salesOrg;
                    stkReqQuery +=' order by SKU__r.SKU_Description__c';
                    	list<Stock_Requirement__c> lstStkreqW_OOffset = new list<Stock_Requirement__c>();
                        lstStkreqW_OOffset = database.query(stkReqQuery);
                        
                        if(lstStkreqW_OOffset.size()<=pageSize){
                            offset=0;  
                        }  
                        
                        string materialval ='ROH';
//stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.Material_type__c !=:materialval AND (SKU__r.SKU_Description__c  like :value OR SKU__r.Product_with_SKU__c like :value) AND '+salesOrg+' order by SKU__r.SKU_Description__c LIMIT :recordToDisply  OFFSET :offset '; 
                    	
                    stkReqQuery = ' SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c,Depot__r.Depot_Code__c, Depot__r.name, Unrestricted_Stock__c,';
                    stkReqQuery +=' Purchase_Order_Stock__c,Outgoing_Reservations__c,Net_Stock_Europe__c,Stock_In_Transit__c,UOM__c, ';                
                    stkReqQuery +=' Outgoing_Reservations_Italy__c,Net_Stock_Italy__c FROM Stock_Requirement__c ';
                    stkReqQuery +=' WHERE SKU__r.Material_type__c !=:materialval AND (SKU__r.SKU_Description__c  like :value OR SKU__r.Product_with_SKU__c like :value) AND '+salesOrg;
                    stkReqQuery +=' order by SKU__r.SKU_Description__c LIMIT :recordToDisply  OFFSET :offset ';
                    
                    //invtryQuery ='SELECT Id, Name,Storage_Location_Depot__c, Storage_Location_Depot__r.name,SKU__r.SKU_Description__c,Stock_Quantity__c,UOM__c FROM Inventory__c WHERE '+salesOrgFil;
                    invtryQuery +='SELECT Id, Name,Production_Date__c,Expiry_Date__c,Depot__r.Depot_Code__c,Storage_Location_Depot__c, Storage_Location_Depot__r.name,Storage_Location_Depot__r.Depot_Code__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,Stock_Quantity__c,';
                    invtryQuery +='Batch_Number__c ,UOM__c FROM Inventory__c WHERE '+salesOrgFil;
                    system.debug('stkReqQuery>>--->'+stkReqQuery);
                    system.debug('invtryQuery>>--->'+invtryQuery);
                    system.debug('SKU');
                    lstStkreq = database.query(stkReqQuery);
                    lstInventory =  database.query(invtryQuery);
                    
                    wObj.total =[SELECT count() FROM Stock_Requirement__c 
                                 WHERE SKU__r.SKU_Description__c  like :value AND Depot__r.Country__c = 'Italy' AND SKU__r.SKU_Description__c !='' 
                                 AND ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0 )];
                    
                    
                }
                
                else if(fieldName == 'Storage Location'){
                    //System.debug('Inside Storage Location Apex > Value> '+value);
                    
                    salesOrgFil += ' AND  SKU__r.Material_type__c !=\'ROH\'';
                
                    invtryQuery ='SELECT Id, Name,Production_Date__c,Expiry_Date__c,Storage_Location_Depot__c,Depot__r.Depot_Code__c,Storage_Location_Depot__r.name,Storage_Location_Depot__r.Depot_Code__c,Batch_Number__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,Stock_Quantity__c,UOM__c FROM Inventory__c WHERE '+salesOrgFil+' AND  Storage_Location_Depot__r.name like :value';
                    lstInventory =  database.query(invtryQuery);
                    //System.debug('lstInventory size---> '+lstInventory.size());
                    set<string> setSku = new set<string>();
                    for(Inventory__c inv : lstInventory){
                        setSku.add(inv.SKU__r.SKU_Description__c);         
                    }  
                    
                    stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,Depot__c,Depot__r.Depot_Code__c,SKU__r.SKU_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Net_Stock_Europe__c,Outgoing_Reservations__c,Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c,UOM__c,Outgoing_Reservations_Italy__c,Net_Stock_Italy__c FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  IN :setSku AND SKU__r.Material_type__c!=\'ROH\' AND '+salesOrg+' order by SKU__r.SKU_Description__c';
                    list<Stock_Requirement__c> lstStkreqW_OOffset = new list<Stock_Requirement__c>();
                    lstStkreqW_OOffset = database.query(stkReqQuery);
                    
                    if(lstStkreqW_OOffset.size()<=pageSize){
                        offset=0;  
                    }  
                    
                    stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.Material_type__c,Depot__c,Depot__r.Depot_Code__c,SKU__r.SKU_Code__c, Depot__r.name,Net_Stock_Europe__c,Outgoing_Reservations__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c,Outgoing_Reservations_Italy__c,Net_Stock_Italy__c FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  IN :setSku AND SKU__r.Material_type__c!=\'ROH\' AND '+salesOrg+' order by SKU__r.SKU_Description__c LIMIT :recordToDisply  OFFSET :offset ';   
                    
                    //system.debug('query>>--->'+stkReqQuery);
                    //system.debug('query>>--->'+invtryQuery);
                    lstStkreq = database.query(stkReqQuery);
                    //system.debug('lstStkreq size>>--->'+lstStkreq.size());
                    //system.debug('lstStkreq1 size>>--->'+lstStkreq);
                    list<Stock_Requirement__c> lstStkreq1 = new list<Stock_Requirement__c>();
                    for(Stock_Requirement__c stkrreq : lstStkreq){
                        if(stkrreq.SKU__r.Material_type__c != 'ROH' && materialType != 'ROH'){
                            lstStkreq1.add(stkrreq);
                        }
                    }
                   
                    lstStkreq = lstStkreq1;
                    
                    isStorageloc = true;
                    system.debug('storage Location');
                    
                    wObj.total =[SELECT count() FROM Stock_Requirement__c
                                 WHERE Depot__r.Country__c = 'Italy'                                 
                                 AND (Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0  )
                                 AND SKU__r.SKU_Description__c  IN :setSku  ];
                    
                }
                
            }
            
            else{
                system.debug('value>>--->'+value);
//stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.Material_type__c != \'ROH\' AND '+salesOrg+'  order by SKU__r.SKU_Description__c  LIMIT :recordToDisply  OFFSET :offset'; 
                stkReqQuery = ' SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c,Depot__r.Depot_Code__c, Depot__r.name, Unrestricted_Stock__c,';
                stkReqQuery +=' Purchase_Order_Stock__c,Outgoing_Reservations__c,Net_Stock_Europe__c,Stock_In_Transit__c,UOM__c, ';                
                stkReqQuery +=' Outgoing_Reservations_Italy__c,Net_Stock_Italy__c FROM Stock_Requirement__c ';
                stkReqQuery +=' WHERE SKU__r.Material_type__c != \'ROH\' AND '+salesOrg;
                stkReqQuery +=' order by SKU__r.SKU_Description__c  LIMIT :recordToDisply  OFFSET :offset';
                system.debug('query>>--->'+stkReqQuery);
                
                invtryQuery ='SELECT Id, Name,Production_Date__c,Expiry_Date__c,Depot__r.Depot_Code__c,Storage_Location_Depot__c,SKU__r.SKU_Code__c, Storage_Location_Depot__r.name,SKU__r.SKU_Description__c,Stock_Quantity__c,UOM__c FROM Inventory__c WHERE '+salesOrgFil; 
                system.debug('query>>--->'+stkReqQuery);
                system.debug('query>>--->'+invtryQuery);
                lstStkreq = database.query(stkReqQuery);
                lstInventory =  database.query(invtryQuery);
                
                wObj.total =[SELECT count() FROM Stock_Requirement__c 
                             WHERE Depot__r.Country__c = 'Italy' AND SKU__r.SKU_Description__c  like :value  
                             AND ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0 )];
                system.debug('wObj.total >>--->'+wObj.total);
            }
            
               /************** Italy Sales Area Manager  Duplication Logic*******/
            if(LoginUser.Profile.Name =='Area Manager Italy'){//
                
                for(Stock_Requirement__c  stk :lstStkreq  ){
                    string key = stk.Depot__r.Depot_Code__c + stk.SKU__r.SKU_Description__c;
                    if(StkReq_Map.containsKey(key)){
                        Stock_Requirement__c StkObj = StkReq_Map.get(key);
                        StkObj.Unrestricted_Stock__c += stk.Unrestricted_Stock__c;
                        StkObj.Purchase_Order_Stock__c += stk.Purchase_Order_Stock__c;
                        StkObj.Stock_In_Transit__c +=  stk.Stock_In_Transit__c;
                        StkObj.Outgoing_Reservations_Italy__c += stk.Outgoing_Reservations__c; 
                        StkObj.Net_Stock_Italy__c += stk.Net_Stock_Europe__c;
                        StkReq_Map.put(key,StkObj);
                    }
                    else{
                        stk.Outgoing_Reservations_Italy__c += stk.Outgoing_Reservations__c; 
                        stk.Net_Stock_Italy__c += stk.Net_Stock_Europe__c;
                        
                        StkReq_Map.put(key,stk);
                    }
                }
                lstStkreq =  StkReq_Map.values();  
                StkReq_Map.clear();
            }
            
            /************** Italy Sales Area Manager  Duplication Logic*******/
                        
             /************** Italy  Duplication Patch*******/
              
            for(Stock_Requirement__c  stk :lstStkreq){
            string key = stk.Depot__r.Depot_Code__c + stk.SKU__r.SKU_Code__c;
            StkReq_Map.put(key,stk);
            }
            
            for(Inventory__c inv :lstInventory){
                string key_batchWise = inv.Depot__r.Depot_Code__c + inv.SKU__r.SKU_Code__c + inv.Storage_Location_Depot__r.Depot_Code__c + inv.Batch_Number__c;
                string key = inv.Depot__r.Depot_Code__c + inv.SKU__r.SKU_Code__c + inv.Storage_Location_Depot__r.Depot_Code__c ;
                if(!inventory_Map_Batchwise.containsKey(key_batchWise)){                    
                    inventory_Map_Batchwise.put(key_batchWise, inv); 
                }
                
            }
            
            for(Inventory__c inv :inventory_Map_Batchwise.values()){
               
                string key = inv.Depot__r.Depot_Code__c + inv.SKU__r.SKU_Code__c + inv.Storage_Location_Depot__r.Depot_Code__c ;
                if(inventory_Map.containsKey(key)){
                    Inventory__c invObj = inventory_Map.get(key);
                    invObj.Stock_Quantity__c += inv.Stock_Quantity__c;
                    inventory_Map.put(key, invObj);
                }
                else{
                    inventory_Map.put(key, inv);
                }                
            }            
            /************** Italy  Duplication Patch*******/
            
            for(Stock_Requirement__c sreq : StkReq_Map.values()  ){
                WrapStockReqInventory wrapObj = new WrapStockReqInventory(); 
                wrapObj.stkReq = sreq;
                for(Inventory__c inv :inventory_Map.values()){
                    if(sreq.SKU__r.SKU_Code__c == inv.SKU__r.SKU_Code__c){
                        wrapObj.lstStrLocInv.add(inv);   
                    }
                }    
                lstWrapStkReqInventObj.add(wrapObj);   
            }  
            
            wObj.listWrapStkReqInv = lstWrapStkReqInventObj;
            return wObj;
        }catch(Exception e){
            system.debug('Error Message >>--->'+e.getMessage());
            system.debug('Error Message Line Number >>--->'+e.getLineNumber());
            return null;
        }
        
    }
    public class WrapperPageResult{
        @AuraEnabled public Integer pageSize {get;set;}
        @AuraEnabled public Integer page {get;set;}
        @AuraEnabled public Integer total {get;set;}
        @AuraEnabled public boolean isAdmin{get;set;}
        @AuraEnabled public boolean isAreaMgr{get;set;}
        @AuraEnabled public List<WrapStockReqInventory> listWrapStkReqInv {get;set;}
        
        public WrapperPageResult(){
            pageSize = 0;
            page = 0;
            total = 0;
            userId = UserInfo.getUserId();
            User LoginUser = [SELECT Id, Country,Profile.Name,Userrole.Name FROM User Where Id=:userId];
            isAdmin=LoginUser.Profile.Name == 'System Administrator' ?True:False;
            isAreaMgr=LoginUser.Profile.Name == 'Area Manager Italy' ?True:False;
            System.debug('isAreaMgr ---> '+isAreaMgr);
        }
    }
    
    public class WrapStockReqInventory{
        @AuraEnabled Stock_Requirement__c  stkReq{get;set;}
        @AuraEnabled list<Inventory__c> lstStrLocInv{get;set;}
        
        public WrapStockReqInventory(){
            stkReq = new Stock_Requirement__c();
            lstStrLocInv = new  list<Inventory__c>();
            
        }        
    }
}