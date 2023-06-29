({
    doInit : function(component, event, helper) {
        
        helper.loadTerritories(component,event);
        helper.loadFiscal_year(component,event);
        helper.loadMonths(component,event);
        //helper.fetchData(component,event, helper);
        
    },
    onterritoriesChange :  function(component, event, helper) {
        component.set("v.comments","");
        component.set("{!v.CheckIfLiquidationIsSubmitted}",false);
        component.set("{!v.NotSubmittedMessage}","Loading..........");
        var selectedTerritories = component.find("sterritories").get("v.value");
        if(selectedTerritories != "-- None --" && selectedTerritories != "" && selectedTerritories != undefined){
            var action = component.get("c.getTerritoryName");
            action.setParams({
                "tId" : selectedTerritories
            });
            action.setCallback(this,function(response) {
                var state= response.getState();
                if(state==='SUCCESS'){
                    component.set("v.selectedTerritoryName",response.getReturnValue());
                }
                else{
                    console.log("Failed to get Territory name with state: " + state);
                }
            });
            $A.enqueueAction(action);
            
            component.set("v.selectedTerritories",selectedTerritories);
            helper.CheckIfLiquidationIsSubmitted( component, event, helper );
        }else{
            component.set("{!v.NotSubmittedMessage}","Please select a Territory");
            component.set("{!v.CheckIfLiquidationIsSubmitted}",false);
        }
    },
    handleApprove : function(component, event, helper){
        helper.handleApproveAllData(component, event, helper);
    },
    handleReject : function(component, event, helper){
        helper.handleRejectAllData(component, event, helper);
    },
    tabSelected : function(component, event, helper){
        console.log('Tab Selection= '+component.find("tabs").get("v.selectedTabId"));
        var cropComponent = component.find("CropLiquidationSWAL");
        cropComponent.callChild();
    },
    commentsSave : function(component, event, helper){
        var b = component.find("tabs").get("v.value");
        console.log('comment -->'+b);
    }
})