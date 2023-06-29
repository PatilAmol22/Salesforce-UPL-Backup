/*
@Author: Pranav Dinakaran
@Class_Description: Schedular Class to call TerritoryTehsilSchedulerClass to call delete Batch 
*/

global class CallTerritoryTehsilMappingDelete_Batch implements Schedulable{
     global void execute(SchedulableContext sc) {
           // Call Class and specify 'Delete' in parameter 
         TerritoryTehsilSchedulerClass DeleteBatch = new TerritoryTehsilSchedulerClass('Delete');
     }
}