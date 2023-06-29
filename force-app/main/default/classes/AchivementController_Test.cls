@isTest
public class AchivementController_Test {
    static testMethod void myUnitTest() {
   Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id devRecordforCC = Schema.SObjectType.Community_Configuration__c.getRecordTypeInfosByName().get('Achievement').getRecordTypeId();
        
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
        
        
        Contact contactObj = new Contact(LastName = 'Contact Last Name');
        contactObj.AccountId = acc.Id;
        insert contactObj;  
        
        Community_Configuration__c sobj = new Community_Configuration__c(
            Country__c = 'Colombia',                                                     // Country
            RecordTypeId = devRecordforCC,
            Distributor_Name__c = acc.Id,// Record Type
            Active__c = true,                                                              // Active
            Community_User_Role__c = '1',                                                  // Community User Role
            Visible_to_All__c = true,                                                      // Visible to All
            Sales_Org__c = '5710',                                                         // Sales Org
            Display_On_Home_Page__c = false,                                               // Display On Home Page
            //Image__c = '\n',                                                               // Image
            Description__c = 'A thing done successfully with effort, skill, or courage.',  // Description
            Valid_From__c = Date.newInstance(2020, 12, 9),                                   // Valid From
            Valid_To__c = Date.newInstance(2022, 12, 9)                                       // Valid To
        );
        insert sobj;
        
        
        
        
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
             
            
            UserRole r = [select id from UserRole where name = 'UPL Management'];
            UserLicense licence = [SELECT Id FROM UserLicense where name ='Customer Community Plus'];
            Profile p = [SELECT Id FROM Profile WHERE UserLicenseId = : licence.Id Limit 1]; 
            
            User comUser = new User(alias = 'test123', 
                                    email='test123@noemail.com',
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
                                    username='newone@noemail.com');
            insert comuser;
        }
        
        User cuser = [select id from user where username ='newone@noemail.com' limit 1];
        
        
        
        
        System.RunAs(cuser) {
            AchivementController tmpObj = new AchivementController();
            tmpObj.gettingAchivementInfo();
        }  
        
    }
}