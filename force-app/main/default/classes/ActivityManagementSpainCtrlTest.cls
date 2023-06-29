@isTest 
public class ActivityManagementSpainCtrlTest{
    static testMethod void validateHelloWorld() {
       Event eventToInsert = new Event();
       Event eventToInsert2 = new Event();
              
         Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
         Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();

        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Spain';
        sorg.Description__c='Spain';
        sorg.Sales_Org_Code__c='2481';
        insert sorg;
        
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Distribution_Channel__c disbj = new Distribution_Channel__c();
        disbj.Name = '20';                      
        disbj.Distribution_Channel_Code__c = '20';  
        disbj.Description__c='test';
        insert disbj;
        
        Division__c Divbj = new Division__c();
        Divbj.Name = '10';         
        Divbj.Description__c = null;    
        Divbj.Division_Code__c = '10'; 
        insert Divbj;
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZORD';              
        ordType.Description__c = 'Spain';    
        ordType.Order_Type_Code__c = 'ZORD';
        insert ordType;
        
        
        Account acc = new Account();
        acc.Name='Nikhil';
        acc.Last_Name__c='Dhoke';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='8600687971';
        acc.Phone='020266589';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Pune';
        acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        //  acc.OwnerId=sobj.Id;
        insert acc;

        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName=acc.Last_Name__c;
        acc.RecordTypeId = conRecordTypeId;
        insert con;
        System.debug('Con: '+con);
        Spain_Portugal_Campaign__c sobj = new Spain_Portugal_Campaign__c(
          Name = 'Avancer Glow',                             // Campaign Name
          Status__c = 'Active',                                  // Status
           End_Date__c = system.today() + 1 , 
           Start_Date__c = system.today()
          
        );
        insert sobj;
        
        

        Division__c divsn2 = new Division__c();
        divsn2.Name = '60';         
        divsn2.Description__c = '60';    
        divsn2.Division_Code__c = '60'; 
        insert divsn2;
        
         RecordType shipLocRcdTp = [SELECT Id FROM RecordType WHERE name = 'Storage Location' and isActive = true LIMIT 1];
         Depot__c depo =new Depot__c ();
        depo.Name='ES51';
        depo.recordtypeId=shipLocRcdTp.id;
        depo.Country__c='Spain';
        depo.Location__c='NORTE';
        depo.Depot_Code__c='ES51';
        depo.SalesOrg__c = sorg.ID;
        depo.Plant_Desc__c= '';
        depo.Active__c = true;
        insert depo;  
        
 		Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        insert pro;
        
        SKU__c sku = new SKU__c();
        sku.Name='DOST';
        sku.SKU_Code__c='704002';
        sku.SKU_Pack__c=1.00;
        sku.SKU_UOM__c='L';
        sku.Multiple_Of__c=5;
        sku.Group__c='DOST';
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='L';
        sku.Division__c = Divbj.id;
        sku.Distribution_Channel__c = disbj.id;
        sku.Active__c=True;
        sku.Combination_Key__c='Cooooooo000011111';
        insert sku;

       
        Spain_Portugal_Campaign__c campaign = new Spain_Portugal_Campaign__c(
        Name = 'Spain',                     // Spain Portugal Campaign Name
        Start_Date__c =system.today(),  // Start Date
        End_Date__c = system.today() +1,   // End Date
        CompositeKey__c = 'C0020',                 // CompositeKey
        Status__c = 'Active'                      // Status
        );
        insert campaign;

      

       
        
        PriceBookMaster__c pbMaster = new PriceBookMaster__c(
          SKUCode__c = sku.id,                      // SKU Code
          Price__c = 45.00,                                    // Price / Max Price
          DepotCode__c = depo.id,                    // Depot Code
          Final_Price__c = 0.00,                               // Final Price
          StartDate__c = system.today(),             // Start Date
          EndDate__c = system.today() + 1,              // End Date
          UOM__c = 'L',                                        // UOM
          Division__c = Divbj.id,                     // Division
          DistributionChannel__c = disbj.id,          // Distribution Channel
          Active__c = true,                                    // Active
          PerUnit__c = 1,                                    // Per Unit
          CompositeKey__c = 'SW0625207010000000000006001071',  // CompositeKey
          Sales_Org__c = sorg.id,                    // Sales Org
          Price_Book_Change__c = false                        // Price_Book_Change
         // Customized_Product__c = false                       // Customized Product
        );
        insert pbMaster;
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
		Id regProfileId = [SELECT Id FROM Profile WHERE Name='Regional Manager/Sales Reps Spain'].Id;
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing',Country='Spian', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = regProfileId,
        TimeZoneSidKey='America/Los_Angeles',
         UserName=uniqueUserName);
         

               
       eventToInsert.Subject = 'Collection';
         eventToInsert.WhatID= acc.Id;
         eventToInsert.Account__c= acc.Id;
         eventToInsert.StartDateTime =system.TODAY();  //datetime.newInstance(2018, 11, 15, 12, 30, 0);
         eventToInsert.EndDateTime =system.TODAY()+1; //datetime.newInstance(2017, 9, 15, 12, 40, 0);
         eventToInsert.CurrencyIsoCode ='EUR';
         eventToInsert.OwnerId = UserInfo.getUserId() ;
         eventToInsert.Meeting_Purpose__c ='test purpose' ;//;
         eventToInsert.Location__c ='Indore'; 
         eventToInsert.Meeting_Notes__c = 'testNotes';
         eventToInsert.Activity_Status__c='Visited';
         eventToInsert.Spain_Portugal_Campaign__c=sobj.id;
         eventToInsert.custom_activity__c=true;
         eventToInsert.Sales_Org_Code_For_Spain__c=sorg.Sales_Org_Code__c;
         insert eventToInsert; 
        
         ActivityManagementSpainCtrl jpr;
          System.runAs(u) {
               
                Account ac = new Account();
                ac.Name='Test';
                ac.Last_Name__c='Data';
                ac.PriceGroupCode__c=pg.id;
                ac.SAP_Code__c='SAP996733';
                ac.RecordTypeId=devRecordTypeId;
                ac.Mobile__c='8600689971';
                ac.Phone='020266889';
                ac.Sales_Org__c=sorg.Id;
                ac.Division__c=Divbj.Id;
                ac.Distribution_Channel__c=disbj.Id;
                ac.BillingCity='Pune';
                ac.Order_Type__c=ordType.Id;
                ac.Depot_Code__c = 'PUN2';
                //  acc.OwnerId=sobj.Id;
                insert ac;
        
                Contact con1 = new Contact();
                con1.AccountId=ac.Id;
                con1.LastName=ac.Last_Name__c;
                ac.RecordTypeId = conRecordTypeId;
                insert con1;
				System.debug('Con1: '+con1);
               
             Event eventToIn = new Event();
             eventToIn.Subject = 'Collection';
             eventToIn.WhatID= ac.Id;
             eventToIn.Account__c= ac.Id;
             eventToIn.StartDateTime =system.TODAY();  //datetime.newInstance(2018, 11, 15, 12, 30, 0);
             eventToIn.EndDateTime =system.TODAY()+1; //datetime.newInstance(2017, 9, 15, 12, 40, 0);
             eventToIn.CurrencyIsoCode ='EUR';
             eventToIn.OwnerId = u.Id ;
             eventToIn.Meeting_Purpose__c ='test purpose' ;//;
             eventToIn.Location__c ='Indore'; 
             eventToIn.Meeting_Notes__c = 'testNotes';
             eventToIn.Activity_Status__c='Visited';
             eventToIn.Spain_Portugal_Campaign__c=sobj.id;
             eventToIn.custom_activity__c=true;
             eventToIn.Sales_Org_Code_For_Spain__c=sorg.Sales_Org_Code__c;
             insert eventToIn; 
        
              jpr = new ActivityManagementSpainCtrl();
          }

         jpr.Account = acc.id;
         jpr.account_Id = acc.id;
         jpr.Meeting_Purpose = 'Test';
         jpr.Start_Date = '2020-09-20T15:30';
         jpr.Account_Type = 'Distributor';
         jpr.End_Date = '2021-08-20T15:30';
         jpr.Meeting_Notes = 'Test';
         jpr.SelectedEventId = eventToInsert.Id;
         jpr.Activity_Type = 'Collection';
         jpr.Contact = con.Id;
         jpr.Campaign = sobj.id;
         jpr.Location = 'Location'; 
         jpr.status = 'Visited';
         jpr.Sales_Org_Code_For_Spain = sorg.Sales_Org_Code__c;
         jpr.visit_reponse = 'Red'; // new..
         
         jpr.CreateEvents();
         jpr.getAccountByRecordType();
         jpr.getAccountDetails();
         jpr.searchAccount();
        
         Attachment attach = new Attachment();
    	 //attachment.ParentId = acc.id;
    	 Blob b = Blob.valueOf('Test Data');
    	 attach.Name = 'Test Attachment for Parent';
    	 attach.Body = b;
        
         jpr.attachmentToDelete = attach.Id;
         jpr.deleteAttachment();

         ActivityManagementSpainCtrl jpr2;
          System.runAs(u) {
              jpr2 = new ActivityManagementSpainCtrl();
          }
        
         //jpr2.Account = acc.id;
         jpr2.account_Id = acc.id;
         jpr2.Meeting_Purpose = 'Test';
         jpr2.Start_Date = '2020-09-20T15:30';
         jpr2.Account_Type = 'Distributor';
         jpr2.End_Date = '2021-08-20T15:30';
         jpr2.Meeting_Notes = 'Test';
         jpr2.SelectedEventId = eventToInsert2.Id;
         jpr2.Activity_Type = 'Collection';
         jpr.Contact = con.Id;
         jpr2.Campaign = sobj.id;
         jpr2.Location = 'Location'; 
         jpr2.status = 'Visited';
         jpr2.Sales_Org_Code_For_Spain = sorg.Sales_Org_Code__c;
         jpr2.visit_reponse = 'Red'; // new..
         

         jpr2.CreateEvents();
         jpr2.getAccountByRecordType();
         jpr2.getAccountDetails();
         jpr2.searchAccount();
         
         }
                              
    
}