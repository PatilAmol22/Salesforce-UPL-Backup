trigger Grz_UserTriggerForSms on User (after insert,after update,before update,before insert) {
    system.debug('ByPassUtils.isByPassed-->'+ByPassUtils.isByPassed('Grz_UserTriggerForSms'));
    if(!ByPassUtils.isByPassed('Grz_UserTriggerForSms')){
        Grz_userSmsController.getRecord(Trigger.New,Trigger.oldMap);
        if(Trigger.isAfter){ 
            
            if(Trigger.isInsert) {            
                Grz_userSmsController.sendWelcomeMessage(Trigger.New,true,Trigger.oldMap);
                Grz_userSmsController.addUserInGroup(Trigger.New,Trigger.oldMap);
                Grz_userSmsController.addUserInGroupForBrazil(Trigger.New, Trigger.oldMap);
                Grz_userSmsController.addUserInGroupForMexico(Trigger.New, Trigger.oldMap);
                //addUserInGroupForArgentina Method added in Grz_UserTriggerForSms Trigger, Mohit Garg(Grazitti) : APPS-1757 added on: 16-08-2022
                Grz_userSmsController.addUserInGroupForArgentina(Trigger.New, Trigger.oldMap);
                //Grz_userSmsController.addUserInGroupForChile(Trigger.New, Trigger.oldMap);
            }   
            if(Trigger.isUpdate){
                system.debug('In isAfter isUpdate');
                Grz_userSmsController.updateUserTMMobileANdPhone(Trigger.New,Trigger.oldMap);
                Grz_userSmsController.updateBRUserRegionAndTerritory(JSON.serialize(Trigger.New),JSON.serialize(Trigger.oldMap));
            }
        }
        if(Trigger.isBefore){
            
            if(Trigger.isInsert){
                system.debug('In before Insert');
                Grz_userSmsController.addTMEmailANDPhone(Trigger.New,Trigger.oldMap);
            }
            
            if(Trigger.isUpdate) {
                system.debug('In before Update');
                Grz_userSmsController.sendWelcomeMessage(Trigger.New,false,Trigger.oldMap);
                Grz_userSmsController.addUserInGroup(Trigger.New,Trigger.oldMap);
                Grz_userSmsController.addTMEmailANDPhone(Trigger.New,Trigger.oldMap);
                Grz_userSmsController.addUserInGroupForBrazil(Trigger.New, Trigger.oldMap);
            }
            
        }
    }
}