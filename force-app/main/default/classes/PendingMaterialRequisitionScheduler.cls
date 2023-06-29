global class PendingMaterialRequisitionScheduler implements Schedulable {
  global void execute(SchedulableContext sc) {
       // Edited by Sandeep Vishwakarma - SKI 27-01-2023
    String labelSalesOrgs = System.Label.ActiveSalesOrgForMaterialRequisition;
    List<String> saleorgs = labelSalesOrgs.split(';');
    PendingMaterialRequisitionBatch batchobj= new PendingMaterialRequisitionBatch(saleorgs,'Pending Material Requisition Notification','Pending Approvals for HO Marketing.');
    Database.executeBatch(batchObj, 1);
   }
}