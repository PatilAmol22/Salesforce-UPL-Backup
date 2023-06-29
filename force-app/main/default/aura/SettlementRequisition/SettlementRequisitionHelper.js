({    
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
                //component.set("v.formFields",returnValue);
                //console.log('returnValue: '+JSON.stringify(returnValue));   
                
                var activityTypeList = returnValue.activityTypeList;
                var mtdList = returnValue.mtdList;
                
                //Activity Type
                opts.push({"class": "optionClass", label: 'ACTIVITY', value: 'None'});
                for(var i=0; i< activityTypeList.length; i++){
                    opts.push({"class": "optionClass", label: activityTypeList[i].toUpperCase(), value: activityTypeList[i]});                        
                }
                component.find("activityTypeOptions").set("v.options", opts);                
                //End
                
                //MTD
                opts=[];
                opts.push({"class": "optionClass", label: 'Month to Date', value: 'None'});
                for(var i=0; i< mtdList.length; i++){
                    var str = mtdList[i];
                    var splitValues = str.split("*");
                    opts.push({"class": "optionClass", label: splitValues[0], value: splitValues[1]});
                }
                component.find("mtdOptions").set("v.options", opts);
                //console.log("opts: "+JSON.stringify(opts));
                //End
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchActivities : function(component, page, recordToDisply, sortField, isAsc, whereClause){
        // show spinner to true on click of a button / onload
        component.set("v.showSpinner", true);
        
        var action = component.get("c.getActivities");
        
        var opts=[];   
        
        action.setParams({
            pageNumber: page,
            recordToDisply: recordToDisply,
            sortField: sortField,
            isAsc: isAsc,
            whereClause: whereClause
        });
        
        action.setCallback(this, function(a) {
            
            // on call back make it false ,spinner stops after data is retrieved
            component.set("v.showSpinner", false); 
            
            var state = a.getState();
            console.log('state: '+JSON.stringify(state));   
            
            if (state == "SUCCESS") {
                var returnValue = a.getReturnValue();
                //console.log('returnValue: '+JSON.stringify(returnValue.results));
                //component.set("v.pagedResult", returnValue);
                
                component.set("v.activityList", returnValue.results);  
                component.set("v.page", returnValue.page);  
                component.set("v.total", parseInt(returnValue.total));  
                component.set("v.pages", Math.ceil(returnValue.total / recordToDisply));  
                
                console.log('total: '+returnValue.total);
                console.log('recordToDisply: '+recordToDisply);
                console.log('pages: '+Math.ceil(returnValue.total / recordToDisply));
                
                /*var start = component.get("v.start");
                var end = component.get("v.end");
                
                if(start==0 && end==0){
                    var page = component.get("v.page") || 1; 
                    var recordToDisply = component.find("recordSize").get("v.value");
                    var total = component.get("v.total");
                    console.log('total: '+total);
                    if(recordToDisply > total){
                        end = total;
                    }
                    else{
                        end = recordToDisply;
                    }
                    if(total==0){
                        start = 0;
                    }
                    else{
                        start = 1;
                    }
                    component.set("v.start",start);
                    component.set("v.end",end);
                }*/
            }
            else{
                this.showErrorToast(component, 'Some error has occurred. Please contact System Administrator.');
            }
        });
        $A.enqueueAction(action);
    },
        
    sortHelper: function(component, event, sortFieldName) {  
        var currentDir = component.get("v.arrowDirection");  
        if (currentDir == 'arrowdown') {  
            component.set("v.arrowDirection", 'arrowup');  
            component.set("v.isAsc", true);  
        } else {  
            component.set("v.arrowDirection", 'arrowdown');  
            component.set("v.isAsc", false);  
        }  
        this.fetchActivities(component, component.get("v.page"), component.find("recordSize").get("v.value"), sortFieldName, component.get("v.isAsc"), '');  
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
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:0} .forceStyle.desktop ");
    },
    
    revertCssChange: function(component){
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:5} .forceStyle.desktop .viewport{overflow:visible}");
    },
})