@isTest
public class AttachPDfCase_Test {
    @isTest static void test1(){
        
        //Prerequisite for account and case object
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        
        
        //Prerequisite for account and case object
        Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
        tsObj1.Name = 'CaseTrigger';
        tsObj1.isActive__c = True;
        
        
        
        Account acc= new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('US Distributor').getRecordTypeId();
        acc.Name = 'Accountt';
        acc.BillingStreet = 'DSP road';
        acc.BillingCity = 'MUMBAI';
        acc.BillingCountry = 'INDIA';
        acc.BillingState = 'MAHARASHTRA';
        acc.BillingPostalCode = '400068';
        acc.Phone='1010101004';
        acc.UPI_Division__c = 'AG';
        acc.WRMS_Code__c='1222';
        
        
        SKU__c skuo = new SKU__c();
        skuo.Name = 'MANCO';
        skuo.SKU_Code__c = 'sku001';
        skuo.Combination_Key__c = '3213456796854';
        
        
        Case_Investigation__c ci = new Case_Investigation__c();
        
        
        
        Case caseObj = new Case();
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('US Distributor').getRecordTypeId();
        caseObj.Status = 'New';
        caseObj.AccountId = acc.Id;
        caseObj.Pack_Size_SKU__c =skuo.Id;
        caseObj.Total_Volume_Effected__c = 21;
        caseObj.Units_1__c = 'Ounces';
        caseObj.List_Price_of_Complaint_Product_Unit__c = 32;
        
        test.startTest();
        
        insert auto;
        insert tsObj1;
        insert acc; 
        insert skuo;
        insert caseObj;  
        ci.Complaint_Case_Name__c = caseObj.Id;
        insert ci;
        
        test.stopTest();
        
        PageReference pageRef = Page.AttachPDFCase;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',caseObj.Id);
        
        AttachPdfCaseController apcc = new AttachPdfCaseController();
        //ApprovalStepWrapper instance for testing
        AttachPdfCaseController.ApprovalStepWrapper asw = new   AttachPdfCaseController.ApprovalStepWrapper();
        asw.workItemApproveOrRejectLink = 'workItemApproveOrRejectLink';
        asw.workItemReassignLink = 'workItemReassignLink';
        
        if([select count() from ProcessInstance where targetobjectid=:caseObj.id] < 1){       
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Approve.');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setObjectId(caseObj.Id);
            // Submit the record to specific process and skip the criteria evaluation
            req.setProcessDefinitionNameOrId('US_Case_Approval_Process_AG_Canada_Sales');
            
            req.setSkipEntryCriteria(true);
            //Submit the approval request
            Approval.ProcessResult result = Approval.process(req);
            
            system.debug('Inside If------->'+result);
            
            List<Id> newWorkItemIds = result.getNewWorkitemIds();
            
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Approving request.');
            req2.setAction('Approve'); //This is the action that is approve in your case, you can set it to Reject also
            req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            
            // Use the ID from the newly created item to specify the item to be worked  
            
            req2.setWorkitemId(newWorkItemIds.get(0));
            
            // Submit the request for approval  
            
            Approval.ProcessResult result2 =  Approval.process(req2);            
        }
        
        
        
    }
}