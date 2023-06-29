({
	doInit : function(component, event, helper) {
        
       var oppId = component.get("v.recordId");
        console.log('@@oppId '+ oppId );
        helper.fetchData(component, event, helper);
       
       
       
   },
})