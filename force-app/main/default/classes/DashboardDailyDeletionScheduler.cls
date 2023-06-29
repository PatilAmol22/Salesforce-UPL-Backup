/*
* Name: DashboardDailyDeletionScheduler
* Created On: 08 May 2017
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Scheduler class to schedule daily data deletion of data created before last 7 days
*/
global class DashboardDailyDeletionScheduler implements Schedulable{
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new DashboardDataDeletionBatch('Daily'), 100);
    }
}