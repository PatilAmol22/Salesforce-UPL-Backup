({
	fetchOrders : function(component, event, helper) {
         component.set("v.loaded", true);
		 var action = component.get("c.getOrders");
         var caseId = component.get("v.recordId");
          action.setParams({
            caseId: caseId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                
                var OrderList = response.getReturnValue();
                component.set("v.OrderList",OrderList);
                component.set("v.loaded", false);
                console.log(OrderList);
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