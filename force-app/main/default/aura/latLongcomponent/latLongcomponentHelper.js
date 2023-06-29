({
	 SaveRecord:function(component,event)
    {
            console.log('save record');
        console.log('lat'+component.get('v.lat'));
        console.log('long'+component.get('v.long'));
            component.find("forceRecord").saveRecord($A.getCallback(function(saveResult) {
                console.log(saveResult.state);
                component.set('v.surveyFields.lat__c',component.get('v.lat'));
                component.set('v.surveyFields.long__c',component.get('v.long'));
                // NOTE: If you want a specific behavior(an action or UI behavior) when this action is successful 
                // then handle that in a callback (generic logic when record is changed should be handled in recordUpdated event handler)
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                    console.log(component.get('v.surveyFields.lat__c'));
                   
                    // handle component related logic in event handler
                } else if (saveResult.state === "INCOMPLETE") {
                    console.log("User is offline, device doesn't support drafts.");
                } else if (saveResult.state === "ERROR") {
                    console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                } else {
                    console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                }
            }));
        
        
    },
    ResumeFlow:function(component,event)
    {
        console.log('Resume Flow');
        //Create request for interview ID
       var action = component.get("c.getPausedId");
       action.setCallback(this, function(response) {
          var interviewId = response.getReturnValue();
          // Find the component whose aura:id is "flowData"
          var flow = component.find("flowData");
          // If an interview ID was returned, resume it in the component
          console.log('interviewId--'+interviewId);
          // whose aura:id is "flowData".
          if ( interviewId !== null ) { 
              console.log(' if interviewId--'+interviewId);
             flow.resumeFlow(interviewID);
          }
          // Otherwise, start a new interview in that component. Reference
          // the flow's API Name.
          else {
               console.log('else interviewId--'+interviewId);
             flow.startFlow("Channel_Partner_KYC_Lightning");
          }
       });
       //Send request to be enqueued
       $A.enqueueAction(action);
    }
})