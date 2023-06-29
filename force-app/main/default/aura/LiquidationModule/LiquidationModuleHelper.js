({
	getDocuments :function(component,event,helper){
        var action = component.get("c.getDocument");
        action.setCallback(this, function(res){
            component.set("v.doc", res.getReturnValue());
        console.log(component.get("v.doc"));
        })
        $A.enqueueAction(action);
	},
    searchRecords : function(component, searchString) {
        var action = component.get("c.getRecords");
        action.setParams({
            "searchString" : searchString
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                const serverResult = response.getReturnValue();
                const results = [];
                serverResult.forEach(element => {
                    const result = {id : element['Id'], value : element['Name']};
                    results.push(result);
                });
                component.set("v.results", results);
                if(serverResult.length>0){
                    component.set("v.openDropDown", true);
                }
            } else{
                var toastEvent = $A.get("e.force:showToast");
                if(toastEvent){
                    toastEvent.setParams({
                        "title": "ERROR",
                        "type": "error",
                        "message": "Something went wrong!! Check server logs!!"
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    }
})