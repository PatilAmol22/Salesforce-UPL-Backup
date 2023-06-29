@isTest
public class FileUploadRESTAPITest2 {

    @testSetup
    static void allTheDataForThisTestClass() {
        
        Sales_Org__c salesOrg= new Sales_Org__c();
        salesorg.Name='Italy';
        salesorg.Description__c='Italy';
        salesorg.Sales_Org_Code__c='2410';
        insert salesorg;
        //Iberia -//Added by Nandhini CR:APPS-2521
        Sales_Org__c salesOrgIberia= new Sales_Org__c();
        salesOrgIberia.Name='Iberia & Portugal';
        salesOrgIberia.Description__c='Iberia & Portugal';
        salesOrgIberia.Sales_Org_Code__c='2510';
        insert salesOrgIberia;
        
        SKU__c skuObjIberia=new SKU__c();
        skuObjIberia.Name='Iberia SAATHI';
        skuObjIberia.SKU_Description__c='Iberia Saathi';
        skuObjIberia.Active__c=true;
        skuObjIberia.Sales_Org__c=salesOrgIberia.Id;
        skuObjIberia.UOM__c='BT';
        skuObjIberia.SKU_Code__c='000000000006052441';
        insert skuObjIberia;
         SKU__c skuObjIberia1=new SKU__c();
        skuObjIberia1.Name='Iberia SAATHI1';
        skuObjIberia1.SKU_Description__c='Iberia Saathi1';
        skuObjIberia1.Active__c=true;
        skuObjIberia1.Sales_Org__c=salesOrgIberia.Id;
        skuObjIberia1.UOM__c='L';
        skuObjIberia1.SKU_Code__c='000000000006052442';
        insert skuObjIberia1;
       
        
        //Poland-//Added by Nandhini CR:APPS-2521
        Sales_Org__c salesOrgPoland= new Sales_Org__c();
        salesOrgPoland.Name='Poland';
        salesOrgPoland.Description__c='Poland';
        salesOrgPoland.Sales_Org_Code__c='2941';
        insert salesOrgPoland;
        
        Division__c div = new Division__c();
        div.Name = '10';
        div.Description__c = '10';
        div.Division_Code__c = '10';
        insert div;
        Depot__c dep = new Depot__c(
            Name = 'PD01',   
            Country__c = 'Poland',                          
            Depot_Code__c = 'PD01',                         
            Active__c = true,                             
            SalesOrg__c = salesOrgPoland.Id                         
        );
        insert dep;
        
        SKU__c skuObjPoland=new SKU__c();
        skuObjPoland.Name='Poland SAATHI';
        skuObjPoland.SKU_Description__c='Poland Saathi';
        skuObjPoland.Active__c=true;
        skuObjPoland.Sales_Org__c=salesOrgPoland.Id;
        skuObjPoland.UOM__c='L';
        skuObjPoland.SKU_Code__c='000000000000917056';
        insert skuObjPoland;
        
        Distribution_Channel__c discObjPoland=new Distribution_Channel__c();
        discObjPoland.Name='20';
        discObjPoland.Description__c='xyz';
        discObjPoland.Distribution_Channel_Code__c='20';
        insert discObjPoland;
        //For Iberia -//Added by Nandhini CR:APPS-2521
         
        SpecialInvoiceDiscount__c sIDiscountObjIberia=new SpecialInvoiceDiscount__c();
        sIDiscountObjIberia.SKUCode__c=skuObjIberia.Id;
        sIDiscountObjIberia.DistributionChannel__c=discObjPoland.Id;
        sIDiscountObjIberia.Sales_Org__c=salesOrgIberia.Id;
        sIDiscountObjIberia.Discount__c=1;
        sIDiscountObjIberia.CompositeKey__c='2000000000000005040036';
        insert sIDiscountObjIberia;
        
        ZSP1_Discount__c zspDiscountObjIberia=new ZSP1_Discount__c();
        zspDiscountObjIberia.SKUCode__c=skuObjIberia.Id;
        zspDiscountObjIberia.DistributionChannel__c=discObjPoland.Id;
        zspDiscountObjIberia.Sales_Org__c=salesOrgIberia.Id;
        zspDiscountObjIberia.Discount__c=1;
        zspDiscountObjIberia.CompositeKey__c='2000000000000005040036';
        insert zspDiscountObjIberia;
        
        PriceBookMaster__c pbmObjIberia= new PriceBookMaster__c();
        pbmObjIberia.SKUCode__c=skuObjIberia.Id;
        pbmObjIberia.Sales_Org__c=salesOrgIberia.Id;
        pbmObjIberia.StartDate__c = system.today();
        pbmObjIberia.EndDate__c = system.today()+1;
        pbmObjIberia.Active__c=true;
        pbmObjIberia.CurrencyIsoCode='EUR';
        pbmObjIberia.CompositeKey__c='2000000000000005040036';
        pbmObjIberia.DistributionChannel__c=discObjPoland.Id;
        insert pbmObjIberia;
        //For poland-//Added by Nandhini CR:APPS-2521
        PriceBookMaster__c pbmObjPoland= new PriceBookMaster__c();
        pbmObjPoland.SKUCode__c=skuObjPoland.Id;
        pbmObjPoland.Sales_Org__c=salesOrgPoland.Id;
        pbmObjPoland.StartDate__c = system.today();
        pbmObjPoland.EndDate__c = system.today()+1;
        pbmObjPoland.Active__c=true;
        pbmObjPoland.CurrencyIsoCode='PLN';
        pbmObjPoland.CompositeKey__c='IT0057109567100000000000000917056';//'2019-05-01IT0057109567100000000000005040036';
        pbmObjPoland.DistributionChannel__c=discObjPoland.Id;
        pbmObjPoland.PAK__c=true;
        insert pbmObjPoland;
        
        SpecialInvoiceDiscount__c sIDiscountObjPoland=new SpecialInvoiceDiscount__c();
        sIDiscountObjPoland.SKUCode__c=skuObjPoland.Id;
        sIDiscountObjPoland.DistributionChannel__c=discObjPoland.Id;
        sIDiscountObjPoland.Sales_Org__c=salesOrgPoland.Id;
        sIDiscountObjPoland.Discount__c=1;
        sIDiscountObjPoland.CompositeKey__c='IT0057109567100000000000000917056';
        insert sIDiscountObjPoland;
        
        ZSP1_Discount__c zspDiscountObjPoland=new ZSP1_Discount__c();
        zspDiscountObjPoland.SKUCode__c=skuObjPoland.Id;
        zspDiscountObjPoland.DistributionChannel__c=discObjPoland.Id;
        zspDiscountObjPoland.Sales_Org__c=salesOrgPoland.Id;
        zspDiscountObjPoland.Discount__c=1;
        zspDiscountObjPoland.CompositeKey__c='IT0057109567100000000000000917056';
        insert zspDiscountObjPoland;
        
        SKU__c skuObjPoland1=new SKU__c();
        skuObjPoland1.Name='Poland SAATHI1';
        skuObjPoland1.SKU_Description__c='Poland Saathi1';
        skuObjPoland1.Active__c=true;
        skuObjPoland1.Sales_Org__c=salesOrgPoland.Id;
        skuObjPoland1.UOM__c='KG';
        skuObjPoland1.SKU_Code__c='000000000000917057';
        insert skuObjPoland1;
        
        SKU__c skuObjPoland2=new SKU__c();
        skuObjPoland2.Name='Poland SAATHI2';
        skuObjPoland2.SKU_Description__c='Poland Saathi2';
        skuObjPoland2.Active__c=true;
        skuObjPoland2.Sales_Org__c=salesOrgPoland.Id;
        skuObjPoland2.UOM__c='L';
        skuObjPoland2.SKU_Code__c='000000000006221181';
        insert skuObjPoland2;
       
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
        //Bolivia-//Added by Nandhini CR:APPS-2521
        Sales_Org__c salesOrgBolivia= new Sales_Org__c();
        salesOrgBolivia.Name='Bolivia';
        salesOrgBolivia.Description__c='Bolivia';
        salesOrgBolivia.Sales_Org_Code__c='5361';
        insert salesOrgBolivia;
        
        SKU__c skuObjBolivia=new SKU__c();
        skuObjBolivia.Name='Bolivia SAATHI';
        skuObjBolivia.SKU_Description__c='Bolivia Saathi';
        skuObjBolivia.Active__c=true;
        skuObjBolivia.Sales_Org__c=salesOrgBolivia.Id;
        skuObjBolivia.UOM__c='KG';
        skuObjBolivia.SKU_Code__c='000000000000702503';
        insert skuObjBolivia;
        
         SKU__c skuObjBolivia1=new SKU__c();
        skuObjBolivia1.Name='Bolivia SAATHI';
        skuObjBolivia1.SKU_Description__c='Bolivia Saathi';
        skuObjBolivia1.Active__c=true;
        skuObjBolivia1.Sales_Org__c=salesOrgBolivia.Id;
        skuObjBolivia1.UOM__c='L';
        skuObjBolivia1.SKU_Code__c='000000000000702502';
        insert skuObjBolivia1;
        
        PriceBookMaster__c pbmObjBOlivia= new PriceBookMaster__c();
        pbmObjBOlivia.SKUCode__c=skuObjBolivia1.Id;
        pbmObjBOlivia.Sales_Org__c=salesOrgBolivia.Id;
        pbmObjBOlivia.StartDate__c = system.today();
        pbmObjBOlivia.EndDate__c = system.today()+1;
        pbmObjBOlivia.Active__c=true;
        pbmObjBOlivia.CurrencyIsoCode='EUR';
        pbmObjBOlivia.CompositeKey__c='09567100000000000005040036';//'2019-05-01IT0057109567100000000000005040036';
        pbmObjBOlivia.DistributionChannel__c=discObjPoland.Id;
        insert pbmObjBOlivia;
        
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
                
        SpecialInvoiceDiscount__c sIDiscountObj=new SpecialInvoiceDiscount__c();
        sIDiscountObj.SKUCode__c=skuObj3.Id;
        sIDiscountObj.DistributionChannel__c=discObj.Id;
        sIDiscountObj.Sales_Org__c=salesOrg2.Id;
        sIDiscountObj.Discount__c=1;
        sIDiscountObj.CompositeKey__c='SW06252070100000000000005040036';
        insert sIDiscountObj;
        
        ZSP1_Discount__c zspDiscountObj=new ZSP1_Discount__c();
        zspDiscountObj.SKUCode__c=skuObj3.Id;
        zspDiscountObj.DistributionChannel__c=discObj.Id;
        zspDiscountObj.Sales_Org__c=salesOrg2.Id;
        zspDiscountObj.Discount__c=1;
        zspDiscountObj.CompositeKey__c='SW06252070100000000000005040036';
        insert zspDiscountObj;
        
        PriceBookMaster__c pbmObj4= new PriceBookMaster__c();
        pbmObj4.SKUCode__c=skuObj3.Id;
        pbmObj4.Sales_Org__c=salesOrg2.Id;
        pbmObj4.StartDate__c = system.today();
        pbmObj4.EndDate__c = system.today()+1;
        pbmObj4.Active__c=true;
        pbmObj4.CurrencyIsoCode='EUR';
        pbmObj4.CompositeKey__c='2019-05-01SW06252070100000000000005040036';
        pbmObj4.DistributionChannel__c=discObj.Id;
        insert pbmObj4;
    }
    
    public static testMethod void method(){
        
        String body ='Sales Org Code,Distribution Channel,Division,PG Code,SKU Code,Currency,UOM,Valid From,Valid to,Batch,Depot/ Storage Location,Material Price,Standard Rebate,Estimated Final Price,Accrual Discount\r\n';
        body+='2410,20,10,95,5040036,EUR,L,2019-05-01,2025-05-01,00,IT00,2500,15,1500,1\r\n';
        body+='2410,20,10,95,5040086,,KG,2019-05-01,2025-05-01,00,IT00,5500,,4500,1\r\n';
        body+='2410,20,10,95,5040037,EUR,L,2019-05-01,2025-05-01,00,IT00,,10,,1\r\n';
        body+='2410,20,10,,5040036,EUR,L,2025-05-01,2019-05-01,00,,2500,15,1500,1\r\n';
        //body+='2410,20,10,95,5040090,EUR,KG,2019-05-01,2025-05-01,00,IT00,5500,10,4500,1\r\n';
        //body+='2410,20,10,95,5040077,EUR,L,2019-05-01,2025-05-01,00,IT00,5500,10,,1\r\n';
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Italy',null,'Pricebook With Price Group Code',null,null,null,null,null);
        //FileUploadRESTAPI.sendEmail(body, body, 1, 1,'');
        
        body ='Sales Org Code,Distribution Channel,Division,Sold To Party Code,SKU Code,Currency,UOM,Valid From,Valid to,Batch,Depot/ Storage Location,Material Price,Standard Rebate,Estimated Final Price,Accrual Discount\r\n';
        body+='2410,20,10,95,1015389,EUR,L,2019-05-01,2025-05-01,00,IT00,2500,15,1500,1\r\n';
        body+='2410,20,10,95,1015380,,KG,2019-05-01,2025-05-01,00,IT00,5500,,4500,1\r\n';
        //body+='2410,20,10,95,1015389,EUR,L,2019-05-01,2025-05-01,00,IT00,,10,,1\r\n';
        //body+='2410,20,10,,1015380,EUR,L,2025-05-01,2019-05-01,00,,2500,15,1500,1\r\n';
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Italy',null,'Pricebook With Customer Code',null,null,null,null,null);
        //FileUploadRESTAPI.sendEmail(body, body, 1, 1,'');
        
        body ='Sales Org Code,Distribution Channel,Division,SKU Code,Currency,UOM,Valid From,Valid to,Batch,Depot/ Storage Location,Material Price,Standard Rebate,Accrual Discount\r\n';
        body+='2410,20,10,6280030,EUR,KG,2019-05-01,2025-05-01,00,IT00,2500,15,1\r\n';
        body+='2410,20,10,6040066,,L,2039-05-01,2019-05-01,00,,5500,10,1\r\n';
        //body+='2410,20,10,6040068,EUR,,2019-05-01,,00,IT00,6000,20,1\r\n';
        //body+='2410,20,10,6280035,EUR,,2019-05-01,,00,IT00,2500,15,1\r\n';
        //body+='2410,20,10,6280039,,KG,2025-05-01,2019-05-01,00,,2500,15,1\r\n';
        //body+='2410,20,10,6040060,EUR,KG,2019-05-01,2025-05-01,00,IT00,6000,20,1\r\n';
        System.debug('body : '+body);
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Italy','','Common Pricebook',null,null,null,null,null);
        //FileUploadRESTAPI.sendEmail(body, body, 10, 10,'');
        
        body = 'Sales Org Code,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,Min Price,Max Price,Sales Director Price,Latam Director Price,Start Date,End Date\r\n';
        body+='5100,67,20,MX51,MXN,6030504,EA,40,65,36,32,2019-01-01,2025-01-01\r\n';
        body+='5100,67,20,MX00,MXN,6030505,EA,117,190,105,95,2019-01-01,2025-01-01\r\n';
        
        // For Mexico
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Mexico',null,null,null,null,null,null,null);
        //FileUploadRESTAPI.sendEmail(body, body, 10, 10,'');
        
        // For Mexico Customerwise
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Mexico Customerwise',null,null,null,null,null,null,null);
        //FileUploadRESTAPI.sendEmail(body, body, 10, 10,'');
        
        
        // Spain, Portugal and Naturagri
        // Common PB
        body = 'Sales Org Code,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,Base Price,Line Discount (),Volume Discount (),Start Date,End Date,Tax\r\n';
        body+='2520,70,10,SW06,EUR,6052441,BT,6.00,2,0,2020-04-01,2021-03-31,10\r\n';
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Iberia & Portugal',null,null,null,'Common Pricebook',null,null,null);
        //Added by Nandhini
        body = 'Sales Org Code,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,Base Price,Line Discount (),Volume Discount (),Start Date,End Date,Tax\r\n';
        body+='2520,70,10,SW06,EUR,6052442,BT,6.00,2,0,2020-04-01,2021-03-31,10\r\n';
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Iberia & Portugal',null,null,null,'Common Pricebook',null,null,null);
        
        body = 'Sales Org Code,Distribution Channel,Division,Depot Code,Campaign Id,SKU Code,Campaign Discount (%)\r\n';
        body+='2510,67,10,SW06,C0001,6001002,5.4\r\n';
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Iberia & Portugal',null,null,null,'Campaign Pricebook',null,null,null);
        Test.startTest();
        body = 'Sales Org Code ,Distribution Channel,Division,Depot/ Storage Location,Currency,SKU Code,UOM,Base Price,Big Volume Discount Pallet,Big Volume Discount Truck,Earlier Order Discount,Start Date (Earlier Order Discount),End Date (Earlier Order Discount),Start Date,End Date\r\n';
        body+='2941,20,10,PD01,PLN,917056,L,37.4,4,6,4,2021-06-30,2021-12-31,2021-06-25,2025-11-21\r\n';
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Poland',null,null,null,null,null,'Common Pricebook',null);

        body = 'Sales Org Code ,Distribution Channel,Division,Depot/ Storage Location,Currency,SKU Code,UOM,Base Price,Big Volume Discount Pallet,Big Volume Discount Truck,Earlier Order Discount,Start Date (Earlier Order Discount),End Date (Earlier Order Discount),Start Date,End Date,PAK\r\n';
        body+='2941,20,10,PD01,PLN,917057,L,37.4,4,6,4,2021-06-30,2021-12-31,2021-06-25,2025-11-21,true\r\n';
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Poland',null,null,null,null,null,'Common Pricebook',null);        
     
        
        body = 'Sales Org Code,Distribution Channel,Division,Depot/ Storage Location,Currency,SKU Code,SAP Customer Code,UOM,Base Price,Payment Term,Manual Discount,Start Date,End Date\r\n';
        body+='2941,20,10,PD01,PLN,6221181,1021932,L,85.3,UK10,2,2021-01-07,2021-12-31\r\n';
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Poland',null,null,null,null,null,'CustomerWise Pricebook',null);
        
        body = 'Sales Org Code,Distribution Channel,Division,Depot/ Storage Location,Currency,SKU Code,UOM,Minimum Price,Maximum Price,Start Date,End Date\r\n';
        body+='5361,20,10,MAINBO01,USD,702502,L,200,500,2021-06-01,2022-12-31\r\n';
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Bolivia & Paraguay',null,null,null,null,null,null,'Common Pricebook');
        
        body = 'Sales Org Code,Distribution Channel,Division,Depot/ Storage Location,Currency,SKU Code,UOM,Minimum Price,Maximum Price,Start Date,End Date\r\n';
        body+='5361,20,10,MAINBO01,USD,702503,L,200,500,2021-06-01,2022-12-31\r\n';
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Bolivia & Paraguay',null,null,null,null,null,null,'Common Pricebook');
        //FileUploadRESTAPI.sendEmail(body, body, 10, 10,'');
        
        Test.stopTest();
        
        
    }
}