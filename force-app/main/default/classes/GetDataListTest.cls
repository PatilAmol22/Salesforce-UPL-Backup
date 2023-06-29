@isTest
public class GetDataListTest {
    static testMethod void getdata(){
       
        
        GetDataList.getlistdata('Depot__c', 'Depot_Code__c');
        GetDataList.getlistdata('Stock_Requirement__c', 'SKU__r.SKU_Description__c');
        GetDataList.getlistdata('Stock_Requirement__c', 'SKU__r.Brand_Name__c');
        GetDataList.getlistdata('Stock_Requirement__c', 'SKU__r.SKU_Code__c');
        
        
       
    }
}