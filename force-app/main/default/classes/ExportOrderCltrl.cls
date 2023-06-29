/*--------------Nikhil----------------*/

public with sharing class ExportOrderCltrl{

    public Transient list<Export_Order__c> expOrderList;
    public Transient list<list<Export_Order__c>> nestedExpOrderList{get;set;}
    
    public ExportOrderCltrl(){
    
       String userId = UserInfo.getUserId();
            
            User LoginUser = [SELECT Id, Country,Profile.Name FROM User Where Id=:userId];
            System.debug('LoginUser...'+ LoginUser);
            System.debug('LoginUser Country..'+ LoginUser.Country);
 
        expOrderList= new list<Export_Order__c>();
        
        if(LoginUser.Country=='Australia'){
           
        expOrderList=[SELECT Id, Name,SKU__r.SKU_Code__c,Shipping_Location__c, Ship_To_Party__c, Ship_To_County__c, Sold_To_Party__c, Plant__c, Sales_Order_No__c, Sales_Order_Date__c, 
                        Customer_PO_Date__c, Customer_PO__c, Material_Description__c, Order_Quantity__c, Schedule_Line_Date__c, Label_Remark_in_SO__c, 
                        Label_confirmation_Date__c, Credit_Status__c, Required_Delivery_Date__c, Last_Date_of_Shipment_as_per_LC__c, Commitment_Date__c, 
                        Rev_Commitment_Date__c, Act_readiness_Date__c, Fact_Stuffing_date__c, Invoice_Quantity__c, Pending_Quantity__c, Tentative_Sailing_date__c, 
                        Actual_sailing_Date__c, Tentative_Arrival_date__c, Vessel_Name__c, Container_No__c, Logistics_Feedback__c, Shipping_Status__c, SO_Net_Price__c, 
                        SO_Net_Value__c, Invoice_net_value__c, Sales_Month__c, Payment_Term_Txt__c, Commercial_Invoice_date__c, Commercial_Invoice__c, DHL_NO__c, 
                        DHL_Date__c, Copy_Docs_Date__c, Docs_remark__c, Ldoc_no__c, Region__c, Overall_Order_Status__c, Excise_Invoice__c, Delivery_Block__c, 
                        Reason_for_rejection__c, Item__c, Schedule_Line__c, Order_quantity_unit__c, Bill_of_Lading_Date__c, MaterialGroupDescription__c, 
                        Distribution_Channel__c, Division__c, Sales_Office__c, sales_office_key__c, Unconfirmed_Mad__c, CurrencyIsoCode, Product__c, Payment_Term__c, 
                        SKU__c, OwnerId, Sales_Org__c, Status__c, CSV_Row__c, Combination_Key__c, SKU__r.Product_with_SKU__c,
                        Product__r.Name,Division__r.Name,Distribution_Channel__r.Name,Ship_To_Party__r.Location_Name__c,Sales_Org__r.Name,
                        Sold_To_Party__r.Name FROM Export_Order__c where Sold_To_Party__r.Hide_Export_Order__c=false
                        AND (NOT Shipping_Location__c LIKE '%DOW%') AND (NOT Shipping_Location__c LIKE '%NUFARM%')];
                 }
                 else{
                 
                 set<String> setCountry = new set<string>();
                     for(User_Country_Mapping__c ucm : [SELECT Id, Name, Sales_Org__c, User__c, Country_Code__c, Country_Name__c FROM User_Country_Mapping__c WHERE User__c=:LoginUser.Id]){
                         setCountry.add(ucm.Country_Name__c);
                     }
                     expOrderList=[SELECT Id, Name,SKU__r.SKU_Code__c,Shipping_Location__c, Ship_To_Party__c, Ship_To_County__c, Sold_To_Party__c, Plant__c, Sales_Order_No__c, Sales_Order_Date__c, 
                        Customer_PO_Date__c, Customer_PO__c, Material_Description__c, Order_Quantity__c, Schedule_Line_Date__c, Label_Remark_in_SO__c, 
                        Label_confirmation_Date__c, Credit_Status__c, Required_Delivery_Date__c, Last_Date_of_Shipment_as_per_LC__c, Commitment_Date__c, 
                        Rev_Commitment_Date__c, Act_readiness_Date__c, Fact_Stuffing_date__c, Invoice_Quantity__c, Pending_Quantity__c, Tentative_Sailing_date__c, 
                        Actual_sailing_Date__c, Tentative_Arrival_date__c, Vessel_Name__c, Container_No__c, Logistics_Feedback__c, Shipping_Status__c, SO_Net_Price__c, 
                        SO_Net_Value__c, Invoice_net_value__c, Sales_Month__c, Payment_Term_Txt__c, Commercial_Invoice_date__c, Commercial_Invoice__c, DHL_NO__c, 
                        DHL_Date__c, Copy_Docs_Date__c, Docs_remark__c, Ldoc_no__c, Region__c, Overall_Order_Status__c, Excise_Invoice__c, Delivery_Block__c, 
                        Reason_for_rejection__c, Item__c, Schedule_Line__c, Order_quantity_unit__c, Bill_of_Lading_Date__c, MaterialGroupDescription__c, 
                        Distribution_Channel__c, Division__c, Sales_Office__c, sales_office_key__c, Unconfirmed_Mad__c, CurrencyIsoCode, Product__c, Payment_Term__c, 
                        SKU__c, OwnerId, Sales_Org__c, Status__c, CSV_Row__c, Combination_Key__c, SKU__r.Product_with_SKU__c,
                        Product__r.Name,Division__r.Name,Distribution_Channel__r.Name,Ship_To_Party__r.Location_Name__c,Sales_Org__r.Name,
                        Sold_To_Party__r.Name FROM Export_Order__c ];
                 }
                 
  nestedExpOrderList = new List<List<Export_Order__c>>();
          Integer count = 0,index=0;
          System.debug('nestedExpOrderList');
          List<Export_Order__c>asts = new List<Export_Order__c>();
      
          for(Export_Order__c acc : expOrderList){
              count++;
            
              if(count>=999){
                     System.debug('count - '+count);
                   nestedExpOrderList.add(asts);  
                   asts= new List<Export_Order__c>();
                   index++;
                  count=0; 
              }
             asts.add(acc);
             
              
          }
          if(asts.size()>0){
               nestedExpOrderList.add(asts); 
          }
          System.debug(asts.size());
           System.debug('nestedExpOrderList');
           System.debug(nestedExpOrderList);

 
    }



  

}