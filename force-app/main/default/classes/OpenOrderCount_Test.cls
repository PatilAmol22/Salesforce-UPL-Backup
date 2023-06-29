@isTest(SeeAllData=true) 
public class OpenOrderCount_Test {
    static testMethod void test(){
        Sales_Org__c salesOrgObj = new Sales_Org__c(
            Name = 'Japan',           // Sales Org Name
            Company_Code__c = '6730',      // Company Code
            Sales_Org_Code__c = '6731'   // Sales Org Code
            
        );
        insert salesOrgObj;
        
        Division__c DivisionObj = new Division__c(
            Name = 'Agro Formulation',// Division Name
            Division_Code__c = '500'    // Division Code
        );
        insert DivisionObj;
        
        Distribution_Channel__c DistributionChannelObj = new Distribution_Channel__c(
            Name = '20',                        // Distribution Channel Name
            Distribution_Channel_Code__c = '450',  // Distribution Channel Code
            Description__c='test'
        );
        insert DistributionChannelObj;       
        
        Id recordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Id devRecordAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account accObj1 = new Account(
            Name = 'SAR123',                                                            // Account Name
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'SAR123',                                         // Last Name
            SAP_Code__c = '0001023234',                                        // SAP Customer Code
            Mobile__c = '0876543219',                                          // Mobile           
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            Sales_Org__c = salesOrgObj.Id,                                  // Sales Org
            Division__c = divisionObj.Id,                                   // Division Name
            Distribution_Channel__c = DistributionChannelObj.Id                       // Distribution Channel                                                                 
        );
        
        Contact c1=new Contact();
        c1.FirstName='test';
        c1.LastName='test';
		c1.AccountId=accObj1.Id;        
        insert c1;
        
        Id devRecordTypeId = Schema.SObjectType.Sales_Order__c.getRecordTypeInfosByName().get('Sales Order').getRecordTypeId();
        Sales_Order__c SalesOrderObj = new Sales_Order__c(
            RecordTypeId = devRecordTypeId,                        // Record Type
            SFDC_Order_Number__c = '87614',                      // SFDC Order Number
            // Order_Raise_By__c = 'Territory Manager',             // Order Raised By
            Order_Date__c = System.today(),            // Order Date
            //OrderSubStatus__c = 'Draft',                         // Order Sub-Status
            Sales_Org_lk__c = salesOrgObj.Id,                 // Sales Org                 
            Order_Status__c ='Completely processed',                                       
            Division_lk__c = DivisionObj.Id,                  // Division
            Distribution_Channel_lk__c = DistributionChannelObj.Id,      // Distribution Channel
            Bill_To_Party__c = accObj1.Id,                // Bill To Party
            Depot_Code__c = 'IT00',                              // Depot Code
            Sold_to_Party__c = accObj1.Id,                // Sold to Party
            Total_Amount__c=12000,        
            UGDN__c = '20011688'                            // UGDN
        );
        insert SalesOrderObj;                	            
        
        Test.startTest();
       	OpenOrderCount.getCount(); 
        Test.stopTest();
        	                                
    }
}