({
	getTaskChange : function(component, event, helper) {
        var details = component.get("v.taskRecord");
        var emp = component.get("v.empanelment");
        var taskrelate = component.get("v.taskrelateto");
        console.log('get task record id = '+component.get("v.taskRecord"));
        console.log('"v.taskrelate to"----helper '+component.get("v.taskrelateto"));
        console.log('"v.empanelment"----helper '+component.get("v.empanelment"));
        
        var navService = component.find("navServiceView");
        var pageReference = {
            type: 'standard__component',
            attributes: { 
                componentName: 'c__ViewEmp',
            },
            state: {
                
                "c__TaskId": details,
                "c__TaskEmpanelment": emp,
                "c__TaskRelateTo" : taskrelate
                
            }
        };
        component.set("v.pageReference", pageReference);
        
        navService.navigate(pageReference);
	}
})