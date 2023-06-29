@isTest
public class ContactTrigger_Test {
    @isTest
    public static void method1(){
        Sales_Org__c sorg =new Sales_Org__c();
        sorg.Name='Canada';
        sorg.Description__c='Canada';
        sorg.Sales_Org_Code__c='3710';
        insert sorg;
        Account acc = TestDataFactory.CreateAccount('0001033509');
        acc.Combination_Key__c='00010335080001033508';
        acc.Sales_Org__c=sorg.id;
        update acc;
        Contact c=new Contact();
        c.lastname='ammu';
        c.AccountId=acc.id;
        c.phone=null;
        try{
        insert c;
            c.Phone='987789987r';
                update c;
        }
        
        catch(Exception e){
            system.debug(e.getMessage());
            //system.assert(e.getMessage().contains('Phone Number is required and should not conatin special characters except'));
        }
    }
    
    
    @isTest
    public static void method2(){
    
    string conid = Schema.SObjectType.Contact.getRecordTypeInfosBydevelopername().get('Europe_Retailer_Contact').getRecordTypeId();
    string Accid = Schema.SObjectType.Account.getRecordTypeInfosBydevelopername().get('Europe_Retailer_Account').getRecordTypeId();
    
    profile p = [select id,name from profile where name = 'Central Europe Sub Region Head'];
    
    user u = new user();
    u.profileid = p.id;
    
    
    u.LastName = 'LIVESTON';
    u.FirstName='JASON';
    u.Alias = 'jliv';
    u.Email = 'jason1234.liveston@asdf.com';
    u.Username = 'jason12345.liveston@asdf.com';
    u.TimeZoneSidKey = 'GMT';
    u.LanguageLocaleKey = 'en_US';
    u.EmailEncodingKey = 'UTF-8';
    u.LocaleSidKey = 'en_US';
    insert u;
    
    
    Sales_org__c sal = new sales_org__c();
    sal.name = 'Romania';
    sal.Sales_Org_Code__c = '2081';
    insert sal;
    
    system.runas(u){
    account a = new account();
    a.name='test';
    a.recordtypeid = Accid ;
    a.Sales_Org__c = sal.id;
        a.BillingStreet='abc';
        a.BillingCity='abc';
        a.BillingPostalCode='123455';
        a.romania_county__c='Bucuresti';
        a.Major_suppliers__c='test supplier';
    insert a;
    
    contact c = new contact();
    c.lastname = 'c1';
    c.recordtypeid = conid ;
    try{
    insert c;
    }catch (DmlException e){
            System.assert( e.getMessage().contains('Please create contact for related account type'));

    }
   } 
    }
}