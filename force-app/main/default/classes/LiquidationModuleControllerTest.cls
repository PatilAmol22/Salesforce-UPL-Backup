@isTest
public class LiquidationModuleControllerTest {

    public static testMethod void method1(){
        Sales_Org__c salesOrg2= new Sales_Org__c();
        salesOrg2.Name='Chile';
        salesOrg2.Description__c='Chile';
        salesOrg2.Sales_Org_Code__c='5661';
        insert salesOrg2;
        
        SKU__c skuid = TestDataFactory.CreateSKU('6221205', salesOrg2, 'CL00566120302020-01-012020-12-31');
        Zone__c zn = new Zone__c();
        zn.Name='CL01';
        zn.ZoneCode__c='CL01';
        insert zn;
        
        Account acc = TestDataFactory.CreateAccount('1234567');
        acc.Account_Type__c = 'Sold To Party';
        update acc;
        
        Account accInsert = [SELECT id,SAP_Code__c FROM Account where SAP_Code__c = '1234567'];
        system.debug('accID::'+accInsert.ID+'::accsapcode::'+accInsert.SAP_Code__c);
        Distributor_SKU_Mapping__c distSKU = new Distributor_SKU_Mapping__c();
        distSKU.Conversion_Quantity__c = 0.1;
        distSKU.Distributor__c = accInsert.Id;
        distSKU.Distributor_Sales_Office_Code__c = '61003';
        distSKU.Distributor_Sales_Office_Name__c = 'BOD. MAL ESTADO';
        distSKU.UPL_Sales_Office_Name__c = zn.Id;
        distSKU.Distributor_SKU_Code__c = '79438';
        distSKU.Distributor_SKU_Name__c = 'MAXIM x 0.1 kg';
        distSKU.Distributor_UOM__c = 'EA';
        distSKU.SKU__c = skuid.Id;
        distSKU.Distributor_City__c='Iquique';
        distSKU.Distributor_City_Code__c='00025';
        distSKU.Unit_Price__c = 10;
        distSKU.Valid_from__c = Date.valueOf('2020-01-01');
        distSKU.Valid_To__c = Date.valueOf('2020-12-31');
        distSKU.Sales_Org__c = salesOrg2.Id;
        insert distSKU;
        system.debug('disttttID::'+distSKU.Distributor__c);
        Distributor_SKU_Mapping__c distSKU1 = [SELECT id,Name,CurrencyIsoCode,Sales_Org__c,Sales_Org__r.Sales_Org_Code__c,Valid_from__c, Valid_To__c, Conversion_Quantity__c, SKU__c, SKU_Name__c, SKUCode__c, 
                                                               Distributor_SKU_Code__c,Distributor_SKU_Name__c,Distributor_City_Code__c,Distributor_City__c,DistributorSAPCode__c,Unit_Price__c,Distributor_Sales_Office_Code__c,Distributor_Sales_Office_Name__c,UPL_Sales_Office_Name__c,UPL_Sales_Office_Code__c 
                                                               FROM Distributor_SKU_Mapping__c  limit 1];
         system.debug('disttttsapcode::'+distSKU1.DistributorSAPCode__c);
        
        String file = 'Product Code,Product Name,Branch Office Code,Branch Office Name,City Name,City Code,Quantity\n79438,MAXIM x 0.1 kg,61003,BOD. MAL ESTADO,Iquique,00025,30\n79438,MAXIM x 0.1 kg,61003,BOD. MAL ESTADO,Iquique,00025,30\n31232,CHECKMATE CM-F,61003,BOD. MAL ESTADO,Iquique,00025,30\n179438,MAXIM x 0.1 kg,61003,BOD. MAL ESTADO,Iquique,00025,30\n31232,CHECKMATE CM-F,610031,BOD. MAL ESTADO,Iquique,00025,30\n';
        String returnString = LiquidationModuleController.passFileAura(file, 'Sales', String.valueOf(acc.Id), '2020', '11', '2020-11-10');
        String returnString1 = LiquidationModuleController.passFileAura(file, 'Inventory', String.valueOf(acc.Id), '2020', '11', '2020-11-10');
        
        String returnStr = LiquidationModuleController.getDocument();
        List<SObject> returnStr1 = LiquidationModuleController.getRecords('Sw');
         List <Secondary_Sales_Data__c> ssData =  LiquidationModuleController.fetchSecondaryRecords();
        List <Inventory_POG__c> invData =  LiquidationModuleController.fetchInventoryRecords();
        Secondary_Sales_Data__c ssD = new Secondary_Sales_Data__c();
        ssD.Mapping_Unit_Price__c = 30;
        ssD.Product_Quantity__c = 10;
        insert ssD;
        String returnstr2 = LiquidationModuleController.saveSecondaryData(new List<Secondary_Sales_Data__c>{ssD});
        Inventory_POG__c invD = new Inventory_POG__c();
        invD.Stock_Quantity__c = 30;
        invD.Customer_Name__c = acc.Id;
        insert invD;
        String returnstr3 = LiquidationModuleController.saveInventoryData(new List<Inventory_POG__c>{invD});
        
    }
    public static testMethod void method2(){
        Sales_Org__c salesOrg2= new Sales_Org__c();
        salesOrg2.Name='Chile';
        salesOrg2.Description__c='Chile';
        salesOrg2.Sales_Org_Code__c='5661';
        insert salesOrg2;
        
        SKU__c skuid = TestDataFactory.CreateSKU('6221205', salesOrg2, 'CL00566120302020-01-012020-12-31');
        Zone__c zn = new Zone__c();
        zn.Name='CL01';
        zn.ZoneCode__c='CL01';
        insert zn;
        
        Account acc = TestDataFactory.CreateAccount('1234567');
        acc.Account_Type__c = 'Sold To Party';
        update acc;
        
        Account accInsert = [SELECT id,SAP_Code__c FROM Account where SAP_Code__c = '1234567'];
        system.debug('accID::'+accInsert.ID+'::accsapcode::'+accInsert.SAP_Code__c);
        Distributor_SKU_Mapping__c distSKU = new Distributor_SKU_Mapping__c();
        distSKU.Conversion_Quantity__c = 0.1;
        distSKU.Distributor__c = accInsert.Id;
        distSKU.Distributor_Sales_Office_Code__c = '61003';
        distSKU.Distributor_Sales_Office_Name__c = 'BOD. MAL ESTADO';
        distSKU.UPL_Sales_Office_Name__c = zn.Id;
        distSKU.Distributor_SKU_Code__c = '79438';
        distSKU.Distributor_SKU_Name__c = 'MAXIM x 0.1 kg';
        distSKU.Distributor_UOM__c = 'EA';
        distSKU.SKU__c = skuid.Id;
        distSKU.Unit_Price__c = 10;
        distSKU.Valid_from__c = Date.valueOf('2019-01-01');
        distSKU.Valid_To__c = Date.valueOf('2019-12-31');
        distSKU.Sales_Org__c = salesOrg2.Id;
        insert distSKU;
        system.debug('disttttID::'+distSKU.Distributor__c);
        Distributor_SKU_Mapping__c distSKU1 = [SELECT id,Name,CurrencyIsoCode,Sales_Org__c,Sales_Org__r.Sales_Org_Code__c,Valid_from__c, Valid_To__c, Conversion_Quantity__c, SKU__c, SKU_Name__c, SKUCode__c, 
                                                               Distributor_SKU_Code__c,Distributor_SKU_Name__c, DistributorSAPCode__c,Unit_Price__c,Distributor_Sales_Office_Code__c,Distributor_Sales_Office_Name__c,UPL_Sales_Office_Name__c,UPL_Sales_Office_Code__c 
                                                               FROM Distributor_SKU_Mapping__c  limit 1];
         system.debug('disttttsapcode::'+distSKU1.DistributorSAPCode__c);
        
        String file = 'Product Code,Product Name,Branch Office Code,Branch Office Name,Quantity\n79438,MAXIM x 0.1 kg,61003,BOD. MAL ESTADO,30\n79438,MAXIM x 0.1 kg,61003,BOD. MAL ESTADO,30\n31232,CHECKMATE CM-F,61003,BOD. MAL ESTADO,30\n179438,MAXIM x 0.1 kg,61003,BOD. MAL ESTADO,30\n31232,CHECKMATE CM-F,610031,BOD. MAL ESTADO,30\n';
        String returnString = LiquidationModuleController.passFileAura(file, 'Sales', String.valueOf(acc.Id), '2020', '11', '2020-11-10');
        String returnString1 = LiquidationModuleController.passFileAura(file, 'Inventory', String.valueOf(acc.Id), '2020', '11', '2020-11-10');
        
    }

}