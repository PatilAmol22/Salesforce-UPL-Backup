/*-----------Nikhil-----------*/
@isTest
public class ExportOrderCltrlTest{

    static testMethod void validateHelloWorld(){
        
        Sales_Org__c salesorg = new Sales_Org__c(
                  Name = 'Turkey',           // Sales Org Name
                  Description__c = 'Turkey',   // Description
                  Company_Code__c = '2000',    // Company Code
                  Sales_Org_Code__c = '2000'  // Sales Org Code
                );
                insert salesorg;
        
        Sales_Org__c salesorg1 = new Sales_Org__c(
                  Name = 'Kenya',           // Sales Org Name
                  Description__c = 'Kenya',   // Description
                  Company_Code__c = '2000',    // Company Code
                  Sales_Org_Code__c = '2000'  // Sales Org Code
                );
                insert salesorg1;
    
     User u2 = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'Marketing Manager Indonesia'].Id,
     LastName = 'last',
     Email = 'puser000@amamama.com',
     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US',
     Country = 'Australia'
);  
    insert u2;
    
     /*  Sales_Org__c salesorg = new Sales_Org__c(
                  Name = 'Turkey',           // Sales Org Name
                  Description__c = 'Turkey',   // Description
                  Company_Code__c = '2000',    // Company Code
                  Sales_Org_Code__c = '2000'  // Sales Org Code
                );
                insert salesorg;
        
        Sales_Org__c salesorg1 = new Sales_Org__c(
                  Name = 'Kenya',           // Sales Org Name
                  Description__c = 'Kenya',   // Description
                  Company_Code__c = '2000',    // Company Code
                  Sales_Org_Code__c = '2000'  // Sales Org Code
                );
                insert salesorg1;*/
        
       User_Country_Mapping__c ucm = new  User_Country_Mapping__c( 
           Sales_Org__c =salesorg1.id, 
           User__c=userInfo.getUserId());  
        insert ucm;
        
        
    
    Date date1=Date.newInstance(2018, 08, 09); 
        
           Export_Order__c sobj = new Export_Order__c(
            Combination_Key__c = '50080331191010',           // Combination Key
            MaterialGroupDescription__c = 'CLODINAFOP 24 EC',  // Material Group Description
            Distribution_Channel__c='a0x28000001p9hcAAA',
            Customer_PO_Date__c=date1,
            Schedule_Line_Date__c=date1,
            Ship_To_County__c ='kenya',
            Label_confirmation_Date__c=date1,
            Required_Delivery_Date__c=date1,
            Last_Date_of_Shipment_as_per_LC__c=date1,
            Commitment_Date__c=date1,
            Rev_Commitment_Date__c=date1,
            Act_readiness_Date__c=date1,
            Fact_Stuffing_date__c=date1,
            Tentative_Sailing_date__c=date1,
            Actual_sailing_Date__c=date1,
            Tentative_Arrival_date__c=date1,
            Commercial_Invoice_date__c=date1,
            DHL_Date__c=date1,
            Copy_Docs_Date__c=date1,
            Bill_of_Lading_Date__c=date1,
            Unconfirmed_Mad__c=date1,
            Plant__c='PL03',
            Sales_Order_No__c='5005000722',
            Customer_PO__c='PO181901',
            Material_Description__c='MANCOZEB 80 WP (BLUE) - 25 KG_VN',
            Label_Remark_in_SO__c='STANDARD',
            Vessel_Name__c='HYUNDAI DYNASTY V-063E',
            Container_No__c='CAIU3602261',
            Logistics_Feedback__c='zzzzzzzz',
            Sales_Month__c='MAY.18',
            Commercial_Invoice__c='1400566959',
            DHL_NO__c='4964337490',
            Ldoc_no__c='1000019192',
            Region__c='RiceCo',
            Sales_Org__c=salesorg.Id,
            Excise_Invoice__c='1416523838',
            Delivery_Block__c='xxxxxx',
            Reason_for_rejection__c='xxxxxx',
            Sales_Office__c='UPL - HO',
            sales_office_key__c='HOP1',
            Order_Quantity__c=1800.00,
            Invoice_Quantity__c=1800.00,
            Pending_Quantity__c=1800.00,
            Item__c=1800.00,
            Schedule_Line__c=1800.00,
            SO_Net_Price__c=84602.88,
            SO_Net_Value__c=84602.88,
            Invoice_net_value__c=84602.88,
            Docs_remark__c='dfgdfg',
            CSV_Row__c='50080333701010',
            Payment_Term_Txt__c='5191BR71'
       );
        insert sobj;
     //  system.runAs(u2){
            ExportOrderCltrl obj = new ExportOrderCltrl();        
      //  }
    }

}