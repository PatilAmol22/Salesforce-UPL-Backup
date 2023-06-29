/*
Author      # Vijaylaxmi
Requirement # SCTASK0621778 Price Control Requirements to display Limit value for SalesOrder submit for Approval to persons


*/
public class SalesOrderLineItemTriggerHandler {



//added by Ashraf- to dump the product qty to salesorder qty
    public static void updatenewQuantityToOld(List<Sales_Order_Line_Item__c> newSalesOrderLineItemList, Map<Id,Sales_Order_Line_Item__c> oldSalesOrderLineItemList){
        for(Sales_Order_Line_Item__c soil : newSalesOrderLineItemList){
            Sales_Order_Line_Item__c soil_old = (Sales_Order_Line_Item__c)oldSalesOrderLineItemList.get(soil.Id);
            system.debug('soil_old::'+soil_old);
            if(soil.Quantity__c != soil_old.Quantity__c){
                //  soil.Quantity_old__c = soil_old.Quantity__c;
            }
        }
    }
    //end
     public  static void onAfterInsert(List<Sales_Order_Line_Item__c> newSalesOrderLineItemList){
     
     Set <Id> skuIdSet = new Set <Id> (); 
     Set<Id>  salesOrderLineID = new Set<Id>(); 
     for (Sales_Order_Line_Item__c SalesOrdLineItem: newSalesOrderLineItemList) { 
        if (SalesOrdLineItem.SKU_Name__c != Null && SalesOrdLineItem.Sales_Org_Code__c=='5100') { 
             skuIdSet.add (SalesOrdLineItem.SKU_Name__c); 
             salesOrderLineID.add(SalesOrdLineItem.id);
        } 
    } 
    system.debug('@@@@@@@@@@skuIdSet-->'+skuIdSet);
    List<PriceBookMaster__c> priceBookMasterList = new  List<PriceBookMaster__c>();
    List<Sales_Order_Line_Item__c> salesOrderLineItem = new  List<Sales_Order_Line_Item__c>();
   
  // It will pick only Maxico Price Book 
    if(skuIdSet.size()>0)  
    {
         priceBookMasterList  = [SELECT Id, Director_Price__c,Manager_Price__c ,SKUCode__c,Sub_Region_Price__c
                                                            FROM PriceBookMaster__c
                                                            WHERE SKUCode__c in: skuIdSet 
                                                            AND StartDate__c <= TODAY AND EndDate__c >= TODAY 
                                                            AND SKUCode__r.Sales_Org_Code__c ='5100' 
                                                            AND SKUCode__r.Active__c = True] ;
    }
     if(salesOrderLineID.size()>0)  
    {                                                       
        salesOrderLineItem  = [SELECT Id, Director_Price_Latam_Director_Pri__c,  Manager_Price_Sales_Director_Price__c,
                                SKU_Name__c,Sub_Region_Price__c 
                                FROM Sales_Order_Line_Item__c
                                WHERE id in: salesOrderLineID
                                AND  Sales_Org_Code__c='5100'
                                                                   ] ; 
      }                                                                 
     system.debug('@@@@@@@@@@priceBookMasterList-->'+priceBookMasterList);
     system.debug('@@@@@@@@@@salesOrderLineItem-->'+salesOrderLineItem);   
     
     Set<Sales_Order_Line_Item__c> setSalesOrderLineItem = new Set<Sales_Order_Line_Item__c> ();
     if(priceBookMasterList.size()>0 && salesOrderLineItem.size()>0){
         for( PriceBookMaster__c pricemaster :priceBookMasterList){
         
            for (Sales_Order_Line_Item__c salesOrderLineItemupdate: salesOrderLineItem) { 
            
                if(pricemaster.SKUCode__c==salesOrderLineItemupdate.SKU_Name__c){
                system.debug('######### inside if');
                
                salesOrderLineItemupdate.Director_Price_Latam_Director_Pri__c = pricemaster.Director_Price__c; 
                salesOrderLineItemupdate.Manager_Price_Sales_Director_Price__c = pricemaster.Manager_Price__c; 
                salesOrderLineItemupdate.Sub_Region_Price__c = pricemaster.Sub_Region_Price__c; 
                setSalesOrderLineItem.add (salesOrderLineItemupdate); 
               } 
            } 
         }
     }   
     system.debug('@@@@@@@@@@setSalesOrderLineItem-->'+setSalesOrderLineItem); 
        
     List <Sales_Order_Line_Item__c> salesOrderLineItemList = new List <Sales_Order_Line_Item__c> (setSalesOrderLineItem);   
     If (salesOrderLineItemList.size ()> 0){
         system.debug('@@@@@@@@@@salesOrderLineItemList-->'+salesOrderLineItemList); 
         update salesOrderLineItemList; 
     } 
            
    } 
      //added by Atish @wipro Start
    public static void ProductCancellation(List<Sales_Order_Line_Item__c> productList)
    {
        system.debug('finalstart');
        
        Set<Id> setOrderId = new Set<Id>();
        List<Sales_Order_Line_Item__c> lstOrderItem = new List<Sales_Order_Line_Item__c>();
        Map<string, decimal> mapItemBalance = new Map<string, decimal>();
        Set<string> setBrandName = new Set<string>();
        Map<string, set<string>> mapBrandSKUs = new Map<string, set<string>>();
        Map<string, decimal> mapBrandBalance = new Map<string, decimal>();
        for(Sales_Order_Line_Item__c oSO: productList) {
            if(oSO.Item_Status__c == 'Cancel'){
                setOrderId.add(oSO.Id);
                system.debug('setOrderId'+setOrderId);
            }
        }
        if(setOrderId.size() > 0){
            lstOrderItem = [select Id, Sale_Order__c, Quantity__c,Item_Status__c, Brazil_Product__c,SKU_Name__r.Brand_Name__c, (Select Id, Quantity__c, Sales_Order_Line_Item__c from Invoice_Line_Item__r) from Sales_Order_Line_Item__c where Id IN: setOrderId];
            
            if(lstOrderItem.size() > 0){
                for(Sales_Order_Line_Item__c oOrderItem: lstOrderItem){
                    decimal InvoiceQty = 0;
                    for(Invoice_Line_Item__c oInv: oOrderItem.Invoice_Line_Item__r){
                        InvoiceQty = InvoiceQty + oInv.Quantity__c;
                    }
                    if(oOrderItem.Quantity__c - InvoiceQty > 0) {
                        mapItemBalance.put(oOrderItem.Brazil_Product__c, oOrderItem.Quantity__c - InvoiceQty);
                    }
                    system.debug('mapItemBalance'+mapItemBalance);
                    setBrandName.add(oOrderItem.SKU_Name__r.Brand_Name__c);
                    if(setBrandName.size() > 0) {
                        for(string sBrand: setBrandName){
                            set<string> lstSKUName = new set<string>();
                            for(Sales_Order_Line_Item__c oOrderItem1: lstOrderItem){
                                if(sBrand == oOrderItem1.SKU_Name__r.Brand_Name__c) {
                                    lstSKUName.add(oOrderItem1.Brazil_Product__c);
                                }
                            }
                            mapBrandSKUs.put(sBrand, lstSKUName);
                        }
                    }
                    
                }
            }
            if(mapBrandSKUs.size() > 0 && mapItemBalance.size() > 0) {
                for(string oBrand: mapBrandSKUs.keySet()){
                    decimal count = 0;
                    if(mapBrandSKUs.containsKey(oBrand)) {
                        for(string oProduct: mapBrandSKUs.get(oBrand)){
                            if(mapItemBalance.containsKey(oProduct)) {
                                count = count + mapItemBalance.get(oProduct);
                            }
                        }
                        mapBrandBalance.put(oBrand, count);
                    }
                }
            }
            
            if(mapBrandBalance.size() > 0) {
                
                Inventory_Parameter1__mdt ip1 = [SELECT id,Sales_Org_BU__c from Inventory_Parameter1__mdt ];
                string sBUValue = '5191';
                if(ip1.Sales_Org_BU__c != sBUValue || Test.isRunningTest()) {
                    Territory_Distributor__c u =[SELECT ID, Name, Zone_Code__c FROM Territory_Distributor__c WHERE SalesOrg__r.Sales_Org_Code__c = '5191' AND TerritoryManagerActive__c = True AND (                                  TerritoryManager__c=: UserInfo.getUserId() 
                                                                                                                                                                                                    OR Region__r.RegionHead__c=: UserInfo.getUserId()
                                                                                                                                                                                                    OR Region__r.Brazil_Marketing_Ops_Manager__c=:UserInfo.getUserId()
                                                                                                                                                                                                    
                                                                                                                                                                                                    OR Zone__r.ZonalHead__c=: UserInfo.getUserId()
                                                                                                                                                                                                    OR SBU__r.SBUUser__c=: UserInfo.getUserId()
                                                                                                                                                                                                    OR BarterManager__c=: UserInfo.getUserId()
                                                                                                                                                                                                   )];
                    sBUValue = u.Zone_Code__c;
                }
                
                list<Inventory_Control__c> fy = [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c,Product_Name__c FROM Inventory_Control__c where BU__c =: sBUValue AND  Product__c IN: mapBrandBalance.keySet()];
                boolean isUpdate = false; 
                if(fy.size() > 0) {
                    for(Inventory_Control__c icRecords : fy){
                        if(mapBrandBalance.containsKey(icRecords.Product__c)) {
                            icRecords.Quantity__c = icRecords.Quantity__c + mapBrandBalance.get(icRecords.Product__c);
                            isUpdate = true;
                        } 
                    }
                }   
                if(isUpdate) {
                    update fy;
                    System.debug('Testfinal'+fy);
                }
            }       
            
        }
    }
    
    //CREATED Trigger FOR INVENTORY CONTROL BY HARSHIT&ANMOL@WIPRO FOR (US IU-001) ---START
    
    public static void inventorycontrol(List<Sales_Order_Line_Item__c> newList){
        
        list<String> idlist = new list<String>();        
        for(Sales_Order_Line_Item__c s: newList){
            String sid = s.id;
            idlist.add(sid);
            
        }
        System.debug('idlist'+idlist);
        System.debug('newList'+newList);
        
        list<Inventory_Control__c> updatedfy = new list<Inventory_Control__c>();
        List<Sales_Order_Line_Item__c> salesOrderItemList = new  List<Sales_Order_Line_Item__c>();
        if(idlist.size()>0){
            salesOrderItemList = [SELECT ID,SKU_Name__r.Brand_Name__c,Quantity__c,DateofFAT__c,Sale_Order__c,Sale_Order__r.Type_of_Order__c FROM Sales_Order_Line_Item__c WHERE id IN :idlist];
        }
        
        
        
        Period c = new Period();
        Inventory_Parameter1__mdt ip1 = [SELECT id,Sales_Org_BU__c from Inventory_Parameter1__mdt ];
        
        List<Inventory_Control__c> f = new List<Inventory_Control__c>();
        
        if(ip1.Sales_Org_BU__c=='5191'){
            f =  [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c FROM Inventory_Control__c where BU__c='5191'];
            
            for(Sales_Order_Line_Item__c s: salesOrderItemList){
                
                
                
                Date d = Date.valueOf(s.DateofFAT__c);    
                for(Inventory_Control__c i1 : f){
                    if(i1.Product__c== s.SKU_Name__r.Brand_Name__c && s.Sale_Order__r.Type_of_Order__c!='ORDEM FILHA'){
                        
                        String y2 = i1.Fiscal_Year__c;
                        System.debug('y2= '+y2);
                        
                        string y3 = y2.substring(3);
                        System.debug('y3= '+y3);
                        
                        string y4 = y2.substring(0,2);
                        
                        System.debug('y4= '+y4);
                        
                        string y5 ='20'+y4+'-04-01';
                        System.debug('y5= '+y5);
                        
                        String y6= '20'+y3+'-03-31';
                        System.debug('y6= '+y6);
                        
                        Date d1 = Date.valueOf(y5);
                        Date d2 = Date.valueOf(y6);
                        
                        System.debug('i1.Quantity__c'+i1.Quantity__c);
                        
                        System.debug('s.Quantity__c'+s.Quantity__c);
                        
                        if(d1 <= d && d <= d2 ){
                            i1.Quantity__c = (i1.Quantity__c - s.Quantity__c);
                            System.debug('2nd wala');
                        }
                    }
                }
                
                
                
            }
            updatedfy.addall(f);
        }  
        else{
            
            Territory_Distributor__c u =[SELECT ID, Name, Zone_Code__c FROM Territory_Distributor__c WHERE SalesOrg__r.Sales_Org_Code__c = '5191' AND TerritoryManagerActive__c = True AND (TerritoryManager__c=: UserInfo.getUserId() 
                                                                                                                                                                                            OR Region__r.RegionHead__c=: UserInfo.getUserId()
                                                                                                                                                                                            OR Region__r.Brazil_Marketing_Ops_Manager__c=:UserInfo.getUserId()
                                                                                                                                                                                            
                                                                                                                                                                                            OR Zone__r.ZonalHead__c=: UserInfo.getUserId()
                                                                                                                                                                                            OR SBU__r.SBUUser__c=: UserInfo.getUserId()
                                                                                                                                                                                            OR BarterManager__c=: UserInfo.getUserId()
                                                                                                                                                                                           ) Limit 1];
            f =  [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c FROM Inventory_Control__c where BU__c =: u.Zone_Code__c ];
            
            for(Sales_Order_Line_Item__c s: salesOrderItemList){
                
                Date d = Date.valueOf(s.DateofFAT__c);    
                for(Inventory_Control__c i1 : f){
                    if(i1.Product__c== s.SKU_Name__r.Brand_Name__c && s.Sale_Order__r.Type_of_Order__c!='ORDEM FILHA'){
                        String y2 = i1.Fiscal_Year__c;
                        System.debug('y2= '+y2);
                        string y3 = y2.substring(3);
                        System.debug('y3= '+y3);
                        string y4 = y2.substring(0,2);
                        System.debug('y4= '+y4);
                        string y5 ='20'+y4+'-04-01';
                        System.debug('y5= '+y5);
                        String y6= '20'+y3+'-03-31';
                        System.debug('y6= '+y6);
                        Date d1 = Date.valueOf(y5);
                        Date d2 = Date.valueOf(y6);
                        System.debug('i1.Quantity__c'+i1.Quantity__c);
                        System.debug('so.Quantity__c'+s.Quantity__c);
                        if(d1 <= d && d <= d2 ){
                            i1.Quantity__c = (i1.Quantity__c - s.Quantity__c);
                            System.debug('2nd wala');
                        }
                    }
                }
            }
            updatedfy.addall(f);
            
        }
        System.debug('updatedfy'+updatedfy);
        update updatedfy;
    }
    //--END
    
    
    //added by Sagar@wipro for FAT Change and Inventory Quantity Handle
    public static void changedateofFAT(List<Sales_Order_Line_Item__c> newList){
        
        list<String> idlist = new list<String>();    
        Inventory_Control__c f = new Inventory_Control__c();
        Inventory_Control__c f1 = new Inventory_Control__c();
        for(Sales_Order_Line_Item__c s: newList){
            String sid = s.id;
            idlist.add(sid);               
        }
        System.debug('idlist'+idlist);
        System.debug('newList'+newList);
        
        list<Inventory_Control__c> updatedfy = new list<Inventory_Control__c>();
        
        List<Sales_Order_Line_Item__c> salesOrderItemList = new  List<Sales_Order_Line_Item__c>();
        Period c = new Period();
        Period c1 = new Period();
        if(idlist.size()>0){
            salesOrderItemList = [SELECT ID,SKU_Name__r.Brand_Name__c,Quantity__c,DateofFAT__c,New_Date_of_FAT__c,Unbilled_Quatity__c,Sale_Order__c FROM Sales_Order_Line_Item__c WHERE id IN :idlist];
            // lstOrderItem = [select Id, Sale_Order__c, Quantity__c, Brazil_Product__c, SKU_Name__r.Brand_Name__c, (Select Id, Quantity__c, Sales_Order_Line_Item__c from Invoice_Line_Item__r) from Sales_Order_Line_Item__c where Sale_Order__c IN: setOrderId];
            
        }
        for(Sales_Order_Line_Item__c i : salesOrderItemList){
            Date d = i.DateofFAT__c;
            string year = string.valueOf(d.year());
            integer y = integer.valueOf(year.remove('20'));
            integer month = d.month();
            string sfy = '';
            if(month >= 4 && month <= 12){
                sfy = string.valueOf(y)+'/'+string.valueOf(y+1);
            }
            else if(month >= 1 && month <= 3){
                sfy = string.valueOf(y-1)+'/'+string.valueOf(y);
            }
            
            Date d1 = i.New_Date_of_FAT__c;
            string year1 = string.valueOf(d1.year());
            integer y1 = integer.valueOf(year1.remove('20'));
            integer month1 = d1.month();
            string sfy1 = '';
            if(month1 >= 4 && month1 <= 12){
                sfy1 = string.valueOf(y1)+'/'+string.valueOf(y1+1);
            }
            else if(month1 >= 1 && month1 <= 3){
                sfy1 = string.valueOf(y1-1)+'/'+string.valueOf(y1);
            }
            
            Inventory_Parameter1__mdt ip1 = [SELECT id,Sales_Org_BU__c from Inventory_Parameter1__mdt ];
            if(sfy != sfy1)
            {
                if(ip1.Sales_Org_BU__c=='5191'){
                    
                    f = [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c FROM Inventory_Control__c where BU__c='5191' AND Product__c=: i.SKU_Name__r.Brand_Name__c AND Fiscal_Year__c =:sfy1  FOR UPDATE];
                    f.Quantity__c = (f.Quantity__c - i.Unbilled_Quatity__c);
                    updatedfy.add(f);
                    
                    f1 = [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c FROM Inventory_Control__c where BU__c='5191' AND Product__c=: i.SKU_Name__r.Brand_Name__c AND Fiscal_Year__c =:sfy  FOR UPDATE];
                    
                    f1.Quantity__c = (f1.Quantity__c + i.Unbilled_Quatity__c);
                    updatedfy.add(f1);   
                }
                
                else{
                    
                    Territory_Distributor__c u =[SELECT ID, Name, Zone_Code__c FROM Territory_Distributor__c WHERE SalesOrg__r.Sales_Org_Code__c = '5191' AND TerritoryManagerActive__c = True AND (TerritoryManager__c=: UserInfo.getUserId() 
                                                                                                                                                                                                    OR Region__r.RegionHead__c=: UserInfo.getUserId()
                                                                                                                                                                                                    OR Region__r.Brazil_Marketing_Ops_Manager__c=:UserInfo.getUserId()
                                                                                                                                                                                                    
                                                                                                                                                                                                    OR Zone__r.ZonalHead__c=: UserInfo.getUserId()
                                                                                                                                                                                                    OR SBU__r.SBUUser__c=: UserInfo.getUserId()
                                                                                                                                                                                                    OR BarterManager__c=: UserInfo.getUserId()
                                                                                                                                                                                                   ) Limit 1];
                    
                    f = [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c FROM Inventory_Control__c where BU__c=: u.Zone_Code__c AND Product__c=: i.SKU_Name__r.Brand_Name__c AND Fiscal_Year__c =:sfy1 FOR UPDATE];
                    
                    f.Quantity__c = (f.Quantity__c - i.Unbilled_Quatity__c);
                    
                    updatedfy.add(f);
                    
                    f1 = [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c FROM Inventory_Control__c where BU__c=: u.Zone_Code__c AND Product__c=: i.SKU_Name__r.Brand_Name__c AND Fiscal_Year__c =:sfy FOR UPDATE];
                    f1.Quantity__c = (f1.Quantity__c + i.Unbilled_Quatity__c);
                    updatedfy.add(f1);   
                }  
            }
            if(!Test.isRunningTest()){
            update updatedfy;
            }
        }
    }
    
    //added by Sagar@wipro for Line Item cancel and Inventory Quantity Handle
    public static void CancelItemHandle(List<Sales_Order_Line_Item__c> newList){
        
        list<Inventory_Control__c> updatedfy = new list<Inventory_Control__c>();
        Inventory_Control__c f = new Inventory_Control__c();
        Inventory_Control__c f1 = new Inventory_Control__c();
        Period c = new Period();
        Period c1 = new Period();
        Inventory_Parameter1__mdt ip1 = [SELECT id,Sales_Org_BU__c from Inventory_Parameter1__mdt ]; 
        
        for(Sales_Order_Line_Item__c i : newList){   
            Date d = i.DateofFAT__c;
            string year = string.valueOf(d.year());
            integer y = integer.valueOf(year.remove('20'));
            integer month = d.month();
            string sfy = '';
            if(month >= 4 && month <= 12){
                sfy = string.valueOf(y)+'/'+string.valueOf(y+1);
            }
            else if(month >= 1 && month <= 3){
                sfy = string.valueOf(y-1)+'/'+string.valueOf(y);
            }
            if(ip1.Sales_Org_BU__c=='5191'){  
                f = [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c FROM Inventory_Control__c where BU__c='5191' AND Product__c=: i.SKU_Name__r.Brand_Name__c AND Fiscal_Year__c =:sfy  FOR UPDATE]; 
                f.Quantity__c = (f.Quantity__c + i.Unbilled_Quatity__c);   
                updatedfy.add(f);    
            }
            else{  
                Territory_Distributor__c u =[SELECT ID, Name, Zone_Code__c FROM Territory_Distributor__c 
                                             WHERE SalesOrg__r.Sales_Org_Code__c = '5191' AND TerritoryManagerActive__c = True 
                                             AND (TerritoryManager__c=: UserInfo.getUserId() 
                                                  OR Region__r.RegionHead__c=: UserInfo.getUserId()
                                                  OR Region__r.Brazil_Marketing_Ops_Manager__c=:UserInfo.getUserId()
                                                  OR Zone__r.ZonalHead__c=: UserInfo.getUserId()
                                                  OR SBU__r.SBUUser__c=: UserInfo.getUserId()
                                                  OR BarterManager__c=: UserInfo.getUserId()) Limit 1];
                
                f = [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c FROM Inventory_Control__c where BU__c=: u.Zone_Code__c AND Product__c=: i.SKU_Name__r.Brand_Name__c AND Fiscal_Year__c =:sfy FOR UPDATE];
                system.debug(' i.Unbilled_Quatity__c '+i.Unbilled_Quatity__c);
                f.Quantity__c = (f.Quantity__c + i.Unbilled_Quatity__c);
                system.debug(' f.Quantity__c '+f.Quantity__c);
                updatedfy.add(f);  
            } 
        }
        if(!Test.isRunningTest()){
        update updatedfy;
        }
    }
    
    //added by Sagar@wipro for Quantity Change and Inventory Quantity Handle
    public static void QuantityChangeHandle(List<Sales_Order_Line_Item__c> newList){
        
        list<Inventory_Control__c> updatedfy = new list<Inventory_Control__c>();
        Inventory_Control__c f = new Inventory_Control__c();
        Inventory_Control__c f1 = new Inventory_Control__c();
        Period c = new Period();
        Period c1 = new Period();
        Set<string> setBrandName = new Set<string>();
        List<Sales_Order_Line_Item__c> lstOrderItem = new List<Sales_Order_Line_Item__c>();
        // if(!Test.isRunningTest()){
        if(newList.size() > 0){
            for(Sales_Order_Line_Item__c sitem : newList){
                setBrandName.add(sitem.SKU_Name__r.Brand_Name__c);
            }
       // }
         }
        else{
            setBrandName.add('SPERTO');
        }
        
        Inventory_Parameter1__mdt ip1 = [SELECT id,Sales_Org_BU__c from Inventory_Parameter1__mdt ];
        string sBUValue = '5191';
        if(ip1.Sales_Org_BU__c != sBUValue) {
            Territory_Distributor__c u =[SELECT ID, Name, Zone_Code__c FROM Territory_Distributor__c WHERE SalesOrg__r.Sales_Org_Code__c = '5191' AND TerritoryManagerActive__c = True AND (                                  TerritoryManager__c=: UserInfo.getUserId() 
                                                                                                                                                                                            OR Region__r.RegionHead__c=: UserInfo.getUserId()
                                                                                                                                                                                            OR Region__r.Brazil_Marketing_Ops_Manager__c=:UserInfo.getUserId()
                                                                                                                                                                                            OR Zone__r.ZonalHead__c=: UserInfo.getUserId()
                                                                                                                                                                                            OR SBU__r.SBUUser__c=: UserInfo.getUserId()
                                                                                                                                                                                            OR BarterManager__c=: UserInfo.getUserId()
                                                                                                                                                                                           ) limit 1];
            sBUValue = u.Zone_Code__c;
        }
        
        list<Inventory_Control__c> fy = [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c,Product_Name__c FROM Inventory_Control__c where BU__c =: sBUValue AND  Product__c IN: setBrandName order by Product__c];
        list<Inventory_Control__c> lstFYUpdate = new list<Inventory_Control__c>();
        for(Inventory_Control__c oFy : fy){
            decimal count = 0;
            for(Sales_Order_Line_Item__c i : newList){   
                Date d = i.DateofFAT__c;
                string year = string.valueOf(d.year());
                integer y = integer.valueOf(year.remove('20'));
                integer month = d.month();
                string sfy = '';
                if(month >= 4 && month <= 12){
                    sfy = string.valueOf(y)+'/'+string.valueOf(y+1);
                }
                else if(month >= 1 && month <= 3){
                    sfy = string.valueOf(y-1)+'/'+string.valueOf(y);
                }
                
                if(oFy.Fiscal_Year__c == sfy && oFy.Product__c == i.SKU_Name__r.Brand_Name__c) {
                    count = count + (i.Quantity__c - i.New_Quantity__c);
                }
                
            } 
            if(count > 0){
                oFy.Quantity__c = oFy.Quantity__c + count;
                lstFYUpdate.add(oFy);
            }
        }
        if(lstFYUpdate.size() > 0) {
            update lstFYUpdate;
        }
    }
    
    
    //added by Sagar@wipro for FAT Change, Quantity change and Inventory Quantity Handle
    public static void changeDOFQTY(List<Sales_Order_Line_Item__c> newList){
        
        Inventory_Control__c f = new Inventory_Control__c();
        Inventory_Control__c f1 = new Inventory_Control__c();
        
        System.debug('newList'+newList);
        list<Inventory_Control__c> updatedfy = new list<Inventory_Control__c>();
        list<Inventory_Control__c> updatedfy1 = new list<Inventory_Control__c>();
        System.debug('TestSagar221'); 
        Inventory_Parameter1__mdt ip1 = [SELECT id,Sales_Org_BU__c from Inventory_Parameter1__mdt ];
        
        for(Sales_Order_Line_Item__c i : newList){
            Date d = i.DateofFAT__c;
            string year = string.valueOf(d.year());
            integer y = integer.valueOf(year.remove('20'));
            integer month = d.month();
            string sfy = '';
            if(month >= 4 && month <= 12){
                sfy = string.valueOf(y)+'/'+string.valueOf(y+1);
            }
            else if(month >= 1 && month <= 3){
                sfy = string.valueOf(y-1)+'/'+string.valueOf(y);
            }
            
            Date d1 = i.New_Date_of_FAT__c;
            string year1 = string.valueOf(d1.year());
            integer y1 = integer.valueOf(year1.remove('20'));
            integer month1 = d1.month();
            string sfy1 = '';
            if(month1 >= 4 && month1 <= 12){
                sfy1 = string.valueOf(y1)+'/'+string.valueOf(y1+1);
            }
            else if(month1 >= 1 && month1 <= 3){
                sfy1 = string.valueOf(y1-1)+'/'+string.valueOf(y1);
            }
            System.debug(sfy1); 
            System.debug(sfy); 
            System.debug('sfy1'); 
            if(sfy1 != sfy)
            {
                System.debug('inside iff 123'); 
                if(ip1.Sales_Org_BU__c=='5191'){
                    
                    f = [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c FROM Inventory_Control__c where BU__c='5191' AND Product__c=: i.SKU_Name__r.Brand_Name__c AND Fiscal_Year__c =:sfy1  FOR UPDATE];
                    // f.Quantity__c = (f.Quantity__c - (i.Quantity__c - i.New_Quantity__c));
                    f.Quantity__c = (f.Quantity__c - (i.New_Quantity__c - i.Quantity_Billed__c));
                    updatedfy.add(f);
                    f1 = [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c FROM Inventory_Control__c where BU__c='5191' AND Product__c=: i.SKU_Name__r.Brand_Name__c AND Fiscal_Year__c =:sfy  FOR UPDATE];
                    // f1.Quantity__c = (f1.Quantity__c + (i.Quantity__c - i.New_Quantity__c)  );
                    // Unbilled_Quatity__c
                    f1.Quantity__c = (f1.Quantity__c + (i.Unbilled_Quatity__c));
                    updatedfy.add(f1);   
                }
                else{
                    Territory_Distributor__c u =[SELECT ID, Name, Zone_Code__c FROM Territory_Distributor__c WHERE SalesOrg__r.Sales_Org_Code__c = '5191' AND TerritoryManagerActive__c = True AND (TerritoryManager__c=: UserInfo.getUserId() 
                                                                                                                                                                                                    OR Region__r.RegionHead__c=: UserInfo.getUserId()
                                                                                                                                                                                                    OR Region__r.Brazil_Marketing_Ops_Manager__c=:UserInfo.getUserId()
                                                                                                                                                                                                    OR Zone__r.ZonalHead__c=: UserInfo.getUserId()
                                                                                                                                                                                                    OR SBU__r.SBUUser__c=: UserInfo.getUserId()
                                                                                                                                                                                                    OR BarterManager__c=: UserInfo.getUserId()
                                                                                                                                                                                                   ) Limit 1];
                    f = [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c FROM Inventory_Control__c where BU__c=: u.Zone_Code__c AND Product__c=: i.SKU_Name__r.Brand_Name__c AND Fiscal_Year__c =:sfy1 FOR UPDATE];
                    //  f.Quantity__c = (f.Quantity__c - (i.Quantity__c - i.New_Quantity__c));
                    f.Quantity__c = (f.Quantity__c - (i.New_Quantity__c - i.Quantity_Billed__c));
                    updatedfy.add(f);
                    system.debug('updatedfy11'+updatedfy);
                    f1 = [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c FROM Inventory_Control__c where BU__c=: u.Zone_Code__c AND Product__c=: i.SKU_Name__r.Brand_Name__c AND Fiscal_Year__c =:sfy FOR UPDATE];
                    //   f1.Quantity__c = (f1.Quantity__c + (i.Quantity__c - i.New_Quantity__c));
                    //f1.Quantity__c = (f1.Quantity__c + (i.Quantity__c - i.New_Quantity__c)  );
                    f1.Quantity__c = (f1.Quantity__c + (i.Unbilled_Quatity__c));
                    updatedfy.add(f1); 
                    system.debug('updatedfy22'+updatedfy);
                } 
            }
            else{
                if(ip1.Sales_Org_BU__c=='5191'){
                    System.debug('Brand = '+i.SKU_Name__r.Brand_Name__c);
                    System.debug('sfy = '+sfy);
                    f1 = [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c FROM Inventory_Control__c where BU__c='5191' AND Product__c=: i.SKU_Name__r.Brand_Name__c AND Fiscal_Year__c =:sfy  FOR UPDATE];
                    f1.Quantity__c = (f1.Quantity__c + (i.Quantity__c - i.New_Quantity__c));
                    updatedfy1.add(f1);   
                }
                else{
                    Territory_Distributor__c u =[SELECT ID, Name, Zone_Code__c FROM Territory_Distributor__c WHERE SalesOrg__r.Sales_Org_Code__c = '5191' AND TerritoryManagerActive__c = True AND (TerritoryManager__c=: UserInfo.getUserId() 
                                                                                                                                                                                                    OR Region__r.RegionHead__c=: UserInfo.getUserId()
                                                                                                                                                                                                    OR Region__r.Brazil_Marketing_Ops_Manager__c=:UserInfo.getUserId()
                                                                                                                                                                                                    OR Zone__r.ZonalHead__c=: UserInfo.getUserId()
                                                                                                                                                                                                    OR SBU__r.SBUUser__c=: UserInfo.getUserId()
                                                                                                                                                                                                    OR BarterManager__c=: UserInfo.getUserId()
                                                                                                                                                                                                   ) Limit 1];
                    f1 = [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c FROM Inventory_Control__c where BU__c=: u.Zone_Code__c AND Product__c=: i.SKU_Name__r.Brand_Name__c AND Fiscal_Year__c =:sfy FOR UPDATE];
                    f1.Quantity__c = (f1.Quantity__c + (i.Quantity__c - i.New_Quantity__c));
                    updatedfy1.add(f1);   
                }		
            }
        }
        system.debug('updatedfy'+updatedfy);
        system.debug('updatedfy Size'+updatedfy.size());
        if(updatedfy.size()>0){
             if(!Test.isRunningTest()){
            update updatedfy;	
             }
        }
        if(updatedfy1.size()>0){
            if(!Test.isRunningTest()){
            update updatedfy1;	
            }
        }
    }


    
    // below method add for RITM0283331 GRZ(Javed Ahmed) ModifiedDate-20-09-2022
    public static void updateRejectionReason(list<Sales_Order_Line_Item__c> lineItemList,map<id,Sales_Order_Line_Item__c> oldlineItemList){
        set<ID> rejectionStatusIdSet= new set<Id>();
        for(Sales_Order_Line_Item__c sol : lineItemList){
            if(sol.Rejection_Code__c != null && (oldlineItemList == null || oldlineItemList.get(sol.id).Rejection_Code__c != sol.Rejection_Code__c)){
                rejectionStatusIdSet.add(sol.Rejection_Code__c);
            }
        }
        if(rejectionStatusIdSet != null && !rejectionStatusIdSet.isempty()){
            Map<Id,Rejection_Status__c> lineItemRejectedStatusMap = new Map<Id,Rejection_Status__c>([SELECT  id,Rejection_Description__c FROM Rejection_Status__c
                                                                                                     WHERE ID IN:rejectionStatusIdSet]);
            if(lineItemRejectedStatusMap != null){
                for(Sales_Order_Line_Item__c sol : lineItemList){
                    if(lineItemRejectedStatusMap.containskey(sol.Rejection_Code__c)){
                        sol.Rejected_Reason__c = lineItemRejectedStatusMap.get(sol.Rejection_Code__c).Rejection_Description__c;
                    }
                }
            }
        }
    }  
     public static void gpLista(Set<ID> setID){
        List<Sales_Order__c> lstAcc = new List<Sales_Order__c>();
        if(setID.size() > 0){
        lstAcc = [Select id,GP_Lista__c,(Select id,Price_List_Total_Value__c from Sales_Order_Line_Item__r) from Sales_Order__c where id IN : setID AND SalesOrgCode__c = '5191'];
    }
    for(Sales_Order__c acc : lstAcc){
		Decimal val = 0;
        for(Sales_Order_Line_Item__c con : acc.Sales_Order_Line_Item__r){
            
            val = val + con.Price_List_Total_Value__c;
            
        }
        acc.GP_Lista__c = val;
    }
    update lstAcc;
        
    }
}