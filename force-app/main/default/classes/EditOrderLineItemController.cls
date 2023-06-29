/*
@Author: Pranav Dinakaran
@Class_Description: Sales Order Line Item Edit Quantity.
*/ 
public with sharing class EditOrderLineItemController {
public String SalesOrderID{get;set;} // Holds Sales Order ID 
public List<Sales_Order_Line_Item__c> OrderLineItemList {get;set;} // List of Sales Order Line Item 
public List<Sales_Order__c> SalesOrderList{get;set;}
public Map<String, Integer> SalesOrderLineItemQuantitiyMap;

    // Controller to Retrieve LineItem List 
    public EditOrderLineItemController(ApexPages.StandardController controller) {
        SalesOrderID =ApexPages.currentPage().getParameters().get('OrderID');
        SalesOrderLineItemQuantitiyMap = new Map<String, Integer>();
        SalesOrderList = new List<Sales_Order__c>([select id, name, SFDC_Order_Number__c,SAP_Order_Number__c,Sold_to_Party__r.Name,
                                                Order_Cancel_Reason__c,OrderCancellationRequestby__c, OrderCancellationRequestDate__c,
                                                Order_Status__c from Sales_Order__c 
                                                where id=:SalesOrderID ]);
                                                
                                                
        OrderLineItemList = new List<Sales_Order_Line_Item__c>([select id,Product__c, name,Sale_Order__r.Sold_to_Party__r.Name,Sale_Order__r.SFDC_Order_Number__c,Item_Number__c,Price__c,
                                                                No_of_Case__c,SKU_Code__c,Quantity__c,SKU_Name__r.Pack_Size__c,SKU_Name__r.name,Sale_Order__r.Order_Status__c,
                                                                ProductName__c ,Sale_Order__r.id , Item_Status__c, OrderQuantityEdited__c, ItemQuantityEditedby__c
                                                                from Sales_Order_Line_Item__c
                                                                 where Sale_Order__r.id =: SalesOrderID] );
         // Put Line Item Id and No of Cases in Map                                                            
        for(Sales_Order_Line_Item__c st : OrderLineItemList ){
            SalesOrderLineItemQuantitiyMap.put(String.valueof(st.id),Integer.valueof(st.No_of_Case__c));
        }                                                               
    }
    
    // Update Line Item is invoked from visualforce page
    Public void updateLineItem(){
        // we iterate though the List and compare Current No of Cases value with old  value stored in Map if changed  update no of case and OrderQuantityEdited__c flag
        for(Sales_Order_Line_Item__c st : OrderLineItemList){
            st.Quantity__c = st.No_of_Case__c * st.SKU_Name__r.Pack_Size__c;
            st.ItemQuantityEditedby__c =  userinfo.getUserId();
            if(st.No_of_Case__c != SalesOrderLineItemQuantitiyMap.get(st.id))
            st.OrderQuantityEdited__c = True;
            
            
        }
        // Update Sales Order Line Item List
        update OrderLineItemList;
    
    }
}