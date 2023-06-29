//Created by Naresh Kumar EY Team #RITM0378285
global class BatchGTMDetailsRecordsUpdate  implements Database.Batchable<sObject> {
global Database.QueryLocator start(Database.BatchableContext BC) {
        string userId = '0055D0000054Z7PQAU';
         String query = 'select id,crop__r.Name,GTM_Customer__r.Name,RecordTypeId,Product_Category__r.Name,createdById,Sales_Org__r.name,CreatedDate,Is_Duplicate_GTM_Record__c from GTM_Details__c where Is_Duplicate_GTM_Record__c = false';
        return Database.getQueryLocator(query);
    }
    
     global void execute(Database.BatchableContext BC, List<GTM_Details__c> scope) {
		 List<Id> updateListIds =new List<Id>();
     
         
        Map<String,Gtm_Details__c> uniqueNameMapCompetitor = new Map<String,Gtm_Details__C>();
          Map<String,Gtm_Details__c> uniqueNameMapProfile  = new Map<String,Gtm_Details__C>();
          Map<String,Gtm_Details__c> uniqueNameMapOutlook = new Map<String,Gtm_Details__C>();
          Map<String,Gtm_Details__c> uniqueNameMapProduct = new Map<String,Gtm_Details__C>();
           Map<String,Gtm_Details__c> uniqueNameMapCrop = new Map<String,Gtm_Details__C>();
         
         
         //checking not Empty list condition 
         if(!scope.isEmpty()){
        for(GTM_Details__c gtmDetails : scope)
        {
            //Gtm Details RecordType
         Id  CompetitorRecordType = Schema.SObjectType.GTM_Details__c.getRecordTypeInfosByDeveloperName().get('Competitor').getRecordTypeId();
         Id  Profile_PotentialRecordType = Schema.SObjectType.GTM_Details__c.getRecordTypeInfosByDeveloperName().get('Profile_Potential').getRecordTypeId();
		 Id  OutlookRecordType = Schema.SObjectType.GTM_Details__c.getRecordTypeInfosByDeveloperName().get('Outlook').getRecordTypeId();
    	 Id  Product_Category_AllocationRecordType = Schema.SObjectType.GTM_Details__c.getRecordTypeInfosByDeveloperName().get('Product_Category_Allocation').getRecordTypeId();
         Id  Crop_AllocationRecordType = Schema.SObjectType.GTM_Details__c.getRecordTypeInfosByDeveloperName().get('Crop_Allocation').getRecordTypeId();
       			            
             if(gtmDetails.RecordTypeId == CompetitorRecordType)
            {      
              gtmDuplicateRecordsCompetitorUpdate(uniqueNameMapCompetitor,updateListIds,gtmDetails);
            }
            
            if(gtmDetails.RecordTypeId == Profile_PotentialRecordType){
                 gtmDuplicateRecordsProfileUpdate(uniqueNameMapProfile,updateListIds,gtmDetails);
            }
            
            if(gtmDetails.RecordTypeId == OutlookRecordType){
                gtmDuplicateRecordsOutlookUpdate(uniqueNameMapOutlook,updateListIds,gtmDetails);
            }
            
			if(gtmDetails.RecordTypeId == Crop_AllocationRecordType)
            {
                   gtmDuplicateRecordsCropUpdate(uniqueNameMapCrop,updateListIds,gtmDetails);
            }
            
            if(gtmDetails.RecordTypeId == Product_Category_AllocationRecordType)
            {
                   gtmDuplicateRecordsProductUpdate(uniqueNameMapProduct,updateListIds,gtmDetails);
            }
         
         
}
             
         if(!updateListIds.isEmpty()){
             
             List<Gtm_Details__c> gtUpdateList = new List<Gtm_Details__c>();
                                      
               List<Gtm_Details__C> updatingCheckboxList = [select id,Is_Duplicate_GTM_Record__c from GTM_Details__c WHERE ID IN: updateListIds];
             
             for(Gtm_Details__C gtUpdateObj : updatingCheckboxList){
               if(gtUpdateObj.Is_Duplicate_GTM_Record__c != true){
               		 gtUpdateObj.Is_Duplicate_GTM_Record__c = true;
               		 gtUpdateList.add(gtUpdateObj);
                     }
             }
             
             if(!gtUpdateList.isEmpty()){
                 update gtUpdateList;
             }
             
         }
             
               }
    }

    // Finish Method
    global void finish(Database.BatchableContext BC) {
     //   AsyncApexJob jobInfo = [SELECT id,Status,NumberOfErrors,TotalJobItems FROM AsyncApexJob where id = BC.getJobId()];
    }
     public void gtmDuplicateRecordsCompetitorUpdate(Map<String,Gtm_Details__c> uniqueNameMapCompetitor,List<id> updateListIds, Gtm_Details__c gtmDetails){
        
         if(!uniqueNameMapCompetitor.containsKey(gtmDetails.GTM_Customer__r.name)){
                    uniqueNameMapCompetitor.put(gtmDetails.GTM_Customer__r.name,gtmDetails);
                }else{
                    Gtm_Details__c check = uniqueNameMapCompetitor.get(gtmDetails.GTM_Customer__r.name);
                    if(check.CreatedDate < gtmDetails.CreatedDate){
                        uniqueNameMapCompetitor.put(gtmDetails.GTM_Customer__r.name,gtmDetails);
                            updateListIds.add(check.id);
                        }else{
                            updateListIds.add(gtmDetails.id);
                        }
                    }
    }
    public void gtmDuplicateRecordsProfileUpdate(Map<String,Gtm_Details__c> uniqueNameMapProfile,List<id> updateListIds,Gtm_Details__c  gtmDetails){
         if(!uniqueNameMapProfile.containsKey(gtmDetails.GTM_Customer__r.name)){
                    uniqueNameMapProfile.put(gtmDetails.GTM_Customer__r.name,gtmDetails);
                }else{
                    Gtm_Details__c check = uniqueNameMapProfile.get(gtmDetails.GTM_Customer__r.name);
                     if(check.CreatedDate < gtmDetails.CreatedDate){
                        uniqueNameMapProfile.put(gtmDetails.GTM_Customer__r.name,gtmDetails);
                            updateListIds.add(check.id);
                        }else{
                            updateListIds.add(gtmDetails.id);
                        }
                    }
    }
    public void gtmDuplicateRecordsOutlookUpdate(Map<String,Gtm_Details__c> uniqueNameMapOutlook,List<id> updateListIds,Gtm_Details__c gtmDetails){
         if(!uniqueNameMapOutlook.containsKey(gtmDetails.GTM_Customer__r.name)){
                    uniqueNameMapOutlook.put(gtmDetails.GTM_Customer__r.name,gtmDetails);
                }else{
                    Gtm_Details__c check = uniqueNameMapOutlook.get(gtmDetails.GTM_Customer__r.name);
                    if(check.CreatedDate < gtmDetails.CreatedDate){
                        uniqueNameMapOutlook.put(gtmDetails.GTM_Customer__r.name,gtmDetails);
                            updateListIds.add(check.id);
                        }else{
                            updateListIds.add(gtmDetails.id);
                        }
                    }
    }

	
    public void   gtmDuplicateRecordsCropUpdate(Map<String,Gtm_Details__c> uniqueNameMapCrop,List<id>  updateListIds, Gtm_Details__c  gtmDetails){
        String GtmCustomerCropKeys = gtmDetails.GTM_Customer__r.name+''+gtmDetails.Crop__r.name;
         if(!uniqueNameMapCrop.containsKey(GtmCustomerCropKeys)){
                    uniqueNameMapCrop.put(GtmCustomerCropKeys,gtmDetails);
                }else{
                    Gtm_Details__c check = uniqueNameMapCrop.get(GtmCustomerCropKeys);
                    if(check.CreatedDate < gtmDetails.CreatedDate){
                        uniqueNameMapCrop.put(GtmCustomerCropKeys,gtmDetails);
                            updateListIds.add(check.id);
                        }else{
                            updateListIds.add(gtmDetails.id);
                        }
                    }
    }
    
    public void gtmDuplicateRecordsProductUpdate(Map<String,Gtm_Details__c> uniqueNameMapProduct,List<id> updateListIds,Gtm_Details__c gtmDetails){
		
        String GtmCustomerProductkeys = gtmDetails.GTM_Customer__r.name+''+gtmDetails.Product_Category__r.name;
        
         if(!uniqueNameMapProduct.containsKey(GtmCustomerProductkeys)){
                    uniqueNameMapProduct.put(GtmCustomerProductkeys,gtmDetails);
                }else{
                    Gtm_Details__c check = uniqueNameMapProduct.get(GtmCustomerProductkeys);
                    if(check.CreatedDate < gtmDetails.CreatedDate){
                        uniqueNameMapProduct.put(GtmCustomerProductkeys,gtmDetails);
                            updateListIds.add(check.id);
                        }else{
                            updateListIds.add(gtmDetails.id);
                        }
                    }
    }
}