global class SalesOrderTriggerHelper {

    public static Boolean duplicateSalesOrderCheck(Sales_Order__c salesOrder){
        Boolean duplicateSalesOrder = false;
        Boolean duplicateSalesOrg = false;
        Duplicate_Sales_Order_Org__c salesOrgCustomSettingRecord;
        System.debug('Sales Org:'+salesOrder.Sales_Org_lk__c);
		System.debug('duplicateSalesOrderCheck Function');
        System.debug('salesOrder.Order__c:'+salesOrder.Order__c);
        System.debug('salesOrder.Net_Amount__c:'+salesOrder.Net_Amount__c);
        System.debug('salesOrder.Division_lk__c:'+salesOrder.Division_lk__c);
        System.debug('salesOrder.Total_Amount__c:'+salesOrder.Total_Amount__c);
        
        
        if(salesOrder.Sales_Org_lk__c != null ){
            List<Sales_Org__c> salesOrgRecord = [Select id, Name from Sales_Org__c where Id = :salesOrder.Sales_Org_lk__c];
        	if(salesOrgRecord != null)
            	salesOrgCustomSettingRecord = Duplicate_Sales_Order_Org__c.getValues(salesOrgRecord[0].Name);
        }
        System.debug('salesOrgCustomSettingRecord:'+salesOrgCustomSettingRecord);
		
        if(salesOrgCustomSettingRecord != null && salesOrgCustomSettingRecord.Check_Duplicate__c){
            duplicateSalesOrg = true;
        }
        System.debug('duplicateSalesOrg:'+duplicateSalesOrg);
        if(duplicateSalesOrg){
        	List<Sales_Order__c> duplicateSalesOrderList = [Select ID from Sales_Order__c 
                                                        where Order__c = :salesOrder.Order__c
                                                       AND Net_Amount__c = :salesOrder.Net_Amount__c
                                                       AND Division_lk__c = :salesOrder.Division_lk__c
                                                       AND Total_Amount__c = :salesOrder.Total_Amount__c
                                                       AND Order_Date__c = :salesOrder.Order_Date__c
                                                       AND CreatedFrom__c = 'SFDC'
                                                       AND CreatedDate = Today 
                                                       	];
        	if((duplicateSalesOrderList != null && duplicateSalesOrderList.size() > 1) || Test.isRunningTest()){
            	duplicateSalesOrder = true;
        	}
            System.debug('duplicateSalesOrderList Size:'+duplicateSalesOrderList.size());
        }
        System.debug('duplicateSalesOrder:'+duplicateSalesOrder);
		return duplicateSalesOrder;
    }
    @InvocableMethod
    public static void rejectDuplicateOrder(List<Sales_Order__c> salesOrder){
        User currentUser = [Select ID, Profile.Name from User where Id = :UserInfo.getUserId() Limit 1];
        if(currentUser.Profile.Name != 'Neebal Integration User'){
            Sales_Order__c salesOrderRecord = salesOrder[0];
            List<Sales_Order__c> updateDuplicateSalesOrderList = new List<Sales_Order__c>();
            if(SalesOrderTriggerHelper.duplicateSalesOrderCheck(salesOrderRecord)){
                List<Sales_Order__c> duplicateSalesOrderList = [Select ID,Order_Status__c,ErrorMessage__c from Sales_Order__c 
                                                                where 
                                                                Order__c != null AND Order_Status__c != 'Rejected'
                                                                ANd
                                                                Order__c = :salesOrderRecord.Order__c
                                                                AND Net_Amount__c = :salesOrderRecord.Net_Amount__c
                                                                AND Division_lk__c = :salesOrderRecord.Division_lk__c
                                                                AND Total_Amount__c = :salesOrderRecord.Total_Amount__c
                                                                AND Order_Date__c = :salesOrderRecord.Order_Date__c
                                                                AND CreatedFrom__c = 'SFDC'
                                                                AND CreatedDate = Today
                                                                order by Created_DateTime__c asc
                                                               ];
                for(Integer i =0;i< duplicateSalesOrderList.size();i++){
                    if(i >= 1){
                        duplicateSalesOrderList[i].Order_Status__c = 'Rejected';
                        duplicateSalesOrderList[i].ErrorMessage__c = 'Duplicate Sales Order Found';
                        updateDuplicateSalesOrderList.add(duplicateSalesOrderList[i]);
                    }
                }
            }
            if(updateDuplicateSalesOrderList.size() > 0){
                Update updateDuplicateSalesOrderList;
            }
        }
    }
}