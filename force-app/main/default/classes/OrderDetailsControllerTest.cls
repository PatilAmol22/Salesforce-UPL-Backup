@isTest
public class OrderDetailsControllerTest {
    private static testMethod void unit1(){
        Id AccRecordId = Schema.SObjectType.account.getRecordTypeInfosByDeveloperName().get('Hannaford_Farm').getRecordTypeId();
        Id idRecordId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('Hannaford_General_Query').getRecordTypeId();
        Account acc = new Account(Name = 'Test', Email__c = 'kuhinoor.barbhuiya@ibm.com',
                                  LegacyId__c='112233', Mobile__c='1234567890',recordTypeId = AccRecordId,
                                 Country__c = 'Other', Tax_classification_for_customer__c= '1' );
        insert acc;
        system.assertEquals(acc.name, 'Test');
        case cs = new case(subject = 'Test', recordTypeId = idRecordId, type='Open',
                           AccountId = acc.Id, SuppliedEmail ='kuhinoor.barbhuiya@ibm.com');
        insert cs;
        
        Contract cr = new Contract(accountId = acc.Id, status='Draft');
        insert cr;
        OrderDetailsController.getContracts(cs.Id);
        
        Order odr = new Order(ContractId= cr.Id , AccountId= acc.Id,
                             EffectiveDate = Date.today(), status='Draft');
        insert odr;
        
        OrderDetailsController.getOrders(cs.Id); 
    }
}