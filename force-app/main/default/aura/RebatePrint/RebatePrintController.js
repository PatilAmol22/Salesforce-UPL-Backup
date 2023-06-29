({
    Back: function (component, event, helper) {
        component.set("v.showPrint",false);
        component.set("v.showHome",true);
        
    },
    
    doInit: function (component, event, helper) {
        var Contract = component.get("v.ContractHeader");
        console.log(Contract);
        if(Contract.DistAccepted){
            component.set("v.submitConsent", false);   
        }
        else{
            component.set("v.submitConsent", true);     
        }
        
        if(component.get("v.UserType") == 'Distributor'){
            component.set("v.isDistributor", true); //BrazilPortal
            //component.set("v.communityName", "/BrazilPortal");
        }
        else{
            component.set("v.isDistributor", false);    
        }
        
        
    },
    
    Submit: function (component, event, helper) {
        console.log(component.get("v.Accepted"));
        if(component.get("v.Accepted")){
            var Contract = component.get("v.ContractHeader");    
            var action = component.get("c.UpdateDistributorAcceptance");
            action.setParams({  
                rC : component.get("v.ContractHeader")
            });
            action.setCallback(this, function(response){
                
                var state = response.getState();
                
                if(state === 'SUCCESS'){
                    component.set("v.ContractHeader", response.getReturnValue());
                    component.set("v.submitConsent", false);
                    
                    
                }
                
            });
            $A.enqueueAction(action);
        }
        else{
            component.find('notifLib').showToast({
                "variant": "success",
                "message": "Please select checkbox to provide consent",
                
            });
        }
    },
    
   
    //Ticket APPS-5297 Created By:-Gunnagya Nijhawan 1/06/2023
    //Start
    SendContract : function(component, event, helper) {
        component.set("v.spinner", true);
        var docId ='';
        var Contract = component.get("v.ContractHeader");
        console.log("ContractId	>>",  Contract.ContractId);
        var con = Contract.ContractId;
        console.log('con--',con);
        var action = component.get("c.pdfAction");
        action.setParams({ ContractId1 : con });
        
        action.setCallback(this, function(response) {        
            var state = response.getState();
             docId = response.getReturnValue();
            console.log('docId>>',docId);
           
            if (state === "SUCCESS") {
                component.set("v.spinner", false);
                $A.get('e.force:showToast').setParams
                ({
                    "title": "Success",
                    "message": "Rebate Contract Send successfully!",
                    "type": "success",
                }).fire();
                console.log(state);
            } 
            else {
                $A.get('e.force:showToast').setParams
                ({
                    "title": "Error",
                    "message": "Could not send Rebate Contract!",
                    "type": "error",
                }).fire();
                component.set("v.spinner", false);
                console.log(state);
            }
        });
        $A.enqueueAction(action);	
      
        
    }
    //End
    
    
})