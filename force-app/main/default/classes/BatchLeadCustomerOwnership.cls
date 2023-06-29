/*******************************************************************************************
* @Name         BatchLeadCustomerOwnership 
* @Author       Priyanka Nalawade <Priyanka.Nalawade@skinternational.com>
* @Date         18/08/2022
* @Group        SKI
* @Description  This Batch class is used Pathfinder Admin Configuration Module.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer         Date(MM/DD/YYYY)      Description
*-------------------------------------------------------------------------------------------
*  1.0              Priyanka             18/08/2022       Initial Creation                                                      
*******************************************************************************************/
global class BatchLeadCustomerOwnership implements database.batchable<Account>, Database.Stateful{
    List<Account> acc = new List<Account>();
    List < String > errorCSVList = new List < String > ();
    List < String > successCSVList = new List < String > ();
     List < String > csvData = new List < String > ();
    public BatchLeadCustomerOwnership(List<Account> accList){
        this.acc = accList;
        System.debug('Account List ' + accList);
    } 
    
    global Iterable<Account> start(Database.batchableContext bc){
        
        return this.acc;
    }
    
    global void execute (database.batchableContext bc, List<Account> Scope){
        updateAccountOwnership(Scope);
    }
     global void finish(database.batchableContext bc){
      Sales_Org__c salesOrg = GtmLeadCustomer.getSalesOrg();
      String fiscalYear = GTMPathFinder.getFiscalYear();
    successCSVList.add('Record Id');
    errorCSVList.add('Record Id');
     GtmLeadCustomer.sendEmail(String.join(successCSVList, '\r\n'), String.join(errorCSVList, '\r\n'), 
               successCSVList.size(), errorCSVList.size() - 1, 'Lead Customer Uploads');
         List <GTM_Details__c> GtmD = new List <GTM_Details__c>();
         GtmD = [SELECT Id, Name, GTM_Details__c, GTM_Customer__r.Lead_Customer_Ownership__c FROM
   GTM_Details__c WHERE  GTM_Customer__r.Lead_Customer_Ownership__c = null AND GTM__r.Sales_Org__r.Sales_org_code__c ='5191' and GTM__r.Fiscal_Year__c=: fiscalYear];
         Delete GtmD;
         System.debug('GtmD ' + GtmD);
     }
   private void updateAccountOwnership(List<Account> Scope){
        Database.SaveResult[] srList;
        if (Scope.size() > 0) {
            System.debug('SCOPE +++ ' + Scope);
            GtmLeadCustomer.removeManualShare(scope);
            srList = Database.update(Scope, false);
            GtmLeadCustomer.updateOwnership(Scope);
            GtmLeadCustomer.manualShareRead(scope);
        }
        System.debug('Account size' + srList.size());
        for (Integer i = 0; i < srList.size(); i++) {
            if (!srList[i].isSuccess()) {
                Database.Error[] errs = srList[i].getErrors();
                errorCSVList.add('Error Message ' + errs[0].getMessage());
            } else {
                successCSVList.add(Scope[i].get('Id') + 'Success File ' );
            }
        }

    }  
}