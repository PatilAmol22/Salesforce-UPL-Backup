@isTest
public class ApprovalRejection_Test {
    @isTest
    Public Static Void SampleData(){
        
        Account accObj = new Account();
        accObj.Name='Agrolic Pharma Pvt Ltd';
        accObj.SAP_Code__c='319362';
        accObj.Account_Type__c='Sold To Party';
        insert accObj;
        
        Sales_Org__c salesOrgObj = new Sales_Org__c();
        salesOrgObj.Name = 'Brazil';            
        salesOrgObj.Company_Code__c = '5190';        
        salesOrgObj.Sales_Org_Code__c = '5191';      
        salesOrgObj.Country_Code__c = 'BR';     
        insert salesOrgObj;
        
        Return_Sales_Order__c rsoList = new Return_Sales_Order__c();
        rsoList.Order_Status__c='';
        rsoList.SalesOrg__c=salesOrgObj.Id;
        rsoList.Return_Type__c='Commercial';
        rsoList.RSO_SFDC_Number__c='122345';
        rsoList.RSO_Raised_By__c='Sales Rep';
        rsoList.Sub_Status__c='Pending At Quality Team';
        rsoList.Comment__c='Go for Approval';
        rsoList.Proceed_with_Return__c='No';
        rsoList.Customer__c=accObj.Id;
        
        insert rsoList;
        rsoList.Order_Status__c='Pending';
        update rsoList;
        
        
        List<Return_Sales_Order__c> rsorecord = new List<Return_Sales_Order__c>();
        rsorecord.add(rsoList);
        System.debug('List Of Records==>'+rsorecord);
        test.startTest();
        submitApproval(rsorecord[0]);
        ApprovalRejection.rejectRecord(new List<Id>{rsorecord[0].Id});
        test.stopTest();
    }
    
    private static void submitApproval(Return_Sales_Order__c rso){
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();          
        req.setComments('Submitting approval request');        
        req.setObjectId(rso.id);     
        Approval.ProcessResult result = Approval.process(req);   
    }

}