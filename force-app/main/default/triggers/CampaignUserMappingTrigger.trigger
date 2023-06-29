/*
@Developer Name: Ketan Khatri
@Description: To delete share record  when CampaignUserMapping record is deleted
*/
trigger CampaignUserMappingTrigger on Campaign_user_Mapping__c (after insert, after update, before delete) {
    
   
    list<CampaignShare> deleteCampaignShareList = new List<CampaignShare>();
    list<Campaign_Crop_Mapping__c> cropObservationList = new list<Campaign_Crop_Mapping__c>();
    set<ID> userSet = new set<ID>();
    set<ID> campaignIDset = new set<ID>();
    Map<string,Campaign_Crop_Mapping__Share> campaignCropMappingShareMap = new Map<String,Campaign_Crop_Mapping__Share>();
    map<string,Campaign_Crop_Mapping__Share> campaignCropMappingSharePrevDataMap = new Map<string,Campaign_Crop_Mapping__Share>();
    list<Campaign_Crop_Mapping__Share> campaignCropMappingList = new list<Campaign_Crop_Mapping__Share>();
    
    
   //Capture the details from the deleted CampaignUserMapping Record 
    if(Trigger.isDelete){
        for(Campaign_user_Mapping__c cuMap : Trigger.old){
            userSet.add(cuMap.User__c);
            campaignIDset.add(cuMap.Campaign__c);
        }
    // Fetch the Campaign Share records to be deleted based on the specific criterias
    deleteCampaignShareList = [Select id, CampaignID, UserOrGroupId,RowCause  
                               from CampaignShare 
                               where UserOrGroupId in: userSet AND CampaignID in: campaignIDset AND RowCause ='Manual'];
     
    //Finally Delete the desired CampaignShare Records
    if(deleteCampaignShareList.size()>0){
        delete deleteCampaignShareList;
    }
     
    system.debug('trigger completed');
    }
    
    if(Trigger.isInsert){
        for(Campaign_user_Mapping__c cuMap : Trigger.New){
           
             userSet.add(cuMap.User__c);
             campaignIDset.add(cuMap.Campaign__c);
           
        }
     //Fetch data from crop observation to share crop observation record  to new campaign user mapping record 
     cropObservationList = [SELECT id,Name,Campaign__c FROM Campaign_Crop_Mapping__c WHERE Campaign__c IN : campaignIDset];
     list<string> cropObsevationIdList = new list<String>();
     
     if (!cropObservationList.isEmpty()){
         for(Campaign_Crop_Mapping__c campCrop : cropObservationList){
         cropObsevationIdList.add(campCrop.id);
     }  
     campaignCropMappingList =[SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Campaign_Crop_Mapping__Share Where RowCause = 'Manual' AND UserOrGroupId in: userSet And ParentId IN :cropObsevationIdList];
     
     if(!campaignCropMappingList.isEmpty()){
         for(Campaign_Crop_Mapping__Share campCrop : campaignCropMappingList){
             campaignCropMappingSharePrevDataMap.put(campCrop.ParentId+''+campCrop.UserOrGroupId,campCrop);
         }
     }   
         for(Campaign_Crop_Mapping__c cropObser : cropObservationList){
             for(Id userId : userSet){
             Campaign_Crop_Mapping__Share cropObShareObj = new Campaign_Crop_Mapping__Share();
             cropObShareObj.ParentId = cropObser.id;
             cropObShareObj.AccessLevel = 'Read' ;
             cropObShareObj.UserOrGroupId = userId;
             if(!campaignCropMappingShareMap.containskey(cropObser.id +''+userId) && !campaignCropMappingSharePrevDataMap.containsKey(cropObser.id +''+userId)){
             campaignCropMappingShareMap.put(cropObser.id +''+userId,cropObShareObj);
             }
             }
           
         }
         if(!campaignCropMappingShareMap.values().IsEmpty()){
             Insert campaignCropMappingShareMap.values();
           }
     }
    }
    
    if(Trigger.isUpdate){
        for(Campaign_user_Mapping__c cuMap : Trigger.New){
           
             userSet.add(cuMap.User__c);
             campaignIDset.add(cuMap.Campaign__c);
           
        }
     //Fetch data from crop observation to share crop observation record  to new campaign user mapping record 
     cropObservationList = [SELECT id,Name,Campaign__c FROM Campaign_Crop_Mapping__c WHERE Campaign__c IN : campaignIDset];
     list<string> cropObsevationIdList = new list<String>();
     
     if (!cropObservationList.isEmpty()){
         for(Campaign_Crop_Mapping__c campCrop : cropObservationList){
         cropObsevationIdList.add(campCrop.id);
     }  
     campaignCropMappingList =[SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Campaign_Crop_Mapping__Share Where RowCause = 'Manual' AND UserOrGroupId in: userSet And ParentId IN :cropObsevationIdList];
     
     if(!campaignCropMappingList.isEmpty()){
         for(Campaign_Crop_Mapping__Share campCrop : campaignCropMappingList){
             campaignCropMappingSharePrevDataMap.put(campCrop.ParentId+''+campCrop.UserOrGroupId,campCrop);
         }
     }   
         for(Campaign_Crop_Mapping__c cropObser : cropObservationList){
             for(Id userId : userSet){
             Campaign_Crop_Mapping__Share cropObShareObj = new Campaign_Crop_Mapping__Share();
             cropObShareObj.ParentId = cropObser.id;
             cropObShareObj.AccessLevel = 'Read' ;
             cropObShareObj.UserOrGroupId = userId;
             if(!campaignCropMappingShareMap.containskey(cropObser.id +''+userId) && !campaignCropMappingSharePrevDataMap.containsKey(cropObser.id +''+userId)){
             campaignCropMappingShareMap.put(cropObser.id +''+userId,cropObShareObj);
             }
             }
         }
         if(!campaignCropMappingShareMap.values().IsEmpty()){
             Insert campaignCropMappingShareMap.values();
           }
     }
    }
  
}