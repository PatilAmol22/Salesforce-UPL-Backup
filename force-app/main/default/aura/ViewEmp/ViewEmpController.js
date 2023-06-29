({
    doInit : function(component, event, helper) {
        
        var myPageRef = component.get("v.pageReference");
        
        var TaskIdVal = myPageRef.state.c__TaskId;
         
       
        var TaskEmpanelmentVal = myPageRef.state.c__TaskEmpanelment;
         
         var TaskRelateToVal = myPageRef.state.c__TaskRelateTo;
         //alert(TaskIdVal);
        
        console.log('TaskIdVal TaskIdVal + === '+ TaskIdVal);
        console.log('TaskRelateToVal TaskRelateToVal + === '+ TaskRelateToVal);
        console.log('TaskEmpanelment TaskEmpanelment + === '+ TaskEmpanelmentVal);        
        component.set("v.TaskId", TaskIdVal);
         
        component.set("v.TaskRelateTo",TaskRelateToVal);
         
        component.set("v.TaskEmpanelment",TaskEmpanelmentVal);
        
        
        var action3 = component.get("c.empanelValues");
        action3.setParams({ 
            "empanelmentId" : TaskEmpanelmentVal
        });
        action3.setCallback(this, function(response){
            var state = response.getState();
            console.log('state--- '+state);
            
            var responseVal = response.getReturnValue();
            console.log('re[cv ' +responseVal);
            if (state === "SUCCESS" || state === "DRAFT") {
                component.set("v.FarmerState", responseVal.Farmer__r.Village__pr.State__c );
                component.set("v.cropp", responseVal.CultivatedCrop__c);
                component.set("v.sowDate", responseVal.SowingDate__c);
                component.set("v.acre", responseVal.CultivatedArea__c);
                console.log('crop + ' + responseVal.CultivatedCrop__c + 
                            'area + ' + responseVal.CultivatedArea__c +
                           'sowdare '+responseVal.SowingDate__c + 'Farmer State = ' + responseVal.Farmer__r.Village__pr.State__c);
            }
           
        });
        $A.enqueueAction(action3);
        
    },
    
    empChange : function(component, event, helper){
        console.log('Invoked empChange');
        
        var action2 = component.get("c.mapCRController");
        console.log('action2 ==  '+action2);
        var te = component.get("v.TaskEmpanelment");
        console.log('te======te   ' + te);
        action2.setParams({ 
            "empanelmentId" : te
        });
        
        action2.setCallback(this, function(response){
            var state1 = response.getState();
            console.log('state1====state1 '+state1);
            
            var responseVal1 = response.getReturnValue();
            if (state1 === "SUCCESS" || state1 === "DRAFT") {
                
                component.set("v.MapCRParent",response.getReturnValue());
                var arrayOfMapKeys = [];
                for (var singlekey in responseVal1) {
                    arrayOfMapKeys.push(singlekey);
                    console.log('==- = singlekey '+singlekey);
                    console.log('==- = singlekey should be 1 '+singlekey);
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
    handleSaveEmpanelmentandRecommend : function(component, event, helper){
        
        component.set('v.rFlagSave',true);        
        
    },
    
    handleCancelHide : function(component, event, helper){
         component.set('v.rFlagSave',false);        
        
    },
    
    handleCancel : function(component, event, helper){
         component.set('v.recommendationFlagSave',false); 
         	var te = component.get("v.TaskId");
         
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": te,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
})