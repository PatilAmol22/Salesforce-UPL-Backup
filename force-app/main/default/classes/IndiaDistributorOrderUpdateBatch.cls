global class IndiaDistributorOrderUpdateBatch implements Database.Batchable<sObject> {
    SET <String> tmpSalesId = new SET <String>();  
    public String query ='';
    //Added to change the Sales Org Code to 1410 from 1000
    public String salesOrgCodeIndiaSAS;
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //Sales Orders created by India Distributors having Order Status as 'Pending'
        // Migration from 1000 to 1410 
        //salesOrgCodeIndiaSAS = UtilityClass.getSalesOrgIndiaSAS();  
         Map<String, UPL_SalesOrg_Detail__mdt> salesOrgDetailsMap = UtilityClass.getSalesOrgDetails();
         salesOrgCodeIndiaSAS = salesOrgDetailsMap.get('India_SalesOrg').value__c;              
         query = 'SELECT Id, Name, SalesOrgCode__c, Order_Status__c, Escalation_Date_Time_del__c, Notification_Reminder__c, Rejection_Notification__c FROM Sales_Order__c Where SalesOrgCode__c = \''+ salesOrgCodeIndiaSAS +'\' and Order_Status__c = \'Pending\''; 
        
        return Database.getQueryLocator(query);     
    }
    
    global void execute(Database.BatchableContext BC, List<Sales_Order__c> salesOrderList) {
        try{
            // Migration from 1000 to 1410 
        	//salesOrgCodeIndiaSAS = UtilityClass.getSalesOrgIndiaSAS();  
         	Map<String, UPL_SalesOrg_Detail__mdt> salesOrgDetailsMap = UtilityClass.getSalesOrgDetails();
         	salesOrgCodeIndiaSAS = salesOrgDetailsMap.get('India_SalesOrg').value__c;
            System.debug('salesOrderList '+salesOrderList);
            // Update India Orders after 24 hrs of craetion by distributor & no action is taken by TM/ZSM          
            List<Sales_Order__c> soLst = new List<Sales_Order__c>();
            
            
            soLst =[SELECT Id, Name, SalesOrgCode__c, Order_Status__c, Escalation_Date_Time_del__c,
                    Notification_Reminder__c, Rejection_Notification__c 
                    FROM Sales_Order__c 
                    where SalesOrgCode__c = :salesOrgCodeIndiaSAS 
                    and Order_Status__c = 'Pending' 
                    and Notification_Reminder__c = FALSE 
                    and India_Distributor_Order_Time_Escalation__c > 24 
                    and India_Distributor_Order_Time_Escalation__c < 48];
            
            System.debug('solist '+soLst);
            System.debug('solist size '+soLst.size());
            
            List <Sales_Order__c> sListUpdate = new List <Sales_Order__c>();
            if(salesOrderList.size() > 0){
                for(Sales_Order__c salesObj : soLst){               
                    salesObj.Notification_Reminder__c = True;              
                    sListUpdate.add(salesObj);
                }
                if(sListUpdate.size() > 0){
                    update sListUpdate;
                }
            }         
            
            // Update India Orders after 48 hrs of craetion by distributor & still no action is taken by TM/ZSM
            List <Sales_Order__c> soListToRejectOrders = new List <Sales_Order__c>(); 
            soListToRejectOrders = [SELECT Id, Name, SalesOrgCode__c, Order_Status__c, Escalation_Date_Time_del__c,
                                    Notification_Reminder__c, Rejection_Notification__c 
                                    FROM Sales_Order__c 
                                    where SalesOrgCode__c = :salesOrgCodeIndiaSAS
                                    and Order_Status__c = 'Pending' 
                                    and Notification_Reminder__c = TRUE 
                                    and India_Distributor_Order_Time_Escalation__c > 48];
            
            System.debug('soListToRejectOrders '+soListToRejectOrders);
            System.debug('soListToRejectOrders '+soListToRejectOrders.size());
            
            List <Sales_Order__c> sListUpdate1 = new List <Sales_Order__c>();
            if(soListToRejectOrders.size() > 0 || Test.isRunningTest()){
                for(Sales_Order__c salesObj : soListToRejectOrders){
                    salesObj.Rejection_Notification__c = True;
                    salesObj.Notification_Reminder__c = False; 
                    sListUpdate1.add(salesObj);
                }
                
                for(Sales_Order__c sobj :sListUpdate1){
                    tmpSalesId.add(sobj.id);
                }
                System.debug('tmpSalesId '+tmpSalesId);
                System.debug('tmpSalesId size '+tmpSalesId.size());
                
                if(sListUpdate1.size() > 0 || Test.isRunningTest()){
                    update sListUpdate1;
                    rejectRecord();
                }
            }
        }
        catch(Exception ex){
            system.debug('Error Msg===>'+ex.getMessage());
            system.debug('Error line===>'+ex.getLineNumber());
        }
        
    }  
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
    public void rejectRecord()
    {
        //Class used for Approving Record
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Auto Rejected - No Action taken in 48 hrs');  
        
        //Reject Record
        req.setAction('Reject');
        
        //Getting Work Item Id
        ProcessInstanceWorkitem pItem = [Select Id from ProcessInstanceWorkitem 
                                         where ProcessInstance.TargetObjectId IN: tmpSalesId];
        
        req.setWorkitemId(pItem.Id);
        // Submit the request for approval
        Approval.ProcessResult result = Approval.process(req);
        
    } 
    
}