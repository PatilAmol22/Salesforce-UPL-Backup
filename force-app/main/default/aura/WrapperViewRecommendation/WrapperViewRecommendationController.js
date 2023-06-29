({
	doInit : function(component, event, helper) {
        
        var key = component.get("v.CallIdFromRecommendationwrapper");
        var map = component.get("v.MapCRParentWrapper");
  		console.log("ey key = + =  =  "+key);
        console.log("ey map = + =  =  "+map);
        // set the values of map to the value attribute	
        // to get map values in lightning component use "map[key]" syntax. 
        component.set("v.ListofRecommendation" , map[key]);
        console.log(' map[key]  map[key]  =  =  =  ' +  map[key]  );
        
		
	}
})