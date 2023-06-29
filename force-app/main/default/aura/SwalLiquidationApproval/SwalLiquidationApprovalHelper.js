({
    loadTerritories : function(component,event) {
        var action = component.get("c.getsTerritories");
        action.setCallback(this,function(response) {
            console.log("Inside Callback");
            var state= response.getState();
            console.log("**state: " + state);
            if(state==='SUCCESS'){
                component.set("v.territories",response.getReturnValue());
                //console.log("Success : " +JSON.stringify(res));
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
        
    },
    loadFiscal_year : function(component,event){
        var action = component.get("c.getFiscal_Year");
        action.setCallback(this,function(response) {
            var state= response.getState();
            if(state==='SUCCESS'){
                component.set("v.Fiscal_Years",response.getReturnValue());
                component.set("v.selectedFiscalYear",response.getReturnValue());
            }
            else{
                console.log("Failed to load Fiscal_Year with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    loadMonths : function(component,event){
        var action = component.get("c.getMonths");
        action.setCallback(this,function(response) {
            var state= response.getState();
            if(state==='SUCCESS'){
                component.set("v.Months",response.getReturnValue());
                component.set("v.selectedMonth",response.getReturnValue());
            }
            else{
                console.log("Failed to load Months with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    CheckIfLiquidationIsSubmitted : function( component, event, helper ){
        var tId = component.get("v.selectedTerritories");
        var FY = component.get("v.selectedFiscalYear");
        var M = component.get("v.selectedMonth");
        console.log('t-->'+component.get("v.selectedTerritories"));
        console.log('fy-->'+component.get("v.selectedFiscalYear"));
        console.log('m-->'+component.get("v.selectedMonth"));
        var action = component.get("c.CheckIfLiquidationIsSubmittedApex");
        action.setParams({
            "tId" : tId,
            "FY" : FY,
            "M" : M
        });
        action.setCallback(this,function(response) {
            var state= response.getState();
            if(state==='SUCCESS'){
                component.set("v.CheckLiquidationStatus",response.getReturnValue());
                console.log('Liquidation-->'+response.getReturnValue());
                var tName = component.get("v.selectedTerritoryName");
                console.log('tName-->'+tName);
                if( component.get("v.CheckLiquidationStatus") === "Approved" ){
                    component.set("{!v.CheckIfLiquidationIsSubmitted}",false);
                    component.set("{!v.NotSubmittedMessage}","Liquidation for "+tName+" is Approved already");
                }else if( component.get("v.CheckLiquidationStatus") === "Rejected" ){
                    component.set("{!v.CheckIfLiquidationIsSubmitted}",false);
                    component.set("{!v.NotSubmittedMessage}","Liquidation for "+tName+" is Rejected");
                }else if( component.get("v.CheckLiquidationStatus") === "Not Created" ){
                    component.set("{!v.CheckIfLiquidationIsSubmitted}",false);
                    component.set("{!v.NotSubmittedMessage}","Liquidation for "+tName+" is Not Yet Submitted");
                }else{
                    component.set("{!v.CheckIfLiquidationIsSubmitted}",true);
                }
            }
            else{
                console.log("Failed to CheckIfLiquidationIsSubmitted with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    handleApproveAllData : function(component, event, helper){
        var tId = component.get("v.selectedTerritories");
        var FY = component.get("v.selectedFiscalYear");
        var M = component.get("v.selectedMonth");
        var comment = component.get("v.comments");
        console.log('handleApproveAllData tId-->'+tId);
        console.log('handleApproveAllData FY-->'+FY);
        console.log('handleApproveAllData M-->'+M);
        console.log('handleApproveAllData comment-->'+comment);
        var action = component.get("c.ApproveAllData");
        action.setParams({
            "tId" : tId,
            "FY" : FY,
            "M" : M,
            "C" : comment
        });
        action.setCallback(this,function(response) {
            var state= response.getState();
            if(state==='SUCCESS'){
                var result = response.getReturnValue();
                if( result==="Liquidation YTD sales and Crop sum is miss-match"||result==="Failed to Approve records" ){
                    /*var toastEvent1 = $A.get("e.force:showToast");
                    var titl  = $A.get("{!$Label.c.Error}");
                    toastEvent1.setParams({
                        "title": titl,
                        "type": "Error",
                        "message": response.getReturnValue()
                    });
                    toastEvent1.fire();*/
                    alert(result);
                    var cmpTarget = component.find('CropTab');
                    $A.util.addClass(cmpTarget, 'changeMe');
                }else if( result==="Liquidation for this territory is Approved successfully" ){
                    /*var toastEvent1 = $A.get("e.force:showToast");
                    var titl  = $A.get("{!$Label.c.Success}");
                    toastEvent1.setParams({
                        "title": titl,
                        "type": "Success",
                        "message": response.getReturnValue()
                    });
                    toastEvent1.fire();*/
                    alert('Liquidation for this territory is Approved successfully');
                }
                
                this.CheckIfLiquidationIsSubmitted( component, event, helper );
            }
            else{
                
            }
        });
        $A.enqueueAction(action);
    },
    handleRejectAllData : function(component, event, helper){
        var tId = component.get("v.selectedTerritories");
        var FY = component.get("v.selectedFiscalYear");
        var M = component.get("v.selectedMonth");
        var comment = component.get("v.comments");
        var action = component.get("c.RejectAllData");
        action.setParams({
            "tId" : tId,
            "FY" : FY,
            "M" : M,
            "C" : comment
        });
        action.setCallback(this,function(response) {
            var state= response.getState();
            if(state==='SUCCESS'){
                /*var toastEvent1 = $A.get("e.force:showToast");
                var titl  = $A.get("{!$Label.c.Success}");
                toastEvent1.setParams({
                    "title": titl,
                    "type": "Error",
                    "message": response.getReturnValue()
                });
                toastEvent1.fire();*/
                alert(response.getReturnValue());
                this.CheckIfLiquidationIsSubmitted( component, event, helper );
            }
            else{
                
            }
        });
        $A.enqueueAction(action);
    }
})