/**
 * class Name: ArgentinaCaseNotificationScheduler
 * Author: EY
 * CR: APPS-5392
 * Description: This is invoked from Scheduled flow to run the batch at particular frequecy.
 * */
public class ArgentinaCaseNotificationScheduler  {
	 @InvocableMethod
    public static void invokeArgentinaCaseNotificationJob() {
         Database.executeBatch(new ArgentinaCaseReminder(),20);
    }
}