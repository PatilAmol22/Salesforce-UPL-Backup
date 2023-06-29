public class CaseEmailNotifactionBatch implements Database.Batchable<sObject>{
    public string salesOrgCodeIndiaSAS;
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query;
        salesOrgCodeIndiaSAS = UtilityClass.getSalesOrgIndiaSAS();
        return Database.getQueryLocator('Select CaseNumber,Type,OwnerId, Owner.Email, Account.OwnerId, Account.Name, Subject, Priority, Status, CreatedDate From Case WHERE Account.Recordtype.Name = \'Distributor\' AND Account.Sales_Org_Code__c IN (\''+salesOrgCodeIndiaSAS+'\',\'1210\',\'1510\') AND Status != \'Closed\' AND Origin != \'Call-Inbound\' AND Type != \'\' AND CreatedDate >= 2018-10-29T00:00:00.000Z');
    }
    
    public void execute(Database.BatchableContext BC, List<Case> scope){
        List<Id> territoryMgrIds = new List<Id>();
        for(Case c : scope){
            territoryMgrIds.add(c.Account.OwnerId);
        }
        List<Territory_Distributor__c> territories = [Select Zonal_Manager_Id__c,TerritoryManager__c, RCM_Email__c From Territory_Distributor__c where TerritoryManager__c IN : territoryMgrIds];
        List<TM_Depot_Mapping__c> deopList = [Select Territory_Manager__c, Depot__c, Depot__r.Case_Access_Email__c From TM_Depot_Mapping__c where Territory_Manager__c IN : territoryMgrIds];
        map<Id, String> rcmEmail = new map<Id, String>();
        salesOrgCodeIndiaSAS = UtilityClass.getSalesOrgIndiaSAS();
        map<Id, List<String>> cnfEmail = new map<Id, List<String>>();
        for(Territory_Distributor__c t : territories){
            if(t.RCM_Email__c != null){
                rcmEmail.put(t.TerritoryManager__c, t.RCM_Email__c);
            }
        }
        for(TM_Depot_Mapping__c d : deopList){
            if(cnfEmail.get(d.Territory_Manager__c) == null){
                cnfEmail.put(d.Territory_Manager__c, new List<String>());
            }
            if(d.Depot__r.Case_Access_Email__c != null){
                cnfEmail.get(d.Territory_Manager__c).add(d.Depot__r.Case_Access_Email__c);
            }
        }
        system.debug('rcmEmail ----->> ' + rcmEmail);
        system.debug('cnfEmail ----->> ' + cnfEmail);
        List <Messaging.Singleemailmessage> emailList = new List <Messaging.Singleemailmessage>();
        EmailTemplate emailtemp = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Pending_Case_Email_India'];
        for(Case c : scope){
            List<String> toEmailIds = new List<String>();
            List<String> bccEmailIds = new List<String>();
            List<String> ccEmailIds = new List<String>();
            
            Messaging.Singleemailmessage email = Messaging.renderStoredEmailTemplate(emailtemp.Id, UserInfo.getUserId(), c.id);
            if(c.Type == 'Invoice' || c.Type == 'Dispatch' || c.Type == 'Payments & Receipts' || c.Type == 'Product Leakage'){
                if(null != cnfEmail.get(c.Account.OwnerId) && cnfEmail.get(c.Account.OwnerId).size() > 0){
                    toEmailIds.addAll(cnfEmail.get(c.Account.OwnerId));
                }
            } 
            if(c.Type == 'Invoice' || c.Type == 'Payments & Receipts'){
                if(null != rcmEmail.get(c.Account.OwnerId)){
                    toEmailIds.add(rcmEmail.get(c.Account.OwnerId));    
                }           
            } 
            if(c.Type == 'Invoice Cancellation' || c.Type == 'Invoice Update'){
                if(c.account.Sales_Org_Code__c == salesOrgCodeIndiaSAS){
                    toEmailIds.add(System.Label.CaseNotificationBatchIndiaSAAS);    
                }
                if(c.account.Sales_Org_Code__c == '1210'){
                    toEmailIds.add(System.Label.CaseNotificationBatch1210);    
                }
                if(c.account.Sales_Org_Code__c == '1510'){
                    toEmailIds.add(System.Label.CaseNotificationBatch1510);
                }
            } 
            if(c.Type == 'Outstanding' || c.Type == 'Account Related' || c.Type == 'Others-FCE'){
                toEmailIds.add(System.Label.CaseNotificationBatchOutAccFCE);
            } 
            if(c.Type == 'Credit Limit' || c.Type == 'Scheme' || c.Type == 'Product Availability' || c.Type == 'Product Complaints by Farmers' || c.Type == 'Product Related'){
                if(null != c.Owner.Email){
                    toEmailIds.add(c.Owner.Email);    
                }                
            } 
            if(c.Type == 'Customer Master Updation'){               
                toEmailIds.add(System.Label.CaseNotificationBatchCustMasterUpdation);
            } 
            if(c.Type == 'Product Availability'){
                toEmailIds.add(System.Label.CaseNotificationBatchProductAvail);
            }
            if(c.Type == 'Product Complaints by Farmers' || c.Type == 'Product related'){
                toEmailIds.addAll((System.Label.CaseNotificationBatchProductRelated).split(';'));
                //toEmailIds.add('neerajkumar.sharma@upl-ltd.com');
                //toEmailIds.add('abhijeet.jagdale@upl-ltd.com');
            }
            if(null != toEmailIds && toEmailIds.size() > 0){
                email.setToAddresses(toEmailIds);    
            }
            if(null != bccEmailIds && bccEmailIds.size() > 0){
                email.setBccAddresses(bccEmailIds);    
            }
            email.setTreatTargetObjectAsRecipient(false); 
            if(c.CreatedDate.Date().daysBetween(system.Today()) > 4 || Test.isRunningTest()){
                //ccEmailIds.add('purviish.shah@uniphos.com');
                if(c.Type == 'Credit Limit' || c.Type == 'Invoice' || c.Type == 'Outstanding' || c.Type == 'Payments & Receipts' || c.Type == 'Account Related' || c.Type == 'Customer master updation' || c.Type == 'Others-FCE'){                    
                    ccEmailIds.add(System.Label.CaseNotificationBatchCreditLimit);
                } 
                if(c.Type == 'Invoice' || c.Type == 'Dispatch' || c.Type == 'Product Leakage'){
                    ccEmailIds.add(System.Label.CaseNotificationBatchInvDisPL);
                } 
                if(c.Type == 'Scheme'){
                    ccEmailIds.add(System.Label.CaseNotificationBatchScheme);
                }
            }
            if(ccEmailIds != null && ccEmailIds.size() > 0){
                email.setCcAddresses(ccEmailIds);
            }
            emailList.add(email);
        }
        
        if(emailList.size() > 0 && !Test.isRunningTest()){
            Messaging.sendEmail(emailList);
        }
    }
    
    public void finish(Database.BatchableContext BC){
    }
    
}