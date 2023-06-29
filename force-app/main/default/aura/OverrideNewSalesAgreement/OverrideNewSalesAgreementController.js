({
	doInit : function(component, event, helper) {
		var action = component.get("c.isNotCreatable");
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state '+response.getState());
            if(state==="SUCCESS"){
                console.log('response '+response.getReturnValue());
                component.set("v.isCreatable",response.getReturnValue());
                if(response.getReturnValue()==false){
                    var createRecordEvent = $A.get("e.force:createRecord");
					createRecordEvent.setParams({
						"entityApiName": "SalesAgreement"
					});
					createRecordEvent.fire();
                }else{
                    console.log('Invalid Right Access');
                }
            }
        });
        $A.enqueueAction(action);
	},
    closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
     history.back();
      component.set("v.isCreatable", false);
   }
})