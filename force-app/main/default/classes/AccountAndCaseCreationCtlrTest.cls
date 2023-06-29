@isTest
public class AccountAndCaseCreationCtlrTest {
	private static testMethod void unit1(){
        Id AccRecordId = Schema.SObjectType.account.getRecordTypeInfosByDeveloperName().get('PreRegistered_Farmer').getRecordTypeId();
        Id idRecordId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('nurture_farm_care').getRecordTypeId();
        
        
        State__c st = new State__c(Name = 'Assam');
        insert st;
        
        District__c ds = new District__c(Name = 'Cacher', State__c= st.Id);
        insert ds;
        
        Tehsil__c ts = new Tehsil__c(Name = 'Cacher', District__c= ds.Id);
        insert ts;
        
        Village__c vill = new Village__c(Name = 'DidarKush', Tehsil__c= ts.Id, Postal_Code__c ='788099'); 
        insert vill;
        
        Account acc = new Account(FirstName = 'Test', LastName='abc', Email__c = 'kuhinoor.barbhuiya@ibm.com',
                                  LegacyId__c='112233', PersonMobilePhone='1234567890',recordTypeId = AccRecordId,
                                 Country__c = 'Other', Tax_classification_for_customer__c= '1',
                                 Using_Watsapp__c ='Yes', Using_Smart_Phone__c='Yes',Preferred_Language__pc ='English',
                                 Village__pc  =vill.Id);
         insert acc;
        system.assertEquals(acc.LastName, 'abc');
        ApexPages.currentPage().getParameters().put('RecordTypeId', idRecordId);
        ApexPages.currentPage().getParameters().put('accountId', acc.Id);
        
        case cs = new case(subject = 'Test', recordTypeId = idRecordId,
                           AccountId = acc.Id, SuppliedEmail ='kuhinoor.barbhuiya@ibm.com');
        insert cs;
        
        //AccountAndCaseCreationCtlr.CaseWrapperCls obj2 = new AccountAndCaseCreationCtlr.CaseWrapperCls(cs, false, false);
		AccountAndCaseCreationCtlr obj = new AccountAndCaseCreationCtlr();
        
        obj.caseIndx =1;
        //obj.addRow();
        obj.removeIndex = 0;
        obj.lnameStr = '';
        obj.checkValidations();
        obj.isPersonAccount = true;
        obj.lnameStr = 'test';
        obj.fnameStr = '';
        obj.selectedRecTypeId = AccRecordId;
        obj.checkValidations();
        obj.lnameStr = 'test';
        obj.fnameStr = 'Test';
        //obj.selectedRecTypeId = '';
        obj.checkValidations();
        
        obj.recordTypes();
        obj.toggleCallerField();
        obj.showProdSec();
        obj.showProductRecom();
        obj.chnageRecordType();
        obj.isPersonAccount = true;
        obj.lnameStr = 'test';
        obj.fnameStr = 'test';
        //obj.selectedRecTypeId = idRecordId;
        obj.callerCase.Status = 'Closed';
        obj.callerCase.Reason_for_calling__c ='test';
        obj.callerCase.QRC_type__c ='test'; 
        obj.saveCases();
        obj.addRow();
        obj.removeRow();
        
    }
    
    private static testMethod void unit2(){
        Id idRecordId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('nurture_farm_care').getRecordTypeId();
        ApexPages.currentPage().getParameters().put('RecordTypeId', idRecordId);
        AccountAndCaseCreationCtlr obj = new AccountAndCaseCreationCtlr();
        system.assert(obj.caseRecordTypeID != null);
    }
    
   private static testMethod void unit3(){
        Id AccRecordId = Schema.SObjectType.account.getRecordTypeInfosByDeveloperName().get('PreRegistered_Farmer').getRecordTypeId();
        Id idRecordId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('nurture_farm_care').getRecordTypeId();
        
        
        State__c st = new State__c(Name = 'Assam');
        insert st;
        
        District__c ds = new District__c(Name = 'Cacher', State__c= st.Id);
        insert ds;
        
        Tehsil__c ts = new Tehsil__c(Name = 'Cacher', District__c= ds.Id);
        insert ts;
        
        Village__c vill = new Village__c(Name = 'DidarKush', Tehsil__c= ts.Id, Postal_Code__c ='788099'); 
        insert vill;
        
        Account acc = new Account(FirstName = 'Test', LastName='abc', Email__c = 'kuhinoor.barbhuiya@ibm.com',
                                  LegacyId__c='112233', PersonMobilePhone='1234567890',recordTypeId = AccRecordId,
                                 Country__c = 'Other', Tax_classification_for_customer__c= '1',
                                 Using_Watsapp__c ='Yes', Using_Smart_Phone__c='Yes',Preferred_Language__pc ='English',
                                 Village__pc  =vill.Id);
         insert acc;
        system.assertEquals(acc.LastName, 'abc');
        ApexPages.currentPage().getParameters().put('RecordTypeId', idRecordId);
        ApexPages.currentPage().getParameters().put('accountId', acc.Id);
        
        case cs = new case(subject = 'Test', recordTypeId = idRecordId,
                           AccountId = acc.Id, SuppliedEmail ='kuhinoor.barbhuiya@ibm.com',Status='Escalated-L1',Order_number__c ='test');
        insert cs;
        
        //AccountAndCaseCreationCtlr.CaseWrapperCls obj2 = new AccountAndCaseCreationCtlr.CaseWrapperCls(cs, false, false);
		AccountAndCaseCreationCtlr obj = new AccountAndCaseCreationCtlr();
        
        obj.caseIndx =1;
        //obj.addRow();
        obj.removeIndex = 0;
        obj.lnameStr = '';
        obj.checkValidations();
        obj.isPersonAccount = true;
        obj.lnameStr = 'test';
        obj.fnameStr = '';
        obj.selectedRecTypeId = AccRecordId;
        obj.checkValidations();
        obj.lnameStr = 'test';
        obj.fnameStr = 'Test'; 
        obj.callerCase.Status ='Closed';
        obj.callerCase.Reason_for_calling__c ='test';
        obj.callerCase.Order_number__c ='test'; 
        obj.callerCase.QRC_Category__c='Order Related';
        //obj.selectedRecTypeId = '';
        obj.checkValidations();
        obj.callerCase.Order_number__c ='test1212test1212'; 
        obj.checkValidations();
       obj.callerCase.Order_number__c ='XXXXXX-XXXXXXXXX';
        obj.callerCase.Reason_for_calling__c =null;
        obj.checkValidations();
        obj.callerCase.Reason_for_calling__c ='test';
       obj.callerCase.QRC_Category__c=null;
       obj.checkValidations();
        obj.callerCase.QRC_type__c='Query';
       obj.callerCase.Status ='Escalated-L1';
       obj.checkValidations();
       obj.selectedRecTypeId = null;
        obj.checkValidations();
        obj.selectedRecTypeId = AccRecordId;
        obj.recordTypes();
        obj.toggleCallerField();
        obj.showProdSec();
        obj.showProductRecom();
        obj.chnageRecordType();
        obj.isPersonAccount = true;
        obj.lnameStr = 'test';
        obj.fnameStr = 'test';
        //obj.selectedRecTypeId = idRecordId;
       obj.caseIndx=1;
       obj.showComSec();
        obj.hideComSec();
        obj.showCatSec();
        obj.hideCatSec();
        obj.cancel();
       obj.checkValidations();
        obj.saveCases();
        obj.addRow();
        obj.removeRow();
        
    }
    
    
}