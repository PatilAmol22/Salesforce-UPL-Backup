@isTest 
public class ProductCatalogControllerTest {
    public static TestMethod void validateHelloWorld() {

        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
      
         Sales_Org__c sorg =new Sales_Org__c();
         sorg.Name='2520';
         sorg.Description__c='Spain';
         sorg.Sales_Org_Code__c='2520';
         insert sorg;

         Account acc = new Account();
         acc.Name='Nikhil';
         acc.Last_Name__c='Dhoke';
         acc.SAP_Code__c='SAP996734';
         acc.RecordTypeId=devRecordTypeId;
         acc.Mobile__c='8600687971';
         acc.Phone='020266589';
         acc.Sales_Org__c=sorg.Id;
         
         acc.BillingCity='Mumbai';
         acc.Depot_Code__c = 'MUM';
         acc.Account_Type__c = 'Sold To Party';
         //  acc.OwnerId=sobj.Id;
         insert acc;

         contact con = new Contact();
         con.AccountId=acc.Id;
         con.LastName=acc.Last_Name__c;
         insert con;
    
         Profile p = [SELECT Id,name FROM Profile WHERE Name = 'PartnerCommunity Distributor Profile'];
         userrole  usrole = new userrole();
        usrole.Name ='Customer User';

        User sobj1 = new User();
        sobj1.ProfileId  = p.ID;  
        sobj1.UserRoleId=usrole.id; 
        sobj1.ContactId=con.Id;
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'test@skinternational.com';                             
        sobj1.Username = 'test@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='Terriotory Manager';
        sobj1.CommunityNickname = 'zonalExe1222 Di'; 
        sobj1.TimeZoneSidKey = 'Asia/Kolkata'; 
        // sobj1.Contact.AccountID = acc.id;// Time Zone
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.Country = 'Columbia';
        insert sobj1;

        Product_URL__c prdURL = new Product_URL__c();
        
        prdURL.name='Columbia';
        prdURL.URL__c='https://co.uplonline.com/api/products-categories-targets';
        insert prdURL;

        system.runAs(sobj1){
            Test.startTest();
            ProductCatalogController.CropWrapper crpWrap = new ProductCatalogController.CropWrapper();
            ProductCatalogController.PestDiseaseWrapper pestWrap = new ProductCatalogController.PestDiseaseWrapper();
            ProductCatalogController.DownloadWrapper dwnWrap = new ProductCatalogController.DownloadWrapper();
            
            Test.setMock(HttpCalloutMock.class, new ProductCatalogMock2());
            ProductCatalogController.ProductWrapper proWrap = ProductCatalogController.getProductDetails('devrinol-450-sc');

            Test.setMock(HttpCalloutMock.class, new ProductCatalogMock1());
            List<ProductCatalogController.ProductWrapper> firstDrpDwn = ProductCatalogController.getFirstDropDown();
            List<ProductCatalogController.ProductWrapper> secndDrpDwn = ProductCatalogController.getSecondDropDown('1');
            List<ProductCatalogController.ProductWrapper> thrdDrpDwn = ProductCatalogController.getThirdDropDown('1','2');
            
            Test.setMock(HttpCalloutMock.class, new ProductCatalogMock1());
            List<ProductCatalogController.ProductWrapper> allproducts = ProductCatalogController.getProducts('1','2','1');
            
            Test.stopTest();
            
        }
    }
}