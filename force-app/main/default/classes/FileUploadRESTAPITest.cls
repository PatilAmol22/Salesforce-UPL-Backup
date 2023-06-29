@isTest
public class FileUploadRESTAPITest {

    @testSetup
    static void allTheDataForThisTestClass() {
        
        
        Sales_Org__c salesOrg2= new Sales_Org__c();
        salesOrg2.Name='Colombia';
        salesOrg2.Description__c='Colombia';
        salesOrg2.Sales_Org_Code__c='5710';
        insert salesOrg2;
        
        SKU__c skuObj=new SKU__c();
        skuObj.Name='SAATHI';
        skuObj.SKU_Description__c='Saathi';
        skuObj.Active__c=true;
        skuObj.Sales_Org__c=salesOrg2.Id;
        skuObj.UOM__c='L';
        skuObj.SKU_Code__c='000000000006180698';
        insert skuObj;
        
        Distribution_Channel__c discObj=new Distribution_Channel__c();
        discObj.Name='10';
        discObj.Description__c='xyz';
        discObj.Distribution_Channel_Code__c='67';
        insert discObj;
        
        PriceBookMaster__c pbmObj= new PriceBookMaster__c();
        pbmObj.SKUCode__c=skuObj.Id;
        pbmObj.Sales_Org__c=salesOrg2.Id;
        pbmObj.StartDate__c = system.today();
        pbmObj.EndDate__c = system.today()+1;
        pbmObj.Active__c=true;
        pbmObj.CurrencyIsoCode='COP';
        pbmObj.CompositeKey__c='CO515710671000000000000618069875';
        pbmObj.DistributionChannel__c=discObj.Id;
        insert pbmObj;
        
    }
    
    public static testMethod void method(){
        /*String body = 'Sales Org,Distribution Channel ,Division,Depot Code,Currency,SKU Code,UOM,Min Price,List Price,Start Date,End Date\r\n';
        body+='5631,10,10,AR13,USD,6070001,LTS,2.80,3,2018-04-01,2019-03-31\r\n';
        body+='5631,10,10,AR13,USD,6070041,LTS,2.80,3,2018-04-01,2019-03-31\r\n';*/ // Earlier using above test data for Argentina
        
        String body = 'Sales Org Code,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,Min Price,Max Price,Manager Price,Director Price,Budget Price,Start Date,End Date\r\n';
        body+='5100,67,20,MX51,MXN,6030504,EA,40,65,36,32,31,2019-01-01,2025-01-01\r\n';
        body+='5100,67,20,MX00,MXN,6030505,EA,117,190,105,95,91,2019-01-01,2025-01-01\r\n';
        
        // For Argentina
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Argentina',null,null,null,null,null,null,null);
        //FileUploadRESTAPI.sendEmail(body, body, 10, 10,'');
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Mexico',null,null,null,null,null,null,null);
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Mexico Customerwise',null,null,null,null,null,null,null);
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Italy',null,'Pricebook With Price Group Code',null,null,null,null,null);
        
        
        /*body = 'Sales Org,Distribution Channel ,Division,SKU Code,Customer Code,Price per unit,Min Price,Max Price,Regional Head Price,Currency,UOM,Start Date,End Date,Batch,Depot Code\r\n';
        body+='5310,10,10,6070001,5002773,25.3,41.2,56.32,25.62,USD,KG,3,2018-04-01,2019-03-31,1010,CROO\r\n';
        body+='5310,20,10,6070041,5002774,25.3,41.2,56.32,24.23,USD,KG,3,2018-04-01,2019-03-31,1010,CROO\r\n';
        FileUploadRESTAPI.processData(Blob.valueOf(body),'CAM',null,null,null);
        FileUploadRESTAPI.sendEmail(body, body, 10, 10,'');*/
        
        /* new code for CAM */ //SOC
        body = 'Sales Org Code,Distribution Channel,Division,Customer Code,SKU Code,Depot Code,Currency,UOM ,Valid From,Valid to ,Maximum Price,Regional Price\r\n';
        body+='5310,10,10,6070001,5002773,CROO,USD,KG,2020-07-24,2020-12-31,56.32,25.62\r\n';
        body+='5310,10,10,6120136,5002773,CROO,USD,KG,2020-07-24,2020-12-31,56.32,25.62\r\n';
        FileUploadRESTAPI.processData(Blob.valueOf(body),'CAM',null,null,'CustomerWise',null,null,null,null);
        //FileUploadRESTAPI.sendEmail(body, body, 10, 10,'');
        
        body = 'Sales Org Code,Distribution Channel,Division,Country,Customer Group,Price Classification,Price List,SKU Code,Depot Code,Currency,UOM ,Valid From,Valid to ,Maximum Price,Minimum Price\r\n';
        body+='5310,10,10,Costa Rica,75,B2B,B2B,6070001,CROO,USD,KG,2020-07-24,2020-12-31,56.32,25.62\r\n';
        body+='5310,10,10,Costa Rica,3,B2B,B2B,6070001,CROO,USD,KG,2020-07-24,2020-12-31,56.32,25.62\r\n';
        FileUploadRESTAPI.processData(Blob.valueOf(body),'CAM',null,null,'CombinationWise',null,null,null,null);
        //FileUploadRESTAPI.sendEmail(body, body, 10, 10,''); //EOC
        
        //body = 'Sales Org Code,Distribution Channel,Division,SKU Code,Price per unit,Currency,UOM,Valid From,Valid to,Batch,Depot/Storage Location,Minimum Price,Maximum Price,Floor Price\r\n';
        
        //body+='5710,67,10,5130076,5,USD,L,2019-01-20,2029-01-20,1010,T-41,1,5,4\r\n';
        //body+='5710,67,10,6170059,50,USD,L,2019-01-20,2029-01-20,1010,T-41,10,60,15\r\n';
        body ='Sales Org Code,Distribution Channel,Division,Sold To Party Code,SKU Code,Currency,UOM,Valid From,Valid to,Batch,Depot/ Storage Location,Minimum Price,Maximum Price,Floor Price\r\n';
        body+='5710,67,10,0001059428,6051101,COP,L,2019-01-01,2039-05-05,1010,CO51,165,1100,160\r\n';
        body+='5710,67,10,0001059428,,COP,L,,2039-05-05,1010,,165,-1100,160\r\n';
        body+='5710,67,10,,6180696,,L,2019-01-01,2039-05-05,1010,CO51,,,160\r\n';
        body+='5710,67,10,0001059430,6180697,,L,2019-01-01,2039-05-05,1010,,,1100,160\r\n';
        body+='5710,67,10,,6180698,,L,2039-05-05,2019-01-01,,CO51,165,,160\r\n';
        body+='5710,67,10,0001059432,6180698,,L,2039-05-05,,1010,CO51,1100,160,160\r\n';
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Colombia','CustomerWise',null,null,null,null,null,null);
        //FileUploadRESTAPI.sendEmail(body, body, 10, 10,'');
        
        body ='Sales Org Code,Distribution Channel,Division,Customer Group Code,SKU Code,Currency,UOM,Valid From,Valid to,Batch,Depot/ Storage Location,Minimum Price,Maximum Price,Floor Price\r\n';
        body+='5710,67,10,75,6051101,COP,L,2019-01-01,2039-05-05,1010,CO51,165,1100,160\r\n';
        body+='5710,67,10,75,6180694,,L,2019-01-01,,,CO51,165,1100,160\r\n';
        body+='5710,67,10,,6051102,COP,L,2039-01-01,2011-05-05,1010,,165,1100,160\r\n';
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Colombia','CustomerGroup',null,null,null,null,null,null);
        //FileUploadRESTAPI.sendEmail(body, body, 10, 10,'');
        
        
        body = 'Sales Org,Distribution Channel,Division,SKU Code,Multiply Of,Unit Cost,Sales Agent Msp,Area Manager Msp,Sales Director Msp,GST,Pallet Size\r\n';
        body+='5100,20,10,6030190,12,234.75,20,10,20,18,20\r\n';
        FileUploadRESTAPI.processSKUData(Blob.valueOf(body),'Argentina');
        FileUploadRESTAPI.sendEmail(body, body, 10, 10,'SKUUploadFile');
        
        /*body ='Sales Org Code,Distribution Channel,Division,PG Code,SKU Code,Currency,UOM,Valid From,Valid to,Batch,Depot/ Storage Location,Material Price,Standard Rebate,Estimated Final Price\r\n';
        body+='2410,20,10,95,5040036,EUR,L,2019-05-01,2025-05-01,00,IT00,2500,15,1500\r\n';
        body+='2410,20,10,95,5040086,,KG,2019-05-01,2025-05-01,00,IT00,5500,,4500\r\n';
        body+='2410,20,10,95,5040037,EUR,L,2019-05-01,2025-05-01,00,IT00,,10,\r\n';
        body+='2410,20,10,,5040036,EUR,L,2025-05-01,2019-05-01,00,,2500,15,1500\r\n';
        body+='2410,20,10,95,5040090,EUR,KG,2019-05-01,2025-05-01,00,IT00,5500,10,4500\r\n';
        body+='2410,20,10,95,5040077,EUR,L,2019-05-01,2025-05-01,00,IT00,5500,10,\r\n';
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Italy',null,'Pricebook With Price Group Code');
        FileUploadRESTAPI.sendEmail(body, body, 1, 1);*/
        
        /*body ='Sales Org Code,Distribution Channel,Division,SKU Code,Currency,UOM,Valid From,Valid to,Batch,Depot/ Storage Location,Material Price,Standard Rebate\r\n';
        body+='2410,20,10,6280030,EUR,KG,2019-05-01,2025-05-01,00,IT00,2500,15\r\n';
        body+='2410,20,10,6040066,,L,2039-05-01,2019-05-01,00,,5500,10\r\n';
        body+='2410,20,10,6040068,EUR,,2019-05-01,,00,IT00,6000,20\r\n';
        body+='2410,20,10,6280035,EUR,,2019-05-01,,00,IT00,2500,15\r\n';
        body+='2410,20,10,6280039,,KG,2025-05-01,2019-05-01,00,,2500,15\r\n';
        body+='2410,20,10,6040060,EUR,KG,2019-05-01,2025-05-01,00,IT00,6000,20\r\n';
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Italy','','Common Pricebook');
        FileUploadRESTAPI.sendEmail(body, body, 10, 10);*/
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/FileUpload/v1/*';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(body);
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        FileUploadRESTAPI.attachDoc();
        Test.stopTest();
        
        
    }
    
    public static testMethod void method2(){
        /*String body = 'Sales Org,Distribution Channel ,Division,Depot Code,Currency,SKU Code,UOM,Min Price,List Price,Start Date,End Date\r\n';
        body+='5631,10,10,AR13,USD,6070001,LTS,2.80,3,2018-04-01,2019-03-31\r\n';
        body+='5631,10,10,AR13,USD,6070041,LTS,2.80,3,2018-04-01,2019-03-31\r\n';*/ // Earlier using above test data for Argentina
        
        String body = 'Sales Org Code,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,Min Price,Max Price,Manager Price,Director Price,Budget Price,Start Date,End Date\r\n';
        body+='5100,67,20,MX51,MXN,6030504,EA,40,65,36,32,31,2019-01-01,2025-01-01\r\n';
        body+='5100,67,20,MX00,MXN,6030505,EA,117,190,105,95,91,2019-01-01,2025-01-01\r\n';
        
        // For Argentina
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Argentina',null,null,null,null,null,null,null);
        //FileUploadRESTAPI.sendEmail(body, body, 10, 10,'');
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Mexico',null,null,null,null,null,null,null);
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Mexico Customerwise',null,null,null,null,null,null,null);
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Italy',null,'Common Pricebook',null,null,null,null,null);
        
        FileUploadRESTAPI.processSKUData(Blob.valueOf(body),'Mexico');
        
    }
    
    public static testMethod void method3(){
        /*String body = 'Sales Org,Distribution Channel ,Division,Depot Code,Currency,SKU Code,UOM,Min Price,List Price,Start Date,End Date\r\n';
        body+='5631,10,10,AR13,USD,6070001,LTS,2.80,3,2018-04-01,2019-03-31\r\n';
        body+='5631,10,10,AR13,USD,6070041,LTS,2.80,3,2018-04-01,2019-03-31\r\n';*/ // Earlier using above test data for Argentina
        
        String body = 'Sales Org Code,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,Min Price,Max Price,Manager Price,Director Price,Budget Price,Start Date,End Date\r\n';
        body+='5100,67,20,MX51,MXN,6030504,EA,40,65,36,32,31,2019-01-01,2025-01-01\r\n';
        body+='5100,67,20,MX00,MXN,6030505,EA,117,190,105,95,91,2019-01-01,2025-01-01\r\n';
        
        // For Argentina
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Argentina',null,null,null,null,null,null,null);
        //FileUploadRESTAPI.sendEmail(body, body, 10, 10,'');
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Mexico',null,null,null,null,null,null,null);
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Mexico Customerwise',null,null,null,null,null,null,null);
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Italy',null,'Pricebook With Customer Code',null,null,null,null,null);
        
        FileUploadRESTAPI.processSKUData(Blob.valueOf(body),'CAM');
        
    }
    
    public static testMethod void method4(){
        /*String body = 'Sales Org,Distribution Channel ,Division,Depot Code,Currency,SKU Code,UOM,Min Price,List Price,Start Date,End Date\r\n';
        body+='5631,10,10,AR13,USD,6070001,LTS,2.80,3,2018-04-01,2019-03-31\r\n';
        body+='5631,10,10,AR13,USD,6070041,LTS,2.80,3,2018-04-01,2019-03-31\r\n';*/ // Earlier using above test data for Argentina
        
        String body = 'Sales Org Code,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,Min Price,Max Price,Manager Price,Director Price,Budget Price,Start Date,End Date\r\n';
        body+='5100,67,20,MX51,MXN,6030504,EA,40,65,36,32,31,2019-01-01,2025-01-01\r\n';
        body+='5100,67,20,MX00,MXN,6030505,EA,117,190,105,95,91,2019-01-01,2025-01-01\r\n';
        
        // For Argentina
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Argentina',null,null,null,null,null,null,null);
        //FileUploadRESTAPI.sendEmail(body, body, 10, 10,'');
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Mexico',null,null,null,null,null,null,null);
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Mexico Customerwise',null,null,null,null,null,null,null);
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Italy',null,'Pricebook With Customer Code',null,null,null,null,null);
        
        FileUploadRESTAPI.processSKUData(Blob.valueOf(body),'Colombia');
        
    }
    
    public static testMethod void method5(){
        /*String body = 'Sales Org,Distribution Channel ,Division,Depot Code,Currency,SKU Code,UOM,Min Price,List Price,Start Date,End Date\r\n';
        body+='5631,10,10,AR13,USD,6070001,LTS,2.80,3,2018-04-01,2019-03-31\r\n';
        body+='5631,10,10,AR13,USD,6070041,LTS,2.80,3,2018-04-01,2019-03-31\r\n';*/ // Earlier using above test data for Argentina
        
        String body = 'Sales Org Code,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,Min Price,Max Price,Manager Price,Director Price,Budget Price,Start Date,End Date\r\n';
        body+='5100,67,20,MX51,MXN,6030504,EA,40,65,36,32,31,2019-01-01,2025-01-01\r\n';
        body+='5100,67,20,MX00,MXN,6030505,EA,117,190,105,95,91,2019-01-01,2025-01-01\r\n';
        
        // For Argentina
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Argentina',null,null,null,null,null,null,null);
        //FileUploadRESTAPI.sendEmail(body, body, 10, 10,'');
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Mexico',null,null,null,null,null,null,null);
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Mexico Customerwise',null,null,null,null,null,null,null);
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Italy',null,'Pricebook With Customer Code',null,null,null,null,null);
        
        FileUploadRESTAPI.processSKUData(Blob.valueOf(body),'Italy');
        
    }
    
    public static testMethod void method6(){
        /*String body = 'Sales Org,Distribution Channel ,Division,Depot Code,Currency,SKU Code,UOM,Min Price,List Price,Start Date,End Date\r\n';
        body+='5631,10,10,AR13,USD,6070001,LTS,2.80,3,2018-04-01,2019-03-31\r\n';
        body+='5631,10,10,AR13,USD,6070041,LTS,2.80,3,2018-04-01,2019-03-31\r\n';*/ // Earlier using above test data for Argentina
        
        String body = 'Sales Org Code,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,Min Price,Max Price,Manager Price,Director Price,Budget Price,Start Date,End Date\r\n';
        body+='5100,67,20,MX51,MXN,6030504,EA,40,65,36,32,31,2019-01-01,2025-01-01\r\n';
        body+='5100,67,20,MX00,MXN,6030505,EA,117,190,105,95,91,2019-01-01,2025-01-01\r\n';
        
        // For Argentina
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Argentina',null,null,null,null,null,null,null);
        //FileUploadRESTAPI.sendEmail(body, body, 10, 10,'');
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Mexico',null,null,null,null,null,null,null);
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Mexico Customerwise',null,null,null,null,null,null,null);
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Italy',null,'Pricebook With Customer Code',null,null,null,null,null);
        
        FileUploadRESTAPI.processSKUData(Blob.valueOf(body),'Iberia & Portugal');
        
    }
    
    public static testMethod void method7(){
        /*String body = 'Sales Org,Distribution Channel ,Division,Depot Code,Currency,SKU Code,UOM,Min Price,List Price,Start Date,End Date\r\n';
        body+='5631,10,10,AR13,USD,6070001,LTS,2.80,3,2018-04-01,2019-03-31\r\n';
        body+='5631,10,10,AR13,USD,6070041,LTS,2.80,3,2018-04-01,2019-03-31\r\n';*/ // Earlier using above test data for Argentina
        
        String body = 'Sales Org Code,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,Min Price,Max Price,Manager Price,Director Price,Budget Price,Start Date,End Date\r\n';
        body+='5100,67,20,MX51,MXN,6030504,EA,40,65,36,32,31,2019-01-01,2025-01-01\r\n';
        body+='5100,67,20,MX00,MXN,6030505,EA,117,190,105,95,91,2019-01-01,2025-01-01\r\n';
        
        // For Argentina
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Argentina',null,null,null,null,null,null,null);
        //FileUploadRESTAPI.sendEmail(body, body, 10, 10,'');
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Mexico',null,null,null,null,null,null,null);
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Mexico Customerwise',null,null,null,null,null,null,null);
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Italy',null,'Pricebook With Customer Code',null,null,null,null,null);
        
        FileUploadRESTAPI.processSKUData(Blob.valueOf(body),'Poland');
        
    }
    
    public static testMethod void method8(){
        /*String body = 'Sales Org,Distribution Channel ,Division,Depot Code,Currency,SKU Code,UOM,Min Price,List Price,Start Date,End Date\r\n';
        body+='5631,10,10,AR13,USD,6070001,LTS,2.80,3,2018-04-01,2019-03-31\r\n';
        body+='5631,10,10,AR13,USD,6070041,LTS,2.80,3,2018-04-01,2019-03-31\r\n';*/ // Earlier using above test data for Argentina
        
        String body = 'Sales Org Code,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,Min Price,Max Price,Manager Price,Director Price,Budget Price,Start Date,End Date\r\n';
        body+='5100,67,20,MX51,MXN,6030504,EA,40,65,36,32,31,2019-01-01,2025-01-01\r\n';
        body+='5100,67,20,MX00,MXN,6030505,EA,117,190,105,95,91,2019-01-01,2025-01-01\r\n';
        
        // For Argentina
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Argentina',null,null,null,null,null,null,null);
        //FileUploadRESTAPI.sendEmail(body, body, 10, 10,'');
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Mexico',null,null,null,null,null,null,null);
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Mexico Customerwise',null,null,null,null,null,null,null);
        
        FileUploadRESTAPI.processData(Blob.valueOf(body),'Italy',null,'Pricebook With Customer Code',null,null,null,null,null);
        
        FileUploadRESTAPI.processSKUData(Blob.valueOf(body),'Bolivia & Paraguay');
        
        FileUploadRESTAPI.testCoverage();
        
    }
}