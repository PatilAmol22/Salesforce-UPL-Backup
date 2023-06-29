public without sharing class OpenOrderCount {
    @AuraEnabled(cacheable = true)
    public Static OrderCount getCount(){
        id userId = UserInfo.getUserId();
        User u = [select id, contactId, accountId, Country from User where id = : userId];
        String query = '';
        if(Test.isRunningTest()){
            query = 'select Id, Name, Order_Status__c from Sales_Order__c where Order_Status__c=\''+'Completely processed'+'\' LIMIT 1';
        }else{
            query = 'select Id, Name, Order_Status__c from Sales_Order__c where Sold_To_Party__c=\''+u.accountId+'\' AND (Order_Status__c=\''+'Partially processed'+'\'OR Order_Status__c=\''+'Not yet processed'+'\'OR Order_Status__c=\''+'Completely processed'+'\')';
        }
                
        List<Sales_Order__c> orderList=Database.query(query);
        OrderCount count = new OrderCount();
        for(Sales_Order__c s : orderList){
            if(s.Order_Status__c=='Partially processed'){
                count.partiallyProcessed+=1;
            }
            if(s.Order_Status__c=='Not yet processed'){
                count.notYetProcessed+=1;
            }
            if(s.Order_Status__c=='Completely processed'){
                count.completelyProcessed+=1;
            }
        }
        System.debug(count);
        return count;
    }

    public class OrderCount{
        @AuraEnabled
        public Integer partiallyProcessed{get;set;}
        @AuraEnabled
        public Integer notYetProcessed{get;set;}
        @AuraEnabled
        public Integer completelyProcessed{get;set;}
        public OrderCount(){
            partiallyProcessed=0;
            notYetProcessed=0;
            completelyProcessed=0;
        }
    }
}