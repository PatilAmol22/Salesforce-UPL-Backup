/* Name: GetNAMYOYGrowthEDISalesTest (test class)
/Created On: 17 Oct 2022
/Author: Ankita&Krishanu (Ankita&Krishanu@wipro.com)
/Description: Apex Class used for test coverage of GetNAMYOYGrowthEDISales apex class
/Project: UPL USA Ignite

*/@isTest 
public class GetNAMYOYGrowthEDISalesTest 
{
      static testMethod void testMethod1() 
    {
        Secondary_Sales_Data__c invcy = new Secondary_Sales_Data__c();
        Secondary_Sales_Data__c invpy = new Secondary_Sales_Data__c();
        
        id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();
        
        Sales_Org__c sorg = new Sales_Org__c();
        sorg.Name='USA';
        sorg.Sales_Org_Code__c='3100';
        insert sorg;
        
        Division__c div = new Division__c();
        div.Name='Decco';
        div.Description__c='Decco';
        div.Division_Code__c = 'DC';
        insert div; 
        
        Depot__c dep = new Depot__c(
            Name = 'UPL Do Brasil - Aparecida de Goiania',  // Depot Name
            Country__c = 'Brazil',                          // Country
            Depot_Code__c = 'BR04',                         // Depot Code
            Active__c = true,                               // Active
            SalesOrg__c = sorg.Id                           // Sales Org
        );
        insert dep;
        Distribution_Channel__c dChannel= new Distribution_Channel__c();
        dChannel.Name='10';
        dChannel.Distribution_Channel_Code__c = '10';
        
        insert dChannel;
        
        Account acc1 = new Account();
        acc1.Name='LEONARDO DICAPRIO';
        acc1.Email__c = 'ganesh0539@gmail.com';
        acc1.Last_Name__c='DECAPRIO';
        acc1.SAP_Code__c='2028844';
        acc1.RecordTypeId = devRecordTypeId;
        acc1.Mobile__c = '9967341759';
        acc1.Phone = '01234567891';
        acc1.Sales_Org__c = sorg.Id;
        acc1.Division__c=Div.Id;
        acc1.Distribution_Channel__c=dChannel.Id;
        acc1.BillingCity='MINEIROS';
        acc1.Depot_Code__c=dep.Id;
        acc1.Tax_Number_3__c='114415456';
        acc1.Tax_Number_1__c='114445896';
        acc1.Customer_Region__c='AC';
        acc1.Customer_Group__c='675';
        acc1.Program_Margin_Discount__c=0.00;
        acc1.Active__c=true;
        acc1.Search_Terms_1__c='LEONARDO DICAPRIO';
        acc1.Search_Terms_2__c='FAZ SEUBAK1';
        insert acc1;
        
        
        invcy.Year__c='2022';
        invcy.Month__c='10';
        invcy.Customer_Name__c=acc1.id;
        //invcy.Sold_To_Party__c=acc1.id;
        //invcy.Sales_Order__c=sobj.id;
        
        invpy.Year__c='2021';
        invpy.Month__c='10';
        invpy.Customer_Name__c=acc1.id;
        //invpy.Sold_To_Party__c=acc1.id;
        //invpy.Sales_Order__c=sobj.id;
        
        insert invcy;
        insert invpy;
        
        Test.startTest();

            GetNAMYOYGrowthEDISales obj = new GetNAMYOYGrowthEDISales();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}