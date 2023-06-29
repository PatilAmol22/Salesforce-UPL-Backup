@isTest
public class Grz_ActivityContactMappingCETest {
     @isTest
    public static void method1(){
        
    string ActivityId = Schema.SObjectType.Event.getRecordTypeInfosBydevelopername().get('Europe_Farmer_Activity').getRecordTypeId();
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
    
    event c = new event();
    c.subject = 'c1';
       c.StartDateTime = date.today();
        c.EndDateTime = date.today();
    c.recordtypeid = ActivityId ;
    try{
    insert c;
    }catch (DmlException e){
            System.assert( e.getMessage().contains('Please create Event for related account type'));

    }
   } 
    }
}