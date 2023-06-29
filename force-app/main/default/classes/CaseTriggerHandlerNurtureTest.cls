/* Developer Name : Nandhini Perumalsamy
* Purpose: Test class for CaseTriggerHandlerNurture class
* Ticket: RITM0464580
* Author: EY
* Created Date: 08/12/2022
*/
@isTest
public class CaseTriggerHandlerNurtureTest {
    
    static final Id nurtureProfileId = [SELECT Id, Name FROM Profile WHERE Name = 'Nurture CC Lead'].Id;
    /*  
* Name: CaseNurture    
* return:void
* Description: RITM0464580-This method responsible to cover InvokeCaseAssignmentForInlineEdit method.
*/     
    static testmethod void CaseNurture(){
        Id nurtureProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Nurture CC Lead'].Id; //change this to Business Center Coordinator
        User userRecord = createSalesforceUser(true, NurtureProfile);
        List<Group> gpList=new List<Group>();
        Group gp= new Group();
        gp.Name= 'QRC Technical Queue';
        gp.DeveloperName= 'QRCTechnicalQueue';
        gp.Type= 'Regular';
        gpList.add(gp);
        Group gp1= new Group();
        gp1.Name= 'QRC Technical Queue L2';
        gp1.DeveloperName= 'QRCTechnicalQueueL2';
        gp1.Type= 'Regular';
        gpList.add(gp1);
        insert gpList;
        List<GroupMember> gmList=new List<GroupMember>();
        GroupMember gm=new GroupMember();
        gm.UserOrGroupId=userRecord.id;
        gm.GroupId=gpList[0].id;
        gmList.add(gm);
        GroupMember gm1=new GroupMember();
        gm1.UserOrGroupId=userRecord.id;
        gm1.GroupId=gpList[1].id;
        gmList.add(gm1);
        
        insert gmList;
        Test.startTest();
        System.runAS(userRecord){
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Distributor').RecordTypeId;
            Id nurtureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('nurture_farm_care').getRecordTypeId();
           Id uplConsumerRecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('UPL_consumer_product').getRecordTypeId();
            Case c=new case();
            c.recordtypeid = nurtureRecordTypeId;
            c.Caller_Type__c='Retailer';
            c.Caller_Name__c='Test New';
            c.Department__c='.Farm';
            c.QRC_Category__c='Nurture Farm App';
            c.QRC_sub_category__c='Cashout';
            c.Subject='Test New record';
            c.status='closed';
            c.Crop_pick__c='Insect';
            insert c;
           
            c.Subject='This is to cover update scenario';
            c.status='Escalated-L1';
            update c;
            
             
           
            
            
        }
        Test.stopTest();
    }
     /*  
* Name: updateCaseOwnerEscalated   
* return:void
* Description: RITM0481463-This method responsible to cover InvokeCaseAssignmentForInlineEdit method.
               This test method runs once the case status gets changed from Escalated L1 to Escalated L2.
*/     
    static testmethod void updateCaseOwnerEscalated(){ 
        User userRecord = createSalesforceUser(true, nurtureProfileId);
        List<Group> gpList=new List<Group>();
        Group gp= new Group();
        gp.Name= 'QRC Technical Queue';
        gp.DeveloperName= 'QRCTechnicalQueue';
        gp.Type= 'Regular';
        gpList.add(gp);
        Group gp1= new Group();
        gp1.Name= 'QRC Technical Queue L2';
        gp1.DeveloperName= 'QRCTechnicalQueueL2';
        gp1.Type= 'Regular';
        gpList.add(gp1);
        insert gpList;
        List<GroupMember> gmList=new List<GroupMember>();
        GroupMember gm=new GroupMember();
        gm.UserOrGroupId=userRecord.id;
        gm.GroupId=gpList[0].id;
        gmList.add(gm);
        GroupMember gm1=new GroupMember();
        gm1.UserOrGroupId=userRecord.id;
        gm1.GroupId=gpList[1].id;
        gmList.add(gm1);
        
        insert gmList;
        Test.startTest();
            System.runAS(userRecord){        
                Case caseRecord = new case();
                caseRecord.recordtypeid = UPLConstantClass.nurtureRecordTypeId;
                caseRecord.Caller_Type__c='Retailer';
                caseRecord.Caller_Name__c='Test New';
                caseRecord.Department__c='.Farm';
                caseRecord.QRC_Category__c='Nurture Farm App';
                caseRecord.QRC_sub_category__c='Cashout';
                caseRecord.Subject='Test New record';
                caseRecord.status='Escalated-L1';
                caseRecord.Crop_pick__c='Insect';
                INSERT caseRecord;
                
                System.assertEquals('Escalated-L1',caseRecord.status);
                System.assertNOTEquals('Escalated-L1',null);
                caseRecord.Subject='This is to cover update scenario';
                caseRecord.status='Escalated-L2';
                update caseRecord;
                
                System.assertEquals('Escalated-L2',caseRecord.status);
                System.assertNOTEquals('Escalated-L2',null);
            }
        Test.stopTest();
    }
     
   static testmethod void  insertSkuUnitCostOnCase(){ 
      
       Id nurtureProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Nurture CC Lead'].Id; //change this to Business Center Coordinator
        User userRecord = createSalesforceUser(true, NurtureProfile);
        
        System.runAS(userRecord){
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='USA';
        sorg.Description__c='USA';
        sorg.Sales_Org_Code__c='3100';
        sorg.Is_Active_Forecast__c = true;
        insert sorg;
      Id SkURecorTypeId = Schema.SObjectType.SKU__c.getRecordTypeInfosByDeveloperName().get('US').getRecordTypeId();
 
      SKU__c skuobj = new SKU__c(
            Name = 'NIMBUS 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250380',             // SKU Code
            SKU_Description__c = 'NIMBUS 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
          //  Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '3100000000000005250380',  // Combination Key
            Active__c = true, 
          RecordTypeId=SkURecorTypeId,// Active
            Multiple_of__c = 0.00                        // Multiple Of
        );
        insert skuobj;
        
       SKU__c skuobj1 = new SKU__c(
            Name = 'TEST 4X5 L',                        // SKU Name
            SKU_Code__c = '000000000005250382',             // SKU Code
            SKU_Description__c = 'TEST 4X5 L',            // SKU Description
            UOM__c = 'L',                                   // UOM
          //  Division__c = div.Id,                // Division
            Sales_Org__c = sorg.Id,               // Sales Org
            Combination_Key__c = '3100000000000005250382',  // Combination Key
            Active__c = true,                               // Active
            Multiple_of__c = 0.00,
            RecordTypeId=SkURecorTypeId// Multiple Of
        );
       // skuList.add(skuobj);
        insert skuobj1;
       
       Test.startTest();
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Distributor').RecordTypeId;
            Id nurtureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('nurture_farm_care').getRecordTypeId();
            Case c=new case();
            c.recordtypeid = nurtureRecordTypeId;
            c.Caller_Type__c='Retailer';
            c.Caller_Name__c='Test New';
            c.Department__c='.Farm';
            c.QRC_Category__c='Nurture Farm App';
            c.QRC_sub_category__c='Cashout';
            c.Subject='Test New record';
            c.status='Escalated-L1';
            c.Crop_pick__c='Insect';
            c.SalesOrg__c=sorg.id;
            c.Pack_Size_SKU__c=skuobj.id;
            insert c;
            
           c.Pack_Size_SKU__c=skuobj1.id;
            update c;
            
            
        }
        Test.stopTest();
     
   }   
    
    public static User createSalesforceUser(Boolean doInsert, Id colombiaProfile){
        UserRole testUserRole = new UserRole();
        testUserRole.Name ='Case Escalation Test Assignee User';
        insert testUserRole;
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'swapnil.more@in.ibm.com';
        sobj1.ProfileId  = colombiaProfile;                                                     
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