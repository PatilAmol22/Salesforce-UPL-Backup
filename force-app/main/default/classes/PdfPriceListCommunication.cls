/*
* Name: OrderIndiaControllerVer2
* Created On: 13 July 2018
* Author: Azhar Shaikh (azhar.shaikh@skinternational.com)
* Description: Class is used for displaying pricelist communication data in PdfPriceListCommunication visualforce page
*/
public class PdfPriceListCommunication {

    
    public List<Pricelist_Communication__c> plcList {get;set;}
    
    public PdfPriceListCommunication(){
        
        plcList = new List<Pricelist_Communication__c>();
        getPCDetails();
    }
    
    public List<Pricelist_Communication__c> getPCDetails(){
        
        
        plcList = [SELECT Id, Financial_Year_Short_Name__c, Financial_Year_Long_Name__c, First_day_of_financial_year__c, 
                   Distributor_billing_done_from__c, Product_Placement_Scheme__c, Cash_Collection_Scheme_Month__c, Cash_Collection_Scheme_Recieved__c, 
                   Distributor_Margin__c, pro_rata_basis_regular__c, Business_Head__c, SBU_Head__c  FROM Pricelist_Communication__c];
            
        String billing_date= formatDate(plcList[0].Distributor_billing_done_from__c);
        String firstDay_date= formatDate(plcList[0].First_day_of_financial_year__c);
        System.debug('plcList :- '+plcList);  
        System.debug('billing_date :- '+billing_date);  
        System.debug('firstDay_date :- '+firstDay_date); 
      
        return plcList;
    }
    
    public static String formatDate(Date d) {
    return d.day()+'-'+ d.month() + '-'+ d.year();
}
    
}