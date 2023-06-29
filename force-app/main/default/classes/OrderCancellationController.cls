/*
@Author: Pranav Dinakaran
@Class_Description : Sales Order Cancellation.
*/ 
public with sharing class OrderCancellationController {

public String SalesOrderID{get;set;} // Stores Sales Order Record Id passed from vf page
public List<SelectOption> rejectionResaon{get;set;}  // Cancellation Reason Picklist
public List<Sales_Order__c> SalesOrderList ;
public String SelectedReason {get;set;} // Stores Reason Selected in vf page

    // Controller to prepareCancellation Status Picklist and retrieve Sales Order Record
    public OrderCancellationController(ApexPages.StandardController controller) {
       rejectionResaon = new List<SelectOption>();
          // Picklist is Populated from Rejection_Status__c object
           List<Rejection_Status__c> rejectionList = new List<Rejection_Status__c>([select id, name, Rejection_Code__c,Rejection_Description__c from Rejection_Status__c]);
            for(Rejection_Status__c r: rejectionList){
                rejectionResaon.add(new SelectOption(r.Rejection_Code__c+'-'+r.Rejection_Description__c, r.Rejection_Description__c));
            }           
        SalesOrderID =ApexPages.currentPage().getParameters().get('OrderID');
        SalesOrderList = new List<Sales_Order__c>([select id, name, SFDC_Order_Number__c,SAP_Order_Number__c,Order_Cancel_Reason__c,OrderCancellationRequestby__c, OrderCancellationRequestDate__c, Order_Status__c from Sales_Order__c where id=:SalesOrderID ]); 
        
    }
    // Cancel Order Method is invoked from vf Page this Method Update Sales Order Record order status, Reason for Cancellation field Values 
    public void CancelOrder(){
        SalesOrderList[0].Order_Status__c = 'Request for Cancellation';
        SalesOrderList[0].OrderCancellationRequestDate__c = System.now();
        SalesOrderList[0].OrderCancellationRequestby__c = UserInfo.getUserId();
        SalesOrderList[0].Order_Cancel_Reason__c = SelectedReason.substring(0,2);
        SalesOrderList[0].Order_Cancel_Code_Reason__c= SelectedReason;
        SalesOrderList[0].RequestforCancellationCheck__c = true;
        // update the Sales Order Record 
        update SalesOrderList;
    }

}