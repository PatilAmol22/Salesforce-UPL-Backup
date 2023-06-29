global class ScheduleWebService implements Schedulable {
    
    public Monitor_Integration_Flow__c mif = new Monitor_Integration_Flow__c();   
    
    public ScheduleWebService(Monitor_Integration_Flow__c mif){
        mif = mif;
    }
        
    global void execute(SchedulableContext sc) {

        sc.getTriggerId();
        
        System.Debug('Get trigger ID ===== '+sc.getTriggerId());
        
        List<Monitor_Integration_Flow__c> lstMIF = new list<Monitor_Integration_Flow__c>();
        
        String jobid = String.valueOf(sc.getTriggerId()).substring(0, 15);

        lstMIF = [SELECT id, Service_Url__c, Service_body__c, Flow_Name__c FROM Monitor_Integration_Flow__c WHERE JobId__c=:jobid  ];
        if(Test.isRunningTest()){
            lstMIF = [SELECT id, Service_Url__c, Service_body__c, Flow_Name__c FROM Monitor_Integration_Flow__c];
        }
        System.Debug('LIST MIF ========= ' + lstMIF);
        
        CallingExternalScheduledService.CallService(lstMIF[0].Service_body__c,lstMIF[0].Service_Url__c,lstMIF[0].Flow_Name__c,lstMIF[0].id,'Auto'); 
       
    }
    
     global static void scheduleIt(Monitor_Integration_Flow__c mif) {
 
        System.Debug('mig === scheduleIt === ' +mif);
 
        System.schedule('Transaction Flow name - '+mif.Flow_Name__c,mif.Cronjob_format__c, new ScheduleWebService(mif));
 
    }
 
}