@isTest
private class DgApprovalHistoryUtilTest {
    @testSetup static void methodName() {
        Account newAccount = new Account(Name = 'Test Account');
        insert newAccount;
    }
    @isTest static void isCurrentUserIdTest_SystemAdmin(){
        List<User> users = [select Id, FirstName, LastName FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1];
        List<Account> accounts = [SELECT Id FROM Account LIMIT 1];
        Profile prof = [select id from profile where name = 'System Administrator'];    
        User u = new User(Alias = 'standt', Email='paresh@gmail.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = prof.Id,  Country='Colombia',
        TimeZoneSidKey='America/Los_Angeles', UserName='appuesr@gmail.com');
		insert u;
        System.runAs(u){
            boolean isAdmin = DgApprovalHistoryUtil.isCurrentUserSystemAdmin(accounts.get(0).Id);
            System.assertEquals(true, isAdmin, 'The user was supposed to be found admin');
        }
       
    }

    @isTest static void isCurrentUserIdTest_NOT_SystemAdmin(){
        List<User> users = [select Id, FirstName, LastName FROM User WHERE Profile.Name != 'System Administrator' LIMIT 1];
        List<Account> accounts = [SELECT Id FROM Account LIMIT 1];
        System.runAs(users.get(0)){
            boolean isAdmin = DgApprovalHistoryUtil.isCurrentUserSystemAdmin(accounts.get(0).Id);
            System.assertEquals(false, isAdmin, 'The user was not supposed to be found admin');
        }
       
    }

    @isTest static void processStepTest_EmptyWorkItems(){
        List<User> users = [select Id, FirstName, LastName FROM User WHERE Profile.Name != 'System Administrator' LIMIT 1];
        List<Account> accounts = [SELECT Id FROM Account LIMIT 1];
        List<ProcessInstanceWorkitem> workItems = new List<ProcessInstanceWorkitem>();
        String retVal = DgApprovalHistoryUtil.processStep( workItems, 'comments',users.get(0).Id, accounts.get(0).Id);

    }
    
    @isTest static void processStepTest_NotEmptyWorkItems(){
        List<User> users = [select Id, FirstName, LastName FROM User WHERE Profile.Name != 'System Administrator' LIMIT 1];
        List<Account> accounts = [SELECT Id FROM Account LIMIT 1];
        List<ProcessInstanceWorkitem> workItems = new List<ProcessInstanceWorkitem>();
        workItems.add(new ProcessInstanceWorkitem(Id = '04i3h000001L5fGAAS'));
        try{
            String retVal = DgApprovalHistoryUtil.processStep( workItems, 'comments',users.get(0).Id, accounts.get(0).Id);
        }catch(Exception e){

        }
    }

    @isTest static void reassignStepTest(){
        List<User> users = [SELECT Id, FirstName, LastName FROM User LIMIT 1];
        List<ProcessInstanceWorkitem> workItems = new List<ProcessInstanceWorkitem>();
        workItems.add(new ProcessInstanceWorkitem(Id = '04i3h000001L5fGAAS'));
        try{
            DgApprovalHistoryUtil.reassignStep(workItems, users.get(0).Id);
        }catch(Exception e){
        }
    }

    @isTest static void populateApprovalHistoryTest(){
        List<Account> accounts = [SELECT Id FROM Account LIMIT 1];

        List<ProcessInstance> processInstances = new List<ProcessInstance> ();
        DgApprovalHistoryController.ApprovalHistory retVal = DgApprovalHistoryUtil.populateApprovalHistorySteps(processInstances, accounts.get(0).Id, accounts.get(0).Id);

    }

    @isTest static void populateApprovalHistoryRecord(){
        List<User> users = [SELECT Id, FirstName, LastName FROM User LIMIT 1];
        List<Account> accounts = [SELECT Id FROM Account LIMIT 1];
        List<DgApprovalHistoryController.ApprovalHistoryStep> approvalSteps = new List<DgApprovalHistoryController.ApprovalHistoryStep>();
        approvalSteps.add(new DgApprovalHistoryController.ApprovalHistoryStep( 'stepName','stepId', DateTime.now(),'stepStatus', 'assignedTo', 'assignedToId', 'Comments', accounts.get(0).Id, 'Customer Community Plus User - Poland - 1'));
        DgApprovalHistoryController.ApprovalHistory approvalHistoryToReturn = new DgApprovalHistoryController.ApprovalHistory( approvalSteps,  false, true, true);
        ProcessInstanceHistory step = new ProcessInstanceHistory();
        DgApprovalHistoryUtil.populateApprovalHistoryRecord(approvalHistoryToReturn, step,  true, users.get(0).Id );
        System.assertEquals(true, approvalHistoryToReturn.showRecall, 'The recall attribute is supposed to be true');
        System.assertEquals(true, approvalHistoryToReturn.isCurrentUserApprover, 'The isCurrentUserApprover attribute is supposed to be true');
        System.assertEquals(false, approvalHistoryToReturn.showSubmitForApproval, 'The showSubmitForApproval attribute is supposed to be false');
        
    }



}