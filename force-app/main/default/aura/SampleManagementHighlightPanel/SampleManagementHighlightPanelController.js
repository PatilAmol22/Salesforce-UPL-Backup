({
    doInit: function(component, event, helper) {
        console.log('Do init----------------'+component.get("v.recordId"));
        
        console.log('3`213'+component.find("navigationService"));
    },
	redirectSamplematerial : function(component, event, helper) {
		console.log('----------------'+component.get("v.recordId"));
        var recordId1 = component.get("v.recordId");
        
        /* var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef  : "c:SampleManagementEdit" ,
                componentAttributes  : {
                    recordId :recordId,
                    
                },
                isredirect : true
            });
            console.log('Event '+evt);
            evt.fire();*/
       var pageref = {
    type: "standard__component",
    attributes: {
        componentName: "c__SampleManagementEdit" 
    },
    state: { 
        "c__id":recordId1
    }
	}
        component.find("navigationService").navigate(pageref,true);
       component.set("v.pageReference",pageref);
	},
    handlePageChange : function(component, event, helper) {
        console.log('highlight panel handler');
    }
})