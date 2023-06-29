({
	 
    getBUDetails: function(component,event,helper) {
        var action = component.get("c.getBUOps");
        action.setCallback(this, function(response) {
        var callBackResponse =  response.getReturnValue();
        var BU =JSON.parse(JSON.stringify(callBackResponse));
        
        component.set("v.BU", response.getReturnValue().listZone);
        component.set("v.ShowEnabledLastMonth", response.getReturnValue().EnabledAccess);
        component.set("v.enable", response.getReturnValue().EnabledAccess);
            if(response.getReturnValue().listZone.length==1){ 
                
            window.setTimeout(
                $A.getCallback( function() {
                    // Now set our preferred value
                    component.find("intendBU").set("v.value", response.getReturnValue().listZone[0].Id);
                    //helper.helperonChangePickValBU(component,event,helper);
                    helper.helperonChangePickValRegion(component,event,helper);
                }));
                
            }
            
            
     });

        $A.enqueueAction(action);
		
	},
    
    helperonChangePickValRegion : function(component,event,helper) {
        
        
        var intendBU = component.find("intendBU").get("v.value");
        //component.set("v.SelectedTerrId",component.find("intend").get("v.value"));
        var getsalrep = component.get("c.getSalesRep");
        getsalrep.setParams({
            "BU": intendBU
        });
        
        getsalrep.setCallback(this, function(response) {
            
            var callBackResponse =  response.getReturnValue();
            var SR =JSON.parse(JSON.stringify(callBackResponse));
            component.set("v.salesrep", response.getReturnValue());
            
            if(response.getReturnValue().length==1){ 
                
            window.setTimeout(
                $A.getCallback( function() {
                    // Now set our preferred value
                    component.find("intendSalesRep").set("v.value", response.getReturnValue()[0].Id);
                    //helper.helperonChangePickValSales(component,event,helper);
                    helper.helperonChangePickValBU(component,event,helper);
                }));
                
            }
            
        });
        
        $A.enqueueAction(getsalrep);
    },
    
    helperonChangePickValBU : function(component,event,helper) {
        
        var va1 = component.find("intendSalesRep").get("v.value");
        
        var getterritory = component.get("c.getZone");
        getterritory.setParams({
            "SalesRep": va1
        });
        
        getterritory.setCallback(this, function(response) {
            
            var callBack =  response.getReturnValue();
            var convert =JSON.parse(JSON.stringify(callBack));
            component.set("v.zone", response.getReturnValue());
            
            if(response.getReturnValue().length==1){ 
                
            window.setTimeout(
                $A.getCallback( function() {
                    // Now set our preferred value
                    component.find("intend").set("v.value", response.getReturnValue()[0].Id);
                    //helper.helperonChangePickValRegion(component,event,helper);
                    helper.helperonChangePickValSales(component,event,helper);
                }));
                
            }
            
        });
        
        $A.enqueueAction(getterritory);
        
    },
    
    helperonChangePickValSales : function(component,event,helper) {
        component.set("v.SelectedTerrId",component.find("intend").get("v.value"));
         var Salesrep = component.find("intendSalesRep").get("v.value");
        
        var region = component.find("intend").get("v.value");
        
        var getCustomer = component.get("c.getCustomer");
        getCustomer.setParams({
            "Region": region,
            "Salesrep": Salesrep
        });
        
        getCustomer.setCallback(this, function(response) {
            
            var callBackResponse =  response.getReturnValue();
            var customer =JSON.parse(JSON.stringify(callBackResponse));
            component.set("v.Customers", customer);
            
            if(response.getReturnValue().length==1){ 
                
            window.setTimeout(
                $A.getCallback( function() {
                    // Now set our preferred value
                    component.find("intendCustomer").set("v.value", response.getReturnValue()[0].Id);
                    helper.helperonChangePickValCustomer(component,event,helper);
                }));
                
            }
            
        });
        
        $A.enqueueAction(getCustomer);
        
        
    },
    
    helperonChangePickValCustomer : function(component,event,helper) {
        
        component.set("v.SelectedCustId",component.find("intendCustomer").get("v.value")) ; 
        
    }
    
})