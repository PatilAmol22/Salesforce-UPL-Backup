({
    doInit : function(component, event, helper) {
        /* var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        $A.get('e.force:refreshView').fire(); */
        component.set("v.showSpinner", true);
        var recordId = component.get("v.recordId");
        console.log('recordId.... : '+ recordId);
        if(recordId != ''){
            
            helper.checkStatus(component, event, helper);
        }
        else{
            
            component.set("v.errorMsg", $A.get("$Label.c.Quote_Id_Not_Found"));
            component.set("v.showError", true);
            component.set("v.showSpinner", false);
        }        
    },

    doneRendering: function(cmp, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },

    redirectToOrder: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.showSuccess", false);
        var soId = component.get("v.soList");
        /* for(var i=0;i<soId.length;i++){
            window.open("/lightning/r/Sales_Order__c/"+soId[i]+"/view","_blank");
        } */
        window.open("/lightning/r/Sales_Order__c/"+soId[0]+"/view","_blank");
        $A.get("e.force:closeQuickAction").fire();
    },

    reloadPage: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.showError", false);
        $A.get("e.force:closeQuickAction").fire();
        location.reload(true);
    },


    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.showSuccess", false);
        $A.get("e.force:closeQuickAction").fire();
        //location.reload(true);
    },

    closeErrorModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.showError", false);
        $A.get("e.force:closeQuickAction").fire();
    },
})