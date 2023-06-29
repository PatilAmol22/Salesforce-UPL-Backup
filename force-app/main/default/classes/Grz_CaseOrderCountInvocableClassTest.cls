/**************************************************************************************************
* Name             : Grz_CaseOrderCountInvocableClassTest                                                     
* Description      : To cover the invocable class created for Grz_UPLArgCaseCount flow
* Created Date     : 09-08-2022                                                                        
* Project/JIRA     : APPS-1757                                                                        
* Created By       : Gurubaksh Grewal (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 16-08-2022                                                                        
**************************************************************************************************/

@isTest
public class Grz_CaseOrderCountInvocableClassTest {
    Public  static testmethod void testMethod1(){
		//new map<string,object>{'UserId'=>UserInfo.getUserId(),'CaseCount'=>0,'OrderCount'=>0}
		Grz_CaseOrderCountInvocableClass.FlowVariables fv=new Grz_CaseOrderCountInvocableClass.FlowVariables();
        fv.CaseCount=0;
        fv.OrderCount=0;
        fv.UserId=UserInfo.getUserId();
        Test.startTest();
        Grz_CaseOrderCountInvocableClass.getCountList(new list<Grz_CaseOrderCountInvocableClass.FlowVariables>{fv});
        Test.stopTest();
    }
    
}