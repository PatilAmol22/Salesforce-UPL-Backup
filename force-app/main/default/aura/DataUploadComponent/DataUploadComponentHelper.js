({
	getDocuments :function(component,event,helper){
        var action = component.get("c.getDocument");
        action.setCallback(this, function(res){
            component.set("v.doc", res.getReturnValue());
        console.log(component.get("v.doc"));
        })
        $A.enqueueAction(action);
        var action1 = component.get("c.getDocument1");
        action1.setCallback(this, function(res){
            component.set("v.doc1", res.getReturnValue());
        console.log(component.get("v.doc1"));
        })
        $A.enqueueAction(action1);
	}
})