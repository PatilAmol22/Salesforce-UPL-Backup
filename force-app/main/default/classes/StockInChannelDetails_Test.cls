@isTest(seeAllData=false)
public class StockInChannelDetails_Test {
    
    static testMethod void CallStockInChannelDetails()
    {
        //User usr = TestDataFactory.CreateUser();
        StockInChannel_Test.insertUser();
        user usr = [select id from user limit 1];
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        Account acc = TestDataFactory.CreateAccount('SAP996734');
        acc.OwnerId = usr.id;
        acc.Sales_Org__c = sorg.id; 
        update acc;
        Zone__c zn = TestDataFactory.CreateZone();
        Territory_Distributor__c tr =TestDataFactory.CreateTerritory(zn,usr,sorg) ;
        Stock_In_Channel__c sic = TestDataFactory.CreateStockInChannel(acc,'51912018','2019');
        Stock_In_Channel__c sic2 = TestDataFactory.CreateStockInChannel(acc,'5191201811','2019');
        SKU__c skuo = TestDataFactory.CreateSKU('sku001',sorg,'3213456796854');
        SKU__c skuo2 = TestDataFactory.CreateSKU('sku002',sorg,'3213456796541');
        Stock_In_Channel_Detail__c sicd= new Stock_In_Channel_Detail__c();
        sicd.Stock_In_Channel__c= sic.Id;
        sicd.SKU__c= skuo.id;
        insert sicd;
        Stock_In_Channel_Detail__c sicd2= new Stock_In_Channel_Detail__c();
        sicd2.Stock_In_Channel__c= sic2.Id;
        insert sicd2;
        insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18,Company_Code__c='5190');	
        
        StockInChannelDetails.SKUPaginationWrapper sk = new StockInChannelDetails.SKUPaginationWrapper();
        sk = StockInChannelDetails.getallSKU(string.valueOf(sic.id), 'January', 'December', 'November', true, string.valueOf(acc.id));
        sk = StockInChannelDetails.getallSKU(null, 'January', 'December', 'November', false, string.valueOf(acc.id));
        sk = StockInChannelDetails.getallSKU(string.valueOf(sic.id), 'January', 'December', 'November', false, string.valueOf(acc.id));
        sk = StockInChannelDetails.getallSKU(string.valueOf(sic.id), 'February','January', 'December', false, string.valueOf(acc.id));
        sk = StockInChannelDetails.getallSKU(null, 'February','January', 'December', false, string.valueOf(acc.id));
        sk = StockInChannelDetails.getallSKU(null, 'March','February','January', false, string.valueOf(acc.id));
        sk = StockInChannelDetails.getallSKU(string.valueOf(sic.id), 'March','February','January', false, string.valueOf(acc.id));
        Test.startTest();
        String upSIC= StockInChannelDetails.upsertStockInChannelDetails(string.valueOf(skuo.id), 0, 0, 0, '', string.valueOf(acc.id), string.valueOf(tr.id), 'January', 'December', 'November');
        StockInChannelDetails.resetStockMethod(null,'February','January', 'December');
        StockInChannelDetails.copyStockMethod(null,'February','January', 'December');
        String UnsertSICD= StockInChannelDetails.UnsertStockInChannelDetails('temp','temp','test',string.valueOf(sic.id),string.valueOf(acc.id), string.valueOf(tr.id),'January', 'December', 'November');
        UnsertSICD= StockInChannelDetails.UnsertStockInChannelDetails('temp','temp','test',string.valueOf(sic.id),string.valueOf(acc.id), string.valueOf(tr.id),'February','January', 'December');    
        String SICDM= StockInChannelDetails.upsertStockInChannelDetailsMonth(string.valueOf(skuo.id),10,string.valueOf(sic.id),string.valueOf(acc.id),string.valueOf(tr.id),'October');
        SICDM= StockInChannelDetails.upsertStockInChannelDetailsMonth(string.valueOf(skuo.id),10,'',string.valueOf(acc.id),string.valueOf(tr.id),'October');
        Test.stopTest();
        
    }
    
    static testMethod void CallStockInChannelDetails2()
    {
        //
        //User usr = TestDataFactory.CreateUser();
        StockInChannel_Test.insertUser();
        user usr = [select id from user limit 1];
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        Account acc = TestDataFactory.CreateAccount('SAP996734');
        acc.OwnerId = usr.id;
        acc.Sales_Org__c = sorg.id; 
        update acc;
        Zone__c zn = TestDataFactory.CreateZone();
        Territory_Distributor__c tr =TestDataFactory.CreateTerritory(zn,usr,sorg);
        Stock_In_Channel__c sic = TestDataFactory.CreateStockInChannel(acc,'5191201822','2019');
        Stock_In_Channel__c sic2 = TestDataFactory.CreateStockInChannel(acc,'5191201811','2019');     
        SKU__c skuo = TestDataFactory.CreateSKU('sku001',sorg,'3213456796854');
        SKU__c skuo2 = TestDataFactory.CreateSKU('sku002',sorg,'3213456796541');
        Stock_In_Channel_Detail__c sicd= new Stock_In_Channel_Detail__c();
        sicd.Stock_In_Channel__c= sic.Id;
        insert sicd;
        insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18,Company_Code__c='5190');	
        StockInChannelDetails.SKUPaginationWrapper sk = new StockInChannelDetails.SKUPaginationWrapper();
        String upSIC= StockInChannelDetails.upsertStockInChannelDetails(string.valueOf(skuo.id), 0, 0, 0, '', string.valueOf(acc.id), string.valueOf(tr.id), 'January', 'December', 'November');    
    }
    
    
    static testMethod void CallStockInChannelDetails3()
    {
        StockInChannel_Test.insertUser();
        user usr = [select id from user limit 1];
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        Account acc = TestDataFactory.CreateAccount('SAP99673334');
        acc.OwnerId = usr.id;
        acc.Sales_Org__c = sorg.id; 
        update acc;
        Zone__c zn = TestDataFactory.CreateZone();
        Territory_Distributor__c tr =TestDataFactory.CreateTerritory(zn,usr,sorg) ;    
        Stock_In_Channel__c sic = TestDataFactory.CreateStockInChannel(acc,'5191201822','2020');
        SKU__c skuo = TestDataFactory.CreateSKU('sku001',sorg,'3213456796854');
        Stock_In_Channel_Detail__c sicd= new Stock_In_Channel_Detail__c();
        sicd.Stock_In_Channel__c= sic.Id;
        insert sicd;
        
        insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18,Company_Code__c='5190');	
        
        String SICDM = StockInChannelDetails.upsertStockInChannelDetails(string.valueOf(skuo.id), 0, 0, 0, '', string.valueOf(acc.id), string.valueOf(tr.id), 'February','January', 'December');
        SICDM= StockInChannelDetails.UnsertStockInChannelDetails('temp','temp','test',string.valueOf(sic.id),string.valueOf(acc.id), string.valueOf(tr.id),'February','January', 'December');    
        SICDM= StockInChannelDetails.UnsertStockInChannelDetails('temp','temp','test',string.valueOf(sic.id),string.valueOf(acc.id), string.valueOf(tr.id),'March','January', 'December');    
        delete acc;
        delete sic;
        Test.startTest();
        Account acc2 = TestDataFactory.CreateAccount('SAP996733sfds34');
        acc2.OwnerId = usr.id;
        acc2.Sales_Org__c = sorg.id; 
        update acc2;
        Stock_In_Channel__c sic2 = TestDataFactory.CreateStockInChannel(acc2,'51912018112','2019');
        Stock_In_Channel_Detail__c sicd2= new Stock_In_Channel_Detail__c();
        sicd2.Stock_In_Channel__c= sic2.Id;
        insert sicd2;
        SICDM = StockInChannelDetails.upsertStockInChannelDetails(string.valueOf(skuo.id), 0, 0, 0, string.valueOf(sic2.id), string.valueOf(acc2.id), string.valueOf(tr.id), 'March','January', 'December');
        SICDM= StockInChannelDetails.UnsertStockInChannelDetails('temp','temp','test','',string.valueOf(acc2.id), string.valueOf(tr.id),'March','January', 'December');    
        delete acc2;
        Account acc3 = TestDataFactory.CreateAccount('SSSSAP996733sfds34');
        acc3.OwnerId = usr.id;
        acc3.Sales_Org__c = sorg.id; 
        update acc3;
        SICDM= StockInChannelDetails.upsertStockInChannelDetails(string.valueOf(skuo.id), 0, 0, 0, '', string.valueOf(acc3.id), string.valueOf(tr.id), 'February','January', 'December');
        StockInChannelDetails.SICExceptionWrapper SICw = StockInChannelDetails.SICSKUExc(string.valueOf(skuo.id),string.valueOf(acc3.id));
    	Test.stopTest();
    }   
    
}