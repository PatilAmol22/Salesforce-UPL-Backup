@isTest
public class TestGetPriceBookDataPoland {
    @testSetup static void GetData() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Price_Group_Master__c pgcode=new Price_Group_Master__c();
        pgcode.PG_Code__c='04';
        insert pgcode;
        
        
        
        Distribution_Channel__c discObj=new Distribution_Channel__c();
        discObj.Name='20';
        discObj.Description__c='xyz';
        discObj.Distribution_Channel_Code__c='20';
        insert discObj;
        
        Division__c divObj= new Division__c();
        divObj.Name='Abc';
        divObj.Description__c = 'xyz';
        divObj.Division_Code__c= '10';
        insert divObj;
        
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesorg.Name='Poland';
        salesorg.Description__c='Poland';
        salesorg.Sales_Org_Code__c='2941'; 
        insert salesorg;
        
        
        
        Order_Type__c orderTypeObj = new Order_Type__c(
            Name = 'ZORD',                  // Order Type Name
            Description__c = 'Credit',        // Description
            Order_Type_Code__c = 'ZORD',      // Order Type Code
            SalesOrg__c = salesorg.Id  // Sales Org
        );
        insert orderTypeObj;
        
        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='TEST';
        pro.Sales_Org__c=salesOrg.Id;
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        insert pro;
        
        
        
        Order_Type__c ordObj = new Order_Type__c();
        ordObj.Name='ZORD';
        ordObj.Description__c='abc';
        ordObj.Division__c=divObj.Id;
        ordObj.Order_Type_Code__c='ZORD';
        insert ordObj;
        
        
        
        Depot__c depObj=new Depot__c();
        depObj.Name='PD01';
        depObj.Country__c='Poland';
        depObj.Location__c='PD01';
        depObj.Depot_Code__c='PD01';
        depObj.Active__c=true;
        depObj.SalesOrg__c=salesorg.Id;
        
        insert depObj;
        
        SKU__c skuObj=new SKU__c();
        skuObj.Name='TEST';
        skuObj.SKU_Description__c='TEST';
        skuObj.Active__c=true;
        skuObj.Brand_Name__c='brdskuname';
        skuObj.SKU_Pack__c=1.00;
        skuObj.Division__c=divObj.Id;
        skuObj.Group__c='SAATHI';
        skuObj.GST__c=18;
        skuObj.Pack_Size__c=10;
        skuObj.Product_Name__c=pro.Id;
        skuObj.Sales_Org__c=salesOrg.Id;
        skuObj.SKU_Code__c='52';
        skuObj.UOM__c='KG';
        skuObj.Logistic_Discount__c=10;
        skuObj.Multiple_Of__c=10;
        skuObj.Distribution_Channel__c=discObj.id;
        
        skuObj.Combination_Key__c='Cooooooo000011111';
        insert skuObj;
        
        
        Account acnt= new Account();
        acnt.Name = 'TEST ACCOUNT';
        acnt.Email__c='testmail@gmail.com';
        acnt.BillingCity ='Poland';
        acnt.BillingCountry='Poland';
        acnt.RecordTypeId=devRecordTypeId;
        acnt.Mobile__c='1111111111';
        acnt.Phone='020256580';
        acnt.Sales_Org__c=salesOrg.Id;
        acnt.SAP_Code__c='SAP123456';
        acnt.Depot_Code__c=depObj.Id;
        acnt.Distribution_Channel__c=discObj.Id;
        acnt.Division__c=divObj.Id;
        acnt.PriceGroupCode__c=pgcode.id;
        insert acnt;
        PriceBookMaster__c PbMaster = new PriceBookMaster__c();
        PbMaster.SKUCode__c = skuObj.id;
        
        PbMaster.DepotCode__c =depObj.id;         
        PbMaster.Price__c = 30; 
        PbMaster.MaxPrice__c=50;
        PbMaster.PG_CODE__c =pgcode.Id;  
        PbMaster.UOM__c = 'NOS';                          
        PbMaster.StartDate__c = system.today()-1;
        PbMaster.EndDate__c = system.today()+1;
        PbMaster.Active__c = true;                      
        PbMaster.PerUnit__c = 1;                       
        PbMaster.Batch__c ='test'; 
        PbMaster.CurrencyIsoCode='MXN'; 
        PbMaster.Division__c= divObj.ID;
        PbMaster.CompositeKey__c='c1';
        PbMaster.DistributorCustomerCode__c=acnt.id;
        insert PbMaster; 
        
    }
    static testMethod void testMethod1(){
        ID acId=[Select id from Account].id;
        test.startTest();
        List<GetPriceBookDataPoland.pricebookMasterAndDiscountWrapper> wrapperList = GetPriceBookDataPoland.getPriceBookData(acId);
        test.stopTest();
    }
    
}