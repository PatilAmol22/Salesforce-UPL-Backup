({
	doInit : function(component, event, helper) {
		helper.fetchData(component,event, helper);
        //Added by Varun Shrivastava: SCTASK0459610
        helper.fetchLiquidationCustomSetting(component);
        //Added by Varun Shrivastava: SCTASK0459610
	},
    handleSaveEdition: function (component, event, helper) {
        helper.handleEditCell(component, event, helper);
    },
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    }
    
})