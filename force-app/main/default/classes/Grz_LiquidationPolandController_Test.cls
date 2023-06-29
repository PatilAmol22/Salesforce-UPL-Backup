@isTest
public class Grz_LiquidationPolandController_Test {
 @TestSetup
    static void makeData(){
        
          Liquidation_Batch_Filters__c lbf2 = new Liquidation_Batch_Filters__c();
        lbf2.Name = 'Poland';
        lbf2.Sales_Org_Filter__c = 'Sales_Org_Code__c = \'2941\'';
        lbf2.Account_Type_Filter__c ='AccountType__c = \'Sold To Party\'';
        lbf2.Distributor_Filter__c = 'test';
        lbf2.Active__c = true;
   
        insert lbf2;
        
        
        Sales_Org__c so_indo1 = new Sales_Org__c();
        so_indo1.Name='Poland';
        so_indo1.Sales_Org_Code__c='2941';
        insert so_indo1;
        
        Id rec_type_acc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account acc1 = new Account();
        acc1.Name = 'acc1';
        acc1.Account_Type__c = 'Sold To Party';
        acc1.RecordTypeId=rec_type_acc;
        acc1.Sales_Org__c = so_indo1.Id;
        insert acc1;
        
        
              
        
    }
    
    Public static testmethod void TestPogPolandController(){
        
        Account acc1 = [select id,Name from Account where Name='acc1' limit 1];
        
        Test.startTest(); 
        ApexPages.currentPage().getParameters().put('distributor', String.valueOf(acc1.Id));
        ApexPages.currentPage().getParameters().put('distributorName', String.valueOf(acc1.Name));
        ApexPages.currentPage().getParameters().put('year', String.valueOf(2020));
        ApexPages.currentPage().getParameters().put('quarter', 'Quarter 2');
        ApexPages.currentPage().getParameters().put('searchValue', 'Test');
        Grz_LiquidationPolandController.getPOGLiquidationpoland();
        Test.stopTest(); 
        
    }
    
  
    
    
    
    
    
}