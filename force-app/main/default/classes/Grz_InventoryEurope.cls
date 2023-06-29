public with sharing class Grz_InventoryEurope {

    public static string userId;
    public static list<User_Material_Type_Mapping__c> listUser;
    public static string materialType;
    public static  String salesOrg_filter; 
    public static  String salesOrg;
    public static  String salesOrg_SKU; //To differentiate between SKU Descrpition and SKU Code   
    public static  list<String> pskuList;


    @AuraEnabled(cacheable=true)
    public static List<Object> getEuropeOrg(){
        List<Object> DepotOptions = new List<Object>();
        List<Object> Orgs = new List<Object>();  
        boolean b = true; 
         profile p = [select id,name from profile where Id =: userinfo.getProfileid()];

            if(p.name.contains('Central Europe Bulgaria')){
                b=false;
            }
            else if(p.name.contains('Central Europe Hungary')){
                  b=false;
            }
            else if(p.name.contains('Central Europe Romania')){
                b=false;
            }
        List<String> salesorgcode = System.Label.Grz_EuropeSalesOrgCode.trim().Split(',');
        List<Sales_Org__c> Org_list= [SELECT Id, Name, Sales_Org_Code__c, Company_Code__c, Country_Code__c FROM Sales_Org__c WHERE Sales_Org_Code__c IN : salesorgcode];
        for(Integer i=0 ; i< Org_list.size() ;i++){
            Map<String, object> orgJSON = new Map<String, object>();
            orgJSON.put('Name', Org_list[i].Name);
            orgJSON.put('Sales_Org_Code__c', Org_list[i].Sales_Org_Code__c);
            orgJSON.put('countrySpecific', b);
            Orgs.add(orgJSON);
            
        }
        if(Orgs!=null && Orgs.size()>0){
            DepotOptions.addAll(Orgs);
        }
        system.debug('DepotOptions###'+DepotOptions);
        return DepotOptions;
    }

    @AuraEnabled 
    public static WrapperPageResult getInventories(Decimal pageNumber,Integer recordToDisply,String SelectedDepots,boolean NoZeroSAPRecord,List<String> orgValue,String fieldname, String value ){ 
        try{    
            System.debug('pageNumber -->'+ pageNumber);
            System.debug('recordToDisply -->'+ recordToDisply);
            System.debug('SelectedDepots -->'+ SelectedDepots);
            System.debug('NoZeroSAPRecord -->'+ NoZeroSAPRecord);
            System.debug('orgValue -->'+ orgValue);
            System.debug('fieldname -->'+ fieldname);
            System.debug('value -->'+ value);       
            system.debug('Data-In-Get-Inventory'+pageNumber+'@@'+recordToDisply+'@@'+SelectedDepots+'@@'+NoZeroSAPRecord+'@@'+orgValue+'@@@fieldname'+fieldname+'@@@SearchTerm'+value);
            userId = UserInfo.getUserId();

            List<String> salesorgcode = new list<string>();
            
            List<String> Depots = System.Label.Grz_EuropeDepot.trim().Split(',');
             
            List<String> OrgValues = new List<String>();


             profile p = [select id,name from profile where Id =: userinfo.getProfileid()];

            if(p.name.contains('Central Europe Bulgaria')){
                salesorgcode.add(System.Label.Grz_BulgariaSalesOrgCode);
                OrgValues.add(System.Label.Grz_BulgariaSalesOrgCode);
            }
            else if(p.name.contains('Central Europe Hungary')){
                 salesorgcode.add(System.Label.Grz_HungarySalesOrgCode);
                  OrgValues.add(System.Label.Grz_HungarySalesOrgCode);
            }
            else if(p.name.contains('Central Europe Romania')){
                salesorgcode.add(System.Label.Grz_RomaniaSalesOrgCode);
                 OrgValues.add(System.Label.Grz_RomaniaSalesOrgCode);
            }
            else{
               salesorgcode = System.Label.Grz_EuropeSalesOrgCode.trim().Split(',');

                if(orgValue!= null && (!orgValue.contains('ALL'))){
                OrgValues=orgValue;  
            }
            else if(orgValue!= null && orgValue.contains('ALL')){
                List<Sales_Org__c> Org_list= [SELECT Id, Name, Sales_Org_Code__c, Company_Code__c, Country_Code__c FROM Sales_Org__c WHERE Sales_Org_Code__c IN :salesorgcode];
                for(Sales_Org__c org:Org_list){
                    OrgValues.add(org.Sales_Org_Code__c);                 
                } 
            }
             
            }
              system.debug('OrgValues@@@'+OrgValues);
                system.debug('salesorgcode@@@'+salesorgcode);


            User LoginUser = [SELECT Id,Name ,Country,Profile.Name FROM User Where Id=:userId];
            String inventory_Query ='';
            String Stk_Req_Query ='';
            System.debug('LoginUser -->'+ LoginUser.Name);
            System.debug('SelectedDepots -->'+ SelectedDepots);
            System.debug('orgValue in class-->'+orgValue);
            map<id,id> storgaeVSSKUmap = new map<id,id>();// Not directly used create for see data
            map<String,List<Inventory__c>> skuidVSInventories = new   map<String,List<Inventory__c>>();//Not directly used create for see data
            map<String,Stock_Requirement__c> StrVSstockreq = new map<String,Stock_Requirement__c>();// use to filter data
            
            set<id> Skuid= new set<id>();// use in sales order line ietm query
            list<String> DepotList= new list<String>(); // use to get deput list 'uk10,uk12'
            list<Stock_Requirement__c> lstStkreq = new list<Stock_Requirement__c>();// use to save query Stock requirement query
            list<Inventory__c> lstInventory = new list<Inventory__c>(); // use to save inteventory query resuly
            map<String,list<Inventory__c>> SkuidDepotcodeVSListofInventoryMap= new map<String,list<Inventory__c>>();
            
            for(Depot__c depo:[SELECT Id, Name, Country__c, Depot__c, Depot_Code__c, SalesOrg__r.Country_Code__c FROM Depot__c Where Country__c='Europe' AND RecordType.Name='Depot' And SalesOrg__r.Sales_Org_Code__c IN :salesorgcode]){
                DepotList.add(depo.Name);
            }
            system.debug('DepotList@@@@@'+DepotList);
            
            
                    
            
            
            
            
            if(!String.isBlank(value)){   
                if( fieldName == 'SKU__r.SKU_Description__c'){ 
                    value = value.toUpperCase();
                    value = '%'+value+'%';
                    if(NoZeroSAPRecord==true){
                        salesOrg = '(Depot__r.Country__c = \'Europe\' AND Sales_Org_Code__c in :OrgValues AND SKU__r.SKU_Description__c  like :value  AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :DepotList And Unrestricted_Stock__c!=0  And Sales_Org__r.Sales_Org_Code__c in :OrgValues  And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\')  And SKU__r.Division__r.Division_Code__c IN (\'10\'))';
                    }
                    
                    else{
                        
                        salesOrg = '(Depot__r.Country__c = \'Europe\' AND Sales_Org_Code__c in :OrgValues AND  SKU__r.SKU_Description__c  like :value  AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :DepotList And Sales_Org__r.Sales_Org_Code__c in :OrgValues And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\') And SKU__r.Division__r.Division_Code__c IN (\'10\'))';
                    }
                    salesOrg_filter = '(Storage_Location_Depot__r.Country__c = \'Europe\' AND Sales_Org_Code__c in :OrgValues AND Storage_Location_Depot__r.Depot__r.Name in :DepotList And Sales_Org__r.Sales_Org_Code__c in :OrgValues And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\')  And SKU__r.Division__r.Division_Code__c IN (\'10\'))';
                }
                else if(fieldName == 'SKU__r.SKU_Code__c'){
                    value = '%'+value+'%';
                    if(NoZeroSAPRecord==true){
                        salesOrg = '(Depot__r.Country__c = \'Europe\' AND Sales_Org_Code__c in :OrgValues AND SKU__r.SKU_Code__c  like :value  AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :DepotList  And Unrestricted_Stock__c!=0 And Sales_Org__r.Sales_Org_Code__c in :OrgValues And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\')  And SKU__r.Division__r.Division_Code__c IN (\'10\'))';
                    }
                    else{
                        salesOrg = '(Depot__r.Country__c = \'Europe\' AND Sales_Org_Code__c in :OrgValues AND SKU__r.SKU_Code__c  like :value  AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :DepotList And Sales_Org__r.Sales_Org_Code__c in :OrgValues And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\')  And SKU__r.Division__r.Division_Code__c IN (\'10\'))';
                    }
                    salesOrg_filter = '(Storage_Location_Depot__r.Country__c = \'Europe\' AND Sales_Org_Code__c in :OrgValues AND Storage_Location_Depot__r.Depot__r.Name in :DepotList And Sales_Org__r.Sales_Org_Code__c in :OrgValues And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\')  And SKU__r.Division__r.Division_Code__c IN (\'10\'))';
                    System.debug('Inside SKU Code==> '+salesOrg);                    
                }
                else if(fieldName == 'SKU__r.Brand_Name__c'){
                    value = '%'+value+'%';
                    if(NoZeroSAPRecord==true){
                        salesOrg = '(Depot__r.Country__c = \'Europe\' AND Sales_Org_Code__c in :OrgValues  AND SKU__r.Brand_Name__c  like :value  AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :DepotList  And Unrestricted_Stock__c!=0 And Sales_Org__r.Sales_Org_Code__c in :OrgValues  And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\')  And SKU__r.Division__r.Division_Code__c IN (\'10\'))';
                    }
                    else{
                        salesOrg = '(Depot__r.Country__c = \'Europe\' AND Sales_Org_Code__c in :OrgValues  AND SKU__r.Brand_Name__c  like :value  AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :DepotList And Sales_Org__r.Sales_Org_Code__c in :OrgValues And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\')  And SKU__r.Division__r.Division_Code__c IN (\'10\'))';
                    }
                    salesOrg_filter = '(Storage_Location_Depot__r.Country__c = \'Europe\' AND Sales_Org_Code__c in :OrgValues AND Storage_Location_Depot__r.Depot__r.Name in :DepotList And Sales_Org__r.Sales_Org_Code__c in :OrgValues  And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\')  And SKU__r.Division__r.Division_Code__c IN (\'10\'))';
                    System.debug('Inside Brand_Name__c==> '+salesOrg);                    
                }  
                else if(fieldName=='Depot_Code__c'){
                    value = '%'+value+'%';
                    if(NoZeroSAPRecord==true){
                        salesOrg = '(Depot__r.Country__c = \'Europe\' AND Sales_Org_Code__c in :OrgValues AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :DepotList And Unrestricted_Stock__c!=0 And Sales_Org__r.Sales_Org_Code__c in :OrgValues  And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\')  And SKU__r.Division__r.Division_Code__c IN (\'10\'))';
                    }
                    else{
                        salesOrg = '(Depot__r.Country__c = \'Europe\' AND Sales_Org_Code__c in :OrgValues AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :DepotList And Sales_Org__r.Sales_Org_Code__c in :OrgValues And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\')  And SKU__r.Division__r.Division_Code__c IN (\'10\'))';
                    }
                    System.debug('Inside Depot Code==> '+salesOrg);           
                    salesOrg_filter = '(Storage_Location_Depot__r.Country__c = \'Europe\' AND Sales_Org_Code__c in :OrgValues AND Storage_Location_Depot__r.Depot__r.Name in :DepotList AND Storage_Location_Depot__r.name like :value And Sales_Org__r.Sales_Org_Code__c in :OrgValues  And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\')  And SKU__r.Division__r.Division_Code__c IN (\'10\'))'; 
                }    
                
            }
            else{
                if(NoZeroSAPRecord==true){
                    salesOrg = '(Depot__r.Country__c = \'Europe\' AND Sales_Org_Code__c in :OrgValues AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :DepotList And Unrestricted_Stock__c!=0 And Sales_Org__r.Sales_Org_Code__c in :OrgValues  And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\') And SKU__r.Division__r.Division_Code__c IN (\'10\'))';
                }
                else{
                    salesOrg = '(Depot__r.Country__c = \'Europe\' AND Sales_Org_Code__c in :OrgValues AND Depot__r.Recordtype.Name=\'Depot\' AND Depot__r.name in :DepotList And Sales_Org__r.Sales_Org_Code__c in :OrgValues And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\')   And SKU__r.Division__r.Division_Code__c IN (\'10\'))';
                }
                
                salesOrg_filter = '(Storage_Location_Depot__r.Country__c = \'Europe\' AND Sales_Org_Code__c in :OrgValues AND Storage_Location_Depot__r.Depot__r.Name in :DepotList And Sales_Org__r.Sales_Org_Code__c in :OrgValues And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\')  And SKU__r.Division__r.Division_Code__c IN (\'10\'))';
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
            
            if(fieldName=='Depot_Code__c' && (value!=null && value!='')){
                list<Stock_Requirement__c> tempStockRequirementList = new list<Stock_Requirement__c>();
                list<Id> stockDeployAccordingID = new list<Id>();
                inventory_Query = 'SELECT Id, Name,Production_Date__c,Expiry_Date__c,Storage_Location_Depot__c, Sales_Org_Code__c,Sales_Org__r.Sales_Org_Code__c,Depot__r.Depot_Code__c,Storage_Location_Depot__r.name,Storage_Location_Depot__r.Depot_Code__c,Batch_Number__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,Stock_Quantity__c,UOM__c FROM Inventory__c Where '+salesOrg_filter;               
                system.debug('@@@inventory_Query'+inventory_Query);
                lstInventory = database.query(inventory_Query);              
                system.debug('lstInventory--------------->'+lstInventory);
                for(Inventory__c inv :lstInventory){
                    if(SkuidDepotcodeVSListofInventoryMap.containsKey(inv.SKU__c+inv.Depot__r.Depot_Code__c)){
                        SkuidDepotcodeVSListofInventoryMap.get(inv.SKU__c+inv.Depot__r.Depot_Code__c).add(inv);
                    }
                    else{
                        SkuidDepotcodeVSListofInventoryMap.put(inv.SKU__c+inv.Depot__r.Depot_Code__c,new list<Inventory__c>{inv});
                    }
                    
                }
                
                Stk_Req_Query = 'SELECT Id, Name, SKU__r.SKU_Description__c,Depot__c,SKU__r.SKU_Code__c,Depot__r.Depot_Code__c,Sales_Org_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Europe__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c Where '+salesOrg+'  order by SKU__r.SKU_Description__c';
                system.debug('Stk_Req_Query'+Stk_Req_Query); 
                
                tempStockRequirementList = database.query(Stk_Req_Query);
                
                if(tempStockRequirementList!=null && tempStockRequirementList.size()>0){
                    for(Stock_Requirement__c sreq : tempStockRequirementList){
                        if(lstInventory!=null && lstInventory.size()>0)
                        {
                            for(Inventory__c inv :lstInventory){
                                if(sreq.SKU__c == inv.SKU__c && sreq.Depot__r.Depot_Code__c==inv.Depot__r.Depot_Code__c){
                                    stockDeployAccordingID.add(sreq.id);
                                }
                            }
                        }
                        
                    }
                }
system.debug('@@@@@stockDeployAccordingID'+stockDeployAccordingID); 
                if(Test.isRunningTest()){
          lstStkreq=[SELECT Id, Name, SKU__r.SKU_Description__c, Depot__c, SKU__r.SKU_Code__c, Depot__r.Depot_Code__c, Sales_Org_Code__c, Depot__r.name, Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c, Delivery_Stock__c, Net_Stock_Europe__c, Outgoing_Reservations__c, Purchase_Order_Stock__c, Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c Where  Id In:stockDeployAccordingID];       
                }
                else{
                lstStkreq= [SELECT Id, Name, SKU__r.SKU_Description__c,Depot__c,SKU__r.SKU_Code__c,Depot__r.Depot_Code__c,Sales_Org_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Europe__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c Where Id In:stockDeployAccordingID  order by SKU__r.SKU_Description__c  LIMIT :recordToDisply  OFFSET :offset];
                }
                system.debug('lstInventory@@'+lstStkreq);
                if(lstStkreq!=null && lstStkreq.size()>0){
                for(Stock_Requirement__c  stk :lstStkreq  ){
                    skuid.add(stk.SKU__c);
                }
                }
                map<String,decimal> skuIdVsunapprovedstockQ =new map<String,decimal>();
                if(skuId.size()>0){
                    
                    List<string> statusList = new List<string>{'Pending','Open'};
                        for(sales_order_line_item__c salesorderline:[Select id,sku_Name__c,Quantity__c,Sale_Order__c,Sale_Order__r.Order_Status__c,Depot_Code__c
                                                                     FROM sales_order_line_item__c 
                                                                     WHERE sku_Name__c IN:skuId AND Sale_Order__r.Order_Status__c IN:statusList And Depot_Code__c in : Depots]){
                                                                         decimal Quant=0;
                                                                         if(skuIdVsunapprovedstockQ.containskey(salesorderline.sku_Name__c+salesorderline.Depot_Code__c)){
                                                                             Quant=skuIdVsunapprovedstockQ.get(salesorderline.sku_Name__c+salesorderline.Depot_Code__c)+salesorderline.Quantity__c;
                                                                         }
                                                                         else{
                                                                             Quant=salesorderline.Quantity__c;
                                                                         }
                                                                         skuIdVsunapprovedstockQ.put(salesorderline.sku_Name__c+salesorderline.Depot_Code__c,Quant);
                                                                     }
                }
                
                system.debug('skuIdVsunapprovedstockQ@@@'+skuIdVsunapprovedstockQ);
                
                integer  count= database.countQuery('SELECT count() FROM Stock_Requirement__c Where Id In:stockDeployAccordingID');
                wObj.total=count;
                system.debug('the count is '+ count);
                
                if(lstStkreq!=null && lstStkreq.size()>0){
                    for(Stock_Requirement__c sreq : lstStkreq){
                       Decimal UnretricStock=sreq.Unrestricted_Stock__c !=null?sreq.Unrestricted_Stock__c:0;
                        Decimal PurchaseStock=sreq.Purchase_Order_Stock__c !=null?sreq.Purchase_Order_Stock__c:0;
                        Decimal StockTransit=sreq.Stock_In_Transit__c !=null?sreq.Stock_In_Transit__c:0;
                        Decimal OutgoingReserve=sreq.Outgoing_Reservations__c !=null?sreq.Outgoing_Reservations__c:0;
                        Decimal unapprovedLocal=0;
                        WrapStockReqInventory wrapObj = new WrapStockReqInventory(); 
                        // wrapObj.unapproved=unapprovedLocal;
                        wrapObj.stkReq = sreq;
                        // if(skuIdVsunapprovedstockQ.KeySet()!=null && skuIdVsunapprovedstockQ.Keyset().size()>0){
                        //     if(skuIdVsunapprovedstockQ.get(sreq.SKU__c+sreq.Depot__r.Depot_Code__c)==null){
                        //         unapprovedLocal=0;
                        //     }
                        //     else{
                        //         unapprovedLocal=skuIdVsunapprovedstockQ.get(sreq.SKU__c+sreq.Depot__r.Depot_Code__c);
                        //     }
                        //     wrapObj.unapproved=unapprovedLocal;
                        //     system.debug('the unapprovedLocal is '+ unapprovedLocal);
                        // }
                        // if(unapprovedLocal!=null){
                        //     wrapObj.netTotal=UnretricStock+PurchaseStock+StockTransit-OutgoingReserve-unapprovedLocal;
                        // }
                        // else{
                            wrapObj.netTotal=UnretricStock+PurchaseStock+StockTransit-OutgoingReserve;
                        // }
                         system.debug('@@@newlstInventoryIF'+lstInventory);
                        if(lstInventory!=null && lstInventory.size()>0)
                        { 
                            pskuList= New List<String>();
                            for(Inventory__c inv :lstInventory){
                                system.debug('myloopInternal');
                                System.debug('**Inventory__c -> '+inv.SKU__r.SKU_Code__c+' == '+sreq.SKU__r.SKU_Code__c);
                                if(sreq.SKU__c == inv.SKU__c && sreq.Depot__r.Depot_Code__c==inv.Depot__r.Depot_Code__c && sreq.Sales_Org_Code__c==inv.Sales_Org_Code__c){   
                                    wrapObj.SLocation.add((inv.storage_Location_Depot__r.Name!=null && inv.storage_Location_Depot__r.Name!='') ? inv.storage_Location_Depot__r.Name : '-');  
                                    wrapObj.PSku.add((inv.SKU__r.SKU_Description__c!=null && inv.SKU__r.SKU_Description__c!='') ? inv.SKU__r.SKU_Description__c : '-');   
                                    wrapObj.UnrestrictInvent.add(inv.Stock_Quantity__c != null ? inv.Stock_Quantity__c :0);  
                                    wrapObj.BNumber.add((inv.Batch_Number__c!=null && inv.Batch_Number__c!='') ? inv.Batch_Number__c : '-');  
                                    wrapObj.PDate.add(inv.Production_Date__c != null? GetEuropeInventoryData.getDate(inv.Production_Date__c):'-');   
                                    wrapObj.EDate.add(inv.Expiry_Date__c != null? GetEuropeInventoryData.getDate(inv.Expiry_Date__c):'-'); 
                                    pskuList.add(inv.SKU__r.SKU_Description__c);
                                }
                            }  
                        }
                        system.debug('pskuList@@@'+pskuList);
                        
                        if(pskuList!=null){
                            if(pskuList.size()>0){
                                wrapObj.isData=true;
                            }
                            else{
                                wrapObj.isData=false;
                            }
                        }
                        lstWrapStkReqInventObj.add(wrapObj);   
                    } 
                }
                system.debug('@@SkuidDepotcodeVSListofInventoryMap'+SkuidDepotcodeVSListofInventoryMap);
                
                system.debug('DepotCode@@@Stk_Req_Query'+Stk_Req_Query); 
                wObj.listWrapStkReqInv = lstWrapStkReqInventObj;
                system.debug('FinalWrapper'+wObj);
                return wObj;                  
                
            }
            
            
            
            
            
            
            
            
            else{
                if(Test.isRunningTest()){
                Stk_Req_Query = 'SELECT Id, Name, SKU__r.SKU_Description__c,Depot__c,SKU__r.SKU_Code__c,Depot__r.Depot_Code__c,Sales_Org_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Europe__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c Where '+salesOrg;
                }
                else{
                    Stk_Req_Query = 'SELECT Id, Name, SKU__r.SKU_Description__c,Depot__c,SKU__r.SKU_Code__c,Depot__r.Depot_Code__c,Sales_Org_Code__c, Depot__r.name,Depot__r.SalesOrg__r.Sales_Org_Code__c, Unrestricted_Stock__c, Sales_Order_Stock__c,Delivery_Stock__c,Net_Stock_Europe__c,Outgoing_Reservations__c, Purchase_Order_Stock__c,Stock_In_Transit__c, UOM__c FROM Stock_Requirement__c Where '+salesOrg+'  order by SKU__r.SKU_Description__c  LIMIT :recordToDisply  OFFSET :offset';
                }
                    system.debug('Stk_Req_Query'+Stk_Req_Query); 
                
                lstStkreq = database.query(Stk_Req_Query);
                system.debug('lstStkreq@@@'+lstStkreq);
                system.debug('salesOrg_filter'+salesOrg_filter);
                
                
                inventory_Query = 'SELECT Id, Name,Production_Date__c,Expiry_Date__c,Storage_Location_Depot__c, Sales_Org_Code__c,Sales_Org__r.Sales_Org_Code__c,Depot__r.Depot_Code__c,Storage_Location_Depot__r.name,Storage_Location_Depot__r.Depot_Code__c,Batch_Number__c,SKU__r.SKU_Code__c,SKU__r.SKU_Description__c,Stock_Quantity__c,UOM__c FROM Inventory__c WHERE'+ salesOrg_filter;
                system.debug('@@@inventory_Query'+inventory_Query);
                lstInventory = database.query(inventory_Query);
                
                system.debug('lstInventory@@'+lstInventory);
                if(lstInventory!=null && lstInventory.size()>0){
                for(Stock_Requirement__c  stk :lstStkreq  ){
                    skuid.add(stk.SKU__c);
                }
                }
                // map<String,decimal> skuIdVsunapprovedstockQ =new map<String,decimal>();
                // if(skuId.size()>0){
                    
                //     List<string> statusList = new List<string>{'Pending','Open'};
                //         for(sales_order_line_item__c salesorderline:[Select id,sku_Name__c,Quantity__c,Sale_Order__c,Sale_Order__r.Order_Status__c,Depot_Code__c
                //                                                      FROM sales_order_line_item__c 
                //                                                      WHERE sku_Name__c IN:skuId AND Sale_Order__r.Order_Status__c IN:statusList And Depot_Code__c in ('HU00','RO00','BG00')]){
                //                                                          decimal Quant=0;
                //                                                          system.debug('salesorderlineIDD@@@'+salesorderline.id);
                //                                                          if(skuIdVsunapprovedstockQ.containskey(salesorderline.sku_Name__c+salesorderline.Depot_Code__c)){
                //                                                              Quant=skuIdVsunapprovedstockQ.get(salesorderline.sku_Name__c+salesorderline.Depot_Code__c)+salesorderline.Quantity__c;
                //                                                          }
                //                                                          else{
                //                                                              Quant=salesorderline.Quantity__c;
                //                                                          }
                //                                                          skuIdVsunapprovedstockQ.put(salesorderline.sku_Name__c+salesorderline.Depot_Code__c,Quant);
                //                                                      }
                // }
                
                // system.debug('skuIdVsunapprovedstockQ@@@'+skuIdVsunapprovedstockQ);
                
                integer  count= database.countQuery('Select Count() From Stock_Requirement__c where'+salesOrg);
                wObj.total=count;
                system.debug('the count is '+ count);
                
                if(lstStkreq!=null && lstStkreq.size()>0){
                    for(Stock_Requirement__c sreq : lstStkreq){
                        
                        Decimal UnretricStock=sreq.Unrestricted_Stock__c !=null?sreq.Unrestricted_Stock__c:0;
                        Decimal PurchaseStock=sreq.Purchase_Order_Stock__c !=null?sreq.Purchase_Order_Stock__c:0;
                        Decimal StockTransit=sreq.Stock_In_Transit__c !=null?sreq.Stock_In_Transit__c:0;
                        Decimal OutgoingReserve=sreq.Outgoing_Reservations__c !=null?sreq.Outgoing_Reservations__c:0;
                        // Decimal unapprovedLocal=0;
                        
                        WrapStockReqInventory wrapObj = new WrapStockReqInventory(); 
                        wrapObj.stkReq = sreq;
                        
                        // if(skuIdVsunapprovedstockQ.KeySet()!=null && skuIdVsunapprovedstockQ.Keyset().size()>0){
                        //     if(skuIdVsunapprovedstockQ.get(sreq.SKU__c+sreq.Depot__r.Depot_Code__c)==null){
                        //         unapprovedLocal=0;
                        //     }
                        //     else{
                        //         unapprovedLocal=skuIdVsunapprovedstockQ.get(sreq.SKU__c+sreq.Depot__r.Depot_Code__c);
                        //     }
                        //     wrapObj.unapproved=unapprovedLocal;
                        //     system.debug('the unapprovedLocal is '+ unapprovedLocal);
                            
                        // }
                        
                    //   system.debug('nullCheck'+sreq.Purchase_Order_Stock__c+'12'+sreq.Stock_In_Transit__c+'23'+sreq.Outgoing_Reservations__c+'34'+unapprovedLocal);
                      
                        // if(unapprovedLocal!=null){
                        //     wrapObj.netTotal=UnretricStock+PurchaseStock+StockTransit-OutgoingReserve-unapprovedLocal;
                        // }
                        // else{
                            wrapObj.netTotal=UnretricStock+PurchaseStock+StockTransit-OutgoingReserve;
                        // }
                        system.debug('@@@newlstInventoryElse'+lstInventory);
                        if(lstInventory!=null && lstInventory.size()>0)
                        {
                            
                            pskuList= New List<String>();
                            for(Inventory__c inv :lstInventory){
                                
                                system.debug('myloopInternal');
                                System.debug('**Inventory__c -> '+inv.SKU__r.SKU_Code__c+' == '+sreq.SKU__r.SKU_Code__c);
                                if(sreq.SKU__c == inv.SKU__c && sreq.Depot__r.Depot_Code__c==inv.Depot__r.Depot_Code__c && sreq.Sales_Org_Code__c==inv.Sales_Org_Code__c){
                                    wrapObj.SLocation.add((inv.storage_Location_Depot__r.Name!=null && inv.storage_Location_Depot__r.Name!='') ? inv.storage_Location_Depot__r.Name : '-');  
                                    wrapObj.PSku.add((inv.SKU__r.SKU_Description__c!=null && inv.SKU__r.SKU_Description__c!='') ? inv.SKU__r.SKU_Description__c : '-');   
                                    wrapObj.UnrestrictInvent.add(inv.Stock_Quantity__c != null ? inv.Stock_Quantity__c :0);  
                                    wrapObj.BNumber.add((inv.Batch_Number__c!=null && inv.Batch_Number__c!='') ? inv.Batch_Number__c : '-');  
                                   wrapObj.PDate.add(inv.Production_Date__c != null? GetEuropeInventoryData.getDate(inv.Production_Date__c):'-');   
                                    wrapObj.EDate.add(inv.Expiry_Date__c != null? GetEuropeInventoryData.getDate(inv.Expiry_Date__c):'-'); 
                                    pskuList.add(inv.SKU__r.SKU_Description__c);
                                }
                            }  
                        }
                        system.debug('pskuList@@@'+pskuList);
                        
                        if(pskuList!=null){
                            if(pskuList.size()>0){
                                wrapObj.isData=true;
                            }
                            else{
                                wrapObj.isData=false;
                            }
                        }
                        lstWrapStkReqInventObj.add(wrapObj);   
                    } 
                }
                wObj.listWrapStkReqInv = lstWrapStkReqInventObj;
                system.debug('FinalWrapper'+wObj);
                return wObj;  
            }
        }catch(Exception e){
            system.debug('Error Message >>--->'+e.getMessage());
            system.debug('Error Message Line Number >>--->'+e.getLineNumber());
            system.debug('Error Cause >>--->'+e.getCause());
            system.debug('Error getStackTraceString >>--->'+e.getStackTraceString());
            return null;
        }
    } 
    
    @AuraEnabled(cacheable=true)
    public static  List<sObject> getlistdata(string objname,string fieldname){
        List<String> salesorgcode = System.Label.Grz_EuropeSalesOrgCode.trim().Split(',');
        system.debug('@@@data@@@'+objname+'####'+fieldname);

        list<string> depot = new list<string>();
        list<string> salesOrg = new list<string>();
        
         
            profile p = [select id,name from profile where Id =: userinfo.getProfileid()];

            if(p.name.contains('Central Europe Bulgaria')){
                depot.add('\''+System.Label.Grz_BulgariaDepot+'\'');
                salesOrg.add('\'2471\'');
            }
            else if(p.name.contains('Central Europe Hungary')){
                 depot.add('\''+System.Label.Grz_HungaryDepot+'\'');
                salesOrg.add('\'2921\'');
            }
            else if(p.name.contains('Central Europe Romania')){
                depot.add('\''+System.Label.Grz_RomaniaDepot+'\'');
                salesOrg.add('\'2081\'');
            }
            else{
                depot.add('\''+System.Label.Grz_BulgariaDepot+'\'');
                depot.add('\''+System.Label.Grz_HungaryDepot+'\'');
                depot.add('\''+System.Label.Grz_RomaniaDepot+'\'');
                salesOrg.add('\''+System.Label.Grz_BulgariaSalesOrgCode+'\'');
                salesOrg.add('\''+System.Label.Grz_HungarySalesOrgCode+'\'');
                salesOrg.add('\''+System.Label.Grz_RomaniaSalesOrgCode+'\'');
            }

        String WhereClause;
        String soql;
        if(fieldname=='SKU__r.SKU_Description__c'){
         WhereClause='(Depot__r.Country__c = \'Europe\' And Depot__r.name In '+depot+' And Sales_Org__r.Sales_Org_Code__c IN '+salesOrg+'  And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\')  And SKU__r.Division__r.Division_Code__c IN (\'10\')) ORDER BY SKU__r.SKU_Description__c';   
        }
        else if(fieldname=='Depot_Code__c'){
          WhereClause='Depot__r.Country__c = \'Europe\' AND RecordType.Name=\'Storage Location\' And Depot__r.name IN '+depot+' Order By Name';    
        }
         else if(fieldname=='SKU__r.SKU_Code__c'){
            WhereClause='(Depot__r.Country__c = \'Europe\' And Depot__r.name In '+depot+' And ((Sales_Org__r.Sales_Org_Code__c IN '+salesOrg+' And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\') )) And SKU__r.Division__r.Division_Code__c IN (\'10\')) ORDER BY SKU__r.SKU_Code__c';    
        }
         else if(fieldname=='SKU__r.Brand_Name__c'){
             WhereClause='(Depot__r.Country__c = \'Europe\'And Depot__r.name In '+depot+' And ((Sales_Org__r.Sales_Org_Code__c IN '+salesOrg+' And SKU__r.Distribution_Channel__r.Distribution_Channel_Code__c IN (\'20\') )) And SKU__r.Division__r.Division_Code__c IN (\'10\')) ORDER BY SKU__r.SKU_Code__c';   
        }
        
        System.debug('WhereClause'+WhereClause);
        soql = 'SELECT Name, Id, ' +
            fieldname +
            ' FROM '  + String.escapeSingleQuotes(objname) +
            ' WHERE ' + WhereClause;
        
        System.debug('soql inside AutoComplete--> '+soql);
        return Database.query(soql);
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
            User LoginUser = [SELECT Id, Country,Profile.Name FROM User Where Id=:userId];
            isAdmin = LoginUser.Profile.Name == 'System Administrator' ? True : LoginUser.Profile.Name == 'Finese System Admin' ? True : False;
        }
    }
    
    public class WrapStockReqInventory{
        @AuraEnabled public Stock_Requirement__c  stkReq{get;set;}
        @AuraEnabled public list<String> SLocation{get;set;}
        @AuraEnabled public list<String> PSku{get;set;}
        @AuraEnabled public list<Decimal> UnrestrictInvent{get;set;}
        @AuraEnabled public list<String> BNumber{get;set;}
        @AuraEnabled public list<String> PDate{get;set;}
        @AuraEnabled public list<String> EDate{get;set;}
        // @AuraEnabled public Decimal unapproved{get;set;}
        @AuraEnabled public Decimal netTotal{get;set;}
        @AuraEnabled public boolean isData{get;set;}
        
        	
        public WrapStockReqInventory(){
            stkReq = new Stock_Requirement__c();
            SLocation = new  list<String>();
            PSku = new  list<String>();
            UnrestrictInvent = new  list<Decimal>();
            BNumber = new  list<String>();
            PDate = new  list<String>();
            EDate = new  list<String>();
            // unapproved=0.0;
            netTotal=0.0;
            isData=false;
            
        }        
    }    
    public static string getDate(Date d){
        Datetime todayDateTime = d; // Implicit cast
        String str = todayDateTime.format('MMM');
        System.debug('Month : ' + str);
        //String dd=d.day() + '-' + d.month() + '-' + d.year();
        String dd=d.day() + ' ' + str + ', ' + d.year();
        return dd;
    }
}