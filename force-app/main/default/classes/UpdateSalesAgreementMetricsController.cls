public without sharing class UpdateSalesAgreementMetricsController {
    @AuraEnabled
    public static List<Sales_Forecast_Setting__c> getsalesforecastsetting(){
        return [SELECT Id, Name, Active_Forecast_Month__c, Start_Day_Of_Approval__c, End_Day_Of_Approval__c, Start_Day_of_Submission__c, End_Day_of_Submission__c, Sales_Org__c FROM Sales_Forecast_Setting__c limit 1];
    }

    @AuraEnabled
    public static String executeBatch(String month, String year){
        String status=null;
        try{
            String userEmail = ''; 
            //userEmail = UserInfo.getUserEmail();
            userEmail = Label.Email_Sent_to_SalesRep_or_SDM;
            
            List<String> apexNameList=new List<String>();
            apexNameList.add('UpdateMetricsBatchNoOne');
            apexNameList.add('UpdateMetricsBatchNoTwo');
            apexNameList.add('UpdateMetricsBatchNoThree');
            apexNameList.add('SalesAgreementScheduleUpdateBatch');//Update combination key of SAPS after generating salesforcecast. 
            apexNameList.add('SalesForeCastBatch');
                        
            AsyncApexJob[] jobs = [select id,status from AsyncApexJob where ApexClass.Name IN: apexNameList AND JobType='BatchApex'];
            
            Set<String> statusSet=new Set<String>();
            for(AsyncApexJob aSJobs:jobs){
                if(aSJobs.status=='Processing'){
                    //status=aSJobs.status;
                    statusSet.add(aSJobs.status);
                }
            }
            //System.debug('status : '+status);
            /*if (status!='Processing') {
                UpdateMetricsBatch batchObj=new UpdateMetricsBatch(month,year,userEmail);
                String jobId1=Database.executeBatch(batchObj,200);*/
            if(!statusSet.contains('Processing')){
                UpdateMetricsBatchNoOne batchObj1=new UpdateMetricsBatchNoOne(month,year,userEmail);
                String jobId1=Database.executeBatch(batchObj1,200);
                insertCustomSettings('UM Batch 1',jobId1);
                
                UpdateMetricsBatchNoTwo batchObj2=new UpdateMetricsBatchNoTwo(month,year,userEmail);
                String jobId2=Database.executeBatch(batchObj2,200);
                insertCustomSettings('UM Batch 2',jobId2);
                
                UpdateMetricsBatchNoThree batchObj3=new UpdateMetricsBatchNoThree(month,year,userEmail);
                String jobId3=Database.executeBatch(batchObj3,200);
                insertCustomSettings('UM Batch 3',jobId3);
                                
                if(!test.isRunningTest()){
                    //System.debug('jobId1 :'+jobId1);
                    System.FlexQueue.moveJobToFront(jobId1);
                    System.FlexQueue.moveAfterJob(jobId2, jobId1);
                    System.FlexQueue.moveAfterJob(jobId3,jobId2);    
                }
            }
            else{
                status='Processing';
            }
        }
        catch(Exception ex){
            System.debug('Exception in UpdateSalesAgreementMetricsController getsalesforecastsetting method at line no- '+  ex.getLineNumber() + ' Exception is -'+ ex);
        }
        return status;
    }
    
    public static void insertCustomSettings(String no,String jobId){
        List<Salesforecast_Batch_Process__c> sbpList=[SELECT id, Name, Job_id__c from Salesforecast_Batch_Process__c where Name=:no];
        for(Salesforecast_Batch_Process__c sbp:sbpList){
            //System.debug('sbp :'+sbp);
            sbp.Job_Id__c=jobId;
        }
        update sbpList;
    }
}