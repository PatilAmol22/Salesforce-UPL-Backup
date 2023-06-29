({
	handleRecordUpdated : function(component, event, helper) {
        
         var action = component.get("c.GetInvoicesAPICall");
                
         action.setParams({ SAPOrderNumber : component.get("v.simpleRecord.SAP_Order_Number__c") });
         action.setCallback(this, function(response) {
             //alert('successfull call');
             //$A.get('e.force:refreshView').fire();
         });
         $A.enqueueAction(action);
        
		
	}
})