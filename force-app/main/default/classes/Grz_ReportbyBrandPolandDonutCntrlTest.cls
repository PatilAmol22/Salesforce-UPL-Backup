@isTest
public class Grz_ReportbyBrandPolandDonutCntrlTest {
	  public static testMethod void method1() {
        Sales_Org__c so_indo1 = new Sales_Org__c();
        so_indo1.Name='Poland';
        so_indo1.Sales_Org_Code__c='2941';
        insert so_indo1;
          
          Id rec_type = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
          
        Account acc = new Account();
          acc.name = 'Test';
          acc.Active_for_Liquidation__c = true;
          acc.Sales_Org__c = so_indo1.id;
          acc.RecordTypeId = rec_type;
          insert acc;
          
          DistributorSalesAreaMapping__c dis = new DistributorSalesAreaMapping__c();
          //dis.Name = 'Test';
          dis.AccountType__c = 'Sold To Party';
          dis.Distributor__c = acc.id;
          insert dis;
              
       
        
        SKU__c sku1 = new SKU__c();
        sku1.Name = '6 LTR';
        sku1.SKU_Code__c = '000000000005160032';
        sku1.Brand_Name__c = 'ABACO';
        sku1.SKU_Description__c = 'SCANNER (PARAQUAT DICHLOR 276SL) 5LT....';
        sku1.Active_for_Liquidation__c =true;
        sku1.Sales_Org__c = so_indo1.Id;
        insert sku1;
        
         Date dt = System.today();
        String year = String.valueof(dt.Year()); 
        
        list<string> test = new list<string>();
        Grz_ReportbyBrandPolandDonutController.getPickListValuesIntoList('Quarter 1',year);
        Grz_ReportbyBrandPolandDonutController.getDonData(year,'Quarter 1',test);
    }
    
}