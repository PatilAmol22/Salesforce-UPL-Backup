global class BrazilApproverReassignScheduler implements Schedulable{
global void execute(SchedulableContext SC) {
        BrazilApproverReassign bar = new BrazilApproverReassign();
        bar.reassignApprover();
    }
}