/*
* Name: SalesorderUkController
* Created On: 12 feb 2021
* Author: Meenu Thakur
* Description: Class is used for Placing Orders by Distributor of UK
*/

public without sharing class SalesorderUkController {
    
    public static List<AuditHistory> beforeSort = new List<AuditHistory>();   
    public static List<AuditHistory> afterSort = new List<AuditHistory>(); 
    
    // Method to get all info on doinit method//
    @AuraEnabled  
    public static AllFieldsdata getOrderFields(String accId,String objectName){
        String recordId = accId; 
        AllFieldsdata ofObj = new AllFieldsdata(); 
        system.debug('objectName=='+objectName);
        /* ----------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ---------------- */
        User loginUserObj = [SELECT Id, Name, Country, IsActive, Show_Inventory__c, Show_Credit_Limit__c, 
                        Show_Inventory_Column__c, Show_InTransit__c, Show_InTransit_Values__c, 
                        ProfileId,Profile.Name, ManagerId, Country_Head__c, Zonal_Manager__c, RegionalManager__c
                        FROM User WHERE Id =: UserInfo.getUserId() AND IsActive = True];

        List<Login_Country__c> logCntry = new List<Login_Country__c>();
        logCntry = [SELECT Id, Name, For_Contry__c, Sales_Org_Code__c, Delivery_Date__c, 
                    PO_Date__c, Show_Delivery_Date__c, Show_PO_Date__c FROM Login_Country__c 
                    where Name =:loginUserObj.Country limit 1];

        if(logCntry.size() > 0){
            
            ofObj.showPODate = logCntry[0].Show_PO_Date__c;
            ofObj.isPORequired = logCntry[0].PO_Date__c;
            ofObj.showDeliveryDate = logCntry[0].Show_Delivery_Date__c;
            ofObj.isDeliveryRequired = logCntry[0].Delivery_Date__c;
        } 
        /* --------------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------------- */

        if(objectName=='SalesOrder'){
          
            Sales_order__c salesorder=[SELECT Id,Bill_To_Party__c,Sold_to_Party__c 
                                       FROM Sales_order__c 
                                       WHERE id=:recordId];
            
            if(salesorder!=null){
                recordId=salesorder.Sold_to_Party__c;
            }
            
        }
         
        ofObj.DistributorData = SalesorderUkController.fetchDistributorDetails(recordId);
        ofObj.ShippingLocList = SalesorderUkController.getShippingLoations(recordId);
        ofObj.IncoTermList = SalesorderUkController.getIncoTerms(recordId);
        if(objectName=='SalesOrder'){
            ofObj.SalesOrdersList=SalesorderUkController.getSalesOrder(accId); 
            ofObj.documentList=SalesorderUkController.getAllDocuments(accId);
            ofObj.generatedata=SalesorderUkController.generateData(accId);
        }
        return ofObj;
    }
    
    /*To Fetch the distributor details*/
    @AuraEnabled    
    public static DistributorWrapper fetchDistributorDetails(String recordId){
        string currencycode='';
        //Accounts Data
        List<Account> accList =  Database.query(SalesorderUkController.getQuery('Account') + ' FROM Account WHERE Id = \'' + recordId +'\' LIMIT 1');
        
        //To get Sales Area data of account
        List<DistributorSalesAreaMapping__c> SalesAreaDMList = [SELECT Id,AccountOwner__c, Division_Code__c, Sales_Org_Code__c, Order_Type__c, PriceGroupMaster__c, 
                                                                Distribution_Channel_Code__c, SalesOrg__c, Division__c, Distributor__c,CurrencyIsoCode  
                                                                FROM DistributorSalesAreaMapping__c where Distributor__c=:recordId And (Distribution_Channel_Code__c='40' OR Distribution_Channel_Code__c='20') 
                                                                AND Manually_Created__c = false LIMIT 1];
        //To get Depot location mapped with account
        List<Distributor_Depot_Mapping__c> dmList = [SELECT id, Distributor__c ,Depot__c, Depot__r.Location__c  
                                                     FROM Distributor_Depot_Mapping__c  
                                                     WHERE Distributor__c=:recordId LIMIT 1];   
        
        //To get Credit Info 
        List<Credit_Info__c> ciList = [SELECT id, name,Distributor__c,distributor__r.name,  
                                       Credit_Limit__c,Balance_Limit__c,Used_Limit__c,Internal_Limit__c     
                                       FROM Credit_Info__c  
                                       WHERE Distributor__c =:recordId LIMIT 1];
        system.debug('ciList--------------------------->'+ciList);
        
        //To get Net Outstanding field 
        List<Outstanding_Ageing__c> oagList = [SELECT id, Net_Outstanding__c  
                                               FROM Outstanding_Ageing__c   
                                               WHERE Customer_Code__c =:recordId LIMIT 1];  
        
        //To get Net overdue field
        List<Payments__c> oaList = [SELECT id, Net_Overdue__c  FROM Payments__c     
                                    WHERE Customer_Name__c =:recordId LIMIT 1]; 
        
        //Start of Distributor wrapper//
        DistributorWrapper distributorDetails = new DistributorWrapper();
        if(!accList.isEmpty() && accList!=null){
            distributorDetails.distributorName = accList[0].Name; 
            if(accList[0].SAP_Code__c!=null && accList[0].SAP_Code__c!=''){
                distributorDetails.sapCode = accList[0].SAP_Code__c;    
            }
            else{
                distributorDetails.sapCode = '-';    
            }
            distributorDetails.salesOrgName = accList[0].Sales_Org__r.Name;
            distributorDetails.distributorChannelId = accList[0].Distribution_Channel__c;       
            distributorDetails.areaManagerId = accList[0].Region__r.RegionHead__c;  
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
            distributorDetails.salesOrgId =accList[0].Sales_Org__c;
            distributorDetails.divisionId = accList[0].Division__c;
            if(accList[0].Sales_Org__r.currencyIsoCode=='EUR'){
                currencycode='€';
            }
            else{
                currencycode='£';
            }
        }
        if(!SalesAreaDMList.isEmpty() && SalesAreaDMList!=null){
            //distributorDetails.divisionId = SalesAreaDMList[0].Division__c;     
            distributorDetails.priceGroupId = SalesAreaDMList[0].PriceGroupMaster__c; 
            //distributorDetails.salesOrgId =SalesAreaDMList[0].SalesOrg__c;  
        }
        if(!oaList.isEmpty()  && oaList!=null){ 
            if(oaList[0].Net_Overdue__c!=null){
                distributorDetails.netOverdue =oaList[0].Net_Overdue__c; 
            }
        }  
        
        if(!oagList.isEmpty() && oagList!=null){ 
            if(oagList[0].Net_Outstanding__c!=null){
                distributorDetails.paymentOutstanding =oagList[0].Net_Outstanding__c; 
            }
            
        }   
        
        if(!dmList.isEmpty() && dmList!=null){  
            distributorDetails.depot = dmList[0].Depot__r.Location__c;
            distributorDetails.depot = dmList[0].Depot__r.Location__c;  
        }   
        
        if(!ciList.isEmpty() && ciList!=null){ 
            if(ciList[0].Credit_Limit__c!=null){
                distributorDetails.creditLimit = ciList[0].Credit_Limit__c; 
            }
           
            if(ciList[0].Used_Limit__c!=null){
                distributorDetails.creditUsed =ciList[0].Used_Limit__c; 
            }
           
            if(ciList[0].Balance_Limit__c!=null){
                distributorDetails.creditBalance = ciList[0].Balance_Limit__c; 
            }
            
            if(ciList[0].Internal_Limit__c!=null){
                distributorDetails.internalCredit =ciList[0].Internal_Limit__c; 
            }
        }   
        return distributorDetails;  
    } 
    
    public static List<Shipping_Location__c> getShippingLoations(string accountId){
        List<Shipping_Location__c> options = new List<Shipping_Location__c>(); 
        if(String.isNotBlank(accountId) && accountId!=null){
            options=[SELECT Id,OwnerId, Name,Location_Name__c, Distributor__c, City__c, 
                     Region__c, Pincode__c, State__c, Country__c,Shipping_Notes__c,House_Number__c,
                     Sold_To_Party_SAP_Code__c, SAP_Code__c,Billing_Street_1__c,Billing_Street_2__c,
                     Billing_Street_3__c,Billing_Street_4__c,Billing_Street_5__c,Billing_Street_6__c,Expiry_Date__c
                     FROM Shipping_Location__c
                     WHERE Distributor__c =:accountId AND active__c=true AND (Pincode__c!=null OR City__c!=null OR Location_Name__c!=null) ORDER BY Location_Name__c ASC];
        }
        return options;
    }
    
    
    public static List<Inco_term__c> getIncoTerms(string accId){
        List<Inco_term__c> options = new List<Inco_term__c>(); 
        if(String.isNotBlank(accId) && accId!=null){
            Account acc=[SELECT id,sales_org__c 
                         FROM Account 
                         WHERE id =:accId];
            options=[SELECT Id,OwnerId, Name,Sales_Org__c,Combination_Key__c,IncoTerm_Code__c
                     FROM Inco_term__c
                     WHERE Sales_Org__c =:acc.sales_org__c And Active__c=true ORDER BY Name ASC];
        }
        return options;
    }  
    
    @AuraEnabled    
    public static Sales_Order__c getSalesOrder(ID soId) {   
        //Make sure to add new fields that are being input from the UI to this SOQL query otherwise the data will not be inserted.  
        List<Sales_Order__c> soList=new List<Sales_Order__c>();
        if(soId!=null){
        // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022....Added field to query... Purchase_Order_Date__c...   
        soList = [SELECT Id, Name, SAP_Order_Number__c, Order_Status__c,Total_Amount__c,Order_Raise_By__c,PONumber__c,DirectApproved__c,Inco_Term__c,Remarks__c,   
                                       Sold_to_Party__r.Tax_Number_1__c,Ship_To_Party__r.City__c,Payment_Term__r.Payment_Term__c,Ship_To_Party__r.Name,Is_Fixed_Rate_Available_Italy__c,    
                                       Sold_to_Party__r.Name, Sold_to_Party__c, ReloadPaymentTerms__c, OrderSubStatus__c,Ship_To_Party__r.Location_Name__c, 
                                       Sold_to_Party__r.Tax_Number_3__c, Depot_Code__c,Sent_for_Manager_Approval_Mexico__c,Is_Order_FCA_Italy__c,Is_Express_Delivery_Italy__c,  
                                       Sold_to_Party__r.SAP_Code__c,Ship_To_Party__c,Remarks_Long__c,Check_Transport_contribution__c,Order_FCA_Italy__c,    
                                       Sold_to_Party__r.Customer_Group__c,Sent_for_Latam_Director_Approval__c,Editable_Payment_Term_Discount__c,    
                                       Sold_to_Party__r.BillingCity,CreatedById, OwnerId, Owner.Name,CurrencyIsoCode,Sent_for_Director_Approval_Mexico__c,  
                                       Sold_to_Party__r.BillingState,Payment_Term_Discount_Italy__c,Is_Payment_Term_Discount_Approval_Italy__c, Order_Type_Italy__c,Valid_From__c,Valid_To__c,
                                       Payment_Term__c, Sold_to_Party__r.Depot_Code__c,Normal_Delivery_Cost__c,Express_Delivery_Cost__c, 
                                       Sold_to_Party__r.Customer_Region__c,is_Different_Free_Product__c, Purchase_Order_Date__c, 
                                       RecordType.Name, SalesOrgCode__c,Sales_Order__r.Name,Parent_SAP_Order_Number__c,Order_Type_Code__c     
                                       FROM Sales_Order__c  
                                       WHERE Id =: soId];   
        
                    
        }
        return soList[0];   
    }   
    
    public static List<docWrapper> getAllDocuments(String recordId){
        List<docWrapper> doclist=new List<docWrapper>();
        set<id> setofdocId=new set<id>();
        if(recordId!=null){
                  for(ContentDocumentLink condoclink:[SELECT id,contentDocumentId FROM ContentDocumentLink
                                            WHERE LinkedEntityId=:recordId]){
                                                setofdocId.add(condoclink.contentDocumentId); 
                                            }  
        }

        if(setofdocId!=null){
        for(ContentVersion cV:[SELECT Id, ContentDocumentId, Title 
                               FROM ContentVersion WHERE ContentDocumentId IN:setofdocId]){
            docWrapper wrap=new docWrapper();
            wrap.contentVersionId=cV.id;
            string name=cV.Title;
             if(cV.Title.length() > 10){
                name = cV.Title.substring(0, 10);
            }
            wrap.name=name;
            wrap.documentId=cV.ContentDocumentId;
            doclist.add(wrap);
        }
       } 
        return doclist;
    }
    //Get SKU product data
    @AuraEnabled     
    public static List<PriceDetail> getSkuData(String accId,String searchKey){
        List<PriceDetail> priceList = new List<PriceDetail>(); 
        List<PriceBookMaster__c> pbmList =new List<PriceBookMaster__c>();   
        string division='10',distributionchennal=''; 
        List<Account> accList =  Database.query(SalesorderUkController.getQuery('Account') + ' FROM Account WHERE Id = \'' + accId +'\' LIMIT 1');
        system.debug('accList--------->'+accList);
        if(accList!=null){
            if(accList[0].Sales_Org__r.Sales_Org_Code__c=='2031'){
            distributionchennal='20';
        }
        else{
            distributionchennal='40';
        } 
        }
               
            if(searchKey!=null && searchKey!=''){
                String key = '%' + searchKey + '%';
                pbmList =  Database.query(SalesorderUkController.getQuery('PriceBookMaster__c') + ' FROM PriceBookMaster__c WHERE DistributorCustomerCode__c = \'' + accId +'\' AND SKUCode__r.Sales_Org__r.sales_org_code__c = \''+accList[0].Sales_Org__r.Sales_Org_Code__c+'\' AND SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c = \'' + distributionchennal +'\' AND SKUCode__r.Division__r.Division_Code__c=\'10\'' +   
                                          'AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True AND (SKUCode__r.Brand_Name__c LIKE :key OR SKUCode__r.SKU_Code__c LIKE :key OR SKUCode__r.SKU_Description__c LIKE :key)'+   
                                          'ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC,LastModifiedDate ASC ');          
                
            }
            else{
                
                pbmList =  Database.query(SalesorderUkController.getQuery('PriceBookMaster__c') + ' FROM PriceBookMaster__c WHERE DistributorCustomerCode__c = \'' + accId +'\' AND SKUCode__r.Sales_Org__r.sales_org_code__c = \''+accList[0].Sales_Org__r.Sales_Org_Code__c+'\' AND SKUCode__r.Distribution_Channel__r.Distribution_Channel_Code__c = \'' + distributionchennal +'\' AND SKUCode__r.Division__r.Division_Code__c=\'10\' '+   
                                          'AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True '+   
                                          'ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC,LastModifiedDate ASC ');         
            }
        system.debug('list===>'+pbmList);
        set<id> skuIds=new set<id>();
        if(pbmList.size()>0){
            for(PriceBookMaster__c pbObj :pbmList){
                skuIds.add(pbObj.SKUCode__c);
            }
        }
        map<id,Stock_Requirement__c> skuIdVsStockreq =new map<id,Stock_Requirement__c>();
        map<id,decimal> skuIdVsunapprovedstockQ =new map<id,decimal>();
        system.debug('skuIds'+skuIds);
        if(skuIds.size()>0 && skuIds!=null){
            for(Stock_Requirement__c stockReq :[SELECT id,Available_Stock__c, Delivery_Stock__c,
                                                Outgoing_Reservations__c,SKU__c,Stock_In_Transit__c,
                                                Purchase_Order_Stock__c,Unrestricted_Stock__c
                                                FROM Stock_Requirement__c 
                                                WHERE SKU__c IN:skuIds AND (Depot_Code__c =:'UK12' OR Depot_Code__c=:'UK10')])
                                                {
                                                    skuIdVsStockreq.put(stockReq.SKU__c,stockReq);  
           
                                                }
           
            List<string> statusList = new List<string>{'Pending','Open'};
                for(sales_order_line_item__c salesorderline:[Select sku_Name__c,Quantity__c,Sale_Order__c,Sale_Order__r.Order_Status__c 
                                                             FROM sales_order_line_item__c 
                                                             WHERE sku_Name__c IN:skuIds AND Sale_Order__r.Order_Status__c IN:statusList]){
                                                                 decimal Quant=0;
                                                                 if(skuIdVsunapprovedstockQ.containskey(salesorderline.sku_Name__c)){
                                                                     Quant=skuIdVsunapprovedstockQ.get(salesorderline.sku_Name__c)+salesorderline.Quantity__c;
                                                                 }
                                                                 else{
                                                                     Quant=salesorderline.Quantity__c;
                                                                 }
                                                                 skuIdVsunapprovedstockQ.put(salesorderline.sku_Name__c,Quant);
                                                             }
        }
        string seleceddate='';
        
        if(pbmList.size()>0 && pbmList!=null){
            for(PriceBookMaster__c pbObj :pbmList){
                decimal aproxQuant=0;
                PriceDetail pb = new PriceDetail();
                pb.skuId = pbObj.SKUCode__c;    
                pb.skuCategory = pbObj.SKUCode__r.Product_Category__c;  
                pb.skuDescription = pbObj.SKUCode__r.SKU_Description__c;
                pb.skuCode = pbObj.SKUCode__r.SKU_Code__c; 
                pb.skuBrand = pbObj.SKUCode__r.Name;   
                pb.unitCost = pbObj.SKUCode__r.Unit_Cost__c;    
                pb.UOM = pbObj.SKUCode__r.UOM__c; 
                pb.customerCode = pbObj.DistributorCustomerCode__c;//accid
                pb.unitValue = pbObj.Final_Price__c; 
                pb.unitPrice = pbObj.Price__c;
                pb.totalPrice=pbObj.Price__c;
                pb.materialPrice = pbObj.Price__c; //basePrice   
                pb.pricebookId = pbObj.Id;  
                pb.multipleOf = pbObj.SKUCode__r.Multiple_of__c;
                
                if(skuIdVsStockreq.containskey(pbObj.SKUCode__c)){
                    aproxQuant=skuIdVsStockreq.get(pbObj.SKUCode__c).Unrestricted_Stock__c + skuIdVsStockreq.get(pbObj.SKUCode__c).Purchase_Order_Stock__c + skuIdVsStockreq.get(pbObj.SKUCode__c).Stock_In_Transit__c - skuIdVsStockreq.get(pbObj.SKUCode__c).Outgoing_Reservations__c;
                }
                if(skuIdVsunapprovedstockQ.containskey(pbObj.SKUCode__c)){
                    aproxQuant=aproxQuant-skuIdVsunapprovedstockQ.get(pbObj.SKUCode__c);
                }
                pb.approxStock=aproxQuant;
                 BusinessHours bh;
        List<BusinessHours> temp = [SELECT ID, Name, IsDefault, IsActive From BusinessHours 
                                    WHERE Name =: System.Label.UK_Business_Hours];
        if(temp!=null){
            for (BusinessHours b : temp) {
            bh = b;
        } 
        }
        date d=system.today().addDays(1);
        String test = String.valueof(d);
        Date selecteddate=SalesorderUkController.checkholidays(test,bh);
                if(selecteddate!=null){
                     pb.shipDate=String.valueOf(selecteddate);
                }
       
                priceList.add(pb);
            } 
        }
        return priceList;
    }    
    
    @AuraEnabled    
    public static CartWrapper saveOrder(String accountId, String OrderItemString ,String orderType,string OrderId,string currencycode,string objectName){ 
        SalesOrderItem OrderItemList1 = (SalesOrderItem)JSON.deserialize(OrderItemString, SalesOrderItem.class); 
        
        
        CartWrapper cartObj = new CartWrapper();
        try{
            if(objectName=='SalesOrder'){
                if(OrderId!=null && OrderId!=''){
                    cartObj.cartOrderId = OrderId;
                }
            }
            else{
                if(OrderId!=null && OrderId!=''){
                    cartObj.cartOrderId = OrderId;  
                } 
                else{
                    Order__c orderObj = new Order__c();  
                    orderObj.OwnerId = UserInfo.getUserId(); 
                    orderObj.Bill_To_Party__c = accountId;   
                    orderObj.Order_Status__c = 'Draft';  
                    orderObj.CurrencyIsoCode = currencycode;    
                    orderObj.Order_Date__c = System.today(); 
                    // orderObj.Order_Type__c=orderType;
                    
                    /*List<Sales_Org__c> salesOrgList = [Select ID FROM Sales_Org__c   
WHERE Sales_Org_Code__c = '2031'  
AND Country_Code__c = 'UK' LIMIT 1];*/
                    List<Account> accountList = [Select ID,Sales_Org__c 
                                                 FROM Account   
                                                 WHERE id =: accountId LIMIT 1]; 
                    
                    if(!accountList.isEmpty()){ 
                        orderObj.Sales_Org__c = accountList[0].Sales_Org__c; 
                        orderObj.Order_Type__c=[Select Id,SalesOrg__c FROM Order_Type__c WHERE SalesOrg__c=:accountList[0].Sales_Org__c limit 1].Id;
                    }    
                    insert  orderObj;    
                    cartObj.cartOrderId = orderObj.Id;   
                    system.debug('orderObj.Id'+orderObj.Id); 
                    OrderId=orderObj.Id;
                }
                system.debug('OrderItemString : '+OrderItemString);
            } 
            SalesorderUkController.OrderItems(cartObj ,OrderId , OrderItemList1,currencycode,objectName); 
        }
        
        catch(Exception ex){   
            System.debug('ErrLine-->'+ex.getMessage()); 
            cartObj.errorMessage = ex.getMessage()+'+'+ex.getLineNumber()+'+'+ex.getStackTraceString()+'+'+ex.getCause();   
        }  
        
        return cartObj; 
    }   
    
    @AuraEnabled    
    public static void OrderItems(CartWrapper cartObj2 ,string OrderId, SalesOrderItem OrderItemString,string currencycode,string objectName){
        BusinessHours bh;
        string seleceddate='';
        List<BusinessHours> temp = [SELECT ID, Name, IsDefault, IsActive From BusinessHours 
                                    WHERE Name =: System.Label.UK_Business_Hours];
        if(temp!=null){
            for (BusinessHours b : temp) {
            bh = b;
        } 
        }
        /*String test = OrderItemString.shipDate+' 00:00:00';
        DateTime now = DateTime.valueOfGmt(test);
        seleceddate=string.valueOf(now.format('EEEE'));
        system.debug('day=='+now.format('EEEE'));
        Boolean isHoliday = !BusinessHours.isWithin(bh.Id, now);*/
        if(objectName=='SalesOrder'){
            Integer i = 0;  
            Integer j= 0;
            Integer k = 0;
            sales_order__c salesorderobj=[SELECT id,SalesOrg__c,Depot__c,CurrencyIsoCode FROM Sales_order__c WHERE id=:OrderId LIMIT 1];
            Integer counter = [SELECT COUNT() FROM sales_order_line_item__c WHERE sale_order__c=:OrderId LIMIT 1];
            sales_order_line_item__c salesoliobj=new sales_order_line_item__c();
            if(counter>0){
               salesoliobj=[SELECT id,Item_Number__c,Sequence_Number__c FROM sales_order_line_item__c
                                                  WHERE sale_order__c=:OrderId Order By Item_Number__c DESC LIMIT 1];  
            }
            if(salesoliobj!=null){
                if(salesoliobj.Item_Number__c!=null){
                    i=integer.valueof(salesoliobj.Item_Number__c);
                    k=integer.valueof(salesoliobj.Item_Number__c);
                }
            }
            i=i+10;
            k=k+1;
            system.debug('k====>'+k);  
            List<sales_order_line_item__c> oliList = new List<sales_order_line_item__c>();   
            system.debug('soli'+OrderId);  
            system.debug('OrderItemString=='+OrderItemString);  
            sales_order_line_item__c oliObj = new sales_order_line_item__c();   
            oliObj.sale_Order__c = OrderId; 
            oliObj.SKU_Name__c = OrderItemString.skuId;
            oliObj.UOM__c =OrderItemString.UOM; 
            oliObj.PriceBookMaster__c= OrderItemString.pricebookId;
            oliObj.Price__c =OrderItemString.netPrice;
            /* -------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ---------------- */
            if(String.isNotBlank(OrderItemString.deliveryDate)){
                oliObj.Delivery_Date__c = Date.valueof(OrderItemString.deliveryDate);
            }
            else if(String.isBlank(OrderItemString.deliveryDate)){
                oliObj.Delivery_Date__c = null;
            }
            /* -------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ----------------- */
            try{
                date d =date.valueOf(OrderItemString.shipDate);
                String test = String.valueof(d);
                Date selecteddate=SalesorderUkController.checkholidays(test,bh);
                if(selecteddate!=null){
                     oliObj.Shipping_Date__c=selecteddate;
                }
            }   
            catch(Exception ex){    
                system.debug('catch'+ex.getMessage());  
                //oliObj.Shipping_Date__c = Date.parse(OrderItemString.shipDate);
                date d =date.parse(OrderItemString.shipDate);
                String test = String.valueof(d);
                Date selecteddate=SalesorderUkController.checkholidays(test,bh);
                if(selecteddate!=null){
                     oliObj.Shipping_Date__c=selecteddate;
                }
            }   
            oliObj.multipleOf__c =OrderItemString.multipleOf;   
            oliObj.CurrencyIsoCode =salesorderobj.CurrencyIsoCode;  
            oliObj.Quantity__c = OrderItemString.qty;   
            oliObj.FinalPrice__c = OrderItemString.unitValue;   
            oliObj.Net_Price__c =OrderItemString.materialPrice;//basePrice  
            oliObj.Comment__c=OrderItemString.personalNotes;// Comment
            oliObj.Per_Unit_Discount__c=OrderItemString.discountvalue;// CR110
            oliObj.Item_Number__c = i; 
            oliObj.Sequence_Number__c = k;
            oliObj.Sales_Org__c = salesorderobj.SalesOrg__c;
            oliObj.DepotDepot__c = salesorderobj.Depot__c;
            oliList.add(oliObj);  
            if(!oliList.isEmpty() && oliList!=null){  
                insert oliList; 
                OrderItemString.oliId = oliList[0].Id;  
                cartObj2.soitemObj =OrderItemString;    
            } 
        }
        else{
            List<OrderLineItem__c> oliList = new List<OrderLineItem__c>();   
            system.debug('soli'+OrderId);  
            system.debug('OrderItemString=='+OrderItemString);  
            OrderLineItem__c oliObj = new OrderLineItem__c();   
            oliObj.Order__c = OrderId; 
            oliObj.SKU_Name__c = OrderItemString.skuId;
            oliObj.UOM__c =OrderItemString.UOM; 
            // oliObj.Price__c =OrderItemString.materialPrice;
            oliObj.Price_Book_Master__c= OrderItemString.pricebookId;
            oliObj.Price__c =OrderItemString.netPrice;

            /* ------------------ Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ---------------- */
            if(String.isNotBlank(OrderItemString.deliveryDate)){
                oliObj.Delivery_Date__c = Date.valueof(OrderItemString.deliveryDate);
            }
            else if(String.isBlank(OrderItemString.deliveryDate)){
                oliObj.Delivery_Date__c = null;
            }
            /* ------------------ End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 --------------------- */
            try{
                //oliObj.Shipping_Date__c=Date.valueOf(OrderItemString.shipDate);
                date d =date.valueOf(OrderItemString.shipDate);
                String test = String.valueof(d);
                Date selecteddate=SalesorderUkController.checkholidays(test,bh);
                if(selecteddate!=null){
                     oliObj.Shipping_Date__c=selecteddate;
                }
            }   
            catch(Exception ex){    
                system.debug('catch'+ex.getMessage());  
                //oliObj.Shipping_Date__c = Date.parse(OrderItemString.shipDate);
                date d =date.parse(OrderItemString.shipDate);
                String test = String.valueof(d);
                Date selecteddate=SalesorderUkController.checkholidays(test,bh);
                if(selecteddate!=null){
                     oliObj.Shipping_Date__c=selecteddate;
                }
            }   
            oliObj.multipleOf__c =OrderItemString.multipleOf;   
            oliObj.CurrencyIsoCode =currencycode;  
            oliObj.Quantity__c = OrderItemString.qty;   
            oliObj.FinalPrice__c = OrderItemString.unitValue;   
            oliObj.Net_Price__c =OrderItemString.materialPrice;//basePrice  
            oliObj.Comment__c=OrderItemString.personalNotes;// Comment
            oliObj.Per_Unit_Discount_UK__c=OrderItemString.discountvalue;// CR110
            oliList.add(oliObj);  
            system.debug('oliList : '+oliList); 
            if(!oliList.isEmpty() && oliList!=null){  
                insert oliList; 
                OrderItemString.oliId = oliList[0].Id;  
                cartObj2.soitemObj =OrderItemString;    
                system.debug('OrderItemString.oliId'+OrderItemString.oliId);    
            } 
        }  
    } 
    public static String cleanDate(String theDate){
        String [] s = theDate.split('/');
        String newDate= '';
        if(s[0].length() == 1){
            newDate = '0'+s[0];
        }else{
            newDate = s[0];
        }
        newDate = s[1]+'/'+newDate+'/'+s[2];
        return newDate;
    }
    
    @AuraEnabled   
    public static CartWrapper updateOrderLineItems(String orderItemListString,string objectName){    
        CartWrapper updatedCart = new CartWrapper();    
        try{    
            SalesOrderItem item = (SalesOrderItem)JSON.deserialize(orderItemListString, SalesOrderItem.class); 
            BusinessHours bh;
            string seleceddate='';
            List<BusinessHours> temp = [SELECT ID, Name, IsDefault, IsActive From BusinessHours 
                                        WHERE Name =: System.Label.UK_Business_Hours];
            if(temp!=null){
                for (BusinessHours b : temp) {
                    bh = b;
                } 
            }
            //Date txnDate = date.valueof(OrderItemList1.shipDate);
           /* String test = item.shipDate+' 00:00:00';
            DateTime now = DateTime.valueOfGmt(test);
            seleceddate=string.valueOf(now.format('EEEE'));
            system.debug('day=='+now.format('EEEE'));
            System.debug('dt---'+now);
            //Datetime now = Datetime.newInstance(txnDate.year(), txnDate.month(), txnDate.day(), 0, 0, 0);        
            Boolean isHoliday = !BusinessHours.isWithin(temp[0].Id, now);*/
            
            if(objectName=='SalesOrder'){
                List<Sales_Order_Line_Item__c> oliList = new List<Sales_Order_Line_Item__c>();  
                Sales_Order_Line_Item__c oliObj = new Sales_Order_Line_Item__c();  
                oliObj.Id = item.oliId; 
                oliObj.Quantity__c = item.qty;  
                oliObj.FinalPrice__c = item.unitValue;//    
                oliObj.Price__c =item.netPrice; 
                oliObj.Comment__c=item.personalNotes;// Comment
                oliObj.Per_Unit_Discount__c=item.discountvalue;
                system.debug('oliObj'+oliObj);
                system.debug('oliObj'+oliObj.Quantity__c);

                /* ----------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 -------------- */
                if(String.isNotBlank(item.deliveryDate)){
                    oliObj.Delivery_Date__c = Date.valueof(item.deliveryDate);
                }
                else if(String.isBlank(item.deliveryDate)){
                    oliObj.Delivery_Date__c = null;
                }
                /* ---------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ----------------- */
                try{  
                    date d =date.valueOf(item.shipDate);
                    String test = String.valueof(d);
                    Date selecteddate=SalesorderUkController.checkholidays(test,bh);
                    if(selecteddate!=null){
                       oliObj.Shipping_Date__c = selecteddate;   
                    }
                    
                }   
                catch(Exception ex){    
                    system.debug('catch'+ex.getMessage());  
                 date d =date.parse(item.shipDate);
                 String test = String.valueof(d);
                 Date selecteddate=SalesorderUkController.checkholidays(test,bh);
                 if(selecteddate!=null){
                       oliObj.Shipping_Date__c = selecteddate;   
                    }    
                }   
                oliList.add(oliObj);    
                
                if(!oliList.isEmpty()){ 
                    update oliList; 
                }
                
            }
            else{
                List<OrderLineItem__c> oliList = new List<OrderLineItem__c>();  
                // for(SalesOrderItem item: OrderItemList){    
                system.debug('item'+item);  
                OrderLineItem__c oliObj = new OrderLineItem__c();  
                oliObj.Id = item.oliId; 
                oliObj.Quantity__c = item.qty;  
                oliObj.FinalPrice__c = item.unitValue;//    
                oliObj.Price__c =item.netPrice; 
                oliObj.Comment__c=item.personalNotes;// Comment
                oliObj.Per_Unit_Discount_UK__c=item.discountvalue;

                /* ------------------ Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 -------------- */
                if(String.isNotBlank(item.deliveryDate)){
                    oliObj.Delivery_Date__c = Date.valueof(item.deliveryDate);
                }
                else if(String.isBlank(item.deliveryDate)){
                    oliObj.Delivery_Date__c = null;
                }
                /* ----------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ----------------- */
                try{
                    date d =date.valueOf(item.shipDate);
                    String test = String.valueof(d);
                    Date selecteddate=SalesorderUkController.checkholidays(test,bh);
                    if(selecteddate!=null){
                       oliObj.Shipping_Date__c = selecteddate;   
                    }
                }   
                catch(Exception ex){    
                    system.debug('catch'+ex.getMessage());  
                     date d =Date.parse(item.shipDate);
                    String test = String.valueof(d);
                    Date selecteddate=SalesorderUkController.checkholidays(test,bh);
                    if(selecteddate!=null){
                       oliObj.Shipping_Date__c = selecteddate;   
                    }
                }   
                oliList.add(oliObj);    
                
                if(!oliList.isEmpty() && oliList!=null){ 
                    update oliList; 
                }
            }
        }catch(Exception ex){   
            System.debug('ErrLine-->'+ex.getMessage()); 
            updatedCart.errorMessage = ex.getMessage();   
            // ApexLog.exceptionHandler(ex, orderId, accountId);    
        }
        return updatedCart; 
    }   
    
    @AuraEnabled   
    public static CartWrapper getCartOrderItems(ID recordId,string objectName) { 
        CartWrapper cartObj = new CartWrapper(); 
        decimal amount=0;
        if(objectName=='SalesOrder'){
            cartObj = getsalesorderLineItems(recordId); 
        }
        else{
            Order__c ordObj =new Order__c();    
            String orderId =''; 
            Boolean isChange =false;  
            List<Order__c> recentOrderList =new List<Order__c>();
            if(recordId!=null){
                recentOrderList =  [SELECT Id, Name, Bill_To_Party__c, Order_Date__c,Net_Amount__c,   
                                               Order_Status__c, OwnerId,Gross_Net__c, Order_Type__c    
                                               FROM Order__c WHERE Order_Status__c='Draft'  
                                               AND Bill_To_Party__c =: recordId Order By CreatedDate DESC LIMIT 1];    
            
            }
            if(!recentOrderList.isEmpty() && recentOrderList!=null){             
                ordObj = recentOrderList[0];    
                orderId = ordObj.Id;    
                cartObj.grossNetPrice =recentOrderList[0].Gross_Net__c; 
                cartObj.orderType = recentOrderList[0].Order_Type__c;
                
            }   
            decimal QuantityLitters=0,QuantityKgs=0,Totaldiscount=0;
            // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 .....added one field to quesry....Delivery_Date__c...
            List<OrderLineItem__c> oliList = [SELECT Id, Name, CurrencyIsoCode, SKU_Name__r.SKU_Description__c,Discount__c,multipleOf__c,Net_Invoice_Price__c,Transport_contribution2__c,  
                                              Order__c, UOM__c, SKU_Name__c,Net_Price__c,FinalPrice__c,Shipping_Date__c,Price_Book_Master__c, 
                                              SKU_Name__r.Name, Quantity__c, Price__c,Comment__c,Per_Unit_Discount_UK__c,    
                                              SKU_Name__r.Brand_Name__c,SKU_Name__r.SKU_Code__c, Delivery_Date__c 
                                              FROM OrderLineItem__c 
                                              WHERE Order__c=:orderId Order By CreatedDate];
            if(oliList!=null && !oliList.isEmpty()){
                 for(OrderLineItem__c oli:oliList){
                Totaldiscount=Totaldiscount+oli.Per_Unit_Discount_UK__c;
                cartObj.Totaldiscount=Totaldiscount;
                amount=amount+oli.Price__c;
                cartObj.Net_Amount=amount;
                if(oli.UOM__c=='L'){
                    QuantityLitters=QuantityLitters+oli.Quantity__c;
                }
                else if(oli.UOM__c=='KG'){
                    QuantityKgs=QuantityKgs+oli.Quantity__c; 
                }
                
            }
            }
           
            if(QuantityLitters!=0){
                cartObj.Net_QuantityLiters=QuantityLitters+'L';
            }
            if(QuantityKgs!=0){
                cartObj.Net_QuantityKgs=QuantityKgs+'KG';
            }
            List<SalesOrderItem> itemList = new List<SalesOrderItem>();   
            system.debug('oliList: '+oliList);
            if(oliList!=null && !oliList.isEmpty()){
            for(OrderLineItem__c oliObj: oliList){   
                SalesOrderItem item = new SalesOrderItem(); 
                item.skuId = oliObj.SKU_Name__c;    
                item.skuName = oliObj.SKU_Name__r.SKU_Description__c;  
                item.skucode = oliObj.SKU_Name__r.SKU_Code__c; 
                item.unitValue = oliObj.FinalPrice__c;//estimated final price   
                item.qty = oliObj.Quantity__c;  
                item.materialPrice = oliObj.Net_Price__c; //base price  
                item.UOM = oliObj.UOM__c;   
                item.multipleOf = oliObj.multipleOf__c;
                if(oliObj.Shipping_Date__c!=null ){
                    date shipdate= oliObj.Shipping_Date__c;
                    String dTXT = shipdate.format();
                    item.shipDateformatted = cleanDate(dTXT);
                    item.shipDate = String.valueOf(oliObj.Shipping_Date__c);
                }
                /* -------------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------------- */
                if(oliObj.Delivery_Date__c != null){
                    item.deliveryDate = String.valueof(oliObj.Delivery_Date__c);
                }
                else{
                    item.deliveryDate = '';
                }
                /* ----------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 --------------------- */
                //item.shipDate = String.valueOf(oliObj.Shipping_Date__c);    
                item.netPrice = oliObj.Price__c ;   
                item.oliId =oliObj.Id;
                if(oliObj.Comment__c!='' && oliObj.Comment__c!=null){
                    item.personalNotes=oliObj.Comment__c;
                }
                else{
                    item.personalNotes='';
                }
                item.discountvalue=oliObj.Per_Unit_Discount_UK__c;
                item.pricebookId=oliObj.Price_Book_Master__c;
                itemList.add(item); 
            } 
            } 
            cartObj.cartOrderId =orderId;   
            cartObj.soiList = itemList;
        }
        return cartObj; 
    }
    
    public static CartWrapper getsalesorderLineItems(string recId){
        CartWrapper cartObj = new CartWrapper();
        sales_Order__c ordObj =new sales_Order__c();
        List<sales_Order__c> recentOrderList =  [SELECT Id, Name, Bill_To_Party__c, Order_Date__c,Net_Amount__c,   
                                                 Order_Status__c, OwnerId, Order_Type_lk__c    
                                                 FROM sales_Order__c WHERE id =:recId Order By CreatedDate DESC LIMIT 1];    
        
        if(!recentOrderList.isEmpty() && recentOrderList!=null){             
            ordObj = recentOrderList[0];    
            // orderId = ordObj.Id;    
            //cartObj.grossNetPrice =recentOrderList[0].Gross_Net__c; 
            cartObj.orderType = recentOrderList[0].Order_Type_lk__c;
            
        } 
        decimal QuantityLitters=0,QuantityKgs=0,Totaldiscount=0,netamount=0;
        // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022...added field to query...Delivery_Date__c...
        List<Sales_Order_Line_Item__c> oliList = [SELECT Id, Name, CurrencyIsoCode, SKU_Name__r.SKU_Description__c,Discount__c,multipleOf__c,Net_Invoice_Price__c,Transport_contribution2__c,  
                                                  Sale_Order__c, UOM__c, SKU_Name__c,Net_Price__c,FinalPrice__c,Shipping_Date__c,PriceBookMaster__c, 
                                                  SKU_Name__r.Name, Quantity__c, Price__c,Comment__c,Per_Unit_Discount__c,    
                                                  SKU_Name__r.Brand_Name__c,SKU_Name__r.SKU_Code__c, Delivery_Date__c
                                                  FROM Sales_Order_Line_Item__c 
                                                  WHERE Sale_Order__c=:recId Order By CreatedDate];
        
        List<SalesOrderItem> itemList = new List<SalesOrderItem>();   
        if(oliList!=null && !oliList.isEmpty()){
        for(Sales_Order_Line_Item__c oliObj:oliList){
            netamount=netamount+oliObj.Price__c;
            cartObj.Net_Amount=netamount;
            if(oliObj.Per_Unit_Discount__c!=null){
                Totaldiscount=Totaldiscount+oliObj.Per_Unit_Discount__c; 
            }
            cartObj.Totaldiscount=Totaldiscount;
            if(oliObj.UOM__c=='L'){
                QuantityLitters=QuantityLitters+oliObj.Quantity__c;
            }
            else if(oliObj.UOM__c=='KG'){
                QuantityKgs=QuantityKgs+oliObj.Quantity__c; 
            }
            SalesOrderItem item = new SalesOrderItem(); 
            item.skuId = oliObj.SKU_Name__c;    
            item.skuName = oliObj.SKU_Name__r.SKU_Description__c;  
            item.skucode = oliObj.SKU_Name__r.SKU_Code__c; 
            item.unitValue = oliObj.FinalPrice__c;//estimated final price   
            item.qty = oliObj.Quantity__c;  
            item.materialPrice = oliObj.Net_Price__c; //base price  
            item.UOM = oliObj.UOM__c;   
            item.multipleOf = oliObj.multipleOf__c;
            if(oliObj.Shipping_Date__c!=null ){
                date shipdate= oliObj.Shipping_Date__c;
                String dTXT = shipdate.format();
                item.shipDateformatted = cleanDate(dTXT);
                item.shipDate = String.valueOf(oliObj.Shipping_Date__c);
            }
            //item.shipDate = String.valueOf(oliObj.Shipping_Date__c);    
            item.netPrice = oliObj.Price__c ;   
            item.oliId =oliObj.Id;
            if(oliObj.Comment__c!='' && oliObj.Comment__c!=null){
                item.personalNotes=oliObj.Comment__c;
            }
            else{
                item.personalNotes='';
            }
            item.discountvalue=oliObj.Per_Unit_Discount__c;
            item.pricebookId=oliObj.PriceBookMaster__c;

            /* -------------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------------- */
            if(oliObj.Delivery_Date__c != null){
                item.deliveryDate = String.valueof(oliObj.Delivery_Date__c);
            }
            else{
                item.deliveryDate = '';
            }
            /* ------------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ----------------- */
            itemList.add(item); 
        }
        }
        if(QuantityLitters!=0){
            cartObj.Net_QuantityLiters=QuantityLitters+'L';
        }
        if(QuantityKgs!=0){
            cartObj.Net_QuantityKgs=QuantityKgs+'KG';
        }
        
        cartObj.cartOrderId =recId;   
        cartObj.soiList = itemList; 
        return cartObj; 
    }
    @AuraEnabled    
    public static CartWrapper deleteOrderLineItem(String oliId,String orderId,String itemsLength,boolean isall,string objectName){
        //string objectName='';
        CartWrapper cartObj = new CartWrapper();
        try{
            System.debug('oliId-->'+oliId);
            if(objectName=='SalesOrder'){
                if(isall){
                    delete[Select id,Sale_Order__c from Sales_Order_Line_Item__c where Sale_Order__c=:orderId];
                    // delete[Select id from Sales_Order__c where id=:orderId]; 
                }
                else{
                    delete[Select id from Sales_Order_Line_Item__c where id=:oliId];
                    if(itemsLength=='1'){
                        //   delete[Select id from Sales_Order__c where id=:orderId]; 
                    }  
                }
            }
            else{
                if(isall){
                    delete[Select id,order__c from OrderLineItem__c where order__c=:orderId];
                    delete[Select id from Order__c where id=:orderId]; 
                }
                else{
                    delete[Select id from OrderLineItem__c where id=:oliId];
                    if(itemsLength=='1'){
                        delete[Select id from Order__c where id=:orderId]; 
                    }  
                }
            }
        }
        catch(Exception ex){    
            System.debug('ErrLine-->'+ex.getMessage()); 
            cartObj.errorMessage = System.Label.Error_While_Deleting_Item_Please_Contact_System_Administrator;  
        } 
        
        return cartObj;
        
    }
    
    @AuraEnabled    // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022...added method parameter...String poDate...
    public static CartWrapper saveSalesOrder(String recordId,String distributorData,String orderdata,String orderStatus,string incotermid,string shippingaddress,string remark,string ponumber,string podocument,boolean isapprovalreq,string currencycodename,string objectName,String poDate){
        DistributorWrapper distributor = (DistributorWrapper)JSON.deserialize(distributorData, DistributorWrapper.class);
        CartWrapper cartdata = (CartWrapper)JSON.deserialize(orderdata, CartWrapper.class);
        docWrapper[] docwrapper = (docWrapper[])JSON.deserialize(podocument, docWrapper[].class);
        Sales_Order__c salesorder=new Sales_Order__c();
        /* ------------ Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ----- */
        if(poDate == ''){
            salesorder.Purchase_Order_Date__c = null;
        }
        else{
            salesorder.Purchase_Order_Date__c = Date.valueof(poDate);
        }
        /* ------------ End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ----- */

        if(objectName=='SalesOrder'){
            salesorder.Id=recordId;
            salesorder.Inco_Term__c=incotermid;
            if(shippingaddress!='' && shippingaddress!=null ){
                salesorder.Ship_To_Party__c=shippingaddress;
            }
            
            salesorder.Remarks__c=remark;
            salesorder.PONumber__c=ponumber;
            
            user us=[SELECT id,ManagerId,UserRoleId ,UserRole.Name  FROM User where id =:UserInfo.getUserId()];
            if(orderStatus!='Draft'){
                if(isapprovalreq){
                    if(us.UserRole.Name!='Commercial Manager UK/IE' || us.UserRole.Name!='Country Manager UK/IE'){
                        salesorder.Order_Status__c='Pending';
                    }
                    else{
                        salesorder.Order_Status__c='Open';
                    }
                    
                }else{
                    salesorder.Order_Status__c='Open';
                }
                if(us.ManagerId!=null){
                    salesorder.TerritoryManager__c =us.ManagerId;
                }
            }
            if(salesorder!=null){
               update salesorder;
            }
            
        }
        else{
            salesorder.Sales_Org_lk__c=distributor.salesOrgId;
            salesorder.Order_Type_lk__c=cartdata.orderType;
            salesorder.Inco_Term__c=incotermid;
            salesorder.Division_lk__c=distributor.divisionId;
            salesorder.Distribution_Channel_lk__c=distributor.distributorChannelId;
            salesorder.Depot__c=[SELECT id FROM depot__c where Depot_Code__c ='UK12' LIMIT 1].id;
            if(shippingaddress!=null && shippingaddress!=''){
                salesorder.Ship_To_Party__c=shippingaddress;
            }
            
            salesorder.Sold_to_Party__c=recordId;
            salesorder.Remarks__c=remark;
            salesorder.PONumber__c=ponumber;
            salesorder.Order_Date__c=System.today();
            salesorder.CurrencyIsoCode = currencycodename; 
            salesorder.CreatedFrom__c = 'SFDC';
            salesorder.Order_Status__c=orderStatus;
            user us=[SELECT id,ManagerId,UserRoleId,UserRole.Name  FROM User where id =:UserInfo.getUserId()];
            system.debug('us.UserRole.Name==='+us.UserRole.Name);
            if(orderStatus!='Draft'){
                system.debug('orderStatus==='+orderStatus);
                if(isapprovalreq){
                    system.debug('isapprovalreq==='+isapprovalreq);
                    if(us.UserRole.Name!='Commercial Manager UK/IE' && us.UserRole.Name!='Country Manager UK/IE'){
                        salesorder.Order_Status__c='Pending';
                        system.debug('Pending===');
                    }
                    else{
                        salesorder.Order_Status__c='Open';
                        system.debug('Open===');
                    }
                }else{
                    salesorder.Order_Status__c='Open';
                }
            }
          
            if(us.ManagerId!=null){
                salesorder.TerritoryManager__c =us.ManagerId;
            }
            if(salesorder!=null){
                insert salesorder;
            }
            
            system.debug('us.UserRole.Name==='+salesorder);
        }
        List<ContentDocumentLink> listofCV=new List<ContentDocumentLink>();
        if(docwrapper!=null && !docwrapper.isEmpty()){
            for(docWrapper doc: docwrapper){
                if(doc.contentVersionId!='' && doc.contentVersionId!=null){
                    Delete [SELECT Id, LinkedEntityId, ContentDocumentId, IsDeleted, SystemModstamp, ShareType, Visibility 
                            FROM ContentDocumentLink where LinkedEntityId=:recordId];
                    
                    ContentDocumentLink contentdoclink=new ContentDocumentLink();
                    contentdoclink.contentDocumentId= doc.documentId;
                    contentdoclink.LinkedEntityId=salesorder.id;
                    listofCV.add(contentdoclink);
                }
                else{
                    ContentVersion cv = new ContentVersion();
                    cv.VersionData = EncodingUtil.base64Decode(doc.base64);
                    cv.Title = doc.name;
                    cv.PathOnClient = doc.name;
                    try {
                        insert cv;
                    } catch(DMLException e) {
                        System.debug(e);
                    }
                    ContentDocumentLink contentdoclink=new ContentDocumentLink();
                    contentdoclink.ContentDocumentId = [
                        SELECT ContentDocumentId 
                        FROM ContentVersion 
                        WHERE Id =: cv.id
                    ].ContentDocumentId;
                    //contentdoclink.contentDocumentId= cv.ContentDocumentId;
                    contentdoclink.LinkedEntityId=salesorder.id;
                    contentdoclink.ShareType = 'V';
                    listofCV.add(contentdoclink);
                }
                
            }
            if(listofCV!=null && !listofCV.isEmpty()){
                insert listofCV;
            }
        }
        
        if(objectName!='SalesOrder'){
            if(cartdata.cartOrderId!=null && cartdata.cartOrderId!=''){
                Order__c orderObj = new Order__c(); 
                orderObj.id =cartdata.cartOrderId;   
                orderObj.Order_Status__c ='Approved';   
                update orderObj;
            }
            SalesorderUkController.saveOrderItems(salesorder,cartdata.soiList);
        }
        
        CartWrapper orderwrap = new CartWrapper();
        orderwrap.cartOrderId=salesorder.Id;
        
        return orderwrap;
    }
    
    public static List<SalesOrderItem> saveOrderItems(Sales_Order__c salesorderobj, List<SalesOrderItem> salesOrderItemList){ 
        List<SalesOrderItem> salesorderList=new List<SalesOrderItem>();
        List<Sales_Order_Line_Item__c> salesorderListinsert=new List<Sales_Order_Line_Item__c>();
        Integer i = 0;  
        Integer j= 0;
        Integer k = 0;
        for(SalesOrderItem item: salesOrderItemList){ 
            k = k+1;
            i = i+10; 
            Sales_Order_Line_Item__c soiObj = new Sales_Order_Line_Item__c();
            soiObj.Item_Number__c = i;  
            soiObj.Sale_Order__c = salesorderobj.Id; 
            soiObj.SKU_Name__c = item.skuId;    
            soiObj.CurrencyIsoCode = salesorderobj.CurrencyIsoCode;
            soiObj.Sequence_Number__c = k;
            soiObj.Comment__c=item.personalNotes;
            soiObj.UOM__c = item.UOM;   
            soiObj.Quantity__c = item.qty;
            soiObj.Price__c = item.netPrice; 
            soiObj.multipleOf__c =item.multipleOf; 
            soiObj.Net_Price__c =item.materialPrice;
            soiObj.Per_Unit_Discount__c=item.discountvalue;

            /* --------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------------- */
            if(String.isNotBlank(item.deliveryDate)){
                soiObj.Delivery_Date__c = Date.valueof(item.deliveryDate);
            }
            else if(String.isBlank(item.deliveryDate)){
                soiObj.Delivery_Date__c = null;
            }
            /* ---------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 -------------- */
            try{    
                soiObj.Shipping_Date__c = Date.valueOf(item.shipDate);  
            }   
            catch(Exception ex){    
                system.debug('catch'+ex.getMessage());  
                soiObj.Shipping_Date__c = Date.parse(item.shipDate);    
            }   
            soiObj.FinalPrice__c = item.unitValue; 
            soiObj.Sales_Org__c = salesorderobj.SalesOrg__c;
            soiObj.DepotDepot__c = salesorderobj.Depot__c; 
            soiObj.PriceBookMaster__c=item.pricebookId;
            salesorderListinsert.add(soiObj);
        }
        if (salesorderListinsert!=null && !salesorderListinsert.isEmpty()){
            insert salesorderListinsert;
        }
        return salesorderList;
    }
    
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
        if(processList!=null && !processList.isEmpty()){
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
        }
        if(recordId!=null && recordId !=''){
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
        }
          
        beforeSort = approvalResultForObject.listOfStepsAudit;  
        sortAuditHistory(); 
        approvalResultForObject.listOfStepsAudit = afterSort;   
        approvalResultForObject.recordId = recordId;    
        return approvalResultForObject; 
    } 
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
            system.debug('beforeSort'+beforeSort[i]);
            if(beforeSort[i].createdDate > dt){ // if decending 
               
                dt = beforeSort[i].createdDate; 
                mini = i;   
            }   
        }   
        
        afterSort.add(beforeSort[mini]);    
        beforeSort.remove(mini);    
    }   
    
    public static date checkholidays(string orderdate,BusinessHours bh){
        Boolean isHoliday=false,isHoliday2=false;
        date finalordre=Date.valueOf(orderdate);
        do {
            String test = finalordre+' 00:00:00';
            DateTime now = DateTime.valueOfGmt(test);
            system.debug('day=='+now.format('EEEE'));
            isHoliday = !BusinessHours.isWithin(bh.Id, now);
            isHoliday2 = !BusinessHours.isWithin(bh.Id, now);
            if(now.format('EEEE')=='Sunday'){
                isHoliday=true;
                finalordre=finalordre.addDays(1);
            }
            else if(now.format('EEEE')=='Saturday'){
                 isHoliday=true;
                 finalordre= finalordre.addDays(2);
            }
           if(isHoliday2){
                finalordre=finalordre.addDays(1);   
            }
            system.debug('isHoliday'+isHoliday);
        } while (isHoliday);
        
        system.debug('isHoliday'+finalordre);
        return finalordre;
    } 
    
    public static String getQuery(string Objname){
        String sQuery='';
        if(Objname == 'Account'){
            sQuery= 'SELECT Id, Name, BillingCity,Payment_Term_Code__C, BillingCountry, RegionalManager__c,'+    
                ' BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, Sales_Org__r.Name,Billing_Street_6__c,Sales_Org__r.currencyIsoCode,Sales_Org__r.Sales_Org_Code__c, '+ 
                'OwnerId, SAP_Code__c, Sales_Org__c, Distribution_Channel__c, Division__c,Region__r.RegionHead__c,Billing_Street_4__c,Billing_Street_5__c,'+  
                'Order_Type__c, Order_Block__c,Sales_Org_Code__c, Status__c,Payment_Terms__c,Billing_Street_1__c,Billing_Street_2__c,Billing_Street_3__c,'+   
                'PriceGroupCode__c,Sales_District__c,Sales_District__r.Sales_Director__c,Sales_District__r.Latam_Director__c,Depot_Code__c ';
        }
        else if (Objname == 'PriceBookMaster__c'){
            sQuery= 'SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name,'+     
                'SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c,'+ 
                'DepotCode__c, DepotCode__r.Location__c,SKUCode__r.UOM__c, Price__c,SKUCode__r.Product_Category__c,'+  
                'UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Unit_Cost__c,'+  
                'SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,'+  
                'SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c ';
        }
        return sQuery;
    } 
    
    
    //All field wrapper
    public class AllFieldsdata{ 
        @AuraEnabled public DistributorWrapper DistributorData;
        @AuraEnabled public List<Shipping_Location__c> ShippingLocList;
        @AuraEnabled public List<Inco_Term__c> IncoTermList;
        @AuraEnabled public Sales_order__c SalesOrdersList;
        @AuraEnabled public List<docWrapper> documentList;
        @AuraEnabled public ApprovalList generatedata;
        /* ----------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------------- */
        @AuraEnabled public Boolean isPORequired;
        @AuraEnabled public Boolean showPODate;
        @AuraEnabled public Boolean showDeliveryDate;
        @AuraEnabled public Boolean isDeliveryRequired;
        /* ---------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ----------------- */

        public AllFieldsdata(){   
            DistributorData = new DistributorWrapper(); 
            ShippingLocList = new List<Shipping_Location__c>(); 
            IncoTermList= new List<Inco_Term__c>();
            SalesOrdersList=new Sales_order__c();
            documentList=new List<docWrapper>();
            generatedata=new ApprovalList();
            /* ----------------- Start SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------------ */
            showPODate = false;
            isPORequired = false;
            showDeliveryDate = false;
            isDeliveryRequired = false;
            /* ---------------- End SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022 ------------------ */
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
        @AuraEnabled   public Decimal netOverdue;    
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
        @AuraEnabled   public Decimal internalCredit;
       
        
    }
    
    public class PriceDetail{   
        @AuraEnabled public String skuId;   
        @AuraEnabled public String skuDescription;  
        @AuraEnabled public String skuCategory; 
        @AuraEnabled public String UOM; 
        @AuraEnabled public String customerCode;    
        @AuraEnabled public String shipDate;
        @AuraEnabled public String shipDateformatted;
        @AuraEnabled public Decimal unitCost;   
        @AuraEnabled public Decimal materialPrice;  
        @AuraEnabled public String pricebookId; 
        @AuraEnabled public Decimal qty;    
        @AuraEnabled public String skuCode; 
        @AuraEnabled public String skuBrand;    
        @AuraEnabled public Decimal multipleOf; 
        @AuraEnabled public String orderItemId; 
        @AuraEnabled public Decimal balanceQty; 
        @AuraEnabled public Decimal days;   
        @AuraEnabled public Decimal totalValue; 
        @AuraEnabled public Decimal itemNo; 
        @AuraEnabled public Decimal unitValue;
        @AuraEnabled public Decimal unitPrice;
        @AuraEnabled public Decimal totalPrice;
        @AuraEnabled public Decimal approxStock;
        
        public PriceDetail(){   
            UOM = 'N/A';    
            itemNo = 0; 
            skuId = ''; 
            customerCode ='';   
            skuDescription = '';    
            skuBrand = '';  
            skuCategory = '';   
            shipDate = ''; 
            shipDateformatted='';
            unitCost =0;    
            materialPrice = 0;  
            pricebookId = '';   
            days = 0;   
            //qty = 0;  
            skuCode = '';   
            multipleOf = 0; 
            orderItemId = '';   
            approxStock=0;
            unitValue=0;
            unitPrice=0;
            totalPrice=0;
        }   
    }   
    public class CartWrapper{   
        @AuraEnabled public List<SalesOrderItem> soiList;  
        @AuraEnabled public SalesOrderItem soitemObj;  
        @AuraEnabled public String cartOrderId;    
        @AuraEnabled public String errorMessage;   
        @AuraEnabled public Decimal grossNetPrice; 
        @AuraEnabled public String orderType;
        @AuraEnabled public Decimal Net_Amount;
        @AuraEnabled public String Net_QuantityLiters;
        @AuraEnabled public String Net_QuantityKgs;
        @AuraEnabled public Decimal Totaldiscount;
        
        public CartWrapper(){   
            soiList = new List<SalesOrderItem>();  
            soitemObj = new SalesOrderItem();  
            cartOrderId ='';   
            errorMessage='';   
            grossNetPrice=0;   
            orderType ='';
            Net_Amount=0;
            Net_QuantityLiters='0L';
            Net_QuantityKgs='0KG';
            Totaldiscount=0;
        }    
    }   
    
    public class SalesOrderItem {   
        
        @AuraEnabled public String skuId;   
        @AuraEnabled public String productCode; 
        @AuraEnabled public String ordrId;  
        @AuraEnabled public String oliId;   
        @AuraEnabled public String priceBookDetailId;   
        @AuraEnabled public String skuCategory;
        @AuraEnabled public String skuName;
        @AuraEnabled public String skucode;
        @AuraEnabled public String UOM; 
        @AuraEnabled public String customerCode;    
        @AuraEnabled public String productName; 
        @AuraEnabled public String shipDate; 
        @AuraEnabled public String shipDateformatted;
        @AuraEnabled public Decimal qty;    
        @AuraEnabled public Decimal unitValue;//final prices    
        @AuraEnabled public Decimal materialPrice;  
        @AuraEnabled public Decimal discount;           
        @AuraEnabled public Decimal netPrice;   
        @AuraEnabled public Decimal totalDiscount;  
        @AuraEnabled public String personalNotes;
        
        @AuraEnabled public Decimal multipleOf; 
        @AuraEnabled public Decimal itemNo; 
        @AuraEnabled public Decimal discountvalue;
        @AuraEnabled public String salesOrderItemId;
        @AuraEnabled public String parentOrderNumber;
        @AuraEnabled public String pricebookId;
        @AuraEnabled public String deliveryDate; // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022....
        
        public SalesOrderItem(){    
            UOM = 'N/A';    
            itemNo = 0; 
            skuId = ''; 
            customerCode ='';   
            productCode = ''; 
            skuName='';
            skucode='';
            ordrId = '';    
            priceBookDetailId = ''; 
            productName = '';   
            materialPrice =0;   
            shipDate = '';
            shipDateformatted='';
            qty = 0;    
            oliId ='';  
            discount = 0;   
            multipleOf = 0; 
            netPrice = 0;   
            personalNotes=' ';
            salesOrderItemId='';
            pricebookId='';
            discountvalue=0;
            deliveryDate = '';  // SKI(Nik) : #CR152 : PO And Delivery Date : 07-09-2022....
        }   
    }  
    public class docWrapper {   
        @AuraEnabled public String name;   
        @AuraEnabled public String documentId;
        @AuraEnabled public String contentVersionId;
        @AuraEnabled public String base64;
        public docWrapper(){    
            name = '';    
            documentId = ''; 
            contentVersionId = '';
            base64='';
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
}