({
    doInit: function (component, event, helper) {
        var last_year = component.get("v.ContractHeader").Final_date;
        last_year= last_year.split("-",1);
        
        component.set("v.AdjacentYear",last_year-1);
        component.set("v.LastYear",last_year[0]);
       
        console.log('value is isisisisisisi '+ JSON.stringify(component.get("v.ContractHeader")));
        var action = component.get("c.getgoalvsActualCalculations");
        //Set the Object parameters and Field Set name
         action.setParams({  
            rContract : component.get("v.ContractHeader")
            });
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                component.set("v.LoadingBalls", false)
                //alert (response.getReturnValue().responseService);
                if(!(response.getReturnValue().responseService))
                {
                    //document.getElementById("Q10_Help").style.display = "block";
                    //alert('1');
                    var error=  $A.get("$Label.c.REB_Error_Message");
                    component.find('notifLib').showToast({
                        "variant": "error",
                        "message": error,
                        
                    });
                }
                component.set("v.Goaldata", response.getReturnValue().goalData);
                component.set("v.Actualdata", response.getReturnValue().actualData);
                component.set("v.GrowthAnalysisVSPreviousYear", response.getReturnValue().GrowthAnalysisVSPreviousYear);
                component.set("v.PamProductList", response.getReturnValue().liRebGoal);
                component.set("v.TotalPP", response.getReturnValue().TotalPP);
                component.set("v.OtherProduct", response.getReturnValue().OtherProduct);
                component.set("v.totalProduct", response.getReturnValue().TotalP); 
                component.set("v.ProductCategory", response.getReturnValue().categories);// ADDED by DIWANSH
                component.set("v.myTotalMap", response.getReturnValue().Mymap);
                console.log('value of total product is  '+ JSON.stringify(component.get("v.totalProduct")));
                var arrayOfMapKeys = [];
                for (var singlekey in response.getReturnValue().Mymap) {
                    arrayOfMapKeys.push(singlekey);
                }
                //var map = response.getReturnValue().Mymap;
               	component.set("v.valueMap", arrayOfMapKeys);
                
                console.log('values are '+ component.get("v.valueMap"));
            }
        });
        $A.enqueueAction(action);
    	//helper.getProductCategory(component, event, helper);
    },
    
    Back: function (component, event, helper) {
        component.set("v.showDetail",false);
        component.set("v.showHome",true);
        
    }
    
  
    
})