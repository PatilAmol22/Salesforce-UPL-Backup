/*
     Author: Aarzoo Arora/Rasika
     Name: OverrideNewButtonController
     Description : this class is used for CompetitionTrackingLwc component
    */


public with sharing class OverrideNewButtonController {
    @AuraEnabled
    public static User getUserInformation(){
        User userObj = new User();
        userObj = [Select Id, Name,Country FROM User Where Id=:userinfo.getuserId() WITH SECURITY_ENFORCED limit 1];
        return userObj;
    }
}