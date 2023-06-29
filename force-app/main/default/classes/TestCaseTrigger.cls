@isTest
public class TestCaseTrigger {
    static Auto_Number__c autObj;
    static Trigger_Settings__c tsObj;
    static Price_Group_Master__c pg;
    static Account ac; 
    static contact con;
    static Account acc;
    static Account accObj;
    static  Case caseObj;
    static user sobj1;
    static List<case> caseList = new List<case>();
    
    static   Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
    static   Id indocaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Indonesia Distributor').getRecordTypeId();
    static  Id distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
    static Id nutureFarmRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('nurture.farm care').getRecordTypeId();
 public static TestMethod void testInsertTrigger(){
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
        tsObj1.Name = 'CaseTrigger';
        tsObj1.isActive__c = True;
        insert tsObj1;
        State__c s=new State__c(Name='UP');
        insert s;
        District__c d=new District__c(Name='Bareilly',State__c=s.Id);
        insert d;
        Tehsil__c t=new Tehsil__c(Name='abc',District__c=d.Id, Tehsil_Code__c='123456');
        insert t;
        Village__c v=new Village__c(Name='Atak Pardi',Tehsil__c=t.Id);
        insert v;
        Employee__c e=new Employee__c(Name='Anant', Mobile__c='7065749466',Active__c=true);
        insert e;
        Date fromDate=System.today();
        Date toDate=fromDate.addDays(5);
        
        Employee_Village_Mapping__c evm=new Employee_Village_Mapping__c(Employee__c=e.Id, Village__c=v.Id,Active__c=true, To__c=toDate, From__c=fromDate);
        insert evm;
        RecordType r=new RecordType();
        r=[SELECT Id,Name From RecordType WHERE SObjectType='Account' AND Name='Farmer' limit 1];
   
        Account acc1=new Account(FirstName='Anant', LastName='Agarwal', Village__pc=v.Id, PersonMobilePhone='7065749466', RecordTypeId=r.Id, Crops_Cultivated__pc='Fruit/Vegetables', Decision_Maker__pc='Yes', Fruit_Vegetable_Acerage__pc='1 or Above', SMS_Voice_Msg_Call_Consent__pc='Yes',Village_Pin_Code_Manual__pc='123456',Preferred_Language__pc='Tamil',Using_Smart_Phone__c='Yes',Using_Watsapp__c='Yes');
        insert acc1;
        Case c=new Case(accountid = acc1.id,Status='Escalated-L2',Subject='ABC',Type='Disease', Crop_pick__c='Cole', Sub_Query__c='How To Use', Origin='Call Inbound', /*Neebal_Integration_Status__c='Ready For Creation',*/ SMS_Sent__c=true,Total_Land_for_selected_Crop_in_acre__c=8.0,Total_Land_infected_due_to_infection__c=2.0);
        insert c;

    }
 /*   public static TestMethod void testUpdateTrigger(){
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        Trigger_Settings__c tsObj = new Trigger_Settings__c();
        tsObj.Name = 'CaseTrigger';
        tsObj.isActive__c = True;
        insert tsObj;
        State__c s=new State__c(Name='UP');
        insert s;
        District__c d=new District__c(Name='Bareilly',State__c=s.Id);
        insert d;
        Tehsil__c t=new Tehsil__c(Name='abc',District__c=d.Id, Tehsil_Code__c='123456');
        insert t;
        Village__c v=new Village__c(Name='Atak Pardi',Tehsil__c=t.Id);
        insert v;
        Employee__c e=new Employee__c(Name='Anant', Mobile__c='7065749466',Active__c=true);
        insert e;
        Date fromDate=System.today();
        fromDate=fromDate.addDays(-2);
        Date toDate=fromDate.addDays(8);
        
        Employee_Village_Mapping__c evm=new Employee_Village_Mapping__c(Employee__c=e.Id, Village__c=v.Id,Active__c=true, To__c=toDate, From__c=fromDate);
        insert evm;
        RecordType r=new RecordType();
        r=[SELECT Id,Name From RecordType WHERE SObjectType='Account' AND Name='Farmer' limit 1];
        Account acc=new Account(FirstName='Anant', LastName='Agarwal', Village__pc=v.Id, PersonMobilePhone='7065749466', RecordTypeId=r.Id, Crops_Cultivated__pc='Fruit/Vegetables', Decision_Maker__pc='Yes', Fruit_Vegetable_Acerage__pc='1 or Above', SMS_Voice_Msg_Call_Consent__pc='Yes');
        insert acc;
        Case c=new Case(AccountId=acc.Id,Status='Closed',Subject='ABC',Type='AFS', Crop_pick__c='Cole', Sub_Query__c='How To Use', Origin='Call Inbound', Neebal_Integration_Status__c='Not Created in Neebal',Products_Recommended__c='ULALA;');
        insert c;
        
        c.Neebal_Integration_Status__c='Ready For Creation';
        c.SMS_Sent__c=true;
        update c;
    }*/
    
    public static TestMethod void testElseTrigger(){
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        
        insert auto;
        Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
        tsObj1.Name = 'CaseTrigger';
        tsObj1.isActive__c = True;
        insert tsObj1;
        State__c s=new State__c(Name='UP');
        insert s;
        District__c d=new District__c(Name='Bareilly',State__c=s.Id);
        insert d;
        Tehsil__c t=new Tehsil__c(Name='abc',District__c=d.Id, Tehsil_Code__c='123456');
        insert t;
        Village__c v=new Village__c(Name='Atak Pardi',Tehsil__c=t.Id);
        insert v;
        Employee__c e=new Employee__c(Name='Anant', Mobile__c='7065749466',Active__c=true);
        insert e;
        Date fromDate=System.today();
        fromDate=fromDate.addDays(-2);
        Date toDate=fromDate.addDays(8);
        
        Employee_Village_Mapping__c evm=new Employee_Village_Mapping__c(Employee__c=e.Id, Village__c=v.Id,Active__c=true, To__c=toDate, From__c=fromDate);
        insert evm;
        RecordType r=new RecordType();
        r=[SELECT Id,Name From RecordType WHERE SObjectType='Account' AND Name='Farmer' limit 1];
        Account acc1=new Account(FirstName='Anant', LastName='Agarwal', Village__pc=v.Id, PersonMobilePhone='7065749466', RecordTypeId=r.Id, Crops_Cultivated__pc='Fruit/Vegetables', Decision_Maker__pc='Yes', Fruit_Vegetable_Acerage__pc='1 or Above', SMS_Voice_Msg_Call_Consent__pc='Yes',Village_Pin_Code_Manual__pc='123456',Preferred_Language__pc='Tamil',Using_Smart_Phone__c='Yes',Using_Watsapp__c='Yes');
        insert acc1;
        Case c=new Case(Products_Recommended__c='ULALA;',AccountId=acc1.Id,Status='Closed',Subject='ABC',Type='AFS', Crop_pick__c='Cole', Sub_Query__c='How To Use', Origin='Call Inbound',recordtypeid=nutureFarmRecordTypeId/*, Neebal_Integration_Status__c='Not Created in Neebal'*/);
        insert c;
        
        //c.Neebal_Integration_Status__c='Ready For Creation';
        c.SMS_Sent__c=true;
        c.Status='Reopen';
        update c;
    }
    
        public static void init(){
        
        
        
        autObj = new Auto_Number__c();
        autObj.Name = 'FarmerCode';
        autObj.Sequence__c = '0';
        insert autObj;
        
        tsObj = new Trigger_Settings__c();
        tsObj.Name = 'CaseTrigger';
        tsObj.isActive__c = True;
        insert tsObj;
        
        pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        ac = new Account();
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
        
        con = new Contact();
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
        u.LocaleSidKey = 'en_IN';                                    
        u.LanguageLocaleKey = 'en_US';                                             
        u.ForecastEnabled = false;                                                     
        u.EmailEncodingKey = 'ISO-8859-1';    
        u.Show_Inventory__c = false;                                                     
        u.Show_Credit_Limit__c = false; 
        u.UserRoleId=usrole.id;
        insert u;
        
        
        userrole  usrole1 = new userrole();
        usrole1.Name ='Bhavik Devdhar Customer User';
        
        Profile p1 = [SELECT Id,name FROM Profile WHERE Name = 'PartnerCommunity Distributor Profile'];
        
        sobj1 = new User();
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
        sobj1.RegionalManager__c = u.Id;
        sobj1.ZonalHead__c=u.Id;
        sobj1.Sales_Head__c=u.Id;
        sobj1.C_F_User__c=u.id;
        sobj1.Escalation_Owner__c=u.Id;
        insert sobj1;
        
        Sales_Org__c sorg = new Sales_Org__c(
            Name = 'India',           
            Description__c = 'India',  
            Sales_Org_Code__c = '1000'  
        );
        insert sorg; 
        
        
        acc = new account();
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        acc.Mobile__c='9869457515';
        acc.Email__c='test@gmail.com';
        acc.Phone='1010101004';
        acc.BillingStreet='test';
        acc.BillingCity='test';
        acc.BillingState='test';
        acc.BillingPostalCode='test';
        acc.BillingCountry='test';
        acc.PriceGroupCode__c=Pg.Id;
        acc.Last_Name__c='test';
        acc.First_Name__c='test';
        acc.Name='test';
        acc.Middle_Name__c='tets';
        acc.Salutation__c='Mr.';
        acc.OwnerId=sobj1.Id;
        acc.Sales_Org__c = sorg.id;
        insert acc;
        
        accObj=[select id,name,Sales_Org_Code__c,Sales_Org__c from account where id =:acc.id];
        system.debug('Sales_Org__c '+acc.Sales_Org__c);
        system.debug('Sales_Org_Code__c'+acc.Sales_Org_Code__c);
        
    }
    
    /*public static void init1(){
        
        autObj = new Auto_Number__c();
        autObj.Name = 'FarmerCode';
        autObj.Sequence__c = '0';
        insert autObj;
        
        tsObj = new Trigger_Settings__c();
        tsObj.Name = 'CaseTrigger';
        tsObj.isActive__c = True;
        insert tsObj;
        
        pg = new Price_Group_Master__c ();
        pg.PG_Code__c='03';
        insert Pg;
        
        ac = new Account();
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
        
        con = new Contact();
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
        u.LocaleSidKey = 'en_IN';                                    
        u.LanguageLocaleKey = 'en_US';                                             
        u.ForecastEnabled = false;                                                     
        u.EmailEncodingKey = 'ISO-8859-1';    
        u.Show_Inventory__c = false;                                                     
        u.Show_Credit_Limit__c = false; 
        u.UserRoleId=usrole.id;
        insert u;
        
        
        userrole  usrole1 = new userrole();
        usrole1.Name ='Bhavik Devdhar Customer User';
        
        Profile p1 = [SELECT Id,name FROM Profile WHERE Name = 'PartnerCommunity Distributor Profile'];
        
        sobj1 = new User();
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
        sobj1.RegionalManager__c = u.Id;
        sobj1.ZonalHead__c=u.Id;
        sobj1.Sales_Head__c=u.Id;
        sobj1.C_F_User__c=u.id;
        sobj1.Escalation_Owner__c=u.Id;
        insert sobj1;
        
        Sales_Org__c sorg = new Sales_Org__c(
            Name = 'Indonesia',                        
            Description__c = 'Credit Control Area UPID', 
            Sales_Org_Code__c = '6410'                   
        );
        insert sorg;
        
        
        acc = new account();
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        acc.Mobile__c='9869457515';
        acc.Email__c='test@gmail.com';
        acc.Phone='1010101004';
        acc.BillingStreet='test';
        acc.BillingCity='test';
        acc.BillingState='test';
        acc.BillingPostalCode='test';
        acc.BillingCountry='test';
        acc.PriceGroupCode__c=Pg.Id;
        acc.Last_Name__c='test';
        acc.First_Name__c='test';
        acc.Name='test';
        acc.Middle_Name__c='tets';
        acc.Salutation__c='Mr.';
        acc.OwnerId=sobj1.Id;
        acc.Sales_Org__c = sorg.id;
        insert acc;
        
        accObj=[select id,name,Sales_Org_Code__c,Sales_Org__c from account where id =:acc.id];
        system.debug('Sales_Org__c '+acc.Sales_Org__c);
        system.debug('Sales_Org_Code__c'+acc.Sales_Org_Code__c);
        
    }
	
	

    static testmethod void method1(){
        init();
        
        System.runAs(sobj1){
            
            for(Integer i=0;i<=5;i++){
                caseObj = new Case();
                caseObj.AccountId = accObj.id;
                caseObj.RecordTypeId = caseRecordTypeId;
                caseObj.status='New';
                caseObj.Origin='Uni View';
              //  caseObj.EscalationUser__c=sobj1.id;
                if(i==0){
                    caseObj.Type='Credit Limit';
                }
                else if(i==1){
                    caseObj.Type='Scheme';
                }
                else if(i==2){
                    caseObj.Type='Order Cancellation';
                }
                else if(i==3){
                    caseObj.Type='Invoice';
                }
                else if(i==4){
                    caseObj.Type='Dispatch';
                }
                else if(i==5){
                    caseObj.Type='Inventory';
                }
               
                
                caseList.add(caseObj);
                
            }
            System.debug('caseList---test class'+caseList);
              System.debug('caseList---test class'+caseList.size());
            if(caseList.size()>0){
                insert caseList;
                
            }
            
        }
    }
    static testmethod void method2(){
        init();
        
        System.runAs(sobj1){
            
            for(Integer i=0;i<=5;i++){
                caseObj = new Case();
                caseObj.AccountId = accObj.id;
                caseObj.RecordTypeId = caseRecordTypeId;
                caseObj.status='New';
                caseObj.Origin='Uni View';
              //  caseObj.EscalationUser__c=sobj1.id;
            
                if(i==0){
                    caseObj.Type='Product Availability';
                }  else if(i==1){
                    caseObj.Type='Order Update';
                }
                else if(i==2){
                    caseObj.Type='Product Leakage';
                }
                else if(i==3){
                    caseObj.Type='Near Expiry';
                }  else if(i==4){
                    caseObj.Type='Shipping Address';
                }
                
                caseList.add(caseObj);
                
            }
            System.debug('caseList---test class'+caseList);
              System.debug('caseList---test class'+caseList.size());
            if(caseList.size()>0){
                insert caseList;
                
            }
            
        }
    }
    static testmethod void method3(){
        init();
        
        System.runAs(sobj1){
            
            for(Integer i=0;i<=5;i++){
                caseObj = new Case();
                caseObj.AccountId = accObj.id;
                caseObj.RecordTypeId = caseRecordTypeId;
                caseObj.status='New';
                caseObj.Origin='Uni View';
              //  caseObj.EscalationUser__c=sobj1.id;
            
                if(i==0){
                    caseObj.Type='Account Related';
                }  else if(i==1){
                    caseObj.Type='Others';
                }
                else if(i==2){
                    caseObj.Type='Product Complaints by Farmers';
                }
                else if(i==3){
                    caseObj.Type='Account Ledger';
                }  else if(i==4){
                    caseObj.Type='Payments';
                }
                else if(i==5){
                    caseObj.Type='Outstanding';
                }
                caseList.add(caseObj);
                
            }
            System.debug('caseList---test class'+caseList);
              System.debug('caseList---test class'+caseList.size());
            if(caseList.size()>0){
                insert caseList;
                
            }
            
        }
    }
        static testmethod void method4(){
        init1();
        
        System.runAs(sobj1){
            
            for(Integer i=0;i<=5;i++){
                caseObj = new Case();
                caseObj.AccountId = accObj.id;
                caseObj.RecordTypeId = indocaseRecordTypeId;
                caseObj.status='New';
                caseObj.Origin='Uni View';
              //  caseObj.EscalationUser__c=sobj1.id;
            
                if(i==0){
                    caseObj.Type='Credit Limit';
                }  else if(i==1){
                    caseObj.Type='Scheme';
                }
                else if(i==2){
                    caseObj.Type='Order Cancellation';
                }
                else if(i==3){
                    caseObj.Type='Invoice';
                }  else if(i==4){
                    caseObj.Type='Inventory';
                }
                else if(i==5){
                    caseObj.Type='Dispatch';
                }
                caseList.add(caseObj);
                
            }
            System.debug('caseList---test class'+caseList);
              System.debug('caseList---test class'+caseList.size());
            if(caseList.size()>0){
                insert caseList;
                
            }
            
        }
    }
           static testmethod void method5(){
        init1();
        
        System.runAs(sobj1){
            
            for(Integer i=0;i<=5;i++){
                caseObj = new Case();
                caseObj.AccountId = accObj.id;
                caseObj.RecordTypeId = indocaseRecordTypeId;
                caseObj.status='New';
                caseObj.Origin='Uni View';
              //  caseObj.EscalationUser__c=sobj1.id;
            
                if(i==0){
                    caseObj.Type='Product Availability';
                }  else if(i==1){
                    caseObj.Type='Order Update';
                }
                else if(i==2){
                    caseObj.Type='Product Leakage';
                }
                else if(i==3){
                    caseObj.Type='Near Expiry';
                }  else if(i==4){
                    caseObj.Type='Shipping Address';
                }
                else if(i==5){
                    caseObj.Type='Account Related';
                }
                caseList.add(caseObj);
                
            }
            System.debug('caseList---test class'+caseList);
              System.debug('caseList---test class'+caseList.size());
            if(caseList.size()>0){
                insert caseList;
                
            }
            
        }
    }
    static testmethod void method6(){
        init1();
        
        System.runAs(sobj1){
            
            for(Integer i=0;i<=4;i++){
                caseObj = new Case();
                caseObj.AccountId = accObj.id;
                caseObj.RecordTypeId = indocaseRecordTypeId;
                caseObj.status='New';
                caseObj.Origin='Uni View';
              //  caseObj.EscalationUser__c=sobj1.id;
            
                if(i==0){
                    caseObj.Type='Others';
                }  else if(i==1){
                    caseObj.Type='Product Complaints by Farmers';
                }
                else if(i==2){
                    caseObj.Type='Account Ledger';
                }
                else if(i==3){
                    caseObj.Type='Payments';
                }  else if(i==4){
                    caseObj.Type='Outstanding';
                }
               /* else if(i==5){
                    caseObj.Type='Account Related';
                }*/
                /*caseList.add(caseObj);
                
            }
            System.debug('caseList---test class'+caseList);
              System.debug('caseList---test class'+caseList.size());
            if(caseList.size()>0){
                insert caseList;
                
            }
            
        }
    }*/
    
    
}