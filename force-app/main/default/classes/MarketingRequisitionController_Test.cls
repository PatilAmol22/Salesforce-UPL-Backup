@isTest
public class MarketingRequisitionController_Test{
    
    public static TestMethod void marketingRequisitionTest(){
        
        Id RecordTypeIdContact1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c salorg = new Sales_Org__c();
        salorg.name = 'Inddonesia';
        salorg.Sales_Org_Code__c = '6451';
        insert salorg; 
        
        
        Account accObj = new Account(
            Name = 'AKASH KRUSHI KENDRA',
            Last_Name__c = 'AKASH KRUSHI KENDRA - MANDRUP',       // Last Name
            recordtypeid=RecordTypeIdContact1,                // Mobile
            OwnersetbyProcess__c = true,                          // Owner set by Process
            /* Photograph__c = false,  
Security_cheque_scan__c = false,                      // Security cheque scan
Copy_of_PesticideSeed_License__c = false,             // Copy of Pesticide / Seed License
GST_Certificate__c = false,                           // GST Certificate
CopyofPartnershipfirmcompanyHUFPro__c = false,        // Copy of Partnership firm/company/HUF/Pro
Signed_business_policy__c = false,                    // Signed business policy
One_Blank_Letter_Pad_for_address_proof_o__c = false,  // One Blank Letter Pad for address proof o
Order_Block__c = false,  */                             // Order Block
            Status__c = 'Active',                                 // Status
            Zone__c = 'Pune',   
            Sales_Org__c  =  salorg.id,                                 // Zone
            Cust_Group__c = '189',                                // Customer Group
            Territory_Code__c = '189',                            // Territory Code
            ApprovedbyRegionalManager__c = false,                 // Approved by Regional Manager
            ApprovedbyZonalHead__c = false,
            ApprovalStatus__c = 'Draft'                          // Approval Status
        );
        insert accObj;
        
        
        Crop__c crpObj = new Crop__c(
            Name = 'Alfalfa',               // Crop Name
            Active__c = true,                 // Active
            SalesOrg__c = salorg.id  // Sales Org
            // Liquidation__c = false           // Liquidation
        );
        insert crpObj;
        
        Product2 pdct = new Product2(
            Name = 'ATRAZINE 50 SC',             // Product Name
            ProductCode = '88852',                 // Product Code
            Product_Code__c = '88852',             // Product Code
            IsActive = true,
            Active_For_Liquidation__c= true,                      // Active
            Active__c = false,                     // Active
            Sales_Org__c = salorg.id,      // Sales Org
            Combination_Key__c = '8885210002010',  // Combination Key
            Popular__c = false,                    // Popular
            // Brand Type
            Power_Brand__c = false,                // Power Brand
            // Multiple Of
            Indication_Type__c = 'Fungicide'      // Indication Type
        );
        insert pdct;
        
        Id RecordTypeIdContact = Schema.SObjectType.Activity_Plan__c.getRecordTypeInfosByName().get('Marketing Requisiton').getRecordTypeId();
        Activity_Plan__c ActPlnobj1 = new Activity_Plan__c(
            recordtypeid= RecordTypeIdContact,
            Activity_Type__c = 'Key Farmer Meeting (KFM)',// Activity Type
            Crop__c = crpObj.id,                    // Crop
            Start_Date__c = system.Today(),       // Start Date
            End_Date__c = system.Today() +1,         // End Date
            No_of_farmer_invited__c = 66,                   // No. of Farmers Invited
            No_of_R1_invited__c = 67,                       // No. of R1s Invited
            Location__c = 'mmm',                            // Location
            Time__c = '8:30'                               // Time
        );
        insert ActPlnobj1;
        
        Activity_Plan__c ActPlnobj = new Activity_Plan__c(
            
            Activity_Type__c = 'Key Farmer Meeting (KFM)',// Activity Type
            Crop__c = crpObj.id,  
            Marketing_Requisition__c = ActPlnobj1.id,                  // Crop
            Start_Date__c = system.Today(),       // Start Date
            End_Date__c = system.Today() +1,         // End Date
            No_of_farmer_invited__c = 66,                   // No. of Farmers Invited
            No_of_R1_invited__c = 67,                       // No. of R1s Invited
            Location__c = 'mmm',                            // Location
            Time__c = '8:30'                               // Time
        );
        insert ActPlnobj;
        
        Allocation__c allctnObj = new Allocation__c(
            Activity_Plan__c = ActPlnobj.id,// Activity Plan
            All_Percentage__c = 67.00,             // Allocation Percentage
            Product_Group__c = pdct.id  // Brand
        );
        insert allctnObj;
        
        Item_and_accomodation__c itemAcmdtnObj = new Item_and_accomodation__c(
            Activity_Plan__c = ActPlnobj.id,// Activity Plan
            Item__c = 'LAIN-LAIN',                 // Item
            Other_Item__c = 'Test',                // Other Item
            Discription__c = 'Test',               // Discription
            No_of_Unit__c = 40,                    // No. of Units
            Cost_Per_Unit__c = 400.00             // Cost Per Unit
        );
        insert itemAcmdtnObj;
        
        Liquidation__c sobj = new Liquidation__c(
            Activity_Plan__c = ActPlnobj.id,
            Distributor__c = accObj.id,// Activity Plan
            Product__c = pdct.id,        // Brand
            Liquidation_Quantity__c = 10.000,      // Liquidation Quantity
            Price__c = 10.00,                      // Distributor Price
            BALQTY__c = 10.000,                    // BAL. QTY (KG/LTR)
            NEWPOQTY__c = 10.000,                  // NEW PO QTY (KG/LTR)
            NewDistributorPrice__c = 10.00        // New Distributor Price (Kg/Ltr)
        );
        insert sobj;
        
        //String serialAll = String.valueOf(allctnObj);
        //String serialitem = String.valueOf(itemAcmdtnObj);
        //String serialLiq = String.valueOf(sobj);
        
        // Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Marketing Requisiton').getRecordTypeId();
        //Added by Nandhini
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Indonesia';
        sorg.Description__c='Indonesia';
        sorg.Sales_Org_Code__c='6410';
        insert sorg;
        SKU__c sku = new SKU__c();
        sku.Name='DOST';
        sku.SKU_Code__c='704002';
        sku.SKU_Pack__c=1.00;
        sku.SKU_UOM__c='L';
        sku.Group__c='DOST';
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pdct.Id;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='L';
        sku.Active__c=True;
        Insert sku;
        MarketingRequisitionController.Item itemList = new MarketingRequisitionController.Item(); 
        itemList.item='SOUND SYSTEM';
        itemList.description='Test';
        itemList.nou=10;
        itemList.cpu=20;
        itemList.subtotal=300;
        itemList.index=10;
        String serialitem=JSON.serialize(itemList);
        serialitem='['+serialitem+']';
        MarketingRequisitionController.Allocation allocationList = new MarketingRequisitionController.Allocation();
       allocationList.productGroupId=sku.id;
        allocationList.productGroupName='Test Product';
        allocationList.allocationPercent=20;
        String serialAll=JSON.serialize(allocationList);
        serialAll='['+serialAll+']';
        MarketingRequisitionController.Liquidation liqObj = new MarketingRequisitionController.Liquidation();
        liqObj.distributorId=accObj.Id;
        liqObj.productGroupId=sku.id;
        liqObj.qty=10;
        liqObj.price=100;
        liqObj.subtotal=100;
        String serialLiq=JSON.serialize(liqObj);
        serialLiq='['+serialLiq+']';
        
        
        
        MarketingRequisitionController markReqsitnCtlObj = new MarketingRequisitionController();  
        MarketingRequisitionController.getRecord(ActPlnobj.id);
        MarketingRequisitionController.getFormFields();
        MarketingRequisitionController.getActivities(1,10,'Start_Date__c', true,'');
        MarketingRequisitionController.saveRecord(ActPlnobj,serialAll,serialitem,serialLiq);
        MarketingRequisitionController.deleteActivityRecord(ActPlnobj.id);
        
    }
}