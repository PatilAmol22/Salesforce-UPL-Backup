({
	handleClick : function(component, event, helper) {
        console.log('Cancel log:'+component.get("v.ShowModel"));
        component.set("v.ShowModel", true);
        console.log('Cancel log:'+component.get("v.ShowModel"));
        console.log('recordId:'+component.get("v.recordId"));
		
	},
    
    handleRecordUpdated : function(component, event, helper) {
        console.log('status'+component.get("v.simpleRecord.BrazilSalesOrderStatus__c"));
        if(component.get("v.simpleRecord.BrazilSalesOrderStatus__c") != 'Approved' &&
          component.get("v.simpleRecord.BrazilSalesOrderStatus__c") != 'Aprovado')
            component.set("v.disableCancelOrder", true);
    }
            
            
        
    
})