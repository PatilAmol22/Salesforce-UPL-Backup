@isTest
public class SOChileComp_ControllerTest {
    @testSetup
    static void allTheDataForThisTestClass() {
       Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Chile';
        sorg.Description__c='Chile';
        sorg.Sales_Org_Code__c='5661';
        insert sorg;
        Id devRecordAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account accObj1 = new Account(
            Name = 'BAM',                              // Account Name
            RecordTypeId = devRecordAcc,                                        // Account Record Type
            Last_Name__c = 'SAR123',                                         // Last Name
            SAP_Code__c = '0001023234',                                        // SAP Customer Code
            Mobile__c = '0876543219',				                           // Mobile
            Order_Block__c = false,                                            // Order Block
            Tax_Number_1__c = '8600589793',                                    // Tax Number 1
            Account_Type__c = 'Sold To Party',                                 // Account Type
            Incoterms_Part_2__c = 'FREIGHT PAID BY UPL',                       // Incoterms (Part 2)
            // LanguageKey__c = 'EN',                                             // Language Key
            Billing_Street_1__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTA',          // Billing Street 1
            Billing_Street_2__c = 'KM. 1.5 AUTOPISTA MEDELLIN COSTADO NORTE',  // Billing Street 2
            Billing_Street_3__c = 'BODEGA NoCENTRO EMPRESARIAL SAN BERNARDO',  // Billing Street 3
            // CountryKey__c = 'IN',                                              // Country Key
            Sales_Org__c = sorg.Id                                 // Sales Org
            //   ShippingConditions__c = '01'            PriceGroupCode__c =priceGroupMasterObj.Id							// Tax classification for customer
        );
        insert accObj1;
    }
	static testMethod void method1(){
        List<Account> accList = [SELECT id,Sales_Org_Code__c FROM Account LIMIT 1];
        PageReference pageRef2 = Page.SOChileComp_VF;
        Test.setCurrentPage(pageRef2);
        ApexPages.CurrentPage().getParameters().put('recordId',accList[0].id);
        ApexPages.Standardsetcontroller sc2 = new ApexPages.Standardsetcontroller(accList);
        SOChileComp_Controller ordmanage2 = new SOChileComp_Controller(sc2);
    }
}