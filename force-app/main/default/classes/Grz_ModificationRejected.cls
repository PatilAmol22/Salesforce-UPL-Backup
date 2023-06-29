public with sharing class Grz_ModificationRejected {
    public class listOfInput{
        @InvocableVariable
        public String recordId;
    }
	@InvocableMethod(label='Modification Rejected' description='Modification Rejected')
    public static void updateModificationField(List<listOfInput> recordIds){
         system.debug('recordIds==>'+recordIds);
        String idVal;
        if(!recordIds.isEmpty()){
          idVal  =recordIds[0].recordId;            
        }
        system.debug('idVal==>'+idVal);
        Account acc =[Select id,email__c, Mobile__c,Prior_Email_and_Mobile_Value__c,Modification_Rejected__c from account where id =:idVal];
        acc.Email__c = (acc.Prior_Email_and_Mobile_Value__c).substringBetween('Email:', ';');
        acc.Mobile__c = (acc.Prior_Email_and_Mobile_Value__c).substringBetween('Mobile:', ';');
        acc.Modification_Rejected__c=false;
        acc.Prior_Email_and_Mobile_Value__c='';
        Update acc;
        
        
        
    }
}