/**************************************************************************************************
* Name               : BatchUpdateInvoiceBrazil                                                      
* Description        : Batch class and scheduler is ScheduleFetchInvoiceBrazil
* Test Class         : BatchUpdateInvoiceBrazilTest
* Created By         : Nikhil Verma (Grazitti) RITM0543410                                                                      
**************************************************************************************************/
public class BatchUpdateInvoiceBrazil implements Database.Batchable<WrapperDate>, Database.AllowsCallouts{
    list<WrapperDate> lidate = new list<WrapperDate>();
    public BatchUpdateInvoiceBrazil(list<WrapperDate> lidate){
        this.lidate = lidate;
    }
    public Iterable<WrapperDate> start(Database.BatchableContext BC){         
        return lidate;
    }

    public void execute(Database.BatchableContext bc, List<WrapperDate> dates){
        SalesOrderTrackingRequestWrapper req = new SalesOrderTrackingRequestWrapper();  
        req.dateFrom = String.valueOf(dates[0].startDate);
        req.dateTo = String.valueOf(dates[0].endDate);
        req.invoiceId = '';
        req.sapOrderNumber = '';
        SalesOrderTrackingResponseWrapper res = GetInvoices.APICallout(req);
        if(res.status == 'S'){
            String salesOrgCode = UPL_Settings__c.getOrgDefaults().SalesOrg__c; 
            Sales_Org__c sOrg = [SELECT Id, Sales_Org_Code__c 
                                FROM Sales_Org__c 
                                WHERE Sales_Org_Code__c = :salesOrgCode LIMIT 1];
             /*---------------------------------------------------------*/
            /* To Upsert Invoice Data*/
            Set<String> invSapOrderNumberSet = new Set<String>();
            Set<String> invBillingDocSet = new Set<String>();
            /* start Add below code for RITM0514419 GRZ(Javed) 09-03-2023*/
            Map<String,Id> depotMap=new Map<String,Id>();
            set<string> depotCode= new set<string>();
            for(SalesOrderTrackingInvoices wrap: res.invoices){
                invSapOrderNumberSet.add(wrap.sapOrderNumber);
                invBillingDocSet.add(wrap.invoiceIdNumber);
                depotCode.add(wrap.Depot);
            }
            List<Depot__c> d = [select id,name,depot_code__C from Depot__c where depot_code__C IN:depotCode];
            for(Depot__c dd: d){
                depotMap.put(dd.depot_code__C,dd.Id);
            }
            /* end Add below code for RITM0514419 GRZ(Javed) 09-03-2023*/
            system.debug('Set of SAP order Number on Invoice ===> '+ invSapOrderNumberSet.size());
            system.debug('Set Billing Doc ===> '+ invBillingDocSet.size());
            Map<String,Sales_Order__c> mapSoFInv = new Map<String,Sales_Order__c>();
            for (Sales_Order__c so: [SELECT Id, Sold_to_Party__c,SAP_Order_Number__c
                                     FROM Sales_Order__c 
                                     WHERE SAP_Order_Number__c IN:invSapOrderNumberSet
                                     ]){
                                        mapSoFInv.put(so.SAP_Order_Number__c, so);
                                        }
            system.debug('Sales Order found in SF for Invoices SAP Order Number===> '+ mapSoFInv.size());
           
            Set<String> invInSFSet = new Set<String>();
            for (Invoice__c inv: [SELECT Id, Billing_Doc_Number__c
                                     FROM Invoice__c 
                                     WHERE Billing_Doc_Number__c IN:invBillingDocSet
                                     ]){
                                        invInSFSet.add(inv.Billing_Doc_Number__c);
                                        }
            system.debug('Invoice found in SF ===> '+ invInSFSet.size());
            Map<String,Invoice__c> mapInvoices = new Map<String,Invoice__c>();
            for(SalesOrderTrackingInvoices wrap: res.invoices){
                if(!mapSoFInv.isEmpty() && mapSoFInv.keySet().contains(wrap.sapOrderNumber)){
                    Invoice__c inv = new Invoice__c();
                    inv.Billing_Doc_Number__c = wrap.invoiceIdNumber;
                    inv.Nota_Fiscal__c = wrap.invoiceNumber;
                    inv.Sender_Document__c = wrap.senderDocument;
                    inv.Destination_Document__c = wrap.destinationDocument;
                    inv.Carrier_Name__c = wrap.carrierName;
                    inv.Invoice_Total_Value__c = decimal.valueOf(wrap.invoiceTotalValue);
                    inv.Billing_Status__c = wrap.generalStatusOfTheInvoice;
                    inv.Invoice_key__c = wrap.invoicekey;
                    inv.Sales_Org__c = sOrg.Id;
                    inv.Sold_To_Party__c = mapSoFInv.get(wrap.sapOrderNumber).Sold_to_Party__c;
                    inv.Sales_Order__c = mapSoFInv.get(wrap.sapOrderNumber).Id;
                    //  Start Add this field  for RITM0514419 GRZ(Javed) 09-03-2023 
                    inv.SAP_Billing_DOC__c = wrap.SAPBillingDOC;
                    if(depotMap != null && depotMap.containskey(wrap.Depot)){
                        inv.Depot__c = depotMap.get(wrap.Depot);
                    }             
                    //  end  for RITM0514419 GRZ(Javed) 09-03-2023 
                    if(string.isNotBlank(wrap.invoiceDate)){
                        if(wrap.invoiceDate != '0000-00-00' && wrap.invoiceDate != '    -  -  '){// Added check to exclude bad date value comming from SAP, GRZ(Nikhil Verma) : APPS-1394
                            if(date.valueOf(wrap.invoiceDate).month() != 0 &&
                               date.valueOf(wrap.invoiceDate).day() != 0 &&
                               date.valueOf(wrap.invoiceDate).Year() != 0){
                                    inv.Billing_Date__c = date.valueOf(wrap.invoiceDate);
                               }
                        }
                    }
                    if(string.isNotBlank(wrap.cancellationDate)){
                        if(wrap.cancellationDate != '0000-00-00' && wrap.cancellationDate != '    -  -  '){// Added check to exclude bad date value comming from SAP, GRZ(Nikhil Verma) : APPS-1394
                            if(date.valueOf(wrap.cancellationDate).month() != 0 &&
                               date.valueOf(wrap.cancellationDate).day() != 0 &&
                               date.valueOf(wrap.cancellationDate).Year() != 0){
                                    inv.Data_de_Cancelamento__c = date.valueOf(wrap.cancellationDate);
                               }
                        }
                    }
                    if(string.isNotBlank(wrap.deliveryDate)){
                        if(wrap.deliveryDate != '0000-00-00' && wrap.deliveryDate != '    -  -  '){  // Added check to exclude bad date value comming from SAP, GRZ(Nikhil Verma) : APPS-1394
                            if(date.valueOf(wrap.deliveryDate).month() != 0 &&
                               date.valueOf(wrap.deliveryDate).day() != 0 &&
                               date.valueOf(wrap.deliveryDate).Year() != 0){
                                    inv.Delivery_Date__c = date.valueOf(wrap.deliveryDate);
                               }
                        }
                    }
                    if(string.isNotBlank(wrap.estimatedDeliveryDate)){
                        if(wrap.estimatedDeliveryDate != '0000-00-00' && wrap.estimatedDeliveryDate != '    -  -  '){// Added check to exclude bad date value comming from SAP, GRZ(Nikhil Verma) : APPS-1394
                            if(date.valueOf(wrap.estimatedDeliveryDate).month() != 0 &&
                               date.valueOf(wrap.estimatedDeliveryDate).day() != 0 &&
                               date.valueOf(wrap.estimatedDeliveryDate).Year() != 0){
                                    inv.Estimated_Delivery_Date__c = date.valueOf(wrap.estimatedDeliveryDate);
                               }
                        }
                    }
                    //if((!invInSFSet.isEmpty() && !invInSFSet.contains(wrap.invoiceIdNumber)) || invInSFSet.isEmpty()){
                        mapInvoices.put(wrap.invoiceIdNumber, inv);
                    //}
                }      
            }
            system.debug('Final Invoice to be insert in SF ===> '+ mapInvoices.size());
            if(!mapInvoices.values().isEmpty()){
                Database.upsert(mapInvoices.values(), Invoice__c.Fields.Billing_Doc_Number__c,false);
            }
            /*---------------------------------------------------------*/
            /* To Upsert InvoiceLineItems To Invoices Data*/
            Map<String, Invoice_Line_Item__c> mapInvoiceLI = new Map<String, Invoice_Line_Item__c>();
            Set<String> skuCodes = new Set<String>();
            Set<String> invIdSet = new Set<String>();
            Set<String> lineItemKeySet = new Set<String>();
            /* start Add below code for RITM0514419 GRZ(Javed) 09-03-2023*/
            Map<String,Id> depotMap1=new Map<String,Id>();
            Map<String,Id> salesOrderMap=new Map<String,Id>();
            set<string> salesOrderNumber= new set<string>();
            set<string> depotCode1= new set<string>();

            for(SalesOrderTrackingMaterial soli: res.materials){
                skuCodes.add(soli.productCode);            
                invIdSet.add(soli.notUsed);   
                lineItemKeySet.add(soli.notUsed + soli.itemNumber); 
                depotCode1.add(soli.Depot);
                salesOrderNumber.add(soli.SalesOrder);       
            }
            if(salesOrderNumber != null && !salesOrderNumber.isEmpty()){
                for(Sales_Order__c s: [select id,name,SAP_Order_Number__c from Sales_Order__c where SAP_Order_Number__c IN:salesOrderNumber AND SAP_Order_Number__c != null AND SalesOrgCode__c = '5191']){
                    salesOrderMap.put(s.SAP_Order_Number__c,s.Id);
                }
            }
            List<Depot__c> d1=[select id,name,depot_code__C from Depot__c where depot_code__C IN:depotCode1];
            for(Depot__c dd: d1){
                depotMap1.put(dd.depot_code__C,dd.Id);
            }
            /* end Add below code for RITM0514419 GRZ(Javed) 09-03-2023*/
            system.debug('Sku Code in response ===> '+ skuCodes.size());
            system.debug('Bill Doc Id in Line Item response ===> '+ invIdSet.size());
            system.debug('Line Item Key ===> '+ lineItemKeySet.size());
            Map<String,SKU__c> mapSKU = new Map<String,SKU__c>();
            for (SKU__c sku: [SELECT Id,SKU_Code__c FROM SKU__C
                                WHERE SKU_Code__c IN:skuCodes And  Sales_Org_Code__c ='5191'])  // Added Sales_Org_Code__c for RITM0538824 GRZ(Dheeraj Sharma) 18-04-2023
                                {
                                    mapSKU.put(sku.SKU_Code__c,sku);  
                                }
            system.debug('SKU in SF ===> '+ mapSKU.size());
            Map<String,Invoice__c> mapInvFLi = new Map<String,Invoice__c>();
            for (Invoice__c inv: [SELECT Id,Billing_Doc_Number__c FROM Invoice__c
                                WHERE Billing_Doc_Number__c IN:invIdSet])
                                {
                                    mapInvFLi.put(inv.Billing_Doc_Number__c,inv);  
                                }
            system.debug('Invoice in SF for Line Items ===> '+ mapInvFLi.size());
            Set<String> lineSFSet = new Set<String>();
            for (Invoice_Line_Item__c li: [SELECT Id,Invoice_Item_Key__c FROM Invoice_Line_Item__c
                                            WHERE Invoice_Item_Key__c IN:lineItemKeySet])
                                            {
                                                lineSFSet.add(li.Invoice_Item_Key__c);  
                                            }
            system.debug('Invoice Line Item Found in SF ===> '+ lineSFSet.size());
            for(SalesOrderTrackingMaterial soli: res.materials){
                if(!mapInvFLi.keySet().isEmpty() && mapInvFLi.keySet().contains(soli.notUsed)){
                    Invoice_Line_Item__c invLi = new Invoice_Line_Item__c();
                    invLi.SKU__C = mapSKU.get(soli.productCode) != null ? mapSKU.get(soli.productCode).Id : null;
                    invLi.SalesOrg__c = sOrg.Id;
                    invLi.Invoice__c = mapInvFLi.get(soli.notUsed).Id;
                    invLi.Invoice_Item_Key__c = mapInvFLi.get(soli.notUsed).Billing_Doc_Number__c + soli.itemNumber;
                    invLi.Invoice_Item__c = soli.itemNumber;
                    invLi.Quantity__c = decimal.valueof(soli.volume);
                    invLi.Net_Value__c = decimal.valueof(soli.value);
                    /* start add below line's  for RITM0514419 GRZ(Javed) 09-03-2023 */
                    invLi.Unit_Price__c = soli.UnitPrice != '' ? decimal.valueof(soli.UnitPrice) : 0.0;
                    if(soli.ManufacturingDate != '0000-00-00' && soli.ManufacturingDate !=null ){
                        invLi.Manufacturing_Date__c = date.valueof(soli.ManufacturingDate);
                    }
                    invLi.Billing_DOC_reference_number__c = soli.BillingDOCreferencenumber;
                    if(soli.ExpireDate != '0000-00-00' && soli.ExpireDate != null){
                        invLi.Expire_Date__c = date.valueOf(soli.ExpireDate);
                    }
                    if(depotMap1 != null && depotMap1.containskey(soli.depot)){
                        invLi.Depot__c = depotMap1.get(soli.depot);
                    }
                    if(salesOrderMap != null && salesOrderMap.containskey(soli.SalesOrder)){
                        invLi.Sales_Order__c = salesOrderMap.get(soli.SalesOrder);
                    }
                    invLi.Batch__c = soli.Batch;
                    invLi.SAP_Billing_DOC__c = soli.SAPBillingDOC;
                    /* end add below line's  for RITM0514419 GRZ(Javed) 09-03-2023 */
                    //if((!lineSFSet.isEmpty() && !lineSFSet.contains(soli.notUsed + soli.itemNumber)) || lineSFSet.isEmpty()){
                        mapInvoiceLI.put(invLi.Invoice_Item_Key__c, invLi);
                    //}
                    
                }
            }
            system.debug('Line Items to update ===> '+ mapInvoiceLI.size());
            if(!mapInvoiceLI.values().isEmpty()){
                Database.upsert(mapInvoiceLI.values(), Invoice_Line_Item__c.Fields.Invoice_Item_Key__c, false);
            }
        }
        if(res.status == 'E'){
            System.debug('error from SAP integration');
        }  
    }

    public void finish(Database.BatchableContext bc){
    }
}