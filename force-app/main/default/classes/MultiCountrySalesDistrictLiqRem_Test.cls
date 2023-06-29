@isTest
public class MultiCountrySalesDistrictLiqRem_Test {
    @isTest
    static void TestSalesDistrictLiqSchTurkey(){
    String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');   
    Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
    String orgId = UserInfo.getOrganizationId();
    String uniqueName = orgId + dateString + randomInt;

        Sales_Org__c salesOrgTurkey = new Sales_Org__c(
        Name = 'Turkey',               
        Company_Code__c = '7100',        
        Sales_Org_Code__c = '7110',      
        Description__c = 'Turkey'      
       );
       insert salesOrgTurkey;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt1', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            Country = 'Turkey',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id,                 
            TimeZoneSidKey='America/Los_Angeles',
            email = uniqueName + '@test' + orgId + '.org',
            Username = uniqueName + '@test' + orgId + '.org');
        insert u;
        
   /*     User u2 = new User(Alias = 'standt2', Email='standarduser2@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2@testorg.com');
        insert u2; */
        
        Sales_District__c s1 = new Sales_District__c();
        s1.SalesOrg__c = salesOrgTurkey.Id;
        s1.User__c = u.Id;
        s1.Sales_District_Code__c = '4684684';
        insert s1;
        
        Sales_District__c s2 = new Sales_District__c();
        s2.SalesOrg__c = salesOrgTurkey.Id;
        s2.User__c = u.Id;
        s2.Sales_District_Code__c = '46846784';
        insert s2;
        
        Liquidation_Annual_Plan__c lap1 = new Liquidation_Annual_Plan__c();
        lap1.Fiscal_Start_Date__c = Date.parse('01/04/20');
        insert lap1;
        
        Liquidation2__c l1 = new Liquidation2__c ();
        l1.Sales_District__c = s1.Id;
        l1.Month__c = 'Nov';
        l1.Liquidation_Annual_Plan__c = lap1.Id;
        l1.Distributors_Inventory__c=0;
        l1.Retailers_Inventory__c=0;
        l1.Plan_for_the_month__c=0;
        insert l1;
        
        MultiCountrySalesDistrictLiqReminder sh1 = new MultiCountrySalesDistrictLiqReminder();      
         String sch = '30 5 11 27 10 ? *';
         system.schedule('Test', sch, sh1);
            
    }
}