/*
Created On : 8th Aug 2020
Created by: Pallavi Gite
Description: The Class which will be called by Case Assignment final process builder to share the case with users in case access
*/

@isTest
private class InvokeMexicoCaseAccess_Test {
    static testMethod void validateCaseTeam() {
        
                List<String> idOfList = new List<String>();

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Mexico Distributor').getRecordTypeId();
       Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        
        
        
        
        Sales_Org__c salesOrgobj = new Sales_Org__c(
            Name = 'Mexico',           // Sales Org Name
            Sales_Org_Code__c = '5100'     // Sales Org Code
            
        );
        insert salesOrgobj;
      
        Account accobj = new Account(
            Name = 'HACIENDA OJO DE AGUA S.A.',     // Account Name                           
            Last_Name__c = 'HACIENDA OJO DE AGUA S.A.',                // Last Name
            SAP_Code__c = '0001022461', 
            RecordTypeId = accRecordTypeId,
            Account_Type__c = 'Sold To Party', // Account Type
            Phone='1010101004',
            Sales_Org__c = salesOrgobj.Id,
            BillingStreet = 'DSP road',
            BillingCity = 'MUMBAI',
            BillingCountry = 'INDIA',
            BillingState = 'MAHARASHTRA',
            BillingPostalCode = '400068'
        
        );
        insert accobj;
        
         Case_Matrix__c CaseMatrixObj1 = new Case_Matrix__c(
            Case_Type__c = 'Account Ledger',                                                                                                                                     // Case Type
            Case_Access_Argentina__c = 'Beatriz Trejo;Diana Garrido;Erik Medina;Edith Navarro;Lorena Castañeda;Diana Oyervides;Mario Solano;Gabriela Silva Romero;Alfredo Reyna',  // Case Access Mexico
            Case_Owner__c = 'Diana Garrido;Erik Medina',                                                                                                                           // Case Owner
            Sales_Org__c = salesOrgobj.Id,                                                                                                                                      // Sales Org
            Case_Type_Argentina__c = 'Account Ledger'                                                                                                                             // Case Type Mexico
        );
        insert CaseMatrixObj1;
        
        Case_Matrix__c CaseMatrixObj2 = new Case_Matrix__c(
            Case_Type__c = 'Invoice',                                                                                                                                     // Case Type
            Case_Access_Argentina__c = 'Beatriz Trejo;Diana Garrido;Erik Medina;Edith Navarro;Lorena Castañeda;Diana Oyervides;Mario Solano;Gabriela Silva Romero;Alfredo Reyna',  // Case Access Mexico
            Case_Owner__c = 'Diana Garrido;Erik Medina',                                                                                                                           // Case Owner
            Sales_Org__c = salesOrgobj.Id,                                                                                                                                      // Sales Org
            Case_Type_Argentina__c = 'Invoice'                                                                                                                             // Case Type Mexico
        );
        
        insert CaseMatrixObj2;
        
       
        List<Case> lst = new List<Case>();
        
        Case caseObj1 = new Case();
        caseObj1.RecordTypeId =recordTypeId;
        caseObj1.Status = 'Approved';
        caseObj1.AccountId = accobj.Id;
        caseObj1.Type = 'Account Ledger';
        caseObj1.Approval_Submitted_Date__c = Date.newInstance(2019, 12, 9);
        caseObj1.Level_1_Approved__c = false;
        caseObj1.Origin = 'Email';                                                                                                                                                                                                // Case Origin
        caseObj1.Priority = 'Medium';
        lst.add(caseObj1);
            
        Case caseObj2 = new Case();
        caseObj2.RecordTypeId = recordTypeId;
        caseObj2.Status = 'Approved';
        caseObj2.AccountId = accobj.Id;
        caseObj2.Approval_Submitted_Date__c = Date.newInstance(2019, 12, 9);
        caseObj2.Type = 'Invoice';
        caseObj2.Level_1_Approved__c = false;
        caseObj2.Origin = 'Email';                                                                                                                                                                                                // Case Origin
        caseObj2.Priority = 'Medium';
         lst.add(caseObj2); 
        
        
        test.startTest();
        
        insert lst;
        test.stopTest();
        idOfList.add(caseObj1.Id);
        
        
        //InvokeMexicoCaseAccess.caseAccessMethod(idOfList);
         
        //idOfList.clear();
        idOfList.clear();
        idOfList.add(caseObj2.Id);
        InvokeMexicoCaseAccess.caseAccessMethod(idOfList);
        

    
    
    }   
}