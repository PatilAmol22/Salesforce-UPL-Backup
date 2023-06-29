public class Grz_SubmitLiquidation implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful  {
	private List<Id> lst_id;	
    public Grz_SubmitLiquidation(List<Id> strParam) {
        lst_id = strParam;
    }
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,submitted__c from Liquidation2__c where Id IN:lst_id');
       }
    
    public void execute(Database.BatchableContext BC, List<Liquidation2__c> scope){
        system.debug('inside batch submit liquidation');
        List<Liquidation2__c> lst_submit = new List<Liquidation2__c>();
        for(Liquidation2__c liq:scope){
            liq.submitted__c = true;
            lst_submit.add(liq);
        }
        system.debug('update list==>'+lst_submit);
        if(lst_submit.size()!=0){
            update lst_submit;
        }     
        system.debug('after update batch');
    }
    
    public void finish(Database.BatchableContext BC){
        
    }
}