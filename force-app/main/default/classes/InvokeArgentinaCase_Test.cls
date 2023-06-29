/*
Created On : 24nd May 2018
Developer: Ketan Khatri
Description: The Class which will be called by Case Assignment final process builder to share the case with users in case access
*/@isTest
public class InvokeArgentinaCase_Test {
@isTest
    static void test1(){
        
        List<String> idList = new List<String>();
        
        /*CaseTeamTemplate myCaseTeam = new CaseTeamTemplate();
        myCaseTeam.name = 'Access Team';
        myCaseTeam.description = 'Test Description';
        insert myCaseTeam;*/
        
        
        Sales_Org__c sOrg = new Sales_Org__c(
            Name = 'Argentina',        // Sales Org Name
            Sales_Org_Code__c = '5631'  // Sales Org Code
        );
        insert sOrg;
       
        Account acc= new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        acc.Name = 'Accountt';
        acc.BillingStreet = 'DSP road';
        acc.BillingCity = 'MUMBAI';
        acc.BillingCountry = 'INDIA';
        acc.BillingState = 'MAHARASHTRA';
        acc.BillingPostalCode = '400068';
        acc.Phone='1010101004';
        acc.WRMS_Code__c='1222';
        acc.Sales_Org__c = sOrg.Id;
        insert acc; 
        
        Case_Matrix__c cmObj1 = new Case_Matrix__c(
            Case_Type__c = 'Account Ledger',                          // Case Type
            Case_Type_Argentina__c = 'Account Ledger',
            Case_Owner__c = 'Francisco Garcia',                       // Case Owner
            Sales_Org__c =sOrg.Id,			                          // Sales Org
            Case_Access_Argentina__c = 'Marcelo Gorla;Jose Lottice',   // Case Access Argentina
            Case_Owner_Notify__c = 'Juan Alonso'
           
        );
        insert cmObj1;
        
         Case_Matrix__c cmObj2 = new Case_Matrix__c(
            Case_Type__c = 'Payments',
            Case_Type_Argentina__c = 'Payments',// Case Type
            Case_Owner__c = 'Francisco Garcia',                       // Case Owner
            Sales_Org__c =sOrg.Id,			                          // Sales Org
            //Case_Access_Argentina__c = 'Marcelo Gorla;Jose Lottice',   // Case Access Argentina
            Case_Owner_Notify__c = 'Juan Alonso'
        );
        insert cmObj2;
        
         List<Case> lst = new List<Case>();
        
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Argentina Distributor').getRecordTypeId();
        caseObj1.Status = 'Approved';
        caseObj1.AccountId = acc.Id;
        caseObj1.Type = 'Account Ledger';
        lst.add(caseObj1);
            
        Case caseObj2 = new Case();
        caseObj2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Argentina Distributor').getRecordTypeId();
        caseObj2.Status = 'Approved';
        caseObj2.AccountId = acc.Id;
        caseObj2.Type = 'Payments';
       	lst.add(caseObj2); 
        
        
        test.startTest();
        
        insert lst;
        test.stopTest();
        
        //List<Case> lst = [Select Id from Case];
        //for(Case c : Lst){
            idList.add(caseObj1.Id);
            
        //}
        
        InvokeArgentinaCaseAccess.caseAccessMethod(idList);
        idList.clear();
        idList.add(caseObj2.Id);
        InvokeArgentinaCaseAccess.caseAccessMethod(idList);
  
    }
}