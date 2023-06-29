({
	doInit : function(component, event, helper) {
        
		var action3 = component.get("c.empanelValues");
        action3.setParams({
            "empanelmentId" : component.get("v.recordId")
        });
        action3.setCallback(this, function(response){
            var state = response.getState();
            console.log('state--- '+state);
            
            var responseVal = response.getReturnValue();
            console.log('re[cv ' +responseVal);
            if (state === "SUCCESS" || state === "DRAFT") {
                
                   
                component.set("v.empanelment", responseVal.Id );
                component.set("v.FarmerId",responseVal.Farmer__r.Id);
                component.set("v.FarmerState",responseVal.Farmer__r.Village_pr.State__c);
                component.set("v.FarmerName",responseVal.Farmer__r.Name);
                
                console.log('empanelment + id = ' + responseVal.Id);
                console.log('fid = ' + responseVal.Farmer__r.Id);
                console.log('fstate = ' + responseVal.Farmer__r.Village_pr.State__c);
                console.log('fname + id = ' + responseVal.Farmer__r.Name);
            }
           
        });
        $A.enqueueAction(action3);
        
        
      },
    
    empIdChange : function(component, event, helper) {
        
        var emp = component.get("v.empanelment");
        var fid =  component.get("v.FarmerId");
        var fstate = component.get("v.FarmerState");
        var fname = component.get("v.FarmerName");
        
        var navService = component.find("navServiceViewEmp");
        var pageReference = {
            type: 'standard__component',
            attributes: { 
                componentName: 'c__ViewingFromEmpanelment',
            },
            state: {
                "c__EmpanelmentVal": emp,
                "c__FarmerName": fname,
                "c__FarmerId": fid,
                "c__FarmerState": fstate
            }
        };
        component.set("v.pageReference", pageReference);
        
        navService.navigate(pageReference);
    },
        
    
})