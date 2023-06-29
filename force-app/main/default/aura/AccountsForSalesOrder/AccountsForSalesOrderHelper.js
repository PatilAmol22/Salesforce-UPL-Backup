({
    loginUserDetails: function(component, event, helper) {
        //console.log('RecordTp.... ',rcdTp_nm);
      component.set("v.showSpinner", true);
      var userId = component.get("v.loginUserId");
      var action = component.get("c.getLoginUserDetails");

      action.setParams({
        user_id: userId
      });

      action.setCallback(this, function(response) {
      if (response.getState() == "SUCCESS") {
          
        var resp = response.getReturnValue();
        console.log('Response.... ',resp);
        if(resp != null){
          component.set("v.userCountry",resp);  
          this.fetchAccounts(component, event, helper);
        }
        else{
          component.set("v.errorMsg", $A.get("$Label.c.Log_In_User_Country_Not_Found"));
          component.set("v.showError", true);
        }
      }
      else{
        component.set("v.errorMsg", $A.get("$Label.c.ERROR_REQUEST_FAILED_NO_ERROR"));
        component.set("v.showError", true);
      }

      component.set("v.showSpinner", false);
      });
      $A.enqueueAction(action);
    },

    fetchAccounts: function(component, event, helper) {
        //console.log('RecordTp.... ',rcdTp_nm);
        component.set("v.showSpinner", true);
        var userId = component.get("v.loginUserId");
        var action = component.get("c.getAccountList");

        action.setParams({
          user_id: userId
        });

        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                
            var resp = response.getReturnValue();
            console.log('Status Response.... ',resp);
            if(resp == null || resp == ''){
                component.set("v.errorMsg", $A.get("$Label.c.Account")+' '+$A.get("$Label.c.Not_Available"));
                component.set("v.showError", true);
            }
            else{
                component.set("v.accountList", resp); 
                component.set("v.showSuccess", true);
            }
            
            }
            else{
            component.set("v.errorMsg", $A.get("$Label.c.ERROR_REQUEST_FAILED_NO_ERROR"));
            component.set("v.showError", true);
            }
            
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
   }
})