@isTest
public class SICApproveRejectTest {
    static testMethod void CallStockInChannel(){
        
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
        sic.Territory__c = tr.id;
        insert sic;
        
        SICApproveReject.init(sic.Id);
        system.runAs(usr){
        list<SIC_Approval__c> LISICA = SICApproveReject.SubmitForApprovalApex(sic.Id);
        }
        list<SIC_Approval__c> LISICA2 = SICApproveReject.ApproveReject(true,'test',sic.Id);
        list<SIC_Approval__c> LISICA3 = SICApproveReject.ApproveReject(false,'test',sic.Id);
        
        
        
    }

}