/*******************************************************************************************
* @Name         GlobalEmailTemplate
* @Author       Prashant Kumbhar <prashant.kumbhar@skinternational.com>
* @Date         02/12/2022
* @Group        SKI
* @Description  This class contains all  methods related to GlobalEmailTemplate.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Prashant        02/12/2022           Initial Creation                                                      
*******************************************************************************************/

public  class GlobalEmailTemplate {
    
    public string recipientId;
    public string relatedToId;
    
    public User recipient {get;set;}
    public Sales_Order__c relatedTo {get;set;}
    
    public string getRecipientId() {return recipientId; }
    public void setRecipientId(string inString) {
        recipientId = inString;
        recipient = [SELECT id,name FROM User WHERE id = :recipientId];
        System.debug('recipient id'+recipient);
    }
    
    
    public string getRelatedToId() { return relatedToId;}
    public void setRelatedToId(string inString) {
        relatedToId = inString;
        relatedTo = [SELECT id,name,TotalValueWithoutInterest__c,Payment_Term__r.Payterms_Desc__c,Total_Amount__c,Exchange_Rate__c,Sent_for_Latam_Director_Approval__c,Sent_for_CCO__c,Total_Overall_Margin__c,Sold_to_Party__r.Name,REH__r.Name,Ship_To_Party__r.Name,Manager__r.Name,Sales_Director_Mexico__r.Name,Latam_Director_Mexico__r.Name,RegionalManager__r.Name,Order_Value_USD__c,Payment_Term_Days__c,Payment_Term_Mexico__c,Inco_Term_Mexico__c,Remarks_Long__c,Ship_To_Party__r.Location_Name__c,Net_Amount__c,Payment_Method_Mexico__c,Sold_to_Party__r.SAP_Code__c,CurrencyIsoCode,SalesOrg__r.Name,SalesOrgCode__c,PaymentMethod__r.Description__c  ,Payment_Term__r.Payment_Term__c,Inco_Term__r.Name,Remarks__c,(select id,name,Contribution__c,SKU_Net_Price__c,Margin_Block_Level_1__c, Margin_Block_Level_2__c,Margin_Block_Level_3__c,SKU_Name__r.Product_Name__r.MG_Desc__c,SKU_Name__r.Brand_Name__c,SKU_Name__r.SKU_Code__c,SKU_Name__r.SKU_Description__c, Base_UOM__c,UOM__c,Converted_Qty__c,Quantity__c,Manager_Price_Sales_Director_Price__c,Director_Price_Latam_Director_Pri__c,Sub_Region_Price__c,Is_Approval_LATAM__c,Converted_Net_Price_USD__c,PLN_Value_USD__c,
                     Converted_Net_Price__c,Net_Price__c,PLN__c,Contribution_Margin__c,Type_of_Sale__c,Reason__c,Net_Price_USD__c,CurrencyIsoCode,Blanket_SKU_Status__c,Blanket_SKU_Start_Date__c,Blanket_SKU_End_Date__c,ExchangeRate__r.ExchangeRate__c from Sales_Order_Line_Item__r),(select id,name from Attachments) FROM Sales_Order__c where id=:relatedToId];
        
    }
    
}