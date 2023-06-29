({
	fetchNotes : function(component, event, helper) {
		 var action = component.get("c.fetchNotes");
         var caseId = component.get("v.recordId");
          action.setParams({
            strRecordId: caseId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var notesList = response.getReturnValue();
                component.set("v.notesList",notesList);
            }
            else {
                console.log('Error in getting data');
            }
        });
        // Adding the action variable to the global action queue
        $A.enqueueAction(action);
        },
    
    saveNote : function(component, event, helper) {
        /* var caseId = component.get("v.recordId");
        var indx = event.target.id;
        var notes = component.get("v.notesList");
        var action = component.get("c.saveNotes");
        action.setParams({
            parentId : caseId,
            Id : notes[indx].noteId,
            notesText : notes[indx].strNotes
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
               alert(state)
            }
            else {
                console.log('Error in getting data');
            }
        });
        $A.enqueueAction(action);
        */
    }
	
})