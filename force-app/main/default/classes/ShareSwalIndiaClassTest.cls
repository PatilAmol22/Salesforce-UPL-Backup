@isTest
public class ShareSwalIndiaClassTest {
 static testMethod void method() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        
        userrole  usrole = new userrole();
        usrole.Name ='Custom Role';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Territory Manager'];
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'himanshua.mehta@skinternational.com';                             
        sobj1.ProfileId  = p.ID;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='Terriotory Manager';
        sobj1.CommunityNickname = 'zonalExe1222 Di'; 
        sobj1.TimeZoneSidKey = 'Asia/Kolkata'; 
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId=usrole.id;
        insert sobj1;
        
        User sobj2 = new User();
        sobj2.Alias = 'zonaa2';                                                            
        sobj2.Email = 'abhishek.verma@skinternational.com';                             
        sobj2.ProfileId  = p.ID;                                                     
        sobj2.Username = 'verma9931@upl122333.com.devbox';                                    
        sobj2.IsActive = true;  
        sobj2.LastName=' Manager';
        sobj2.CommunityNickname = 'zonalExe1223 Di'; 
        sobj2.TimeZoneSidKey = 'Asia/Kolkata'; 
        sobj2.LocaleSidKey = 'en_IN';                                    
        sobj2.LanguageLocaleKey = 'en_US';                                             
        sobj2.ForecastEnabled = false;                                                     
        sobj2.EmailEncodingKey = 'ISO-8859-1';    
        sobj2.Show_Inventory__c = false;                                                     
        sobj2.Show_Credit_Limit__c = false; 
        sobj2.UserRoleId=usrole.id;
        insert sobj2;
        
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Depot__c dp =new Depot__c ();
        dp.Name='Pune';
        dp.Country__c='India';
        dp.Location__c='Pune';
        dp.Depot_Code__c='PUN1';
        insert dp;
        
        Product2 pro = new Product2();
        pro.ProductCode = '66700';
        pro.Product_Code__c='66700';
        pro.Name='DOST';
        pro.popular__c = true;
        pro.Combination_Key__c='RM0065100';
        insert Pro;
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='India';
        sorg.Description__c='India';
        sorg.Sales_Org_Code__c='1000';
        insert sorg;
        
        Sales_Org__c sorg1 =new Sales_Org__c();
        sorg1.Name='SWAL';
        sorg1.Description__c='SWAL';
        sorg1.Sales_Org_Code__c='1210';
        insert sorg1;
        
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
        
   /*     SKU__c sku = new SKU__c();
        sku.Name='DOST';
        sku.SKU_Code__c='704002';
        sku.SKU_Pack__c=1.00;
        sku.SKU_UOM__c='L';
        sku.Group__c='DOST';
        sku.Pack_Size__c=10.00;
        sku.Product_Name__c=pro.Id;
        sku.Sales_Org__c = sorg.Id;
        sku.UOM__c='L';
        sku.Active__c=True;
        sku.GST__c=18;
        sku.Combination_Key__c='Cooooooo000011111';
        insert sku;
        
        PriceBookMaster__c PbMaster = new PriceBookMaster__c();
        PbMaster.SKUCode__c = sku.id;           
        PbMaster.DepotCode__c =dp.id;         
        PbMaster.Price__c = 34500;                    
        PbMaster.PG_CODE__c =Pg.Id;  
        PbMaster.UOM__c = 'NOS';                          
        PbMaster.StartDate__c = system.today();
        PbMaster.EndDate__c = system.today()+1;
        PbMaster.Active__c = true;                      
        PbMaster.PerUnit__c = 1;                       
        PbMaster.Batch__c ='test'; 
        PbMaster.CompositeKey__c='c1';
        insert PbMaster; */
        
        Order_Type__c ordType =new Order_Type__c();
        ordType.Name = 'ZORD';              
        ordType.Description__c = 'India';    
        ordType.Order_Type_Code__c = 'ZORD';
        insert ordType;
        
        Account acc = new Account();
        acc.Name='Distributor Account';
        acc.Last_Name__c='Distributor Account';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='9999999999';
        acc.Phone='020256589';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Pune';
        acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        acc.OwnerId = sobj2.Id;
        insert acc;
        system.debug('acc-->'+acc.ownerID);
        
        DistributorSalesAreaMapping__c   sales1 = new DistributorSalesAreaMapping__c();
        sales1.AccountOwner__c = sobj1.id;
        sales1.Distributor__c = acc.id;
        sales1.SalesOrg__c= sorg1.id;
        sales1.Division__c = divbj.id;
        sales1.DistributionChannel__c=disbj.Id;
        insert sales1;
       DistributorSalesAreaMapping__c dsal =[select id, name, AccountOwner__c,Distributor__c, CurrentAccountOwner__c, OwnerDosentMatch__c from DistributorSalesAreaMapping__c 
                                                                                                    where id=: sales1.id];
        system.debug('dsal -> '+dsal.OwnerDosentMatch__c);
         ShareSwalIndiaClass sh = new ShareSwalIndiaClass();  
         //for trigger and class
        sales1.AccountOwner__c = sobj2.id; 
        update sales1;                                                                                       
               
       }
  }