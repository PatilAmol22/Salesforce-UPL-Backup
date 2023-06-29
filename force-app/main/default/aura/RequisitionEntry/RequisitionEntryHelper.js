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
        var mktEvent = component.getEvent("mktEvent");
        mktEvent.setParams({
            "message" : "message" });
        mktEvent.fire();  
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
                
                var activityTypeList = returnValue.activityTypeList;
                var timeList = returnValue.timeList;
                
                //Activity Type
                opts.push({"class": "optionClass", label: 'None', value: 'None'});
                for(var i=0; i< activityTypeList.length; i++){
                    opts.push({"class": "optionClass", label: activityTypeList[i], value: activityTypeList[i]});                        
                }
                component.find("activityTypeOptions").set("v.options", opts);                
                //End
                
                //Time Picklist
                opts=[];
                opts.push({"class": "optionClass", label: 'None', value: 'None'});
                for(var i=0; i< timeList.length; i++){
                    opts.push({"class": "optionClass", label: timeList[i], value: timeList[i]});                        
                }
                component.find("timeOptions").set("v.options", opts);                
                //End
            }
        });
        $A.enqueueAction(action);
    },
    
    getTotalAllocation : function(component) {
        var allocationList = component.get("v.allocationList"); 
        var totalAllocation = 0;
        for (var idx = 0; idx < allocationList.length; idx++) {
            totalAllocation += allocationList[idx].allocationPercent;
        }
        component.set("v.totalAllocation",totalAllocation);
    },
    
    getTotalItem : function(component) {
        var itemList = component.get("v.itemList"); 
        var totalItem = 0;
        for (var idx = 0; idx < itemList.length; idx++) {
            totalItem += itemList[idx].subtotal;
        }
        component.set("v.totalItem",totalItem);
    },
    
    getTotalLiquidation : function(component) {
        var liquidationList = component.get("v.liquidationList"); 
        var totalLiquidation = 0;
        for (var idx = 0; idx < liquidationList.length; idx++) {
            totalLiquidation += liquidationList[idx].subtotal;
        }
        component.set("v.totalLiquidation",totalLiquidation);
    },
    
    validateForm: function (component) {
        var isValid = true;
        
        var allocationList = component.get("v.allocationList"); 
        var itemList = component.get("v.itemList"); 
        var liquidationList = component.get("v.liquidationList"); 
        
        var activityType = component.find("activityTypeOptions").get("v.value");
        //var crop = component.find("crop").get("v.value");
        var location = component.find("location").get("v.value");
        var farmersInvited = component.find("farmersInvited").get("v.value");
        var r1Invited = component.find("r1Invited").get("v.value");
        var startDate = component.find("startDate").get("v.value");
        var endDate = component.find("endDate").get("v.value");
        var time = component.find("timeOptions").get("v.value");
        
        if(activityType=='None'){
            isValid = false;
            component.find("activityTypeOptions").set("v.errors",[{message: 'Complete this field'}]);                    
        }
        else{
            component.find("activityTypeOptions").set("v.errors",null);    
        }
        //var crop = component.get("v.selectCR");
        var crop = component.get("v.apObj.Crop_txt__c");
        if(!crop){
            isValid = false;
            this.showErrorToast(component, 'Crop is required'); 
        }
        else{
            component.set("v.apObj.Crop__c", crop.val);
        }
        
        if(!location){
            isValid = false;
            component.find("location").set("v.errors",[{message: 'Complete this field'}]);                    
        }
        else{
            component.find("location").set("v.errors",null);    
        }
        
        if(!farmersInvited){
            isValid = false;
            component.find("farmersInvited").set("v.errors",[{message: 'Complete this field'}]);                    
        }
        else{
            component.find("farmersInvited").set("v.errors",null);    
        }
        
        if(!r1Invited){
            isValid = false;
            component.find("r1Invited").set("v.errors",[{message: 'Complete this field'}]);                    
        }
        else{
            component.find("r1Invited").set("v.errors",null);    
        }
        
        if(!startDate){
            isValid = false;
            component.find("startDate").set("v.errors",[{message: 'Complete this field'}]);                    
        }
        else{
            component.find("startDate").set("v.errors",null);    
        }
        
        if(!endDate){
            isValid = false;
            component.find("endDate").set("v.errors",[{message: 'Complete this field'}]);                    
        }
        else{
            component.find("endDate").set("v.errors",null);    
        }

        if(time=='None'){
            isValid = false;
            component.find("timeOptions").set("v.errors",[{message: 'Complete this field'}]);     
        }
        else{
            component.find("timeOptions").set("v.errors",null); 
        }
        
        //if(allocationList.length == 0 || itemList.length == 0 || liquidationList.length == 0){
        if(itemList.length == 0){
            isValid = false;
            this.showErrorToast(component, 'Please fill Item & Accomodations before proceeding.');
            //this.showErrorToast(component, 'Please fill all sections before proceeding');
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