({
	doInit : function(cmp, event, helper) {
		var action = cmp.get("c.getKYCList");
        action.setParams({ accountId : cmp.get("v.AccountId") , SurveyId : cmp.get("v.SurveyId") });
		action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //("From server: " + response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	}
})