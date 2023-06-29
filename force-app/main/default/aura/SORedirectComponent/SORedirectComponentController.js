({
    doInit : function(component, event, helper) {
        component.set("v.showSpinner", true);
        var recordId = component.get("v.recordId");
        console.log('SORedirectComponent recordId.... : '+ recordId);
        if(recordId != ''){
            helper.loginUserDetails(component, event, helper);
           
        }
        else{
            component.set("v.errorMsg", $A.get("$Label.c.No_Records_Found"));
            console.log('SORedirect Error - ',  $A.get("$Label.c.No_Records_Found"));
            component.set("v.showError", true);
            $A.get("e.force:closeQuickAction").fire();
        }
       // component.set("v.showSpinner", false);
        
        
    },
})