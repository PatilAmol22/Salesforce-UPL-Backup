@isTest
public class InventoryPOG_test {

    static testMethod void getCampaign()
    {
        InventoryPOG.getCampaign('C01');
        InventoryPOG.getCampaign('C02');
        InventoryPOG.getCampaign('C03');
        InventoryPOG.getCampaign('C04');
        InventoryPOG.getCampaign('C05');
        InventoryPOG.getCampaign('C06');
        InventoryPOG.getCampaign('C07');
        InventoryPOG.getCampaign('C08');
        InventoryPOG.getCampaign('C09');
        InventoryPOG.getCampaign('C10');
        InventoryPOG.getCampaign('C11');
        InventoryPOG.getCampaign('C12');
        InventoryPOG.getCampaign('C00');
    }
    
    static testMethod void getSKU()
    {
        SalesOrgCode__c socode = new SalesOrgCode__c();
        socode.Name = 'France';
        socode.Code__c = '2710';
        insert socode;
        Account acc = TestDataFactory.CreateAccount('0001033509');
            
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='France';
        sorg.Description__c='France';
        sorg.Sales_Org_Code__c='2710';
        insert sorg;
        SalesOrgCode__c sorg1 = new SalesOrgCode__c(Name ='France', Code__c = '2710',Inventory_Block_Days__c=10); 
		insert sorg1;
        acc.Sales_Org__c = sorg.Id;
        update acc;
        SKU__c sk = new SKU__c();
        sk.SKU_Code__c='000000000006250320';
        sk.name='Pesticides';
        sk.Product_Campaign__c='C05';
        sk.Sales_Org__c=sorg.ID;
        insert sk;
        
        SKU__c sk1 = new SKU__c();
        sk1.SKU_Code__c='000000000006250321';
        sk1.name='Pesticides';
        sk1.Product_Campaign__c='C05';
        sk1.Sales_Org__c=sorg.ID;
        insert sk1;
        
        SKU__c sk2 = new SKU__c();
        sk2.SKU_Code__c='000000000006250001';
        sk2.name='Pesticides';
        sk2.Product_Campaign__c='C05';
        sk2.Sales_Org__c=sorg.ID;
        insert sk2;
        
        
        Inventory_POG__c pog = new Inventory_POG__c();
		pog.SKU_Name__c= sk.id;
        pog.Customer_Name__c=acc.id;
        pog.Sales_Org__c=sorg.id;
        pog.Start_Date__c=date.valueOf('2020-02-01');
        pog.End_Date__c=date.valueOf('2021-01-31');
        pog.Quantity_ordered__c=0;
        pog.Quantity_Sold_Current_Campaign__c=0;
        pog.Quantity_Sold_Current_Fiscal__c=0;
        pog.Quantity_Sold_Last_Fiscal__c=0;
        insert pog;
        date dt = Date.today();
        InventoryPOG.SKUPaginationWrapper wrapper = new InventoryPOG.SKUPaginationWrapper();
        wrapper = InventoryPOG.getallSKU(String.valueOf(acc.Id), date.valueof('2020-04-03'));
        wrapper=InventoryPOG.getallSKU(String.valueOf(acc.Id), dt);
        String upsertSAFLC= InventoryPOG.upsertInventoryPOGDetailsSAFLC(String.valueOf(sk.Id), 10, 20, 30, 40, 50, String.valueOf(acc.id));
        //String upsertInventory = InventoryPOG.upsertInventoryPOGDetails(String.valueOf(sk.Id), 10, 20, 30, 40,50,String.valueOf(acc.id));
        String upsertInventory = InventoryPOG.upsertInventoryPOGDetails(String.valueOf(sk.Id),20,String.valueOf(acc.id),dt);
        InventoryPOG.upsertInventoryPOGDetails(String.valueOf(sk1.Id),20,String.valueOf(acc.id),dt);
        InventoryPOG.updateStockPendingPrev(String.valueOf(sk.Id), 10, 20,String.valueOf(acc.id));
        InventoryPOG.updateStockPendingPrev(String.valueOf(sk2.Id), 10, 20,String.valueOf(acc.id));
       
    }
   
}