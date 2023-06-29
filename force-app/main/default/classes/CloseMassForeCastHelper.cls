public without sharing class CloseMassForeCastHelper{

	public static void approveDraftSalesAgreements(List<String> salesAgreementsDraft){
		List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest> ();
            for(Id id1 : salesAgreementsDraft){
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Auto submitted by the Demand planner');
                req1.setObjectId(id1);
                requests.add(req1);
            }
            Approval.ProcessResult[] processResults = null;
            try {
                processResults = Approval.process(requests, true);
                System.debug('Process Result on line 264 '+processResults.size());
            }catch (System.DmlException e) {
                System.debug('Exception Is ' + e.getMessage());
            }
	}
	
	public static List<Boolean> approvePendingSalesAgreement(List<String> salesAgreements){
		Set<Id> pIds = (new Map<Id, ProcessInstance>([SELECT Id,Status,TargetObjectId FROM ProcessInstance where Status='Pending' and TargetObjectId in :salesAgreements])).keySet();

        Set<Id> pInstanceWorkitems = (new Map<Id, ProcessInstanceWorkitem>([SELECT Id,ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstanceId in :pIds])).keySet();

        List<Approval.ProcessWorkitemRequest> allReq = new List<Approval.ProcessWorkitemRequest>(); 
        System.debug('pInstanceWorkitems '+pInstanceWorkitems.size());
        for (Id pInstanceWorkitemsId:pInstanceWorkitems){
            system.debug(pInstanceWorkitemsId);
                Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
                req2.setComments('Approved by SDM');
                req2.setAction('Approve'); 
                // req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                req2.setWorkitemId(pInstanceWorkitemsId);
                allReq.add(req2);
        }
        Approval.ProcessResult[] result2 = null;
        try {
           result2 =  Approval.process(allReq);
        } catch (Exception e) {
            System.debug('Exception while appoving '+e);
        }
		List<Boolean> success = new List<Boolean>();
        for(Approval.ProcessResult res: result2){
            success.add(res.isSuccess());
        }
        return success;
	}

}