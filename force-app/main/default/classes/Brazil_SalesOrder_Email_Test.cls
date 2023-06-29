@isTest
    private class Brazil_SalesOrder_Email_Test {
        
  @testSetup
    static void allTheDataForThisTestClass() {
     
        /*id ProfileId = [SELECT Id FROM Profile WHERE Name = 'Brazil System Administrator'].Id;
        user u = new user();
        u=[select id,name,email from user where ProfileId=:ProfileId and IsActive=true limit 1];
        system.debug('**User Details - ' +u);*/
        
        Id devRecordTypeId = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Sales Order').getRecordTypeId();
        Id devRecordAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id devRecordDepot = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();
        
        
        //Data for Sales Org
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Brazil',           // Sales Org Name
            Company_Code__c = '2400',      // Company Code
            Sales_Org_Code__c = '5191',    // Sales Org Code
            Country_Code__c = 'BR'        // Country Codes
        );
        insert salesOrgObj;
        
        //Data for Division
        Division__c DivisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert DivisionObj;
        
        
        //Data for Distribution Channel
        Distribution_Channel__c DistributionChannelObj = new Distribution_Channel__c(
            Name = '20',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '20',  // Distribution Channel Code
            Description__c='test'
        );
        insert DistributionChannelObj;
    
        //Data for Payment Term      
        Payment_Term__c paymentTermObj = new Payment_Term__c(
            Payment_Term__c = 'Net 7 days',   // Payment Term
            Payment_Term_Code__c = 'UK01',      // Payment Term Code
            Payterms_Desc__c = 'Net 7 days',    // Payterms Desc
            Sales_Org__c = salesOrgObj.Id,   // Sales Org
            Days_to_calc_interest__c = 0,     // Days (to calc interest)
            Active__c = true,                   // Active
            CombinationKey__c = '5710UK01'     // CombinationKey
        );
        insert paymentTermObj;
        
        //Data for Price Group
        Price_Group_Master__c priceGroupMasterObj = new Price_Group_Master__c(
            PG_Code__c = '95',                // PG Code
            Description_Colombia__c = 'Casagro'  // Description
        );
        insert priceGroupMasterObj;
     
        //Data for Account 2
        Account accObj = new Account(
            Name = 'BAM S.A.',                              // Account Name
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'BAM S.A.',                                         // Last Name
            SAP_Code__c = '0001023194',                                        // SAP Customer Code
            Mobile__c = '1234567980',                                   // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589795',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = salesOrgObj.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentTermObj.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07',                                         // Payment Terms
            PriceGroupCode__c =priceGroupMasterObj.Id,              // Tax classification for customer
          AuthorizationGroupSalesoffice__c='',
          Tax_classification_for_customer__c='',
          Email__c='test@test.com'
        );
        insert accObj;
        
        Account accObj1 = new Account(
            Name = 'BAM S.A.',                              // Account Name
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'BAM S.A.',                                         // Last Name
            SAP_Code__c = '0001023195',                                        // SAP Customer Code
            Mobile__c = '1234567980',                                   // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589795',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = salesOrgObj.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentTermObj.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07',                                         // Payment Terms
            PriceGroupCode__c =priceGroupMasterObj.Id,              // Tax classification for customer
          AuthorizationGroupSalesoffice__c='',
          Tax_classification_for_customer__c='',
          Email__c='test1@test.com'
        );
        insert accObj1;
        
        Contact con = new Contact(
	         lastName = 'test',
             AccountId = accObj.id,
			 CurrencyIsoCode = 'USD',
             email='test@test.com',
             Brazil_Approval_Contact__c=true
                              );
	    insert con;
        
        Shipping_Location__c shippingLocationObj = new Shipping_Location__c(
            Location_Name__c = 'BAM S.A.',                           // Location Name
            SAP_Code__c = '0001023194',                                // SAP Code
            Distributor__c = accObj.Id,                        // Distributor
            City__c = 'BOGOTA DC',                                     // City
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',  // Billing Street 1
            State__c = '11',                                           // State
            Country__c = 'CO',                                         // Country
            Billing_Street_3__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',  // Billing Street 3
            Pincode__c = '11001',                                      // Pincode
            Sold_To_Party_SAP_Code__c = '0001023194',                  // Sold To Party (SAP Code)
            Combination_Key__c = '00010231940001023194',               // Combination Key
            Country_Name__c = 'Italy',                   // Country Name
            Sales_Org__c = salesOrgObj.Id,                          // Sales Org
            Distribution_Channel__c = DistributionChannelObj.Id,               // Distribution Channel
            Division__c = divisionObj.Id                           // Division
            
        );
        insert shippingLocationObj;
   
        //system.runAs(u){
          //Data for Sales Orders
        Sales_Order__c SalesOrderObj = new Sales_Order__c(
            RecordTypeId = devRecordTypeId,                        // Record Type
            SFDC_Order_Number__c = '87614',                      // SFDC Order Number
         // Order_Raise_By__c = 'Territory Manager',             // Order Raised By
            Desc_Punctuality__c = false,                         // Desc Punctuality
            Order_Date__c = System.today(),            // Order Date
            OrderSubStatus__c = 'Draft',                         // Order Sub-Status
            Punctuality_Discount__c = 0.00,                      // Punctuality Discount
            Flag_Status__c = '\n',                               // Flag Status
            isOffline_Mobile_Order__c = false,                   // isOffline Mobile Order
            BrazilOrderSubmittedforApproval__c = false,
            Call_Process_Builder_Flow__c = false,                // Call Process Builder Flow
            ProcessBuilderFlag__c = false,                       // Process Builder Flag
            Customer_Approval__c = false,                        // Customer Approval
            Sales_Org_lk__c = salesOrgObj.Id,                 // Sales Org
            RequestforCancellationCheck__c = false,              // Request for Cancellation
            TM_Code__c = '00051120',                             // TM Code
            ApprovedBySDM__c = false,     
            Order_Status__c ='Pending',
            ApprovedBySOM__c = false,                            // Approved By SOM
            ApprovedByBM__c = false,                             // Approved By BM
            ApprovedBySOMifSDMisNull__c = false,                 // Approved By SOM if SDM is Null
            Approved_By_SD__c = false,                           // Approved By SD
            Division_lk__c = DivisionObj.Id,                  // Division
            Distribution_Channel_lk__c = DistributionChannelObj.Id,      // Distribution Channel
            Sent_for_Manager_Approval_Mexico__c = true,          // Sent for Manager Approval
            Sent_for_Director_Approval_Mexico__c = false,        // Sent for Director Approval
            Bill_To_Party__c = accObj.Id,                // Bill To Party
            Depot_Code__c = 'IT00',                              // Depot Code
            Sold_to_Party__c = accObj.Id,                // Sold to Party
            Ship_To_Party__c = shippingLocationObj.Id,                // Ship To Party
            UGDN__c = '20011688'
            //OwnerId= u.Id
        );
        insert SalesOrderObj;
        
         Sales_Order__c SalesOrderObj2 = new Sales_Order__c(
            RecordTypeId = devRecordTypeId,                        // Record Type
            SFDC_Order_Number__c = '87611',                      // SFDC Order Number
         // Order_Raise_By__c = 'Territory Manager',             // Order Raised By
            Desc_Punctuality__c = false,                         // Desc Punctuality
            Order_Date__c = System.today(),            // Order Date
            OrderSubStatus__c = 'Draft',                         // Order Sub-Status
            Punctuality_Discount__c = 0.00,                      // Punctuality Discount
            Flag_Status__c = '\n',                               // Flag Status
            isOffline_Mobile_Order__c = false,                   // isOffline Mobile Order
            BrazilOrderSubmittedforApproval__c = false,
            Call_Process_Builder_Flow__c = false,                // Call Process Builder Flow
            ProcessBuilderFlag__c = false,                       // Process Builder Flag
            Customer_Approval__c = false,                        // Customer Approval
            Sales_Org_lk__c = salesOrgObj.Id,                 // Sales Org
            RequestforCancellationCheck__c = false,              // Request for Cancellation
            TM_Code__c = '00051120',                             // TM Code
            ApprovedBySDM__c = false,     
            Order_Status__c ='Pending',
            ApprovedBySOM__c = false,                            // Approved By SOM
            ApprovedByBM__c = false,                             // Approved By BM
            ApprovedBySOMifSDMisNull__c = false,                 // Approved By SOM if SDM is Null
            Approved_By_SD__c = false,                           // Approved By SD
            Division_lk__c = DivisionObj.Id,                  // Division
            Distribution_Channel_lk__c = DistributionChannelObj.Id,      // Distribution Channel
            Sent_for_Manager_Approval_Mexico__c = true,          // Sent for Manager Approval
            Sent_for_Director_Approval_Mexico__c = false,        // Sent for Director Approval
            Bill_To_Party__c = accObj1.Id,                // Bill To Party
            Depot_Code__c = 'IT00',                              // Depot Code
            Sold_to_Party__c = accObj1.Id,                // Sold to Party
            Ship_To_Party__c = shippingLocationObj.Id,                // Ship To Party
            UGDN__c = '20011689'
            //OwnerId= u.Id
        );
        insert SalesOrderObj2;
        
          }

     @isTest 
      static void tmethod() {
          list<Sales_Order__c> updateso = new list<Sales_Order__c>();
          list<Sales_Order__c> updateRso = new list<Sales_Order__c>();
          list<Sales_Order__c> so = new list<Sales_Order__c>();
          list<Sales_Order__c> soSalesRep = new list<Sales_Order__c>();
          list<id> soId = new list<id>();
          list<id> soRepId = new list<id>();
          
         so = [Select id,name,Order_Status__c,ownerId,Sold_to_Party__r.email__c,SFDC_Order_Number__c,UGDN__c,SAP_Order_Number__c From Sales_Order__c where UGDN__c='20011688' limit 1];
         soSalesRep = [Select id,name,Order_Status__c,ownerId,Sold_to_Party__r.email__c,SFDC_Order_Number__c,UGDN__c,SAP_Order_Number__c  From Sales_Order__c where UGDN__c='20011689' limit 1];
         
          system.debug('**Queried Sales_Order : ' +so);
          system.debug('**Queried soSalesRep : ' +soSalesRep);
          
          if(so!=null && so.size()>0){
             for(Sales_Order__c solist:so){
                 system.debug('**Inside If ');
             solist.Order_Status__c ='Approved';
             solist.SAP_Order_Number__c = '7000000966';
                 soId.add(solist.id);
                 updateso.add(solist);
             }
         }
         if(soSalesRep!=null && soSalesRep.size()>0){
             for(Sales_Order__c sorlist:soSalesRep){
                 system.debug('**Inside sales rep If ');
             sorlist.Order_Status__c ='Approved';
             sorlist.SAP_Order_Number__c = '7000000967';
                 soRepId.add(sorlist.id);
                 updateRso.add(sorlist);
             }
         }
          
        Test.startTest();  
        update updateso;
        update updateRso;
        system.debug('**updated Queried Sales_Order : ' +updateso);
          system.debug('**Sales_Order Id list : ' +soId);
        Brazil_SalesOrder_Email.sendPDFEmail(soId);
        Brazil_SalesOrder_Email.sendPDFEmail(soRepId);
        Test.stopTest();
    }
        @isTest 
        static void test2(){
         string sid;
         Sales_Order__c sorder = [Select id,name,Order_Status__c,ownerId,Sold_to_Party__r.email__c From Sales_Order__c  limit 1];
         sid=sorder.name;
         system.debug('**sorder id : ' +sid);
         system.debug('**sorder : ' +sorder);
        //Id distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        list<string> approvalString = new list<string>();
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        BrazilSOEmailServiceClass sClassObj = new BrazilSOEmailServiceClass();
        
        email.plainTextBody = 'APROVAR';
        email.fromAddress ='test@test.com';
        //String contactEmail = 'test@domain.com';
        //email.ccAddresses = new String[] {'Test Domain <' + contactEmail + '>'};
        email.subject = sid;
        
        
        sClassObj.handleInboundEmail(email, envelope);
    }
}