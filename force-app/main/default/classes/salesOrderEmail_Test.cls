@isTest
public class salesOrderEmail_Test {
    @isTest
    public static void testSalesOrderEmail(){
    String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');   
    Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
    String orgId = UserInfo.getOrganizationId();
    String uniqueName = orgId + dateString + randomInt;
        
       Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Account a1 = new Account();
        a1.Name = 'Test';
        a1.RecordTypeId = RecordTypeId;
        a1.SAP_Code__c = '12346';
        insert a1;
        
        Contact c = new Contact();
        c.AccountId=a1.Id;
        c.LastName='Test';
        c.Is_Community__c = true;
        c.Email='test@test.com';
        insert c;
        
        Sales_Order__c s1 = new Sales_Order__c();
        s1.Sold_to_Party__c=a1.Id;
        s1.Order_Status__c='Rejected';
        insert s1;
        
      
        List<Id> id = new List<Id>();
        id.add(s1.Id);
        
        Test.startTest();
      //  salesOrderEmail s = new salesOrderEmail();
        salesOrderEmail.sendSOEmails(id);
        Test.stopTest();
          
    }
}