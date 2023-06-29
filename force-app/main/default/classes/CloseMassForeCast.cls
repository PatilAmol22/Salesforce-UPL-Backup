public without sharing class CloseMassForeCast implements Database.Batchable<String>,Database.Stateful {
	public Map<String, SalesAgreement> mapSalesAgreements;
    MonitoringForecast.FiltersWrapper filters;
    List<Boolean> success;
    public CloseMassForeCast(MonitoringForecast.FiltersWrapper filters){
        this.filters = filters;
    }
    
    public Iterable<String> start(Database.BatchableContext bc) {
		mapSalesAgreements = new Map<String, SalesAgreement>([SELECT Id, Region__c,Region__r.TerritoryManager__c,Year__c, Sale_Org_Code__c, Name, SA_Status__c, Active_Forecast_Month__c, OwnerId,Owner.Name,Account.Id FROM SalesAgreement where Sale_Org_Code__c =:filters.salesorg and Active_Forecast_Month__c=:filters.month and  Year__c=:filters.year and Region__r.TerritoryManager__c=:filters.salesRep and (SA_Status__c='Draft' OR SA_Status__c='Pending')]);
		
		Set<String> salesAgreementKeys = mapSalesAgreements.keySet();
		return new List<String>(salesAgreementKeys);
    }
    public void execute(Database.BatchableContext bc, List<String> records){
		List<String> salesAgreementsDraft = new List<String>();
		List<String> salesAgreementsPending = new List<String>();
        List<String> salesAgreements = new List<String>();
		
		for(String salesAgreement:records){
			String status = mapSalesAgreements.get(salesAgreement).SA_Status__c;
			if(status.equalsIgnoreCase('Draft')){
                salesAgreementsDraft.add(salesAgreement);
			}
			if(status.equalsIgnoreCase('Pending')){
                salesAgreementsPending.add(salesAgreement);
			}
		}
		CloseMassForeCastHelper.approveDraftSalesAgreements(salesAgreementsDraft);
        salesAgreements.addAll(salesAgreementsDraft);
        salesAgreements.addAll(salesAgreementsPending);
        success = CloseMassForeCastHelper.approvePendingSalesAgreement(salesAgreements);
    }    
    public void finish(Database.BatchableContext bc){
        System.debug('Number of record Approved '+success.size());
        filters.indicator = 'Green';
        String filter = JSON.serialize(filters);
        MonitoringForecast.sendRemainder(filter);
    }    
}