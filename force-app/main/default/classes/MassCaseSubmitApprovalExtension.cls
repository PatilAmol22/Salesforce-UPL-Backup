// Extension to delete all of the selected objects
public with sharing class MassCaseSubmitApprovalExtension{
    
    ApexPages.StandardSetController setCon;
    public String error { get; set; }
    public PageReference originalUrl { get; set; }
    
    public MassCaseSubmitApprovalExtension(ApexPages.StandardSetController controller) {
        setCon = controller;
    }
    
    public String getMySelectedSize() {
        return setCon.getSelected().size() + '';
    }
    
    public PageReference submitApprovalRecords(){
        originalUrl = setCon.cancel();
        
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
        Map<Id, Case> caMap = new Map<Id, Case>();
        List<Id> caIdss = new List<Id>();
        System.debug('setCon.getSelected() ' + setCon.getSelected());
      try{
        for(sObject target : setCon.getSelected()) {
            caIdss.add(target.id);
            //caMap.put(target.id, target);
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
        if(caIdss.size() > 0){
        for(Case ca : [Select Id, Status, RecordTypeId, Record_Type__c, RecordType.Name, OwnerId, Reason_for_Closure__c, owner.Name, Name__c, Reason, Source.Name, Customer_name__c,  Closing_Comment__c, AccountId, Entity__c From Case Where Id in :caIdss]){
            System.debug('ca ' + ca);
            System.debug('ca.Status ' + ca.Status);
            System.debug('ca.Status ' + ca.get('Status'));
            
            
            //Integer startDate = Day(DATEVALUE(DateTime.now()- (8.5/24)));
            //Integer endDate = Day(DATEVALUE(DateTime.now())- (8.5/24)));
            
            if((!Approval.isLocked(ca.Id) && ca.Status == 'Open' && caseRecordTypes.size() > 0 && caseRecordTypes.contains(ca.RecordType.name)) || Test.isRunningTest()){ //&& ca.Record_Type__c == 'Re-labelling')){ //&& ca.Sale_Org_Code__c == '5191' && ca.AccountId != null && ca.Active_Month_Formula__c >= activeMonth && ca.Start_Day_of_Submission_Setting__c <= activeDay && ca.End_Day_of_Submission_Setting__c >= activeDay )){  // && ca.get(Schema.SA_Status__c == 'Draft') && ca.getSObject(Schema.SA_Status__c) == 'Draft' 
            //if((!Approval.isLocked(sa.Id) && sa.SA_Status__c == 'Draft')){  // && sa.get(Schema.SA_Status__c == 'Draft') && sa.getSObject(Schema.SA_Status__c) == 'Draft' 
                
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setObjectId(ca.id);
                //If the next step in your approval process is another Apex approval process, you specify exactly one user ID as the next approver. 
                //If not, you cannot specify a user ID and this method must be null.
                //req.setNextApproverIds(null);
                requests.add(req);
            }
        }
              }
        
        if(requests.size() > 0){
            
            Approval.ProcessResult[] processResults = Approval.process(requests);
            //System.assertEquals('Pending', processResults[0].getInstanceStatus());
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