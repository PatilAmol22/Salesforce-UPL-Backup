@isTest
public class OrderHistoryControllerTest {
    static testMethod void Method() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='1000';
        sorg.Description__c='India';
        sorg.Sales_Org_Code__c='1000';
        insert sorg;
        
        
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        Trigger_Settings__c tsObj = new Trigger_Settings__c();
        tsObj.Name = 'CaseTrigger';
        tsObj.isActive__c = True;
        insert tsObj;
        
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
        
        System.runas(userobj2){
        
        Sales_Order__c salesOrderObj = new Sales_Order__c();
        salesOrderObj.Order_Date__c=system.today();
        salesOrderObj.Sold_to_Party__c = acc.id;
        salesOrderObj.Order_Status__c='Open';
        salesOrderObj.Total_Amount__c=1000;
        salesOrderObj.Order_Cancel__c=false;
        insert salesOrderObj;
        
        OrderHistoryController orderHisObj = new OrderHistoryController();
        orderHisObj.startdate = system.today();
        orderHisObj.enddate = system.today();
        orderHisObj.searchdata();
        orderHisObj.toHome();
        }
        
    }
}