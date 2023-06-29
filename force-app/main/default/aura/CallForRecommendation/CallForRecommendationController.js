({
    //Component On-Load
    init: function (component, event, helper) {
        
        //start
        // get the fields API name and pass it to helper function  
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var dependingFieldAPIDU = component.get("v.dependingFieldAPIDU");
        var objDetails = component.get("v.objDetail");
        // call the helper function
        helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI,"v.depnedentFieldMap");
        helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPIDU,"v.depnedentFieldMapDU");
        //end
        
        
        
        
        
        
        // call the fetchPickListVal helper function and pass (component, Field_API_Name, target_Attribute_Name_For_Store_Value)   
        helper.fetchPickListVal(component, 'Disease__c', 'Disease');
        helper.fetchPickListVal(component, 'Insect__c', 'Insect');
        helper.fetchPickListVal(component, 'PGR__c', 'Pgr');
        helper.fetchPickListVal(component, 'Weed__c', 'Weed');
        helper.fetchPickListVal1(component, 'Product__c', 'Product');
        helper.fetchPickListVal1(component, 'DosageUnit__c', 'DosageUnit');
        helper.fetchPickListVal1(component, 'Dosage__c', 'Dose');
        
        var today = $A.localizationService.formatDate(new Date()+1, "YYYY-MM-DD");
        component.set("v.maxDatePest",today);
        var sowingdate = component.get("v.DateSow");
        component.set("v.minDatePest",sowingdate);
        
    },
    
   formPress: function(component, event, helper) {    
        var backspacevalue = '';
        
    	if (event.keyCode === 8) {
			component.set("v.provalue1",backspacevalue);
		}
     },
    formPressSecond: function(component, event, helper) {    
        var backspacevalue = '';
        
    	if (event.keyCode === 8) {
			component.set("v.provalue2",backspacevalue);
		}
     },
    formPressThird: function(component, event, helper) {    
        var backspacevalue = '';
        
    	if (event.keyCode === 8) {
			component.set("v.provalue3",backspacevalue);
		}
     },
    formPressFourth: function(component, event, helper) {    
        var backspacevalue = '';
        
    	if (event.keyCode === 8) {
			component.set("v.provalue4",backspacevalue);
		}
     },
    
    //START
    onControllerFieldChange: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        var depnedentFieldMapDU = component.get("v.depnedentFieldMapDU");
         if(event.getParams().keyCode == 8){
        //alert('BACK key pressed'); // Do your work here fire the event
             
    	}
        
        if (controllerValueKey != '') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            var ListOfDependentFieldsDU = depnedentFieldMapDU[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields,"v.listDependingValues");    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['']);
            }  
            
            if(ListOfDependentFieldsDU.length > 0){
                component.set("v.bDisabledDependentFldDU" , false);  
                helper.fetchDepValues(component, ListOfDependentFieldsDU,"v.listDependingValuesDU");    
            }else{
                component.set("v.bDisabledDependentFldDU" , true); 
                component.set("v.listDependingValuesDU", ['']);
            } 
            
            
        } else {
            component.set("v.listDependingValues", ['']);
            component.set("v.bDisabledDependentFld" , true);
            component.set("v.listDependingValuesDU", ['']);
            component.set("v.bDisabledDependentFldDU" , true);
        }
    },
    //end
    
    onControllerFieldChange1: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        var depnedentFieldMapDU = component.get("v.depnedentFieldMapDU");
         if(event.getParams().keyCode == 8){
        //alert('BACK key pressed'); // Do your work here fire the event
             
    	}
        
        if (controllerValueKey != '') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            var ListOfDependentFieldsDU = depnedentFieldMapDU[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields,"v.listDependingValues1");    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues1", ['']);
            }  
            
            if(ListOfDependentFieldsDU.length > 0){
                component.set("v.bDisabledDependentFldDU" , false);  
                helper.fetchDepValues(component, ListOfDependentFieldsDU,"v.listDependingValuesDU1");    
            }else{
                component.set("v.bDisabledDependentFldDU" , true); 
                component.set("v.listDependingValuesDU1", ['']);
            } 
            
            
        } else {
            component.set("v.listDependingValues", ['']);
            component.set("v.bDisabledDependentFld" , true);
            component.set("v.listDependingValuesDU", ['']);
            component.set("v.bDisabledDependentFldDU" , true);
        }
    },
    //end
    //
    onControllerFieldChange2: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        var depnedentFieldMapDU = component.get("v.depnedentFieldMapDU");
         if(event.getParams().keyCode == 8){
        //alert('BACK key pressed'); // Do your work here fire the event
             
    	}
        
        if (controllerValueKey != '') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            var ListOfDependentFieldsDU = depnedentFieldMapDU[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields,"v.listDependingValues2");    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues2", ['']);
            }  
            
            if(ListOfDependentFieldsDU.length > 0){
                component.set("v.bDisabledDependentFldDU" , false);  
                helper.fetchDepValues(component, ListOfDependentFieldsDU,"v.listDependingValuesDU2");    
            }else{
                component.set("v.bDisabledDependentFldDU" , true); 
                component.set("v.listDependingValuesDU2", ['']);
            } 
            
            
        } else {
            component.set("v.listDependingValues", ['']);
            component.set("v.bDisabledDependentFld" , true);
            component.set("v.listDependingValuesDU", ['']);
            component.set("v.bDisabledDependentFldDU" , true);
        }
    },
    //end
    //
    onControllerFieldChange3: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        var depnedentFieldMapDU = component.get("v.depnedentFieldMapDU");
         if(event.getParams().keyCode == 8){
        //alert('BACK key pressed'); // Do your work here fire the event
             
    	}
        
        if (controllerValueKey != '') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            var ListOfDependentFieldsDU = depnedentFieldMapDU[controllerValueKey];
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields,"v.listDependingValues3");    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues3", ['']);
            }  
            
            if(ListOfDependentFieldsDU.length > 0){
                component.set("v.bDisabledDependentFldDU" , false);  
                helper.fetchDepValues(component, ListOfDependentFieldsDU,"v.listDependingValuesDU3");    
            }else{
                component.set("v.bDisabledDependentFldDU" , true); 
                component.set("v.listDependingValuesDU3", ['']);
            } 
            
            
        } else {
            component.set("v.listDependingValues", ['']);
            component.set("v.bDisabledDependentFld" , true);
            component.set("v.listDependingValuesDU", ['']);
            component.set("v.bDisabledDependentFldDU" , true);
        }
    },
    //end
    
    
    handlecheckbox : function(component, event, helper) {
        component.get("v.truthy");
        if (component.get("v.isChecked")){
            component.set("v.truthy", true); 
        }
        else if(!component.get("v.isChecked")){
            component.set("v.truthy", false);
        }
        
    },
    
    handleDisease : function(component, event, helper) {
        // get the updated/changed values   
        var selectedOptionsList = event.getParam("value");
        // get the updated/changed source  
        var targetName = event.getSource().get("v.name");
        // update the selected itmes  
        if(targetName == 'diseases'){ 
            component.set("v.dvalues" , selectedOptionsList);
        }
        
    },
    
    handleInsect : function(component, event, helper) {
        var selectedOptionsList = event.getParam("value");
        var targetName = event.getSource().get("v.name");
        if(targetName == 'insects'){ 
            component.set("v.ivalues" , selectedOptionsList);
        }
        var stringstart = event.getParam("accesskey");
        console.log('stringstartstringstart '+stringstart);
    },
    
    handlePgr : function(component, event, helper) {
        var selectedOptionsList = event.getParam("value");
        var targetName = event.getSource().get("v.name");
        if(targetName == 'pgr'){ 
            component.set("v.pvalue" , selectedOptionsList);
        }        
    },
    
    handleWeed : function(component, event, helper) {
        var selectedOptionsList = event.getParam("value");
        var targetName = event.getSource().get("v.name");
        if(targetName == 'weed'){ 
            component.set("v.wvalue" , selectedOptionsList);
        }
        
    },
    
    handleProduct : function(component, event, helper) {
        var selectedOptionsList = event.getParam("value");
        var targetName = event.getSource().get("v.name");
        if(targetName == 'controllerFld1'){ 
            var selectedItem = event.getSource().get("v.value");
            component.set("v.provalue1" , selectedItem);
            component.set("v.req1",true);
        }
        if(targetName == 'controllerFld2'){ 
            var selectedItem = event.getSource().get("v.value");
            component.set("v.provalue2" , selectedItem);
            component.set("v.req2",true);
        }
        if(targetName == 'controllerFld3'){ 
            var selectedItem = event.getSource().get("v.value");
            component.set("v.provalue3" , selectedItem);
            component.set("v.req3",true);
        }
        if(targetName == 'controllerFld4'){ 
            var selectedItem = event.getSource().get("v.value");
            component.set("v.provalue4" , selectedItem);
            component.set("v.req4",true);
        }
    },
    
    handleDose :  function(component, event, helper) {
        var selectedOptionsList = event.getParam("value");
        var targetName = event.getSource().get("v.name");
        if(targetName == 'dependentFld1'){ 
            var selectedItem = event.getSource().get("v.value");
            component.set("v.p1dosage" , selectedItem);
            //alert('val-looking'+selectedItem);
        }else if(targetName == 'dependentFld2'){ 
            var selectedItem = event.getSource().get("v.value");
            component.set("v.p2dosage" , selectedItem);
            // alert('val-lookingp2'+selectedItem);
        }else if(targetName == 'dependentFld3'){ 
            var selectedItem = event.getSource().get("v.value");
            component.set("v.p3dosage" , selectedItem);
        }else if(targetName == 'dependentFld4'){ 
            var selectedItem = event.getSource().get("v.value");
            component.set("v.p4dosage" , selectedItem);
        }
        
    },
    
    handleDosage : function(component, event, helper) {
        var selectedOptionsList = event.getParam("value");
        var targetName = event.getSource().get("v.name");
        if(targetName == 'dependentFldDU1'){ 
            var selectedItem = event.getSource().get("v.value");
            component.set("v.douvalue1" , selectedItem);
        }else if(targetName == 'dependentFldDU2'){ 
            var selectedItem = event.getSource().get("v.value");
            component.set("v.douvalue2" , selectedItem);
            //alert('val-douvalue2'+selectedItem);
        }else if(targetName == 'dependentFldDU3'){ 
            var selectedItem = event.getSource().get("v.value");
            component.set("v.douvalue3" , selectedItem);
        }else if(targetName == 'dependentFldDU4'){ 
            var selectedItem = event.getSource().get("v.value");
            component.set("v.douvalue4" , selectedItem);
        }
        
    },
    
    doSave : function(component, event, helper) {
        var action = component.get("c.setViewStat");
        
        action.setParams({
            Empanelment : component.get("v.EmpanelmentId"),
            Disease : component.get("v.dvalues"),
            Insect : component.get("v.ivalues"),
            Pgr : component.get("v.pvalue"),
            Weed : component.get("v.wvalue"),
            PestInfection : component.get("v.isChecked"),
            PestInfectionObservedDate : component.get("v.pdate")
            
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
                     
            var responseVal = response.getReturnValue();
            component.set("v.callid",responseVal.Id);
            console.log("responseval=== " +responseVal+ "responsevalId " + responseVal.Id  );
            
            var provalue = []; var pdosage = []; var douvalue = [];
            
            provalue.push(component.get("v.provalue1"),component.get("v.provalue2"), component.get("v.provalue3"), component.get("v.provalue4"));
            component.set("v.provalue",provalue);
            
            pdosage.push(component.get("v.p1dosage"),component.get("v.p2dosage"),component.get("v.p3dosage"),component.get("v.p4dosage"));
            component.set("v.pdosage",pdosage);
            
            douvalue.push(component.get("v.douvalue1"),component.get("v.douvalue2"),component.get("v.douvalue3"),component.get("v.douvalue4"));
            component.set("v.douvalue",douvalue);
           
           	console.log('here componenet' + component.get("v.p1dosage"));
            console.log('list of product names ' +provalue);
            console.log('list of product DOSE ' +pdosage);
            console.log('list of product DOSAGEUNIT ' +douvalue);
            helper.saveRecommendationCall(component,event,helper);
        });
        $A.enqueueAction(action);
    },
    
    doCancel : function(component, event, helper) {
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.FarmerId"),
            "slideDevName": "detail"
        });
        navEvt.fire();        
        
    },
    
    doRecommendation : function(component, event, helper) {
        
        var action = component.get("c.getRecommendations");
        var valueofstate = component.get("v.FarmerState");
        
        action.setParams({
            Empanelment : component.get("v.EmpanelmentId"),
            Disease : component.get("v.dvalues"),
            Insect : component.get("v.ivalues"),
            Pgr : component.get("v.pvalue"),
            Weed : component.get("v.wvalue"),
            State : component.get("v.FarmerState"),
            PestInfection : component.get("v.isChecked"),
            PestInfectionObservedDate : component.get("v.pdate"),
            Crop : component.get("v.crop"),
            DateOfSowing : component.get("v.DateSow"),
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var responseVal = response.getReturnValue();
            
            var stringifying = JSON.stringify(responseVal);
            if(state === 'SUCCESS'){
                var i;
                var messagetodisplay='';
                for (i=0;i<responseVal.length;i++){
                    messagetodisplay = messagetodisplay + ' Product:' + responseVal[i].Product__c + ' with dosage '+ responseVal[i].Dosage__c+' '+responseVal[i].Dosage_Unit__c + ' is recommended \n' ;
                } 
                
                if(responseVal.length == 0)
                {
                    messagetodisplay = 'Could not find any matching recommendations';
                }
                
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Recommendations",
                    "message": messagetodisplay, 
                    "type" : "Success",
                    "duration" : 20000
                });
                resultsToast.fire();
            }
            else if( state === 'ERROR'){
                var errMsg = "";
                    // saveResult.error is an array of errors, 
                    // so collect all errors into one message
                    for (var i = 0; i < state.error.length; i++) {
                        errMsg += state.error[i].message + "\n";
                        console.log('eroor-- '+errMsg);
                    }}
           
        });
        $A.enqueueAction(action);
    },
})