@IsTest
public class Grz_PolandPOGPriceUploadTest {
    
    @IsTest
    static void testPolandPOGPriceUpload(){
        
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
        
        Id rec_type_acc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account acc1 = new Account();
        acc1.Name = 'acc1';
        acc1.Account_Type__c = 'Sold To Party';
        acc1.RecordTypeId=rec_type_acc;
        acc1.Sales_Org__c = so_indo1.Id;
        insert acc1;
        
        Id rec_type_LAP = Schema.SObjectType.Liquidation_Annual_Plan__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Liquidation_Annual_Plan__c lap = new Liquidation_Annual_Plan__c();
        lap.FIscal_Year__c = '2020-2021';
        lap.Fiscal_Start_Date__c = Date.newInstance(Integer.valueOf('2020'), 4, 1); 
        lap.Fiscal_End_Date__c =  Date.newInstance(Integer.valueOf('2021'), 3, 31); 
        lap.Distributor__c = acc1.Id;
        lap.Sales_Org__c = so_indo1.Id;
        lap.recordTypeId = rec_type_LAP;
        insert lap;
        
        Id rec_type_OI = Schema.SObjectType.Opening_Inventory2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        Opening_Inventory2__c oi = new Opening_Inventory2__c();
        oi.SKU__c = sku1.Id;
        oi.Distributor__c = acc1.Id;
        oi.Opening_Inventory__c = 3360;
        oi.Liquidation_Annual_Plan__c = lap.Id;
        oi.recordTypeId = rec_type_OI;
        insert oi;
        
        List<Grz_PolandPOGPriceUpload.OpeningInvWrapper> oiWrapList = new List<Grz_PolandPOGPriceUpload.OpeningInvWrapper>();
        Grz_PolandPOGPriceUpload.OpeningInvWrapper oiWrap = new Grz_PolandPOGPriceUpload.OpeningInvWrapper();
        oiWrap.combKey = sku1.SKU_Code__c;
        oiWrap.price = '20.5';
        oiWrap.year = '2020-2021';
        oiWrapList.add(oiWrap);
        Grz_PolandPOGPriceUpload.OpeningInvWrapper oiWrap1 = new Grz_PolandPOGPriceUpload.OpeningInvWrapper();
        oiWrap1.combKey = '000000000005160035';
        oiWrap1.price = '26.5';
        oiWrap1.year = '2020-2021';
        oiWrapList.add(oiWrap1);
        
        Grz_PolandPOGPriceUpload.OpeningInvWrapper oiWrap2 = new Grz_PolandPOGPriceUpload.OpeningInvWrapper();
        oiWrap2.combKey = '000000000005160036';
        oiWrap2.price = '0';
        oiWrap2.year = '2020-2021';
        oiWrapList.add(oiWrap2);
        
		Test.starttest();
        Grz_PolandPOGPriceUpload.getOIDetails();
        Grz_PolandPOGPriceUpload.updateOpeningInv(JSON.serialize(oiWrapList),'2020-2021');
        Grz_POGSkuPriceListController.getPOGSkuPriceList('2020-2021');
        Test.stoptest();
    }
    
}