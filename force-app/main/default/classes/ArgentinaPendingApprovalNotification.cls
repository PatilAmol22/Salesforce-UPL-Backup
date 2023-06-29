public class ArgentinaPendingApprovalNotification {
 @InvocableMethod
    Public static void invokeArgentinaCaseApprovalNotificationJob() {
         Database.executeBatch(new ArgentinaCaseApprovalReminder(),20);
    }
}