trigger CropWiseAcerageTrigger on Crop_Wise_Acerage__c (before insert) {
    
    CropWiseAcerageAccessCheck.hasEditAccess(trigger.new);

}