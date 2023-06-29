({
    loginUserDetails: function(component, event, helper) {
        component.set("v.showSpinner", true);
        //var userId = component.get("v.loginUserId");
        var recordId = component.get("v.recordId");
        var action = component.get("c.getLoginUserDetails");
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                
              var resp = response.getReturnValue();
              console.log('Response.... ',resp);
              if(resp != null){
                //component.set("v.userCountry",resp);  
                 if(resp == 'Spain'){
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef: "c:SpainPortugalSalesOrder",  /* SpainPortugalSalesOrder */
                        componentAttributes: {
                            recordId: recordId
                        }
                    });
                    evt.fire();
                 }
                 else if(resp == 'Vietnam'){
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef: "c:VietnamSalesOrder",  
                        componentAttributes: {
                            recordId: recordId
                        }
                    });
                    evt.fire();
                 }
                 else if(resp == 'Bolivia' || resp == 'Paraguay'){
                  var evt = $A.get("e.force:navigateToComponent");
                  evt.setParams({
                      componentDef: "c:BoliviaParaguaySalesOrder",  
                      componentAttributes: {
                          recordId: recordId
                      }
                  });
                  evt.fire();
               }
              }
              else{
                component.set("v.errorMsg", $A.get("$Label.c.Log_In_User_Country_Not_Found"));
                console.log('SORedirect Error - ',  $A.get("$Label.c.Log_In_User_Country_Not_Found"));
                component.set("v.showError", true);
              }
            }
            else{
              component.set("v.errorMsg", $A.get("$Label.c.ERROR_REQUEST_FAILED_NO_ERROR"));
              console.log('SORedirect Error - ',  $A.get("$Label.c.ERROR_REQUEST_FAILED_NO_ERROR"));
              component.set("v.showError", true);
            }
      
            component.set("v.showSpinner", false);
            $A.get("e.force:closeQuickAction").fire();
            });
            $A.enqueueAction(action);
    }
})