@isTest
public class UpdatePricebookDiscountControllerTest {

    private static testMethod void checkMethod() {
    	Test.startTest();
        Date todaySDate=Date.today();
        Date todaySAdditonalDate=todaySDate.addDays(15);
        
        Spain_Portugal_Campaign__c spCampaignObj=new Spain_Portugal_Campaign__c();
        spCampaignObj.Name='Campaign 1';
        spCampaignObj.Start_Date__c=todaySDate;
        spCampaignObj.End_Date__c=todaySAdditonalDate;
        spCampaignObj.Status__c='Active';
        spCampaignObj.CurrencyIsoCode='EUR';
        spCampaignObj.Description__c='Test Campaign';
        insert spCampaignObj;
        
        List<String> listCampaign=new List<String>();
        listCampaign.add(spCampaignObj.Id);
        
        Depot__c dp =new Depot__c ();
        dp.Name='Pune';
        dp.Country__c='India';
        dp.Location__c='Pune';
        dp.Depot_Code__c='PUN1';
        insert dp;
        
        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        insert Pro;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Spain';
        sorg.Description__c='Spain';
        sorg.Sales_Org_Code__c='2510';
        insert sorg;
        
        Distribution_Channel__c disbj = new Distribution_Channel__c();
        disbj.Name = '67';                      
        disbj.Distribution_Channel_Code__c = '67';  
        disbj.Description__c='test';
        insert disbj;
        
        Division__c Divbj = new Division__c();
        Divbj.Name = '10';         
        Divbj.Description__c = null;    
        Divbj.Division_Code__c = '10'; 
        insert Divbj;
        
        SKU__c sku = new SKU__c();
        sku.Name='DOST';
        sku.SKU_Code__c='6001002';
        sku.SKU_Pack__c=1.00;
        sku.SKU_UOM__c='L';
        sku.Group__c='DOST';
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='L';
        sku.Active__c=True;
        sku.GST__c=18;
        sku.Combination_Key__c='Cooooooo000011111';
        insert sku;
        
        PricebookDiscount__c pbObj=new PricebookDiscount__c();
        pbObj.Spain_Portugal_Campaign__c=spCampaignObj.Id;
        pbObj.SKUCode__c=sku.Id;
        pbObj.DistributionChannel__c=disbj.Id;
        pbObj.Division__c=Divbj.Id;
        pbObj.CompositeKey__c=todaySDate+spCampaignObj.Campaign_Id__c+'25106710000000000006001002';
        insert pbObj;
        
        UpdatePricebookDiscountController.updateStartEndDate(listCampaign);

        Test.stopTest();

    }
}