/*
* Name: SalesOrderCol_pdfController
* Created On: 15/7/2019
* Author: Ganesh Chaurasia (ganesh.chaurasia@skinternational.com)
* Description: Class to create PDF of Selected Sales Order.
* Supporting Classes: ---(Test Class).
*/
public class SalesOrderCol_pdfController {
   
    public String selectedIDs{get;set;}
    public Sales_Order__c soPDF{get;set;}
    public List<Sales_Order_Line_Item__c> solPDF{get;set;}
    Public datetime now {get;set;}
    public String dateStr {get;set;}
   
    
    public SalesOrderCol_pdfController() {
        solPDF=new List<Sales_Order_Line_Item__c>();
        now = system.today();
        dateStr =now.format();
      
        //getting recordId from component
        selectedIDs=ApexPages.CurrentPage().getParameters().get('id1');
        system.debug('Selected Record ID '+selectedIDs);
        system.debug('userinfo'+userinfo.getLocale()+'language'+userinfo.getLanguage());
        //retrieving value from Sales order 
        soPDF = [SELECT Id, Name, SAP_Order_Number__c, Order_Status__c,Sold_to_Party__r.BillingAddress,createdDate,Ship_To_Party__r.City__c,Ship_To_Party__r.Pincode__c,
                 Sold_to_Party__r.Name, Sold_to_Party__c,Sold_to_Party__r.BillingPostalCode,Sold_to_Party__r.BillingStreet,Ship_To_Party__r.State__c,CurrencyIsoCode,
                 Ship_To_Party__r.Billing_Street_1__c,Ship_To_Party__r.Billing_Street_2__c,Ship_To_Party__r.Billing_Street_3__c,Ship_To_Party__r.Billing_Street_5__c,Gross_Margin_Per_Colombia__c,
                 Sold_to_Party__r.Tax_Number_3__c,Sold_to_Party__r.BillingCountry,Sold_to_Party__r.SAP_Code__c,Sold_to_Party__r.Email__c,Ship_To_Party__r.Country_Name__c,
                 Payment_Term__r.Payterms_Desc__c,Sold_to_Party__r.BillingCity, OwnerId, Owner.Name,Net_Amount__c,Gross_Profit_colombia__c,Total_Discount_Per_Colombia__c,
                 Business_Impact_Per_colombia__c,Gross_Margin_Colombia__c,Remarks_Long__c,Order_Type_Colombia__c,
                 Sold_to_Party__r.BillingState,Currency_Brazil__c,Payment_Term__c                                     
                 FROM Sales_Order__c 
                 WHERE Id =: selectedIDs]; 
       
       system.debug('soPDF '+soPDF);
        //retrieving value from Sales order Line Item
        solPDF = [SELECT ID, Sale_Order__c, SKU_Name__c,UOM__c,Profit_colombia__c,Price__c,FinalPrice__c,Net_Margin_colombia__c,
                  Net_Price__c,Discount_Per_colombia__c,Margin_colombia__c,Discount_Value_colombia__c,UnitValue__c,Business_Type_Colombia__c,Unit_Price__c,
                  Quantity__c,CurrencyIsoCode, Sales_Org__c,SKU_Name__r.Name,   SKU_Name__r.SKU_Description__c
                  FROM Sales_Order_Line_Item__c   WHERE Sale_Order__c=:selectedIDs];
    }
    
}