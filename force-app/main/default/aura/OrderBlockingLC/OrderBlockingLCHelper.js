({
    //Method for cancelReason by Harshit&Sirisha
    getCancelReasonPicklist : function(component, event) {
        var action = component.get("c.cancelReason");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result is ',result);
                var cancelMap = [];
                for(var key in result){
                    cancelMap.push({key: key, value: result[key]});
                }
                component.set("v.cancelMap", cancelMap);
            }
        });
        $A.enqueueAction(action);
    },
    
    // Added by Sagar@Wipro for StatusOrdemVendas API Call
     SKUUpdateAPI : function(component, event, helper) {
        var action = component.get("c.SKUUpdateAPI");
        console.log('recordId API --> ' + component.get("v.recordId"));
         action.setParams({
            "soId": component.get("v.recordId")
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state == "SUCCESS") {
               // var isbraziluser1 = a.getReturnValue();
               console.log('Order Status API Call Success');
               // component.set("v.isbraziluser1", isbraziluser1);                
            }
        });
        $A.enqueueAction(action);
    },
    
    
})