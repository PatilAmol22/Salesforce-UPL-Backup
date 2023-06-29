global class BulkApprovalWebService {

  /**
  * Bulk request approval from list view
  * @param  recordIds String
  * @return JSON String
  */
 /* webService static String bulkRequest( String recordIds ) {
    Map<String, Object> response = new Map<String, Object>();
    try{
    	List<String> ids = recordIds.split(',');
    	List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
    
    	for(String rId : ids){
          Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
          req.setObjectId(rId);
          //If the next step in your approval process is another Apex approval process, you specify exactly one user ID as the next approver. 
          //If not, you cannot specify a user ID and this method must be null.
          //req.setNextApproverIds(null);
          requests.add(req);
    	}
    	Approval.ProcessResult[] processResults = Approval.process(requests);
    	//Valid values are: Approved, Rejected, Removed or Pending.
    	System.assertEquals('Pending', processResults[0].getInstanceStatus());
    } catch ( Exception ex ){
    	response.put('status', '500');
    	response.put('error', ex.getMessage());
    	return JSON.serialize(response);
    }
    response.put('status', '200');
    return JSON.serialize(response);
  } */

  /**
   * Bulk approve records from list view
   * @param  recordIds String
   * @return JSON String
   */
  webService static String bulkApprove( String recordIds ) {
    Map<String, Object> response = new Map<String, Object>();
    try{
        
        List<ProcessInstance > pI = new List<ProcessInstance >();
        List<ProcessInstanceWorkitem> pIWI = new List<ProcessInstanceWorkitem>();
        //List<Approval.Workitems> wI = new List<Approval.Workitems>();
        List<Approval.ProcessRequest> pR = new List<Approval.ProcessRequest>();
        List<Approval.ProcessResult> pRe = new List<Approval.ProcessResult>();
        List<Approval.ProcessSubmitRequest> pSR = new List<Approval.ProcessSubmitRequest>();
        List<Approval.ProcessWorkitemRequest> pWIR = new List<Approval.ProcessWorkitemRequest>();
        List<Case> caList = new List<Case>();
        
       
        List<String> ids = recordIds.split(',');
        
         for(Case cas :  [Select Id, Customer_service_lookup__c, Status, Origin, Entity__c , Date__c, Productname__c, Closing_Comment__c, Packaging__c From Case Where Id in :ids]){
            case ca = new case();
             ca.id = cas.Id;
             ca.status = cas.status;
             ca.Closing_Comment__c = cas.Closing_Comment__c;
             caList.add(ca);
        }
        
    	List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
    
    	List<ProcessInstanceWorkitem> workItems = [SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId IN :ids ];
    	for(ProcessInstanceWorkitem workItem : workItems){
          Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
          req.setWorkitemId(workItem.Id);
          //Valid values are: Approve, Reject, or Removed. 
          //Only system administrators can specify Removed.
          req.setAction('Approve');
          req.setComments('Approved by France System Administrator');
          requests.add(req);
    	}
    	Approval.ProcessResult[] processResults = Approval.process(requests);
    } catch ( Exception ex  ){
      response.put('status', '500');
      response.put('error', ex.getMessage());
      return JSON.serialize(response);
    }
     
      response.put('Status', '400');
      response.put('Status', '600');
      response.put('Status', '300');
      response.put('Status', '100');
      response.put('Status', '900');
      response.put('Status', '800');
      response.put('Status', '700');
     
      
    response.put('status', '200');
    return JSON.serialize(response);
  }
	
}