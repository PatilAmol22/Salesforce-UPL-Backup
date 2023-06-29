@isTest
public class SOROrderDetailsChildControllerTest {
 @TestSetup
    public static void testData(){
        Sales_Org__c so = new Sales_Org__c();
        so.Name = 'Brazil';            
        so.Company_Code__c = '5190';        
        so.Sales_Org_Code__c = '5191';      
        so.Country_Code__c = 'BR';     
        insert so;
        
        Depot__c dp =new Depot__c ();
        dp.Name='Brazil';
        dp.Country__c='Brazil';
        dp.Depot_Code__c='CL00';
        dp.SalesOrg__c = so.Id;
        insert dp;
        
        Account accObj = new Account();
        accObj.Name='Test User';
        accObj.SAP_Code__c = '0001013292';              
        accObj.Last_Name__c = 'UserTest';     
        accObj.Order_Block__c = false;                       
        accObj.Mobile__c = '1234567890';  
        accObj.Phone='2345678909'; // Mobile
        accObj.Email__c = 'test@gmail.com';       
        accObj.Account_Type__c = 'Sold To Party';           
        accObj.Raise_Order_Type__c = 'Factura';                 
        accObj.Billing_Street_2__c = 'CATAMARCA 3454';      
        accObj.Sales_Org__c = so.id; 
        accObj.Brazil_Depot_Code__c=dp.Id;
        accObj.Active__c=true;
        insert accObj;
        
        Territory_Distributor__c td=new Territory_Distributor__c();
        td.Name='test';
        td.SalesOrg__c=so.Id;
        insert td;
        
        Customer_and_Region_Mapping__c crm=new Customer_and_Region_Mapping__c();
        crm.Active__c=true;
        crm.Customer_Name__c=accObj.Id;
        crm.CustomerRegion__c=td.Id;
        insert crm;
        
        Rebate_Contract__c rc=new Rebate_Contract__c();
        rc.Name='test';
        rc.Sales_Org__c=so.Id;
        rc.Distributor__c=accObj.Id;
        insert rc;

        
        RSO_Return_Sub_Status__c st=new RSO_Return_Sub_Status__c();
        st.Sub_Return_Type_Code__c='st123';
        insert st;
       
                
    }
    @istest
    public static void testClassMethod(){
        RSO_Return_Sub_Status__c rrst=[select id,Return_Type__c from RSO_Return_Sub_Status__c];
        Account acc=[select id from Account];
        Customer_and_Region_Mapping__c crm=[select Id from Customer_and_Region_Mapping__c];
        string rrstString=rrst.Return_Type__c;
        String accId=acc.Id;
        Test.startTest();
        SOROrderDetailsChildController.getSubReturnTypes(rrstString);
        SOROrderDetailsChildController.getRebateRegionDistrict(crm.Id);
        SOROrderDetailsChildController.getRebateContract(accId);
          //SORIntegrationService.updateCSWithSAP(httpList,'','');
        // SORIntegrationService.responseToCustmerService();
        Test.stopTest();
    }
}