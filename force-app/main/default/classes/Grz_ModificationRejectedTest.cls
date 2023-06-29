@isTest
public class Grz_ModificationRejectedTest {
    
    @testSetup static void setup() { 
        
        Sales_Org__c objSalesOrg = new Sales_Org__c();
        objSalesOrg.Name = 'test1';
        objSalesOrg.Sales_Org_Code__c = '1000';
        objSalesOrg.Company_Code__c='1200';
        
        insert objSalesOrg;
        
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account objAcc = new Account();
        objAcc.RecordTypeId = stExam;
        objAcc.Name = 'Test';
        objAcc.Sales_Org__c = objSalesOrg.Id;
        objAcc.Email__c='taruni.uce@test.com';
        objAcc.Mobile__c='8493434223';
        objAcc.GST_Validated__c=True;
        insert objAcc;
        
    }
    
        @istest static void SyncMethod1(){     
        list<Account> acc= [SELECT ID,Email__c,Prior_Email_and_Mobile_Value__c from Account];
            acc[0].Prior_Email_and_Mobile_Value__c='Email:test@gmail.com;';
            acc[0].Modification_Rejected__c=false;
            update acc[0];
        Grz_ModificationRejected.listOfInput l=new Grz_ModificationRejected.listOfInput();
        l.recordId=acc[0].id;
		test.startTest();  
   		Grz_ModificationRejected.updateModificationField(new list<Grz_ModificationRejected.listOfInput>{l});
        test.stopTest();
    }
}