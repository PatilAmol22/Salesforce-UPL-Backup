/*
*   Author : EY (Harshaprasad Srustu)
*   Schedular Class - LastLoginUsersReportScheduler
*   CreatedDate: 01-12-2022
*   Description - Fetch Reports for Country specific
**/
global class LastLoginUsersReportScheduler implements Schedulable{
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new LastLoginUsersReportBatch(),5);
    }
}