@isTest
public class Grz_LineItemRejectedresonUpdateTest {
    public static testmethod void unitTest(){
        test.startTest();
        Rejection_Status__c ob= new Rejection_Status__c();
        ob.Rejection_Description__c='test description';
        ob.Rejection_Code__c='12323';
        insert ob;
        
        
        Sales_Order__c so = new Sales_Order__c();
        so.Order_Date__c = system.today();
        so.CreatedFrom__c = 'SFDC';
        so.OwnerId = UserInfo.getUserId();
        so.Order_Status__c = 'Draft';
        Insert so;
        
        Sales_Order_Line_Item__c sliObj = new Sales_Order_Line_Item__c();
        sliObj.Rejection_Code__c=ob.id;
        sliObj.Sale_Order__c = so.Id;
        //sliObj.Rejected_Reason__c=' ';
        list<Sales_Order_Line_Item__c> salesLineItemList= new list<Sales_Order_Line_Item__c>();
        salesLineItemList.add(sliObj);
        
        Insert salesLineItemList;
        system.debug('salesLineItemList:'+salesLineItemList);
        Grz_LineItemRejectedresonUpdate ob1= new Grz_LineItemRejectedresonUpdate();
        dataBase.executeBatch(ob1);
        test.stopTest();
        
        
    }
}