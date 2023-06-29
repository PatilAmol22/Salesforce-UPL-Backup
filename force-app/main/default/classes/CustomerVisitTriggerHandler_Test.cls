@isTest
public class CustomerVisitTriggerHandler_Test{

    @isTest
    Static void beforeInsertProductTest(){
        test.startTest();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        //Id devContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('General_Contact').getRecordTypeId();
        Id devCustomerVisitRecordTypeId = Schema.SObjectType.Customer_Visit__c.getRecordTypeInfosByName().get('FR NeoFog teams').getRecordTypeId();
        system.debug('devCustomerVisitRecordTypeId ' + devCustomerVisitRecordTypeId);
        Sales_Org__c sorg = new Sales_Org__c();
        sorg.Name = 'France';
        sorg.Sales_Org_Code__c = '2700';
        insert sorg;
        
        Division__c div = new Division__c();
        div.Name = 'Decco';
        div.Description__c = 'Decco';
        div.Division_Code__c = 'DC';
        insert div; 
        
         Distribution_Channel__c dChannel =  new Distribution_Channel__c();
         dChannel.Name = '10';
         dChannel.Distribution_Channel_Code__c = '10';
         insert dChannel;
        
        Depot__c dep = new Depot__c(
            Name = 'UPL Do france - Aparecida de Goiania',   // Depot Name
            Country__c = 'france',                           // Country
            Depot_Code__c = 'FR04',                          // Depot Code
            Active__c = true,                                // Active
            SalesOrg__c = sorg.Id                           // Sales Org
        );
        insert dep;
        
        Account acc = new Account();
        acc.Name = 'LEONARDO PASSINATO';
        acc.Email__c = 'ganesh039@gmail.com';
        acc.Last_Name__c = 'PASSINATO';
        acc.SAP_Code__c = '2028843';
        acc.RecordTypeId = devRecordTypeId;
        acc.Mobile__c = '9967341759';
        acc.Phone = '01234567891';
        acc.Sales_Org__c = sorg.Id;
        acc.Division__c = Div.Id;
        acc.Distribution_Channel__c = dChannel.Id;
        acc.BillingCity = 'MINEIROS';
        acc.SAP_Code__c = '2028843';
        acc.Depot_Code__c = dep.Id;
        acc.Tax_Number_3__c = '114415455';
        acc.Tax_Number_1__c = '114414523';
        acc.Customer_Region__c = 'AC';
        acc.Customer_Group__c = '001';
        acc.Program_Margin_Discount__c = 0.00;
        acc.Active__c = true;
        acc.Search_Terms_1__c = 'LEONARDO PASSINATO';
        acc.Search_Terms_2__c = 'FAZ SEUBAK';
        //acc.key_account_manager__c = userTerMan1.Id;
        acc.Price_Conversion_Group__c = 'A';
        insert acc;
        
        
        //Account acc = [Select Id, Name From Account Where Name = '110 BOURGOGNE' Limit 1];
        //Contact con = [Select Id, Name From Contact where LastName = 'IgnoreMe' Limit 1];
        
        Contact con = new Contact(
        //RecordTypeId = devContactRecordTypeId,
        AccountId = acc.Id,
        LastName = 'ABC'
        //CurrencyIsoCode = 'INR - Indian Rupee' 
        //Segment_Multiselect__c = 'Dirigeant',
        //MobilePhone = '9123045876'
        );
        insert con;
        
        Customer_Visit__c cvObj = new Customer_Visit__c(
        RecordTypeId = devCustomerVisitRecordTypeId,
        Customer_Name__c = acc.Id,
        Cust_Interlocutor__c = con.Id,
        Date__c = system.today(),
        Product__c = 'DORMIR'    
       );
        
        insert cvObj;
        
        Customer_Visit__c cvObj1 = new Customer_Visit__c(
        RecordTypeId = devCustomerVisitRecordTypeId,
        Customer_Name__c = acc.Id,
        Cust_Interlocutor__c = con.Id,
        Date__c = system.today(),
        Product__c = 'ARGOS'    
       );
        
        insert cvObj1;
        test.stopTest();
        
    }
    
}