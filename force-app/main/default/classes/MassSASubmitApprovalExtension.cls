// Extension to delete all of the selected objects
public with sharing class MassSASubmitApprovalExtension {
    
    ApexPages.StandardSetController setCon;
    public String error { get; set; }
    public PageReference originalUrl { get; set; }
    
    public MassSASubmitApprovalExtension(ApexPages.StandardSetController controller) {
        setCon = controller;
    }
    
    public String getMySelectedSize() {
        return setCon.getSelected().size() + '';
    }
    
    public PageReference submitApprovalRecords(){
        originalUrl = setCon.cancel();
        
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
        Map<Id, SalesAgreement> saMap = new Map<Id, SalesAgreement>();
        List<Id> saIdss = new List<Id>();
        System.debug('setCon.getSelected() ' + setCon.getSelected());
        try{
            for(sObject target : setCon.getSelected()) {
                saIdss.add(target.id);
                //saMap.put(target.id, target);
                //System.debug('*************** Current Target: ' + target.Name); 
            }
            
            
            if(saIdss.size() > 0){
                for(SalesAgreement sa : [Select Id, Start_Day_of_Submission_Setting__c, Name, Active_Month_Formula__c, End_Day_of_Submission_Setting__c , Sale_Org_Code__c, AccountId, SA_Status__c From SalesAgreement Where Id in :saIdss]){
                    System.debug('sa ' + sa);
                    System.debug('sa.SA_Status__c ' + sa.SA_Status__c);
                    System.debug('sa.SA_Status__c ' + sa.get('SA_Status__c'));
                    
                    DateTime currTime = System.now();
                    System.debug('currTime ==>'+currTime );
                    Integer min1 = Integer.ValueOf(Label.Grz_Brazil_Minutes); 
                    System.debug('min1---' +min1);  // -510
                    
                    DateTime hrBefore =  currTime.addMinutes(min1);  //currTime.addMinutes(hour1);
                    System.debug('hrBefore ==>'+hrBefore);
                    
                    Integer activeMonth = hrBefore.month(); //Month(DATEVALUE(DateTime.now() - (8.5/24)));
                    System.debug('activeMonth ' + activeMonth);
                    Integer activeDay = hrBefore.day(); //Month(DATEVALUE(DateTime.now() - (8.5/24)));
                    System.debug('activeDay ' + activeDay);
                    //Integer startDate = Day(DATEVALUE(DateTime.now()- (8.5/24)));
                    //Integer endDate = Day(DATEVALUE(DateTime.now())- (8.5/24)));
                    
                    if((!Approval.isLocked(sa.Id) && sa.SA_Status__c == 'Draft' && sa.Sale_Org_Code__c == '5191' && sa.AccountId != null && sa.Active_Month_Formula__c >= activeMonth && sa.Start_Day_of_Submission_Setting__c <= activeDay && sa.End_Day_of_Submission_Setting__c >= activeDay )){  // && sa.get(Schema.SA_Status__c == 'Draft') && sa.getSObject(Schema.SA_Status__c) == 'Draft' 
                        //if((!Approval.isLocked(sa.Id) && sa.SA_Status__c == 'Draft')){  // && sa.get(Schema.SA_Status__c == 'Draft') && sa.getSObject(Schema.SA_Status__c) == 'Draft' 
                        
                        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                        req.setObjectId(sa.id);
                        //If the next step in your approval process is another Apex approval process, you specify exactly one user ID as the next approver. 
                        //If not, you cannot specify a user ID and this method must be null.
                        //req.setNextApproverIds(null);
                        requests.add(req);
                    }
                }
            }
            
            if(requests.size() > 0 && !Test.isRunningTest()){
                
                Approval.ProcessResult[] processResults = Approval.process(requests);
                System.assertEquals('Pending', processResults[0].getInstanceStatus());
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