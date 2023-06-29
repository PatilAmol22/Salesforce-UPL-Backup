({
	doInit : function(component, event, helper) {
        console.log('id');
        console.log(component.get('v.surveyrecordId'));
        if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    var latit = position.coords.latitude;
                    var longit = position.coords.longitude;
                    component.set('v.lat',latit);
                    component.set('v.long',longit);
                    console.log('latit-->'+latit);
                    console.log('longit-->'+longit);
                    
					});
			}
        
    /*    var action = component.get("c.updateSurvey");
            console.log(component.get('v.surveyrecordId'));
            action.setParams({
                "SurveyId" :component.get('v.surveyrecordId'),
                "Lattitude":latit,
                "longit":longit
            });
            // set call back 
            action.setCallback(this, function(response) {
                var state = response.getState();
          //      alert('record Save'+response.getState());
                if (state === "SUCCESS") {
                    console.log(response.getReturnValue());
                }
                else
                {
                   alert('Problem saving product Managers'); 
                }
            });
            // enqueue the server side action  
            $A.enqueueAction(action); */
    }
  /*  recordUpdated : function(component, event, helper) {
	console.log('calleds');
        
     var eventParams = event.getParams();
       console.log(component.get('v.surveyFields.Latitude__c'));
     //  component.set('v.surveyFields.lat__c',component.get('v.lat'));
     //  component.set('v.surveyFields.long__c',component.get('v.long'));
     
        
        console.log(eventParams.changeType);
        if(eventParams.changeType === "CHANGED") {
           
            // get the fields that changed for this record
            var changedFields = eventParams.changedFields;
            console.log('Fields that are changed: ' + JSON.stringify(changedFields));
            // record is changed, so refresh the component (or other component logic)
         var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title": "Saved",
                "message": "The record was updated."
            });
            resultsToast.fire(); 
 		
//        helper.NavigateToOpportunity(component,event);    
        
        } else if(eventParams.changeType === "LOADED") {
            
            
         helper.SaveRecord(component,event);
       //  helper.ResumeFlow(component,event);   
            // record is loaded in the cache
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted and removed from the cache
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving or deleting the record
        }
    } */
})