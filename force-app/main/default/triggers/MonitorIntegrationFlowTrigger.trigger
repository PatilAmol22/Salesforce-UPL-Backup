trigger MonitorIntegrationFlowTrigger on Monitor_Integration_Flow__c (before insert, before update, before delete) {

    if(Trigger.isBefore && Trigger.isUpdate){
    
        for(Monitor_Integration_Flow__c mif: trigger.new){
        
            Monitor_Integration_Flow__c oldMif = Trigger.oldMap.get(mif.Id);
        //Added condition for SKU update Flag by Krishanu @ Wipro
            if(mif.Flow_Enable__c == true && oldMif.Flow_Enable__c == false &&mif.SKU_Update__c==false){
                String jobId = System.schedule('Transaction Flow name - '+mif.Flow_Name__c,mif.Cronjob_format__c, new ScheduleWebService(mif));
                mif.jobid__c= jobId;
            }
            
            else if(mif.Flow_Enable__c == true && oldMif.Flow_Enable__c == false &&mif.SKU_Update__c==true){
                String jobId = System.schedule('Transaction Flow name - '+mif.Flow_Name__c,mif.Cronjob_format__c, new SkuScheduler(mif));
                mif.jobid__c= jobId;
            }
			//-end Krishanu @ Wipro    
            if(mif.Flow_Enable__c == false && oldMif.Flow_Enable__c == true){
                if(mif.jobid__c != null){
                    System.abortjob(mif.jobid__c); 
                    mif.jobid__c='';
                }  
            }
            
         }
    }
    
    if(Trigger.isBefore && Trigger.isDelete){

        for(Monitor_Integration_Flow__c mif: trigger.old){
            
            if(mif.Flow_Enable__c == true){
                mif.addError('Disable this interation flow before delete a record.');
            }            
        }

    }   
}