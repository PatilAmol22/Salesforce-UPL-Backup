({
	doInit : function(component, event, helper) {
        console.log('Crop Component doinit');
        helper.fetchURLHelper(component, event, helper);
	},
    callChildMethod : function(component, event, helper){
        component.set("v.CheckIfLiquidationIsSubmitted",false);
        console.log("Method Called From Parent");
        component.set('v.pageReference',"");
        helper.fetchURLHelper(component, event, helper);
        component.set("v.CheckIfLiquidationIsSubmitted",true);
    }
})