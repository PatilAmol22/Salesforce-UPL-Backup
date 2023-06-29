@isTest
public class AttachpdfCSR_Test {
    @isTest static void test1(){
       // Prerequisite for brand pack look up field in case 
        Product2 prdct = new product2();
        prdct.name = 'MANCOZEB';
        prdct.Combination_Key__c = '31324564612564';
        insert prdct;
        
          //Prerequisite for account and case object
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        //Prerequisite for account and case object
        Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
        tsObj1.Name = 'CaseTrigger';
        tsObj1.isActive__c = True;
        insert tsObj1;
        
        Account acc= new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('US Distributor').getRecordTypeId();
        acc.Name = 'Accountt';
        acc.BillingStreet = 'DSP road';
        acc.BillingCity = 'MUMBAI';
        acc.BillingCountry = 'INDIA';
        acc.BillingState = 'MAHARASHTRA';
        acc.BillingPostalCode = '400068';
        acc.Phone='1010101004';
        acc.WRMS_Code__c='1222';
        acc.UPI_Division__c = 'AG';
        insert acc; 
        
        CSR__c csrObj = new CSR__c();
        csrObj.Account_Name__c = acc.id;
        csrObj.Brand_Pack__c = prdct.Id;
        csrObj.CSR_Status__c = 'New';
        insert csrObj;
        
        PageReference pageRef = Page.AttachPdfCSR;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',csrObj.Id);
        AttachPdfCSRController apc = new AttachPdfCSRController();
        apc.recordId = csrObj.Id;
        apc.ORG_LNK = 'https://'+URL.getSalesforceBaseUrl().getHost();
        //ApprovalStepWrapper instance for testing
        AttachPdfCSRController.ApprovalStepWrapper asw = new   AttachPdfCSRController.ApprovalStepWrapper();
        asw.workItemApproveOrRejectLink = 'workItemApproveOrRejectLink';
        asw.workItemReassignLink = 'workItemReassignLink';
        
        
        if([select count() from ProcessInstance where targetobjectid=:csrObj.id] < 1){       
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Approve.');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setObjectId(csrObj.Id);
            // Submit the record to specific process and skip the criteria evaluation
            //req.setProcessDefinitionNameOrId('CSR_Process');
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
        
        // apc.idVal = 'a240k000000DI8K';
        apc.CSRItem = new CSR__c();
        apc.skuList = new List<CSRSKU__c>();
         // apc.aSW = new AttachPdfCSRController.ApprovalList();
    }
}