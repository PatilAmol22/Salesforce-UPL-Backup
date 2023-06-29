({
    helperMethod : function(component,event) {
        var action = component.get("c.callBatchClass");
        var recordId = component.get("v.recordId");

        action.setParams({
            recId: recordId
        });

        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS") {
                this.showToast(component, event, $A.get("$Label.c.Metrics_update_process_has_been_initiated"),$A.get("$Label.c.Success"),'success'); 
                //console.log('orderItems: '+JSON.stringify(a.getReturnValue()));
            }
            else{
                this.showToast(component, event, $A.get("$Label.c.Failed_to_update_Metrics_Please_contact_your_Salesforce_Administrator"),$A.get("$Label.c.Error"),'error');                      
            }
            $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
    },

    showToast : function(component, event, toastMsg,titleTp,Evnttype) {
        var toastEvent = $A.get("e.force:showToast");
        var success = $A.get("$Label.c.Success");
        
            toastEvent.setParams({
                title: titleTp,
                mode: 'dismissible',
                type: Evnttype,
                message: toastMsg
            });
            toastEvent.fire();
        }


})