/*
 * Name :  ReportingSnapshotDeletor_Scheduler
 * Description : To delete unrelevant records created by reporting snapshot
 * Author : Ketan Khatri
 * Called from : scheduled from anonymous window 
*/



global class ReportingSnapshotDeletor_Scheduler implements Schedulable {

    global void execute(SchedulableContext sc)
    {
        //ReportingSnapshotDeletor.deleteOldRecords();
        deleteOldRecords();
    }    
    
    
    public static void deleteOldRecords(){
        
        try
        {            
        List<Last_Login__c> lastLoginList = new List<Last_Login__c>();
        lastLoginList = [SELECT Id FROM Last_Login__c WHERE CreatedDate!= TODAY];        
        
            if(lastLoginList.size()>0){
                DELETE lastLoginList;
            }        
            
        }
        
        catch(Exception ex){
            System.debug('Error Occured at Line-> '+ex.getLineNumber());
            System.debug('Error Message-> '+ex.getMessage()+' Cause - '+ex.getCause());
        }
      
    }
    
}