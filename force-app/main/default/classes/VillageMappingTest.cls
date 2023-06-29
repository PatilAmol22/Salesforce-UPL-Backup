@isTest
public class VillageMappingTest {
    public static testMethod void unit1(){
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Farmer').getRecordTypeId();
        State__c st = new State__c(Name = 'Assam');
        insert st;
        
        District__c ds = new District__c(Name = 'Cacher', State__c= st.Id);
        insert ds;
        
        Tehsil__c ts = new Tehsil__c(Name = 'Cacher', District__c= ds.Id);
        insert ts;
        
        Village__c vill = new Village__c(Name = 'DidarKush', Tehsil__c= ts.Id, Postal_Code__c ='788099'); 
        insert vill;
        
        Account acc = new Account(LastName = 'TestAcc', VillageName__c = 'DidarKush',
                                  District__c = 'Cacher', StateName__c ='Assam',
                                  PersonMobilePhone = '1234567890' ,recordTypeId = RecordTypeId);
        insert acc;
        system.assertEquals(acc.LastName, 'TestAcc');
        
        
        
    }
}