@isTest 
public class GlobalEmailTemp_Test {
    
    @isTest 
    public static Void GlobalEmailTemptest(){
        GlobalEmailTemplate mail = new GlobalEmailTemplate();
        
        User argentinaUsr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager Argentina'].Id,
            LastName = 'ABCD',
            Email = 'prashant.kumbhar@skinternational.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'SK international',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Country = 'Argentina'
        );
        insert argentinaUsr;
        System.runAs(argentinaUsr){
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();            
            
            Depot__c dp =new Depot__c ();
            dp.Name='Charata';
            dp.Country__c='Argentina';
            dp.Location__c='Charata';
            dp.Depot_Code__c='PUN1';
            insert dp;
            
            TM_Depot_Mapping__c TMDepoMap = new TM_Depot_Mapping__c();
            TMDepoMap.Depot__c = dp.Id;        // Depot
            TMDepoMap.Territory_Manager__c = argentinaUsr.id;  // Territory Manager
            insert TMDepoMap;
            
            Sales_Org__c sorg = new Sales_Org__c();
            sorg.Sales_Org_Code__c ='5631';
            sorg.Name ='Argentina';
            insert sorg;
            
            Distribution_Channel__c distributionChannelObj = new Distribution_Channel__c(
                Name = 'Direct',                   
                Distribution_Channel_Code__c = '10' 
            );
            insert distributionChannelObj;
           
            Division__c divisionObj = new Division__c(
                Name = 'Agro Formulation',// Division Name
                Division_Code__c = '10'   // Division Code
            );
            insert divisionObj;
            
            Account accObj = new Account(
                Name='Prashant Kumbhar',
                SAP_Code__c = '0001013292', 
                RecordTypeId=devRecordTypeId,             
                Last_Name__c = 'ADECO AGROPECUARIA S.A.',     
                Order_Block__c = false,                       
                Mobile__c = '9619335445',  
                Phone='5454545454', // Mobile
                Email__c = 'pkumbhar128@gmail.com',       
                Account_Type__c = 'Sold To Party',            
                Raise_Order_Type__c = 'Factura',                 
                Billing_Street_2__c = 'CATAMARCA 3454',      
                Sales_Org__c = sorg.id,             
                Division__c = divisionObj.Id,              
                Distribution_Channel__c = distributionChannelObj.Id,  
                Depot_Code__c = 'AR13'                     
            );
            insert accObj;
            
            Shipping_Location__c shippingLocationObj = new Shipping_Location__c(
                Location_Name__c = 'ADECO AGROPECUARIA S.A.',
                Distributor__c = accObj.Id,            
                SAP_Code__c = '00010132925631',                
                City__c = 'MARTINEZ -PCIA. BUENOS AI',         
                State__c = '01',                               
                Country__c = 'AR',                             
                Pincode__c = '1640',                           
                Sold_To_Party_SAP_Code__c ='0001013292',      
                Sales_Org__c = sorg.Id,            
                Distribution_Channel__c = distributionChannelObj.Id,   
                Division__c = divisionObj.id              
            );
            insert shippingLocationObj;
            
            Payment_Method__c paymentMethodObj = new Payment_Method__c(
                Name = 'Contado',                   
                Sales_Org__c = sorg.Id,  
                Payment_Method_Code__c = 'C1',     
                Active__c = true,  
                Description__c='CHEQUE-C'
            );
            insert paymentMethodObj;
            
            Payment_Term__c paymentTermObj = new Payment_Term__c(
                Payment_Term_Code__c = '0015',                    
                Payment_Term__c = '30 dias',                         
                Payterms_Desc__c = 'Pagamento estrito em 30 dias.',  
                Maturity_Date_Mandatory__c = 'Yes',                  
                Sales_Org__c = sorg.Id,                   
                Active__c = false                                 
            );
            insert paymentTermObj;
            
            Inco_Term__c IT = new Inco_Term__c();
            IT.IncoTerm_Code__c ='CIP';
            IT.Name ='CIP';
            IT.IncoTerm_Desc__c='CIP';
            IT.Sales_Org__c=sorg.id;
            insert IT;
   
            Sales_Order__c sales = new Sales_Order__c();
            sales.Sold_to_Party__c=accObj.id;
            sales.REH__c =argentinaUsr.Name;
            sales.Ship_To_Party__c=shippingLocationObj.id;
            sales.Manager__c=argentinaUsr.id;
            sales.Sales_Director_Mexico__c=argentinaUsr.id;
            sales.Latam_Director_Mexico__c=argentinaUsr.id;
            sales.RegionalManager__c=argentinaUsr.id;
            sales.CurrencyIsoCode='USD';
            sales.Exchange_Ratio_from__c=10;
            sales.Exchange_Rate__c=15;
            sales.Remarks_Long__c='ABCD';
            sales.Shipping_Location_Name__c=shippingLocationObj.Name;
            sales.SalesOrg__c=sorg.id;
            Sales.PaymentMethod__c=paymentMethodObj.id;
            Sales.Payment_Term__c=paymentTermObj.id;
            Sales.Inco_Term__c=IT.id;
            Sales.Remarks__c='Abcd';
              
            insert sales;
            
            Sales_Order_Line_Item__c salesordr = new Sales_Order_Line_Item__c();
            salesordr.Sale_Order__c = sales.Id;
            salesordr.SKU_Net_Price__c= 383035.71;
            salesordr.Margin_Block_Level_1__c =true;   
            salesordr.Margin_Block_Level_2__c =true;                                                                                      
            salesordr.Margin_Block_Level_3__c =true;
            salesordr.Base_UOM__c = 'L';
            salesordr.UOM__c = 'L';
            salesordr.Converted_Qty__c =3000.00;
            salesordr.Quantity__c =3000.00;
            salesordr.Manager_Price_Sales_Director_Price__c = 667.07;
            salesordr.Director_Price_Latam_Director_Pri__c=606.36;
            salesordr.Sub_Region_Price__c = 606.36;
            salesordr.Is_Approval_LATAM__c =true;
            salesordr.Converted_Net_Price__c = 178.57;
            salesordr.Net_Price__c = 178.57;
            salesordr.PLN__c = 178.57;
            salesordr.Contribution_Margin__c =-9.12;
            salesordr.Type_of_Sale__c ='Real Sale';
            salesordr.CurrencyIsoCode = 'USD';
            salesordr.Blanket_SKU_Status__c =true;
            salesordr.Sales_Deduction_Cal__c =10;
            salesordr.E2E_Cost_Cal__c=40;   
            insert salesordr;
             
            Test.startTest();
            mail.setRelatedToId(sales.Id);
            mail.setRecipientId(argentinaUsr.id);
            mail.getRecipientId();
            mail.getRelatedToId();
            Test.stopTest();
            
        }
    }
}