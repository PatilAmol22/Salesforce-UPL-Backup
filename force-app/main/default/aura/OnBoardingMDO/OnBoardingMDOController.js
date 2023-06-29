({
    doInit : function(component, event, helper) {
        console.log('in do init method');
        var recId = component.get("v.recordId");
        console.log('recId '+recId);
        // calling helper method
        helper.getingMDODetails(component,event,helper,recId);
        // location.reload();
        window.setTimeout($A.getCallback(function() {location.reload();}),5000 );
        // window.setTimeout($A.getCallback(function() {helper.gotoURL(component,recId);}),2000 );
        
    }
})