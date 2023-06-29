({
	doInit : function(component, event, helper) {
        
        var myPageRef = component.get("v.pageReference");
        
        var valueEmp = myPageRef.state.c__EmpanelmentVal;
        var valueFId = myPageRef.state.c__FarmerId;
        var valueFState = myPageRef.state.c__FarmerState;
        var valueFName = myPageRef.state.c__FarmerName;
        var valueEmpName = myPageRef.state.c__EmpanelmentNameVal;
        
        
        
        component.set("v.EmpanelmentVal",valueEmp);
        component.set("v.FarmerId",valueFId);
        component.set("v.FarmerState",valueFState);
        component.set("v.FarmerName",valueFName);
        component.set("v.EmpanelmentNameVal",valueEmpName);
        
		//alert('name of emp'+valueEmpName);
        
        //change label of new tab when clicked on View Empanelment     
        var workspaceAPI = component.find("workspace2");
        workspaceAPI.getAllTabInfo().then(function(response) {
            console.log(response);
		 workspaceAPI.getFocusedTabInfo().then(function(response) {
            //alert('focus tab-from view');
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Empanelment"
            });
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "utility:user",
                iconAlt: "User"
            });
        })            
       })
        .catch(function(error) {
            console.log('What is error'+error);
        });
        
        
        
        var action3 = component.get("c.empanelValues");
        action3.setParams({
            "empanelmentId" : component.get("v.EmpanelmentVal")
        });
        action3.setCallback(this, function(response){
            var state2 = response.getState();
            var responseVal = response.getReturnValue();
            var storeFarmer =  responseVal.Farmer__r.Village__pr.State__c == 'Undefined' ? '' :  responseVal.Farmer__r.Village__pr.State__c; 
            
            if (state2 === "SUCCESS" || state2 === "DRAFT") {
               component.set("v.FarmerState", storeFarmer );
                component.set("v.cropp", responseVal.CultivatedCrop__c);
                component.set("v.sowDate", responseVal.SowingDate__c);
                component.set("v.acre", responseVal.CultivatedArea__c);
               console.log('crop + ' + responseVal.CultivatedCrop__c + 
                 'area + ' + responseVal.CultivatedArea__c +
                 'sowdare '+responseVal.SowingDate__c + 'Farmer State = ' + responseVal.Farmer__r.Village__pr.State__c);
            }
            if (state2 === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }else{
                console.log('hereis error');
            }
           
        });
        $A.enqueueAction(action3);
        
        
      },
    
    empChange : function(component, event, helper){
        var action2 = component.get("c.mapCRController");
        
        var te = component.get("v.EmpanelmentVal");
        
        action2.setParams({ 
            "empanelmentId" : te
        });
        
        action2.setCallback(this, function(response){
            var state1 = response.getState();
            
            
            var responseVal1 = response.getReturnValue();
            if (state1 === "SUCCESS" || state1 === "DRAFT") {
                
                component.set("v.MapCRParent",response.getReturnValue());
                var arrayOfMapKeys = [];
                for (var singlekey in responseVal1) {
                    arrayOfMapKeys.push(singlekey);
                    
                }
                // Set the all list of keys on component attribute, which name is lstKey and type is list.     
                component.set("v.lstCRParent", arrayOfMapKeys);
                console.log('arrayOfMapKeys arrayOfMapKeys arrayOfMapKeys   =  '+arrayOfMapKeys);
            }
            if (state1 === "ERROR") {
                
                var errMsg = "";
                // saveResult.error is an array of errors, 
                // so collect all errors into one message
                for (var i = 0; i < saveResult.error.length; i++) {
                    errMsg += saveResult.error[i].message + "\n";
                }
            }
        });
        $A.enqueueAction(action2);
        
    },
     handleCancel : function(component, event, helper){
         component.set('v.recommendationFlagSave',false); 
         	var te = component.get("v.EmpanelmentVal");
         
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": te,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
    
    handleSaveEmpanelmentandRecommend : function(component, event, helper){
        
        component.set('v.rFlagSave',true);        
        
    },
    handleCancelHide : function(component, event, helper){
         component.set('v.rFlagSave',false);        
        
    }
                           
          
})