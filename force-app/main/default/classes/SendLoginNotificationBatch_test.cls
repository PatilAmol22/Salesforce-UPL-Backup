@isTest
private class SendLoginNotificationBatch_test{
      public static testMethod void test1(){
          //Email_Id__c, Last_Login__c,User_Full_Name__c,Owner.Email,CreatedDate FROM Last_Login__c WHERE CreatedDate = TODAY
             Last_Login__c last = new Last_Login__c();
             last.User_Full_Name__c='abhishek';
             last.Last_Login__c=System.now();
             last.Email_Id__c='verma9931@gmail.com';
             insert last;
             
                test.startTest();
                SendLoginNotificationBatch obj = new SendLoginNotificationBatch();
                DataBase.executeBatch(obj);
                test.stopTest();
    }
}