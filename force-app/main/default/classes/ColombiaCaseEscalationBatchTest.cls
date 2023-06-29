/**
* Test Class Name: ColombiaCaseEscalationBatchTest
* Author: EY
* CR: APPS-2074
* CreatedDate: 01-Nov-2022
* ModifiedDate: 28-Oct-2022 02:10 AM IST 
02-Nov-2022 19:01 AM IST 
* Description: Test class for ColombiaCaseEscalationBatch batch class
* */
@isTest
public class ColombiaCaseEscalationBatchTest {
    public static final String INVOICE = System.Label.Columbia_Case_Invoice;
    public static final String INVOICE_ENG ='Invoice';
    static testmethod void testBatchLogic(){ 
        Id systemAdministratorProfileId = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'].Id;
        User userRecord = createSalesforceUser(true, systemAdministratorProfileId);
        //APPS-2074-Added by Nandhini to pass values for Colombia User field
        User userRecordforColombiaField = createSalesforceUserforColomibaField(true, systemAdministratorProfileId);
        //Naresh, Vijaylaxmi - Connect with me, I am leftr with one clause colombia_user__r.userName IN '+ userNameList  to run the Batch.
        Test.startTest();
        System.runAS(userRecord){
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Distributor').RecordTypeId;
            Id colombiaRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Colombia_Case').getRecordTypeId();
            Sales_Org__c sOrg = Grz_TestDataFactory.createSalesOrg(true, 'Test Org','5710');
            Territory_Distributor__c trt = Grz_TestDataFactory.createTeritory(true);
            
            Account acc = new Account();
            acc.Name = 'Test Account';
            acc.Territory_Distributor__c = trt.Id;
            acc.RecordTypeId = accRecordTypeId;
            acc.SAP_Code__c = '1001801';
            acc.Sales_Org__c = sOrg.Id;
            acc.Sap_UserId__c = 'UPLINTCRM';
            insert acc;
            
            contact con=new contact();
            con.firstname='Test';
            con.lastname='test2';
            con.AccountId=acc.id;
            insert con;
            System.debug('acc>>>>>>>>>>>>>>.'+acc);
            //Contact con = Grz_TestDataFactory.createContact(true,'Test Contact',acc.Id); 
            try{
                Case caseRecordInvoice =new Case(AccountId = acc.Id,recordtypeid = colombiaRecordTypeId,Status='New', Colombia_user__c = userRecordforColombiaField.id, Assignee__c = 'Billing Head',Type = 'Invoice');
                Case caseRecordDis =new Case(AccountId = acc.Id,recordtypeid = colombiaRecordTypeId,Status='New', Colombia_user__c = userRecordforColombiaField.id, Assignee__c = 'Billing Head',Type = 'Dispatch');
                Case caseeRecordOtros =new Case(AccountId = acc.Id,recordtypeid = colombiaRecordTypeId,Status='New', Colombia_user__c = userRecordforColombiaField.id, Assignee__c = 'Billing Head',Type = 'Other');
                Case caseRecordProduct =new Case(AccountId = acc.Id,recordtypeid = colombiaRecordTypeId,Status='New', Colombia_user__c = userRecordforColombiaField.id, Assignee__c = 'Billing Head',Type = 'Product Leakage');
                Case caseRecordOU =new Case(AccountId = acc.Id,recordtypeid = colombiaRecordTypeId,Status='New', Colombia_user__c = userRecordforColombiaField.id, Assignee__c = 'Billing Head',Type = 'Order Update');
                Case caseRecordPAvil =new Case(AccountId = acc.Id,recordtypeid = colombiaRecordTypeId,Status='New', Colombia_user__c = userRecordforColombiaField.id, Assignee__c = 'Billing Head',Type = 'Product Availability');
                
                List<Case> ls = new List<Case>();
                ls.add(caseRecordInvoice);
                ls.add(caseRecordDis);
                ls.add(caseeRecordOtros);
                ls.add(caseRecordProduct);
                ls.add(caseRecordOU);
                ls.add(caseRecordPAvil);
                insert ls;
                
                //Case caseRecordProduct = createCasePrLeakType(acc.Id, colombiaRecordTypeId, userRecord);
            } catch(Exception e){
                system.assert(e.getMessage().contains('Insert failed'));
                
                
            }
            //System.debug('caseRecord>>>>>>>>>>>>>>.'+caseRecordDis);
            
            ColombiaCaseEscalationBatch colombiaCaseBatch = new ColombiaCaseEscalationBatch();
            Database.executeBatch(colombiaCaseBatch);
        }
        Test.stopTest();
    }
    
    static User createSalesforceUser(Boolean doInsert, Id systemAdministratorProfileId){
        UserRole testUserRole = new UserRole();
        testUserRole.Name ='Case Escalation Test Assignee User';
        insert testUserRole;
        
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
        //sobj1.UserRoleId = testUserRole.id;
        insert sobj1;
        return sobj1;
    }
    //APPS-2074-Added by Nandhini to pass values for Colombia User field
    static User createSalesforceUserforColomibaField(Boolean doInsert, Id systemAdministratorProfileId){
        UserRole testUserRole = new UserRole();
        testUserRole.Name ='Case Escalation Test Assignee User';
        insert testUserRole;
        
        User sobj1 = new User();
        sobj1.Alias = 'zonaa23';                                                            
        sobj1.Email = 'swapnil.more@in.ibm.com11';
        sobj1.ProfileId  = systemAdministratorProfileId;                                                     
        sobj1.Username = 'zonal_aaexe1232@upl122333.com.devboxsdfsd';                                    
        sobj1.IsActive = true;  
        sobj1.LastName='More';
        sobj1.CommunityNickname = 'zonalExe1222 Di23'; 
        sobj1.TimeZoneSidKey = 'America/Sao_Paulo'; 
        sobj1.LocaleSidKey = 'en_IN';                                    
        sobj1.LanguageLocaleKey = 'en_US';                                             
        sobj1.ForecastEnabled = false;                                                     
        sobj1.EmailEncodingKey = 'ISO-8859-1';    
        sobj1.Show_Inventory__c = false;                                                     
        sobj1.Show_Credit_Limit__c = false; 
        //sobj1.UserRoleId = testUserRole.id;
        insert sobj1;
        return sobj1;
    }
    
    public static Case createCaseInvoiceType(Id accId, Id caseRecordId, User userRecord){	
        Id colombiaRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Colombia_Case').getRecordTypeId();
        Case caseObj = new Case();	
        caseObj.recordtypeid = caseRecordId;	
        caseObj.AccountId = accId;	
        caseObj.Status = 'New';
        caseObj.Colombia_user__c = userRecord.Id;
        caseObj.Assignee__c = 'Billing Head';
        caseObj.Type ='Invoice';
        // insert caseObj;	
        return caseObj;    	
    }
    public static Case createCaseDisType(Id accId, Id caseRecordId, User userRecord){	
        Id colombiaRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Colombia_Case').getRecordTypeId();
        Case caseObjDis = new Case();	
        caseObjDis.recordtypeid = caseRecordId;	
        caseObjDis.AccountId = accId;	
        caseObjDis.Status = 'New';
        caseObjDis.Colombia_user__c = userRecord.Id;
        caseObjDis.Assignee__c = 'Billing Head';
        caseObjDis.Type ='Dispatch';
        //  insert caseObjDis;
        return caseObjDis;    	
    }
    public static Case createCaseOtrosType(Id accId, Id caseRecordId, User userRecord){	
        Id colombiaRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Colombia_Case').getRecordTypeId();
        Case caseObjOt = new Case();	
        caseObjOt.recordtypeid = caseRecordId;	
        caseObjOt.AccountId = accId;	
        caseObjOt.Status = 'New';
        caseObjOt.Colombia_user__c = userRecord.Id;
        caseObjOt.Assignee__c = 'Billing Head';
        caseObjOt.Type ='Other';
        //    insert caseObjOt;
        return caseObjOt;    
    }
    public static Case createCasePrLeakType(Id accId, Id caseRecordId, User userRecord){	
        Id colombiaRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Colombia_Case').getRecordTypeId();
        Case caseObjPl = new Case();	
        caseObjPl.recordtypeid = caseRecordId;	
        caseObjPl.AccountId = accId;	
        caseObjPl.Status = 'New';
        caseObjPl.Colombia_user__c = userRecord.Id;
        caseObjPl.Assignee__c = 'Billing Head';
        caseObjPl.Type ='Product Leakage';
        // insert caseObjPL;
        return caseObjPL;   	
    }
    public static Case createCaseProductOrder(Id accId, Id caseRecordId, User userRecord){	
        Id colombiaRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Colombia_Case').getRecordTypeId();
        Case caseObjPl = new Case();	
        caseObjPl.recordtypeid = caseRecordId;	
        caseObjPl.AccountId = accId;	
        caseObjPl.Status = 'New';
        caseObjPl.Colombia_user__c = userRecord.Id;
        caseObjPl.Assignee__c = 'Billing Head';
        caseObjPl.Type ='Order Update';
        // insert caseObjPL;
        return caseObjPL;   	
    }
    public static Case createCaseProduct(Id accId, Id caseRecordId, User userRecord){	
        Id colombiaRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Colombia_Case').getRecordTypeId();
        Case caseObjPl = new Case();	
        caseObjPl.recordtypeid = caseRecordId;	
        caseObjPl.AccountId = accId;	
        caseObjPl.Status = 'New';
        caseObjPl.Colombia_user__c = userRecord.Id;
        caseObjPl.Assignee__c = 'Billing Head';
        caseObjPl.Type ='Product Availability';
        // insert caseObjPL;
        return caseObjPL;   	
    }
        
}