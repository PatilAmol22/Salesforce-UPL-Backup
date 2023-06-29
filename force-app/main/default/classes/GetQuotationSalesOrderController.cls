public with sharing class GetQuotationSalesOrderController {
    
    public String salesOrderId {get;set;}
    //public String lstName{get;set;}
    public String accountId {get;set;}
    
    public Sales_order__c soObject=new Sales_order__c();
    
    public List<Sales_Order__c> salesOrderList{get;set;}
    public Sales_Order_Line_Item__c soliObj=new Sales_Order_Line_Item__c();
    public List<Sales_Order_Line_Item__c> soliList{get;set;}
    
    
    public GetQuotationSalesOrderController(ApexPages.StandardController controller) {
        salesOrderId= ApexPages.CurrentPage().getparameters().get('soid');
        salesOrderList=new List<Sales_Order__c>();
        soliList=new  List<Sales_Order_Line_Item__c>();
       
        getGeneratePDF();
       
    }
    
    public void getGeneratePDF(){
        try{
            
            System.Debug('Enter into Generate PDF');
            System.Debug('Enter into Generate PDF' + salesOrderId);
            
            if(salesOrderId!=null || salesOrderId!=''){
                System.debug('sales Order id is '+salesOrderId);
                
                //getting list from sales order    
                salesOrderList=[select id,Name,createdDate,SFDC_Order_Number__c,SoldtoPartySAPCode__c,Sold_to_Party__r.Last_Name__c,Net_Amount__c,
                                PaymentMethod__r.Name,Payment_Term__r.Payment_Term__c,Ship_To_Party__r.City__c,Remarks__c 
                                from sales_order__c WHERE id=:salesOrderId LIMIT 1]; 
                                
                System.debug('salesOrderList'+salesOrderList);
                
                accountId=salesOrderList[0].Sold_to_Party__c;
                //getting list from sales order line item    
                
                soliList=[select id,SKU_Code__c,Product__c,SKU_Name__r.Product_with_SKU__c,Net_Price__c,
                          Quantity__c,UOM__c,Price__c 
                          from Sales_Order_Line_Item__c where Sale_Order__c=:salesOrderId];
                          
                     System.debug('soliList'+soliList);
            }  
            
            
        }
        catch(Exception ex){
           ApexLog.exceptionHandlerForSalesOrder(ex, salesOrderId, accountId); 
        }
        
    }
    
    
   
    
    
    
    
    
    
    
}