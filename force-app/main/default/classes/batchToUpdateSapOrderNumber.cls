/* Created by- Javed Ahmed
 * description- After post refresh activity update all the sales orders SAP Order number field with UAT
Eg SAP Order Number # 76543789  after SAP Order Number # 76543789UAT 
regarding 
Note- before running this batch you neeed to deactivate below process builder and flows
SOLICombKeyTrigger(Trigger on Sales Order)\
salesOrderShare(triger On Sales order)
Duplicate Sales Order Process V1(Process Builder version  3)
Push Notification & Sales order assignment Version 1(process builder version 7)
Hide all versionsBrazil Sales Order Email(process builder version 3)
india-Argentina-Mexico-Europe-CAM-Colombia Sales Order Approval flow(process builder version 74)
Vietnam SAP Notification to RM(Process buider version 1)
Italy Country Manager SO(Process builder version 1)
Ship to Party SAP Code field update( process builder version 1)
Italy Approval Process Flow for a Particular Account(process builder version 1)
Sales Order Auto Approval for NEW CAM(process builder version 4)\
Brazil Sales Order Cancellation(process builder version 1)
Sales Order PB V3.0(Process Builder Version 42)
Brazil Sales Order Approval BKUP v3.7 (process buider Version 15)
Sales Order Update Group Fields(process builder version 2)
Call Sales Order Approval Process(flow version 1)
versionsTurkey/Italy/UK/IE Approval Process Flow v2.3(process builder version 41)
Hide all versionsSales Order SalesOrgCountry Update(process builder version 1)
*/
public class batchToUpdateSapOrderNumber implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext context) {
        // Implement the start method to return a query locator for the records to be processed
        // Example:
        return Database.getQueryLocator([select id,name,SAP_Order_Number__c from Sales_Order__c where  SAP_Order_Number__c!=null  and ( NOT(SAP_Order_Number__c like '%UAT') ) ]);
    }
    public void execute(Database.BatchableContext context, List<Sales_Order__c> soLIst) {
        system.debug('soLIst:'+soLIst);
         system.debug('size:'+soLIst.size());
        // Implement the execute method to process the records in the current batch
     list<Sales_Order__c> lstSO = new list<Sales_Order__c>();
        for (Sales_Order__c  so: soLIst) {
          so.SAP_Order_Number__c=so.SAP_Order_Number__c+'UAT';
            lstSO.add(so);
        }
        
        if(!lstSO.isEmpty()){
           database.update(lstSO);
        }
    }
    public void finish(Database.BatchableContext context) {
        // Implement the finish method for any post-processing logic
        // This method is executed after all batches have been processed
    }
    
}