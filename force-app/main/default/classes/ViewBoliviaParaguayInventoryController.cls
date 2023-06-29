public class ViewBoliviaParaguayInventoryController {
	public static string userId;
    public static list<User_Material_Type_Mapping__c> listUser;
    public static string materialType;
    public static map<String,Inventory__c> inventory_Map_Batchwise;
    public static map<String,Inventory__c> inventory_Map;
    public static map<String,Stock_Requirement__c > StkReq_Map;
    public static String salesOrg_filter; 
    public static String salesOrg;
    public static set<Id> PublicGroupMembers;
    public static boolean isNewzealandUser;
    
    public  ViewBoliviaParaguayInventoryController(){
        
        System.debug('Cons-------');
        listUser = new list<User_Material_Type_Mapping__c>();
        materialType ='';
        userId ='';
        salesOrg_filter = ''; 
        salesOrg = '';
        
    }
    
    @AuraEnabled
    public static List<Object> getDepot(){
        string userId = userinfo.getUserId();
        List<Object> options = new List<Object>();
        List<Object> s = new List<Object>();
        system.debug('userId: '+userId);
        User u = [SELECT Id,Name,Country,Profile.Name FROM User WHERE Id=:userId];
        
        //Query multi select depot picklist based on the login user
        system.debug('user profile : '+u.Profile.Name);
        if(u.Profile.Name=='System Administrator' || u.Country=='Bolivia' || u.Country=='Paraguay'){
            //If System Admin
            List<Depot__c> dp_list= [SELECT Id, Name, Country__c, Depot__c, Depot_Code__c, SalesOrg__r.Continent__c FROM Depot__c Where Country__c=:u.Country AND RecordType.Name='Depot'];// AND Active__c = true];
            System.debug('dp_list--IF------>'+dp_list);
            for(Integer i=0 ; i< dp_list.size() ;i++){
                Map<String, object> depoJSON = new Map<String, object>();
                //if(dp_list[i].Depot__c!=null){
                    System.debug('dp_list[i].Depot__c :---'+dp_list[i].Name);
                    depoJSON.put('Depot_Code__c', dp_list[i].Depot_Code__c);
                    depoJSON.put('Depot__c', dp_list[i].Depot__c);
                    depoJSON.put('Country__c', dp_list[i].Country__c);
                    depoJSON.put('Name', dp_list[i].Name);
                    // s.add(dp_list[i].Name);
                    s.add(depoJSON);
                //}
                
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
        //options.sort();
        return options;
    } 
    @AuraEnabled 
    public static WrapperPageResult getInventories(Decimal pageNumber,Integer recordToDisply, String SelectedDepots, boolean NoZeroSAPRecord){ 
        try{
            inventory_Map = new map<String,Inventory__c>();
            inventory_Map_Batchwise = new map<String,Inventory__c>();
            StkReq_Map=new map<String,Stock_Requirement__c >();
            PublicGroupMembers = new set<Id>();
            isNewzealandUser = false;
            
            /*for(groupmember gp  : [select userorgroupid from groupmember where group.name = 'Australia-New Zealand Users']){
                PublicGroupMembers.add(gp.userorgroupid);
            }*/
            userId = UserInfo.getUserId();
            User LoginUser = [SELECT Id, Country,Profile.Name,UserRole.Name FROM User Where Id=:userId];
           
            String inventory_Query ='';
            String Stk_Req_Query ='';
            
            List<String> ListOfDepots = new List<String>();
            System.debug('SelectedDepots==> '+SelectedDepots);
            if(SelectedDepots!= null && SelectedDepots!='All'){
                ListOfDepots = SelectedDepots.split(';');
                System.debug('ListOfDepots.size() ---> '+ListOfDepots.size());
                System.debug('ListOfDepots==> '+ListOfDepots);
            }
            
            
            System.debug('LoginUser :'+ LoginUser);
            if(LoginUser.Country == 'Bolivia'){
                System.debug('Inside Bolivia');
                salesOrg_filter = 'Sales_Org__r.Sales_Org_Code__c =  \'5361\' AND Storage_Location_Depot__r.SalesOrg__r.Sales_Org_Code__c = \'5361\' AND Stock_Quantity__c != 0 AND Storage_Location_Depot__r.Depot__r.Name in :ListOfDepots';     //'5361';
                salesOrg ='Depot__r.SalesOrg__r.Sales_Org_Code__c = \'5361\'  AND SKU__r.SKU_Description__c !=\'\' AND ( Unrestricted_Stock__c != 0 OR Sales_Order_Stock__c != 0 OR Delivery_Stock__c != 0 OR Available_Stock__c != 0 ) AND Depot__r.Recordtype.Name=\'Depot\'  AND Depot__r.name in :ListOfDepots';
            }
            else if(LoginUser.Country == 'Paraguay'){
                System.debug('Inside Paraguay');
                salesOrg_filter = 'Sales_Org__r.Sales_Org_Code__c =  \'5441\' AND Storage_Location_Depot__r.SalesOrg__r.Sales_Org_Code__c = \'5441\' AND Stock_Quantity__c != 0 AND Storage_Location_Depot__r.Depot__r.Name in :ListOfDepots';  
                salesOrg ='Depot__r.SalesOrg__r.Sales_Org_Code__c = \'5441\'  AND SKU__r.SKU_Description__c !=\'\' AND ( Unrestricted_Stock__c != 0 OR Sales_Order_Stock__c != 0 OR Delivery_Stock__c != 0 OR Available_Stock__c != 0 ) AND Depot__r.Recordtype.Name=\'Depot\'  AND Depot__r.name in :ListOfDepots';
            }
            
            else if(LoginUser.Profile.Name == 'System Administrator'){
                System.debug('Inside Admin block');
                salesOrg_filter = '(Sales_Org__r.Sales_Org_Code__c = \'5361\' OR Sales_Org__r.Sales_Org_Code__c =  \'6100\' OR Sales_Org__r.Sales_Org_Code__c =  \'5441\') AND (Storage_Location_Depot__r.SalesOrg__r.Sales_Org_Code__c = \'6100\' OR Storage_Location_Depot__r.SalesOrg__r.Sales_Org_Code__c = \'5361\' OR Storage_Location_Depot__r.SalesOrg__r.Sales_Org_Code__c = \'5441\') AND Storage_Location_Depot__r.Depot__r.Name in :ListOfDepots';
                salesOrg = '(Depot__r.SalesOrg__r.Sales_Org_Code__c = \'5361\' OR Depot__r.SalesOrg__r.Sales_Org_Code__c = \'6100\' OR Depot__r.SalesOrg__r.Sales_Org_Code__c =  \'5441\') AND SKU__r.SKU_Description__c !=\'\'  AND SKU__r.SKU_Description__c !=\'\' AND Depot__r.Recordtype.Name=\'Depot\'  AND Depot__r.name in :ListOfDepots';
            }
            
            System.debug('salesOrg --->'+salesOrg+' And  salesOrg_filter ----> '+salesOrg_filter +'Vs LoginUser.Country'+LoginUser.Country);
            
            listUser = [SELECT Id, Inventory_Material_Type__c,Inventory_Material_Type__r.Name, User__c, Name FROM User_Material_Type_Mapping__c WHERE user__c =: userId];
            for(User_Material_Type_Mapping__c ummap : listUser){ 
                materialType = ummap.Inventory_Material_Type__r.Name;
            }  
            system.debug('materialType>>--->'+materialType);
             
            list<WrapStockReqInventory> lstWrapStkReqInventObj = new list<WrapStockReqInventory>();
            Integer pageSize = recordToDisply;  
            Integer offset = ((Integer)pageNumber - 1) * pageSize; 
            WrapperPageResult wObj = new WrapperPageResult();
            wObj.pageSize = pageSize;
            wObj.page = (Integer) pageNumber; 
            
            list<Stock_Requirement__c> lstStkreq = new list<Stock_Requirement__c>();
            list<Inventory__c> lstInventory = new list<Inventory__c>();
            
            if(materialType =='ROH'){
                Stk_Req_Query = 'SELECT Id, Name, SKU__r.SKU_Description__c ,SKU__r.SKU_Code__c,Depot__c, Depot__r.name, Depot__r.Depot_Code__c, Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE '+salesOrg+'  SKU__r.Active__c = true and order by SKU__r.SKU_Description__c  LIMIT :recordToDisply  OFFSET :offset'; // Updated for INC0418898 GRZ(Dheeraj Sharma) 05-12-2022 

                lstStkreq = database.query(Stk_Req_Query);
            }else{
				Stk_Req_Query = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.Depot_Code__c,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.Active__c = true and SKU__r.Material_type__c != \'ROH\' AND '+salesOrg+'  order by SKU__r.SKU_Description__c  LIMIT :recordToDisply  OFFSET :offset';// Updated for INC0418898 GRZ(Dheeraj Sharma) 05-12-2022 

                lstStkreq = database.query(Stk_Req_Query);
                
            }
            
            system.debug('salesOrg_filter>>--->'+salesOrg_filter); 
            system.debug('lstStkreq>>--->'+lstStkreq);
            
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
            
            
            /*lstInventory = [SELECT Id, Name,Storage_Location_Depot__c, Storage_Location_Depot__r.name,SKU__r.SKU_Description__c,Stock_Quantity__c
FROM Inventory__c
WHERE Sales_Org__r.Sales_Org_Code__c = :salesOrg_filter];
*/
            inventory_Query = 'SELECT Id,Batch_Number__c,Name,Production_Date__c,Expiry_Date__c,Storage_Location_Depot__c,Storage_Location_Depot__r.Depot_Code__c,SKU__r.SKU_Code__c, Depot__r.Depot_Code__c ,Storage_Location_Depot__r.name,SKU__r.SKU_Description__c,Stock_Quantity__c,UOM__c FROM Inventory__c WHERE SKU__r.Active__c = true and '+ salesOrg_filter;// Updated for INC0418898 GRZ(Dheeraj Sharma) 05-12-2022
            lstInventory = database.query(inventory_Query);
            system.debug('lstInventory>>--->'+lstInventory);
             if(LoginUser.Country == 'Bolivia'){
            wObj.total = [SELECT COUNT() FROM Stock_Requirement__c WHERE SKU__r.Active__c = true AND Depot__r.SalesOrg__r.Sales_Org_Code__c = '5361' AND ( Unrestricted_Stock__c != 0 OR Sales_Order_Stock__c != 0 OR Delivery_Stock__c != 0 OR Available_Stock__c != 0 ) ]; // Updated for INC0418898 GRZ(Dheeraj Sharma) 05-12-2022 

             }
            
            if(LoginUser.Country == 'Paraguay'){
            wObj.total = [SELECT COUNT() FROM Stock_Requirement__c WHERE SKU__r.Active__c = true AND Depot__r.SalesOrg__r.Sales_Org_Code__c = '5441' AND  SKU__r.SKU_Description__c !=null AND ( Unrestricted_Stock__c != 0 OR Sales_Order_Stock__c != 0 OR Delivery_Stock__c != 0 OR Available_Stock__c != 0 ) ]; // Updated for INC0418898 GRZ(Dheeraj Sharma) 05-12-2022 

             }
            
            if(LoginUser.Profile.Name == 'System Administrator'){
            wObj.total = [SELECT COUNT() FROM Stock_Requirement__c WHERE SKU__r.Active__c = true AND (Depot__r.SalesOrg__r.Sales_Org_Code__c = '5361' OR Depot__r.SalesOrg__r.Sales_Org_Code__c = '5441') AND SKU__r.SKU_Description__c !='']; // Updated for INC0418898 GRZ(Dheeraj Sharma) 05-12-2022 

             }
            
            /*for(Stock_Requirement__c sr :lstStkreq){
                system.debug('lstStkreq>>--->'+sr.Depot__r.name);
            }*/
            /*  for(Inventory__c sr :lstInventory){
system.debug('lstStkreq>>--->'+sr.Storage_Location_Depot__r.name);
}
*/
            for(Inventory__c inv :lstInventory){
                string key_batchWise = inv.Depot__r.Depot_Code__c + inv.SKU__r.SKU_Code__c + inv.Storage_Location_Depot__r.Depot_Code__c + inv.Batch_Number__c;
                string key = inv.Depot__r.Depot_Code__c + inv.SKU__r.SKU_Code__c + inv.Storage_Location_Depot__r.Depot_Code__c ;
                if(!inventory_Map_Batchwise.containsKey(key_batchWise)){
                    inventory_Map.put(key_batchWise, inv);
                } 
            }
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
            system.debug('wObj.total >>--->'+wObj.total);                       
            return wObj;  
        }catch(Exception e){
            system.debug('Error Message >>--->'+e.getMessage());
            system.debug('Error Message Line Number >>--->'+e.getLineNumber());
            return null;
        }
    } 
    // This method used for reterived  the list of Inventory records based on the search string 
    @AuraEnabled 
    public static WrapperPageResult getBySKUAndSLocation(String fieldName ,string value,Decimal pageNumber,Integer recordToDisply) { 
        try{
            inventory_Map = new map<String,Inventory__c>();
            inventory_Map_Batchwise = new map<String,Inventory__c>();
            PublicGroupMembers = new set<Id>();
            isNewzealandUser = false;
            
            system.debug('Method start');
            if( fieldName == 'Product/Sku'){
            	value = value.toUpperCase();
            }
            userId = UserInfo.getUserId();           
            User LoginUser = [SELECT Id, Country,Profile.Name,UserRole.Name FROM User Where Id=:userId];
            System.debug('LoginUser Bolivia'+ LoginUser);
            if(LoginUser.Country == 'Bolivia'){
                System.debug('Inside Bolivia');
                salesOrg_filter = 'Sales_Org__r.Sales_Org_Code__c =  \'5361\' AND Storage_Location_Depot__r.SalesOrg__r.Sales_Org_Code__c = \'5361\' AND Stock_Quantity__c != 0';     //'5361';
                salesOrg ='Depot__r.SalesOrg__r.Sales_Org_Code__c = \'5361\' AND SKU__r.SKU_Description__c !=\'\' AND   ( Unrestricted_Stock__c != 0 OR Sales_Order_Stock__c != 0 OR Delivery_Stock__c != 0 OR Available_Stock__c != 0 )  ';
            }
            else if(LoginUser.Country == 'Paraguay'){
                System.debug('Inside Paraguay');
                salesOrg_filter = 'Sales_Org__r.Sales_Org_Code__c =  \'5441\' AND Storage_Location_Depot__r.SalesOrg__r.Sales_Org_Code__c = \'5441\' AND Stock_Quantity__c != 0';  
                salesOrg ='Depot__r.SalesOrg__r.Sales_Org_Code__c = \'5441\' AND SKU__r.SKU_Description__c !=\'\' AND   ( Unrestricted_Stock__c != 0 OR Sales_Order_Stock__c != 0 OR Delivery_Stock__c != 0 OR Available_Stock__c != 0 )  ';
            }
            else if(LoginUser.Profile.Name == 'System Administrator'){
                System.debug('Inside Admin block');
                salesOrg_filter = '(Sales_Org__r.Sales_Org_Code__c = \'5361\' OR Sales_Org__r.Sales_Org_Code__c =  \'5441\')';
                salesOrg = '(Depot__r.SalesOrg__r.Sales_Org_Code__c = \'5361\' OR Depot__r.SalesOrg__r.Sales_Org_Code__c =  \'5441\') AND SKU__r.SKU_Description__c !=\'\'';
            }          
            
            materialType = '';
            listUser = [SELECT Id, Inventory_Material_Type__c,Inventory_Material_Type__r.Name, User__c, Name FROM User_Material_Type_Mapping__c WHERE user__c =: userId];
            for(User_Material_Type_Mapping__c ummap : listUser){ 
                materialType = ummap.Inventory_Material_Type__r.Name;
            }  
            system.debug('materialType>>--->'+materialType);
            
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
                    if(materialType == 'ROH'){
                        stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  like :value AND '+salesOrg+' order by SKU__r.SKU_Description__c';
                        list<Stock_Requirement__c> lstStkreqW_OOffset = new list<Stock_Requirement__c>();
                        lstStkreqW_OOffset = database.query(stkReqQuery);
                        
                        if(lstStkreqW_OOffset.size()<=pageSize){
                            offset=0;  
                        }                       
                       stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  like :value AND '+salesOrg+' order by SKU__r.SKU_Description__c LIMIT :recordToDisply  OFFSET :offset ';
                        
                    }
                    else{
                        stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  like :value AND '+salesOrg+' order by SKU__r.SKU_Description__c';
                        list<Stock_Requirement__c> lstStkreqW_OOffset = new list<Stock_Requirement__c>();
                        lstStkreqW_OOffset = database.query(stkReqQuery);
                        system.debug('lstStkreqW_OOffset>>--->'+lstStkreqW_OOffset);
                        if(lstStkreqW_OOffset.size()<=pageSize){
                            offset=0;  
                        }  
                        
                        string materialval ='ROH';
                        stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.Material_type__c !=:materialval AND SKU__r.SKU_Description__c  like :value AND '+salesOrg+' order by SKU__r.SKU_Description__c LIMIT :recordToDisply  OFFSET :offset '; 
                    }
                    
                    invtryQuery ='SELECT Id,Depot__r.Depot_Code__c,Production_Date__c,Expiry_Date__c,Storage_Location_Depot__r.Depot_Code__c ,SKU__r.SKU_Code__c, Name,Storage_Location_Depot__c,Batch_Number__c, Storage_Location_Depot__r.name,SKU__r.SKU_Description__c,Stock_Quantity__c,UOM__c FROM Inventory__c WHERE '+salesOrgFil;
                    system.debug('stkReqQuery>>--->'+stkReqQuery);
                    system.debug('invtryQuery>>--->'+invtryQuery);
                    system.debug('SKU');
                    lstStkreq = database.query(stkReqQuery);
                    lstInventory =  database.query(invtryQuery);
                   
                     if(LoginUser.Country == 'Bolivia'){
                    wObj.total =[SELECT count() FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  like :value AND Depot__r.SalesOrg__r.Sales_Org_Code__c = '5361' AND ( Unrestricted_Stock__c != 0 OR Sales_Order_Stock__c != 0 OR Delivery_Stock__c != 0 OR Available_Stock__c != 0 )];
                    }
                    
                    if(LoginUser.Country == 'Paraguay'){
                    wObj.total =[SELECT count() FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  like :value AND Depot__r.SalesOrg__r.Sales_Org_Code__c = '5441' AND ( Unrestricted_Stock__c != 0 OR Sales_Order_Stock__c != 0 OR Delivery_Stock__c != 0 OR Available_Stock__c != 0 )];
                    }
                    
                     if(LoginUser.Profile.Name == 'System Administrator'){
                    wObj.total =[SELECT count() FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  like :value AND (Depot__r.SalesOrg__r.Sales_Org_Code__c = '5361' OR Depot__r.SalesOrg__r.Sales_Org_Code__c = '5441') AND SKU__r.SKU_Description__c !=''];
                    }
                    
                } else if( fieldName == 'SKU Number' ||fieldName =='SKU Code'){
                    if(materialType == 'ROH'){
                        stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  like :value AND '+salesOrg+' order by SKU__r.SKU_Description__c';
                        list<Stock_Requirement__c> lstStkreqW_OOffset = new list<Stock_Requirement__c>();
                        lstStkreqW_OOffset = database.query(stkReqQuery);
                        
                        if(lstStkreqW_OOffset.size()<=pageSize){
                            offset=0;  
                        }                       
                       stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.SKU_Code__c  like :value AND '+salesOrg+' order by SKU__r.SKU_Description__c LIMIT :recordToDisply  OFFSET :offset ';
                        
                    }
                    else{
                        stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.SKU_Code__c  like :value AND '+salesOrg+' order by SKU__r.SKU_Description__c';
                        list<Stock_Requirement__c> lstStkreqW_OOffset = new list<Stock_Requirement__c>();
                        lstStkreqW_OOffset = database.query(stkReqQuery);
                        
                        if(lstStkreqW_OOffset.size()<=pageSize){
                            offset=0;  
                        }  
                        
                        string materialval ='ROH';
                        //stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.Material_type__c !=:materialval AND SKU__r.SKU_Code__c  like :value AND '+salesOrg+' order by SKU__r.SKU_Description__c LIMIT :recordToDisply  OFFSET :offset '; 
                        stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.Material_type__c !=:materialval AND SKU__r.SKU_Code__c  like  \'%'+value+'%\' AND '+salesOrg+' order by SKU__r.SKU_Description__c LIMIT :recordToDisply  OFFSET :offset '; 
                    }
                    
                    invtryQuery ='SELECT Id,Depot__r.Depot_Code__c,Production_Date__c,Expiry_Date__c,Storage_Location_Depot__r.Depot_Code__c ,SKU__r.SKU_Code__c, Name,Storage_Location_Depot__c,Batch_Number__c, Storage_Location_Depot__r.name,SKU__r.SKU_Description__c,Stock_Quantity__c,UOM__c FROM Inventory__c WHERE '+salesOrgFil;
                    system.debug('stkReqQuery>>--->'+stkReqQuery);
                    system.debug('invtryQuery>>--->'+invtryQuery);
                    system.debug('SKU');
                    lstStkreq = database.query(stkReqQuery);
                    lstInventory =  database.query(invtryQuery);
                    system.debug('lstStkreq>>--->'+lstStkreq);
                    if(LoginUser.Country == 'Paraguay'){
                        wObj.total =[SELECT count() FROM Stock_Requirement__c WHERE SKU__r.SKU_Code__c like :value AND Depot__r.SalesOrg__r.Sales_Org_Code__c = '5441' AND ( Unrestricted_Stock__c != 0 OR Sales_Order_Stock__c != 0 OR Delivery_Stock__c != 0 OR Available_Stock__c != 0 )];
                    }
                    if(LoginUser.Profile.Name == 'System Administrator'){
                      wObj.total =[SELECT count() FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  like :value AND (Depot__r.SalesOrg__r.Sales_Org_Code__c = '5361' OR Depot__r.SalesOrg__r.Sales_Org_Code__c = '6100' OR Depot__r.SalesOrg__r.Sales_Org_Code__c = '5441') AND SKU__r.SKU_Description__c !=''];
                    }
                }        
                else if(fieldName == 'Brand Name'){

				if(materialType == 'ROH'){
                        stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.Brand_Name__c  like :value AND '+salesOrg+' order by SKU__r.Brand_Name__c';
                        list<Stock_Requirement__c> lstStkreqW_OOffset = new list<Stock_Requirement__c>();
                        lstStkreqW_OOffset = database.query(stkReqQuery);
                        
                        if(lstStkreqW_OOffset.size()<=pageSize){
                            offset=0;  
                        }                       
                       stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.Brand_Name__c  like :value AND '+salesOrg+' order by SKU__r.Brand_Name__c LIMIT :recordToDisply  OFFSET :offset ';
                        
                    }
                    else{
                        stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.Brand_Name__c  like :value AND '+salesOrg+' order by SKU__r.Brand_Name__c';
                        list<Stock_Requirement__c> lstStkreqW_OOffset = new list<Stock_Requirement__c>();
                        lstStkreqW_OOffset = database.query(stkReqQuery);
                        
                        if(lstStkreqW_OOffset.size()<=pageSize){
                            offset=0;  
                        }  
                        
                        string materialval ='ROH';
                        //stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.Material_type__c !=:materialval AND SKU__r.SKU_Code__c  like :value AND '+salesOrg+' order by SKU__r.SKU_Description__c LIMIT :recordToDisply  OFFSET :offset '; 
                        stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.Material_type__c !=:materialval AND SKU__r.Brand_Name__c  like  \'%'+value+'%\' AND '+salesOrg+' order by SKU__r.Brand_Name__c LIMIT :recordToDisply  OFFSET :offset '; 
                    }
                    
                    invtryQuery ='SELECT Id,Depot__r.Depot_Code__c,Production_Date__c,Expiry_Date__c,Storage_Location_Depot__r.Depot_Code__c ,SKU__r.SKU_Code__c, Name,Storage_Location_Depot__c,Batch_Number__c, Storage_Location_Depot__r.name,SKU__r.SKU_Description__c,Stock_Quantity__c,UOM__c FROM Inventory__c WHERE '+salesOrgFil;
                    system.debug('stkReqQuery>>--->'+stkReqQuery);
                    system.debug('invtryQuery>>--->'+invtryQuery);
                    system.debug('SKU');
                    lstStkreq = database.query(stkReqQuery);
                    lstInventory =  database.query(invtryQuery);
                    system.debug('lstStkreq>>--->'+lstStkreq);
                    
            }else{
                    invtryQuery ='SELECT Id,Production_Date__c,Expiry_Date__c,Storage_Location_Depot__r.Depot_Code__c, Name,Depot__r.Depot_Code__c,SKU__r.SKU_Code__c,Storage_Location_Depot__c,Batch_Number__c, Storage_Location_Depot__r.name,SKU__r.SKU_Description__c,Stock_Quantity__c,UOM__c FROM Inventory__c WHERE '+salesOrgFil+' AND  Storage_Location_Depot__r.name like :value ';
                    lstInventory =  database.query(invtryQuery);
                    System.debug('lstInventory size---> '+lstInventory.size());
                    set<string> setSku = new set<string>();
                    for(Inventory__c inv : lstInventory){
                        setSku.add(inv.SKU__r.SKU_Description__c);         
                    }  
                    if(materialType == 'ROH'){
                        stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  IN :setSku AND '+salesOrg+' order by SKU__r.SKU_Description__c';
                        list<Stock_Requirement__c> lstStkreqW_OOffset = new list<Stock_Requirement__c>();
                        lstStkreqW_OOffset = database.query(stkReqQuery);
                        
                        if(lstStkreqW_OOffset.size()<=pageSize){
                            offset=0;  
                        }  
                        
                        stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,SKU__r.Material_type__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  IN :setSku AND '+salesOrg+' order by SKU__r.SKU_Description__c LIMIT :recordToDisply  OFFSET :offset ';   
                    }else{
                         stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  IN :setSku AND '+salesOrg+' order by SKU__r.SKU_Description__c';
                        list<Stock_Requirement__c> lstStkreqW_OOffset = new list<Stock_Requirement__c>();
                        lstStkreqW_OOffset = database.query(stkReqQuery);
                        
                        if(lstStkreqW_OOffset.size()<=pageSize){
                            offset=0;  
                        }  
                                                
                        stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,SKU__r.Material_type__c,Depot__c, Depot__r.name, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  IN :setSku AND '+salesOrg+' order by SKU__r.SKU_Description__c LIMIT :recordToDisply  OFFSET :offset ';   
                    }
                    system.debug('query>>--->'+stkReqQuery);
                    system.debug('query>>--->'+invtryQuery);
                    lstStkreq = database.query(stkReqQuery);
                    system.debug('lstStkreq size>>--->'+lstStkreq.size());
                    system.debug('lstStkreq1 size>>--->'+lstStkreq);
                    list<Stock_Requirement__c> lstStkreq1 = new list<Stock_Requirement__c>();
                    for(Stock_Requirement__c stkrreq : lstStkreq){
                        if(stkrreq.SKU__r.Material_type__c != 'ROH' && materialType != 'ROH'){
                            lstStkreq1.add(stkrreq);
                        }
                    }
                    if(materialType != 'ROH'){
                        lstStkreq = lstStkreq1;
                    }           
                    system.debug('lstStkreq1 size>>--->'+lstStkreq.size());
                    system.debug('lstStkreq1 size>>--->'+lstStkreq);
                    
                    isStorageloc = true;
                    system.debug('storage Location');
                     
                    if(LoginUser.Country == 'Bolivia'){
                    wObj.total =[SELECT count() FROM Stock_Requirement__c WHERE Depot__r.SalesOrg__r.Sales_Org_Code__c = '5361' AND SKU__r.SKU_Description__c  IN :setSku AND ( Unrestricted_Stock__c != 0 OR Sales_Order_Stock__c != 0 OR Delivery_Stock__c != 0 OR Available_Stock__c != 0 ) ];
                     }
                    
                    if(LoginUser.Country == 'Paraguay'){
                    wObj.total =[SELECT count() FROM Stock_Requirement__c WHERE Depot__r.SalesOrg__r.Sales_Org_Code__c = '5441' AND SKU__r.SKU_Description__c  IN :setSku AND ( Unrestricted_Stock__c != 0 OR Sales_Order_Stock__c != 0 OR Delivery_Stock__c != 0 OR Available_Stock__c != 0 ) ];
                     }
                    
                    if(LoginUser.Profile.Name == 'System Administrator'){
                    wObj.total =[SELECT count() FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  IN :setSku ];
                     }
                }
            }
            else{
                system.debug('value>>--->'+value);
                if(materialType == 'ROH'){
                    stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.Material_type__c != \'ROH\' AND '+salesOrg+'  order by SKU__r.SKU_Description__c  LIMIT :recordToDisply  OFFSET :offset';
                }else{
                    string materialval ='ROH';
                    stkReqQuery = 'SELECT Id, Name, SKU__r.SKU_Description__c,SKU__r.SKU_Code__c,Depot__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Available_Stock__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c WHERE SKU__r.Material_type__c != \'ROH\' AND '+salesOrg+'  order by SKU__r.SKU_Description__c  LIMIT :recordToDisply  OFFSET :offset'; 
                    system.debug('query>>--->'+stkReqQuery);
                }
                invtryQuery ='SELECT Id, Name,Production_Date__c,Expiry_Date__c,Storage_Location_Depot__r.Depot_Code__c,Storage_Location_Depot__c,SKU__r.SKU_Code__c,Depot__r.Depot_Code__c ,Batch_Number__c, Storage_Location_Depot__r.name,SKU__r.SKU_Description__c,Stock_Quantity__c,UOM__c FROM Inventory__c WHERE '+salesOrgFil; 
                system.debug('query>>--->'+stkReqQuery);
                system.debug('query>>--->'+invtryQuery);
                lstStkreq = database.query(stkReqQuery);
                lstInventory =  database.query(invtryQuery);
                 
                 if(LoginUser.Country == 'Bolivia'){
                wObj.total =[SELECT count() FROM Stock_Requirement__c WHERE Depot__r.SalesOrg__r.Sales_Org_Code__c = '5361' AND SKU__r.SKU_Description__c  like :value  AND ( Unrestricted_Stock__c != 0 OR Sales_Order_Stock__c != 0 OR Delivery_Stock__c != 0 OR Available_Stock__c != 0 ) ];
                 }
                
                if(LoginUser.Country == 'Paraguay'){
                wObj.total =[SELECT count() FROM Stock_Requirement__c WHERE Depot__r.SalesOrg__r.Sales_Org_Code__c = '5441' AND SKU__r.SKU_Description__c  like :value  AND ( Unrestricted_Stock__c != 0 OR Sales_Order_Stock__c != 0 OR Delivery_Stock__c != 0 OR Available_Stock__c != 0 ) ];
                 }
                
                if(LoginUser.Profile.Name == 'System Administrator'){
                wObj.total =[SELECT count() FROM Stock_Requirement__c WHERE SKU__r.SKU_Description__c  like :value ];
                 }
                system.debug('wObj.total >>--->'+wObj.total);
            }
            
            for(Inventory__c inv :lstInventory){
                string key_batchWise = inv.Depot__r.Depot_Code__c + inv.SKU__r.SKU_Code__c + inv.Storage_Location_Depot__r.Depot_Code__c + inv.Batch_Number__c;
                if(!inventory_Map_Batchwise.containsKey(key_batchWise)){
                    
                    inventory_Map.put(key_batchWise, inv);
                }  
            }
            for(Stock_Requirement__c sreq : lstStkreq){
                WrapStockReqInventory wrapObj = new WrapStockReqInventory(); 
                wrapObj.stkReq = sreq;
                for(Inventory__c inven :inventory_Map.values()){
                    if(sreq.SKU__r.SKU_Code__c == inven.SKU__r.SKU_Code__c){
                        wrapObj.lstStrLocInv.add(inven);   
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
        @AuraEnabled public List<WrapStockReqInventory> listWrapStkReqInv {get;set;}
        
        public WrapperPageResult(){
            pageSize = 0;
            page = 0;
            total = 0;
        	userId = UserInfo.getUserId();
            User LoginUser = [SELECT Id, Country,Profile.Name,UserRole.Name FROM User Where Id=:userId];
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