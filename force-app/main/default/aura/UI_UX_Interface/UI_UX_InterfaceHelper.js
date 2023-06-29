({
	fetchData : function(component, event, helper) {
        var action = component.get('c.fetchDatas'); 
        // method name i.e. getEntity should be same as defined in apex class
        // params name i.e. entityType should be same as defined in getEntity method
        action.setParams({
            "accId" : component.get('v.recordId') 
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                component.set('v.data', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})