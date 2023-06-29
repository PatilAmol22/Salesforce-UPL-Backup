/*  
* Name: ReturnOrderItalyController    
* Created On: 17 July 2019  
* Author: Ganesh Chaurasia (ganesh.chaurasia@skinternational.com)   
* Description: Lightning Component Apex Controller used for Raising orders by Sales agents/area manager/customer service for Italy. 
*/ 
public without sharing class ReturnOrderItalyController { 
    public static List<AuditHistory> beforeSort = new List<AuditHistory>();   
    public static List<AuditHistory> afterSort = new List<AuditHistory>();
    
    //Added by Varun Shrivastava : SCTASK0360650 start
    @AuraEnabled public static List<SalesOrderItem> getBlankOrderItemList(){
        List<SalesOrderItem> blankOrderItemList = new List<SalesOrderItem>();
        return blankOrderItemList;
    }
    //Added by Varun Shrivastava : SCTASK0360650 end
    
    @AuraEnabled    
    public static CartWrapper saveOrder(String accountId, String OrderItemString ,String orderObjId,Boolean ExpressOrderCheck,String orderType){ 
        CartWrapper cartObj = new CartWrapper();    
        
        try{ 
            Order__c orderObj = new Order__c();  
            system.debug('orderObjId'+orderObjId);   
            if(orderObjId!=null && orderObjId!=''){  
                orderObj.id = orderObjId; 
                orderObj.Is_Express_Delivery_Italy__c= ExpressOrderCheck; 
                upsert orderObj; 
                system.debug('orderObjId--->1'+orderObj); 
            }    
            else{    
                system.debug('orderObjId--Else--'+orderObjId);   
                orderObj.OwnerId = UserInfo.getUserId(); 
                orderObj.Bill_To_Party__c = accountId;   
                orderObj.Order_Status__c = 'Draft';  
                orderObj.CurrencyIsoCode = 'EUR';    
                orderObj.Order_Date__c = System.today(); 
                orderObj.Is_Express_Delivery_Italy__c = ExpressOrderCheck;  
                orderObj.Order_Type_Italy__c='Return Order';
                
                List<Sales_Org__c> salesOrgList = [Select ID FROM Sales_Org__c   
                                                   WHERE Sales_Org_Code__c = '2410'  
                                                   AND Country_Code__c = 'IT' LIMIT 1];  
                
                if(!salesOrgList.isEmpty()){ 
                    orderObj.Sales_Org__c = salesOrgList[0].Id;  
                }    
                insert  orderObj;    
                cartObj.cartOrderId = orderObj.Id;   
                system.debug('orderObj.Id'+orderObj.Id); 
            }    
            system.debug('OrderItemString : '+OrderItemString);
            SalesOrderItem OrderItemList1 = (SalesOrderItem)JSON.deserialize(OrderItemString, SalesOrderItem.class); 
            ReturnOrderItalyController.OrderItems(cartObj ,orderObj , OrderItemList1); 
            
        }    
        catch(Exception ex){   
            System.debug('ErrLine-->'+ex.getMessage()); 
            //If Exception occurrs or If Upsert Fails assign data to return wrapper object. 
            cartObj.errorMessage = 'Product not added to the Cart Please Contact System Administrator';    
        }  
        return cartObj; 
    }   
    
    @AuraEnabled   
    public static CartWrapper updateOrderLineItems( String orderItemListString){    
        CartWrapper updatedCart = new CartWrapper();    
        try{    
            List<SalesOrderItem> OrderItemList = (List<SalesOrderItem>)JSON.deserialize(orderItemListString, List<SalesOrderItem>.class);   
            
            List<OrderLineItem__c> oliList = new List<OrderLineItem__c>();  
            for(SalesOrderItem item: OrderItemList){    
                system.debug('item'+item);  
                OrderLineItem__c oliObj = new OrderLineItem__c();   
                oliObj.Net_Invoice_Price__c = item.netInvoicePrice; 
                oliObj.Apply_Rebate__c =  item.applyRebate; 
                
                // oliObj.Transport_contribution__c =item.TransContribution; 
                if(item.TransContribution == null){  oliObj.Transport_contribution__c = 0;   }
                else{  oliObj.Transport_contribution__c = item.TransContribution;  }   
                if(item.TransContribution2 == null){    oliObj.Transport_contribution2__c = 0;  }
                else{  oliObj.Transport_contribution2__c = item.TransContribution2;    }   
                oliObj.Quantity__c = item.qty;  
                oliObj.FinalPrice__c = item.unitValue;//    
                oliObj.Average_Final_Price__c =item.averageFinalP;  
                oliObj.Net_Price__c =item.netPrice; 
                // system.debug('item1-->'+item.oliId);  
                oliObj.Id = item.oliId; 
                try{     oliObj.Shipping_Date__c = Date.valueOf(item.shipDate);  }   
                catch(Exception ex){      oliObj.Shipping_Date__c = Date.parse(item.shipDate);     }   
                oliList.add(oliObj);    
            }   
            if(!oliList.isEmpty()){ 
                update oliList; 
            }   
        }catch(Exception ex){   
            System.debug('ErrLine-->'+ex.getMessage()); 
            updatedCart.errorMessage = System.Label.Error_While_Editing_Cart_Please_Contact_System_Administrator;   
            // ApexLog.exceptionHandler(ex, orderId, accountId);    
        }   
        return updatedCart; 
    }   
    
    
    @AuraEnabled   
    public static CartWrapper deleteOrderItems(String orderId ){    
        CartWrapper cartObj = new CartWrapper();    
        try{    
            delete[Select id from OrderLineItem__c where order__c=:orderId];  
            delete[Select id from Order__c where id=:orderId];// Added by Azhar
        }   
        catch(Exception ex){    
            System.debug('ErrLine-->'+ex.getMessage()); 
            cartObj.errorMessage = System.Label.Error_While_Deleting_Cart_Please_Contact_System_Administrator;  
            // ApexLog.exceptionHandler(ex, orderId, accountId);    
        }   
        return cartObj; 
    }   
    
    
    
    @AuraEnabled    
    public static CartWrapper deleteOItem(String oliId,String orderId,String itemsLength){
        System.debug('itemsLength :'+itemsLength);
        CartWrapper cartObj = new CartWrapper();    
        try{    
            delete[Select id from OrderLineItem__c where id=:oliId];
            if(itemsLength=='0'){// Added by Azhar
                delete[Select id from Order__c where id=:orderId]; 
            }
        }   
        catch(Exception ex){    
            System.debug('ErrLine-->'+ex.getMessage()); 
            cartObj.errorMessage = System.Label.Error_While_Deleting_Item_Please_Contact_System_Administrator;  
            // ApexLog.exceptionHandler(ex, orderId, accountId);    
        }   
        return cartObj; 
    }   
    
    
    
    @AuraEnabled    
    public static void OrderItems(CartWrapper cartObj2 ,Order__c orderObj2, SalesOrderItem OrderItemString){
        List<OrderLineItem__c> oliList = new List<OrderLineItem__c>();   
        system.debug('soli'+orderObj2);     
        OrderLineItem__c oliObj = new OrderLineItem__c();   
        oliObj.Order__c = orderObj2.Id; 
        oliObj.SKU_Name__c = OrderItemString.productId; 
        oliObj.UOM__c =OrderItemString.UOM; 
        oliObj.Price__c =OrderItemString.materialPrice; 
        oliObj.Discount__c = OrderItemString.standardRebate;    
        oliObj.Discount2__c = OrderItemString.standardRebate2;  
        oliObj.Net_Invoice_Price__c = OrderItemString.netInvoicePrice;  
        try{    
            oliObj.Shipping_Date__c = Date.valueOf(OrderItemString.shipDate);  
        }   
        catch(Exception ex){    
            system.debug('catch'+ex.getMessage());  
            oliObj.Shipping_Date__c = Date.parse(OrderItemString.shipDate);     
        }   
        oliObj.pallet_Size_Italy__c = OrderItemString.palletSize;   
        oliObj.Average_Final_Price__c =OrderItemString.averageFinalP;   
        oliObj.multipleOf__c =OrderItemString.multipleOf;   
        oliObj.Apply_Rebate__c =  OrderItemString.applyRebate;  
        oliObj.Transport_contribution__c =OrderItemString.TransContribution;    
        system.debug('oliObj.Transport_contribution__c'+oliObj.Transport_contribution__c);  
        if(OrderItemString.TransContribution2 == null){ 
            oliObj.Transport_contribution2__c = 0;  
        }else{  
            oliObj.Transport_contribution2__c = OrderItemString.TransContribution2; 
        }   
        system.debug('orderObj2.CurrencyIsoCode'+orderObj2.CurrencyIsoCode);    
        oliObj.CurrencyIsoCode ='EUR';  
        oliObj.Quantity__c = OrderItemString.qty;   
        oliObj.FinalPrice__c = OrderItemString.unitValue;   
        oliObj.FinalPrice2__c = OrderItemString.unitValue2; 
        oliObj.Product_Type_Italy__c = OrderItemString.typeOfProduct;   
        oliObj.Net_Price__c =OrderItemString.netPrice;  
        oliObj.Inventory_order_Flag_Color_Italy__c=OrderItemString.flagImage;
        if(OrderItemString.flagImageDisc!=null){
            oliObj.Inventory_Description_Italy__c=OrderItemString.flagImageDisc;
        }
        if(OrderItemString.accrualDiscount!=null){
            oliObj.Accrual_Discount__c=OrderItemString.accrualDiscount;
        }else{
            oliObj.Accrual_Discount__c=null;
        }
        /*if(OrderItemString.VenditaOmaggioPosition!=null){
oliObj.Vendita_Omaggio_Position_Italy__c=OrderItemString.VenditaOmaggioPosition;
}*/
        oliObj.Comment__c=OrderItemString.personalNotes;// CR110
        oliList.add(oliObj);  
        system.debug('oliList : '+oliList); 
        if(!oliList.isEmpty()){  
            insert oliList; 
            OrderItemString.oliId = oliList[0].Id;  
            cartObj2.soitemObj =OrderItemString;    
            system.debug('OrderItemString.oliId'+OrderItemString.oliId);    
        }   
    }   
    
    @AuraEnabled    
    public static OrderWrapper saveSalesOrder(Sales_Order__c soObj, String salesOrderItemString) {  
        
        System.debug('Sales Order: '+soObj);    
        //Initialize Return Order Wrapper.  
        OrderWrapper owObj = new OrderWrapper();    
        String ProfileName = '';    
        String LoggedInUser =''; 
        ///Guduli
        String SoldToParty='';
        //
        try{    
            //If Owner Id is blank or None set Owner Id to Logged In User
            //Guduli
           /* system.debug('@@@@@@@@soObj-->'+soObj);
             system.debug('@@@@@@@@soObj Sold_to_Party__c-->'+soObj.Sold_to_Party__c);
            SoldToParty=soObj.Sold_to_Party__c;
            Account acc =[SELECT id,name,OwnerId from Account where id=:SoldToParty];
            system.debug('@@@@@@@@acc.Owner-->'+acc.OwnerId);
            soObj.OwnerId =acc.OwnerId;*/
            
            //Guduli
            if(!Test.isRunningTest())
            {
            SoldToParty=soObj.Sold_to_Party__c;
            Account acc =[Select Id,Territory_Distributor__r.TerritoryManager__c ,OwnerId  from Account Where Territory_Distributor__r.TerritoryManagerActive__c=True AND id=:SoldToParty];
            system.debug('@@@@@@@@acc.Owner-->'+acc.OwnerId);
            soObj.OwnerId =acc.Territory_Distributor__r.TerritoryManager__c ;
            }
            if(Test.isRunningTest())
            {
              soObj.OwnerId = UserInfo.getUserId();
            }
            LoggedInUser = UserInfo.getUserId();    
            //  system.debug('soObj.Order_Status__c'+soObj.Order_Status__c+''+soObj); 
            User userObj =   [Select Id, Profile.Name, Show_List_Value__c,Show_Min_Price__c,Show_Max_Price__c,Show_Floor_Price__c, IsActive, ContactId,UserRole.name,   
                              Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,   
                              Show_Inventory_Column__c, ManagerId,Show_InTransit__c, Show_InTransit_Values__c,HO__c, Country_Head__c, Marketing_Manager__c   
                              FROM User  
                              WHERE Id =:LoggedInUser    
                              AND IsActive = True];  
            
            User userObj1 = [Select Id, Profile.Name FROM User WHERE Id =:LoggedInUser AND IsActive = True];    
            
            User userObj2 = [Select Id, Profile.Name, Marketing_Manager__c,ManagerId, Country_Head__c FROM User WHERE Id =:soObj.OwnerId AND IsActive = True];  
            
            system.debug('soObj.OwnerId'+soObj.OwnerId +'Profile'+userObj.Profile.Name);    
            if(userObj!=null && userObj.Profile.Name!='Customer Service & Finance Manager Italy'){  
                ProfileName =userObj.Profile.Name;  
                //assigning Commercial Manager  
                if(String.isNotBlank(userObj.Marketing_Manager__c)){    
                    soObj.Sales_Director_Mexico__c = userObj.Marketing_Manager__c;  
                }   
                //assigning Country Manager 
                if(String.isNotBlank(userObj.Country_Head__c)){ 
                    soObj.Latam_Director_Mexico__c = userObj.Country_Head__c;   
                }   
            }else if( userObj.Profile.Name=='Customer Service & Finance Manager Italy'){    
                if(String.isNotBlank(userObj2.Marketing_Manager__c)){  
                    soObj.Sales_Director_Mexico__c = userObj2.Marketing_Manager__c; 
                }   
                //assigning Country Manager 
                if(String.isNotBlank(userObj2.Country_Head__c)){    
                    soObj.Latam_Director_Mexico__c = userObj2.Country_Head__c;  
                }   
            }   
            
            if(userObj1!=null){ 
                if(userObj1.Profile.Name=='Sales Agents Italy' || userObj1.Profile.Name=='Customer Service & Finance Manager Italy' ){  
                    soObj.Order_Raise_By__c ='Sales Agent'; 
                }else if(userObj1.Profile.Name=='Area Manager Italy' || userObj1.Profile.Name=='Marketing Responsible/Logistics Responsible Italy'){    
                    soObj.Order_Raise_By__c ='Area Manager';    
                }   
            }   
            
            List<Sales_Org__c> salesOrgList = [Select ID FROM Sales_Org__c  
                                               WHERE Sales_Org_Code__c = '2410'     
                                               AND Country_Code__c = 'IT' LIMIT 1]; 
            
            if(!salesOrgList.isEmpty()){    
                soObj.Sales_Org_lk__c = salesOrgList[0].Id; 
            }  
            System.debug('soObj.Order_Type_Italy__c :'+soObj.Order_Type_Italy__c);
            
            soObj.Order_Type_lk__c = [Select Id,SalesOrg__c FROM Order_Type__c WHERE Order_Type_Code__c='ZIR1' AND SalesOrg__r.Sales_Org_Code__c='2410' limit 1].Id;
            soObj.CurrencyIsoCode = 'EUR'; 
            soObj.Order_Date__c = System.today();  
            soObj.CreatedFrom__c = 'SFDC'; 
            
            
            //Logic to query if the record Id is not a rollback record as the Id for rollback record will be invalidated    
            List<Sales_Order__c> salesOrderList = [Select Id, Name FROM Sales_Order__c WHERE Id=:soObj.Id]; 
            if(salesOrderList.isEmpty()){   
                //After rollback the ID remains in the record, make it null & upsert    
                soObj.Id = null;    
            } 
            upsert soObj;   
            
            //Change Added   
            //desc:creating share object for cross role hierarchy    
            //Date:13/1/2020 
            system.debug('userObj2.ManagerId--'+userObj2.ManagerId+'soObj.Manager__c---'+soObj.Manager__c+'soObj.Id'+soObj.Id); 
            //Divya Singh: 28/12/2020: Added Sales Agents Italy profile for SCTASK0340013
            if( userObj.Profile.Name=='Customer Service & Finance Manager Italy' ||userObj.Profile.Name=='Sales Agents Italy' || userObj.Profile.Name=='Area Manager Italy'){  
                //Moumita: Added ownerid!=Createdbyid condition.
                if((userObj2.ManagerId!=soObj.Manager__c) || ((soObj.OwnerId!= soObj.CreatedById) && (userObj2.ManagerId!=soObj.Manager__c))){  
                    Sales_Order__Share soShare = new Sales_Order__Share();  
                    soShare.ParentId = soObj.Id;    
                    soShare.UserOrGroupId =soObj.Manager__c;    
                    soShare.AccessLevel = 'read';   
                    Database.SaveResult soShareResult = Database.insert(soShare,false); 
                    system.debug('soShareResult'+soShareResult);    
                }   
            }   
            //Change End    
            //check if user insert PO number    
            List<Sales_Order__c> salesOrderObj = [Select Id, Name,PONumber__c FROM Sales_Order__c WHERE Id=:soObj.Id LIMIT 1];
            system.debug('salesOrderObj :'+salesOrderObj); 
            if(!salesOrderObj.isEmpty()){   
                if(salesOrderObj[0].PONumber__c==null){ 
                    system.debug('salesOrderObj[0].PONumber__c :'+salesOrderObj[0].PONumber__c);
                    salesOrderObj[0].PONumber__c =salesOrderObj[0].Name;    
                    update salesOrderObj;   
                    system.debug('salesOrderObj :'+salesOrderObj);
                }   
            }   
            
            
            
            List<SalesOrderItem> salesOrderItemList = (List<SalesOrderItem>)JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class); 
            System.debug('salesOrderItemList: '+salesOrderItemList);    
            //System.debug('salesOrderItemList.size: '+salesOrderItemList.size());  
            String OrderLineId =salesOrderItemList[0].oliId;    
            String pricegroupCode =salesOrderItemList[0].pgCode;    
            String customerWiseCode =salesOrderItemList[0].customerCode;    
            
            if(OrderLineId!=null && OrderLineId!=''){   
                if(!Test.isRunningTest()){
                    Order__c orderObj = new Order__c(); 
                    String orderId =[select Id,Order__c from OrderLineItem__c where Id =:OrderLineId Limit 1].Order__c; 
                    system.debug('orderId'+orderId);    
                    orderObj.id =orderId;   
                    orderObj.Order_Status__c ='Approved';   
                    update orderObj;  
                }
                
            }   
            owObj.soiList = ReturnOrderItalyController.saveOrderItems(soObj, salesOrderItemList, salesOrgList,pricegroupCode,customerWiseCode );  
            owObj.soObj = ReturnOrderItalyController.getSalesOrder(soObj.Id);
            owObj.sfdcOrderNo = [Select Id, Name FROM Sales_Order__c WHERE Id=:soObj.Id].Name;
            owObj.sapOrderNo = soObj.SAP_Order_Number__c;
            owObj.orderTypeItaly = soObj.Order_Type_Italy__c;
            system.debug('owObj'+owObj);    
            
            if(soObj.Order_Status__c!='Draft'){// Added by Azhar
                /*if(soObj.DirectApproved__c== true){ 
                    if(soObj.is_Different_Free_Product__c==true || soObj.Check_Transport_contribution__c== true || soObj.Is_Payment_Term_Discount_Approval_Italy__c ==true ){   
                        soObj.Order_Status__c = 'Pending';  
                        update soObj;   
                    }else{  
                        soObj.Order_Status__c = 'Open'; 
                        update soObj;   
                    }   
                }else{  
                    
                    if(soObj.Order_Status__c == 'Submitted' && (owObj.soObj.Sent_for_Manager_Approval_Mexico__c || owObj.soObj.Sent_for_Director_Approval_Mexico__c || owObj.soObj.Sent_for_Latam_Director_Approval__c || owObj.soObj.Check_Transport_contribution__c||owObj.soObj.Is_Payment_Term_Discount_Approval_Italy__c||owObj.soObj.is_Different_Free_Product__c)){    
                        soObj.Order_Status__c = 'Pending';  
                        soObj.Colombia_Order_Submitted_for_Approval__c = false; 
                        update soObj;   
                    }else   
                        if(!owObj.soObj.Sent_for_Manager_Approval_Mexico__c && !owObj.soObj.Sent_for_Director_Approval_Mexico__c && !owObj.soObj.Sent_for_Latam_Director_Approval__c && soObj.Order_Status__c == 'Submitted' && !owObj.soObj.Is_Payment_Term_Discount_Approval_Italy__c){   
                            soObj.Order_Status__c = 'Open'; 
                            update soObj;   
                            system.debug('soObj---->'+soObj);   
                        }   
                }*/
            }
            soObj.Italy_Return_Order_Level_1_Approver__c = [SELECT Id FROM User 
                                                            WHERE UGDN_Number__c =:UPL_Settings__c.getInstance().Return_Order_Level1_Approver_UGDN__c LIMIT 1].Id;
            soObj.Order_Status__c='Pending';
            update soObj;
            owObj.soObj.ErrorMessage__c = '';   
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
            ApexLog.exceptionHandlerItaly(ex, soObj.Sold_to_Party__c, soObj, salesOrderItemString); 
        }  
        return owObj;   
    }   
    
    @AuraEnabled  
    public static void saveSalesOrderPFD(ID recordId) { 
        system.debug('recordId'+recordId);  
        GeneratePDFForItaly.ProcessSalesorderForItaly(recordId);    
    }   
    
    
    //Reload existing Sales Order with given recordID  
    @AuraEnabled    
    public static Sales_Order__c getSalesOrder(ID soId) {   
        //Make sure to add new fields that are being input from the UI to this SOQL query otherwise the data will not be inserted.  
        List<Sales_Order__c> soList = [SELECT Id, Name, SAP_Order_Number__c, Order_Status__c,Italy_Return_Order_Level_1_Approver__c,Total_Amount__c,Order_Raise_By__c,PONumber__c,DirectApproved__c,   
                                       Sold_to_Party__r.Tax_Number_1__c,Ship_To_Party__r.City__c,Payment_Term__r.Payment_Term__c,Ship_To_Party__r.Name,Is_Fixed_Rate_Available_Italy__c,    
                                       Sold_to_Party__r.Name, Sold_to_Party__c, ReloadPaymentTerms__c, OrderSubStatus__c,Ship_To_Party__r.Location_Name__c, 
                                       Sold_to_Party__r.Tax_Number_3__c, Depot_Code__c,Sent_for_Manager_Approval_Mexico__c,Is_Order_FCA_Italy__c,Is_Express_Delivery_Italy__c,  
                                       Sold_to_Party__r.SAP_Code__c,Ship_To_Party__c,Remarks_Long__c,Check_Transport_contribution__c,Order_FCA_Italy__c,    
                                       Sold_to_Party__r.Customer_Group__c,Sent_for_Latam_Director_Approval__c,Editable_Payment_Term_Discount__c,    
                                       Sold_to_Party__r.BillingCity,CreatedById, OwnerId, Owner.Name,CurrencyIsoCode,Sent_for_Director_Approval_Mexico__c,  
                                       Sold_to_Party__r.BillingState,Payment_Term_Discount_Italy__c,Is_Payment_Term_Discount_Approval_Italy__c, Order_Type_Italy__c,Valid_From__c,Valid_To__c,
                                       Payment_Term__c, Sold_to_Party__r.Depot_Code__c,Normal_Delivery_Cost__c,Express_Delivery_Cost__c, 
                                       Sold_to_Party__r.Customer_Region__c,is_Different_Free_Product__c, 
                                       RecordType.Name, SalesOrgCode__c,Sales_Order__r.Name,Parent_SAP_Order_Number__c,Order_Type_Code__c     
                                       FROM Sales_Order__c  
                                       WHERE Id =: soId AND Order_Type_Italy__c='Return Order'];   
        
        return soList[0];   
    }   
    
    @AuraEnabled   
    public static Sales_Order__c getSalesSTP(ID soId) { 
        List<Sales_Order__c> soList = [SELECT Id,Sold_to_Party__c   
                                       FROM Sales_Order__c  
                                       WHERE Id =: soId];   
        
        return soList[0];   
    }   
    
    
    //Method to save Order Line Items from the wrapper against the Sales Order  
    @AuraEnabled    
    public static List<SalesOrderItem> saveOrderItems(Sales_Order__c soObj2, List<SalesOrderItem> salesOrderItemList, List<Sales_Org__c> salesOrgList ,String pricegroupCode ,String customerWiseCode){ 
        List<Inco_Term__c> incoList = new List<Inco_Term__c>(); 
        String depotCodeId= ''; 
        String incoTermId ='';  
        Boolean sentForManager = false; 
        Boolean sentForDirector = false;    
        Boolean sentForLatam = false;   
        Boolean customizePB =false; 
        Boolean isFinalPriceChanged = false;    
        Boolean isFCA = false;  
        Boolean belowLimit = false; 
        Boolean isAvgFinalPriceSame =false;
        Decimal totalQty=0; 
        
        //Patch Added   
        for(SalesOrderItem item: salesOrderItemList){   
            totalQty=totalQty+item.qty; 
        }   
        if(totalQty<100){   
            belowLimit = true;  
        }   
        //Patch End 
        
        System.debug('pricegroupCode :'+pricegroupCode);
        System.debug('customerWiseCode :'+customerWiseCode);
        if((pricegroupCode!=null && pricegroupCode!='') || (customerWiseCode!=null && customerWiseCode!='')){   
            customizePB =true;  
        }   
        
        depotCodeId = [Select Id,Name ,Depot__c,SalesOrg__r.sales_org_code__c From Depot__c where Depot_Code__c ='IT00' LIMIT 1].Id;    
        incoList =  [Select Id,Name ,Sales_Org__r.sales_org_code__c From Inco_Term__c where IncoTerm_Code__c ='FCA' AND Sales_Org__r.sales_org_code__c='2410' LIMIT 1]; 
        
        if(incoList.size()>0){ 
            incoTermId  = incoList[0].Id;    
        }  
        
        Map<Id,SKU__c> SKUMap = new Map<Id,SKU__c>();  
        for(SKU__c skuObj: [SELECT Id, Sales_Agent_MSP__c, Area_Manager_MSP__c, Sales_Director_MSP__c  
                            FROM SKU__c     
                            WHERE Sales_Org_Code__c ='2410' 
                            AND Distribution_Channel__r.Distribution_Channel_Code__c ='20'  
                            AND Active__c = True]){ 
                                
                                SKUMap.put(skuObj.Id, skuObj);                                            
                            }   
        
        //For Item Number maintenance on Order reload, while saving items delete & re-insert all line items.    
        delete [SELECT Id FROM Sales_Order_Line_Item__c WHERE Sale_Order__c=:soObj2.Id];    
        
        
        
        List<Sales_Order_Line_Item__c> soiList = new List<Sales_Order_Line_Item__c>();  
        
        Integer i = 0;  
        Integer j= 0;
        Integer k = 0;// Using for maintaining Sequence number
        
        System.debug('soObj2 data :'+soObj2);
        
        if(soObj2.Order_Type_Italy__c==null){
            soObj2.Order_Type_Italy__c='Return Order';
        }
        
        for(SalesOrderItem item: salesOrderItemList){   
            
            Sales_Order_Line_Item__c soiObj = new Sales_Order_Line_Item__c(); 
            if((item.qty!=0 && item.typeOfProduct=='Vendita') || (item.qty!=0 && item.typeOfProduct=='Omaggio')){
                
                k = k+1;
                i = i+10;   
                if(item.typeOfProduct=='Vendita'){  
                    j = i;  
                }   
                soiObj.Item_Number__c = i;  
                soiObj.Sale_Order__c = soObj2.Id;   
                soiObj.SKU_Name__c = item.productId;    
                soiObj.CurrencyIsoCode = soObj2.CurrencyIsoCode;    
                soiObj.Rebate__c = item.standardRebate; 
                //Added by Azhar
                System.debug('k :'+k);
                
                soiObj.Inventory_order_flag_color_Italy__c=item.flagImage;
                if(item.flagImageDisc!=null){
                    String imageDe= item.flagImageDisc.replace('\r\n', ' ');
                    soiObj.Inventory_Description_Italy__c=imageDe;
                }
                soiObj.Comment__c=item.personalNotes; // CR110
                if(item.accrualDiscount!=null){
                    soiObj.Accrual_Discount__c=item.accrualDiscount;
                }
                //EOC//
                if(item.standardRebate2!=null){  
                    soiObj.Rebate_2__c = item.standardRebate2;  
                }    
                soiObj.UOM__c = item.UOM;   
                soiObj.Quantity__c = item.qty;  
                soiObj.Product_Type_Italy__c = item.typeOfProduct;  
                soiObj.Price__c = item.materialPrice; //label :"Value" in soli  
                soiObj.Net_Invoice_Price__c = item.netInvoicePrice; 
                soiObj.pallet_Size_Italy__c = item.palletSize;  
                soiObj.Apply_Rebate__c =  item.applyRebate; 
                soiObj.multipleOf__c =item.multipleOf;
                soiObj.Transport_contribution__c = 0;
                soiObj.Transport_contribution2__c = 0;
                soiObj.Net_Price__c =item.netPrice; 
                
                if(SKUMap.containsKey(item.productId)){ 
                    SKU__c skuObj1  = SKUMap.get(item.productId);   
                    soiObj.Country_Head_Price__c = skuObj1.Sales_Director_MSP__c;   
                    soiObj.Director_Price__c = skuObj1.Area_Manager_MSP__c; 
                    soiObj.Manager_Price__c = skuObj1.Sales_Agent_MSP__c;   
                }   
                try{    
                    soiObj.Shipping_Date__c = Date.valueOf(item.shipDate);  
                }   
                catch(Exception ex){    
                    system.debug('catch'+ex.getMessage());  
                    soiObj.Shipping_Date__c = Date.parse(item.shipDate);    
                }   
                if(item.typeOfProduct=='Vendita'){  
                    soiObj.Average_Final_Price__c = item.averageFinalP; 
                    soiObj.FinalPrice__c = item.unitValue;  
                    if(item.unitValue2!=null){  
                        soiObj.FinalPrice2__c = item.unitValue2;    
                    }  
                }   
                if(!salesOrgList.isEmpty()){    
                    soiObj.Sales_Org__c = salesOrgList[0].Id;   
                }   
                if(depotCodeId!=null && depotCodeId!=''){   
                    soiObj.DepotDepot__c = depotCodeId; 
                } 
                
                if(pricegroupCode!=null && pricegroupCode!=''){
                    soiObj.PriceBookMaster__c=item.pricebookId;
                }
                if(customerWiseCode!=null && customerWiseCode!=''){
                    soiObj.PriceBookMaster__c=item.pricebookId;
                }
                soiList.add(soiObj); 
            }
        }   
        if(isFCA){  
            soObj2.Inco_Term__c =incoTermId;   
        }   
        /*  if(((pricegroupCode==null || customerWiseCode=='') || (soObj2.Payment_Term_Discount_Italy__c!= soObj2.Editable_Payment_Term_Discount__c)) && soObj2.Editable_Payment_Term_Discount__c > 5){   
soObj2.Is_Payment_Term_Discount_Approval_Italy__c = true;   
}*/ 
        if(soObj2.Order_Status__c!='Draft'){
            system.debug('pricegroupCode'+pricegroupCode+'soObj2'+soObj2);  
            //if((pricegroupCode==null || pricegroupCode=='') &&((soObj2.Payment_Term_Discount_Italy__c!= soObj2.Editable_Payment_Term_Discount__c) &&(soObj2.Editable_Payment_Term_Discount__c > 5))){   
            if(soObj2.Payment_Term_Discount_Italy__c!= soObj2.Editable_Payment_Term_Discount__c && soObj2.Editable_Payment_Term_Discount__c > 5){    
                soObj2.Is_Payment_Term_Discount_Approval_Italy__c = true;   
            }   
            
            // Code commented for approvals will on everon 19-09-2020
            /*if(customizePB && isFinalPriceChanged == false){  
System.debug('is direct approved');
soObj2.DirectApproved__c =true; 
} 

else{  */
            
            if(isFinalPriceChanged == false && isAvgFinalPriceSame == true){
                System.debug('is direct approved');
                soObj2.DirectApproved__c =true; 
            } else{
                System.debug('sentForLatam :'+sentForLatam);
                System.debug('sentForDirector :'+sentForDirector);
                System.debug('sentForManager :'+sentForManager);
                if(sentForLatam){   
                    soObj2.Sent_for_Latam_Director_Approval__c =true;   
                }
                if(sentForDirector){  
                    soObj2.Sent_for_Director_Approval_Mexico__c= true;  
                }
                if(sentForManager){   
                    soObj2.Sent_for_Manager_Approval_Mexico__c =true;   
                } 
            }
        }
        soObj2.Sent_for_Latam_Director_Approval__c =true;
        soObj2.Sent_for_Director_Approval_Mexico__c= true;
        soObj2.Sent_for_Manager_Approval_Mexico__c =true;
        System.debug('soObj2 :'+soObj2);
        if(!soiList.isEmpty()){ 
            insert soiList; 
            update soObj2;  
        }   
        return getSalesOrderItems(soObj2.Id);   
    }   
    
    @AuraEnabled    
    public static CartWrapper getCartOrderItems(ID accId) { 
        Order__c ordObj =new Order__c();    
        
        // Map<Id,Decimal> pBDiscountMap1 = ReturnOrderItalyController.getPbDiscount(); 
        // Map<Id,Decimal> MPMap = ReturnOrderItalyController.getMaterialPriceMap();    
        String orderId =''; 
        Boolean isChange =false;    
        
        CartWrapper cartObj = new CartWrapper();    
        
        List<Order__c> recentOrderList =  [SELECT Id, Name, Bill_To_Party__c, Order_Date__c,Is_Express_Delivery_Italy__c,   
                                           Order_Status__c, OwnerId,Gross_Net__c, Order_Type_Italy__c    
                                           FROM Order__c WHERE Order_Status__c='Draft'  
                                           AND Bill_To_Party__c =: accId AND Order_Type_Italy__c='Return Order' Order By CreatedDate DESC LIMIT 1];    
        
        if(!recentOrderList.isEmpty()){ 
            ordObj = recentOrderList[0];    
            system.debug('ordObj'+ordObj);  
            orderId = ordObj.Id;    
            cartObj.grossNetPrice =recentOrderList[0].Gross_Net__c; 
            cartObj.isExpressDelivery = recentOrderList[0].Is_Express_Delivery_Italy__c; 
            cartObj.orderTypeItaly = recentOrderList[0].Order_Type_Italy__c; 
        }   
        
        List<OrderLineItem__c> oliList = [SELECT Id, Name, CurrencyIsoCode, SKU_Name__r.SKU_Description__c,Discount__c,multipleOf__c,Net_Invoice_Price__c,Transport_contribution2__c,  
                                          Order__c, UOM__c, SKU_Name__c,Net_Price__c,FinalPrice__c,Product_Type_Italy__c,pallet_Size_Italy__c,Shipping_Date__c, 
                                          SKU_Name__r.Name, Quantity__c, Price__c,Apply_Rebate__c,Transport_contribution__c,    
                                          FinalPrice2__c,Discount2__c,Average_Final_Price__c,Accrual_Discount__c,
                                          Inventory_order_Flag_Color_Italy__c,Inventory_Description_Italy__c,Comment__c     
                                          FROM OrderLineItem__c 
                                          WHERE Order__c=:orderId Order By CreatedDate]; 
        
        List<SalesOrderItem> itemList = new List<SalesOrderItem>();   
        system.debug('oliList: '+oliList);
        for(OrderLineItem__c oliObj: oliList){   
            SalesOrderItem item = new SalesOrderItem(); 
            item.productId = oliObj.SKU_Name__c;    
            item.productName = oliObj.SKU_Name__r.SKU_Description__c;   
            item.unitValue = oliObj.FinalPrice__c;//estimated final price   
            // item.averageFinalP = oliObj.FinalPrice__c;    
            item.qty = oliObj.Quantity__c;  
            item.materialPrice = oliObj.Price__c; //material price  
            item.UOM = oliObj.UOM__c;   
            item.standardRebate = oliObj.Discount__c;   
            item.netInvoicePrice = oliObj.Net_Invoice_Price__c; 
            item.palletSize = oliObj.pallet_Size_Italy__c;  
            item.multipleOf = oliObj.multipleOf__c; 
            item.applyRebate = oliObj.Apply_Rebate__c;      
            item.averageFinalP = oliObj.Average_Final_Price__c; 
            item.unitValue2 = oliObj.FinalPrice2__c ;   
            item.standardRebate2 = oliObj.Discount2__c ;    
            item.TransContribution = oliObj.Transport_contribution__c;  
            item.TransContribution2 = oliObj.Transport_contribution2__c;    
            item.shipDate = String.valueOf(oliObj.Shipping_Date__c);    
            item.typeOfProduct = oliObj.Product_Type_Italy__c;  
            item.netPrice = oliObj.Net_Price__c ;   
            item.oliId =oliObj.Id;
            item.flagImage=oliObj.Inventory_order_Flag_Color_Italy__c;// Added by Azhar
            if(oliObj.Inventory_Description_Italy__c!=null){
                item.flagImageDisc=oliObj.Inventory_Description_Italy__c.replaceAll('\r\n|\n|\r','\n');// Added by Azhar
            }
            if(oliObj.Accrual_Discount__c!=null){
                item.accrualDiscount=oliObj.Accrual_Discount__c;
            }else{
                item.accrualDiscount=null;
            }
            item.personalNotes=oliObj.Comment__c;//  CR110 : Added by Azhar Shaikh 11-05-2020
            itemList.add(item); 
        }  
        system.debug('itemList'+itemList);   
        cartObj.cartOrderId =orderId;   
        cartObj.soiList = itemList; 
        return cartObj; 
    }   
    
    //Reload existing Sales Order Line Items with given Sales Order ID     
    @AuraEnabled    
    public static List<SalesOrderItem> getSalesOrderItems(ID soId) {
        
        List<Sales_Order_Line_Item__c> salesOrderItemList = [SELECT ID, Sale_Order__c,Sequence_Number__c, SKU_Name__c,Apply_Rebate__c,multipleOf__c, Discount__c,MinPrice__c,MinValue__c,UOM__c,Transport_contribution2__c,    
                                                             SKU_Name__r.SKU_Description__c,Item_Number__c,Quantity__c,Price__c,FinalPrice__c,pallet_Size_Italy__c,Transport_contribution__c,   
                                                             CurrencyIsoCode, Sales_Org__c,Net_Price__c,FinalPrice2__c,Rebate__c,Net_Invoice_Price__c,  
                                                             UnitValue__c,Product_Type_Italy__c,Unit_Price__c,Rebate_2__c,Shipping_Date__c,Average_Final_Price__c,
                                                             Inventory_order_Flag_Color_Italy__c,Inventory_Description_Italy__c,Comment__c,Accrual_Discount__c, 
                                                             SKU_Name__r.Name,is_Different_Free_Product__c,PriceBookMaster__c, PriceBookMaster__r.DistributorCustomerCode__c,PriceBookMaster__r.PG_CODE__c
                                                             FROM Sales_Order_Line_Item__c  
                                                             WHERE Sale_Order__c=:soId Order By CreatedDate];   
        
        List<SalesOrderItem> itemList = new List<SalesOrderItem>(); 
        System.debug('salesOrderItemList'+salesOrderItemList); 
        
        for(Sales_Order_Line_Item__c soiObj: salesOrderItemList){   
            SalesOrderItem item = new SalesOrderItem(); 
            item.balanceQtyStr=String.valueOf(item.balanceQty);
            item.productId = soiObj.SKU_Name__c;    
            item.productName = soiObj.SKU_Name__r.SKU_Description__c;   
            item.qty = soiObj.Quantity__c;  
            item.UOM = soiObj.UOM__c;   
            item.typeOfProduct = soiObj.Product_Type_Italy__c;  
            item.materialPrice = soiObj.Price__c;   
            item.itemNo = soiObj.Item_Number__c;    
            item.standardRebate = soiObj.Rebate__c; 
            item.multipleOf = soiObj.multipleOf__c; 
            
            item.netInvoicePrice = soiObj.Net_Invoice_Price__c; 
            item.palletSize = soiObj.pallet_Size_Italy__c;  
            item.applyRebate =soiObj.Apply_Rebate__c;   
            item.TransContribution = soiObj.Transport_contribution__c;  
            item.TransContribution2 = soiObj.Transport_contribution2__c;    
            item.netPrice = soiObj.Net_Price__c;    
            item.flagImage=soiObj.Inventory_order_Flag_Color_Italy__c;// Added by Azhar
            if(soiObj.Inventory_Description_Italy__c!=null){
                item.flagImageDisc=soiObj.Inventory_Description_Italy__c.replaceAll('\r\n|\n|\r','\n');// Added by Azhar
            }
            if(soiObj.Accrual_Discount__c!=null){//Added by Azhar
                item.accrualDiscount=soiObj.Accrual_Discount__c;
            }else{
                item.accrualDiscount=null;
            }
            item.personalNotes=soiObj.Comment__c;//  CR110 : Added by Azhar Shaikh 11-05-2020
            if(soiObj.Rebate_2__c!=null){   
                item.standardRebate2 = soiObj.Rebate_2__c;  
            }   
            item.shipDate = String.valueOf(soiObj.Shipping_Date__c);    
            item.isDiffProduct = soiObj.is_Different_Free_Product__c;     
            if(soiObj.Product_Type_Italy__c=='Vendita'){    
                item.averageFinalP = soiObj.Average_Final_Price__c; 
                if(soiObj.FinalPrice2__c!=null){    
                    item.unitValue2 =soiObj.FinalPrice2__c; 
                }   
                item.unitValue = soiObj.FinalPrice__c;  
            }else if(soiObj.Product_Type_Italy__c=='Omaggio'){  
                item.averageFinalP = 0;    
                item.unitValue = 0;    
                item.unitValue2 = 0;   
            } 
            if(soiObj.PriceBookMaster__r.DistributorCustomerCode__c!=null){
                item.customerCode=soiObj.PriceBookMaster__r.DistributorCustomerCode__c;
                item.pricebookId=soiObj.PriceBookMaster__c;
            }
            if(soiObj.PriceBookMaster__r.PG_CODE__c!=null){
                item.pgCode=soiObj.PriceBookMaster__r.PG_CODE__c;
                item.pricebookId=soiObj.PriceBookMaster__c;
            }
            itemList.add(item); 
        }           
        System.debug('itemList: '+itemList);    
        return itemList;    
    }   
    
    @AuraEnabled    
    public static OrderFields getOrderFields(String accId){ 
        String recordId = accId;    
        OrderFields ofObj = new OrderFields();  
        ofObj.DistributorData = ReturnOrderItalyController.fetchDistributorDetails(recordId); 
        ofObj.ShippingLocMap = ReturnOrderItalyController.getShippingLoations(recordId);  
        system.debug(' ofObj.DistributorData.priceGroupId'+ofObj.DistributorData.priceGroupId); 
        ofObj.PaymentTermMap = ReturnOrderItalyController.getPaymentTermMap(ofObj.DistributorData.priceGroupId);  
        ofObj.PaymentTermCustomerMap = ReturnOrderItalyController.getPaymentTermCustomerMap(recordId);    
        ofObj.PaymentTermMap1 = ReturnOrderItalyController.getPaymentTermMap1();  
        ofObj.productTypesList = ReturnOrderItalyController.getProductTypes();    
        ofObj.TransContributionParam = ReturnOrderItalyController.getTransContriDetails();    
        ofObj.userObj = [Select Id, Profile.Name, Show_List_Value__c FROM User WHERE Id=:UserInfo.getUserId()]; 
        return ofObj;   
    }   
    
    @AuraEnabled    
    public static DistributorWrapper fetchDistributorDetails(String recordId){  
        
        String  Payment_Terms = ''; 
        List<Payment_Term__c> paymentTermList = new List<Payment_Term__c>();    
        List<Account> accList = [SELECT Id, Name, BillingCity,Payment_Term_Code__C, BillingCountry, RegionalManager__c,Normal_Delivery_Cost_Italy__c,Express_Delivery_Cost_Italy__c,    
                                 BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, Sales_Org__r.Name,Is_Fixed_Rate_Available_Italy__c,Is_Special_Rate_Available__c,Billing_Street_6__c,  
                                 OwnerId, SAP_Code__c, Sales_Org__c, Distribution_Channel__c, Division__c,Region__r.RegionHead__c,Billing_Street_4__c,Billing_Street_5__c,  
                                 Order_Type__c, Order_Block__c,Sales_Org_Code__c, Status__c,Payment_Terms__c,Billing_Street_1__c,Billing_Street_2__c,Billing_Street_3__c,   
                                 PriceGroupCode__c,Sales_District__c,Sales_District__r.Sales_Director__c,Sales_District__r.Latam_Director__c    
                                 FROM Account   
                                 WHERE Id=:recordId LIMIT 1];   
        
        if(accList.size()>0){   
            if(accList[0].Payment_Term_Code__c!=null){  
                Payment_Terms = accList[0].Payment_Term_Code__c ;   
                paymentTermList =  [SELECT Id,name,Payterms_Desc__c,Payment_Term__c,Discount_Italy__c,Sales_Org__c,Payment_Term_Code__c FROM Payment_Term__c    
                                    where id=:Payment_Terms limit 1]; 
            }   
        }   
        
        List<Distributor_Depot_Mapping__c> dmList = [SELECT id, Distributor__c ,Depot__c, Depot__r.Location__c  
                                                     FROM Distributor_Depot_Mapping__c  
                                                     WHERE Distributor__c=:recordId LIMIT 1];   
        
        List<DistributorSalesAreaMapping__c> SalesAreaDMList = [SELECT Id,AccountOwner__c, Division_Code__c, Sales_Org_Code__c, Order_Type__c, PriceGroupMaster__c, 
                                                                Distribution_Channel_Code__c, SalesOrg__c, Division__c, Distributor__c  
                                                                FROM DistributorSalesAreaMapping__c where Distributor__c=:recordId And (Distribution_Channel_Code__c='67' OR Distribution_Channel_Code__c='20') 
                                                                AND Manually_Created__c = false LIMIT 1];                                                   
        
        List<Credit_Info__c> ciList = [SELECT id, name,Distributor__c,distributor__r.name,  
                                       Credit_Limit__c,Balance_Limit__c,Used_Limit__c,  
                                       Internal_Limit__c, Sum_Open_Item__c, DAYS_ARREARS__c     
                                       FROM Credit_Info__c  
                                       WHERE Distributor__c =:recordId LIMIT 1];    
        
        List<Outstanding_Ageing__c> oagList = [SELECT id, OutstandingTotalGreaterthan90__c, Net_Outstanding__c  
                                               FROM Outstanding_Ageing__c   
                                               WHERE Customer_Code__c =:recordId LIMIT 1];  
        
        List<Payments__c> oaList = [SELECT id, Net_Overdue__c  FROM Payments__c     
                                    WHERE Customer_Name__c =:recordId LIMIT 1]; 
        
        
        DistributorWrapper distributorDetails = new DistributorWrapper();   
        distributorDetails.distributorName = accList[0].Name;   
        distributorDetails.sapCode = accList[0].SAP_Code__c;    
        distributorDetails.salesOrgId =SalesAreaDMList[0].SalesOrg__c;  
        distributorDetails.salesOrgName = accList[0].Sales_Org__r.Name; 
        distributorDetails.distributorChannelId = accList[0].Distribution_Channel__c;       
        distributorDetails.Sales_Director = accList[0].Sales_District__r.Sales_Director__c; 
        distributorDetails.Latam_Director = accList[0].Sales_District__r.Latam_Director__c; 
        distributorDetails.areaManagerId = accList[0].Region__r.RegionHead__c;  
        distributorDetails.divisionId = SalesAreaDMList[0].Division__c;     
        distributorDetails.priceGroupId = SalesAreaDMList[0].PriceGroupMaster__c;   
        if(paymentTermList.size()>0){   
            distributorDetails.paymentTermId = Payment_Terms;   
            distributorDetails.paymentTerms = paymentTermList[0].Payment_Term__c;   
            distributorDetails.paymentTermsDiscount = paymentTermList[0].Discount_Italy__c; 
        }   
        distributorDetails.address = accList[0].BillingStreet;  
        distributorDetails.city = accList[0].BillingCity;   
        distributorDetails.state = accList[0].BillingState; 
        distributorDetails.country = accList[0].BillingCountry; 
        distributorDetails.pincode = accList[0].BillingPostalCode;  
        distributorDetails.billingSteet1 = accList[0].Billing_Street_1__c;  
        distributorDetails.billingSteet2 = accList[0].Billing_Street_2__c;  
        distributorDetails.billingSteet3 = accList[0].Billing_Street_3__c;  
        distributorDetails.billingSteet4 = accList[0].Billing_Street_4__c;  
        distributorDetails.billingSteet5 = accList[0].Billing_Street_5__c;  
        distributorDetails.billingSteet6 = accList[0].Billing_Street_6__c;  
        distributorDetails.currencyIso = accList[0].currencyIsoCode;    
        distributorDetails.regionalManagerId = accList[0].RegionalManager__c;   
        distributorDetails.fixedRateAvailable =accList[0].Is_Fixed_Rate_Available_Italy__c;
        distributorDetails.specialRateAvailable =accList[0].Is_Special_Rate_Available__c; //Divya: 12/05/2021: Added for SCTASK0452622
        distributorDetails.normalDCostTC =accList[0].Normal_Delivery_Cost_Italy__c; 
        distributorDetails.expressDCostTC =accList[0].Express_Delivery_Cost_Italy__c;   
        
        if(!oaList.isEmpty()){  
            distributorDetails.greaterThan90 = oaList[0].Net_Overdue__c; //oaList[0].OutstandingTotalGreaterthan90__c;  
        }   
        
        if(!oagList.isEmpty()){ 
            distributorDetails.paymentOutstanding = oagList[0].Net_Outstanding__c;  
        }   
        
        if(!dmList.isEmpty()){  
            distributorDetails.depot = dmList[0].Depot__r.Location__c;  
        }   
        
        if(!ciList.isEmpty()){  
            distributorDetails.creditLimit = ciList[0].Credit_Limit__c; 
            distributorDetails.creditUsed = ciList[0].Used_Limit__c;    
            distributorDetails.creditBalance = ciList[0].Balance_Limit__c;  
            distributorDetails.daysArrears = ciList[0].DAYS_ARREARS__c; 
            distributorDetails.internalCredit = ciList[0].Internal_Limit__c;    
        }   
        return distributorDetails;  
    }   
    
    //Method to get a map of picklist values of Shipping Location from custom object.   
    public static Map<String,Shipping_Location__c> getShippingLoations(string accountId){   
        Map<String,Shipping_Location__c> options = new Map<String,Shipping_Location__c>();   
        if(String.isNotBlank(accountId)){   
            options = ItalyShipLocationShare.getShippingLocation(accountId);    
            system.debug('options'+options);    
        }   
        return options; 
    }   
    
    
    //Method to get a map of picklist values of Payment Terms from custom object.   
    public static Map<String,Payment_Term_PG_Group_Mapping__c> getPaymentTermMap(String pgcode){    
        Map<String,Payment_Term_PG_Group_Mapping__c> options = new Map<String,Payment_Term_PG_Group_Mapping__c>();  
        for(Payment_Term_PG_Group_Mapping__c pTObj:[SELECT Id, Payment_Term_Italy__c,Payment_Term_Italy__r.Payment_Term__c,Customer_italy__c,Payterm_Term_Discount_Italy__c,    
                                                    Price_Group_Master_Italy__c  FROM Payment_Term_PG_Group_Mapping__c   
                                                    WHERE Price_Group_Master_Italy__c=: pgcode and Customer_italy__c = null ORDER BY Payment_Term_Italy__r.Sequence_Number__c ASC]){    
                                                        options.put(pTObj.Payment_Term_Italy__r.Payment_Term__c, pTObj); 
                                                    }    
        return options; 
    }   
    
    //Method to get a map of picklist values where pgCode is not available but custom available in mapping Object. 
    public static Map<String,Payment_Term_PG_Group_Mapping__c> getPaymentTermCustomerMap(String recordId){  
        Map<String,Payment_Term_PG_Group_Mapping__c> options = new Map<String,Payment_Term_PG_Group_Mapping__c>();  
        for(Payment_Term_PG_Group_Mapping__c pTObj:[SELECT Id, Payment_Term_Italy__c,Payment_Term_Italy__r.Payment_Term__c,Customer_italy__c,Payterm_Term_Discount_Italy__c,    
                                                    Price_Group_Master_Italy__c  FROM Payment_Term_PG_Group_Mapping__c   
                                                    WHERE Customer_italy__c=: recordId AND Price_Group_Master_Italy__c = null ORDER BY Payment_Term_Italy__r.Sequence_Number__c ASC]){  
                                                        options.put(pTObj.Payment_Term_Italy__r.Payment_Term__c, pTObj); 
                                                    }    
        return options; 
    }   
    
    //Method to get a map of picklist values of Payment Terms from custom object.   
    public static Map<String,Payment_Term__c> getPaymentTermMap1(){     
        Map<String,Payment_Term__c> options = new Map<String,Payment_Term__c>();    
        for(Payment_Term__c pTObj:[SELECT Id, Sequence_Number__c, Payment_Term_Code__c,Discount_Italy__c,   
                                   Payment_Term__c  FROM Payment_Term__c    
                                   WHERE SalesOrgCode__c = '2410' and Sequence_Number__c!=null  ORDER BY Sequence_Number__c ASC]){   
                                       options.put(pTObj.Payment_Term__c, pTObj);   
                                   }    
        return options; 
    }   
    
    //Method to get all the picklist values of types of Product.   
    public static List<String> getProductTypes(){  
        List<String> options = new List<String>();  
        Schema.DescribeFieldResult fieldResult = Sales_Order_Line_Item__c.Product_Type_Italy__c.getDescribe();  
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();   
        for (Schema.PicklistEntry f: ple) { 
            options.add(f.getLabel());  
        }   
        return options; 
    }   
    
    //Method to fetch admin parameter List  
    @AuraEnabled    
    public static Trans_Contribution__c getTransContriDetails() {   
        List<Trans_Contribution__c> TCParamList = Trans_Contribution__c.getall().values();  
        return TCParamList[0];  
    }   
    
    @AuraEnabled     
    public static List<PriceDetail> getSkuData(String accId ,String pgCode){    
        system.debug('pgCode'+pgCode);  
        
        List<PriceDetail> priceList = new List<PriceDetail>();  
        List<PriceBookMaster__c> pbmList =new List<PriceBookMaster__c>();   
        List<PricebookDiscount__c> pbdisList =new List<PricebookDiscount__c>(); 
        Map<Id,PriceBookMaster__c> PBMmap = new Map<Id,PriceBookMaster__c>();   
        Map<Id,Decimal> pBDiscountMap = new Map<Id,Decimal>();  
        Map<Id,Decimal> accrualDiscountMap = new Map<Id,Decimal>();
        
        pbmList =  [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name,     
                    SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c, 
                    DepotCode__c, DepotCode__r.Location__c,SKUCode__r.UOM__c,SKUCode__r.Area_Manager_MSP__c,    
                    SKUCode__r.Sales_Director_MSP__c, Price__c, PG_CODE__c, PG_CODE__r.Name,SKUCode__r.Product_Category__c,SKUCode__r.Sales_Agent_MSP__c,   
                    UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Unit_Cost__c,SKUCode__r.pallet_Size_Italy__c,   
                    SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,SKUCode__r.Active_ingredient_Italy__c,
                    SKUCode__r.Inventory_order_Flag_Color_Italy__c,SKUCode__r.Inventory_Description_Italy__c,SKUCode__r.Inventory_order_Flag_Italy__c,  
                    SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c 
                    FROM PriceBookMaster__c 
                    WHERE (DistributorCustomerCode__c =: accId AND PG_CODE__c = NULL AND DepotCode__r.Location__c ='IT00')  
                    AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2410'   
                    AND SKUCode__r.Sales_Agent_MSP__c!=null  AND SKUCode__r.Sales_Agent_MSP__c!=0   
                    AND SKUCode__r.Area_Manager_MSP__c!=null AND SKUCode__r.Area_Manager_MSP__c!=0  
                    AND SKUCode__r.Sales_Director_MSP__c!=null AND SKUCode__r.Sales_Director_MSP__c!=0  
                    AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True   
                    ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC,LastModifiedDate ASC ];    
        system.debug('Price Book List query went in the First block. Records found-->'+pbmList.Size());
        pbdisList = [SELECT Id, SKUCode__c ,PG_Code__c,  
                     Price__c, Accrual_Discount__c, CurrencyIsoCode, LastModifiedDate    
                     FROM PricebookDiscount__c  
                     WHERE  DepotCode__r.Location__c ='IT00'    
                     AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2410'  
                     AND PG_Code__c =null AND DistributorCustomerCode__c=:accId 
                     AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True
                     ORDER BY LastModifiedDate ASC];    
        system.debug('Price Discount List query went in the first block. Records found-->'+pbdisList.Size());
        if(pbmList.size()==0){
            system.debug('PBM List 1 Query return no result');
            pbdisList.clear();    
            pbmList =  [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name,  
                        SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c, 
                        DepotCode__c, DepotCode__r.Location__c,SKUCode__r.UOM__c,SKUCode__r.Area_Manager_MSP__c,    
                        SKUCode__r.Sales_Director_MSP__c, Price__c, PG_CODE__c, PG_CODE__r.Name,SKUCode__r.Product_Category__c,SKUCode__r.Sales_Agent_MSP__c,   
                        UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Unit_Cost__c,SKUCode__r.pallet_Size_Italy__c,   
                        SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,SKUCode__r.Active_ingredient_Italy__c,
                        SKUCode__r.Inventory_order_Flag_Color_Italy__c,SKUCode__r.Inventory_Description_Italy__c,SKUCode__r.Inventory_order_Flag_Italy__c,
                        SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c 
                        FROM PriceBookMaster__c 
                        WHERE (PG_CODE__c =: pgCode AND DistributorCustomerCode__c =NULL AND DepotCode__r.Location__c ='IT00') 
                        AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2410'  
                        AND SKUCode__r.Sales_Agent_MSP__c!=null  AND SKUCode__r.Sales_Agent_MSP__c!=0  
                        AND SKUCode__r.Area_Manager_MSP__c!=null AND SKUCode__r.Area_Manager_MSP__c!=0 
                        AND SKUCode__r.Sales_Director_MSP__c!=null AND SKUCode__r.Sales_Director_MSP__c!=0 
                        AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True      
                        ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC,LastModifiedDate ASC ];   
            system.debug('Price Book List query went in the second block. Records found-->'+pbmList.Size());
            system.debug('Sayan00 pgCode-->'+pgCode);
            pbdisList = [SELECT Id, SKUCode__c ,PG_Code__c,   
                         Price__c, Accrual_Discount__c, CurrencyIsoCode, LastModifiedDate    
                         FROM PricebookDiscount__c  
                         WHERE  DepotCode__r.Location__c ='IT00'    
                         AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2410'  
                         AND PG_Code__c =: pgCode AND DistributorCustomerCode__c=null   
                         AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True
                         ORDER BY LastModifiedDate ASC];    
            system.debug('Price Discount List query went in the second block. Records found-->'+pbdisList.Size());
        }else{
            system.debug('PBM List 1 Query has found prices');
        }
        if(pbmList.size()==0){
            system.debug('PBM List 2 Query return no result');
            pbdisList.clear();  
            pbmList =  [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name,    
                        SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c, 
                        DepotCode__c, DepotCode__r.Location__c,SKUCode__r.UOM__c,SKUCode__r.pallet_Size_Italy__c,   
                        Price__c, PG_CODE__c, PG_CODE__r.Name,SKUCode__r.Product_Category__c,SKUCode__r.Area_Manager_MSP__c,    
                        SKUCode__r.Sales_Director_MSP__c,SKUCode__r.Sales_Agent_MSP__c,SKUCode__r.Active_ingredient_Italy__c,
                        SKUCode__r.Inventory_order_Flag_Color_Italy__c,SKUCode__r.Inventory_Description_Italy__c,SKUCode__r.Inventory_order_Flag_Italy__c,
                        UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Unit_Cost__c,   
                        SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,   
                        SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c 
                        FROM PriceBookMaster__c WHERE (PG_CODE__c = NULL AND DepotCode__r.Location__c ='IT00' AND DistributorCustomerCode__c =NULL) 
                        AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2410'   
                        AND SKUCode__r.Sales_Agent_MSP__c!=null AND SKUCode__r.Sales_Agent_MSP__c!=0    
                        AND SKUCode__r.Area_Manager_MSP__c!=null AND SKUCode__r.Area_Manager_MSP__c!=0  
                        AND SKUCode__r.Sales_Director_MSP__c!=null AND SKUCode__r.Sales_Director_MSP__c!=0  
                        AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True   
                        ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC,LastModifiedDate ASC ];    
            system.debug('Price Book List query went in the third block. Records found-->'+pbmList.Size());
            pbdisList = [SELECT Id, SKUCode__c ,PG_Code__c, 
                         Price__c, Accrual_Discount__c, CurrencyIsoCode, LastModifiedDate     
                         FROM PricebookDiscount__c  
                         WHERE  DepotCode__r.Location__c ='IT00'    
                         AND SKUCode__r.Sales_Org__r.sales_org_code__c ='2410'  
                         AND /*PG_Code__c =: pgCode (Sayan: INC0116960)*/ PG_Code__c =null AND DistributorCustomerCode__c=null   
                         AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True
                         ORDER BY LastModifiedDate ASC];    
            system.debug('Price Discount List query went in the third block. Records found-->'+pbdisList.Size());
        }else{
            system.debug('PBM List 2 Query has found prices');
        }
        
        if(pbmList.size()>0){   
            for(PriceBookMaster__c pbObj :pbmList){ 
                PBMmap.put(pbObj.SKUCode__c, pbObj);    
            }   
        }   
        if(pbdisList.size()>0){ 
            for(PricebookDiscount__c pbdObj :pbdisList){
                if(pbdObj.Price__c!=null){
                    pBDiscountMap.put(pbdObj.SKUCode__c, pbdObj.Price__c);        
                }else{
                    pBDiscountMap.put(pbdObj.SKUCode__c, 0);        
                }
                if(pbdObj.Accrual_Discount__c!=null){
                    accrualDiscountMap.put(pbdObj.SKUCode__c, pbdObj.Accrual_Discount__c);        
                }else{
                    accrualDiscountMap.put(pbdObj.SKUCode__c, 0);        
                }
                
            }   
        }   
        system.debug('pbmList.size()'+pbmList.size());  
        if(pbmList.size()>0){   
            system.debug('pbmList.size()'+pbmList); 
            for(PriceBookMaster__c pbObj :PBMmap.values()){ 
                PriceDetail pb = new PriceDetail();    
                system.debug('pbObj'+pb);  
                pb.skuId = pbObj.SKUCode__c;    
                pb.skuCategory = pbObj.SKUCode__r.Product_Category__c;  
                pb.skuDescription = pbObj.SKUCode__r.SKU_Description__c;    
                pb.activeIngredient = pbObj.SKUCode__r.Active_ingredient_Italy__c;  
                pb.skuBrand = pbObj.SKUCode__r.Brand_Name__c;   
                pb.unitCost = pbObj.SKUCode__r.Unit_Cost__c;    
                pb.UOM = pbObj.SKUCode__r.UOM__c;   
                if(pbObj.PG_CODE__c!= null){    
                    pb.pgCode = pbObj.PG_CODE__c;   
                }else{  
                    pb.pgCode = ''; 
                }   
                system.debug('pbObj.DistributorCustomerCode__c'+pbObj.DistributorCustomerCode__c);  
                if(pbObj.DistributorCustomerCode__c!=null){         
                    pb.customerCode = pbObj.DistributorCustomerCode__c;         
                }else{          
                    pb.customerCode = '';           
                }   
                pb.unitValue = pbObj.Final_Price__c;    
                // pb.unitValue2 = pbObj.Final_Price__c; 
                // pb.minValue = pbObj.MinPrice__c;  
                pb.materialPrice = pbObj.Price__c; //maxPrice   
                pb.pricebookId = pbObj.Id;  
                pb.skuCode = pbObj.SKUCode__r.SKU_Code__c;  
                pb.multipleOf = pbObj.SKUCode__r.Multiple_of__c;    
                
                pb.palletSize = pbObj.SKUCode__r.pallet_Size_Italy__c;  
                pb.SalesAgentMSP = pbObj.SKUCode__r.Sales_Agent_MSP__c; 
                pb.AreaManagerMSP = pbObj.SKUCode__r.Area_Manager_MSP__c;   
                pb.SalesDirectorMSP = pbObj.SKUCode__r.Sales_Director_MSP__c;   
                pb.flagImage=pbObj.SKUCode__r.Inventory_order_Flag_Color_Italy__c;
                if(pbObj.SKUCode__r.Inventory_Description_Italy__c!=null){
                    pb.flagImageDisc=pbObj.SKUCode__r.Inventory_Description_Italy__c;
                }else{
                    if(pbObj.SKUCode__r.Inventory_order_Flag_Italy__c=='Green'){
                        pb.flagImageDisc=System.Label.Available;
                    }else if(pbObj.SKUCode__r.Inventory_order_Flag_Italy__c=='Red'){
                        pb.flagImageDisc=System.Label.Not_Available;
                    }else if(pbObj.SKUCode__r.Inventory_order_Flag_Italy__c=='Yellow'){
                        pb.flagImageDisc=System.Label.Limited_Quantity_Available;
                    }
                    
                }
                if(pbdisList.size()>0){ 
                    if(pBDiscountMap.containsKey(pbObj.SKUCode__c)){    
                        pb.standardRebate = pBDiscountMap.get(pbObj.SKUCode__c);//discount  
                        // pb.standardRebate2 = pBDiscountMap.get(pbObj.SKUCode__c);
                    }  
                    if(accrualDiscountMap.containsKey(pbObj.SKUCode__c)){   
                        pb.accrualDiscount = accrualDiscountMap.get(pbObj.SKUCode__c);
                    } 
                }   
                priceList.add(pb);    
            }   
            system.debug('priceList'+priceList);   
        } 
        return priceList;   
    }       

    
    //Approval Process Methods  
    @AuraEnabled    
    public static ApprovalList processApproval(Boolean isApproved, String recordId, String comments) {  
        // Approve the submitted request    
        // First, get the ID of the newly created item  
        // First, get the IDs for the WorkItems     
        List<Id> newWorkItemIds = new List<Id>();
        if(!Test.isRunningTest()){
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
            req2.setWorkitemId(newWorkItemIds.get(0));  
            
            // Submit the request for approval  
            Approval.ProcessResult result2 =  Approval.process(req2);   
            
            // Verify the results   
            System.debug('Instance Status'+result2.getInstanceStatus());    
            System.debug('Success'+String.valueOf(result2.isSuccess()));    
        }
        return ReturnOrderItalyController.generateData(recordId); //result2.isSuccess();  
    }       
    //End of Approval Process   
    
    //Approval History Table Logic  
    
    @AuraEnabled    
    public static ApprovalList generateData(String recordId){   
        System.debug('Generate Data: '+recordId);   
        ApprovalList approvalResultForObject = new ApprovalList();  
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
            for(ProcessInstanceHistory sWI:pI.StepsAndWorkitems){   
                if(sWI.StepStatus==System.Label.Pending){   
                    if(approvalResultForObject.enableApproval != true){ 
                        System.debug('Approver actor Enable: '+(sWI.ActorId==UserInfo.getUserId()));    
                        System.debug('Original actor Enable: '+(sWI.OriginalActorId==UserInfo.getUserId()));    
                        if(sWI.OriginalActorId==UserInfo.getUserId()){  
                            system.debug('UserInfo.getUserId()'+UserInfo.getUserId());  
                            approvalResultForObject.enableApproval = true;  
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
                                        approvalResultForObject.listOfStepsAudit.add(ahObj);                                        
                                    }   
        beforeSort = approvalResultForObject.listOfStepsAudit;  
        sortAuditHistory(); 
        approvalResultForObject.listOfStepsAudit = afterSort;   
        approvalResultForObject.recordId = recordId;    
        return approvalResultForObject; 
    }   
    
    
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
        Datetime dt = Datetime.newInstance(1900, 12, 31, 00, 00, 00); // if decending   
        
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
    
    
    /*******************************************/   
    /* Wrapper classes to store All Data  */    
    /*****************************************/ 
    
    public class OrderFields{  
        @AuraEnabled public DistributorWrapper DistributorData; 
        // @AuraEnabled public List<String> orderTypeList;   
        @AuraEnabled public List<String> paymentMethodList; 
        @AuraEnabled public List<String> currencyList;  
        @AuraEnabled public Map<String, Shipping_Location__c> ShippingLocMap;   
        @AuraEnabled public Map<String,Payment_Term_PG_Group_Mapping__c> PaymentTermMap;    
        @AuraEnabled public Map<String,Payment_Term_PG_Group_Mapping__c> PaymentTermCustomerMap; 
        @AuraEnabled public Map<String,Payment_Term__c> PaymentTermMap1;    
        @AuraEnabled public List<String> incoTermsList; 
        @AuraEnabled public List<String> productTypesList;  
        @AuraEnabled public List<String> priceList; 
        @AuraEnabled public User userObj;   
        @AuraEnabled public Boolean hasDefaultRules;    
        @AuraEnabled public Trans_Contribution__c TransContributionParam;   
        
        public OrderFields(){   
            DistributorData = new DistributorWrapper(); 
            //  orderTypeList = new List<String>();   
            paymentMethodList = new List<String>(); 
            currencyList = new List<String>();  
            ShippingLocMap = new Map<String, Shipping_Location__c>();   
            PaymentTermMap = new Map<String, Payment_Term_PG_Group_Mapping__c>();   
            PaymentTermCustomerMap = new Map<String, Payment_Term_PG_Group_Mapping__c>();   
            PaymentTermMap1 = new Map<String, Payment_Term__c>();   
            incoTermsList = new List<String>(); 
            productTypesList = new List<String>();  
            priceList = new List<String>(); 
            userObj = new User();   
            hasDefaultRules = false;    
            TransContributionParam = new Trans_Contribution__c();   
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
        
        @AuraEnabled public List<AuditHistory> listOfStepsAudit;    
        @AuraEnabled public List<ProcessInstanceHistory> listOfSteps;   
        @AuraEnabled public Boolean enableApproval; 
        @AuraEnabled public Id recordId;    
        
        public ApprovalList(){  
            
            listOfStepsAudit = new List<AuditHistory>();    
            listOfSteps = new  List<ProcessInstanceHistory>();  
            enableApproval = false; 
        }   
    }   
    
    public class OrderWrapper{  
        @AuraEnabled public Sales_Order__c soObj;   
        @AuraEnabled public ApprovalList approvalList;  
        @AuraEnabled public List<SalesOrderItem> soiList;   
        @AuraEnabled public String sfdcOrderNo; 
        @AuraEnabled public String sapOrderNo;  
        @AuraEnabled public String orderSubStatus; 
        @AuraEnabled public String orderTypeItaly;//Added for type of order i.e normal, parent,child.
        public Exception exObj; 
        
        public OrderWrapper(){  
            soObj = new Sales_Order__c();   
            approvalList = new ApprovalList();  
            soiList = new List<SalesOrderItem>();   
            sfdcOrderNo = '';   
            sapOrderNo = '';    
            orderSubStatus = '';
            orderTypeItaly = '';
        }   
    }   
    
    public class CartWrapper{   
        @AuraEnabled public List<SalesOrderItem> soiList;  
        @AuraEnabled public SalesOrderItem soitemObj;  
        @AuraEnabled public String cartOrderId;    
        @AuraEnabled public String errorMessage;   
        @AuraEnabled public Decimal grossNetPrice; 
        @AuraEnabled public Boolean isExpressDelivery; 
        @AuraEnabled public String orderTypeItaly;
        
        
        
        public CartWrapper(){   
            soiList = new List<SalesOrderItem>();  
            soitemObj = new SalesOrderItem();  
            cartOrderId ='';   
            errorMessage='';   
            grossNetPrice=0;   
            isExpressDelivery =false; 
            orderTypeItaly ='';
        }    
    }   
    
    public class SalesOrderItem {   
        
        @AuraEnabled public String productId;   
        @AuraEnabled public String productCode; 
        @AuraEnabled public String ordrId;  
        @AuraEnabled public String oliId;   
        @AuraEnabled public String priceBookDetailId;   
        @AuraEnabled public String skuCategory; 
        @AuraEnabled public String UOM; 
        @AuraEnabled public String pgCode;  
        @AuraEnabled public String customerCode;    
        @AuraEnabled public String productName; 
        @AuraEnabled public String shipDate;    
        @AuraEnabled public Decimal qty;    
        @AuraEnabled public Decimal inventory;  
        @AuraEnabled public Decimal listValue;  
        @AuraEnabled public Decimal minValue;   
        @AuraEnabled public Decimal unitValue;//final prices    
        @AuraEnabled public Decimal unitValue2; 
        @AuraEnabled public Decimal estimatedFPrice;    
        @AuraEnabled public Decimal unitCost;   
        @AuraEnabled public Decimal materialPrice;  
        @AuraEnabled public Decimal standardRebate; 
        @AuraEnabled public Decimal standardRebate2;    
        @AuraEnabled public Decimal budgetValue;    
        @AuraEnabled public Decimal discount;   
        @AuraEnabled public Decimal discount_percent;   
        @AuraEnabled public Decimal profit; 
        @AuraEnabled public String typeOfProduct;   
        @AuraEnabled public String applyRebateDisc; 
        @AuraEnabled public Decimal averageFinalP;  
        
        @AuraEnabled public Decimal netSales;   
        @AuraEnabled public Decimal netInvoicePrice;    
        @AuraEnabled public Decimal netPrice;   
        @AuraEnabled public Decimal margin; 
        @AuraEnabled public Decimal netMargin;  
        @AuraEnabled public String resultByMargin;  
        @AuraEnabled public String resultByPrice;   
        @AuraEnabled public Decimal totalSales; 
        @AuraEnabled public Decimal grossProfit;    
        @AuraEnabled public Decimal grossMargin;    
        @AuraEnabled public Decimal businessImpact; 
        @AuraEnabled public Decimal totalDiscount;  
        @AuraEnabled public Decimal maxPrice;   
        @AuraEnabled public Decimal TransContribution;  
        @AuraEnabled public Decimal TransContribution2;
        @AuraEnabled public Decimal TransContributionPreviousValue;//Sayan: 06/07/2021: Added for SCTASK0452622
        @AuraEnabled public Decimal TransContributionPreviousValue2;//Sayan: 06/07/2021: Added for SCTASK0452622
        @AuraEnabled public Decimal palletSize; 
        @AuraEnabled public Decimal SalesAgentMSP;      
        @AuraEnabled public Decimal AreaManagerMSP;     
        @AuraEnabled public Decimal SalesDirectorMSP;   
        @AuraEnabled public String flagImage;
        @AuraEnabled public String flagImageDisc;
        @AuraEnabled public String personalNotes;
        
        @AuraEnabled public Decimal replacementMargin;  
        @AuraEnabled public Decimal ledgerMargin;   
        @AuraEnabled public Decimal unitValueWithInterest;  
        @AuraEnabled public Decimal totalValue; 
        @AuraEnabled public Decimal totalValueWithInterest; 
        @AuraEnabled public Decimal interestRate;   
        @AuraEnabled public Decimal days;   
        @AuraEnabled public Decimal timeInMonths;   
        @AuraEnabled public Decimal multipleOf; 
        @AuraEnabled public String cultureDesc; 
        @AuraEnabled public Decimal itemNo; 
        @AuraEnabled public Decimal moItemNo;   
        @AuraEnabled public Boolean isMO;   
        @AuraEnabled public Boolean applyRebate;    
        @AuraEnabled public Decimal availableInv;   
        @AuraEnabled public String availableInv2;
        @AuraEnabled public Decimal balanceQty;
        @AuraEnabled public Decimal sequenceNumber;
        @AuraEnabled public String salesOrderItemId;
        @AuraEnabled public Decimal accrualDiscount;
        @AuraEnabled public String tcCalculation;
        @AuraEnabled public String tcCalculation1;
        @AuraEnabled public String parentOrderNumber;
        @AuraEnabled public String venditaPos;
        @AuraEnabled public String VenditaOmaggioPosition;
        @AuraEnabled public String VenditaPosition;
        @AuraEnabled public String balanceQtyStr;
        @AuraEnabled public Boolean isDiffProduct;   
        @AuraEnabled public String pricebookId;
        
        public SalesOrderItem(){    
            UOM = 'N/A';    
            applyRebate = false;    
            itemNo = 0; 
            moItemNo = 0;   
            productId = ''; 
            pgCode = '';    
            customerCode ='';   
            productCode = '';   
            ordrId = '';    
            priceBookDetailId = ''; 
            productName = '';   
            maxPrice = 0;   
            unitCost =0;    
            unitValue2 =0;  
            netInvoicePrice =0; 
            TransContribution = 0;  
            TransContribution2 =0;
            TransContributionPreviousValue = 0;//Sayan: 06/07/2021: Added for SCTASK0452622
            TransContributionPreviousValue2 = 0;//Sayan: 06/07/2021: Added for SCTASK0452622
            materialPrice =0;   
            standardRebate = 0; 
            standardRebate2 =0; 
            shipDate = '';  
            qty = 0;    
            palletSize =0;  
            oliId ='';  
            averageFinalP = 0;  
            SalesAgentMSP = 0;  
            AreaManagerMSP = 0; 
            SalesDirectorMSP = 0;   
            discount = 0;   
            discount_percent = 0;   
            availableInv = 0;   
            availableInv2 = 'Out of Stock'; 
            profit = 0; 
            netSales = 0;   
            multipleOf = 0; 
            netPrice = 0;   
            margin = 0; 
            netMargin = 0;  
            unitValueWithInterest = 0;  
            totalValueWithInterest = 0; 
            totalValue = 0; 
            interestRate = 0;   
            days = 0;   
            cultureDesc = '';   
            flagImage='';
            flagImageDisc=''; 
            personalNotes='';
            balanceQty = 0;
            salesOrderItemId='';
            sequenceNumber=0;
            accrualDiscount=0;
            tcCalculation='';
            tcCalculation1='';
            venditaPos='';
            VenditaOmaggioPosition='';
            VenditaPosition='';
            balanceQtyStr='';
            isDiffProduct = false;
            pricebookId='';
        }   
    }   
    
    public class PriceDetail{   
        @AuraEnabled public String skuId;   
        @AuraEnabled public String skuDescription;  
        @AuraEnabled public String skuCategory; 
        @AuraEnabled public String UOM; 
        @AuraEnabled public String pgCode;  
        @AuraEnabled public String activeIngredient;    
        @AuraEnabled public String customerCode;    
        @AuraEnabled public String shipDate;    
        @AuraEnabled public Decimal unitValue;  
        @AuraEnabled public Decimal unitValue2; 
        @AuraEnabled public Decimal unitCost;   
        @AuraEnabled public Decimal materialPrice;  
        @AuraEnabled public Decimal standardRebate; 
        @AuraEnabled public Decimal standardRebate2;    
        @AuraEnabled public Decimal TransContribution;  
        @AuraEnabled public Decimal palletSize; 
        @AuraEnabled public Decimal SalesAgentMSP;      
        @AuraEnabled public Decimal AreaManagerMSP;     
        @AuraEnabled public Decimal SalesDirectorMSP;   
        @AuraEnabled public String flagImage;
        @AuraEnabled public String flagImageDisc;
        
        @AuraEnabled public Decimal minValue;   
        @AuraEnabled public String pricebookId; 
        @AuraEnabled public Decimal qty;    
        @AuraEnabled public String skuCode; 
        @AuraEnabled public String skuBrand;    
        @AuraEnabled public Decimal multipleOf; 
        @AuraEnabled public Decimal monthlyInterestRate;    
        @AuraEnabled public String orderItemId; 
        @AuraEnabled public String regState;    
        @AuraEnabled public Decimal balanceQty; 
        @AuraEnabled public Decimal balanceQty2;    
        @AuraEnabled public String fatDate; 
        @AuraEnabled public Decimal percUsed;   
        @AuraEnabled public Decimal days;   
        @AuraEnabled public Decimal unitValueWithInterest;  
        @AuraEnabled public Decimal totalValue; 
        @AuraEnabled public Decimal totalValueWithInterest; 
        @AuraEnabled public Decimal interestRate;           
        @AuraEnabled public String cultureDesc; 
        @AuraEnabled public Boolean isMO;   
        @AuraEnabled public Boolean applyRebate;    
        @AuraEnabled public Decimal itemNo; 
        @AuraEnabled public Boolean isValid;    
        @AuraEnabled public Decimal maxPrice;   
        @AuraEnabled public Decimal availableInv;   
        @AuraEnabled public String availableInv2;   
        @AuraEnabled public Decimal accrualDiscount;
        
        public PriceDetail(){   
            UOM = 'N/A';    
            itemNo = 0; 
            skuId = ''; 
            pgCode = '';    
            customerCode ='';   
            skuDescription = '';    
            skuBrand = '';  
            skuCategory = '';   
            //   unitValue = 0;    
            unitValue2 = 0; 
            shipDate = '';  
            activeIngredient = '';  
            unitCost =0;    
            palletSize =0;  
            // TransContribution = 0;    
            materialPrice = 0;  
            standardRebate = 0; 
            standardRebate2 =0; 
            minValue = 0;   
            pricebookId = '';   
            days = 0;   
            //qty = 0;  
            maxPrice = 0;   
            availableInv = 0;   
            SalesAgentMSP = 0;  
            AreaManagerMSP = 0; 
            SalesDirectorMSP = 0;   
            flagImage='';
            flagImageDisc='';   
            availableInv2 = 'Out of Stock'; 
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
            totalValue = 0; 
            interestRate = 0;   
            totalValueWithInterest = 0; 
            applyRebate = false;    
            isValid = false;  
            accrualDiscount = 0;
        }   
    }   
    
    public class DistributorWrapper{    
        @AuraEnabled   public String Sales_Director;    
        @AuraEnabled   public String Latam_Director;    
        @AuraEnabled   public List<String> divisionIds; 
        @AuraEnabled   public String distributorName;   
        @AuraEnabled   public String areaManagerId; 
        @AuraEnabled   public String salesOrgId;    
        @AuraEnabled   public String salesOrgName;  
        @AuraEnabled   public String distributorChannelId;  
        @AuraEnabled   public String divisionId;    
        @AuraEnabled   public String orderType; 
        @AuraEnabled   public String sapCode;   
        @AuraEnabled   public String depot; 
        @AuraEnabled   public Decimal creditLimit;  
        @AuraEnabled   public Decimal daysArrears;  
        @AuraEnabled   public Decimal creditUsed;   
        @AuraEnabled   public Decimal creditBalance;    
        @AuraEnabled   public Decimal paymentOutstanding;   
        @AuraEnabled   public Decimal greaterThan90;    
        @AuraEnabled   public Decimal normalDCostTC;    
        @AuraEnabled   public Decimal expressDCostTC;   
        @AuraEnabled   public String address;   
        @AuraEnabled   public String city;  
        @AuraEnabled   public String state; 
        @AuraEnabled   public String country;   
        @AuraEnabled   public String pincode;   
        @AuraEnabled   public String billingSteet1; 
        @AuraEnabled   public String billingSteet2; 
        @AuraEnabled   public String billingSteet3; 
        @AuraEnabled   public String billingSteet4; 
        @AuraEnabled   public String billingSteet5; 
        @AuraEnabled   public String billingSteet6; 
        @AuraEnabled   public String currencyIso;   
        @AuraEnabled   public Id regionalManagerId; 
        @AuraEnabled   public String paymentTerms;  
        @AuraEnabled   public Decimal paymentTermsDiscount; 
        @AuraEnabled   public String paymentTermId; 
        @AuraEnabled   public Id priceGroupId;  
        @AuraEnabled   public Id priceListType; 
        @AuraEnabled   public String territoryManagerId;    
        @AuraEnabled   public Decimal internalCredit;   
        @AuraEnabled   public Boolean fixedRateAvailable;
        @AuraEnabled   public Boolean specialRateAvailable; //Divya: 12/05/2021: Added for SCTASK0452622
        
        // @AuraEnabled public Payment_Term__c paymentTerms;    
    }   
}