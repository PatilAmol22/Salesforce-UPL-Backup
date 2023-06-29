/*
@Author: Pranav Dinakaran
@Class_Description: Schedular Class to call TerritoryTehsilSchedulerClass 
*/

global class CallTerritoryTehsilMappingCreate_Batch implements Schedulable{
     global void execute(SchedulableContext sc) {
         // Call Class and specify 'Create' in parameter 
         TerritoryTehsilSchedulerClass InsertBAtch = new TerritoryTehsilSchedulerClass('Create');
     }
}