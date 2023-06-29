@isTest
public class MonitorIntegrationFlowExecution_Test {
    
    //testing data setup for all methods in this class
    @testSetup
    static void allTheDataForThisTestClass() {
        Monitor_Integration_Flow__c monitor_integration_flow = new Monitor_Integration_Flow__c(
            OwnerId = '005280000017DV0AAM',
            CurrencyIsoCode = 'INR',
            Flow_Name__c = 'Payment Terms',
            Service_Url__c = 'https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/pullPaymentMaster',
            Service_body__c = 'Test',
            //JobId__c = '08e0k000004igMF',
            //Executed_Date__c = DateTime.newInstance(2018,2,8,17,1058,63480),
            //Transaction_Status__c = 'Success',
            //Total_Process_Count__c = 1.0,
            //Success_Count__c = 0.0,
            //Failed_Count__c = 0.0,
            Transaction_Type__c = 'Auto',
            Flow_Enable__c = true,
            Cronjob_format__c = '0 50 * * * ?',
            Calling_Date__c = DateTime.newInstance(2018,2,8,17,1057,63420));
        
        insert monitor_integration_flow;
    }
    
    public static testMethod void method(){
		Monitor_Integration_Flow__c monitor_integration_flow = [Select ID FROM Monitor_Integration_Flow__c LIMIT 1];
        
        //monitor_integration_flow.JobId__c = '08e0k000004igMF';
        monitor_integration_flow.Flow_Enable__c = false;
        update monitor_integration_flow;
    }
    
    public static testMethod void method2(){
        Monitor_Integration_Flow__c monitor_integration_flow = [SELECT ID, Cronjob_format__c, Flow_Name__c, Service_Url__c, Service_body__c 
                                                                FROM Monitor_Integration_Flow__c 
                                                                LIMIT 1];     
        monitor_integration_flow.Flow_Enable__c = false;
        update monitor_integration_flow;        
        monitor_integration_flow.Flow_Enable__c = true;
        update monitor_integration_flow;       
        monitor_integration_flow.Flow_Enable__c = false;
        update monitor_integration_flow;   
    }
    
    public static testMethod void method3(){
        Monitor_Integration_Flow__c monitor_integration_flow = [Select ID FROM Monitor_Integration_Flow__c LIMIT 1];       
        monitor_integration_flow.Flow_Enable__c = false;
        try{
            delete monitor_integration_flow;
        }
        catch(Exception ex){
            //Handled Trigger Validation
        }
    }
    
    public static testMethod void method4(){
        Monitor_Integration_Flow__c monitor_integration_flow = [SELECT ID, Cronjob_format__c, Flow_Name__c, Service_Url__c, Service_body__c 
                                                                FROM Monitor_Integration_Flow__c 
                                                                LIMIT 1];       
		MonitorIntegrationFlowExecution mif = new MonitorIntegrationFlowExecution();
        mif.callwebservice(monitor_integration_flow.ID);
    }
    
    public static testMethod void method5(){
        Monitor_Integration_Flow__c monitor_integration_flow = [SELECT ID, Cronjob_format__c, Flow_Name__c, Service_Url__c, Service_body__c 
                                                                FROM Monitor_Integration_Flow__c 
                                                                LIMIT 1];       
        ScheduleWebService.scheduleIt(monitor_integration_flow);
    }
}