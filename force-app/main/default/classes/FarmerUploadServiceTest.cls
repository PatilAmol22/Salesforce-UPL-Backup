@isTest
public class FarmerUploadServiceTest {
    static testMethod void Method(){
        FarmerUploadService.FarmerDetails fdObj = new FarmerUploadService.FarmerDetails();
        
        
        List<FarmerUploadService.FarmerDetails> farmerList = new List<FarmerUploadService.FarmerDetails>();
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
        //dis.Active__c=True;
        insert dis;
        
        Tehsil__c ts = new Tehsil__c();
        ts.Name='vasai';
        //ts.Active__c=true;
        ts.District__c=dis.Id;
        insert ts;
        
        Village__c villObj = new Village__c();
        villObj.Name='vasai';
        villObj.Tehsil__c=ts.Id;
        villObj.Village_Code__c='650504';
        insert villObj;
        
        
        Account acc = new account();
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
        //acc.Name = 'test';
        acc.FirstName='test';
        acc.LastName='test';
        acc.PersonMobilePhone='9967341755';
        acc.Village__pc=villObj.Id;
        acc.Farmer_Code__pc = 'fm0'+String.valueOf(auto.Sequence__c);
        acc.PersonEmail='test@gmail.com';
        acc.Phone='9967341753';
        acc.WRMS_Code__c='1222';
        acc.BillingStreet='test';
        acc.BillingCity='test';
        acc.BillingState='test';
        acc.BillingPostalCode='test';
        acc.BillingCountry='test';
      
        insert acc;
        
        
        
        
        
        fdObj.firstName=acc.First_Name__c;
        fdObj.lastName=acc.Last_Name__c;
        fdObj.billingStreet=acc.BillingStreet;
        fdObj.billingCity=acc.BillingCity;
        fdObj.billingState=acc.BillingState;
        fdObj.billingPostalCode=acc.BillingPostalCode;
        fdObj.billingCountry=acc.BillingCountry;
        fdObj.email=acc.Email__c;
        fdObj.mobile=acc.Mobile__c;
        fdObj.phone=acc.Phone;
        fdObj.villageCode=acc.Village__pc;
        //fdObj.villageCode=villObj.Id;
        fdObj.wrmsCode = acc.WRMS_Code__c;
        fdObj.accountRecordType=acc.RecordTypeId;
        //fdObj.sfdcId=acc.id;
        farmerList.add(fdObj);
        FarmerUploadService.uploadAccounts(farmerList);
        
    }
    
}