/*******************************************************************************************
* @Name         RecallSalesAgreementTrigger 
* @Author       Sandeep Vishwakarma <sandeep.vishwakarma@skinternational.com>
* @Date         09/27/2022
* @Group        SKI
* @Description  This trigger use to recall SalesAgreements. //<!--CR#162 MonitorForecast - Sandeep.Vishwakarma 9-27-2022-->
*******************************************************************************************/
trigger RecallSalesAgreementTrigger on RecallSalesAgreements__e (After insert) {

    System.debug('Events RecallSalesAgreements__e'+Trigger.new);
    List<String> salesAgreements = new List<String>();
    for(RecallSalesAgreements__e event:Trigger.new){
        if(!String.isEmpty(event.SalesAgreementId__c)){
            salesAgreements.add(event.SalesAgreementId__c);
        }
    }
    if(salesAgreements.size()>0){
        MonitoringForecast.recallSalesAgreementsEvent(salesAgreements);
    }

}