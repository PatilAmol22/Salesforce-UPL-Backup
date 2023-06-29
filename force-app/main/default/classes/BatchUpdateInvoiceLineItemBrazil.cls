/**************************************************************************************************
* Name               : BatchUpdateInvoiceLineItemBrazil                                                      
* Description        : Batch class called from GetInvoices apex class
* Test Class         : BatchUpdateInvoiceLineItemBrazilTest
* Created By         : Nikhil Verma (Grazitti) RITM0554451 
**************************************************************************************************/
public class BatchUpdateInvoiceLineItemBrazil implements Database.Batchable<String>, Database.AllowsCallouts{
    List<String> lidate = new List<String>();
    public BatchUpdateInvoiceLineItemBrazil(List<String> lidate){
        this.lidate = lidate;
    }
    public Iterable<String> start(Database.BatchableContext BC){         
        return lidate;
    }

    public void execute(Database.BatchableContext bc, List<String> InvoiceId){
        string SalesOrgCode = UPL_Settings__c.getOrgDefaults().SalesOrg__c;
        Sales_Org__c SOrg = [select id, Sales_Org_Code__c 
                             from Sales_Org__c 
                             where Sales_Org_Code__c = :SalesOrgCode];
        
        Invoice__c INV = [select id,
                          Sales_Order__r.SAP_Order_Number__c,
                          Invoice_key__c,
                          Billing_Doc_Number__c,
                          Last_Invoice_Line_Items_Updated__c,
                          Last_Invoice_Line_Items_Updated_Status__c,
                          SuccessFull_Invoice_Line_Items_Updated__c,
                          Nota_Fiscal__c
                          from Invoice__c 
                          where Billing_Doc_Number__c = :InvoiceId[0]];
        SalesOrderTrackingRequestWrapper req = new SalesOrderTrackingRequestWrapper();
        req.dateFrom = '';
        req.dateTo = '';
        req.invoiceId = InvoiceId[0]; 
        req.sapOrderNumber = INV.Sales_Order__r.SAP_Order_Number__c;
        SalesOrderTrackingResponseWrapper res = GetInvoices.APICallout(req);
        /* start Add below code for RITM0514419 GRZ(Javed) 09-03-2023*/
        Map<String,Id> depotMap=new Map<String,Id>();
        Map<String,Id> salesOrderMap=new Map<String,Id>();
        set<string> salesOrderNumber= new set<string>();
        set<string> depotCode= new set<string>();
        for(SalesOrderTrackingMaterial SOTI: res.materials){
            depotCode.add(SOTI.Depot);
            salesOrderNumber.add(SOTI.SalesOrder);
        }
        if(salesOrderNumber != null && !salesOrderNumber.isEmpty()){
            for(Sales_Order__c s: [select id,name,SAP_Order_Number__c from Sales_Order__c where SAP_Order_Number__c IN:salesOrderNumber AND SAP_Order_Number__c != null AND  SalesOrgCode__c = '5191']){
                salesOrderMap.put(s.SAP_Order_Number__c,s.Id);
            }
        }
        List<Depot__c> d=[select id,name,depot_code__C from Depot__c where depot_code__C IN:depotCode];
        for(Depot__c dd: d){
            depotMap.put(dd.depot_code__C,dd.Id);
        }
        /* end Add below code for RITM0514419 GRZ(Javed) 09-03-2023*/
        INV.Last_Invoice_Line_Items_Updated__c = system.now();
        if(res.status == 'S'){
            INV.Last_Invoice_Line_Items_Updated_Status__c = 'Success';
            INV.SuccessFull_Invoice_Line_Items_Updated__c = system.now();
            update INV;
            list<Invoice__c> liInvoice = new list<Invoice__c>();
             system.debug('res@@@@@@:'+res);
            for (SalesOrderTrackingInvoices SOTI : res.invoices){
                 system.debug('res.invoices:'+res.invoices);
                Invoice__c Invc = new Invoice__c();
                Invc.Billing_Doc_Number__c = SOTI.invoiceIdNumber;
                Invc.Invoice_key__c = SOTI.invoicekey;
                liInvoice.add(Invc);
            }
            system.debug('liInvoice:'+liInvoice);
            upsert liInvoice Billing_Doc_Number__c; 
            
            INV = [select id,Sales_Order__r.SAP_Order_Number__c,
                   Invoice_key__c,Billing_Doc_Number__c,
                   Nota_Fiscal__c
                   from Invoice__c where Billing_Doc_Number__c = :InvoiceId[0]];
            system.debug('invoice key'+INV.Invoice_key__c);
            map<string, Invoice_Line_Item__c> MapInvoiceLI = new map<string, Invoice_Line_Item__c>();
            set<string> SKUCodes = new set<string>();
            for(SalesOrderTrackingMaterial SOTI: res.materials){
                SKUCodes.add(SOTI.productCode);            
            }
            map<string,SKU__c> mapSKU = new map<string,SKU__c>();
            for (SKU__c S: [select Id,SKU_Code__c from SKU__C
                            where SKU_Code__c = :SKUCodes And Sales_Org_Code__c ='5191']){  // Added Sales_Org_Code__c for RITM0538824 GRZ(Dheeraj Sharma) 18-04-2023
                                mapSKU.put(S.SKU_Code__c,S);  
                            }

            
            for(SalesOrderTrackingMaterial SOTI: res.materials){   
                Invoice_Line_Item__c ILI = new Invoice_Line_Item__c();
                ILI.SKU__C = mapSKU.get(SOTI.productCode) != null ? mapSKU.get(SOTI.productCode).Id : null;
                ILI.Invoice_Item_Key__c = INV.Billing_Doc_Number__c+SOTI.itemNumber;
                ILI.Invoice_Item__c = SOTI.itemNumber;
                ILI.Quantity__c = decimal.valueof(SOTI.volume);
                ILI.Net_Value__c = decimal.valueof(SOTI.value);
                ILI.SalesOrg__c = SOrg.Id;
                ILI.Invoice__c = INV.Id;
                /* start add below line's  for RITM0514419 GRZ(Javed) 09-03-2023 */
                ILI.Unit_Price__c = SOTI.UnitPrice != '' ? decimal.valueof(SOTI.UnitPrice) : 0.0;
                if(SOTI.ManufacturingDate != '0000-00-00' && SOTI.ManufacturingDate !=null ){
                    ILI.Manufacturing_Date__c = date.valueof(SOTI.ManufacturingDate);
                }
                ILI.Billing_DOC_reference_number__c = SOTI.BillingDOCreferencenumber;
                if(SOTI.ExpireDate != '0000-00-00' && SOTI.ExpireDate != null){
                    ILI.Expire_Date__c = date.valueOf(SOTI.ExpireDate);
                }
                if(depotMap != null && depotMap.containskey(SOTI.depot)){
                    ILI.Depot__c = depotMap.get(SOTI.depot);
                }
                if(salesOrderMap != null && salesOrderMap.containskey(SOTI.SalesOrder)){
                    ILI.Sales_Order__c = salesOrderMap.get(SOTI.SalesOrder);
                }
                ILI.Batch__c = SOTI.Batch;
                ILI.SAP_Billing_DOC__c = SOTI.SAPBillingDOC;
                /* end add below line's  for RITM0514419 GRZ(Javed) 09-03-2023 */ 
                MapInvoiceLI.put(SOTI.itemNumber, ILI);
            }
            upsert MapInvoiceLI.values() Invoice_Item_Key__c;
        }
        if(res.status == 'E'){
            INV.Last_Invoice_Line_Items_Updated_Status__c = 'Failure';
            Update INV;
        }
    }

    public void finish(Database.BatchableContext bc){
    }
}