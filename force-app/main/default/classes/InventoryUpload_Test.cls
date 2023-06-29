@isTest(seeAllData =false)
public class InventoryUpload_Test {
    
    static testMethod void CallInventoryUpload()
    {
        Document d = TestDataFactory.CreateDocument();
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        StockInChannel_Test.insertUser();
        user usr = [select id,email from user limit 1];
        Account acc = TestDataFactory.CreateAccount('0001046736');
        acc.OwnerId = usr.id;
        acc.Sales_Org__c = sorg.id; 
        update acc;
        
        Zone__c zn = TestDataFactory.CreateZone();
        Territory_Distributor__c tr =TestDataFactory.CreateTerritory(zn,usr,sorg) ;
        Division__c DivObj = new Division__c();
        DivObj.Name = '10';         
        DivObj.Description__c = null;    
        DivObj.Division_Code__c = '10'; 
        insert DivObj;
        
        Distribution_Channel__c disObj = new Distribution_Channel__c();
        disObj.Name = '20';                      
        disObj.Distribution_Channel_Code__c = '20';  
        disObj.Description__c='test';
        insert disObj;
        Customer_and_Region_Mapping__c crmObj =  new Customer_and_Region_Mapping__c();
        crmObj.Customer_Name__c = acc.Id;
        crmObj.Sales_Org__c =sorg.Id;   
        crmObj.Division__c = DivObj.Id;
        crmObj.Distribution_Channel__c = disObj.Id;
        //crmObj.CustomerRegion__c=sorg.Id;
        crmObj.CustomerRegion__c =tr.Id;
        insert crmObj;
        
        InventoryUpload.SalesRepCSVTemplate inrCls =new InventoryUpload.SalesRepCSVTemplate();
        inrCls.Year='2022';
        inrCls.Month=1;
        inrCls.CustomerCode='0000002';
        inrCls.SKUCode='000000000006305754';
        inrCls.Volume=2.0;
        SKU__c sk = TestDataFactory.CreateSKU('000000000006305754',sorg,'100000000');
        insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
        Boolean temp;
        InventoryUpload.getDataAsCSV();
        InventoryUpload.getCustomer('Brazil',usr.id);  
        temp=InventoryUpload.submitDate(30);
        InventoryUpload invUpl = new InventoryUpload();
        invUpl= InventoryUpload.checkAccess();
        String results;
        String file='2019,September,1046736,6305754,123,\n2019,September,1046736,6305754,123 \n 2019,June,1046736,6305754,123212,\n';
        results= InventoryUpload.passFile(file,'upl');
        String file2='abcd,1111,1046736,6305754,123,\nabbb,1234,,,12aa3212,\n';
        results= InventoryUpload.passFile(file2,'upp');
        
    }
     static testMethod void CallInventoryUpload1()
    {
        Document d = TestDataFactory.CreateDocument();
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        StockInChannel_Test.insertUser();
        user usr = [select id from user limit 1];
        system.runAs(usr){
        Account acc = TestDataFactory.CreateAccount('0001046736');
        acc.OwnerId = usr.id;
        acc.Sales_Org__c = sorg.id; 
        update acc;
        
        Zone__c zn = TestDataFactory.CreateZone();
        Territory_Distributor__c tr =TestDataFactory.CreateTerritory(zn,usr,sorg) ;
        Division__c DivObj = new Division__c();
        DivObj.Name = '10';         
        DivObj.Description__c = null;    
        DivObj.Division_Code__c = '10'; 
        insert DivObj;
        
        Distribution_Channel__c disObj = new Distribution_Channel__c();
        disObj.Name = '20';                      
        disObj.Distribution_Channel_Code__c = '20';  
        disObj.Description__c='test';
        insert disObj;
        Customer_and_Region_Mapping__c crmObj =  new Customer_and_Region_Mapping__c();
        crmObj.Customer_Name__c = acc.Id;
        crmObj.Sales_Org__c =sorg.Id;   
        crmObj.Division__c = DivObj.Id;
        crmObj.Distribution_Channel__c = disObj.Id;
        //crmObj.CustomerRegion__c=sorg.Id;
        crmObj.CustomerRegion__c =tr.Id;
        insert crmObj;
        
        InventoryUpload.SalesRepCSVTemplate inrCls =new InventoryUpload.SalesRepCSVTemplate();
        inrCls.Year='2022';
        inrCls.Month=1;
        inrCls.CustomerCode='0000002';
        inrCls.SKUCode='000000000006305754';
        inrCls.Volume=2.0;
      //  SKU__c sk = TestDataFactory.CreateSKU('000000000006305754',sorg,'100000000');
        insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
        Boolean temp;
        InventoryUpload.getDataAsCSV();
        InventoryUpload.getCustomer('Brazil',usr.id);  
        temp=InventoryUpload.submitDate(30);
        InventoryUpload invUpl = new InventoryUpload();
        invUpl= InventoryUpload.checkAccess();
        String results;
        String file='2019,September,1046736,6305754,123,\n2019,September,1046736,6305754,123 \n 2019,June,1046736,6305754,123212,\n';
        results= InventoryUpload.passFile(file,'upl');
        String file2='abcd,1111,1046736,6305754,123,\nabbb,1234,,,12aa3212,\n';
        results= InventoryUpload.passFile(file2,'upp');
    }
    }
    @future
    public static void insertUser() {
         User usr = TestDataFactory.CreateUser();
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Brazil Sales Person'];
        usr.profileid = p.id;
       if(System.IsBatch() == false && System.isFuture() == false){ 
     		update usr;
		}
    }
}