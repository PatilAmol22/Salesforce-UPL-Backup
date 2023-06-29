@isTest
public class SPCampaignFileUploadRestAPITest {
@testSetup
    static void allTheDataForThisTestClass() {
        
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesorg.Name='Italy';
        salesorg.Description__c='Italy';
        salesorg.Sales_Org_Code__c='2410';
        insert salesorg;
        
       
        SKU__c skuObj=new SKU__c();
        skuObj.Name='SAATHI';
        skuObj.SKU_Description__c='Saathi';
        skuObj.Active__c=true;
        skuObj.Sales_Org__c=salesOrg.Id;
        skuObj.UOM__c='L';
        skuObj.SKU_Code__c='000000000005040036';
        insert skuObj;
        
        SKU__c skuObj2=new SKU__c();
        skuObj2.Name='SAATHI';
        skuObj2.SKU_Description__c='Saathi';
        skuObj2.Active__c=true;
        skuObj2.Sales_Org__c=salesOrg.Id;
        skuObj2.UOM__c='KG';
        skuObj2.SKU_Code__c='000000000006280030';
        insert skuObj2;
        
        
        Distribution_Channel__c discObj=new Distribution_Channel__c();
        discObj.Name='10';
        discObj.Description__c='xyz';
        discObj.Distribution_Channel_Code__c='67';
        insert discObj;
            
        PriceBookMaster__c pbmObj2= new PriceBookMaster__c();
        pbmObj2.SKUCode__c=skuObj.Id;
        pbmObj2.Sales_Org__c=salesOrg.Id;
        pbmObj2.StartDate__c = system.today();
        pbmObj2.EndDate__c = system.today()+1;
        pbmObj2.Active__c=true;
        pbmObj2.CurrencyIsoCode='EUR';
        pbmObj2.CompositeKey__c='IT0057109567100000000000005040036';//'2019-05-01IT0057109567100000000000005040036';
        pbmObj2.DistributionChannel__c=discObj.Id;
        insert pbmObj2;
        
        PriceBookMaster__c pbmObj3= new PriceBookMaster__c();
        pbmObj3.SKUCode__c=skuObj2.Id;
        pbmObj3.Sales_Org__c=salesOrg.Id;
        pbmObj3.StartDate__c = system.today();
        pbmObj3.EndDate__c = system.today()+1;
        pbmObj3.Active__c=true;
        pbmObj3.CurrencyIsoCode='EUR';
        pbmObj3.CompositeKey__c='2019-05-01IT0057106710000000000006280030';
        pbmObj3.DistributionChannel__c=discObj.Id;
        insert pbmObj3;
        
        Date startDate=system.today() ;
        Date endDate=startDate.addDays(15);
        Spain_Portugal_Campaign__c spCampObj=new Spain_Portugal_Campaign__c();
        spCampObj.Name='Campaign Test';
        spCampObj.Start_Date__c=startDate;
        spCampObj.End_Date__c=endDate;
        spCampObj.Status__c='Active';
        spCampObj.Description__c='test';
        insert spCampObj;
        
        
        //2520,70,10,SW06,EUR,6052441,BT,6.00,2,0,2020-04-01,2021-03-31
        
        
        Sales_Org__c salesOrg2= new Sales_Org__c();
        salesOrg2.Name='Portugal';
        salesOrg2.Description__c='Portugal';
        salesOrg2.Sales_Org_Code__c='2520';
        insert salesOrg2;
        
       
        SKU__c skuObj3=new SKU__c();
        skuObj3.Name='SAATHI';
        skuObj3.SKU_Description__c='Saathi';
        skuObj3.Active__c=true;
        skuObj3.Sales_Org__c=salesOrg2.Id;
        skuObj3.UOM__c='L';
        skuObj3.SKU_Code__c='000000000005040036';
        insert skuObj3;
        
        PricebookDiscount__c pbmObj4= new PricebookDiscount__c();
        pbmObj4.SKUCode__c=skuObj3.Id;
        pbmObj4.Sales_Org__c=salesOrg2.Id;
        pbmObj4.StartDate__c = system.today();
        pbmObj4.EndDate__c = system.today()+1;
        pbmObj4.Active__c=true;
        pbmObj4.CurrencyIsoCode='EUR';
        pbmObj4.CompositeKey__c='2019-05-01SW06252070100000000000005040036';
        pbmObj4.DistributionChannel__c=discObj.Id;
        pbmObj4.Spain_Portugal_Campaign__c=spCampObj.Id;
        insert pbmObj4;
    }
    
    public static testMethod void method(){
        
        String body = 'Sales Org Code,Distribution Channel,Division,Depot Code,Campaign Id,SKU Code,Campaign Discount (%)\r\n';
        body+='2510,67,10,SW06,C0001,6001002,5.4\r\n';
        SPCampaignFileUploadRestAPI.processData(Blob.valueOf(body),'Campaign Pricebook');
        SPCampaignFileUploadRestAPI.sendEmail(body, body, 10, 10);
    }
}