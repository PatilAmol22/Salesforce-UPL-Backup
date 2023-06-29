@isTest
public class InvokeCasePDF_Test {
    @isTest
    static void test1(){
        List<String> idList = new List<String>();
        
        //Prerequisite for account and case object
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        insert auto;
        
        //Prerequisite for account and case object
        Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
        tsObj1.Name = 'CaseTrigger';
        tsObj1.isActive__c = True;
        insert tsObj1;
        
        
        Account acc= new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('US Distributor').getRecordTypeId();
        acc.Name = 'Accountt';
        acc.BillingStreet = 'DSP road';
        acc.BillingCity = 'MUMBAI';
        acc.BillingCountry = 'INDIA';
        acc.BillingState = 'MAHARASHTRA';
        acc.BillingPostalCode = '400068';
        acc.Phone='1010101004';
        acc.WRMS_Code__c='1222';
        insert acc; 
        
        SKU__c skuo = new SKU__c();
        skuo.Name = 'MANCO';
        skuo.SKU_Code__c = 'sku001';
        skuo.Combination_Key__c = '3213456796854';
        insert skuo;
        
        
        
        Case caseObj = new Case();
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('US Distributor').getRecordTypeId();
        caseObj.Status = 'Closed';
        caseObj.AccountId = acc.Id;
        caseObj.Pack_Size_SKU__c =skuo.Id;
        caseObj.Total_Volume_Effected__c = 21;
        caseObj.Units_1__c = 'Ounces';
        caseObj.List_Price_of_Complaint_Product_Unit__c = 32;
        
        
        
        test.startTest();
        insert caseObj;
        test.stopTest();
        List<Case> lst = [Select Id from Case where ID=:caseObj.Id];
        for(Case c : Lst){
            idList.add(c.Id);
        }
        PageReference pageRef = Page.AttachPdfCase;
        
        Test.setCurrentPage(pageRef); 
        
        Blob content = Blob.valueOf('UNIT.TEST');//Just use blob.value of .In your actual code you can add istestRunning
        
        InvokeCasePDF.savePDF(idList);
    }
}