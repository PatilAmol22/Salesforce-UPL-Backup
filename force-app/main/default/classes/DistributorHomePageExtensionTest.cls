@isTest
public class DistributorHomePageExtensionTest {
   /* static testMethod void Method() {
        Id distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Auto_Number__c autObj = new Auto_Number__c();
        autObj.Name = 'FarmerCode';
        autObj.Sequence__c = '0';
        insert autObj;
        
        Trigger_Settings__c tsObj = new Trigger_Settings__c();
        tsObj.Name = 'CaseTrigger';
        tsObj.isActive__c = True;
        insert tsObj;
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        
        Account ac = new Account();
        ac.Name='Bhavik Devdhar';
        ac.Last_Name__c='Devdhar';
        ac.PriceGroupCode__c=pg.id;
        ac.SAP_Code__c='SAP996734';
        ac.RecordTypeId=distributorRecordTypeId;
        ac.Mobile__c='9967341759';
        ac.Phone='020256589';
        ac.BillingCity='Pune';
        ac.Depot_Code__c = 'PUN1';
        //  acc.OwnerId=sobj.Id;
        insert ac;
        
        contact con = new Contact();
        con.AccountId=ac.Id;
        con.LastName=ac.Last_Name__c;
        insert con;
        
        
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Regional/Zonal Mangers'];
        userrole  usrole = new userrole();
        usrole.Name ='Zonal Commercial Executive Pune';
        
        User u = new User();
        u.Alias = 'zonaa';                                                            
        u.Email = 'himanshua.mehta@skinternational.com';                             
        u.ProfileId  = p.ID;                                                     
        u.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        u.IsActive = true;  
        u.LastName='Terriotory Manager';
        u.CommunityNickname = 'zonalExe1222 Di'; 
        u.TimeZoneSidKey = 'Asia/Kolkata'; 
        // sobj1.Contact.AccountID = acc.id;// Time Zone
        u.LocaleSidKey = 'en_IN';                                    
        u.LanguageLocaleKey = 'en_US';                                             
        u.ForecastEnabled = false;                                                     
        u.EmailEncodingKey = 'ISO-8859-1';    
        u.Show_Inventory__c = false;                                                     
        u.Show_Credit_Limit__c = false; 
        u.UserRoleId=usrole.id;
        //  sobj1.ContactId=con.Id;
        insert u;
        
        
        userrole  usrole1 = new userrole();
        usrole1.Name ='Bhavik Devdhar Customer User';
        
        Profile p1 = [SELECT Id,name FROM Profile WHERE Name = 'PartnerCommunity Distributor Profile'];
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'himanshua.mehta@skinternational.com';                             
        sobj1.ProfileId  = p1.ID;                                                     
        sobj1.Username = 'zonal122_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='Terriotory Manager';
        sobj1.CommunityNickname = 'zonalExe122212Di'; 
        sobj1.TimeZoneSidKey = 'Asia/Kolkata'; 
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId=usrole1.id;
        sobj1.ContactId=con.Id;
        sobj1.ZonalCommercialExecutive__c=u.id;
        insert sobj1;
        
        Shipping_Location__c shippLoc =new Shipping_Location__c();
        shippLoc.Location_Name__c ='Same as Billing Address'; 
        shippLoc.Region__c='S.No:46/1, A1 Building, First Floor, Office No.101 E-Space, Wadgoan Sheri,Nagar Rd, Aga Nagar,';
        shippLoc.Distributor__c=ac.Id;
        shippLoc.City__c='Pune';
        shippLoc.Sold_To_Party_SAP_Code__c=ac.SAP_Code__c;
        shippLoc.SAP_Code__c='SAP0001';
        shippLoc.State__c='13';
        insert shippLoc;
        
        State_Tax_Structure__c statetax = new State_Tax_Structure__c();
        statetax.State_Name__c = 'Maharashtra';
        statetax.Country__c = 'India';          
        statetax.Tax__c = 10;           
        statetax.State_Code__c = '13';
        statetax.AdditionalTax__c = 30;      
        insert statetax;
        
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
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='1000';
        sorg.Description__c='India';
        sorg.Sales_Org_Code__c='1000';
        insert sorg;
        
        System.runas(sobj1){
  
        Account ac1 = new Account();
        ac1.Name='Bhavik Devdhar';
        ac1.Last_Name__c='Devdhar';
        ac1.PriceGroupCode__c=pg.id;
        ac1.SAP_Code__c='SAP996734';
        ac1.RecordTypeId=distributorRecordTypeId;
        ac1.Mobile__c='9967341757';
        ac1.Phone='020256589';
        ac1.BillingCity='Pune';
        ac1.Depot_Code__c = 'PUN1';
        //  acc.OwnerId=sobj.Id;
        insert ac1;
                    
            
            DistributorHomePageExtension disObj = new DistributorHomePageExtension();
            Order__c ord = new Order__c();
            ord.Shipping_Location__c = shippLoc.id;  
            ord.Bill_To_Party__c = ac.Id;        
            ord.Order_Date__c = system.today();  
            ord.Order_Raise_By__c = 'Distributor';            
            ord.VAT__c = statetax.Tax__c;                            
            ord.Order_Status__c = 'Pending';                    
            ord.Additional_Tax__c =statetax.AdditionalTax__c;                   
            ord.Sales_Org__c =sorg.Id;          
            ord.Distribution_Channel__c =disbj.Id; 
            ord.Division__c = Divbj.Id;
            ord.OwnerId=sobj1.Id;
            insert ord;
        }
        
    }*/
    static testMethod void Method() {
         Id distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
         Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Auto_Number__c autObj = new Auto_Number__c();
        autObj.Name = 'FarmerCode';
        autObj.Sequence__c = '0';
        insert autObj;
        
        Trigger_Settings__c tsObj = new Trigger_Settings__c();
        tsObj.Name = 'CaseTrigger';
        tsObj.isActive__c = True;
        insert tsObj;
        
                
        Account ac = new Account();
        ac.Name='Bhavik Devdhar';
        ac.Last_Name__c='Devdhar';
        ac.PriceGroupCode__c=pg.id;
        ac.SAP_Code__c='SAP996734';
        ac.RecordTypeId=distributorRecordTypeId;
        ac.Mobile__c='9967341759';
        ac.Phone='020256589';
        ac.BillingCity='Pune';
        ac.Depot_Code__c = 'PUN1';
        //  acc.OwnerId=sobj.Id;
        insert ac;
        
        
        contact con = new Contact();
        con.AccountId=ac.Id;
        con.LastName=ac.Last_Name__c;
        insert con;
        
        
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Regional/Zonal Mangers'];
        userrole  usrole = new userrole();
        usrole.Name ='Zonal Commercial Executive Pune';
        
        User u = new User();
        u.Alias = 'zonaa';                                                            
        u.Email = 'himanshua.mehta@skinternational.com';                             
        u.ProfileId  = p.ID;                                                     
        u.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        u.IsActive = true;  
        u.LastName='Terriotory Manager';
        u.CommunityNickname = 'zonalExe1222 Di'; 
        u.TimeZoneSidKey = 'Asia/Kolkata'; 
        // sobj1.Contact.AccountID = acc.id;// Time Zone
        u.LocaleSidKey = 'en_IN';                                    
        u.LanguageLocaleKey = 'en_US';                                             
        u.ForecastEnabled = false;                                                     
        u.EmailEncodingKey = 'ISO-8859-1';    
        u.Show_Inventory__c = false;                                                     
        u.Show_Credit_Limit__c = false; 
        u.UserRoleId=usrole.id;
        //  sobj1.ContactId=con.Id;
        insert u;
        
        
        userrole  usrole1 = new userrole();
        usrole1.Name ='Bhavik Devdhar Customer User';
        
       Profile p1 = [SELECT Id,name FROM Profile WHERE Name = 'PartnerCommunity Distributor Profile'];
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'himanshua.mehta@skinternational.com';                             
        sobj1.ProfileId  = p1.ID;                                                     
        sobj1.Username = 'zonal122_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='Terriotory Manager';
        sobj1.CommunityNickname = 'zonalExe122212Di'; 
        sobj1.TimeZoneSidKey = 'Asia/Kolkata'; 
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId=usrole1.id;
        sobj1.ContactId=con.Id;
        
        sobj1.ZonalCommercialExecutive__c=u.id;
        insert sobj1;
        
     System.runas(sobj1){
     DistributorHomePageExtension disObj = new DistributorHomePageExtension();
        Contact con1 = new Contact();
        Credit_Info__c creObj = new Credit_Info__c();
        
        Distributor_Depot_Mapping__c dpMp = new Distributor_Depot_Mapping__c();
        disObj.dpMapping=dpMp;
        Sales_Order__c ord= new Sales_Order__c();
        List<Sales_Order__c> lsOrd = new List<Sales_Order__c>();
        lsOrd.add(ord);
        disObj.orderHistoryList=lsOrd;
        
        Account_Ledger__c al = new Account_Ledger__c();
        List<Account_Ledger__c> lsAl = new List<Account_Ledger__c>();
        lsAl.add(al);
        
        disObj.conObj=con;
        disObj.creditInfoObject.add(creObj);
        disObj.AccountLedgerList = lsAl;
        
        
  
        Account ac1 = new Account();
        ac1.Name='Bhavik Devdhar';
        ac1.Last_Name__c='Devdhar';
        ac1.PriceGroupCode__c=pg.id;
        ac1.SAP_Code__c='SAP9967344';
        ac1.RecordTypeId=distributorRecordTypeId;
        ac1.Mobile__c='9967341757';
        ac1.Phone='020256589';
        ac1.BillingCity='Pune';
        ac1.Depot_Code__c = 'PUN1';
        //  acc.OwnerId=sobj.Id;
        insert ac1;
         disObj.distributorObject =ac1; 
         
        contact con2 = new Contact();
        con2.AccountId=ac1.Id;
        con2.LastName=ac.Last_Name__c;
        insert con2;
        
        //sobj1.ContactId = con2.Id;
        //update sobj1;
        
        //DistributorHomePageExtension disObj = new DistributorHomePageExtension();
                   
         
        }
    }
}