/* Name: OrderRequestController
/Created On: 25 July 2017
/Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
/Description: Lightning Component Apex Controller used for Raising orders by Sales users of 
/Brazil Supporting Classes: Refer ApexLog Class for Exception Handling Method & BrazilAccountShare for fetching Accounts with sharing.
/RITM0148162: Sayan (crmconsultant3) have introduced new order type: REMESSA PARA TESTE which is exactly same as BONIFICAÇÃO but goes through two approval steps, 16th Dec 2021
*/

public without sharing class OrderRequestController {
    public static List<AuditHistory> beforeSort = new List<AuditHistory>();
    public static List<AuditHistory> afterSort = new List<AuditHistory>();
    public static Boolean isKeyAccount = false;
    public static String selectedSellerId = null;
    
    //RITM0355165 - Brazil sales order enhancement to track revenue of cancel order
    @AuraEnabled
    public static List<Sales_Order__c> getLast24MonthsSalesOrders(){
        String loggedInUsers = UserInfo.getUserId();
        List<Sales_Order__c> soList=new List<Sales_Order__c>();
        if(Test.isRunningTest()){
            soList=[SELECT Id,OwnerId, Name,Created_DateTime__c,BrazilSalesOrderStatus__c,SAP_Order_Number__c, Order_Status__c,Type_of_Order__c,Order_Date__c,SalesOrderNumber_Brazil__c, Sold_to_Party__r.Customer_Group__c,Sold_to_Party__r.Name FROM Sales_Order__c 
                    WHERE SalesOrgCode__c = '5191' and Created_DateTime__c =LAST_N_DAYS:0 and OwnerId =: loggedInUsers LIMIT 1];
        }else{
            soList=[SELECT Id,OwnerId, Name,Created_DateTime__c,BrazilSalesOrderStatus__c,SAP_Order_Number__c, Order_Status__c,Type_of_Order__c,Order_Date__c,SalesOrderNumber_Brazil__c, Sold_to_Party__r.Customer_Group__c,Sold_to_Party__r.Name FROM Sales_Order__c 
                    WHERE SalesOrgCode__c = '5191' and Created_DateTime__c =LAST_N_DAYS:730  and OwnerId =: loggedInUsers];// and Sold_to_Party__r.Name =: customerName    
        }
        
        //  System.debug('****************soList*************************************'+soList+'*****************'+loggedInUsers);
        return soList;
    }
    //    //RITM0355165 - Brazil sales order enhancement to track revenue of cancel order
    
    //Method to get Sales District of Brazil (Sales Org Code = 5191)
    @AuraEnabled
    public static List<Region__c> getSalesDistrict() {
        List<Region__c> regionList = [SELECT Id, Name, RegionCode__c, SalesOrg__c, 
                                      Sales_Org_Code__c, Zone__c, RegionHead__c, RegionHeadActive__c ,Brazil_Marketing_Ops_Manager__c
                                      FROM Region__c
                                      WHERE SalesOrg__r.Sales_Org_Code__c ='5191'
                                      ORDER BY createdDate ASC];
        
        //System.debug('regionList: '+regionList);
        
        return regionList;  
    }
    // COGS changes by Sagar
    @AuraEnabled    
    public static decimal cogsValueUpdate(string productid, string customer1){
        decimal cogs = 0.0;
        Account acc = [SELECT Id, Depot_Code__c FROM Account WHERE Id=:customer1 ];
        String depotcode = acc.Depot_Code__c;
        SKU__c skuitem= [select id,SKU_Code__c from SKU__c where id=:productid];
        string skucode=skuitem.SKU_Code__c;
        Material_Plant_Relation__c mtrel = [Select id,Name,Material_Code__c,Depot__c,COGSinfo__c from Material_Plant_Relation__c where Active__c=true and Material_Code__c=: skucode and Depot__c=:depotcode ];
        cogs= mtrel.COGSinfo__c;
        system.debug('cogs***'+cogs);
        return cogs;
    }
    @AuraEnabled
    public static list<Shipping_Location__c> getShippingLoations(string accId){
        list<Shipping_Location__c> shipToPartyList = new list<Shipping_Location__c>();
        shipToPartyList = [SELECT Id,Name,Location_Name__c,Distributor__c,Distributor__r.Name,City__c,
                           State__c,Country__c,Pincode__c,Sales_Org__c FROM Shipping_Location__c WHERE Distributor__c=:accId
                           AND Sales_Org__r.sales_org_code__c ='5191' ];
        if(!shipToPartyList.isEmpty()){ return shipToPartyList;
                                      }else{
                                          return null;
                                      }
    }
    
    //Method to update Signed field on Sales Order
    @AuraEnabled
    public static Sales_Order__c signOrder(Sales_Order__c soObj) {
        
        
        //Savepoint sp = Database.setSavepoint();
        
        try{
            update soObj;   
            
            List<ProcessInstance> instanceList = [SELECT Id FROM ProcessInstance
                                                  WHERE TargetObjectId=:soObj.Id 
                                                  AND Status = 'Pending' LIMIT 1];
            
            if(!instanceList.isEmpty()){ ProcessInstance instance = instanceList[0];
                                        
                                        ProcessInstanceWorkitem workItem = [SELECT Id FROM ProcessInstanceWorkitem
                                                                            WHERE ProcessInstanceId=:instance.Id LIMIT 1];
                                        
                                        Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
                                        pwr.setWorkitemId(workItem.id);
                                        pwr.setAction('Reject');
                                        pwr.setComments('Cancelled: '+soObj.Remarks__c);
                                        Approval.ProcessResult result2 =  Approval.process(pwr);
                                        //System.debug(result2);
                                       }   
            
            if(soObj.Order_Status__c=='Cancelled' || soObj.Order_Status__c=='Cancelado'){ AuditHistory__c ahObj = new AuditHistory__c();
                                                                                         ahObj.SalesOrder__c = soObj.Id;
                                                                                         ahObj.CreatedDateTime__c = System.now();
                                                                                         ahObj.ModifiedDateTime__c = System.now();
                                                                                         ahObj.OrderCancelled__c = true;
                                                                                         ahObj.LastModifiedBy__c = UserInfo.getUserId();
                                                                                         insert ahObj;
                                                                                        }       
        }
        catch(Exception ex){
            //Database.rollback(sp);
            ApexLog.exceptionHandlerBrazil(ex, soObj.Sold_to_Party__c, soObj, '');
            System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage());  
            
            //Add an entry to Transaction Log
            TransactionLogHandler.addTransactionEntry(ex, soObj);
        }        
        
        //soObj = getSalesOrder(soObj.Id);
        return soObj;
    }
    
    //Method to update Barter Discount on Sales Order Line Item, added by Sagar@Wipro fro SO-003
    @AuraEnabled
    public static Sales_Order__c barterDiscountUpdate(Sales_Order__c soObj, String salesOrderItemString, boolean isApprove) {
        
        
        //Savepoint sp = Database.setSavepoint();
        
        try{
            system.debug('soObj'+soObj);
            system.debug('soObj'+soObj.Business_Discount__c);
            system.debug('soObj'+soObj.CurrencyIsoCode);
            Sales_Order__c soObj1 = [select id,Business_Discount__c from Sales_Order__c where id=:soObj.Id];
            soObj1.Business_Discount__c = soObj.Business_Discount__c;
            update soObj1; 
            // update soObj;   
            system.debug('signOrder salesOrderItemString'+salesOrderItemString);
            List<Sales_Order_Line_Item__c> salesOrderItemList = [SELECT ID, Sale_Order__c, SKU_Name__c, Discount__c,SKU_Name__r.SKU_Description__c,
                                                                 UnitValue__c, MinValue__c,Quantity__c, UnitValuewithInterest__c,
                                                                 CurrencyIsoCode, TotalValueWithoutInterest__c,SKU_Name__r.Name, TotalValueWithInterest__c,
                                                                 Discount_Considering_Barter_Discount__c
                                                                 FROM Sales_Order_Line_Item__c WHERE Sale_Order__c=:soObj.id];
            Map<String,SalesOrderItem> newmap = new Map<String,SalesOrderItem>();
            if(salesOrderItemString != null || salesOrderItemString !=''){
                List<SalesOrderItem> salesOrderItemList1 = (List<SalesOrderItem>)JSON.deserialize(salesOrderItemString, List<SalesOrderItem>.class); 
                for(SalesOrderItem sitemmap : salesOrderItemList1) {
                    newmap.put(sitemmap.productId,sitemmap);
                }
                system.debug('signOrder newmap'+newmap);
                if(salesOrderItemList.size()>0){
                    for(Sales_Order_Line_Item__c sitem:salesOrderItemList){
                        if(newmap.containsKey(sitem.SKU_Name__c)){
                            SalesOrderItem oSOItem =newmap.get(sitem.SKU_Name__c);
                            if(oSOItem.unitValue != null){
                                sitem.UnitValue__c = oSOItem.unitValue;
                            }
                            if(oSOItem.DiscountBarter > 0.00){
                                sitem.Discount_Considering_Barter_Discount__c = oSOItem.DiscountBarter;
                            }
                            else{
                                sitem.Discount_Considering_Barter_Discount__c = 0.00;  
                            }
                        }
                    }
                }
                if(salesOrderItemList.size()>0){
                    update salesOrderItemList;
                } 
            }
            
            
            List<ProcessInstance> instanceList = [SELECT Id FROM ProcessInstance
                                                  WHERE TargetObjectId=:soObj.Id 
                                                  AND Status = 'Pending' LIMIT 1];
            
            if(!instanceList.isEmpty() && !isApprove){
                ProcessInstance instance = instanceList[0];
                
                ProcessInstanceWorkitem workItem = [SELECT Id FROM ProcessInstanceWorkitem
                                                    WHERE ProcessInstanceId=:instance.Id LIMIT 1];
                
                Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
                pwr.setWorkitemId(workItem.id);
                pwr.setAction('Reject');
                pwr.setComments('Cancelled: '+soObj.Remarks__c);
                Approval.ProcessResult result2 =  Approval.process(pwr);
                System.debug('TestSagar');
            }
            /*else if(!instanceList.isEmpty() && isApprove){
ProcessInstance instance = instanceList[0];

ProcessInstanceWorkitem workItem = [SELECT Id FROM ProcessInstanceWorkitem
WHERE ProcessInstanceId=:instance.Id LIMIT 1];

Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
pwr.setWorkitemId(workItem.id);
pwr.setAction('Approve');
pwr.setComments('Approved: '+soObj.Remarks__c);
Approval.ProcessResult result2 =  Approval.process(pwr);
System.debug('TestSagar');

}*/
            
            if(soObj.Order_Status__c=='Cancelled' || soObj.Order_Status__c=='Cancelado'){ AuditHistory__c ahObj = new AuditHistory__c();
                                                                                         ahObj.SalesOrder__c = soObj.Id;
                                                                                         ahObj.CreatedDateTime__c = System.now();
                                                                                         ahObj.ModifiedDateTime__c = System.now();
                                                                                         ahObj.OrderCancelled__c = true;
                                                                                         ahObj.LastModifiedBy__c = UserInfo.getUserId();
                                                                                         insert ahObj;
                                                                                        }       
        }
        catch(Exception ex){
            //Database.rollback(sp);
            ApexLog.exceptionHandlerBrazil(ex, soObj.Sold_to_Party__c, soObj, '');
            System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage());  
            
            //Add an entry to Transaction Log
            TransactionLogHandler.addTransactionEntry(ex, soObj);
        }        
        
        //soObj = getSalesOrder(soObj.Id);
        return soObj;
    }
    
    //Method to simulate existing orders and change record type
    @AuraEnabled
    public static OrderWrapper simulateSalesOrder(Sales_Order__c soObj, String salesOrderItemString,boolean IsSimulated) { // add IsSimulated Parameter for RITM0518333 GRZ(Javed Ahmed) 14-03-2023
        
        List<Sales_Org__c> salesOrgList = [SELECT ID FROM Sales_Org__c WHERE NAME = 'Brazil' OR Country_Code__c = 'BR' LIMIT 1];  //Updated by GRZ(Dheeraj Sharma) for RITM0556333 modified 18-05-2023
        
        //Id recordTypeId = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Simulation').getRecordTypeId();        
        Id idforsimulation;
        
        RecordType clientOnlyRecordType = [
            SELECT Id FROM RecordType WHERE DeveloperName = 'Simulation'
        ];
        
        if( clientOnlyRecordType != null ){
            idforsimulation = clientOnlyRecordType.Id;
        }else{
            idforsimulation = '0120K000001HskHQAS';
        }
        //Clone the order without Id
        Sales_Order__c soObj2 = soObj.clone(false, true, false, false);
        soObj2.Parent_Order_Simulated__c = soObj.Id;
        soObj2.RecordTypeId = idforsimulation;
        //System.debug('soObj2.RecordTypeId'+soObj2.RecordTypeId);
        
        OrderWrapper owObj = new OrderWrapper();
        
        try{
            if(!salesOrgList.isEmpty()){
                soObj2.Sales_Org_lk__c = soObj.Sales_Org_lk__c = salesOrgList[0].Id;
                //Sayan Inserted the Sales Org data in Cloned Instance: soObj2 as it is necessary in Simulation: INC0082906, 9th July, 2020
            }
            String ownerId = soObj2.OwnerId;
            //System.debug('ownerId'+ownerId);
            
            if(String.isNotBlank(ownerId) && ownerId == 'None'){
                soObj2.OwnerId = UserInfo.getUserId();
            }
            //soObj2.Currency_Brazil__c = returnENvalue(soObj2.Currency_Brazil__c);
            insert soObj2;
            
            //soObj2 = getSalesOrder(soObj2.Id);
            System.debug('Sales Order Object: '+soObj);
            //System.debug('Serialized Item List: '+salesOrderItemString);
            
            List<SalesOrderItem> salesOrderItemList = (List<SalesOrderItem>)JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class);
            
            // System.debug('salesOrderItemList: '+salesOrderItemList);
            // System.debug('salesOrderItemList Deserialize: '+JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class));
            
            //Sales line items against cloned record
            owObj.soObj = soObj2;
            owObj.soiList = OrderRequestController.saveOrderItems(soObj2, salesOrderItemList, salesOrgList,IsSimulated); // add IsSimulated Parameter for RITM0518333 GRZ(Javed Ahmed) 14-03-2023
        }
        catch(Exception ex){
            ApexLog.exceptionHandlerBrazil(ex, soObj2.Sold_to_Party__c, soObj2, salesOrderItemString);
            System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage());            
        }
        return owObj;
    }
    
    //Get KEDE for Brazil Sales Org(5191) and return Sales Order Line Item (Wrapper with details)
    public static KEDE getKEDE(String loggedInUser) {
        system.debug('getKEDE'+loggedInUser);
        //Added by GRZ(Nikhil Verma) for RITM0422585 modified 09-09-2022
        List<Territory_Distributor__c> tdList =  new List<Territory_Distributor__c>();
        if(!String.isBlank(loggedInUser) && loggedInUser != 'null' && loggedInUser.startsWith('BR')){
            tdList = [SELECT ID, Region__r.RegionHead__c,Region__r.Brazil_Marketing_Ops_Manager__c, BrazilAnalyst__c,
                      Zone__r.ZonalHead__c, SBU__r.SBUUser__c,SBU__r.GSD__c,SBU__r.REH__c,
                      TerritoryManager__c, BarterManager__c
                      FROM Territory_Distributor__c 
                      WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                      AND TerritoryManagerActive__c = True
                      AND TerritoryCode__c  =: loggedInUser
                      ORDER BY LastModifiedDate DESC];
        }else{
            tdList = [SELECT ID, Region__r.RegionHead__c,Region__r.Brazil_Marketing_Ops_Manager__c, BrazilAnalyst__c,
                      Zone__r.ZonalHead__c, SBU__r.SBUUser__c,SBU__r.GSD__c,SBU__r.REH__c,
                      TerritoryManager__c, BarterManager__c
                      FROM Territory_Distributor__c 
                      WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                      AND TerritoryManagerActive__c = True
                      AND (TerritoryManager__c=: loggedInUser 
                           OR Region__r.RegionHead__c=: loggedInUser
                           OR Region__r.Brazil_Marketing_Ops_Manager__c=: loggedInUser
                           OR Zone__r.ZonalHead__c=: loggedInUser
                           OR SBU__r.SBUUser__c=: loggedInUser
                           OR BarterManager__c=: loggedInUser
                          ) 
                      ORDER BY LastModifiedDate DESC];
        }       
        // ----- End Here Added by GRZ(Nikhil Verma) for RITM0422585 modified 09-09-2022
        System.debug('Territory_Distributor List: '+tdList);
        
        KEDE kedeObj = new KEDE();
        
        if(!tdList.isEmpty()){
            String territoryUser = tdList[0].TerritoryManager__c;
            String regionalHeadUser = tdList[0].Region__r.RegionHead__c;
            String regionalBrazilMarketingOpsManager = tdList[0].Region__r.Brazil_Marketing_Ops_Manager__c;
            
            String zonalHeadUser = tdList[0].Zone__r.ZonalHead__c;
            String sbuUser = tdList[0].SBU__r.SBUUser__c;
            String barterManager = tdList[0].BarterManager__c;
            String analystUser = tdList[0].BrazilAnalyst__c;
            String gsdUser = tdList[0].SBU__r.GSD__c;
            String rehUser = tdList[0].SBU__r.REH__c;
            
            Set<Id> userIdSet = new Set<Id>();
            
            if(String.isNotBlank(territoryUser)){
                userIdSet.add(territoryUser);
            }
            
            if(String.isNotBlank(regionalHeadUser)){
                userIdSet.add(regionalHeadUser);
            }
            if(String.isNotBlank(regionalBrazilMarketingOpsManager)){
                userIdSet.add(regionalBrazilMarketingOpsManager);
            }
            
            if(String.isNotBlank(zonalHeadUser)){
                userIdSet.add(zonalHeadUser);
            }
            
            if(String.isNotBlank(sbuUser)){
                userIdSet.add(sbuUser);    
            }
            
            if(String.isNotBlank(barterManager)){ kedeObj.barterManager = barterManager;
                                                }
            
            if(String.isNotBlank(analystUser)){
                kedeObj.brazilAnalyst = analystUser;
            }
            if(String.isNotBlank(gsdUser)){
                kedeObj.GSDManager = gsdUser;
            }
            if(String.isNotBlank(rehUser)){
                kedeObj.REHManager = rehUser;
            }
            
            //Get Business rules for all the users in a Map and assign them to KEDE wrapper with Total Margin & List Price Discount
            Map<Id, Employee_Details__c> businessRulesMap = OrderRequestController.getBusinessRuleMap(userIdSet);
            Map<String, Business_Rule__c> defaultBusinessRulesMap = OrderRequestController.getDefaultBusinessRulesMap();
            
            if(businessRulesMap.containsKey(territoryUser) && String.isNotBlank(territoryUser)){ Employee_Details__c brObj = businessRulesMap.get(territoryUser);
                                                                                                //kedeObj.salesPerson = loggedInUser;                
                                                                                                if(String.isNotBlank(brObj.Associate_Group__c)){
                                                                                                    kedeObj.SP_TotalOrderMargin = brObj.Associate_Group__r.Business_Rule__r.Total_Order_Margin__c;
                                                                                                    kedeObj.SP_ListPriceDiscount = brObj.Associate_Group__r.Business_Rule__r.List_Price_Discount__c;
                                                                                                    kedeObj.tax = brObj.Associate_Group__r.Business_Rule__r.Taxes__c;
                                                                                                    kedeObj.freight = brObj.Associate_Group__r.Business_Rule__r.Freight__c;
                                                                                                }
                                                                                               }
            else if(defaultBusinessRulesMap.containsKey('Sales Person')){
                Business_Rule__c defObj = defaultBusinessRulesMap.get('Sales Person');
                kedeObj.SP_TotalOrderMargin = defObj.Total_Order_Margin__c;
                kedeObj.SP_ListPriceDiscount = defObj.List_Price_Discount__c;
                kedeObj.tax = defObj.Taxes__c;
                kedeObj.freight = defObj.Freight__c;
            }
            
            if(businessRulesMap.containsKey(regionalHeadUser) && String.isNotBlank(regionalHeadUser)){
                Employee_Details__c brObj = businessRulesMap.get(regionalHeadUser);
                if(String.isNotBlank(brObj.Associate_Group__c)){
                    kedeObj.salesDistrictManager = regionalHeadUser;
                    kedeObj.SDM_TotalOrderMargin1 = brObj.Associate_Group__r.Business_Rule__r.Total_Order_Margin__c;
                    kedeObj.SDM_ListPriceDiscount1 = brObj.Associate_Group__r.Business_Rule__r.List_Price_Discount__c;
                }
            }
            else if(defaultBusinessRulesMap.containsKey('Sales District Manager')){
                Business_Rule__c defObj = defaultBusinessRulesMap.get('Sales District Manager');
                kedeObj.salesDistrictManager = regionalHeadUser;
                kedeObj.SDM_TotalOrderMargin1 = defObj.Total_Order_Margin__c;
                kedeObj.SDM_ListPriceDiscount1 = defObj.List_Price_Discount__c;
            }
            if(businessRulesMap.containsKey(regionalBrazilMarketingOpsManager) && String.isNotBlank(regionalBrazilMarketingOpsManager)){
                Employee_Details__c brObj = businessRulesMap.get(regionalBrazilMarketingOpsManager);
                if(String.isNotBlank(brObj.Associate_Group__c)){
                    kedeObj.BrazilMarketingOpsManager = regionalBrazilMarketingOpsManager;
                    kedeObj.SDM_TotalOrderMargin4 = brObj.Associate_Group__r.Business_Rule__r.Total_Order_Margin__c;
                    kedeObj.SDM_ListPriceDiscount4 = brObj.Associate_Group__r.Business_Rule__r.List_Price_Discount__c;
                }
            }
            else if(defaultBusinessRulesMap.containsKey('Brazil Marketing Ops Manager')){
                Business_Rule__c defObj = defaultBusinessRulesMap.get('Brazil Marketing Ops Manager');
                kedeObj.BrazilMarketingOpsManager = regionalBrazilMarketingOpsManager;
                kedeObj.SDM_TotalOrderMargin4 = defObj.Total_Order_Margin__c;
                kedeObj.SDM_ListPriceDiscount4 = defObj.List_Price_Discount__c;
            }
            
            if(businessRulesMap.containsKey(zonalHeadUser) && String.isNotBlank(zonalHeadUser)){
                Employee_Details__c brObj = businessRulesMap.get(zonalHeadUser);
                if(String.isNotBlank(brObj.Associate_Group__c)){
                    kedeObj.salesOfficeManager = zonalHeadUser;
                    kedeObj.SOM_TotalOrderMargin2 = brObj.Associate_Group__r.Business_Rule__r.Total_Order_Margin__c;
                    kedeObj.SOM_ListPriceDiscount2 = brObj.Associate_Group__r.Business_Rule__r.List_Price_Discount__c;
                }
            }
            else if(defaultBusinessRulesMap.containsKey('Sales Office Manager')){
                Business_Rule__c defObj = defaultBusinessRulesMap.get('Sales Office Manager');
                kedeObj.salesOfficeManager = zonalHeadUser;
                kedeObj.SOM_TotalOrderMargin2 = defObj.Total_Order_Margin__c;
                kedeObj.SOM_ListPriceDiscount2 = defObj.List_Price_Discount__c;
            }     
            
            if(businessRulesMap.containsKey(sbuUser) && String.isNotBlank(sbuUser)){
                Employee_Details__c brObj = businessRulesMap.get(sbuUser);
                if(String.isNotBlank(brObj.Associate_Group__c)){
                    kedeObj.salesDirector = sbuUser;
                    kedeObj.SD_TotalOrderMargin3 = brObj.Associate_Group__r.Business_Rule__r.Total_Order_Margin__c;
                    kedeObj.SD_ListPriceDiscount3 = brObj.Associate_Group__r.Business_Rule__r.List_Price_Discount__c;
                }                
            }
            else if(defaultBusinessRulesMap.containsKey('Sales Director')){
                Business_Rule__c defObj = defaultBusinessRulesMap.get('Sales Director');
                kedeObj.salesDirector = sbuUser;
                kedeObj.SD_TotalOrderMargin3 = defObj.Total_Order_Margin__c;
                kedeObj.SD_ListPriceDiscount3 = defObj.List_Price_Discount__c;
            } 
            //added by ganesh Date:29/5/2019
            if(businessRulesMap.containsKey(rehUser) && String.isNotBlank(rehUser)){
                Employee_Details__c brObj = businessRulesMap.get(rehUser);
                if(String.isNotBlank(brObj.Associate_Group__c)){
                    kedeObj.REHManager = rehUser;
                    kedeObj.REH_TotalOrderMargin4 = brObj.Associate_Group__r.Business_Rule__r.Total_Order_Margin__c;
                    kedeObj.REH_ListPriceDiscount4 = brObj.Associate_Group__r.Business_Rule__r.List_Price_Discount__c;
                }                
            }
            else if(defaultBusinessRulesMap.containsKey('REH')){
                Business_Rule__c defObj = defaultBusinessRulesMap.get('REH');
                kedeObj.REHManager = rehUser;
                kedeObj.REH_TotalOrderMargin4 = defObj.Total_Order_Margin__c;
                kedeObj.REH_ListPriceDiscount4 = defObj.List_Price_Discount__c;
            } 
            // End
        }
        return kedeObj;
    }
    
      // Added below method for RITM0508956 GRZ(Dheeraj Sharma) 20-02-2023

    @AuraEnabled
    public static string getRegionCode(){
      
          List<Territory_Distributor__c> regCode=[SELECT id,name ,Regional_Manager__c , Region__r.RegionCode__c, TerritoryManager__r.Name from Territory_Distributor__c where TerritoryManager__c=: Userinfo.getUserId()];
        
        
        return regCode[0].Region__r.RegionCode__c;
    }
 // End method for RITM0508956 GRZ(Dheeraj Sharma) 20-02-2023









    //Method to fetch Default Business Rules
    @AuraEnabled
    public static Map<String, Business_Rule__c> getDefaultBusinessRulesMap() {
        Map<String, Business_Rule__c> businessRulesMap = new Map<String, Business_Rule__c>();
        for(Business_Rule__c brObj: [SELECT Id, Default__c, AppliedFor__c, 
                                     Taxes__c, Freight__c, 
                                     Total_Order_Margin__c, List_Price_Discount__c
                                     FROM Business_Rule__c 
                                     WHERE Default__c = True]){
                                         
                                         businessRulesMap.put(brObj.AppliedFor__c, brObj);                                            
                                     }
        //System.debug('businessRulesMap: '+businessRulesMap);
        
        return businessRulesMap;
    }
    
    //Method to fetch Business Rule of User specified as parameter
    public static Map<Id, Employee_Details__c> getBusinessRuleMap(Set<Id> userIdSet) {
        Map<Id, Employee_Details__c> employeeDetailMap = new Map<Id, Employee_Details__c>();
        for(Employee_Details__c edObj: [SELECT Id, Associate_Group__c, User__c,
                                        Associate_Group__r.Business_Rule__c,
                                        Associate_Group__r.Business_Rule__r.Taxes__c,
                                        Associate_Group__r.Business_Rule__r.Freight__c,
                                        Associate_Group__r.Business_Rule__r.Total_Order_Margin__c,
                                        Associate_Group__r.Business_Rule__r.List_Price_Discount__c
                                        FROM Employee_Details__c 
                                        WHERE User__c IN: userIdSet]){
                                            
                                            employeeDetailMap.put(edObj.User__c, edObj);                                            
                                        }
        //System.debug('employeeDetailMap: '+employeeDetailMap);
        
        return employeeDetailMap;
    }
    
    //Method to fetch Business Rule of Logged In User
    @AuraEnabled
    public static Employee_Details__c getBusinessRule(String soId, String loggedInUser) {
        Employee_Details__c edObj = new Employee_Details__c();
        //Reload business rule for existing Sales Order
        if(String.isBlank(soId)){
            List<Employee_Details__c> employeeDetailList = [SELECT Id, Associate_Group__c,
                                                            Associate_Group__r.Business_Rule__c,
                                                            Associate_Group__r.Business_Rule__r.Taxes__c,
                                                            Associate_Group__r.Business_Rule__r.Freight__c,
                                                            Associate_Group__r.Business_Rule__r.Total_Order_Margin__c,
                                                            Associate_Group__r.Business_Rule__r.List_Price_Discount__c, User__c                                                      
                                                            FROM Employee_Details__c 
                                                            WHERE User__c=: loggedInUser LIMIT 1];
            //System.debug('employeeDetailList: '+employeeDetailList);
            
            if(!employeeDetailList.isEmpty()){ edObj = employeeDetailList[0];
                                             }
        }
        /*else{
//Reload business rule for new Sales Order as per sales order owner
//commented by ganesh
List<Sales_Order__c> soList = [Select Id, OwnerId FROM Sales_Order__c WHERE Id=:soId];
List<Employee_Details__c> employeeDetailList = [SELECT Id, Associate_Group__c,
Associate_Group__r.Business_Rule__c,
Associate_Group__r.Business_Rule__r.Taxes__c,
Associate_Group__r.Business_Rule__r.Freight__c,
Associate_Group__r.Business_Rule__r.Total_Order_Margin__c,
Associate_Group__r.Business_Rule__r.List_Price_Discount__c, User__c                                                      
FROM Employee_Details__c 
WHERE User__c=: soList[0].OwnerId LIMIT 1];
System.debug('employeeDetailList: '+employeeDetailList);

if(!employeeDetailList.isEmpty()){
edObj = employeeDetailList[0];
}
}*/
        return edObj;
    }
    
    /*@AuraEnabled
public static List<String> getHolidays() {
List<Holiday> holidayList = [Select StartTimeInMinutes, Name, ActivityDate 
FROM Holiday 
WHERE ActivityDate = THIS_YEAR];

List<String> datesList = new List<String>();                                                        
for(Holiday holObj:holidayList){
datesList.add(String.valueOf(holObj.ActivityDate));
}

System.debug('datesList: '+datesList);
return datesList;
}*/
    
    //Returns Order Sub Status.
    @AuraEnabled
    public static String getOrderSubStatus(ID soId){
        List<Sales_Order__c> soList = [SELECT Id, toLabel(OrderSubStatus__c)
                                       FROM Sales_Order__c 
                                       WHERE Id =: soId];
        
        return soList[0].OrderSubStatus__c;
    }
    
    //Returns Order createdDate :SCTASK0340391
    @AuraEnabled
    public static DateTime getCreatedDate(ID soId){
        
        List<Sales_Order__c> soList = [SELECT Id, CreatedDate
                                       FROM Sales_Order__c 
                                       WHERE Id =: soId];
        //String inputDate = soList[0].CreatedDate;
        
        //System.debug('inside my function1'+soList[0].CreatedDate);
        return soList[0].CreatedDate;
    }
    
    //Reload existing Sales Order with given recordID
    @AuraEnabled
    public static Sales_Order__c getSalesOrder(ID soId) {
        //Make sure to add new fields that are being input from the UI to this SOQL query otherwise the data will not be inserted.
        // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.......added two fields to query ...Sent_for_CCO__c, Sent_for_Latam_Director_Approval__c, Total_Overall_Margin__c...
        // Change by Swaranjeet(Grazitti) APPS-4591---added five fields to query
        List<Sales_Order__c> soList = [SELECT Id,TotalReplacementCost__c,Total_Punctuality_Without_Interest__c,TotalBarterDiscount__c,Total_Tax_Without_Interest__c,Total_Freight_Without_Interest__c,Kit_Order__c, Name,Ship_To_Party__c,Ship_To_Party__r.Location_Name__c,Use_Campaign__c,Campaign_Type__c,Pronutiva__c,
                                       Directed_Sales__c,Expected_Number_of_days__c,SAP_Order_Number__c, Order_Status__c, SalesOrderNumber_Brazil__c, BarterManager__c, 
                                       Sold_to_Party__r.Program_Margin_Discount__c,Sold_to_Party__r.Tax_Number_Br_Portal_Filter__c ,Maturity_Date__c,Price_Book__c, Sales_Order__c, Sold_to_Party__r.Tax_Number_1__c,
                                       Sold_to_Party__r.Name, Sold_to_Party__c, ReloadPaymentTerms__c, OrderSubStatus__c, BrazilAnalyst__c,TM_Code__c,
                                       Sold_to_Party__r.Tax_Number_3__c, TotalValueWithInterest__c, Inco_Term__c, Inco_Term__r.IncoTerm_Code__c,
                                       Sold_to_Party__r.SAP_Code__c, TotalValueWithoutInterest__c, SalesOrderLedgerMargin__c, BrazilSalesOrderApproved__c,
                                       Sold_to_Party__r.Customer_Group__c, SalesOrderReplacementMargin__c, Punctuality_Discount__c, Tax__c, Freight__c,Tax_D__c,Freight_D__c,
                                       Sold_to_Party__r.BillingCity,CreatedById, OwnerId, Owner.Name, Flag__c, Price_Book__r.Name, CurrencyIsoCode,Cancelled_details_SO__c,
                                       Sold_to_Party__r.BillingState,Sales_District__c,Sales_Office__c,Created_By_Name__c, Type_of_Order__c, Valid_From__c, Signed__c,Business_Discount__c,BudgetApprovalCheck__c,Enable_cancelled_sales_order__c,
                                       Valid_To__c, Purchase_Order_no__c, Purchase_Order_Date__c, avec_order__c, PaymentMethod__c,Financial_Discount__c,
                                       Payment_Term__c, Invoice_Message__c, Internal_OBS__c, Sales_order_OBS__c, BrazilSalesOrderStatus__c,Price_Book__r.Interest_Date__c,
                                       Sales_Order__r.SalesOrderNumber_Brazil__c, Sales_Order__r.SAP_Order_Number__c, Sales_Order__r.Sold_to_Party__r.Name, 
                                       Sales_Order__r.Sold_to_Party__r.Customer_Group__c, Sales_Order__r.Sold_to_Party__r.BillingCity, Sales_Order__r.Price_Book__r.Name,
                                       Sold_to_Party__r.Depot_Code__c, Sales_Order__r.Price_Book__c, Sales_Order__r.CurrencyIsoCode, Sold_to_Party__r.Customer_Region__c,
                                       Sales_Order__r.Sold_to_Party__r.BillingState, Sales_Order__r.Type_of_Order__c, KeyAccountDesOwnerBrazil__c,
                                       Sales_Order__r.Name, Sales_Order__r.ReloadPaymentTerms__c, Sales_Order__r.Maturity_Date__c, Remarks__c,
                                       Sales_Order__r.Sold_to_Party__c, Sales_Order__r.Currency_Brazil__c, Currency_Brazil__c, Key_Account__c,
                                       Parent_Order_Simulated__c,Campaign_Payment_Term_Date__c,Payment_Term__r.Payterms_Desc__c,Campaign_Payment_Term__c, Parent_Order_Simulated__r.SalesOrderNumber_Brazil__c, 
                                       RecordType.Name, SalesOrgCode__c,Total_Group_Discount__c,Sold_to_Party__r.Price_Conversion_Group__c,GM_Hedge__c,GM_Barter__c,GP_Total__c,GM_Net__c,Total_GP_Lista__c,Impacto_GP_vs_LP__c, Sent_for_CCO__c, Sent_for_Latam_Director_Approval__c, Total_Overall_Margin__c,
                                       Invoice_Status__c,Blocked_Cancellation_Message__c,CreatedFrom__c,Sales_Order_Replacement_Margin_WI__c,Gross_Margin_with_Barter1__c,Total_of_Discount_Applied__c
                                       FROM Sales_Order__c 
                                       WHERE Id =: soId];//Modified by Deeksha for kit selling Project
        
        soList[0].CreatedFrom__c = 'SFDC';//Sayan Majumder, INC0077467, Sales order field Value "Created from"- Brazil Org, 10th July'2020
        system.debug('**Reload Pricebook - '+soList[0].Sales_Order__r.Price_Book__c);
        
        return soList[0];
    }
    
    @AuraEnabled
    public static List<StructOrderLineItem> getStructSalesOrderItems(ID soId) {
        // added Recommended_price__c, DDS_Grade__c in query by Sagar for DDS score
        List<Sales_Order_Line_Item__c> salesOrderItemList = [SELECT ID, Sale_Order__c, DateofFAT__c,Campaign_Group__c,Campaign_Subgroup__c, SKU_Name__c, Discount__c, Tax__c, Freight__c,
                                                             SKU_Name__r.SKU_Description__c, Time_in_months__c, Days__c,Cogs_Info__c, Flag__c, MO_Item_No__c,
                                                             UnitValue__c, InterestRate__c, ProductReplacementMargin__c, Net_Price__c,MinValue__c,
                                                             Quantity__c, UnitValuewithInterest__c, Culture__r.Culture_Desc__c,BudgetPrice__c,
                                                             ProductLedgerMargin__c,Product_Category__c, Approval_Flag__c, Culture__c, Item_Number__c,Budget_Value_Margin__c,
                                                             PriceBookDetail__c, CurrencyIsoCode, Sales_Org__c, Sales_Order_Line_Item__c,SKU_Name__r.Brand_Name__c,
                                                             MaterialPlantRelation__c, TotalValueWithoutInterest__c, Sales_Order_Line_Item__r.Item_Number__c,
                                                             ExchangeRate__c, SKU_Name__r.Name, TotalValueWithInterest__c, Recommended_price__c, DDS_Grade__c
                                                             FROM Sales_Order_Line_Item__c
                                                             WHERE Sale_Order__c=:soId Order By CreatedDate];
        
        List<StructOrderLineItem> itemList = new List<StructOrderLineItem>();
        //System.debug('salesOrderItemList'+salesOrderItemList);
        
        for(Sales_Order_Line_Item__c soiObj: salesOrderItemList){  StructOrderLineItem item = new StructOrderLineItem();
                                                                 //item.replacementMargin = soiObj.ProductReplacementMargin__c;
                                                                 // item.ledgerMargin = soiObj.ProductLedgerMargin__c;
                                                                 item.invoiceDate = String.valueOf(soiObj.DateofFAT__c);
                                                                 item.skuId = soiObj.SKU_Name__c;
                                                                 item.skuDesc = soiObj.SKU_Name__r.SKU_Description__c;
                                                                 item.intialPrice = soiObj.UnitValue__c;
                                                                 item.fspPrice = soiObj.BudgetPrice__c; //added by ganesh Date:12/11/2018
                                                                 
                                                                 
                                                                 //item.cost = soiObj.MinValue__c; //added by ganesh Date:16/5/8 
                                                                 item.prdctVol = soiObj.Quantity__c;
                                                                 item.priceWithInterest = soiObj.UnitValuewithInterest__c;
                                                                 //item.timeInMonths = soiObj.Time_in_months__c;
                                                                 item.soItemId = soiObj.Sales_Order_Line_Item__c;
                                                                 if(soiObj.Days__c!=null){
                                                                     item.days = soiObj.Days__c;
                                                                     system.debug('item.days==='+item.days);
                                                                     system.debug('item.days==='+soiObj.Days__c);
                                                                 }
                                                                 item.CogsInfo  = soiObj.Cogs_Info__c;
                                                                 
                                                                 item.Recommendedprice=soiObj.Recommended_price__c;// added by Sagar for DDS score   
                                                                 item.DDSGrade=soiObj.DDS_Grade__c;   // added by Sagar for DDS score                                                    
                                                                 /*if(String.isNotBlank(soiObj.Sales_Order_Line_Item__c)){
item.itemNo = soiObj.Sales_Order_Line_Item__r.Item_Number__c;
}
else{
item.itemNo = soiObj.Item_Number__c;
}*/
                                                                 //system.debug('budgetFlag'+item.budgetFlag);
                                                                 //system.debug('soiObj.Budget_Value_Margin__c'+soiObj.Budget_Value_Margin__c);
                                                                 //added by ganesh Date:12/11/2018
                                                                 /* if(soiObj.Budget_Value_Margin__c  < 0){
Sales_Order__c so =[select id,BudgetApprovalCheck__c from Sales_Order__c where id =:soId limit 1]; 
if(so.BudgetApprovalCheck__c!=true){
so.BudgetApprovalCheck__c=true;
update so;
}
// item.budgetFlag = true;
}else if(soiObj.Budget_Value_Margin__c  > 0){
Sales_Order__c so =[select id,BudgetApprovalCheck__c from Sales_Order__c where id =:soId limit 1]; 
if(so.BudgetApprovalCheck__c!=false){
so.BudgetApprovalCheck__c=false;
update so;
} 
}*/
                                                                 //end
                                                                 //item.moItemNo = soiObj.MO_Item_No__c;
                                                                 item.combinationkey = soiObj.PriceBookDetail__c;
                                                                 //item.interestRate = soiObj.InterestRate__c;
                                                                 item.totalValWithInterest = soiObj.TotalValueWithoutInterest__c; //changes by ganesh Date :11/5/2018
                                                                 item.totalVal = soiObj.TotalValueWithoutInterest__c;
                                                                 //item.flag = soiObj.Flag__c;
                                                                 item.FinalUnitPrice = soiObj.Net_Price__c;
                                                                 // item.discount = soiObj.Discount__c;
                                                                 item.cultureDesc = soiObj.Culture__r.Culture_Desc__c;
                                                                 item.culture = soiObj.Culture__c;
                                                                 
                                                                 itemList.add(item);
                                                                }          
        System.debug('itemList: '+itemList);
        return itemList;
    }
    
    
    
    //CREATED METHOD FOR IMPACT OF BONIFICATION ORDER BY HARSHIT&ANMOL@WIPRO FOR (US SO-016) ---START  
    @AuraEnabled
    public static List<relatedOrder> relatedOrder(ID soId) {
        
        List<relatedOrder> r=new List<relatedOrder>();
        Decimal total=0;
        Decimal total1=0;
        Decimal total2=0;
        Decimal total3=0;
        Decimal total4=0;
        Decimal total5=0;
        Decimal total6=0;
        Decimal total7=0;
        Decimal total8=0;
        Decimal total9=0;
        Decimal total10=0;
        Decimal total11=0;
        
        Sales_Order__c sb = new Sales_Order__c();
        if(soId != null) { 
            sb = [Select Id,Name, Tax__c,Freight__c,Type_of_Order__c,Sales_Order__c,Sales_Order__r.name,(select Tax__c,Freight__c, SKU_Description__c,UnitValue__c,SKU_Name__r.Unit_Cost__c,Quantity__c from Sales_Order_Line_Item__r) FROM Sales_Order__c where id=:soId];
        }
        
        Sales_Order__c lst = new Sales_Order__c();
        if(sb != null && sb.Sales_Order__c != null) {
            lst = [Select Id,Name, Tax__c,Freight__c,Type_of_Order__c,Sales_Order__c,Sales_Order__r.name,(select  Tax__c,Freight__c,SKU_Description__c,UnitValue__c,SKU_Name__r.Unit_Cost__c,Quantity__c from Sales_Order_Line_Item__r) FROM Sales_Order__c where id=:sb.Sales_Order__c];
        }
        String str2 = '%';
        //for(Sales_Order__c ot:sb){
        //for(Sales_Order__c oSD: lst){
        
        
        
        
        
        
        
        
        
        
        
        
        // System.debug(lst.Name);
        /// System.debug(lst.Tax__c);
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        // System.debug(lst.Freight__c);
        
        
        //System.debug(oSD.Sales_Order_Line_Item__r);
        List<Sales_Order_Line_Item__c> orderList = new List<Sales_Order_Line_Item__c>();
        
        List<Sales_Order_Line_Item__c> orderList2 = new List<Sales_Order_Line_Item__c>();
        
        List<Sales_Order_Line_Item__c> orderList3 = new List<Sales_Order_Line_Item__c>();
        
        if(lst != null && lst.Sales_Order_Line_Item__r != null) {
            orderList.addAll(lst.Sales_Order_Line_Item__r);
        }
        orderList2.addAll(sb.Sales_Order_Line_Item__r);
        for(Sales_Order_Line_Item__c sol: orderList){
            
            for(Sales_Order_Line_Item__c sol1: orderList2){
                if(sol.SKU_Description__c==sol1.SKU_Description__c){
                    orderList3.add(sol);
                    
                }
            }
            
        }   
        
        
        
        
        
        
        System.debug('orderList'+orderList);
        System.debug('orderList2'+orderList2);
        
        Integer i=0;
        List<boolean> arr = new list<boolean>();
        
        for(Sales_Order_Line_Item__c sol: orderList){
            arr.add(false);
            for(Sales_Order_Line_Item__c sol1: orderList2){
                if(sol.SKU_Description__c==sol1.SKU_Description__c){
                    arr[i]=true;
                }
            }
            i=i+1;
        }   
        i=0;
        
        for(Sales_Order_Line_Item__c sol: orderList){
            
            
            
            
            relatedOrder ro=new relatedOrder();
            
            
            
            ro.grossSales = sol.UnitValue__c * sol.Quantity__c ;
            total1= total1+ro.grossSales;
            system.debug('grossSales'+ro.grossSales);
            system.debug('UnitValue__c'+sol.UnitValue__c);
            system.debug('Quantity__c'+sol.Quantity__c);
            system.debug('sol.Tax__c'+sol.Tax__c);
            ro.tax = (ro.grossSales*sol.Tax__c)/100;
            total2= total2+ ro.tax ;
            
            ro.freigh = (ro.grossSales*sol.Freight__c)/100;
            total3= total3+ro.freigh;
            if(sol.SKU_Name__r.Unit_Cost__c != null){
                ro.totalvar = sol.SKU_Name__r.Unit_Cost__c * sol.Quantity__c;
            }
            else {
                ro.totalvar = 0;
            }
            
            total4=total4+ ro.totalvar ;
            
            ro.grossmar = ro.grossSales - ro.tax - ro.freigh - ro.totalvar;
            total=total+ro.grossmar;
            
            ro.grosspro =( ro.grossmar/(ro.grossSales - ro.tax - ro.freigh))*100;
            ro.grosspro = ro.grosspro.setScale(0);
            ro.grossproper = String.valueOf(ro.grosspro);
            ro.grossproper = ro.grossproper + '%';
            
            ro.totalgrosspro=total/(total1 - total2 - total3)*100;
            
            ro.totalgrosspro = ro.totalgrosspro.setScale(0);
            ro.totalgrossproper = String.valueOf(ro.totalgrosspro);
            ro.totalgrossproper = ro.totalgrossproper + '%';
            
            System.debug('ro.totalgrosspro'+ro.totalgrosspro);
            
            for(Sales_Order_Line_Item__c sol1: orderList2){
                
                
                
                if(sol.SKU_Description__c==sol1.SKU_Description__c){ 
                    System.debug('  inside if ' );
                    ro.Name=sol.SKU_Description__c;
                    
                    
                    
                    ro.grossSalesBoni = sol1.UnitValue__c * sol1.Quantity__c ;
                    if(sol1.SKU_Name__r.Unit_Cost__c != null) {
                        ro.totalvarCostBoni=sol1.SKU_Name__r.Unit_Cost__c * sol1.Quantity__c;
                    }
                    else {
                        ro.totalvarCostBoni = 0;
                    }
                    
                    ro.taxBoni=(ro.grossSalesBoni*sol1.Tax__c)/100;
                    total5= total5+ ro.taxBoni ;
                    
                    ro.freighBoni = (ro.grossSalesBoni*sol1.Freight__c)/100;
                    total6= total6+ro.freighBoni;
                    
                    
                    ro.totalgrossmarBoni=ro.taxBoni - ro.freighBoni - ro.totalvarCostBoni;
                    system.debug('ro.totalgrossmarBoni'+ro.totalgrossmarBoni);
                    ro.totalgrossmarBoni=ro.totalgrossmarBoni+ro.grossmar  ;
                    
                    total7=total7+ro.totalgrossmarBoni;
                    
                    system.debug('totalgrossmarBoni'+ro.totalgrossmarBoni);
                    System.debug('grossmar'+ro.grossmar);
                    
                    ro.grossproBoni = (ro.totalgrossmarBoni/(ro.grossSales - ro.tax - ro.freigh- ro.taxBoni-ro.freighBoni))*100;
                    System.debug('  ro.grossproBoni '+  ro.grossproBoni );
                    ro.grossproBoni = ro.grossproBoni.setScale(0);
                    ro.grossproBoniper = String.valueOf(ro.grossproBoni);
                    ro.grossproBoniper = ro.grossproBoniper +  '%';
                    
                    ro.totalgrossproBoni=total7/(total1 - total2 - total3 - total5 - total6)*100;
                    
                    ro.totalgrossproBoni = ro.totalgrossproBoni.setScale(0);
                    ro.totalgrossproBoniper = String.valueOf(ro.totalgrossproBoni);
                    ro.totalgrossproBoniper = ro.totalgrossproBoniper + '%';
                    
                    System.debug('  ro.totalgrossproBoni: '+  ro.totalgrossproBoni );
                    
                    
                }
                else if(arr[i]==false){ //
                    System.debug('  inside else ' );
                    ro.grossproBoniper=ro.grossproper;
                    
                    //ro.totalgrossmarBoni = ro.grossmar;
                    
                    //ro.grossmar = ro.grossSales - ro.tax - ro.freigh - ro.totalvar;
                    total7= total7+ro.grossmar;
                    //total11 = total10+ro.grossmar;
                    System.debug('  total11: '+  total11 );
                    System.debug('  total10: '+  total10 );
                    System.debug('  total7: '+  total7 +'   ro.grossmar  '+ro.grossmar);
                    //total10 = total10 + ro.totalgrossmarBoni;
                    
                    ro.totalgrossproBoni = total7/(total1 - total2 - total3)*100;
                    System.debug('  total1: '+  total1 );
                    System.debug('  total2: '+  total2 );
                    System.debug('  total3: '+  total3 );
                    
                    ro.totalgrossproBoni = ro.totalgrossproBoni.setScale(0);
                    ro.totalgrossproBoniper = String.valueOf(ro.totalgrossproBoni);
                    ro.totalgrossproBoniper = ro.totalgrossproBoniper + '%';
                    
                    
                    
                    
                    //ro.totalgrossproBoni=total7/(total1 - total2 - total3 - total5 - total6)*100;
                    
                    
                    
                    
                    
                    /*

ro.totalvarCostBoni=sol1.SKU_Name__r.Unit_Cost__c * sol1.Quantity__c;













ro.taxBoni=(ro.grossSalesBoni*sol1.Tax__c)/100;
total5= total5+ ro.taxBoni ;






































ro.freighBoni = (ro.grossSalesBoni*sol1.Freight__c)/100;
total6= total6+ro.freighBoni;


ro.totalgrossmarBoni=ro.taxBoni - ro.freighBoni - ro.totalvarCostBoni;
system.debug('ro.totalgrossmarBoni'+ro.totalgrossmarBoni);
ro.totalgrossmarBoni=ro.totalgrossmarBoni+ro.grossmar  ;
total11= ro.totalgrossmarBoni;


ro.totalgrossproBoni = total11/(total1 - total2 - total3)*100;
ro.totalgrossproBoni = ro.totalgrossproBoni.setScale(0);
ro.totalgrossproBoniper = String.valueOf(ro.totalgrossproBoni);
ro.totalgrossproBoniper = ro.totalgrossproBoniper + '%';

*/
                    
                }
                
                
            }
            
            
            
            
            
            ro.totalgrossmar=total;
            ro.totalgrossSales=total1;
            ro.totaltax=total2;
            ro.totalfreigh=total3;
            ro.totalvarCost=total4;
            ro.totaltaxBoni=total5;
            ro.totalfreighBoni=total6;
            ro.totalgrossmarBoni1=total7;
            r.add(ro);
            
            
            
            System.debug(sol.SKU_Name__r.Unit_Cost__c);
            System.debug(sol.UnitValue__c);
            System.debug(sol.Quantity__c);
            // System.debug(.totalvarCostBoni);
            
            System.debug('r is'+r);
            
            
            
            
            
            i=i+1;
            
        }
        
        
        
        return r;
        
        
    }
    
    
    
    //CREATED METHOD FOR IMPACT OF BONIFICATION ORDER BY HARSHIT&ANMOL@WIPRO FOR (US SO-016) ---START  
    
    @AuraEnabled
    public static List<relatedOrder1> relatedOrder1(ID soId) {
        
        List<relatedOrder1> r=new List<relatedOrder1>();
        Decimal total=0;
        Decimal total1=0;
        Decimal total2=0;
        Decimal total3=0;
        Decimal total4=0;
        Decimal total5=0;
        Decimal total6=0;
        Decimal total7=0;
        Decimal total8=0;
        Decimal total9=0;
        Decimal total10=0;
        Decimal total11=0;
        
        Sales_Order__c sb = new Sales_Order__c();
        if(soId != null){
            sb = [Select Id,Name, Tax__c,Freight__c,Type_of_Order__c,Sales_Order__c,Sales_Order__r.name,(select Tax__c,Freight__c, SKU_Description__c,UnitValue__c,SKU_Name__r.Unit_Cost__c,Quantity__c from Sales_Order_Line_Item__r) FROM Sales_Order__c where id=:soId];
        }
        Sales_Order__c lst = new Sales_Order__c();
        if(sb.Sales_Order__c != null && sb.Sales_Order__c != null){
            lst = [Select Id,Name, Tax__c,Freight__c,Type_of_Order__c,Sales_Order__c,Sales_Order__r.name,(select  Tax__c,Freight__c,SKU_Description__c,UnitValue__c,SKU_Name__r.Unit_Cost__c,Quantity__c from Sales_Order_Line_Item__r) FROM Sales_Order__c where id=:sb.Sales_Order__c];
        }
        
        String str2 = '%';
        //for(Sales_Order__c ot:sb){
        //for(Sales_Order__c oSD: lst){
        
        
        
        
        
        
        
        
        
        
        
        
        // System.debug(lst.Name);
        // System.debug(lst.Tax__c);
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        // System.debug(lst.Freight__c);
        
        
        //System.debug(oSD.Sales_Order_Line_Item__r);
        List<Sales_Order_Line_Item__c> orderList = new List<Sales_Order_Line_Item__c>();
        
        List<Sales_Order_Line_Item__c> orderList2 = new List<Sales_Order_Line_Item__c>();
        
        List<Sales_Order_Line_Item__c> orderList3 = new List<Sales_Order_Line_Item__c>();
        
        if(lst!=null && lst.Sales_Order_Line_Item__r != null){
            orderList.addAll(lst.Sales_Order_Line_Item__r);
        }
        
        orderList2.addAll(sb.Sales_Order_Line_Item__r);
        for(Sales_Order_Line_Item__c sol: orderList){
            
            for(Sales_Order_Line_Item__c sol1: orderList2){
                if(sol.SKU_Description__c==sol1.SKU_Description__c){
                    orderList3.add(sol);
                    
                }
            }
            
        }   
        
        
        
        
        
        
        System.debug('orderList'+orderList);
        System.debug('orderList2'+orderList2);
        
        Integer i=0;
        List<boolean> arr = new list<boolean>();
        
        for(Sales_Order_Line_Item__c sol: orderList){
            arr.add(false);
            for(Sales_Order_Line_Item__c sol1: orderList2){
                if(sol.SKU_Description__c==sol1.SKU_Description__c){
                    arr[i]=true;
                }
            }
            i=i+1;
        }   
        i=0;
        
        for(Sales_Order_Line_Item__c sol: orderList3){
            
            
            
            
            relatedOrder1 ro=new relatedOrder1();
            
            
            
            ro.grossSales = sol.UnitValue__c * sol.Quantity__c ;
            total1= total1+ro.grossSales;
            
            ro.tax = (ro.grossSales*sol.Tax__c)/100;
            total2= total2+ ro.tax ;
            
            ro.freigh = (ro.grossSales*sol.Freight__c)/100;
            total3= total3+ro.freigh;
            
            if(sol.SKU_Name__r.Unit_Cost__c != null) {                 
                ro.totalvar = sol.SKU_Name__r.Unit_Cost__c * sol.Quantity__c;
            }
            else {
                ro.totalvar = 0;
            }           
            total4=total4+ ro.totalvar ;
            
            ro.grossmar = ro.grossSales - ro.tax - ro.freigh - ro.totalvar;
            total=total+ro.grossmar;
            
            ro.grosspro =( ro.grossmar/(ro.grossSales - ro.tax - ro.freigh))*100;
            ro.grosspro = ro.grosspro.setScale(0);
            ro.grossproper = String.valueOf(ro.grosspro);
            ro.grossproper = ro.grossproper + '%';
            
            ro.totalgrosspro=total/(total1 - total2 - total3)*100;
            
            ro.totalgrosspro = ro.totalgrosspro.setScale(0);
            ro.totalgrossproper = String.valueOf(ro.totalgrosspro);
            ro.totalgrossproper = ro.totalgrossproper + '%';
            
            System.debug('ro.totalgrosspro'+ro.totalgrosspro);
            
            for(Sales_Order_Line_Item__c sol1: orderList2){
                
                
                
                if(sol.SKU_Description__c==sol1.SKU_Description__c){ 
                    System.debug('  inside if ' );
                    ro.Name=sol.SKU_Description__c;
                    
                    
                    
                    ro.grossSalesBoni = sol1.UnitValue__c * sol1.Quantity__c ;
                    
                    if(sol1.SKU_Name__r.Unit_Cost__c != null) {
                        ro.totalvarCostBoni=sol1.SKU_Name__r.Unit_Cost__c * sol1.Quantity__c;
                    }
                    else {
                        ro.totalvarCostBoni = 0;
                    }
                    
                    ro.taxBoni=(ro.grossSalesBoni*sol1.Tax__c)/100;
                    total5= total5+ ro.taxBoni ;
                    
                    ro.freighBoni = (ro.grossSalesBoni*sol1.Freight__c)/100;
                    total6= total6+ro.freighBoni;
                    
                    
                    ro.totalgrossmarBoni=ro.taxBoni - ro.freighBoni - ro.totalvarCostBoni;
                    system.debug('ro.totalgrossmarBoni'+ro.totalgrossmarBoni);
                    ro.totalgrossmarBoni=ro.totalgrossmarBoni+ro.grossmar  ;
                    
                    total7=total7+ro.totalgrossmarBoni;
                    
                    system.debug('totalgrossmarBoni'+ro.totalgrossmarBoni);
                    System.debug('grossmar'+ro.grossmar);
                    
                    ro.grossproBoni = (ro.totalgrossmarBoni/(ro.grossSales - ro.tax - ro.freigh- ro.taxBoni-ro.freighBoni))*100;
                    System.debug('  ro.grossproBoni '+  ro.grossproBoni );
                    ro.grossproBoni = ro.grossproBoni.setScale(0);
                    ro.grossproBoniper = String.valueOf(ro.grossproBoni);
                    ro.grossproBoniper = ro.grossproBoniper +  '%';
                    
                    ro.totalgrossproBoni=total7/(total1 - total2 - total3 - total5 - total6)*100;
                    
                    ro.totalgrossproBoni = ro.totalgrossproBoni.setScale(0);
                    ro.totalgrossproBoniper = String.valueOf(ro.totalgrossproBoni);
                    ro.totalgrossproBoniper = ro.totalgrossproBoniper + '%';
                    
                    System.debug('  ro.totalgrossproBoni: '+  ro.totalgrossproBoni );
                    
                    
                }
                else if(arr[i]==false){ //
                    System.debug('  inside else ' );
                    ro.grossproBoniper=ro.grossproper;
                    
                    //ro.totalgrossmarBoni = ro.grossmar;
                    
                    //ro.grossmar = ro.grossSales - ro.tax - ro.freigh - ro.totalvar;
                    total7= total7+ro.grossmar;
                    //total11 = total10+ro.grossmar;
                    System.debug('  total11: '+  total11 );
                    System.debug('  total10: '+  total10 );
                    System.debug('  total7: '+  total7 +'   ro.grossmar  '+ro.grossmar);
                    //total10 = total10 + ro.totalgrossmarBoni;
                    
                    ro.totalgrossproBoni = total7/(total1 - total2 - total3)*100;
                    System.debug('  total1: '+  total1 );
                    System.debug('  total2: '+  total2 );
                    System.debug('  total3: '+  total3 );
                    
                    ro.totalgrossproBoni = ro.totalgrossproBoni.setScale(0);
                    ro.totalgrossproBoniper = String.valueOf(ro.totalgrossproBoni);
                    ro.totalgrossproBoniper = ro.totalgrossproBoniper + '%';
                    
                    
                    
                    
                    //ro.totalgrossproBoni=total7/(total1 - total2 - total3 - total5 - total6)*100;
                    
                    
                    
                    
                    
                    /*

ro.totalvarCostBoni=sol1.SKU_Name__r.Unit_Cost__c * sol1.Quantity__c;













ro.taxBoni=(ro.grossSalesBoni*sol1.Tax__c)/100;
total5= total5+ ro.taxBoni ;






































ro.freighBoni = (ro.grossSalesBoni*sol1.Freight__c)/100;
total6= total6+ro.freighBoni;


ro.totalgrossmarBoni=ro.taxBoni - ro.freighBoni - ro.totalvarCostBoni;
system.debug('ro.totalgrossmarBoni'+ro.totalgrossmarBoni);
ro.totalgrossmarBoni=ro.totalgrossmarBoni+ro.grossmar  ;
total11= ro.totalgrossmarBoni;


ro.totalgrossproBoni = total11/(total1 - total2 - total3)*100;
ro.totalgrossproBoni = ro.totalgrossproBoni.setScale(0);
ro.totalgrossproBoniper = String.valueOf(ro.totalgrossproBoni);
ro.totalgrossproBoniper = ro.totalgrossproBoniper + '%';

*/
                    
                }
                
                
            }
            
            
            
            
            
            ro.totalgrossmar=total;
            ro.totalgrossSales=total1;
            ro.totaltax=total2;
            ro.totalfreigh=total3;
            ro.totalvarCost=total4;
            ro.totaltaxBoni=total5;
            ro.totalfreighBoni=total6;
            ro.totalgrossmarBoni1=total7;
            r.add(ro);
            
            
            
            System.debug(sol.SKU_Name__r.Unit_Cost__c);
            System.debug(sol.UnitValue__c);
            System.debug(sol.Quantity__c);
            // System.debug(.totalvarCostBoni);
            
            System.debug('r is'+r);
            
            
            
            
            
            i=i+1;
            
        }
        
        
        
        return r;
        
        
    }
    
    
    
    
    
    
    
    
    
    
    //--END
    //CREATED METHOD TO GIVE BONIFICATION RELATED ORDER BY HARSHIT&ANMOL@WIPRO FOR (US SO-012) ---START
    
    @AuraEnabled
    public static List<Sales_Order__c> getrelatedSalesOrder(ID soId) {
        
        list<Sales_Order__c> sb = [Select Id,Name,Type_of_Order__c,Sales_Order__c FROM Sales_Order__c where Sales_Order__c=:soId and Type_of_Order__c = 'BONIFICAÇÃO'];
        
        // SalesOrderItem item = new SalesOrderItem();
        /* if(sb.size()>0){
for(Sales_Order__c s: sb)
{

item.name = String.valueOf(s.Name);
item.typ = String.valueOf(s.Type_of_Order__c);
System.debug(item.name);
System.debug(item.typ);

}
//System.debug(item.name);
//System.debug(item.typ);


}*/
        
        return sb;
        
        
    }
    
    //---END
    
    //CREATED METHOD FOR INVENTORY CONTROL BY HARSHIT&ANMOL@WIPRO FOR (US IU-001) ---START
    
    @AuraEnabled
    public static List<Inventory> getInventory(ID soId) {
        
        list<String> fyearlist = new list<String>();
        list<String> prolist = new list<String>();
        Decimal total=0;
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        Inventory_Parameter1__mdt ip1 = [SELECT id,Sales_Org_BU__c from Inventory_Parameter1__mdt ];
        
        List<Inventory> iv = new List<Inventory>();
        integer y=0;
        
        
        
        
        
        
        
        
        
        if(ip1.Sales_Org_BU__c=='5191'){
            list<Inventory_Control__c> ic =  [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c, Inventory_Active__c ,Inventory_Block_Alert__c FROM Inventory_Control__c where BU__c='5191'];
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            for(Inventory_Control__c i: ic){
                
                String y2 = i.Fiscal_Year__c;
                System.debug('y2= '+y2);
                
                
                
                string y3 = y2.substring(3);
                System.debug('y3= '+y3);
                
                string y4 = y2.substring(0,2);
                
                System.debug('y4= '+y4);
                
                
                
                
                
                
                
                
                
                
                
                string y5 ='20'+y4+'-04-01';
                System.debug('y5= '+y5);
                
                String y6= '20'+y3+'-03-31';
                System.debug('y6= '+y6);
                
                
                Inventory inv = new Inventory();
                
                
                
                inv.year = y5;
                inv.year1 = y6;
                total = i.Quantity__c;
                inv.qty =  i.Quantity__c;
                inv.inventoryactive = i.Inventory_Active__c;
                inv.inventoryblockalert = i.Inventory_Block_Alert__c;
                inv.productname = i.Product__c;
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                inv.totalqty = total;
                
                iv.add(inv);
                
                
            }   
        }
        
        
        
        
        
        else{
            
            
            System.debug( 'UserInfo.getUserId()'+ UserInfo.getUserId()  );
            Territory_Distributor__c u =[SELECT ID, Name, Zone_Code__c FROM Territory_Distributor__c WHERE SalesOrg__r.Sales_Org_Code__c = '5191' AND TerritoryManagerActive__c = True AND (TerritoryManager__c=: UserInfo.getUserId() 
                                                                                                                                                                                            OR Region__r.RegionHead__c=: UserInfo.getUserId()
                                                                                                                                                                                            OR Region__r.Brazil_Marketing_Ops_Manager__c=:UserInfo.getUserId()
                                                                                                                                                                                            
                                                                                                                                                                                            OR Zone__r.ZonalHead__c=: UserInfo.getUserId()
                                                                                                                                                                                            OR SBU__r.SBUUser__c=: UserInfo.getUserId()
                                                                                                                                                                                            OR BarterManager__c=: UserInfo.getUserId()
                                                                                                                                                                                           )];
            list<Inventory_Control__c> ic =  [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c, Inventory_Active__c ,Inventory_Block_Alert__c FROM Inventory_Control__c where BU__c =: u.Zone_Code__c];
            















            for(Inventory_Control__c i: ic){
                System.debug('i.Product__c'+i.Product__c);
                
                
                
                
                
                
                
                
                
                String y2 = i.Fiscal_Year__c;
                System.debug('y2= '+y2);
                
                string y3 = y2.substring(3);
                System.debug('y3= '+y3);
                
                
                
                
                
                
                
                
                
                
                
                
                string y4 = y2.substring(0,2);
                
                System.debug('y4= '+y4);
                
                
                
                
                
                string y5 ='20'+y4+'-04-01';
                System.debug('y5= '+y5);
                
                String y6= '20'+y3+'-03-31';
                System.debug('y6= '+y6);
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                Inventory inv = new Inventory();
                inv.year = y5;
                inv.year1 = y6;
                total =  i.Quantity__c;
                inv.inventoryactive = i.Inventory_Active__c;
                inv.qty =  i.Quantity__c;
                inv.inventoryblockalert = i.Inventory_Block_Alert__c;
                inv.productname = i.Product__c;
                
                inv.totalqty = total;
                iv.add(inv);
                
                
            }
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        return iv;  
        
        
    }
    
    
    //----END
    
    
    
    
    //Reload existing Sales Order Line Items with given Sales Order ID    
    @AuraEnabled
    public static List<SalesOrderItem> getSalesOrderItems(ID soId) {
        string regCode;
        List<Territory_Distributor__c> tdList = [SELECT ID, Name, TerritoryCode__c, Region__c,Region__r.RegionCode__c,Region__r.Brazil_Marketing_Ops_Manager__c
                                                 FROM Territory_Distributor__c 
                                                 WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                                                 AND (TerritoryManager__c=: UserInfo.getUserId() 
                                                      OR Region__r.RegionHead__c=: UserInfo.getUserId()
                                                      OR Zone__r.ZonalHead__c=: UserInfo.getUserId()
                                                      OR Region__r.Brazil_Marketing_Ops_Manager__c=:UserInfo.getUserId()
                                                      
                                                      OR SBU__r.SBUUser__c=: UserInfo.getUserId()
                                                      OR BarterManager__c=: UserInfo.getUserId()
                                                     ) limit 1]; 
        
        //system.debug('**Territory List --> ' +tdList);
        if(tdList.size()>0){
            regCode = tdList[0].Region__r.RegionCode__c;
            system.debug('**regionCode --> ' +regCode);
        }
        
        
        Map<Id,date> dateMap = new Map<Id,date>();
        list<Brazil_Region_SKU_Combination__c> comboList = new list<Brazil_Region_SKU_Combination__c>();
        if(regCode!=null){
            comboList = [SELECT Id, SKU__c, Sales_District__c, Availability__c,Date__c FROM Brazil_Region_SKU_Combination__c where Sales_District__r.RegionCode__c =:regCode] ;
            
            system.debug('**List Brazil_Region_SKU_Combination --> ' +comboList);
        }
        
        
        
        
        
        
        
        if(comboList.size()>0){
            for( Brazil_Region_SKU_Combination__c temp: comboList){
                if(temp.Date__c !=null){
                    dateMap.put(temp.SKU__c, temp.Date__c); 
                }
            }
        }
        
        system.debug('**Map Min Date --> ' +dateMap);
        // added Recommended_price__c, DDS_Grade__c in query by Sagar for DDS score
        // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.......added 22 newly created fields for this CR.
        //  Change by Swaranjeet(Grazitti) APPS-4591----Added 3 fields in query 
        List<Sales_Order_Line_Item__c> salesOrderItemList = [SELECT ID,Customer_Conversion_Factor__c,SelloutPrice__c,round__c,Sale_Order__r.Price_Book__r.CreatedDate,Sale_Order__r.Kit_Order__c,Item_Category__c,Kit_Item_Number__c,Kit_Product__c,Kit_SKU__c,Kit_SKU__r.SKU_Description__c,Kit_SKU__r.Name, Sale_Order__c, DateofFAT__c, SKU_Name__c, Discount__c, Tax__c, Freight__c,
                                                             SKU_Name__r.SKU_Description__c,SKU_Name__r.Product_Name__c, Time_in_months__c, Days__c, Flag__c,New_Date_of_FAT__c,New_Quantity__c, MO_Item_No__c,Cogs_Info__c, Recommended_price__c, DDS_Grade__c,
                                                             UnitValue__c,Product_Category__c, InterestRate__c, ProductReplacementMargin__c,GP_Total__c,GP_Lista__c,gplistaunitvalue__c,Impacto_GP_vs_LP__c, Net_Price__c,MinValue__c,
                                                             Quantity__c, UnitValuewithInterest__c, Culture__r.Culture_Desc__c,BudgetPrice__c, Product_Replacement_Margin_Unit_Price__c,
                                                             ProductLedgerMargin__c, Approval_Flag__c, Culture__c, Item_Number__c,Budget_Value_Margin__c,
                                                             PriceBookDetail__c, CurrencyIsoCode, Sales_Org__c, Sales_Order_Line_Item__c,
                                                             MaterialPlantRelation__c, TotalValueWithoutInterest__c, Sales_Order_Line_Item__r.Item_Number__c,
                                                             ExchangeRate__c, SKU_Name__r.Name, TotalValueWithInterest__c,multipleOf__c,CreatedDate,
                                                             PriceBookDetail__r.Price_book__r.Currency__c,MaterialPlantRelation__r.Replacement_Cost__c,ExchangeRate__r.ExchangeRate__c,
                                                             PriceBookDetail__r.Unit_Price__c, PriceBookDetail__r.Unit_Price_R__c, PriceBookDetail__r.Unit_Price_U__c,
                                                             PriceBookDetail__r.CreatedDate, SKU_Name__r.Brand_Name__c, PriceBookDetail__r.Minimum_Price_R__c,PriceBookDetail__r.Price_Book__r.Apply_Minimum_Price__c,
                                                             PriceBookDetail__r.Minimum_Price_U__c, PriceBookDetail__r.Price_Book__r.Interest_Date__c,Product_PO_item_number__c,Unit_Price_R__c,Tax_Amount_Without_Interest__c,Freight_Amount_Without_Interest__c,TotalTax__c,TotalFreight__c,TotalPunctuality__c,
                                                             Punctuality_Discount_WI_Calculated__c,Sale_Order__r.Punctuality_Discount__c,TotalReplacementCost__c,Discount_Considering_Barter_Discount__c,SalesPerson__c,Item_Status__c, //Divya INCTASK0186953
                                                             Sales_Deduction_Budget__c, Discount1__c, E2E_Cost__c, Blanket_SKU_End_Date__c, Blanket_SKU_Start_Date__c, Blanket_SKU_Status__c, Level_1_max__c, Level_1_min__c, 
                                                             Level_2_max__c, Level_2_min__c, Level_3_below__c, Approval_Level__c, UOM__c, Base_UOM__c, Converted_Qty__c, Sales_Deduction_Cal__c, Discount_Cal__c, 
                                                             E2E_Cost_Cal__c, Margin_Block_Level_1__c, Margin_Block_Level_2__c, Contribution_Margin__c, Converted_Net_Price__c,Barter_Discount_Percentage__c,BarterDiscountCalculated1__c,Gross_Margin_with_Barter1__c,Cancellation_Reason__c //Added cancellation reason Bhavika
                                                             FROM Sales_Order_Line_Item__c
                                                             WHERE Sale_Order__c=:soId Order By CreatedDate];//Modified by Deeksha for kit selling Project
        // below 27 lines added by Anmol@wipro for US SOS-002
        Map<String,Decimal> FYMap = new Map<String,Decimal>();
        
        list<String> skulist = new list<String>();
        list<String> fyearlist = new list<String>();
        for(Sales_Order_Line_Item__c soiObj: salesOrderItemList){
            String sku = soiobj.SKU_Name__r.Name;
            String year = String.valueOf(soiobj.CreatedDate.year());
            skulist.add(sku);
            fyearlist.add(year);
            
        }
        System.debug('sku list-'+skulist);
        System.debug('fyearlist-'+fyearlist);
        
        list<Account_Target__c> fy = [SELECT Id, Quantity__c ,Price__c,Product__c,Product__r.Name,Year__c,RecordType.Name FROM Account_Target__c where Product__r.Name IN :skulist and Year__c IN :fyearlist and RecordType.Name='Yearly'];
        System.debug('fy list-'+fy);
        
        // list<Sales_Order__c> sb = [Select Id,Name,Type_of_Order__c,Sales_Order__c FROM Sales_Order__c where Sales_Order__c=:soId and Type_of_Order__c = 'BONIFICAÇÃO'];
        
        
        if(fy.size()>0){
            for( Account_Target__c temp: fy){
                if(temp.id !=null){
                    FYMap.put(temp.Product__r.Name, temp.Price__c); 
                }
            }
        }
        
        
        
        
        
        List<SalesOrderItem> itemList = new List<SalesOrderItem>();
        // System.debug('salesOrderItemList'+salesOrderItemList);
        Map<Decimal,List<Decimal>> kitValuesMap = new  Map<Decimal,List<Decimal>>();//Modified by Deeksha for kit selling Project
        for(Sales_Order_Line_Item__c soiObj: salesOrderItemList){
            SalesOrderItem item = new SalesOrderItem();
            
            if( dateMap.containskey(soiObj.SKU_Name__c)){
                system.debug('**Inside Date Map **');
                item.minDate = String.valueOf(dateMap.get(soiObj.SKU_Name__c));
                system.debug('**Date Min --> ' +item.minDate );
            }
            // below 4 lines added by Anmol@wipro for US SOS-002
            if( FYMap.containskey(soiObj.SKU_Name__r.Name)){
                item.quantity = Integer.valueOf(FYMap.get(soiObj.SKU_Name__r.Name));
                //system.debug('**Date Min --> ' +item.minDate );
            }
            
            
            
            item.applyMinPrice = soiObj.PriceBookDetail__r.Price_Book__r.Apply_Minimum_Price__c;  // Priya RITM0237685
            
            //Modified by Deeksha for kit selling Project
            item.kitProduct = soiObj.Kit_Product__c;
            if(soiObj.Kit_Product__c){
                item.kitNo = soiObj.Item_Number__c;
            }
            item.refKitNo = soiObj.Kit_Item_Number__c;
            //item. = soiObj.Customer_Conversion_Factor__c;// Added by VT for Conversion
            item.productId = soiObj.SKU_Name__c;
            item.productName = soiObj.SKU_Name__r.SKU_Description__c;
            item.brand = soiObj.SKU_Name__r.Brand_Name__c; 
            item.kitSKU = soiObj.Kit_SKU__c;
            item.create_Date = String.valueOf(soiObj.Sale_Order__r.Price_Book__r.CreatedDate); 
            item.currency_Code = soiObj.CurrencyIsoCode;
            item.itemCategory = soiObj.Item_Category__c;
            item.selloutprice=soiObj.SelloutPrice__c; //Added by Krishanu@Wipro 
            //End
            //Added by Sirisha start
            
            item.replacementMargin = soiObj.ProductReplacementMargin__c;
            if(!Test.isRunningTest()){
                item.gptotal = soiObj.GP_Total__c;
            }
            item.gplista = soiObj.GP_Lista__c;
            item.gplistaunitvalue =soiObj.gplistaunitvalue__c; 
            item.impactgpvslp = soiObj.Impacto_GP_vs_LP__c;
            if(soiObj.PriceBookDetail__r.Price_book__r.Currency__c == 'Only BRL'){
                item.unitpriceofpricelist =soiObj.PriceBookDetail__r.Unit_Price_R__c;    
            }
            else{
                item.unitpriceofpricelist =soiObj.PriceBookDetail__r.Unit_Price_U__c;  
            }
            
            //item.unitpriceofpricelist =soiObj.PriceBookDetail__r.Unit_Price_R__c;
            item.replacementMarginUP = soiObj.Product_Replacement_Margin_Unit_Price__c; //Divya: 13-07-2020: Added for SCTASK0216506
            item.ledgerMargin = soiObj.ProductLedgerMargin__c;
            item.cancellationReason = soiObj.Cancellation_Reason__c;//added by tanuj >> Cancellation Reason >> 6 Feb 2023
            item.fatDate = String.valueOf(soiObj.DateofFAT__c);
            item.fatDateNew = String.valueOf(soiObj.New_Date_of_FAT__c);
            item.unitValue = soiObj.UnitValue__c;
            item.budgetValue = soiObj.BudgetPrice__c; //added by ganesh Date:12/11/2018
            //item.minValue = soiObj.MinValue__c; //added by ganesh Date:16/5/8
            item.qty = soiObj.Quantity__c;
            item.qtyNew = soiObj.New_Quantity__c;
            system.debug('@@@@@soiObj.New_Quantity__c'+soiObj.New_Quantity__c);
            if(soiObj.New_Quantity__c==0 || soiObj.New_Quantity__c==null){
                item.qtyNew=soiObj.Quantity__c;
            }
              system.debug('@@@@@soiObj.item.qtyNe'+item.qtyNew);
            item.skuCategory = soiObj.Product_Category__c;
            item.unitValueWithInterest = soiObj.UnitValuewithInterest__c;
            //item.impactgpvslp=(item.gptotal-(item.gplista));
            //Added by Sagar
            item.aderencia=item.unitValueWithInterest/item.unitpriceofpricelist;
            system.debug('PresentValue'+item.unitValueWithInterest);
            system.debug('unitpriceofpricelist1'+item.unitpriceofpricelist);
            //unitValue
            decimal totalValWithoutinsterestUP = soiObj.Quantity__c * item.unitpriceofpricelist;
            decimal taxUP=(soiObj.Tax__c /100) * totalValWithoutinsterestUP;
            decimal freightUP=(soiObj.Freight__c/100) * totalValWithoutinsterestUP;
            decimal punctualityUP = 0;
            if(soiObj.Sale_Order__r.Punctuality_Discount__c != null){
                punctualityUP=(soiObj.Sale_Order__r.Punctuality_Discount__c/100) * totalValWithoutinsterestUP;
            }
            decimal denominator = (totalValWithoutinsterestUP - taxUP - punctualityUP);
            system.debug('totalValWithoutinsterestUP'+totalValWithoutinsterestUP);
            system.debug('taxUP'+taxUP);
            system.debug('freightUP'+freightUP);
            system.debug('punctualityUP'+punctualityUP);
            system.debug('TotalReplacementCost__c'+soiObj.TotalReplacementCost__c);
            decimal TotalReplacementCost = 0;
            if(soiObj.TotalReplacementCost__c != null){
                TotalReplacementCost = soiObj.TotalReplacementCost__c;
            }
            if(denominator != 0.00){
                item.MargemLista = ((totalValWithoutinsterestUP - taxUP - freightUP - punctualityUP-TotalReplacementCost)/(totalValWithoutinsterestUP - taxUP - punctualityUP ))*100 ;
                system.debug('item.MargemLista'+item.MargemLista);
            }
            else{
                item.MargemLista = 0.00; 
            }
            // item.MargemLista = ((soiObj.Quantity__c * item.unitpriceofpricelist)-(soiObj.Tax__c * item.unitpriceofpricelist) - (soiObj.Freight__c * item.unitpriceofpricelist)-(soiObj.Sale_Order__r.Punctuality_Discount__c * item.unitpriceofpricelist)-soiObj.TotalReplacementCost__c ) / (soiObj.Quantity__c * item.unitpriceofpricelist);
            // item.MargemLista =((  (soiObj.Quantity__c * item.unitpriceofpricelist)  - (soiObj.Tax__c * soiObj.Quantity__c * item.unitpriceofpricelist) - (soiObj.Freight__c * item.unitpriceofpricelist * soiObj.Quantity__c ) - (soiObj.Sale_Order__r.Punctuality_Discount__c * item.unitpriceofpricelist * soiObj.Quantity__c) - soiObj.TotalReplacementCost__c )/ ((soiObj.Quantity__c * item.unitpriceofpricelist) - (soiObj.Tax__c * soiObj.Quantity__c * item.unitpriceofpricelist) - (soiObj.Sale_Order__r.Punctuality_Discount__c * item.unitpriceofpricelist * soiObj.Quantity__c) ));
            item.totaltax = soiObj.TotalTax__c;
            item.totalfreight = soiObj.TotalFreight__c;
            item.totalpunctuality = soiObj.TotalPunctuality__c;
            
            item.totalValueWithInterest = soiObj.TotalValueWithoutInterest__c; //changes by ganesh Date :11/5/2018
            item.taxAmountWithoutInterest = soiObj.Tax_Amount_Without_Interest__c;
            item.freightAmountWithoutInterest = soiObj.Freight_Amount_Without_Interest__c;
            item.punctualityDiscountWICalculated = soiObj.Punctuality_Discount_WI_Calculated__c;
            item.totalReplacementCost1 = soiObj.TotalReplacementCost__c;
            item.timeInMonths = soiObj.Time_in_months__c;
            item.orderItemId = soiObj.Sales_Order_Line_Item__c;
            if(soiObj.Days__c!=null){
                item.days = soiObj.Days__c;
                system.debug('item.days=='+item.days);
                system.debug('item.days=='+soiObj.Days__c);
            }
            item.CogsInfo= soiObj.Cogs_Info__c;
            
            
            
            // added by Sagar for DDS score 
            item.DiscountBarter=soiObj.Discount_Considering_Barter_Discount__c;
            item.BarterDiscountPercentage=soiObj.Barter_Discount_Percentage__c;// Change by Swaranjeet(Grazitti) APPS-4591 
            if(soiObj.Barter_Discount_Percentage__c != null){
                item.bartercheckpoint=true;
            }
            else{
                item.bartercheckpoint=false;
            }
            
            if(soiObj.Gross_Margin_with_Barter1__c != null){
            	item.GrossMarginwithBarter=soiObj.Gross_Margin_with_Barter1__c;//Change by Swaranjeet(Grazitti) APPS-4591 
            }else{
                item.GrossMarginwithBarter = 0;
            }
            item.BarterDiscountCalculated=soiObj.BarterDiscountCalculated1__c;//Change by Swaranjeet(Grazitti) APPS-4591
            
            item.Ids=soiObj.ID;
            item.salesperson=soiObj.SalesPerson__c;
            
            item.ItemStatus = soiObj.Item_Status__c;
            item.CustomerConversionFactor = soiObj.Customer_Conversion_Factor__c; //Added by Sagar for calculating Barter Discount
            item.Recommendedprice=soiObj.Recommended_price__c;      
            item.DDSGrade=soiObj.DDS_Grade__c;
            
            // added by Sagar for DDS score 
            if(item.DDSGrade == 'Very Good Quality'){
                item.DDSGrade='Muito Bom';
            }
            else if(item.DDSGrade == 'Good Quality'){
                item.DDSGrade='Ok';
            }
            else if(item.DDSGrade == 'Low Quality'){
                item.DDSGrade='Ruim';
            }
            else if(item.DDSGrade == 'Very Low Quality'){
                item.DDSGrade='Muito Ruim';
            }
            else if(item.DDSGrade == 'No Grade as deal_price<min_price'){
                item.DDSGrade='No Grade as deal price min price';
            }
            item.interest_Date = String.valueOf(soiObj.PriceBookDetail__r.Price_Book__r.Interest_Date__c);//Divya INCTASK0186953
            if(String.isNotBlank(soiObj.Sales_Order_Line_Item__c)){ item.itemNo = soiObj.Sales_Order_Line_Item__r.Item_Number__c;
                                                                  }
            else{
                item.itemNo = soiObj.Item_Number__c;
            }
            system.debug('budgetFlag'+item.budgetFlag);
            system.debug('soiObj.Budget_Value_Margin__c'+soiObj.Budget_Value_Margin__c);
            //added by ganesh Date:12/11/2018
            if(soiObj.Budget_Value_Margin__c  < 0){ Sales_Order__c so =[select id,BudgetApprovalCheck__c from Sales_Order__c where id =:soId limit 1]; 
                                                   if(so.BudgetApprovalCheck__c!=true){
                                                       so.BudgetApprovalCheck__c=true;
                                                       update so;
                                                   }
                                                   // item.budgetFlag = true;
                                                  }
            // else block commented by Nik on 12/11/2019 as discussed with Sandip sir and Ganesh....
            /* else if(soiObj.Budget_Value_Margin__c  > 0){
Sales_Order__c so =[select id,BudgetApprovalCheck__c from Sales_Order__c where id =:soId limit 1]; 
if(so.BudgetApprovalCheck__c!=false){
so.BudgetApprovalCheck__c=false;
update so;
} 
}*/
            //end
            item.cancellationReason = soiObj.Cancellation_Reason__c;//Added by Bhavika 7 Feb 2023
            item.moItemNo = soiObj.MO_Item_No__c;
            item.priceBookDetailId = soiObj.PriceBookDetail__c;
            item.interestRate = soiObj.InterestRate__c;
            item.flag = soiObj.Flag__c;
            item.listValue = soiObj.Net_Price__c;
            item.discount = soiObj.Discount__c;
            item.cultureDesc = soiObj.Culture__r.Culture_Desc__c;
            item.culture=soiObj.Culture__c;            
            
            item.POItemNumber = soiObj.Product_PO_item_number__c;//Deeksha SCTASK0216504
            item.multipleOf = soiObj.multipleOf__c;  // added by Nik on 10/05/2019......
            //Modified by Deeksha for kit selling Project
            item.round = soiObj.round__c;  
            if(!soiObj.Kit_Product__c){
                item.create_Date = String.valueOf(soiObj.PriceBookDetail__r.CreatedDate);   // CR92....Nik...22/07/2019......
                item.materialPlnRplc_Cost = soiObj.MaterialPlantRelation__r.Replacement_Cost__c;   // CR92....Nik...22/07/2019......
                item.exchange_Rate = soiObj.ExchangeRate__r.ExchangeRate__c;                       // CR92....Nik...22/07/2019......
                item.currency_Code = soiObj.PriceBookDetail__r.Price_book__r.Currency__c;          // CR92....Nik...22/07/2019......
                //item.unitValue = soiObj.PriceBookDetail__r.Unit_Price__c;                       // CR92....Nik...22/07/2019......
                item.unitValueBRL = soiObj.PriceBookDetail__r.Unit_Price_R__c;                       // CR92....Nik...22/07/2019......
                //item.unitValueBRL = soiObj.Unit_Price_R__c;
                item.unitValueUSD = soiObj.PriceBookDetail__r.Unit_Price_U__c;                       // CR92....Nik...22/07/2019......
                item.minValueBRL = soiObj.PriceBookDetail__r.Minimum_Price_R__c;                   // CR92 changes....Nik...27/07/2019......
                item.minValueUSD = soiObj.PriceBookDetail__r.Minimum_Price_U__c;                   // CR92 changes....Nik...27/07/2019......
                //item.totalValue = soiObj.TotalValueWithoutInterest__c;
                
                if(item.currency_Code == 'Only BRL'){ item.minValue = soiObj.PriceBookDetail__r.Minimum_Price_R__c;
                                                    }
                else{
                    item.minValue = soiObj.PriceBookDetail__r.Minimum_Price_U__c;
                }
            }
            if(soiObj.Sale_Order__r.Kit_Order__c){
                List<Decimal> valuesList = new List<Decimal>();
                if(soiObj.Kit_Product__c){
                    if(item.currency_Code == 'BRL'){ item.currency_Code = 'Only BRL';
                                                   }
                    else{
                        item.currency_Code = 'Only USD';
                    }
                    if(kitValuesMap.containsKey(item.kitNo)){  kitValuesMap.get(item.kitNo).set(0,item.qty);
                                                            }
                    else{
                        valuesList.add(item.qty);
                        valuesList.add(item.unitValueBRL);
                        valuesList.add(item.unitValueUSD);
                        valuesList.add(item.minValueBRL);
                        valuesList.add(item.minValueUSD);
                        valuesList.add(item.minValue);
                        //valuesList.add(item.totalValue);
                    }
                }
                else{
                    if(kitValuesMap.containsKey(soiObj.Kit_Item_Number__c)){
                        valuesList = kitValuesMap.get(soiObj.Kit_Item_Number__c);
                        if(valuesList[1]!=null){valuesList[1] += item.unitValueBRL*item.qty;}else{valuesList[1] = item.unitValueBRL*item.qty;}
                        if(valuesList[2]!=null){valuesList[2] += item.unitValueUSD*item.qty;}else{valuesList[2] = item.unitValueUSD*item.qty;}
                        if(valuesList[3]!=null){valuesList[3] += item.minValueBRL*item.qty;}else{valuesList[3] =item.minValueBRL*item.qty;}
                        if(valuesList[4]!=null){valuesList[4] += item.minValueUSD*item.qty;}else{valuesList[4] = item.minValueUSD*item.qty;}
                        if(valuesList[5]!=null){valuesList[5] += item.minValue*item.qty;}else{valuesList[5] = item.minValue*item.qty;}
                        //if(valuesList[6]!=null){valuesList[6] += item.totalValue;}else{valuesList[6] = item.totalValue;}
                        
                    }
                    else{
                        valuesList.add(1);
                        valuesList.add(item.unitValueBRL);
                        valuesList.add(item.unitValueUSD);
                        valuesList.add(item.minValueBRL);
                        valuesList.add(item.minValueUSD);
                        valuesList.add(item.minValue);
                        //valuesList.add(item.totalValue);                        
                    }
                }
                kitValuesMap.put(item.kitNo,valuesList);
                System.debug('@@@kitValuesMap '+kitValuesMap);
            }
            
            /* ******************************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start ************************************************* */
            item.salesDeductionCost = soiObj.Sales_Deduction_Budget__c;
            item.cogsCost = soiObj.Discount1__c;
            item.e2eCost = soiObj.E2E_Cost__c;
            
            if(soiObj.Blanket_SKU_End_Date__c != null){
                item.blnkt_EndDate = String.valueOf(soiObj.Blanket_SKU_End_Date__c);
            }
            if(soiObj.Blanket_SKU_Start_Date__c != null){
                item.blnkt_StartDate = String.valueOf(soiObj.Blanket_SKU_Start_Date__c);
            }
            
            item.blnkt_Status = soiObj.Blanket_SKU_Status__c;
            item.isBlanket = soiObj.Blanket_SKU_Status__c;
            item.level1Max = soiObj.Level_1_max__c;
            item.level1Min = soiObj.Level_1_min__c;
            item.level2Max = soiObj.Level_2_max__c;
            item.level2Min = soiObj.Level_2_min__c;
            item.level3Below = soiObj.Level_3_below__c;
            item.approvalLevel = soiObj.Approval_Level__c;
            item.uom = soiObj.UOM__c;
            item.baseUOM = soiObj.Base_UOM__c;
            item.convertedQnty = soiObj.Converted_Qty__c;
            item.convertedNetPrice = soiObj.Converted_Net_Price__c;
            item.salesDeductionCal = soiObj.Sales_Deduction_Cal__c;
            item.cogsCostCal = soiObj.Discount_Cal__c;
            item.e2eCostCal = soiObj.E2E_Cost_Cal__c;
            item.mbLevel1 = soiObj.Margin_Block_Level_1__c;
            item.mbLevel2 = soiObj.Margin_Block_Level_2__c;
            item.contMargin = soiObj.Contribution_Margin__c;
            item.exchngRate = soiObj.ExchangeRate__r.ExchangeRate__c;
            item.curncyCode = soiObj.CurrencyIsoCode;
            /* ******************************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End ************************************************* */
            
            
            
            itemList.add(item);
        } 
        if(!kitValuesMap.isEmpty()){
            for(SalesOrderItem item : itemList){
                if(item.kitProduct){
                    if(kitValuesMap.containsKey(item.kitNo)){
                        item.unitValueBRL = (kitValuesMap.get(item.kitNo))[1];                   
                        item.unitValueUSD = (kitValuesMap.get(item.kitNo))[2];
                        item.minValueBRL = (kitValuesMap.get(item.kitNo))[3];
                        item.minValueUSD = (kitValuesMap.get(item.kitNo))[4];
                        item.minValue = (kitValuesMap.get(item.kitNo))[5];  
                        //item.totalValueWithInterest = (kitValuesMap.get(item.kitNo))[6]; 
                        if(item.currency_Code == 'Only BRL'){  item.listValue = item.unitValueBRL/item.qty;
                                                            }
                        else{
                            item.listValue = item.unitValueUSD/item.qty;
                        }
                    }
                }
                else{
                    if(kitValuesMap.containsKey(item.refKitNo)){
                        System.debug('@@@'+kitValuesMap.get(item.refKitNo));
                        item.componentQty = item.qty/kitValuesMap.get(item.refKitNo)[0];
                        if(item.currency_Code == 'Only BRL'){ item.listValue = item.unitValueBRL;
                                                            }
                        else{
                            item.listValue = item.unitValueUSD;
                        }
                        //item.listValue = item.componentQty*
                    }
                    
                }
            }  
            
        }
        //End:Modified by Deeksha for kit selling Project
        System.debug('itemList: '+itemList);
        return itemList;
    }
    //Method To fetch structure Campaign Info by prashant
    
    @AuraEnabled
    public static StructCampaignDetailWrap fetchStructureCampaign(string structCampId,string soId){
        StructCampaignDetailWrap structCampDtlObj = new StructCampaignDetailWrap();
        Price_Book__c PriceBookObject = new Price_Book__c();
        list<Price_Book_Details__c> listPriceBookDetails = new  list<Price_Book_Details__c>();
        list<Campaign_Group__c> listCampaignGroup = new list<Campaign_Group__c>();
        set<string> setGroup = new set<string>(); 
        set<string> setSubgroup = new set<string>();
        map<string,Campaign_Group__c> mapCampaignGroup = new map<string,Campaign_Group__c>(); 
        list<StructOrderLineItem> lstStructureOrderLineItem = new list<StructOrderLineItem>();
        map<string,list<Price_Book_Details__c>> mapPriceBookDetailList = new map<string,list<Price_Book_Details__c>>();
        map<string,map<string,list<Price_Book_Details__c>>> MapofMapPriceBokDtlList = new map<string,map<string,list<Price_Book_Details__c>>>();
        
        map<string,Sales_Order_Line_Item__c> mapSalesOrderItem = new map<string,Sales_Order_Line_Item__c>();
        map<string,Price_Book_Details__c> mapofPriceBookDetails = new map<string,Price_Book_Details__c>();
        system.debug('structCampId>>--->'+structCampId);
        //structCampId='a330k000000AoWHAA0';// 'a330k000000AptDAAS';
        system.debug('structCampId>>--->'+structCampId);
        PriceBookObject =[SELECT Id,Name,isActive__c,Campaign_Type__c,Expiry_Date__c,Interest_Date__c,
                          Interest_Rate_R__c,Interest_Rate_U__c,Sales_Order_Block_Date__c,Valid_From__c,
                          Product_Discount__c FROM Price_Book__c WHERE Id =:structCampId];
        if(soId != '' && soId != null){
            List<Sales_Order_Line_Item__c> salesOrderItemList = new List<Sales_Order_Line_Item__c>();
            // this list is used for view submitted and draft order in interface
            // added Recommended_price__c, DDS_Grade__c in query by Sagar for DDS score
            salesOrderItemList = [SELECT ID, Sale_Order__c, DateofFAT__c,Campaign_Group__c,Campaign_Subgroup__c, SKU_Name__c, Discount__c, Tax__c, Freight__c,
                                  SKU_Name__r.SKU_Description__c, Time_in_months__c, Days__c,Cogs_Info__c, Flag__c, MO_Item_No__c, Recommended_price__c, DDS_Grade__c,
                                  UnitValue__c,Group_Discount__c, InterestRate__c, ProductReplacementMargin__c, Net_Price__c,MinValue__c,
                                  Quantity__c, UnitValuewithInterest__c, Culture__r.Culture_Desc__c,BudgetPrice__c,
                                  ProductLedgerMargin__c, Approval_Flag__c, Culture__c, Item_Number__c,Budget_Value_Margin__c,
                                  PriceBookDetail__c, CurrencyIsoCode, Sales_Org__c, Sales_Order_Line_Item__c,
                                  MaterialPlantRelation__c, TotalValueWithoutInterest__c, Sales_Order_Line_Item__r.Item_Number__c,
                                  ExchangeRate__c,Volume_Difference__c,Total_Value__c,Initial_Price_with_Discount__c,SKU_Name__r.Brand_Name__c,
                                  SKU_Name__r.Name, TotalValueWithInterest__c,Total_Value_With_Interest_Structured__c,
                                  Price_With_Interest_Structured__c
                                  FROM Sales_Order_Line_Item__c
                                  WHERE Sale_Order__c=:soId Order By CreatedDate];
            
            structCampDtlObj.salesOrderObj =getSalesOrder(soId);
            structCampDtlObj.orderSubStatus = getOrderSubStatus(soId);
            structCampDtlObj.sfdcOrderNo = [Select Id, SalesOrderNumber_Brazil__c FROM Sales_Order__c WHERE Id=:soId].SalesOrderNumber_Brazil__c;//soObj.SalesOrderNumber_Brazil__c;
            structCampDtlObj.sapOrderNo =[Select Id, SAP_Order_Number__c FROM Sales_Order__c WHERE Id=:soId].SAP_Order_Number__c; //soObj.SAP_Order_Number__c;
            
            structCampDtlObj.approvalList = OrderRequestController.generateData(soId);
            structCampDtlObj.errorList = OrderRequestController.getErrorHistory(soId);
            for(Sales_Order_Line_Item__c soitem : salesOrderItemList){ mapSalesOrderItem.put(soitem.PriceBookDetail__c,soitem);   
                                                                     }
        }
        if(PriceBookObject != NULL){
            structCampDtlObj.priceBookObj = PriceBookObject;
            listPriceBookDetails = [SELECT Id, Name, Equivalence__c, Anchor__c,Cost_R__c,Cost_U__c,Exchange_Rate__c,Price_Book__r.Interest_Rate_R__c,
                                    Future_Sales_Price_R__c,Future_Sales_Price_U__c,Group__c,Minimum_Price_R__c,Price_Book__r.Product_Discount__c,
                                    Minimum_Price_U__c,Monthly_Interest_Rate__c,Multiplication_Factor__c,Sales_District1__c,Price_Book__r.Interest_Rate_U__c,
                                    Price_Book__r.Interest_Date__c,Price_Book__r.Sales_Order_Block_Date__c, SKU__r.Product_Category__c, 
                                    SKU__c,SKU__r.Multiple_of__c,SKU__r.UOM__c,Sku_Name1__c,Sub_Group__c,Sub_Group_Required__c,Unit_Price_R__c,Unit_Price_U__c,
                                    Volume__c,SKU__r.Brand_Name__c FROM Price_Book_Details__c WHERE Price_Book__c =: PriceBookObject.Id ORDER BY Anchor__c desc,Group__c asc,Sub_Group_Required__c desc];
            
            listCampaignGroup = [SELECT Id,Name,Campaign__c,Do_not_generate_group_discount__c,Group_Description__c,
                                 Group_Discount__c,Limited_volume__c,Name_of_the_group__c,Required_sub_group_Qty__c,
                                 Will_you_have_a_sub_product_group__c FROM Campaign_Group__c WHERE Campaign__c =:PriceBookObject.Id];
            
            for(Campaign_Group__c cmpgrp: listCampaignGroup){
                mapCampaignGroup.put(cmpgrp.Name_of_the_group__c,cmpgrp);
            }
            system.debug('mapCampaignGroup'+mapCampaignGroup);
            
            
            list<campaignGroupWrap> listCampaignGroupwrap = new list<campaignGroupWrap>();
            //wrapper used for rules and save data 
            if(!listPriceBookDetails.isEmpty()){
                for(Price_Book_Details__c pbd : listPriceBookDetails){
                    setGroup.add(pbd.Group__c);
                    setSubgroup.add(pbd.Sub_Group__c);
                    
                    StructOrderLineItem solineItem = new StructOrderLineItem();
                    if(soId != '' && mapSalesOrderItem.containskey(pbd.id)){ solineItem.soItemId = mapSalesOrderItem.get(pbd.id).id;
                                                                           }      
                    solineItem.combinationkey = pbd.id;
                    solineItem.campGrp = pbd.Group__c;
                    solineItem.camSubgrp = pbd.Sub_Group__c;
                    solineItem.skuId = pbd.SKU__c;
                    solineItem.skuDesc = pbd.Sku_Name1__c;
                    solineItem.skuCategory = pbd.SKU__r.Product_Category__c;
                    solineItem.costBRL = pbd.Future_Sales_Price_R__c; 
                    solineItem.costUSD = pbd.Future_Sales_Price_U__c;
                    solineItem.interestDate =  String.valueOf(pbd.Price_Book__r.Interest_Date__c);
                    solineItem.interestRateBRL = pbd.Price_Book__r.Interest_Rate_R__c; 
                    solineItem.interestRateUSD = pbd.Price_Book__r.Interest_Rate_U__c;
                    solineItem.brand = pbd.SKU__r.Brand_Name__c;
                    system.debug('Brand Name...Of >>--->'+pbd.SKU__r.Brand_Name__c);
                    if(pbd.SKU__r.Multiple_of__c ==0){ solineItem.multipleOf = 1;   
                                                     }else{
                                                         solineItem.multipleOf = pbd.SKU__r.Multiple_of__c;   
                                                     }
                    
                    solineItem.salesOrderBlockDate = String.valueOf(pbd.Price_Book__r.Sales_Order_Block_Date__c);
                    
                    if( pbd.Price_Book__r.Product_Discount__c != 0 && pbd.Price_Book__r.Product_Discount__c != null ){  solineItem.manDiscount = pbd.Price_Book__r.Product_Discount__c; 
                                                                                                                      solineItem.isManDiscount  = true;
                                                                                                                     }else{
                                                                                                                         solineItem.isManDiscount  = false;
                                                                                                                     }  
                    system.debug('equivalence>>>'+pbd.Equivalence__c);
                    if(pbd.Equivalence__c!= null ){
                        solineItem.equivalence = pbd.Equivalence__c;
                    }    
                    if(pbd.Anchor__c=='Sim'){
                        solineItem.isAnchor = true;    
                    }
                    
                    lstStructureOrderLineItem.add(solineItem);
                    structCampDtlObj.mapofStructureLineItem.put(solineItem.combinationkey,solineItem);
                }
                structCampDtlObj.lstStructOrderLineItem = lstStructureOrderLineItem;
                system.debug('lstStructureOrderLineItem>>--->'+lstStructureOrderLineItem);
                //this loop map priceBook data according to group and subgroup
                for(Price_Book_Details__c pbd : listPriceBookDetails){ 
                    
                    if(MapofMapPriceBokDtlList.containsKey(pbd.Group__c)){ if(mapPriceBookDetailList.containsKey(pbd.Group__c+'-'+pbd.Sub_Group__c)){ list<Price_Book_Details__c> listPriceBookDtls = new list<Price_Book_Details__c>();
                                                                                                                                                     listPriceBookDtls = mapPriceBookDetailList.get(pbd.Group__c+'-'+pbd.Sub_Group__c);
                                                                                                                                                     system.debug('pbd>>--->'+pbd);
                                                                                                                                                     listPriceBookDtls.add(pbd);
                                                                                                                                                     mapPriceBookDetailList.put(pbd.Group__c+'-'+pbd.Sub_Group__c,listPriceBookDtls);
                                                                                                                                                     MapofMapPriceBokDtlList.put(pbd.Group__c,mapPriceBookDetailList);
                                                                                                                                                     
                                                                                                                                                     list<Sales_Order_Line_Item__c> listOrderItems = new list<Sales_Order_Line_Item__c>();
                                                                                                                                                     map<string,list<Sales_Order_Line_Item__c>> mapsalOrdrItmLst = new map<string,list<Sales_Order_Line_Item__c>>();
                                                                                                                                                     
                                                                                                                                                    }else{
                                                                                                                                                        
                                                                                                                                                        list<Price_Book_Details__c> listPriceBookDtls = new list<Price_Book_Details__c>();
                                                                                                                                                        if(mapPriceBookDetailList.containskey(pbd.Group__c+'-'+pbd.Sub_Group__c)){
                                                                                                                                                            listPriceBookDtls = mapPriceBookDetailList.get(pbd.Sub_Group__c);
                                                                                                                                                        }
                                                                                                                                                        listPriceBookDtls.add(pbd);    
                                                                                                                                                        mapPriceBookDetailList.put(pbd.Group__c+'-'+pbd.Sub_Group__c,listPriceBookDtls);
                                                                                                                                                        MapofMapPriceBokDtlList.put(pbd.Group__c,mapPriceBookDetailList);
                                                                                                                                                        
                                                                                                                                                        list<Sales_Order_Line_Item__c> listOrderItems = new list<Sales_Order_Line_Item__c>();
                                                                                                                                                        map<string,list<Sales_Order_Line_Item__c>> mapsalOrdrItmLst = new map<string,list<Sales_Order_Line_Item__c>>();
                                                                                                                                                        
                                                                                                                                                        
                                                                                                                                                    }
                                                                         }else{
                                                                             
                                                                             list<Price_Book_Details__c> listPriceBookDtls = new list<Price_Book_Details__c>();
                                                                             listPriceBookDtls.add(pbd);  
                                                                             mapPriceBookDetailList.put(pbd.Group__c+'-'+pbd.Sub_Group__c,listPriceBookDtls);
                                                                             MapofMapPriceBokDtlList.put(pbd.Group__c,mapPriceBookDetailList); 
                                                                             
                                                                         }
                }
                //this loop is used for display data on interface according to Campaign group and sub-group
                for(string grp : setGroup){
                    CampaignGroupWrap campaignGroupObj = new CampaignGroupWrap();  
                    integer i = 1;
                    //system.debug('value of group i>>--->'+i);
                    //system.debug('MapValue>>--->'+ MapofMapPriceBokDtlList.get(grp)); 
                    map<string,list<Price_Book_Details__c>> mapSubgroup = MapofMapPriceBokDtlList.get(grp);
                    system.debug('keyset====>'+mapSubgroup.keyset());
                    integer subgrpNum = 1;
                    for(string subgrp : mapSubgroup.keyset()){
                        //system.debug('i value ==>'+i);
                        CampaignSubGroupWrap campSubgrpWrapObj = new CampaignSubGroupWrap();  
                        
                        for(Price_Book_Details__c pbd : mapSubgroup.get(subgrp)){
                            if(grp==pbd.Group__c){    
                                PriceBookDetailWrap priceBookDetailWrapObj = new PriceBookDetailWrap();
                                system.debug('value of PriceBookDetail before '+grp+'----'+subgrp+' i++>>--->'+i);
                                priceBookDetailWrapObj.totalGrpRowspan = i; 
                                i++;
                                system.debug('value of PriceBookDetail after i>>--->'+i);
                                priceBookDetailWrapObj.priceBookObj = pbd;
                                //system.debug('solineItem.combinationkey>>>>'+pbd.Id);
                                
                                if(soId != '' && soId != null && mapSalesOrderItem.containsKey(pbd.Id)){ Sales_Order_Line_Item__c orderItems = new Sales_Order_Line_Item__c();
                                                                                                        orderItems = mapSalesOrderItem.get(pbd.Id);
                                                                                                        system.debug('orderItems>>--->'+orderItems.Culture__r.Culture_Desc__c);
                                                                                                        priceBookDetailWrapObj.salesOrderitem = orderItems ;    
                                                                                                       }
                                if(mapCampaignGroup.containskey(grp)){  
                                    priceBookDetailWrapObj.campaignGroupDesc = mapCampaignGroup.get(grp).Group_Description__c;
                                }
                                priceBookDetailWrapObj.campaignSubgroup = pbd.Sub_Group__c;
                                priceBookDetailWrapObj.campaignGroup = pbd.Group__c;
                                priceBookDetailWrapObj.priceitemsize = mapSubgroup.get(subgrp).size();
                                priceBookDetailWrapObj.groupRowspan = mapSubgroup.get(subgrp).size()+1;
                                
                                campSubgrpWrapObj.priceBooklistObj.add(priceBookDetailWrapObj);
                                
                                campSubgrpWrapObj.priceitemSize = campSubgrpWrapObj.priceBooklistObj.size(); 
                                campSubgrpWrapObj.subGroup = pbd.Sub_Group__c;
                                campSubgrpWrapObj.campGrp =pbd.Group__c;
                                
                            }   //system.debug('pricelist size>>--->'+campSubgrpWrapObj.priceitemSize);
                        }
                        
                        if(campSubgrpWrapObj.campGrp==grp && campSubgrpWrapObj.campGrp+'-'+campSubgrpWrapObj.subGroup == subgrp){  
                            campaignGroupObj.campaignSubGroupList.add(campSubgrpWrapObj); 
                            campaignGroupObj.subgroupSize = campaignGroupObj.campaignSubGroupList.size();
                            campaignGroupObj.campaignGroup = grp;
                            campaignGroupObj.campGroupObj = mapCampaignGroup.get(grp) ;
                            campaignGroupObj.totalPriceBookSize = campaignGroupObj.totalPriceBookSize + mapSubgroup.get(subgrp).size() +1;
                        }
                        //system.debug('subgroup size>>--->'+campaignGroupObj.subgroupSize);
                        
                    }
                    
                    structCampDtlObj.listCampaignGroupWrap.add(campaignGroupObj);
                    structCampDtlObj.groupsize =MapofMapPriceBokDtlList.size();
                    //system.debug('group Size>>--->'+ structCampDtlObj.groupsize);
                }
                
                system.debug('lstStructureOrderLineItem>>--->'+lstStructureOrderLineItem);
                
                structCampDtlObj.mapofCampaignGroup = mapCampaignGroup;
                system.debug('group Size>>--->'+ structCampDtlObj.groupsize);
                //system.debug('group Size>>--->'+structCampDtlObj.listCampaignGroupWrap.size());
                for(CampaignGroupWrap campgrp : structCampDtlObj.listCampaignGroupWrap){
                    system.debug('sub group Size>>--->'+campgrp.campaignSubGroupList.size());
                    for(CampaignSubGroupWrap camSubgrp :campgrp.campaignSubGroupList){
                        for(PriceBookDetailWrap pbw : camSubgrp.priceBooklistObj){
                            system.debug('pbw>>--->'+pbw.totalGrpRowspan);
                            // pbw.totalGrpPricelist = campgrp.totalPriceBookSize + campgrp.subgroupSize ;
                        }
                        //system.debug('price Book Size>>--->'+ camSubgrp.priceBooklistObj.size());   
                    }
                }
                
                
            }
        }
        system.debug('Wrapper Class>>--->'+structCampDtlObj); 
        return  structCampDtlObj;                        
    }
    
    
    /* @AuraEnabled
public static StructCampaignDetailWrap rollbackStructSalesOrder (Sales_Order__c soObj, String salesOrderItemString, Boolean isSimulated) {
//Create a savepoint while AccountNumber is null
Savepoint sp = Database.setSavepoint();
StructCampaignDetailWrap structureCampaignDetailObj = new StructCampaignDetailWrap();
structureCampaignDetailObj = OrderRequestController.saveStructuresalesOrder(soObj, salesOrderItemString, true, isSimulated);

//Rollback to the previous null value
//if(owObj.soObj.Flag_Status__c!='like'){
Database.rollback(sp);   
//}
// System.debug('Rolled back: '+soObj.Id);

//Insert an entry in Monitor Log in case of error during rollback.
if(structureCampaignDetailObj.exObj!=null){
System.debug('ex No: '+structureCampaignDetailObj.exObj.getLineNumber()+' ex Msg: '+structureCampaignDetailObj.exObj.getMessage());
ApexLog.exceptionHandlerBrazil(structureCampaignDetailObj.exObj, soObj.Sold_to_Party__c, soObj, salesOrderItemString);
}
structureCampaignDetailObj.sfdcOrderNo = '';
return structureCampaignDetailObj;
} */  
    
    
    @AuraEnabled
    public static StructCampaignDetailWrap saveStructuresalesOrder(Sales_Order__c soObj,String structCampSoitemStr,string structsoitemData){
        StructCampaignDetailWrap structureCampaignDetailObj = new StructCampaignDetailWrap(); 
        list<StructOrderLineItem> listStructOrderItemWrap = new list<StructOrderLineItem>();     
        try{
            system.debug('structCampSoitemStr >>--->'+structCampSoitemStr);
            structCampSoitemStr = structCampSoitemStr.replaceAll('N/A', 'NA');
            listStructOrderItemWrap = (list<StructOrderLineItem>)JSON.deserialize(structCampSoitemStr,list<StructOrderLineItem>.class);
            system.debug('listStructOrderItemWrap>>--->'+listStructOrderItemWrap);
            system.debug('sales Order>>--->'+soObj);
            system.debug('sales Order Approval Check>>--->'+soObj.BudgetApprovalCheck__c);
            system.debug('sales Order call Process Builder Flow>>--->'+soObj.Call_Process_Builder_Flow__c);
            system.debug('sales Order BrazilSalesOrderApproved>>--->'+soObj.BrazilSalesOrderApproved__c );
            system.debug('sales Order Territory>>--->'+soObj.Region_Territory__c);
            //Sales_Order__c soObj = new Sales_Order__c();
            String accOwner = soObj.KeyAccountDesOwnerBrazil__c; 
            String TManagerCode = soObj.TM_Code__c;
            String territoryId ='';// OrderRequestController.getTerritory();
            String territoryId1 ='';           
            system.debug('Discount'+soObj.Punctuality_Discount__c);  
            if(soObj.Punctuality_Discount__c == null){
                soObj.Punctuality_Discount__c = 0.0;
            }
            List<Territory_Distributor__c> tdObj1 = new List<Territory_Distributor__c>();
            if(String.isNotBlank(accOwner) && accOwner!=null){ if(String.isNotBlank(TManagerCode) && TManagerCode!=null){ tdObj1 = [SELECT Id,Regional_Manager_Id__c
                                                                                                                                    FROM Territory_Distributor__c 
                                                                                                                                    WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                                                                                                                                    AND Open_TM_Code__c!=null AND TerritoryCode__c=:TManagerCode
                                                                                                                                    // AND Regional_Manager_Id__c =:accOwner 
                                                                                                                                    limit 1];
                                                                                                                         if(tdObj1.size()>0){
                                                                                                                             territoryId1 =tdObj1[0].Id;
                                                                                                                             system.debug('tdObj1'+tdObj1);
                                                                                                                         }
                                                                                                                        }
                                                              else{
                                                                  tdObj1 = [SELECT Id
                                                                            FROM Territory_Distributor__c 
                                                                            WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                                                                            AND TerritoryManagerActive__c = True
                                                                            AND TerritoryManager__c=:accOwner limit 1];
                                                                  if(tdObj1.size()>0){
                                                                      system.debug('tdObj'+tdObj1);
                                                                      territoryId1 =tdObj1[0].Id;
                                                                  }
                                                              }
                                                              territoryId= territoryId1;
                                                             }
            else{
                territoryId =  OrderRequestController.getTerritory();
            }
            if(String.isNotBlank(territoryId)){ soObj.Region_Territory__c = territoryId;
                                              }
            
            //If Owner Id is blank or None set Owner Id to Logged In User
            String ownerId = soObj.OwnerId;
            system.debug('Owner Id>>--->'+soObj.OwnerId);
            if(String.isBlank(ownerId) || ownerId=='None'){
                soObj.OwnerId = UserInfo.getUserId();
            }
            //  system.debug('soObj.Order_Status__c'+soObj.Order_Status__c+''+soObj);
            User userObj = [Select Id, Profile.Name, Show_List_Value__c FROM User WHERE Id=:UserInfo.getUserId()];
            //If Order Status=='Draft' & Profile=='SOM' || 'SDM' set ownership of Sales Order to Logged In User
            system.debug('soObj.Order_Status__c>>--->'+soObj.Order_Status__c);
            if(soObj.Order_Status__c=='Draft'){ String profileName = userObj.Profile.Name;
                                               if(profileName=='Brazil Sales Office Manager' || profileName=='Brazil Sales District Manager'|| profileName=='Brazil Marketing Ops Manager'){
                                                   soObj.OwnerId = UserInfo.getUserId();
                                                   system.debug('profileName>>--->'+ profileName);
                                               }
                                              }else{
                                                  String keyOwnerId = soObj.KeyAccountDesOwnerBrazil__c;
                                                  String profileName = userObj.Profile.Name;
                                                  if(profileName=='Brazil Sales Office Manager' || profileName=='Brazil Sales District Manager'|| profileName=='Brazil Marketing Ops Manager'){ if(String.isNotBlank(keyOwnerId)){ soObj.OwnerId = keyOwnerId;
                                                                                                                                                                                                                                 }
                                                                                                                                                                                              }
                                              }
            
            //Sales_Order_Line_Item__c soiBusinessObj = OrderRequestController.getKEDE(soObj.OwnerId);
            KEDE kedeObj = OrderRequestController.getKEDE(soObj.OwnerId);
            if(kedeObj!=null){
                System.debug('soObj'+soObj);
                //added by ganesh Date:23/04/2018
                //desc:save business rule when type of order other than ORDEM FILHA.
                if(soObj.Type_of_Order__c!= 'ORDEM FILHA'){ soObj.Tax__c = kedeObj.tax; 
                                                           soObj.Freight__c = kedeObj.freight;
                                                          }
                //end
                
                if(String.isNotBlank(kedeObj.salesDistrictManager)){ soObj.SalesDistrictManager__c = kedeObj.salesDistrictManager;
                                                                   }
                if(String.isNotBlank(kedeObj.BrazilMarketingOpsManager)){ soObj.Marketing_Ops_Manager__c = kedeObj.BrazilMarketingOpsManager;
                                                                        }
                if(String.isNotBlank(kedeObj.salesOfficeManager)){ soObj.SalesOfficeManager__c = kedeObj.salesOfficeManager;
                                                                 }
                if(String.isNotBlank(kedeObj.salesDirector)){ soObj.SalesDirector__c = kedeObj.salesDirector;
                                                            }
                if(String.isNotBlank(kedeObj.barterManager)){ soObj.BarterManager__c = kedeObj.barterManager;
                                                            }
                if(String.isNotBlank(kedeObj.brazilAnalyst)){ soObj.BrazilAnalyst__c = kedeObj.brazilAnalyst;
                                                            }
                
                //added by ganesh date:12/11/2018
                //Desc:added REH and GSD to SO
                if(String.isNotBlank(kedeObj.REHManager)){ soObj.REH__c = kedeObj.REHManager ;
                                                         }
                if(String.isNotBlank(kedeObj.GSDManager)){ soObj.GSD__c = kedeObj.GSDManager ;
                                                         }
                //End
            }
            
            List<Sales_Org__c> salesOrgList = [Select ID FROM Sales_Org__c 
                                               WHERE NAME = 'Brazil' 
                                               OR Country_Code__c = 'BR' LIMIT 1]; //Updated by GRZ(Dheeraj Sharma) for RITM0556333 modified 18-05-2023
            
            if(!salesOrgList.isEmpty()){
                soObj.Sales_Org_lk__c = salesOrgList[0].Id;
            }
            
            List<Sales_Order__c> salesOrderList = [Select Id, SalesOrderNumber_Brazil__c FROM Sales_Order__c WHERE Id=:soObj.Id];
            if(salesOrderList.isEmpty()){
                //After rollback the ID remains in the record, make it null & upsert
                soObj.Id = null;
            }
            soObj.PaymentMethod__c = null;
            
            upsert soObj;
            
            list<StructOrderLineItem> salesOrderItemList =new list<StructOrderLineItem>(); 
            
            salesOrderItemList = OrderRequestController.saveStructSalesOrderitems(soObj,listStructOrderItemWrap,salesOrgList);
            system.debug('soObj>>--->'+soObj);
            //owObj.soObj = OrderRequestController.getSalesOrder(soObj.Id);
            
            
        }
        catch(Exception ex){
            System.debug('ErrLine-->'+ex.getLineNumber());
            System.debug('cause>>--->'+ex.getCause());
            //If Exception occurrs or If Upsert Fails assign data to return wrapper object.
            structureCampaignDetailObj.salesOrderObj.ErrorMessage__c = 'Sales Order save failed. Please contact System Administrator.';
            structureCampaignDetailObj.salesOrderObj.Flag_Message__c = structureCampaignDetailObj.salesOrderObj.ErrorMessage__c;
            structureCampaignDetailObj.salesOrderObj.Flag_Status__c = ''; 
            structureCampaignDetailObj.exObj = ex;
            //End of Logic
            
            System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage());
            ApexLog.exceptionHandlerBrazil(ex, structureCampaignDetailObj.salesOrderObj.Sold_to_Party__c, structureCampaignDetailObj.salesOrderObj, structsoitemData);
        }
        
        
        return fetchStructureCampaign(soObj.Price_Book__c,soObj.Id);
    }
    
    public static list<StructOrderLineItem> saveStructSalesOrderitems(Sales_Order__c soObj2, list<StructOrderLineItem>  structorderitems,List<Sales_Org__c> salesOrgList){
        
        list<Sales_Order_Line_Item__c> structOrderLineitems = new list<Sales_Order_Line_Item__c>();
        integer i = 0;
        Map<String,Id> cultureMap = new Map<String,Id>();
        boolean isLessBudgetedVal = false;
        for(Culture__c culObj:[SELECT Id, Name, Culture_Code__c, 
                               Culture_Desc__c, Division__c, Sales_Org__c 
                               FROM Culture__c 
                               WHERE Active__c=True 
                               ORDER BY Culture_Code__c]){
                                   
                                   cultureMap.put(culObj.Culture_Desc__c, culObj.Id);
                               }
        system.debug('soObj2.Id'+soObj2.Id);
        for(StructOrderLineItem item: structorderitems){
            Sales_Order_Line_Item__c soiObj = new Sales_Order_Line_Item__c();
            system.debug('item.isTrue>>--->'+item.isTrue);
            if(item.isTrue){
                
                i = i+10;
                if(item.soItemId != ''){
                    soiObj.id =item.soItemId;
                }else{
                    soiObj.Sale_Order__c = soObj2.Id;    
                }
                soiObj.Item_Number__c = i;
                
                //item.invoiceDate = item.invoiceDate.replace('-','/');
                
                //system.debug('----'+item.invoiceDate.split('-')[0]+'---'+item.invoiceDate.split('-')[1]+'---'+item.invoiceDate.split('-')[2]);
                //Date invDate =  Date.newInstance(integer.valueof(item.invoiceDate.split('-')[0]),integer.valueof(item.invoiceDate.split('-')[1]),integer.valueof(item.invoiceDate.split('-')[2]));
                //system.debug('fatDate>>--->'+invDate);
                
                try{
                    system.debug('item.fatDate'+item.invoiceDate);
                    soiObj.DateofFAT__c =  Date.valueOf(item.invoiceDate);
                }
                catch(Exception ex){
                    system.debug('items.fatDate'+item.invoiceDate);
                    soiObj.DateofFAT__c = Date.parse(item.invoiceDate); 
                }
                soiObj.Campaign_Group__c = item.campGrp;
                
                
                soiObj.Campaign_Subgroup__c = item.camSubgrp;    
                soiObj.SKU_Name__c = item.skuId;
                soiObj.UnitValue__c = item.FinalUnitPrice;
                //if(item.fspPrice!= null){
                //soiObj.BudgetPrice__c = item.fspPrice; 
                //}
                soiObj.Group_Discount__c = item.grpDiscount;
                if(soObj2.CurrencyIsoCode == 'BRL'){
                    soiObj.BudgetPrice__c = item.costBRL;   
                    
                }else{
                    soiObj.BudgetPrice__c =item.costUSD;   
                }  
                if(!isLessBudgetedVal){
                    system.debug('Future Sales Price'+soiObj.BudgetPrice__c);
                    if( item.FinalUnitPrice < soiObj.BudgetPrice__c){
                        isLessBudgetedVal =true;
                    }
                }
                soiObj.InterestRate__c = item.interestRate;
                soiObj.Quantity__c = item.prdctVol;
                soiObj.UnitValuewithInterest__c = item.FinalUnitPrice;
                soiObj.Net_Price__c = item.intialPrice;
                //soiObj.Discount__c = item.discount;
                soiObj.Time_in_months__c = item.timeInMonths;
                soiObj.Days__c = item.days;
                system.debug('soiObj.Days__c=='+soiObj.Days__c);
                system.debug('soiObj.Days__c=='+item.days);
                soiObj.Recommended_price__c=item.Recommendedprice; // added by Sagar for DDS score  
                soiObj.DDS_Grade__c=item.DDSGrade; // added by Sagar for DDS score  
                soiObj.PriceBookDetail__c = item.combinationkey;
                soiObj.CurrencyIsoCode = soObj2.CurrencyIsoCode;
                soiObj.Volume_Difference__c =item.volDifference ;
                soiObj.Total_Value__c = item.totalValStr;    
                soiObj.Total_Value_With_Interest_Structured__c = item.totalValWithInterestStr;
                soiObj.Price_With_Interest_Structured__c = item.priceWithInterestStr;
                soiObj.Initial_Price_with_Discount__c = item.discountedInitialPriceStr;
                
                
                if(cultureMap.containsKey(item.cultureDesc)){
                    soiObj.Culture__c = cultureMap.get(item.cultureDesc);
                }
                
                if(!salesOrgList.isEmpty()){
                    soiObj.Sales_Org__c = salesOrgList[0].Id;
                }
                
                structOrderLineitems.add(soiObj);
            }     
        }
        
        system.debug('structOrderLineitems>>--->'+structOrderLineitems);
        
        
        upsert structOrderLineitems;
        if(soObj2.Order_Status__c=='Draft'){
            soObj2.Call_Process_Builder_Flow__c = false;
        }else if(soObj2.Order_Status__c=='Submitted'){
            system.debug('Order Status>>--->'+soObj2.Order_Status__c);
            soObj2.Call_Process_Builder_Flow__c = true;
            system.debug('Call_Process_Builder_Flow__c>>--->'+soObj2.Call_Process_Builder_Flow__c);
        }
        soObj2.BudgetApprovalCheck__c = isLessBudgetedVal;
        
        update soObj2;
        system.debug('sales order call >>--->'+soObj2);
        
        return getStructSalesOrderItems(soObj2.id);   
    } 
    
    
    //Method to delete a particular Sales Order record.
    @AuraEnabled
    public static Boolean deleteSalesOrder (String recordId) {
        Boolean flag = false;
        
        //Id recordTypeId = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Simulation').getRecordTypeId();        
        Id idforsimulation;
        
        RecordType clientOnlyRecordType = [
            SELECT Id FROM RecordType WHERE DeveloperName = 'Simulation'
        ];
        
        if( clientOnlyRecordType != null ){
            idforsimulation = clientOnlyRecordType.Id;
        }else{
            idforsimulation = '0120K000001HskHQAS';
        }
        
        List<Sales_Order__c> soList = [SELECT Id FROM Sales_Order__c 
                                       WHERE Id=:recordId 
                                       AND (RecordTypeId =: idforsimulation OR Order_Status__c = 'Draft')
                                       AND (RecordTypeId =: idforsimulation OR OwnerId =: UserInfo.getUserId()) LIMIT 1];
        
        if(!soList.isEmpty()){
            try{
                delete soList;
                flag = true;
            }
            catch(Exception ex){
                System.debug('Delete denied. Please contact System Administrator.');
            }
        }
        
        return flag;
    }
    
    //Method to save & rollback sales order record to calculate the formulas & flag
    @AuraEnabled
    public static OrderWrapper rollbackSalesOrder (Sales_Order__c soObj, String salesOrderItemString, Boolean isSimulated, String TCforBarterManagerProcess) { //Added new parameter TCforBarterManagerProcess by GRZ(Nikhil Verma) for RITM0422585 modified 09-09-2022
        //Create a savepoint while AccountNumber is null
        System.debug('@@@'+salesOrderItemString);
        system.debug('rollbackSalesOrder');
        Savepoint sp = Database.setSavepoint();
        OrderWrapper owObj = new OrderWrapper();
        owObj = OrderRequestController.saveSalesOrder(soObj, salesOrderItemString, true, isSimulated, TCforBarterManagerProcess); //Added new parameter TCforBarterManagerProcess by GRZ(Nikhil Verma) for RITM0422585 modified 09-09-2022
        
        //Rollback to the previous null value
        //if(owObj.soObj.Flag_Status__c!='like'){
        Database.rollback(sp);   
        //}
        // System.debug('Rolled back: '+soObj.Id);
        
        //Insert an entry in Monitor Log in case of error during rollback.
        if(owObj.exObj!=null){
            System.debug('ex No: '+owObj.exObj.getLineNumber()+' ex Msg: '+owObj.exObj.getMessage());
            ApexLog.exceptionHandlerBrazil(owObj.exObj, soObj.Sold_to_Party__c, soObj, salesOrderItemString);
        }
        owObj.sfdcOrderNo = '';
        return owObj;
    }   
    
    public static FlagStatus checkFlag(String recordId, Boolean isSimulated, String orderType, String orderStatus){
        List<AggregateResult> lstAR = [SELECT max(Approval_Flag__c)af 
                                       FROM Sales_Order_Line_Item__c 
                                       WHERE Sale_Order__c =:recordId];
        
        Decimal flagCount = (Decimal)lstAR[0].get('af');
        
        String greenFlag = 'like'; 
        String yellowFlag = 'midlike'; 
        String redFlag = 'dislike'; 
        String blackFlag ='dislike_black';
        String blueFlag ='Blue_Dislike';
        
        //String salesOrderMarginMsg = 'The Sales Order does not fall within the Margin Limits Set. It will be sent ahead For Approval. Do you wish to send it for Approval?';
        //String simulationMarginMsg = 'The Simulation does not fall within the Margin Limits Set. Do you wish To save it as Simulation Order?';
        //String draftMarginMsg = 'The Sales Order does not fall within the Margin Limits Set. It will be sent ahead for Approval. Do you wish to Save it as Draft?';
        
        FlagStatus fsObj = new FlagStatus();
        
        //Set Green Flag - if flagCount = 0 or Order type == 'ORDEM FILHA' (Child Order)
        //if(flagCount==0.0 || orderType=='ORDEM FILHA'){
        if((flagCount==0.0 && orderType!='REMESSA PARA TESTE') || orderType=='ORDEM FILHA'){    
            if(isSimulated){
                fsObj.flagMessage = System.Label.Simulation_Saved_Successfully; //'Simulation Saved Successfully.';
            }
            else if(orderStatus == 'Draft'){
                fsObj.flagMessage = System.Label.Sales_Order_Draft_Saved_Successfully; //'Sales Order Draft Saved Successfully.';
            }       
            else{
                fsObj.flagMessage = System.Label.Sales_Order_Submitted_Successfully; //'Sales Order Submitted Successfully.';
            }
            
            fsObj.flagStatus = greenFlag;
        }
        
        //Always sent for Approval if Type of Order = 'BONIFICAÇÃO' or 'REMESSA PARA TESTE'
        else if(flagCount==1.0 || flagCount==2.0 || flagCount==3.0 || flagCount==4.0 || ((orderType=='BONIFICAÇÃO' || orderType=='REMESSA PARA TESTE') && flagCount!=5.0) ){
            
            if(isSimulated){
                fsObj.flagMessage = System.Label.The_Simulation_does_not_fall_within_the_Margin_Limits_Set_Do_you_wish_To_save_i;//'The Simulation does not fall within the Margin Limits Set. Do you wish To save it as Simulation Order?';
            }            
            else if(orderStatus == 'Draft'){
                fsObj.flagMessage = System.Label.The_Sales_Order_does_not_fall_within_the_Margin_Limits_Set_It_will_be_sent_ahea; //'The Sales Order does not fall within the Margin Limits Set. It will be sent ahead for Approval. Do you wish to Save it as Draft?';
            }                           
            else{
                fsObj.flagMessage = System.Label.Sales_Order_Does_Not_Fall_Within_Margin_Limits; //'The Sales Order does not fall within the Margin Limits Set. It will be sent ahead For Approval. Do you wish to send it for Approval?';
            }
            
            //Set Red flag if count = 3 or Order Type = 'BONIFICAÇÃO'
            if(flagCount==3.0 || orderType=='BONIFICAÇÃO' || orderType=='REMESSA PARA TESTE' ||flagCount==2.0){
                fsObj.flagStatus = redFlag;
            }
            //Set Yellow flag if count = 1 or 2
            else if(flagCount==1.0 ){
                fsObj.flagStatus = yellowFlag;
            }
            else if(flagCount==4.0 ){
                fsObj.flagStatus = blueFlag;
            }
        }else if(flagCount==5.0){
            if(orderStatus == 'Draft'){
                fsObj.flagMessage = System.Label.The_Sales_Order_does_not_fall_within_the_Future_Sales_Price_set_It_will_be_sent;
            }else{  
                fsObj.flagMessage = System.Label.The_Sales_Order_Does_Not_Fall_Within_The_Margin_Limits_Set;   
            }
            fsObj.flagStatus = blackFlag;   
        }
        
        //System.debug('flagCount ' + flagCount );
        
        return fsObj;
    }
    
    //Method to save sales order record
    //Params: Sales Order (Object),
    //        Sales Order Items (JSON String),
    //        isRollback (True if checking for approval flag),
    //        isSimulated (True if Order is being simulated)
    @AuraEnabled
    public static OrderWrapper saveSalesOrder(Sales_Order__c soObj, String salesOrderItemString, Boolean isRollback, Boolean isSimulated, String TCforBarterManagerProcess) { //Added new parameter TCforBarterManagerProcess by GRZ(Nikhil Verma) for RITM0422585 modified 09-09-2022
        System.debug('@@@'+salesOrderItemString);
        System.debug('Sales Order: '+soObj);
         System.debug('isRollback: '+isRollback);
        System.debug('Ship To Party >>---> '+soObj.Ship_To_Party__c);
        // System.debug('salesOrderItemList Deserialize: '+JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class));
        
        System.debug('Sales Order Items (Serialized): '+salesOrderItemString);
        //Initialize Return Order Wrapper.
        OrderWrapper owObj = new OrderWrapper();
        //Exception exObj;
        
        //soObj.Currency_Brazil__c = returnENvalue(soObj.Currency_Brazil__c);
        try{
            String paymentMethod = '';
            String paymentMethodId = soObj.PaymentMethod__c;
            String accOwner =soObj.KeyAccountDesOwnerBrazil__c;
            String TManagerCode = soObj.TM_Code__c;
            soObj.Approval_Reason__c = 'Pedido De Venda - Novo'; //added by Sagar@Wipro
            system.debug('TManagerCode'+TManagerCode+'accOwner'+accOwner+'soObj.OwnerId'+soObj.OwnerId);
            List<Territory_Distributor__c> tdObj1 = new List<Territory_Distributor__c>();
            
            if(String.isNotBlank(paymentMethodId) && paymentMethodId!='None'){
                paymentMethod = [SELECT Id, Name, Payment_Method_Code__c 
                                 FROM Payment_Method__c 
                                 WHERE Active__c=True 
                                 AND Id=:paymentMethodId].Name;
                
                System.debug('paymentMethod: '+paymentMethod);                
            }
            else{
                soObj.PaymentMethod__c = null;
            }
            
            String territoryId ='';// OrderRequestController.getTerritory();
            String territoryId1 ='';           
            //added by Ganesh
            if(String.isNotBlank(accOwner) && accOwner!=null){
                if(String.isNotBlank(TManagerCode) && TManagerCode!=null){
                    tdObj1 = [SELECT Id,Regional_Manager_Id__c
                              FROM Territory_Distributor__c 
                              WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                              AND Open_TM_Code__c!=null AND TerritoryCode__c=:TManagerCode
                              // AND Regional_Manager_Id__c =:accOwner 
                              limit 1];
                    if(tdObj1.size()>0){
                        territoryId1 =tdObj1[0].Id;
                        system.debug('tdObj1'+tdObj1);
                    }
                }
                else{
                    tdObj1 = [SELECT Id
                              FROM Territory_Distributor__c 
                              WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                              AND TerritoryManagerActive__c = True
                              AND TerritoryManager__c=:accOwner limit 1];
                    if(tdObj1.size()>0){
                        system.debug('tdObj'+tdObj1);
                        territoryId1 =tdObj1[0].Id;
                    }
                }
                territoryId= territoryId1;
            }
            else{
                territoryId =  OrderRequestController.getTerritory();
            }
            //Patch end
            
            if(String.isNotBlank(territoryId)){
                soObj.Region_Territory__c = territoryId;
                system.debug('territoryId'+territoryId);
            }
            Id idforsimulation;
            if(isSimulated){
                //Id recordTypeId = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Simulation').getRecordTypeId();  
                RecordType clientOnlyRecordType = [
                    SELECT Id FROM RecordType WHERE DeveloperName = 'Simulation'
                ];
                
                if( clientOnlyRecordType != null ){
                    idforsimulation = clientOnlyRecordType.Id;
                }else{
                    idforsimulation = '0120K000001HskHQAS';
                }
                soObj.RecordTypeId = idforsimulation;
            }
            
            //If Owner Id is blank or None set Owner Id to Logged In User
            String ownerId = soObj.OwnerId;
            if(String.isBlank(ownerId) || ownerId=='None'){
                soObj.OwnerId = UserInfo.getUserId();
            }
            //  system.debug('soObj.Order_Status__c'+soObj.Order_Status__c+''+soObj);
            User userObj = [Select Id, Profile.Name, Show_List_Value__c FROM User WHERE Id=:UserInfo.getUserId()];
            //If Order Status=='Draft' & Profile=='SOM' || 'SDM' set ownership of Sales Order to Logged In User
            if(soObj.Order_Status__c=='Draft'){
                
                String profileName = userObj.Profile.Name;
                if(profileName=='Brazil Sales Office Manager' || profileName=='Brazil Sales District Manager'||  profileName=='Brazil Marketing Ops Manager'){
                    soObj.OwnerId = UserInfo.getUserId();
                }
            }
            else{
                String keyOwnerId = soObj.KeyAccountDesOwnerBrazil__c;
                String profileName = userObj.Profile.Name;
                if(profileName=='Brazil Sales Office Manager' || profileName=='Brazil Sales District Manager'||  profileName=='Brazil Marketing Ops Manager'){
                    if(String.isNotBlank(keyOwnerId)){
                        soObj.OwnerId = keyOwnerId;
                    }
                }
            }
            //added by Swapnil - To assign owner as selected seller
            system.debug('1m '+soObj.OwnerId);
            system.debug('2m '+soObj.KeyAccountDesOwnerBrazil__c);
            if(userObj.Profile.Name=='Brazil Sales Person'){
                if(string.isNotBlank(soObj.KeyAccountDesOwnerBrazil__c)){
                    soObj.OwnerId = soObj.KeyAccountDesOwnerBrazil__c;
                }
            }
            //end
            //Sales_Order_Line_Item__c soiBusinessObj = OrderRequestController.getKEDE(soObj.OwnerId);
            KEDE kedeObj = new KEDE();
            //Added by GRZ(Nikhil Verma) for RITM0422585 modified 09-09-2022
            if(userObj.Profile.Name == 'Brazil Barter Manager' && TCforBarterManagerProcess != 'null' && TCforBarterManagerProcess != null && TCforBarterManagerProcess != ''){
                kedeObj = OrderRequestController.getKEDE(TCforBarterManagerProcess);
            }else{
                kedeObj = OrderRequestController.getKEDE(soObj.OwnerId);
            }
            // ---- End here Added by GRZ(Nikhil Verma) for RITM0422585 modified 09-09-2022
            if(kedeObj!=null){
                System.debug('soObj ownerId'+soObj.OwnerId);
                //added by ganesh Date:23/04/2018
                //desc:save business rule when type of order other than ORDEM FILHA.
                if(soObj.Type_of_Order__c!= 'ORDEM FILHA'){
                    soObj.Tax__c = kedeObj.tax; 
                    soObj.Freight__c = kedeObj.freight;
                }
                //end
                
                if(String.isNotBlank(kedeObj.salesDistrictManager)){
                    soObj.SalesDistrictManager__c = kedeObj.salesDistrictManager;
                }
                if(String.isNotBlank(kedeObj.BrazilMarketingOpsManager)){
                    soObj.Marketing_Ops_Manager__c = kedeObj.BrazilMarketingOpsManager;
                }
                if(String.isNotBlank(kedeObj.salesOfficeManager)){
                    soObj.SalesOfficeManager__c = kedeObj.salesOfficeManager;
                }
                if(String.isNotBlank(kedeObj.salesDirector)){
                    soObj.SalesDirector__c = kedeObj.salesDirector;
                }
                if(String.isNotBlank(kedeObj.barterManager)){
                    soObj.BarterManager__c = kedeObj.barterManager;
                }
                if(String.isNotBlank(kedeObj.brazilAnalyst)){
                    soObj.BrazilAnalyst__c = kedeObj.brazilAnalyst;
                }
                
                //added by ganesh date:12/11/2018
                //Desc:added REH and GSD to SO
                if(String.isNotBlank(kedeObj.REHManager)){
                    soObj.REH__c = kedeObj.REHManager ;
                }
                if(String.isNotBlank(kedeObj.GSDManager)){
                    soObj.GSD__c = kedeObj.GSDManager ;
                }
                //End
            }
            
            List<Sales_Org__c> salesOrgList = [Select ID FROM Sales_Org__c 
                                               WHERE NAME = 'Brazil' 
                                               OR Country_Code__c = 'BR' LIMIT 1];  //Updated by GRZ(Dheeraj Sharma) for RITM0556333 modified 18-05-2023
            
            if(!salesOrgList.isEmpty()){
                soObj.Sales_Org_lk__c = salesOrgList[0].Id;
            }
            
            //Stop Order Save if payment method = 'Barter' & Barter Manager not present in KEDE.
            if(String.isBlank(soObj.BarterManager__c) && paymentMethod == 'Barter'){
                soObj.ErrorMessage__c = 'Barter manager does not exist. Please contact System Administrator.';
                soObj.Flag_Message__c = soObj.ErrorMessage__c;
                soObj.Flag_Status__c = '';   
                owObj.soObj = soObj; 
                owObj.soiList = (List<SalesOrderItem>)JSON.deserialize(salesOrderItemString, List<SalesOrderItem>.class);
            }
            else{
                
                //Logic to query if the record Id is not a rollback record as the Id for rollback record will be invalidated
                List<Sales_Order__c> salesOrderList = [Select Id, SalesOrderNumber_Brazil__c FROM Sales_Order__c WHERE Id=:soObj.Id];
                if(salesOrderList.isEmpty()){
                    //After rollback the ID remains in the record, make it null & upsert
                    System.debug('Sales Order11: '+soObj);
                    soObj.Id = null;
                }
                soObj.Call_Process_Builder_Flow__c = false;
               system.debug('before upsert :'+soObj);
                upsert soObj;
                system.debug('after upsert :'+soObj);
                List<SalesOrderItem> salesOrderItemList = (List<SalesOrderItem>)JSON.deserialize(salesOrderItemString, List<SalesOrderItem>.class);
                
                System.debug('salesOrderItemList: '+salesOrderItemList);
                System.debug('salesOrderItemList Deserialize: '+JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class));
                
                //Assign everything to Order Wrapper after upsert.
                owObj.soiList = OrderRequestController.saveOrderItems(soObj, salesOrderItemList, salesOrgList,isSimulated); // add IsSimulated Parameter for RITM0518333 GRZ(Javed Ahmed) 14-03-2023
                system.debug('get salesOrder>>--->'+OrderRequestController.getSalesOrder(soObj.Id));
                owObj.soObj = OrderRequestController.getSalesOrder(soObj.Id);
                owObj.orderSubStatus = getOrderSubStatus(soObj.Id);
                owObj.sfdcOrderNo = [Select Id, SalesOrderNumber_Brazil__c FROM Sales_Order__c WHERE Id=:soObj.Id].SalesOrderNumber_Brazil__c;//soObj.SalesOrderNumber_Brazil__c;
                owObj.sapOrderNo = soObj.SAP_Order_Number__c;
                
                owObj.approvalList = OrderRequestController.generateData(soObj.Id);
                owObj.errorList = OrderRequestController.getErrorHistory(soObj.Id);
                //End of Logic
                
                //Check flag logic only if Rollback true
                //if(isRollback == true){
                FlagStatus fsObj = OrderRequestController.checkFlag(owObj.soObj.Id, isSimulated, owObj.soObj.Type_of_Order__c, owObj.soObj.Order_Status__c);
                owObj.soObj.Flag_Message__c = fsObj.flagMessage;
                owObj.soObj.Flag_Status__c = fsObj.flagStatus;
                //}
                
                system.debug('soObjBBB'+soObj);
                //Call Approval By Enabling Flow Checkbox 
                if(isRollback == false && owObj.soObj.Order_Status__c=='Submitted'){
                    soObj.Call_Process_Builder_Flow__c = true;
                    update soObj;
                }
                
                owObj.soObj.ErrorMessage__c = '';
                List<String> s1 = new List<String>(); // added Aditya for calling productapi for DDS Score
                s1.add(soObj.id);
                ProductCodeOutbound.SendSalesOrder(s1);
            }
        }
        catch(Exception ex){
            System.debug('ErrLine-->'+ex.getLineNumber());
            //If Exception occurrs or If Upsert Fails assign data to return wrapper object.
            soObj.ErrorMessage__c = 'Sales Order save failed. Please contact System Administrator.';
            soObj.Flag_Message__c = soObj.ErrorMessage__c;
            soObj.Flag_Status__c = ''; 
            owObj.soObj = soObj;
            owObj.soiList = (List<SalesOrderItem>)JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class);            
            owObj.exObj = ex;
            //End of Logic
            
            System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage());
            ApexLog.exceptionHandlerBrazil(ex, soObj.Sold_to_Party__c, soObj, salesOrderItemString);
        }
        
        return owObj;
    }
    
    //Method to save Order Line Items from the wrapper against the Sales Order 
    @AuraEnabled
    public static List<SalesOrderItem> saveOrderItems(Sales_Order__c soObj2, List<SalesOrderItem> salesOrderItemList, List<Sales_Org__c> salesOrgList,boolean IsSimulated){  // add IsSimulated Parameter for RITM0518333 GRZ(Javed Ahmed) 14-03-2023
        Boolean ccoFlag = false;   // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022......
        Boolean globalFlag = false;   // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022......
        List<ExchangeRate__c> exchangeRateList = [SELECT Id, ExchangeRate__c, Createddate 
                                                  FROM ExchangeRate__c  where FromCurrency__c = 'USD' AND ToCurrency__c = 'BRL' 
                                                  Order BY Createddate DESC];
        Set<String> materialCodeSet = new Set<String>();
        for(SalesOrderItem item: salesOrderItemList){
            materialCodeSet.add(item.productId);
        }
        String depotCode = [SELECT Id, Depot_Code__c FROM Account WHERE Id=:soObj2.Sold_to_Party__c].Depot_Code__c;
        String customerGroup = [SELECT Id, customer_group__c FROM Account WHERE Id=:soObj2.Sold_to_Party__c].customer_group__c;
        String ConversionFactor = [SELECT Id, Price_Conversion_Group__c FROM Account WHERE Id=:soObj2.Sold_to_Party__c].Price_Conversion_Group__c;
        system.debug('ConversionFactor in Apex1 ='+ConversionFactor);
        //Patch added by ganesh 
        //Date:7/3/2018
        //desc:to get Price book details Unite price
        /*Map<String,Decimal> PBdeatilMap = new Map<String,Decimal>();

for(Price_Book_Details__c pbdObj:[SELECT Id, Name, SKU__r.SKU_Code__c,
Price_Book__c, Sales_District1__c, Minimum_Price__c,
Sales_District1__r.Name, SKU__r.Multiple_of__c,
SKU__c, SKU__r.SKU_Description__c, 
Unit_Price__c, Monthly_Interest_Rate__c 
FROM Price_Book_Details__c 
WHERE Price_Book__c =: soObj2.Price_Book__c AND SKU__r.Active__c=True]){

PBdeatilMap.put(pbdObj.Id, pbdObj.Unit_Price__c);
}
//Patch end
*/
        system.debug('soObj2.Type_of_Order__c'+soObj2.Type_of_Order__c);
        
        
        Map<Id,Id> materialPlantMap = new Map<Id,Id>();
        
        if(soObj2.Type_of_Order__c == 'ORDEM FILHA'){
            for(Material_Plant_Relation__c mprObj: [SELECT Id, Depot__c, SKU__c, SKU__r.SKU_Code__c
                                                    FROM Material_Plant_Relation__c 
                                                    WHERE SKU__c IN: materialCodeSet 
                                                    AND Depot__c=:depotCode]){
                                                        //AND Active__c = True]){
                                                        materialPlantMap.put(mprObj.SKU__c, mprObj.Id);       
                                                    }
        }
        else{
            list<Material_Plant_Relation__c> mprList= new list<Material_Plant_Relation__c>();
            /*  start add below code for  RITM0518333 GRZ(Javed Ahmed) 14-03-2023 */
            system.debug('materialCodeSet!!!!!:'+materialCodeSet);
            system.debug('depotCode!!!!!:'+depotCode);
if(IsSimulated){
    mprList= [SELECT Id, Depot__c, SKU__c, SKU__r.SKU_Code__c
    FROM Material_Plant_Relation__c 
    WHERE SKU__c IN: materialCodeSet];
}else{
    mprList=[SELECT Id, Depot__c, SKU__c, SKU__r.SKU_Code__c
    FROM Material_Plant_Relation__c 
    WHERE SKU__c IN: materialCodeSet 
    AND Depot__c=:depotCode
    AND Active__c = True];
}
system.debug('mprList!!!:'+mprList);
system.debug('mprListsize!!!:'+mprList.size());
     /*  end add below code for  RITM0518333 GRZ(Javed Ahmed) 14-03-2023 */         
for(Material_Plant_Relation__c mprObj: mprList){
                                                        system.debug('mprObj:'+mprObj);
                                                        //commented by ganesh Date:19/10/2018 
                                                        //desc:requested in CR to show inactive product to if mother selected at the time of creation
                                                        //WHERE Depot__r.Depot_Code__c =: soObj2.Depot_Code__c]){
                                                        materialPlantMap.put(mprObj.SKU__c, mprObj.Id);                                         
                                                    }
        }
        //System.debug('soObj2.Parent_Order_Simulated__c'+soObj2.Parent_Order_Simulated__c);
        //System.debug('materialPlantMap: '+materialPlantMap);
        System.debug('salesOrderItemList>'+salesOrderItemList);
        
        //For Item Number maintenance on Order reload, while saving items delete & re-insert all line items.
        delete [SELECT Id FROM Sales_Order_Line_Item__c WHERE Sale_Order__c=:soObj2.Id];
        
        
        //Sales_Order_Line_Item__c soiBusinessObj = OrderRequestController.getKEDE(soObj2.OwnerId);
        KEDE kedeObj = OrderRequestController.getKEDE(soObj2.OwnerId);
        //System.debug('kedeObj'+kedeObj);
        
        Map<String,Id> cultureMap = new Map<String,Id>();
        for(Culture__c culObj:[SELECT Id, Name, Culture_Code__c, 
                               Culture_Desc__c, Division__c, Sales_Org__c 
                               FROM Culture__c 
                               WHERE Active__c=True 
                               ORDER BY Culture_Code__c]){
                                   
                                   cultureMap.put(culObj.Culture_Desc__c, culObj.Id);
                               }
        
        List<Sales_Order_Line_Item__c> soiList = new List<Sales_Order_Line_Item__c>();
        
        Integer i = 0;
        
        //Added by Swapnil
        Map<string,Customer_Conversion_factor__c> MapCCF = new Map<string,Customer_Conversion_factor__c>();
        for (Customer_Conversion_factor__c DM: [select id, Conversion_Factor__c, Customer_Group__c,
                                                Sales_Org__c, Combination_Key__c,Brand_Name__c
                                                from Customer_Conversion_factor__c]){
                                                    MapCCF.put(DM.Customer_Group__c+DM.Brand_Name__c, DM);  //Updated by Divya for SCTASK0486924 
                                                }
        
        //Added by Swapnil
        Map<string,Discount_Matrix__c> MapDM = new Map<string,Discount_Matrix__c>();
        for (Discount_Matrix__c DM: [select id, Brand_Name__c, BU_Manager__c,
                                     Sales_Director__c, Sales_District_Manager__c,
                                     Sales_Person__c from Discount_Matrix__c]){
                                         MapDM.put(DM.Brand_Name__c, DM);   //Updated by Divya for SCTASK0486924
                                     }
        //end
        Map<Decimal,Decimal> kitItemNumberMap = new Map<Decimal,Decimal>();//Modified by Deeksha for kit selling Project
        Map<Decimal, String> kitSKUMap = new Map<Decimal, String>();//Modified by Deeksha for kit selling Project
        for(SalesOrderItem item: salesOrderItemList){
            system.debug('soObj2.Id'+soObj2);
            system.debug('item>>--->'+item);
            Sales_Order_Line_Item__c soiObj = new Sales_Order_Line_Item__c();
            i = i+10;
            soiObj.Item_Number__c = i;
            soiObj.Sale_Order__c = soObj2.Id;
            soiObj.Product_Category__c = item.skuCategory;
            soiObj.SelloutPrice__c = item.selloutprice; //added by Krishanu@wipro
            soiObj.Item_Category__c = item.itemCategory;//Modified by Deeksha for kit selling Project
            soiObj.Round__c = item.round;//Modified by Deeksha for kit selling Project
            soiObj.Cancellation_Reason__c = item.cancellationReason;//Added by Bhavika 7 Feb 2023
            
            system.debug('fatDate'+item.fatDate);
            try{
                system.debug('item.fatDate'+item.fatDate);
                soiObj.DateofFAT__c = Date.valueOf(item.fatDate);
            }
            catch(Exception ex){
                system.debug('items.fatDate'+item.fatDate);
                soiObj.DateofFAT__c = Date.parse(item.fatDate); 
            }
            
            //Modified by Deeksha for kit selling Project
            soiObj.SKU_Name__c = item.productId;
            soiObj.Kit_Product__c = item.kitProduct;
            if(soObj2.Kit_Order__c){
                if(item.kitProduct){
                    //soiObj.Kit_SKU__c = item.productId;
                    kitItemNumberMap.put(item.kitNo, soiObj.Item_Number__c);
                    kitSKUMap.put(item.kitNo,item.productId);
                }else{
                    if(kitItemNumberMap.containsKey(item.refKitNo) && kitSKUMap.containsKey(item.refKitNo)){
                        soiObj.Kit_Item_Number__c = kitItemNumberMap.get(item.refKitNo);
                        soiObj.Kit_SKU__c = kitSKUMap.get(item.refKitNo);
                    }
                    
                }
            }
            //End
            soiObj.SKU_Name__c = item.productId;
            soiObj.UnitValue__c = item.unitValue;
            if(item.budgetValue!= null){
                soiObj.BudgetPrice__c = item.budgetValue; //added by ganesh Date:13/11/2018
            }
            
            
            //end
            //
            soiObj.MinValue__c =item.minValue;  //added by ganesh Date:16/5/18 
            
            soiObj.InterestRate__c = item.interestRate;
            soiObj.Quantity__c = item.qty;
            soiObj.UnitValuewithInterest__c = item.unitValueWithInterest;
            //soiObj.TotalValuewithInterest__c = item.totalValueWithInterest;
            //Patch Added By Swapnil - To Calculate Customer Conversion Factor, Updated by Divya for SCTASK0486924
            if(MapCCF.containskey(ConversionFactor+item.brand)){
                if(string.isNotBlank(string.valueOf(MapCCF.get(ConversionFactor+item.brand).Conversion_Factor__c))){
                    soiObj.Customer_Conversion_Factor__c = MapCCF.get(ConversionFactor+item.brand).Conversion_Factor__c;//added by Swapnil
                }
                else{
                    soiObj.Customer_Conversion_Factor__c = 1; 
                }
            }
            else{
                soiObj.Customer_Conversion_Factor__c = 1;
            }
            //end
            soiObj.Time_in_months__c = item.timeInMonths;
            soiObj.Days__c = item.days;
            system.debug('soiObj.Days__c=='+soiObj.Days__c);
            system.debug('soiObj.Days__c=='+item.days);
            soiObj.Recommended_price__c=item.Recommendedprice;  // added by Sagar for DDS score 
            soiObj.DDS_Grade__c=item.DDSGrade;  // added by Sagar for DDS score 
            if(item.priceBookDetailId!= '' && item.priceBookDetailId != null && !item.kitProduct)////Modified by Deeksha for kit selling Project
            {soiObj.PriceBookDetail__c = item.priceBookDetailId;}
            soiObj.multipleOf__c = item.multipleOf; // added by Nik on 10/05/2019...
            /* commented by ganesh
//System.debug('PBdeatilMap'+PBdeatilMap);

if(PBdeatilMap.containsKey(item.priceBookDetailId)){
soiObj.UnitPriceonPriceBookDetail__c =PBdeatilMap.get(item.priceBookDetailId);
//System.debug('soiObj.UnitPriceonPriceBookDetail__c'+soiObj.UnitPriceonPriceBookDetail__c);
}*/
            soiObj.CurrencyIsoCode = soObj2.CurrencyIsoCode;
            soiObj.MO_Item_No__c = item.moItemNo;
            if(cultureMap.containsKey(item.cultureDesc)){
                soiObj.Culture__c = cultureMap.get(item.cultureDesc);
            }
            
            if(!salesOrgList.isEmpty()){
                soiObj.Sales_Org__c = salesOrgList[0].Id;
            }
            if(!soObj2.Kit_Order__c || (soObj2.Kit_Order__c && !item.kitProduct)){ //Modified by Deeksha for kit selling Project
                if(materialPlantMap.containsKey(item.productId)){
                    soiObj.MaterialPlantRelation__c = materialPlantMap.get(item.productId);
                }
                else{
                    CalloutException e = new CalloutException();
                    e.setMessage('?Material   ID not found: '+item.productId);
                    //soObj2.ErrorMessage__c = '?Material Plant ID not found: '+item.productId;
                    throw e;
                }
            }
            if(!exchangeRateList.isEmpty()){
                soiObj.ExchangeRate__c = exchangeRateList[0].Id;
                //System.debug('soiObj.ExchangeRate__c'+soiObj.ExchangeRate__c);
            }
            //added by ganesh date:28/5/18 
            //desc : reload Line item when simulating existing SO
            if(String.isNotBlank(item.orderItemId)){
                soiObj.Sales_Order_Line_Item__c = item.orderItemId;
            } 
            //System.debug('edit from existing SO:-'+soObj2.Parent_Order_Simulated__c);
            
            soiObj.Product_PO_item_number__c = item.POItemNumber;//Deeksha SCTASK0216504
            
            RecordType clientOnlyRecordType = [
                SELECT Id FROM RecordType WHERE DeveloperName = 'Simulation'
            ];
            Id idforsimulation;
            if( clientOnlyRecordType != null ){
                idforsimulation = clientOnlyRecordType.Id;
            }else{
                idforsimulation = '0120K000001HskHQAS';
            }
            
            //if(soObj2.RecordTypeId == Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Simulation').getRecordTypeId() && soObj2.Parent_Order_Simulated__c!=null){
            if(soObj2.RecordTypeId == idforsimulation && soObj2.Parent_Order_Simulated__c!=null){
                Sales_Order_Line_Item__c soliKEDE = [select Id,ListPriceDiscount__c, ListPriceDiscount_1__c,ListPriceDiscount_2__c,ListPriceDiscount_3__c,ListPriceDiscount_4__c,
                                                     TotalOrderMargin__c,TotalOrderMargin_1__c,TotalOrderMargin_2__c,TotalOrderMargin_3__c,ExchangeRate__c,TotalOrderMargin_4__c,
                                                     SalesDistrictManager__c,Marketing_Ops_Manager__c, SalesOfficeManager__c,SalesDirector__c,REH__c,Tax__c,Freight__c
                                                     FROM Sales_Order_Line_Item__c where Sale_Order__c=:soObj2.Parent_Order_Simulated__c limit 1];
                
                
                if(soliKEDE!=null){
                    soiObj.ExchangeRate__c = soliKEDE.ExchangeRate__c;
                    //soiObj.SalesPerson__c = kedeObj.salesPerson;
                    soiObj.TotalOrderMargin__c = soliKEDE.TotalOrderMargin__c;
                    soiObj.ListPriceDiscount__c = soliKEDE.ListPriceDiscount__c;                
                    soiObj.Tax__c = soliKEDE.Tax__c; 
                    soiObj.Freight__c = soliKEDE.Freight__c;
                    
                    if(String.isNotBlank(soliKEDE.SalesDistrictManager__c)){
                        soiObj.SalesDistrictManager__c = soliKEDE.SalesDistrictManager__c;                    
                        soiObj.TotalOrderMargin_1__c = soliKEDE.TotalOrderMargin_1__c;
                        soiObj.ListPriceDiscount_1__c = soliKEDE.ListPriceDiscount_1__c;
                        
                    }
                    if(String.isNotBlank(soliKEDE.Marketing_Ops_Manager__c)){
                        soiObj.Marketing_Ops_Manager__c = soliKEDE.Marketing_Ops_Manager__c;                    
                        soiObj.TotalOrderMargin_1__c = soliKEDE.TotalOrderMargin_1__c;
                        soiObj.ListPriceDiscount_1__c = soliKEDE.ListPriceDiscount_1__c;
                        
                    }
                    
                    
                    if(String.isNotBlank(soliKEDE.SalesOfficeManager__c)){
                        soiObj.SalesOfficeManager__c = soliKEDE.SalesOfficeManager__c;
                        soiObj.TotalOrderMargin_2__c = soliKEDE.TotalOrderMargin_2__c;
                        soiObj.ListPriceDiscount_2__c = soliKEDE.ListPriceDiscount_2__c;
                    }
                    if(String.isNotBlank(soliKEDE.SalesDirector__c)){
                        soiObj.SalesDirector__c = soliKEDE.SalesDirector__c;
                        soiObj.TotalOrderMargin_3__c = soliKEDE.TotalOrderMargin_3__c;
                        soiObj.ListPriceDiscount_3__c = soliKEDE.ListPriceDiscount_3__c;
                    }
                    if(String.isNotBlank(soliKEDE.REH__c)){
                        soiObj.REH__c = soliKEDE.REH__c;
                        soiObj.TotalOrderMargin_4__c = soliKEDE.TotalOrderMargin_4__c;
                        soiObj.ListPriceDiscount_4__c = soliKEDE.ListPriceDiscount_4__c;
                    }
                }   
                //System.debug('soliKEDE'+soliKEDE+'solist'+soiList);
            }
            else if(kedeObj!=null){
                system.debug('kedeObj'+kedeObj);
                system.debug('kedeObj.REH_TotalOrderMargin4;'+kedeObj.REH_TotalOrderMargin4);
                //soiObj.SalesPerson__c = kedeObj.salesPerson;
                soiObj.TotalOrderMargin__c = kedeObj.SP_TotalOrderMargin;
                //soiObj.ListPriceDiscount__c = kedeObj.SP_ListPriceDiscount;
                //system.debug('Brand'+soiObj.SKU_Name__r.brand_name__c);
                //added by Swapnil
                system.debug('Sales_Person__c'+(item.brand));  
                if(!item.kitProduct){//Modified by Deeksha for kit selling Project
                    system.debug('Sales_Person__c'+MapDM.get(item.brand).Sales_Person__c);                
                    soiObj.ListPriceDiscount__c = MapDM.get(item.brand).Sales_Person__c;
                }
                soiObj.Tax__c = kedeObj.tax; 
                soiObj.Freight__c = kedeObj.freight;
                
                if(String.isNotBlank(kedeObj.salesDistrictManager)){
                    soiObj.SalesDistrictManager__c = kedeObj.salesDistrictManager;                    
                    soiObj.TotalOrderMargin_1__c = kedeObj.SDM_TotalOrderMargin1;
                    if(String.isNotBlank(kedeObj.BrazilMarketingOpsManager)){
                        soiObj.Marketing_Ops_Manager__c = kedeObj.BrazilMarketingOpsManager;    
                    }
                    //Update by Swapnil
                    //soiObj.ListPriceDiscount_1__c = kedeObj.SDM_ListPriceDiscount1;
                    if(!item.kitProduct){//Modified by Deeksha for kit selling Project
                        soiObj.ListPriceDiscount_1__c = MapDM.get(item.brand).Sales_District_Manager__c
                            +MapDM.get(item.brand).Sales_Person__c;
                    }
                }
                
                if(String.isNotBlank(kedeObj.salesOfficeManager)){
                    soiObj.SalesOfficeManager__c = kedeObj.salesOfficeManager;
                    soiObj.TotalOrderMargin_2__c = kedeObj.SOM_TotalOrderMargin2;
                    //Update by Swapnil
                    //soiObj.ListPriceDiscount_2__c = kedeObj.SOM_ListPriceDiscount2;
                    if(!item.kitProduct){//Modified by Deeksha for kit selling Project
                        soiObj.ListPriceDiscount_2__c = MapDM.get(item.brand).BU_Manager__c
                            + MapDM.get(item.brand).Sales_District_Manager__c
                            + MapDM.get(item.brand).Sales_Person__c;
                    }
                }
                if(String.isNotBlank(kedeObj.salesDirector)){
                    soiObj.SalesDirector__c = kedeObj.salesDirector;
                    soiObj.TotalOrderMargin_3__c = kedeObj.SD_TotalOrderMargin3;
                    //Update by Swapnil
                    //soiObj.ListPriceDiscount_3__c = kedeObj.SD_ListPriceDiscount3;
                    if(!item.kitProduct){//Modified by Deeksha for kit selling Project
                        soiObj.ListPriceDiscount_3__c = MapDM.get(item.brand).Sales_Director__c
                            + MapDM.get(item.brand).BU_Manager__c
                            + MapDM.get(item.brand).Sales_District_Manager__c
                            + MapDM.get(item.brand).Sales_Person__c;
                    }
                }
                
                if(String.isNotBlank(kedeObj.REHManager)){
                    soiObj.REH__c = kedeObj.REHManager;
                    soiObj.TotalOrderMargin_4__c = kedeObj.REH_TotalOrderMargin4;
                    soiObj.ListPriceDiscount_4__c = kedeObj.REH_ListPriceDiscount4;
                }
                System.debug('soiList1'+soiObj);
            }
            
            /* ************************************* SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start ************************************************ */
            
            soiObj.Sales_Deduction_Budget__c = item.salesDeductionCost;
            soiObj.Discount1__c = item.cogsCost;
            soiObj.E2E_Cost__c = item.e2eCost;
            if(item.isBlanket == true){
                soiObj.Blanket_SKU_End_Date__c = Date.valueOf(item.blnkt_EndDate);
                soiObj.Blanket_SKU_Start_Date__c = Date.valueOf(item.blnkt_StartDate);
                soiObj.Blanket_SKU_Status__c = item.blnkt_Status;
            }
            
            soiObj.Level_1_max__c = item.level1Max;
            soiObj.Level_1_min__c = item.level1Min;
            soiObj.Level_2_max__c = item.level2Max;
            soiObj.Level_2_min__c = item.level2Min;
            soiObj.Level_3_below__c = item.level3Below;
            soiObj.Approval_Level__c = item.approvalLevel;
            soiObj.UOM__c = item.uom;
            soiObj.Base_UOM__c = item.baseUOM;
            soiObj.Converted_Qty__c = item.convertedQnty;
            soiObj.Converted_Net_Price__c = item.convertedNetPrice;
            soiObj.Sales_Deduction_Cal__c = item.salesDeductionCal;
            soiObj.Discount_Cal__c = item.cogsCostCal;
            soiObj.E2E_Cost_Cal__c = item.e2eCostCal;
            soiObj.Margin_Block_Level_1__c = item.mbLevel1;
            soiObj.Margin_Block_Level_2__c = item.mbLevel2;
            soiObj.Contribution_Margin__c = item.contMargin;
            
            if(item.mbLevel1 == true){
                ccoFlag = true;
            }
            /* if(item.mbLevel1 == true && item.mbLevel2 == true){
globalFlag = true;                // Update by Dheeraj RITM0502271 Comment due to order not want sent to go in global CCO Step
} */
            /* ************************************* SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End ************************************************ */
            
            soiList.add(soiObj);
        }
        
        if(!soiList.isEmpty()){
            insert soiList;
            /* ************************* SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start ********************* */
            soObj2.Sent_for_CCO__c = false;
            soObj2.Sent_for_Latam_Director_Approval__c = false;
            if(soObj2.AVEC_Order__c == false){ // SKI(Nik) added if statement only for AVEC order...on 04-10-2022...
                if(ccoFlag == true){
                    soObj2.Sent_for_Latam_Director_Approval__c = true;
                }
                if(globalFlag == true){
                    soObj2.Sent_for_CCO__c = true;
                }
            }
            
            update soObj2;
            /* ************************* SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End ********************** */
        }
        
        return getSalesOrderItems(soObj2.Id);
    }
    
    //Method to Get Sales Order Mother records
    @AuraEnabled
    public static List<Sales_Order__c> getSOM(String currentValue, String TerritoryCode){
        //  public static List<Sales_Order__c> getSOM(){
        String territoryId ='';
        String territoryId1 = '';
        String territorycd1 = '';
        String regionID = '';
        //Added by ganesh Date:11_10_2018
        // desc:get territory id when SDM placing child order behalf of Selected User
        if(String.isNotBlank(currentValue) && currentValue!=null){ 
            if(String.isNotBlank(TerritoryCode) && TerritoryCode!=null){
                territoryId1=[SELECT Id,Region__c
                              FROM Territory_Distributor__c 
                              WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                              AND TerritoryManagerActive__c = false
                              AND TerritoryCode__c=:TerritoryCode limit 1].Region__c;
                
                territoryId= territoryId1; 
                system.debug('territoryId'+territoryId);
            }else{
                list<Territory_Distributor__c> tdi=[SELECT Id,Region__c,TerritoryCode__c 
                              FROM Territory_Distributor__c 
                              WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                              AND TerritoryManagerActive__c = True
                              AND TerritoryManager__c=:currentValue limit 1];
               territoryId1=tdi[0].Region__c;
               territorycd1=tdi[0].TerritoryCode__c;//Updated for RITM0546479 GRZ(Gurubaksh Grewal) 17-0-2023
                system.debug('territoryId1'+territoryId1+'TerritoryCode'+TerritoryCode);
                territoryId= territoryId1;
            }
        }else{
            // territoryId = OrderRequestController.getTerritory();
            List<String> regionList = OrderRequestController.getRegion();
            system.debug('regionList-----'+regionList);
            if(regionList.size() > 0) {
                territoryId = regionList[0];
            }
        }
        
        //Patch End
        //Added By Ganesh DAte:2/6/18
        //Desc:Get all The SOM from System and filter by Customer group of SP
        // territoryId = OrderRequestController.getTerritory();
        Set<String> SpCustomerGroupSet = new Set<String>();
        List<string> SpCustomerGroup001List = new List<String>();
        
        String territorycd='';
       /********start add below code for RITM0541352 GRZ(Javed Ahmed) 21-04-2023 */
        string profileName='';
        List<Profile> profileNameList = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        if(profileNameList.size()>0){
        profileName=profileNameList[0].Name;
         }

        List<Territory_Distributor__c> terCode= new list<Territory_Distributor__c>();
        if(profileName=='Brazil Sales District Manager'){
            terCode= [SELECT id,name ,Regional_Manager__c , Region__r.RegionCode__c,TerritoryCode__c, TerritoryManager__r.Name from Territory_Distributor__c where (TerritoryManager__c=:currentValue or TerritoryCode__c=:TerritoryCode) limit 1]; //Added  TerritoryCode conditions for INC0479142 GRZ(Dheeraj Sharma) 25-05-2023 
        /********end for RITM0541352 GRZ(Javed Ahmed) 21-04-2023 */
        }else{
            terCode  = [SELECT id,name ,Regional_Manager__c , Region__r.RegionCode__c,TerritoryCode__c, TerritoryManager__r.Name from Territory_Distributor__c where TerritoryManager__c=: Userinfo.getUserId() limit 1];
        }
       
        if(terCode.size()>0){																																	 //Added  conditions for RITM0538180 GRZ(Dheeraj Sharma) 17-04-2023 
             territorycd=terCode[0].TerritoryCode__c;   
        }
                                                                                                                     
        //changed added by Ganesh Date:4/2/2019
        //Desc:Based on currentvalue fetch CustRegion
        if(TerritoryCode==null){
            for(Customer_and_Region_Mapping__c CustRegion:[select id,CustomerRegion__c,Customer_Group__c,Customer_Name__c from Customer_and_Region_Mapping__c
                                                           where Account_Active__c = True
                                                           //AND Active__c = True AND CustomerRegion__r.Region__c =: territoryId AND CustomerRegionCode__c=:territorycd]){  //Updated  conditions for RITM0538180 GRZ(Dheeraj Sharma) 17-04-2023 
                                                           AND Active__c = True AND (CustomerRegionCode__c=:territorycd1 OR CustomerRegionCode__c=:territorycd)]){  //Updated  conditions for RITM0546479 GRZ(Gurubaksh Grewal) 17-0-2023 
                                                               if(CustRegion.Customer_Group__c=='001'){
                                                                   SpCustomerGroup001List.add(CustRegion.Customer_Name__c);
                                                               }
                                                               SpCustomerGroupSet.add(CustRegion.Customer_Group__c); 
                                                               system.debug('CustRegion.Id'+CustRegion.Id);
                                                           }
        }else{
            for(Customer_and_Region_Mapping__c CustRegion:[select id,CustomerRegion__c,Customer_Group__c,Customer_Name__c from Customer_and_Region_Mapping__c
                                                           where Account_Active__c = True
                                                           AND Active__c = True AND CustomerRegion__r.Region__c =: territoryId AND CustomerRegionCode__c=:territorycd]){     //Updated  conditions for RITM0538180 GRZ(Dheeraj Sharma) 17-04-2023
                                                               if(CustRegion.Customer_Group__c=='001'){
                                                                   SpCustomerGroup001List.add(CustRegion.Customer_Name__c);
                                                               }
                                                               SpCustomerGroupSet.add(CustRegion.Customer_Group__c); 
                                                               system.debug('CustRegion.Id'+CustRegion.Id+'CustRegion.Customer_Group__c'+CustRegion.Customer_Group__c);
                                                           }
            
        }
        //Chaned End
        System.debug('SpCustomerGroup001List'+SpCustomerGroup001List); 
        system.debug('size'+SpCustomerGroup001List.size());
        System.debug('SpCustomerGroupSet'+SpCustomerGroupSet);
        //System.debug('territoryId'+territoryId);
        //added Internal_OBS__c, Sales_order_OBS__c in query by Harshit@wipro
        // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... ...Added two fields to query..Sent_for_CCO__c, Sent_for_Latam_Director_Approval__c, Total_Overall_Margin__c....
        // GRZ(Nikhil Verma) added Business_Discount__c field RITM0419745 date 19-09-2022
        Map<Id, Sales_Order__c> somMap = new Map<Id, Sales_Order__c>([SELECT Id, Sales_Order__c,BrazilSalesOrderStatus__c,Name,Business_Discount__c, Order_Status__c, SAP_Order_Number__c, Sold_to_Party__r.Name, SalesOrderNumber_Brazil__c, Tax__c, Freight__c,
                                                                      Currency_Brazil__c, CurrencyISOCode, PaymentMethod__c, Price_Book__c, Price_Book__r.Name, Price_Book__r.Interest_Date__c,Price_Book__r.Sales_Order_Block_Date__c,
                                                                      Punctuality_Discount__c,Use_Campaign__c, Campaign_Type__c, Sent_for_CCO__c, Sent_for_Latam_Director_Approval__c, 
                                                                      Sold_to_Party__r.Customer_Group__c, Sold_to_Party__r.BillingCity, Maturity_Date__c, Total_Overall_Margin__c, 
                                                                      Sold_to_Party__r.BillingState, Region__c, Type_of_Order__c, ReloadPaymentTerms__c, OrderQuantity__c,
                                                                      Campaign_Payment_Term_Date__c,Payment_Term__c,Directed_Sales__c,Invoice_Message__c,Internal_OBS__c, Sales_order_OBS__c,SalesOrderReplacementMargin__c,AVEC_Order__c,TotalTax__c,TotalFreight__c,TotalPunctuality__c,TotalReplacementCost__c,(select id,name,Item_Status__c,SKU_Name__c,quantity__c from Sales_Order_Line_Item__r )
                                                                      FROM Sales_Order__c
                                                                      WHERE Sold_to_Party__r.Sales_Org_Country__c='Brazil' 
                                                                      AND Type_of_Order__c = 'CONTRATO MÃE'
                                                                      AND SAP_Order_Number__c!=''
                                                                      AND BrazilSalesOrderStatus__c != 'Cancelled'
                                                                      AND BrazilSalesOrderStatus__c != 'Cancelado'
                                                                      AND BrazilSalesOrderStatus__c != 'Blocked'
                                                                      AND BrazilSalesOrderStatus__c != 'Bloqueada'
                                                                      AND OrderQuantity__c > 0
                                                                      //Below line added by Sirisha@Wipro
                                                                      AND Order_Status__c != 'Cancelled'
                                                                   
                                                                      AND Valid_From__c <= TODAY 
                                                                      AND Valid_To__c >= TODAY
                                                                      AND CreatedDate >=LAST_N_FISCAL_YEARS:1  // Updated  conditions for RITM0561638 GRZ(Dheeraj Sharma) 31-05-2023
                                                                      AND Sold_to_Party__r.Customer_Group__c IN :SpCustomerGroupSet]);
        //AND Region_Territory__c =: territoryId 
        System.debug('somMap0'+somMap);
        
        
        // Added below conditions for INC0434718 GRZ(Dheeraj Sharma) 20-01-2023
        map<string,decimal> checkQnty = new map<string,decimal>();
        
        for(Sales_Order__c so:somMap.values()){
            Decimal val = 0;
            for(Sales_order_line_item__c sitms : so.Sales_Order_Line_Item__r){
                val = val + sitms.quantity__c;
            }
            checkQnty.put(so.id,val);
            if(so.Sold_to_Party__r.Customer_Group__c=='001'){
                System.debug('so.Sold_to_Party__c'+so.Id);
                if(!SpCustomerGroup001List.contains(so.Sold_to_Party__c)){
                    System.debug('not Contain '+so.Id);
                    somMap.remove(so.Id);
                }
            }
        }                                               
        //Patch End                                                              
        System.debug('somMap'+somMap);
        
        AggregateResult[] groupedResults = [SELECT Sales_Order__c, SUM(OrderQuantity__c) used
                                            FROM Sales_Order__c
                                            WHERE Sales_Order__c IN: somMap.keySet()
                                            AND BrazilSalesOrderStatus__c!='Cancelled'
                                            AND BrazilSalesOrderStatus__c!='Cancelado'
                                            AND BrazilSalesOrderStatus__c!='Draft'
                                            AND BrazilSalesOrderStatus__c!='Simulado' AND CREATEDDATE>LAST_N_FISCAL_YEARS:2
                                            GROUP BY Sales_Order__c];
        
        System.debug('somAccount'+groupedResults);
        
        for(AggregateResult ar : groupedResults){
            String somId = String.valueOf(ar.get('Sales_Order__c'));
            String used = String.valueOf(ar.get('used'));
            
            if(somMap.containsKey(somId)){
                //Decimal moQty = somMap.get(somId).OrderQuantity__c;
                Decimal moQty = 0;
                if(checkQnty.containskey(somMap.get(somId).id)){      // updated for INC0434718 GRZ(Dheeraj Sharma) 20-01-2023
                    moQty = checkQnty.get(somMap.get(somId).id);       // updated for INC0434718 GRZ(Dheeraj Sharma) 20-01-2023
                } 
                Decimal chQty = Decimal.valueOf(used);
                
                if(chQty >= moQty){
                    somMap.remove(somId);
                }
            }
        } 
        System.debug('somValue'+somMap.values());
        return somMap.values();
    }   
    //CREATED METHOD WHEN TYPE OF ORDER IS BONIFICATION BY HARSHIT&ANMOL@WIPRO FOR (US SO-011) ---START
    
    @AuraEnabled
    public static List<Sales_Order__c> typeofOrderBonification(String currentValue, String TerritoryCode){
        
        
        //List<Budget_For_Bonification__c> budgetBonification
        /* List<Sales_Order__c> typeBonification=[Select id,SAP_Order_Number__c,Sold_to_Party__r.Customer_Group__c,BrazilSalesOrderStatus__c
from Sales_Order__c
where BrazilSalesOrderStatus__c='Approved'
and SAP_Order_Number__c!=null
and (Type_of_Order__c='VENDA NORMAL' or Type_of_Order__c='ORDEM FILHA')
];


*/
        
        
        //  public static List<Sales_Order__c> getSOM(){
        String territoryId ='';
        String territoryId1 = '';
        String regionID = '';
        //Added by ganesh Date:11_10_2018
        // desc:get territory id when SDM placing child order behalf of Selected User
        if(String.isNotBlank(currentValue) && currentValue!=null){ 
            if(String.isNotBlank(TerritoryCode) && TerritoryCode!=null){
                territoryId1=[SELECT Id,Region__c
                              FROM Territory_Distributor__c 
                              WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                              AND TerritoryManagerActive__c = false
                              AND TerritoryCode__c=:TerritoryCode limit 1].Region__c;
                
                territoryId= territoryId1; 
                system.debug('territoryId'+territoryId);
            }else{
                territoryId1=[SELECT Id,Region__c
                              FROM Territory_Distributor__c 
                              WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                              AND TerritoryManagerActive__c = True
                              AND TerritoryManager__c=:currentValue limit 1].Region__c;
                
                system.debug('territoryId1'+territoryId1+'TerritoryCode'+TerritoryCode);
                territoryId= territoryId1;
            }
        }else{
            // territoryId = OrderRequestController.getTerritory();
            List<String> regionList = OrderRequestController.getRegion();
            // system.debug('regionList-----'+regionList);
            territoryId = regionList[0];
        }
        
        //Patch End
        //Added By Ganesh DAte:2/6/18
        //Desc:Get all The SOM from System and filter by Customer group of SP
        // territoryId = OrderRequestController.getTerritory();
        Set<String> SpCustomerGroupSet = new Set<String>();
        List<string> SpCustomerGroup001List = new List<String>();
        
        
        //changed added by Ganesh Date:4/2/2019
        //Desc:Based on currentvalue fetch CustRegion
        if(TerritoryCode==null){
            for(Customer_and_Region_Mapping__c CustRegion:[select id,CustomerRegion__c,Customer_Group__c,Customer_Name__c from Customer_and_Region_Mapping__c
                                                           where Account_Active__c = True
                                                           AND Active__c = True AND CustomerRegion__r.Region__c =: territoryId]){
                                                               if(CustRegion.Customer_Group__c=='001'){
                                                                   SpCustomerGroup001List.add(CustRegion.Customer_Name__c);
                                                               }
                                                               SpCustomerGroupSet.add(CustRegion.Customer_Group__c);
                                                               //SpCustomerGroupSet.add(CustRegion.Customer_Name__c);
                                                               system.debug('CustRegion.Id'+CustRegion.Id);
                                                           }
        }else{
            for(Customer_and_Region_Mapping__c CustRegion:[select id,CustomerRegion__c,Customer_Group__c,Customer_Name__c from Customer_and_Region_Mapping__c
                                                           where Account_Active__c = True
                                                           AND Active__c = True AND CustomerRegion__r.Region__c =: territoryId]){
                                                               if(CustRegion.Customer_Group__c=='001'){
                                                                   SpCustomerGroup001List.add(CustRegion.Customer_Name__c);
                                                               }
                                                               SpCustomerGroupSet.add(CustRegion.Customer_Group__c); 
                                                               // SpCustomerGroupSet.add(CustRegion.Customer_Name__c); 
                                                               system.debug('CustRegion.Id'+CustRegion.Id+'CustRegion.Customer_Group__c'+CustRegion.Customer_Group__c);
                                                           }
            
        }
        //Chaned End
        System.debug('SpCustomerGroup001List'+SpCustomerGroup001List); 
        system.debug('size'+SpCustomerGroup001List.size());
        System.debug('SpCustomerGroupSet'+SpCustomerGroupSet);
        //System.debug('territoryId'+territoryId);
        DateTime dt = DateTime.newInstance(2021, 4, 01);
        // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... ...Added two fields to query..Sent_for_CCO__c, Sent_for_Latam_Director_Approval__c, Total_Overall_Margin__c....
        Map<Id, Sales_Order__c> bonificationMap = new Map<Id, Sales_Order__c>([SELECT Id, Name, SAP_Order_Number__c, Sold_to_Party__r.Name, SalesOrderNumber_Brazil__c, Tax__c, Freight__c,
                                                                               Currency_Brazil__c, CurrencyISOCode, PaymentMethod__c, Price_Book__c, Price_Book__r.Name, Price_Book__r.Interest_Date__c,Price_Book__r.Sales_Order_Block_Date__c,
                                                                               Punctuality_Discount__c,Use_Campaign__c, Campaign_Type__c, Sent_for_CCO__c, Sent_for_Latam_Director_Approval__c, 
                                                                               Sold_to_Party__r.Customer_Group__c, Sold_to_Party__r.BillingCity, Maturity_Date__c, Total_Overall_Margin__c, 
                                                                               Sold_to_Party__r.BillingState, Region__c, Type_of_Order__c, ReloadPaymentTerms__c, OrderQuantity__c,
                                                                               Campaign_Payment_Term_Date__c,Payment_Term__c,Directed_Sales__c,Invoice_Message__c,Internal_OBS__c, Sales_order_OBS__c,avec_order__c
                                                                               FROM Sales_Order__c 
                                                                               WHERE Sold_to_Party__r.Sales_Org_Country__c='Brazil' 
                                                                               
                                                                               
                                                                               And (Type_of_Order__c='VENDA NORMAL' or Type_of_Order__c='ORDEM FILHA')
                                                                               
                                                                               AND SAP_Order_Number__c!=''
                                                                               //Rakesh K G Wipro Ticket number : RITM0389990.
                                                                               //Removed the Order_Status__c = 'Approved' and Updated BrazilSalesOrderStatus__c = 'Approved' ie if the below condition is true then its brazil sales order status = 'Approved'
                                                                               AND (Order_Status__c = 'Not yet processed' OR Order_Status__c='Partially processed' OR Order_Status__c = 'Completly processed' 
                                                                                    OR Order_Status__c='In Transit' OR Order_Status__c = 'Error from SAP' OR Order_Status__c='Approved')
                                                                               AND CreatedDate >=: dt
                                                                               AND Sold_to_Party__r.Customer_Group__c IN :SpCustomerGroupSet
                                                                               //And SAP_Order_Number__c!=null
                                                                              ]);
        //AND Region_Territory__c =: territoryId 
        
        
        //AND Region_Territory__c =: territoryId 
        System.debug('bonificationMap'+bonificationMap);
        
        for(Sales_Order__c so:bonificationMap.values()){
            if(so.Sold_to_Party__r.Customer_Group__c=='001'){
                System.debug('so.Sold_to_Party__c'+so.Id);
                if(!SpCustomerGroup001List.contains(so.Sold_to_Party__c)){
                    System.debug('not Contain '+so.Id);
                    bonificationMap.remove(so.Id);
                }
            }
        }            
        
        //Patch End                                                              
        System.debug('bonificationMap'+bonificationMap);
        /*
AggregateResult[] groupedResults = [SELECT Sales_Order__c, SUM(OrderQuantity__c) used
FROM Sales_Order__c
WHERE Sales_Order__c IN: bonificationMap.keySet()
AND BrazilSalesOrderStatus__c!='Cancelled'
AND BrazilSalesOrderStatus__c!='Cancelado'
AND BrazilSalesOrderStatus__c!='Draft'
AND BrazilSalesOrderStatus__c!='Simulado'
GROUP BY Sales_Order__c];

System.debug('somAccount'+groupedResults);

for(AggregateResult ar : groupedResults){
String somId = String.valueOf(ar.get('Sales_Order__c'));
String used = String.valueOf(ar.get('used'));

if(bonificationMap.containsKey(somId)){
Decimal moQty = bonificationMap.get(somId).OrderQuantity__c;
Decimal chQty = Decimal.valueOf(used);

if(chQty >= moQty){
bonificationMap.remove(somId);
}
}
}
System.debug('somValue'+bonificationMap.values());

*/
        
        return bonificationMap.values();
        
        
        
        
        
        
        
        // return typeBonification;
        
    }
    
    
    //--END           
    //added by krishanu@wipro
    @AuraEnabled
    public static MinValWrapper getMinValDisc(String typeval){
        
        List<MinValue_Discount_Parameters__mdt> listV1 = new List<MinValue_Discount_Parameters__mdt>();
        if(typeval != '' && typeval != null) {
            listV1 = [select Type__c,Min_Value__c,Max_Discount__c,Min_Value_USD__c from MinValue_Discount_Parameters__mdt where Type__c = :typeval limit 1];
        }
        
        MinValWrapper res1 = new MinValWrapper();
        if(listV1.size() > 0) {
            res1.OrderType = listV1.get(0).Type__c;
            res1.MinVal = listV1.get(0).Min_Value__c;
            res1.MinValUSD = listV1.get(0).Min_Value_USD__c;
            res1.MaxDisc = listV1.get(0).Max_Discount__c;
        }
        return res1;
    }           
    
    @AuraEnabled
    public static List<Account> getKeyCustomers(String userId, String orderType, String customerGroup, String accountId){ // ,String keyAccTMcodeTicket# INCTASK0100403:- Ankita, patch for open region{
        List<Account> accountList = new List<Account>();
        List<Account> accountListKAM = new List<Account>();
        //System.debug('userId: '+userId);
        //System.debug('orderType: '+orderType);
        //System.debug('customerGroup: '+customerGroup);
        //System.debug('accountId: '+accountId);
        //accountList = BrazilAccountShare.getKeyCustomers(userId, orderType, customerGroup, accountId);
        map<id, Territory_Distributor__c> TerritoryManagers = getTerritoryManagers();
        
        if(!String.isNotBlank(userId)){
            userId = UserInfo.getUserId();  
        }
        
        //Change by Nikhil(Grazitti)-INC0373530-6st Sept
        if(userId == UserInfo.getUserId() || TerritoryManagers.containskey(userId)){
            accountList = BrazilAccountShare.getKeyCustomers(userId, orderType, customerGroup, accountId).values();//Commented Ankita's Code -- ,keyAccTMcode
            if(orderType=='BONIFICAÇÃO' || orderType=='ORDEM FILHA'){
                for (account A : [select id,name,SAP_Code__c,BillingCity,
                                  Depot_Code__c,Tax_Number_3__c,
                                  Tax_Number_1__c,Customer_Region__c,
                                  Customer_Group__c,Program_Margin_Discount__c
                                  from account 
                                  where
                                  Customer_Group__c= :customerGroup
                                  AND key_account_manager__c = :userId]){ //userId
                                      accountList.add(A);
                                      System.debug('inside bonif'+accountList);
                                  }
            }
            else{
                for (account A : [select id,name,SAP_Code__c,BillingCity,
                                  Depot_Code__c,Tax_Number_3__c,
                                  Tax_Number_1__c,Customer_Region__c,
                                  Customer_Group__c,Program_Margin_Discount__c
                                  from account 
                                  where key_account_manager__c = :userId]){ //userId
                                      accountList.add(A);    
                                      System.debug('outside bonif'+accountList);
                                      
                                  }
            }
        }
        if(userId == UserInfo.getUserId() || !TerritoryManagers.containskey(userId)){
            //added by swapnil to fetch accounts with logged in user as KAM
            /*if(userId == UserInfo.getUserId()){
for (account A : [select id,name,SAP_Code__c,BillingCity,
Depot_Code__c,Tax_Number_3__c,
Tax_Number_1__c,Customer_Region__c,
Customer_Group__c,Program_Margin_Discount__c
from account 
where key_account_manager__c = :UserInfo.getUserId()]){ //userId
accountList.add(A);    
}
}*/
            //Change by Nikhil(Grazitti)-INC0373530-6st Sept
            if(userId != UserInfo.getUserId()){
                accountListKAM = BrazilAccountShare.getKeyCustomers(userId, orderType, customerGroup, accountId).values();//Commented Ankita's Code - ,keyAccTMcode
                for (Account A: accountListKAM){
                    if(a.Key_Account_Manager__c == UserInfo.getUserId()){
                        accountList.add(A); 
                    }
                    
                }
                
                
            }
        }
        
        return accountList;
    }
    
    @AuraEnabled
    public static List<Account> getCustomers(String selectedUser, String orderType, String customerGroup, String accountId, String customerRegionCode){
        // Ticket# INCTASK0100403:- Ankita, patch for open region key account, ,String keyAccTMcode
        //added by ganesh
        //desc:sdm login then Based on seller account fetch
        String userId;
        if(String.isNotBlank(selectedUser)){
            userId = selectedUser;  
        }
        else{
            userId = UserInfo.getUserId();
        }
        
        map<id, Territory_Distributor__c> TerritoryManagers = getTerritoryManagers();
        //Change by Nikhil(Grazitti)-INC0373530-6st Sept
        Map<id,Account> accountList = new Map<id,Account>();//updating to set
        //KAM plus seller from KAM region 
        
        //RITM0333006  fetch all accounts for Barter Managers
        
        User userObj = [Select Id, Profile.Name FROM User WHERE Id=:UserInfo.getUserId()];
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        String profileName = userObj.Profile.Name;
        
        if(profileName=='Brazil Barter Manager'){                    
            system.debug('**profileName --> '+ profileName);
            
            for (account Acc : [select id,name,SAP_Code__c,BillingCity,
                                Depot_Code__c,Tax_Number_3__c,
                                Tax_Number_1__c,Customer_Region__c,
                                Customer_Group__c,Program_Margin_Discount__c
                                from account where Sales_Org_Code__c='5191' limit 499]){//limit changed from 49999 to 499 >> page load was slow and don't need for barter Manager Profile >>Grazitti(Tanuj)- RITM0333006-8 Aug 2022
                                    accountList.put(Acc.Id,Acc);    
                                }
        }
        
        if(profileName!='Brazil Barter Manager' && (userId == UserInfo.getUserId() || TerritoryManagers.containskey(userId))) {
            // Added to fetch customer for SDM using regionCode GRZ(Nikhil Verma) INC0385117 date: 06-10-2022
            if((profileName == 'Brazil Sales District Manager' || profileName == 'Brazil Sales Office Manager') && customerRegionCode != 'null' && customerRegionCode.startsWith('BR')){ // Added for SOM GRZ(Javed) for RITM0490875 modified 03-02-2023-->
                accountList = BrazilAccountShare.getKeyCustomersForSDM(customerRegionCode ,customerGroup ); //// Update condition by GRZ(Dheeraj Sharma) for INC0479142 on 25-05-2023
            }else{
                //Change by Nikhil(Grazitti)-INC0373530-6st Sept
                accountList = BrazilAccountShare.getKeyCustomers(userId, orderType, customerGroup, accountId);//Commented Ankita's Code - ,keyAccTMcode -BrazilAccountShare.getCustomers(orderType, customerGroup, accountId); 
            }
            //-------------End GRZ(Nikhil Verma) INC0385117 date: 06-10-2022------------
        }
        Set<id> LiAccountId = new set<id>();
        LiAccountId=accountList.keyset();
        /*if(profileName!='Brazil Barter Manager')//Don't need to add this list to another list for barter manager profile >> Grazitti(Tanuj)- RITM0333006-8 Aug 2022
{
for(Account A: accountList){
LiAccountId.add(A.Id); //getting all Account id in list of string
}
}*/
        
        
        //KAM plus territory manager of account where logged in user is KAM
        if(profileName!='Brazil Barter Manager' && (userId == UserInfo.getUserId() || !TerritoryManagers.containskey(userId)))
        {
            
            
            
            
            
            System.debug('Customer_Group__c'+customerGroup);
            
            System.debug('UserInfo.getUserId'+UserInfo.getUserId());
            System.debug('LiAccountId'+LiAccountId);
            if((orderType=='BONIFICAÇÃO'||orderType=='ORDEM FILHA') && customerGroup != null && customerGroup != ''){
                
                for (account A : [select id,name,SAP_Code__c,BillingCity,
                                  Depot_Code__c,Tax_Number_3__c,
                                  Tax_Number_1__c,Customer_Region__c,
                                  Customer_Group__c,Program_Margin_Discount__c
                                  from account 
                                  where
                                  Customer_Group__c=:customerGroup
                                  AND key_account_manager__c = :UserInfo.getUserId()
                                  and id not in :LiAccountId]){//userId
                                      accountList.put(A.Id,A);   
                                      System.debug('inside bonif'+accountList);
                                  }
                
                
                System.debug('inside Customer_Group__c'+customerGroup);
                
                System.debug('inside UserInfo.getUserId'+UserInfo.getUserId());
                System.debug('inside LiAccountId'+LiAccountId);
            }else
            {
                for (account A : [select id,name,SAP_Code__c,BillingCity,
                                  Depot_Code__c,Tax_Number_3__c,
                                  Tax_Number_1__c,Customer_Region__c,
                                  Customer_Group__c,Program_Margin_Discount__c
                                  from account 
                                  where
                                  key_account_manager__c = :UserInfo.getUserId()
                                  and id not in :LiAccountId]){//userId
                                      accountList.put(A.Id,A);    
                                      System.debug('inside bonif'+accountList);
                                  }
                
                
                System.debug('inside1 Customer_Group__c'+customerGroup);
                
                System.debug('inside2 UserInfo.getUserId'+UserInfo.getUserId());
                System.debug('inside3 LiAccountId'+LiAccountId);
            }
        }
        //End
        //added by Swapnil -- To avoid duplicate list of account
        if(profileName!='Brazil Barter Manager')//Don't need to add this list to another list and another SET for barter manager profile >> Grazitti(Tanuj)- RITM0333006-8 Aug 2022
        {
            set<account> setAccount = new set<account>();
            //for(Account A:accountList){
            setAccount.addAll(accountList.values());
            System.debug(' setAccount' +setAccount);
            
            //}
            list<account> liAccount = new list<account>();
            liAccount.addAll(setAccount);
            //return accountList;
            System.debug(' LiAccountId' +LiAccount);
            System.debug('Size' +LiAccount.size());
            return liAccount;
            //Change by Nikhil(Grazitti)-INC0373530-6st Sept
        }
        else//send this list for Barter Manager profile >> Grazitti(Tanuj)- RITM0333006-8 Aug 2022
        {
            return accountList.values();
        }
        
    }
    
    //Returns Map of Material with Depot from Material Plant Relation where Account Depot matches Material Relation depot
    public static Map<Id,Id> getMaterialPlantRelation(String depotCode){
        system.debug('depotCode'+depotCode);
        Map<Id,Id> materialPlantMap = new Map<Id,Id>();
        // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022....added two fields to query COGS_Cost__c, Sales_Deduction_Cost__c...
        for(Material_Plant_Relation__c mprObj: [SELECT Id, Depot__c, SKU__c, Replacement_Cost__c, COGS_Cost__c, Sales_Deduction_Cost__c   
                                                FROM Material_Plant_Relation__c 
                                                WHERE Active__c = True 
                                                AND Depot__c =: depotCode]){
                                                    materialPlantMap.put(mprObj.SKU__c, mprObj.Depot__c);                                           
                                                }
        System.debug('materialPlantMap: '+materialPlantMap);    
        
        return materialPlantMap;
    }
    
	//Method created by Sumit kumar for Ticket No. RITM0518333
    public static Map<Id,Id> getMaterialPlantRelationSimulate(){
        Map<Id,Id> materialPlantMap = new Map<Id,Id>();
        for(Material_Plant_Relation__c mprObj: [SELECT Id, Depot__c, SKU__c, Replacement_Cost__c, COGS_Cost__c, Sales_Deduction_Cost__c   
                                                FROM Material_Plant_Relation__c limit 50000  ]){
                                                    materialPlantMap.put(mprObj.SKU__c, mprObj.Depot__c);                                           
                                                }
        System.debug('materialPlantMap@@@@@: '+materialPlantMap);    
        
        return materialPlantMap;
    }
    
    public static Map<Id,Material_Plant_Relation__c> getMaterialPlantRelationObjList(String depotCode){
        
        Map<Id,Material_Plant_Relation__c> materialPlantMap = new Map<Id,Material_Plant_Relation__c>();
        // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022....added two fields to query COGS_Cost__c, Sales_Deduction_Cost__c...
        for(Material_Plant_Relation__c mprObj: [SELECT Id, Depot__c, SKU__c, Replacement_Cost__c, COGS_Cost__c, Sales_Deduction_Cost__c   
                                                FROM Material_Plant_Relation__c 
                                                WHERE Active__c = True 
                                                AND Depot__c =: depotCode]){
                                                    materialPlantMap.put(mprObj.SKU__c, mprObj);                                           
                                                }
        //System.debug('materialPlantMap: '+materialPlantMap);    
        
        return materialPlantMap;
    }
    //Method created by Sumit kumar for Ticket No. RITM0518333
    public static Map<Id,Material_Plant_Relation__c> getMaterialPlantRelationObjListSimulate(){
        
        Map<Id,Material_Plant_Relation__c> materialPlantMap = new Map<Id,Material_Plant_Relation__c>();
        for(Material_Plant_Relation__c mprObj: [SELECT Id, Depot__c, SKU__c, Replacement_Cost__c, COGS_Cost__c, Sales_Deduction_Cost__c   
                                                FROM Material_Plant_Relation__c limit 50000  ]){
                                                    materialPlantMap.put(mprObj.SKU__c, mprObj);                                           
                                                }
        System.debug('materialPlantMap22222: '+materialPlantMap);    
        
        return materialPlantMap;
    }
    
    //Added By Krishanu@Wipro
    public static Map<Id,Material_Plant_Relation__c> getMaterialPlantRelationObjListBR00(){
        
        Map<Id,Material_Plant_Relation__c> materialPlantMap = new Map<Id,Material_Plant_Relation__c>();
        
        for(Material_Plant_Relation__c mprObj: [SELECT Id, Depot_Code__c, SKU__c, Replacement_Cost__c  
                                                FROM Material_Plant_Relation__c 
                                                WHERE Active__c = True 
                                                AND Depot_Code__c = 'BR00']){
                                                    materialPlantMap.put(mprObj.SKU__c, mprObj);                                           
                                                }
        //System.debug('materialPlantMap: '+materialPlantMap);    
        
        return materialPlantMap;
    }
    
    //Returns a Map with Valid SKU from Material Registration Object
    public static Map<Id, Material_Registration__c> getMaterialRegistration(Set<Id> skuSet, String accountState){
        Map<Id, Material_Registration__c> materialRegistrationMap = new Map<Id, Material_Registration__c>();
        
        for(Material_Registration__c mrObj: [SELECT Id, Name, Sales_Org__c, SKU__c, State__c, 
                                             Effective_From__c, Effective_To__c
                                             FROM Material_Registration__c 
                                             WHERE SKU__c IN : skuSet
                                             AND State__c =: accountState AND Effective_From__c <= TODAY AND Effective_To__c >= TODAY]){
                                                 // Added by Deeksha AND Effective_From__c <= TODAY AND Effective_To__c >= TODAY
                                                 //WHERE Effective_From__c <= TODAY 
                                                 //AND Effective_To__c >= TODAY                                                 
                                                 materialRegistrationMap.put(mrObj.SKU__c, mrObj);                                          
                                             }
        
        //System.debug('materialRegistrationMap: '+materialRegistrationMap);
        return materialRegistrationMap;
    }   
    
    /* ********************************* SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start ************************************************* */
    public static Map<Id,Blanket_SKU__c> getBlanketSKUMap(String salesOrgCode){
        Map<Id,Blanket_SKU__c> blanketMap = new Map<Id,Blanket_SKU__c>();
        for(Blanket_SKU__c blnsku : [SELECT Id, Name, SKU__c, Status__c, Start_Date__c, End_Date__c, Sales_Org__c, 
                                     Combination_Key__c FROM Blanket_SKU__c WHERE Sales_Org__r.Sales_Org_Code__c =: salesOrgCode AND 
                                     Status__c = True AND End_Date__c >=: System.today() AND Start_Date__c <=: System.today()]){
                                         if(!blanketMap.containsKey(blnsku.SKU__c)){
                                             blanketMap.put(blnsku.SKU__c,blnsku);
                                         }                            
                                     }
        return blanketMap;
    }
    /* ********************************* SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End **************************************************** */
    
    //Get Pricebook when Order Type != 'ORDEM FILHA'/'Child Order'
    @AuraEnabled   
    public static List<PriceDetail> getPriceBookDetails(String priceBookId, String depotCode, String accountState, String accid,Boolean isSimulated){
        
        System.debug('priceBookId : '+priceBookId);
        System.debug('depotCode : '+depotCode);
        System.debug('accountState : '+accountState);
        System.debug('accid : '+accid);
        System.debug('isSimulated : '+isSimulated);
        //code added by Sagar@Wipro SOS-006 for applying Increase/Decrease Percentage start--
        List<Price_Book__c> lstPB = new List<Price_Book__c>();
        Price_Book__c pb = new Price_Book__c();
        if(priceBookId != null && priceBookId != ''){
            lstPB = [select id,Currency_Code__c from Price_Book__c where id=:priceBookId];
            if(lstPB.size() > 0) {
                pb = lstPB.get(0);
            }
        }
        String pbcurrency=pb.Currency_Code__c;
        List<Increase_Decrease_Percentage__c> idp= [select id,Start_Date__c,End_Date__c,Percentage__c,Status__c,CurrencyIsoCode from Increase_Decrease_Percentage__c where Start_Date__c<=today AND End_Date__c>=today and Status__c='Approved' and CurrencyIsoCode=:pbcurrency limit 1];
        decimal percentdec=0.0;
        if(idp.size() > 0){
            string percent=string.Valueof(idp[0].Percentage__c);
            percentdec=idp[0].Percentage__c;
            system.debug('Test123  '+percent);
        }  
        //code added by Sagar@Wipro SOS-006 for applying Increase/Decrease Percentage end--
        // Changes added by Priya for RITM0176543 - SCTASK0398608 started
        string regCode;
        List<Territory_Distributor__c> tdList = [SELECT ID, Name, TerritoryCode__c, Region__c,Region__r.RegionCode__c
                                                 FROM Territory_Distributor__c 
                                                 WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                                                 AND (TerritoryManager__c=: UserInfo.getUserId() 
                                                      OR Region__r.RegionHead__c=: UserInfo.getUserId()
                                                      
                                                      OR Zone__r.ZonalHead__c=: UserInfo.getUserId()
                                                      OR SBU__r.SBUUser__c=: UserInfo.getUserId()
                                                      OR BarterManager__c=: UserInfo.getUserId()
                                                     ) limit 1];     
        //system.debug('**Territory List --> ' +tdList);
        
        if(tdList.size()>0){
            regCode = tdList[0].Region__r.RegionCode__c;
            system.debug('**regionCode --> ' +regCode);
        }
        
        
        
        Map<Id,String> newmap = new Map<Id,String>();
        Map<Id,date> dateMap = new Map<Id,date>();
        Map<Id,date> MaxDate = new Map<Id,date>(); // added by Krishanu
        
        list<Brazil_Region_SKU_Combination__c> comboList = new list<Brazil_Region_SKU_Combination__c>();
        if(regCode!=null){
            if(isSimulated){   // added by Sumit Kumar for Ticket No. RITM0518333
                 comboList = [SELECT Id, SKU__c, Sales_District__c, Availability__c,Date__c,Maximum_Date__c FROM Brazil_Region_SKU_Combination__c limit 50000] ;                
            }else{
                 comboList = [SELECT Id, SKU__c, Sales_District__c, Availability__c,Date__c,Maximum_Date__c FROM Brazil_Region_SKU_Combination__c where Sales_District__r.RegionCode__c =:regCode] ;
            }
            system.debug('**List Brazil_Region_SKU_Combination --> ' +comboList);   
        }           
        
        if(comboList.size()>0){
            for( Brazil_Region_SKU_Combination__c temp: comboList){
                newmap.put(temp.SKU__c, temp.Availability__c);
                if(temp.Date__c !=null){
                    dateMap.put(temp.SKU__c, temp.Date__c); 
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                // added by Krishanu
                if(temp.Maximum_Date__c !=null){
                    MaxDate.put(temp.SKU__c, temp.Maximum_Date__c); 
                }
                
            }                  
        }
        
        //end
        
        //Get Material with Depot from Material Plant Relation where Account Depot matches Material Relation depot
        Map<Id,Id> materialPlantMap = new Map<Id,Id>();
        Map<Id,Material_Plant_Relation__c> materialPlantMapObjList = new Map<Id,Material_Plant_Relation__c>();
        
        // added by Sumit Kumar for Ticket No. RITM0518333
        if(isSimulated){ 
            materialPlantMap = OrderRequestController.getMaterialPlantRelationSimulate();
            materialPlantMapObjList = OrderRequestController.getMaterialPlantRelationObjListSimulate();
        }else{
            materialPlantMap = OrderRequestController.getMaterialPlantRelation(depotCode);
            materialPlantMapObjList = OrderRequestController.getMaterialPlantRelationObjList(depotCode); // CR92...nik...20/07/2019
        }
        //Map<Id,Material_Plant_Relation__c> materialPlantMapObjListbr00 = OrderRequestController.getMaterialPlantRelationObjListBR00(); //Added by Krishanu@Wipro
        system.debug('materialPlantMap'+materialPlantMap);
        system.debug('materialPlantMapObjList'+materialPlantMapObjList);
        List<ExchangeRate__c> exchangeRateList = [SELECT Id, ExchangeRate__c, Createddate 
                                                  FROM ExchangeRate__c where FromCurrency__c = 'USD' AND ToCurrency__c = 'BRL'
                                                  Order BY Createddate DESC];
        system.debug('exchangeRateList'+exchangeRateList);
        List<PriceDetail> priceList = new List<PriceDetail>();
        String CustomerPriceConvFactor;
        //system.debug('laxmanaccid->'+accid);
        ////Added by Sayan, 20th July, RITM0234559
        if(String.isNotBlank(accid) && accid!=null){
            CustomerPriceConvFactor = [SELECT Price_Conversion_Group__c 
                                       FROM Account WHERE Id =:accid LIMIT 1 ].Price_Conversion_Group__c;
        }
        Map<string,Customer_Conversion_factor__c> MapCCFactor = new Map<string,Customer_Conversion_factor__c>();
        if( String.isNotBlank(CustomerPriceConvFactor) && CustomerPriceConvFactor!= null ){
            
            for (Customer_Conversion_factor__c DM: [SELECT id,Brand_Name__c, Conversion_Factor__c, Customer_Group__c,
                                                    Sales_Org__c, Combination_Key__c
                                                    FROM Customer_Conversion_factor__c 
                                                    WHERE Customer_Group__c=:CustomerPriceConvFactor]){
                                                        MapCCFactor.put(DM.Customer_Group__c+DM.Brand_Name__c, DM);   
                                                    }
        }
        
        ////Added by Sayan, 20th July, RITM0234559
        
        Boolean kitPriceBook = false;//Modified by Deeksha for kit selling Project
        Set<Id> kitSKUSet = new Set<Id>();//Modified by Deeksha for kit selling Project
        Set<Id> skuSet = new Set<Id>();
        for(Price_Book_Details__c pbdObj:[SELECT Id, SKU__c
                                          FROM Price_Book_Details__c 
                                          WHERE Price_Book__c =: priceBookId 
                                          AND SKU__r.Active__c=True]){
                                              skuSet.add(pbdObj.SKU__c);
                                              
                                          }  
        Map<Id, Material_Registration__c> materialRegistrationMap = OrderRequestController.getMaterialRegistration(skuSet,accountState);
        
        /* *************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start ************************************************ */ 
        Map<Id,Blanket_SKU__c> blanketSKUMap = OrderRequestController.getBlanketSKUMap('5191');
        /* *************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End ************************************************** */                                 
        
        //Add those materials to pricelist where depot matches with Account depot
        // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022...added SKU__r.UOM__c field to query...
        for(Price_Book_Details__c pbdObj:[SELECT Id,Name,SKU__r.Item_Category__c,Sellout_Price_BRL__c,Sellout_Price_USD__c,SKU__r.Kit_Product__c,Price_Book__r.Kit_Price_Book__c, SKU__r.Product_Category__c,SKU__r.SKU_Code__c,Price_Book__r.Interest_Date__c,Price_Book__r.Interest_Rate_R__c,
                                          Price_Book__r.Interest_Rate_U__c,Price_Book__c,Sales_District1__c, Minimum_Price__c,Minimum_Price_R__c, SKU__r.UOM__c, 
                                          Minimum_Price_U__c,Sales_District1__r.Name, SKU__r.Multiple_of__c,Price_Book__r.Currency__c,Price_Book__r.Apply_Increase_Decrease_Percentage__c,
                                          Future_Sales_Price__c,Future_Sales_Price_R__c,Future_Sales_Price_U__c,SKU__c, CreatedDate, SKU__r.Brand_Name__c,
                                          SKU__r.SKU_Description__c,Unit_Price__c,Unit_Price_R__c,Unit_Price_U__c, Monthly_Interest_Rate__c ,Kit_SKU__c,Price_Book__r.Apply_Minimum_Price__c
                                          FROM Price_Book_Details__c 
                                          WHERE Price_Book__c =: priceBookId AND SKU__r.Active__c=True
                                          and Active__c = True]){ //added Active Condition
                                              //Modified by Deeksha for kit selling Project
                                              if(!kitPriceBook && pbdObj.Price_Book__r.Kit_Price_Book__c){
                                                  kitPriceBook =  true;
                                              }
                                              
                                              if(materialPlantMap.containsKey(pbdObj.SKU__c)){
                                                  //if(materialRegistrationMap.containsKey(pbdObj.SKU__c)){
                                                  
                                                  Material_Plant_Relation__c materialRelObj = materialPlantMapObjList.get(pbdObj.SKU__c);
                                                  //Material_Plant_Relation__c materialRelObjbr00 = materialPlantMapObjListbr00.get(pbdObj.SKU__c); //Added by Krishanu@Wipro
                                                  
                                                  
                                                  PriceDetail pd = new PriceDetail();
                                                  pd.skuId = pbdObj.SKU__c;
                                                  
                                                  /* *********************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start ********************************** */
                                                  pd.uom = pbdObj.SKU__r.UOM__c;
                                                  
                                                  if(materialRelObj.Sales_Deduction_Cost__c != null){
                                                      pd.salesDeductionCost = materialRelObj.Sales_Deduction_Cost__c;
                                                  }
                                                  
                                                  if(materialRelObj.COGS_Cost__c != null){
                                                      pd.cogsCost = materialRelObj.COGS_Cost__c;
                                                  }
                                                  
                                                  if(blanketSKUMap.containsKey(pbdObj.SKU__c)){
                                                      pd.isBlanket = true;
                                                      pd.blnkt_EndDate = String.valueOf(blanketSKUMap.get(pbdObj.SKU__c).End_Date__c);
                                                      pd.blnkt_StartDate = String.valueOf(blanketSKUMap.get(pbdObj.SKU__c).Start_Date__c);
                                                      pd.blnkt_Status = blanketSKUMap.get(pbdObj.SKU__c).Status__c;
                                                  }
                                                  /* ************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End ******************************** */
                                                  //Added by Priya for RITM0176543 - SCTASK0398608
                                                  if( newmap.containskey(pbdObj.SKU__c)  && newmap.get(pbdObj.SKU__c) == 'No'){
                                                      pd.avail = false;
                                                  }
                                                  
                                                  if( dateMap.containskey(pbdObj.SKU__c)){
                                                      pd.minDate = String.valueOf(dateMap.get(pbdObj.SKU__c));
                                                  } 
                                                  //added by Krishanu
                                                  if( MaxDate.containskey(pbdObj.SKU__c)){
                                                      system.debug('**Inside Date Map **');
                                                      pd.maxDate = String.valueOf(MaxDate.get(pbdObj.SKU__c));
                                                      system.debug('**Date Min --> ' +pd.maxDate );
                                                  } 
                                                  
                                                  pd.selloutprice = pbdObj.Sellout_Price_BRL__c;
                                                  
                                                  pd.selloutpriceU = pbdObj.Sellout_Price_USD__c; 
                                                  
                                                  
                                                  
                                                  pd.applyMinPrice = pbdObj.Price_Book__r.Apply_Minimum_Price__c; // Priya RITM0237685
                                                  pd.skuCategory = pbdObj.SKU__r.Product_Category__c; 
                                                  pd.skuDescription = pbdObj.SKU__r.SKU_Description__c;
                                                  
                                                  pd.itemCategory = pbdObj.SKU__r.Item_Category__c; //Modified by Deeksha for kit selling Project
                                                  pd.unitValue = pbdObj.Unit_Price__c;
                                                  
                                                  pd.minValue = pbdObj.Minimum_Price__c;
                                                  pd.minValueBRL = pbdObj.Minimum_Price_R__c; 
                                                  pd.unitValueBRL = pbdObj.Unit_Price_R__c;
                                                  pd.unitValueUSD = pbdObj.Unit_Price_U__c ;
                                                  pd.minValueUSD = pbdObj.Minimum_Price_U__c;
                                                  
                                                  //code added by Sagar@Wipro SOS-006 for applying Increase/Decrease Percentage start--
                                                  if(idp.size() > 0 && pbdObj.Price_Book__r.Apply_Increase_Decrease_Percentage__c == true){
                                                      if((pbdObj.Price_Book__r.Currency__c =='Only BRL' || pbdObj.Price_Book__r.Currency__c =='BRL and USD') && idp[0].CurrencyIsoCode == 'BRL' ){
                                                          system.debug('Test');
                                                          pd.minValueBRL = pbdObj.Minimum_Price_R__c + (pbdObj.Minimum_Price_R__c * percentdec/100);
                                                          pd.unitValueBRL = pbdObj.Unit_Price_R__c +  (pbdObj.Unit_Price_R__c * percentdec/100);
                                                      }
                                                      if((pbdObj.Price_Book__r.Currency__c =='Only USD' || pbdObj.Price_Book__r.Currency__c =='BRL and USD') && idp[0].CurrencyIsoCode == 'USD' ){
                                                          system.debug('Test');
                                                          pd.unitValueUSD = pbdObj.Unit_Price_U__c + (pbdObj.Unit_Price_U__c * percentdec/100);
                                                          pd.minValueUSD = pbdObj.Minimum_Price_U__c + (pbdObj.Minimum_Price_U__c* percentdec/100);
                                                      }
                                                  }
                                                  else{
                                                      pd.minValueBRL = pbdObj.Minimum_Price_R__c; 
                                                      pd.unitValueBRL = pbdObj.Unit_Price_R__c;
                                                      pd.unitValueUSD = pbdObj.Unit_Price_U__c ;
                                                      pd.minValueUSD = pbdObj.Minimum_Price_U__c;
                                                  }
                                                  //code added by Sagar@Wipro SOS-006 for applying Increase/Decrease Percentage end--
                                                  //pd.minValueBRL = pbdObj.Minimum_Price_R__c;
                                                  //pd.minValueUSD = pbdObj.Minimum_Price_U__c;
                                                  //added by ganesh Date:12/11/2018 
                                                  //desc:CR to add future sales value(budget value)
                                                  pd.BudgetValue = pbdObj.Future_Sales_Price__c;
                                                  pd.budgetValueBRL = pbdObj.Future_Sales_Price_R__c;
                                                  pd.budgetValueUSD = pbdObj.Future_Sales_Price_U__c;
                                                  pd.pricebookId = pbdObj.Id;
                                                  pd.skuCode = pbdObj.SKU__r.SKU_Code__c;
                                                  pd.multipleOf = pbdObj.SKU__r.Multiple_of__c;
                                                  pd.monthlyInterestRate = pbdObj.Monthly_Interest_Rate__c;
                                                  pd.monthlyInterestRateBRL = pbdObj.Price_Book__r.Interest_Rate_R__c;
                                                  pd.monthlyInterestRateUSD = pbdObj.Price_Book__r.Interest_Rate_U__c;
                                                  
                                                  if(materialRelObj.Replacement_Cost__c != null){                     //...CR92....Nik....22/07/2019
                                                      pd.materialPlnRplcCost = materialRelObj.Replacement_Cost__c;
                                                      pd.e2eCost = materialRelObj.Replacement_Cost__c;                // ****SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022......     
                                                  } 
                                                  /*if(!test.isRunningTest()){
if(materialRelObjbr00.Replacement_Cost__c != null){                     //Added by Krishanu@Wipro
pd.materialPlnRplcCostbr00 = materialRelObjbr00.Replacement_Cost__c;     
}
}*/                 
                                                  
                                                  if(!exchangeRateList.isEmpty()){                                    //...CR92....Nik....22/07/2019
                                                      pd.exchangeRate = exchangeRateList[0].ExchangeRate__c;
                                                  }
                                                  pd.currencyCode = pbdObj.Price_Book__r.Currency__c;                 //...CR92....Nik....22/07/2019
                                                  pd.create_Dt = String.valueOf((pbdObj.CreatedDate).date());         //...CR92....Nik....22/07/2019
                                                  pd.brand = pbdObj.SKU__r.Brand_Name__c;                             //...CR93....Nik....25/07/2019
                                                  
                                                  if(materialRegistrationMap.containsKey(pbdObj.SKU__c)){
                                                      Material_Registration__c mrObj = materialRegistrationMap.get(pbdObj.SKU__c);
                                                      if(mrObj.Effective_From__c<= System.today() && mrObj.Effective_To__c>= System.today()){
                                                          pd.isValid = true;
                                                      }
                                                      pd.regState = mrObj.State__c;
                                                  }
                                                  system.debug('pd'+pd);
                                                  system.debug('pbdObj'+pbdObj);
                                                  
                                                  //Modified by Deeksha for kit selling Project
                                                  if(pbdObj.SKU__r.Kit_Product__c && pbdObj.Price_Book__r.Kit_Price_Book__c){
                                                      pd.kitSKU = pbdObj.Kit_SKU__c;
                                                  }
                                                  if(!pbdObj.SKU__r.Kit_Product__c && pbdObj.Price_Book__r.Kit_Price_Book__c){
                                                      pd.kitProduct = false;
                                                      kitSKUSet.add(pbdObj.Kit_SKU__c);
                                                      pd.kitSKU = pbdObj.Kit_SKU__c;
                                                  }else if(!pbdObj.SKU__r.Kit_Product__c && !pbdObj.Price_Book__r.Kit_Price_Book__c){
                                                      pd.kitProduct = false;
                                                  }
                                                  
                                                  //End
                                                  ////Added by Sayan, 20th July, RITM0234559
                                                  if( String.isNotBlank(CustomerPriceConvFactor) && CustomerPriceConvFactor!= null ){
                                                      system.debug('Sayan00 inside CustomerPriceConvFactor null check');
                                                      if(MapCCFactor.containskey(CustomerPriceConvFactor+pbdObj.SKU__r.Brand_Name__c)){
                                                          system.debug('Sayan00 inside found key');
                                                          if(string.isNotBlank(string.valueOf(MapCCFactor.get(CustomerPriceConvFactor+pbdObj.SKU__r.Brand_Name__c).Conversion_Factor__c))){
                                                              pd.custconversionfator = MapCCFactor.get(CustomerPriceConvFactor+pbdObj.SKU__r.Brand_Name__c).Conversion_Factor__c;
                                                          }             
                                                      }else{
                                                          system.debug('Sayan00 inside not found key');
                                                          pd.custconversionfator = 1;
                                                      }
                                                  }else{
                                                      system.debug('Sayan00 inside CustomerPriceConvFactor null');
                                                      pd.custconversionfator = 1;
                                                  }
                                                  ////Added by Sayan, 20th July, RITM0234559
                                                  //pd.regState = materialRegistrationMap.get(pbdObj.SKU__c).State__c;
                                                  priceList.add(pd);
                                                  //}
                                              }
                                              
                                          }
        
        //System.debug('priceBookId: '+priceBookId);
        //Modified by Deeksha for kit selling Project
        if(kitPriceBook){
            List<id> kitSKUList = new List<Id>();
            kitSKUList.addAll(kitSKUSet);
            List<PriceDetail> priceListTemp = fetchKitComponentProduct(priceList, kitSKUList,priceBookId);
            priceList.clear();
            priceList = priceListTemp;
        }
        
        return priceList;
    }
    
    //Modified by Deeksha for kit selling Project
    public static List<PriceDetail> fetchKitComponentProduct(List<PriceDetail> componentPriceList,List<Id> kitSKUs,String priceBookId){
        Map<id,List<String>> origKitComponentSKUMap = new Map<id,List<id>>();
        Map<id,List<Component__c>> kitComponentMap = new Map<id,List<Component__c>>();
        for(Component__c cmp : [select id,Kit_SKU__r.Brand_Name__c,Kit_SKU__r.Product_Category__c,Kit_SKU__r.SKU_Code__c,Kit_SKU__r.Item_Category__c,Component_Item_Category__c,Component_Quantity__c,Kit_SKU__r.SKU_Description__c,Kit_SKU__c,Component_SKU__c from Component__c where Kit_SKU__c =:kitSKUs]){
            List<String> strList = new List<String>();
            if(origKitComponentSKUMap.containsKey(cmp.Kit_SKU__c)){
                strList = origKitComponentSKUMap.get(cmp.Kit_SKU__c);
            }
            strList.add(cmp.Component_SKU__c+''+cmp.Kit_SKU__c);  
            origKitComponentSKUMap.put(cmp.Kit_SKU__c,strList);
            
            List<Component__c> comp = new List<Component__c>();
            if(kitComponentMap.containsKey(cmp.Kit_SKU__c)){
                comp = kitComponentMap.get(cmp.Kit_SKU__c);
            }
            comp.add(cmp);
            kitComponentMap.put(cmp.Kit_SKU__c,comp);
            
        }
        Map<String,PriceDetail> componentPriceDetailMap =  new Map<String,PriceDetail>();
        Map<id,PriceDetail> kitPriceDetailMap =  new Map<id,PriceDetail>();
        for(PriceDetail pb : componentPriceList) {
            componentPriceDetailMap.put(pb.skuId+''+pb.kitSKU ,pb);
        }
        kitSKUs.clear();
        //system.debug('origKitComponentSKUMap'+origKitComponentSKUMap);
        system.debug('origKitComponentSKUMap'+origKitComponentSKUMap);
        for(id kitId : origKitComponentSKUMap.keySet()){
            Boolean addKit = true;
            for(String kitCompId : origKitComponentSKUMap.get(kitId)){
                if(componentPriceDetailMap.containsKey(kitCompId)){
                    addKit = true;
                }
                else{
                    addKit = false;
                    break;
                }
            }
            if(addKit){
                kitSKUs.add(kitId);
            }
        }
        
        Map<id,List<PriceDetail>> kitComponentSKUMap = new Map<id,List<PriceDetail>>();
        
        system.debug('kitSKUs'+kitSKUs);
        system.debug('componentPriceDetailMap'+componentPriceDetailMap);
        for(id kitId :kitSKUs){
            for(Component__c cmp : kitComponentMap.get(kitId)){
                componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).componentQty = cmp.Component_Quantity__c;
                componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).itemCategory = cmp.Component_Item_Category__c;
                
                if(!kitPriceDetailMap.containsKey(cmp.Kit_SKU__c)){
                    PriceDetail pd = new PriceDetail();
                    pd.skuId = cmp.Kit_SKU__c;
                    pd.skuCategory = cmp.Kit_SKU__r.Product_Category__c; 
                    pd.itemCategory = cmp.Kit_SKU__r.Item_Category__c;
                    pd.skuDescription = cmp.Kit_SKU__r.SKU_Description__c;
                    pd.kitProduct = true;
                    pd.skuCode = cmp.Kit_SKU__r.SKU_Code__c;
                    pd.brand = cmp.Kit_SKU__r.Brand_Name__c;
                    if(componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).unitValue!=null){pd.unitValue = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).unitValue*componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).componentQty;}
                    if(componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).unitValueBRL!=null){pd.unitValueBRL = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).unitValueBRL*componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).componentQty;}
                    if(componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).unitValueUSD!=null){pd.unitValueUSD = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).unitValueUSD*componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).componentQty;}
                    if(componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).minValue!=null){pd.minValue = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).minValue*componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).componentQty;}
                    if(componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).minValueBRL!=null){pd.minValueBRL = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).minValueBRL*componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).componentQty;}
                    if(componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).minValueUSD!=null){pd.minValueUSD = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).minValueUSD*componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).componentQty;}
                    if(componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).BudgetValue!=null){pd.BudgetValue = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).BudgetValue*componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).componentQty;}
                    if(componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).budgetValueBRL!=null){pd.budgetValueBRL = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).budgetValueBRL*componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).componentQty;}
                    if(componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).budgetValueUSD!=null){pd.budgetValueUSD = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).budgetValueUSD*componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).componentQty;}
                    pd.pricebookId = priceBookId;
                    pd.exchangeRate =componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).exchangeRate;
                    pd.currencyCode = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).currencyCode;
                    pd.create_Dt = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).create_Dt;
                    pd.materialPlnRplcCost =componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).materialPlnRplcCost;
                    pd.monthlyInterestRate = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).monthlyInterestRate;
                    pd.monthlyInterestRateBRL = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).monthlyInterestRateBRL;
                    pd.monthlyInterestRateUSD = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).monthlyInterestRateUSD;
                    
                    /* ***************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start ******************************************************** */
                    pd.salesDeductionCost = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).salesDeductionCost;
                    pd.cogsCost = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).cogsCost;
                    pd.e2eCost = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).e2eCost;
                    pd.blnkt_EndDate = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).blnkt_EndDate;
                    pd.blnkt_StartDate = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).blnkt_StartDate;
                    pd.blnkt_Status = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).blnkt_Status;
                    pd.uom = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).uom;
                    pd.isBlanket = componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).isBlanket;
                    /* ***************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End ******************************************** */
                    
                    kitPriceDetailMap.put(cmp.Kit_SKU__c, pd);
                }
                else{
                    if(kitPriceDetailMap.get(cmp.Kit_SKU__c).unitValue!=null && componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).unitValue!=null){kitPriceDetailMap.get(cmp.Kit_SKU__c).unitValue += (componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).unitValue*componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).componentQty);}
                    if(kitPriceDetailMap.get(cmp.Kit_SKU__c).unitValueBRL!=null && componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).unitValueBRL!=null){kitPriceDetailMap.get(cmp.Kit_SKU__c).unitValueBRL += (componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).unitValueBRL*componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).componentQty);}
                    if(kitPriceDetailMap.get(cmp.Kit_SKU__c).unitValueUSD!=null && componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).unitValueUSD!=null){kitPriceDetailMap.get(cmp.Kit_SKU__c).unitValueUSD += (componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).unitValueUSD*componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).componentQty);}
                    if(kitPriceDetailMap.get(cmp.Kit_SKU__c).minValue!=null && componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).minValue!=null){kitPriceDetailMap.get(cmp.Kit_SKU__c).minValue += (componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).minValue*componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).componentQty);}
                    if(kitPriceDetailMap.get(cmp.Kit_SKU__c).minValueBRL!=null && componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).minValueBRL!=null){kitPriceDetailMap.get(cmp.Kit_SKU__c).minValueBRL += (componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).minValueBRL*componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).componentQty);}
                    if(kitPriceDetailMap.get(cmp.Kit_SKU__c).minValueUSD!=null && componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).minValueUSD!=null){kitPriceDetailMap.get(cmp.Kit_SKU__c).minValueUSD += (componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).minValueUSD*componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).componentQty);}
                    if(kitPriceDetailMap.get(cmp.Kit_SKU__c).BudgetValue!=null && componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).BudgetValue!=null){kitPriceDetailMap.get(cmp.Kit_SKU__c).BudgetValue += componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).BudgetValue;}
                    if(kitPriceDetailMap.get(cmp.Kit_SKU__c).budgetValueBRL!=null && componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).budgetValueBRL!=null){kitPriceDetailMap.get(cmp.Kit_SKU__c).budgetValueBRL += componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).budgetValueBRL;}
                    if(kitPriceDetailMap.get(cmp.Kit_SKU__c).budgetValueUSD!=null && componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).budgetValueUSD!=null){kitPriceDetailMap.get(cmp.Kit_SKU__c).budgetValueUSD += componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).budgetValueUSD;}
                    //if(kitPriceDetailMap.get(cmp.Kit_SKU__c).monthlyInterestRate!=null && componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).monthlyInterestRate!=null){kitPriceDetailMap.get(cmp.Kit_SKU__c).monthlyInterestRate += componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).monthlyInterestRate;}
                    //if(kitPriceDetailMap.get(cmp.Kit_SKU__c).monthlyInterestRateBRL!=null && componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).monthlyInterestRateBRL!=null){kitPriceDetailMap.get(cmp.Kit_SKU__c).monthlyInterestRateBRL += componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).monthlyInterestRateBRL;}
                    //if(kitPriceDetailMap.get(cmp.Kit_SKU__c).monthlyInterestRateUSD!=null && componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).monthlyInterestRateUSD!=null){kitPriceDetailMap.get(cmp.Kit_SKU__c).monthlyInterestRateUSD += componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).monthlyInterestRateUSD;}
                    if(kitPriceDetailMap.get(cmp.Kit_SKU__c).materialPlnRplcCost!=null && componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).materialPlnRplcCost!=null){kitPriceDetailMap.get(cmp.Kit_SKU__c).materialPlnRplcCost += componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).materialPlnRplcCost;}
                    
                    /* ***************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start ******************************************************** */
                    if(kitPriceDetailMap.get(cmp.Kit_SKU__c).salesDeductionCost!=null && componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).salesDeductionCost!=null){kitPriceDetailMap.get(cmp.Kit_SKU__c).salesDeductionCost += componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).salesDeductionCost;}
                    if(kitPriceDetailMap.get(cmp.Kit_SKU__c).cogsCost!=null && componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).cogsCost!=null){kitPriceDetailMap.get(cmp.Kit_SKU__c).cogsCost += componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).cogsCost;}
                    if(kitPriceDetailMap.get(cmp.Kit_SKU__c).e2eCost!=null && componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).e2eCost!=null){kitPriceDetailMap.get(cmp.Kit_SKU__c).e2eCost += componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c).e2eCost;}
                    /* ***************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End ******************************************** */
                }
                
                if(kitComponentSKUMap.containsKey(cmp.Kit_SKU__c)){
                    kitComponentSKUMap.get(cmp.Kit_SKU__c).add(componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c));
                }else{
                    kitComponentSKUMap.put(cmp.Kit_SKU__c, new List<PriceDetail> {componentPriceDetailMap.get(cmp.Component_SKU__c+''+cmp.Kit_SKU__c)});
                }
                
            }
        }
        system.debug('kitPriceDetailMap'+kitPriceDetailMap);
        for(id kitSKU : kitComponentSKUMap.KeySet()){
            
            if(kitPriceDetailMap.containsKey(kitSKU)){
                system.debug('kitComponentSKUMap'+kitComponentSKUMap.get(kitSKU));
                kitPriceDetailMap.get(kitSKU).kitProductPB = kitComponentSKUMap.get(kitSKU);
            }
        } 
        return kitPriceDetailMap.values();
    }
    
    //Logic to validate SOC Balance with refreshed balance from the Server before saving Sales Order
    //Modified by Sumit kumar for Ticket No. RITM0518333 on Date 13/03/2023
    @AuraEnabled      
    public static SOMQuantity validateQuantitySOC(String priceBookId, String motherOrderId, String depotCode, String accountState, String orderId, String salesOrderItemString,Boolean isSimulated){
        
        List<PriceDetail> priceList = getMOPriceBookDetails(priceBookId, motherOrderId, depotCode, accountState, orderId, false,isSimulated);
        
        List<SalesOrderItem> salesOrderItemList = (List<SalesOrderItem>)JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class);
        
        Map<Decimal, PriceDetail> priceMap = new Map<Decimal, PriceDetail>();
        for (PriceDetail pdObj : priceList) {
            priceMap.put(pdObj.itemNo, pdObj);
        }
        
        Map<Decimal, SalesOrderItem> soiMap = new Map<Decimal, SalesOrderItem>();
        
        //Boolean flag = true;
        List<String> productList = new List<String>();
        for(SalesOrderItem soiObj : salesOrderItemList){
            
            soiMap.put(soiObj.moItemNo, soiObj);
            
            if(priceMap.containsKey(soiObj.moItemNo)){
                PriceDetail priceObj = priceMap.get(soiObj.moItemNo);  
                
                //System.debug('soiObj.moItemNo: '+soiObj.moItemNo);
                //System.debug('soiObj.qty: '+soiObj.qty);
                //System.debug('priceObj.balanceQty2: '+priceObj.balanceQty2);
                
                if(soiObj.qty > priceObj.balanceQty2){
                    productList.add(soiObj.productName);
                    //break;
                }
            }
        }
        
        SOMQuantity sqObj;
        
        if(!productList.isEmpty()){
            for(PriceDetail pdObj:priceList){
                if(soiMap.containsKey(pdObj.itemNo)){
                    SalesOrderItem soiObj = soiMap.get(pdObj.itemNo);
                    pdObj.balanceQty -= soiObj.qty;
                    pdObj.balanceQty2 -= soiObj.qty;
                    pdObj.percUsed = (Math.abs(pdObj.balanceQty / pdObj.qty) *100).setScale(2);
                }
            }
            sqObj = new SOMQuantity();
            sqObj.priceList = priceList;
            sqObj.productList = productList;
        }
        
        return sqObj;
    }
    
    //Get Pricebook when Order Type = 'ORDEM FILHA'/'Child Order'
    @AuraEnabled   
    public static List<PriceDetail> getMOPriceBookDetails(String priceBookId, String motherOrderId, String depotCode, String accountState, String orderId, Boolean withDraft, Boolean isSimulated){
        
        System.debug('priceBookId : '+priceBookId);
        System.debug('motherOrderId : '+motherOrderId);
        System.debug('depotCode : '+depotCode);
        System.debug('accountState : '+accountState);
        System.debug('orderId : '+orderId);
        System.debug('withDraft : '+withDraft);
        System.debug('isSimulated : '+isSimulated);
        // Changes added by Priya for RITM0176543 - SCTASK0398608 started
        string regCode;
        List<Territory_Distributor__c> tdList = [SELECT ID, Name, TerritoryCode__c, Region__c,Region__r.RegionCode__c
                                                 FROM Territory_Distributor__c 
                                                 WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                                                 AND (TerritoryManager__c=: UserInfo.getUserId() 
                                                      OR Region__r.RegionHead__c=: UserInfo.getUserId()
                                                      OR Region__r.Brazil_Marketing_Ops_Manager__c=:UserInfo.getUserId()
                                                      
                                                      OR Zone__r.ZonalHead__c=: UserInfo.getUserId()
                                                      OR SBU__r.SBUUser__c=: UserInfo.getUserId()
                                                      OR BarterManager__c=: UserInfo.getUserId()
                                                     ) limit 1]; 
        
        
        
        //system.debug('**Child Order Territory List --> ' +tdList);
        
        
        
        
        
        if(tdList.size()>0){ 
            regCode = tdList[0].Region__r.RegionCode__c;
            system.debug('** Child Order regionCode --> ' +regCode);
        }        
        
        
        
        
        Map<Id,String> newmap = new Map<Id,String>();
        Map<Id,date> dateMap = new Map<Id,date>();
        list<Brazil_Region_SKU_Combination__c> comboList = new list<Brazil_Region_SKU_Combination__c>();
        if(regCode!=null){
            //added by Sumit kumar for Ticket No. RITM0518333
            if(isSimulated){
               comboList = [SELECT Id, SKU__c, Sales_District__c, Availability__c,Date__c FROM Brazil_Region_SKU_Combination__c limit 50000];                           
            }else{
               comboList = [SELECT Id, SKU__c, Sales_District__c, Availability__c,Date__c FROM Brazil_Region_SKU_Combination__c where Sales_District__r.RegionCode__c =:regCode];           
            }
            system.debug('**List Child Order Brazil_Region_SKU_Combination --> ' +comboList);
        }
        
        ////Added by Sayan, 20th July, RITM0234559
        String CustomerPriceConvFactor = [SELECT Sold_to_Party__r.Price_Conversion_Group__c 
                                          FROM Sales_Order__c WHERE Id =:motherOrderId LIMIT 1 ].Sold_to_Party__r.Price_Conversion_Group__c;
        Map<string,Customer_Conversion_factor__c> MapCCFactor = new Map<string,Customer_Conversion_factor__c>();
        if( String.isNotBlank(CustomerPriceConvFactor) && CustomerPriceConvFactor!= null ){
            
            for (Customer_Conversion_factor__c DM: [SELECT id,Brand_Name__c, Conversion_Factor__c, Customer_Group__c,
                                                    Sales_Org__c, Combination_Key__c
                                                    FROM Customer_Conversion_factor__c 
                                                    WHERE Customer_Group__c=:CustomerPriceConvFactor]){
                                                        MapCCFactor.put(DM.Customer_Group__c+DM.Brand_Name__c, DM);   
                                                    }
        }
        
        ////Added by Sayan, 20th July, RITM0234559
        
        if(comboList.size()>0){
            for( Brazil_Region_SKU_Combination__c temp: comboList){
                newmap.put(temp.SKU__c, temp.Availability__c);
                if(temp.Date__c !=null){
                    dateMap.put(temp.SKU__c, temp.Date__c); 
                }
            }
        }
        
        system.debug('**Map Child Order SKU To Availability --> ' +newmap);
        system.debug('**Map Child Order Min Date --> ' +dateMap);
        
        
        //Get Material with Depot from Material Plant Relation where Account Depot matches Material Relation depot
        //  Map<Id,Id> materialPlantMap = OrderRequestController.getMaterialPlantRelation(depotCode);
        //change-Request Added by ganesh Date :19/10/2018
        Set<Id> kitSKUSet = new Set<Id>();//Modified by Deeksha for kit selling Project
        Map<Id,Id> materialPlantMap = new Map<Id,Id>();
        Map<Id,Material_Plant_Relation__c> materialPlantMapObjList = new Map<Id,Material_Plant_Relation__c>();  // CR92...nik...20/07/2019
        String MOrderSOType='';
        //added by Sumit kumar for Ticket No. RITM0518333
        List<Material_Plant_Relation__c> materialPlantList1 = new List<Material_Plant_Relation__c>();
        List<Material_Plant_Relation__c> materialPlantList2 = new List<Material_Plant_Relation__c>();
        if(isSimulated){
        	materialPlantList1 = [SELECT Id, Depot__c, SKU__c, Replacement_Cost__c, COGS_Cost__c, Sales_Deduction_Cost__c FROM Material_Plant_Relation__c limit 50000];            
        }else{
        	materialPlantList1 = [SELECT Id, Depot__c, SKU__c, Replacement_Cost__c, COGS_Cost__c, Sales_Deduction_Cost__c FROM Material_Plant_Relation__c WHERE Depot__c =: depotCode];            
        }
        system.debug('materialPlantList1!!!!@@@:'+materialPlantList1);
        // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022....added two fields to query COGS_Cost__c, Sales_Deduction_Cost__c...
        for(Material_Plant_Relation__c mprObj: materialPlantList1){
            materialPlantMap.put(mprObj.SKU__c, mprObj.Depot__c); 
            materialPlantMapObjList.put(mprObj.SKU__c, mprObj);
        }
        //End
        //added by ganesh for structure so. Date:12/4/2019
        
        // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022....added two fields to query COGS_Cost__c, Sales_Deduction_Cost__c...
        /*for(Material_Plant_Relation__c mprObj: [SELECT Id, Depot__c, SKU__c, Replacement_Cost__c, COGS_Cost__c, Sales_Deduction_Cost__c   
                                                FROM Material_Plant_Relation__c 
                                                WHERE Depot__c =: depotCode]){
                                                    materialPlantMapObjList.put(mprObj.SKU__c, mprObj);                                           
                                                } */                                                                     //...AND Active__c = True
        
        List<ExchangeRate__c> exchangeRateList = [SELECT Id, ExchangeRate__c, Createddate 
                                                  FROM ExchangeRate__c  where FromCurrency__c = 'USD' AND ToCurrency__c = 'BRL'
                                                  Order BY Createddate DESC];  // CR92...nik...20/07/2019
        
        List<Sales_Order__c> MOList = [SELECT id,Campaign_Type__c,Kit_Order__c FROM Sales_Order__c WHERE id=:motherOrderId limit 1];
        if(!MOList.isEmpty()){
            MOrderSOType = MOList[0].Campaign_Type__c;
        }
        //end
        
        Map<ID, List<Sales_Order_Line_Item__c>> orderItemMap = new Map<ID, List<Sales_Order_Line_Item__c>>();
        // added Recommended_price__c, DDS_Grade__c fields in query by Sagar for DDS score
        for(Sales_Order_Line_Item__c soiObj:[SELECT Id,Item_Category__c,Kit_Item_Number__c,Product_Category__c,SKU_Description__c,Quantity__c,Kit_SKU__r.SKU_Code__c,Kit_SKU__r.Brand_Name__c, Name,  Sale_Order__c, SKU_Name__c, DateofFAT__c,
                                             UnitValue__c,Kit_SKU__c, CurrencyISOCode, SKU_Code__c, Sales_Order_Line_Item__c,
                                             UnitValueWithInterest__c, Days__c,Cogs_Info__c, Recommended_price__c, DDS_Grade__c, Culture__r.Culture_Desc__c, Item_Number__c
                                             FROM Sales_Order_Line_Item__c
                                             WHERE Sale_Order__c =:motherOrderId
                                             AND SKU_Name__r.Active__c=True Order By CreatedDate]){ //Modified by Deeksha for kit selling Project
                                                 
                                                 List<Sales_Order_Line_Item__c> soiList = new List<Sales_Order_Line_Item__c>();
                                                 if(orderItemMap.containsKey(soiObj.SKU_Name__c)){
                                                     soiList = orderItemMap.get(soiObj.SKU_Name__c);
                                                 }
                                                 kitSKUSet.add(soiObj.Kit_SKU__c);    //Modified by Deeksha for kit selling Project                                 
                                                 soiList.add(soiObj);
                                                 orderItemMap.put(soiObj.SKU_Name__c, soiList);
                                             }
        
        System.debug('orderItemMap: : mother order line items '+orderItemMap);
        
        Map<String, SOMBalance> balanceMap = new Map<String, SOMBalance>();
        List<SOMBalance> soiList = OrderRequestController.getSOMBalance(motherOrderId);
        for(SOMBalance soiObj:soiList){
            balanceMap.put(soiObj.lineItemId, soiObj);
        }
        
        System.debug('soiList: SOM Balance: '+soiList.size());
        
        System.debug('balanceMap: SOM Balance: '+balanceMap.size());
        
        List<PriceDetail> priceList = new List<PriceDetail>();
        
        System.debug('priceBookId: '+priceBookId);
        
        Set<Id> skuSet = new Set<Id>();
        for(Price_Book_Details__c pbdObj:[SELECT Id, SKU__c
                                          FROM Price_Book_Details__c 
                                          WHERE Price_Book__c =: priceBookId 
                                          AND SKU__r.Active__c=True]){
                                              skuSet.add(pbdObj.SKU__c);
                                          }     
        
        Map<Id, Material_Registration__c> materialRegistrationMap = OrderRequestController.getMaterialRegistration(skuSet,accountState);
        
        /* *************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start ************************************************ */ 
        Map<Id,Blanket_SKU__c> blanketSKUMap = OrderRequestController.getBlanketSKUMap('5191');
        /* *************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End ************************************************** */ 
        
        //Patch Added by Bhavik 10/03/2019
        Set<ID> orderItemIdSet = new Set<ID>();
        // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022...added SKU__r.UOM__c field to query...
        for(Price_Book_Details__c pbdObj: [SELECT Id,SKU__r.Kit_Product__c,Price_Book__r.Kit_Price_Book__c, Kit_SKU__c,Name, Product__c, SKU__r.SKU_Code__c,SKU__r.Product_Category__c,
                                           Price_Book__c, Sales_District1__c, Sales_District1__r.Name, 
                                           SKU__c, SKU__r.SKU_Description__c, Unit_Price__c, SKU__r.UOM__c, 
                                           Monthly_Interest_Rate__c, SKU__r.Multiple_of__c,Unit_Price_R__c,
                                           Unit_Price_U__c, Minimum_Price_R__c, Minimum_Price_U__c,
                                           Future_Sales_Price_R__c,Future_Sales_Price_U__c, SKU__r.Brand_Name__c,
                                           Price_Book__r.Interest_Rate_R__c,Price_Book__r.Interest_Rate_U__c,
                                           Price_Book__r.Currency__c, CreatedDate,Price_Book__r.Apply_Minimum_Price__c
                                           FROM Price_Book_Details__c 
                                           WHERE Price_Book__c =: priceBookId
                                           AND SKU__r.Active__c=True]){//Modified by Deeksha for kit selling Project
                                               
                                               System.debug('priceList 1520: '+priceList.size());                                               
                                               //Uncomment below line if required (Not needed at the moment)                                   
                                               //if(orderItemMap.containsKey(pbdObj.SKU__c) && materialRegistrationMap.containsKey(pbdObj.SKU__c) && materialPlantMap.containsKey(pbdObj.SKU__c)){
                                               //Sales_Order_Line_Item__c soiObj = orderItemMap.get(pbdObj.SKU__c);
                                               System.debug('orderItemMap 1524: '+orderItemMap.size());        
                                               if(orderItemMap.containsKey(pbdObj.SKU__c) && materialPlantMap.containsKey(pbdObj.SKU__c)){
                                                   List<Sales_Order_Line_Item__c> soiMapList = orderItemMap.get(pbdObj.SKU__c); 
                                                   Material_Plant_Relation__c materialRelObj = materialPlantMapObjList.get(pbdObj.SKU__c);   // CR92...nik...20/07/2019
                                                   for(Sales_Order_Line_Item__c soiObj:soiMapList){
                                                       PriceDetail pd = new PriceDetail();
                                                       pd.skuId = pbdObj.SKU__c;
                                                       
                                                       //Added by Priya for RITM0176543 - SCTASK0398608
                                                       if( newmap.containskey(pbdObj.SKU__c)  && newmap.get(pbdObj.SKU__c) == 'No'){
                                                           system.debug('**Inside Child Order Map Availability No **');
                                                           pd.avail = false;
                                                       }
                                                       
                                                       if( dateMap.containskey(pbdObj.SKU__c)){
                                                           system.debug('**Inside Child Order Date Map **');
                                                           pd.minDate = String.valueOf(dateMap.get(pbdObj.SKU__c));
                                                           system.debug('**Date Min --> ' +pd.minDate );
                                                       } 
                                                       pd.applyMinPrice = pbdObj.Price_Book__r.Apply_Minimum_Price__c; // Priya RITM0237685
                                                       system.debug('**Priya OrderFilha Apply Minimum Price  --> ' +pd.applyMinPrice);
                                                       pd.skuCategory = pbdObj.SKU__r.Product_Category__c;
                                                       pd.itemCategory = soiObj.Item_Category__c;//Modified by Deeksha for kit selling Project
                                                       pd.skuDescription = pbdObj.SKU__r.SKU_Description__c;
                                                       pd.unitValue = soiObj.UnitValue__c;
                                                       pd.itemNo = soiObj.Item_Number__c;
                                                       pd.pricebookId = pbdObj.Id;
                                                       if(MOrderSOType!='Structured'){
                                                           if(materialRegistrationMap.get(pbdObj.SKU__c)!=null){
                                                               pd.regState = materialRegistrationMap.get(pbdObj.SKU__c).State__c;
                                                           }}
                                                       pd.qty = soiObj.Quantity__c;
                                                       pd.balanceQty = soiObj.Quantity__c;
                                                       pd.balanceQty2 = soiObj.Quantity__c;
                                                       pd.refKitNo = soiObj.Kit_Item_Number__c;
                                                       Date d = soiObj.DateofFAT__c;
                                                       system.debug('d'+d);
                                                       String finalFAT = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd/MM/yyyy'); //format changed by ganesh
                                                       System.debug(logginglevel.error,finalFAT);
                                                       pd.fatDate = finalFAT;
                                                       pd.unitValueWithInterest = (soiObj.UnitValueWithInterest__c).setScale(2);
                                                       pd.cultureDesc = soiObj.Culture__r.Culture_Desc__c;
                                                       pd.culture=soiObj.Culture__c;
                                                       
                                                       
                                                       
                                                       pd.skuCode = pbdObj.SKU__r.SKU_Code__c;
                                                       pd.multipleOf = pbdObj.SKU__r.Multiple_of__c;
                                                       pd.monthlyInterestRate = pbdObj.Monthly_Interest_Rate__c;
                                                       pd.orderItemId = soiObj.Id;
                                                       
                                                       pd.unitValueBRL = pbdObj.Unit_Price_R__c;
                                                       pd.unitValueUSD = pbdObj.Unit_Price_U__c;
                                                       pd.minValueBRL = pbdObj.Minimum_Price_R__c;
                                                       pd.minValueUSD = pbdObj.Minimum_Price_U__c;
                                                       pd.budgetValueBRL = pbdObj.Future_Sales_Price_R__c;
                                                       pd.budgetValueUSD = pbdObj.Future_Sales_Price_U__c;
                                                       pd.monthlyInterestRateBRL = pbdObj.Price_Book__r.Interest_Rate_R__c;
                                                       pd.monthlyInterestRateUSD = pbdObj.Price_Book__r.Interest_Rate_U__c;
                                                       
                                                       /* *********************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start ********************************** */
                                                       pd.uom = pbdObj.SKU__r.UOM__c;
                                                       if(materialRelObj.Sales_Deduction_Cost__c != null){
                                                           pd.salesDeductionCost = materialRelObj.Sales_Deduction_Cost__c;
                                                       }
                                                       
                                                       if(materialRelObj.COGS_Cost__c != null){
                                                           pd.cogsCost = materialRelObj.COGS_Cost__c;
                                                       }
                                                       
                                                       if(blanketSKUMap.containsKey(pbdObj.SKU__c)){
                                                           pd.isBlanket = true;
                                                           pd.blnkt_EndDate = String.valueOf(blanketSKUMap.get(pbdObj.SKU__c).End_Date__c);
                                                           pd.blnkt_StartDate = String.valueOf(blanketSKUMap.get(pbdObj.SKU__c).Start_Date__c);
                                                           pd.blnkt_Status = blanketSKUMap.get(pbdObj.SKU__c).Status__c;
                                                       }
                                                       /* ************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End ******************************** */
                                                       
                                                       if(materialRelObj.Replacement_Cost__c != null){                     //...CR92....Nik....22/07/2019
                                                           pd.materialPlnRplcCost = materialRelObj.Replacement_Cost__c;    
                                                           pd.e2eCost = materialRelObj.Replacement_Cost__c;                // ********SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022....     
                                                       }                    
                                                       
                                                       if(!exchangeRateList.isEmpty()){                                    //...CR92....Nik....22/07/2019
                                                           pd.exchangeRate = exchangeRateList[0].ExchangeRate__c;
                                                       }
                                                       pd.currencyCode = pbdObj.Price_Book__r.Currency__c;                 //...CR92....Nik....22/07/2019
                                                       pd.create_Dt = String.valueOf((pbdObj.CreatedDate).date());         //...CR92....Nik....22/07/2019
                                                       pd.brand = pbdObj.SKU__r.Brand_Name__c;                             //...CR93....Nik....25/07/2019 
                                                       
                                                       
                                                       //Not in use (isMO)
                                                       pd.isMO = true;
                                                       if(MOrderSOType!='Structured'){
                                                           if(materialRegistrationMap.containsKey(pbdObj.SKU__c)){
                                                               Material_Registration__c mrObj = materialRegistrationMap.get(pbdObj.SKU__c);
                                                               if(mrObj.Effective_From__c<= System.today() && mrObj.Effective_To__c>= System.today()){
                                                                   pd.isValid = true;
                                                               }
                                                           }
                                                       }else{
                                                           pd.isValid = true;  
                                                       }
                                                       //Modified by Deeksha for kit selling Project
                                                       if(pbdObj.SKU__r.Kit_Product__c && pbdObj.Price_Book__r.Kit_Price_Book__c){
                                                           pd.kitSKU = pbdObj.Kit_SKU__c;
                                                       }
                                                       if(!pbdObj.SKU__r.Kit_Product__c && pbdObj.Price_Book__r.Kit_Price_Book__c){
                                                           pd.kitProduct = false;
                                                           kitSKUSet.add(pbdObj.Kit_SKU__c);
                                                           pd.kitSKU = pbdObj.Kit_SKU__c;
                                                       }else if(!pbdObj.SKU__r.Kit_Product__c && !pbdObj.Price_Book__r.Kit_Price_Book__c){
                                                           pd.kitProduct = false;
                                                       }
                                                       //End
                                                       ////Added by Sayan, 20th July, RITM0234559
                                                       if( String.isNotBlank(CustomerPriceConvFactor) && CustomerPriceConvFactor!= null ){
                                                           if(MapCCFactor.containskey(CustomerPriceConvFactor+pbdObj.SKU__r.Brand_Name__c)){
                                                               if(string.isNotBlank(string.valueOf(MapCCFactor.get(CustomerPriceConvFactor+pbdObj.SKU__r.Brand_Name__c).Conversion_Factor__c))){
                                                                   pd.custconversionfator = MapCCFactor.get(CustomerPriceConvFactor+pbdObj.SKU__r.Brand_Name__c).Conversion_Factor__c;
                                                               }             
                                                           }else{
                                                               pd.custconversionfator = 1;
                                                           }
                                                       }else
                                                           pd.custconversionfator = 1;
                                                       ////Added by Sayan, 20th July, RITM0234559
                                                       //Patch Added by Bhavik 10/03/2019
                                                       if(!orderItemIdSet.contains(soiObj.Id) && pbdObj.Kit_SKU__c == soiObj.Kit_SKU__c) {
                                                           orderItemIdSet.add(soiObj.Id);
                                                           priceList.add(pd);  
                                                       }
                                                       System.debug('priceList 1561: '+priceList.size());   
                                                   }
                                               }
                                               //}
                                           }
        //Modified by Deeksha for kit selling Project
        if(!MOList.isEmpty()){
            if(MOList[0].Kit_Order__c){
                List<id> kitSKUList = new List<Id>();
                kitSKUList.addAll(kitSKUSet);
                List<PriceDetail> priceListTemp = fetchMOKitComponentProduct(priceList, kitSKUList,priceBookId,orderItemMap);
                priceList.clear();
                priceList = priceListTemp;
                
            }
        }
        System.debug('priceList 1563: '+priceList.size());
        System.debug('balanceMap 1563: '+balanceMap);
        for(PriceDetail pd:priceList) {
            
            if(balanceMap.containsKey(pd.orderItemId)) {
                SOMBalance balObj = balanceMap.get(pd.orderItemId);
                pd.qty = Decimal.valueOf(balObj.quantity);
                pd.balanceQty = Decimal.valueOf(balObj.balance);
                pd.balanceQty2 = Decimal.valueOf(balObj.balance);
                pd.percUsed = Decimal.valueOf(balObj.percent).setScale(2);
            }
        }
        System.debug('priceList after all processing: '+priceList.size());
        System.debug('priceList: '+priceList.size());
        System.debug('priceList: '+priceList);
        if(String.isNotBlank(orderId) && withDraft){
            Map<Id, List<Sales_Order_Line_Item__c>> socDraftItemsMap = new Map<Id, List<Sales_Order_Line_Item__c>>();
            for(Sales_Order_Line_Item__c soiObj:[SELECT Id, Quantity__c,Kit_Item_Number__c, Sale_Order__c, SKU_Name__c, DateofFAT__c,
                                                 UnitValue__c, SKU_Code__c, Sales_Order_Line_Item__c, Item_Number__c,
                                                 UnitValueWithInterest__c
                                                 FROM Sales_Order_Line_Item__c
                                                 WHERE Sale_Order__c =:orderId AND 
                                                 (Sale_Order__r.Order_Status__c = 'Draft' OR Sale_Order__r.Order_Status__c = 'Simulado') // OR Sale_Order__r.Order_Status__c = 'Simulado'
                                                 AND SKU_Name__r.Active__c=True Order By CreatedDate]){
                                                     
                                                     if(socDraftItemsMap.containsKey(soiObj.SKU_Name__c)){
                                                         socDraftItemsMap.get(soiObj.SKU_Name__c).add(soiObj);
                                                     }
                                                     else{
                                                         List<Sales_Order_Line_Item__c> socList = new List<Sales_Order_Line_Item__c>();
                 
                                                         socList.add(soiObj);
                                                         socDraftItemsMap.put(soiObj.SKU_Name__c, socList);   
                                                     }
                                                 }
            
            System.debug('socDraftItemsMap: '+socDraftItemsMap);
            System.debug('socDraftItemsMap.size(): '+socDraftItemsMap.size());
            System.debug('priceList: '+priceList);
            System.debug('priceList.size(): '+priceList.size());
            
            for(PriceDetail pdObj:priceList){
                if(socDraftItemsMap.containsKey(pdObj.skuId)){
                    List<Sales_Order_Line_Item__c> socList = socDraftItemsMap.get(pdObj.skuId);
                    //System.debug('pdObj Before: '+pdObj);
                    for(Sales_Order_Line_Item__c socObj:socList){
                        pdObj.balanceQty -= socObj.Quantity__c;
                        //pdObj.balanceQty2 = socObj.Quantity__c;
                        pdObj.balanceQty2 -= socObj.Quantity__c;
                        pdObj.itemNo = socObj.Item_Number__c;
                        //pdObj.percUsed = String.valueOf((Math.abs(pdObj.balanceQty / pdObj.qty) *100).setScale(2));
                        pdObj.percUsed = (Math.abs(pdObj.balanceQty / pdObj.qty) *100).setScale(2);
                    }
                    //System.debug('pdObj After: '+pdObj);
                }
            }
        }
        System.debug('priceList minus draft: '+priceList.size());
        
        return priceList;
    }
    
    //Modified by Deeksha for kit selling Project
    public static List<PriceDetail> fetchMOKitComponentProduct(List<PriceDetail> componentPriceList,List<Id> kitSKUs,String priceBookId,Map<ID, List<Sales_Order_Line_Item__c>> orderItemMap){
        Map<id,List<String>> origKitComponentSKUMap = new Map<id,List<id>>();
        Map<id,List<Component__c>> kitComponentMap = new Map<id,List<Component__c>>();
        for(Component__c cmp : [select id,Kit_SKU__r.Brand_Name__c,Kit_SKU__r.SKU_Code__c,Kit_SKU__r.Item_Category__c,Component_Item_Category__c,Component_Quantity__c,Kit_SKU__r.SKU_Description__c,Kit_SKU__c,Component_SKU__c from Component__c where Kit_SKU__c =:kitSKUs]){
            List<String> strList = new List<String>();
            if(origKitComponentSKUMap.containsKey(cmp.Kit_SKU__c)){
                strList = origKitComponentSKUMap.get(cmp.Kit_SKU__c);
            }
            strList.add(cmp.Component_SKU__c+''+cmp.Kit_SKU__c);  
            origKitComponentSKUMap.put(cmp.Kit_SKU__c,strList);
            
            List<Component__c> comp = new List<Component__c>();
            if(kitComponentMap.containsKey(cmp.Kit_SKU__c)){
                comp = kitComponentMap.get(cmp.Kit_SKU__c);
            }
            comp.add(cmp);
            kitComponentMap.put(cmp.Kit_SKU__c,comp);
            
        }
        Map<String,Map<String,PriceDetail>> componentPriceDetailMap =  new Map<String,Map<String,PriceDetail>>();
        for(PriceDetail pb : componentPriceList) {
            Map<String ,PriceDetail> pbMap = new Map<String,PriceDetail>();
            if(componentPriceDetailMap.containsKey(pb.skuId+pb.kitSKU)){
                pbMap = componentPriceDetailMap.get(pb.skuId+''+pb.kitSKU);
            }
            pbMap.put(pb.refKitNo+''+pb.skuId,pb);
            componentPriceDetailMap.put(pb.skuId+''+pb.kitSKU ,pbMap);
        }
        kitSKUs.clear();
        //system.debug('origKitComponentSKUMap'+origKitComponentSKUMap);
        system.debug('origKitComponentSKUMap'+origKitComponentSKUMap);
        for(id kitId : origKitComponentSKUMap.keySet()){
            Boolean addKit = true;
            for(String kitCompId : origKitComponentSKUMap.get(kitId)){
                if(componentPriceDetailMap.containsKey(kitCompId)){
                    addKit = true;
                }
                else{
                    addKit = false;
                    break;
                }
            }
            if(addKit){
                kitSKUs.add(kitId);
            }
        }
        
        //Map<id,List<PriceDetail>> kitComponentSKUMap = new Map<id,List<PriceDetail>>();
        List<PriceDetail> priceList = new List<PriceDetail>();
        system.debug('kitSKUs'+kitSKUs);
        system.debug('componentPriceDetailMap'+componentPriceDetailMap);
        for(id kitId : kitSKUs){
            
            List<Sales_Order_Line_Item__c> soiMapList = orderItemMap.get(kitId); 
            if(soiMapList!= null){
                for(Sales_Order_Line_Item__c soiObj:soiMapList){
                    PriceDetail pd = new PriceDetail();
                    pd.skuId = soiObj.SKU_Name__c;
                    pd.skuCategory = soiObj.Product_Category__c;
                    pd.itemCategory = soiObj.Item_Category__c;
                    pd.skuDescription = soiObj.SKU_Description__c;
                    pd.unitValue = soiObj.UnitValue__c;
                    pd.itemNo = soiObj.Item_Number__c;
                    pd.pricebookId = priceBookId;
                    pd.kitProduct = true;
                    pd.kitNo = soiObj.Item_Number__c;
                    pd.qty = soiObj.Quantity__c;
                    pd.balanceQty = soiObj.Quantity__c;
                    pd.balanceQty2 = soiObj.Quantity__c;
                    Date d = soiObj.DateofFAT__c;
                    system.debug('d'+d);
                    String finalFAT = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd/MM/yyyy'); //format changed by ganesh
                    System.debug(logginglevel.error,finalFAT);
                    pd.fatDate = finalFAT;
                    pd.unitValueWithInterest = (soiObj.UnitValueWithInterest__c).setScale(2);
                    pd.cultureDesc = soiObj.Culture__r.Culture_Desc__c;
                    pd.culture=soiObj.Culture__c;
                    
                    pd.skuCode = soiObj.Kit_SKU__r.SKU_Code__c;
                    //pd.multipleOf = soiObj.Kit_SKU__c.Multiple_of__c;
                    //pd.monthlyInterestRate = soiObj.Monthly_Interest_Rate__c;
                    pd.orderItemId = soiObj.Id;
                    pd.unitValueBRL = soiObj.UnitValue__c;
                    //pd.unitValueUSD = soiObj.Unit_Price_U__c;
                    //pd.minValueBRL = soiObj.Minimum_Price_R__c;
                    //pd.minValueUSD = soiObj.Minimum_Price_U__c;
                    //pd.budgetValueBRL = soiObj.Future_Sales_Price_R__c;
                    //pd.budgetValueUSD = soiObj.Future_Sales_Price_U__c;
                    //pd.monthlyInterestRateBRL = soiObj.Price_Book__r.Interest_Rate_R__c;
                    //pd.monthlyInterestRateUSD = soiObj.Price_Book__r.Interest_Rate_U__c;
                    //pd.materialPlnRplcCost = soiObj.Replacement_Cost__c;     
                    //pd.exchangeRate = exchangeRateList[0].ExchangeRate__c;
                    //pd.currencyCode = soiObj.Price_Book__r.Currency__c;                 
                    //pd.create_Dt = String.valueOf((pbdObj.CreatedDate).date());        
                    pd.brand = soiObj.Kit_SKU__r.Brand_Name__c; 
                    List<PriceDetail> kitPD = new List<PriceDetail>();  
                    for(Component__c comp :kitComponentMap.get(kitId)){
                        system.debug('@@@'+componentPriceDetailMap.get(comp.Component_SKU__c+''+kitId));
                        system.debug('@@@'+soiObj.Item_Number__c+''+comp.Component_SKU__c);
                        system.debug('@@@'+componentPriceDetailMap.get(comp.Component_SKU__c+''+kitId).get(soiObj.Item_Number__c+''+comp.Component_SKU__c));
                        componentPriceDetailMap.get(comp.Component_SKU__c+''+kitId).get(soiObj.Item_Number__c+''+comp.Component_SKU__c).componentQty = comp.Component_Quantity__c;
                        componentPriceDetailMap.get(comp.Component_SKU__c+''+kitId).get(soiObj.Item_Number__c+''+comp.Component_SKU__c).itemCategory = comp.Component_Item_Category__c;
                        kitPD.add(componentPriceDetailMap.get(comp.Component_SKU__c+''+kitId).get(soiObj.Item_Number__c+''+comp.Component_SKU__c));
                        
                    }   
                    system.debug('@@'+kitPD);
                    pd.kitProductPB = kitPD;
                    pd.isMO = true;
                    pd.isValid = true;  
                    priceList.add(pd);  
                }
            }
            System.debug('priceList 1561: '+priceList.size());   
        }
        return priceList;
    }
    
    
    @AuraEnabled
    public static List<SOMBalance> getSOMBalance(String recordId){
        
        //System.debug('getSOMBalance recordId: '+recordId);
        //Get SOM Balance quantity of Line Items for the Mother Order
        List<Sales_Order_Line_Item__c> salesOrderItemList = [SELECT ID,Sale_Order__r.Kit_Order__c,SKU_Name__c, SKU_Name__r.SKU_Description__c, Quantity__c, 
                                                             Sales_Order_Line_Item__c
                                                             FROM Sales_Order_Line_Item__c  
                                                             WHERE Sale_Order__c=:recordId];
        
        Map<Id,String> soiMap = new Map<Id,String>();
        
        for(Sales_Order_Line_Item__c soiObj:salesOrderItemList){
            soiMap.put(soiObj.Id, String.valueOf(soiObj.Quantity__c));
            
        }
        
        List<SOMBalance> balanceList = new List<SOMBalance>();
        //System.debug('recordId: '+recordId);
        
        AggregateResult[] groupedResults = 
            [SELECT SKU_Name__c, SKU_Name__r.SKU_Description__c, SUM(Quantity__c) used, Sales_Order_Line_Item__c
             FROM Sales_Order_Line_Item__c
             WHERE Sale_Order__r.Sales_Order__c=:recordId 
             AND Sale_Order__r.BrazilSalesOrderStatus__c!='Cancelled'
             AND Sale_Order__r.BrazilSalesOrderStatus__c!='Cancelado'
             AND Sale_Order__r.BrazilSalesOrderStatus__c!='Draft'
             AND Sale_Order__r.BrazilSalesOrderStatus__c!='Simulado'
             GROUP BY SKU_Name__c, SKU_Name__r.SKU_Description__c, Sales_Order_Line_Item__c];
        
        //System.debug('groupedResults: '+groupedResults);
        
        for(AggregateResult ar : groupedResults){
            String skuName = String.valueOf(ar.get('Sales_Order_Line_Item__c'));
            if(soiMap.containsKey(skuName)){
                SOMBalance balObj = new SOMBalance();
                balObj.productId = String.valueOf(ar.get('SKU_Name__c'));
                balObj.product = String.valueOf(ar.get('SKU_Description__c'));
                balObj.quantity = soiMap.get(String.valueOf(ar.get('Sales_Order_Line_Item__c')));
                balObj.used = String.valueOf(ar.get('used'));
                balObj.balance = String.valueOf(Math.abs(Decimal.valueOf(balObj.quantity) - Decimal.valueOf(balObj.used)));
                balObj.percent = String.valueOf(Math.abs((Decimal.valueOf(balObj.balance) / Decimal.valueOf(balObj.quantity)) *100).setScale(2));
                balObj.lineItemId = String.valueOf(ar.get('Sales_Order_Line_Item__c'));
                //pd.percUsed = String.valueOf(Decimal.valueOf(balObj.percent).setScale(2));
                balanceList.add(balObj);
            }
        }
        //System.debug('balanceList: '+balanceList);
        
        if(balanceList.isEmpty()){
            for(Sales_Order_Line_Item__c soiObj : salesOrderItemList){
                SOMBalance balObj = new SOMBalance();
                balObj.productId = soiObj.SKU_Name__c;
                balObj.product = soiObj.SKU_Name__r.SKU_Description__c;
                balObj.quantity = String.valueOf(soiObj.Quantity__c);
                balObj.balance = String.valueOf(soiObj.Quantity__c);
                balObj.percent = String.valueOf(Double.valueOf(balObj.balance) / Double.valueOf(balObj.quantity) *100);
                balObj.lineItemId = soiObj.Id;
                balanceList.add(balObj);
            }
            
            //System.debug('balanceList if empty: '+balanceList);
        }
        
        return balanceList;
    }
    
    @AuraEnabled
    public static List<String> getSeller(){
        //added by Swapnil
        String loggedInUser = UserInfo.getUserId();
        Id currentUserProfileId = UserInfo.getProfileId();
        String loggedInUserProfileName = [SELECT Name FROM Profile WHERE Id =: currentUserProfileId].Name;
        
        Boolean KAMObjectflag = true;
        Boolean KAMFieldflag = false;    
        List<Key_Account_Manager__c> keyAccountList = [SELECT Id FROM Key_Account_Manager__c 
                                                       WHERE Active__c = True
                                                       AND Brazil_User__c =:loggedInUser 
                                                       LIMIT 1];
        /*if(keyAccountList.isEmpty()){
KAMObjectflag = false;
}
*/
        // else{ commented by Swapnil
        List<account> liAcc = [select id from account
                               where key_account_manager__c = :loggedInUser limit 1];
        if(!liAcc.isEmpty()){
            KAMFieldflag = true;
        }
        // }
        //end
        
        List<Territory_Distributor__c> tdList = new List<Territory_Distributor__c>(); //added by swapnil
        List<Territory_Distributor__c> tdList2 = new List<Territory_Distributor__c>();
        if(KAMObjectflag){ // added by Swapnil commented latest
            if(loggedInUserProfileName!='Brazil Barter Manager')
            {
                tdList = [SELECT ID, Name, TerritoryCode__c, SBU__c, Region__c, Open_TM_Code__c,
                          Zone__r.ZonalHead__c, SBU__r.SBUUser__c, Region__r.RegionHead__c,Region__r.Brazil_Marketing_Ops_Manager__c,
                          Zone__c, TerritoryManager__c, BarterManager__c
                          FROM Territory_Distributor__c 
                          WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                          //AND TerritoryManagerActive__c = True
                          AND (TerritoryManager__c=: loggedInUser 
                               OR Region__r.RegionHead__c=: loggedInUser
                               OR Region__r.Brazil_Marketing_Ops_Manager__c=: loggedInUser
                               OR Zone__r.ZonalHead__c=: loggedInUser
                               OR SBU__r.SBUUser__c=: loggedInUser
                               OR BarterManager__c=: loggedInUser
                              )
                          
                          ORDER BY LastModifiedDate DESC ];
            }
            else
            {
                tdList = [SELECT ID, Name, TerritoryCode__c, SBU__c, Region__c, Open_TM_Code__c,
                          Zone__r.ZonalHead__c, SBU__r.SBUUser__c, Region__r.RegionHead__c,Region__r.Brazil_Marketing_Ops_Manager__c,
                          Zone__c, TerritoryManager__c, BarterManager__c
                          FROM Territory_Distributor__c 
                          WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                          //AND TerritoryManagerActive__c = True
                          AND (TerritoryManager__c=: loggedInUser 
                               OR Region__r.RegionHead__c=: loggedInUser
                               OR Region__r.Brazil_Marketing_Ops_Manager__c=: loggedInUser
                               OR Zone__r.ZonalHead__c=: loggedInUser
                               OR SBU__r.SBUUser__c=: loggedInUser
                               OR BarterManager__c=: loggedInUser
                               OR BarterManager__r.profile.name ='Brazil Barter Manager' 
                              ) // need this for all users >> Grazitti(Tanuj)- RITM0333006-19 Aug 2022
                          
                          ORDER BY TerritoryManager__r.Name ASC];  // added asc for   RITM0490875 GRZ(Javed) 20-01-2023
            }
            
            if(!tdList.isEmpty()){
                String territoryUser = tdList[0].TerritoryManager__c;
                String regionalHeadUser = tdList[0].Region__r.RegionHead__c;
                String regionalBrazilMarketingOpsManager= tdList[0].Region__r.Brazil_Marketing_Ops_Manager__c;
                
                String zonalHeadUser = tdList[0].Zone__r.ZonalHead__c;
                String sbuUser = tdList[0].SBU__r.SBUUser__c;
                String barterManager = tdList[0].BarterManager__c;//uncommented this >> Grazitti(Tanuj)- RITM0333006-8 Aug 2022
                
                if(loggedInUser==territoryUser ){
                    tdList2 = [SELECT ID, TerritoryManager__c, TerritoryCode__c,Regional_Manager_Id__c,Open_TM_Code__c,  TerritoryManager__r.Name 
                               FROM Territory_Distributor__c 
                               WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                               //AND TerritoryManagerActive__c = True
                               AND Region__r.RegionHead__c=:regionalHeadUser
                               AND Region__r.Brazil_Marketing_Ops_Manager__c=:regionalBrazilMarketingOpsManager
                               
                               AND TerritoryManager__c!=:territoryUser ORDER BY TerritoryManager__r.Name ASC];  // added asc for   RITM0490875 GRZ(Javed) 20-01-2023
                }
                
                if(loggedInUser==regionalHeadUser ){
                    tdList2 = [SELECT ID, TerritoryManager__c,TerritoryCode__c,Regional_Manager_Id__c,Open_TM_Code__c, TerritoryManager__r.Name 
                               FROM Territory_Distributor__c 
                               WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                               //AND TerritoryManagerActive__c = True
                               AND Region__r.RegionHead__c=:regionalHeadUser
                               ORDER BY TerritoryManager__r.Name ASC];  // added asc for   RITM0490875 GRZ(Javed) 20-01-2023
                }
                if(loggedInUser==regionalBrazilMarketingOpsManager ){
                    tdList2 = [SELECT ID, TerritoryManager__c,TerritoryCode__c,Regional_Manager_Id__c,Open_TM_Code__c, TerritoryManager__r.Name 
                               FROM Territory_Distributor__c 
                               WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                               //AND TerritoryManagerActive__c = True
                               AND Region__r.Brazil_Marketing_Ops_Manager__c=:regionalBrazilMarketingOpsManager
                               ORDER BY TerritoryManager__r.Name ASC];  // added asc for   RITM0490875 GRZ(Javed) 20-01-2023  
                }
                
                if(loggedInUser==zonalHeadUser){
                    tdList2 = [SELECT ID, TerritoryManager__c,TerritoryCode__c,Regional_Manager_Id__c,Open_TM_Code__c, TerritoryManager__r.Name 
                               FROM Territory_Distributor__c 
                               WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                               //AND TerritoryManagerActive__c = True
                               AND Zone__r.ZonalHead__c=:zonalHeadUser
                               ORDER BY TerritoryManager__r.Name ASC];  // added asc for   RITM0490875 GRZ(Javed) 20-01-2023
                }
                
                if(loggedInUser==sbuUser){
                    tdList2 = [SELECT ID, TerritoryManager__c,TerritoryCode__c,Regional_Manager_Id__c,Open_TM_Code__c, TerritoryManager__r.Name 
                               FROM Territory_Distributor__c 
                               WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                               //AND TerritoryManagerActive__c = True
                               AND SBU__r.SBUUser__c=:sbuUser
                               ORDER BY LastModifiedDate DESC];  
                }
                if(loggedInUserProfileName=='Brazil Barter Manager'){//added this for barter Manager Profile >> Grazitti(Tanuj)- RITM0333006-8 Aug 2022
                    tdList2 = [SELECT ID, TerritoryManager__c,TerritoryCode__c,Regional_Manager_Id__c,Open_TM_Code__c, TerritoryManager__r.Name 
                               FROM Territory_Distributor__c 
                               WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                               AND BarterManager__c=:barterManager
                               ORDER BY TerritoryManager__r.Name ASC];  //sorted by name >> Grazitti(Tanuj)- RITM0333006-8 Aug 2022
                }
            }
        }
        //added by Swapnil
        //if logged in user is Key account manager of account
        if(KAMFieldflag){
            Map<Id, account> MapAcc = new Map<Id, account>([select id from account where Key_Account_Manager__c = :loggedInUser]);
            system.debug('MapAcc'+MapAcc);
            if(MapAcc.values().size()>0){
                list<Customer_and_Region_Mapping__c> liCRM = [select Customer_Name__c, 
                                                              CustomerRegion__c 
                                                              from Customer_and_Region_Mapping__c
                                                              where Customer_Name__c = :MapAcc.keySet() ] ;
                system.debug('liCRM'+liCRM);    
                map<Id ,Customer_and_Region_Mapping__c> mapCRM = new map<Id ,Customer_and_Region_Mapping__c>();
                for(Customer_and_Region_Mapping__c CRM: liCRM){
                    if(!mapCRM.containsKey(CRM.CustomerRegion__c)){
                        mapCRM.put(CRM.CustomerRegion__c, CRM);  
                    }
                    // mapCRM.get(CRM.CustomerRegion__c).add(CRM);
                }
                system.debug('mapCRM'+mapCRM);
                for(Territory_Distributor__c TD: [SELECT ID, TerritoryManager__c,TerritoryCode__c,Regional_Manager_Id__c,Open_TM_Code__c, TerritoryManager__r.Name 
                                                  FROM Territory_Distributor__c 
                                                  WHERE SalesOrg__r.Sales_Org_Code__c = '5191'                           
                                                  AND id = :mapCRM.keySet()  ]){
                                                      tdList2.add(TD);   
                                                  }
                system.debug('tdList2'+tdList2);
            }
        }
        //
        //end
        List<String> options = new List<String>();
        Set<String> tmNameSet = new Set<String>();
        for(Territory_Distributor__c tdObj:tdList2){
            if(String.isNotBlank(tdObj.TerritoryManager__c) && String.isBlank(tdObj.Open_TM_Code__c)){
                if(tdObj.TerritoryManager__c != UserInfo.getUserId()){
                    if(!tmNameSet.contains(tdObj.TerritoryManager__r.Name)){
                        options.add(tdObj.TerritoryCode__c+' - '+tdObj.TerritoryManager__r.Name+'*'+tdObj.TerritoryManager__c);
                        tmNameSet.add(tdObj.TerritoryManager__r.Name);                
                    }
                }
            }else if(String.isNotBlank(tdObj.Open_TM_Code__c) && String.isBlank(tdObj.TerritoryManager__c)){
                options.add(tdObj.TerritoryCode__c+' - '+' Open User'+'*'+loggedInUser+'~~'+ tdObj.TerritoryCode__c);  
            }
        }
        return options;
    } 
    
    //Returns True/False after checking if default business values exist.
    public static Boolean hasDefaultBusinessRules(){
        Map<String, Business_Rule__c> defaultBusinessRulesMap = OrderRequestController.getDefaultBusinessRulesMap();
        Boolean flag = false;
        if(!defaultBusinessRulesMap.isEmpty()){
            if(defaultBusinessRulesMap.keyset().size() >= 4){
                flag = true;
            }
        }
        return flag;
    }
    
    
    //Method to populate custom wrapper with all the picklist values from Schema/Database and return to JS Controller
    //Also returns User details, Business Rule Info and default business rule for 'SP'
    //modified by Ankita&Krishanu@wipro
    @AuraEnabled
    public static OrderFields getOrderFields(Boolean keyAccount,String sellerId,Boolean isSimulated,boolean avec,string custid,string ordertype,boolean isStructure,boolean isKit){
        selectedSellerId = sellerId;
        isKeyAccount = keyAccount;
        OrderFields ofObj = new OrderFields();
        ofObj.orderTypeList = OrderRequestController.getOrderType();
        ofObj.CancellationReasonOptions = OrderRequestController.getCancellationReasonOptions();//Added by tanuj 6feb2023
        ofObj.paymentMethodList = OrderRequestController.getPaymentMethod();
        ofObj.currencyList = OrderRequestController.getCurrency();
        ofObj.paymentTermsMap = OrderRequestController.getPaymentTermsMap();
        //RITM0355165 - Brazil sales order enhancement to track revenue of cancel order
        ofObj.Last24MonthsSalesOrdersList = OrderRequestController.getLast24MonthsSalesOrders();
        //RITM0355165 - Brazil sales order enhancement to track revenue of cancel order
        ofObj.incoTermsList = OrderRequestController.getIncoTerms();
        // ofObj.culturalDescList = OrderRequestController.getCultureDesc();
        ofObj.priceList = OrderRequestController.getPriceListValues(isKeyAccount,sellerId,isSimulated,avec,custid,ordertype,isStructure,isKit);// modified by Krishanu&Aditya
        ofObj.userObj = [Select Id, Profile.Name, Show_List_Value__c FROM User  WHERE Id=:UserInfo.getUserId()];
        ofObj.isKeyAccountManager = OrderRequestController.getKeyAccountManager(UserInfo.getUserId());
        ofObj.hasDefaultRules = OrderRequestController.hasDefaultBusinessRules();
        Map<String, Business_Rule__c> defaultBusinessRulesMap = OrderRequestController.getDefaultBusinessRulesMap();
        if(defaultBusinessRulesMap.containsKey('Sales Person')){
            ofObj.defaultRule = defaultBusinessRulesMap.get('Sales Person');
        }
        
        /* ************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start ************************************************************* */
        List<Admin_MPT_Colombia__c> adminMPTList = [SELECT Id, Name, Active__c, Level_1_max__c, Level_1_min__c, Level_2_max__c, 
                                                    Level_2_min__c, Level_3_below__c, Sales_Org__c, Approval_Level__c 
                                                    FROM Admin_MPT_Colombia__c WHERE Sales_Org__r.Sales_Org_Code__c = '5191' LIMIT 1];
        if(adminMPTList.size()>0){
            
            AdminMPTParameters adminMPT = new AdminMPTParameters();
            adminMPT.id = adminMPTList[0].id;
            adminMPT.level1Max = adminMPTList[0].Level_1_max__c;
            adminMPT.level1Min = adminMPTList[0].Level_1_min__c;
            adminMPT.level2Max = adminMPTList[0].Level_2_max__c;
            adminMPT.level2Min = adminMPTList[0].Level_2_min__c;
            adminMPT.level3Below = adminMPTList[0].Level_3_below__c;
            adminMPT.approvalLevel = adminMPTList[0].Approval_Level__c;
            adminMPT.active = adminMPTList[0].Active__c;
            
            ofObj.adminparameters = adminMPT;
        }                                        
        /* ************************ SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End ********************************************************** */
        return ofObj;
    }
    
    /* ********************************* Start SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022 ************************************ */
    @AuraEnabled
    public static CustomerTaxAndFreight getCustomerTaxFreight(String regnName){
        CustomerTaxAndFreight taxFreight = new CustomerTaxAndFreight();
        if(regnName != null || String.isNotBlank(regnName) || regnName != ''){
            List<Business_Rule__c> bRuleList = [SELECT Id,Name,Freight__c,Taxes__c FROM Business_Rule__c WHERE Name =: regnName LIMIT 1];
            if(bRuleList.size()>0){
                taxFreight.tax = bRuleList[0].Taxes__c;
                taxFreight.freight = bRuleList[0].Freight__c;
                taxFreight.customerRegion = bRuleList[0].Name;
                taxFreight.id = bRuleList[0].id;
            }
        }
        return taxFreight;
    }
    /* ***************************** End SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022 **************************************** */
    /*
* Non Aura Methods
* Used in Above Method
*/
    //Method to get all the Order Types from Schema of Sales Order custom object.
    public static List<String> getOrderType(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Sales_Order__c.Type_of_Order__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        return options;
    } 
    
    //Method to get all the picklist values of Payment Methods from custom object.
    public static List<String> getPaymentMethod(){
        List<String> options = new List<String>();
        for(Payment_Method__c ptObj:[SELECT Id, Name, Payment_Method_Code__c, 
                                     Distribution_Channel__c, Division__c, Sales_Org__c 
                                     FROM Payment_Method__c 
                                     WHERE Active__c=True 
                                     AND Sales_Org__r.Sales_Org_Code__c = '5191'
                                     ORDER BY Payment_Method_Code__c]){
                                         options.add(ptObj.Name+'*'+ptObj.Id);
                                     }
        return options;
    } 
    
    //Method to get all the picklist values of culture descriptions from custom object.
    @AuraEnabled
    public static List<String> getCultureDesc(string pbid,string ordertype,string motherOrderId){
        List<String> options = new List<String>();
        options.add('None');
        if(ordertype!='ORDEM FILHA' )
        {
            List<Price_Book_Crop_Culture__c> pbCC=[Select Id,Price_Book_Brazil__c,Crop_Culture1__c from Price_Book_Crop_Culture__c where Price_Book_Brazil__c=:pbid or Price_Book_Brazil__r.Name=:pbid ];
            
            for( Price_Book_Crop_Culture__c pbc:pbCC){
                for(Culture__c ptObj:[SELECT Id, Name, Culture_Code__c, Culture_Desc__c, Division__c, Sales_Org__c,Price_Book_Brazil__c
                                      FROM Culture__c 
                                      WHERE Active__c=True 
                                      AND Sales_Org__r.Sales_Org_Code__c = '5191'
                                      AND id=:pbc.Crop_Culture1__c
                                      
                                      ORDER BY Culture_Code__c]){
                                          if(!options.contains(ptObj.Culture_Desc__c))
                                              options.add(ptObj.Culture_Desc__c);
                                      }
                
            }
        }
        else
        {
            List<Sales_Order_Line_Item__c> solitem=[Select id, Name,Sale_Order__c,Culture__c from Sales_Order_Line_Item__c where Sale_Order__c=:motherOrderId];
            for(Sales_Order_Line_Item__c soitem:solitem){
                for(Culture__c ptObj:[SELECT Id, Name, Culture_Code__c, Culture_Desc__c, Division__c, Sales_Org__c 
                                      FROM Culture__c 
                                      WHERE Active__c=True 
                                      AND Sales_Org__r.Sales_Org_Code__c = '5191'
                                      AND id=:soitem.Culture__c
                                      ORDER BY Culture_Code__c]){  
                                          if(!options.contains(ptObj.Culture_Desc__c))
                                              options.add(ptObj.Culture_Desc__c);
                                      }
            }
            
        }
        //System.debug('Culture Options: '+options);
        return options;
        
    } 
    
    //Method to get all the currency picklist values from Schema of Sales Order Custom Object.
    public static List<String> getCurrency(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Sales_Order__c.Currency_Brazil__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            system.debug('PicklistEntry Value:' + f.getValue() + ' Translated Label:' + f.getLabel());
            //options.add(f.getLabel());
            options.add(f.getLabel()+'*'+f.getValue());
        }
        return options;
    } 
    
    
    //Method to get all the CancellationReason picklist values from Schema of Sales Order line items Custom Object. // Added by tanuj 6feb 2023
    public static List<object> getCancellationReasonOptions(){
        List<object> options = new List<object>();
        Schema.DescribeFieldResult fieldResult = Sales_Order_Line_Item__c.Cancellation_Reason__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            system.debug('PicklistEntry Value:' + f.getValue() + ' Translated Label:' + f.getLabel());
            options.add(new map<string,string>{'label'=>f.getLabel(),'value'=>f.getValue()});
        }
        system.debug('==='+options);
        return options;
    } 
    
    //Method to get a map of picklist values of Payment Terms from custom object.
    public static Map<String,Payment_Term__c> getPaymentTermsMap(){
        Map<String,Payment_Term__c> options = new Map<String,Payment_Term__c>();
        for(Payment_Term__c ptObj:[SELECT Id, Days_to_calc_interest__c, Payment_Term_Code__c, 
                                   Payterms_Desc__c, Sales_Org__c, Maturity_Date_Mandatory__c 
                                   FROM Payment_Term__c
                                   WHERE Active__c = True
                                   AND Sales_Org__r.Sales_Org_Code__c = '5191'
                                   ORDER BY Payment_Term_Code__c]){
                                       
                                       options.put(ptObj.Payment_Term_Code__c+' '+ptObj.Payterms_Desc__c, ptObj);
                                   }
        return options;
    }
    
    //----------------------------Added to get customerconversionvalue----------------  
    @AuraEnabled 
    public static Decimal getCustomerConversionFactor(String AccountId,String productName){
        system.debug('CustConversionFactor inside get ='+AccountId);
        String ConversionFactor = '';
        List<Account> lstAcc = new List<Account>();
        if(AccountId != null && AccountId != '') {
            lstAcc = [SELECT Id, Price_Conversion_Group__c FROM Account WHERE Id=:AccountId];
            if(lstAcc.size() > 0) {
                ConversionFactor = lstAcc.get(0).Price_Conversion_Group__c;
            }
        }
        
        system.debug('ConversionFactor from query='+ConversionFactor);
        Decimal CustConversionFactor=1;
        system.debug('CustConversionFactor Declared ='+CustConversionFactor);
        Map<string,Customer_Conversion_factor__c> MapCCF = new Map<string,Customer_Conversion_factor__c>();
        /*for (Customer_Conversion_factor__c DM: [select id, Conversion_Factor__c, Customer_Group__c,
Sales_Org__c, Combination_Key__c
from Customer_Conversion_factor__c]){
MapCCF.put(DM.Customer_Group__c, DM);   
}*/
        for (Customer_Conversion_factor__c DM: [select id, Conversion_Factor__c, Customer_Group__c,
                                                Sales_Org__c, Combination_Key__c,Brand_Name__c
                                                from Customer_Conversion_factor__c]){
                                                    MapCCF.put(DM.Customer_Group__c+DM.Brand_Name__c, DM); //updated by Ujjwal Kumar for <ticket number > on 01-Nov-2021  
                                                }
        if(MapCCF.containskey(ConversionFactor+productName)){
            if(string.isNotBlank(string.valueOf(MapCCF.get(ConversionFactor+productName).Conversion_Factor__c))){
                CustConversionFactor = MapCCF.get(ConversionFactor+productName).Conversion_Factor__c;
            }             
        } 
        system.debug('return1 ='+CustConversionFactor);
        return CustConversionFactor;
    }
    
    @AuraEnabled
    public static PriceBookPaymentTermWrapper getPBPaymentTerms(String priceBook_id){
        
        PriceBookPaymentTermWrapper ofObj = new PriceBookPaymentTermWrapper();
        
        ofObj.payTermsDays = OrderRequestController.getPaymentTermsDays(priceBook_id);
        ofObj.payTermsDates = OrderRequestController.getPaymentTermsDates(priceBook_id);
        ofObj.payTermBR71 = OrderRequestController.getBR71PaymentTerm();
        ofObj.priceBook = OrderRequestController.getPriceBook(priceBook_id);
        return ofObj;
    }
    
    // for price book payment terms in days....
    public static Map<String,Campaign_Payment_Terms__c> getPaymentTermsDays(String pb_id){
        Map<String,Campaign_Payment_Terms__c> options = new Map<String,Campaign_Payment_Terms__c>();
        for(Campaign_Payment_Terms__c ptObj:[SELECT Id, Name, Price_Book_Brazil__c, Payment_Term__c,Payment_Term__r.Payment_Term_Code__c,Payment_Term__r.Payterms_Desc__c,
                                             Payment_Term__r.Days_to_calc_interest__c, 
                                             Payment_Term_in_Date__c FROM Campaign_Payment_Terms__c 
                                             where Price_Book_Brazil__c=:pb_id AND Payment_Term__r.Active__c = True]){ // Added payment term active check RITM0447500 GRZ(Nikhil Verma) 01-11-2022
                                                 
                                                 options.put(ptObj.Payment_Term__r.Payment_Term_Code__c+' '+ptObj.Payment_Term__r.Payterms_Desc__c, ptObj);
                                             }
        return options;
    }
    
    // for price book payment terms in DATES....
    public static Map<String,Campaign_Payment_Terms__c> getPaymentTermsDates(String pb_id){
        Map<String,Campaign_Payment_Terms__c> options = new Map<String,Campaign_Payment_Terms__c>();
        for(Campaign_Payment_Terms__c ptObj:[SELECT Id, Name, Price_Book_Brazil__c, Payment_Term__c,Payment_Term__r.Payment_Term_Code__c,Payment_Term__r.Payterms_Desc__c,
                                             Payment_Term__r.Days_to_calc_interest__c, 
                                             Payment_Term_in_Date__c FROM Campaign_Payment_Terms__c 
                                             where Price_Book_Brazil__c=:pb_id]){
                                                 
                                                 options.put(String.valueof(ptObj.Payment_Term_in_Date__c), ptObj);
                                             }
        return options;
    }
    
    // for BR71 payment terms in DATES....
    public static Payment_Term__c  getBR71PaymentTerm(){
        
        Payment_Term__c br71Term = new Payment_Term__c();
        br71Term =[SELECT Id, Days_to_calc_interest__c, Payment_Term_Code__c, Payterms_Desc__c, Sales_Org__c, Maturity_Date_Mandatory__c 
                   FROM Payment_Term__c WHERE Active__c = True AND Sales_Org__r.Sales_Org_Code__c = '5191' AND Payment_Term_Code__c='BR71'
                   AND Payterms_Desc__c='INFORMAR VENCIMENTO' limit 1];
        return br71Term;
        
    }
    
    // for interest date.......
    public static Price_Book__c  getPriceBook(String pb_id){
        
        Price_Book__c pb = new Price_Book__c();
        pb =[SELECT Id, Name, Interest_Date__c,Sales_Order_Block_Date__c FROM Price_Book__c where id=:pb_id];
        
        return pb;
        
    }
    //added by krishanu@wipro
    @AuraEnabled
    public static Price_Book__c getPriceBookValues(String pb_id){
        
        Price_Book__c pb = new Price_Book__c();
        List<Price_Book__c> lstPB = new List<Price_Book__c>();
        if(pb_id != null && pb_id != '') {
            lstPB =[SELECT Id,Currency__c, CreatedDate FROM Price_Book__c where id=:pb_id];
            if(lstPB.size() > 0) {
                pb = lstPB.get(0);
            }
        }
        return pb;
        
    } 
    
    //Method to get all picklist values of Inco Terms from custom object.
    public static List<String> getIncoTerms(){
        List<String> options = new List<String>();
        for(Inco_Term__c ictObj:[SELECT Id, Name, IncoTerm_Code__c, IncoTerm_Desc__c, Sales_Org__c, 
                                 Active__c, Distribution_Channel__c, Division__c 
                                 FROM Inco_Term__c 
                                 WHERE Active__c = True
                                 AND Sales_Org__r.Sales_Org_Code__c = '5191'
                                 ORDER BY IncoTerm_Code__c]){
                                     
                                     options.add(ictObj.IncoTerm_Code__c+'*'+ictObj.Id);
                                 }
        return options;
    }
    
    //Method to check if loggedInUser is Key Account Manager
    public static Boolean getKeyAccountManager(String loggedInUser) {
        Boolean flag = false;
        
        List<Key_Account_Manager__c> keyAccountList = [SELECT Id FROM Key_Account_Manager__c 
                                                       WHERE Active__c = True
                                                       AND Brazil_User__c =:loggedInUser 
                                                       LIMIT 1];
        if(!keyAccountList.isEmpty()){
            flag = true;
        }
        //added by swapnil to show option in case user is not available in KAM object
        else{
            List<account> liAcc = [select id from account
                                   where key_account_manager__c = :loggedInUser limit 1];
            if(!liAcc.isEmpty()){
                flag = true;
            }
        }
        
        return flag;
    }    
    
    //Get all the pricelists belonging to the Sales District of the current Logged In user 
    //modified by krishanu&Ankita@wipro
    @AuraEnabled
    public static List<String> getPriceListValues(Boolean keyAccount,String sellerId, Boolean isSimulated,boolean avec, string custid, string ordertype,boolean isStructure,boolean isKit){
        selectedSellerId = sellerId;
        isKeyAccount = keyAccount;
        List<String> options = new List<String>();
        
        List<String> regionList = OrderRequestController.getRegion();
        List<string> pblist = new List<string>();
        
        Set<Id> salesDistrictPriceBookSet = new Set<Id>();
        
        for(Price_Book_Sales_District__c sdObj:[SELECT Id, Name, Price_Book__c, Sales_District1__c
                                                FROM Price_Book_Sales_District__c
                                                WHERE Sales_District1__c IN: regionList AND Price_Book__r.Expiry_Date__c >= TODAY]){
                                                    
                                                    salesDistrictPriceBookSet.add(sdObj.Price_Book__c);
                                                }
        if(salesDistrictPriceBookSet.size() > 0) {
            List<Price_Book__c> lstPriceBook = [Select Id from Price_Book__c where Id IN: salesDistrictPriceBookSet AND Id NOT IN (Select Price_Book_Brazil__c FROM Customer__c)];
            if(lstPriceBook.size() > 0) {
                for(Price_Book__c oPB: lstPriceBook){
                    pblist.add(oPB.Id);
                }
            }

        } 
        
        if(custid!=null){
            system.debug(custid);
            
            
            
            for(Price_Book__c cobj:[Select Id, Name from Price_Book__c where Id in (Select Price_Book_Brazil__c FROM Customer__c where Account__r.Id =: custid)]){
                pblist.add(cobj.Id);
            }                          
            
        } 
        /*
//added by swapnil -- to get regional Pricebook
Set<Id> salesDistrictPriceBookSetRefine = new Set<Id>();
for(Price_Book__c sdObj:[SELECT Id, Name, (select id from Price_Books_Sales_Districts__r)
FROM Price_Book__c
WHERE Id IN: salesDistrictPriceBookSet]){
list<Price_Book_Sales_District__c> lipb = sdObj.Price_Books_Sales_Districts__r;
if(lipb.size()==1){
salesDistrictPriceBookSetRefine.add(sdObj.Id);
}                                      
}  

*/
        
        System.debug('isSimulated '+isSimulated+salesDistrictPriceBookSet);
        if(isSimulated==true) {
            if(ordertype!='ORDEM FILHA'){
                System.debug('ordertype');
                System.debug('Test');
                for(Price_Book__c pbObj:[SELECT Id, Name, Division__c, Currency__c, Valid_From__c, Expiry_Date__c ,Campaign_Type__c,//(select id from Customers__r),
                                         Optional_Simulator__c,AVEC_Price_Book__c, Interest_Date__c,Simulation_Price_Book__c FROM Price_Book__c 
                                         WHERE //Id IN:salesDistrictPriceBookSet //salesDistrictPriceBookSet
                                         id IN :pblist
                                         AND Valid_From__c <= TODAY
                                         AND Expiry_Date__c >= TODAY
                                         AND isActive__c = True
                                         AND Status__c = 'Approved'
                                         AND Base_Price_Book__c = false
                                         AND Kit_Price_Book__c=:isKit
                                         AND AVEC_Price_Book__c = :avec                          
                                         ORDER BY Name])
                {// if(pbobj.Customer__r.)
                    options.add(pbObj.Name+'*'+pbObj.Id+'*'+pbObj.Campaign_Type__c+'*'+pbObj.Optional_Simulator__c+'*'+pbObj.AVEC_Price_Book__c+'*1');
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    

                }
                
                /*else if(isStructure==true)
{
System.debug('Test');
//idforsimulation = clientOnlyRecordType.Id;
//clientOnlyRecordType.id == '0120K000001HskHQAS';
for(Price_Book__c pbObj:[SELECT Id, Name, Division__c, Currency__c, Valid_From__c, Expiry_Date__c ,Campaign_Type__c,
Optional_Simulator__c, Interest_Date__c,Simulation_Price_Book__c,AVEC_Price_Book__c FROM Price_Book__c
WHERE Id IN:salesDistrictPriceBookSet //salesDistrictPriceBookSet
AND id IN :pblist
AND Valid_From__c <= TODAY
AND Expiry_Date__c >= TODAY
AND isActive__c = True
AND Status__c = 'Approved'
AND Base_Price_Book__c = True
AND Campaign_Type__c='Structured'
AND Simulation_Price_Book__c= true
AND AVEC_Price_Book__c = false   
ORDER BY Name])
{
options.add(pbObj.Name+'*'+pbObj.Id+'*'+pbObj.Campaign_Type__c+'*'+pbObj.Optional_Simulator__c);

}
}

else{
for(Price_Book__c pbObj:[SELECT Id, Name, Division__c, Currency__c, Valid_From__c, Expiry_Date__c ,Campaign_Type__c,
Optional_Simulator__c, Interest_Date__c,Simulation_Price_Book__c,AVEC_Price_Book__c FROM Price_Book__c
WHERE Id IN:salesDistrictPriceBookSet //salesDistrictPriceBookSet
AND id IN :pblist
AND Valid_From__c <= TODAY
AND Expiry_Date__c >= TODAY
AND isActive__c = True
AND Status__c = 'Approved'
AND Base_Price_Book__c = false
AND Simulation_Price_Book__c= true
AND AVEC_Price_Book__c = false   
ORDER BY Name])
{
options.add(pbObj.Name+'*'+pbObj.Id+'*'+pbObj.Campaign_Type__c+'*'+pbObj.Optional_Simulator__c+'*'+pbObj.AVEC_Price_Book__c+'*2');

}
}*/
            }
            else if (ordertype=='ORDEM FILHA'){
                //if(avec==true){
                System.debug('Test');
                for(Price_Book__c pbObj:[SELECT Id, Name, Division__c, Currency__c, Valid_From__c, Expiry_Date__c ,Campaign_Type__c,//(select id from Customers__r),
                                         Optional_Simulator__c,AVEC_Price_Book__c, Interest_Date__c,Simulation_Price_Book__c FROM Price_Book__c 
                                         WHERE Id IN:salesDistrictPriceBookSet //salesDistrictPriceBookSet
                                         
                                         AND Valid_From__c <= TODAY
                                         AND Expiry_Date__c >= TODAY
                                         AND isActive__c = True
                                         AND Status__c = 'Approved'
                                         AND Base_Price_Book__c = false
                                         AND Kit_Price_Book__c=:isKit
                                         AND AVEC_Price_Book__c = :avec                          
                                         ORDER BY Name])
                {// if(pbobj.Customer__r.)
                    options.add(pbObj.Name+'*'+pbObj.Id+'*'+pbObj.Campaign_Type__c+'*'+pbObj.Optional_Simulator__c+'*'+pbObj.AVEC_Price_Book__c+'*2');
                    
                }
                //}
                /*else if(isStructure==true)
{
System.debug('Test');
//idforsimulation = clientOnlyRecordType.Id;
//clientOnlyRecordType.id == '0120K000001HskHQAS';
for(Price_Book__c pbObj:[SELECT Id, Name, Division__c, Currency__c, Valid_From__c, Expiry_Date__c ,Campaign_Type__c,
Optional_Simulator__c, Interest_Date__c,Simulation_Price_Book__c,AVEC_Price_Book__c FROM Price_Book__c
WHERE Id IN:salesDistrictPriceBookSet //salesDistrictPriceBookSet

AND Valid_From__c <= TODAY
AND Expiry_Date__c >= TODAY
AND isActive__c = True
AND Status__c = 'Approved'
AND Base_Price_Book__c = True
AND Campaign_Type__c='Structured'
AND Simulation_Price_Book__c= true
AND AVEC_Price_Book__c = false   
ORDER BY Name])
{
options.add(pbObj.Name+'*'+pbObj.Id+'*'+pbObj.Campaign_Type__c+'*'+pbObj.Optional_Simulator__c);

}
}
else 
{
System.debug('Test');
//idforsimulation = clientOnlyRecordType.Id;
//clientOnlyRecordType.id == '0120K000001HskHQAS';
for(Price_Book__c pbObj:[SELECT Id, Name, Division__c, Currency__c, Valid_From__c, Expiry_Date__c ,Campaign_Type__c,
Optional_Simulator__c, Interest_Date__c,Simulation_Price_Book__c,AVEC_Price_Book__c FROM Price_Book__c
WHERE Id IN:salesDistrictPriceBookSet //salesDistrictPriceBookSet

AND Valid_From__c <= TODAY
AND Expiry_Date__c >= TODAY
AND isActive__c = True
AND Status__c = 'Approved'
AND Base_Price_Book__c = false
AND Simulation_Price_Book__c= true
AND AVEC_Price_Book__c = false   
ORDER BY Name])
{
options.add(pbObj.Name+'*'+pbObj.Id+'*'+pbObj.Campaign_Type__c+'*'+pbObj.Optional_Simulator__c+'*'+pbObj.AVEC_Price_Book__c+'*4');

}
}*/
            }
        }
        else {
            if(ordertype!='ORDEM FILHA'){
                system.debug('issim false: ');
                //if(avec==true){
                system.debug('inside avec true');
                system.debug(salesDistrictPriceBookSet);
                system.debug(pblist);
                for(Price_Book__c pbObj:[SELECT Id, Name, Division__c, Currency__c, Valid_From__c, Expiry_Date__c ,Campaign_Type__c,
                                         Optional_Simulator__c,AVEC_Price_Book__c, Interest_Date__c,Simulation_Price_Book__c FROM Price_Book__c
                                         WHERE //Id IN:salesDistrictPriceBookSet //salesDistrictPriceBookSet
                                         id IN :pblist
                                         AND Valid_From__c <= TODAY
                                         AND Expiry_Date__c >= TODAY
                                         AND isActive__c = True
                                         AND Status__c = 'Approved'
                                         AND Base_Price_Book__c = false
                                         AND Simulation_Price_Book__c= false
                                         AND AVEC_Price_Book__c = :avec
                                         AND Kit_Price_Book__c=:isKit                          
                                         ORDER BY Name])
                    
                    
                    
                    
                    
                {
                    options.add(pbObj.Name+'*'+pbObj.Id+'*'+pbObj.Campaign_Type__c+'*'+pbObj.Optional_Simulator__c+'*'+pbObj.AVEC_Price_Book__c+'*3');
                    system.debug('inside avec true');
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                /*}else if(isStructure==true)
{
System.debug('Test');
//idforsimulation = clientOnlyRecordType.Id;
//clientOnlyRecordType.id == '0120K000001HskHQAS';
for(Price_Book__c pbObj:[SELECT Id, Name, Division__c, Currency__c, Valid_From__c, Expiry_Date__c ,Campaign_Type__c,
Optional_Simulator__c, Interest_Date__c,Simulation_Price_Book__c,AVEC_Price_Book__c FROM Price_Book__c
WHERE Id IN:salesDistrictPriceBookSet //salesDistrictPriceBookSet
AND id IN :pblist
AND Valid_From__c <= TODAY
AND Expiry_Date__c >= TODAY
AND isActive__c = True
AND Status__c = 'Approved'
AND Base_Price_Book__c = True
AND Campaign_Type__c='Structured'
AND Simulation_Price_Book__c= false
AND AVEC_Price_Book__c = false   
ORDER BY Name])
{
options.add(pbObj.Name+'*'+pbObj.Id+'*'+pbObj.Campaign_Type__c+'*'+pbObj.Optional_Simulator__c);

}
}
else{
//idforsimulation = '0120K000001HskHQAS';
system.debug('inside avec false');
for(Price_Book__c pbObj:[SELECT Id, Name, Division__c, Currency__c, Valid_From__c, Expiry_Date__c ,Campaign_Type__c,
Optional_Simulator__c,AVEC_Price_Book__c, Interest_Date__c,Simulation_Price_Book__c FROM Price_Book__c
WHERE Id IN:salesDistrictPriceBookSet //salesDistrictPriceBookSet
AND id IN :pblist
AND Valid_From__c <= TODAY
AND Expiry_Date__c >= TODAY
AND isActive__c = True
AND Status__c = 'Approved'
AND Base_Price_Book__c = false
AND Simulation_Price_Book__c= false
AND AVEC_Price_Book__c = false
ORDER BY Name])
{
options.add(pbObj.Name+'*'+pbObj.Id+'*'+pbObj.Campaign_Type__c+'*'+pbObj.Optional_Simulator__c+'*'+pbObj.AVEC_Price_Book__c+'*6');
system.debug('inside avec true');
}
}*/
            }
            else if(ordertype=='ORDEM FILHA'){
                //if(avec==true){
                system.debug('inside avec true');
                for(Price_Book__c pbObj:[SELECT Id, Name, Division__c, Currency__c, Valid_From__c, Expiry_Date__c ,Campaign_Type__c,
                                         Optional_Simulator__c,AVEC_Price_Book__c, Interest_Date__c,Simulation_Price_Book__c FROM Price_Book__c
                                         WHERE Id IN:salesDistrictPriceBookSet //salesDistrictPriceBookSet
                                         
                                         AND Valid_From__c <= TODAY
                                         AND Expiry_Date__c >= TODAY
                                         AND isActive__c = True
                                         AND Status__c = 'Approved'
                                         AND Base_Price_Book__c = false
                                         AND Simulation_Price_Book__c= false
                                         AND AVEC_Price_Book__c = :avec                          
                                         AND Kit_Price_Book__c=:isKit
                                         ORDER BY Name])
                    
                    
                    
                    
                    
                {
                    options.add(pbObj.Name+'*'+pbObj.Id+'*'+pbObj.Campaign_Type__c+'*'+pbObj.Optional_Simulator__c+'*'+pbObj.AVEC_Price_Book__c+'*4');
                    system.debug('inside avec true');
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    

                }
                /*}else if(isStructure==true)
{
System.debug('Test');
//idforsimulation = clientOnlyRecordType.Id;
//clientOnlyRecordType.id == '0120K000001HskHQAS';
for(Price_Book__c pbObj:[SELECT Id, Name, Division__c, Currency__c, Valid_From__c, Expiry_Date__c ,Campaign_Type__c,
Optional_Simulator__c, Interest_Date__c,Simulation_Price_Book__c,AVEC_Price_Book__c FROM Price_Book__c
WHERE Id IN:salesDistrictPriceBookSet //salesDistrictPriceBookSet

AND Valid_From__c <= TODAY
AND Expiry_Date__c >= TODAY
AND isActive__c = True
AND Status__c = 'Approved'
AND Base_Price_Book__c = True
AND Campaign_Type__c='Structured'
AND Simulation_Price_Book__c= false
AND AVEC_Price_Book__c = false   
ORDER BY Name])
{
options.add(pbObj.Name+'*'+pbObj.Id+'*'+pbObj.Campaign_Type__c+'*'+pbObj.Optional_Simulator__c);

}
}
else{
//idforsimulation = '0120K000001HskHQAS';
system.debug('inside avec false');
for(Price_Book__c pbObj:[SELECT Id, Name, Division__c, Currency__c, Valid_From__c, Expiry_Date__c ,Campaign_Type__c,
Optional_Simulator__c,AVEC_Price_Book__c, Interest_Date__c,Simulation_Price_Book__c FROM Price_Book__c
WHERE Id IN:salesDistrictPriceBookSet //salesDistrictPriceBookSet

AND Valid_From__c <= TODAY
AND Expiry_Date__c >= TODAY
AND isActive__c = True
AND Status__c = 'Approved'
AND Base_Price_Book__c = false
AND Simulation_Price_Book__c= false
AND AVEC_Price_Book__c = false
ORDER BY Name])
{
options.add(pbObj.Name+'*'+pbObj.Id+'*'+pbObj.Campaign_Type__c+'*'+pbObj.Optional_Simulator__c+'*'+pbObj.AVEC_Price_Book__c+'*8');
system.debug('inside avec true');
}
}*/
                
            }
        }
        //so.RecordTypeid=idforsimulation;     
        
        
        //to be commented by Krishanu/Ankita@Wipro
        /*for(Price_Book__c pbObj:[SELECT Id, Name, Division__c, Currency__c, Valid_From__c, Expiry_Date__c ,Campaign_Type__c,
Optional_Simulator__c,AVEC_Price_Book__c, Interest_Date__c FROM Price_Book__c 
WHERE Id IN:salesDistrictPriceBookSet //salesDistrictPriceBookSet
AND Valid_From__c <= TODAY 
AND Expiry_Date__c >= TODAY
AND isActive__c = True
AND Status__c = 'Approved'
AND Base_Price_Book__c = false
ORDER BY Name]){ 



options.add(pbObj.Name+'*'+pbObj.Id+'*'+pbObj.Campaign_Type__c+'*'+pbObj.Optional_Simulator__c+'*'+pbObj.AVEC_Price_Book__c+'*9');

}*/
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        System.debug('PriceBook options: '+options);
        
        return options;
    }
    
    //Method to Get the Region(s) associated with the Logged In user from KEDE
    public static List<String> getRegion(){
        String UserId = UserInfo.getUserId();
        //Updated for SDM by GRZ(Nikhil Verma) for INC0385117 modified 06-10-2022
        if(isKeyAccount && selectedSellerId != null && !selectedSellerId.startsWith('BR')){
            UserId = selectedSellerId;
        }
        List<Territory_Distributor__c> tdList = new List<Territory_Distributor__c>();
        if(selectedSellerId != null && selectedSellerId.startsWith('BR')){
            tdList = [SELECT ID, Name, TerritoryCode__c, Region__c
                      FROM Territory_Distributor__c 
                      WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                      AND TerritoryCode__c =:selectedSellerId]; 
        }else{
            tdList = [SELECT ID, Name, TerritoryCode__c, Region__c
                      FROM Territory_Distributor__c 
                      WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                      AND TerritoryManagerActive__c = True
                      AND (TerritoryManager__c=: UserId 
                           OR Region__r.RegionHead__c=: UserId
                           OR Region__r.Brazil_Marketing_Ops_Manager__c=:UserId
                           
                           OR Zone__r.ZonalHead__c=: UserId
                           OR SBU__r.SBUUser__c=: UserId
                           OR BarterManager__c=: UserId
                          )]; 
        }
        //---------End GRZ(Nikhil Verma) for INC0385117 modified 06-10-2022
        
        
        //System.debug('Region tdList: '+tdList);
        
        
        Set<String> regionSet = new Set<String>();
        for(Territory_Distributor__c tdObj:tdList){
            regionSet.add(tdObj.Region__c);
        }
        
        List<String> regionList = new List<String>();
        regionList.addAll(regionSet);
        System.debug('regionList_6177@@@'+regionList);
        System.debug('size@@@'+regionList.size());
        return regionList;
    }
    
    //Method to Get the Territory of the Logged In user from KEDE
    public static String getTerritory(){
        
        List<Territory_Distributor__c> tdList = [SELECT ID, Name, TerritoryCode__c, Region__c, BarterManager__c
                                                 FROM Territory_Distributor__c 
                                                 WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                                                 AND TerritoryManagerActive__c = True
                                                 AND (TerritoryManager__c=: UserInfo.getUserId() 
                                                      OR Region__r.RegionHead__c=: UserInfo.getUserId()
                                                      OR Region__r.Brazil_Marketing_Ops_Manager__c=:UserInfo.getUserId()
                                                      
                                                      OR Zone__r.ZonalHead__c=: UserInfo.getUserId()
                                                      OR SBU__r.SBUUser__c=: UserInfo.getUserId()
                                                      OR BarterManager__c=: UserInfo.getUserId()
                                                     ) LIMIT 1]; 
        //  System.debug('Territory tdList: '+tdList);
        String territoryId = '';
        if(!tdList.isEmpty()){
            territoryId = tdList[0].Id;
        }
        
        return territoryId;
    }
    
    /*
* End of Non Aura Methods
*/ 
    
    @AuraEnabled
    public static List<Transaction_Log__c> getErrorHistory(String recordId){
        
        return [SELECT CreatedDate, Message__c FROM Transaction_Log__c WHERE Sales_Order__c=:recordId];
        
    }
    
    
    
    //Approval Process Methods
    @AuraEnabled
    public static ApprovalList processApproval(Boolean isApproved, String recordId, String comments) {
        // Approve the submitted request
        // First, get the ID of the newly created item
        // First, get the IDs for the WorkItems 
        List<Id> newWorkItemIds = new List<Id>();
        for (List<ProcessInstance> pis : [Select (Select Id From Workitems) From ProcessInstance p WHERE p.TargetObjectId = :recordId AND p.Status = 'Pending']) {
            for (ProcessInstance pi : pis) {
                for (List<ProcessInstanceWorkitem> wis : pi.Workitems) {
                    for (ProcessInstanceWorkitem wi : wis ) {
                        newWorkItemIds.add(wi.id);
                    }
                }           
            }
        }
        
        // Instantiate the new ProcessWorkitemRequest object and populate it
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments(comments);
        if (isApproved) {
            req2.setAction('Approve');
        } else {
            req2.setAction('Reject');
        }
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        
        // Use the ID from the newly created item to specify the item to be worked
        if(newWorkItemIds.size() > 0) {
            req2.setWorkitemId(newWorkItemIds.get(0));
            
            // Submit the request for approval
            Approval.ProcessResult result2 =  Approval.process(req2);
        }
        // Verify the results
        //System.debug('Instance Status'+result2.getInstanceStatus());
        // System.debug('Success'+String.valueOf(result2.isSuccess()));
        /*System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());

System.assertEquals(
'Approved', result2.getInstanceStatus(), 
'Instance Status'+result2.getInstanceStatus());*/
        
        return OrderRequestController.generateData(recordId); //result2.isSuccess();
    }    
    //End of Approval Process
    
    //Approval History Table Logic
    
    @AuraEnabled
    public static ApprovalList generateData(String recordId){
        System.debug('Generate Data: '+recordId);
        ApprovalList approvalResultForObject = new ApprovalList();
        //List<ApprovalStepWrapper> aSW = new List<ApprovalStepWrapper>();
        String recallApprovalProcessLink;
        Boolean isSubmitForApproval = true;
        
        List<ProcessInstance> processList = [SELECT ID, 
                                             (SELECT ID, ProcessNodeId, ToLabel(StepStatus), Comments, TargetObjectId, ActorId, 
                                              CreatedById, IsDeleted, IsPending, OriginalActorId, ProcessInstanceId, RemindersSent, 
                                              CreatedDate, Actor.Name, OriginalActor.Name , ProcessNode.Name 
                                              FROM StepsAndWorkitems order by CreatedDate DESC,IsPending DESC ) 
                                             FROM ProcessInstance WHERE TargetObjectId =:recordId ORDER BY CreatedDate DESC];
        
        System.debug('processInstanceMap: '+processList);
        
        for(ProcessInstance pI:processList){
            
            //Map<Id,List<ProcessInstanceHistory>> mapOfProcessNodeIdAndProcessInstanceHistory = new Map<Id,List<ProcessInstanceHistory>>();
            //Set<Id> processNodeId= new Set<Id>(); 
            
            for(ProcessInstanceHistory sWI:pI.StepsAndWorkitems){
                /*if(processNodeId.size() == 0)
processNodeId.add(sWI.ProcessNodeId);
else if(processNodeId.size()>0 && processNodeId.contains(sWI.ProcessNodeId)!= NULL)
processNodeId.add(sWI.ProcessNodeId);*/
                
                if(sWI.StepStatus==System.Label.Pending){
                    if(approvalResultForObject.enableApproval != true){
                        System.debug('Approver actor Enable: '+(sWI.ActorId==UserInfo.getUserId()));
                        System.debug('Original actor Enable: '+(sWI.OriginalActorId==UserInfo.getUserId()));
                        System.debug('OriginalActorId==>'+sWI.OriginalActorId);
                        
                        // if(sWI.OriginalActorId==UserInfo.getUserId() || sWI.OriginalActorId!=UserInfo.getUserId()){
                        //if(sWI.OriginalActorId==UserInfo.getUserId()){
                        if(sWI.ActorId==UserInfo.getUserId()){
                            system.debug('UserInfo.getUserId()'+UserInfo.getUserId());
                            approvalResultForObject.enableApproval = true;
                        }
                        else{
                            approvalResultForObject.enableApproval = false;
                        }
                    }
                }
                approvalResultForObject.listOfSteps.add(sWI);
                
                AuditHistory ahObj = new AuditHistory();
                ahObj.createdDate = sWI.CreatedDate;
                ahObj.stepStatus = sWI.StepStatus;
                ahObj.originalActorName = sWI.OriginalActor.Name;
                ahObj.actorName = sWI.Actor.Name;
                ahObj.comments = sWI.Comments;
                approvalResultForObject.listOfStepsAudit.add(ahObj);
            }
            
            /*for(Id pNId: processNodeId){
ApprovalStepWrapper aSWr = new ApprovalStepWrapper();
for(ProcessInstanceHistory sWI:pI.StepsAndWorkitems){
if(sWI.processNodeId == pNID){
//aSWr.listOfSteps.add(sWI);
}
if(sWI.StepStatus == 'Pending'){
//aSWr.workItemApproveOrRejectLink = ORG_LNK+'/p/process/ProcessInstanceWorkitemWizardStageManager?id='+sWI.Id;
//aSWr.workItemReassignLink =  ORG_LNK+'/'+sWI.Id+'/e?et=REASSIGN&retURL=/'+retURLRecordId;
//recallApprovalProcessLink =  ORG_LNK +'/'+sWI.Id+'/e?et=REMOVE&retURL=/'+retURLRecordId;
isSubmitForApproval = false;
}

}
aSW.add(aSWr);
}*/
        }
        
        for(AuditHistory__c ahyObj:[SELECT Id, CreatedByUser__r.Name, CreatedDateTime__c, 
                                    LastModifiedBy__r.Name , MessageString__c, 
                                    ModifiedDateTime__c, SalesOrder__c
                                    FROM AuditHistory__c
                                    WHERE SalesOrder__c=:recordId ORDER BY CreatedDate DESC]){
                                        
                                        AuditHistory ahObj = new AuditHistory();
                                        ahObj.createdDate = ahyObj.ModifiedDateTime__c;
                                        ahObj.stepStatus = ahyObj.MessageString__c;
                                        ahObj.originalActorName = ahyObj.LastModifiedBy__r.Name;
                                        //ahObj.originalActorName = ahyObj.CreatedByUser__r.Name;
                                        //ahObj.actorName = ahyObj.LastModifiedBy__r.Name;
                                        //ahObj.comments = ahyObj.MessageString__c;
                                        approvalResultForObject.listOfStepsAudit.add(ahObj);                                       
                                    }
        beforeSort = approvalResultForObject.listOfStepsAudit;
        sortAuditHistory();
        approvalResultForObject.listOfStepsAudit = afterSort;
        //approvalResultForObject.approvals = aSW;
        approvalResultForObject.recordId = recordId;
        //approvalResultForObject.isSubmitForApproval = isSubmitForApproval;
        //approvalResultForObject.recallApprovalProcessLink = recallApprovalProcessLink;
        //System.debug('approvalResultForObject: '+approvalResultForObject);
        
        return approvalResultForObject;
    }
    
    /*public class ApprovalStepWrapper{
@AuraEnabled public String workItemApproveOrRejectLink;
@AuraEnabled public String workItemReassignLink;
//@AuraEnabled public List<ProcessInstanceHistory> listOfSteps;

public ApprovalStepWrapper(){
//listOfSteps = new  List<ProcessInstanceHistory>();
}
}*/
    
    //Sorting Audit History, Custom Logic used for Audit History Wrapper
    //Logic sorts the dates, used for sorting through Approval History and Audit History
    public static void sortAuditHistory(){
        Integer targetsize = beforeSort.size();
        
        while(afterSort.size() != targetsize){
            findMinDateValue();
        }
    }
    
    //Compare dates to get the sorted list of dates for Audit History List.
    public static void findMinDateValue(){
        //Datetime dt = Datetime.newInstance(2999, 12, 31, 00, 00, 00); // if ascending
        Datetime dt = Datetime.newInstance(1900, 12, 31, 00, 00 , 00); // if decending
        
        Integer i = 0;
        Integer mini = 0;
        
        for (i = 0; i != beforeSort.size() ; i ++){
            //if(beforeSort[i].createdDated > dt){ // if ascending
            if(beforeSort[i].createdDate > dt){ // if decending
                dt = beforeSort[i].createdDate;
                mini = i;
            }
        }
        
        afterSort.add(beforeSort[mini]);
        beforeSort.remove(mini);
    }
    //End of Patch
    
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
        
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
        
        insert oAttachment;
        
        return oAttachment.Id;
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.Body);
        
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        
        update a;
    }
    
    
    public class SOMQuantity{
        @AuraEnabled public List<PriceDetail> priceList;
        @AuraEnabled public List<String> productList;
        
        public SOMQuantity(){
            priceList = new List<PriceDetail>();
            productList = new List<String>();
        }
    }
    
    public class FlagStatus{
        @AuraEnabled public String flagMessage;
        @AuraEnabled public String flagStatus;
        
        public FlagStatus(){
            flagMessage = '';
            flagStatus = '';
        }
    }
    
    public class AuditHistory{
        @AuraEnabled public DateTime createdDate;
        @AuraEnabled public String stepStatus;
        @AuraEnabled public String originalActorName;
        @AuraEnabled public String actorName;
        @AuraEnabled public String comments;
        
        public AuditHistory(){
            createdDate = System.now();
            stepStatus = '';
            originalActorName = '';
            actorName = '';
            comments = '';
        }
    }
    
    public class ApprovalList{
        //@AuraEnabled public List<ApprovalStepWrapper> approvals;
        @AuraEnabled public List<AuditHistory> listOfStepsAudit;
        @AuraEnabled public List<ProcessInstanceHistory> listOfSteps;
        //@AuraEnabled public String recallApprovalProcessLink;
        //@AuraEnabled public Boolean isSubmitForApproval;
        @AuraEnabled public Boolean enableApproval;
        @AuraEnabled public Id recordId;
        
        public ApprovalList(){
            //approvals = new List<ApprovalStepWrapper>();
            listOfStepsAudit = new List<AuditHistory>();
            listOfSteps = new  List<ProcessInstanceHistory>();
            //isSubmitForApproval = true;
            enableApproval = false;
        }
    }
    //End Approval History Table Logic
    
    
    
    public class OrderWrapper{
        @AuraEnabled public Sales_Order__c soObj;
        @AuraEnabled public ApprovalList approvalList;
        @AuraEnabled public List<Transaction_Log__c> errorList;
        @AuraEnabled public List<SalesOrderItem> soiList;
        @AuraEnabled public String sfdcOrderNo;
        @AuraEnabled public String sapOrderNo;
        @AuraEnabled public String orderSubStatus;
        public Exception exObj;
        
        public OrderWrapper(){
            soObj = new Sales_Order__c();
            approvalList = new ApprovalList();
            errorList = new List<Transaction_Log__c>();
            soiList = new List<SalesOrderItem>();
            sfdcOrderNo = '';
            sapOrderNo = '';
            orderSubStatus = '';
        }
    }
    // added by Harshit
    public class Inventory {
        @AuraEnabled public Decimal qty;
        @AuraEnabled public Boolean inventoryactive;
        @AuraEnabled public String inventoryblockalert;
        @AuraEnabled public String productname;
        @AuraEnabled public String year;
        @AuraEnabled public String year1;
        
        @AuraEnabled public Decimal totalqty;
        
        
        
        public Inventory(){
            qty = 0;
            inventoryactive= false;
            inventoryblockalert = '';
            productname='';
            year='';
            year1='';
            totalqty = 0;
        }
        
        
    }
    
    public class SalesOrderItem {
        @AuraEnabled public string minDate;
        @AuraEnabled public Boolean applyMinPrice; // Priya RITM0237685
        @AuraEnabled public String productId;
        @AuraEnabled public String productCode;
        @AuraEnabled public String orderItemId;
        @AuraEnabled public String priceBookDetailId;
        @AuraEnabled public String skuCategory;
        @AuraEnabled public String productName;
        @AuraEnabled public String fatDate;
        @AuraEnabled public String fatDateNew;
        @AuraEnabled public Decimal qty;
        @AuraEnabled public Decimal qtyNew;
        @AuraEnabled public Decimal inventory;
        @AuraEnabled public Decimal listValue;
        @AuraEnabled public Decimal minValue;
        @AuraEnabled public Decimal unitValue;
        @AuraEnabled public Decimal budgetValue;
        @AuraEnabled public Decimal discount;
        @AuraEnabled public Decimal replacementMargin;
        @AuraEnabled public Decimal replacementMarginUP;
        @AuraEnabled public Decimal ledgerMargin;
        @AuraEnabled public Decimal unitValueWithInterest;
        @AuraEnabled public Decimal totalValue;
        @AuraEnabled public Decimal totalValueWithInterest;
        @AuraEnabled public Decimal gptotal;
        @AuraEnabled public Decimal gplista;
        @AuraEnabled public Decimal gplistaunitvalue;
        @AuraEnabled public String salesperson;
        @AuraEnabled public Decimal unitpriceofpricelist;
        @AuraEnabled public Decimal interestRate;
        @AuraEnabled public Decimal days;
        @AuraEnabled public Decimal CogsInfo;//Modified by Sagar
        @AuraEnabled public Decimal aderencia; // added by Sagar 
        @AuraEnabled public Decimal MargemLista; // added by Sagar 
        @AuraEnabled public Decimal impactgpvslp;//Added by Sirisha
        
        @AuraEnabled public Decimal Recommendedprice; // added by Sagar for DDS score   
        @AuraEnabled public String DDSGrade; // added by Sagar for DDS score    
        @AuraEnabled public String cogsitem;//Modified by Sagar for Deal scoring   
        @AuraEnabled public String DDSApiErrMsg; // added by Sagar for DDS score
        @AuraEnabled public Decimal DiscountBarter; // added by Sagar for Discount Barter
        @AuraEnabled public String ItemStatus;// added by Sagar for Item Status
        @AuraEnabled public Decimal CustomerConversionFactor; //Added by Sagar for calculating Barter Discount
        @AuraEnabled public Decimal BarterDiscountPercentage;//Change by Swaranjeet(Grazitti) APPS-4591 
       
         @AuraEnabled public Decimal GrossMarginwithBarter;//Change by Swaranjeet(Grazitti) APPS-4591
        @AuraEnabled public Decimal BarterDiscountCalculated;//Change by Swaranjeet(Grazitti) APPS-4591
        
        @AuraEnabled public String Ids;//Change by Swaranjeet(Grazitti) APPS-4591 
        @AuraEnabled public boolean bartercheckpoint;//Change by Swaranjeet(Grazitti) APPS-4591 
        @AuraEnabled public Decimal timeInMonths;
        @AuraEnabled public Decimal multipleOf;
        @AuraEnabled public String cultureDesc;
        @AuraEnabled public String culture;
        @AuraEnabled public String cancellationReason;//Added by Bhavika 6Feb 2023
        
        @AuraEnabled public String flag;
        @AuraEnabled public Decimal itemNo;
        @AuraEnabled public Decimal moItemNo;
        @AuraEnabled public Boolean isMO;
        @AuraEnabled public Boolean budgetFlag;
        @AuraEnabled public String currency_Code;
        @AuraEnabled public Decimal materialPlnRplc_Cost;
        @AuraEnabled public Decimal exchange_Rate;
        @AuraEnabled public String create_Date;
        @AuraEnabled public Decimal unitValueBRL;
        @AuraEnabled public Decimal unitValueUSD;
        @AuraEnabled public String brand;
        @AuraEnabled public Decimal minValueBRL;
        @AuraEnabled public Decimal minValueUSD;
        @AuraEnabled public String interest_Date; //Divya INCTASK0186953
        @AuraEnabled public String POItemNumber; //Deeksha SCTASK0216504
        @AuraEnabled public Boolean kitProduct; //Modified by Deeksha for kit selling Project
        @AuraEnabled public Decimal kitNo;//Modified by Deeksha for kit selling Project
        @AuraEnabled public Decimal refKitNo;//Modified by Deeksha for kit selling Project
        @AuraEnabled public Decimal componentQty;//Modified by Deeksha for kit selling Project
        @AuraEnabled public String itemCategory;//Modified by Deeksha for kit selling Project
        @AuraEnabled public String kitSKU ;//Modified by Deeksha for kit selling Project
        @AuraEnabled public Decimal round;//Modified by Deeksha for kit selling Project
        @AuraEnabled public Decimal totalreplacementcost;//Modified by Sagar for Deal scoring 
        @AuraEnabled public Decimal quantity;// Modified by by Anmol@wipro for US SOS-002 
        //added by Krishanu@Wipro
        @AuraEnabled public Decimal taxAmountWithoutInterest;
        @AuraEnabled public Decimal freightAmountWithoutInterest;
        @AuraEnabled public Decimal punctualityDiscountWICalculated;
        @AuraEnabled public Decimal totalReplacementCost1;
        @AuraEnabled public Decimal totaltax ;
        @AuraEnabled public Decimal totalfreight;
        @AuraEnabled public Decimal totalpunctuality;
        @AuraEnabled public Decimal selloutprice; //added by Aditya@wipro
        
        /* ************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start ************************************** */
        @AuraEnabled public Decimal salesDeductionCost;
        @AuraEnabled public Decimal cogsCost;
        @AuraEnabled public Decimal e2eCost;
        @AuraEnabled public String blnkt_EndDate;
        @AuraEnabled public String blnkt_StartDate;
        @AuraEnabled public Boolean blnkt_Status;
        @AuraEnabled public Boolean isBlanket;
        @AuraEnabled public Decimal level1Max;
        @AuraEnabled public Decimal level1Min;
        @AuraEnabled public Decimal level2Max;
        @AuraEnabled public Decimal level2Min;
        @AuraEnabled public Decimal level3Below;
        @AuraEnabled public String approvalLevel;
        @AuraEnabled public String uom;
        @AuraEnabled public String baseUOM;
        @AuraEnabled public Decimal convertedQnty;
        @AuraEnabled public Decimal convertedNetPrice;
        @AuraEnabled public Decimal salesDeductionCal;
        @AuraEnabled public Decimal cogsCostCal;
        @AuraEnabled public Decimal e2eCostCal;
        @AuraEnabled public Boolean mbLevel1;
        @AuraEnabled public Boolean mbLevel2;
        @AuraEnabled public Decimal contMargin;
        @AuraEnabled public Decimal exchngRate;
        @AuraEnabled public String curncyCode;
        /* ************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End ************************************** */
        
        public SalesOrderItem(){
            totaltax = 0;
            totalfreight =0;
            totalpunctuality = 0;
            minDate = '';
            applyMinPrice= false;
            skuCategory = '';
            itemCategory = '';//Modified by Deeksha for kit selling Project
            isMO = false;
            budgetFlag = false;
            itemNo = 0;
            moItemNo = 0;
            productId = '';
            productCode = '';
            budgetValue = 0;
            orderItemId = '';
            priceBookDetailId = '';
            productName = '';
            fatDate = '';
            fatDateNew='';
            interest_Date = '';//Divya INCTASK0186953
            qty = 0;
            qtyNew=0;
            listValue = 0;
            minValue = 0;
            unitValue = 0;
            unitValueWithInterest = 0;
            totalValueWithInterest = 0;
            totalValue = 0;
            interestRate = 0;
            gptotal = 0;
            gplista = 0;
            gplistaunitvalue = 0;
            impactgpvslp = 0;
            days = 0;
            CogsInfo=0;
            punctualityDiscountWICalculated=0;
            taxAmountWithoutInterest=0;
            freightAmountWithoutInterest=0;
            totalReplacementCost1=0;
            Recommendedprice = 0;//added by Sagar for Deal scoring 
            DDSGrade = '';//added by Sagar for Deal scoring 
            DDSApiErrMsg=''; //added by Sagar for Deal scoring
            quantity=0;// Modified by by Anmol@wipro for US SOS-002 
            cultureDesc = '';
            culture='';
            cancellationReason='';//Added by Bhavika
            
            currency_Code = '';
            materialPlnRplc_Cost = 0;
            exchange_Rate = 0;
            create_Date = '';
            unitValueBRL = 0;
            unitValueUSD = 0;
            replacementMargin = 0;
            replacementMarginUP = 0;
            discount = 0;
            brand = '';
            minValueBRL = 0;
            minValueUSD = 0;
            POItemNumber = ''; //Deeksha :SCTASK0216504
            componentQty = 0;//Modified by Deeksha for kit selling Project
            kitSKU = '';//Modified by Deeksha for kit selling Project
            round = 0;//Modified by Deeksha for kit selling Project
            totalreplacementcost= 0;//added by Sagar for Deal scoring 
            CustomerConversionFactor = 0;//Added by Sagar for calculating Barter Discount
            
            selloutprice = 0; //added by Aditya@wipro
            
            /* ************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start ************************************** */
            salesDeductionCost = 0;
            cogsCost = 0;
            e2eCost = 0;
            blnkt_EndDate = '';
            blnkt_StartDate = '';
            blnkt_Status = false;
            isBlanket = false;
            level1Max = 0;
            level1Min = 0;
            level2Max = 0;
            level2Min = 0;
            level3Below = 0;
            approvalLevel = '';
            uom = '';
            baseUOM = '';
            convertedQnty = 0;
            convertedNetPrice = 0;
            salesDeductionCal = 0;
            cogsCostCal = 0;
            e2eCostCal = 0;
            mbLevel1 = false;
            mbLevel2 = false;
            contMargin = 0;
            exchngRate = 0;
            curncyCode = '';
            /* ************************* SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End ******************************************* */
        }
    } 
    
    public class PriceDetail{
        
        @AuraEnabled public String skuId;
        @AuraEnabled public String skuDescription;
        @AuraEnabled public Decimal custconversionfator;//Added by Sayan, 20th July, RITM0234559
        @AuraEnabled public String skuCategory;
        @AuraEnabled public Decimal unitValueBRL;
        @AuraEnabled public Decimal unitValueUSD;
        @AuraEnabled public Decimal unitValue;
        @AuraEnabled public Decimal minValue;
        @AuraEnabled public Decimal minValueBRL;
        @AuraEnabled public Decimal minValueUSD;
        @AuraEnabled public Decimal budgetValue;
        @AuraEnabled public Decimal budgetValueBRL;
        @AuraEnabled public Decimal budgetValueUSD; 
        @AuraEnabled public String pricebookId;
        @AuraEnabled public Decimal qty;
        @AuraEnabled public String skuCode;
        @AuraEnabled public Decimal multipleOf;
        @AuraEnabled public Decimal monthlyInterestRate;
        @AuraEnabled public Decimal monthlyInterestRateBRL;
        @AuraEnabled public Decimal monthlyInterestRateUSD;
        @AuraEnabled public String orderItemId;
        @AuraEnabled public String regState;
        @AuraEnabled public Decimal balanceQty;
        @AuraEnabled public Decimal balanceQty2;
        @AuraEnabled public String fatDate;
        @AuraEnabled public Decimal percUsed;
        @AuraEnabled public Decimal days;
        @AuraEnabled public Decimal Recommendedprice;//added by Sagar for Deal scoring  
        @AuraEnabled public String DDSGrade;//added by Sagar for Deal scoring 
        @AuraEnabled public Decimal unitValueWithInterest;
        @AuraEnabled public Decimal totalValue;
        @AuraEnabled public Decimal totalValueWithInterest;
        @AuraEnabled public Decimal interestRate;        
        @AuraEnabled public String cultureDesc;
        @AuraEnabled public String culture;
        
        @AuraEnabled public Boolean isMO;
        @AuraEnabled public Decimal itemNo;
        @AuraEnabled public Boolean isValid;
        @AuraEnabled public String currencyCode;
        @AuraEnabled public Decimal materialPlnRplcCost;
        @AuraEnabled public Decimal materialPlnRplcCostbr00;
        @AuraEnabled public Boolean isActiveSKU;    //added by Sagar@Wipro
        @AuraEnabled public Decimal exchangeRate;
        @AuraEnabled public String create_Dt;
        @AuraEnabled public String brand;
        @AuraEnabled public Boolean kitProduct;//Modified by Deeksha for kit selling Project
        @AuraEnabled public List<PriceDetail> kitProductPB;//Modified by Deeksha for kit selling Project
        @AuraEnabled public Decimal componentQty;//Modified by Deeksha for kit selling Project
        @AuraEnabled public String kitSKU;//Modified by Deeksha for kit selling Project
        @AuraEnabled public Decimal kitNo;//Modified by Deeksha for kit selling Project
        @AuraEnabled public Decimal refKitNo;//Modified by Deeksha for kit selling Project
        @AuraEnabled public String itemCategory;//Modified by Deeksha for kit selling Project
        @AuraEnabled public Boolean avail; // added by Priya Dhawan for SCTASK0398608 (RITM0176543)
        @AuraEnabled public string minDate; // added by Priya Dhawan for SCTASK0398608 (RITM0176543)
        @AuraEnabled public string maxDate;//added by Krishanu
        @AuraEnabled public Boolean applyMinPrice; // Priya RITM0237685
        @AuraEnabled public Decimal selloutprice;//added by Krishanu
        @AuraEnabled public Decimal selloutpriceU;//added by Krishanu
        /* ************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start ************************************** */
        @AuraEnabled public Decimal salesDeductionCost;
        @AuraEnabled public Decimal cogsCost;
        @AuraEnabled public Decimal e2eCost;
        @AuraEnabled public String blnkt_EndDate;
        @AuraEnabled public String blnkt_StartDate;
        @AuraEnabled public Boolean blnkt_Status;
        @AuraEnabled public Boolean isBlanket;
        @AuraEnabled public String uom;
        /* ************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End ************************************** */
        
        public PriceDetail(){
            kitProductPB = new List<PriceDetail>();//Modified by Deeksha for kit selling Project
            skuCategory = '';
            itemCategory = '';//Modified by Deeksha for kit selling Project
            itemNo = 0;
            skuId = '';
            minValueBRL = 0;
            monthlyInterestRateBRL = 0;
            monthlyInterestRateUSD = 0;
            minValueUSD = 0;
            unitValueUSD = 0;
            unitValueBRL = 0;
            skuDescription = '';
            custconversionfator = 1;//Added by Sayan, 20th July, RITM0234559
            unitValue = 0;
            minValue = 0;
            budgetValue = 0;
            pricebookId = '';
            days = 0;
            Recommendedprice = 0;   //added by Sagar for Deal scoring 
            DDSGrade = ''; //added by Sagar for Deal scoring 
            qty = 0;
            componentQty = 0;//Modified by Deeksha for kit selling Project
            skuCode = '';
            multipleOf = 0;
            monthlyInterestRate = 0;
            orderItemId = '';
            regState = '';
            balanceQty = 0;
            balanceQty2 = 0;
            percUsed = 100;
            unitValueWithInterest = 0;
            cultureDesc = '';
            culture='';
            totalValue = 0;
            interestRate = 0;
            totalValueWithInterest = 0;
            isMO = false;
            isValid = false;
            isActiveSKU = false; //added by Sagar@Wipro
            currencyCode = '';
            materialPlnRplcCost = 0;
            materialPlnRplcCostbr00 = 0;
            exchangeRate = 0;
            create_Dt = '';
            brand = '';
            avail = true; // added by Priya Dhawan for SCTASK0398608 (RITM0176543)
            minDate = ''; // added by Priya Dhawan for SCTASK0398608 (RITM0176543) 
            maxDate = '';
            applyMinPrice = false;
            selloutprice =0;
            selloutpriceU =0;
            /* ************************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start ************************************** */
            salesDeductionCost = 0;
            cogsCost = 0;
            e2eCost = 0;
            blnkt_EndDate = '';
            blnkt_StartDate = '';
            blnkt_Status = false;
            isBlanket = false;
            uom = '';
            /* ************************* SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End ******************************************* */
        }
    }
    
    public class SOMBalance{
        @AuraEnabled public String productId;
        @AuraEnabled public String product;
        @AuraEnabled public String quantity;
        @AuraEnabled public String balance;
        @AuraEnabled public String used;
        @AuraEnabled public String percent;
        @AuraEnabled public String lineItemId;
        
        public SOMBalance(){
            product = '';
            quantity = '0';
            balance = '0';
            percent = '0';
            used = '0';
            lineItemId = '';
        }
    }
    
    public class KEDE{
        @AuraEnabled public String salesPerson;
        @AuraEnabled public Decimal SP_TotalOrderMargin;
        @AuraEnabled public Decimal SP_ListPriceDiscount;
        @AuraEnabled public Decimal tax;
        @AuraEnabled public Decimal freight;
        
        @AuraEnabled public String salesDistrictManager;
        @AuraEnabled public Decimal SDM_TotalOrderMargin1;
        @AuraEnabled public Decimal SDM_ListPriceDiscount1;
        @AuraEnabled public String BrazilMarketingOpsManager;
        @AuraEnabled public Decimal SDM_TotalOrderMargin4;
        @AuraEnabled public Decimal SDM_ListPriceDiscount4;
        
        @AuraEnabled public String salesOfficeManager;
        @AuraEnabled public Decimal SOM_TotalOrderMargin2;
        @AuraEnabled public Decimal SOM_ListPriceDiscount2;
        
        @AuraEnabled public String salesDirector;
        @AuraEnabled public Decimal SD_TotalOrderMargin3;
        @AuraEnabled public Decimal SD_ListPriceDiscount3;
        
        @AuraEnabled public String barterManager;
        @AuraEnabled public String brazilAnalyst;
        
        //added by ganesh Date:12/11/2018
        //Desc:
        @AuraEnabled public String REHManager;
        @AuraEnabled public Decimal REH_TotalOrderMargin4;
        @AuraEnabled public Decimal REH_ListPriceDiscount4;
        
        @AuraEnabled public String GSDManager;
        
        
        public KEDE(){
            salesPerson = '';
            SP_TotalOrderMargin = 0;
            SP_ListPriceDiscount = 0;
            tax = 0;
            freight = 0;
            
            salesDistrictManager = '';
            SDM_TotalOrderMargin1 = 0;
            SDM_ListPriceDiscount1 = 0;
            BrazilMarketingOpsManager = '';
            SDM_TotalOrderMargin1 = 0;
            SDM_ListPriceDiscount1 = 0;
            
            salesOfficeManager = '';
            SDM_TotalOrderMargin1 = 0;
            SDM_ListPriceDiscount1 = 0;
            
            salesDirector = '';
            SD_TotalOrderMargin3 = 0;
            SD_ListPriceDiscount3 = 0;
            
            REHManager = '' ;
            REH_TotalOrderMargin4 = 0;
            REH_ListPriceDiscount4 = 0;
            
            barterManager = '';
            brazilAnalyst = '';
            GSDManager = '';
            
        }
    }
    /* ********************* SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... Start ********************** */
    public class AdminMPTParameters{
        @AuraEnabled public Decimal level1Max;
        @AuraEnabled public Decimal level1Min;
        @AuraEnabled public Decimal level2Max;
        @AuraEnabled public Decimal level2Min;
        @AuraEnabled public Decimal level3Below;
        @AuraEnabled public String approvalLevel;
        @AuraEnabled public String id;
        @AuraEnabled public Boolean active;
        
        public AdminMPTParameters(){
            level1Max = 0;
            level1Min = 0;
            level2Max = 0;
            level2Min = 0;
            level3Below = 0;
            approvalLevel = '';
            id = '';
            active = false;
        }
    }
    
    public class CustomerTaxAndFreight{
        @AuraEnabled public Decimal tax;
        @AuraEnabled public Decimal freight;
        @AuraEnabled public String customerRegion;
        @AuraEnabled public String id;
        
        public CustomerTaxAndFreight(){
            tax = 0;
            freight = 0;
            customerRegion = '';
            id = '';
        }
    }
    /* ********************** SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022.... End ********************** */
    
    public class OrderFields{
        @AuraEnabled public List<String> orderTypeList;
        @AuraEnabled public List<String> paymentMethodList;
        @AuraEnabled public List<String> currencyList;
        @AuraEnabled public Map<String, Payment_Term__c> paymentTermsMap;
        @AuraEnabled public List<Sales_Order__c> Last24MonthsSalesOrdersList;
        @AuraEnabled public List<String> incoTermsList;
        @AuraEnabled public List<String> culturalDescList;
        @AuraEnabled public List<object> CancellationReasonOptions;//Added by tanuj 6 feb 2023
        @AuraEnabled public List<String> priceList;
        @AuraEnabled public User userObj;
        @AuraEnabled public Boolean isKeyAccountManager;
        @AuraEnabled public Boolean hasDefaultRules;
        @AuraEnabled public Business_Rule__c defaultRule;
        @AuraEnabled public AdminMPTParameters adminparameters; // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022......
        
        public OrderFields(){
            orderTypeList = new List<String>();
            paymentMethodList = new List<String>();
            currencyList = new List<String>();
            paymentTermsMap = new Map<String, Payment_Term__c>();
            Last24MonthsSalesOrdersList= new List<Sales_Order__c>();
            incoTermsList = new List<String>();
            culturalDescList = new List<String>();
            CancellationReasonOptions = new List<object>();//addded by tanuj 6feb2023
            priceList = new List<String>();
            userObj = new User();
            isKeyAccountManager = false;
            hasDefaultRules = false;
            defaultRule = new Business_Rule__c();
            adminparameters = new AdminMPTParameters(); // SKI(Nik) : #CR155 : Brazil Margin Block : 30-08-2022......
        }
    }
    
    public class StructCampaignDetailWrap{
        @AuraEnabled public Price_Book__c priceBookObj{get;set;}
        @AuraEnabled public Sales_Order__c salesOrderObj{get;set;}
        @AuraEnabled public integer groupsize{get;set;}
        @AuraEnabled public list<CampaignGroupWrap> listCampaignGroupWrap{get;set;}
        @AuraEnabled public map<string,Campaign_Group__c> mapofCampaignGroup{get;set;}    
        @AuraEnabled public list<StructOrderLineItem> lstStructOrderLineItem;
        @AuraEnabled public list<StructOrderLineItem> saveListStructOrderLineItem; 
        @AuraEnabled public map<string,StructOrderLineItem> mapofStructureLineItem{get;set;}        
        @AuraEnabled public string sfdcOrderNo; 
        @AuraEnabled public string sapOrderNo;  
        @AuraEnabled public String orderSubStatus;
        @AuraEnabled public ApprovalList approvalList;
        @AuraEnabled public List<Transaction_Log__c> errorList;
        public Exception exObj;
        
        public StructCampaignDetailWrap(){
            sapOrderNo ='';
            sfdcOrderNo =''; 
            orderSubStatus = '';
            mapofStructureLineItem = new map<String,StructOrderLineItem>();
            saveListStructOrderLineItem = new  list<StructOrderLineItem>();
            approvalList = new ApprovalList();
            errorList = new List<Transaction_Log__c>();
            lstStructOrderLineItem = new  list<StructOrderLineItem>();
            priceBookObj = new Price_Book__c(); 
            salesOrderObj = new Sales_Order__c();
            mapofCampaignGroup = new map<string,Campaign_Group__c>();
            listCampaignGroupWrap = new list<CampaignGroupWrap>();
            groupsize = 0;
        }
    }
    public class CampaignGroupWrap{
        
        @AuraEnabled public list<CampaignSubGroupWrap>  campaignSubGroupList{get;set;}
        @AuraEnabled public Campaign_Group__c campGroupObj{get;set;}
        @AuraEnabled public string campaignGroup{get;set;}
        @AuraEnabled public integer subgroupSize{get;set;}
        @AuraEnabled public integer totalPriceBookSize{get;set;}
        
        public CampaignGroupWrap(){
            campaignSubGroupList  =  new list<CampaignSubGroupWrap>();
            campGroupObj = new Campaign_Group__c();
            totalPriceBookSize = 0;
            campaignGroup = '';
            subgroupSize = 0;
        }
    }
    public class CampaignSubGroupWrap{
        
        @AuraEnabled public string subGroup{get;set;}
        @AuraEnabled public integer priceitemSize{get;set;}
        @AuraEnabled public string campGrp{get;set;}
        // @AuraEnabled public list<Price_Book_Details__c> priceBookObj;
        @AuraEnabled public list<PriceBookDetailWrap> priceBooklistObj{get;set;}
        
        public  CampaignSubGroupWrap(){
            campGrp ='';
            subGroup = '';
            priceitemSize = 0;
            priceBooklistObj = new  list<PriceBookDetailWrap>();
        }
        
    }
    
    public class PriceBookDetailWrap{
        @AuraEnabled public string campaignSubgroup{get;set;} 
        @AuraEnabled public string campaignGroup{get;set;}   
        @AuraEnabled public string campaignGroupDesc;
        @AuraEnabled public Price_Book_Details__c priceBookObj{get;set;}
        @AuraEnabled public Sales_Order_Line_Item__c salesOrderitem{get;set;}
        @auraEnabled public Boolean isTrue{get;set;}
        @auraEnabled public Integer priceitemsize{get;set;}  
        @auraEnabled public Integer groupRowspan{get;set;}  
        @AuraEnabled public integer totalGrpPricelist{get;set;}
        @AuraEnabled public integer totalGrpRowspan{get;set;}
        
        public PriceBookDetailWrap(){
            campaignGroupDesc ='';
            totalGrpRowspan = 0;
            totalGrpPricelist = 0;
            groupRowspan =0; 
            priceitemsize = 0;
            campaignSubgroup = '';
            campaignGroup = '';
            priceBookObj = new  Price_Book_Details__c();
            salesOrderitem = new  Sales_Order_Line_Item__c();
            isTrue =false;   
        }    
        //@AuraEnabled public string campaignGroup;
    }
    //CREATED METHOD FOR IMPACT OF BONIFICATION ORDER BY HARSHIT&ANMOL@WIPRO FOR (US SO-016) ---START  
    public class relatedOrder1{
        
        @AuraEnabled public decimal grossSales;
        @AuraEnabled public decimal tax;
        @AuraEnabled public decimal freigh;
        @AuraEnabled public decimal totalvar;
        @AuraEnabled public decimal grossmar;
        @AuraEnabled public decimal grosspro;
        @AuraEnabled public String Name;
        @AuraEnabled public decimal totalgrossSales;
        @AuraEnabled public decimal totaltax;
        @AuraEnabled public decimal totalfreigh;
        @AuraEnabled public decimal totalvarCost;
        
        @AuraEnabled public decimal totalvarCostBoni;
        @AuraEnabled public decimal totalgrossmarBoni;
        @AuraEnabled public decimal grossproBoni;
        @AuraEnabled public decimal taxBoni;
        @AuraEnabled public decimal freighBoni;
        @AuraEnabled public decimal grossSalesBoni;
        
        
        
        
        
        
        
        
        
        
        
        
        @AuraEnabled public decimal totalgrossmar;
        @AuraEnabled public decimal totalgrosspro;
        @AuraEnabled public decimal totalgrossmarBoni1;
        @AuraEnabled public decimal totaltaxBoni;
        @AuraEnabled public decimal totalfreighBoni;
        @AuraEnabled public decimal totalgrossproBoni;
        @AuraEnabled public String grossproper;
        @AuraEnabled public String grossproBoniper;
        @AuraEnabled public String totalgrossproper;
        @AuraEnabled public String totalgrossproBoniper;
        
        
        public relatedOrder1(){
            
            grossproper='';
            grossproBoniper='';
            totalgrossproper='';
            totalgrossproBoniper='';
            
            taxBoni=0.0;
            freighBoni=0.0;
            grossSales = 0.0;  
            tax = 0.0;    
            freigh =0.0;
            totalvar =0.0;
            grossmar =0.0;
            grosspro =0.0;
            Name='';
            totalgrossSales=0.0;
            totaltax=0.0;
            totalfreigh=0.0;
            totalvarCost=0.0;
            totalgrossmar=0.0;
            totalgrosspro=0.0;
            totalvarCostBoni=0.0;
            totalgrossmarBoni=0.0;
            grossproBoni=0.0;
            grossSalesBoni=0.0;
            totalgrossmarBoni1=0.0;
            totaltaxBoni=0.0;
            totalfreighBoni=0.0;
            totalgrossproBoni=0.0;
            
            
            
            
            
        }
    }
    
    public class StructOrderLineItem{
        @AuraEnabled public string soItemId;
        @AuraEnabled public string combinationkey;
        @AuraEnabled public string campGrp;
        @AuraEnabled public string camSubgrp;
        @AuraEnabled public string skuId;
        @AuraEnabled public Decimal multipleOf;
        @AuraEnabled public string skuDesc;
        @AuraEnabled public string skuCategory;
        @AuraEnabled public string cultureId;
        @AuraEnabled public string cultureDesc;
        @AuraEnabled public String culture;
        @AuraEnabled public Decimal conversionFactor;
        @AuraEnabled public string UOM;
        @AuraEnabled public decimal volume;
        @AuraEnabled public string volDifference;
        @AuraEnabled public string discountedInitialPriceStr;
        @AuraEnabled public string totalValStr;
        @AuraEnabled public String priceWithInterestStr;
        @AuraEnabled public String totalValWithInterestStr;
        @AuraEnabled public decimal prdctVol;
        @AuraEnabled public decimal intialPrice;
        @AuraEnabled public string invoiceDate;
        @AuraEnabled public decimal grpDiscount;
        @AuraEnabled public decimal totalVal;
        @AuraEnabled public decimal interestRate;
        @AuraEnabled public decimal costBRL;
        @AuraEnabled public decimal costUSD;
        @AuraEnabled public decimal fspPrice;
        @AuraEnabled public decimal intialPriceDisount;
        @AuraEnabled public decimal priceWithInterest;
        @AuraEnabled public decimal FinalUnitPrice;
        @AuraEnabled public decimal totalValWithInterest;
        @AuraEnabled public decimal equivalence;
        @AuraEnabled public boolean isTrue;
        @AuraEnabled public decimal days;
        @AuraEnabled public decimal CogsInfo;
        
        @AuraEnabled public Decimal Recommendedprice;//added by Sagar for Deal scoring 
        @AuraEnabled public String DDSGrade;//added by Sagar for Deal scoring 
        @AuraEnabled public integer timeInMonths;
        @AuraEnabled public boolean isAnchor;
        @AuraEnabled public boolean isManDiscount;
        @AuraEnabled public decimal manDiscount;
        @AuraEnabled public string interestDate;
        @AuraEnabled public decimal interestRateBRL;
        @AuraEnabled public decimal interestRateUSD;
        @AuraEnabled public string salesOrderBlockDate;
        @AuraEnabled public boolean isManual;
        @AuraEnabled public string brand;
        
        
        public StructOrderLineItem(){
            
            skuCategory = '';  
            isManual = false;    
            interestRateBRL =0.0;
            interestRateUSD =0.0;
            interestDate ='';
            volDifference ='';
            totalValStr ='';    
            totalValWithInterestStr='';
            priceWithInterestStr ='';
            discountedInitialPriceStr = '';
            salesOrderBlockDate ='';
            manDiscount = 0.0;
            isManDiscount = false;
            soItemId = '';    
            combinationkey = '';
            multipleOf = 0;
            campGrp ='';
            camSubgrp='';
            skuId='';
            skuDesc='';
            cultureId ='';
            cultureDesc ='';
            culture='';
            
            UOM ='';    
            volume = 0;
            prdctVol= 0;
            intialPrice= 0;
            invoiceDate='';
            grpDiscount=0;
            fspPrice =0;
            totalVal= 0; 
            costBRL= 0;
            costUSD= 0;
            intialPriceDisount= 0;
            priceWithInterest= 0;
            FinalUnitPrice= 0;
            totalValWithInterest= 0;
            equivalence = 0;
            isTrue = false; 
            interestRate =0;  
            days = 0;
            CogsInfo=0;
            
            Recommendedprice =0;//added by Sagar for Deal scoring 
            DDSGrade = '';//added by Sagar for Deal scoring 
            timeInMonths = 0; 
            isAnchor = false;
            brand='';
        }
    }
    
    
    
    
    
    /*public class StructCampaignDetailWrap{

@AuraEnabled public Sales_Order__c salesOrderObj;
@AuraEnabled public list<string> listCampaignGroup;
@AuraEnabled public map<string,Integer> mapSubgroupSize; 

@AuraEnabled public map<string,list<string>> mapCampaignSubgroup;
@AuraEnabled public Map<string,map<string,list<Price_Book_Details__c>>> mapofMapListPriceBook;
@AuraEnabled public map<string,Campaign_Group__c> mapofCampaignGroup;
@AuraEnabled public list<Campaign_Payment_Terms__c> listCampaignPaymentTermDays;
@AuraEnabled public list<Campaign_Payment_Terms__c> listCampaignPaymentFixeDate;
@AuraEnabled public SalesOrderItemsWrap salesOrderitemWrapObj;

public StructCampaignDetailWrap(){
mapSubgroupSize = new map<string,Integer>();
priceBookObj = new Price_Book__c();
salesOrderObj = new Sales_Order__c();
listCampaignGroup = new list<string>();
mapCampaignSubgroup = new map<string, list<string>>();
salesOrderitemWrapObj = new SalesOrderItemsWrap();
mapofMapListPriceBook = new Map<string,map<string,list<Price_Book_Details__c>>>();
mapofCampaignGroup = new map<string,Campaign_Group__c>();
listCampaignPaymentTermDays = new list<Campaign_Payment_Terms__c>();
listCampaignPaymentFixeDate = new list<Campaign_Payment_Terms__c>();
}
}*/
    
    
    public class PriceBookPaymentTermWrapper {
        
        @AuraEnabled public Map<String,Campaign_Payment_Terms__c> payTermsDays;
        @AuraEnabled public Map<String,Campaign_Payment_Terms__c> payTermsDates;
        @AuraEnabled public Payment_Term__c payTermBR71;
        @AuraEnabled public Price_Book__c priceBook;
        
        public PriceBookPaymentTermWrapper(){
            payTermsDays = new Map<String,Campaign_Payment_Terms__c>();
            payTermsDates = new Map<String,Campaign_Payment_Terms__c>();
            payTermBR71 = new Payment_Term__c();
            priceBook = new Price_Book__c();
        }
        
    }
    
    //added By Swapnil - To get Territory managers available in Same region
    
    public static map<id, Territory_Distributor__c> getTerritoryManagers(){
        String loggedInUser = UserInfo.getUserId();
        Id currentUserProfileId = UserInfo.getProfileId();
        String loggedInUserProfileName = [SELECT Name FROM Profile WHERE Id =: currentUserProfileId].Name;
        map<id, Territory_Distributor__c> TManagersMap = new map<id, Territory_Distributor__c>();
        List<Territory_Distributor__c> tdList2 = new List<Territory_Distributor__c> ();
        List<Territory_Distributor__c> tdlist = new List<Territory_Distributor__c> ();
        if(loggedInUserProfileName!='Brazil Barter Manager')
        {
            tdList = [SELECT ID, Name, TerritoryCode__c, SBU__c, Region__c, Open_TM_Code__c,
                      Zone__r.ZonalHead__c, SBU__r.SBUUser__c, Region__r.RegionHead__c,Region__r.Brazil_Marketing_Ops_Manager__c,
                      Zone__c, TerritoryManager__c, BarterManager__c
                      FROM Territory_Distributor__c 
                      WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                      //AND TerritoryManagerActive__c = True
                      AND (TerritoryManager__c=: loggedInUser 
                           OR Region__r.RegionHead__c=: loggedInUser
                           OR Region__r.Brazil_Marketing_Ops_Manager__c=:loggedInUser
                           OR Zone__r.ZonalHead__c=: loggedInUser
                           OR SBU__r.SBUUser__c=: loggedInUser
                           OR BarterManager__c=: loggedInUser
                           //OR BarterManager__r.profile.name ='Brazil Barter Manager' //Commented By Rakesh on INC0369642
                          ) // need this for all users >> Grazitti(Tanuj)- RITM0333006-19 Aug 2022
                      
                      ORDER BY LastModifiedDate DESC ];
            
        }
        else    // need this only for barter manager >> Grazitti(Tanuj)- RITM0333006-25 Aug 2022
        {
            tdList = [SELECT ID, Name, TerritoryCode__c, SBU__c, Region__c, Open_TM_Code__c,
                      Zone__r.ZonalHead__c, SBU__r.SBUUser__c, Region__r.RegionHead__c,Region__r.Brazil_Marketing_Ops_Manager__c,
                      Zone__c, TerritoryManager__c, BarterManager__c
                      FROM Territory_Distributor__c 
                      WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                      AND (TerritoryManager__c=: loggedInUser 
                           OR Region__r.RegionHead__c=: loggedInUser
                           OR Region__r.Brazil_Marketing_Ops_Manager__c=:loggedInUser
                           
                           OR Zone__r.ZonalHead__c=: loggedInUser
                           OR SBU__r.SBUUser__c=: loggedInUser
                           OR BarterManager__c=: loggedInUser
                           OR BarterManager__r.profile.name ='Brazil Barter Manager'
                          ) // need this for all users >> Grazitti(Tanuj)- RITM0333006-25 Aug 2022
                      
                      ORDER BY LastModifiedDate DESC ];
            
        }
        
        
        
        
        
        if(!tdList.isEmpty()){
            String territoryUser = tdList[0].TerritoryManager__c;
            String regionalHeadUser = tdList[0].Region__r.RegionHead__c;
            String regionalBrazilMarketingOpsManager=tdList[0].Region__r.Brazil_Marketing_Ops_Manager__c;
            
            String zonalHeadUser = tdList[0].Zone__r.ZonalHead__c;
            String sbuUser = tdList[0].SBU__r.SBUUser__c;
            String barterManager = tdList[0].BarterManager__c;//uncommented this >> Grazitti(Tanuj)- RITM0333006-8 Aug 2022
            
            if(loggedInUser==territoryUser ){
                tdList2 = [SELECT ID, TerritoryManager__c, TerritoryCode__c,Regional_Manager_Id__c,Open_TM_Code__c,  TerritoryManager__r.Name 
                           FROM Territory_Distributor__c 
                           WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                           //AND TerritoryManagerActive__c = True
                           AND Region__r.RegionHead__c=:regionalHeadUser
                           AND Region__r.Brazil_Marketing_Ops_Manager__c=: regionalBrazilMarketingOpsManager
                           
                           AND TerritoryManager__c!=:territoryUser];  
            }
            
            if(loggedInUser==regionalHeadUser ){
                tdList2 = [SELECT ID, TerritoryManager__c,TerritoryCode__c,Regional_Manager_Id__c,Open_TM_Code__c, TerritoryManager__r.Name 
                           FROM Territory_Distributor__c 
                           WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                           //AND TerritoryManagerActive__c = True
                           AND Region__r.RegionHead__c=:regionalHeadUser
                           ORDER BY LastModifiedDate DESC];  
            }
            if(loggedInUser==regionalBrazilMarketingOpsManager ){
                tdList2 = [SELECT ID, TerritoryManager__c,TerritoryCode__c,Regional_Manager_Id__c,Open_TM_Code__c, TerritoryManager__r.Name 
                           FROM Territory_Distributor__c 
                           WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                           //AND TerritoryManagerActive__c = True
                           AND Region__r.Brazil_Marketing_Ops_Manager__c=:regionalBrazilMarketingOpsManager
                           ORDER BY LastModifiedDate DESC];  
            }
            
            if(loggedInUser==zonalHeadUser){
                tdList2 = [SELECT ID, TerritoryManager__c,TerritoryCode__c,Regional_Manager_Id__c,Open_TM_Code__c, TerritoryManager__r.Name 
                           FROM Territory_Distributor__c 
                           WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                           //AND TerritoryManagerActive__c = True
                           AND Zone__r.ZonalHead__c=:zonalHeadUser
                           ORDER BY LastModifiedDate DESC];  
            }
            
            if(loggedInUser==sbuUser){
                tdList2 = [SELECT ID, TerritoryManager__c,TerritoryCode__c,Regional_Manager_Id__c,Open_TM_Code__c, TerritoryManager__r.Name 
                           FROM Territory_Distributor__c 
                           WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                           //AND TerritoryManagerActive__c = True
                           AND SBU__r.SBUUser__c=:sbuUser
                           ORDER BY LastModifiedDate DESC];  
            }
            if(loggedInUserProfileName=='Brazil Barter Manager'){//added this for barter manager profile >> Grazitti(Tanuj)- RITM0333006-8 Aug 2022 
                tdList2 = [SELECT ID, TerritoryManager__c,TerritoryCode__c,Regional_Manager_Id__c,Open_TM_Code__c, TerritoryManager__r.Name 
                           FROM Territory_Distributor__c 
                           WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                           AND BarterManager__c=:barterManager
                           ORDER BY TerritoryManager__r.Name ASC];  
            }
            
        }
        
        for (Territory_Distributor__c TD:tdList2){
            TManagersMap.put(TD.TerritoryManager__c, TD);
        }
        system.debug('**TManagersMap - '+TManagersMap);
        return TManagersMap;
    }
    
    //Added By Krishanu@wipro
    @AuraEnabled
    public static String getPriceBookT(String salesId){
        Sales_Order__c so = [select Kit_Order__c,Use_Campaign__c,AVEC_Order__c from Sales_Order__c where id = :salesId];
        if(so.Kit_Order__c){
            return 'Price Book for Kit';
        }else if(so.Use_Campaign__c){
            return 'Price Book for Campaign';
        }else if(so.AVEC_Order__c){
            return 'AVEC / Descontinuados Price Book';
        }
        return 'Normal Price Book';
    }
    
    //Added by Swapnil - To Get all the pricelists belonging to the Sales 
    //District of the selected sales rep
    @AuraEnabled
    public static List<String> getPriceListValuesSalesRep(String SalesRepId){
        
        List<String> options = new List<String>();
        
        System.debug('SalesRepId: '+SalesRepId);
        
        List<String> regionList = new list<string>();
        
        List<Territory_Distributor__c> tdList = [SELECT ID, Name, TerritoryCode__c, Region__c
                                                 FROM Territory_Distributor__c 
                                                 WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                                                 AND TerritoryManagerActive__c = True
                                                 AND (TerritoryManager__c=: SalesRepId 
                                                      OR Region__r.RegionHead__c=: SalesRepId
                                                      OR Region__r.Brazil_Marketing_Ops_Manager__c=:SalesRepId
                                                      
                                                      OR Zone__r.ZonalHead__c=: SalesRepId
                                                      OR SBU__r.SBUUser__c=: SalesRepId
                                                      OR BarterManager__c=: SalesRepId
                                                     )]; 
        System.debug('Region tdList: '+tdList);
        
        Set<String> regionSet = new Set<String>();
        for(Territory_Distributor__c tdObj:tdList){
            regionSet.add(tdObj.Region__c);
        }
        
        
        regionList.addAll(regionSet);
        System.debug('regionList: '+regionList);
        Set<Id> salesDistrictPriceBookSet = new Set<Id>();
        
        
        
        for(Price_Book_Sales_District__c sdObj:[SELECT Id, Name, Price_Book__c, Sales_District1__c
                                                FROM Price_Book_Sales_District__c
                                                WHERE Sales_District1__c IN: regionList]){
                                                    
                                                    salesDistrictPriceBookSet.add(sdObj.Price_Book__c);
                                                    
                                                    
                                                    
                                                } 
        System.debug('salesDistrictPriceBookSet: '+salesDistrictPriceBookSet);
        
        for(Price_Book__c pbObj:[SELECT Id, Name, Division__c, Currency__c, Valid_From__c, Expiry_Date__c ,Campaign_Type__c,
                                 Optional_Simulator__c, Interest_Date__c FROM Price_Book__c 
                                 WHERE Id IN:salesDistrictPriceBookSet //salesDistrictPriceBookSet
                                 AND Valid_From__c <= TODAY 
                                 AND Expiry_Date__c >= TODAY
                                 AND isActive__c = True
                                 AND Status__c = 'Approved'
                                 AND Base_Price_Book__c = false
                                 ORDER BY Name]){ 
                                     
                                     
                                     
                                     options.add(pbObj.Name+'*'+pbObj.Id+'*'+pbObj.Campaign_Type__c+'*'+pbObj.Optional_Simulator__c);
                                     
                                 }
        
        System.debug('PriceBook options: '+options);
        
        return options;
    } 
    // created this mtd by Sagar for DDS score  
    
    //Below method added by Sagar@wipro
    @AuraEnabled
    public static boolean isBrazilUsercheck (){
        Boolean braziluserflag = false;
        String userid= UserInfo.getUserId();
        User u = [select id, Name, Region1__c from user where id =:userid];
        if(u.Region1__c == 'BRAZIL'){
            braziluserflag=true; 
        }
        return braziluserflag;
    }
    //Below method added by Anmol@wipro
    @AuraEnabled
    public static boolean isBrazilSalesUsercheck (){
        Boolean braziluserflag = false;
        String userid= UserInfo.getUserId();
        User u = [select id, Name,Profile.Name, Region1__c from user where id =:userid];
        if(u.Profile.Name == 'Brazil Sales Person'){
            braziluserflag=true; 
        }
        return braziluserflag;
    }
    //Change by Swaranjeet(Grazitti) APPS-4591 
    @AuraEnabled
    public static boolean updateBarter (Map<String,decimal> recordMap, Decimal TotalofDiscount, Decimal BarterDiscountSalesorder, Decimal Grosssalesorder,Map<String,decimal> NewGrossmap, Map<String,decimal> BarterpercentcalculatedMap) {
        System.debug('recordMap-------'+recordMap);
         System.debug('BarterpercentcalculatedMap-------'+BarterpercentcalculatedMap);
        List<Sales_Order_Line_Item__c> updatelist = new List<Sales_Order_Line_Item__c>();
        Set<Sales_Order__c> updatesetsalesorder = new Set<Sales_Order__c>();
         list<Sales_Order__c> updatelistsalesorder = new List<Sales_Order__c>();
        List<Sales_Order_Line_Item__c> salesOrderItemList = [SELECT ID,BarterDiscountCalculated1__c,Sale_Order__c,Barter_Discount_Percentage__c,Gross_Margin_with_Barter1__c
                                                             FROM Sales_Order_Line_Item__c
                                                             WHERE ID in :recordMap.keyset()];
        System.debug('salesOrderItemList----++++-------'+salesOrderItemList);
        if(salesOrderItemList.size()>0){
            for(Sales_Order_Line_Item__c salesitem :salesOrderItemList){
                System.debug('recordmap.get(salesitem.ID)-----'+recordmap.get(salesitem.ID));
                salesitem.Barter_Discount_Percentage__c = recordmap.get(salesitem.ID);
                if(BarterpercentcalculatedMap.containsKey(salesitem.ID)){
                salesitem.BarterDiscountCalculated1__c = BarterpercentcalculatedMap.get(salesitem.ID);
                    }
                if(NewGrossmap.containsKey(salesitem.ID)){
                     salesitem.Gross_Margin_with_Barter1__c = NewGrossmap.get(salesitem.ID);
                }
               
                updatelist.add(salesitem);
            }
            String salesorderid = salesOrderItemList[0].Sale_Order__c;
            System.debug('salesorderid++++-------'+salesorderid);
            Sales_Order__c ssorder = [select id, Total_of_Discount_Applied__c,TotalBarterDiscount__c,Gross_Margin_with_Barter1__c from Sales_Order__c where id =:salesorderid];
            System.debug('ssorder++++-------'+ssorder);
           
              if(TotalofDiscount != Null && BarterDiscountSalesorder != Null && Grosssalesorder != Null){
                System.debug('TotalofDiscount----'+TotalofDiscount);
                System.debug('BarterDiscountSalesorder----'+BarterDiscountSalesorder);
                System.debug('Grosssalesorder----'+Grosssalesorder);
                ssorder.Total_of_Discount_Applied__c = TotalofDiscount;
                ssorder.TotalBarterDiscount__c = BarterDiscountSalesorder;
                ssorder.Gross_Margin_with_Barter1__c = Grosssalesorder;
                System.debug('ssorder.TotalBarterDiscount__c++++-------'+ssorder.TotalBarterDiscount__c);
                System.debug('ssorder.Gross_Margin_with_Barter1__c++++-------'+ssorder.Gross_Margin_with_Barter1__c);
                System.debug('ssorder.Total_of_Discount_Applied__c++++-------'+ssorder.Total_of_Discount_Applied__c);
                updatesetsalesorder.add(ssorder);
                 
            }
           
        }
        System.debug('updatelist++++-------'+updatelist);
        if(updatelist.size()>0){
            update updatelist;
        }
         System.debug('updatesetsalesorder++++-------'+updatesetsalesorder);
        updatelistsalesorder.addAll(updatesetsalesorder);
         System.debug('updatelistsalesorder++++-------'+updatelistsalesorder);
        if(updatelistsalesorder.size()>0){
            update updatelistsalesorder;
        }
        
        return true;
    }
    
      //Change by Swaranjeet(Grazitti) APPS-4591
    @AuraEnabled
    public static List<SalesOrderItem> updateBarterLineitem (String salesOrderItemString,String pbid1, Map<String,decimal> businessdiscmap) {
        Map<Id, decimal> mapSkuUnitPrice = new Map<Id, decimal>();
          System.debug('in the updateBarterLineitem--------');
        List<Price_Book_Details__c> lstPBDetails = [Select Id, Name,Price_Book__r.CurrencyIsoCode,Unit_Price_U__c, Unit_Price_R__c, SKU__c from Price_Book_Details__c where Price_Book__c =: pbid1];
        if(lstPBDetails.size() > 0) {
            for(Price_Book_Details__c oPBDetails : lstPBDetails) {
                if(oPBDetails.Price_Book__r.CurrencyIsoCode	 == 'USD') {
                    mapSkuUnitPrice.put(oPBDetails.SKU__c, oPBDetails.Unit_Price_U__c);
                }
                else {
                    mapSkuUnitPrice.put(oPBDetails.SKU__c, oPBDetails.Unit_Price_R__c);
                }
            }
        }
        System.debug('mapSkuUnitPrice-----'+mapSkuUnitPrice);
        List<SalesOrderItem> item = (List<SalesOrderItem>)JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class);
        system.debug('lineitemsize**00000000'+item.size());
        List<string> itemsku = new List<string>();
        System.debug('businessdiscmap-----'+businessdiscmap);
        for(SalesOrderItem soitem: item){ 
            if(businessdiscmap.containsKey(soitem.Ids)){
             system.debug('businessdiscmap.containsKey(soitem.Ids)'+businessdiscmap.containsKey(soitem.Ids));    
            system.debug('soitem.unitValue000'+soitem.unitValue);
            system.debug('mapSkuUnitPrice.get(soitem.productId)==='+mapSkuUnitPrice.get(soitem.productId));
            soitem.DiscountBarter = (soitem.unitValue / mapSkuUnitPrice.get(soitem.productId) ) * 100;
            system.debug('soitem.DiscountBarter000---'+soitem.DiscountBarter);
           //	soitem.unitValue =  soitem.unitValue - (soitem.unitValue * businessdiscmap.get(soitem.Ids) / 100); //>> Grazitti(Butesh Singla)- RITM0518895-09 March 2023 (Barter discount should not applied on line items)
          // system.debug('soitem.unitValue000---'+soitem.unitValue);    
            }
         }  
        system.debug('items**------'+item);
        return item;
    }
    
    //Method added by Sagar for SO-003
    @AuraEnabled
    public static List<SalesOrderItem> updatePresentValueByBarter (String salesOrderItemString,String pbid1, decimal businessdisc) {
        Map<Id, decimal> mapSkuUnitPrice = new Map<Id, decimal>();
        
        List<Price_Book_Details__c> lstPBDetails = [Select Id, Name,Price_Book__r.CurrencyIsoCode,Unit_Price_U__c, Unit_Price_R__c, SKU__c from Price_Book_Details__c where Price_Book__c =: pbid1];
        if(lstPBDetails.size() > 0) {
            for(Price_Book_Details__c oPBDetails : lstPBDetails) {
                if(oPBDetails.Price_Book__r.CurrencyIsoCode	 == 'USD') {
                    mapSkuUnitPrice.put(oPBDetails.SKU__c, oPBDetails.Unit_Price_U__c);
                }
                else {
                    mapSkuUnitPrice.put(oPBDetails.SKU__c, oPBDetails.Unit_Price_R__c);
                }
            }
        }
        
        List<SalesOrderItem> item = (List<SalesOrderItem>)JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class);
        system.debug('lineitemsize**'+item.size());
        List<string> itemsku = new List<string>();
        // decimal totalDiscount = businessdisc + financialdisc;
        for(SalesOrderItem soitem:item){ 
            system.debug('soitem.unitValue'+soitem.unitValue);
            system.debug('mapSkuUnitPrice.get(soitem.productId)'+mapSkuUnitPrice.get(soitem.productId));
            //soitem.DiscountBarter = (soitem.unitValue / mapSkuUnitPrice.get(soitem.productId) ) * 100;
           // soitem.unitValue =  soitem.unitValue - (soitem.unitValue * businessdisc / 100); //>> Grazitti(Butesh Singla)- RITM0518895-09 March 2023 (Barter discount should not applied on line items)
            // if(soitem.CurrencyIsoCode == 'USD'){
            //below code added by Sagar for calculating Barter Discount using CustomerConversionFactor
            system.debug('soitem.unitValue'+soitem.unitValue);
            system.debug('mapSkuUnitPrice.get(soitem.productId)'+mapSkuUnitPrice.get(soitem.productId));
            decimal UnitPricePB = mapSkuUnitPrice.get(soitem.productId)* soitem.CustomerConversionFactor ; 
            system.debug('UnitPricePB'+UnitPricePB);
            soitem.DiscountBarter =100 - ((soitem.unitValue / UnitPricePB) * 100 );
            system.debug('soitem.DiscountBarter'+soitem.DiscountBarter);
            //     }
        }  
        system.debug('items**'+item);
        
        return item;
    }
    
    
    @AuraEnabled
    public static List<SalesOrderItem> totalrepcostlogic (String salesOrderItemString, string sCurrencyCode, decimal usdrate, string customer1) {
        List<SalesOrderItem> item = (List<SalesOrderItem>)JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class);
        system.debug('lineitemsize**'+item.size());
        List<string> itemsku = new List<string>();
        for(SalesOrderItem item1:item){
            itemsku.add(item1.productCode);
        }
        Account acc = [SELECT Id, Depot_Code__c FROM Account WHERE Id=:customer1];
        String depotcode = acc.Depot_Code__c;
        system.debug('depotcode**'+depotcode);
        List<Material_Plant_Relation__c> mtrel = [Select id,Name,Material_Code__c,Replacement_Cost__c,Depot_Code__c from Material_Plant_Relation__c where Active__c=true and Material_Code__c IN :itemsku and Depot__c=:depotcode];
        
        system.debug('itemskulist'+itemsku);
        //totalreplacementcost
        system.debug(mtrel);
        for(SalesOrderItem soitem:item){    
            for(Material_Plant_Relation__c mtrel1:mtrel){
                if(mtrel1.Material_Code__c == soitem.productCode) {
                    decimal decReplacementCost = mtrel1.Replacement_Cost__c;
                    
                    system.debug('mtrel1.Depot_Code__c**'+mtrel1.Depot_Code__c);
                    soitem.totalreplacementcost = decReplacementCost * soitem.qty;
                }
            }
        }  
        system.debug('items**'+item);
        
        return item;
    }
    // created this mtd by Sagar for DDS score 
    @AuraEnabled
    public static List<SalesOrderItem> dealScoringValidCall (Sales_Order__c soObj, String salesOrderItemString, string customer1, string sellerid) {
        String userid= UserInfo.getUserId();
        string custid= customer1;
        system.debug('custid**'+custid);
        String LongDate = ' ';
        id pbid= soObj.Price_Book__c;
        string sCurrencyCode = soObj.CurrencyIsoCode;
        integer intStatusCode=0;
        String sResultBody='';
        Price_Book__c PBdetail = [select id,USD_Rate__c from Price_Book__c where id=:pbid];
        decimal usdrate=0;
        if(PBdetail.USD_Rate__c != null){
            usdrate=PBdetail.USD_Rate__c;
        }
        
        List<SalesOrderItem> item1 = OrderRequestController.totalrepcostlogic(salesOrderItemString, sCurrencyCode, usdrate, customer1);
        User userObj = [Select Id, Profile.Name, Show_List_Value__c FROM User WHERE Id=:UserInfo.getUserId()];
        String profileName = userObj.Profile.Name;
        Territory_Distributor__c Territory = new Territory_Distributor__c();
        string sSBUCode;
        if(sellerid == null){
            Territory = [select id, TerritoryManager__r.Name,Region__r.Zone__r.SBU_Code__c from Territory_Distributor__c where TerritoryManager__c =:userid AND TM_Code__c != null];
            sSBUCode = Territory.Region__r.Zone__r.SBU_Code__c;
        }
        else if(sellerid == userid && profileName == 'Brazil Sales District Manager'){
            Region__c regionobj = [select id,Zone__r.SBU_Code__c from Region__c where RegionHead__c =:userid Limit 1]; // Limit added GRZ(Sumit kumar) INC0374694 modified on 12-09-2022
            sSBUCode = regionobj.Zone__r.SBU_Code__c;
        }
        else{
            Territory = [select id, TerritoryManager__r.Name,Region__r.Zone__r.SBU_Code__c from Territory_Distributor__c where TerritoryManager__c =:sellerid AND TM_Code__c != null];
            sSBUCode = Territory.Region__r.Zone__r.SBU_Code__c;
        }
        //id regionid=Territory.Region__c;
        //Region__c regionobj = [select id,Zone__r.SBU_Code__c from Region__c where id=:regionid];
        //string sSBUCode = Territory.Region__r.Zone__r.SBU_Code__c;
        system.debug('sSBUCode'+sSBUCode);
        
        List<ResWrapper> responseObjlst = new List<ResWrapper>();
        List<SalesOrderItem> lineitems = new List<SalesOrderItem>();
        List<SalesOrderItem> item = (List<SalesOrderItem>)JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class);
        system.debug('lineitems**'+lineitems);
        system.debug('lineitemsize**'+item.size());
        
        Set<string> lstSKUId = new Set<string>();
        Map<string, string> ddscon = new Map<string, string>();
        ddscon.put('Very Good Quality', 'Muito Bom');
        ddscon.put('Good Quality', 'Ok');
        ddscon.put('Low Quality', 'Ruim');
        ddscon.put('Very Low Quality', 'Muito Ruim');
        ddscon.put('No Grade as deal_price<min_price', 'No Grade as deal price min price');
        Map<Id, decimal> mapSKUIdUPrice = new Map<Id, decimal>();
        for(SalesOrderItem oItem: item1) {
            lstSKUId.add(oItem.productId);
        }
        if(lstSKUId.size() > 0) {
            List<Price_Book_Details__c> lstPBDetails = [Select Id, Name, Unit_Price_U__c, Unit_Price_R__c, SKU__c from Price_Book_Details__c where SKU__c IN: lstSKUId AND Price_Book__c =: pbid];
            if(lstPBDetails.size() > 0) {
                for(Price_Book_Details__c oPBDetails : lstPBDetails) {
                    if(sCurrencyCode == 'USD') {
                        mapSKUIdUPrice.put(oPBDetails.SKU__c, oPBDetails.Unit_Price_U__c);
                    }
                    else {
                        mapSKUIdUPrice.put(oPBDetails.SKU__c, oPBDetails.Unit_Price_R__c);
                    }
                }
            }
        }
        
        double itemsize = item.size();
        List<salesorder> soList = new List<Salesorder>();
        Datetime cDT = System.now();
        LongDate = cDT.format('MM/yyyy');
        Account acc = [Select Name, Price_Conversion_Group__c,Customer_Region__c from Account where id IN (:customer1)];
        String customerName=acc.Name;
        String customerGroup=acc.Price_Conversion_Group__c;
        String CustomerRegion = acc.Customer_Region__c;
        Business_Rule__c BRobj = [select Freight__c,Taxes__c from Business_Rule__c where Name=:CustomerRegion];
        system.debug('BRobj'+BRobj);
        
        string totalreq;
        String fxrate= string.valueOf(usdrate);
        string fxrateheader =  '{"FX_Rate":'+usdrate+'}';
        
        ExchangeRate__c   exrate= [SELECT Id, ExchangeRate__c, Createddate 
                                   FROM ExchangeRate__c  where FromCurrency__c = 'USD' AND ToCurrency__c = 'BRL' 
                                   Order BY Createddate DESC limit 1];
        decimal exrate1=exrate.ExchangeRate__c;
        system.debug('item1==>>'+item1);
        try{
            for(SalesOrderItem soitem:item1){
                salesorder sorder = new Salesorder();
                //decimal replacementMargin1= ((soitem.totalValueWithInterest) - ((BRobj.Taxes__c/100) * soitem.totalValueWithInterest));
                decimal totalreplcostformargin=soitem.totalreplacementcost;
                if(soObj.CurrencyIsoCode == 'BRL') {
                    totalreplcostformargin=(soitem.totalreplacementcost * exrate1);
                }
                decimal replacementMargin1= (soitem.totalValueWithInterest - ((BRobj.Taxes__c/100) * soitem.totalValueWithInterest) - ((BRobj.Freight__c/100) * soitem.totalValueWithInterest) - (totalreplcostformargin)) / soitem.totalValueWithInterest ;
                
                //system.debug('replacementMargin1'+replacementMargin1);
                decimal decTotalValueWithInterest = soitem.totalValueWithInterest;
                system.debug('decTotalValueWithInterest'+decTotalValueWithInterest+ 'totalreplacementcost'+soitem.totalreplacementcost);
                //decimal replacementMargin2 = decTotalValueWithInterest - soitem.totalreplacementcost;
                decimal replacementMargin2 = decTotalValueWithInterest * replacementMargin1;
                if(soObj.CurrencyIsoCode == 'BRL') {
                    replacementMargin2=replacementMargin2/usdrate;
                }
                system.debug('replacementMargin1'+replacementMargin1+ 'replacementMargin2'+replacementMargin2);
                //system.debug('replacementMargin2'+replacementMargin2);
                sorder.Numero_do_Pedido=0;
                sorder.Management= sSBUCode; //regionobj.Zone__r.SBU_Code__c;
                sorder.Mes_do_pedido=LongDate;
                sorder.Business_Unit=userInfo.getUserId();
                sorder.Customer_Group=customerGroup;
                sorder.Customer=customerName;
                sorder.Brand=soitem.brand;
                sorder.Prod_Code=integer.ValueOf(soitem.productCode);
                sorder.Product_Description=soitem.productName;
                sorder.Quantity=integer.ValueOf(soitem.qty);
                sorder.Order_Sales_FV_USD=soitem.totalValueWithInterest;
                sorder.Order_Total_Cogs_USD=soitem.totalreplacementcost;
                sorder.Order_Gross_Margin_PV_USD=replacementMargin2;
                
                decimal decUPrice = 0;
                if(mapSKUIdUPrice.containsKey(soitem.productId)) {
                    decUPrice = mapSKUIdUPrice.get(soitem.productId);
                }
                decimal PriceListSalesFVUSD = (decUPrice)*(integer.ValueOf(soitem.qty));
                system.debug('PriceListSalesFVUSD**'+PriceListSalesFVUSD);
                sorder.Price_List_Sales_FV_USD=PriceListSalesFVUSD.setScale(2, RoundingMode.HALF_UP);
                
                
                sorder.Currency1=soObj.CurrencyIsoCode;
                soList.add(sorder);
            }
            System.debug(soList);
            System.debug(JSON.serialize(soList));
            Http http = new Http();              
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('X-Requested-With','XMLHttpRequest');
            req1.setEndpoint('callout:Product_Credentials');
            string srsoi = JSON.serialize(soList);
            srsoi = srsoi.replaceAll('Numero_do_Pedido', 'Número do Pedido');
            srsoi = srsoi.replaceAll('Mes_do_pedido', 'Mês do pedido');
            srsoi = srsoi.replaceAll('Business_Unit', 'Business Unit');
            srsoi = srsoi.replaceAll('Customer_Group', 'Customer Group');
            srsoi = srsoi.replaceAll('Prod_Code', 'Prod Code');
            srsoi = srsoi.replaceAll('Product_Description', 'Product Description');
            srsoi = srsoi.replaceAll('Order_Sales_FV_USD', 'Order Sales FV');
            srsoi = srsoi.replaceAll('Order_Total_Cogs_USD', 'Order Total Cogs');
            srsoi = srsoi.replaceAll('Order_Gross_Margin_PV_USD', 'Order Gross Margin FV');
            srsoi = srsoi.replaceAll('Price_List_Sales_FV_USD', 'Price List Sales FV');
            srsoi = srsoi.replaceAll('Currency1', 'Currency');
            system.debug(srsoi);
            totalreq = '[' + fxrateheader + ',' + srsoi + ']';
            system.debug(totalreq);
            req1.setBody(totalreq);
            req1.setMethod('POST');
            req1.setTimeout(15000);
            System.debug(req1);
            HttpResponse result = new HttpResponse();
            if(!Test.isRunningTest()) {
                result= http.send(req1);
            }
            else{
                result.setBody('[{"Prod_Code": 6302691, "Recommended_price": 217.92, "DDS_Grade": "Very Good Quality"}] ');
                result.setStatusCode(200);
                
            }
            result.getStatusCode();
            intStatusCode = result.getStatusCode();
            sResultBody =result.getBody();
            System.debug('result.getBody()=='+result.getBody());
            System.debug(result.getStatusCode());
            String errormsg1;
            errormsg1='';
            if(result.getStatusCode()==200){
                system.debug('Checkpoint');
                responseObjlst = (List<ResWrapper>)JSON.deserialize(result.getBody(), List<ResWrapper>.class);
                system.debug('Checkpoint1');
                System.debug('responseObjlst = '+responseObjlst);
                
                integer count = 0;
                for(SalesOrderItem soitem:item)
                {   
                    soitem.Recommendedprice=responseObjlst[count].Recommended_price;
                    soitem.Recommendedprice=soitem.Recommendedprice.setScale(2);
                    soitem.DDSGrade=ddscon.get(responseObjlst[count].DDS_Grade);
                    soitem.DDSApiErrMsg = 'No Error';
                    
                    count = count + 1;
                } 
                Deal_Scoring_ErrorLog__c dserror = new Deal_Scoring_ErrorLog__c();
                dserror.Error_Type__c='Sales Order Details';
                dserror.Message__c = errormsg1;
                dserror.StackTrace__c = result.getBody();
                //insert dserror;
                
                if(Test.isRunningTest()){
                    string accId = null;
                    string[] strArray = accId.split('-');
                }
            }  
            else{
                Deal_Scoring_ErrorLog__c dserror = new Deal_Scoring_ErrorLog__c();
                dserror.Error_Type__c='Sales Order Details';
                dserror.Message__c = errormsg1;
                dserror.StackTrace__c = result.getBody();
                insert dserror;
            }
        }
        
        catch(Exception e){
            system.debug('Errors=>'+e.getLineNumber()+ e.getMessage());
            for(SalesOrderItem soitem:item){
                soitem.DDSApiErrMsg = 'Error While Exectuting the model';
            }
            Deal_Scoring_ErrorLog__c dserror = new Deal_Scoring_ErrorLog__c();
            dserror.Error_Type__c='Sales Order Failed Details';
            if(intStatusCode == 200){
                dserror.StackTrace__c =sResultBody;
            }
            else{
                dserror.StackTrace__c = e.getMessage();
            }
            insert dserror;
        }
        return item; 
    }
    // Added by Krishanu and Ankita to return Sellout matrix @ Wipro
    @AuraEnabled
    public static List<Sell_Out_Percentage__c> getSelloutMinpriceFactor(){
        return [select Type__c,Sell_Out_Factor__c,Min_Price_Factor__c from Sell_Out_Percentage__c];
    }
    
    @AuraEnabled
    public static Boolean checkApproval(String recordid) {
        system.debug('@@@@recordid++++'+recordid);
        Boolean resposneBoolean=false;
        List<ProcessInstanceWorkitem> PIWIList=[select id,ProcessInstance.ProcessDefinition.DeveloperName,ProcessInstance.Status,ProcessInstance.ProcessDefinitionid,ProcessInstance.ProcessDefinition.Name,Actor.name,ProcessInstance.TargetObjectId from
                                                ProcessInstanceWorkitem where ProcessInstance.TargetObjectId =:recordid and ProcessInstance.ProcessDefinitionid=:system.label.Approval_Process_id and Actorid=: Userinfo.getUserId() and ProcessInstance.Status='Pending']; 
        if(PIWIList.size()>0){
            resposneBoolean=true;
        }
        return resposneBoolean;
        
    }
    
    
    
    
    // created this mtd by Sagar for DDS score 
    public class Salesorder{
        @AuraEnabled public integer Numero_do_Pedido{get;set;}
        @AuraEnabled public string Management{get;set;}
        @AuraEnabled public string Mes_do_pedido{get;set;}
        @AuraEnabled public string Business_Unit{get;set;}
        @AuraEnabled public string Customer_Group{get;set;}
        @AuraEnabled public string Customer{get;set;}
        @AuraEnabled public string Brand{get;set;}
        @AuraEnabled public integer Prod_Code{get;set;}
        @AuraEnabled public string Product_Description{get;set;}
        @AuraEnabled public integer Quantity{get;set;}
        @AuraEnabled public double Order_Sales_FV_USD{get;set;}
        @AuraEnabled public double Order_Total_Cogs_USD{get;set;}
        @AuraEnabled public double Order_Gross_Margin_PV_USD{get;set;}
        @AuraEnabled public double Price_List_Sales_FV_USD{get;set;}
        @AuraEnabled public string Currency1{get;set;}    
    }
    // created this mtd by Sagar for DDS score 
    public class ResWrapper{
        @AuraEnabled public Integer Prod_Code{get;set;}
        @AuraEnabled public decimal Recommended_price{get;set;}
        @AuraEnabled public String DDS_Grade{get;set;}
        @AuraEnabled public String sErrMsg;
        @AuraEnabled public String result;  
    }
    public class MinValWrapper{
        @AuraEnabled public String OrderType{get;set;}
        @AuraEnabled public decimal MinVal{get;set;}
        @AuraEnabled public decimal MinValUSD{get;set;}
        @AuraEnabled public decimal MaxDisc{get;set;}
    }
    //CREATED METHOD FOR IMPACT OF BONIFICATION ORDER BY HARSHIT&ANMOL@WIPRO FOR (US SO-016) ---START  
    public class relatedOrder{
        
        @AuraEnabled public decimal grossSales;
        @AuraEnabled public decimal tax;
        @AuraEnabled public decimal freigh;
        @AuraEnabled public decimal totalvar;
        @AuraEnabled public decimal grossmar;
        @AuraEnabled public decimal grosspro;
        @AuraEnabled public String Name;
        @AuraEnabled public decimal totalgrossSales;
        @AuraEnabled public decimal totaltax;
        @AuraEnabled public decimal totalfreigh;
        @AuraEnabled public decimal totalvarCost;
        @AuraEnabled public decimal totalvarCostBoni;
        @AuraEnabled public decimal totalgrossmarBoni;
        @AuraEnabled public decimal grossproBoni;
        @AuraEnabled public decimal taxBoni;
        @AuraEnabled public decimal freighBoni;
        @AuraEnabled public decimal grossSalesBoni;
        @AuraEnabled public decimal totalgrossmar;
        @AuraEnabled public decimal totalgrosspro;
        @AuraEnabled public decimal totalgrossmarBoni1;
        @AuraEnabled public decimal totaltaxBoni;
        @AuraEnabled public decimal totalfreighBoni;
        @AuraEnabled public decimal totalgrossproBoni;
        @AuraEnabled public String grossproper;
        @AuraEnabled public String grossproBoniper;
        @AuraEnabled public String totalgrossproper;
        @AuraEnabled public String totalgrossproBoniper;
        
        
        public relatedOrder(){
            
            grossproper='';
            grossproBoniper='';
            totalgrossproper='';
            totalgrossproBoniper='';
            taxBoni=0.0;
            freighBoni=0.0;
            grossSales = 0.0;  
            tax = 0.0;    
            freigh =0.0;
            totalvar =0.0;
            grossmar =0.0;
            grosspro =0.0;
            Name='';
            totalgrossSales=0.0;
            totaltax=0.0;
            totalfreigh=0.0;
            totalvarCost=0.0;
            totalgrossmar=0.0;
            totalgrosspro=0.0;
            totalvarCostBoni=0.0;
            totalgrossmarBoni=0.0;
            grossproBoni=0.0;
            grossSalesBoni=0.0;
            totalgrossmarBoni1=0.0;
            totaltaxBoni=0.0;
            totalfreighBoni=0.0;
            totalgrossproBoni=0.0;
        }
        
    }
    
    // Added by Krishanu and Ankita to return replacement cost from SKU @ Wipro
    @AuraEnabled	
    public static Decimal getReplacementCost(string skuid){
        Material_Plant_Relation__c mtrel = [Select id,Name,SKU__c,Material_Code__c,Replacement_Cost__c,Active__c,Depot_Code__c  from Material_Plant_Relation__c where SKU__C=:skuid AND Depot_Code__c  ='BR07' LIMIT 1];     		
        return mtrel.Replacement_Cost__c;
    }
    
    // Added by Sagar@Wipro for StatusOrdemVendas API Call
    @AuraEnabled	
    Public static void SKUUpdateAPI(String soId){
        SKUBrazilOutboundAPI.SKUUpdate(soId,null,null);
    }
    
    // created this mtd by Sagar for Child Replacement Margin
    @AuraEnabled
    public static decimal ChildReplacementMargin (Sales_Order__c soObj, String salesOrderItemString) {
        User userObj = [Select Id, Profile.Name, Show_List_Value__c FROM User WHERE Id=:UserInfo.getUserId()];
        string sCurrencyCode = soObj.CurrencyIsoCode;
        Price_Book__c PBdetail = [select id,USD_Rate__c from Price_Book__c where id=:soObj.Price_Book__c];
        decimal usdrate=0;
        if(PBdetail.USD_Rate__c != null){
            usdrate=PBdetail.USD_Rate__c;
        }
        List<SalesOrderItem> lineitems = new List<SalesOrderItem>();
        Account acc = [Select Name,Depot_Code__c, Price_Conversion_Group__c,Customer_Region__c from Account where id =: soObj.Sold_to_Party__c];
        List<SalesOrderItem> item1 = (List<SalesOrderItem>)JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class); 
        List<string> itemsku = new List<string>();
        for(SalesOrderItem item:item1){
            itemsku.add(item.productCode);
        }
        
        system.debug('item1'+item1);
        
        List<Material_Plant_Relation__c> mtrel = [Select id,Name,Material_Code__c,Replacement_Cost__c,Depot_Code__c from Material_Plant_Relation__c 
                                                  where Active__c=true and Material_Code__c IN :itemsku and Depot__c=:acc.Depot_Code__c];		
        map<string,decimal> mtrelmap = new map<string,decimal>();
        for(Material_Plant_Relation__c mtrel1:mtrel ){
            mtrelmap.put(mtrel1.Material_Code__c,mtrel1.Replacement_Cost__c);
        }
        
        System.debug('mtrelmap'+mtrelmap);
        
        double itemsize = item1.size();
        
        String CustomerRegion = acc.Customer_Region__c;
        Business_Rule__c BRobj = [select Freight__c,Taxes__c from Business_Rule__c where Name=:CustomerRegion];
        system.debug('BRobj'+BRobj);
        ExchangeRate__c   exrate= [SELECT Id, ExchangeRate__c, Createddate 
                                   FROM ExchangeRate__c  where FromCurrency__c = 'USD' AND ToCurrency__c = 'BRL' 
                                   Order BY Createddate DESC limit 1];
        
        System.debug('exrate'+exrate);
        decimal exrate1=exrate.ExchangeRate__c;
        decimal ATotalreplcost = 0.0;
        decimal ATaxAmount = 0.0;
        decimal ATotalFreight = 0.0;
        decimal ATotalValueWithInterest = 0.0;
        decimal ATotalPunctuality = 0.0;
        for(SalesOrderItem soitem:item1){
            system.debug('mtrelmap.get(soitem.productCode)'+mtrelmap.get(soitem.productCode));
            system.debug('soitem.qty'+soitem.qty);
            
            soitem.productCode=String.ValueOf(soitem.productCode);
            system.debug('soitem.productCode'+soitem.productCode);
            
            soitem.totalreplacementcost = mtrelmap.get(soitem.productCode) * soitem.qty ;
            system.debug('soitem.totalreplacementcost'+soitem.totalreplacementcost);
            
            ATotalreplcost = ATotalreplcost + soitem.totalreplacementcost;
            
            system.debug('ATotalreplcost'+ATotalreplcost);
            
            ATotalValueWithInterest = ATotalValueWithInterest + (soitem.qty * soitem.unitValueWithInterest);
            
            system.debug('ATotalValueWithInterest'+ATotalValueWithInterest);
            
            ATaxAmount = ATaxAmount + ((BRobj.Taxes__c/100) * soitem.qty * soitem.unitValueWithInterest) ;
            system.debug('ATaxAmount'+ATaxAmount);
            system.debug('BRobj.Taxes__c'+BRobj.Taxes__c);
            
            ATotalFreight = ATotalFreight + ((BRobj.Freight__c/100) * soitem.qty * soitem.unitValueWithInterest) ;
            system.debug('ATotalFreight'+ATotalFreight);
            System.debug('BRobj.Freight__c'+BRobj.Freight__c);
            
            if(soObj.Punctuality_Discount__c != null){
                ATotalPunctuality = ATotalPunctuality + (soObj.Punctuality_Discount__c * soitem.qty * soitem.unitValueWithInterest);
                system.debug('ATotalPunctuality'+ATotalPunctuality);
            }
            
            // decimal replacementMargin1;
            // decimal replacementMargin2;
            // system.debug('replacementMargin1'+replacementMargin1+ 'replacementMargin2'+replacementMargin2);
        }
        /*  
if(soObj.CurrencyIsoCode == 'BRL') {
totalreplcostformargin=(soitem.totalreplacementcost * exrate1);
}
*/
        system.debug('usdrate: '+usdrate);
        system.debug('ATotalValueWithInterest prev: '+ATotalValueWithInterest);
        system.debug('ATotalreplcost Prev: '+ATotalreplcost);
        //ATotalValueWithInterest = ATotalValueWithInterest / usdrate ;
        ATotalreplcost = ATotalreplcost * exrate1 ;
        system.debug('ATotalValueWithInterest aft: '+ATotalValueWithInterest);
        system.debug('ATotalreplcost aft: '+ATotalreplcost);
        
        decimal Result = ( ( ATotalValueWithInterest - ATaxAmount - ATotalFreight - ATotalPunctuality - ATotalreplcost )/(ATotalValueWithInterest- ATaxAmount - ATotalPunctuality));  
        System.debug('result'+Result);
        // return item1; 
        Result = Result * 100 ;
        return Result; 
    }
    @AuraEnabled	
    Public static decimal latestExchangeRate(){ 		//Added by Krishanu@Wipro
        ExchangeRate__c er = [select ExchangeRate__c from ExchangeRate__c order by createddate desc limit 1];
        return er.ExchangeRate__c;
    }
    
    // method added by Sagar@wipro
    @AuraEnabled
    public static string validateSAPResponse (Boolean isApproved, String recordId, String comments, string processname){
        string SAPResponse = '';
        if(processname == 'isSOCancelProcess'){
            Sales_Order__c SO = [select id,SAP_Order_Number__c, ErrorMessage__c,Order_Status__c,Error_Message__c,
                                 Order_Blocked__c,SDM_Approval_On_Order_Cancellation__c,Cancel_Comment__c,Cancellation_Reason__c
                                 from Sales_Order__c where Id =:recordId]; // Query modified by Sagar
            
            
            SalesOrderCancellationRequestWrapper request = new SalesOrderCancellationRequestWrapper();
            request.SAP_Order_Number = SO.SAP_Order_Number__c;
            request.Action = '2';
            request.Rejection_Code = SO.Cancellation_Reason__c; // Added by Sagar@Wipro for sending Rejection Code in SAP OC-001
            // request.Rejection_Code = null;
            if(!Test.isRunningTest()){
                SalesOrderCancellationResponseWrapper response = OrderBlocking.OrderBlockingAPICall(request);
                SAPResponse=response.Message_Text;
                if(response.Message_Type == 'S'){
                    customProcessApproval(isApproved,recordId,comments);
                }
            }
            return SAPResponse;
        }
        
        if(processname == 'isSOItemsEditProcess'){
            Sales_Order__c soapi = [select id, SAP_Order_Number__c,Order_Status__c from Sales_Order__c where Id=:recordId]; 
            
            List<Sales_Order_Line_Item__c> soitems =  [Select Id,Name,Item_Number__c,ProductName__c,SKU_Name__r.Brand_Name__c,Quantity__c,Unbilled_Quatity__c,Quantity_Billed__c ,DateofFAT__c,Cancel_Line_Item__c,New_Quantity__c,New_Date_of_FAT__c,Date_Of_FAT_Changed__c,Quantity_Changed__c,Cancellation_Reason__c,Item_Status__c from Sales_Order_Line_Item__c where Sale_Order__c =:recordId AND (Date_Of_FAT_Changed__c = true OR Quantity_Changed__c = true OR Cancel_Line_Item__c =true)];
            
            //BrazilOrderItemEditController.OrderItemBlockingCallout(json.serialize(soapi),json.serialize(soitems),2);
            if(!Test.isRunningTest()){
                OrderItemBlocking.OrderItemBlockingRes response = OrderItemBlocking.OrderItemBlockingAPICall1(soapi,soitems,2);
                
                SAPResponse=response.Message_Text;
                if(response.Message_Type == 'S'){
                    customProcessApproval(isApproved,recordId,comments);
                }
            }
            return SAPResponse;
        }
        return 'sucesso' ;
    }
    
    //Below method added by Sagar@wipro
    @AuraEnabled
    public static boolean isSOCancelProcessCheck (string soId){
        Boolean isSOCancelProcessFlag = false;
        Sales_Order__c so = [select id,SDM_Approval_On_Order_Cancellation__c from Sales_Order__c where id =:soId];
        if(so.SDM_Approval_On_Order_Cancellation__c  == 1 && Approval.isLocked(so.id)){
            isSOCancelProcessFlag=true; 
        }
        return isSOCancelProcessFlag;
    }
    
    //Below method added by Sagar@wipro
    @AuraEnabled
    public static boolean isSOItemsEditProcessCheck (string soId){
        Boolean isSOItemsEditProcessFlag = false;
        String userid= UserInfo.getUserId();
        Sales_Order__c so = [select id,SDM_Item_Update_Cancel_Status__c from Sales_Order__c where id =:soId];
        if(so.SDM_Item_Update_Cancel_Status__c == 'Pending' && Approval.isLocked(so.id)){
            isSOItemsEditProcessFlag=true; 
        }
        return isSOItemsEditProcessFlag;
    }
    
    
    //Approval Process Methods
    @AuraEnabled
    public static void customProcessApproval(Boolean isApproved, String recordId, String comments) { 
        List<Id> newWorkItemIds = new List<Id>();
        for (List<ProcessInstance> pis : [Select (Select Id From Workitems) From ProcessInstance p WHERE p.TargetObjectId = :recordId AND p.Status = 'Pending']) {
            for (ProcessInstance pi : pis) {
                for (List<ProcessInstanceWorkitem> wis : pi.Workitems) {
                    for (ProcessInstanceWorkitem wi : wis ) {
                        newWorkItemIds.add(wi.id);
                    }
                }           
            }
        }
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments(comments);
        if (isApproved) {
            req2.setAction('Approve');
        } else {
            req2.setAction('Reject');
        }
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        if(newWorkItemIds.size() > 0) {
            req2.setWorkitemId(newWorkItemIds.get(0));
            
            Approval.ProcessResult result2 =  Approval.process(req2);
        }
        
    }
    
}