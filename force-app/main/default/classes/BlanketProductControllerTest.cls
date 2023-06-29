@isTest
public class BlanketProductControllerTest {
    
    
    @isTest
    static void testgetAllActiveSku(){
      User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
     LastName = 'lastname',
     Email = 'testName@test.com',
     Username = 'test@test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST1',
     Title = 'title1',
     Alias = 'T1',
     country='HO',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
);
        insert u;
       
        Login_Country__c lc=new Login_Country__c();
        lc.Name='HO';
        lc.For_Contry__c='HO';
        lc.Sales_Org_Code__c='5191';
        insert lc;
        
        Distribution_Channel__c dc=new Distribution_Channel__c();
        dc.Distribution_Channel_Code__c='10';
        insert dc;
        
        Division__c d=new Division__c();
        d.Division_Code__c='10';
        insert d;
        
        Sales_Org__c so=new Sales_Org__c();
        so.Name='HO';
        so.Sales_Org_Code__c='5191';
        
        insert so;
        
         List<SKU__c> skuList=new List<SKU__c>();
        
        SKU__c sk=new SKU__c();
        sk.Name='15X111';
        sk.Active__c=true;
        sk.Combination_Key__c='11111111111';
        sk.Sales_Org__c=so.Id;
        sk.SKU_Code__c='000000000006250502';
        insert sk;        
      
        List<Blanket_SKU__c> bskuList=new List<Blanket_SKU__c>();
       
        
        Blanket_SKU__c bsku=new Blanket_SKU__c();
        bsku.Start_Date__c=Date.today();
        bsku.End_Date__c=Date.today();
        bsku.Status__c=true;
        bsku.Combination_Key__c=sk.Combination_Key__c;
        bsku.SKU__c=sk.Id;
        bsku.Sales_Org__c=so.Id;
        bsku.Expired_Reason__c='Near Expiry SKU';
        insert bsku;
        List<Blanket_SKU__c> blanketList =[Select Id,SKU__r.Name,Combination_Key__c,Sales_Org__r.Sales_Org_Code__c,Start_Date__c,End_Date__c,Status__c FROM Blanket_SKU__c where Combination_Key__c =: sk.Combination_Key__c ];

       
        BlanketProductController.wrapperClass wc=new BlanketProductController.wrapperClass();
         wc.skuName='15X111';
         wc.combinationKey='11111111111';
         wc.skuStatus=true;
         wc.startDate=Date.today();
         wc.endDate=Date.today();
         wc.Id=sk.Id;
         wc.Type1='Near Expiry SKU';
         wc.salesOrgName=so.Name;
         
        
          String str = 'SKU Code;Combination Key;Start Date;End Date;Status;Expired Reason\n000000000006250502;11111111111;2022-08-01;2022-08-01;true;Near Expiry SKU';
          ContentVersion cv=new Contentversion(); 
          cv.title='BlanketSku';
          cv.PathOnClient ='test'; 
          Blob b=Blob.valueOf(str); 
          cv.versiondata=b; 
          insert cv;
        
         List<SKU__c> skuObjList=[Select Id,Name,Combination_Key__c,Sales_Org__c FROM SKU__c]; 
         List<Blanket_SKU__c> blankList =[Select Id,SKU__r.Name,Combination_Key__c,Sales_Org__r.Sales_Org_Code__c,Start_Date__c,End_Date__c,Status__c,Expired_Reason__c FROM Blanket_SKU__c ];
          Map<String,SKU__c> skuMap=new Map<String,SKU__c>();
          for(SKU__c sk1:skuObjList){
                    skuMap.put(sk1.Combination_Key__c,sk1); 
                }
         
         Map<String,Blanket_SKU__c> blanketSkuMap=new Map<String,Blanket_SKU__c>();
            for(Blanket_SKU__c blankSku:blankList){
                    blanketSkuMap.put(blankSku.Combination_Key__c,blankSku); 
                }        

         ContentVersion  testContentInsert = [select id, ContentDocumentId from ContentVersion WHERE Id =: cv.Id];
        
        List<string> errorList=new List<string>();
        List<string> successList=new List<string>();
        List<string> pickListVal=new List<string>();

         Test.startTest();
         BlanketProductController.wrapperClass wcBlanket=new BlanketProductController.wrapperClass();
         BlanketProductController.getAllActiveSku();
         BlanketProductController.updateSku('[{"startDate": "2022-09-07", "endDate": "2022-09-07", "skuStatus": true, "Id": "a1C5D0000019k4WUAQ","Type1":"Near Expiry SKU"}]');
         BlanketProductController.updateSku('[{"startDate": "2022-09-07", "endDate": "2021-09-07", "skuStatus": true, "Id": "a1C5D0000019k4WUAQ","Type1":""}]');
         BlanketProductController.getBlanketSkuBySearch(sk.Id, '2022-08-20', '2022-08-20', 'true');
         BlanketProductController.getBlanketSkuBySearch('', '', '', '');
         BlanketProductController.getSalesOrg();
         BlanketProductController.formatDate(Date.Today());
         skuObjList.add(sk);
         blankList.add(bsku);
         blanketList.add(bsku);
         skuList.add(sk);
         blanketList.add(bsku);
        
         skuMap.put(sk.Combination_Key__c,sk);
         blanketSkuMap.put(bsku.Combination_Key__c,bsku); 
         BlanketProductController.populateCsvData('000000000006250502,11111111111, 2022-08-20, 2020-08-20, false,Near Expiry SKU', skuMap,blanketSkuMap,errorList,successList,pickListVal);
         BlanketProductController.populateCsvData('000000000006250502,11111111111, 2022-08-20, 2022-08-20, active,Near Expiry SKU',skuMap,blanketSkuMap,errorList,successList,pickListVal);
         BlanketProductController.populateCsvData('11111111111,test123,000000000006250502, 2022-08-20, 2022-08-20, true,null',skuMap,blanketSkuMap,errorList,successList,pickListVal);
         BlanketProductController.uploadDownloadedCsvFile(testContentInsert.ContentDocumentId);
        BlanketProductController.sendMail('err', 'scc', 0, 1, 'abcd');
         Test.stopTest();
    }

}