global class ReminderMaterialRequisitionZMScheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
    // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
    String labelSalesOrgs = System.Label.ActiveSalesOrgForMaterialRequisition;
    List<String> saleorgs = labelSalesOrgs.split(';');
    ReminderMaterialRequisitionZMBatch batchObj= new ReminderMaterialRequisitionZMBatch(saleorgs,'Pending Material Requisition Notification','Pending Approvals for ZMH.');
    Database.executeBatch(batchObj, 1);
   }
}