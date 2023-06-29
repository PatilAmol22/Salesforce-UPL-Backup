({
	doInit : function(component, event, helper) {
        console.log('In do int method ');
        helper.showHideDetailsInfos(component,event,helper);
        helper.fetchCollectionInfos(component,event,helper);
        helper.fetchOutstandingInfos(component,event,helper);
        helper.fetchCreditInfo(component,event,helper);
        helper.fetchSalesOrderAmount(component,event,helper);
        //helper.fetchSalesgrowth(component,event,helper);
        
	}
})