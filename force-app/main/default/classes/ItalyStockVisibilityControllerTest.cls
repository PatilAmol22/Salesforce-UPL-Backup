@isTest
public class ItalyStockVisibilityControllerTest {

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
    }
    static testmethod void testFetchRecordTypes() {
       
        String salesOrgCode='2410';
        String distributionChannelCode='20';
        String divisionCode='10';
        decimal pageNumber=2;
        Integer recordToDisply=10;
        String productSearch='5040086';
        String productIdentification='productCode';
        ItalyStockVisibilityController.getActivities(salesOrgCode,distributionChannelCode,divisionCode,pageNumber ,recordToDisply, productSearch,productIdentification);
        
        String salesOrgCode2='2410';
        String distributionChannelCode2='20';
        String divisionCode2='10';
        decimal pageNumber2=2;
        Integer recordToDisply2=10;
        String productSearch2='ELICIO';
        String productIdentification2='productName';
        ItalyStockVisibilityController.getActivities(salesOrgCode2,distributionChannelCode2,divisionCode2,pageNumber2,recordToDisply2,productSearch2,productIdentification2);
        
        
        String salesOrgCode3='2410';
        String distributionChannelCode3='20';
        String divisionCode3='10';
        decimal pageNumber3=2;
        Integer recordToDisply3=10;
        ItalyStockVisibilityController.getActivities(salesOrgCode3,distributionChannelCode3,divisionCode3,pageNumber3,recordToDisply3,'','');
        
        
       
        //String csvStr='[{"salesOrgCode":"2410","distributionChannel":"20","Division":"60","skuCode":"5040086","ReferenceQuantity":"20.4","RestrictChange":"TRUE","inventoryFlag":"Green","inventoryDescription":"Test new"},{"salesOrgCode":"2410","distributionChannel":"20","Division":"60","skuCode":"6301627","ReferenceQuantity":"20.4","RestrictChange":"TRUE","inventoryFlag":"Green","inventoryDescription":"Test new"}]';
        //String strfromCSV='SalesOrgCode,DistributionChannel,Division,SKUCode,ReferenceQuantity,RestrictChange,Inventoryflag,InventoryDescription\r\n';
        //strfromCSV+='2410,20,10,5040086,20,true,Green,test\r\n';
        //strfromCSV+='2410,20,10,5040086,20,true,Green,test\r\n';
        String csvStr='[{"salesOrgCode":"2410","distributionChannel":"20","Division":"60","skuCode":"5040086","ReferenceQuantity":"20.4","RestrictChange":"TRUE","inventoryFlag":"Green","inventoryDescription":"Test new"}]';
        List<SKU__c> listSKU=[Select id,name, SKU_Code__c, Combination_Key__c from SKU__c];
        ItalyStockVisibilityController.updateCSVData(csvStr);
        
        ItalyStockVisibilityController.sendEmail(csvStr, csvStr, 1, 1, 'SKUUploadFile');
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
        ItalyStockVisibilityController.updateSKUItem(skuObj);
        ItalyStockVisibilityController.getSkuListItem(skuObj.Id);
        
        
    }

}