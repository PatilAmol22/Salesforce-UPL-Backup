public with sharing class ReminderMaterialRequisitionSBUScheduler implements Schedulable{
    public ReminderMaterialRequisitionSBUScheduler() {

    }
    public void execute(SchedulableContext sc) {
        // Edited by Sandeep Vishwakarma - SKI 27-01-2023 AF Material Requisition
        List<String> saleorgs = new List<String>{'1410'};
        ReminderMaterialRequisitionZMBatch batchObj= new ReminderMaterialRequisitionZMBatch(saleorgs,'Pending Material Requisition Notification','Pending Approvals for SBU Marketing Head/SBU Sales Head.');
        Database.executeBatch(batchObj, 1);
       }
}