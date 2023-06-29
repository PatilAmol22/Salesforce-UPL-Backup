trigger ContentDocLinkTrigger on ContentDocumentLink (before insert,after insert) { 
    Map<Id, Id> contDocandVersionId = new Map<Id, Id>();
    
    public static List<contentdocument> contentdocuments=ContentVersionTriggerHelper.contentdocuments;//---SKI (PrashantK) : #CR165 : Margin Block Integration :28-09-2022
    
    public static List<contentversion> contentversions=ContentVersionTriggerHelper.contentversions;//---SKI (PrashantK) : #CR165 : Margin Block Integration :28-09-2022
    Set<Id> contentdocIds = new Set<Id>();
    List<Id> contentDocId=new List<Id>();
    for(ContentDocumentLink con : Trigger.new){
        contentDocId.add(con.ContentDocumentId);
        contDocandVersionId.put(con.ContentDocumentId, con.LinkedEntityId);
    }
    System.debug('contDocandVersionId ' + contDocandVersionId);
    Map<Id,String> cdTitleMap=new Map<Id,String>();
    if(ContentVersionTriggerHelper.contentdocuments==null || ContentVersionTriggerHelper.contentdocuments.size()==0){ //---SKI (PrashantK) : #CR165 : Margin Block Integration :28-09-2022
    	contentdocuments = [Select Id,Title from contentdocument where Id In :contentDocId];   
        ContentVersionTriggerHelper.contentdocuments = contentdocuments; 
    }
    for(ContentDocument con : contentdocuments){
        cdTitleMap.put(con.Id,con.Title);
    }
    if(trigger.isInsert && trigger.isBefore){
        
        for(ContentDocumentLink con : Trigger.new){ 
            System.debug('ContentDocumentLink con-----'+con.Id);
            if(!cdTitleMap.isEmpty() && cdTitleMap.containsKey(con.ContentDocumentId)){
                String Title = cdTitleMap.get(con.ContentDocumentId);
                List<String> checkhypen = Title.split('-');
                boolean isbillingdoc= false;
                if(checkhypen.size()==2){
                    string billingdoc = checkhypen[1];
                    System.debug('billingdoc---- ' + billingdoc);
                    isbillingdoc = true;
                     System.debug('isbillingdoc---- ' + isbillingdoc);
                }
                if(Title.Contains('#') && ((String)con.LinkedEntityId).startsWith('001') && isbillingdoc){
                    
                      System.debug('----yipee---inside if check-----1 con'+con.Id);
                    contentdocIds.add(con.Id);
                   
                     System.debug('----yipee---inside if check-----1contentdoc'+contentdocIds);
                }
            }
            
            if(((String)con.LinkedEntityId).startsWith('a1X')){
                  System.debug('----yipee---inside if check-----2');
                contentdocIds.add(con.Id);
                 System.debug('----yipee---inside if check-----2'+contentdocIds);
            }
            
        }
        if(!contentdocIds.isEmpty()){
            for(ContentDocumentLink c : Trigger.new){
                if(contentdocIds.contains(c.Id)){
                
                      System.debug('----yipee---inside if check-----3qq');
                    c.Visibility = 'AllUsers';
                     System.debug('----yipee---inside if check-----3ID,'+c.Id);
                     System.debug('----yipee---inside if check-----3visibility,'+c.Visibility);
                }
            }
        }
        
    }
    
   /* if(trigger.isInsert && trigger.isAfter){
         system.debug('contDocandVersionId' + contDocandVersionId);
        Map<Id,ContentVersion> contentdocverIdMap=new Map<Id,ContentVersion>();
        for(ContentVersion cv:[Select Id,contentdocumentid,Guest_Record_fileupload__c from contentversion where contentdocumentid IN :contentDocId]){   //  contentDocId
            contentdocverIdMap.put(cv.contentdocumentid,cv);
            
               
        }  */
    
    
    if(trigger.isInsert && trigger.isAfter){
          
            Id Case_recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
      System.debug('Case_recordTypeId' + Case_recordTypeId);
        //Change by Aashima(Grazitti) for APPS-4027 28Dec22
     Map<Id,Sales_Org__c> salesOrgs = new Map<Id,Sales_Org__c >([Select Id, Name, Sales_Org_Code__c from Sales_Org__c where Name = 'UPL SAS' or Name = 'SWAL']);
        System.debug('salesOrgs' + salesOrgs);
       Map<Id, Case> caseAllMap = new Map<Id, Case>();  
    for(Case c : [Select Id, CaseNumber, cateSub__c, Sub_Category__c, SalesOrg__c, RecordTypeId from case where ID in :contDocandVersionId.values() or (RecordTypeId =: Case_recordTypeId and (catesub__c = 'Request' or catesub__c = 'Complaint') and Salesorg__c IN :salesOrgs.keySet()) ]){
        //if((c.catesub__c == 'Request' || c.catesub__c == 'Complaint') && (c.RecordTypeId == Case_recordTypeId) && (salesOrgs.containsKey(c.SalesOrg__c))){
               caseAllMap.put(c.Id, c);
         //}       
     }
                system.debug('contDocandVersionId' + contDocandVersionId);
        System.debug('caseAllMap ' + caseAllMap);
        //System.debug('ContentDocumentId ' + ContentDocumentId);
        Map<Id,ContentVersion> contentdocverIdMap=new Map<Id,ContentVersion>();
        if(contentversions==null){ //---SKI (PrashantK) : #CR165 : Margin Block Integration :28-09-2022
            contentversions = [Select Id,contentdocumentid,Guest_Record_fileupload__c from contentversion where contentdocumentid IN :contentDocId];
        	ContentVersionTriggerHelper.contentversions = contentversions;
        }
        for(ContentVersion cv:contentversions){
             contentdocverIdMap.put(cv.contentdocumentid,cv);
            //}
         }  
          
          System.debug('contentdocverIdMap ' + contentdocverIdMap);
          
          
        List<Id> contentUpDocId=new List<Id>();
        List<ContentDocumentLink> condocList = new List<ContentDocumentLink>();
        
        system.debug('!contentdocverIdMap.isEmpty() ' + !contentdocverIdMap.isEmpty());
       
        for(ContentDocumentLink cdl:Trigger.new){
               // system.debug('contentdocverIdMap.containsKey ' + contentdocverIdMap.containsKey(cdl.ContentDocumentId));
              // system.debug('LinkedEntityId ' + cdl.LinkedEntityId);
               // system.debug('contentdocverIdMap.get(cdl.ContentDocumentId).Guest_Record_fileupload__c ' + contentdocverIdMap.get(cdl.ContentDocumentId).Guest_Record_fileupload__c);
        
            if(!contentdocverIdMap.isEmpty() && contentdocverIdMap.containsKey(cdl.ContentDocumentId) && contentdocverIdMap.get(cdl.ContentDocumentId).Guest_Record_fileupload__c!=null && ((String)cdl.LinkedEntityId).startsWith('500')){
                if(cdl.Visibility != 'AllUsers'){
                    ContentDocumentLink cnlink = new ContentDocumentLink(Id= cdl.Id);                
                    cnlink.Visibility = 'AllUsers';
                    condocList.add(cnlink);
                }
                contentUpDocId.add(cdl.ContentDocumentId);
            }
        }
        if(!condocList.isEmpty()){
            update condocList;
        }
        List<ContentDist__e> Contnetdisevents = new List<ContentDist__e>();
        for(Id i:contentUpDocId){
            if(contentdocverIdMap.containskey(i)){
                Contnetdisevents.add(new ContentDist__e(ContentVersionId__c=contentdocverIdMap.get(i).Id, ContentTitle__c=cdTitleMap.get(i)));               
            }
        }
        List<Database.SaveResult> results = EventBus.publish(Contnetdisevents);
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                System.debug('Successfully published event.');
            } else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Error returned: ' +
                                 err.getStatusCode() +
                                 ' - ' +
                                 err.getMessage());
                }
            }       
        }
        
    }
}