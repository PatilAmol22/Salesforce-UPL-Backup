({
	redirectColombiaCase : function(component, event, helper) {
		console.log('----------------'+component.get("v.recordId"));
        var recordId = component.get("v.recordId");
         var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef  : "c:EditColombiaCase" ,
                componentAttributes  : {
                    recordId :recordId,
                    
                }
            });
            console.log('Event '+evt);
            evt.fire();
	}
})