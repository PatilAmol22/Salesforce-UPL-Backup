({
    
    doInit : function(component, event, helper) {
        
		var action = component.get("c.getTasks");
        action.setParams({
            "taskRecordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var returnVal = response.getReturnValue();
            
            if(state === 'SUCCESS'){
            component.set("v.taskRecord",returnVal.Id);	
            component.set("v.taskrelateto",returnVal.WhatId);
            component.set("v.empanelment",returnVal.Empanelment__c);  
            }
         });
        $A.enqueueAction(action);
        
      },
    
    taskChange : function(component, event, helper) {
        
        helper.getTaskChange(component, event, helper);
    },
    
})