@isTest
public class Schedule_Mexico_Case_Escalation_Test {

public static testMethod void testschedule() {

Test.StartTest();
Schedule_Mexico_Case_Escalation_Batch sh1 = new Schedule_Mexico_Case_Escalation_Batch();
String sch = '0 0 0/1 1/1 * ? *'; 
system.schedule('Hourly Mexico Case Escalation Batch Job', sch, sh1); 
Test.stopTest(); }
}