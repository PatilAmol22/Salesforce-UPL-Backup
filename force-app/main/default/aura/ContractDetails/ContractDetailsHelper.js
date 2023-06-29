({
	fetchContracts : function(component, event, helper) {
         component.set("v.loaded", true);
		 var action = component.get("c.getContracts");
         var caseId = component.get("v.recordId");
          action.setParams({
            caseId: caseId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                
                var ContractsList = response.getReturnValue();
                component.set("v.ContractsList",ContractsList);
                component.set("v.loaded", false);
                console.log(ContractsList);
            }
            else {
                component.set("v.loaded", false);
                console.log('Error in getting data');
            }
        });
        // Adding the action variable to the global action queue
        $A.enqueueAction(action);
        },
})