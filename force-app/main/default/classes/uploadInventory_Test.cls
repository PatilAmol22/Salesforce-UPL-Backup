/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Test class for uploadInventory apex class
*
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Manisha Yadav   <myadava1@in.ibm.com>
* @modifiedBy     Manisha Yadav   <myadava1@in.ibm.com>
* @maintainedBy   Manisha Yadav   <myadava1@in.ibm.com>
* @version        1.0
* @created        2020-02-21
* @modified       2020-03-03
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
*                 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

@isTest
public class uploadInventory_Test {
    static testMethod void CalluploadInventory(){
          Document d = TestDataFactory.CreateDocument();
         // Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();          
          insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);          
          Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
          sorg=[SELECT Id,sales_org_code__c from sales_org__c];
          list<sales_org__c> salesorgId= [SELECT ID  FROM sales_org__c where sales_org_code__c=: sorg.sales_org_code__c];
           //SKU__c sk = TestDataFactory.CreateSKU('000000000006052179',sorg,'100000000');          
         String file='Warehouse code,SKU Code,Availibility,Comment,Availibility Date, \nBR00,6052179,Medium,Stock is there,10/13/2021, \nBR00,6052179,Low,No Stock,09/21/2021, \n BR00,6052179,Empty,No Stock,,\n';
          String file1= 'Warehouse code,SKU Code,Availibility,Comment,Availibility Date, \n BR00,6052179,Empty,No Stock,, \nBR00,6052179,Low,No Stock, \nBR00,6250357,High,Ample quantity,,\n';
          String file2='Warehouse code,SKU Code,Availibility,Comment,Availibility Date, \nBROO,000000000006052179,Medium,Stock,12/12/2020,\n';
          String file4='Warehouse code,SKU Code,Availibility,Comment,Availibility Date, \nBROO,000000000006052179,Low,Stock,12/12/2019,\n';
          String result2=uploadInventory.passFile(file1);
          Depot__c dp =new Depot__c ();
          dp.Name='BR';
          dp.Country__c='BRAZIL';
          dp.Location__c='BRAZIL';
          dp.Depot_Code__c='BROO';
          dp.SalesOrg__c=sorg.ID;
          insert dp;
          //Create SKU          
          SKU__c sk= new sku__c();
          sk.SKU_Code__c='000000000006052179';
          sk.Sales_Org__c=sorg.ID;
          sk.Combination_Key__c ='100000000';
          sk.Brand_Name__c='testBrand';
          sk.Name='TestSku';
          insert sk;
          String file3='Warehouse code,SKU Code,Availibility,Comment,Availibility Date \nbr44,6052179,Medium,Stock,,\n';          
          String result1=uploadInventory.passFile(file3);
          
          test.startTest();
          uploadInventory.getDocument();
          
           uploadInventory.errorWrapper var= new uploadInventory.errorWrapper();
           List<uploadInventory.errorWrapper> var1= new List<uploadInventory.errorWrapper>();
           System.assertEquals(null, var.recordno);
           System.assertEquals(null, var.wareHouseCode );
           System.assertEquals(null, var.SKUCode );
           System.assertEquals(null, var.avail );
           System.assertEquals(null, var.cmnt );
           System.assertEquals(null, var.availdte );
           System.assertEquals(null, var.reason );
           String result;
           result=uploadInventory.passFile(file1);           
           result=uploadInventory.passFile(file2);
           result=uploadInventory.passFile(file);
           result=uploadInventory.passFile(file4);
          Test.stopTest();
          
    }
}