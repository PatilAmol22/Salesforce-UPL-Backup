public with sharing class ReminderMaterialRequisitionAFZMScheduler implements Schedulable {
    public ReminderMaterialRequisitionAFZMScheduler() {

    }
    public void execute(SchedulableContext sc) {
        // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
        List<String> saleorgs = new List<String>{'1410'};
        ReminderMaterialRequisitionRMBatch batchObj= new ReminderMaterialRequisitionRMBatch(saleorgs,'Pending Material Requisition Notification','Pending Approvals for ZMM/ZSM.');
        Database.executeBatch(batchObj, 1);
       }
}