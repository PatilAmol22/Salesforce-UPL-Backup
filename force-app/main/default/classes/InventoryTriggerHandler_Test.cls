@isTest
public class InventoryTriggerHandler_Test {
    
    static testMethod void inventorytest(){
        
        
        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        Insert Pro;
        
        Inventory_Control__c f2 = new Inventory_Control__c();
        f2.Quantity__c = 1000;
        f2.Fiscal_Year__c = '22/23';
        f2.Product_Name__c = pro.id;
        f2.BU__c = 'BR15';
        f2.Product__c='SPERTO';
        //f2.CombinationKey__c='BR1522/23SPERTO';
        insert f2;
        
        
        List<Inventory_Control__c> f1 = new List<Inventory_Control__c>();
        for(Inventory_Control__c i : f1){
            i.BU__c = 'BR15';
            i.Product_Name__c = Pro.id;
            i.Quantity__c = 1000;
            i.Product__c='SPERTO';
            i.Fiscal_Year__c = '22/23';
            //i.CombinationKey__c='BR1522/23SPERTO';
            
            f1.add(i);
            
        }
        if(!f1.isEmpty()) {
            insert f1;
        }
        
    }
    public static testmethod void testInventoryControlDuplicate() {
        // Create test data
        List<Inventory_Control__c> testInventory = new List<Inventory_Control__c>();
        
        // Create Inventory_Control__c records with matching product names
        Inventory_Control__c ic1 = new Inventory_Control__c();
        ic1.Product__c = 'Product A';
        ic1.Quantity__c = 10;
        ic1.Fiscal_Year__c = '2023';
          ic1.BU__c = 'BR15';
        testInventory.add(ic1);
        
        Inventory_Control__c ic2 = new Inventory_Control__c();
        ic2.Product__c = 'Product A';
        ic2.Quantity__c = 20;
        ic2.IsDeleted__c=true;
          ic2.BU__c = 'BR15';
        ic2.Fiscal_Year__c = '20/23';
        testInventory.add(ic2);
        
        // Create Inventory_Control__c record with a different product name
        Inventory_Control__c ic3 = new Inventory_Control__c();
        ic3.Product__c = 'Product A';
        ic3.Quantity__c = 15;
          ic3.BU__c = 'BR15';
        ic3.Fiscal_Year__c = '2023';
        testInventory.add(ic3);
        
        // Insert test records
        insert testInventory;
        
        // Call the method to test
        Test.startTest();
        inventoryTriggerHandler.inventorycontrolDuplicate(testInventory);
        inventoryTriggerHandler.delRecords(testInventory);
        Test.stopTest();
        
        // Retrieve updated records
        List<Inventory_Control__c> updatedInventory = [
            SELECT Id, Quantity__c
            FROM Inventory_Control__c
            WHERE Product__c = 'Product A' AND Fiscal_Year__c = '2023'
        ];
        
        // Assert the expected results
        
    } 
    
}