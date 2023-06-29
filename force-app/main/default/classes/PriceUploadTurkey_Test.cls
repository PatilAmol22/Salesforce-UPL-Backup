@isTest
public class PriceUploadTurkey_Test {
    static String str = 'Name,AccountNumber,Type,Accountsource,Industry\n Esha Patharabe,10001,Prospect,Test,Banking\n Trupti Nimje,10002,Prospect,Test,Banking';       
           
    public static String[] csvFileLines;
    public static Blob csvFileBody;

    static testmethod void testfileupload(){
        String body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,PG Code,Min Price,Start Date,End Date,Batch\r\n';
        body+='7110,20,10,TR00,TRY,368001,DR,03,2.5,2018-07-01,2019-07-01,1010\r\n';
        body+='7110,20,10,TR01,TRY,555005,DR,03,2.3,2018-07-02,2019-07-02,1010\r\n';
        Test.startTest();       
        csvFileBody = Blob.valueOf(body);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n'); 

        PriceUploadTurkeyController importData = new PriceUploadTurkeyController();
        
        importData.BlobFileValue = csvFileBody;
        importData.getItems();
        importData.docType = 'Pricebook';
        importData.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,Customer Code,Discount,PG Code,Start Date,End Date\r\n';
        body+='7110,20,10,TR00,TRY,368001,1036953,10,03,2018-07-01,2019-07-01\r\n';
        body+='7110,20,10,TR00,TRY,555005,1036953,23,03,2018-07-02,2019-07-02\r\n';
        csvFileBody = Blob.valueOf(body);
        PriceUploadTurkeyController importData1 = new PriceUploadTurkeyController();
        importData1.BlobFileValue = csvFileBody;
        
        importData1.docType = 'Discount';
        importData1.processData();
        
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,PG Code,Min Price,Start Date,End Date,Batch\r\n';
        body+=',20,10,TR00,TRY,368001,DR,03,2.5,2018-07-01,2019-07-01,1010\r\n';
        body+='7110,20,10,TR01,TRY,555005,DR,03,2.3,2018-07-02,2019-07-02,1010\r\n';         
        csvFileBody = Blob.valueOf(body);        
        PriceUploadTurkeyController importData2 = new PriceUploadTurkeyController();        
        importData2.BlobFileValue = csvFileBody;
        importData2.getItems();
        importData2.docType = 'Pricebook';
        importData2.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,PG Code,Min Price,Start Date,End Date,Batch\r\n';
        body+='7110,,10,TR00,TRY,368001,DR,03,2.5,2018-07-01,2019-07-01,1010\r\n';
        body+='7110,20,10,TR01,TRY,555005,DR,03,2.3,2018-07-02,2019-07-02,1010\r\n';         
        csvFileBody = Blob.valueOf(body);        
       // PriceUploadTurkeyController importData2 = new PriceUploadTurkeyController();        
        importData2.BlobFileValue = csvFileBody;
        importData2.getItems();
        importData2.docType = 'Pricebook';
        importData2.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,PG Code,Min Price,Start Date,End Date,Batch\r\n';
        body+='7110,20,,TR00,TRY,368001,DR,03,2.5,2018-07-01,2019-07-01,1010\r\n';
        body+='7110,20,10,TR01,TRY,555005,DR,03,2.3,2018-07-02,2019-07-02,1010\r\n';         
        csvFileBody = Blob.valueOf(body);        
       // PriceUploadTurkeyController importData2 = new PriceUploadTurkeyController();        
        importData2.BlobFileValue = csvFileBody;
        importData2.getItems();
        importData2.docType = 'Pricebook';
        importData2.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,PG Code,Min Price,Start Date,End Date,Batch\r\n';
        body+='7110,20,10,,TRY,368001,DR,03,2.5,2018-07-01,2019-07-01,1010\r\n';
        body+='7110,20,10,TR01,TRY,555005,DR,03,2.3,2018-07-02,2019-07-02,1010\r\n';         
        csvFileBody = Blob.valueOf(body);        
       // PriceUploadTurkeyController importData2 = new PriceUploadTurkeyController();        
        importData2.BlobFileValue = csvFileBody;
        importData2.getItems();
        importData2.docType = 'Pricebook';
        importData2.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,PG Code,Min Price,Start Date,End Date,Batch\r\n';
        body+='7110,20,10,TR00,,368001,DR,03,2.5,2018-07-01,2019-07-01,1010\r\n';
        body+='7110,20,10,TR01,TRY,555005,DR,03,2.3,2018-07-02,2019-07-02,1010\r\n';         
        csvFileBody = Blob.valueOf(body);        
       // PriceUploadTurkeyController importData2 = new PriceUploadTurkeyController();        
        importData2.BlobFileValue = csvFileBody;
        importData2.getItems();
        importData2.docType = 'Pricebook';
        importData2.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,PG Code,Min Price,Start Date,End Date,Batch\r\n';
        body+='7110,20,10,TR00,TRY,,DR,03,2.5,2018-07-01,2019-07-01,1010\r\n';
        body+='7110,20,10,TR01,TRY,555005,DR,03,2.3,2018-07-02,2019-07-02,1010\r\n';         
        csvFileBody = Blob.valueOf(body);        
       // PriceUploadTurkeyController importData2 = new PriceUploadTurkeyController();        
        importData2.BlobFileValue = csvFileBody;
        importData2.getItems();
        importData2.docType = 'Pricebook';
        importData2.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,PG Code,Min Price,Start Date,End Date,Batch\r\n';
        body+='7110,20,10,TR00,TRY,368001,,03,2.5,2018-07-01,2019-07-01,1010\r\n';
        body+='7110,20,10,TR01,TRY,555005,DR,03,2.3,2018-07-02,2019-07-02,1010\r\n';         
        csvFileBody = Blob.valueOf(body);        
       // PriceUploadTurkeyController importData2 = new PriceUploadTurkeyController();        
        importData2.BlobFileValue = csvFileBody;
        importData2.getItems();
        importData2.docType = 'Pricebook';
        importData2.processData();
        
         body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,PG Code,Min Price,Start Date,End Date,Batch\r\n';
        body+='7110,20,10,TR00,TRY,368001,DR,,2.5,2018-07-01,2019-07-01,1010\r\n';
        body+='7110,20,10,TR01,TRY,555005,DR,03,2.3,2018-07-02,2019-07-02,1010\r\n';         
        csvFileBody = Blob.valueOf(body);        
       // PriceUploadTurkeyController importData2 = new PriceUploadTurkeyController();        
        importData2.BlobFileValue = csvFileBody;
        importData2.getItems();
        importData2.docType = 'Pricebook';
        importData2.processData();
        
         
         body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,PG Code,Min Price,Start Date,End Date,Batch\r\n';
        body+='7110,20,10,TR00,TRY,368001,DR,03,,2018-07-01,2019-07-01,1010\r\n';
        body+='7110,20,10,TR01,TRY,555005,DR,03,2.3,2018-07-02,2019-07-02,1010\r\n';         
        csvFileBody = Blob.valueOf(body);        
       // PriceUploadTurkeyController importData2 = new PriceUploadTurkeyController();        
        importData2.BlobFileValue = csvFileBody;
        importData2.getItems();
        importData2.docType = 'Pricebook';
        importData2.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,PG Code,Min Price,Start Date,End Date,Batch\r\n';
        body+='7110,20,10,TR00,TRY,368001,DR,03,2.5,,2019-07-01,1010\r\n';
        body+='7110,20,10,TR01,TRY,555005,DR,03,2.3,2018-07-02,2019-07-02,1010\r\n';         
        csvFileBody = Blob.valueOf(body);        
       // PriceUploadTurkeyController importData2 = new PriceUploadTurkeyController();        
        importData2.BlobFileValue = csvFileBody;
        importData2.getItems();
        importData2.docType = 'Pricebook';
        importData2.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,PG Code,Min Price,Start Date,End Date,Batch\r\n';
        body+='7110,20,10,TR00,TRY,368001,DR,03,2.5,2018-07-02,,1010\r\n';
        body+='7110,20,10,TR01,TRY,555005,DR,03,2.3,2018-07-02,2019-07-02,1010\r\n';         
        csvFileBody = Blob.valueOf(body);        
       // PriceUploadTurkeyController importData2 = new PriceUploadTurkeyController();        
        importData2.BlobFileValue = csvFileBody;
        importData2.getItems();
        importData2.docType = 'Pricebook';
        importData2.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,PG Code,Min Price,Start Date,End Date,Batch\r\n';
        body+='7110,20,10,TR00,TRY,368001,DR,03,2.5,2018-07-02,2019-07-02,1010\r\n';
        body+='7110,20,10,TR01,TRY,555005,DR,03,2.3,2018-07-02,2019-07-02,1010\r\n';         
        csvFileBody = Blob.valueOf(body);        
       // PriceUploadTurkeyController importData2 = new PriceUploadTurkeyController();        
        importData2.BlobFileValue = csvFileBody;
        importData2.getItems();
        importData2.docType = 'Pricebook';
        importData2.processData();
        
        /************Discount Negative**************/
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,Customer Code,Discount,PG Code,Start Date,End Date\r\n';
        body+=',20,10,TR00,TRY,368001,1036953,10,03,2018-07-01,2019-07-01\r\n';
        body+='7110,20,10,TR00,TRY,555005,1036953,23,03,2018-07-02,2019-07-02\r\n';
        csvFileBody = Blob.valueOf(body);        
        importData1.BlobFileValue = csvFileBody;        
        importData1.docType = 'Discount';
        importData1.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,Customer Code,Discount,PG Code,Start Date,End Date\r\n';
        body+='7110,,10,TR00,TRY,368001,1036953,10,03,2018-07-01,2019-07-01\r\n';
        body+='7110,20,10,TR00,TRY,555005,1036953,23,03,2018-07-02,2019-07-02\r\n';
        csvFileBody = Blob.valueOf(body);        
        importData1.BlobFileValue = csvFileBody;        
        importData1.docType = 'Discount';
        importData1.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,Customer Code,Discount,PG Code,Start Date,End Date\r\n';
        body+='7110,20,,TR00,TRY,368001,1036953,10,03,2018-07-01,2019-07-01\r\n';
        body+='7110,20,10,TR00,TRY,555005,1036953,23,03,2018-07-02,2019-07-02\r\n';
        csvFileBody = Blob.valueOf(body);        
        importData1.BlobFileValue = csvFileBody;        
        importData1.docType = 'Discount';
        importData1.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,Customer Code,Discount,PG Code,Start Date,End Date\r\n';
        body+='7110,20,10,,TRY,368001,1036953,10,03,2018-07-01,2019-07-01\r\n';
        body+='7110,20,10,TR00,TRY,555005,1036953,23,03,2018-07-02,2019-07-02\r\n';
        csvFileBody = Blob.valueOf(body);        
        importData1.BlobFileValue = csvFileBody;        
        importData1.docType = 'Discount';
        importData1.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,Customer Code,Discount,PG Code,Start Date,End Date\r\n';
        body+='7110,20,10,TR00,,368001,1036953,10,03,2018-07-01,2019-07-01\r\n';
        body+='7110,20,10,TR00,TRY,555005,1036953,23,03,2018-07-02,2019-07-02\r\n';
        csvFileBody = Blob.valueOf(body);        
        importData1.BlobFileValue = csvFileBody;        
        importData1.docType = 'Discount';
        importData1.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,Customer Code,Discount,PG Code,Start Date,End Date\r\n';
        body+='7110,20,10,TR00,TRY,,1036953,10,03,2018-07-01,2019-07-01\r\n';
        body+='7110,20,10,TR00,TRY,555005,1036953,23,03,2018-07-02,2019-07-02\r\n';
        csvFileBody = Blob.valueOf(body);        
        importData1.BlobFileValue = csvFileBody;        
        importData1.docType = 'Discount';
        importData1.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,Customer Code,Discount,PG Code,Start Date,End Date\r\n';
        body+='7110,20,10,TR00,TRY,368001,,10,03,2018-07-01,2019-07-01\r\n';
        body+='7110,20,10,TR00,TRY,555005,1036953,23,03,2018-07-02,2019-07-02\r\n';
        csvFileBody = Blob.valueOf(body);        
        importData1.BlobFileValue = csvFileBody;        
        importData1.docType = 'Discount';
        importData1.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,Customer Code,Discount,PG Code,Start Date,End Date\r\n';
        body+='7110,20,10,TR00,TRY,368001,1036953,,03,2018-07-01,2019-07-01\r\n';
        body+='7110,20,10,TR00,TRY,555005,1036953,23,03,2018-07-02,2019-07-02\r\n';
        csvFileBody = Blob.valueOf(body);        
        importData1.BlobFileValue = csvFileBody;        
        importData1.docType = 'Discount';
        importData1.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,Customer Code,Discount,PG Code,Start Date,End Date\r\n';
        body+='7110,20,10,TR00,TRY,368001,1036953,10,,2018-07-01,2019-07-01\r\n';
        body+='7110,20,10,TR00,TRY,555005,1036953,23,03,2018-07-02,2019-07-02\r\n';
        csvFileBody = Blob.valueOf(body);        
        importData1.BlobFileValue = csvFileBody;        
        importData1.docType = 'Discount';
        importData1.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,Customer Code,Discount,PG Code,Start Date,End Date\r\n';
        body+='7110,20,10,TR00,TRY,368001,1036953,10,03,,2019-07-01\r\n';
        body+='7110,20,10,TR00,TRY,555005,1036953,23,03,2018-07-02,2019-07-02\r\n';
        csvFileBody = Blob.valueOf(body);        
        importData1.BlobFileValue = csvFileBody;        
        importData1.docType = 'Discount';
        importData1.processData();
        
        body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,Customer Code,Discount,PG Code,Start Date,End Date\r\n';
        body+='7110,20,10,TR00,TRY,368001,1036953,10,,2018-07-01,\r\n';
        body+='7110,20,10,TR00,TRY,555005,1036953,23,03,2018-07-02,2019-07-02\r\n';
        csvFileBody = Blob.valueOf(body);        
        importData1.BlobFileValue = csvFileBody;        
        importData1.docType = 'Discount';
        importData1.processData();
       
        
        
            
                
        Test.stopTest();
    } 

    static testmethod void testfileuploadNegative(){
        Test.startTest();       
        csvFileBody = Blob.valueOf(str);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n'); 

        PriceUploadTurkeyController importData = new PriceUploadTurkeyController();
        importData.processData() ;
        
        
        String body = 'Sales Org,Distribution Channel,Division,Depot Code,Currency,SKU Code,UOM,PG Code,Min Price,Start Date,End Date,Batch\r\n';
        body+=',20,10,TR00,TRY,368001,DR,03,2.5,2018-07-01,2019-07-01,1010\r\n';
        body+='7110,20,10,TR01,TRY,555005,DR,03,2.3,2018-07-02,2019-07-02,1010\r\n';
         
        csvFileBody = Blob.valueOf(body);
        
        PriceUploadTurkeyController importData1 = new PriceUploadTurkeyController();
        
        importData1.BlobFileValue = csvFileBody;
        importData1.getItems();
        importData1.docType = 'Pricebook';
        importData1.processData();
        
        
        
        
        
        
        Test.stopTest();
    }

}