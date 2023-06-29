@isTest
public class Section_Controller_Test {
    static testMethod void myUnitTest() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id devRecordforCC = Schema.SObjectType.Community_Configuration__c.getRecordTypeInfosByName().get('Account Summary').getRecordTypeId();
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Colombia';
        sorg.Description__c='Colombia';
        sorg.Sales_Org_Code__c='5710';
        insert sorg;
        
        
        
        Order_Type__c  orderTypeObj = new Order_Type__c(
            Name = 'ZXOR',                  // Order Type Name
            Description__c = 'Factura',     // Description
            Order_Type_Code__c = 'ZXOR',      // Order Type Code
            SalesOrg__c = sorg.Id  // Sales Org
        );
        insert orderTypeObj;
        
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
        
        
        
        Depot__c dp =new Depot__c ();
        dp.Name='Argentina';
        dp.Country__c='Argentina';
        dp.Location__c='Charata';
        dp.Depot_Code__c='PUN1';
        insert dp;
        
        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        insert Pro;
        
        
        
        Distribution_Channel__c disbj = new Distribution_Channel__c();
        disbj.Name = '20';                      
        disbj.Distribution_Channel_Code__c = '20';  
        disbj.Description__c='test';
        insert disbj;
        
        Division__c Divbj = new Division__c();
        Divbj.Name = '10';         
        Divbj.Description__c = null;    
        Divbj.Division_Code__c = '10'; 
        insert Divbj;
        
        SKU__c sku = new SKU__c();
        sku.Name='DOST';
        sku.SKU_Code__c='704002';
        sku.SKU_Pack__c=1.00;
        sku.SKU_UOM__c='L';
        sku.Group__c='DOST';
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='L';
        sku.Active__c=True;
        sku.Combination_Key__c='Cooooooo000011111';
        sku.Multiple_of__c = 5.00;
        insert sku;
        
        PriceBookMaster__c PbMaster = new PriceBookMaster__c(
            BudgetPrice__c = 5.00,                                        // Budget Price
            SKUCode__c = sku.id,                               // SKU Code
            MinPrice__c = 5.20,                                           // Min Price
            DepotCode__c = dp.id,                             // Depot Code
            Price__c = 7.00,
            PG_CODE__c =Pg.Id,                           // Price
            UOM__c = 'KG',                                                // UOM
            StartDate__c = system.today(),                      // Start Date
            
            EndDate__c = system.today()+1,                       // End Date
            // DistributionChannel__c = 'a0x0k000000IQiV',                   // Distribution Channel
            Active__c = true,                                            // Active
            PerUnit__c = 1, 
            Batch__c ='test',
            CompositeKey__c = 'c1',  // CompositeKey
            Sales_Org__c = sorg.id,                             // Sales Org
            Price_Book_Change__c = false                                 // Price_Book_Change
        );
        insert PbMaster; 
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZXOR';              
        ordType.Description__c = 'Factura';    
        ordType.Order_Type_Code__c = 'ZXOR';
        insert ordType;
        
        Account acc = new Account();
        acc.Name='Bhavik Devdhar';
        acc.Last_Name__c='Devdhar';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Raise_Order_Type__c = 'Factura';
        acc.Mobile__c='9967341759';
        acc.Phone='020256589';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Charata';
        acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        //acc.OwnerId=sobj.Id;
        insert acc;
        
        
       /* Payments__c paymentObj = new Payments__c(
            Bounce__c = 0.00,                    // Bounce
            Customer_Name__c = acc.Id,  // Customer Name
            X1_15__c = 0.00,                       // 1 - 15
           // Company_Code__c = 'a1F280000002VNK',   // Company Code
            X16_30__c = 0.00,                      // 16-30
            X31_60__c = 0.00,                      // 31-60
            X61_90__c = 0.00,                      // 61-90
            X91_120__c = 0.00,                     // 91-120
            Forecasted_Collection__c = 10000.00,   // Forecasted Collection
            Total_Collectibles__c = 82246.59,      // Total Collectibles
            Net_Overdue__c = 82246.59,             // Net Overdue
            Total_Collection__c = 10000.00,        // Total Collection
            Non_Forecasted_Collection__c = 0.00   // Non-Forecasted Collection
        );
        insert paymentObj;*/
        
        Contact contactObj = new Contact(LastName = 'Contact Last Name');
        contactObj.AccountId = acc.Id;
        insert contactObj;  
        
        Community_Configuration__c ccObj = new Community_Configuration__c(
            Country__c = 'Colombia',                   // Country
            RecordTypeId = devRecordforCC,                  // Record Type
            Active__c = true,                            // Active
            Community_User_Role__c = '1',                // Community User Role
            Visible_to_All__c = true,                    // Visible to All
            Sales_Org__c = '5710',                       // Sales Org
            Distributor_Name__c = acc.Id,     // Distributor Name
            Image__c = '\n',                             // Image
            Custom_Link_Name__c = 'www.google.com',      // Custom Link Name
            Valid_From__c = System.today(),  // Valid From
            Valid_To__c = System.today()    // Valid To
        );
        insert ccObj;
        
        Sales_Org__c sorg1 =new Sales_Org__c();
        sorg1.Name='Poland';
        sorg1.Description__c='Poland';
        sorg1.Sales_Org_Code__c='2941';
        insert sorg1;
        
        Account acc1 = new Account();
        acc1.Name='Bhavik Devdhar1';
        acc1.Last_Name__c='Devdhar1';
        acc1.PriceGroupCode__c=pg.id;
        acc1.SAP_Code__c='SAP996756';
        acc1.RecordTypeId=devRecordTypeId;
        acc1.Raise_Order_Type__c = 'Factura';
        acc1.Mobile__c='9967341759';
        acc1.Phone='020256589';
        acc1.Sales_Org__c=sorg1.Id;
        acc1.Division__c=Divbj.Id;
        acc1.Distribution_Channel__c=disbj.Id;
        acc1.BillingCity='Charata';
        acc1.Order_Type__c=ordType.Id;
        acc1.Depot_Code__c = 'PUN1';
        //acc.OwnerId=sobj.Id;
        insert acc1;
        
		Contact contactObj1 = new Contact(LastName = 'Contact Last Name');
        contactObj1.AccountId = acc1.Id;
        insert contactObj1;     
        
        Invoice__c inv=new Invoice__c();
        inv.Sold_To_Party__c=acc1.id;
        inv.Billing_Date__c=Date.newInstance(2022, 12, 9);
        insert inv;
        
        
        
        Invoice_Line_Item__c invLineItem=new Invoice_Line_Item__c();
        
        invLineItem.Invoice__c=inv.id;
        invLineItem.Product__c=pro.Id;
        invLineItem.Net_Value__c=1000;
        invLineItem.Quantity__c=5;
        insert invLineItem;
        
       Invoice__c inv1=new Invoice__c();
        inv1.Sold_To_Party__c=acc1.id;
        inv1.Billing_Date__c=Date.newInstance(2021, 12, 9);
        insert inv1;
        
        
        
        Invoice_Line_Item__c invLineItem1=new Invoice_Line_Item__c();
        
        invLineItem1.Invoice__c=inv1.id;
        invLineItem1.Product__c=pro.Id;
        invLineItem1.Net_Value__c=1000;
        invLineItem1.Quantity__c=5;
        insert invLineItem1;
        
         
        Invoice_Line_Item__c invLineItem2=new Invoice_Line_Item__c();
        
        invLineItem2.Invoice__c=inv1.id;
        invLineItem2.Product__c=pro.Id;
        invLineItem2.Net_Value__c=1000;
        
        insert invLineItem2;
        UserRole r1 = [select id from UserRole where name = 'UPL Management'];
        UserLicense licence1 = [SELECT Id FROM UserLicense where name ='Customer Community Plus'];
        Profile p1 = [SELECT Id, Name FROM Profile WHERE UserLicenseId = : licence1.Id and Name='Customer Community Plus User - Colombia' Limit 1]; 
        
        User User = new User(alias = 'test1234', 
                                    email='test1234@noemail.com',
                                    emailencodingkey='UTF-8', 
                                    lastname='Testing1234', 
                                    languagelocalekey='en_US',
                                    localesidkey='en_US', 
                                    profileid = p1.Id, 
                                    country='Poland',
                                    Community_Role__c ='1',
                                    IsActive =true,
                                    contactId=contactObj1.Id,
                                    timezonesidkey='America/Los_Angeles', 
                                    username='newone1234@noemail.com');
            insert User;
        
        	UserRole r = [select id from UserRole where name = 'UPL Management'];
            UserLicense licence = [SELECT Id FROM UserLicense where name ='Customer Community Plus'];
            Profile p = [SELECT Id , Name FROM Profile WHERE UserLicenseId = : licence.Id and Name='Customer Community Plus User - Colombia' Limit 1]; 
            
            User comUser = new User(alias = 't12345', 
                                    email='test12345@noemail.com',
                                    emailencodingkey='UTF-8', 
                                    lastname='Testing', 
                                    languagelocalekey='en_US',
                                    localesidkey='en_US', 
                                    profileid = p.Id, 
                                    country='United States',
                                    Community_Role__c ='1',
                                    IsActive =true,
                                    contactId=contactObj.Id,
                                    timezonesidkey='America/Los_Angeles', 
                                    username='newone12345@noemail.com');
            insert comuser;
        
            
        //User cuser = [select id from user where username ='newone@noemail.com' limit 1];
                           
        System.RunAs(comuser) {
            //Section_Controller tmpObj = new Section_Controller();
            test.startTest();
            Section_Controller.showHideDetailsInfo();
            Section_Controller.collectionInfo();
            Section_Controller.outstandingInfo();
            Section_Controller.Credit_Info();
            Section_Controller.fetchSalesAmt();
            Section_Controller.fetchSalesGrowth();
            Grz_ShowConversionRateClass.showConversionInfo();
 
             
             Section_Controller.fetchSalesAmtMontly();
            Section_Controller.fetchSalesAmtProductWise();
            test.stopTest();
            
        }  
        
        System.RunAs(User) {
            //Section_Controller tmpObj = new Section_Controller();
            Section_Controller.showHideDetailsInfo();
            Section_Controller.collectionInfo();
            Section_Controller.outstandingInfo();
            Section_Controller.Credit_Info();
            Section_Controller.fetchSalesAmt();
            Section_Controller.fetchSalesGrowth();
                  
             Section_Controller.fetchSalesAmtMontly();
            Section_Controller.fetchSalesAmtProductWise();
            
           Grz_ShowConversionRateClass.showConversionInfo();
        }  
    }
    
    
    
    
    
    
}