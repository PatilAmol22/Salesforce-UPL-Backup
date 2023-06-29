/**************************************************************************************************
* Name             : Grz_CaseOrderCountInvocableClass                                                      
* Description      : Invocable class created to pass relevant case and sales order count to the Grz_UPLArgCaseCount screen flow
* Test Class       : Grz_CaseOrderCountInvocableClassTest
* Created Date     : 09-08-2022                                                                        
* Project/JIRA     : APPS-1757                                                                        
* Created By       : Gurubaksh Grewal (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 16-08-2022                                                                        
**************************************************************************************************/

public with sharing class  Grz_CaseOrderCountInvocableClass {
    @InvocableMethod(label='Get Order and Case Count' description='Returns the required count' category='Integer')
    public static List<FlowVariables> getCountList(List<FlowVariables> FlowVariables) {
        String userId=FlowVariables[0].UserId;
        Id caseRecId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Argentina_Distributor').getRecordTypeId();
        user loggedUser=[SELECT ID,AccountID FROM User WHERE ID =: userId]; 
        
        integer caseCount=0;
        integer orderCount=0;
        List<String> salesorgcode = System.Label.Grz_ArgentinaSalesOrgCode.trim().Split(',');
        list<string>caseStatus=new list<string>{'Approved','Rejected','Pending','Closed'};
            list<string>orderStatus=new list<string>{'Open','Pending','Not yet processed','Partially processed','Completly processed','Completely processed'};
                list<string>caseTypes=new list<string>{'Batch error','Product Return – Due','Product Return - Near Expiry','Return - Product spill / Break'};
                    
                    if(loggedUser.AccountId==null){
                        caseCount=[SELECT count() FROM Case WHERE CreatedDate = THIS_FISCAL_YEAR AND Type in: caseTypes AND Status in: CaseStatus AND RecordTypeId =: caseRecId];   
                        orderCount=[SELECT count()  FROM Sales_Order__c WHERE Order_Status__c in: orderStatus AND CreatedDate = THIS_FISCAL_YEAR AND SalesOrgCode__c in: salesorgcode];   
                    }else {
                        caseCount=[SELECT count() FROM Case WHERE CreatedDate = THIS_FISCAL_YEAR AND Type in: caseTypes AND Status in: CaseStatus AND RecordTypeId =: caseRecId AND AccountId =: loggedUser.AccountId];
                        orderCount=[SELECT count()  FROM Sales_Order__c WHERE Order_Status__c in: orderStatus AND CreatedDate = THIS_FISCAL_YEAR AND Sold_to_Party__c =: loggedUser.AccountId AND SalesOrgCode__c in: salesorgcode];   
                    }               
         
        FlowVariables[0].CaseCount=CaseCount;
        FlowVariables[0].OrderCount=OrderCount;
        
        return FlowVariables;
    }
    
    public class FlowVariables {
        @InvocableVariable(required=true  label='UserId')
        public String UserId;
        @InvocableVariable(required=true  label='CaseCount')
        public Integer CaseCount;
        @InvocableVariable(required=true  label='OrderCount')
        public Integer OrderCount;
    }
}