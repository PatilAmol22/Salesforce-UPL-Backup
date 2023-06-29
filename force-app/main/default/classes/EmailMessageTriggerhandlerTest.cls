/* Developer Name : Nandhini Perumalsamy
* Purpose: Test class for EmailMessageHandler and EmailMessaageTrigger
* Ticket: APPS-3946
* Author: EY
* Created Date: 29/12/2022
*/
@isTest
public class EmailMessageTriggerhandlerTest {
    @isTest
    public static void UpdateCaseStatusToResolvedCoverage()
    {
        Id nurtureProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Nurture CC Lead'].Id; //change this to Business Center Coordinator
        User userRecord = createSalesforceUser(NurtureProfile);
        Trigger_Settings__c emailMessagebyPass = new Trigger_Settings__c();
        emailMessagebyPass.Name = 'EmailMessageTrigger';
        emailMessagebyPass.IsActive__c	= false;
        Insert emailMessagebyPass;
        Test.startTest();
        System.runAS(userRecord){
            //Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Distributor').RecordTypeId;
            Id nurtureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Nurture_Care').getRecordTypeId();
            Case newCase=new case();
            newCase.recordtypeid = nurtureRecordTypeId;
            newCase.Caller_Type__c='Retailer';
            newCase.Caller_Name__c='Test New';
            newCase.Department__c='.Farm';
            newCase.QRC_Category__c='Nurture Farm App';
            newCase.QRC_sub_category__c='Cashout';
            newCase.Subject='Test New record';
            newCase.status='Resolved';
            newCase.Crop_pick__c='Insect';
            insert newCase;
            EmailMessage email = new EmailMessage();
            email.FromAddress = 'test@abc.org';
            email.Incoming = True;
            email.ToAddress= 'test@xyz.org';
            email.Subject = 'Test email';
            email.HtmlBody = 'Test email body';
            email.ParentId = newCase.Id; 
            insert email;
            
             Account accRecord = new Account();
            accRecord.Name='Bhavik Devdhar';
            accRecord.Last_Name__c='Devdhar';
            accRecord.SAP_Code__c='0001131274';
            accRecord.RecordTypeId=UPLConstantClass.distributorRecordTypeId;
            accRecord.Mobile__c='9967341759';
            accRecord.Phone='020256589';
            accRecord.BillingCity='Pune';
            accRecord.Depot_Code__c = 'PUN1';
            insert accRecord;
            
            EmailMessage emailM = new EmailMessage();
            emailM.FromAddress = 'test@abc.org';
            emailM.Incoming = True;
            emailM.ToAddress= 'test@xyz.org';
            emailM.Subject = 'Email to customer from SFDC';
            emailM.HtmlBody = 'Test email body';
            emailM.relatedToId = accRecord.Id; 
            insert emailM;
            //System.assertEquals([Select Id, Status From Case Where Id = :newCase.Id][0].Status,'Reopen');
            
            
        }
        Test.stopTest();
        
    }
    public static User createSalesforceUser(Id profileIdInfo){
        
        User userRec = new User();
        userRec.Alias = 'zonaa';                                                            
        userRec.Email = 'TestUser@in.testUser.com';
        userRec.ProfileId  = profileIdInfo;                                                     
        userRec.Username = 'zonal_aaexe1232@upl122333.com.devbox';                                    
        userRec.IsActive = true;  
        userRec.LastName='More';
        userRec.CommunityNickname = 'zonalExe1222 Di'; 
        userRec.TimeZoneSidKey = 'America/Sao_Paulo'; 
        userRec.LocaleSidKey = 'en_IN';                                    
        userRec.LanguageLocaleKey = 'en_US';                                             
        userRec.ForecastEnabled = false;                                                     
        userRec.EmailEncodingKey = 'ISO-8859-1';    
        userRec.Show_Inventory__c = false;                                                     
        userRec.Show_Credit_Limit__c = false; 
        
        insert userRec;
        return userRec;
    }
}