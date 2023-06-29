/**************************************************************************************************
* Name               : StrategicAccountTest                                                      
* Description        : Test class for StrategicAccount and AccountStrategic
* Created Date       : 20/07/2022                                                                 
* Created By         : Ishita (Grazitti)
* Ticket Number		 :  RITM0245056
**************************************************************************************************/
@isTest
public class StrategicAccountTest {
    static testMethod void testMethod1()   
    {
        Account tstaccount = TestDataFactory.CreateAccount('1001801');
      	Test.StartTest(); 
        StrategicAccount.getContactsRelatedToAccount(tstaccount.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(tstaccount);
        AccountStrategicClass testAccPlan = new AccountStrategicClass(sc);
        
        PageReference pageRef = Page.AccountStrategicCustomerProfile; 
        pageRef.getParameters().put('id', String.valueOf(tstaccount.Id));
        Test.setCurrentPage(pageRef);
        Test.StopTest(); 
    }
}