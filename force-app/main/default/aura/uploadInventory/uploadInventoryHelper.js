({   
    getDocuments :function(component,event,helper){
        var action = component.get("c.getDocument");
        action.setCallback(this, function(res){
            component.set("v.doc", res.getReturnValue());
        console.log(component.get("v.doc"));
        })
        $A.enqueueAction(action);
	}
})