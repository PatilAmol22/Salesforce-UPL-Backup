@isTest(SeeAllData=true)
private class brazil_RegionSKU_Upload_Test {
    
@isTest
     public static void testUpload() {
         
        Sales_Org__c saleOrg = [select id,name from Sales_Org__c where Sales_Org_Code__c='5191' limit 1];
        system.debug('**saleOrg -> '+saleOrg);
        
        Division__c div = [select id from Division__c where Division_Code__c='DC' limit 1];
        system.debug('**Division -> '+div);
         
        SKU__c skuRec = new SKU__c(
            Name = 'a1C0k000000A1ug',                                 // SKU Name
            SKU_Code__c = '000000000001000004',                       // SKU Code
            SKU_Description__c = 'Kit ',   // SKU Description
            UOM__c = 'KG', 
            Division__c = div.Id,                                     // Division
            Sales_Org__c = saleOrg.Id,                                  // Sales Org
            Multiple_of__c = 25.00,                                   // Multiple Of
            Combination_Key__c = '5191000000000001000004',          // Combination Key
            Active__c = true,
            Kit_Product__c = true,
            brand_name__c = 'MANZATE Kit'// Active
        );
        insert skuRec; 
        system.debug('**skuRecord -> '+skuRec);
         
        Brazil_Region_SKU_Combination__c brObj = new Brazil_Region_SKU_Combination__c();
         
        insert  brObj;
         
       String strInsert = 'Sales District,SKU,Sales Org,Availability,Date\nBR6003,1000004,5191,Yes,2021-05-02';
        ContentVersion cv1=new Contentversion(); 
        cv1.title='Brazil'; 
        cv1.PathOnClient ='test'; 
        Blob b1=Blob.valueOf(strInsert); 
        cv1.versiondata=b1; 
        insert cv1; 
        
         ContentVersion  testContentInsert = [select id, ContentDocumentId from ContentVersion WHERE Id =: cv1.Id];
         
        list<string> insertStr = new  list<string>();
        insertStr.add('"BR1504",1000004,"5191",Yes,2021-05-02, 2023-12-02');
        
        list<string> insertDupStr = new  list<string>();
        insertDupStr.add('"BR1504",1000004,"5191",Yes,2021-05-02, 2023-12-02');
        insertDupStr.add('"BR1504",1000005,"5191",Yes,2021-05-02, 2023-12-02');
         //String csvLine = String.valueOf(lstCSVLines[i]);
          //list<String> csvRow = csvLine.split(',');
         //String sub = csvLine.substring(startIndex, endIndex);
         //csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
              
        string insertHeader = 'Sales District,SKU,Sales Org,Availability,Date';
         //brObj.Sales_District__r=new Region__c(RegionCode__c=csvRow[0].replaceAll(':quotes:', '').replaceAll(':comma:', ',').replace(',', '').trim());
        Test.startTest();  
        brazil_RegionSKU_Upload.getAllRecordId();
        brazil_RegionSKU_Upload.getDownloadURLForTemplates();
        brazil_RegionSKU_Upload.readCSVFileBr(testContentInsert.ContentDocumentId);
        brazil_RegionSKU_Upload.uploadBr(insertStr,insertHeader);
        brazil_RegionSKU_Upload.uploadBr(insertDupStr,insertHeader);
         brazil_RegionSKU_Upload.sendMail('This is Test','This is test1',1,2);
         
        Test.stopTest(); 
    }
}