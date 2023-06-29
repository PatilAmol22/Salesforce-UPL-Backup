@isTest(SeeAllData=true)
public with sharing class FileUpload_JapanTest {
    @isTest
    public static void FileUpload_JapanTestmethod(){
        
        System_Admin_ID__c s = new System_Admin_ID__c();
        s.Name='ukfahfilhalfhailwhlhaw';
        insert s; 
       
        Distributor_Inventory__c DI1 = new Distributor_Inventory__c();
        insert DI1;
        
        Ex_Distributor_Shipment_Data__c ogs1 = new Ex_Distributor_Shipment_Data__c();
        insert ogs1;
        
        String str1 = 'Sales Office Code エリア,Fiscal Year 会計年,Month 月,Distributor code 特約店名,Distributors Sales Office 特約店 営業所,Area code 県名,Material Code 商品名,Sales Org Code,Single Pack Number 袋/本数,Pesticidal Year 農年度,Price Single Bottle,Amount JPY,Single Bottle No,Calendar Year,Region,Number in case\nJP03,2018,1,1083449,愛知川,13,5290238,6731,241,30,1,1,1,2019,Tohoku,1\nJP03,2018,2,"10,83,449",愛知川,3,"5,29,023",6,731,241,30,1,1,1,2019,Tohoku,1';
        ContentVersion cv1=new Contentversion(); 
        cv1.title='Distributor Inventory'; 
        cv1.PathOnClient ='test'; 
        Blob b1=Blob.valueOf(str1); 
        cv1.versiondata=b1; 
        insert cv1; 
            
        String str2 = 'Distributor Area Code 特約店の 県名,Chemical IPM 化学/IPM,Sales office for ex distributor customer 得意先の営業所エリア,Area in Ex distributors 得意先の都道府県,Sales Office Area In distributors 特約店の営業所エリア,UPL FY UPL 年度,Calender year 年,Month 月,Distributor code 特約店名,Customer Name,Distributors sales Office Code 特約店の営業所（化学のみ）,Region in exdistributors Customer 得意先ブロック（化学のみ）,District in ex distributors Customer 得意先県名（北海道は地域名）,Customer Category 得意先分類,JA Area Name JAエリア,Volume 数量（袋/本数）,Pesticidal year 農年,Price per single bottle 1本/袋の金額,Amount JPY 金額(C価)円,Order Type IPM受注伝票タイプ,Material Code （新SAP） 品目コード,Sales Org Code,Customer Address IPM出荷先住所(市区町村＋所在地),Single bottle bag Number in case 入数,UOM\n13,Bee,JP03,13,JP03,2017,2017,1,1083449,abc,JP03,北海道西部,空知,JA,そらち南,10,2017,719,719,test,5290238,6731,test,60,KG\n3,Bee,JP03,3,JP03,2017,2017,1,1083449,abc,JP03,北海道西部,空知,JA,そらち南,10,2017,719,719,test,"529,023",6731,test,60,KG';
        ContentVersion cv2=new Contentversion(); 
        cv2.title='Distributor Inventory'; 
        cv2.PathOnClient ='test'; 
        Blob b2=Blob.valueOf(str2); 
        cv2.versiondata=b2; 
        insert cv2; 
        
         String str3 = 'Record Id,Sales Office Code エリア,Fiscal Year 会計年,Month 月,Distributor code 特約店名,Distributors Sales Office 特約店 営業所,Area code 県名,Material Code 商品名,Sales Org Code,Single Pack Number 袋/本数,Pesticidal Year 農年度,Price Single Bottle,AmountJPY,Single Bottle no,Calendar Year,Region,Number in case\n'+DI1.Id+',JP03,2018,1,1083449,愛知川,13,5290238,6731,241,30,1,1,1,2019,Tohoku,1';
        ContentVersion cv3=new Contentversion(); 
        cv3.title='Distributor Inventory'; 
        cv3.PathOnClient ='test'; 
        Blob b3=Blob.valueOf(str3); 
        cv3.versiondata=b3; 
        insert cv3; 
        
        String str4 = 'Record Id,Distributor Area Code 特約店の 県名,Chemical IPM 化学/IPM,Sales office for ex distributor customer 得意先の営業所エリア,Area in Ex distributors 得意先の都道府県,Sales Office Area In distributors 特約店の営業所エリア,UPL FY UPL 年度,Calender year 年,Month 月,Distributor code 特約店名,Customer Name,Distributors sales Office Code 特約店の営業所（化学のみ）,Region in exdistributors Customer 得意先ブロック（化学のみ）,District in ex distributors Customer 得意先県名（北海道は地域名）,Customer Category 得意先分類,JA Area Name JAエリア,Volume 数量（袋/本数）,Pesticidal year 農年,Price per single bottle 1本/袋の金額,Amount JPY 金額(C価)円,Order Type IPM受注伝票タイプ,Material Code （新SAP） 品目コード,Sales Org Code,Customer Address IPM出荷先住所(市区町村＋所在地),Single bottle bag Number in case 入数,UOM\n'+OGS1.Id+',13,Bee,JP03,13,JP03,2017,2017,1,1083449,abc,JP03,北海道西部,空知,JA,そらち南,10,2017,719,719,test,5290238,6731,test,60,KG\naaa,3,Bee,JP03,3,JP03,2017,2017,1,1083449,abc,JP03,北海道西部,空知,JA,そらち南,10,2017,719,719,test,"529,023",6731,test,60,KG';
        ContentVersion cv4=new Contentversion(); 
        cv4.title='Distributor Inventory'; 
        cv4.PathOnClient ='test'; 
        Blob b4=Blob.valueOf(str4); 
        cv4.versiondata=b4; 
        insert cv4; 
        
        String str5 = 'Record Id\n'+DI1.Id;
        ContentVersion cv5=new Contentversion(); 
        cv5.title='Distributor Inventory'; 
        cv5.PathOnClient ='test'; 
        Blob b5=Blob.valueOf(str5); 
        cv5.versiondata=b5; 
        insert cv5;
        system.debug('**ID to delete -> ' +DI1.Id);
        
        String str6 = 'Record Id\n'+ogs1.Id;
        ContentVersion cv6=new Contentversion(); 
        cv6.title='Distributor Inventory'; 
        cv6.PathOnClient ='test'; 
        Blob b6=Blob.valueOf(str5); 
        cv6.versiondata=b6; 
        insert cv6; 
        
         ContentVersion  testContentInsert = [select id, ContentDocumentId from ContentVersion WHERE Id =: cv1.Id];
         ContentVersion  testContentInsert2 = [select id, ContentDocumentId from ContentVersion WHERE Id =: cv2.Id];
         ContentVersion  testContentInsert3 = [select id, ContentDocumentId from ContentVersion WHERE Id =: cv3.Id];
         ContentVersion  testContentInsert4 = [select id, ContentDocumentId from ContentVersion WHERE Id =: cv4.Id];
         ContentVersion  testContentInsert5 = [select id, ContentDocumentId from ContentVersion WHERE Id =: cv5.Id];
         ContentVersion  testContentInsert6 = [select id, ContentDocumentId from ContentVersion WHERE Id =: cv6.Id];
                
        list<string> insertDIstr = new  list<string>();

         insertDIstr.add('JP03,2018,1,1083449,愛知川,13,5290238,6731,241,30,1,1,1,2019,Tohoku,1');
        
        list<string> updateDIstr = new  list<string>();

        updateDIstr.add(''+DI1.Id+',JP03,2018,1,1083449,愛知川,13,5290238,6731,241,30,1,1,1,2019,Tohoku,1');
        
        list<string> deleteDIstr = new  list<string>();

        deleteDIstr.add(DI1.Id);
        
        list<string> insertShipstr = new  list<string>();

         insertShipstr.add('13,Bee,JP03,13,JP03,2017,2017,1,1083449,abc,JP03,北海道西部,空知,JA,そらち南,10,2017,719,719,test,5290238,6731,test,60,KG');
        
        list<string> updateShipstr = new  list<string>();

        updateShipstr.add(''+OGS1.Id+',13,Bee,JP03,13,JP03,2017,2017,1,1083449,abc,JP03,北海道西部,空知,JA,そらち南,10,2017,719,719,test,5290238,6731,test,60,KG');
        
        list<string> deleteShipstr = new  list<string>();

        deleteShipstr.add(ogs1.Id);

         string insertDIHeader = 'Sales Office Code エリア,Fiscal Year 会計年,Month 月,Distributor code 特約店名,Distributors Sales Office 特約店 営業所,Area code 県名,Material Code 商品名,Sales Org Code,Single Pack Number 袋/本数,Pesticidal Year 農年度,Price Single Bottle,Amount JPY,Single Bottle No,Calendar Year,Region,Number in case';
         string updateDIHeader = 'Record Id,Sales Office Code エリア,Fiscal Year 会計年,Month 月,Distributor code 特約店名,Distributors Sales Office 特約店 営業所,Area code 県名,Material Code 商品名,Sales Org Code,Single Pack Number 袋/本数,Pesticidal Year 農年度,Price Single Bottle,Amount JPY,Single Bottle No,Calendar Year,Region,Number in case';
         string deleteHeader = 'Record Id';
         string insertShipHeader = 'Distributor Area Code 特約店の 県名,Chemical IPM 化学/IPM,Sales office for ex distributor customer 得意先の営業所エリア,Area in Ex distributors 得意先の都道府県,Sales Office Area In distributors 特約店の営業所エリア,UPL FY UPL 年度,Calender year 年,Month 月,Distributor code 特約店名,Customer Name,Distributors sales Office Code 特約店の営業所（化学のみ）,Region in exdistributors Customer 得意先ブロック（化学のみ）,District in ex distributors Customer 得意先県名（北海道は地域名）,Customer Category 得意先分類,JA Area Name JAエリア,Volume 数量（袋/本数）,Pesticidal year 農年,Price per single bottle 1本/袋の金額,Amount JPY 金額(C価)円,Order Type IPM受注伝票タイプ,Material Code （新SAP） 品目コード,Sales Org Code,Customer Address IPM出荷先住所(市区町村＋所在地),Single bottle bag Number in case 入数,UOM';
         string updateShipHeader ='Record Id,Distributor Area Code 特約店の 県名,Chemical IPM 化学/IPM,Sales office for ex distributor customer 得意先の営業所エリア,Area in Ex distributors 得意先の都道府県,Sales Office Area In distributors 特約店の営業所エリア,UPL FY UPL 年度,Calender year 年,Month 月,Distributor code 特約店名,Customer Name,Distributors sales Office Code 特約店の営業所（化学のみ）,Region in exdistributors Customer 得意先ブロック（化学のみ）,District in ex distributors Customer 得意先県名（北海道は地域名）,Customer Category 得意先分類,JA Area Name JAエリア,Volume 数量（袋/本数）,Pesticidal year 農年,Price per single bottle 1本/袋の金額,Amount JPY 金額(C価)円,Order Type IPM受注伝票タイプ,Material Code （新SAP） 品目コード,Sales Org Code,Customer Address IPM出荷先住所(市区町村＋所在地),Single bottle bag Number in case 入数,UOM';
         
      Test.startTest();  
        FileUpload_Japan.getAllRecordId();
        FileUpload_Japan.getDownloadURLForTemplates();
        FileUpload_Japan.readCSVFileDistributorInventory(testContentInsert.ContentDocumentId,'Insert');
        FileUpload_Japan.uploadDI(insertDIstr,'Insert' ,insertDIHeader);
        FileUpload_Japan.readCSVFileExDistributorShipmentData(testContentInsert2.ContentDocumentId,'Insert');
        FileUpload_Japan.uploadShipmentData(insertShipstr,'Insert' ,insertShipHeader);
        FileUpload_Japan.readCSVFileDistributorInventory(testContentInsert3.ContentDocumentId,'Update');
        FileUpload_Japan.uploadDI(updateDIstr,'Update' ,updateDIHeader);
        FileUpload_Japan.readCSVFileExDistributorShipmentData(testContentInsert4.ContentDocumentId,'Update');
        FileUpload_Japan.uploadShipmentData(updateShipstr,'Update' ,updateShipHeader);
        FileUpload_Japan.readCSVFileDistributorInventory(testContentInsert5.ContentDocumentId,'Delete');
        FileUpload_Japan.uploadDI(deleteDIstr,'Delete' ,deleteHeader);
        FileUpload_Japan.readCSVFileExDistributorShipmentData(testContentInsert6.ContentDocumentId,'Delete');
        FileUpload_Japan.uploadShipmentData(deleteShipstr,'Delete' ,deleteHeader);
      Test.stopTest(); 
    }
}