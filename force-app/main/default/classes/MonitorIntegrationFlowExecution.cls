public class MonitorIntegrationFlowExecution {
    
    
    public void callwebservice(String recordID){

        System.debug('recordId --->'+recordID);
        List<Monitor_Integration_Flow__c> lst = new List<Monitor_Integration_Flow__c>();
        lst = [select id,name,Service_body__c,Executed_Date__c, Service_Url__c,
               Flow_Name__c,Cronjob_format__C,Transaction_Type__c
               from Monitor_Integration_Flow__c where id =:recordID];
        System.debug('lst--->'+lst);
        try{
            if(!lst.isEmpty())
                CallingExternalScheduledService.CallService(lst[0].Service_body__c,lst[0].Service_Url__c,lst[0].Flow_Name__c,lst[0].id,lst[0].Transaction_Type__c);
        }catch(Exception ex)
        {
            System.Debug('enter into exception'+ex.getLineNumber());
            System.Debug('Exception - ' +ex);
        }
    }

}