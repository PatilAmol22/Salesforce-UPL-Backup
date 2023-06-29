({
    loadTerritories : function(component,event) {
        var action = component.get("c.getTerritories");
        action.setCallback(this,function(response) {
            var state= response.getState();
            if(state==='SUCCESS'){
                component.set("v.territories",response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
        
    },
    loadMonth : function(component,event) {
        var ac = component.get("c.getMonth"); 
        ac.setCallback(this,function(response) {
            var state= response.getState();
            if(state==='SUCCESS'){
                component.set("v.Month",response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(ac);
    },
    loadFY : function(component,event) {
        var act = component.get("c.getFYData");
        act.setCallback(this,function(response) {
            var state= response.getState();
            if(state==='SUCCESS'){
                component.set("v.fYear",response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(act);
    },
    
    CheckIfLiquidationIsSubmitted: function(component,event){
        
        var selectedTerritories = component.get("v.selectedTerritories");
        var mon = component.get('v.Month');
        var fy = component.get('v.fYear');
        var actions = component.get("c.getAlreadyApprovedRecord"); 
        actions.setParams({ 
            sTerritory: selectedTerritories, 
            currentFY: fy,
            currentMonth: mon
        });
        actions.setCallback(this,function(response) {
            var state= response.getState();
            if(state==='SUCCESS'){
                component.set("v.CheckLiquidationStatus",response.getReturnValue());
                var check = component.get("v.CheckLiquidationStatus");
                console.log('CheckLiquidationStatus'+check);
                if( component.get("v.CheckLiquidationStatus") === "Approved" ){
                    component.set("{!v.recordApproved}",false);
                    component.set("{!v.NotSubmittedMessage}","Liquidation for Selected Territory is Approved already");
                }else if( component.get("v.CheckLiquidationStatus") === "Rejected" ){
                    component.set("{!v.recordApproved}",false);
                    component.set("{!v.NotSubmittedMessage}","Liquidation for Selected Territory is Rejected");
                }else if( component.get("v.CheckLiquidationStatus") === "Not Created" ){
                    component.set("{!v.recordApproved}",false);
                    component.set("{!v.NotSubmittedMessage}","Liquidation for Selected Territory is Not Yet Submitted");
                }else{
                    component.set("{!v.recordApproved}",true);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(actions);
    },
    approvedData : function(component, event, helper){
        var tId = component.get("v.selectedTerritories");
        console.log('Approve Button Territory' +tId);
        var FY = component.get("v.fYear");
        var M = component.get("v.Month");
        var commentLine= component.get("v.commentValue");
        
        var action = component.get("c.liquiApprove");
        action.setParams({
            "tId" : tId,
            "FY" : FY,
            "M" : M,
            commentHistory:commentLine
        });
        action.setCallback(this,function(response) {
            var state= response.getState();
            if(state==='SUCCESS'){
                var result = response.getReturnValue();
                console.log('result' +result);
                if( result==="Liquidation YTD sales and Crop sum is miss-match"||result==="Failed to Approve records" ){
                    /* var toastEvent1 = $A.get("e.force:showToast");
                    var titl  = $A.get("{!$Label.c.Error}");
                    toastEvent1.setParams({
                        "title": titl,
                        "type": "Error",
                        "message": response.getReturnValue()
                    });
                    toastEvent1.fire(); */
                    alert(result);
                    var cmpTarget = component.find('CropTab');
                    $A.util.addClass(cmpTarget, 'changeMe');
                }else if( result==="Liquidation for this territory is Approved successfully" ){
                    /*  var toastEvent1 = $A.get("e.force:showToast");
                    var titl  = $A.get("{!$Label.c.Success}");
                    toastEvent1.setParams({
                        "title": titl,
                        "type": "Success",
                        "message": response.getReturnValue()
                    });
                    toastEvent1.fire(); */
                    alert('Liquidation for this territory is Approved successfully');
                }
                this.CheckIfLiquidationIsSubmitted( component, event, helper );
            }
            else{
                
            }
        });
        $A.enqueueAction(action);
    },
    rejectData : function(component, event, helper){
        var tId = component.get("v.selectedTerritories");
        console.log('Reject Button Territory' +tId);
        var FY = component.get("v.fYear");
        var M = component.get("v.Month");
        var commentLine= component.get("v.commentValue");
        
        var action = component.get("c.liquiReject");
        action.setParams({
            "tId" : tId,
            "FY" : FY,
            "M" : M,
            commentHistory:commentLine
        });
        action.setCallback(this,function(response) {
            var state= response.getState();
            if(state==='SUCCESS'){
                /*  var toastEvent1 = $A.get("e.force:showToast");
                var titl  = $A.get("{!$Label.c.Success}");
                toastEvent1.setParams({
                    "title": titl,
                    "type": "Error",
                    "message": response.getReturnValue()
                });
                toastEvent1.fire(); */
                alert(response.getReturnValue());
                this.CheckIfLiquidationIsSubmitted( component, event, helper );
            }
            else{
                
            }
        });
        $A.enqueueAction(action);
    }
})