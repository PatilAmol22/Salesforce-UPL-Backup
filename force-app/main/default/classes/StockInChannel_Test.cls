@isTest
public class StockInChannel_Test {
    static testMethod void CallStockInChannel(){
        
        //User usr = TestDataFactory.CreateUser();
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
        sic.Year__c='2019';
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
                
            String test= StockInChannel.getNotesID('2019',string.valueOf(acc.id) , string.valueOf(tr.id));
                
                
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