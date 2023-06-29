@IsTest
public class SORParentControllerTest {
    @testSetup
    static void validateTest() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c sorg = new Sales_Org__c();
        sorg.Name='Brazil';
        sorg.Description__c='Brazil';
        sorg.Sales_Org_Code__c='5191';
        insert sorg;
       
        Account acc = new Account(
            Name = 'MAURICIO BERNARDO X',// Account Name
            SAP_Code__c = '0001419276',                                     // SAP Customer Code
            Mobile__c = '000000000000000000',                               // Mobile
            Email__c = 'mauri@xxx.com',                            // Email
            Order_Block__c = false,                                         // Order Block
            Sales_Org__c = sorg.id,                               // Sales Org
            taxjurcode__c = 'GO 5218805',                                   // taxjurcode
            TaxNumber2__c = '12031688880',                                  // Tax Number 2
            Account_Type__c = 'Sold To Party',                              // Account Type
            Final_Approval_Date__c = system.today(),             // Final Approval Date
            Customer_Group__c = '069',                                      // Customer Group(Attribute 6)
            Last_Name__c = 'MAURICIO BERNARDO SCHOLTEN E OUTROS',           // Last Name
            OwnersetbyProcess__c = false,                                   // Owner set by Process
            RecordTypeId = devRecordTypeId                                     // Account Record Type
        );
        insert acc;
        
        Profile profAdmn = [SELECT Id,name FROM Profile WHERE Name = 'System Administrator'];
        Profile profSP = [SELECT Id,name FROM Profile WHERE Name = 'Brazil Sales Person'];
        Profile profSDM = [SELECT Id,name FROM Profile WHERE Name = 'Brazil Sales District Manager'];
        Profile profBSOM = [SELECT Id,name FROM Profile WHERE Name = 'Brazil Sales Office Manager'];
        Profile profBSaD = [SELECT Id,name FROM Profile WHERE Name = 'Brazil Sales Director'];
        Profile profBL = [SELECT Id,name FROM Profile WHERE Name = 'Brazil Logistics'];
        Profile profBCSU = [SELECT Id,name FROM Profile WHERE Name = 'Brazil Customer Service User'];
        Profile profBQT = [SELECT Id,name FROM Profile WHERE Name = 'Brazil Quality Team'];
        Profile profBLM = [SELECT Id,name FROM Profile WHERE Name = 'Brazil Logistics Manager'];
        Profile profBOM = [SELECT Id,name FROM Profile WHERE Name = 'Brazil Operation Manager'];
        Profile profBSD = [SELECT Id,name FROM Profile WHERE Name = 'Brazil Supply Director'];
        
        userrole  usrole = new userrole();
        usrole.Name ='CUSTOMER SERVICE ANALYST';
        
        User userAdmn = new User(
            Alias = 'admin',                                                            
            Email = 'skiadmin@skinternational123.com',                             
            ProfileId  = profAdmn.Id,                                                     
            Username = 'admin@upl122333.com.devbox',                                    
            IsActive = true,  
            LastName='Admin',
            CommunityNickname = 'AdminExe1222 Di', 
            TimeZoneSidKey = 'Asia/Kolkata', 
            LocaleSidKey = 'en_IN',                                    
            LanguageLocaleKey = 'en_US',                                             
            ForecastEnabled = false,                                                     
            EmailEncodingKey = 'ISO-8859-1',    
            Show_Inventory__c = false,                                                     
            Show_Credit_Limit__c = false, 
            UserRoleId=usrole.id,
            Country = 'Brazil'
        );
        insert userAdmn;
        
        User userSP = new User(
            Alias = 'SP',                                                            
            Email = 'skiSP@skinternational123.com',                             
            ProfileId  = profSP.Id,                                                     
            Username = 'SP@upl122333.com.devbox',                                    
            IsActive = true,  
            LastName='SP',
            CommunityNickname = 'SPExe1222 Di', 
            TimeZoneSidKey = 'Asia/Kolkata', 
            LocaleSidKey = 'en_IN',                                    
            LanguageLocaleKey = 'en_US',                                             
            ForecastEnabled = false,                                                     
            EmailEncodingKey = 'ISO-8859-1',    
            Show_Inventory__c = false,                                                     
            Show_Credit_Limit__c = false, 
            UserRoleId=usrole.id,
            Country = 'Brazil'
        );
        insert userSP;
        
        User userSDM = new User(
            Alias = 'SDM',                                                            
            Email = 'skiSDM@skinternational123.com',                             
            ProfileId  = profSDM.Id,                                                     
            Username = 'SDM@upl122333.com.devbox',                                    
            IsActive = true,  
            LastName='SDM',
            CommunityNickname = 'SDMExe1222 Di', 
            TimeZoneSidKey = 'Asia/Kolkata', 
            LocaleSidKey = 'en_IN',                                    
            LanguageLocaleKey = 'en_US',                                             
            ForecastEnabled = false,                                                     
            EmailEncodingKey = 'ISO-8859-1',    
            Show_Inventory__c = false,                                                     
            Show_Credit_Limit__c = false, 
            UserRoleId=usrole.id,
            Country = 'Brazil'
        );
        insert userSDM;
        
        User userBSOM = new User(
            Alias = 'BSOM',                                                            
            Email = 'skiBSOM@skinternational123.com',                             
            ProfileId  = profBSOM.Id,                                                     
            Username = 'BSOM@upl122333.com.devbox',                                    
            IsActive = true,  
            LastName='BSOM',
            CommunityNickname = 'BSOMExe1222 Di', 
            TimeZoneSidKey = 'Asia/Kolkata', 
            LocaleSidKey = 'en_IN',                                    
            LanguageLocaleKey = 'en_US',                                             
            ForecastEnabled = false,                                                     
            EmailEncodingKey = 'ISO-8859-1',    
            Show_Inventory__c = false,                                                     
            Show_Credit_Limit__c = false, 
            UserRoleId=usrole.id,
            Country = 'Brazil'
        );
        insert userBSOM;
        
        User userBSaD = new User(
            Alias = 'BSaD',                                                            
            Email = 'skiBSaD@skinternational123.com',                             
            ProfileId  = profBSaD.Id,                                                     
            Username = 'BSaD@upl122333.com.devbox',                                    
            IsActive = true,  
            LastName='BSaD',
            CommunityNickname = 'BSaDExe1222 Di', 
            TimeZoneSidKey = 'Asia/Kolkata', 
            LocaleSidKey = 'en_IN',                                    
            LanguageLocaleKey = 'en_US',                                             
            ForecastEnabled = false,                                                     
            EmailEncodingKey = 'ISO-8859-1',    
            Show_Inventory__c = false,                                                     
            Show_Credit_Limit__c = false, 
            UserRoleId=usrole.id,
            Country = 'Brazil'
        );
        insert userBSaD;
        
        User userBL = new User(
            Alias = 'BL',                                                            
            Email = 'skiBL@skinternational123.com',                             
            ProfileId  = profBL.Id,                                                     
            Username = 'BL@upl122333.com.devbox',                                    
            IsActive = true,  
            LastName='BL',
            CommunityNickname = 'BLExe1222 Di', 
            TimeZoneSidKey = 'Asia/Kolkata', 
            LocaleSidKey = 'en_IN',                                    
            LanguageLocaleKey = 'en_US',                                             
            ForecastEnabled = false,                                                     
            EmailEncodingKey = 'ISO-8859-1',    
            Show_Inventory__c = false,                                                     
            Show_Credit_Limit__c = false, 
            UserRoleId=usrole.id,
            Country = 'Brazil'
        );
        insert userBL;
        
        User userBCSU = new User(
            Alias = 'BCSU',                                                            
            Email = 'skiBCSU@skinternational123.com',                             
            ProfileId  = profBCSU.Id,                                                     
            Username = 'BCSU@upl122333.com.devbox',                                    
            IsActive = true,  
            LastName='BCSU',
            CommunityNickname = 'BCSUExe1222 Di', 
            TimeZoneSidKey = 'Asia/Kolkata', 
            LocaleSidKey = 'en_IN',                                    
            LanguageLocaleKey = 'en_US',                                             
            ForecastEnabled = false,                                                     
            EmailEncodingKey = 'ISO-8859-1',    
            Show_Inventory__c = false,                                                     
            Show_Credit_Limit__c = false, 
            UserRoleId=usrole.id,
            Country = 'Brazil'
        );
        insert userBCSU;
        
        User userBQT = new User(
            Alias = 'BQT',                                                            
            Email = 'skiBQT@skinternational123.com',                             
            ProfileId  = profBQT.Id,                                                     
            Username = 'BQT@upl122333.com.devbox',                                    
            IsActive = true,  
            LastName='BQT',
            CommunityNickname = 'BQTExe1222 Di', 
            TimeZoneSidKey = 'Asia/Kolkata', 
            LocaleSidKey = 'en_IN',                                    
            LanguageLocaleKey = 'en_US',                                             
            ForecastEnabled = false,                                                     
            EmailEncodingKey = 'ISO-8859-1',    
            Show_Inventory__c = false,                                                     
            Show_Credit_Limit__c = false, 
            UserRoleId=usrole.id,
            Country = 'Brazil'
        );
        insert userBQT;
        
        User userBLM = new User(
            Alias = 'BLM',                                                            
            Email = 'skiBLM@skinternational123.com',                             
            ProfileId  = profBLM.Id,                                                     
            Username = 'BLM@upl122333.com.devbox',                                    
            IsActive = true,  
            LastName='BLM',
            CommunityNickname = 'BLMExe1222 Di', 
            TimeZoneSidKey = 'Asia/Kolkata', 
            LocaleSidKey = 'en_IN',                                    
            LanguageLocaleKey = 'en_US',                                             
            ForecastEnabled = false,                                                     
            EmailEncodingKey = 'ISO-8859-1',    
            Show_Inventory__c = false,                                                     
            Show_Credit_Limit__c = false, 
            UserRoleId=usrole.id,
            Country = 'Brazil'
        );
        insert userBLM;
        
        User userBOM = new User(
            Alias = 'BOM',                                                            
            Email = 'skiBOM@skinternational123.com',                             
            ProfileId  = profBOM.Id,                                                     
            Username = 'BOM@upl122333.com.devbox',                                    
            IsActive = true,  
            LastName='BOM',
            CommunityNickname = 'BOMExe1222 Di', 
            TimeZoneSidKey = 'Asia/Kolkata', 
            LocaleSidKey = 'en_IN',                                    
            LanguageLocaleKey = 'en_US',                                             
            ForecastEnabled = false,                                                     
            EmailEncodingKey = 'ISO-8859-1',    
            Show_Inventory__c = false,                                                     
            Show_Credit_Limit__c = false, 
            UserRoleId=usrole.id,
            Country = 'Brazil'
        );
        insert userBOM;
        
        User userBSD = new User(
            Alias = 'BSD',                                                            
            Email = 'skiBSD@skinternational123.com',                             
            ProfileId  = profBSD.Id,                                                     
            Username = 'BSD@upl122333.com.devbox',                                    
            IsActive = true,  
            LastName='BSD',
            CommunityNickname = 'BSDExe1222 Di', 
            TimeZoneSidKey = 'Asia/Kolkata', 
            LocaleSidKey = 'en_IN',                                    
            LanguageLocaleKey = 'en_US',                                             
            ForecastEnabled = false,                                                     
            EmailEncodingKey = 'ISO-8859-1',    
            Show_Inventory__c = false,                                                     
            Show_Credit_Limit__c = false, 
            UserRoleId=usrole.id,
            Country = 'Brazil'
        );
        insert userBSD;
        
        SBU__c sbu = new SBU__c(
            SBUUser__c = userBSaD.Id,            // SBU User
            SBUCode__c = 'BR7',                          // SBU Code
            Brazil_SBU_Name__c = 'CULTURAS EXTENSIVAS',  // Brazil SBU Name
            SalesOrg__c = sorg.Id             // Sales Org
            // REH__c = '0055D000005Off6',                  // REH
            //GSD__c = '0050K000008kfCl'                  // GSD
        );
        insert sbu;
        
        Zone__c zone =  new Zone__c();
        zone.SalesOrg__c = sorg.Id;
        zone.Name = 'BU MATO GROSSO';
        zone.ZoneCode__c = 'BR000';              
        zone.ZonalHead__c = userBSOM.Id;
        //  zone.SBU_Code__c = sbu.Id;
        insert zone;
        
        Region__c region = new Region__c();
        region.Name = 'MATO GROSSO DO SUL';
        region.RegionCode__c =  'BR0000';
        region.SalesOrg__c = sorg.Id;
        region.Zone__c = zone.Id;
        region.RegionHead__c = userSDM.Id;
        //region.BrazilAnalyst__c = brzlU.Id;    
        // region.SBU__c = sbu.Id;                                                                           
        insert region;
        
        //system.debug('Test Class Data - region **** -' + region);
        
        Territory_Distributor__c territory =  new Territory_Distributor__c();
        territory.Name = 'Araxá';
        territory.TerritoryCode__c = 'BR000';
        //territory.SBU__c = sbu.Id;     
        territory.Region__c = region.id;
        territory.SalesOrg__c = sorg.Id;
        territory.RegionDesciption__c = 'BR1001102 CHPS';                       
        territory.Zone__c = zone.Id;
        territory.TerritoryManager__c = userSP.Id;
        // territory.TerritoryManagerActive__c = false;
        insert territory;
        
        Distribution_Channel__c dChannel =  new Distribution_Channel__c();
        dChannel.Name = '10';
        dChannel.Distribution_Channel_Code__c = '10';
        insert dChannel;
        
        Division__c div = new Division__c();
        div.Name = 'Agro Formulation';
        div.Description__c = 'Agro Formulation';
        div.Division_Code__c = '10';
        insert div;
        
        Product2 product = new Product2(
            Name = 'JACARÉ (4X5)',                           // Product Name
            Product_Code__c = '000000000006250371',            // Product Code
            Sales_Org__c = sorg.Id,                  // Sales Org
            Popular__c = false,                                // Popular
            Combination_Key__c = '5191000000000006250371',     // Combination Key
            Active__c = true,                                  // Active
            Division__c = div.Id,                   // Division
            Power_Brand__c = false,                            // Power Brand
            Active_For_Liquidation__c = false,                 // Active For Liquidation
            Budget_NRV__c = 0.00,                            // Budget NRV
            Is_Forecast_Required__c = true,                    // Is Forecast Required
            Product_Category__c = 'HERBICIDES',                // Product Category
            Brand_Name__c = 'JACARE',                          // Brand Name
            Default_Quantity_For_Sales_Agreement__c = 0.00,  // Default Quantity For Sales Agreement
            Description = 'JACARÉ (4X5)'                      // Product Description
        );
        insert product;
        
        SKU__c sku = new SKU__c(
            SKU_Description__c = 'JACARÉ (4X5)',              // SKU Description
            Active_For_Liquidation__c = false,                  // Active For Liquidation
            Name = 'JACARÉ (4X5)',                              // SKU Name
            SKU_Code__c = '000000000006250371',                 // SKU Code
            Product_Name__c = product.Id,                // Product Name
            Product_Category__c = 'HERBICIDES',                 // Product Category
            UOM__c = 'L',                                       // UOM
            Division__c = div.Id,                    // Division
            Sales_Org__c = sorg.Id,                     // Sales Org
            Multiple_of__c = 20.00,                           // Multiple Of
            Combination_Key__c = '5191000000000006250371',      // Combination Key
            PriceList_Active__c = false,                        // PriceList Active
            Active__c = true,                                   // Active
            Brand_Name__c = 'JACARE',                           // Brand Name
            Inventory_Dynamic_Check_Italy__c = false,           // Inventory Dynamic Check
            Inventory_order_Flag__c = 'Red',                    // Inventory order Flag
            Special_SKU__c = false,                             // Price Block SKU
            Kit_Product__c = false,                             // Kit Product
            Is_Forecast_Required__c = true,                     // Is Forecast Required
            Industrial_SKU__c = false,                          // Industrial SKU
            Material_Group_5__c = '2,4-D DIM240+PICLORAM64SC',  // Material Group 5
            Material_Group__c = 'A20190027'                    // Material Group
        );
        insert sku;
        
        Inco_Term__c inco = new Inco_Term__c();
        inco.Name = 'CIF';
        inco.IncoTerm_Code__c = 'CIF';
        inco.IncoTerm_Desc__c = 'Custo,  seguro & frete';
        inco.Sales_Org__c = sorg.Id;
        inco.Division__c = div.Id;
        inco.Distribution_Channel__c = dChannel.Id;
        inco.Active__c = true;
        insert inco;
        
        Depot__c depo = new Depot__c(
            Name = 'UPL Do Brazil - Bahia',            // Depot Name
            Country__c = 'Brazil',                       // Country
            //RecordTypeId = 'undefined',                  // Record Type
            Depot_Code__c = 'BR06',                      // Depot Code
            SalesOrg__c = sorg.Id,            // Sales Org
            Plant_Desc__c = 'UPL Do Brazil - Bahia',     // Plant Desc
            Active__c = true                            // Active
        );
        insert depo;
        
        Sales_Order__c so = new Sales_Order__c(
            //OwnerId = userTerMan.Id, 
            SFDC_Order_Number__c = '8360',                     // SFDC Order Number
            SAP_Order_Number__c = '7009090604',                 // SAP Order Number
            Order_Cancel__c = false,     
            Sales_Org_lk__c = sorg.Id,                             // Order Cancel
            Order_Status__c = 'Not yet processed',              // Order Status
            OrderSubStatus__c = 'Approved',                     // Order Sub-Status
            Region_Territory__c = territory.Id,                  // Region / Territory
            RequestforCancellationCheck__c = false,  
            BudgetApprovalCheck__c = false,// Request for Cancellation
            //  BarterManager__c = BarterUser.Id, 
            Flag_Status__c = 'dislike\n',                       // Flag Status
            BrazilOrderSubmittedforApproval__c = true,          // Brazil Order Submitted for Approval
            SalesOfficeManager__c = zone.ZonalHead__c,          // Sales Office Manager
            //Price_Book__c = pbook.Id,                          // Price Book
            SalesDistrictManager__c = region.RegionHead__c,    
            Inco_Term__c = inco.Id, 
            Currency_Brazil__c = 'Billing USD / Payment USD',   // Currency (Brazil)
            Key_Account__c = false,                             // Key Account
            Sold_to_Party__c = acc.Id,                         // Sold to Party
            Valid_FROM__c = system.today(), 
            //  PaymentMethod__c = pMethod.Id, // Valid FROM
            Valid_To__c = system.today()+350,                   // Valid To
            //Payment_Term__c = payTerm.Id,                     // Payment Term
            Type_of_Order__c = 'CONTRATO MÃE'                 // Type of Order
        );
        insert so;
        
        Invoice__c invc = new Invoice__c(
            Billing_Doc_Number__c = '0000495527',  // Billing Doc Number
            Billing_Date__c = system.today(),  // Billing Date
            Sales_Order__c = so.Id,            // Sales Order
            Sold_To_Party__c = acc.Id,          // Sold To Party
            Depot__c = depo.Id,                  // Depot
            Billing_Status__c = 'M',                // Billing Status
            SAP_Billing_DOC__c = '2199172208',             // SAP Billing DOC
            Sales_Org__c = sorg.Id,              // Sales Org
            Check_Attachment_File__c = false              // Check Attachment File
        );
        insert invc;
        //Add by kalpesh-start here
        Key_Account_Manager__c kam=new Key_Account_Manager__c();
        kam.Active__c=true;
        kam.Brazil_User__c=userSP.Id;
        kam.UniqueEmployee__c='test1234';
        insert kam;
        
        Order_Type__c ot=new Order_Type__c();
        ot.Order_Type_Code__c='test';
        ot.SalesOrg__c=sorg.id;
        ot.Name='ZROB';
        insert ot;
        
        RSO_Deposit__c dpst=new RSO_Deposit__c();
        dpst.Deposit_Code__c='teat123';
        insert dpst;
        
        RSO_Return_Sub_Status__c rss = new RSO_Return_Sub_Status__c();
        rss.Sub_Return_Type_Code__c='st123';
        insert rss;
        
        Return_Sales_Order__c rso=new Return_Sales_Order__c();
        rso.Customer__c=acc.Id;
        rso.SFDC_Order_Number__c='test1';
        rso.Order_Status__c='Pending';
        rso.Sub_Status__c='Pending At Quality Team';
        rso.Return_Sub_Type__c=rss.Id;
        rso.Refusal__c='No';
        rso.RSO_Raised_By__c='Sales District Manager';
        rso.Sales_District_Manager__c=userSP.Id;
        rso.Logistics_Operator_Email__c='devolucoes@bravolog.com.br	';
        rso.Sales_Office_Manager__c=userSP.Id;
        rso.Sales_Director__c=userSP.Id;
        rso.Credit_Analyst__c=userSP.Id;
        
        insert rso;
        
        Return_Sales_Order__c rso1=new Return_Sales_Order__c();
        rso1.Customer__c=acc.Id;
        rso1.SFDC_Order_Number__c='test12345';
        rso1.Order_Status__c='Approved';
        rso1.Sub_Status__c='Pending At Collection';
        rso1.Return_Sub_Type__c=rss.Id;
        rso1.Refusal__c='No';
        rso1.RSO_Raised_By__c='Sales District Manager';
        rso1.Sales_District_Manager__c=userSP.Id;
        rso1.Logistics_Operator_Email__c='devolucoes@bravolog.com.br';
        rso1.Sales_Office_Manager__c=userSP.Id;
        rso1.Sales_Director__c=userSP.Id;
        rso1.Credit_Analyst__c=userSP.Id;
        
        insert rso1;
        
        
         test.startTest(); 
        String str='TestData';
        ContentVersion cv=new Contentversion(); 
        cv.title='Test';
        cv.PathOnClient ='test'; 
        Blob b=Blob.valueOf(str); 
        cv.versiondata=b; 
        insert cv;
       
        ContentVersion  testContentInsert = [select id, ContentDocumentId from ContentVersion WHERE Id =: cv.Id limit 1];
        ContentDocumentLink cdl=new ContentDocumentLink();
        cdl.ContentDocumentId=testContentInsert.ContentDocumentId;
        cdl.LinkedEntityId=rso.id;
        cdl.ShareType='V';
        insert cdl;
        
        Invoice_Line_Item__c ili=new Invoice_Line_Item__c();
        ili.Billing_DOC_reference_number__c='ABCD12345';
        ili.Invoice__c=invc.Id;
        ili.SKU__c=sku.Id;
        insert ili;
        
        Return_Sales_Order_Line_Item__c rsoli=new Return_Sales_Order_Line_Item__c();
        rsoli.Invoice_Line_Item__c=ili.Id;
        rsoli.Return_Sales_Order__c=rso.Id;
        rsoli.Invoice_Line_Item__c=ili.Id;
        rsoli.Invoice__c=invc.Id;
        rsoli.Volumn_KG_LT__c=20;
        rsoli.Invoice_Line_Item__c=ili.Id;
        rsoli.Item_Number__c='1234567';
        rsoli.Slow_Moving__c='Yes';
        rsoli.Product_Contention__c='Yes';
        rsoli.Product_can_be_reworked__c='Yes';
        insert rsoli;
       
        
        RSO_with_Customer_Service__c rwcs=new RSO_with_Customer_Service__c();
        rwcs.Return_Sales_Order__c=rso.Id;
        rwcs.Invoice_Date__c=system.today();
        rwcs.Customer_Invoice_Date__c=system.today();
        rwcs.Order_Type__c=ot.Id;
        rwcs.Deposit__c=dpst.Id;
        rwcs.SAP_Order_Number__c='test54321';
        rwcs.Billing_Doc__c='Test1010';
        rwcs.Inco_Term__c='CIF';
        rwcs.Inco_Term_2__c='CFR';
        rwcs.Sub_Return_Type__c=rss.Id;
        rwcs.Deposit_Flag__c='TEST';
        rwcs.Full_Return__c=true;
        rwcs.Customer_Invoice__c='test12345';
        rwcs.Quantity__c=10;
        rwcs.Quantity_Flag__c='ABCD';
        rwcs.Billing_Doc_Item_Number__c=rsoli.Id;
        rwcs.Invoice__c=invc.Id;
        rwcs.Customer_Invoice__c='test12345';
        insert rwcs;
        
        Admin_MPT_Colombia__c amc=new Admin_MPT_Colombia__c();
        amc.Active__c=true;
        amc.Sales_Org__c=sorg.Id;
        amc.Maximum_Return_Value_BRL__c=10.0;
        amc.Maximum_Return_Value_USD__c=10;
        insert amc;
         test.stopTest();
         
    }
    static testMethod void methodSP() {
         test.startTest();
        User userSP=[SELECT Id,name, Profile.name FROM User where Alias='SP'];
        Account acc=[select Id from Account];
        Invoice__c invc=[select id from Invoice__c];
        Return_Sales_Order__c rso=[select id,RSO_Raised_By__c,Refusal__c,Order_Status__c,Sub_Status__c,Inco_Term_1__c from Return_Sales_Order__c where Order_Status__c='Pending'];
        Key_Account_Manager__c kam=[select Id,Brazil_User__c from Key_Account_Manager__c];
        // SORAttachmentChildController.AttachmentWrapper
       
        ContentVersion cv=[select id from ContentVersion];
        ContentVersion  testContentInsert = [select id, ContentDocumentId from ContentVersion WHERE Id =: cv.Id];
        List<SORAttachmentChildController.AttachmentWrapper> attWrapList=new List<SORAttachmentChildController.AttachmentWrapper>();
        SORAttachmentChildController.AttachmentWrapper attWrap=new SORAttachmentChildController.AttachmentWrapper();
        attWrap.docId=testContentInsert.ContentDocumentId;
        attWrap.sorId=rso.Id;
        attWrap.isEdit=true;
        attWrap.name='TestFile';
        attWrap.download='';
        attWrapList.add(attWrap);
        
        //SORTabSectionChildController.CustomerServiceWrapper
        List<SORTabSectionChildController.CustomerServiceWrapper> customerServiceList=new List<SORTabSectionChildController.CustomerServiceWrapper>();
        SORTabSectionChildController.CustomerServiceWrapper csWrap=new SORTabSectionChildController.CustomerServiceWrapper();
        RSO_with_Customer_Service__c rwcs=[select id,Billing_Doc_Item_Number__c,Quantity_Flag__c,Quantity__c,Full_Return__c,Customer_Invoice_Date__c,Customer_Invoice__c,Billing_Doc__c,Invoice__c,Inco_Term__c,Sub_Return_Type__c,Deposit__c,Deposit_Flag__c,Order_Type__c from RSO_with_Customer_Service__c];
        csWrap.recId = rwcs.Id;
        csWrap.sorId = '';
        csWrap.billingDoc = rwcs.Billing_Doc__c;
        csWrap.invoice = rwcs.Invoice__c;
        csWrap.invoiceName = '';
        csWrap.custInvoice = rwcs.Customer_Invoice__c;
        csWrap.returnType = rwcs.Sub_Return_Type__c;
        csWrap.returnTypeName = '';
        csWrap.srNo = 0;
        csWrap.invoiceDate = '2023-12-12';
        csWrap.incoTerm = rwcs.Inco_Term__c;
        csWrap.incoTerm2 = '';
        csWrap.fullReturn = false;
        csWrap.deposit = rwcs.Deposit__c;
        csWrap.depositName = '';
        csWrap.depositFlag = rwcs.Deposit_Flag__c;
        csWrap.productId = rwcs.Billing_Doc_Item_Number__c; // SOR Item Id...
        csWrap.productName = '';
        csWrap.quantity = rwcs.Quantity__c;
        csWrap.maxQuantity = 0;
        csWrap.quantityFlag = rwcs.Quantity_Flag__c;
        csWrap.billingDocNum = ''; // SOR Item Name...
        csWrap.custInvoiceDt = '2023-12-12';
        csWrap.docType = rwcs.Order_Type__c;
        csWrap.sapNo = '';
        csWrap.disableAction = false;
        csWrap.docTypeName = '';
        customerServiceList.add(csWrap); 
        
        List<SORProductDetailsChildController.ProductDetailsWrapper> rsoItemList=new List<SORProductDetailsChildController.ProductDetailsWrapper>();
        SORProductDetailsChildController.ProductDetailsWrapper ProDetailWrap=new SORProductDetailsChildController.ProductDetailsWrapper();
        Return_Sales_Order_Line_Item__c rsoli=[select Id,Invoice_Line_Item__c,Invoice__c from Return_Sales_Order_Line_Item__c];
        ProDetailWrap.accountId=acc.Id;
        ProDetailWrap.sorId=rso.Id;
        ProDetailWrap.invoiceId=invc.Id;
        ProDetailWrap.incoTerm=rso.Inco_Term_1__c;
        ProDetailWrap.billingDoc='';
        ProDetailWrap.invoiceDate=string.valueof(System.today());
        ProDetailWrap.srNo = 0;
        ProDetailWrap.recId = rsoli.Id;
        ProDetailWrap.invoiceItemId = rsoli.Invoice_Line_Item__c;
        ProDetailWrap.invoiceName = '';
        ProDetailWrap.productCode = '';
        ProDetailWrap.productName = '';
        ProDetailWrap.productDescription = '';
        ProDetailWrap.batch = '';
        ProDetailWrap.currencyCode = '';
        ProDetailWrap.volume = 0;
        ProDetailWrap.unitValue = 0;
        ProDetailWrap.totalValue = 0;
        ProDetailWrap.expireDate = string.valueof(System.today());
        ProDetailWrap.atAG = '';
        ProDetailWrap.productDamage = '';
        ProDetailWrap.packagingCondition = '';
        ProDetailWrap.productCondition = '';
        ProDetailWrap.comments = '';
        ProDetailWrap.slowMoving = 'Yes';
        ProDetailWrap.productContention = 'Yes';
        ProDetailWrap.productRework = 'Yes';
        ProDetailWrap.reworkCost = 0;
        ProDetailWrap.writeOff = '';
        ProDetailWrap.uom = '';
        ProDetailWrap.maxVolume = 0;
        ProDetailWrap.isEdit = false;
        ProDetailWrap.billingDoc = '';
        ProDetailWrap.invoiceDate = '';
        rsoItemList.add(ProDetailWrap);
        String jsonString = JSON.serialize(rsoItemList);
        system.debug('jsonString@@@@'+jsonString);
        SOROrderDetailsChildController.OrderDetailsWrapper odWrap=new SOROrderDetailsChildController.OrderDetailsWrapper();
        SORTabSectionChildController.TabSectionWrapper tsWrap=new SORTabSectionChildController.TabSectionWrapper();
        Map<String,Decimal> sdMap =new Map<String,Decimal>();
        String sorDetailsString = '{"sorId":"'+rso.id+'", "orderDetailsWrap":{"refusal":"No", "reInvoicing":"No", "dateOfIncident":"2022-03-01", "logisticsOperator":"ABC", "returnType":"Return", "returnSubType":"", "accountId":"'+acc.Id+'", "accountName":"Test Account", "soNumber":"1234", "creditAnalyst":"", "returnDetails":"Test Details"}, "tabSectionWrap":{"cnpjCPF":"01234567890", "contact":"Test Contact", "email":"test@test.com", "costCenter":"Test Cost Center", "address":"Test Address", "postCode":"12345678", "state":"Test State", "branch":"Test Branch", "farm":"Test Farm", "suburb":"Test Suburb", "city":"Test City", "phoneNumber":"1234567890", "returnAmount":15, "estimatedCollectionDate":"2023-03-30", "proceedWithRtrn":"Yes", "necessaryTechInspectn":"No","inspectionDate":"2022-03-15"},"productWrapList":[{"writeOff":"","volume":0,"uom":"","unitValue":0,"totalValue":0,"srNo":0,"sorId":"a4J0k000000b4C2EAI","slowMoving":"Yes","reworkCost":0,"recId":"a4I0k000000bPzpEAE","productRework":"Yes","productName":"","productDescription":"","currencyCode":"USD"}]}';
     //  test.stopTest();
        System.runAs(userSP){
           // test.startTest();
            SORParentController.getSORDetails(rso.Id);
            SORParentController.createSOR(sorDetailsString);
            SORParentController.getUserFromProfile(userSP.Profile.name);
            SORParentController.getUserByName(userSP.name);
            SORParentController.checkKeyAccountManager(kam.Brazil_User__c);
            SORParentController.createAttachments(attWrapList,rso.Id);
            SORParentController.createSORItem(rsoItemList,rso.Id,rso.Order_Status__c,false);
            rso.Order_Status__c='Approved';
            rso.Sub_Status__c='Pending At Process Return';
            SORParentController.createCustomerService(customerServiceList,rso);
            
            test.stopTest();
            //Add by kalpesh-End here
        }
    }
    static testMethod void methodSDM() {
         test.startTest();
        User userSDM=[SELECT Id,name, Profile.name FROM User where Alias='SDM'];
        Account acc=[select id from Account];
        Return_Sales_Order__c rso=[select id,RSO_Raised_By__c from Return_Sales_Order__c where Order_Status__c='Approved'];
        Key_Account_Manager__c kam=[select Id,Brazil_User__c from Key_Account_Manager__c];
        System.runAs(userSDM){
           
            rso.Order_Status__c = 'Draft';
            SORParentController.getSORDetails(rso.Id);
            SORParentController.getUserFromProfile(userSDM.Profile.name);
            SORParentController.getUserByName(userSDM.name);
            SORParentController.checkKeyAccountManager(kam.Brazil_User__c);
            test.stopTest();
            //Add by kalpesh-End here
        }
    }
    static testMethod void methodBL() {
         test.startTest();
        User userBL=[SELECT Id,name, Profile.name FROM User where Alias='BL'];
        Account acc=[select id from Account];
        Return_Sales_Order__c rso1=[select id,RSO_Raised_By__c,Order_Status__c from Return_Sales_Order__c where Order_Status__c='Approved'];
        Key_Account_Manager__c kam=[select Id,Brazil_User__c from Key_Account_Manager__c];
        String sorDetailsString = '{"sorId":"", "orderDetailsWrap":{"refusal":"No", "reInvoicing":"No","status":"Approved", "dateOfIncident":"2022-03-01","subStatus":"Pending At Book Collection", "logisticsOperator":"ABC", "returnType":"Return", "returnSubType":"", "accountId":"'+acc.Id+'", "accountName":"Test Account", "soNumber":"1234", "creditAnalyst":"", "returnDetails":"Test Details"}, "tabSectionWrap":{"logisticOperatorMail":"devolucoes@bravolog.com.br","cnpjCPF":"01234567890", "contact":"Test Contact", "email":"test@test.com", "costCenter":"Test Cost Center", "address":"Test Address", "postCode":"12345678", "state":"Test State", "branch":"Test Branch", "farm":"Test Farm", "suburb":"Test Suburb", "city":"Test City", "phoneNumber":"1234567890", "returnAmount":15, "estimatedCollectionDate":"2023-03-30", "proceedWithRtrn":"Yes", "necessaryTechInspectn":"No","inspectionDate":"2022-03-15"},"productWrapList":[{"writeOff":"","volume":0,"uom":"","unitValue":0,"totalValue":0,"srNo":0,"sorId":"a4J0k000000b4C2EAI","slowMoving":"Yes","reworkCost":0,"recId":"a4I0k000000bPzpEAE","productRework":"Yes","productName":"","productDescription":"","currencyCode":"BRL"}]}';
        String sorDetailsString1 = '{"sorId":"'+rso1.id+'", "orderDetailsWrap":{"refusal":"No","status":"Approved","subStatus":"Pending At Collection", "reInvoicing":"No", "dateOfIncident":"2022-03-01", "logisticsOperator":"ABC", "returnType":"Return", "returnSubType":"", "accountId":"'+acc.Id+'", "accountName":"Test Account", "soNumber":"1234", "creditAnalyst":"", "returnDetails":"Test Details"}, "tabSectionWrap":{"logisticOperatorMail":"devolucoes@bravolog.com.br","actualCollectionDate":"2023-12-12","cnpjCPF":"01234567890", "contact":"Test Contact", "email":"test@test.com", "costCenter":"Test Cost Center", "address":"Test Address", "postCode":"12345678", "state":"Test State", "branch":"Test Branch", "farm":"Test Farm", "suburb":"Test Suburb", "city":"Test City", "phoneNumber":"1234567890", "returnAmount":15, "estimatedCollectionDate":"2023-03-30", "proceedWithRtrn":"Yes", "necessaryTechInspectn":"No","inspectionDate":"2022-03-15"},"productWrapList":[{"writeOff":"","volume":0,"uom":"","unitValue":0,"totalValue":0,"srNo":0,"sorId":"a4J0k000000b4C2EAI","slowMoving":"Yes","reworkCost":0,"recId":"a4I0k000000bPzpEAE","productRework":"Yes","productName":"","productDescription":"","currencyCode":"BRL"}]}';
        System.runAs(userBL){
           
            SORParentController.getSORDetails(rso1.Id);
            SORParentController.createSOR(sorDetailsString);
            SORParentController.createSOR(sorDetailsString1);
            test.stopTest();
            //Add by kalpesh-End here
        }
    }
}