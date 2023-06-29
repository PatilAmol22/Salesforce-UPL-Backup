@isTest
public class AccountLedgerMobTest {
    static testMethod void Method() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='1000';
        sorg.Description__c='India';
        sorg.Sales_Org_Code__c='1000';
        insert sorg;
        
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Trigger_Settings__c tsObj = new Trigger_Settings__c();
        tsObj.Name = 'CaseTrigger';
        tsObj.isActive__c = True;
        insert tsObj;
        
        
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
        ordType.Description__c = 'India';    
        ordType.Order_Type_Code__c = 'ZORD';
        insert ordType;
        
        
        Account acc = new Account();
        acc.Name='Bhavik Devdhar';
        acc.Last_Name__c='Devdhar';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='9967341759';
        acc.Phone='020256589';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Pune';
        acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        //  acc.OwnerId=sobj.Id;
        insert acc;
        
       
        
        contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName=acc.Last_Name__c;
        insert con;
        
     /*   userrole  usrole = new userrole();
        usrole.Name ='Bhavik Devdhar Customer User';
        
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'PartnerCommunity Distributor Profile'];
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'himanshua.mehta@skinternational.com';                             
        sobj1.ProfileId  = p.ID;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='Terriotory Manager';
        sobj1.CommunityNickname = 'zonalExe1222 Di'; 
        sobj1.TimeZoneSidKey = 'Asia/Kolkata'; 
        // sobj1.Contact.AccountID = acc.id;// Time Zone
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId=usrole.id;
        sobj1.ContactId=con.Id;
        insert sobj1;
        AccountLedgerMob accLedgeObj = new AccountLedgerMob();
        accLedgeObj.createCaseAccountLedger();*/
        
        
        User userobj = new User();
        userobj.ProfileID = [Select Id From Profile Where Name='PartnerCommunity Distributor Profile'].id;
        userobj.EmailEncodingKey = 'ISO-8859-1';
        userobj.LanguageLocaleKey = 'en_US';
        userobj.TimeZoneSidKey = 'America/New_York';
        userobj.LocaleSidKey = 'en_US';
        userobj.FirstName = 'first';
        userobj.LastName = 'last';
        userobj.Username = 'test@appirio.com';   
        userobj.CommunityNickname = 'testUser123';
        userobj.Alias = 't1';
        userobj.Email = 'no@email.com';
        userobj.IsActive = true;
        userobj.ContactId = con.Id;
        //userobj.AccountId = ba.Id;
        insert userobj;
        User userobj2 = [Select Id,Name,AccountId,ContactID from User Where id =: userobj.Id];
 
        System.runas(userobj2){
            
         /*   
            userrole  usrole1 = new userrole();
            usrole1.Name ='Executive';*/
         
  /*  User userobj1 = new User();
        userobj1.ProfileID = [Select Id From Profile Where Name='Executive'].id;
        userobj1.EmailEncodingKey = 'ISO-8859-1';
        userobj1.LanguageLocaleKey = 'en_US';
        userobj1.TimeZoneSidKey = 'America/New_York';
        userobj1.LocaleSidKey = 'en_US';
        userobj1.FirstName = 'first';
        userobj1.LastName = 'last';
        userobj1.Username = 'test@appirio.com';   
        userobj1.CommunityNickname = 'testUser123';
        userobj1.Alias = 't1';
        userobj1.Email = 'no@email.com';
        userobj1.IsActive = true;
        insert userobj1;*/
            
             
            Account_Ledger__c accLedge = new Account_Ledger__c();
            accLedge.Customer__c = acc.id;          
            accLedge.Doc_Amount__c = 1000;                    
            accLedge.Doc_Number__c = 'DOC1';                      
            accLedge.Doc_Type__c = 'D1';                         
            accLedge.Posting_Date__c = system.today();
            accLedge.Due_Date__c =system.today();
            insert accLedge;
            
            Account_Ledger__c accLedge1 = new Account_Ledger__c();
            accLedge1.Customer__c = acc.id;          
            accLedge1.Doc_Amount__c = 1000;                    
            accLedge1.Doc_Number__c = 'DOC1';                      
            accLedge1.Doc_Type__c = 'D1';                         
            accLedge1.Posting_Date__c = system.today();
            accLedge1.Due_Date__c =system.today();
            insert accLedge1;
            
       AccountLedgerMob accLedgeObj =new AccountLedgerMob();    
            accLedgeObj.StartDate = system.today();
            accLedgeObj.EndDate = system.today();
            AccountLedgerMob.AccountLedgerWrapper wrappaccledge = new AccountLedgerMob.AccountLedgerWrapper(accLedge);
            wrappaccledge.selected=true;
            
          
            accLedgeObj.processSelected();
            accLedgeObj.selectedContacts.add(accLedge);
            accLedgeObj.getLoadAccountLedger();
            accLedgeObj.processSelected();
            accLedgeObj.selectedContacts.add(accLedge);
            accLedgeObj.selectedContacts.add(accLedge1);
            accLedgeObj.processSelected();
            accLedgeObj.CreateCaseRequestStatement();
            accLedgeObj.clearInput();
            accLedgeObj.toHome();
          
           
        }
    }
    static testMethod void Method1() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='1000';
        sorg.Description__c='India';
        sorg.Sales_Org_Code__c='1000';
        insert sorg;
        
        
        Price_Group_Master__c pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Trigger_Settings__c tsObj = new Trigger_Settings__c();
        tsObj.Name = 'CaseTrigger';
        tsObj.isActive__c = True;
        insert tsObj;
        
        
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
        ordType.Description__c = 'India';    
        ordType.Order_Type_Code__c = 'ZORD';
        insert ordType;
        
        
        Account acc = new Account();
        acc.Name='Bhavik Devdhar';
        acc.Last_Name__c='Devdhar';
        acc.PriceGroupCode__c=pg.id;
        acc.SAP_Code__c='SAP996734';
        acc.RecordTypeId=devRecordTypeId;
        acc.Mobile__c='9967341759';
        acc.Phone='020256589';
        acc.Sales_Org__c=sorg.Id;
        acc.Division__c=Divbj.Id;
        acc.Distribution_Channel__c=disbj.Id;
        acc.BillingCity='Pune';
        acc.Order_Type__c=ordType.Id;
        acc.Depot_Code__c = 'PUN1';
        //  acc.OwnerId=sobj.Id;
        insert acc;
        
       
        
        contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName=acc.Last_Name__c;
        insert con;
        
    
        
        User userobj = new User();
        userobj.ProfileID = [Select Id From Profile Where Name='PartnerCommunity Distributor Profile'].id;
        userobj.EmailEncodingKey = 'ISO-8859-1';
        userobj.LanguageLocaleKey = 'en_US';
        userobj.TimeZoneSidKey = 'America/New_York';
        userobj.LocaleSidKey = 'en_US';
        userobj.FirstName = 'first';
        userobj.LastName = 'last';
        userobj.Username = 'test@appirio.com';   
        userobj.CommunityNickname = 'testUser123';
        userobj.Alias = 't1';
        userobj.Email = 'no@email.com';
        userobj.IsActive = true;
        userobj.ContactId = con.Id;
        //userobj.AccountId = ba.Id;
        insert userobj;
        User userobj2 = [Select Id,Name,AccountId,ContactID from User Where id =: userobj.Id];
 

            
             
            Account_Ledger__c accLedge = new Account_Ledger__c();
            accLedge.Customer__c = acc.id;          
            accLedge.Doc_Amount__c = 1000;                    
            accLedge.Doc_Number__c = 'DOC1';                      
            accLedge.Doc_Type__c = 'D1';                         
            accLedge.Posting_Date__c = system.today();
            accLedge.Due_Date__c =system.today();
            insert accLedge;
            
            Account_Ledger__c accLedge1 = new Account_Ledger__c();
            accLedge1.Customer__c = acc.id;          
            accLedge1.Doc_Amount__c = 1000;                    
            accLedge1.Doc_Number__c = 'DOC1';                      
            accLedge1.Doc_Type__c = 'D1';                         
            accLedge1.Posting_Date__c = system.today();
            accLedge1.Due_Date__c =system.today();
            insert accLedge1;
            
       AccountLedgerMob accLedgeObj =new AccountLedgerMob();    
            accLedgeObj.StartDate = system.today();
            accLedgeObj.EndDate = system.today();
            AccountLedgerMob.AccountLedgerWrapper wrappaccledge = new AccountLedgerMob.AccountLedgerWrapper(accLedge);
            wrappaccledge.selected=true;
            
          
            accLedgeObj.processSelected();
            accLedgeObj.selectedContacts.add(accLedge);
            accLedgeObj.getLoadAccountLedger();
            accLedgeObj.processSelected();
            accLedgeObj.selectedContacts.add(accLedge);
            accLedgeObj.selectedContacts.add(accLedge1);
            accLedgeObj.processSelected();
       // accLedgeObj.CreateCaseRequestStatement();
       accLedgeObj.Discription='test';
        accLedgeObj.createCaseAccountLedger();
        accLedgeObj.clearInput();
        accLedgeObj.toHome();
          
           
        
    }
}