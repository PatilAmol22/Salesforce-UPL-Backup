/*
* Name: SalesOrderPDFController
* Created On: 28/9/2017 
* Author: Ganesh Chaurasia (ganesh.chaurasia@skinternational.com)
* Description: Class to create PDF of Selected Sales Order.
* Supporting Classes: TestSOMBalanceController(Test Class).
*/
public class SalesOrderPDFController {
   
    public String selectedIDs{get;set;}
    public Sales_Order__c soPDF{get;set;}
    public String punctuality{get;set;}
    public List<Sales_Order_Line_Item__c> solPDF{get;set;}
    Public datetime now {get;set;}
    public String dateStr {get;set;}
    Public String CNPG_CPF {get;set;}
    
    public SalesOrderPDFController() {
        solPDF=new List<Sales_Order_Line_Item__c>();
        now = system.today();
        dateStr =now.format();
        CNPG_CPF = '';
        //getting recordId from component
        selectedIDs=ApexPages.CurrentPage().getParameters().get('id1');
        system.debug('Selected Record ID '+selectedIDs);
        punctuality = ApexPages.CurrentPage().getParameters().get('punct');
        if(null != punctuality){
            if(punctuality.equalsIgnoreCase('true')){
                punctuality = Label.Yes;
            }else{
                punctuality = Label.No;
            }
        }
        system.debug('Punctuality value : '+punctuality);
        system.debug('userinfo'+userinfo.getLocale()+'language'+userinfo.getLanguage());
        //retrieving value from Sales order //#INC-402441:Changed the query 
        soPDF = [SELECT Id, Name, SAP_Order_Number__c,Punctuality_Discount__c, Order_Status__c,Sold_to_Party__r.BillingAddress,Purchase_Order_no__c,createdDate,Expected_Number_of_days__c,
                 Sold_to_Party__r.Name, Sold_to_Party__c, ReloadPaymentTerms__c,Campaign_Payment_Term_Date__c,Use_Campaign__c,Sold_to_Party__r.BillingPostalCode,Sold_to_Party__r.BillingStreet,
                 Sold_to_Party__r.Tax_Number_3__c, TotalValueWithInterest__c,Sold_to_Party__r.Customer_Region__c,Inco_Term__r.Name,Sold_to_Party__r.BillingCountry,
                 Sold_to_Party__r.SAP_Code__c, TotalValueWithoutInterest__c,Inco_Term__c,Sold_to_Party__r.Email__c,Inco_Term_Code__c,Campaign_Type__c,
                 Sold_to_Party__r.Customer_Group__c,TotalReplacementCost__c, SalesOrderReplacementMargin__c,Payment_Term__r.Payterms_Desc__c,
                 Sold_to_Party__r.BillingCity, Price_Book__c, CreatedById, OwnerId, Owner.Name, Flag__c,Sold_to_Party__r.TaxNumber2__c,
                 Sold_to_Party__r.BillingState, Type_of_Order__c, Valid_From__c,Currency_Brazil__c,Sold_to_Party__r.Tax_Number_1__c,
                 Valid_To__c, PONumber__c, Purchase_Order_Date__c, PaymentMethod__c,Maturity_Date__c,
                 Payment_Term__c,Invoice_Message__c,Internal_OBS__c,Sales_order_OBS__c,PaymentMethod__r.Name,Text_Cal_Brazil__c                                      
                 FROM Sales_Order__c 
                 WHERE Id =: selectedIDs];  
        system.debug('soPDF.Sold_to_Party__r.Tax_Number_1__c'+soPDF.Sold_to_Party__r.Tax_Number_1__c);
        //Change added Date 15/6/2018
        if(soPDF!=null){//added by Srikanth
            //if(soPDF.Maturity_Date__c < system.today()){
             //   soPDF.Maturity_Date__c=null;
            //}
            if(soPDF.Sold_to_Party__r.Tax_Number_1__c!= null && soPDF.Sold_to_Party__r.TaxNumber2__c!= null){
                CNPG_CPF =  soPDF.Sold_to_Party__r.Tax_Number_1__c+' /'+soPDF.Sold_to_Party__r.TaxNumber2__c;
            }else if(soPDF.Sold_to_Party__r.Tax_Number_1__c!= null){
                CNPG_CPF =  soPDF.Sold_to_Party__r.Tax_Number_1__c;
            }else{
                CNPG_CPF =  soPDF.Sold_to_Party__r.TaxNumber2__c;
            }
        }
       // Changes by Swaranjeet Kaur(Grazitti) for RITM0491685  17 Jan 22
       // Changes by Swaranjeet Kaur(Grazitti) for RITM0531267  23 Mar 23(Reverting RITM0491685)
       /* DateTime tempdate = DateTime.newInstance(2022,11,30);
        Date tempdate1 = tempdate.date();
        DateTime d1 = soPDF.createdDate;
        Date actualdate = d1.date();*/
        if(soPDF!=null){
           // Changes by Swaranjeet Kaur(Grazitti) for RITM0531267  23 Mar 23(Reverting RITM0491685)
          /* if(actualdate <= tempdate1){
                solPDF = [SELECT ID, Sale_Order__c, DateofFAT__c,Item_Status__c, SKU_Name__c, UnitValue__c, InterestRate__c,
                  Quantity__c, UnitValuewithInterest__c, Time_in_months__c, Days__c, Flag__c,
                  PriceBookDetail__c, CurrencyIsoCode, Sales_Org__c, MaterialPlantRelation__c, Culture__c, Culture__r.Culture_Desc__c,
                  ExchangeRate__c, SKU_Name__r.Name, TotalValueWithInterest__c, TotalValueWithoutInterest__c, SKU_Name__r.SKU_Description__c
                  FROM Sales_Order_Line_Item__c WHERE Sale_Order__c=:selectedIDs];
        		system.debug('solPDF ----1'+solPDF);
                
            }
            else{*/
                system.debug('soPDF '+soPDF);
                //retrieving value from Sales order Line Item
                solPDF = [SELECT ID, Sale_Order__c, DateofFAT__c,Item_Status__c, SKU_Name__c, UnitValue__c, InterestRate__c,
                          Quantity__c, UnitValuewithInterest__c, Time_in_months__c, Days__c, Flag__c,
                          PriceBookDetail__c, CurrencyIsoCode, Sales_Org__c, MaterialPlantRelation__c, Culture__c, Culture__r.Culture_Desc__c,
                          ExchangeRate__c, SKU_Name__r.Name, TotalValueWithInterest__c, TotalValueWithoutInterest__c, SKU_Name__r.SKU_Description__c
                          FROM Sales_Order_Line_Item__c   WHERE Sale_Order__c=:selectedIDs and Item_Status__c !='Inactive'];
                system.debug('solPDF---2 '+solPDF);
                
           // }
            
        }
       
    }
    
}