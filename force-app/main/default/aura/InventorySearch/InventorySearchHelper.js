({
	getWarehouse: function(component,event,helper) {        
        var action = component.get("c.getWH");
        action.setCallback(this, function(response) {
        var callBackResponse =  response.getReturnValue();
        var wh =JSON.parse(JSON.stringify(callBackResponse));
        component.set("v.wh", response.getReturnValue());
            if(response.getReturnValue().length==1){ 
                
            window.setTimeout(
                $A.getCallback( function() {
                    // Now set our preferred value
                    component.find("wh").set("v.value", response.getReturnValue()[0].Id);
                    helper.getHBrand(component,event,helper);
                  }));
                action.setCallback(this, function(a) {
				component.set("v.depotCode", a.getReturnValue());
                     
				});
                
            }
            
            
     });

        $A.enqueueAction(action);
		
	},
    
    getHBrand: function(component,event,helper) {
        component.find("brand").set("v.value",'');
        component.find("materials").set("v.value",''); 
        var action = component.get("c.getbrand");
        action.setCallback(this, function(response) {
        var callBackResponse =  response.getReturnValue();
        var brnd =JSON.parse(JSON.stringify(callBackResponse));
        component.set("v.brnd", response.getReturnValue());
            if(response.getReturnValue().length==1){ 
            window.setTimeout(
                $A.getCallback( function() {
                    // Now set our preferred value
                    
                    component.find("brand").set("v.value", response.getReturnValue()[0].Id);
                    
                }));
                action.setCallback(this, function(a) {
				component.set("v.brand", a.getReturnValue());                
				});
                
            }            
     });
        $A.enqueueAction(action);
	},       
    
    getHMaterials: function(component,event,helper) {       
       console.log('In Hmaterials'); 
        
        component.find("materials").set("v.value",'');
        var action = component.get("c.getMaterials");
        var brandName=component.find("brand").get("v.value");
        //var brandName=$("#brand").val();
        action.setParams({
            "BrandName":brandName
        });
        action.setCallback(this, function(response) {
        var callBackResponse =  response.getReturnValue();
        var mat =JSON.parse(JSON.stringify(callBackResponse));
        
           
            component.set("v.mat", response.getReturnValue());
            if(response.getReturnValue().length==1){ 
                
                window.setTimeout(
                    $A.getCallback( function() {
                        // Now set our preferred value
                        component.find("materials").set("v.value", response.getReturnValue()[0].Id);
						                    
                    }));       
            }    
            
     });

        $A.enqueueAction(action);
		
     },
   HSearch : function(component, event, helper)
    
    {        
        var WH = component.find("depotCode").get("v.value");
        console.log('WH'+WH);
        var BR = component.find("brand").get("v.value"); 
        console.log('BR'+BR);
        var MAT = component.find("materials").get("v.value"); 
        console.log('MAT'+MAT);
        var isRequiredFieldError = false;
        console.log("reached 1"+WH);
        if(WH == null || WH == '' )
        {
            $A.util.removeClass(component.find("depotCodeerro"),"slds-hide");
            isRequiredFieldError = true;
            
        }
        else{
            $A.util.addClass(component.find("depotCodeerro"),"slds-hide");
            isRequiredFieldError = false;
        }
        
        
        if(isRequiredFieldError == true)
        {
            console.log("reached 6");
            return;
        }
        else
        {
        var getInventoryData = component.get("c.getInventoryData");
        getInventoryData.setParams({
            "WH": WH,
            "BR":BR,
            "MAT":MAT
        });
            
        component.set("v.ShowSpinner", true);
        component.set("v.DisplayComponents",false);     
        
        getInventoryData.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
            var callBack =  response.getReturnValue();
               /* nEW CHANGES START HERE */
           console.log('Lengthsss---'+callBack.inventData.length);
           
            component.set("v.invntId", callBack.inventData ); 
            //component.set("v.avails", callBack.avails );
            component.set("v.avails",callBack.availValsList);
            console.log('list'+callBack.availValsList);
            component.set("v.writeaccess", callBack.writeAccess); 
            component.set("v.ShowSpinner", false);
            component.set("v.DisplayComponents",true);
             console.log('Pagination done');  
            }
            else
            {
                component.set("v.ShowSpinner", false);
            	component.set("v.DisplayComponents","True");
                component.find('notifLib').showToast({
                    "variant": "error",
                    "title": "error!",
                    "message": "Inventory is not available"
                });     
            }
        });
        
        $A.enqueueAction(getInventoryData);
        }       
    },
    
    
    getloadMaterials: function(component,event,helper) {       
        var action = component.get("c.getMats");
        action.setCallback(this, function(response) {
        var callBackResponse =  response.getReturnValue();
        var mat =JSON.parse(JSON.stringify(callBackResponse));
            component.set("v.mat", response.getReturnValue());
            if(response.getReturnValue().length==1){ 
                
                window.setTimeout(
                    $A.getCallback( function() {
                        // Now set our preferred value
                        component.find("materials").set("v.value", response.getReturnValue()[0].Id);
                        /*var opts=[];
                        var selopts=[];
                        for(var i in response.getReturnValue){
                          opts.push({
                        class: "optionClass",
                        label: result[i],
                        value: i
                    });                           
						selopts.push({
                        class: "optionClass",
                        label: result[i],
                        value: i.id
                    });      
                        }  
                        component.set("v.mates", opts);*/
                    }));       
            }    
            
     });

        $A.enqueueAction(action);
		
     },
})