@isTest
public class DemandGenerationTest {
    @isTest
    public static void getDemandGeneration() {
        
     	User brazil=new User();
        String  ProfileId = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person'].Id;
            brazil.LastName = 'ABCD';
            brazil.Email = 'prashant.kumbhar@skinternational.com';
            brazil.Username = 'test@test1.com' + System.currentTimeMillis();
            brazil.CompanyName = 'SK international';
            brazil.Title = 'title';
            brazil.Alias = 'alias';
            brazil.TimeZoneSidKey = 'America/Sao_Paulo';
            brazil.EmailEncodingKey = 'UTF-8';
            brazil.LanguageLocaleKey = 'pt_BR';
            brazil.LocaleSidKey = 'pt_BR';
            brazil.Country = 'Brazil';
            brazil.ProfileId=ProfileId;
            insert brazil;
        
         Sales_Org__c salesOrgObj = new Sales_Org__c();
            salesOrgObj.Name = 'Brazil';            
            salesOrgObj.Company_Code__c = '5190';        
            salesOrgObj.Sales_Org_Code__c = '5191';      
            salesOrgObj.Country_Code__c = 'BR';     
            insert salesOrgObj;
        
          Account accObj = new Account();
            accObj.Name='Prashant Kumbhar';
            accObj.SAP_Code__c = '0001013292';              
            accObj.Last_Name__c = 'ADECO AGROPECUARIA S.A.';     
            accObj.Order_Block__c = false;                       
            accObj.Mobile__c = '9619335445';  
            accObj.Phone='5454545454'; // Mobile
            accObj.Email__c = 'pkumbhar128@gmail.com';       
            accObj.Account_Type__c = 'Sold To Party';           
            accObj.Raise_Order_Type__c = 'Factura';                 
            accObj.Billing_Street_2__c = 'CATAMARCA 3454';      
            accObj.Sales_Org__c = salesOrgObj.id;             
                
            insert accObj;
 
        Rebate_Contract__c reb=new Rebate_Contract__c();
            reb.Name='150';
            reb.Actual_Value__c=15;
            reb.Category_Code__c='1500';
            reb.Sales_Org__c=salesOrgObj.id;
            reb.Type__c='Up Líder';
            insert reb;
       
        Region__c reg=new Region__c();
            reg.Marketing_Manager__c =brazil.id;
            reg.Neglected__c=true;
            reg.SalesOrg__c=salesOrgObj.id;
            insert reg;
        
        Territory_Distributor__c  territory =new Territory_Distributor__c ();
            territory.SalesOrg__c=salesOrgObj.id;
            territory.Region__c=reg.id;
            territory.TerritoryManager__c=brazil.id;    
            insert  territory;
            
        Demand_Generation__c dem=new Demand_Generation__c();
        	dem.Actual_Budget__c=151;
        	dem.Balance__c=692;
        	dem.Budget_Available__c=150;
        	dem.Contract_Number__c=reb.id;
        	dem.Credit_Letter__c='Yes';
            dem.Distributor__c=accObj.id;
            dem.Document_Number__c='12345';
        	dem.Error_Message__c='yes';
        	dem.Event_Name__c='Yes';
        	dem.Event_Type__c='Other';
            dem.EventTypeOtherRemark__c='college';
            dem.Important_Information__c='Yes';
        	dem.Marketing_Access_Manager__c=brazil.id;
            dem.Marketing_Manager__c=brazil.id;
            dem.Participate_Profile__c='Sales Person';
            dem.Payment_to_Supplier__c='No';
        	dem.Planned_Value__c=86;
        	dem.Regional_Manager__c=brazil.id;
        	dem.SAP_Document_Number__c='13654';
        	dem.Status__c='Pending';
        	dem.Sub_Status__c='Awaiting MKT Approval';
        	dem.Total_Value__c=158;
        	dem.Type__c='Cooper Up';
        	dem.Zonal_Manager__c=brazil.id;
        	insert dem;
            update dem;
        RSOAndDGEndPoint__c x=new RSOAndDGEndPoint__c();
        x.EndPointUrl__c='www.google.com';
        x.Name='NamedCredentialUrl';
        insert x;
        
         RSOAndDGEndPoint__c x1=new RSOAndDGEndPoint__c();
        x1.Name='DGCompareDate';
        x1.DateForCompare__c='2022-04-01';
        insert x1;
        
        Sub_Distributor__c sub=new Sub_Distributor__c();
        sub.Distributor__c=accObj.id;
        sub.Rebate_Contract__c=reb.id;
        insert sub;
             String json = '{\"actualBudget\":\"10\" }'+   '{\"balance\":\"10\" }' +
                            '{\"budgetAvailable\":\"10\" }' + '{\"contractName\":\"150\" }' +
                           '{\"contractNumber\":\"150\" }' + '{\"countDocumentNumber\":\"150\" }' +
                            '{\"creditLetter\":\"Yes\" }' + '{\"distributorName\":\"Prashant\" }' +
                            '{\"documentNumber\":\"150\" }' + '{\"errorMessage\":\"Error\" }' +
                            '{\"eventName\":\"New\" }' + '{\"eventType\":\"Yes\" }' +
                            '{\"importantInformation\":\"Yes\" }' + '{\"otherRemarks\":\"No\" }' +
                            '{\"participateProfile\":\"Sales\" }' + '{\"paymenttoSupplier\":\"No\" }' +
                            '{\"plannedValue\":\"50\" }' + '{\"SapDocumentNumber\":\"1235\" }' +
                            '{\"status\":\"Pending\" }' + '{\"subStatus\":\"Awaiting MKT Approval\" }' +
                            '{\"totalValue\":\"50\" }' + '{\"type\":\"Credit\" }' +'{\"id\":\"1254\" }' +
                            '{\"zonalId1\":\"50\" }' + '{\"zonalId\":\"Credit\" }' +'{\"regionalId1\":\"1254\" }' +
                            '{\"regionalId\":\"50\" }' + '{\"marketingId1\":\"Credit\" }' +'{\"marketingId\":\"1254\" }' +
                            '{\"marketingAcessManager1\":\"50\" }' + '{\"marketingAcessManager\":\"Credit\" }';
                             
                           		
          
          Test.startTest();
          DemandGeneration.getDemandGeneration(dem.id,reb.id);
          DemandGeneration.getDemandGeneration('',reb.id);
          DemandGeneration.updateDemandGeneration(json);
          DGCustomers.getdistributour(reb.id);
         // DGCancelDemandStatus.dgCancelDemand(reb.Name,dem.SAP_Document_Number__c ,dem.Id);
          Test.stopTest();
        
        
    }        
    

}