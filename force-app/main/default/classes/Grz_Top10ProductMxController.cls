public with sharing class Grz_Top10ProductMxController {
    
	@AuraEnabled
    public static List<DataSet> getTop10ProductCustomer(){
        Id id = UserInfo.getUserId();
        String salesorgcode = System.Label.Grz_MexicoSalesOrgCode;
        List<User> user = [SELECT Id, Username, AccountId, userRole.name, ContactId FROM User where Id =: id];
        String query = 'SELECT SKU_Name__r.Brand_Name__c brandname, COUNT(Brand_Name__c) cnt FROM Sales_Order_Line_Item__c where Sale_Order__r.SalesOrgCode__c =: salesorgcode and SKU_Name__r.Brand_Name__c != null and createddate = THIS_FISCAL_YEAR ';
        
        if(user[0].AccountId != null){
            String accountId = user[0].AccountId;
            query += 'and Sale_Order__r.Sold_to_Party__c =:accountId group by SKU_Name__r.Brand_Name__c order by COUNT(Brand_Name__c) desc limit 10';
        }else{
            query += 'group by SKU_Name__r.Brand_Name__c order by COUNT(Brand_Name__c) desc limit 10';
        }
        
        //List<AggregateResult> result =  [SELECT SKU_Name__r.Brand_Name__c brandname, COUNT(Brand_Name__c) cnt FROM Sales_Order_Line_Item__c where Sale_Order__r.SalesOrgCode__c = '5100' and SKU_Name__r.Brand_Name__c != null and createddate = THIS_FISCAL_YEAR group by SKU_Name__r.Brand_Name__c order by COUNT(Brand_Name__c) desc limit 10];
        List<DataSet> dataSet = new List<DataSet>();
        for(AggregateResult ar:Database.query(query)){
            String status =  (String)ar.get('brandname');
            Integer total =(Integer)ar.get('cnt');
            dataSet.add(new DataSet(status ,total));            
        }
        System.debug('dataSet'+dataSet);  
        return dataSet ; 
    }
    
    public class DataSet{
        public DataSet(String label ,Integer count){
            this.label  = label ; 
            this.count = count ;
        }
        
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public Integer  count {get;set;}
        
    }
}