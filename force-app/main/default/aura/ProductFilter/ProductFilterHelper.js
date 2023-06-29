({
    getFirstDetails: function(component, event, helper) {
        component.set("v.showSpinner", true);
       // var opp_id = component.get("v.recordId");
       // console.log("****Opportunity Id......: " + opp_id);
    
        var action = component.get("c.getFirstDropDown");
    
        /* action.setParams({
            id_val: opp_id
        }); */
    
        action.setCallback(this, function(response) {
          //  console.log(response.getError());
          if (response.getState() == "SUCCESS") {
            // console.log('*****Result****.... '+ JSON.stringify(response.getReturnValue()));
            var resp = response.getReturnValue();
            //console.log('*****Result****.... ', resp);
            component.set("v.firstDropDownList", resp);
          }
    
          component.set("v.showSpinner", false);
        });
    
        $A.enqueueAction(action);
      },

      getSecondDetails: function(component, event, helper) {
        component.set("v.showSpinner", true);
        var cat_id = component.get("v.firstVal");
       // console.log("****Opportunity Id......: " + cat_id);
    
        var action = component.get("c.getSecondDropDown");
    
        action.setParams({
            cat_val: cat_id
        });
    
        action.setCallback(this, function(response) {
          //  console.log(response.getError());
          if (response.getState() == "SUCCESS") {
            // console.log('*****Result****.... '+ JSON.stringify(response.getReturnValue()));
            var resp = response.getReturnValue();
            //console.log('*****Result****.... ', resp);
            component.set("v.secondDropDownList", resp);
          }
    
          component.set("v.showSpinner", false);
        });
    
        $A.enqueueAction(action);
      },

      getThirdDetails: function(component, event, helper) {
        component.set("v.showSpinner", true);
        var cat_id = component.get("v.firstVal");
        var sub_cat_id = component.get("v.secondVal");
       // console.log("****Opportunity Id......: " + cat_id);
    
        var action = component.get("c.getThirdDropDown");
    
        action.setParams({
            cat_val: cat_id,
            sub_cat_val: sub_cat_id
        });
    
        action.setCallback(this, function(response) {
          //  console.log(response.getError());
          if (response.getState() == "SUCCESS") {
            // console.log('*****Result****.... '+ JSON.stringify(response.getReturnValue()));
            var resp = response.getReturnValue();
            //console.log('*****Result****.... ', resp);
            component.set("v.thirdDropDownList", resp);
          }
    
          component.set("v.showSpinner", false);
        });
    
        $A.enqueueAction(action);
      },
});