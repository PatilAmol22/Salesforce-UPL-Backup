@isTest
public class InvoiceSummary_Test {
    @isTest
    public static void invsTest(){
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-',''); 
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String orgId = UserInfo.getOrganizationId();
        String uniqueName = orgId + dateString + randomInt;
        
        /*Account acc = new Account();
        acc.Name='Test';
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        insert acc;*/
        
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Poland',           // Sales Org Name
            Company_Code__c = '2941',      // Company Code
            Sales_Org_Code__c = '2941'   // Sales Org Code
            
        );
        insert salesOrgObj;
        
        Division__c DivisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '10'    // Division Code
        );
        insert DivisionObj;
        
        Distribution_Channel__c DistributionChannelObj = new Distribution_Channel__c(
            Name = '20',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '20',  // Distribution Channel Code
            Description__c='test'
        );
        insert DistributionChannelObj;
        
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
        
        Account acc = new Account(
            Name = 'SAR123',                                                            // Account Name
            RecordTypeId = devRecordTypeId,                                        // Account Record Type
            Last_Name__c = 'SAR123',                                         // Last Name
            SAP_Code__c = '0001023234',                                        // SAP Customer Code
            Mobile__c = '0876543219',                                          // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589793',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type            
            Sales_Org__c = salesOrgObj.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentTermObj.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07'                                         // Payment Terms                       
        );
        insert acc;
        
        Account acc2 = new Account(
            Name = 'SAR1234',                                                            // Account Name
            RecordTypeId = devRecordTypeId,                                        // Account Record Type
            Last_Name__c = 'SAR1234',                                         // Last Name
            SAP_Code__c = '0001023235',                                        // SAP Customer Code
            Mobile__c = '0876543267',                                          // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589793',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type            
            Sales_Org__c = salesOrgObj.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id,                       // Distribution Channel
            Payment_Term_Code__c = paymentTermObj.Id,                          // Payment Term Code
            Payment_Terms__c = 'UK07'                                         // Payment Terms                       
        );
        insert acc2;
        
        Contact c = new Contact();
        c.AccountId=acc.Id;
        c.LastName='Test';
        insert c; 
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
     //     UserRole userRole1 = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User u = new User(Alias = 'standt1', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            Country = 'Poland',
      //      ContactId=c.Id,
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id,                 
            TimeZoneSidKey='America/Los_Angeles',
            email = uniqueName + '@test' + orgId + '.org',
         //   UserRoleId = userRole1.Id,             
            Username = uniqueName + '@test' + orgId + '.org');
        insert u;
        
        User u1 = new User(Alias = 'standt1', 
            EmailEncodingKey='UTF-8',
            LastName='Testing1',
            Country = 'Colombia',
      //      ContactId=c.Id,
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id,                 
            TimeZoneSidKey='America/Los_Angeles',
            email = uniqueName + '@test1' + orgId + '.org',
         //   UserRoleId = userRole1.Id,             
            Username = uniqueName + '@test1' + orgId + '.org');
        insert u1;
        
        Product2 prd=new Product2();
        prd.Name='prd1';
        prd.Combination_Key__c='prd1combkey123mandetory';
        insert prd;
        
        
        Id devRecordTypeId1 = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Sales Order').getRecordTypeId();
        Sales_Order__c so = new Sales_Order__c(
            RecordTypeId = devRecordTypeId1,                        // Record Type
            SFDC_Order_Number__c = '87614',                      // SFDC Order Number
            // Order_Raise_By__c = 'Territory Manager',             // Order Raised By
            Desc_Punctuality__c = false,                         // Desc Punctuality
            Order_Date__c = System.today(),            // Order Date
            //OrderSubStatus__c = 'Draft',                         // Order Sub-Status
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
            Bill_To_Party__c = acc.Id,                // Bill To Party
            Depot_Code__c = 'IT00',                              // Depot Code
            Sold_to_Party__c = acc.Id,                // Sold to Party
            Total_Amount__c=12000,            
            UGDN__c = '20011688',                            // UGDN
            SAP_Order_Number__c='788989'
        );
        insert so;
        
        Invoice__c inv =new Invoice__c();
        //inv.Name='inv1';
        inv.Sales_Org__c=salesOrgObj.Id;
        inv.Sold_To_Party__c=acc.Id;
        inv.Billing_Doc_Number__c='123456';
        //inv.Sales_Order_No__c='1111';
        inv.PO_Number__c='222';
        inv.Billing_Date__c=Date.newInstance(2016, 12, 9);
        inv.CurrencyIsoCode='COP';
        //inv.TotalAmount__c=11111;
        inv.Sales_Order__c=so.Id;
        insert inv;
        
        SKU__c sku=new SKU__c();
        sku.Name='skName';
        sku.SKU_Code__c='sk01';
        sku.Product_Name__c=prd.id;
        insert sku;
        
        Invoice_Line_Item__c il=new Invoice_Line_Item__c();
        il.Invoice__c=inv.Id;
        il.Product__c=prd.Id;
        il.SKU__c=sku.Id;
        insert il;
        
        Poland_Price_Communication__c ppcObj=new Poland_Price_Communication__c();
         ppcObj.Account__c=acc.Id;
         ppcObj.Description__c='test';
         insert ppcObj;
        
        ContentVersion cv = new ContentVersion();
         cv.Title = 'Penguins';
         cv.PathOnClient = 'Penguins.jpeg';
         cv.VersionData = Blob.valueOf('Penguins');
         cv.IsMajorVersion = true;
         insert cv;    
         
         List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
         //create ContentDocumentLink  record 
         ContentDocumentLink cdl = New ContentDocumentLink();
         cdl.LinkedEntityId = ppcObj.id;
         cdl.Visibility='AllUsers';
         cdl.ContentDocumentId = documents[0].Id;
         insert cdl;
        
        Community_Url_Configuration__c cuc=new Community_Url_Configuration__c();
        cuc.Name='cucName';
        cuc.URL__c='abcdmnbv';
        insert cuc;
        
        
        
        test.startTest();
        
        
        PageReference pageRef3 = Page.InvoiceSummaryExcel;
        Test.setCurrentPage(pageRef3);
        pageRef3.getParameters().put('pgNo','1');
        pageRef3.getParameters().put('pgSize','10');
        pageRef3.getParameters().put('soNo','');
        pageRef3.getParameters().put('invDateFrom','');
        pageRef3.getParameters().put('invDateTo','');
        pageRef3.getParameters().put('prod','');
        pageRef3.getParameters().put('poNo','');
        pageRef3.getParameters().put('userAccId','');
        pageRef3.getParameters().put('cntry','Colombia');
        pageRef3.getParameters().put('inNo','12345');
        pageRef3.getParameters().put('sapON','123456');
        pageRef3.getParameters().put('soNo','1234567');
        InvoiceSummary.fetchUser();
        InvoiceSummary.fetchURL();
        InvoiceSummary.getInvoiceSummaryCount('1211','1111','56785','2019-06-01', '2019-07-15', 'prd1', '222', acc.Id, 'Colombia');
        InvoiceSummary.getInvoiceSummary('1', '1', '1111', '2019-06-01', '2019-07-15', 'prd1', '222', acc.Id, 'Colombia');
        InvoiceSummary.getInvoice(inv.Id);
        InvoiceSummary.getInvoiceLineItem(inv.Id);
        InvoiceSummary.getProductList(acc.Id);
        InvoiceSummary invsm3=new InvoiceSummary();
        
        system.runAs(u){
            PageReference pageRef2 = Page.InvoiceSummaryExcel;
            Test.setCurrentPage(pageRef2);
            pageRef2.getParameters().put('pgNo','1');
            pageRef2.getParameters().put('pgSize','10');
            pageRef2.getParameters().put('soNo','1111');
            pageRef2.getParameters().put('invDateFrom','2019-06-01');
            pageRef2.getParameters().put('invDateTo','2019-06-15');
            pageRef2.getParameters().put('prod','prd1');
            pageRef2.getParameters().put('poNo','222');
            pageRef2.getParameters().put('userAccId',acc.Id);
            pageRef2.getParameters().put('cntry','Japan');
            pageRef2.getParameters().put('inNo','12345');
            pageRef2.getParameters().put('sapON','123456');
            pageRef2.getParameters().put('soNo','1234567');
            InvoiceSummary invsm2=new InvoiceSummary();            
            InvoiceSummary.fetchURL();
            InvoiceSummary.getInvoiceSummaryCount('1211','1111','56785','2019-06-01', '2019-07-15', 'prd1', '222', acc.Id, 'Colombia');
            //InvoiceSummary.getInvoiceSummary('1', '1', '1111', '2019-06-01', '2019-07-15', 'prd1', '222', acc.Id, 'Colombia');
            //InvoiceSummary.getInvoice(inv.Id);
            //InvoiceSummary.getInvoiceLineItem(inv.Id);
            //InvoiceSummary.findChildAccounts();
           // InvoiceSummary.getContentVersionIds('12345');
            InvoiceSummary.WrapperInvoiceSummary wrapinv = new InvoiceSummary.WrapperInvoiceSummary();
            InvoiceSummary.ImageWrapper image = new InvoiceSummary.ImageWrapper();
            
        }
        /*
        system.runAs(u1){
            PageReference pageRef4 = Page.InvoiceSummaryExcel;
            Test.setCurrentPage(pageRef4);
            pageRef4.getParameters().put('pgNo','1');
            pageRef4.getParameters().put('pgSize','10');
            pageRef4.getParameters().put('soNo','1111');
            pageRef4.getParameters().put('invDateFrom','2019-06-01');
            pageRef4.getParameters().put('invDateTo','2019-06-15');
            pageRef4.getParameters().put('prod','prd1');
            pageRef4.getParameters().put('poNo','222');
            pageRef4.getParameters().put('userAccId',acc.Id);
            pageRef4.getParameters().put('cntry','Colombia');
            InvoiceSummary invsm4=new InvoiceSummary();
        }
        */
        test.stopTest();
    }

}