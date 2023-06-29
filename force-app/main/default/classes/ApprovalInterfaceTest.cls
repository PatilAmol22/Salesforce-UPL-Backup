@isTest
public without sharing class ApprovalInterfaceTest {
    @isTest  
    public static void creatApprovalConfiguration() {
         Approval_Interface_Configuration__c approvalCon=new Approval_Interface_Configuration__c();
        	approvalCon.Name ='Return_Sales_Order_Brazil_Sales_Person_SMM';
            approvalCon.sObject_API_Name__c = 'Demand_Generation__c';
            approvalCon.Child_Level_1__c ='';
            approvalCon.UGDN_Number__c='12345';
            approvalCon.Stage__c='Pending';
            approvalCon.Approved_SOQL_Statement__c='';
            approvalCon.Open_SOQL_Statement__c='';
            approvalCon.Failed_In_Process_SOQL_Statement__c='';
            approvalCon.Pending_At_Higher_Authority_SOQL_State__c='';
            approvalCon.Rejected_SOQL_Statement__c='';
            approvalCon.Pending_SOQL_Statement__c ='Select id,name,Document_Number__c,SAP_Document_Number__c,Distributor__r.Name,Status__c,Sub_Status__c,Type__c,Event_Name__c,Total_Value__c,Budget_Available__c,Balance__c,Planned_Value__c, Actual_Budget__c from Demand_Generation__c';
            approvalCon.Cancelled_SOQL_Statement__c = 'Select id,name,Document_Number__c,SAP_Document_Number__c,Distributor__r.Name,Status__c,Sub_Status__c,Type__c,Event_Name__c,Total_Value__c,Budget_Available__c,Balance__c,Planned_Value__c, Actual_Budget__c from Demand_Generation__c';
            approvalCon.Profile_API_Name__c = 'Brazil Sales Person';
        	approvalCon.Cancelled_Header_Column_Name__c ='';
        	approvalCon.Approved_Header_Column_Name__c ='';
        	approvalCon.Default_Selected_Statge__c='Pending';
        	approvalCon.Failed_In_Process_Header_Column_Name__c='';
        	approvalCon.Open_Header_Column_Name__c='';
        	approvalCon.Rejected_Header_Column_Name__c='';
        
        insert approvalCon;
        
        Approval_Interface_Configuration__c approvalCon1=new Approval_Interface_Configuration__c();
        	approvalCon1.Name ='Return_Sales_Order_Brazil_Sales_Person_SMM';
            approvalCon1.sObject_API_Name__c = 'Demand_Generation__c';
            approvalCon1.Child_Level_1__c ='';
            approvalCon1.UGDN_Number__c='12345';
            approvalCon1.Stage__c='Pending';
            approvalCon1.Approved_SOQL_Statement__c='';
            approvalCon1.Open_SOQL_Statement__c='';
            approvalCon1.Failed_In_Process_SOQL_Statement__c='';
            approvalCon1.Pending_At_Higher_Authority_SOQL_State__c='';
            approvalCon1.Rejected_SOQL_Statement__c='';
            approvalCon1.Pending_SOQL_Statement__c ='Select id,name,Document_Number__c,SAP_Document_Number__c,Distributor__r.Name,Status__c,Sub_Status__c,Type__c,Event_Name__c,Total_Value__c,Budget_Available__c,Balance__c,Planned_Value__c, Actual_Budget__c from Demand_Generation__c';
            approvalCon1.Cancelled_SOQL_Statement__c = 'Select id,name,Document_Number__c,SAP_Document_Number__c,Distributor__r.Name,Status__c,Sub_Status__c,Type__c,Event_Name__c,Total_Value__c,Budget_Available__c,Balance__c,Planned_Value__c, Actual_Budget__c from Demand_Generation__c';
            approvalCon1.Profile_API_Name__c = 'Brazil Sales Person SMM';
        	approvalCon1.Cancelled_Header_Column_Name__c ='';
        	approvalCon1.Approved_Header_Column_Name__c ='';
        	approvalCon1.Default_Selected_Statge__c='Pending';
        	approvalCon1.Failed_In_Process_Header_Column_Name__c='';
        	approvalCon1.Open_Header_Column_Name__c='';
        	approvalCon1.Rejected_Header_Column_Name__c='';
        
        insert approvalCon1;
    
    Sales_Org__c salesOrgObj = new Sales_Org__c();
            salesOrgObj.Name = 'Brazil';            
            salesOrgObj.Company_Code__c = '5190';        
            salesOrgObj.Sales_Org_Code__c = '5191';      
            salesOrgObj.Country_Code__c = 'BR';     
            insert salesOrgObj;
  
        User Usr = new User();
            Usr.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales Person'].Id;
            Usr.LastName = 'ALEXANDRO ANTUNES GUIMARÃES';
            Usr.Email = 'Priyanka.Nalawade@skinternational.com';
            Usr.Username = '20004672@uniphos.com.brazildb' + System.currentTimeMillis();
            Usr.CompanyName = 'SK international';
            Usr.Title = 'title';
            Usr.Alias = 'alias';
            Usr.TimeZoneSidKey = 'America/Los_Angeles';
            Usr.EmailEncodingKey = 'UTF-8';
            Usr.LanguageLocaleKey = 'en_US';
            Usr.LocaleSidKey = 'en_US';
            Usr.UGDN_Number__c = '12345';
            Usr.Country = 'Brazil';
        insert Usr;
        
         
         
       
        Region__c reg=new Region__c();
            reg.Marketing_Manager__c =Usr.id;
            reg.Neglected__c=true;
            reg.SalesOrg__c=salesOrgObj.id;
            insert reg;
        
        Territory_Distributor__c  territory =new Territory_Distributor__c ();
            territory.SalesOrg__c=salesOrgObj.id;
            territory.Region__c=reg.id;
            territory.TerritoryManager__c=Usr.id;    
            insert  territory;
        
             
 
       
        
        System.runAs(Usr){
            Account accObj = new Account();
            accObj.Name='Priyanka Nalawade';
            accObj.SAP_Code__c = '0001013292';              
            accObj.Last_Name__c = 'ADECO AGROPECUARIA S.A.';     
            accObj.Order_Block__c = false;                       
            accObj.Mobile__c = '9619335445';  
            accObj.Phone='5454545454'; // Mobile
            accObj.Email__c = 'priyanka.nalawade@gmail.com';       
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
            dem.EventTypeOtherRemark__c='college';
            dem.Important_Information__c='Yes';
        	dem.Marketing_Access_Manager__c=Usr.Id;
            dem.Marketing_Manager__c=Usr.Id;
            dem.Participate_Profile__c='Sales Person';
            dem.Payment_to_Supplier__c='No';
        	dem.Planned_Value__c=86;
        	dem.Regional_Manager__c=Usr.Id;
        	dem.SAP_Document_Number__c='13654';
        	dem.Status__c='Open';
        	dem.Total_Value__c=158;
        	dem.Type__c='Cooper Up';
        	dem.Zonal_Manager__c=Usr.id;
        	//dem.Sub_Status__c='Awaiting MKT Approval';
        	insert dem;
              Test.startTest();
            ApprovalInterface.getSobjects();
          	ApprovalInterface.getStage(approvalCon.sObject_API_Name__c);
          	ApprovalInterface.getDefaultStage(approvalCon.sObject_API_Name__c);
    		ApprovalInterface.getSoqlStmt();
    
     		ApprovalInterface.getConfiguration(approvalCon.sObject_API_Name__c);
     		ApprovalInterface.getColumns();
    		ApprovalInterface.getApprovalConfiguration(approvalCon.sObject_API_Name__c,approvalCon.Stage__c);
    		
            ApprovalInterface.getStageRecords( approvalCon.sObject_API_Name__c,approvalCon.Stage__c);
     		submitForApproval(dem);
            ApprovalInterface.processRecord(JSON.serialize(new List<String>{dem.Id}),'Approve','Test');
    		//ApprovalInterface.getMyPendingRecord();
    		
    		 Test.stopTest();
        }
         
    }   
    private static void submitForApproval(Demand_Generation__c dem){
        dem.Status__c = 'Pending';
        dem.Sub_Status__c='Awaiting MKT Approval';
        System.debug('dem '+dem);
        update dem;
    }
}