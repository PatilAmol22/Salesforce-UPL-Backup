({
	handleRecordUpdated : function(component, event, helper) {
        
          var action = component.get("c.GetProductsMaterialsAPICall");
               console.log("datads",component.get("v.simpleRecord.Billing_Doc_Number__c")); 
         action.setParams({ InvoiceId : component.get("v.simpleRecord.Billing_Doc_Number__c") });
         action.setCallback(this, function(response) {
             //alert('successfull call');
             //$A.get('e.force:refreshView').fire();
         });
         $A.enqueueAction(action);
		
	}
})