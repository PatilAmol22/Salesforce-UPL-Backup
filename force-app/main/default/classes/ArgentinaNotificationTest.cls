/**
* Testclass Name: ArgetinaNoticationTest
* Author: EY
* CR: APPS-5392
* Description: If no action on case for 7 days, Send an email to Argentina Users 
and the case didn't get approved by Jorge for 2 days, Send an email to Jorge with the casedetails
* */

@isTest
public class ArgentinaNotificationTest {
	
	//Trigger the ArgentinaCaseNotification Class    
    public static testmethod void argentinaCaseNotification(){
        
        //Start:Insert the test data into Account and Case sObjects
        //        
        Account accountTestRecord = new Account(Name = 'Bhavik Devdhar', Last_Name__c='Devdhar', SAP_Code__c='SAP996734',
                                  				recordTypeId= UPLConstantClass.distributorRecordTypeId, 
                                                Mobile__c='9967341759',
                                                Phone='020256589');
        INSERT accountTestRecord; 
        
        Case caseRec=new case(recordtypeid = UPLConstantClass.argentinaCaseDistributorRTId, Subject='Test New record',
                              status='Open', accountId = accountTestRecord.Id);
        INSERT caseRec;
        
        //End:Insert the test data into Account and Case sObjects
        
        //Start: Invoke the method async
        Test.startTest();
        ArgentinaCaseNotificationScheduler.invokeArgentinaCaseNotificationJob();
        Test.stopTest();
        //End: Runs in sync here after
    }
    
    //Trigger the ArgentinaCaseApprovalNotification Class
    public static testmethod void argentinaCaseApprovalNotification(){
        
        //Start: Insert the test data into SalesOrg , Account and Case sObjects
        Sales_Org__c argentinaSalesOrg = new Sales_Org__c(name='Argentina', description__c='Argentina',sales_Org_Code__c='5631');
        INSERT argentinaSalesOrg;
        
        //Id distributorRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId(); 
        Account accountTestRecord = new Account(name = 'Bhavik Devdhar', last_Name__c='Devdhar', SAP_Code__c='SAP996734',
                                  				recordTypeId= UPLConstantClass.distributorRecordTypeId,
                                                mobile__c='9967341759', phone='020256589',
                                            	sales_Org__c = argentinaSalesOrg.Id);
        INSERT accountTestRecord; 
        
        
        Case testCaseRecord = new Case(recordtypeid = UPLConstantClass.argentinaCaseDistributorRTId , subject='Test New record',
                                       status='Open', accountId = accountTestRecord.Id, type='Batch error');
        INSERT testCaseRecord;
        
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(testCaseRecord.id);
        Approval.ProcessResult result = Approval.process(app);
        //End:Insert the test data into SalesOrg, Account and Case sObjects
        
        Test.startTest();
        ArgentinaPendingApprovalNotification.invokeArgentinaCaseApprovalNotificationJob();
        Test.stopTest();
        
    }
}