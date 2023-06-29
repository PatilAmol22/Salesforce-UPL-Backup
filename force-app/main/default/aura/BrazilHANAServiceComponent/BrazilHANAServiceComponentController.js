({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        console.log('recordId '+recordId);
        
        var action = component.get("c.callHANAFromAction");
        action.setParams({ 
            "recordId": recordId
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            var result = a.getReturnValue();
            
            if(result=='Success'){
                component.find("outputRT").set('v.value','Reprocessing Order. Please wait...');
                window.setTimeout(
                    $A.getCallback(function() {
                        helper.gotoRecord(component, recordId);  
                    }), 5000
                );
				
            }
            else{
                component.find("outputRT").set('v.value','This Order cannot be reprocessed.');
            }
        });
        $A.enqueueAction(action);
    }

})