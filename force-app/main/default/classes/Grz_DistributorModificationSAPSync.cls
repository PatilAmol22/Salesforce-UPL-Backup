public with sharing class Grz_DistributorModificationSAPSync {
    public class listOfInput{
        @InvocableVariable
        public String recordId;
    }
	@InvocableMethod(label='Distributor Modification SAP Sync' description='Distributor Modification SAP Sync')
    public static void syncWithSAP(List<listOfInput> recordIds){
        system.debug('recordIds==>'+recordIds);
        if(!recordIds.isEmpty()){
            String idVal=recordIds[0].recordId;
            callSAPMethod(idVal);
            
        }
    }
    public class modificationWrapper{
        @AuraEnabled public String Distributor {get;set;}      
@AuraEnabled public String Email {get;set;}
        @AuraEnabled public String Mobile {get;set;}
    }    
    public class sapResponseWrapper{
            public cls_item item;
    }
    public class cls_item {
            public String SAP_Code;	
            public String SAP_Response;	
        }
    public static sapResponseWrapper parse(String json){
            return (sapResponseWrapper) System.JSON.deserialize(json, sapResponseWrapper.class);
        }
    
    @future(callout=true)
    public static void callSAPMethod(String idVal){
        
            List<Account> accRecord=[Select id,SAP_Code__c,mobile__c,email__c,Sales_Org_Code__c from account where id=:idVal];
            if(!accRecord.isEmpty()){
                modificationWrapper mw=new modificationWrapper();
                mw.Distributor=accRecord[0].SAP_Code__c;
                mw.Mobile=accRecord[0].mobile__c;
                mw.Email=accRecord[0].email__c;
                
                //Fetching endpoint as per sales org from custom metadata
                    Map<String, Grz_Customer360IntegrationMappings__mdt> integrationSettingsMap = new Map<String, Grz_Customer360IntegrationMappings__mdt>();
                    for(Grz_Customer360IntegrationMappings__mdt data: Grz_Customer360IntegrationMappings__mdt.getAll().values()){
                        integrationSettingsMap.put(data.Sales_Org_Code__c, data);
                    }
                    Grz_Customer360IntegrationMappings__mdt metadataRecord=new Grz_Customer360IntegrationMappings__mdt();
                    if(!integrationSettingsMap.isEmpty() && integrationSettingsMap.containsKey(accRecord[0].Sales_Org_Code__c)){
                        metadataRecord=integrationSettingsMap.get(accRecord[0].Sales_Org_Code__c);
                    }
                    System.debug('metadataRecord==>'+metadataRecord);
                
                
                String sapResponse=Grz_OnboardingSAPIntegration.DistributorModification(JSON.serialize(mw),metadataRecord);
                System.debug('sapResponse==>'+sapResponse);
                if(sapResponse=='Error_In_Sap'){
                    Account sa=new Account(Id=accRecord[0].Id,SAP_Response__c='Error in SAP');
                        update sa;
                }
                else{
                    sapResponseWrapper sapList=sapResponseWrapper.parse(sapresponse);
                        Account sa=new Account(Id=accRecord[0].Id,SAP_Response__c=sapList.item.SAP_Response);
                        update sa;
                }
            }
    }
}