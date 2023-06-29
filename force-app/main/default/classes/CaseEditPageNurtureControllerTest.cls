@isTest
public without sharing class CaseEditPageNurtureControllerTest {
    
    @testSetup
    public static void testDataSetup()
    {
        Id nurtureRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('nurture.farm care').getRecordTypeId();
        Case testCase=new Case();
        testCase.recordTypeId=nurtureRecordType;
        testCase.subject='test';
        testCase.status='Closed';
        insert testCase;
        
    }
    
    
    @isTest
    public static void testMethod1()
    {
        Id sysAdminProfile = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'].Id; //change this to Business Center Coordinator
        User userRecord = createSalesforceUser(true, sysAdminProfile);
        //RITM0466996-Added by nandhini-This will cover changes related to New field introduction on Case create Page
        List<Group> groupsToInsert = new List<Group>();
        List<String> groupNameString = new List<String>();
        groupNameString.add('QRC Technical Queue');
        groupNameString.add('QRC Technical Queue L2');
        groupNameString.add('QRC Non Technical Queue');
        groupNameString.add('QRC Non Technical Queue L2');
        //Create Parent Group
        for(Integer i=0; i<4; i++) {
            Group grp = new Group();
            grp.name = groupNameString[i];
            grp.Type = 'Regular'; 
            groupsToInsert.add(grp);
        }
        
        Insert groupsToInsert;
        List<GroupMember> gmList=new List<GroupMember>();
        //Create Group Member
        for(Group grpObj : groupsToInsert) {
            GroupMember grpMem1 = new GroupMember();
            grpMem1.UserOrGroupId = userRecord.id;
            grpMem1.GroupId = grpObj.Id;
            gmList.add(grpMem1);
        }
        insert gmList;
        system.runAs(userRecord){
            DateTime startTime=System.now();
            Case testCase=[select id,AccountId,Department__c,QRC_Category__c,QRC_sub_category__c,Reason_for_calling__c,QRC_type__c,
                           Order_number__c,Subject,Description,Level_1_Comments__c,Level_2_Comments__c,Status,Origin,State_Head__c,
                           Follow_Up_Status__c,SuppliedEmail,Multibrand_Name__c,Priority,Customer_Related_To__c from Case where subject='test' limit 1];
            testCase.Status='Escalated-L1';
            CaseEditPageNurtureController.updateCaseRecord(testCase,testCase.id,startTime);
        }
    }
    public static User createSalesforceUser(Boolean doInsert, Id systemAdmin){
        UserRole testUserRole = new UserRole();
        testUserRole.Name ='Case Escalation Test Assignee User';
        insert testUserRole;
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'swapnil.more@in.ibm.com';
        sobj1.ProfileId  = systemAdmin;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='More';
        sobj1.CommunityNickname = 'zonalExe1222 Di'; 
        sobj1.TimeZoneSidKey = 'America/Sao_Paulo'; 
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        sobj1.UserRoleId = testUserRole.id;
        insert sobj1;
        return sobj1;
    }
}