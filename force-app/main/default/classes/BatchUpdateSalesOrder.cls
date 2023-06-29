/**************************************************************************************************
* Name               : BatchUpdateSalesOrder                                                      
* Description        : Batch class to update Sales Order from SAP and scheduler is ScheduleFetchSalesOrderStatus
* Test Class         : BatchUpdateSalesOrderTest
* Modified By        : Nikhil Verma (Grazitti) RITM0543410                                                                      
**************************************************************************************************/
public class BatchUpdateSalesOrder implements Database.Batchable<WrapperDate>, Database.AllowsCallouts{
    list<WrapperDate> lidate = new list<WrapperDate>();
    public BatchUpdateSalesOrder(list<WrapperDate> lidate){
        this.lidate = lidate;
    }
    public Iterable<WrapperDate> start(Database.BatchableContext BC){         
        return lidate;
    }
    public void execute(Database.BatchableContext info, List<WrapperDate> dates){
        SalesOrderTrackingRequestWrapper req = new SalesOrderTrackingRequestWrapper();  
        req.dateFrom = String.valueOf(dates[0].startDate);
        req.dateTo = String.valueOf(dates[0].endDate);
        req.invoiceId = '';
        req.sapOrderNumber = '';
        SalesOrderTrackingResponseWrapper res = GetInvoices.APICallout(req);
        if(res.status == 'S'){
            /* To Update Invoice_Status__c at Sales Order Level */
            Map<String,Sales_Order__c> mapSO = new  Map<String,Sales_Order__c>();
            for( SalesOrderTrackingSalesOrders sOrder : res.salesOrders ){
                if(!String.isEmpty(sOrder.sapSalesOrderNumber)){
                    Sales_Order__c so = new Sales_Order__c();
                    so.SAP_Order_Number__c = sOrder.sapSalesOrderNumber;
                    so.Invoice_Status__c = sOrder.invoicesStatus;
                    mapSO.put(sOrder.sapSalesOrderNumber, so);
                }
            }
            system.debug('Total Sales Order in Response ===> '+ mapSO.size());
            Map<String,Sales_Order__c> mapSOAll = new  Map<String,Sales_Order__c>();
            for (Sales_Order__c so: [SELECT Id, SAP_Order_Number__c,Invoice_Status__c
                                     FROM Sales_Order__c 
                                     WHERE SAP_Order_Number__c IN:mapSO.keySet()
                                     ]){
                                         mapSOAll.put(so.SAP_Order_Number__c, so);
                                        }
            system.debug('Sales Order Found in SF ===> '+ mapSOAll.size());
            List<Sales_Order__c> soList = new List<Sales_Order__c>();
            for (Sales_Order__c so: mapSOAll.values()){
               if(String.isEmpty(so.Invoice_Status__c) || so.Invoice_Status__c != mapSO.get(so.SAP_Order_Number__c).Invoice_Status__c){
                    so.Invoice_Status__c = mapSO.get(so.SAP_Order_Number__c).Invoice_Status__c;
                    soList.add(so);
               }
            }
            system.debug('Total Sales Order To Update ==>'+soList.size());
            if(!soList.isEmpty()){
               Database.upsert(soList, Sales_Order__c.Fields.SAP_Order_Number__c, false);
            }
        }
        if(res.status == 'E'){
            System.debug('error from SAP integration');
        }      
    }
    public void finish(Database.BatchableContext info) { 
        List<WrapperDate> LiWrapDate = new list<WrapperDate>();
        date enddate = date.today();
        date startdate = date.today() - integer.valueOf(UPL_Settings__c.getOrgDefaults().OrderBatchDateRange__c);
        integer size = integer.valueOf(UPL_Settings__c.getOrgDefaults().OrderBatchSize__c);
        integer decrement = size+1;
        for (date d=enddate; d >= startdate; d=d-decrement){
            WrapperDate wrapdate = new WrapperDate();
            wrapdate.endDate = d;
            if(d-size>startdate){
                wrapdate.startDate = d-size;
            }else{
                wrapdate.startDate = startdate;
            }
            LiWrapDate.add(wrapdate);
        }           
        if(LiWrapDate != null && LiWrapDate.size() <= 50){
            BatchUpdateInvoiceBrazil bo = new BatchUpdateInvoiceBrazil(LiWrapDate);
            Database.executeBatch(bo,1);
        }else{
            system.debug('SFDC cannot perform more than 100 callouts in Batch');
        }
    }
    
}