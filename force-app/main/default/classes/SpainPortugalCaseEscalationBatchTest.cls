/**
 * class Name: SpainPortugalCaseEscalationBatchTest
 * Author: EY
 * CR: APPS-5135
 * Description: Test class for SpainPortugalCaseEscalationBatch class 
 * */
@IsTest
public class SpainPortugalCaseEscalationBatchTest {
    static testmethod void testBatchLogic(){ 
        Id systemAdministratorProfileId = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'].Id;
        User userRecord = createSalesforceUser(true, systemAdministratorProfileId);
        
        System.runAS(userRecord){
            Id iberiaRecordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Iberia_Community_Cases').getRecordTypeId();
            
            List<case> caseList=new List<Case>();
            Case caseObj = new Case();	
            caseObj.recordtypeid = iberiaRecordType;	
            caseObj.Status = 'Open';
            caseObj.Type ='Method and Payment Terms';
            caseList.add(caseObj);
            
            contact con=new contact();
            con.firstname='Test';
            con.lastname='test2';
            //con.AccountId=acc.id;
            insert con;
            Insert caseList;
            Test.startTest();
            SPainPortugalCaseEscalationBatch cb=new SPainPortugalCaseEscalationBatch();
            database.executeBatch(cb,5);            
            Test.stopTest();
        }
    }
    static User createSalesforceUser(Boolean doInsert, Id systemAdministratorProfileId){
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa';                                                            
        sobj1.Email = 'swapnil.more@in.ibm.com';
        sobj1.ProfileId  = systemAdministratorProfileId;                                                     
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
        
        insert sobj1;
        return sobj1;
    }
    
    
}