@isTest
public class RecallRSOController_Test {
@isTest
    public static void sampleData(){
        
        Account accObj = new Account();
        accObj.Name='Agrolic Pharma Pvt Ltd';
        accObj.SAP_Code__c='319362';
        accObj.Account_Type__c='Sold To Party';
        insert accObj;
        
        Return_Sales_Order__c rsoList = new Return_Sales_Order__c();
        rsoList.Order_Status__c='Pending';
        rsoList.Return_Type__c='Commercial';
        rsoList.RSO_SFDC_Number__c='122345';
        rsoList.RSO_Raised_By__c='Sales Rep';
        rsoList.Refusal__c='No';
        rsoList.Sub_Status__c='Pending At Quality Team';
        rsoList.Comment__c='Go for Approval';
        rsoList.Customer__c=accObj.Id;
        insert rsoList;
        
        
        
       
        
      
         test.startTest();
         RecallRSOController.getRSO(rsoList.Id);
         RecallRSOController.getPicklistValue(rsoList.Return_Type__c, rsoList.RSO_Raised_By__c, rsoList.Sub_Status__c, rsoList.Refusal__c);
         RecallRSOController.updateRSO(rsoList.Id,rsoList.Sub_Status__c,rsoList.Comment__c);
        test.stopTest();
    }
}