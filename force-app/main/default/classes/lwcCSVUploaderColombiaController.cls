/*
@Author: Pragati Sharma For APPS-4997_RITM0511677
@Class_Description : Sales Order and Sales Order Line Item Creation through CSV file for Colombia.
*/ 
public with sharing class lwcCSVUploaderColombiaController {
    @AuraEnabled
    public static String saveFile(String base64Data) {
        List<Sales_Org__c> salesOrgList = [Select ID FROM Sales_Org__c 
                                           WHERE NAME = 'Colombia' 
                                           AND Country_Code__c = 'CO' LIMIT 1];
        Admin_MPT_Colombia__c mtpAdminObj =   [Select Id, of_adjustment_to_display_vendor_utility__c, Active__c,Level_1_max__c,Level_1_min__c,Level_2_max__c, Level_2_min__c, Level_3_below__c,
                                               Max_no_of_prod_asso_with_initial_product__c, Min_for_Profitable_in_result_by_margin__c, Sales_Org__c,USD_conversion_rate__c
                                               FROM Admin_MPT_Colombia__c 
                                               WHERE Sales_Org__r.Sales_Org_Code__c ='5710'
                                               AND Active__c = True  limit 1];
        Decimal adjustedPer=mtpAdminObj.of_adjustment_to_display_vendor_utility__c;
        System.debug('adjustedPer'+adjustedPer);
        
        User userObj =   [Select Id, Profile.Name, Show_List_Value__c,Show_Min_Price__c,Show_Max_Price__c,Show_Floor_Price__c, IsActive, ContactId,UserRole.name,
                          Show_Inventory__c, Show_Credit_Limit__c, EnableDepot__c,
                          Show_Inventory_Column__c, ManagerId,Show_InTransit__c, Show_InTransit_Values__c,HO__c, Country_Head__c, Marketing_Manager__c
                          FROM User 
                          WHERE Id =: UserInfo.getUserId()
                          AND IsActive = True];
        String salesorgId=  [Select Id,SalesOrg__c FROM Order_Type__c WHERE Order_Type_Code__c='ZZOR' and SalesOrg__r.Name = 'Colombia' limit 1].Id;
        Id accountId;
        Set<String> ItemNumberSet=new Set<String>();
        List<String> Accountnames = new List<String>();
        List<String> Namestocompare=new List<String>();
        List<String> ShipToAddressList = new List<String>();
        List<String> skuName = new List<String>();
        List<String> csvRowData = new List<String>();
        
        Map<Id,List<Sales_Order_Line_Item__c>> mapOfOrderVsSOI=new Map<Id,List<Sales_Order_Line_Item__c>>();
        Map<String, Id> mapOfAccountandId = new Map<String, Id>();
        Map<String, Shipping_Location__c> mapOfAccountShipLoc = new Map<String, Shipping_Location__c>();
        
        System.debug('JSON.deserializeUntyped(base64Data)'+JSON.deserializeUntyped(base64Data));
        String data = JSON.deserializeUntyped(base64Data).toString();
        System.debug('data'+data);
        list<Sales_Order__c> lstOrderToUpdate = new list<Sales_Order__c>();
        list<Sales_Order__c> lstOrderToInsert = new list<Sales_Order__c>();
        list<Sales_Order_Line_Item__c> lstSOIToInsert = new list<Sales_Order_Line_Item__c>();
        list<Sales_Order_Line_Item__c> updatedSOIList = new list<Sales_Order_Line_Item__c>();
        Set<ID> salesOrderId=new Set<ID>();
        list<String> lstCSVLines = data.split('\r\n');
        List<Payment_Term__c> paymentTermList=new List<Payment_Term__c> ();
        List<String> csvLineItem = new List<String>();
        List<String> csvLineItemOrderForValidation = new List<String>();
        
        System.debug('lstCSVLines.size()'+lstCSVLines.size());
        
        Sales_Order__c soObj = new Sales_Order__c();
        csvLineItem = lstCSVLines[1].split(',');
        System.debug('csvLineItem'+csvLineItem);
        String csvLine = lstCSVLines[1];
        System.debug('csvLine'+csvLine);
        String prevLine = csvLine;
        Integer startIndex;
        Integer endIndex;
        while(csvLine.indexOf('"') > -1){
            
            if(startIndex == null){
                startIndex = csvLine.indexOf('"');
                csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
            }else{
                if(endIndex == null){
                    endIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                }
            }
            
            if(startIndex != null && endIndex != null){
                String sub = csvLine.substring(startIndex, endIndex);
                sub = sub.replaceAll(',', ':comma:');
                csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                startIndex = null;
                endIndex = null;
            }
        }
        for(Integer a= 1; a < 2; a++){
            csvLineItemOrderForValidation=lstCSVLines[a].split(',');
            System.debug('csvLineItemOrderForValidation'+csvLineItemOrderForValidation[1]);
            
        }
        for(Integer a= 3; a < lstCSVLines.size(); a++){
            List<String> csvLineItemForValidation = new List<String>();
            System.debug('lstCSVLines'+lstCSVLines[a]);
            csvLineItemForValidation = lstCSVLines[a].split(',');
            System.debug('csvLineItemForValidation'+csvLineItemForValidation[1]);
            //System.debug('lstCSVLines[1]'+ csvLineItemOrderForValidation[1]);
            //System.debug('csvLineItemForValidation'+csvLineItemForValidation);
            if(csvLineItemOrderForValidation[1]=='MPT Order'){
                if(a==1 && csvLineItemForValidation[5]=='Impacto Producto' ){
                    system.debug('error');
                    throw new AuraHandledException('First business type could not be Impacto Producto ');
                }
            }
            
            if((csvLineItemForValidation[4])=='0'){
                throw new AuraHandledException(system.label.Colombia_Final_Price_Error); 
            }
        }
        
        if(!salesOrgList.isEmpty()){
            soObj.Sales_Org_lk__c = salesOrgList[0].Id;
        }
        soObj.Order_Type_lk__c = salesorgId;
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
        String ownerId = soObj.OwnerId;
        if(String.isBlank(ownerId) || ownerId=='None'){
            soObj.OwnerId = UserInfo.getUserId();
        }
        
        
        
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
        
        Accountnames.add(csvLineItem[0].trim());
        System.debug('name List'+csvLineItem[0]);
        //System.debug('csvRowData[0]'+csvLineItem[1]+'csvLineItem[1]'+csvLineItem[2]+'(csvLineItem[10]'+(csvLineItem[3]));
        soObj.Order_Type_Colombia__c = csvLineItem[1];
        soObj.Purchase_Order_Date__c=Date.valueOf(csvLineItem[2]);
        soObj.CurrencyIsoCode = 'COP';
        soObj.Order_Date__c = System.today();
        soObj.CreatedFrom__c = 'SFDC';
        soObj.Order_Status__c='Submitted';
        //System.debug('csvRowData[6]'+csvLineItem[6]);
        ShipToAddressList.add(csvLineItem[3].trim());
        System.debug('ShipToAddressList'+ShipToAddressList);
        lstOrderToInsert.add(soObj);
        System.debug('soObj'+soObj);
        
        if(lstOrderToInsert!=null && !lstOrderToInsert.isEmpty()){
            try{
                insert lstOrderToInsert;
            }
            Catch(Exception e){
                System.debug('exception in SO insert'+e.getCause() +'on line number'+e.getLineNumber());
            }
        }
        
        List<Account> acc = [select Id, Name,SAP_Customer_Code__c from Account where Name in :Accountnames and SAP_Customer_Code__c !=null order by CreatedDate desc];
        System.debug('acc'+acc);
        for (Account c : acc) {
            System.debug('accoints list'+c);
            if(!mapOfAccountandId.containsKey(c.Name))
            { 
                mapOfAccountandId.put(c.Name, c.Id);
            }else{
                
                System.debug('Key exists');
            }
        }
        System.debug('mapOfAccountandId'+mapOfAccountandId);
        
        if(lstOrderToInsert!=null){
            soObj = lstOrderToInsert[0];
            System.debug('soObj1'+soObj);
            Id id = mapOfAccountandId.get(Accountnames[0]);
            System.debug('id1'+id);
            List<Account> accList = [select Id, Name,SAP_Customer_Code__c from Account where Name in :Accountnames and SAP_Customer_Code__c !=null order by CreatedDate desc];
            for (Account ac : accList) {
                System.debug('accoints list'+ac);
                if(!mapOfAccountandId.containsKey(ac.Name))
                { 
                    mapOfAccountandId.put(ac.Name, ac.Id);
                    
                }else{
                    
                    System.debug('Key exists');
                }
            }
            System.debug('ShipToAddressList'+ShipToAddressList);
            System.debug('Query ship'+[Select id,City__c,Name,Location_Name__c,Distributor__c from Shipping_Location__c where City__c in :ShipToAddressList and Distributor__r.Name in :mapOfAccountandId.keyset()]);
            if(mapOfAccountandId!=null){
                for(Shipping_Location__c s:[Select id,City__c,Name,Location_Name__c,Distributor__c from Shipping_Location__c where City__c in :ShipToAddressList and Distributor__r.Name in :mapOfAccountandId.keyset()]){
                    System.debug('ship  '+s);
                    if(!mapOfAccountShipLoc.containsKey(s.City__c))
                    { 
                        mapOfAccountShipLoc.put(s.City__c,s);
                        
                    }else{
                        //m.put(c.Name, c.Id);
                        System.debug('Key exists');
                    }
                }
                
            }
            
            if (id != null) {
                System.debug('accPaymentId'+lstOrderToInsert[0].id);
                Id accPaymentId = [SELECT Id,Payment_Term_Code__C
                                   FROM Account 
                                   WHERE Id=: id LIMIT 1].Payment_Term_Code__C;
                System.debug('accPaymentId'+accPaymentId);
                if(accPaymentId!=null){
                    paymentTermList =  [SELECT Id,name,Payterms_Desc__c,Payment_Term__c,Sales_Org__c,Payment_Term_Code__c FROM Payment_Term__c 
                                        where id=:accPaymentId limit 1];
                }
                System.debug('paymentTermList'+paymentTermList);
                soObj.Sold_to_Party__c = id;
                soObj.Bill_To_Party__c=id;
                soObj.Payment_Term__c=paymentTermList[0].id;
                System.debug('206'+soObj.Payment_Term__c);
                
                
                salesOrderId.add(lstOrderToInsert[0].id);
                //System.debug('mapOfAccountShipLoc'+mapOfAccountShipLoc +'mapOfAccountShipLoc.get(ShipToAddressList[0]).Distributor__c'+mapOfAccountShipLoc.get(ShipToAddressList[0]).Distributor__c);
                //System.debug('id'+id+'@@@@22 '+'mapOfAccountShipLoc.get(ShipToAddressList[i]).Distribution_Channel__c'+mapOfAccountShipLoc.get(ShipToAddressList[0]).Distributor__c);
                if(mapOfAccountShipLoc!=null){
                    if(id==mapOfAccountShipLoc.get(ShipToAddressList[0]).Distributor__c){
                        System.debug('eneter in ship');
                        soObj.Ship_To_Party__c=mapOfAccountShipLoc.get(ShipToAddressList[0]).id;
                    }
                    else {
                        System.debug('error in id');
                    }
                }
                lstOrderToUpdate.add(soObj);
                
            }
            if(lstOrderToUpdate!=null && !lstOrderToUpdate.isEmpty()){
                try{
                    update lstOrderToUpdate;  
                }
                Catch(Exception e){
                    System.debug('exception in SO'+e.getCause() +'on line number'+e.getLineNumber());
                }
            }
            
            
            
        }
        saveSalesOrderLineItem(lstOrderToInsert[0].id,data,mapOfAccountandId.get(Accountnames[0]));
        return(lstOrderToInsert[0].id); 
        
    }
    @future
    public static void saveSalesOrderLineItem(String recId,String data,Id accountID){
        System.debug('enter in future');
        Integer IntialProduct;
        Decimal QuantityOnSalesOrder;
        Decimal discountOnSalesOrder;
        Decimal grossMarginImpact;
        Decimal grossProfitOnSalesOrder;
        Decimal netSale=0;
        Decimal grossMargin=0;
        Decimal grossProfit=0;
        Decimal totalDisc=0;
        Decimal totalD=0;
        List<PriceBookMaster__c> pbmList =new List<PriceBookMaster__c>();
        EmailTemplate template = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName ='Colombia_Template_For_Sales_Order_Line_Items'];
        
        Admin_MPT_Colombia__c mtpAdminObj =   [Select Id, of_adjustment_to_display_vendor_utility__c, Active__c,Level_1_max__c,Level_1_min__c,Level_2_max__c, Level_2_min__c, Level_3_below__c,
                                               Max_no_of_prod_asso_with_initial_product__c, Min_for_Profitable_in_result_by_margin__c, Sales_Org__c,USD_conversion_rate__c
                                               FROM Admin_MPT_Colombia__c 
                                               limit 1];
        
        
        System.debug('mtpAdminObj'+mtpAdminObj.of_adjustment_to_display_vendor_utility__c);
        List<Sales_Order__c> salesOrderList=[Select id,Name,Sent_for_Latam_Director_Approval__c,Sent_for_Director_Approval_Mexico__c,Sent_for_Manager_Approval_Mexico__c,Order_Type_Colombia__c from Sales_Order__c where id=:recId];
        System.debug('salesOrderList'+salesOrderList);
        String ErrorMessageForFinalPrice='';
        List<Account> acListForPgCode=[Select id,PG_Code__c,PriceGroupCode__c  from Account where id=:accountID ];
        System.debug('acListForPgCode'+acListForPgCode);
        Decimal adjustedPer=mtpAdminObj.of_adjustment_to_display_vendor_utility__c/100;
        // Decimal adjustedPer=5.12/100;
        System.debug('future method'+adjustedPer);
        String depotCodeId= [Select Id,Name ,Depot__c,SalesOrg__r.sales_org_code__c From Depot__c where Depot_Code__c ='CO51' LIMIT 1].Id;
        List<String> skuName = new List<String>();
        List<String> csvRowData = new List<String>();
        Map<Id,List<Sales_Order_Line_Item__c>> mapOfOrderVsSOI=new Map<Id,List<Sales_Order_Line_Item__c>>();
        Map<String, Shipping_Location__c> mapOfAccountShipLoc = new Map<String, Shipping_Location__c>();
        Map<String,SKU__c> mapSkuIDvsName = new  Map<String,SKU__c>();
        Map<String,PriceBookMaster__c> mapOfSKUAndPriceBook=new Map<String,PriceBookMaster__c>();
        
        list<Sales_Order_Line_Item__c> lstSOIToInsert = new list<Sales_Order_Line_Item__c>();
        list<Sales_Order_Line_Item__c> updatedSOIList = new list<Sales_Order_Line_Item__c>();
        list<priceBookMaster__c> pricebookmasterList=new List<priceBookMaster__c>();
        list<String> lstCSVLines = data.split('\r\n');
        
        List<String> csvLineItem = new List<String>();
        
        System.debug('lstCSVLines.size()'+lstCSVLines.size());
        
        
        csvLineItem = lstCSVLines[3].split(',');
        System.debug('csvLineItem'+csvLineItem);
        String csvLine = lstCSVLines[3];
        String prevLine = csvLine;
        Integer startIndex;
        Integer endIndex;
        
        for(Integer a= 3; a < lstCSVLines.size(); a++){
            
            
            csvLineItem = lstCSVLines[a].split(',');
            Sales_Order_Line_Item__c soiObj = new Sales_Order_Line_Item__c();
            Sales_Order_Line_Item__c intialSoiObj=new  Sales_Order_Line_Item__c();
            soiObj.Sale_Order__c=recId;
            soiObj.DepotDepot__c=depotCodeId;
            
            System.debug('csvLineItem[1].length()'+csvLineItem[1].length());
            if(csvLineItem[1].length()==7){
                skuName.add('00000000000'+csvLineItem[1].trim());
            }
            else if(csvLineItem[1].length()==6){
                skuName.add('000000000000'+csvLineItem[1].trim());
            }
            else if(csvLineItem[1].length()==5){
                skuName.add('0000000000000'+csvLineItem[1].trim());
            }
            System.debug('skuName'+skuName);
            
            soiObj.UOM__c=csvLineItem[2];
            
            //soiObj.Item_Number__c=decimal.valueOf(csvLineItem[3]);
            soiObj.Item_Number__c=a;
            soiObj.Quantity__c=decimal.valueOf(String.valueOf(csvLineItem[3].trim()));
            
            soiObj.Net_Price__c=decimal.valueOf(csvLineItem[4]);
            
            
            soiObj.FinalPrice__c=decimal.valueOf(csvLineItem[4]);
            
            soiObj.Delivery_Date__c=System.Today()+1;
            if(salesOrderList[0].Order_Type_Colombia__c=='MPT Order' && csvLineItem[5]!=''){
                soiObj.Business_Type_Colombia__c=csvLineItem[5];
            }
            
            
            soiObj.Price__c=decimal.valueOf(String.valueOf(csvLineItem[3].trim()))*decimal.valueOf(csvLineItem[4]);
            
            
            
            
            
            
            lstSOIToInsert.add(soiObj);
            System.debug('soiObj list @@ '+soiObj);
            
            
            
        }
        if(lstSOIToInsert!=null && !lstSOIToInsert.isEmpty())
        {
            try{
                insert lstSOIToInsert;
                System.debug('listt'+lstSOIToInsert);
            }
            catch(Exception e){
                System.debug('exception in SOI'+'#####'+e.getMessage() +'on line number'+e.getLineNumber());
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.optOutPolicy = 'FILTER';
                message.subject = system.label.Colombia_Plain_Text_Subject;
                String body =  'Hola,'+'<br/>';
                body +=e.getMessage() +'<br/>' ;
                body +='Por favor, póngase en contacto con el administrador del sistema' +'<br/>' ;
                body+='Gracias';
                message.setHtmlBody(body);
                message.setCcAddresses(new List<String>{'pragatisharma821@gmail.com'});
                message.setTargetObjectId(userInfo.getUserId());
                System.debug('userInfo.getUserId()'+userInfo.getUserId());
                message.setSaveAsActivity(false);
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                if (results[0].success) {
                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: '
                                 + results[0].errors[0].message);
                }
            }
            
        }
        
        if(lstSOIToInsert!=null && !lstSOIToInsert.isEmpty()){
            System.debug('after SOI insert');
            
            if(accountID!=null){
                pbmList =  [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                            SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c,
                            DepotCode__c, DepotCode__r.Location__c,SKUCode__r.UOM__c,
                            Price__c, PG_CODE__c, PG_CODE__r.Name,
                            UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Unit_Cost__c,
                            SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,
                            SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c
                            FROM PriceBookMaster__c
                            WHERE (DistributorCustomerCode__c =:accountID AND DepotCode__r.Location__c ='CO51')
                            AND SKUCode__r.Sales_Org__r.sales_org_code__c ='5710' 
                            AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True ];  
                
            }
            System.debug('pblist 390'+pbmList);
            
            if(pbmList.size()==0) {
                if(acListForPgCode[0].PriceGroupCode__c!=null){
                    System.debug('acListForPgCode[0].PriceGroupCode__c'+acListForPgCode[0].PriceGroupCode__c);
                    pbmList =  [SELECT Id, Director_Price__c,Manager_Price__c,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                                SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c,
                                DepotCode__c, DepotCode__r.Location__c,SKUCode__r.UOM__c,
                                Price__c, PG_CODE__c, PG_CODE__r.Name,SKUCode__r.Product_Category__c,
                                UOM__c, SKUCode__r.Product_Name__r.Name, SKUCode__r.Unit_Cost__c,
                                SKUCode__r.Product_Name__c, CurrencyIsoCode,SKUCode__r.Brand_Name__c,
                                SKUCode__r.Product_Name__r.Popular__c, SKUCode__r.SKU_Description__c,Final_Price__c,PG_CODE__r.Description_Colombia__c
                                FROM PriceBookMaster__c
                                WHERE (DepotCode__r.Location__c ='CO51' AND PG_CODE__c=:acListForPgCode[0].PriceGroupCode__c AND DistributorCustomerCode__c=null)
                                AND SKUCode__r.Sales_Org__r.sales_org_code__c ='5710' 
                                AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True  
                                ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC ];
                    System.debug('pbmList else'+pbmList);
                }
                
                else   {
                    System.debug('eneterd in a'+acListForPgCode[0].PG_Code__c);
                    pbmList =  [SELECT Id,SKUCode__c ,Division__c,MaxPrice__c,SKUCode__r.Multiple_Of__c,SKUCode__r.Name, 
                                SKUCode__r.SKU_Code__c,SKUCode__r.Pack_Size__c, MinPrice__c,DistributorCustomerCode__c
                                
                                FROM PriceBookMaster__c
                                WHERE (DepotCode__r.Location__c ='CO51' AND PG_CODE__r.PG_Code__c=:acListForPgCode[0].PG_Code__c AND DistributorCustomerCode__c=null)
                                AND SKUCode__r.Sales_Org__r.sales_org_code__c ='5710'  
                                AND StartDate__c <= TODAY AND EndDate__c >= TODAY AND SKUCode__r.Active__c = True  
                                ORDER BY SKUCode__r.Brand_Name__c ASC, SKUCode__r.SKU_Code__c DESC, StartDate__c ASC ];
                }
                
            }
            System.debug('pblist 422'+pbmList);
            if(pbmList.size()>0 && !pbmList.isEmpty()){
                System.debug('eneter in 409');
                for(PriceBookMaster__c pb:pbmList){
                    System.debug('pb'+pb.SKUCode__c);
                    if(!mapOfSKUAndPriceBook.containsKey(pb.SKUCode__c)){
                        mapOfSKUAndPriceBook.put(pb.SKUCode__c,pb) ; 
                        System.debug('mapOfSKUAndPriceBook'+mapOfSKUAndPriceBook);
                    }
                    else{
                        system.debug('pricebook already there');
                    }
                    
                }
            }
            
            
            List<SKU__c> skuList=[Select id,name,SKU_Code__c,Unit_Cost__c from SKU__c where SKU_Code__c in:skuName and Active__c =true];
            System.debug('skuList'+skuList);
            for (SKU__c s :skuList) {
                System.debug('266'+s);
                if(!mapSkuIDvsName.containsKey(s.SKU_Code__c)){
                    mapSkuIDvsName.put(s.SKU_Code__c,s);
                }
                else{
                    System.debug('sku already exists');
                }
            }
            System.debug('mapSkuIDvsName'+mapOfSKUAndPriceBook);
            for (Integer i = 0; i < lstSOIToInsert.size();i++) {
                //System.debug('map'+lstSOIToInsert[1]);
                //System.debug('lstSOIToInsert[i].id'+lstSOIToInsert[i].id);
                Sales_Order_Line_Item__c soiObj = lstSOIToInsert[i];
                Sales_Order_Line_Item__c intialSoiObj=new  Sales_Order_Line_Item__c();
                System.debug('soiObj429'+soiObj);
                //soiObj.id=lstSOIToInsert[i].id;
                
                
                SKU__c skuObj = mapSkuIDvsName.get(skuName[i]);
                System.debug('skuObj'+skuObj);
                if(skuObj!=null){
                    soiObj.SKU_Name__c=skuObj.id;
                    
                    System.debug('Null for sku'+skuObj);
                    soiObj.Unit_Price__c=skuObj.Unit_Cost__c;
                    
                    System.debug('soiObj.SKU_Name__c'+ soiObj.SKU_Name__c);
                    System.debug('soiObj.Unit_Price__c'+ soiObj.Unit_Price__c);
                    if(salesOrderList[0].Order_Type_Colombia__c=='Normal Order'){
                        if(soiObj.Unit_Price__c!=null && soiObj.Quantity__c!=null ){
                            soiObj.Profit_colombia__c = adjustedPer*(soiObj.Price__c-(soiObj.Quantity__c*soiObj.Unit_Price__c));
                        }
                        if(!mapOfSKUAndPriceBook.isEmpty()){
                            soiObj.MinPrice__c=mapOfSKUAndPriceBook.get(soiObj.SKU_Name__c).MinPrice__c;
                            soiObj.MaxPrice__c=mapOfSKUAndPriceBook.get(soiObj.SKU_Name__c).Price__c;
                            soiObj.Discount_Per_colombia__c = (1-(soiObj.Unit_Price__c/soiObj.MaxPrice__c))*100;
                            soiObj.Discount_Value_colombia__c= (soiObj.Discount_Per_colombia__c/100)*(soiObj.MaxPrice__c*soiObj.Quantity__c);
                        }
                        soiObj.Net_Margin_colombia__c =  (soiObj.Profit_colombia__c/soiObj.Price__c)*100;
                        netSale += soiObj.Price__c;
                        grossProfit += soiObj.Profit_colombia__c;
                        grossMargin = (grossProfit / netSale ) *100;
                        totalD += soiObj.Discount_Per_colombia__c;
                        system.debug('totalD--'+totalD+'totalSales--'+netSale);
                        totalDisc = (totalD/netSale)*100;
                        
                        if(soiObj.MinPrice__c>soiObj.FinalPrice__c){
                            System.debug('soiObj.MinPrice__c 505'+soiObj.MinPrice__c);
                            System.debug('soiObj.FinalPrice__c 473'+soiObj.FinalPrice__c);
                            ErrorMessageForFinalPrice=system.label.Colombia_Error_On_Final_Price +soiObj.FinalPrice__c+' en '+skuName[i] +'. '+ system.label.Colombia_Final_Price_Error_on_Normal_Order ;  
                        }
                        if(soiObj.Net_Margin_colombia__c <= mtpAdminObj.Level_1_max__c && soiObj.Net_Margin_colombia__c >= mtpAdminObj.Level_1_min__c){
                            system.debug('soiObj.Net_Margin_colombia__c'+soiObj.Net_Margin_colombia__c);
                            salesOrderList[0].Sent_for_Manager_Approval_Mexico__c =true;
                        }
                        if(soiObj.Net_Margin_colombia__c <= mtpAdminObj.Level_2_max__c && soiObj.Net_Margin_colombia__c >= mtpAdminObj.Level_2_min__c){
                            system.debug('soiObj.Net_Margin_colombia__c2'+soiObj.Net_Margin_colombia__c);
                            salesOrderList[0].Sent_for_Manager_Approval_Mexico__c = true;
                            salesOrderList[0].Sent_for_Director_Approval_Mexico__c= true;
                        }
                        if(soiObj.Net_Margin_colombia__c <= mtpAdminObj.Level_3_below__c){
                            system.debug('soiObj.Net_Margin_colombia__c3'+soiObj.Net_Margin_colombia__c);
                            salesOrderList[0].Sent_for_Manager_Approval_Mexico__c = true;
                            salesOrderList[0].Sent_for_Director_Approval_Mexico__c= true;
                            salesOrderList[0].Sent_for_Latam_Director_Approval__c =true;
                        }
                    }
                    if(salesOrderList[0].Order_Type_Colombia__c == 'MPT Order'){
                        System.debug('eneter MPT'+soiObj.Price__c+'@@'+soiObj.Quantity__c+'price'+soiObj.Unit_Price__c);
                        if(soiObj.Unit_Price__c!=null && soiObj.Quantity__c!=null ){
                            soiObj.Profit_colombia__c = adjustedPer*(soiObj.Price__c-(soiObj.Quantity__c*soiObj.Unit_Price__c));
                        }
                        System.debug('Profit_colombia__c'+soiObj.Profit_colombia__c+'soiObj.Price__c'+soiObj.Price__c);
                        System.debug('Quantity__c'+soiObj.Quantity__c+'soiObj.Unit_Price__c'+soiObj.Unit_Price__c);
                        if(soiObj.Business_Type_Colombia__c=='Producto Inicial '){
                            QuantityOnSalesOrder=null;
                            soiObj.Net_Price__c=soiObj.Price__c/soiObj.Quantity__c;
                            
                            System.debug('Producto');
                            
                            if(!mapOfSKUAndPriceBook.isEmpty()){
                                System.debug('eneter in map '+mapOfSKUAndPriceBook.get(soiObj.SKU_Name__c).MinPrice__c+'PRICE'+mapOfSKUAndPriceBook.get(soiObj.SKU_Name__c).Price__c);
                                soiObj.MinPrice__c=mapOfSKUAndPriceBook.get(soiObj.SKU_Name__c).MinPrice__c;
                                soiObj.MaxPrice__c=mapOfSKUAndPriceBook.get(soiObj.SKU_Name__c).Price__c;
                                
                            }
                            System.debug('max'+ soiObj.MinPrice__c);
                            System.debug('max1'+ soiObj.MaxPrice__c);
                            System.debug('max2'+ soiObj.MinPrice__c);
                            System.debug('max3'+ soiObj.Discount_Per_colombia__c);
                            soiObj.Discount_Per_colombia__c = ((soiObj.Net_Price__c/soiObj.MaxPrice__c)-1)*100;
                            soiObj.Discount_Value_colombia__c=0;
                            System.debug('grossMarginImpact'+grossMarginImpact);
                            if(soiObj.Profit_colombia__c!=null && soiObj.Price__c!=null){
                                if(grossMarginImpact==null){ 
                                    grossMarginImpact=(soiObj.Profit_colombia__c/soiObj.Price__c)*100;
                                }
                                else{
                                    Decimal grossMarginImpact1=(soiObj.Profit_colombia__c/soiObj.Price__c)*100;
                                    grossMarginImpact=grossMarginImpact+grossMarginImpact1; 
                                }
                                
                            }
                            
                            System.debug('grossMarginImpact 542 '+grossMarginImpact);
                            soiObj.Net_Margin_colombia__c =  (soiObj.Profit_colombia__c/soiObj.Price__c)*100;
                            
                            System.debug('intialSoiObj.Net_Price__c @@@ '+intialSoiObj.Net_Price__c);
                            if(soiObj.Net_Margin_colombia__c <= mtpAdminObj.Level_1_max__c && soiObj.Net_Margin_colombia__c >= mtpAdminObj.Level_1_min__c){
                                system.debug('soiObj.Net_Margin_colombia__c'+soiObj.Net_Margin_colombia__c);
                                salesOrderList[0].Sent_for_Manager_Approval_Mexico__c =true;
                            }
                            if(soiObj.Net_Margin_colombia__c <= mtpAdminObj.Level_2_max__c && soiObj.Net_Margin_colombia__c >= mtpAdminObj.Level_2_min__c){
                                system.debug('soiObj.Net_Margin_colombia__c2'+soiObj.Net_Margin_colombia__c);
                                salesOrderList[0].Sent_for_Manager_Approval_Mexico__c = true;
                                
                                salesOrderList[0].Sent_for_Director_Approval_Mexico__c= true;
                            }
                            if(soiObj.Net_Margin_colombia__c <= mtpAdminObj.Level_3_below__c){
                                system.debug('soiObj.Net_Margin_colombia__c3'+soiObj.Net_Margin_colombia__c);
                                salesOrderList[0].Sent_for_Manager_Approval_Mexico__c = true;
                                salesOrderList[0].Sent_for_Director_Approval_Mexico__c= true;
                                salesOrderList[0].Sent_for_Latam_Director_Approval__c =true;
                            }
                        }
                        else if(soiObj.Business_Type_Colombia__c=='Impacto Producto') {
                            System.debug('eneter in impacto produto');
                            for(integer j=i-1;j>=0;j--){
                                System.debug('j'+j+'lstSOIToInsert[j].Business_Type_Colombia__c'+lstSOIToInsert[j].Business_Type_Colombia__c);
                                if(lstSOIToInsert[j].Business_Type_Colombia__c=='Producto Inicial '){
                                    System.debug('j@@222 '+j);
                                    IntialProduct=j;
                                }
                                break;
                            }
                            if(!mapOfSKUAndPriceBook.isEmpty()){
                                System.debug('mapOfSKUAndPriceBook'+mapOfSKUAndPriceBook.get(soiObj.SKU_Name__c).Price__c+' soiObj.SKU_Name__c' +soiObj.SKU_Name__c);
                                soiObj.FinalPrice__c=mapOfSKUAndPriceBook.get(soiObj.SKU_Name__c).Price__c;
                                soiObj.MaxPrice__c=mapOfSKUAndPriceBook.get(soiObj.SKU_Name__c).Price__c;
                                System.debug('soiObj.FinalPrice__c'+soiObj.FinalPrice__c +' soiObj.MaxPrice__c'+ soiObj.MaxPrice__c);
                                soiObj.Discount_Value_colombia__c = soiObj.MaxPrice__c*soiObj.Quantity__c;
                            }
                            //System.debug('IntialProduct'+IntialProduct+'@@@@@@@ '+lstSOIToInsert[IntialProduct].Price__c);
                            
                            if(lstSOIToInsert[IntialProduct].Business_Type_Colombia__c=='Producto Inicial '){
                                System.debug('impactoo'+lstSOIToInsert[IntialProduct]);
                                intialSoiObj =lstSOIToInsert[IntialProduct];
                                if(!mapOfSKUAndPriceBook.isEmpty()){
                                    
                                    soiObj.FinalPrice__c=mapOfSKUAndPriceBook.get(soiObj.SKU_Name__c).Price__c;
                                    soiObj.MaxPrice__c=mapOfSKUAndPriceBook.get(soiObj.SKU_Name__c).Price__c;
                                    soiObj.Discount_Per_colombia__c =  soiObj.MaxPrice__c*soiObj.Quantity__c;
                                }
                                System.debug('intialSoiObj'+intialSoiObj.SKU_Name__c);
                                if(soiObj.SKU_Name__c==intialSoiObj.SKU_Name__c){
                                    system.debug('sku name is same');
                                    if(QuantityOnSalesOrder==null){
                                        QuantityOnSalesOrder=intialSoiObj.Quantity__c +soiObj.Quantity__c;
                                        System.debug('QuantityOnSalesOrder1'+QuantityOnSalesOrder);
                                    }
                                    else
                                    {
                                        QuantityOnSalesOrder=QuantityOnSalesOrder+soiObj.Quantity__c;
                                        System.debug('QuantityOnSalesOrder2'+QuantityOnSalesOrder);
                                    }
                                    
                                    intialSoiObj.Profit_colombia__c =adjustedPer*(intialSoiObj.Price__c-(intialSoiObj.Quantity__c*intialSoiObj.Unit_Price__c));
                                    System.debug('intialSoiObj.Profit_colombia__c'+intialSoiObj.Profit_colombia__c+' intialSoiObj.Net_Price__c'+ intialSoiObj.Net_Price__c+'intialSoiObj.Price__c'+intialSoiObj.Price__c);
                                    System.debug('intialSoiObj.Price__c'+intialSoiObj.Price__c);
                                    System.debug('QuantityOnSalesOrder2'+QuantityOnSalesOrder +'@@ '+intialSoiObj.Net_Price__c+'price ## '+intialSoiObj.Price__c);
                                    intialSoiObj.Net_Price__c=intialSoiObj.Price__c/QuantityOnSalesOrder;
                                    System.debug(' intialSoiObj.Net_Price__c'+ intialSoiObj.Net_Price__c);
                                    soiObj.Net_Margin_colombia__c =  (soiObj.Profit_colombia__c/soiObj.Price__c)*100;
                                    
                                    
                                }
                                if(soiObj.SKU_Name__c!=intialSoiObj.SKU_Name__c){
                                    system.debug('sku name is not same');
                                    if(QuantityOnSalesOrder==null){
                                        QuantityOnSalesOrder=intialSoiObj.Quantity__c +soiObj.Quantity__c;
                                        System.debug('QuantityOnSalesOrder'+QuantityOnSalesOrder);
                                    }
                                    else
                                    {
                                        QuantityOnSalesOrder=QuantityOnSalesOrder +soiObj.Quantity__c; 
                                        System.debug('QuantityOnSalesOrder else '+QuantityOnSalesOrder);
                                    }
                                    
                                    intialSoiObj.Profit_colombia__c =intialSoiObj.Profit_colombia__c+ adjustedPer*(intialSoiObj.Price__c-(intialSoiObj.Quantity__c*intialSoiObj.Unit_Price__c));
                                    if(!mapOfSKUAndPriceBook.isEmpty()){
                                        
                                        soiObj.FinalPrice__c=mapOfSKUAndPriceBook.get(soiObj.SKU_Name__c).Price__c;
                                        soiObj.MaxPrice__c=mapOfSKUAndPriceBook.get(soiObj.SKU_Name__c).Price__c;
                                        if(discountOnSalesOrder==null){
                                            discountOnSalesOrder=((soiObj.MaxPrice__c*soiObj.Quantity__c)/intialSoiObj.Price__c)*100; 
                                        }
                                        else{
                                            discountOnSalesOrder=discountOnSalesOrder+(((soiObj.MaxPrice__c*soiObj.Quantity__c)/intialSoiObj.Price__c)*100); 
                                        }
                                        intialSoiObj.Discount_Per_colombia__c = -((intialSoiObj.Net_Price__c/ soiObj.MaxPrice__c)-1)*100;
                                        System.debug('intialSoiObj.Discount_Per_colombia__c'+intialSoiObj.Discount_Per_colombia__c);
                                        intialSoiObj.Net_Margin_colombia__c =  (intialSoiObj.Profit_colombia__c/intialSoiObj.Price__c)*100;
                                        intialSoiObj.Margin_colombia__c =  ((intialSoiObj.Profit_colombia__c+soiObj.Profit_colombia__c)/intialSoiObj.Price__c)*100;
                                        System.debug('intialSoiObj.Margin_colombia__c'+intialSoiObj.Margin_colombia__c);
                                        intialSoiObj.Net_Price__c=  ((intialSoiObj.Price__c-(soiObj.MaxPrice__c*soiObj.Quantity__c))/intialSoiObj.Quantity__c);
                                    }
                                    
                                    
                                }
                                System.debug('intial'+intialSoiObj);
                                
                                
                                
                                soiObj.Price__c =0;
                                
                                soiObj.Net_Price__c = 0;
                                soiObj.Profit_colombia__c=adjustedPer*(soiObj.Net_Price__c-(soiObj.Quantity__c*soiObj.Unit_Price__c));
                                System.debug('soiObj.Profit_colombia__c'+(intialSoiObj.Profit_colombia__c+soiObj.Profit_colombia__c));
                                if(!mapOfSKUAndPriceBook.isEmpty()){
                                    
                                    soiObj.FinalPrice__c=mapOfSKUAndPriceBook.get(soiObj.SKU_Name__c).Price__c;
                                    soiObj.MaxPrice__c=mapOfSKUAndPriceBook.get(soiObj.SKU_Name__c).Price__c;
                                    if(discountOnSalesOrder==null){
                                        discountOnSalesOrder=((soiObj.MaxPrice__c*soiObj.Quantity__c)/intialSoiObj.Price__c)*100; 
                                    }
                                    else{
                                        discountOnSalesOrder=discountOnSalesOrder+(((soiObj.MaxPrice__c*soiObj.Quantity__c)/intialSoiObj.Price__c)*100); 
                                    }
                                    intialSoiObj.Discount_Per_colombia__c = -((intialSoiObj.Net_Price__c/ soiObj.MaxPrice__c)-1)*100;
                                    intialSoiObj.Net_Margin_colombia__c =  (intialSoiObj.Profit_colombia__c/intialSoiObj.Price__c)*100;
                                    intialSoiObj.Margin_colombia__c =  ((intialSoiObj.Profit_colombia__c+soiObj.Profit_colombia__c)/intialSoiObj.Price__c)*100;
                                    System.debug('intialSoiObj.Margin_colombia__c'+intialSoiObj.Margin_colombia__c);
                                }
                                System.debug('grossMarginImpact 1'+grossMarginImpact);
                                if(grossMarginImpact==null){
                                    grossMarginImpact=((intialSoiObj.Profit_colombia__c+soiObj.Profit_colombia__c)/intialSoiObj.Price__c)*100;
                                }
                                else{
                                    Decimal grossMarginImpact1= ((intialSoiObj.Profit_colombia__c+soiObj.Profit_colombia__c)/intialSoiObj.Price__c)*100;
                                    grossMarginImpact=grossMarginImpact+grossMarginImpact1;
                                }
                                
                                System.debug('grossMarginImpact 2 after '+grossMarginImpact);
                                //Decimal netSalesForDiscount=soiObj.Price__c/soiObj.Quantity__c;
                                //soiObj.Discount_Value_colombia__c=-((netSalesForDiscount/soiObj.MaxPrice__c)-1)*100;
                                
                                soiObj.Discount_Per_colombia__c = 0;
                                // soiObj.Discount_Value_colombia__c= (soiObj.Discount_Per_colombia__c/100)*(soiObj.MaxPrice__c*soiObj.Quantity__c);
                                soiObj.Margin_colombia__c = 0;
                                soiObj.Net_Margin_colombia__c =0;
                                
                            }
                        }
                        
                        else if(soiObj.Business_Type_Colombia__c =='Impacto Negocio'){
                            system.debug('eneter in nego'+i);
                            for(integer j=i-1;j>=0;j--){
                                System.debug('j'+j+'lstSOIToInsert[j].Business_Type_Colombia__c'+lstSOIToInsert[j].Business_Type_Colombia__c);
                                if(lstSOIToInsert[j].Business_Type_Colombia__c=='Producto Inicial '){
                                    
                                    IntialProduct=j;
                                    break;
                                }
                                System.debug('j@@222 '+j+'lstSOIToInsert[IntialProduct].Business_Type_Colombia__c'+lstSOIToInsert[IntialProduct].Business_Type_Colombia__c);
                                
                            }
                            if(lstSOIToInsert[IntialProduct].Business_Type_Colombia__c=='Producto Inicial '){
                                System.debug('eneter in 652');
                                intialSoiObj =lstSOIToInsert[IntialProduct];
                                if(QuantityOnSalesOrder==null){
                                    QuantityOnSalesOrder=intialSoiObj.Quantity__c +soiObj.Quantity__c;
                                    System.debug('QuantityOnSalesOrder1 nego'+QuantityOnSalesOrder);
                                }
                                else
                                {
                                    QuantityOnSalesOrder=QuantityOnSalesOrder+soiObj.Quantity__c;
                                    System.debug('QuantityOnSalesOrder2 nego'+QuantityOnSalesOrder);
                                }
                                
                                soiObj.Discount_Per_colombia__c=100;
                                soiObj.Discount_Value_colombia__c=soiObj.Quantity__c*soiObj.FinalPrice__c;
                                if(!mapOfSKUAndPriceBook.isEmpty()){
                                    soiObj.MinPrice__c=mapOfSKUAndPriceBook.get(soiObj.SKU_Name__c).MinPrice__c;
                                    soiObj.MaxPrice__c=mapOfSKUAndPriceBook.get(soiObj.SKU_Name__c).Price__c;
                                    
                                }
                                //soiObj.FinalPrice__c=0;
                                
                                soiObj.Price__c=0;
                                soiObj.Net_Price__c = 0;
                                soiObj.Profit_colombia__c=adjustedPer*(soiObj.Net_Price__c-(soiObj.Quantity__c*soiObj.Unit_Price__c));
                                intialSoiObj.Profit_colombia__c =adjustedPer*(intialSoiObj.Price__c-(intialSoiObj.Quantity__c*intialSoiObj.Unit_Price__c));
                                System.debug('soiObj.Profit_colombia__c 662 '+soiObj.Profit_colombia__c+'intialSoiObj.Profit_colombia__c '+intialSoiObj.Profit_colombia__c);
                                intialSoiObj.Profit_colombia__c=intialSoiObj.Profit_colombia__c;
                                System.debug('intialSoiObj.Profit_colombia__c'+intialSoiObj.Profit_colombia__c);
                                System.debug('grossMarginImpact 702'+grossMarginImpact+'$$ '+(intialSoiObj.Profit_colombia__c+(soiObj.Profit_colombia__c)));
                                if(grossMarginImpact==null){
                                    grossMarginImpact=((intialSoiObj.Profit_colombia__c+(soiObj.Profit_colombia__c))/intialSoiObj.Price__c)*100;
                                }
                                else{
                                    Decimal grossMarginImpact1=((intialSoiObj.Profit_colombia__c+(soiObj.Profit_colombia__c))/intialSoiObj.Price__c)*100;
                                    grossMarginImpact=grossMarginImpact+grossMarginImpact1;
                                    
                                }
                                
                            }
                            
                            System.debug('business impact ends'+grossMarginImpact); 
                        }
                        netSale+=soiObj.Price__c;
                        grossProfit +=soiObj.Profit_colombia__c;
                        
                        grossMargin = (grossProfit / netSale ) *100;
                        totalD+=soiObj.Discount_Per_colombia__c;
                        System.debug('totalD'+totalD);
                        totalDisc=(totalD/netSale)*100;
                        System.debug('totral'+totalDisc);
                        
                        
                        System.debug('netSale'+netSale);
                        System.debug('grossProfit'+grossProfit);
                        System.debug('grossMargin'+grossMargin);
                        
                    }
                    
                    // updatedSOIList.add(intialSoiObj);
                    updatedSOIList.add(soiObj); 
                    System.debug('updatedSOIList'+updatedSOIList);
                    
                }
                
                
            }
            
            if(updatedSOIList!=null && !updatedSOIList.isEmpty()){
                try{
                    if(ErrorMessageForFinalPrice!=''){
                        System.debug('error message'+ErrorMessageForFinalPrice);
                        delete updatedSOIList;
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.optOutPolicy = 'FILTER';
                        message.setSubject(system.label.Colombia_Plain_Text_Subject);
                        String body =  'Hola,'+'<br/>';
                        body +=ErrorMessageForFinalPrice +'<br/>' ;
                        body+='Gracias';
                        message.setHtmlBody(body);
                        message.setCcAddresses(new List<String>{'pragatisharma821@gmail.com'});
                        message.setTargetObjectId(userInfo.getUserId());
                        System.debug('userInfo.getUserId()'+userInfo.getUserId());
                        message.setSaveAsActivity(false);
                        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                        if (results[0].success) {
                            System.debug('The email was sent successfully.');
                        } else {
                            System.debug('The email failed to send: '
                                         + results[0].errors[0].message);
                        }
                    }
                    else{
                        System.debug('upd'+updatedSOIList);
                        System.debug('salesOrderList[0].Name'+salesOrderList[0].Name);
                        upsert updatedSOIList;
                        update salesOrderList[0];
                        
                        String sfUrl = system.url.getsalesforcebaseurl().toexternalform();
                        
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        
                        message.setTemplateID(template.Id);
                        message.setWhatId(salesOrderList[0].Id);
                        String htmlBody = template.HtmlValue;
                        String subject=template.Subject;
                        System.debug('htmlBody'+htmlBody);
                        htmlBody = htmlBody.replace('{!Sales_Order__c.Name}',salesOrderList[0].Name);
                        htmlBody = htmlBody.replace('{!Sales_Order__c.Link}','<a href="'+URL.getSalesforceBaseUrl().toExternalForm() + '/' + salesOrderList[0].Id+'">'+URL.getSalesforceBaseUrl().toExternalForm() + '/' + salesOrderList[0].Id+'</a>');
                        System.debug('htmlBody 1'+htmlBody);
                        message.setHtmlBody(htmlBody);
                        message.setSubject(subject);
                        message.setCcAddresses(new List<String>{'pragati.sharma@upl-ltd.com'});
                        message.setTargetObjectId(userInfo.getUserId());
                        
                        System.debug('userInfo.getUserId()'+userInfo.getUserId());
                        message.setSaveAsActivity(false);
                        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                            System.debug('messages'+messages);
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                        System.debug('messages 609'+results);
                        if (results[0].success) {
                            System.debug('The email was sent successfully after success.');
                        } else {
                            System.debug('The email failed to send: '
                                         + results[0].errors[0].message);
                        }
                    }
                    
                }
                Catch(Exception e){
                    System.debug('exception in SOI'+'#####'+e.getMessage() +'on line number'+e.getLineNumber()); 
                }
            }
            
            
            
            
            List<Sales_Order__c> SOToUpdateStatus=new List<Sales_Order__c>();
            if(recId!=null){
                System.debug('saledorder'+recId);
                for(Sales_Order__c so:[Select id,Order_Status__c,Total_Discount_Per_Colombia__c,Sent_for_Manager_Approval_Mexico__c,Sent_for_Director_Approval_Mexico__c,Sent_for_Latam_Director_Approval__c from Sales_Order__c where id =:recId]){
                    System.debug('soList'+so);
                    
                    
                    so.Gross_Margin_Per_Colombia__c=grossMargin;
                    
                    
                    
                    if(so.Order_Status__c=='Submitted' && (so.Sent_for_Manager_Approval_Mexico__c || so.Sent_for_Director_Approval_Mexico__c || so.Sent_for_Latam_Director_Approval__c)){
                        System.debug('firsy');
                        so.Order_Status__c = 'Pending';
                        so.Colombia_Order_Submitted_for_Approval__c = false;
                        SOToUpdateStatus.add(so);
                    }
                    else
                        if(!so.Sent_for_Manager_Approval_Mexico__c && !so.Sent_for_Director_Approval_Mexico__c && !so.Sent_for_Latam_Director_Approval__c && so.Order_Status__c == 'Submitted'){
                            System.debug('second');
                            so.Order_Status__c = 'Open';
                            SOToUpdateStatus.add(so);
                        }
                    
                } 
                if(SOToUpdateStatus!=null && !SOToUpdateStatus.isEmpty()){
                    update SOToUpdateStatus;
                }
            }
            
            
        }   
        
    }
}