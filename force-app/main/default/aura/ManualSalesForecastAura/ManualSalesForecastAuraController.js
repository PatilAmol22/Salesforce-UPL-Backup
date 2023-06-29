({
    doInit: function(component, event, helper) {
        
        var recordId = component.get("v.recordId");
        console.log('recordId.... : '+ recordId);
        //$A.get("e.force:closeQuickAction").fire();
    }, 

    closeQA : function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
      },
})