@isTest
public class StockInChannelServiceHelper_Test {
      
   static testMethod void CallStockInChannelHelper()
    {
        Account acc = TestDataFactory.CreateAccount('0001033257');
        insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18,BR_Sales_Org__c='5191',Stock_in_Channel_RFC__c='www.www.com',HCI_User_Name__c='test',HCI_Password__c='test');  
        GetStockInChannelRequestWrapper reqSIC= new GetStockInChannelRequestWrapper();
		reqSIC.companyCode='5190';
		reqSIC.initialCustomerCode='0001033257';
        Boolean temp;
        temp=StockInChannelServiceHelper.GetStockInChannel(reqSIC);
        GetStockInChannelRequestWrapper reqSIC2= new GetStockInChannelRequestWrapper();
		reqSIC2.companyCode='5190';
		reqSIC2.initialCustomerCode='0001033253';
        temp=StockInChannelServiceHelper.GetStockInChannel(reqSIC);
        
    }

}