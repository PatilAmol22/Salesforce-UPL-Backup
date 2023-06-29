/*Name :Vishal Pawar
Email : vishal.pawar@skinternational.com
class Name : SalesOrderItalyPDFController*/ 

public without sharing class SalesOrderItalyPDFController {
    
    public String salesOrderId {get;set;}
    public Sales_Order__c salesOrderObj {get;set;}
    public List<Sales_Order__c> salesOrderList {get;set;}
    public List<Sales_Order_Line_Item__c> soliList{get;set;}
    
    public SalesOrderItalyPDFController(ApexPages.StandardController controller) {
        salesOrderId= ApexPages.CurrentPage().getparameters().get('soid');
        salesOrderList=new List<Sales_Order__c>();
        soliList=new  List<Sales_Order_Line_Item__c>();
    }
    
    
    public void gettingSoID(){
        //salesOrderId= ApexPages.CurrentPage().getparameters().get('soid');
        //System.debug('@@@ gettingSoID salesOrderId '+salesOrderId); 
        
        generatePDF();
    }
    
    public void generatePDF(){
        salesOrderObj= new Sales_Order__c();
        
        try{
            
            System.debug('@@@ SalesOrderItalyPDFController salesOrderId '+salesOrderId); 
            
            if(salesOrderId!=null ){
                System.debug('@@@ SalesOrderItalyPDFController inside salesOrderId '+salesOrderId); 
                salesOrderObj = [Select id,Name,createdDate,LastModifiedDate,Sold_to_Party__r.Name,Sold_to_Party__r.SAP_Code__c,
                                 SAP_Order_Number__c,Ship_To_Party__r.Billing_Street_1__c,Ship_To_Party__r.Location_Name__c,
                                 Ship_To_Party__r.City__c, Ship_To_Party__r.State__c,Ship_To_Party__r.Country__c,Ship_To_Party__r.Pincode__c,
                                 Ship_To_Party__r.Billing_Street_2__c,Ship_To_Party__r.Billing_Street_3__c,
                                 Ship_To_Party__r.Billing_Street_4__c,Ship_To_Party__r.Billing_Street_5__c,
                                 Ship_To_Party__r.Billing_Street_6__c,Payment_Term__r.Payment_Term__c,Net_Amount__c,Total_Amount__c,
                                 Order_Type_Italy__c
                                 from Sales_Order__c WHERE Id=:salesOrderId];
                
                System.debug('@@@ salesOrderObj '+salesOrderObj);
                
                soliList = [select id,SKU_Name__r.SKU_Code__c,Net_Price__c,
                            SKU_Name__r.SKU_Description__c,Quantity__c,UOM__c,
                            Price__c,Rebate__c,Net_Invoice_Price__c,Transport_contribution__c,Shipping_Date__c,Comment__c
                            from Sales_Order_Line_Item__c 
                            where Sale_Order__c =:salesOrderId];
                
                System.debug('@@@  SalesOrderItalyPDFController soliList '+soliList.size());
                
                
            }
        }
        catch(Exception ex){
            System.debug('Error Occured '+ex.getLineNumber());
            System.debug('Error Occured '+ex.getMessage());
        }
        
    }
    
    
    
}