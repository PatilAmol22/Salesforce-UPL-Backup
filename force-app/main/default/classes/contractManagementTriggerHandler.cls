public class contractManagementTriggerHandler {
  public static void validateAttachment(List<Contract_management__c> newList){
      
		list<id> newContractIds = new list<id>();
		for(Contract_management__c contr:newList){
		newContractIds.add(contr.id);
		}
      
		list<ContentDocumentLink> attach =  [Select Id, ContentDocumentId  from ContentDocumentLink where LinkedEntityId IN :newContractIds];
		
		for(Contract_management__c contrEr:newList){
		if(contrEr.Contract_Attached__c==true && attach.size()==0){
		contrEr.Contract_Attached__c.addError(system.label.France_Attach_Contract_Error);
		}
		}     
		}
}