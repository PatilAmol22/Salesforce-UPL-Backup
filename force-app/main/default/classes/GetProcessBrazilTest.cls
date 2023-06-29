@isTest
public with sharing class GetProcessBrazilTest {
 
    
    static testMethod void validateHelloWorld() {
        
        User u = [select Id from user where id=:userinfo.getuserid()];
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Brazil Sales District Manager' LIMIT 1];         
        
   
      
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Territory Manager'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );  
        insert u1;
        User u2 = new User(
            ProfileId = [select id from profile where name ='Regional Sales Manager'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            isActive = true
        );  
        insert u2;
        Sales_Org__c salorg = new Sales_Org__c();
        salorg.name = 'India';
        salorg.Sales_Org_Code__c = '1410';
        insert salorg;
        
        Zone__c zonesobj = new Zone__c(
            Name = 'Pune',                  // Zone Name
            SalesOrg__c =salorg.id,  // Sales Org
            ZoneCode__c = 'SWZ08',
            ZonalHead__c= u2.id            // Zone Code
        );
        insert zonesobj;
        
        Region__c Regionsobj = new Region__c(
            Name = 'PUNE',                  // Region Name
            RegionCode__c = 'SW017',          // Region Code
            SalesOrg__c = salorg.id,
            RegionHead__c = u1.id,
            // Sales Org
            Zone__c = zonesobj.id      // Zone
        );
        insert Regionsobj;
        
        
        
        Territory_Distributor__c territory1 = new Territory_Distributor__c();
        territory1.Name = 'Narayangaon1';
        territory1.TerritoryManager__c = u1.id;
        territory1.TerritoryCode__c = '3973';
        territory1.Region__c = Regionsobj.id;
        territory1.SalesOrg__c = salorg.id;
        territory1.Zone__c = zonesobj.id;
        territory1.Present_in_KEDE__c = true;
        territory1.Neglected__c = false;
        insert territory1;
        string caseRecordType1  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
        State__c state = new State__c(Name = 'Tamil Nadu');
        insert state;
        
  Case caseObj1 = new Case(RecordTypeId = caseRecordType1,Status = 'Open',Data_Pattern_Territory__c = territory1.Id,Type = 'PGR',Crop_pick__c = 'Brinjal',PGR__c ='Growth Promoters');
            
            insert caseObj1;
        list<id> l= new list<Id>();
        l.add(u.Id);

        Test.startTest();
        GetProcessInstanceeData.getRowData(u.Id, caseObj1.id, null, 'Case', 'mixed');
        
        GetProcessInstanceeData.getCaseList('Case');
        Approval.ProcessSubmitRequest req1 =
            new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(caseObj1.id);
        
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(u.Id);
        req1.setNextApproverIds(l);
        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('Brazil_Case_Approvals');
        req1.setSkipEntryCriteria(true);
        
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        system.debug('@@@@result--->'+result);
        // Verify the result
       
        
        // Approve the submitted request
        // First, get the ID of the newly created item
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        
        // Instantiate the new ProcessWorkitemRequest object and populate it
        Approval.ProcessWorkitemRequest req2 =
            new Approval.ProcessWorkitemRequest();
        req2.setComments('Approving request.');
        req2.setAction('Approve');
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        
        // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(newWorkItemIds.get(0));
        
        // Submit the request for approval
      //  Approval.ProcessResult result2 = Approval.process(req2);
    
        
    
       // GetProcessInstanceeData.getObjectAvailableFieldsString('Sales_Order__c');
       
        GetProcessInstanceeData.getContactIds(caseObj1.Id);   
       GetProcessInstanceeData.getProcessItemData(u.Id, caseObj1.Id, 'Id', 'Case','Mixed');
         GetProcessInstanceeData.process(null,'Approve',new list<id>{newWorkItemIds.get(0)},'Test');
        UserLookupControllerApprove.search('last',null);
        Test.stopTest();
        
    
    }
}