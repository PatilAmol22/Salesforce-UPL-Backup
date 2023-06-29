({
	AccountChange : function(component, event, helper) {
        var accountDetails = component.get("v.accountRecord");
        var navService = component.find("navService");
         var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'c__CreateEmp',
            },
            state: {
                "c__FarmerName": accountDetails.Name,
                "c__FarmerId": accountDetails.Id,
                "c__FarmerState": accountDetails.State__pc
                
            }
        };
        component.set("v.pageReference", pageReference);
        navService.navigate(pageReference);
    },
	
})