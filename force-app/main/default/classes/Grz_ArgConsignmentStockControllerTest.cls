/**************************************************************************************************
* Name             : Grz_CaseOrderCountInvocableClassTest                                                     
* Description      : To cover the invocable class created for Grz_UPLArgCaseCount flow
* Created Date     : 09-08-2022                                                                        
* Project/JIRA     : APPS-1757                                                                        
* Created By       : Gurubaksh Grewal (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 16-08-2022                                                                        
**************************************************************************************************/

@isTest
public class Grz_ArgConsignmentStockControllerTest {
     @testSetup
    static void testSetup(){
        
        final Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
         Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Argentina';
        sorg.Description__c='Argentina';
        sorg.Sales_Org_Code__c='5631';
        insert sorg;
           
        Account acc = new Account();
        acc.Name='Bhavik Devdhar';
        acc.Last_Name__c='Devdhar';
       
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Raise_Order_Type__c = 'Factura';
        acc.Mobile__c='9967341759';
        acc.Phone='020256589';
        acc.Sales_Org__c=sorg.Id;
       
        acc.BillingCity='Charata';
       
        acc.Depot_Code__c = 'PUN1';
        acc.CurrencyIsoCode = 'USD';
        //acc.OwnerId=sobj.Id;
        insert acc;
        
        Consignment__c con=new Consignment__c();
        con.Account__c=acc.id;
        con.status__c='Pending';
        con.LP_Number__c='345678';
        
        insert con;
        
        Consignment_Stock__c cs=new Consignment_Stock__c();
        cs.Consignment__c=con.id;
        cs.Net_Price1__c=100;
        cs.Qty_Sold__c=100;
        cs.Product__c='P1';
        cs.UOM__c='L';
        cs.Lote_Number__c='1000';
        cs.Quantity__c='500';
        insert cs;
        
       
        
       
        Payment_Method__c paymentMethodObj = new Payment_Method__c(
            Name = 'Contado',                   // Payment Method Name
            Sales_Org__c = sorg.Id,      // Sales Org
            Payment_Method_Code__c = 'C1',     // Payment Method Code
            Active__c = true                  // Active
        );
        insert paymentMethodObj;
        
       Payment_Term__c paymentTermObj = new Payment_Term__c(
            Payment_Term_Code__c = '0015',                     // Payment Term Code
            Payment_Term__c = '30 dias',                         // Payment Term
            Payterms_Desc__c = 'Pagamento estrito em 30 dias.',  // Payterms Desc
            Maturity_Date_Mandatory__c = 'Yes',                  // Maturity Date Mandatory
            Sales_Org__c = sorg.Id,                    // Sales Org
            Active__c = false                                   // Active
        );
        insert paymentTermObj;
        
        Payment_Method_Payment_Term_Mapping__c pmpt = new Payment_Method_Payment_Term_Mapping__c();
        pmpt.Payment_Method__c = paymentMethodObj.Id;
        pmpt.Payment_Term__c = paymentTermObj.Id;
        pmpt.Discount__c = 5;
        insert pmpt;
            
        }
        
        /*UPL_General_Case_Type__mdt customMdtRecord = new UPL_General_Case_Type__mdt();
        customMdtRecord.Name = 'Weed Availability';
        customMdtRecord.Type__c = 'Weed';
        customMdtRecord.Sub_Query__c = 'Availability';  
        customMdtRecord.Required_Fields__c = 'Other_Crop_Name__c;Theme_of_Month__c;Promotional_Product__c;Croplist_is_Already_Updated__c;Crop_Type__c;CropName__c;Sowing_Date__c;Season_Type__c;Override__c;Acreage__c;Type_of_farm__c';
        insert customMdtRecord;*/
    
    
    
    Public  static testmethod void testMethod1(){
		Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true)); 
        Test.startTest();
        Grz_ArgentinaConsignmentStockController.getArData('1177970');
        Grz_ArgentinaConsignmentStockController.loggedUserData();
        Grz_ArgentinaConsignmentStockController.getConsignmentData();
        Grz_ArgentinaConsignmentStockController.ItemInfo wrp = new Grz_ArgentinaConsignmentStockController.ItemInfo();
        wrp.Customer='';
        wrp.MaterialNo='';
        wrp.BatchNo='';
        wrp.MaterialDescription='';
        wrp.UnrestrictedInventory='';
        Test.stopTest();
    }
    
      Public  static testmethod void testMethod2(){
		List<Account> acc=[Select id from Account Limit 1];
          List<Consignment__c> con=[Select id from Consignment__c Limit 1];
          List< Grz_ArgentinaConsignmentStockController.consignmentStockListWrapper> lst=new List<Grz_ArgentinaConsignmentStockController.consignmentStockListWrapper>();
          Grz_ArgentinaConsignmentStockController.consignmentStockListWrapper consignmentWrapper=new Grz_ArgentinaConsignmentStockController.consignmentStockListWrapper();
          consignmentWrapper.lote='1000';
          consignmentWrapper.product='P1';
          consignmentWrapper.quantity='1000';
          consignmentWrapper.uom='L';
          consignmentWrapper.quantitySold=200;
          consignmentWrapper.netPrice=200;
          lst.add(consignmentWrapper);
        Test.startTest();
        Grz_ArgentinaConsignmentStockController.retrievePaymentMethod();
        Grz_ArgentinaConsignmentStockController.retrieveConsignment(acc[0].id);
          Grz_ArgentinaConsignmentStockController.updateStatusOfConsignment(acc[0].id);
           Grz_ArgentinaConsignmentStockController.retreiveExistingRecord(acc[0].id);
          Grz_ArgentinaConsignmentStockController.retrieveConsignmentStock(acc[0].id);
           Grz_ArgentinaConsignmentStockController.retrieveConsignmentStock(acc[0].id);
                  Grz_ArgentinaConsignmentStockController.insertConsignmentStockList(lst,acc[0].id ,
                                                                             'USD', 1.300,'345678' ,'30 dias' , 'Pagamento estrito em 30 dias.', '', '');
       Grz_ArgentinaConsignmentStockController.insertConsignmentStockList(lst,acc[0].id ,
                                                                             'USD', 1.300,'3456781' ,'30 dias' , 'Pagamento estrito em 30 dias.', '', '');

          Grz_ArgentinaConsignmentStockController.retrieveEditDeclaration(acc[0].id,'345678');
          Grz_ArgentinaConsignmentStockController.setMonitorLog('test', 'message');
          Grz_ArgentinaConsignmentStockController.fileUpload(con[0].id,'file','fileName');
        Test.stopTest();
    }
    
}