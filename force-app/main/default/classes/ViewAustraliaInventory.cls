public class ViewAustraliaInventory {
    public static string userId;
    public static list<User_Material_Type_Mapping__c> listUser;
    public static string materialType;
    public static  String salesOrg_filter; 
    public static  String salesOrg;
    public static  String salesOrg_SKU; //To differentiate between SKU Descrpition and SKU Code   
    public static map<String,Stock_Requirement__c > StkReq_Map;
    public static map<String,Inventory__c> inventory_Map_Batchwise;
    public static map<String,Inventory__c> inventory_Map;
    
    public ViewAustraliaInventory() {
        listUser = new list<User_Material_Type_Mapping__c>();
        materialType ='';
        userId ='';
        salesOrg_filter = ''; 
        salesOrg = '';
        salesOrg_SKU ='';
    }

    @AuraEnabled
    public static List<Object> getDepot(){
        string userId = userinfo.getUserId();
        List<Object> options = new List<Object>();
        List<Object> s = new List<Object>();
        
        User u = [SELECT Id,Name,Country,Profile.Name FROM User WHERE Id=:userId];
        if(u.Profile.Name=='System Administrator'){
            List<Depot__c> dp_list= [SELECT Id, Name, Country__c, Depot__c, Depot_Code__c, SalesOrg__r.Continent__c FROM Depot__c Where Country__c='Australia' AND RecordType.Name='Depot' and Active__c = true order by Name asc];
            for(Integer i=0 ; i< dp_list.size() ;i++){
                Map<String, object> depoJSON = new Map<String, object>();
                depoJSON.put('Depot_Code__c', dp_list[i].Depot_Code__c);
                depoJSON.put('Depot__c', dp_list[i].Depot__c);
                depoJSON.put('Country__c', dp_list[i].Country__c);
                depoJSON.put('Name', dp_list[i].Name);
                s.add(depoJSON);
                
            }
        }
        else{
            List<TM_Depot_Mapping__c> tdmList = [SELECT Id, Depot__c, Territory_Manager__c FROM TM_Depot_Mapping__c WHERE Territory_Manager__c=:userId];
            Set<String> DepotIdSet = new Set<String>();
            for(TM_Depot_Mapping__c tdmObj:tdmList){
                DepotIdSet.add(tdmObj.Depot__c);
            }
            if(DepotIdSet.size()>0){
                List<Depot__c> dp_list= [SELECT Id, Name, Country__c, Depot__c, Depot_Code__c, SalesOrg__r.Continent__c FROM Depot__c Where Id in: DepotIdSet AND RecordType.Name='Depot' AND Active__c = true order by Name asc];
                for(Integer i=0 ; i< dp_list.size() ;i++){
                    Map<String, object> depoJSON = new Map<String, object>();
                    depoJSON.put('Depot_Code__c', dp_list[i].Depot_Code__c);
                    depoJSON.put('Depot__c', dp_list[i].Depot__c);
                    depoJSON.put('Country__c', dp_list[i].Country__c);
                    depoJSON.put('Name', dp_list[i].Name);
                    s.add(depoJSON);
                }
            }
        }

        options.addAll(s);
        return options;
    } 

    @AuraEnabled 
    public static WrapperPageResult getInventories(Decimal pageNumber,Integer recordToDisply,String SelectedDepots,boolean NoZeroSAPRecord ){ 
        try{
            StkReq_Map=new map<String,Stock_Requirement__c >();
            inventory_Map = new map<String,Inventory__c>();
            inventory_Map_Batchwise = new map<String,Inventory__c>();
            userId = UserInfo.getUserId();
            User LoginUser = [SELECT Id,Name ,Country,Profile.Name FROM User Where Id=:userId];
            String inventory_Query ='';
            String Stk_Req_Query ='';
            String Depot = '';
            List<String> ListOfDepots = new List<String>();
            
            if(SelectedDepots!= null && SelectedDepots!='All'){
                ListOfDepots = SelectedDepots.split(';');
            }
                      
           if(LoginUser.Profile.Name == 'System Administrator'){
                salesOrg_filter = '(Storage_Location_Depot__r.Country__c = \'Australia\' AND Storage_Location_Depot__r.Active__c = true AND Storage_Location_Depot__r.Depot__r.Name in :ListOfDepots )';
                salesOrg = '(Depot__r.Country__c = \'Australia\' AND Depot__r.Active__c = true AND SKU__r.SKU_Description__c !=\'\' AND Depot__r.Recordtype.Name=\'Depot\'  AND Depot__r.name in :ListOfDepots) AND ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0 )';//'(Depot__r.SalesOrg__r.Continent__c = \'South America\' AND SKU__r.SKU_Description__c !=\'\')';
           }
            else{
                System.debug('Inside user block');
                salesOrg_filter = '(Storage_Location_Depot__r.Country__c = \'Australia\' AND Storage_Location_Depot__r.Active__c = true AND Storage_Location_Depot__r.Depot__r.Name in :ListOfDepots)';
                salesOrg = '(Depot__r.Country__c = \'Australia\' AND Depot__r.Active__c = true AND SKU__r.SKU_Description__c !=\'\' AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :ListOfDepots) AND ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0 )';//'(Depot__r.SalesOrg__r.Continent__c = \'South America\' AND SKU__r.SKU_Description__c !=\'\')';
            }
            
            list<WrapStockReqInventory> lstWrapStkReqInventObj = new list<WrapStockReqInventory>();
            Integer pageSize = recordToDisply;  
            Integer offset = ((Integer)pageNumber - 1) * pageSize;
            if(offset<0){
               offset=0; 
            }
            WrapperPageResult wObj = new WrapperPageResult();
            wObj.pageSize = pageSize;
            wObj.page = (Integer) pageNumber; 
            list<Stock_Requirement__c> lstStkreq = new list<Stock_Requirement__c>();
            list<Inventory__c> lstInventory = new list<Inventory__c>();
            Stk_Req_Query = 'SELECT Id,Quantities_Scheduled_for_Delivery__c, Name, SKU__r.SKU_Description__c,Depot__c,SKU__r.SKU_Code__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Europe__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.Active__c =true and SKU__r.Material_type__c != \'ROH\' AND '+salesOrg+'  order by SKU__r.SKU_Description__c  LIMIT :recordToDisply  OFFSET :offset'; // Updated for INC0418898 GRZ(Dheeraj Sharma) 05-12-2022 

            lstStkreq = database.query(Stk_Req_Query);
            //Updated for RITM0551759 09-05-2023 - Added Quantities_Scheduled_for_Delivery__c Field.
            
          	inventory_Query = 'SELECT Id, Name,Production_Date__c,Expiry_Date__c,Quantities_Scheduled_for_Delivery__c,Storage_Location_Depot__c, Depot__r.Depot_Code__c,Storage_Location_Depot__r.name,Storage_Location_Depot__r.Location__c,Storage_Location_Depot__r.Depot_Code__c,Batch_Number__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,Stock_Quantity__c,UOM__c FROM Inventory__c WHERE SKU__r.Active__c =true and '+ salesOrg_filter; // Updated for INC0418898 GRZ(Dheeraj Sharma) 05-12-2022 

            lstInventory = database.query(inventory_Query);
           	for(Stock_Requirement__c  stk :lstStkreq  ){
                if( NoZeroSAPRecord == true){
                    if(stk.Unrestricted_Stock__c != 0){
                        string key = stk.Depot__r.Depot_Code__c + stk.SKU__r.SKU_Code__c;
                        StkReq_Map.put(key,stk);
                    }
                }else{
                    string key = stk.Depot__r.Depot_Code__c + stk.SKU__r.SKU_Code__c;
                    StkReq_Map.put(key,stk);
                }
            }
            for(Inventory__c inv :lstInventory){
                string key_batchWise = inv.Depot__r.Depot_Code__c + inv.SKU__r.SKU_Code__c + inv.Storage_Location_Depot__r.Depot_Code__c + inv.Batch_Number__c;
                string key = inv.Depot__r.Depot_Code__c + inv.SKU__r.SKU_Code__c + inv.Storage_Location_Depot__r.Depot_Code__c ;
                if(!inventory_Map_Batchwise.containsKey(key_batchWise)){
                    inventory_Map.put(key_batchWise, inv);
                }
            }
            wObj.total =[SELECT COUNT() FROM Stock_Requirement__c 
                          WHERE SKU__r.Active__c = true AND Depot__r.Country__c = 'Australia'  // Updated for INC0418898 GRZ(Dheeraj Sharma) 05-12-2022 
                          AND  SKU__r.Material_type__c !='ROH'
                          AND Depot__r.name in :ListOfDepots
                          AND Depot__r.Active__c = true
                          AND  ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0  )];
            
            for(Stock_Requirement__c sreq : StkReq_Map.values()){
                WrapStockReqInventory wrapObj = new WrapStockReqInventory(); 
                wrapObj.stkReq = sreq;
                for(Inventory__c inv :inventory_Map.values()){
                    if(sreq.SKU__r.SKU_Code__c == inv.SKU__r.SKU_Code__c && sreq.Depot__c == inv.Depot__c){
                        wrapObj.lstStrLocInv.add(inv);   
                    }
                }  
                
                lstWrapStkReqInventObj.add(wrapObj);   
            } 
            wObj.listWrapStkReqInv = lstWrapStkReqInventObj;
            wObj.lastPageCount = (math.mod(wObj.total,wObj.pageSize) == 0)?wObj.total/wObj.pageSize:(wObj.total/wObj.pageSize)+1;
            return wObj;  
        }catch(Exception e){
            system.debug('Error Message >>--->'+e.getMessage());
            system.debug('Error Message Line Number >>--->'+e.getLineNumber());
            return null;
        }
    } 

    // This method used for reterived  the list of Inventory records based on the search string 
    @AuraEnabled 
    public static WrapperPageResult getBySKUAndSLocation(String fieldName ,String value,Decimal pageNumber,Integer recordToDisply, String SelectedDepots,boolean NoZeroSAPRecord) { 
        try{
            List<String> ListOfDepots = new List<String>();
            if(SelectedDepots!= null || SelectedDepots!=''){
                ListOfDepots = SelectedDepots.split(';');
            }
            if( fieldName == 'Product/Sku'){
                salesOrg_SKU = '(Depot__r.Country__c = \'Australia\' AND Depot__r.Active__c = true AND SKU__r.SKU_Description__c !=\'\' AND SKU__r.SKU_Description__c  like :value  AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :ListOfDepots ) AND ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0 )';
            }
            else if(fieldName == 'SKU Code'){
                salesOrg_SKU = '(Depot__r.Country__c = \'Australia\' AND Depot__r.Active__c = true AND SKU__r.SKU_Description__c !=\'\' AND SKU__r.SKU_Code__c  like :value  AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :ListOfDepots ) AND ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0 )';
            }else if(fieldName == 'Brand Name'){
			    salesOrg_SKU = '(Depot__r.Country__c = \'Australia\' AND Depot__r.Active__c = true AND SKU__r.SKU_Description__c !=\'\' AND SKU__r.Brand_Name__c  like :value  AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :ListOfDepots ) AND ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0 )';
            }
            
            if( fieldName == 'Product/Sku'){
                value = value.toUpperCase();
            }
            userId = UserInfo.getUserId();           
            User LoginUser = [SELECT Id,Name, Country,Profile.Name FROM User Where Id=:userId];
            salesOrg_filter = '(Storage_Location_Depot__r.Country__c = \'Australia\' AND Storage_Location_Depot__r.Active__c = true AND Storage_Location_Depot__r.Depot__r.Name in :ListOfDepots)';
            salesOrg = '(Depot__r.Country__c = \'Australia\' AND Depot__r.Active__c = true AND SKU__r.SKU_Description__c !=\'\' AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :ListOfDepots ) AND ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0 )';
        	list<WrapStockReqInventory> lstWrapStkReqInventObj = new list<WrapStockReqInventory>();
            list<Stock_Requirement__c> lstStkreq = new list<Stock_Requirement__c>();
            list<Inventory__c> lstInventory = new list<Inventory__c>();
            Integer pageSize = 0;
            pageSize = recordToDisply;  
            Integer offset = ((Integer)pageNumber - 1) * pageSize;
            WrapperPageResult wObj = new WrapperPageResult();
            wObj.pageSize = pageSize;
            wObj.page = (Integer) pageNumber; 
            string stkReqQuery = '';
            string invtryQuery = '';
            string salesOrgFil = salesOrg_filter;
            Boolean isStorageloc = false;
            if(!String.isBlank(value)){
                value = '%'+value+'%';
                if( fieldName == 'Product/Sku' || fieldName == 'SKU Code'){
                        stkReqQuery = 'SELECT Id, Name,Quantities_Scheduled_for_Delivery__c, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Europe__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE '+salesOrg_SKU+' order by SKU__r.SKU_Description__c';
                        list<Stock_Requirement__c> lstStkreqW_OOffset = new list<Stock_Requirement__c>();
                        lstStkreqW_OOffset = database.query(stkReqQuery);
                        if(lstStkreqW_OOffset.size()<=pageSize){
                            offset=0;  
                        }                         
                    stkReqQuery = 'SELECT Id, Name,Quantities_Scheduled_for_Delivery__c, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Europe__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE '+salesOrg_SKU+' order by SKU__r.SKU_Description__c LIMIT :recordToDisply  OFFSET :offset '; 
                    //Updated for RITM0551759 09-05-2023 - Added Quantities_Scheduled_for_Delivery__c Field.
                    invtryQuery ='SELECT Id, Name,Quantities_Scheduled_for_Delivery__c,Storage_Location_Depot__c, Storage_Location_Depot__r.name,Storage_Location_Depot__r.Location__c,SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Stock_Quantity__c,UOM__c,Batch_Number__c,Production_Date__c,Expiry_Date__c FROM Inventory__c WHERE '+salesOrgFil+' ';
                    lstStkreq = database.query(stkReqQuery);
                    lstInventory =  database.query(invtryQuery);
					wObj.total = [SELECT COUNT() FROM Stock_Requirement__c 
                                WHERE Depot__r.Country__c = 'Australia' 
                                AND Depot__r.name in :ListOfDepots
                                AND Depot__r.Active__c = true
                                AND  (Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0  ) ];
                    
                    
                }else if(fieldName == 'Storage Location'){
                     //Updated for RITM0551759 09-05-2023 - Added Quantities_Scheduled_for_Delivery__c Field.
					invtryQuery ='SELECT Id, Name,Storage_Location_Depot__c, Storage_Location_Depot__r.name,Storage_Location_Depot__r.Location__c,SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Stock_Quantity__c,UOM__c,Batch_Number__c,Production_Date__c,Expiry_Date__c,Quantities_Scheduled_for_Delivery__c FROM Inventory__c WHERE '+salesOrgFil+' AND  Storage_Location_Depot__r.Location__c like :value';
                    lstInventory =  database.query(invtryQuery);
                    set<string> setSku = new set<string>();
                    for(Inventory__c inv : lstInventory){
                        setSku.add(inv.SKU__r.SKU_Description__c);         
                    }  
                    stkReqQuery = 'SELECT Id,Quantities_Scheduled_for_Delivery__c, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Europe__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  IN :setSku AND '+salesOrg+' order by SKU__r.SKU_Description__c';
                    list<Stock_Requirement__c> lstStkreqW_OOffset = new list<Stock_Requirement__c>();
                    lstStkreqW_OOffset = database.query(stkReqQuery);
                    if(lstStkreqW_OOffset.size()<=pageSize){
                        offset=0;  
                    }  
                    stkReqQuery = 'SELECT Id, Name,Quantities_Scheduled_for_Delivery__c, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Europe__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  IN :setSku AND '+salesOrg+' order by SKU__r.SKU_Description__c LIMIT :recordToDisply  OFFSET :offset ';   
                    lstStkreq = database.query(stkReqQuery);
                    list<Stock_Requirement__c> lstStkreq1 = new list<Stock_Requirement__c>();
                    for(Stock_Requirement__c stkrreq : lstStkreq){
                        lstStkreq1.add(stkrreq);
                    }
                    lstStkreq = lstStkreq1;
                    isStorageloc = true;
                    wObj.total =[SELECT count() FROM Stock_Requirement__c
                                WHERE Depot__r.Country__c = 'Australia'
                                AND Depot__r.name in :ListOfDepots
                                AND Depot__r.Active__c = true
                                AND (Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0  )
                                AND SKU__r.SKU_Description__c  IN :setSku  ];
                    
                }else if(fieldName == 'Brand Name'){
                    stkReqQuery = 'SELECT Id, Name,Quantities_Scheduled_for_Delivery__c, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c, SKU__r.Brand_Name__c,Depot__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Europe__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE '+salesOrg_SKU+' order by SKU__r.SKU_Description__c';
                    list<Stock_Requirement__c> lstStkreqW_OOffset = new list<Stock_Requirement__c>();
                    lstStkreqW_OOffset = database.query(stkReqQuery);
                    if(lstStkreqW_OOffset.size()<=pageSize){
                        offset=0;  
                    }                         
                    stkReqQuery = 'SELECT Id, Name,Quantities_Scheduled_for_Delivery__c, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c, SKU__r.Brand_Name__c,Depot__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Europe__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE '+salesOrg_SKU+' order by SKU__r.SKU_Description__c LIMIT :recordToDisply  OFFSET :offset '; 
                	//Updated for RITM0551759 09-05-2023 - Added Quantities_Scheduled_for_Delivery__c Field.
                    invtryQuery ='SELECT Id, Name,Storage_Location_Depot__c, Storage_Location_Depot__r.name,Quantities_Scheduled_for_Delivery__c,Storage_Location_Depot__r.Location__c,SKU__r.SKU_Description__c, SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,Stock_Quantity__c,UOM__c,Batch_Number__c,Production_Date__c,Expiry_Date__c FROM Inventory__c WHERE '+salesOrgFil+' ';
                    lstStkreq = database.query(stkReqQuery);
                    lstInventory =  database.query(invtryQuery);
					wObj.total = [SELECT COUNT() FROM Stock_Requirement__c 
                                WHERE Depot__r.Country__c = 'Australia' 
                                  //AND  SKU__r.Material_type__c !='ROH'
                                AND Depot__r.name in :ListOfDepots
                                AND Depot__r.Active__c = true
                                AND  (Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0  ) ];
                }
            }
            else{
                stkReqQuery = 'SELECT Id,Quantities_Scheduled_for_Delivery__c, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Europe__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE '+salesOrg+'  order by SKU__r.SKU_Description__c  LIMIT :recordToDisply  OFFSET :offset'; 
                 //Updated for RITM0551759 09-05-2023 - Added Quantities_Scheduled_for_Delivery__c Field.
                invtryQuery ='SELECT Id, Name,Storage_Location_Depot__c, SKU__r.SKU_Code__c, Storage_Location_Depot__r.name,Storage_Location_Depot__r.Location__c,SKU__r.SKU_Description__c,Quantities_Scheduled_for_Delivery__c,Stock_Quantity__c,UOM__c,Batch_Number__c,Production_Date__c,Expiry_Date__c FROM Inventory__c WHERE '+salesOrgFil; 
                lstStkreq = database.query(stkReqQuery);
                lstInventory =  database.query(invtryQuery);
                wObj.total =[SELECT count() FROM Stock_Requirement__c WHERE Depot__r.Country__c = 'Australia'  
                            AND Depot__r.name in :ListOfDepots 
                            AND Depot__r.Active__c = true
                            AND ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0  )
                            AND SKU__r.SKU_Description__c  like :value  ];
            }
            for(Stock_Requirement__c sreq : lstStkreq){
                WrapStockReqInventory wrapObj = new WrapStockReqInventory(); 
                wrapObj.stkReq = sreq;
                for(Inventory__c inv :lstInventory){
                    if(sreq.SKU__r.SKU_Description__c == inv.SKU__r.SKU_Description__c){
                        wrapObj.lstStrLocInv.add(inv);   
                    }
                }    
                lstWrapStkReqInventObj.add(wrapObj);   
            }  
            
            wObj.listWrapStkReqInv = lstWrapStkReqInventObj;
            wObj.lastPageCount = (math.mod(wObj.total,wObj.pageSize) == 0)?wObj.total/wObj.pageSize:(wObj.total/wObj.pageSize)+1;
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
        @AuraEnabled public Integer lastPageCount {get;set;}
        @AuraEnabled public boolean isAdmin{get;set;}
        @AuraEnabled public List<WrapStockReqInventory> listWrapStkReqInv {get;set;}
        
        public WrapperPageResult(){
            pageSize = 0;
            page = 0;
            total = 0;
            lastPageCount=0;
        	userId = UserInfo.getUserId();
            User LoginUser = [SELECT Id, Country,Profile.Name FROM User Where Id=:userId];
            isAdmin=LoginUser.Profile.Name == 'System Administrator' ?True:False;
        }
    }
    
    public class WrapStockReqInventory{
        @AuraEnabled public Stock_Requirement__c  stkReq{get;set;}
        @AuraEnabled public list<Inventory__c> lstStrLocInv{get;set;}
        public WrapStockReqInventory(){
            stkReq = new Stock_Requirement__c();
            lstStrLocInv = new  list<Inventory__c>();
        }        
    }


}