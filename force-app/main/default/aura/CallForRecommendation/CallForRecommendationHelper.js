({
	//START
	
    fetchPicklistValues: function(component,objDetails,controllerField, dependentField,mapAttrName) {
        // call the server side function  
        var action = component.get("c.getDependentMap");
        // pass paramerters [object definition , contrller field name ,dependent field name] -
        // to server side function 
        action.setParams({
            'objDetail' : objDetails,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField,
            //'depfieldApiNameDU' : dependentFieldDU
        });
        //set callback   
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set(mapAttrName,StoreResponse);
                 if(mapAttrName == 'v.depnedentFieldMap' || mapAttrName == 'v.depnedentFieldMapDU'){
                // create a empty array for store map keys(@@--->which is controller picklist values) 
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                
                //set the controller field value for lightning:select
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push('');
                }
                
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }  
                // set the ControllerField variable values to country(controller picklist field)
                component.set("v.listControllingValues", ControllerField);
            }else{
                alert('Something went wrong..');
            }
        }
        });
        $A.enqueueAction(action);
    },
    
    fetchDepValues: function(component, ListOfDependentFields,lstAttrName) {
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
        dependentFields.push('');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set(lstAttrName, dependentFields);
        
    },
    
    
    //END


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
            }else{
                alert('Callback Failed...');
            }
        });
        $A.enqueueAction(action);
    },	
    
    fetchPickListVal1: function(component, fieldName,targetAttribute) {
        var action = component.get("c.getselectOptions1");
        action.setParams({
            "objObject": component.get("v.objInfo1"),
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
            }else{
                alert('Callback Failed...');
            }
        });
        $A.enqueueAction(action);
    },	
    
    saveRecommendationCall : function(component, event, helper) {
        var pid = component.get("v.callid");
        var pval = component.get("v.provalue");
        var pdos = component.get("v.pdosage");
        var dval = component.get("v.douvalue");
                console.log('1 '+pid);
        console.log('2 '+pval);
        console.log('3 '+pdos);
        console.log('4 '+dval);
        var action = component.get("c.createRecommendation");
        action.setParams({
            "callId" : pid,
            "productname" : pval,
            "productdosage" : pdos,
            "productdosageunit" : dval,
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var responseVal = response.getReturnValue();
            
            /*
            for (i=0;i<responseVal.length;i++){
            console.log('reponseValId Recommendations Id=='+responseVal[i].Id);    
            }
            console.log('reponseValreponseValreponseVal ==-=--=-=-=--=-=='+responseVal);
            */
            var allValid = component.find('inputRecommendation').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
            
            if (allValid) {
                
                //component.find("empanelmentRecordCreator").saveRecord(function(saveResult) {
                
                if (state === "SUCCESS" || state === "DRAFT") {
                    
                     //returned List of recommendation object
                    component.set("v.ListofRecommendation", response.getReturnValue());
                    component.set("v.setFalse",false);
                    
                    //added by Swapnil
                    var action2 = component.get("c.mapCRController");
                   
                    action2.setParams({ 
                        "empanelmentId" : component.get("v.EmpanelmentId"),
                    });
                    
                     action2.setCallback(this, function(response){
                       	 var state1 = response.getState();
                         
                         var responseVal1 = response.getReturnValue();
                          if (state1 === "SUCCESS" || state1 === "DRAFT") {
                              
                              component.set("v.MapCR",response.getReturnValue());
                              var arrayOfMapKeys = [];
                              for (var singlekey in responseVal1) {
                                  arrayOfMapKeys.push(singlekey);
                                  console.log('==- = singlekey '+singlekey);
                              }
                              // Set the all list of keys on component attribute, which name is lstKey and type is list.     
                              component.set("v.lstCR", arrayOfMapKeys);
                              component.set("v.recommendationFlagSaveCFR",false);
                              component.set("v.viewRecommendationFlagCFR",true);
                              
                              component.set("v.vRFlag",true);
                              component.set("v.rFlagSave",false);
                              
                              var resultsToast = $A.get("e.force:showToast");
                              resultsToast.setParams({
                                  "title": "Saved Recommendation",
                                  "message": "The record was saved.",
                                  "type" : "Success"
                              });
                              resultsToast.fire();
                          }
                         
                         
                     });
                     $A.enqueueAction(action2);
                    //end Here
                    
                } else if (state === "INCOMPLETE") {
                    component.set("v.recordSaveError","User is offline, device doesn't support drafts.");
                    
                } else if(state === "ERROR"){
                    var errMsg = "";
                    var error = response.getError();
                    
                    for (var i = 0; i < error.length; i++) {
                        errMsg += error[i].message + "\n";
                    }
                    component.set("v.alertError", errMsg);
                } else {
                    component.set("v.alertError",'Unknown problem, state: ' + state + ', error: ' + 
                                  JSON.stringify(error));
                } 
                
            }else {
                var errorMessage = "Please update the invalid form entries and try again."
                component.set("v.alertErrorBoolean",true);
                component.set("v.alertError",errorMessage);
                var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Error/Errors",
                        "message": "Please check all fields for invalid entries.",
                		"type" : "Error"
                    });
                    resultsToast.fire();
            }
            
        });
        $A.enqueueAction(action);
    },
})