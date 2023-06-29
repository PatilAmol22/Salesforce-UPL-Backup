/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Test class for searchInventory apex class
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
*/@isTest
public class searchInventory_Test {
    static testMethod void CallsearchInventory(){
    searchInventory SI= new searchInventory();
    insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
          Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
          sorg=[SELECT Id,sales_org_code__c from sales_org__c];
          list<sales_org__c> salesorgId= [SELECT ID  FROM sales_org__c where sales_org_code__c=: sorg.sales_org_code__c];
          //Create SKU          
          SKU__c sk= new sku__c();
          sk.SKU_Code__c='000000000006052179';
          sk.Sales_Org__c=sorg.ID;
          sk.Combination_Key__c ='100000000';
          sk.Brand_Name__c='testBrand';
          sk.Name='TestSku';
          insert sk;
          sk=[SELECT ID,SKU_Code__c,Sales_Org__c,Combination_Key__c ,Brand_Name__c, Name from sku__c];
          
          //Create Depot/Warehouse
          Depot__c dp =new Depot__c ();
          dp.Name='BR';
          dp.Country__c='BRAZIL';
          dp.Location__c='BRAZIL';
          dp.Depot_Code__c='BROO';
          dp.SalesOrg__c=sorg.ID;
          insert dp;
          dp=[SELECT Id,Name,Country__c,location__c,depot_code__c,salesorg__c from depot__c];
          
          String dpId=dp.id;
          String skuId=sk.Id;
          String BR;
          String MAT;
          String avail='Low';
          String availdte='2020-12-02';
          String cmnt='Test';
          searchInventory.inventoryDetailsWrapper var= new searchInventory.inventoryDetailsWrapper ();            
          searchInventory.retinventoryDetailsWrapper  var1= new searchInventory.retinventoryDetailsWrapper();
          List<string> str=new List<string>();
          List<searchInventory.retinventoryDetailsWrapper>  Listvar= new List<searchInventory.retinventoryDetailsWrapper>();
        
        Test.startTest();       
           System.assertEquals(null, var1.inventData );
           System.assertEquals(null, var1.avails);
           System.assertEquals(null, var1.writeAccess );
           var1=searchInventory.getInventoryData(dpId,skuId,skuId);           
           var1=searchInventory.getInventoryData(dpId,BR,skuId);                      
           var1=searchInventory.getInventoryData(dpId,BR,MAT);                      
           var1=searchInventory.getInventoryData(dpId,skuId,MAT);
           System.assertEquals(null, var.brandName );
           System.assertEquals(null, var.SKU);
           System.assertEquals(null, var.avail);
           System.assertEquals(null, var.availDate);
           System.assertEquals(null, var.comment);
           System.assertEquals(null, var.Id);
           System.assertEquals(null, var.SKUCode);
           System.assertEquals(null, var.TSKUCode);
           System.assertEquals(null, var.warehouse);
           System.assertEquals(null, var.avails);
           //list<sales_org__c> salesorgId=new list<sales_org__c>();
           salesorgId=searchInventory.getOrgDetails();
           list<depot__c> dept=searchInventory.getWH();
           List<SKu__c> s=searchInventory.getbrand();
           s=searchInventory.getMats();
           s=searchInventory.getMaterials(sk.id);
           //str=searchInventory.getPickListValuesIntoList();
           Id id;
           string str1=searchInventory.upsertAvailabilityDetails(dp.id,sk.sku_code__c,avail,id,availdte,cmnt);//(dp.id,sk.sku_code__c,avail,id);
           dp.Depot_Code__c='BRO1';           
           update dp;
           str1=searchInventory.upsertAvailabilityDateDetails(dp.id,sk.sku_code__c,avail,id,availdte,cmnt);//(dp.id,sk.sku_code__c,availdte,id); 
           dp.Depot_Code__c='BRO2';           
           update dp;          
           str1=searchInventory.upsertCommentDetails(dp.id,sk.sku_code__c,avail,id,availdte,cmnt);//(dp.id,sk.sku_code__c,cmnt,id);
           
         List<inventory__c>  newinvnt=[SELECT depot__c,Availability__c,SKU_Depot__c,sku__c,Sales_Org__c from Inventory__c];
          dp.Depot_Code__c='BRO3';           
           update dp;
           string str2=searchInventory.upsertAvailabilityDetails(dp.id,sk.sku_code__c,avail,newinvnt[0].id,availdte,cmnt);//(dp.id,sk.sku_code__c,avail,newinvnt[0].id);
          inventory__c i= new inventory__c();
           i.SKU_Depot__c='5191'+'BR00'+'000000000006052179';
           i.depot__c=dp.id;
           i.sku__c=sk.id;
           i.Sales_Org__c =sorg.id;
           insert i;
           //str=searchInventory.getPickListValuesIntoList();         
           var1=searchInventory.getInventoryData(dpId,skuId,skuId);           
           var1=searchInventory.getInventoryData(dpId,BR,skuId);                      
           var1=searchInventory.getInventoryData(dpId,BR,MAT);                      
           var1=searchInventory.getInventoryData(dpId,skuId,MAT);
          Test.stopTest();
          
    }
     
 
}