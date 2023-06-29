/**************************************************************************************************
* Name             : grz_SalesOrderReturnFnlController                                                      
* Description      : Controller for the grz_SalesOrderReturnFnl and grz_SalesOrderReturnReprocess LWC component  
that fetches data from the sales order and provides certain validations related to it's return.  
* Test Class       : grz_SalesOrderReturnFnlControllerTest
* Created Date     : 03-11-2022                                                                        
* Project/JIRA     : APPS-2818                                                                        
* Created By       : Butesh Singhla (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 06-03-2023                                                                        
**************************************************************************************************/


public class grz_SalesOrderReturnFnlController {
    
    @AuraEnabled(cacheable=true)
    public static String GenerateToken(){
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Expiry_Date_SAP_Token');
        req.setTimeout(120000);
        req.setMethod('POST');
        HTTPresponse res= http.send(req);
        Map<String, Object> response= ( Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        Object token = (Object)response.get('access_token');
        return token.toString();
    }
    
    @AuraEnabled(cacheable=true)
    public static data getDetails(String invoiceId){
        
        String token = GenerateToken();
        system.debug(token);
        
        data d = new data();
        boolean error = false;
        String errorMsg = '';
        List<Sales_Order_Return_Config__c> configMonths = new List<Sales_Order_Return_Config__c>();
        List<Invoice__c> inv = new List<Invoice__c>();
        List<Invoice_Line_Item__c> invLineItem = new List<Invoice_Line_Item__c>();
        List<InvLinItem> InvoItemList = new List<InvLinItem>();
        List<pickVals> picVaLst = new List<pickVals>();
        //pickVals picVa = new pickVals();
        
        String ObjectApiName = 'Return_Sales_Order__c';
        String FieldApiName = 'Order_Reason__c';
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Return_Sales_Order__c.Order_Reason__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickVals p = new pickVals();
            p.label = pickListVal.getLabel();
            p.value = pickListVal.getValue();
            picVaLst.add(p);
        } 
        
        d.picks = picVaLst;
        
        
        configMonths = [select id,Months__c,sales_org__c from Sales_Order_Return_Config__c limit 1];
        inv = [select id,name,Billing_Date__c,Sales_Org_Code__c,Sold_To_Party__c,Billing_Doc_Number__c,Sales_Order__r.id,Sales_Order__r.sold_to_party__c,Sales_Order__r.sold_to_party__r.name,Sales_Order__r.name,Sales_Org__r.name,Sales_Order__r.sold_to_party__r.sap_customer_code__c from invoice__c where id =: invoiceId Limit 1];
        /*integer netAmt=0;
        if(inv[0].Sold_To_Party__c!=null){
            AggregateResult arI = [SELECT SUM(TotalAmount__c)ta FROM Invoice__c WHERE Sold_To_Party__c=:inv[0].Sold_To_Party__c AND Billing_Date__c = THIS_FISCAL_YEAR];
            integer totalAmtInv=integer.valueOf(arI.get('ta'));
            AggregateResult arR = [SELECT SUM(Total_Amount__c)ta FROM Return_Sales_Order__c WHERE Sold_To_Party1__c=:inv[0].Sold_To_Party__c AND Order_Status__c='Completely processed' AND Order_Date__c = THIS_FISCAL_YEAR];
            integer totalAmtRet=integer.valueOf(arR.get('ta'));
            if(totalAmtRet==null)totalAmtRet=0;
            if(totalAmtInv>totalAmtRet){
                netAmt=totalAmtInv-totalAmtRet;
            }
        }
        d.ytdAmt=netAmt;*/
        if(configMonths.size() > 0){
            if(configMonths[0].sales_org__c != '' && configMonths[0].sales_org__c != null && inv[0].Sales_Org_Code__c != '' || inv[0].Sales_Org_Code__c != null){
                if(!configMonths[0].sales_org__c.contains(inv[0].Sales_Org_Code__c)){
                    if(error == false){
                        error = true;
                        errorMsg = 'Return not available for this sales org. Valid sales org codes are : '+configMonths[0].sales_org__c;
                    }
                }
            }else{
                if(error == false){
                    error = true;
                    errorMsg = 'Return not available for this sales org.';
                }
            }
        }else{
            if(error == false){
                error = true;
                errorMsg = 'Return not available for this sales org.';
            }
        }
        for(Invoice__c invo : inv){
            /*if(configMonths.size() > 0){
                if(invo.Billing_Date__c < date.today().addMonths(integer.valueof(configMonths[0].months__c) * -1)){
                    if(error == false){
                        error = true;
                        errorMsg = 'Invoice billing date is older than '+configMonths[0].months__c+' months. Kindly E-mail the UPL team for further information on the return.';
                    }
                }
            }*/
            d.salesOrdername = invo.Sales_Order__r.name;
            d.billingDocNum = invo.Billing_Doc_Number__c;
            d.salesOrgName = invo.Sales_Org__r.name;
            d.InvoiceName = invo.name;
        }
        map<string,double>pro2vol=new map<string,double>();
        map<string,date>inl2up=new map<string,date>();
        //{"Item_Key":"1449660078000020","SKU":"000000000000567004","Depot":"BEL1","Batch":"LSYRAM3502"}
        invLineItem = [select SKU_Description__c,SKU_Code__c,Invoice_Item_Key__c,Invoice__r.Depot__c,Expire_Date__c,Invoice__r.Depot__r.Depot_Code__c,id,name,Batch__c,Product__r.name,Quantity__c,Net_Price_Per_Unit__c,Net_Value__c,UOM__c,(select id, quantity__c from Return_Sales_Order_Line_Items__r where Status__c in ('Completely processed','Partially rejected')) from Invoice_Line_Item__c where invoice__c =: invoiceId];
        if(invLineItem.size() > 0){
            for(Invoice_Line_Item__c il : invLineItem){
                system.debug(il.expire_date__c+'==========Exp');
                if(il.expire_date__c==null){
                    if(il.SKU_Code__c!=null&&il.Invoice_Item_Key__c!=null&&il.Batch__c!=null&&il.Invoice__r.Depot__c!=null&&il.Invoice__r.Depot__r.Depot_Code__c!=null){
                        map<string,object> reqPar=new map<string,object>{'Item_Key'=>il.Invoice_Item_Key__c,'SKU'=>il.SKU_Code__c,'Depot'=>il.Invoice__r.Depot__r.Depot_Code__c,'Batch'=>il.Batch__c};
                            Http http = new Http(); 
                        HttpRequest req = new HttpRequest();
                        
                        req.setEndpoint('https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/Fetch_Batch_Expiry_Date');
                        req.setTimeout(120000);
                        req.setHeader('Authorization', 'Bearer '+token);
                        req.setHeader('Content-Type', 'application/json');
                        req.setMethod('POST');
                        String body = JSON.serialize(reqPar);
                        req.setBody(body);
                        string response;
                        try{
                            HTTPresponse res= http.send(req);
                            if(res.getStatusCode() == 200){
                            system.debug(res.getBody());
                                response = res.getBody();
                                map<string,object>respMap=(map<string,object>)JSON.deserializeUntyped(response);
                                if(respMap.containsKey('Expire_Date'))il.Expire_Date__c=date.valueOf(string.valueOf(respMap.get('Expire_Date')));
                                inl2up.put(il.id,il.Expire_Date__c);
                                system.debug('response@@@@+++>'+JSON.serializePretty(response));
                            }
                        }catch(Exception e){
                            system.debug('exceptio**************'+e);
                        }
                    }
                }
            }
            if(inl2up.keySet().size()>0 && !test.isRunningTest())upINV(inl2up);
            for(Invoice_Line_Item__c INVLT : invLineItem){
                pro2vol.put(INVLT.Product__r.name,0);
                Decimal alreadyReturnedval = 0;
                for(Return_Sales_Order_Line_Item__c retLineItem : INVLT.Return_Sales_Order_Line_Items__r){
                    alreadyReturnedval = alreadyReturnedval+retLineItem.quantity__c;
                }
                InvLinItem inn = new InvLinItem(); 
                inn.id = INVLT.id+'@_@_@_@'+(INVLT.Quantity__c-alreadyReturnedval)+'@_@_@_@'+INVLT.UOM__c;
                inn.name = INVLT.name;
                inn.proname = INVLT.SKU_Description__c;
                inn.product = INVLT.Product__r.name;
                inn.totalQnty = INVLT.Quantity__c;
                inn.alreadyReturned = alreadyReturnedval;
                inn.netValue = INVLT.Net_Value__c;
                inn.netValuePerUnit = INVLT.Net_Price_Per_Unit__c;
                inn.uom = INVLT.UOM__c;
                inn.batch = INVLT.Batch__c;
                inn.expDate = INVLT.Expire_Date__c;
                inn.netValueReturned = 0;
                InvoItemList.add(inn);
            }
        }else{
            if(error == false){
                error = true;
                errorMsg = 'This Invoice does not have any Invoice line items related to it.';
            }
        }
        d.InvoiceLineItemList = InvoItemList;
                    
            for(Invoice_Line_Item__c fi:[select id,name,Product__r.name,Quantity__c from Invoice_Line_Item__c where Invoice__r.Sales_Order__r.sold_to_party__c =:inv[0].Sales_Order__r.sold_to_party__c AND  Invoice__r.Billing_Date__c=THIS_FISCAL_YEAR AND Product__r.name in :pro2vol.keySet() AND Invoice__r.Sales_Order__r.Order_Status__c ='Completely processed' AND Quantity__c!=null]){
                pro2vol.put(fi.Product__r.name,(pro2vol.get(fi.Product__r.name)+fi.Quantity__c));
            }
            
            for(Return_Sales_Order_Line_Item__c fi:[select Product__c,Quantity__c from Return_Sales_Order_Line_Item__c WHERE Status__c in ('Completely processed','Partially processed') AND Product__c in: pro2vol.keySet() AND Return_Sales_Order__r.Invoice__r.Billing_Date__c = THIS_FISCAL_YEAR AND Return_Sales_Order__r.Invoice__r.Sales_Order__r.sold_to_party__c =:inv[0].Sales_Order__r.sold_to_party__c AND Quantity__c != null]){
                pro2vol.put(fi.Product__c,(pro2vol.get(fi.Product__c)-fi.Quantity__c));
            }
            d.volMap=pro2vol;

        List<Return_Sales_Order__c> retSalesOrder = new List<Return_Sales_Order__c>();
        retSalesOrder = [select id,name,Order_Status__c,Order_Reason__c from Return_Sales_Order__c where SalesOrder__c =: inv[0].Sales_Order__r.id];
        if(retSalesOrder.size() > 0){
            for(Return_Sales_Order__c r : retSalesOrder){
                if(r.Order_Status__c != 'Return Order Cancelled' && r.Order_Status__c != 'Rejected' && r.Order_Status__c != 'Completely processed' && r.Order_Status__c != 'Error from SAP' && r.Order_Status__c != 'Error in SAP' && r.Order_Status__c != 'Completely rejected' ) {
                    if(error == false){
                        error = true;
                        errorMsg = 'You already have one return request in progress. You can not create another return request until previous one is processed.';
                    }
                }
            }
        }
        map<string,Return_Sales_Order_Time_Frame__mdt>approvalMap=new map<string,Return_Sales_Order_Time_Frame__mdt>();
        for(Return_Sales_Order_Time_Frame__mdt rsoMdt: [SELECT Label,Sales_Org_Code__c,Approver_Username__c,Approver_Threshold__c,FH_username__c FROM Return_Sales_Order_Time_Frame__mdt]){
            approvalMap.put(rsoMdt.Sales_Org_Code__c,rsoMdt);
        }
        
        string currentSalesOrgCode=inv[0].Sales_Org_Code__c;
        string finalApprover=(approvalMap.containsKey(currentSalesOrgCode)?approvalMap.get(currentSalesOrgCode).Approver_Username__c:'');
        string fhApprover=(approvalMap.containsKey(currentSalesOrgCode)?approvalMap.get(currentSalesOrgCode).FH_username__c:'');
        List<user> getApprover=[SELECT Id,Username FROM User WHERE Username =: finalApprover OR Username =: fHApprover limit 2];
        for(user uu:getApprover){
            if(uu.username==finalApprover)d.finalApprover=uu.id;
            if(uu.username==fHApprover)d.finalApprover2=uu.id;
        }
        if(d.finalApprover==null)d.finalApprover = userinfo.getUserId();
        if(d.finalApprover2==null)d.finalApprover2 = userinfo.getUserId();
        
        d.approvalPercent=(approvalMap.containsKey(currentSalesOrgCode)?approvalMap.get(currentSalesOrgCode).Approver_Threshold__c:null);
        
        d.error =error;
        d.errorMsg = errorMsg;
        
        return d;
    }
    
    
    
    @AuraEnabled(cacheable=true)
    public static data getDetailsReprocess(String retSalesOrderId){
         String token = GenerateToken();
        system.debug(token);

        map<string,string>availableProfiles=new map<string,string>();
        for(ReturnSalesOrderOrgProfileMapping__mdt rsoMdt: [SELECT Label,Sales_Order_Codes__c FROM ReturnSalesOrderOrgProfileMapping__mdt]){
            availableProfiles.put(rsoMdt.label,rsoMdt.Sales_Order_Codes__c);
        }
        availableProfiles.put('System Administrator',null);
        
        Id profileId = UserInfo.getProfileId(); 
        String profileName =[Select Id, Name from Profile where Id=:profileId].Name; 
        system.debug('Profile Name : '+profileName);
        
        
        data d = new data();
        boolean error = false;
        String errorMsg = '';
        String invoiceId = '';
        List<Sales_Order_Return_Config__c> configMonths = new List<Sales_Order_Return_Config__c>();
        List<Return_Sales_Order__c> retSalesOrder = new List<Return_Sales_Order__c>();
        List<Return_Sales_Order_Line_Item__c> retSalesOrderLineItems = new List<Return_Sales_Order_Line_Item__c>();
        List<Invoice__c> inv = new List<Invoice__c>();
        List<Invoice_Line_Item__c> invLineItem = new List<Invoice_Line_Item__c>();
        List<InvLinItem> InvoItemList = new List<InvLinItem>();
        retSalesOrder = [select id,name,order_status__c, invoice__r.id,order_reason__c from Return_Sales_Order__c where id =:retSalesOrderId Limit 1];
        List<pickVals> picVaLst = new List<pickVals>();
        if(retSalesOrder.size() > 0){
            pickVals p = new pickVals();
            p.label = retSalesOrder[0].order_reason__c;
            p.value = retSalesOrder[0].order_reason__c;
            picVaLst.add(p);
            invoiceId = retSalesOrder[0].invoice__r.id;
            if(retSalesOrder[0].order_status__c != 'Error from SAP' && retSalesOrder[0].order_status__c != 'Error in SAP'){
                if(error == false){
                    error = true;
                    errorMsg = 'This is not a valid record for reprocess. You can only reprocess sales orders where status is an Error from SAP or Error in SAP.';
                }
            }
        }
        d.picks = picVaLst;
        configMonths = [select id,Months__c from Sales_Order_Return_Config__c limit 1];
        
        inv = [select id,name,Billing_Date__c,Sales_Org_Code__c,Sold_To_Party__c,Billing_Doc_Number__c,Sales_Order__r.id,Sales_Order__r.sold_to_party__c,Sales_Order__r.sold_to_party__r.name,Sales_Order__r.name,Sales_Org__r.name,Sales_Order__r.sold_to_party__r.sap_customer_code__c from invoice__c where id =: invoiceId Limit 1];
        /*integer netAmt=0;
        if(inv[0].Sold_To_Party__c!=null){
            AggregateResult arI = [SELECT SUM(TotalAmount__c)ta FROM Invoice__c WHERE Sold_To_Party__c=:inv[0].Sold_To_Party__c AND Billing_Date__c = THIS_FISCAL_YEAR];
            integer totalAmtInv=integer.valueOf(arI.get('ta'));
            AggregateResult arR = [SELECT SUM(Total_Amount__c)ta FROM Return_Sales_Order__c WHERE Sold_To_Party1__c=:inv[0].Sold_To_Party__c AND Order_Status__c='Completely processed' AND Order_Date__c = THIS_FISCAL_YEAR];
            integer totalAmtRet=integer.valueOf(arR.get('ta'));
            if(totalAmtRet==null)totalAmtRet=0;
            if(totalAmtInv>totalAmtRet){
                netAmt=totalAmtInv-totalAmtRet;
            }
        }
        d.ytdAmt=netAmt;*/
        for(Invoice__c invo : inv){
            /*if(configMonths.size() > 0){
                if(invo.Billing_Date__c < date.today().addMonths(integer.valueof(configMonths[0].months__c) * -1)){
                    if(error == false){
                        error = true;
                        errorMsg = 'Invoice billing date is older than '+configMonths[0].months__c+' months. Kindly E-mail the UPL team for further information on the return.';
                    }
                }
            }*/
            d.salesOrdername = invo.Sales_Order__r.name;
            d.billingDocNum = invo.Billing_Doc_Number__c;
            d.salesOrgName = invo.Sales_Org__r.name;
            d.InvoiceName = invo.name;
            d.customerName = invo.Sales_Order__r.sold_to_party__r.name;
            d.customerCode = invo.Sales_Order__r.sold_to_party__r.sap_customer_code__c;
        }
        
        retSalesOrderLineItems = [select id,Invoice_Line_Item__c,Batch__c,Invoice_Line_Item__r.id, Quantity__c from Return_Sales_Order_Line_Item__c where Return_Sales_Order__r.id =: retSalesOrderId];
        map<string,double>pro2vol=new map<string,double>();
        map<string,date>inl2up=new map<string,date>();
        invLineItem = [select SKU_Description__c,SKU_Code__c,Invoice_Item_Key__c,Invoice__r.Depot__c,Expire_Date__c,Invoice__r.Depot__r.Depot_Code__c,id,name,Product__r.name,Quantity__c,Batch__c,Net_Price_Per_Unit__c,Net_Value__c,UOM__c,(select id, quantity__c from Return_Sales_Order_Line_Items__r where Status__c in ('Completely processed','Partially rejected')) from Invoice_Line_Item__c where invoice__c =: invoiceId];
        if(invLineItem.size() > 0){
            for(Invoice_Line_Item__c il : invLineItem){
                system.debug(il.expire_date__c+'==========Exp');
                if(il.expire_date__c==null){
                    if(il.SKU_Code__c!=null&&il.Invoice_Item_Key__c!=null&&il.Batch__c!=null&&il.Invoice__r.Depot__c!=null&&il.Invoice__r.Depot__r.Depot_Code__c!=null){
                        map<string,object> reqPar=new map<string,object>{'Item_Key'=>il.Invoice_Item_Key__c,'SKU'=>il.SKU_Code__c,'Depot'=>il.Invoice__r.Depot__r.Depot_Code__c,'Batch'=>il.Batch__c};
                            Http http = new Http(); 
                        HttpRequest req = new HttpRequest();
                        
                        req.setEndpoint('https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/Fetch_Batch_Expiry_Date');
                        req.setTimeout(120000);
                        req.setHeader('Authorization', 'Bearer '+token);
                        req.setHeader('Content-Type', 'application/json');
                        req.setMethod('POST');
                        String body = JSON.serialize(reqPar);
                        req.setBody(body);
                        string response;
                        try{
                            HTTPresponse res= http.send(req);
                            if(res.getStatusCode() == 200){
                            system.debug(res.getBody());
                                response = res.getBody();
                                map<string,object>respMap=(map<string,object>)JSON.deserializeUntyped(response);
                                if(respMap.containsKey('Expire_Date'))il.Expire_Date__c=date.valueOf(string.valueOf(respMap.get('Expire_Date')));
                                inl2up.put(il.id,il.Expire_Date__c);
                                system.debug('response@@@@+++>'+JSON.serializePretty(response));
                            }
                        }catch(Exception e){
                        }
                    }
                }
            }
            if(inl2up.keySet().size()>0 && !test.isRunningTest())upINV(inl2up);
            for(Invoice_Line_Item__c INVLT : invLineItem){
                pro2vol.put(INVLT.Product__r.name,0);
                Decimal alreadyReturnedval = 0;
                for(Return_Sales_Order_Line_Item__c retLineItem : INVLT.Return_Sales_Order_Line_Items__r){
                    alreadyReturnedval = alreadyReturnedval+retLineItem.quantity__c;
                }
                InvLinItem inn = new InvLinItem(); 
                inn.id = INVLT.id+'@_@_@_@'+(INVLT.Quantity__c-alreadyReturnedval)+'@_@_@_@'+INVLT.UOM__c;
                inn.name = INVLT.name;
                inn.proname = INVLT.SKU_Description__c;
                inn.product = INVLT.Product__r.name;
                inn.totalQnty = INVLT.Quantity__c;
                inn.expDate = INVLT.Expire_Date__c;
                inn.alreadyReturned = alreadyReturnedval;
                inn.netValue = INVLT.Net_Value__c;
                inn.netValuePerUnit = INVLT.Net_Price_Per_Unit__c;
                inn.uom = INVLT.UOM__c;
                inn.batch = INVLT.Batch__c;
                //inn.netValueReturned = 0;
                if(retSalesOrderLineItems.size() > 0){
                    for(Return_Sales_Order_Line_Item__c rIt : retSalesOrderLineItems){
                        if(rIt.Invoice_Line_Item__r.id == INVLT.id){
                            inn.returnQty = rIt.quantity__c;
                        }
                    }
                }
                if(inn.returnQty == 0 || inn.returnQty == null || inn.netValuePerUnit == 0 || inn.netValuePerUnit == null){
                    inn.netValueReturned = 0;
                }else{
                    inn.netValueReturned = inn.returnQty * inn.netValuePerUnit;
                }
                
                InvoItemList.add(inn);
            }
        }
        
            for(Invoice_Line_Item__c fi:[select id,name,Product__r.name,Quantity__c from Invoice_Line_Item__c where Invoice__r.Sales_Order__r.sold_to_party__c =:inv[0].Sales_Order__r.sold_to_party__c AND  Invoice__r.Billing_Date__c=THIS_FISCAL_YEAR AND Product__r.name in :pro2vol.keySet() AND Invoice__r.Sales_Order__r.Order_Status__c ='Completely processed' AND Quantity__c!=null]){
                pro2vol.put(fi.Product__r.name,(pro2vol.get(fi.Product__r.name)+fi.Quantity__c));
            }
            system.debug('pro2vol======'+JSON.serializePretty(pro2vol));
            for(Return_Sales_Order_Line_Item__c fi:[select Product__c,Quantity__c from Return_Sales_Order_Line_Item__c WHERE Status__c in ('Completely processed','Partially processed') AND Product__c in: pro2vol.keySet() AND Return_Sales_Order__r.Invoice__r.Billing_Date__c = THIS_FISCAL_YEAR AND Return_Sales_Order__r.Invoice__r.Sales_Order__r.sold_to_party__c =:inv[0].Sales_Order__r.sold_to_party__c AND Quantity__c != null]){
                pro2vol.put(fi.Product__c,(pro2vol.get(fi.Product__c)-fi.Quantity__c));
            }
            system.debug('pro2vol======'+JSON.serializePretty(pro2vol));
            d.volMap=pro2vol;
        d.InvoiceLineItemList = InvoItemList;
        
        retSalesOrder = [select id,name,Order_Status__c from Return_Sales_Order__c where SalesOrder__c =: inv[0].Sales_Order__r.id];
        if(retSalesOrder.size() > 0){
            for(Return_Sales_Order__c r : retSalesOrder){
                if(r.Order_Status__c != 'Return Order Cancelled' && r.Order_Status__c != 'Rejected' && r.Order_Status__c != 'Completely processed' && r.Order_Status__c != 'Error from SAP' && r.Order_Status__c != 'Error in SAP' && r.Order_Status__c != 'Completely rejected' ) {
                    if(error == false){
                        error = true;
                        errorMsg = System.Label.Grz_IncompleteRequestMsg;
                    }
                }
            }
        }
        d.error =error;
        d.errorMsg = errorMsg;
        d.errorHeaderMsg='';
        d.errorHeader=false;
        if(!availableProfiles.containsKey(profileName)){
            d.errorHeader=true;
            d.errorHeaderMsg=('The Logged in user\'s profile- '+profileName+' does not have the permission to reprocess the return sales order.');
        }
        map<string,Return_Sales_Order_Time_Frame__mdt>approvalMap=new map<string,Return_Sales_Order_Time_Frame__mdt>();
        for(Return_Sales_Order_Time_Frame__mdt rsoMdt: [SELECT Label,Sales_Org_Code__c,Approver_Username__c,Approver_Threshold__c,FH_username__c FROM Return_Sales_Order_Time_Frame__mdt]){
            approvalMap.put(rsoMdt.Sales_Org_Code__c,rsoMdt);
        }
        
        string currentSalesOrgCode=inv[0].Sales_Org_Code__c;
        string finalApprover=(approvalMap.containsKey(currentSalesOrgCode)?approvalMap.get(currentSalesOrgCode).Approver_Username__c:'');
        string fhApprover=(approvalMap.containsKey(currentSalesOrgCode)?approvalMap.get(currentSalesOrgCode).FH_username__c:'');
        List<user> getApprover=[SELECT Id,Username FROM User WHERE Username =: finalApprover OR Username =: fHApprover limit 2];
        for(user uu:getApprover){
            if(uu.username==finalApprover)d.finalApprover=uu.id;
            if(uu.username==fHApprover)d.finalApprover2=uu.id;
        }
        if(d.finalApprover==null)d.finalApprover = userinfo.getUserId();
        if(d.finalApprover2==null)d.finalApprover2 = userinfo.getUserId();
        
        //if(getApprover!=null)d.finalApprover=getApprover.Id;
        d.approvalPercent=(approvalMap.containsKey(currentSalesOrgCode)?approvalMap.get(currentSalesOrgCode).Approver_Threshold__c:null);
        
        return d;
    }
    
    
    
    @AuraEnabled
    public static String saveRec(List<forList> dataLst, 
                                 String invId1, 
                                 boolean reProcess, 
                                 String retSalesOrderId, 
                                 String orderRsn, 
                                 string finalApprover, 
                                 string fhApprover, 
                                 boolean threshold1, 
                                 boolean threshold2
                                 ){
        system.debug('dataLst==>'+dataLst);
        String invId = '';
        
        if(reProcess == false){
            invId = invId1;
        }
        else{
            List<Return_Sales_Order__c> rSalesOrder = new List<Return_Sales_Order__c>();
            rSalesOrder = [select id,name,invoice__r.id from Return_Sales_Order__c where id =: retSalesOrderId Limit 1];
            if(rSalesOrder.size() > 0){
                invId = rSalesOrder[0].invoice__r.id;
                
            }
        }
        
        List<invoice__c> invdata = new List<invoice__c>();
        invdata = [select id,Sales_Order__c,sales_org_code__c,sales_order__r.Division_lk__c from invoice__c where id =: invId];
        List<Order_type__c> OrderTpe = new List<Order_type__c>();
        if(invdata[0].sales_org_code__c == '1210'){
            OrderTpe = [select id from Order_type__c where SalesOrg__r.sales_org_code__c =: invdata[0].sales_org_code__c and Division__c =: invdata[0].sales_order__r.Division_lk__c and name = 'ZWRD' Limit 1];
        }else if(invdata[0].sales_org_code__c == '1510'){
            OrderTpe = [select id from Order_type__c where SalesOrg__r.sales_org_code__c =: invdata[0].sales_org_code__c and Division__c =: invdata[0].sales_order__r.Division_lk__c and name = 'ZRAD' Limit 1];
        }else if(invdata[0].sales_org_code__c == '1410'){
            OrderTpe = [select id from Order_type__c where SalesOrg__r.sales_org_code__c =: invdata[0].sales_org_code__c and Division__c =: invdata[0].sales_order__r.Division_lk__c and name = 'ZRED' Limit 1];
        }else{
            OrderTpe = [select id from Order_type__c where SalesOrg__r.sales_org_code__c =: invdata[0].sales_org_code__c and Division__c =: invdata[0].sales_order__r.Division_lk__c and name = 'ZRED' Limit 1];
        }
        Return_Sales_Order__c rsalor = new Return_Sales_Order__c();
        rsalor.Invoice__c = invId;
        if(reProcess == true){
            rsalor.id =  retSalesOrderId;
            rsalor.Order_Status__c = 'Draft';
            rsalor.Error_Message__c = '';
        }
        else{
            rsalor.Order_Status__c = 'Draft';
            rsalor.SalesOrder__c = invdata[0].Sales_Order__c;
            rsalor.billing_block__c = '08';
            rsalor.Order_Reason__c = orderRsn;
            rsalor.Created_From__c= 'SFDC';
            if(OrderTpe.size() > 0){
                rsalor.Order_Type__c = OrderTpe[0].id;     
            }
        }
        //  system.debug(invdata[0].Sales_Order__c+'======'+OrderTpe[0].id);
        // ('ytdAmt==>'+ytdAmt+'retAmt==>'+retAmt+'finalApprover==>'+finalApprover+'approvalPercent==>'+approvalPercent);
        
        /*                             
        double appPercent=100-(((ytdAmt-retAmt)/ytdAmt)*100);
        if(appPercent>=approvalPercent){
            rsalor.Threshold__c=true;
            rsalor.Final_Approver__c=finalApprover;
        }else{
            rsalor.Threshold__c=false;
        }*/
                                     
            rsalor.Final_Approver__c=finalApprover;
            rsalor.Threshold__c=threshold1;
            rsalor.FH_Approver__c=fhApprover;
            rsalor.Threshold_2__c=threshold2;
        upsert rsalor;
        
        List<Return_Sales_Order_Line_Item__c> existRetLineItems = new List<Return_Sales_Order_Line_Item__c>();
        existRetLineItems= [select id,Invoice_Line_Item__r.id,Item_Number__c, name from Return_Sales_Order_Line_Item__c where return_sales_order__r.id =:retSalesOrderId ];
        integer highestNo=10;
        List<String> existRetLineItemsIds = new List<String>();
        Map<String,String> existRetLineItemsIdsMap = new Map<String,String>();
                                     system.debug('size$$$$$'+existRetLineItems.size());
        if(existRetLineItems.size() > 0){
            for(Return_Sales_Order_Line_Item__c rItm : existRetLineItems){
                existRetLineItemsIds.add(rItm.Invoice_Line_Item__r.id);
                existRetLineItemsIdsMap.put(rItm.Invoice_Line_Item__r.id,rItm.id);
                system.debug(highestNo+'loopItemNo===='+rItm.Item_Number__c);
                if(rItm.Item_Number__c!=null&&Integer.valueOf(rItm.Item_Number__c)>=highestNo)highestNo=Integer.valueOf(rItm.Item_Number__c)+10;
            }
        }
        
        List<Return_Sales_Order_Line_Item__c> retLineItems = new List<Return_Sales_Order_Line_Item__c>();
        integer itemNo=highestNo;
        system.debug('itemHighest=='+highestNo);
        list<string>existingLn=new list<string>();
        
        for(forList f : dataLst){
            
            Return_Sales_Order_Line_Item__c retInvLinItem = new Return_Sales_Order_Line_Item__c();
            if(reProcess == true){
                //for(Return_Sales_Order_Line_Item__c rLineItm : existRetLineItems){
                if(existRetLineItemsIds.contains(f.id.split( '@_@_@_@' )[0])){
                    retInvLinItem.id = existRetLineItemsIdsMap.get(f.id.split( '@_@_@_@' )[0]);
                    retInvLinItem.Quantity__c = (Decimal.valueof(f.returnQty)).setscale(3);
                    retInvLinItem.Quantity_Entered_SFDC__c=retInvLinItem.Quantity__c;
                    retInvLinItem.Status__c = 'Draft';
               	    
                }
                else{
                    retInvLinItem.SalesOrder__c = invdata[0].Sales_Order__c;
                    system.debug('f.id'+f.id);
                    //system.debug('f.id'+f.id.split( 'fY' ));
                    retInvLinItem.Status__c = 'Draft';
                    retInvLinItem.Invoice_Line_Item__c = f.id.split( '@_@_@_@' )[0];
                    retInvLinItem.Quantity__c = (Decimal.valueof(f.returnQty)).setscale(3);
                    retInvLinItem.Quantity_Entered_SFDC__c=retInvLinItem.Quantity__c;
                    //retInvLinItem.Reason_for_Return__c = f.returnReason;
                    retInvLinItem.Return_Sales_Order__c = retSalesOrderId;
                    retInvLinItem.Item_Number__c=string.valueOf(itemNo);
					system.debug('itemNo$$$$$$$$'+retInvLinItem.Item_Number__c);                    //retLineItems.add(retInvLinItem);
                }
                // retLineItems.add(retInvLinItem);   
                // }
            }else{
                retInvLinItem.SalesOrder__c = invdata[0].Sales_Order__c;
                system.debug('f.id'+f.id);
                //system.debug('f.id'+f.id.split( 'fY' ));
                retInvLinItem.Status__c = 'Draft';
                retInvLinItem.Invoice_Line_Item__c = f.id.split( '@_@_@_@' )[0];
                retInvLinItem.Quantity__c = (Decimal.valueof(f.returnQty)).setscale(3);
                retInvLinItem.Quantity_Entered_SFDC__c=retInvLinItem.Quantity__c;    
                //retInvLinItem.Reason_for_Return__c = f.returnReason;
                retInvLinItem.Return_Sales_Order__c = rsalor.id;
                retInvLinItem.Item_Number__c=string.valueOf(itemNo);
                
            }
            retLineItems.add(retInvLinItem);
            //ids.add(f.id);
            itemNo=itemNo+10;
        }
        upsert retLineItems;
        Return_Sales_Order__c rsalor1=[select id,isApprover1__c,isApprover2__c,Threshold__c,Approver_1__c,Approver_2__c,Final_Approver__c from Return_Sales_Order__c where id =: rsalor.id];
        
        //if(!test.isRunningTest()){
            //List<Profile> pro = [select id from profile where name = 'system administrator' LIMIT 1];
            //if(userinfo.getProfileId() != pro[0].id){
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(rsalor1.id);
            req1.setSubmitterId(userinfo.getUserId()); 
           if(!test.isRunningTest()) req1.setProcessDefinitionNameOrId('Return_Sales_Order_Approval146');
            Approval.ProcessResult result = Approval.process(req1);
            
            
            //}
            
       // }
        return rsalor.id;
    }
    
    public class data {
        @AuraEnabled
        public String salesOrdername {get;set;}
        @AuraEnabled
        public String customerName {get;set;}
        @AuraEnabled
        public String customerCode {get;set;}
        @AuraEnabled       
        public String billingDocNum {get;set;}
        @AuraEnabled
        public String salesOrgName {get;set;}
        @AuraEnabled
        public String InvoiceName {get;set;}
        @AuraEnabled
        public Boolean error {get;set;}
        @AuraEnabled
        public String errorMsg {get;set;}
        @AuraEnabled
        public String finalApprover {get;set;}
        @AuraEnabled
        public Double approvalPercent {get;set;}
        @AuraEnabled
        public String finalApprover2 {get;set;}
        @AuraEnabled
        public Double ytdAmt {get;set;} 
        @AuraEnabled
        public String orderReason {get;set;}
        @AuraEnabled
        public Boolean errorHeader {get;set;}
        @AuraEnabled
        public String errorHeaderMsg {get;set;}
        @AuraEnabled
        public List<invLinItem> InvoiceLineItemList {get;set;}
        @AuraEnabled
        public list<pickVals> picks {get;set;}
		@AuraEnabled
        public Map <string,double> volMap{get;set;}    
    }
    
    public class forList {
        @AuraEnabled
        public String returnQty {get;set;}
        @AuraEnabled
        public String returnReason {get;set;}
        @AuraEnabled
        public String id {get;set;}
    }
    
    public class InvLinItem {
        @AuraEnabled
        public String batch {get;set;}
        @AuraEnabled
        public String id {get;set;}
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String proname {get;set;}
        @AuraEnabled       
        public String product {get;set;}
        @AuraEnabled
        public Decimal totalQnty {get;set;}
        @AuraEnabled
        public Decimal ytdSales {get;set;}
        @AuraEnabled
        public Decimal alreadyReturned {get;set;}
        @AuraEnabled
        public Decimal returnQty {get;set;}
        @AuraEnabled
        public Decimal netValue {get;set;}
        @AuraEnabled
        public Decimal netValuePerUnit {get;set;}
        @AuraEnabled
        public String uom {get;set;}
        @AuraEnabled
        public Decimal netValueReturned {get;set;}
        @AuraEnabled
        public date expDate {get;set;}
        
    }
    
    public class pickVals {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public String value {get;set;}
        
    }
    
    @future 
    public static void upInv(map<string,date>inl2up){
        list<invoice_line_item__c> i2up=new list<invoice_line_item__c>();
        for(string sid:inl2up.keySet()){
            invoice_line_item__c i=new invoice_line_item__c();
            i.id=sid;
            i.Expire_Date__c=inl2up.get(sid);
            i2up.add(i);
    	}
        if(i2up!=null && !i2up.isEmpty())update i2up;
    }
    
}