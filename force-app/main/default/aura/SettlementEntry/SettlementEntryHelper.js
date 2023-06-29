({
    getItemFields : function(component) {
        var returnValue = component.get("v.formFields");
        var itemList = returnValue.itemList;
        //Items
        var opts = [];
        opts.push({"class": "optionClass", label: 'None', value: 'None'});
        for(var i=0; i< itemList.length; i++){
            opts.push({"class": "optionClass", label: itemList[i], value: itemList[i]});                        
        }
        component.find("itemOptions").set("v.options", opts);                
        //End
    },
    
    callEvent : function(component){
        var stlEvent = component.getEvent("stlEvent");
        stlEvent.setParams({
            "message" : "message" });
        stlEvent.fire();
    },
    
    getFormFields : function(component) {
        // show spinner to true on click of a button / onload
        component.set("v.showSpinner", true);
        
        var action = component.get("c.getFormFields");

        var opts=[];   
        action.setCallback(this, function(a) {
            
            // on call back make it false ,spinner stops after data is retrieved
            component.set("v.showSpinner", false); 
            
            var state = a.getState();
            console.log('state: '+JSON.stringify(state));   
            if (state == "SUCCESS") {
                var returnValue = a.getReturnValue();
                component.set("v.formFields",returnValue);
                //console.log('returnValue: '+JSON.stringify(returnValue));   
            }
        });
        $A.enqueueAction(action);
    },
    
    getTotalItem : function(component) {
        var settlementItemList = component.get("v.settlementItemList"); 
        var totalSettlementItem = 0;
        for (var idx = 0; idx < settlementItemList.length; idx++) {
            totalSettlementItem += settlementItemList[idx].subtotal;
        }
        component.set("v.totalSettlementItem",totalSettlementItem);
    },
    
    getTotalLiquidation : function(component) {
        var settlementLiquidationList = component.get("v.settlementLiquidationList"); 
        var totalSettlementLiquidation = 0;
        for (var idx = 0; idx < settlementLiquidationList.length; idx++) {
            totalSettlementLiquidation += settlementLiquidationList[idx].subtotal;
        }
        component.set("v.totalSettlementLiquidation",totalSettlementLiquidation);
    },
    
    getTotalR1 : function(component) {
        var settlementLiquidationList = component.get("v.settlementLiquidationList"); 
        var totalR1StockAfterActivity = 0;
        for (var idx = 0; idx < settlementLiquidationList.length; idx++) {
            totalR1StockAfterActivity += settlementLiquidationList[idx].subtotalR1;
        }
        component.set("v.totalR1StockAfterActivity",totalR1StockAfterActivity);
    },
    
    validateForm: function (component) {
        var isValid = true;

        var settlementItemList = component.get("v.settlementItemList"); 
        var settlementLiquidationList = component.get("v.settlementLiquidationList"); 
        
        if( settlementItemList.length == 0 || settlementLiquidationList.length == 0 ){
        //if(settlementItemList.length == 0){
            isValid = false;
            //this.showErrorToast(component, 'Please fill Item & Accomodations before proceeding.');
            this.showErrorToast(component, 'Please fill all sections before proceeding');
        }
        
        component.set("v.isValid", isValid);
    },
    
    // Show Success Toast (Green)
    // Note: Shows a javascript alert in case the component is loaded within a visualforce page
    showToast : function(component, toastMsg) {
        var toastEvent = $A.get("e.force:showToast");
        var success = $A.get("$Label.c.Success");
        // For lightning1 show the toast
        if (toastEvent!=undefined){
            
            //fire the toast event in Salesforce1
            toastEvent.setParams({
                title: success,
                mode: 'dismissible',
                type: 'success',
                message: toastMsg/*,
                messageTemplate: '{0} '+toastMsg+' {1}',
                messageTemplateData: ['Salesforce', {
                url: '/one/one.app?#/sObject/'+recordId+'/view',
                label: ' Click here',}]*/
            });
            toastEvent.fire();
        }
        else{ // otherwise throw an alert
            alert(success+': ' + toastMsg);
        }
    },
    
    //Show Error Message Toast (Red)
    // Note: Shows a javascript alert in case the component is loaded within a visualforce page
    showErrorToast : function(component, toastMsg) {
        var toastEvent = $A.get("e.force:showToast");
        
        // For lightning1 show the toast
        if (toastEvent){
            //fire the toast event in Salesforce1
            toastEvent.setParams({
                title: 'Error',
                mode: 'dismissible',
                type: 'error',
                message: toastMsg
            });
            toastEvent.fire();
        }
        else{ // otherwise throw an alert
            alert(error+': ' + toastMsg);
        }
    },
    
    applyCSS: function(component){
        //component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:0} .forceStyle.desktop ");
    },
    
    revertCssChange: function(component){
        //component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:5} .forceStyle.desktop .viewport{overflow:visible}");
    },
})