@isTest
public class CaseTemplateController_Test {

    @isTest
    static void test1(){
        
        List<String> idList = new List<String>();
        Sales_Org__c sOrg = new Sales_Org__c(
            Name = 'Argentina',        // Sales Org Name
            Sales_Org_Code__c = '5631'  // Sales Org Code
        );
        insert sOrg;
        
        Account acc= new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        acc.Name = 'Accountt';
        acc.BillingStreet = 'DSP road';
        acc.BillingCity = 'MUMBAI';
        acc.BillingCountry = 'INDIA';
        acc.BillingState = 'MAHARASHTRA';
        acc.BillingPostalCode = '400068';
        acc.Phone='1010101004';
        acc.WRMS_Code__c='1222';
        acc.Sales_Org__c = sOrg.Id;
        insert acc; 
        
        Case caseObj = new Case();
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Argentina Distributor').getRecordTypeId();
        caseObj.Status = 'New';
        caseObj.AccountId = acc.Id;
        caseObj.Type = 'Account Ledger';
        //caseObj.Pack_Size_SKU__c =skuo.Id;
        //caseObj.Total_Volume_Effected__c = 21;
        //caseObj.Units_1__c = 'Ounces';
        //caseObj.List_Price_of_Complaint_Product_Unit__c = 32;
        
        
        test.startTest();
        insert caseObj;
        test.stopTest();
        
        
        CaseTemplateController ctc = new CaseTemplateController();
        ctc.lastApproverName = 'Daniel Vinsintin';
        ctc.comments = 'Approved By Dany';
        ctc.getProcessInstanceList(caseObj.Id);
         //ctc.str='';
        
        /* if([select count() from ProcessInstance where targetobjectid=:caseObj.id] < 1){       
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Approve.');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setObjectId(caseObj.Id);
            // Submit the record to specific process and skip the criteria evaluation
            req.setProcessDefinitionNameOrId('Argentina_Case_Approval_Process_V2_1_1');
            
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
        }*/
        
        
    }
}