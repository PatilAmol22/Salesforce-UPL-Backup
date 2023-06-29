({
	doInit : function(component, event, helper) {
		var recId = component.get("v.recordId");
        console.log('GTM recordId '+recId);
        component.set("v.isView",true);
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:gtmPathFinder",
            componentAttributes: {
                gtmid : component.get("v.recordId")
            }
        });
        evt.fire();
	},
    handlePageChange : function(component, event, helper) {
        console.log("pageReference attribute change");
        component.find('pathfinder').getFiredFromAura();
    }
})