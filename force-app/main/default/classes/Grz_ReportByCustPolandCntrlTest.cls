@isTest
public class Grz_ReportByCustPolandCntrlTest {
    public static testMethod void method1() {
        Sales_Org__c so_indo1 = new Sales_Org__c();
        so_indo1.Name='Poland';
        so_indo1.Sales_Org_Code__c='2941';
        insert so_indo1;
        
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
        Grz_ReportByCustPolandCntrl.getPickListValuesIntoList('Quarter 1',year,test);
        Grz_ReportByCustPolandCntrl.getDonData(year,'Quarter 1',test,test);
    }
    
     public static testMethod void method2() {
         Date dt = System.today();
        String year = String.valueof(dt.Year()); 
        list<string> test = new list<string>();
         test.add('test1');
        Grz_ReportByCustPolandCntrl.getPickListValuesIntoList('Quarter 1',year,test);
    }
    
   
}