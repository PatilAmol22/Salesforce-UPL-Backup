global class AutoApprovalProcessScheduler implements Schedulable {
  global void execute(SchedulableContext sc) {
    // Edited by Sandeep Vishwakarma - SKI 27-01-2023  AF Material Requisition
    String labelSalesOrgs = System.Label.ActiveSalesOrgForMaterialRequisition;
        List<String> salesOrgs = labelSalesOrgs.split(';');
        salesOrgs.add('1410');
        AutoApprovalProcessBatch batchObj= new AutoApprovalProcessBatch(salesOrgs);
        Database.executeBatch(batchObj, 1);
   }
}