({
    // Init method to initalize default values in form on component load. 
    doInit: function(component, event, helper) {
        var action = component.get("c.getSOMBalance");
        if(component.get("v.recordId")!=null){
            action.setParams({
                recordId: component.get("v.recordId")
            });
            
            action.setCallback(this, function(a) {
                var state = a.getState();
                if(state == "SUCCESS") {
                    component.set("v.balanceList", a.getReturnValue());
                   // console.log('balanceList: '+JSON.stringify(a.getReturnValue()));
                }
                else{
                    var toastMsg = 'Error while populating balanceList';
                    console.log('toastMsg: '+toastMsg);
                    //this.showErrorToast(component, event, toastMsg);                      
                }
            });
            $A.enqueueAction(action);
        }
        
    }
})