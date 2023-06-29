({
	doInit : function(component, event, helper) {
        var key = component.get("v.key");
        var map = component.get("v.map");
  console.log('reached 1st step');      
        component.set("v.value" , map[key]);
        console.log(' vvvvvvvvvvvvvv'+component.get("v.value").Goals_Volume);
	},
})