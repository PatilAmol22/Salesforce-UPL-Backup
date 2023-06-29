@isTest
public class PdfPriceListCommunicationTest {
 @testSetup
    static void allDataForThisClass(){
        
        Pricelist_Communication__c plcObj = new Pricelist_Communication__c();
       	plcObj.Financial_Year_Short_Name__c='18-19';
        plcObj.Financial_Year_Long_Name__c='2018-2019';
        plcObj.First_day_of_financial_year__c=System.today();
        plcObj.Distributor_billing_done_from__c=System.today();
        plcObj.Product_Placement_Scheme__c=10.2;
        plcObj.Cash_Collection_Scheme_Month__c='April 2018';
        plcObj.Cash_Collection_Scheme_Recieved__c=5000;
        plcObj.Distributor_Margin__c=7.2;
        plcObj.pro_rata_basis_regular__c=8.5;
        plcObj.SBU_Head__c='Rajendra Rathore';
        plcObj.Business_Head__c='P. Suresh Reddy';
        insert plcObj;
       
    } 
    
    static TestMethod void method(){
        PdfPriceListCommunication pdfplcController = new PdfPriceListCommunication();
        pdfplcController.getPCDetails();
    }
}