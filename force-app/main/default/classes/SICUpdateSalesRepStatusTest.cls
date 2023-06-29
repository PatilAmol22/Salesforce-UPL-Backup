@isTest(seeAllData=false)
public class SICUpdateSalesRepStatusTest {
    
    static testMethod void CallStockInChannelDetails()
    {
        StockInChannel_Test.insertUser();
        user usr = [select id from user limit 1];
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        Account acc = TestDataFactory.CreateAccount('SAP996734');
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
        
        Stock_In_Channel__c sic = new Stock_In_Channel__c();
        sic.Channel__c=acc.id;
        sic.Year__c='2021';
        sic.status_9__c = 'Submitted for Approval';
        insert sic;
        
        insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18);
        
        system.runAs(usr)
        {
            stockinchannel.getInitInfo sicGI = new stockinchannel.getInitInfo();
            list<Zone__c> zone= new list<Zone__c>();
            //zone=StockInChannel.getBUOps();
            sicGI = StockInChannel.getBUOps();
            list<Territory_Distributor__c> trr = new list<Territory_Distributor__c>();
            trr= StockInChannel.getZone(string.valueOf(zn.id));
            list<User> us = new list<User>();
            us = StockInChannel.getSalesRep(string.valueOf(tr.id));
            list<Account> cs = new list<Account>();
            cs= StockInChannel.getCustomer(string.valueOf(tr.id), 'Salesrep');
            StockInChannel st = new StockInChannel();
            st.isCoordinator=false;
            st.isDirector=false;
            st.isManager=false;
            st.zone=null;
            
           
            
            SIC_Customer__c SICC = new SIC_Customer__c();
            SICC.Year__c = '2021';
            SICC.Customer_SAP_Code__c = 'SAP996734';
            
            SIC_User_Info__c SICUO = new SIC_User_Info__c();
            SICUO.Sales_User__c = usr.Id;
            SICUO.Year__c = decimal.valueOf('2021');
            SICUO.Status_9__c = 'Submitted for Approval';
            SICUO.Territory__c = tr.id;
            insert SICUO;
          
            
                SICC.Active__c = true; 
                           
            //SICC.Combination_Key__c = inputvalues[0]+inputvalues[1].leftPad(paddingsapcode,'0');
            insert SICC;
            
             list<string> list1 = new list<string>();
            list1.add('SAP996734');
            SICUpdateSalesRepStatus.UpdateStatus(list1);
            
            
            Test.startTest();
            BatchCreateSICUserInfo uca = new BatchCreateSICUserInfo();
            Id batchId = Database.executeBatch(uca);
            Test.stopTest();
            
        }       
        
        
    }
    
}