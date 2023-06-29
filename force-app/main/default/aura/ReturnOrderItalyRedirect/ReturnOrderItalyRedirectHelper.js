({
    getAccountDetails : function(component, event, helper) {
        component.set("v.showSpinner", true);
        //var userId = component.get("v.loginUserId");
        var recordId = component.get("v.recordId");
        var action = component.get("c.getAccountData");
        if(recordId!=null){
            action.setParams({
                recordId: recordId
            });
        }
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var resp = response.getReturnValue();
                console.log('Response.... ',resp);
                if(resp != null){
                    if(resp.soCode != '2410'){
                        var errorMsg = "This functionality is not available for you";
                        component.set("v.errorMsg", errorMsg);
                        component.set("v.showError", true);
                        alert(errorMsg);
                        var urlInstance= window.location.hostname;
                        var baseURL = 'https://'+urlInstance+'/lightning/r/Account/'+recordId+'/view';
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": baseURL
                        });
                        urlEvent.fire();
                    }
                    else {
                        var evt = $A.get("e.force:navigateToComponent");
                        evt.setParams({
                            componentDef: "c:ReturnOrderItaly",  /* ReturnOrderItaly */
                            componentAttributes: {
                                recordId: recordId
                            }
                        });
                        console.log("main button was created");
                        evt.fire();
                        
                    }
                }
                else{
                    component.set("v.errorMsg", $A.get("$Label.c.ERROR_REQUEST_FAILED_NO_ERROR"));
                    console.log('SORedirect Error - ',  $A.get("$Label.c.ERROR_REQUEST_FAILED_NO_ERROR"));
                    component.set("v.showError", true);
                }
                
                component.set("v.showSpinner", false);
                $A.get("e.force:closeQuickAction").fire();
            }});
            $A.enqueueAction(action);
        }
})