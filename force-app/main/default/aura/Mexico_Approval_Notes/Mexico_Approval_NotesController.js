({
	doInit : function(component, event, helper) {
       // alert('hii');
        var action = component.get('c.getSalesOrderRecord');
      
        action.setParams({ varRecordId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()=='<div style="color: red;"><b>Cuidado,  se esta aprobado debajo de su limite autorizado</b></div>')
                
                {
                    component.set("v.notes", 'Cuidado,  se esta aprobado debajo de su limite autorizado');
                }
            }
        });
        $A.enqueueAction(action);
            
        }
    
})