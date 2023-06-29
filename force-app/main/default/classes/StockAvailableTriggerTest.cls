@isTest
public class StockAvailableTriggerTest {
    static testMethod void initMethod(){
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesOrg.Name='Italy';
        salesOrg.Description__c='Italy';
        salesOrg.Sales_Org_Code__c='2410';
        insert salesOrg;
        
        Distribution_Channel__c discObj=new Distribution_Channel__c();
        discObj.Name='20';
        discObj.Distribution_Channel_Code__c='20';
        insert discObj;
        
        Division__c divObj=new Division__c();
        divObj.Name='10';
        divObj.Division_Code__c='10';
        insert divObj;
        
        SKU__c skuObj=new SKU__c();
        skuObj.Name='MANCOZEB';
        skuObj.SKU_Description__c='MANCOZEB';
        skuObj.Active__c=true;
        skuObj.Sales_Org__c=salesOrg.Id;
        skuObj.Distribution_Channel__c=discObj.Id;
        skuObj.Division__c=divObj.Id;
        skuObj.UOM__c='L';
        skuObj.SKU_Code__c='000000000006000390';
        skuObj.Combination_Key__c='24102010000000000006000390';
        insert skuObj;
        
        Depot__c depotObj=new Depot__c();
        depotObj.SalesOrg__c=salesOrg.id;
        depotObj.Depot_Code__c='IT00';
        insert depotObj;
        
        Depot__c depotObj2=new Depot__c();
        depotObj2.SalesOrg__c=salesOrg.id;
        depotObj2.Depot_Code__c='FR11';
        insert depotObj2;
        
        Stock_Requirement__c stRObj=new Stock_Requirement__c();
        stRObj.SKU__c=skuObj.id;
        stRObj.Depot__c=depotObj.id;
        stRObj.Unrestricted_Stock__c=100;
        stRObj.Sales_Order_Stock__c=50;
        stRObj.Delivery_Stock__c =20;
        insert stRObj;
        
        Stock_Requirement__c stRObj2=new Stock_Requirement__c();
        stRObj2.SKU__c=skuObj.id;
        stRObj2.Depot__c=depotObj2.id;
        stRObj2.Unrestricted_Stock__c=120;
        stRObj2.Sales_Order_Stock__c=50;
        stRObj2.Delivery_Stock__c =20;
        insert stRObj2;
        
    }
    static testMethod void initMethod2(){
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesOrg.Name='Italy';
        salesOrg.Description__c='Italy';
        salesOrg.Sales_Org_Code__c='2410';
        insert salesOrg;
        
        Distribution_Channel__c discObj=new Distribution_Channel__c();
        discObj.Name='20';
        discObj.Distribution_Channel_Code__c='20';
        insert discObj;
        
        Division__c divObj=new Division__c();
        divObj.Name='10';
        divObj.Division_Code__c='10';
        insert divObj;
        
        SKU__c skuObj=new SKU__c();
        skuObj.Name='MANCOZEB';
        skuObj.SKU_Description__c='MANCOZEB';
        skuObj.Active__c=true;
        skuObj.Sales_Org__c=salesOrg.Id;
        skuObj.Distribution_Channel__c=discObj.Id;
        skuObj.Division__c=divObj.Id;
        skuObj.UOM__c='L';
        skuObj.SKU_Code__c='000000000006000390';
        skuObj.Combination_Key__c='24102010000000000006000390';
        insert skuObj;
        
        Depot__c depotObj=new Depot__c();
        depotObj.SalesOrg__c=salesOrg.id;
        depotObj.Depot_Code__c='IT00';
        insert depotObj;
        
        Depot__c depotObj2=new Depot__c();
        depotObj2.SalesOrg__c=salesOrg.id;
        depotObj2.Depot_Code__c='FR11';
        insert depotObj2;
        
        Stock_Requirement__c stRObj=new Stock_Requirement__c();
        stRObj.SKU__c=skuObj.id;
        stRObj.Depot__c=depotObj.id;
        stRObj.Unrestricted_Stock__c=100;
        stRObj.Sales_Order_Stock__c=50;
        stRObj.Delivery_Stock__c =20;
        insert stRObj;
        
        Stock_Requirement__c stRObj2=new Stock_Requirement__c();
        stRObj2.SKU__c=skuObj.id;
        stRObj2.Depot__c=depotObj2.id;
        stRObj2.Unrestricted_Stock__c=120;
        stRObj2.Sales_Order_Stock__c=50;
        stRObj2.Delivery_Stock__c =20;
        insert stRObj2;
                
        delete stRObj;
        delete stRObj2;
        
    }
}