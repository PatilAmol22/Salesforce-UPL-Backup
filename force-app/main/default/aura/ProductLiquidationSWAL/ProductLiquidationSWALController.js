({
    doInit : function(component, event, helper) {
        console.log('Product Component doinit');
        console.log('Territory Id-->'+component.get("v.ProductTerritoryId")  );
        helper.fetchData(component,event, helper);
        //Added by Varun Shrivastava: SCTASK0459610
        helper.fetchLiquidationCustomSetting(component);
        //Added by Varun Shrivastava: SCTASK0459610
    },
    
    handleSaveEdition: function (component, event, helper) {
        /*var target = event.getSource();  
        var val = target.get("v.value");
        if(parseFloat(val) <= 0 || isNaN(parseFloat(val))){
            target.focus();
            target.set("v.value",0);
        }*/
        helper.handleEditCell(component, event, helper);
        //window.setTimeout( $A.getCallback(function() {helper.handleEditCell(component,event,helper);}),2000 );
        
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