@isTest
public class SICCustomerUploadTest {
    

    @testSetup static void setup() {
        document doc=new document();
        doc.Name='SICCustomer';
        doc.FolderId= UserInfo.getUserId();
        insert doc;
        
        document doc1=new document();
        doc1.Name='SICSalesRepSKUException';
        doc1.FolderId= UserInfo.getUserId();
        insert doc1;
        
         document doc2=new document();
        doc2.Name='SICSalesRepException';
        doc2.FolderId= UserInfo.getUserId();
        insert doc2;
        
        
    }
      static testMethod void PCUCTestCall(){  
       string template = SICCustomerUpload.getDocument();
       String regCodeMV='2020;123;Add'+'\n'+'2020;SAP99673;Add';  
       SICCustomerUpload.passFile(regCodeMV); 
          
      
       string template1 = SICSalesRepSKUEntry.getDocument();
        
        StockInChannel_Test.insertUser();
        user usr = [select id from user limit 1];
          usr.TM_Code__c = '11';
          //update usr;
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        Account acc = TestDataFactory.CreateAccount('SAP996734');
        acc.OwnerId = usr.id;
        acc.Sales_Org__c = sorg.id; 
        acc.SAP_Code__c = 'SAP996734';
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
            insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
        
        SKU__c skuo = TestDataFactory.CreateSKU('sku001',sorg,'3213456796854');
       String regCodeMV1='2020;123;Add;45;67'+'\n'+'SAP996734;11;3213456796854;07;2020';  
       SICSalesRepSKUEntry.passFile(regCodeMV1);
          
          SICSalesRepEntry.getDocument();
           String regCodeMV2='2020'+'\n'+'11';  
       SICSalesRepEntry.passFile(regCodeMV2);
          
          
      }

}