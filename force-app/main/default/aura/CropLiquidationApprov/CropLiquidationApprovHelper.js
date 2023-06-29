({
	fetchURLHelper : function(component, event, helper){
        var ac = component.get('c.getPageURL');
        ac.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set('v.pageReference',data);
            }else{
                console.log('Failed: '+response.getError() );
            }
        });
        $A.enqueueAction(ac);
    }
})