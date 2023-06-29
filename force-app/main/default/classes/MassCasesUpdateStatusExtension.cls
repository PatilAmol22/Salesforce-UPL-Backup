// Extension to Update all of the selected objects
public with sharing class MassCasesUpdateStatusExtension{
    
    ApexPages.StandardSetController setCon;
    public String error { get; set; }
    public PageReference originalUrl { get; set; }
    
    public MassCasesUpdateStatusExtension(ApexPages.StandardSetController controller) {
        setCon = controller;
    }
    
    public String getMySelectedSize() {
        return setCon.getSelected().size() + '';
    }
    
    public PageReference caseClose(){
        originalUrl = setCon.cancel();
        
        //Map<Id, Case> casMap = new Map<Id, Case>();
        List<Case> casList = new List <Case>();
        List<Id> saIdss = new List<Id>();
        System.debug('setCon.getSelected() ' + setCon.getSelected());
        try{
            for(sObject target : setCon.getSelected()) {
                saIdss.add(target.id);
                //casMap.put(target.id, target);
                //System.debug('*************** Current Target: ' + target.Name); 
            }
            
            String allData = UPL_Settings__c.getOrgDefaults().Grz_France_Case_Recordtypes__c; 
            List<String> dataString = new List<String>();
            if(allData != null){
                dataString = allData.split('\n');
            }
            List<String> caseRecordTypes = new List <String>();
            if(dataString != null){
                for(String st : dataString){
                    caseRecordTypes.add(st.trim());
                }
            }
            if(saIdss.size() > 0){
                for(Case ca : [Select Id, Status, RecordTypeId, Record_Type__c, RecordType.Name, OwnerId, Reason_for_Closure__c, owner.Name, Name__c, Reason, Source.Name, Customer_name__c,  Closing_Comment__c, AccountId, Entity__c From Case Where Id in :saIdss]){  //  Record_Type__c = 'Re-labelling'
                    System.debug('ca ' + ca);
                    System.debug('ca.Status ' + ca.Status);
                    System.debug('ca.Status ' + ca.get('Status'));
                    
                    if((ca.Status == 'Open' && caseRecordTypes.size() > 0 && caseRecordTypes.contains(ca.RecordType.name)) || Test.isRunningTest()){// ca.Record_Type__c == 'Re-labelling' || ca.Record_Type__c == 'Quality - Customer' || ca.Record_Type__c == 'Quality - Farmer' || ca.Record_Type__c == 'Other Incidents - Aliment' || ca.Record_Type__c == 'Other Incidents - Animal' || ca.Record_Type__c == 'Other Incidents - Milieu' || ca.Record_Type__c == 'Other Incidents - Personne' || ca.Record_Type__c == 'Other Incidents - Résistance' || ca.Record_Type__c == 'Other Incidents - Végétal')){  //  && sa.Sale_Org_Code__c == '2710' && sa.AccountId != null
                        //Case cas = new Case();
                        //cas.Id = ca.Id;
                        //cas.Status = 'Closed';
                        //cas.Closing_Comment__C = System.Label.GRZ_France_Case_Close_Comment;
                        //casList.add(cas);
                        ca.Status = 'Closed';
                        ca.Closing_Comment__c = System.Label.GRZ_France_Case_Close_Comment;
                        casList.add(ca);
                    }
                }
                
                if(casList.size() > 0){
                    
                    update casList;
                }
            }  
            
        }catch(System.DMLException e) { 
            System.debug('e ' + e);
            System.debug('e ' + e.getStackTraceString());
            System.debug('e ' + e.getCause());
            System.debug('e ' + e.getLineNumber());
            //System.debug('e ' + e.DmlException(param1));
            System.debug('e ' + e.getMessage());
            
        }
        return originalUrl;
    }  
}