({
    doInit : function(component, event, helper) {     
        helper.loadTerritories(component,event); 
        helper.loadFY(component,event);
        helper.loadMonth(component,event);
    },
    onterritoriesChange :  function(component, event, helper) {
        component.set("v.recordApproved",false);
        component.set("{!v.NotSubmittedMessage}","Loading..........");
        var selectTerritory = component.find("sterritories").get("v.value"); 
        component.set("v.selectedTerritories",selectTerritory);
        //alert("Selected Territories : " +selectTerritory);
        if(selectTerritory != "-- None --" && selectTerritory != "" && selectTerritory != undefined){
            helper.CheckIfLiquidationIsSubmitted( component, event, helper );
        }else{
            component.set("{!v.NotSubmittedMessage}","Please select a Territory");
        }
        
    },
    
    handleApprove: function(component, event, helper) {
        helper.approvedData(component,event);
    },
    handleReject: function(component, event, helper) {
        helper.rejectData(component,event);
    },
    tabSelected : function(component, event, helper){
        console.log('Tab Selection= '+component.find("tabs").get("v.selectedTabId"));
        var cropComponent = component.find("CropLiquidation");
        cropComponent.callChildMethod();
    }
})