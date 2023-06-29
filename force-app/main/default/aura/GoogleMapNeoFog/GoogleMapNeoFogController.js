({
    init: function (cmp, event, helper) {
        
        // Get a reference to the getWeather() function defined in the Apex controller
		var action = cmp.get("c.getNeoFogBuilding");
        action.setParams({
            
            neoFogId: cmp.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            console.log('response.getReturnValue() ' + JSON.stringify(response.getReturnValue()));
            var data = response.getReturnValue(); //JSON.parse()  
            console.log( data[0].GPS_Coordinates__Latitude__s);
            console.log( data[0].GPS_Coordinates__Longitude__s);
            
            // Set the component attributes using values returned by the API call
            //if (data.GPS_Coordinates__c) {
                cmp.set('v.mapMarkers', [
            {
                location: {
                    //Street: '1600 Pennsylvania Ave NW',
                    //City: 'Washington',
                    //State: 'DC'
                                            
                        Latitude:  data[0].GPS_Coordinates__Latitude__s.toString(),
                        Longitude: data[0].GPS_Coordinates__Longitude__s.toString()
                 }
               }
        ]);
        cmp.set('v.zoomLevel', 16);
         //   }
        });
        // Invoke the service
        $A.enqueueAction(action);
        
    }
});





/*
  
({
    init: function (cmp, event, helper) {

       cmp.set('v.mapMarkers', [
            {
                location: {
                    //Street: '1600 Pennsylvania Ave NW',
                    //City: 'Washington',
                    //State: 'DC'
                    
                        Latitude: '37.790197',
                        Longitude: '-122.396879'
                },

                title: 'The White House',
                description: 'Landmark, historic home & office of the United States president, with tours for visitors.'
            }
        ]);
        cmp.set('v.zoomLevel', 16); 
        //$A.enqueueAction(action);
    }
});

*/