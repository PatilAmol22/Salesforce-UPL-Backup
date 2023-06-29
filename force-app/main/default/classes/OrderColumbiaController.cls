/*
* Name: OrderColumbiaController
* Created On: 1 June 2019
* Author: Ganesh Chaurasia (ganesh.chaurasia@skinternational.com)
* Description: Lightning Component Apex Controller used for Raising orders by Sp/pc of Columbia
*/
public without sharing class OrderColumbiaController {
      public static List<AuditHistory> beforeSort = new List<AuditHistory>();
      public static List<AuditHistory> afterSort = new List<AuditHistory>();
    
      public class TestException extends Exception{}
    //Method to save sales order record
    /*Params: Sales Order (Object),
            Sales Order Items (JSON String)*/
   
       
    @AuraEnabled
    public static String getAccountSalesOrg(String accId){
        String soCode = '';
        List<Account> accList = [SELECT Id,Sales_Org_Code__c
                                 FROM Account 
                                 WHERE Id=:accId LIMIT 1];
        
        if(accList.size()>0){
            soCode = accList[0].Sales_Org_Code__c ;
        }
        return soCode;
    }
    
    @AuraEnabled
    public static OrderWrapper saveSalesOrder(Sales_Order__c soObj, String salesOrderItemString, Boolean isSimulated,String TotalUSD) {
        
        System.debug('Sales Order TotalUSD: '+TotalUSD);
        System.debug('Sales Order: '+soObj);
        System.debug('Sales Order from : '+soObj.Total_Sales_USD__c);
        soObj.Total_Sales_USD__c = Decimal.valueOf(TotalUSD);
        //Initialize Return Order Wrapper.
        OrderWrapper owObj = new OrderWrapper();
        //Exception exObj;
        
        try{
            //If Owner Id is blank or None set Owner Id to Logged In User
            String ownerId = soObj.OwnerId;
            if(String.isBlank(ownerId) || ownerId=='None'){
                soObj.OwnerId = UserInfo.getUserId();
            }
          //  system.debug('soObj.Order_Status__c'+soObj.Order_Status__c+''+soObj);
            User userObj =   [Select Id,Email,Name, Profile.Name, Show_List_Value__c,Show_Min_Price__c,Show_Max_Price__c,Show_Floor_Price__c, IsActive, ContactId,UserRole.name,
                                 Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,
                                 Show_Inventory_Column__c, ManagerId,Show_InTransit__c, Show_InTransit_Values__c,HO__c, Country_Head__c, Marketing_Manager__c
                                 FROM User 
                                 WHERE Id =: UserInfo.getUserId()
                                 AND IsActive = True];
           
            system.debug('soObj.OwnerId'+soObj.OwnerId);
            if(userObj!=null){
                //assigning Commercial leader
                if(String.isNotBlank(userObj.ManagerId)){
                    soObj.Manager__c = userObj.ManagerId;
                }
                //assigning Commercial Manager
                if(String.isNotBlank(userObj.Marketing_Manager__c)){
                    soObj.Sales_Director_Mexico__c = userObj.Marketing_Manager__c;
                }
                //assigning Country Manager
                if(String.isNotBlank(userObj.Country_Head__c)){
                    soObj.Latam_Director_Mexico__c = userObj.Country_Head__c;
                }
            }
            
            //fetching Admin param data
            Admin_MPT_Colombia__c mtpAdminObj =   [Select Id, of_adjustment_to_display_vendor_utility__c, Active__c,Level_1_max__c,Level_1_min__c,Level_2_max__c, Level_2_min__c, Level_3_below__c,
                                                   Max_no_of_prod_asso_with_initial_product__c, Min_for_Profitable_in_result_by_margin__c, Sales_Org__c,USD_conversion_rate__c
                                                   FROM Admin_MPT_Colombia__c 
                                                   WHERE Sales_Org__r.Sales_Org_Code__c ='5710'
                                                   AND Active__c = True  limit 1];
            
            if(mtpAdminObj!=null){
                soObj.of_adjustment_to_display_vendor_utility__c=mtpAdminObj.of_adjustment_to_display_vendor_utility__c;
                soObj.Min_for_Profitable_in_result_by_margin__c=mtpAdminObj.Min_for_Profitable_in_result_by_margin__c;
                soObj.Max_no_of_prod_asso_with_initial_product__c=mtpAdminObj.Max_no_of_prod_asso_with_initial_product__c;
                soObj.Level_1_max__c=mtpAdminObj.Level_1_max__c;
                soObj.Level_1_min__c=mtpAdminObj.Level_1_min__c;
                soObj.Level_2_max__c=mtpAdminObj.Level_2_max__c;
                soObj.Level_2_min__c=mtpAdminObj.Level_2_min__c;
                soObj.Level_3_below__c=mtpAdminObj.Level_3_below__c;
                soObj.USD_Conversion_Rate__c   = mtpAdminObj.USD_Conversion_Rate__c;   
            }
            
            List<Sales_Org__c> salesOrgList = [Select ID FROM Sales_Org__c 
                                               WHERE NAME = 'Colombia' 
                                               AND Country_Code__c = 'CO' LIMIT 1];
            
            if(!salesOrgList.isEmpty()){
                soObj.Sales_Org_lk__c = salesOrgList[0].Id;
            }
            system.debug('soObj.Order_Type_lk__c');
             soObj.Order_Type_lk__c = [Select Id,SalesOrg__c FROM Order_Type__c WHERE Order_Type_Code__c='ZZOR' and SalesOrg__r.Name = 'Colombia' limit 1].Id; //Divya: 26-08-2020:Replaced ZORU with ZZOR for RITM0114546
             system.debug('soObj.Order_Type_lk__c'+soObj.Order_Type_lk__c);
             soObj.CurrencyIsoCode = 'COP';
             soObj.Order_Date__c = System.today();
             soObj.CreatedFrom__c = 'SFDC';
             //String depotCodeId= [Select Id,Name ,Depot__c,SalesOrg__r.sales_org_code__c From Depot__c where Depot_Code__c ='CO51' LIMIT 1].Id;
            
                //Logic to query if the record Id is not a rollback record as the Id for rollback record will be invalidated
                List<Sales_Order__c> salesOrderList = [Select Id, Name FROM Sales_Order__c WHERE Id=:soObj.Id];
                if(salesOrderList.isEmpty()){
                    //After rollback the ID remains in the record, make it null & upsert
                    soObj.Id = null;
                }
               
                 system.debug('ProfileName community '+userObj.Profile.Name);
                 if(userObj.Profile.Name.equalsIgnoreCase('Customer Partner Community Plus User - Colombia')){
                    soObj.Need_Community_Approval__c = true;
                    soObj.Order_Raise_By__c='Regular Distributor';
                }
               
               //soObj.Need_Community_Approval__c = true;
                upsert soObj;
              
                List<SalesOrderItem> salesOrderItemList = (List<SalesOrderItem>)JSON.deserialize(SalesOrderItemString, List<SalesOrderItem>.class);
                //System.debug('salesOrderItemList: '+salesOrderItemList);
                //System.debug('salesOrderItemList.size: '+salesOrderItemList.size());
                
                //Assign everything to Order Wrapper after upsert.
                owObj.soiList = OrderColumbiaController.saveOrderItems(soObj, salesOrderItemList, salesOrgList , mtpAdminObj);
                owObj.soObj = OrderColumbiaController.getSalesOrder(soObj.Id);
                owObj.sfdcOrderNo = [Select Id, Name FROM Sales_Order__c WHERE Id=:soObj.Id].Name;
                owObj.sapOrderNo = soObj.SAP_Order_Number__c;
                owObj.approvalList = OrderColumbiaController.generateData(soObj.Id);
                //End of Logic
                system.debug('owObj'+owObj);
                
             if(soObj.Order_Status__c == 'Submitted' && (owObj.soObj.Sent_for_Manager_Approval_Mexico__c || owObj.soObj.Sent_for_Director_Approval_Mexico__c || owObj.soObj.Sent_for_Latam_Director_Approval__c)){
                soObj.Order_Status__c = 'Pending';
                soObj.Colombia_Order_Submitted_for_Approval__c = false;
                 //Added by Nandhini -to fix the multiple approval process submission
                 soObj.Need_Community_Approval__c = true;
                update soObj;
                System.debug('soObj--->'+soObj);
            }else
                if(!owObj.soObj.Sent_for_Manager_Approval_Mexico__c && !owObj.soObj.Sent_for_Director_Approval_Mexico__c && !owObj.soObj.Sent_for_Latam_Director_Approval__c && soObj.Order_Status__c == 'Submitted'){
                    soObj.Order_Status__c = 'Open';
                    update soObj;
                }
            owObj.soObj.ErrorMessage__c = '';
            //Added by Nandhini
            User uRec;
            if(userObj.Profile.Name.equalsIgnoreCase('Customer Partner Community Plus User - Colombia')){
                if(soObj.Ship_To_Party__c != null){
                    Shipping_Location__c selectedShippingLocation =[Select Id,Sales_Employee_TM_code__c from Shipping_Location__c where Id=:soObj.Ship_To_Party__c];
                    uRec = [Select id,Name,Email from User where TM_Code__c =:selectedShippingLocation.Sales_Employee_TM_code__c];
                    soObj.OwnerId=uRec.Id;
                }
            }
            if(soObj.Id != null && userObj.Profile.Name != 'Customer Partner Community Plus User - Colombia'){
                soObj.Need_Community_Approval__c = false;
            }
            update soObj;
            // Send an Email for community User.
            EmailTemplate et = [SELECT Id,body,Subject FROM EmailTemplate WHERE DeveloperName = 'Colombia_Sales_Personnel_Template'];
            List<OrgWideEmailAddress> owaList = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'salesexcellence1@upl-ltd.com'];
            contact conObj = [select id,firstname from contact limit 1];
            String organizationEmailId;
            if(null != owaList && !owaList.isEmpty()){
                organizationEmailId = owaList[0].Id;
            }
            if(userObj != null && userObj.Profile.Name.equalsIgnoreCase('Customer Partner Community Plus User - Colombia') && soObj.Order_Status__c == 'Pending'){// equalIgnore
                //SendEMail
                System.debug('In Send EMail ');
                Messaging.SingleEmailMessage  message = new Messaging.SingleEmailMessage();
                message.setOrgWideEmailAddressId(organizationEmailId);
                //message.setCharset('UTF8');
                message.setTemplateId(et.Id);
                message.setTargetObjectId(conObj.Id);
                message.setWhatId(soObj.Id);
                message.setTreatTargetObjectAsRecipient(false);
                //message.setTreatBodiesAsTemplate(true);
                //User uRec = [Select id,Name,Email from User where TM_Code__c ='00051071'];
                //String body = 'Hi'+uRec.Name+ ' Sales Order Created. '+[Select Id, Name FROM Sales_Order__c WHERE Id=:soObj.Id].Name;
                //String body = et.body;
                //body= body.replace('SalesRepName',uRec.Name);
                
                //message.setHtmlBody(body);
                
                message.setToAddresses(new List<String> {uRec.Email});

                Messaging.SingleEmailMessage  messageOne = new Messaging.SingleEmailMessage();
                messageOne.setOrgWideEmailAddressId(organizationEmailId);
                //message.setCharset('UTF8');
                //messageOne.setTemplateId(et.Id);
                messageOne.setTargetObjectId(conObj.Id);
                messageOne.setWhatId(soObj.Id);
                messageOne.setTreatTargetObjectAsRecipient(false);
                //message.setTreatBodiesAsTemplate(true);
                //User uRec = [Select id,Name,Email from User where TM_Code__c ='00051071'];
                String body = 'Estimado Señor '+userObj.Name+ ','+'<br/>'+'<br/>'+' Orden de venta creada '+[Select Id, Name FROM Sales_Order__c WHERE Id=:soObj.Id].Name + '<br/>'+'<br/>'+'Gracias,' +'<br/>'+'UPL Team';

                //String body = et.body;
                //body= body.replace('SalesRepName',uRec.Name);
                
                messageOne.setHtmlBody(body);
                
                messageOne.setToAddresses(new List<String> {userObj.Email});

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message,messageOne });
            }
            if(Test.isRunningTest()){
               throw new TestException('I am running for test class');
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
            ApexLog.exceptionHandlerColumbia(ex, soObj.Sold_to_Party__c, soObj, salesOrderItemString);
        }
        return owObj;
    }
    
     //Reload existing Sales Order with given recordID
    @AuraEnabled
    public static Sales_Order__c getSalesOrder(ID soId) {
        /* ------------------SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022------------------------- */
        //Make sure to add new fields that are being input from the UI to this SOQL query otherwise the data will not be inserted.
        List<Sales_Order__c> soList = [SELECT Id, Name, SAP_Order_Number__c, Order_Status__c,Min_for_Profitable_in_result_by_margin__c, 
                                       Sold_to_Party__r.Tax_Number_1__c,Payment_Term__r.Payment_Term__c,Ship_To_Party__r.City__c,
                                       Sold_to_Party__r.Name, Sold_to_Party__c, ReloadPaymentTerms__c, OrderSubStatus__c,
                                       Sold_to_Party__r.Tax_Number_3__c, Depot_Code__c,Sent_for_Manager_Approval_Mexico__c,
                                       Sold_to_Party__r.SAP_Code__c,Ship_To_Party__c,Remarks_Long__c,Order_Type_Colombia__c,
                                       Sold_to_Party__r.Customer_Group__c,Sent_for_Latam_Director_Approval__c,Gross_Margin_Colombia__c,
                                       Sold_to_Party__r.BillingCity,CreatedById, OwnerId, Owner.Name,CurrencyIsoCode,Sent_for_Director_Approval_Mexico__c,
                                       Sold_to_Party__r.BillingState,Net_Amount__c,Gross_Profit_colombia__c,Total_Discount_Per_Colombia__c,
                                       Payment_Term__c, Sold_to_Party__r.Depot_Code__c,Business_Impact_Per_colombia__c,(SELECT Id,Name FROM Attachments limit 1) ,
                                       Sold_to_Party__r.Customer_Region__c,Total_Sales_USD__c,Need_Community_Approval__c,Order_Raise_By__c,
                                       RecordType.Name, SalesOrgCode__c, Purchase_Order_Date__c 
                                       FROM Sales_Order__c 
                                       WHERE Id =: soId];  
        
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
    public static List<SalesOrderItem> saveOrderItems(Sales_Order__c soObj2, List<SalesOrderItem> salesOrderItemList, List<Sales_Org__c> salesOrgList, Admin_MPT_Colombia__c mtpAdminObj2){
        
     
        String depotCodeId= '';
         depotCodeId = [Select Id,Name ,Depot__c,SalesOrg__r.sales_org_code__c From Depot__c where Depot_Code__c ='CO51' LIMIT 1].Id;
          //String depotCodeId = [SELECT Id, Brazil_Depot_Code__c FROM Account WHERE Id=:soObj2.Sold_to_Party__c].Brazil_Depot_Code__c;
      
        //For Item Number maintenance on Order reload, while saving items delete & re-insert all line items.
        delete [SELECT Id FROM Sales_Order_Line_Item__c WHERE Sale_Order__c=:soObj2.Id];
        
        List<Sales_Order_Line_Item__c> soiList = new List<Sales_Order_Line_Item__c>();
        
        Integer i = 0;
        Integer j= 0;
        for(SalesOrderItem item: salesOrderItemList){
            
            Sales_Order_Line_Item__c soiObj = new Sales_Order_Line_Item__c();
            i = i+10;
            if(soObj2.Order_Type_Colombia__c == 'MPT Order'){
                if(item.typeOfBusiness=='Producto Inicial'){
                    j = i;
                }
            }      
            soiObj.Item_Number__c = i;
            soiObj.Sale_Order__c = soObj2.Id;
            soiObj.SKU_Name__c = item.productId;
            soiObj.CurrencyIsoCode = soObj2.CurrencyIsoCode;
            soiObj.MinPrice__c =item.minValue;       
            soiObj.MaxPrice__c =item.maxPrice;
            soiObj.UOM__c = item.UOM;
            soiObj.Quantity__c = item.qty;
            soiObj.Unit_Price__c = item.unitCost;
            soiObj.Profit_colombia__c = item.profit;
            /* -----------Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022------------ */
            if(String.isNotBlank(item.deliveryDate)){
                soiObj.Delivery_Date__c = Date.valueof(item.deliveryDate);
            }
            else if(String.isBlank(item.deliveryDate)){
                soiObj.Delivery_Date__c = null;
            }
            /* ----------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022---------------- */
            
            //System.debug(soObj2.Order_Type_Colombia__c);
            if(soObj2.Order_Type_Colombia__c == 'Normal Order'){
              soiObj.Price__c = item.netSales;
                soiObj.FinalPrice__c = item.unitValue;
                soiObj.Net_Price__c =item.unitValue;
                soiObj.Discount_Per_colombia__c =item.discount_percent;
                soiObj.Discount_Value_colombia__c = item.discount;
                //soiObj.Margin_colombia__c = item.margin;
                soiObj.Net_Margin_colombia__c =item.netMargin;
                if(soiObj.Net_Margin_colombia__c <= mtpAdminObj2.Level_1_max__c && soiObj.Net_Margin_colombia__c >= mtpAdminObj2.Level_1_min__c){
                    system.debug('soiObj.Net_Margin_colombia__c'+soiObj.Net_Margin_colombia__c);
                   soObj2.Sent_for_Manager_Approval_Mexico__c =true;
                }
                 if(soiObj.Net_Margin_colombia__c <= mtpAdminObj2.Level_2_max__c && soiObj.Net_Margin_colombia__c >= mtpAdminObj2.Level_2_min__c){
                       system.debug('soiObj.Net_Margin_colombia__c2'+soiObj.Net_Margin_colombia__c);
                     soObj2.Sent_for_Manager_Approval_Mexico__c = true;
                     soObj2.Sent_for_Director_Approval_Mexico__c= true;
                 }
                if(soiObj.Net_Margin_colombia__c <= mtpAdminObj2.Level_3_below__c){
                      system.debug('soiObj.Net_Margin_colombia__c3'+soiObj.Net_Margin_colombia__c);
                    soObj2.Sent_for_Manager_Approval_Mexico__c = true;
                    soObj2.Sent_for_Director_Approval_Mexico__c= true;
                    soObj2.Sent_for_Latam_Director_Approval__c =true;
                }
   
            }
          
            if(soObj2.Order_Type_Colombia__c == 'MPT Order'){
            soiObj.Business_Type_Colombia__c = item.typeOfBusiness;
            if(item.typeOfBusiness=='Producto Inicial'){
                soiObj.FinalPrice__c = item.unitValue;//DIVYA updated unitValue instead of maxprice for SCTASK0102624
                soiObj.Price__c = item.netSales;
                if(item.unitValue !=0){
                }
                soiObj.Net_Price__c =item.netPrice;
                soiObj.Discount_Per_colombia__c =item.discount_percent;
                soiObj.Discount_Value_colombia__c = 0;
                soiObj.Margin_colombia__c = item.margin;
                soiObj.Net_Margin_colombia__c =item.netMargin;
               
                if(soiObj.Net_Margin_colombia__c <= mtpAdminObj2.Level_1_max__c && soiObj.Net_Margin_colombia__c >= mtpAdminObj2.Level_1_min__c){
                    system.debug('soiObj.Net_Margin_colombia__c'+soiObj.Net_Margin_colombia__c);
                   soObj2.Sent_for_Manager_Approval_Mexico__c =true;
                }
                 if(soiObj.Net_Margin_colombia__c <= mtpAdminObj2.Level_2_max__c && soiObj.Net_Margin_colombia__c >= mtpAdminObj2.Level_2_min__c){
                       system.debug('soiObj.Net_Margin_colombia__c2'+soiObj.Net_Margin_colombia__c);
                     soObj2.Sent_for_Manager_Approval_Mexico__c = true;
                     soObj2.Sent_for_Director_Approval_Mexico__c= true;
                 }
                if(soiObj.Net_Margin_colombia__c <= mtpAdminObj2.Level_3_below__c){
                      system.debug('soiObj.Net_Margin_colombia__c3'+soiObj.Net_Margin_colombia__c);
                    soObj2.Sent_for_Manager_Approval_Mexico__c = true;
                    soObj2.Sent_for_Director_Approval_Mexico__c= true;
                    soObj2.Sent_for_Latam_Director_Approval__c =true;
                }
                
            }else if(item.typeOfBusiness=='Impacto Producto' || item.typeOfBusiness=='Impacto Negocio'){
                 soiObj.Price__c =0;
                 soiObj.Net_Price__c = 0;
                 soiObj.FinalPrice__c =item.maxPrice;//DIVYA to always show Max price of free product in Edited Estimated Final Price
                 soiObj.Discount_Per_colombia__c = 0;
                 soiObj.Discount_Value_colombia__c = item.discount;
                 soiObj.Margin_colombia__c = 0;
                 soiObj.Net_Margin_colombia__c =0;
            }
            if(item.typeOfBusiness=='Impacto Producto'){
                system.debug('j'+j);
               soiObj.SOLI_Item_Number__c = j; 
            }
             if(item.typeOfBusiness=='Impacto Negocio'){
               soiObj.SOLI_Item_Number__c = 10; 
            }
            }
             if(!salesOrgList.isEmpty()){
                soiObj.Sales_Org__c = salesOrgList[0].Id;
            }
            if(depotCodeId!=null && depotCodeId!=''){
                soiObj.DepotDepot__c = depotCodeId;
            }
            system.debug('soiObj>>--->'+soiObj);
         soiList.add(soiObj);
        }
        //Logic to update so based on gross margin
         if(soObj2.Gross_Margin_Per_Colombia__c <= mtpAdminObj2.Level_1_max__c && soObj2.Gross_Margin_Per_Colombia__c >= mtpAdminObj2.Level_1_min__c){
            soObj2.Sent_for_Manager_Approval_Mexico__c =true;
        }
        if(soObj2.Gross_Margin_Per_Colombia__c <= mtpAdminObj2.Level_2_max__c && soObj2.Gross_Margin_Per_Colombia__c >= mtpAdminObj2.Level_2_min__c){
            soObj2.Sent_for_Manager_Approval_Mexico__c = true;
            soObj2.Sent_for_Director_Approval_Mexico__c= true;
        }
        if(soObj2.Gross_Margin_Per_Colombia__c <= mtpAdminObj2.Level_3_below__c){
            soObj2.Sent_for_Manager_Approval_Mexico__c = true;
            soObj2.Sent_for_Director_Approval_Mexico__c= true;
            soObj2.Sent_for_Latam_Director_Approval__c =true;
        }
        //Logic end
        if(!soiList.isEmpty()){
            insert soiList;
            update soObj2;
            System.debug('soObj2----->'+soObj2);
    }
        return getSalesOrderItems(soObj2.Id);
    }
    
    
     //Reload existing Sal
     //es Order Line Items with given Sales Order ID    
    @AuraEnabled
    public static List<SalesOrderItem> getSalesOrderItems(ID soId) {
        List<Inventory__c> inventorylist = new List<Inventory__c>();
    map<string,Inventory__c> inventoryMap = new map<string,Inventory__c>();   
        inventorylist =[SELECT Id, SKU__c, 
                                          Stock_Quantity__c, Balanced_Quanity__c, In_transit_stock_quantity__c
                                          FROM Inventory__c
                                          WHERE Depot__r.Depot_Code__c ='CO51' AND SKU__r.Active__c = True];    
        
        if(inventorylist.size()>0){
            for(Inventory__c inv :inventorylist){
                inventoryMap.put(inv.SKU__c,inv);
            }
        }
        /* -------------------- SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022----------- */
        List<Sales_Order_Line_Item__c> salesOrderItemList = [SELECT ID, Sale_Order__c,Sale_Order__r.Order_Type_Colombia__c, SKU_Name__c, Discount__c,MinPrice__c,MaxPrice__c,MinValue__c,UOM__c,
                                                             SKU_Name__r.SKU_Description__c,Item_Number__c,Quantity__c,Profit_colombia__c,Price__c,FinalPrice__c,Net_Margin_colombia__c,
                                                             CurrencyIsoCode, Sales_Org__c,Net_Price__c,Discount_Per_colombia__c,Margin_colombia__c,Discount_Value_colombia__c,
                                                             Sales_Order_Line_Item__r.Item_Number__c,UnitValue__c,Business_Type_Colombia__c,Unit_Price__c,
                                                             SKU_Name__r.Name, Delivery_Date__c
                                                             FROM Sales_Order_Line_Item__c
                                                             WHERE Sale_Order__c=:soId Order By CreatedDate];
        
        List<SalesOrderItem> itemList = new List<SalesOrderItem>();
        System.debug('salesOrderItemList'+salesOrderItemList);
        integer itemno = 0;
        for(Sales_Order_Line_Item__c soiObj: salesOrderItemList){
            SalesOrderItem item = new SalesOrderItem();
            item.productId = soiObj.SKU_Name__c;
            item.productName = soiObj.SKU_Name__r.SKU_Description__c;
            item.unitValue = soiObj.UnitValue__c;//final price
            item.maxPrice =soiObj.MaxPrice__c;
            item.minValue = soiObj.MinPrice__c;//item.minValue = soiObj.MinValue__c; 
            item.unitCost = soiObj.Unit_Price__c;
            item.qty = soiObj.Quantity__c;
            item.profit = soiObj.Profit_colombia__c ;
            item.UOM = soiObj.UOM__c;
            item.typeOfBusiness = soiObj.Business_Type_Colombia__c;
            if(inventoryMap.containskey(soiObj.SKU_Name__c)){
                item.inventory = inventoryMap.get(soiObj.SKU_Name__c).Balanced_Quanity__c;
            }
            /* -------------------Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022----------- */
            if(soiObj.Delivery_Date__c != null){
                item.deliveryDate = String.valueOf(soiObj.Delivery_Date__c);
            }
            else{
                item.deliveryDate = '';
            }
            /* -------------------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022------------ */
            /*if(String.isNotBlank(soiObj.Sales_Order_Line_Item__c)){
                item.itemNo = soiObj.Sales_Order_Line_Item__r.Item_Number__c;
            }
            else{
                item.itemNo = soiObj.Item_Number__c;
            }*/
             item.itemNo = itemno++; 
            if(soiObj.Sale_Order__r.Order_Type_Colombia__c=='Normal Order'){
              item.netSales = soiObj.Price__c;
                item.unitValue = soiObj.FinalPrice__c;
                item.netPrice = soiObj.Net_Price__c;
                item.discount_percent = soiObj.Discount_Per_colombia__c ;
                item.discount =soiObj.Discount_Value_colombia__c;
                item.margin =  soiObj.Margin_colombia__c;
                item.netMargin = soiObj.Net_Margin_colombia__c;
            }
            if(soiObj.Sale_Order__r.Order_Type_Colombia__c =='MPT Order'){
            if(soiObj.Business_Type_Colombia__c=='Producto Inicial'){
                item.netSales = soiObj.Price__c;
                item.unitValue = soiObj.FinalPrice__c;
                item.netPrice = soiObj.Net_Price__c;
                item.discount_percent = soiObj.Discount_Per_colombia__c ;
                item.discount = soiObj.Discount_Value_colombia__c;
                item.margin =  soiObj.Margin_colombia__c;
                item.netMargin = soiObj.Net_Margin_colombia__c;
            }else if(soiObj.Business_Type_Colombia__c=='Impacto Producto' || soiObj.Business_Type_Colombia__c=='Impacto Negocio'){
                 item.netSales = 0;
                 item.netPrice = 0;
                 item.unitValue = 0;
                 item.discount_percent = 0;
                 item.discount = soiObj.Discount_Value_colombia__c;
                 item.margin = 0;
                 item.netMargin= 0;
            }
            }    
            itemList.add(item);
        }          
        System.debug('itemList: '+itemList);
        return itemList;
    }
    
    @AuraEnabled (cacheable = true)
    public static List<User> getUserInfo(){
        List<User> u =new List<User>();
        u=[select Id, Country,AccountId, Community_Role__c,profile.Name from user WHERE Id =: UserInfo.getUserId() ];
        return u;
    }
    @AuraEnabled
    public static OrderFields getOrderFields(String accId){

        String recordId = '';
        //below added w.r.t CR - Colombia by vaishnavi
        Id profileId= userinfo.getProfileId();
        String userid = UserInfo.getUserId();
        System.debug('userid '+userid);
        String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('ProfileName community '+profileName);
        if(profileName.equalsIgnoreCase('Customer Partner Community Plus User - Colombia')){
            User userObj = [SELECT Id,UserName, AccountId FROM User WHERE Id=: userid];
            recordId = userObj.AccountId;  
            
        }else{
            recordId = accId;    
        }
        OrderFields ofObj = new OrderFields();
        ofObj.orderTypeList = OrderColumbiaController.getOrderType();
        ofObj.DistributorData = OrderColumbiaController.fetchDistributorDetails(recordId);
        ofObj.ShippingLocMap = OrderColumbiaController.getShippingLoations(recordId,profileName);
        ofObj.businessTypesList = OrderColumbiaController.getBusinessTypes();//adminParam
        ofObj.adminParam = OrderColumbiaController.getAdminParamList();
        //system.debug('ofObj.adminParam'+ofObj.adminParam);
        ofObj.userObj = [Select Id, Profile.Name, Show_List_Value__c,Show_Inventory_Column__c, Country FROM User WHERE Id=:UserInfo.getUserId()];
        /* -------------Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022------------------------ */
        List<Login_Country__c> logCntry = new List<Login_Country__c>();
        logCntry = [SELECT Id, Name, For_Contry__c, Sales_Org_Code__c, Delivery_Date__c, 
                    PO_Date__c, Show_Delivery_Date__c, Show_PO_Date__c FROM Login_Country__c 
                    where Name =:ofObj.userObj.Country limit 1];

        if(logCntry.size() > 0){
            ofObj.showPODate = logCntry[0].Show_PO_Date__c;
            ofObj.showDeliveryDate = logCntry[0].Show_Delivery_Date__c;
            ofObj.isPORequired = logCntry[0].PO_Date__c;
            ofObj.isDeliveryRequired = logCntry[0].Delivery_Date__c;
        }
        /* ----------------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022---------------------- */
        
        return ofObj;
    }

    public static List<String> getOrderType(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Sales_Order__c.Order_Type_Colombia__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        return options;
    } 

    @AuraEnabled
    public static DistributorWrapper fetchDistributorDetails(String recordId){
        
        String  Payment_Terms = '';
        List<Account> accList = [SELECT Id, Name, BillingCity,Payment_Term_Code__C, BillingCountry, RegionalManager__c,
                                 BillingStreet, BillingState, BillingPostalCode , CurrencyIsoCode, Sales_Org__r.Name, 
                                 OwnerId, SAP_Code__c, Sales_Org__c, Distribution_Channel__c, Division__c,
                                 Order_Type__c, Order_Block__c,Sales_Org_Code__c, Status__c,Payment_Terms__c,PG_Code__c, PriceGroupCode__c,Sales_District__c,Sales_District__r.Sales_Director__c,Sales_District__r.Latam_Director__c
                                 FROM Account 
                                 WHERE Id=:recordId LIMIT 1];
        
        if(accList.size()>0){
            Payment_Terms = accList[0].Payment_Term_Code__c ;
        }
        
        List<Payment_Term__c> paymentTermList =  [SELECT Id,name,Payterms_Desc__c,Payment_Term__c,Sales_Org__c,Payment_Term_Code__c FROM Payment_Term__c 
                                                  where id=:Payment_Terms limit 1];
        
        List<Distributor_Depot_Mapping__c> dmList = [SELECT id, Distributor__c ,Depot__c, Depot__r.Location__c 
                                                     FROM Distributor_Depot_Mapping__c 
                                                     WHERE Distributor__c=:recordId LIMIT 1];
        
        List<DistributorSalesAreaMapping__c> SalesAreaDMList = [SELECT Id,AccountOwner__c, Division_Code__c, Sales_Org_Code__c, Order_Type__c, PriceGroupMaster__c,
                                                                Distribution_Channel_Code__c, SalesOrg__c, Division__c, Distributor__c 
                                                                FROM DistributorSalesAreaMapping__c where Distributor__c=:recordId];                                                 
        
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
        
         String distributionChannelId= '';
         distributionChannelId = [Select Id,Distribution_Channel_Code__c From Distribution_Channel__c where Distribution_Channel_Code__c ='20' LIMIT 1].Id;
        
         String divId= '';
         divId = [Select Id,Division_Code__c From Division__c where Division_Code__c ='10' LIMIT 1].Id;
         
        DistributorWrapper distributorDetails = new DistributorWrapper(); 
        if(!accList.isEmpty()){
            distributorDetails.distributorName = accList[0].Name;
            distributorDetails.sapCode = accList[0].SAP_Code__c;
            distributorDetails.salesOrgId =SalesAreaDMList[0].SalesOrg__c;
            distributorDetails.salesOrgName = accList[0].Sales_Org__r.Name;
            distributorDetails.distributorChannelId = distributionChannelId;   
            distributorDetails.Sales_Director = accList[0].Sales_District__r.Sales_Director__c;
            distributorDetails.Latam_Director = accList[0].Sales_District__r.Latam_Director__c;
            distributorDetails.divisionId = divId;   
            distributorDetails.ordertype = accList[0].Order_Type__c; 
            distributorDetails.paymentTerms = paymentTermList[0].Payment_Term__c;
            distributorDetails.paymentTermId = accList[0].Payment_Term_Code__c;
            distributorDetails.priceGroupId = accList[0].PriceGroupCode__c;
            distributorDetails.priceGroupCodes=accList[0].PG_Code__c;

            distributorDetails.address = accList[0].BillingStreet;
            distributorDetails.city = accList[0].BillingCity;
            distributorDetails.state = accList[0].BillingState;
            distributorDetails.country = accList[0].BillingCountry;
            distributorDetails.pincode = accList[0].BillingPostalCode;
            distributorDetails.currencyIso = accList[0].currencyIsoCode;
            distributorDetails.regionalManagerId = accList[0].RegionalManager__c;
        }
       
        if(!oaList.isEmpty()){
            distributorDetails.greaterThan90 = oaList[0].Net_Overdue__c; //oaList[0].OutstandingTotalGreaterthan90__c;
        }else{
            distributorDetails.greaterThan90 = 0.00;
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
         
        List<Shipping_Location__c> slList = [SELECT Id, Name,Location_Name__c, Distributor__c, City__c, 
                                             Region__c, Pincode__c, State__c, Country__c,
                                             Sold_To_Party_SAP_Code__c, SAP_Code__c,Billing_Street_1__c,Billing_Street_2__c,Billing_Street_3__c,Billing_Street_4__c,Billing_Street_5__c,Billing_Street_6__c
                                             FROM Shipping_Location__c
                                             WHERE Distributor__c =:recordId];
        return distributorDetails;
        
        
    }
    
    //Method to get a map of picklist values of Shipping Location from custom object.
    public static Map<String,Shipping_Location__c> getShippingLoations(string recordId,String profileName){
        //Modified by Nandhini
        List<Shipping_Location__c> shippingLocationList =[SELECT Id, Name,Location_Name__c, Distributor__c, City__c, 
                                        Region__c, Pincode__c, State__c, Country__c,Sales_Employee_TM_code__c,
                                        Sold_To_Party_SAP_Code__c, SAP_Code__c,Billing_Street_1__c,Billing_Street_2__c,
                                        Billing_Street_3__c,Billing_Street_4__c,Billing_Street_5__c,Billing_Street_6__c
                                        FROM Shipping_Location__c
                                        WHERE Distributor__c =:recordId];
        set<String> Tmcodes =new set<String>();
        for(Shipping_Location__c slObj:shippingLocationList){
            if(slObj.Sales_Employee_TM_code__c != null){
                Tmcodes.add(slObj.Sales_Employee_TM_code__c);
            }
            
            system.debug('TM codes :'+Tmcodes);
        }
        Map<String,String> userNameTMCodeMap=new Map<String,String>();
        if(Tmcodes !=null && !Tmcodes.isEmpty()){
            for(User userRec:[Select id,Name,Email,TM_Code__c from User where TM_Code__c IN :Tmcodes]){
                userNameTMCodeMap.put(userRec.TM_Code__c,userRec.Name);
                system.debug('TM map :' +userNameTMCodeMap);
            }
        }
       
        Map<String,Shipping_Location__c> options = new Map<String,Shipping_Location__c>();
        for(Shipping_Location__c slObj:shippingLocationList){
            //Modified by Varun Shrivastava: SCTASK0568511: 26 aug 2021 Start
            //options.put(slobj.Location_Name__c+' - '+slObj.City__c, slObj);//Divya:14-05-2020: Concatenated Location Name as well for SCTASK0184974
            if(profileName.equalsIgnoreCase('Customer Partner Community Plus User - Colombia')){
                if(userNameTMCodeMap.containsKey(slObj.Sales_Employee_TM_code__c)){
                    slObj.Sort1__c=userNameTMCodeMap.get(slObj.Sales_Employee_TM_code__c);
                }
            }
            options.put(slobj.Location_Name__c+' - '+slObj.City__c + ' - '+slObj.SAP_Code__c, slObj);//Divya:14-05-2020: Concatenated Location Name as well for SCTASK0184974
            
            //Modified by Varun Shrivastava: SCTASK0568511: 26 aug 2021 End
        }
        return options;
    }
    
     //Method to get all the picklist values of types of business.
     public static List<String> getBusinessTypes(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Sales_Order_Line_Item__c.Business_Type_Colombia__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        return options;
    
    } 
    
     //Method to fetch admin parameter List
    @AuraEnabled
    public static Admin_MPT_Colombia__c getAdminParamList() {
        List<Admin_MPT_Colombia__c> adminParamList = new List<Admin_MPT_Colombia__c>();
        for(Admin_MPT_Colombia__c amcObj: [SELECT Id, of_adjustment_to_display_vendor_utility__c, Min_for_Profitable_in_result_by_margin__c, 
                                           Level_1_max__c, Level_1_min__c,Level_2_max__c,Level_2_min__c,Max_no_of_prod_asso_with_initial_product__c,
                                           Level_3_below__c,USD_conversion_rate__c
                                           FROM Admin_MPT_Colombia__c 
                                           WHERE Active__c = True limit 1]){
                                               adminParamList.add(amcObj);                                            
                                           }
        return adminParamList[0];
    }
    
   @AuraEnabled 
    public static List<PriceDetail> getSkuData(String accId, String pgCode,String pgCodes){
    system.debug('accId'+accId+'pgCode'+pgCode);
        List<String> pgCodesList=new List<String>();
        if(!String.isBlank(pgCodes)){
            for(String s:pgCodes.split(','))
            {
               pgCodesList.add(s) ;
            }
        }
   
     System.debug('pgCodesList----->'+pgCodesList);
    List<PriceDetail> priceList = new List<PriceDetail>();
    List<PriceBookMaster__c> pbmList =new List<PriceBookMaster__c>();
    List<Inventory__c> inventorylist = new List<Inventory__c>();
    map<string,Inventory__c> inventoryMap = new map<string,Inventory__c>();   
        inventorylist =[SELECT Id, SKU__c, 
                                          Stock_Quantity__c, Balanced_Quanity__c, In_transit_stock_quantity__c
                                          FROM Inventory__c
                                          WHERE Depot__r.Depot_Code__c ='CO51' AND SKU__r.Active__c = True];    
        
        if(inventorylist.size()>0){
            for(Inventory__c inv :inventorylist){
                inventoryMap.put(inv.SKU__c,inv);
            }
        }
        
         pbmList =  [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                                        SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c,
                                        DepotCode__c, DepotCode__r.Location__c,SKUCode__r.UOM__c,
                                        Price__c, PG_CODE__c, PG_CODE__r.Name,SKUCode__r.Product_Category__c,
                                        UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Unit_Cost__c,
                                        SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,
                                        SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c
                                        FROM PriceBookMaster__c
                                        WHERE (DistributorCustomerCode__c =: accId AND DepotCode__r.Location__c ='CO51')
                                        AND SKUCode__r.Sales_Org__r.sales_org_code__c ='5710' 
                                        AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True  
                                        ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC ];
        
        if(pbmList.size()==0){
             //Added by Ishu Mittal for ticket RITM0496802
            if(!pgCodesList.isEmpty() )
            {System.debug('enter in if');
            pbmList =  [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                        SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c,
                        DepotCode__c, DepotCode__r.Location__c,SKUCode__r.UOM__c,
                        Price__c, PG_CODE__c, PG_CODE__r.Name,SKUCode__r.Product_Category__c,
                        UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Unit_Cost__c,
                        SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,
                        SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c,PG_CODE__r.Description_Colombia__c
                        FROM PriceBookMaster__c
                        WHERE (DepotCode__r.Location__c ='CO51' AND PG_CODE__r.PG_Code__c=:pgCodesList AND DistributorCustomerCode__c=null)
                        AND SKUCode__r.Sales_Org__r.sales_org_code__c ='5710' 
                        AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True  
                        ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC ];
            }
            else
            {
                pbmList =  [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                        SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c,
                        DepotCode__c, DepotCode__r.Location__c,SKUCode__r.UOM__c,
                        Price__c, PG_CODE__c, PG_CODE__r.Name,SKUCode__r.Product_Category__c,
                        UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Unit_Cost__c,
                        SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,
                        SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c,PG_CODE__r.Description_Colombia__c
                        FROM PriceBookMaster__c
                        WHERE (DepotCode__r.Location__c ='CO51' AND PG_CODE__c=:pgCode AND DistributorCustomerCode__c=null)
                        AND SKUCode__r.Sales_Org__r.sales_org_code__c ='5710' 
                        AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True  
                        ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC ];
            }
                
            
        }
        
        system.debug('pbmList.size()'+pbmList.size());
        if(pbmList.size()>0){
            system.debug('pbmList.size()'+pbmList);
            for(PriceBookMaster__c pbObj :pbmList){
                 PriceDetail pb = new PriceDetail(); 
                // system.debug('pbObj'+pb);
                pb.skuId = pbObj.SKUCode__c;
                pb.skuCategory = pbObj.SKUCode__r.Product_Category__c; 
                pb.skuDescription = pbObj.SKUCode__r.SKU_Description__c;
                pb.unitCost = pbObj.SKUCode__r.Unit_Cost__c;
                pb.UOM = pbObj.UOM__c;
                //pb.unitValue = pbObj.Unit_Price__c;
                pb.minValue = pbObj.MinPrice__c;
                pb.maxPrice = pbObj.Price__c;
                pb.pricebookId = pbObj.Id;
                pb.skuCode = pbObj.SKUCode__r.SKU_Code__c;
                 //Added by Ishu Mittal for ticket RITM0496802
                pb.PriceGroupDescription=pbObj.PG_CODE__r.Description_Colombia__c;
                 
                
            //  pb.multipleOf = pbObj.SKUCode__c.Multiple_of__c;
                if(inventoryMap.containskey(pbObj.SKUCode__c)){
                    pb.balanceQty = inventoryMap.get(pbObj.SKUCode__c).Balanced_Quanity__c;
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
        return OrderColumbiaController.generateData(recordId); //result2.isSuccess();
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
    
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
            deleteSavedAttach(parentId);
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
      
        return Id.valueOf(fileId);
    }
    public static void deleteSavedAttach(String soId){
     list<Attachment> listofAttach = new list<Attachment>();
       listofAttach = [SELECT Id,Name FROM Attachment WHERE parentId=:soId ];
        if(listofAttach.size()>0){
            delete listofAttach;
        }
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
 
    @TestVisible private static void appendToFile(Id fileId, String base64Data) {
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
    
    
    
    /*******************************************/
    /* Wrapper classes to store All Data  */
    /*****************************************/
    
     public class OrderFields{
        @AuraEnabled public DistributorWrapper DistributorData;
        @AuraEnabled public List<String> orderTypeList;
        @AuraEnabled public List<String> paymentMethodList;
        @AuraEnabled public List<String> currencyList;
        @AuraEnabled public Map<String, Shipping_Location__c> ShippingLocMap;
        @AuraEnabled public List<String> incoTermsList;
        @AuraEnabled public List<String> businessTypesList;
        @AuraEnabled public List<String> priceList;
        @AuraEnabled public User userObj;
        @AuraEnabled public Boolean hasDefaultRules;
        @AuraEnabled public Admin_MPT_Colombia__c adminParam;
        /* ------------Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022--------- */
        @AuraEnabled public Boolean showPODate;
        @AuraEnabled public Boolean showDeliveryDate;
        @AuraEnabled public Boolean isPORequired;
        @AuraEnabled public Boolean isDeliveryRequired;
        /* ------------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022----------- */
        public OrderFields(){
            DistributorData = new DistributorWrapper();
            orderTypeList = new List<String>();
            paymentMethodList = new List<String>();
            currencyList = new List<String>();
            ShippingLocMap = new Map<String, Shipping_Location__c>();
            incoTermsList = new List<String>();
            businessTypesList = new List<String>();
            priceList = new List<String>();
            userObj = new User();
            hasDefaultRules = false;
            adminParam = new Admin_MPT_Colombia__c();
            /* -------------Start SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022--------- */
            showPODate = false;
            showDeliveryDate = false;
            isPORequired = false;
            isDeliveryRequired = false;
            /* -------------End SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022--------- */
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
        public Exception exObj;
        
        public OrderWrapper(){
            soObj = new Sales_Order__c();
            approvalList = new ApprovalList();
            soiList = new List<SalesOrderItem>();
            sfdcOrderNo = '';
            sapOrderNo = '';
            orderSubStatus = '';
        }
    }
    
    public class SalesOrderItem {
        
        @AuraEnabled public String productId;
        @AuraEnabled public String productCode;
        @AuraEnabled public String orderItemId;
        @AuraEnabled public String priceBookDetailId;
        @AuraEnabled public String skuCategory;
        @AuraEnabled public String UOM;
        @AuraEnabled public String productName;
        @AuraEnabled public Decimal qty;
        @AuraEnabled public Decimal inventory;
        @AuraEnabled public Decimal listValue;
        @AuraEnabled public Decimal minValue;
        @AuraEnabled public Decimal unitValue;//final prices
        @AuraEnabled public Decimal unitCost;
        @AuraEnabled public Decimal budgetValue;
        @AuraEnabled public Decimal discount;
        @AuraEnabled public Decimal discount_percent;
        @AuraEnabled public Decimal profit;
        @AuraEnabled public String typeOfBusiness;
        @AuraEnabled public Decimal netSales;
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
        @AuraEnabled public String flag;
        @AuraEnabled public Decimal itemNo;
        @AuraEnabled public Decimal moItemNo;
        @AuraEnabled public Boolean isMO;
        @AuraEnabled public String deliveryDate;   //  SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022..
        
        public SalesOrderItem(){
            UOM = 'N/A';
            isMO = false;
            itemNo = 0;
            moItemNo = 0;
            productId = '';
            productCode = '';
            orderItemId = '';
            priceBookDetailId = '';
            productName = '';
            maxPrice = 0;
            unitCost =0;
           // fatDate = '';
            qty = 0;
            discount = 0;
            discount_percent = 0;
            profit = 0;
            netSales = 0;
            netPrice = 0; 
            margin = 0;
            netMargin = 0;
            unitValueWithInterest = 0;
            totalValueWithInterest = 0;
            totalValue = 0;
            interestRate = 0;
            days = 0;
            cultureDesc = '';
            deliveryDate = String.valueOf(System.today()+1);  // SKI(Nik) : #CR152 : PO And Delivery Date : 13-07-2022..
        }
    } 
    
    public class PriceDetail{
        @AuraEnabled public String skuId;
        @AuraEnabled public String skuDescription;
        @AuraEnabled public String skuCategory;
        @AuraEnabled public String UOM;
        @AuraEnabled public Decimal unitValue;
        @AuraEnabled public Decimal unitCost;
        @AuraEnabled public Decimal minValue;
        @AuraEnabled public String pricebookId;
        @AuraEnabled public Decimal qty;
        @AuraEnabled public String skuCode;
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
        @AuraEnabled public Decimal itemNo;
        @AuraEnabled public Boolean isValid;
        @AuraEnabled public Decimal maxPrice;
        @AuraEnabled public String PriceGroupDescription;
        
        public PriceDetail(){
            UOM = 'N/A';
            itemNo = 0;
            skuId = '';
            skuDescription = '';
            skuCategory = '';
            unitValue = 0;
            unitCost =0;
            minValue = 0;
            pricebookId = '';
            days = 0;
            qty = 0;
            maxPrice = 0;
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
            isMO = false;
            isValid = false;
        }
    }
    
    public class DistributorWrapper{
        @AuraEnabled   public String Sales_Director;
        @AuraEnabled   public String Latam_Director;
        @AuraEnabled   public List<String> divisionIds;
        @AuraEnabled   public String distributorName;
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
        @AuraEnabled   public String address;
        @AuraEnabled   public String city;
        @AuraEnabled   public String state;
        @AuraEnabled   public String country;
        @AuraEnabled   public String pincode;
        @AuraEnabled   public String currencyIso;
        @AuraEnabled   public Id regionalManagerId;
        @AuraEnabled   public String paymentTerms;
        @AuraEnabled   public String paymentTermId;
       @AuraEnabled   public Id priceGroupId;
        @AuraEnabled public String PriceGroupCodes;
        @AuraEnabled   public Id priceListType;
        @AuraEnabled   public String territoryManagerId;
        @AuraEnabled   public Decimal internalCredit;
        
        // @AuraEnabled public Payment_Term__c paymentTerms;
    }
    
    public class ShippingLocation{
        @AuraEnabled    public String locationId;
        @AuraEnabled    public String address;
        @AuraEnabled    public String city;
        @AuraEnabled    public String state;
        @AuraEnabled    public String country;
        @AuraEnabled    public String pincode;
    }
    
}