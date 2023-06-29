@isTest
public class DistributorUploadServiceTest {
    static testMethod void Method(){
        DistributorUploadService.DistributorDetails ddObj = new DistributorUploadService.DistributorDetails();
        
        
        List<DistributorUploadService.DistributorDetails> distributorList = new List<DistributorUploadService.DistributorDetails>();
        Auto_Number__c auto = new Auto_Number__c();
        auto.Name='FarmerCode';
        auto.Sequence__c='11';
        
        insert auto;
        
        State__c st = new State__c();
        st.Name='test';
        st.Language__c='Gujarati';
        st.Country__c='India';
        insert st;
        
        District__c dis = new District__c();
        dis.Name='test';
        dis.State__c=st.Id;
       // dis.Active__c=True;
        insert dis;
        
        Tehsil__c ts = new Tehsil__c();
        ts.Name='vasai';
       // ts.Active__c=true;
        ts.District__c=dis.Id;
        insert ts;
        
        Village__c villObj = new Village__c();
        villObj.Name='vasai';
        villObj.Tehsil__c=ts.Id;
        villObj.Village_Code__c='650504';
        insert villObj;
        
        
        Account acc = new account();
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        acc.Name = 'test';
        acc.First_Name__c='test';
        acc.Last_Name__c='Test';
        acc.Mobile__c='9967341750';
        //acc.Village__pc=villObj.Id;
        //acc.Farmer_Code__pc = 'fm0'+String.valueOf(auto.Sequence__c);
        acc.Email__c='test@gmail.com';
        acc.Phone='101010100';
        acc.Sales_Office__c='test';
        acc.Plant__c='test';
        acc.BillingStreet='test';
        acc.BillingCity='test';
        acc.BillingState='test';
        acc.BillingPostalCode='test';
        acc.BillingCountry='test';
        acc.SAP_Code__c='test';
        insert acc;

        ddObj.lastName=acc.Last_Name__c;
        ddObj.billingStreet=acc.BillingStreet;
        ddObj.billingCity=acc.BillingCity;
        ddObj.billingState=acc.BillingState;
        ddObj.billingPostalCode=acc.BillingPostalCode;
        ddObj.billingCountry=acc.BillingCountry;
        ddObj.email=acc.Email__c;
        ddObj.mobile=acc.Mobile__c;
        ddObj.phone=acc.Phone;
        ddObj.salesOffice = acc.Sales_Office__c;
        ddObj.plant=acc.Plant__c;
        ddObj.accountRecordType=acc.RecordTypeId;
    	ddObj.distributorCode=acc.SAP_Code__c;
        ddObj.errorMessage='';
        distributorList.add(ddObj);
        DistributorUploadService.uploadAccounts(distributorList);
        
    }
        
}