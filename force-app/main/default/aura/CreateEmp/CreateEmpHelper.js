({
    fetchPickListVal: function(component, fieldName,targetAttribute) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.set("v."+targetAttribute, opts);
            }else if(response.getState() == "ERROR"){
                var errors = response.getError();
                if(errors || errors[0].message)
                {
                    alert('Callback Failed...with Error');
                    console.log("Error Message: " + errors);
                }
                
            }
        });
        $A.enqueueAction(action);
    },	
    
    handleSaveEmpanelementHelper: function(component,event,helper){
        
        component.set("v.simpleNewEmpanelment.Farmer__c",component.get("v.FarmerId"));
        
        var allValid = component.find('inputEmpanelment').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if (allValid) {
            
            component.find("empanelmentRecordCreator").saveRecord(function(saveResult) {
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                    component.set('v.recordId',saveResult.recordId);
                    //add here
                    component.set("v.alertErrorBoolean",false);
                    component.set("v.alertErrorBoolean1",false);
                    
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Saved",
                        "message": "The record was saved.",
                		"type" : "Success",
                        "duration" : 5000
                    });
                    resultsToast.fire();
                    
                    
                    component.set('v.empanelmentreadonly',true);
                    component.set('v.empanelmentFlag',false);                
                    component.set('v.recommendationFlag',true);
                    component.set('v.recommendationFlagSave',false);
                    
                    var buttonname = event.getSource().get("v.name");
                    
                    if(buttonname == 'srbutton'){
                        component.set('v.recommendationFlagSave',true);
                    }
                    
                } else if (saveResult.state === "INCOMPLETE") {
                    component.set("v.recordSaveError","User is offline, device doesn't support drafts.");
                    
                } else if(saveResult.state === "ERROR"){
                    var errMsg = "";
                    // saveResult.error is an array of errors, 
                    // so collect all errors into one message
                    for (var i = 0; i < saveResult.error.length; i++) {
                        errMsg += saveResult.error[i].message + "\n";
                    }
                    component.set("v.newEmpanelmentError", errMsg);
                    component.set("v.alertErrorBoolean1", true);
                    
                } else {
                    component.set("v.newEmpanelmentError",'Unknown problem, state: ' + saveResult.state + ', error: ' + 
                                  JSON.stringify(saveResult.error));
                }
            }); 
            
        }
        else {
            var errorMessage = "Please update the invalid form entries and try again."
            component.set("v.alertErrorBoolean",true);
            component.set("v.alertError",errorMessage);
        }
    },
})