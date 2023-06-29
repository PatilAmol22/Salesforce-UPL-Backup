@isTest 
public class SettlementRequisitionController_test{
    
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
One_Blank_Letter_Pad_for_address_proof_o__c = false,*/  // One Blank Letter Pad for address proof o
            Order_Block__c = false,                               // Order Block
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
            //Liquidation__c = false           // Liquidation
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
        
        Id RecordTypeIdContact2 = Schema.SObjectType.Activity_Plan__c.getRecordTypeInfosByName().get('Settlement').getRecordTypeId();
        
        Activity_Plan__c ActPlnobj1 = new Activity_Plan__c(
            recordtypeid = RecordTypeIdContact ,
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
            recordtypeid = RecordTypeIdContact2,
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
        
        Item_and_accomodation__c itemAcmdtnObj1 = new Item_and_accomodation__c(
            Activity_Plan__c = ActPlnobj1.id,// Activity Plan
            Item__c = 'SOUND SYSTEM',                 // Item
            //Other_Item__c = 'Test',                // Other Item
            Discription__c = 'Test',               // Discription
            No_of_Unit__c = 40,                    // No. of Units
            Cost_Per_Unit__c = 400.00             // Cost Per Unit
        );
        insert itemAcmdtnObj1;
        
        Item_and_accomodation__c itemAcmdtnObj = new Item_and_accomodation__c(
            Activity_Plan__c = ActPlnobj.id,// Activity Plan
            Item__c = 'SOUND SYSTEM',                 // Item
            //Other_Item__c = 'Test',                // Other Item
            Discription__c = 'Test',               // Discription
            No_of_Unit__c = 40,                    // No. of Units
            Cost_Per_Unit__c = 400.00             // Cost Per Unit
        );
        insert itemAcmdtnObj;
        
        Liquidation__c sobj1 = new Liquidation__c(
            Activity_Plan__c = ActPlnobj1.id,
            Distributor__c = accObj.id,// Activity Plan
            Product__c = pdct.id,        // Brand
            Liquidation_Quantity__c = 10.000,      // Liquidation Quantity
            Price__c = 10.00,                      // Distributor Price
            BALQTY__c = 10.000,                    // BAL. QTY (KG/LTR)
            NEWPOQTY__c = 10.000,                  // NEW PO QTY (KG/LTR)
            NewDistributorPrice__c = 10.00
            // New Distributor Price (Kg/Ltr)
        );
        insert sobj1;
        
        Liquidation__c sobj = new Liquidation__c(
            Activity_Plan__c = ActPlnobj.id,
            Distributor__c = accObj.id,// Activity Plan
            Product__c = pdct.id,        // Brand
            Liquidation_Quantity__c = 10.000,      // Liquidation Quantity
            Price__c = 10.00,                      // Distributor Price
            BALQTY__c = 10.000,                    // BAL. QTY (KG/LTR)
            NEWPOQTY__c = 10.000,                  // NEW PO QTY (KG/LTR)
            NewDistributorPrice__c = 10.00
            // New Distributor Price (Kg/Ltr)
        );
        insert sobj;
        SettlementRequisitionController.RecordData recordInfo = new SettlementRequisitionController.RecordData(); 
        SettlementRequisitionController markReqsitnCtlObj = new SettlementRequisitionController(); 
        //Added By Nandhini-APPS-5426-Start
        SettlementRequisitionController.Item itemList = new SettlementRequisitionController.Item(); 
        itemList.item='SOUND SYSTEM';
        itemList.description='Test';
        itemList.nou=10;
        itemList.cpu=20;
        itemList.subtotal=300;
        itemList.index=10;
        String serialitem=JSON.serialize(itemList);
        serialitem='['+serialitem+']';
        /*SettlementRequisitionController.Allocation allocationList = new SettlementRequisitionController.Allocation();
allocationList.productGroupId=pdct.id;
allocationList.productGroupName='Test Product';
allocationList.allocationPercent=20;*/
        SettlementRequisitionController.Liquidation liqObj = new SettlementRequisitionController.Liquidation();
        liqObj.distributorId=accObj.Id;
        liqObj.productGroupId=pdct.id;
        liqObj.qty=10;
        liqObj.price=100;
        liqObj.subtotal=1000;
        liqObj.balQty=20;
        liqObj.newPOQty=10;
        liqObj.newDistPrice=10;
        liqObj.subtotalR1=10;
        String serialLiq=JSON.serialize(liqObj);
        serialLiq='['+serialLiq+']';
        //Added By Nandhini-APPS-5426-End
        SettlementRequisitionController.getRecord(ActPlnobj.id);
        SettlementRequisitionController.getFormFields();
        SettlementRequisitionController.getActivities(1,10,'Start_Date__c', true,'');
        SettlementRequisitionController.getTime();
        SettlementRequisitionController.saveRecord(ActPlnobj,serialitem,serialLiq);//Added By Nandhini-APPS-5426
        SettlementRequisitionController.deleteActivityRecord(ActPlnobj.id);
    }
}