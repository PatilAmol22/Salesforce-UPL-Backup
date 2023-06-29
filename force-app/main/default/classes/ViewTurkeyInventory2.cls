public class ViewTurkeyInventory2 {

    public static string userId;
    public static list<User_Material_Type_Mapping__c> listUser;
    public static string materialType;
    
    public static  String salesOrg_filter; 
    public static  String salesOrg;
	public static  String salesOrg_SKU; //To differentiate between SKU Descrpition and SKU Code   

    public static map<String,Stock_Requirement__c > StkReq_Map;
    public static map<String,Inventory__c> inventory_Map_Batchwise;
    public static map<String,Inventory__c> inventory_Map;

    public  ViewTurkeyInventory2(){
        System.debug('Cons-------');
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
        
        //Query multi select depot picklist based on the login user
        system.debug('Sohel user profile : '+u.Profile.Name);
        if(u.Profile.Name=='System Administrator' || u.Profile.Name=='Finese System Admin'){
            List<Depot__c> dp_list= [SELECT Id, Name, Country__c, Depot__c, Depot_Code__c, SalesOrg__r.Continent__c FROM Depot__c Where Country__c='Turkey' AND RecordType.Name='Depot' AND Active__c = true];
            System.debug('dp_list--IF------>'+dp_list);
            for(Integer i=0 ; i< dp_list.size() ;i++){
                Map<String, object> depoJSON = new Map<String, object>();
                System.debug('dp_list[i].Depot__c :---'+dp_list[i].Name);
                depoJSON.put('Depot_Code__c', dp_list[i].Depot_Code__c);
                depoJSON.put('Depot__c', dp_list[i].Depot__c);
                depoJSON.put('Country__c', dp_list[i].Country__c);
                depoJSON.put('Name', dp_list[i].Name);
                // s.add(dp_list[i].Name);
                s.add(depoJSON);
                
            }
        }
        //Else fetch depot list from TM depot mapping
        else{
            List<TM_Depot_Mapping__c> tdmList = [SELECT Id, Depot__c, Territory_Manager__c FROM TM_Depot_Mapping__c WHERE Territory_Manager__c=:userId];
            System.debug('tdmList--ELSE------>'+tdmList);
            Set<String> DepotIdSet = new Set<String>();
            for(TM_Depot_Mapping__c tdmObj:tdmList){
                DepotIdSet.add(tdmObj.Depot__c);
            }
            System.debug('DepotIdSet ---> '+DepotIdSet);
            if(DepotIdSet.size()>0){
                List<Depot__c> dp_list= [SELECT Id, Name, Country__c, Depot__c, Depot_Code__c, SalesOrg__r.Continent__c FROM Depot__c Where Id in: DepotIdSet AND Active__c = true];
                System.debug('dp_list--ELSE------>'+dp_list);
                for(Integer i=0 ; i< dp_list.size() ;i++){
                    Map<String, object> depoJSON = new Map<String, object>();
                    System.debug('dp_list[i].Depot__c :---'+dp_list[i].Name);
                    depoJSON.put('Depot_Code__c', dp_list[i].Depot_Code__c);
                    depoJSON.put('Depot__c', dp_list[i].Depot__c);
                    depoJSON.put('Country__c', dp_list[i].Country__c);
                    depoJSON.put('Name', dp_list[i].Name);
                    // s.add(dp_list[i].Name);
                    // s.add(JSON.serialize(depoJSON));
                    s.add(depoJSON);
                    
                }
            }
        }

        options.addAll(s);
        System.debug('DEPOT OPTION------>'+options);
        options.sort();
        return options;
    } 
    
    @AuraEnabled 
    public static WrapperPageResult getInventories(Decimal pageNumber,Integer recordToDisply,String SelectedDepots, boolean NoZeroSAPRecord  ){ 
        try{
            StkReq_Map=new map<String,Stock_Requirement__c >();
            inventory_Map = new map<String,Inventory__c>();
            inventory_Map_Batchwise = new map<String,Inventory__c>();

            userId = UserInfo.getUserId();
            User LoginUser = [SELECT Id,Name ,Country,Profile.Name FROM User Where Id=:userId];
            String inventory_Query ='';
            String Stk_Req_Query ='';
            String Depot = '';
            System.debug('LoginUser -->'+ LoginUser.Name);
            System.debug('SelectedDepots -->'+ SelectedDepots);
            List<String> ListOfDepots = new List<String>();
            
            if(SelectedDepots!= null && SelectedDepots!='All'){
                ListOfDepots = SelectedDepots.split(';');
                System.debug('ListOfDepots.size() ---> '+ListOfDepots.size());
                System.debug('ListOfDepots==> '+ListOfDepots);
            }
                      
           if(LoginUser.Profile.Name == 'System Administrator' || LoginUser.Profile.Name == 'Finese System Admin'){
                //System.debug('Inside Admin block');
                salesOrg_filter = '(Storage_Location_Depot__r.Country__c = \'Turkey\' AND Storage_Location_Depot__r.Depot__r.Name in :ListOfDepots )';
                // salesOrg_filter = '(Storage_Location_Depot__r.Country__c = \'Turkey\')';
                salesOrg = '(Depot__r.Country__c = \'Turkey\' AND SKU__r.SKU_Description__c !=\'\' AND Depot__r.Recordtype.Name=\'Depot\'  AND Depot__r.name in :ListOfDepots) AND ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0 )';//'(Depot__r.SalesOrg__r.Continent__c = \'Turkey\' AND SKU__r.SKU_Description__c !=\'\')';
           }
            else{
                System.debug('Inside user block');
                salesOrg_filter = '(Storage_Location_Depot__r.Country__c = \'Turkey\' AND Storage_Location_Depot__r.Depot__r.Name in :ListOfDepots)';
                salesOrg = '(Depot__r.Country__c = \'Turkey\' AND SKU__r.SKU_Description__c !=\'\' AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :ListOfDepots) AND ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0 )';//'(Depot__r.SalesOrg__r.Continent__c = \'Turkey\' AND SKU__r.SKU_Description__c !=\'\')';
            }
            
            System.debug('salesOrg_filter ----> '+salesOrg_filter+' Vs SalesOrg ----> '+salesOrg);
            
           /* listUser = [SELECT Id, Inventory_Material_Type__c,Inventory_Material_Type__r.Name, User__c, Name FROM User_Material_Type_Mapping__c WHERE user__c =: userId];
            for(User_Material_Type_Mapping__c ummap : listUser){ 
                materialType = ummap.Inventory_Material_Type__r.Name;
            }  
            system.debug('materialType>>--->'+materialType);
            */
            
            
            list<WrapStockReqInventory> lstWrapStkReqInventObj = new list<WrapStockReqInventory>();
            Integer pageSize = recordToDisply;  
            Integer offset = ((Integer)pageNumber - 1) * pageSize;
            system.debug('offset>>--->'+offset+' pageNumber>>--->'+pageNumber+' pageSize>>--->'+pageSize);
            //to avoid error when offset goes negative
            if(offset<0){
               offset=0; 
            }
            WrapperPageResult wObj = new WrapperPageResult();
            wObj.pageSize = pageSize;
            wObj.page = (Integer) pageNumber; 
            
            list<Stock_Requirement__c> lstStkreq = new list<Stock_Requirement__c>();
            list<Inventory__c> lstInventory = new list<Inventory__c>();
            
            //sohel work here
            Stk_Req_Query = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Turkey__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.Active__c = true and '+salesOrg+'  order by SKU__r.SKU_Description__c  LIMIT :recordToDisply  OFFSET :offset'; // Updated for INC0418898 GRZ(Dheeraj Sharma) 05-12-2022 

            system.debug('sohel Stk_Req_Query : '+Stk_Req_Query);
            
            lstStkreq = database.query(Stk_Req_Query);
            
            inventory_Query = 'SELECT Id, Name,Storage_Location_Depot__c, Storage_Location_Depot__r.name,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c,SKU__r.SKU_Description__c,Storage_Location_Depot__r.Depot_Code__c,SKU__r.SKU_Code__c,Stock_Quantity__c,UOM__c,Batch_Number__c,Production_Date__c,Expiry_Date__c FROM Inventory__c WHERE SKU__r.Active__c = true and '+ salesOrg_filter;// Updated for INC0418898 GRZ(Dheeraj Sharma) 05-12-2022 

            system.debug('Sohel inventory query : '+inventory_Query);
            
            lstInventory = database.query(inventory_Query);

            System.debug('IF NoZeroSAPRecord--->'+NoZeroSAPRecord);
            for(Stock_Requirement__c  stk :lstStkreq  ){
                if( NoZeroSAPRecord == true){
                    System.debug('IF stk--->'+stk);
                    if(stk.Unrestricted_Stock__c != 0){
                        System.debug('stk--->'+stk);
                        string key = stk.Depot__r.Depot_Code__c + stk.SKU__r.SKU_Code__c;
                        StkReq_Map.put(key,stk);
                    }
                }else{
                    string key = stk.Depot__r.Depot_Code__c + stk.SKU__r.SKU_Code__c;
                    StkReq_Map.put(key,stk);
                }
            }

            for(Inventory__c inv :lstInventory){
                // System.System.debug('FOR INV==>'+inv);
                // System.System.debug('FOR INV==>'+inv.Storage_Location_Depot__r);
                string key_batchWise = inv.Depot__r.Depot_Code__c + inv.SKU__r.SKU_Code__c + inv.Storage_Location_Depot__r.Depot_Code__c + inv.Batch_Number__c;
                string key = inv.Depot__r.Depot_Code__c + inv.SKU__r.SKU_Code__c + inv.Storage_Location_Depot__r.Depot_Code__c ;
                if(!inventory_Map_Batchwise.containsKey(key_batchWise)){
                    // if(inv.Storage_Location_Depot__r.Active__c == true){
                        inventory_Map.put(key_batchWise, inv);
                    // }
                    //inventory_Map_Batchwise.put(key_batchWise, inv); 
                }
                
            }
            
            //if(LoginUser.Country == 'Australia'){
            wObj.total = [SELECT COUNT() FROM Stock_Requirement__c 
                          WHERE SKU__r.Active__c = true AND Depot__r.Country__c = 'Turkey' // Updated for INC0418898 GRZ(Dheeraj Sharma) 05-12-2022 

                          //AND  SKU__r.Material_type__c !='ROH'
                          AND Depot__r.name in :ListOfDepots
                          AND  ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0  ) ];
             //}
            
            // if(LoginUser.Profile.Name == 'System Administrator'){
            //     wObj.total = [SELECT COUNT() FROM Stock_Requirement__c WHERE (Depot__r.SalesOrg__r.Sales_Org_Code__c = '7110' OR Depot__r.SalesOrg__r.Sales_Org_Code__c = '6100') AND SKU__r.SKU_Description__c !=''];
            // }
            // for(Stock_Requirement__c sr :lstStkreq){
            //     system.debug('lstStkreq>>--->'+sr.Depot__r.name);
            // }
            System.debug('lstStkreq ----> '+lstStkreq.size());
            for(Stock_Requirement__c sreq : StkReq_Map.values()){
                WrapStockReqInventory wrapObj = new WrapStockReqInventory(); 
                wrapObj.stkReq = sreq;
                for(Inventory__c inv :inventory_Map.values()){
                System.debug(sreq.SKU__r.SKU_Code__c+' == '+inv.SKU__r.SKU_Code__c+ ' && '+sreq.Depot__c+ ' == '+inv.Depot__c);
                    if(sreq.SKU__r.SKU_Code__c == inv.SKU__r.SKU_Code__c && sreq.Depot__c == inv.Depot__c){
                        wrapObj.lstStrLocInv.add(inv); 
                    }
                }  
                
                lstWrapStkReqInventObj.add(wrapObj);   
            } 
            wObj.listWrapStkReqInv = lstWrapStkReqInventObj;
            //for(WrapStockReqInventory wsr : lstWrapStkReqInventObj)
                //system.debug('pageSize>>--->'+  wObj.pageSize );
            //system.debug('page>>--->'+wObj.page);
            return wObj;  
        }catch(Exception e){
            system.debug('Error Message >>--->'+e.getMessage());
            system.debug('Error Message Line Number >>--->'+e.getLineNumber());
            return null;
        }
    } 
    // This method used for reterived  the list of Inventory records based on the search string 
    @AuraEnabled 
    public static WrapperPageResult getBySKUAndSLocation(String fieldName ,String value,Decimal pageNumber,Integer recordToDisply, String SelectedDepots, boolean NoZeroSAPRecord ) { 
        try{
            List<String> ListOfDepots = new List<String>();
            
            if(SelectedDepots!= null || SelectedDepots!=''){
                ListOfDepots = SelectedDepots.split(';');
                System.debug('ListOfDepots.size() ---> '+ListOfDepots.size());
                System.debug('ListOfDepots==> '+ListOfDepots);
            }
            
            if( fieldName == 'Product/Sku'){
                
                salesOrg_SKU = '(Depot__r.Country__c = \'Turkey\' AND SKU__r.SKU_Description__c !=\'\' AND SKU__r.SKU_Description__c  like :value  AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :ListOfDepots ) AND ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0 )';
            	//salesOrg_filter_SKU = '(Sales_Org__r.Continent__c = \'Turkey\' AND Storage_Location_Depot__r.Country__c = \'Turkey\' AND Storage_Location_Depot__r.Depot__r.Name in :ListOfDepots)';
            	 System.debug('Inside Product/SKU==> '+salesOrg_SKU);
                 value = value.toUpperCase();
            }
            else if(fieldName == 'SKU Code'){
                
                salesOrg_SKU = '(Depot__r.Country__c = \'Turkey\' AND SKU__r.SKU_Description__c !=\'\' AND SKU__r.SKU_Code__c  like :value  AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :ListOfDepots ) AND ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0 )';
            	//salesOrg_filter_SKU = '(Sales_Org__r.Continent__c = \'Turkey\' AND Storage_Location_Depot__r.Country__c = \'Turkey\' AND Storage_Location_Depot__r.Depot__r.Name in :ListOfDepots)';
            	System.debug('Inside SKU Code==> '+salesOrg_SKU);                    
            }else if(fieldName == 'Brand Name'){

                salesOrg_SKU = '(Depot__r.Country__c = \'Turkey\' AND SKU__r.SKU_Description__c !=\'\' AND SKU__r.Brand_Name__c  like :value  AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :ListOfDepots ) AND ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0 )';
                //salesOrg_filter_SKU = '(Sales_Org__r.Continent__c = \'Asia\' AND Storage_Location_Depot__r.Country__c = \'Turkey\' AND Storage_Location_Depot__r.Depot__r.Name in :ListOfDepots)';
                System.debug('Inside Brand_Name__c==> '+salesOrg_SKU);                    
            }
            
            
            userId = UserInfo.getUserId();           
            User LoginUser = [SELECT Id,Name, Country,Profile.Name FROM User Where Id=:userId];
            System.debug('LoginUser '+ LoginUser.Name);
           //if(LoginUser.Profile.Name == 'System Administrator'){
			//System.debug('Inside Admin block');
                // salesOrg_filter = '(Sales_Org__r.Continent__c = \'South America\' AND Storage_Location_Depot__r.Country__c = \'Turkey\' AND Storage_Location_Depot__r.Depot__r.Name in :ListOfDepots)';
                salesOrg_filter = '(Storage_Location_Depot__r.Country__c = \'Turkey\' AND Storage_Location_Depot__r.Depot__r.Name in :ListOfDepots)';
                salesOrg = '(Depot__r.Country__c = \'Turkey\' AND SKU__r.SKU_Description__c !=\'\' AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :ListOfDepots ) AND ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0 )';
            //}
            
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
            
            
            system.debug('value>>--->'+value);
            system.debug('fieldName>>--->'+fieldName);
            
            if(!String.isBlank(value)){
                value = '%'+value+'%';
                if( fieldName == 'Product/Sku' || fieldName == 'SKU Code'){
                        stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Turkey__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE '+salesOrg_SKU+' order by SKU__r.SKU_Description__c';
                        list<Stock_Requirement__c> lstStkreqW_OOffset = new list<Stock_Requirement__c>();
                        lstStkreqW_OOffset = database.query(stkReqQuery);
                        
                        if(lstStkreqW_OOffset.size()<=pageSize){
                            offset=0;  
                        }                         
                        
                        stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Turkey__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE '+salesOrg_SKU+' order by SKU__r.SKU_Description__c LIMIT :recordToDisply  OFFSET :offset '; 
                    
                    
                    invtryQuery ='SELECT Id, Name,Storage_Location_Depot__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Storage_Location_Depot__r.name,SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Stock_Quantity__c,UOM__c,Batch_Number__c,Production_Date__c,Expiry_Date__c FROM Inventory__c WHERE '+salesOrgFil+' ';
                    /*system.debug('stkReqQuery>>--->'+stkReqQuery);
                    system.debug('invtryQuery>>--->'+invtryQuery);
                    system.debug('SKU');
					*/
                    lstStkreq = database.query(stkReqQuery);
                    lstInventory =  database.query(invtryQuery);
                   
                    wObj.total = [SELECT COUNT() FROM Stock_Requirement__c 
                                  WHERE Depot__r.Country__c = 'Turkey' 
                                  //AND  SKU__r.Material_type__c !='ROH'
                                  AND Depot__r.name in :ListOfDepots
                                  AND  (Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0  ) ];
                    /*if(LoginUser.Profile.Name == 'System Administrator'){
                    wObj.total =[SELECT count() FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  like :value AND (Depot__r.SalesOrg__r.Sales_Org_Code__c = '7110' OR Depot__r.SalesOrg__r.Sales_Org_Code__c = '6100') AND SKU__r.SKU_Description__c !=''];
                    }*/
                    
                }else if(fieldName == 'Storage Location'){

                    System.debug('Inside Storage Location Apex > Value> '+value);
                    
                    System.debug('Inside Storage Location Apex > Value> salesOrgFil>'+salesOrgFil);

                    //salesOrgFil += ' AND  SKU__r.Material_type__c !=\'ROH\'';
                    
                    invtryQuery ='SELECT Id, Name,Storage_Location_Depot__c, Storage_Location_Depot__r.name,SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Stock_Quantity__c,UOM__c,Batch_Number__c,Production_Date__c,Expiry_Date__c FROM Inventory__c WHERE '+salesOrgFil+' AND  Storage_Location_Depot__r.name like :value';
                    lstInventory =  database.query(invtryQuery);
                    //System.debug('lstInventory size---> '+lstInventory.size());
                    set<string> setSku = new set<string>();
                    for(Inventory__c inv : lstInventory){
                        setSku.add(inv.SKU__r.SKU_Description__c);         
                    }  
                    
                    stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Turkey__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  IN :setSku AND '+salesOrg+' order by SKU__r.SKU_Description__c';
                    list<Stock_Requirement__c> lstStkreqW_OOffset = new list<Stock_Requirement__c>();
                    lstStkreqW_OOffset = database.query(stkReqQuery);
                    
                    if(lstStkreqW_OOffset.size()<=pageSize){
                        offset=0;  
                    }  
                    
                    stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Turkey__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  IN :setSku AND '+salesOrg+' order by SKU__r.SKU_Description__c LIMIT :recordToDisply  OFFSET :offset ';   
                    
                    //system.debug('query>>--->'+stkReqQuery);
                    //system.debug('query>>--->'+invtryQuery);
                    lstStkreq = database.query(stkReqQuery);
                    //system.debug('lstStkreq size>>--->'+lstStkreq.size());
                    //system.debug('lstStkreq1 size>>--->'+lstStkreq);
                    list<Stock_Requirement__c> lstStkreq1 = new list<Stock_Requirement__c>();
                    for(Stock_Requirement__c stkrreq : lstStkreq){
                        //if(stkrreq.SKU__r.Material_type__c != 'ROH' && materialType != 'ROH'){
                            lstStkreq1.add(stkrreq);
                        //}
                    }
                    //if(materialType != 'ROH'){
                        lstStkreq = lstStkreq1;
                    //}           
                    //system.debug('lstStkreq1 size>>--->'+lstStkreq.size());
                    //system.debug('lstStkreq1 size>>--->'+lstStkreq);
                    
                    isStorageloc = true;
                    system.debug('storage Location');
                     //if(LoginUser.Country == 'Australia'){
                    wObj.total =[SELECT count() FROM Stock_Requirement__c
                                 WHERE Depot__r.Country__c = 'Turkey'
                                 AND Depot__r.name in :ListOfDepots
                                 AND (Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0  )
                                 AND SKU__r.SKU_Description__c  IN :setSku  ];
                     //}
                   
                    /*if(LoginUser.Profile.Name == 'System Administrator'){
                    wObj.total =[SELECT count() FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  IN :setSku ];
                     }*/
                }else if(fieldName == 'Brand Name'){
                    System.debug('Inside Brand Name Apex > Value> '+value);
                    
                    System.debug('Inside Brand Name Apex > Value> salesOrgFil>'+salesOrgFil);

                    System.debug('Inside Brand Name Apex > Value> salesOrg>'+salesOrg);

                    stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c, SKU__r.Brand_Name__c,Depot__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Turkey__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE '+salesOrg_SKU+' order by SKU__r.SKU_Description__c';
                    list<Stock_Requirement__c> lstStkreqW_OOffset = new list<Stock_Requirement__c>();
                    lstStkreqW_OOffset = database.query(stkReqQuery);
                    
                    if(lstStkreqW_OOffset.size()<=pageSize){
                        offset=0;  
                    }                         
                    
                    stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c, SKU__r.Brand_Name__c,Depot__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Turkey__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE '+salesOrg_SKU+' order by SKU__r.SKU_Description__c LIMIT :recordToDisply  OFFSET :offset '; 
                
                    invtryQuery ='SELECT Id, Name,Storage_Location_Depot__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Storage_Location_Depot__r.name,SKU__r.SKU_Description__c, SKU__r.Brand_Name__c,SKU__r.SKU_Code__c,Stock_Quantity__c,UOM__c,Batch_Number__c,Production_Date__c,Expiry_Date__c FROM Inventory__c WHERE '+salesOrgFil+' ';
                    
                    lstStkreq = database.query(stkReqQuery);
                    lstInventory =  database.query(invtryQuery);

                    System.debug('-Filter lstStkreq->'+lstStkreq);
                    System.debug('-Filter lstInventory->'+lstInventory);

                    wObj.total = [SELECT COUNT() FROM Stock_Requirement__c 
                                WHERE Depot__r.Country__c = 'Turkey' 
                                  //AND  SKU__r.Material_type__c !='ROH'
                                AND Depot__r.name in :ListOfDepots
                                AND  (Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0  ) ];
                }
            }
            else{
                system.debug('value>>--->'+value);
                
                //string materialval ='ROH';
                stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Turkey__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE '+salesOrg+'  order by SKU__r.SKU_Description__c  LIMIT :recordToDisply  OFFSET :offset'; 
                // system.debug('query>>--->'+stkReqQuery);
                
                invtryQuery ='SELECT Id, Name,Storage_Location_Depot__c, SKU__r.SKU_Code__c,Depot__r.Depot_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Storage_Location_Depot__r.name,SKU__r.SKU_Description__c,Stock_Quantity__c,UOM__c,Batch_Number__c,Production_Date__c,Expiry_Date__c FROM Inventory__c WHERE '+salesOrgFil; 
                //system.debug('query>>--->'+stkReqQuery);
                //system.debug('query>>--->'+invtryQuery);
                lstStkreq = database.query(stkReqQuery);
                lstInventory =  database.query(invtryQuery);
                //if(LoginUser.Country == 'Australia'){
                wObj.total =[SELECT count() FROM Stock_Requirement__c WHERE Depot__r.Country__c = 'Turkey'  
                             AND Depot__r.name in :ListOfDepots 
                             AND ( Unrestricted_Stock__c != 0 OR Stock_In_Transit__c != 0 OR Purchase_Order_Stock__c != 0  )
                             AND SKU__r.SKU_Description__c  like :value  ];
                // }
                
                /*if(LoginUser.Profile.Name == 'System Administrator'){
				wObj.total =[SELECT count() FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  like :value ];
				}
                system.debug('wObj.total >>--->'+wObj.total);
				*/
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
        @AuraEnabled public boolean isAdmin {get;set;}
        @AuraEnabled public List<WrapStockReqInventory> listWrapStkReqInv {get;set;}
        @AuraEnabled public boolean allowLineItem{get;set;}
        
        public WrapperPageResult(){
            pageSize = 0;
            page = 0;
            total = 0;
        	 userId = UserInfo.getUserId();
            User LoginUser = [SELECT Id, Country,Profile.Name FROM User Where Id=:userId];
            isAdmin = LoginUser.Profile.Name == 'System Administrator' ? True : LoginUser.Profile.Name == 'Finese System Admin' ? True : False;
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