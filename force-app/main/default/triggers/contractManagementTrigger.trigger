trigger contractManagementTrigger on Contract_management__c (before update) {
  contractManagementTriggerHandler.validateAttachment(Trigger.new);
}